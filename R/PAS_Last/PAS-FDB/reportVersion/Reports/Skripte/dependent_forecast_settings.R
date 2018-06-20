montecarlo.global <- reactiveValues(
  
  max.steps.predict = 0,
  sim_values = NULL,
  dep_var_data = NULL,
  pred_timesteps = NULL,
  used_model = NULL,
  mean_values_forcast = NULL,
  current_graph = NULL,
  current_prediction = NULL
)

# Organisieren der UI-Elemente der Simulationseingaben fuer die Monte-Carlo-Simulation des 
inputPred <- reactive({

  regression.modell <- objects$lmRegressionModell
  
  validate({
    need(length(regression.modell) != 1, "")
  })
  
  # Filtern der Namen der unabhaengigen Variablen, die fuer den Forecast bereitstehen muessen.
  arima.temp <- objects$lmArimaSave
  arima.names <- arima.temp$Variable.Name
  
  expsm.temp <- objects$lmexpsmSave
  expsm.names <- expsm.temp$Variable.Name
  
  forecast.tabelle <- objects$usedForecastsInd
  
  required.names.temp <- objects$coeffNames
  required.names      <- objects$coeffNames
  
  manual.forecast.arima <- sapply(required.names, function(x) x %in% arima.names)
  manual.forecast.expsm <- sapply(required.names, function(x) x %in% expsm.names)
  
  
  # In dieser Variable liegen nun die unabhÃ¤ngigen Variablen fuer die eine manuelle Eingabe erforderlich ist
  if(length(which(manual.forecast.arima == TRUE)) != 0){
    required.names <- required.names[- which(manual.forecast.arima == TRUE)]
    manual.forecast.expsm <- manual.forecast.expsm [- which(manual.forecast.arima==TRUE)]
  }
  
  if(length(which(manual.forecast.expsm==TRUE)) !=0 ){
    required.names <- required.names[- which(manual.forecast.expsm == TRUE)]
  }

  if(!is.null(arima.names)||!is.null(expsm.names)){
    # Sollten fuer alle unabhaengigen Variablen Arima-Modelle bereitstehen, muss kein Maximalwert fuer die "Timesteps" gesetzt werden
    if(length(required.names) == 0){
      montecarlo.global$max.steps.predict <- -1
      return(list(numericInput("steps", h4(strong("Select time steps to predict")), value = 5, min = 0),
                  p("Select the amount of", strong("time steps to predict"),". Be aware that the", strong("maximum of time steps"), "to 
                    predict is", strong("restricted"), "to the", strong("amount of avaiable data.")),
                  numericInput("sim", label = h4(strong("Choose number of simulations")), value = 100, min = 0),
                  radioButtons("CIregression", label = h4(strong("Consider uncertainty of regression model:")), choices = list("Yes" = 1, "No" = 0), selected = 0),
                  numericInput("uncertainty", label = h4(strong("Choose confidence interval")),value = 0.9, min = 0, max = 1),
                  actionButton("startSim", label = "Simulate"),
                  br(),br(),
                  conditionalPanel("input.startSim", actionButton("saveForecastMreg", "Save forecast"))))
    }
  }
  
  lags <- regression.modell[[4]][attributes(regression.modell[[2]])$names %in% required.names.temp]
  lag.names <- data.frame("Independent variables" = required.names.temp, "Lags" = lags)
  
  #print("Bis Manual?")
  manual.data <- objects$lmManualInput
  
  #print("Forecast Kind Hier")
  #print(forecast.tabelle)
  
  # In der Variable "manual.data" befindet sich die Liste mit den unabhaengigen Variablen fuer die kein ARIMA-Modell vorhanden ist.
  # In den einzelnen Listeneintraegen befinden sich die etwaige manuell eingetragene Daten.
  variablen.manual <- as.character(dplyr::filter(forecast.tabelle, Forecast.kind == "Manual Input")[[1]])
  namen.filter <- sapply(names(manual.data), function(x) x %in% variablen.manual)
  manual.data <- manual.data[which(namen.filter == TRUE)]
  
  # Auslesen der Anzahlen der manuell eingegebenen Daten
  count.data <- sapply(manual.data, function(x) dim(x[1])[1])
  
  # Bestimmen des Maximums fuer die Anzahl an "Timesteps" die moeglich ist
  max.steps <- 0
  if(length(count.data) > 0){
    for(i in 1:length(count.data)){
      temp.name <- names(count.data)[i]
      index.lag.frame <- which(lag.names[ ,1] == temp.name)
      temp.lag <- lag.names[index.lag.frame, 2]
      temp.max <- temp.lag + count.data[i]
      if(i == 1){
        max.steps <- temp.max
      } else if(max.steps > temp.max){
        max.steps <- temp.max
      }
    }
  }
  # Challenge des Maximums fuer die Trend-Forecasting-Variablen
  trend.data <- objects$lmTrendInput
  
  # Die Variable "trend.data" beinhaltet nun die Trend-Forecasting-Variablen
  #print("Forecast Kind Hier")
  print(forecast.tabelle)
  variablen.trend <- as.character(dplyr::filter(forecast.tabelle, Forecast.kind == "Trend Input")[[1]])
  namen.filter <- sapply(names(trend.data), function(x) x %in% variablen.trend)
  trend.data <- trend.data[which(namen.filter == TRUE)]
  
  # Auslesen der Anzahlen der manuell eingegebenen Daten
  count.data.trend <- sapply(trend.data, function(x) dim(x[[2]])[1])
  
  if(length(count.data.trend) > 0){
    for(i in 1:length(count.data.trend)){
      temp.name <- names(count.data.trend)[i]
      index.lag.frame <- which(lag.names[ ,1] == temp.name)
      temp.lag <- lag.names[index.lag.frame, 2]
      temp.max <- temp.lag + count.data.trend[i]
      if(i == 1 && max.steps == 0){
        max.steps <- temp.max
      } else if(max.steps > temp.max){
        max.steps <- temp.max
      }
    }
  }
  montecarlo.global$max.steps.predict <- max.steps
  return(list(numericInput("steps", h4(strong("Select time steps to predict")), value = 5, min = 0, max = max.steps),
              p("Select the amount of", strong("time steps to predict"),". Be aware that the", strong("maximum of time steps"), "to 
              predict is", strong("restricted"), "to the", strong("amount of avaiable data.")),
              numericInput("sim", label = h4(strong("Choose number of simulations")), value = 100, min = 0),
              radioButtons("CIregression", label = h4(strong("Consider uncertainty of regression model:")), choices = list("Yes" = 1, "No" = 0), selected = 0),
              numericInput("uncertainty", label = h4(strong("Choose confidence interval")), value = 0.9, min = 0, max = 1),
              actionButton("startSim", label = "Simulate"),
              br(),br(),
              conditionalPanel("input.startSim", actionButton("saveForecastMreg", "Save forecast"))))
})

# Ausgabe der UI-Elemente 1-3 fuer die erste column
output$inputPredout1 <- renderUI({
  
  if(is.null(objects$lmRegressionModell)) {return()}
  
  if(is.null(objects$usedForecastsInd) || any(objects$usedForecastsInd[ ,2] == "Outstanding")) {
    return(p("Not all forecast methods of the corresponding independent variables are completed"))
  } 

  if(any(objects$updateTableIndVariables[ ,2] == "Need update")){
    return(p("The prediction model was updated - Update forecast methods of the corresponding independent variables in the window above as well before continuing"))
  }
  
  inputPred()[1:3]
  
})

# Ausgabe der UI-Elemente 4-7 fuer die zweite column
output$inputPredout2 <- renderUI({
  
  if(is.null(objects$usedForecastsInd)  || any(objects$usedForecastsInd[ ,2] == "Outstanding") || any(objects$updateTableIndVariables[ ,2] == "Need update")) {return()} 

  inputPred()[4:7]
  
})

# Erstellen des CSV-Download-Buttons für die Simulationswerte
output$downloadMonteForecast <- renderUI({
  
  if(is.null(objects$usedForecastsInd)  || any(objects$usedForecastsInd[ ,2] == "Outstanding") || any(objects$updateTableIndVariables[ ,2] == "Need update")) {return()} 
  
  if(is.null(montecarlo.global$current_prediction)) return()
  
  return(downloadButton('downloadMonteFor', 'Download Prediction as CSV'))
})

# Speichern der Tabelle mit den aus der Simulation resultierenden Forecast-Werten
output$downloadMonteFor <- downloadHandler(
  filename = function() { paste("forecast_monte_", objects$lmRegressionModell[[7]], '.xlsx', sep='') },
  content = function(file) {
    write.xlsx(montecarlo.global$current_prediction, file)
  }
)

