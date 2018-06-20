arima.values <- reactiveValues(
  
  # Tabelle verwendete Forecast-Methoden fuer die unabhaengigen Variablen des multivariaten Regressiondmodells
  tabelle.variablen = 0,
  
  # Maximaler Timestep-Input fuer den Forecast. Berechnet anhand der Forecast-Methoden der unabhaengigen Variablen
  max.steps.predict = 0
  
)

# Ausgabe der Ueberschrift 
output$headerOutstanding <- renderUI({
  
  if(is.null(dim(arima.values$tabelle.variablen))) return()
  
  return(h4(strong("Forecast overview")))
})

# Ueber diesen Eventhandler wird die reactiveVariable "tabelle.variablen" befuellt, auf Basis der 
# benoetigten Variablen fuer das Regressionsmodell
observe({
  
  input$storeReg
  input$storeRegAuto
  
 
  regression.modell <- regression.modelle$gespeichertes.modell
  
  ergebnis.tabelle <- data.frame()
  if(length(regression.modell) == 1) return()
  
  required.names <- names(regression.modell[[1]]$coefficients)[-1][names(regression.modell[[1]]$coefficients[-1])
                                                                   %in% (attributes(regression.modell[[2]])$names)]
  
  arima.names <- store.graph$saveArima$Variable.Name
  manual.data <- submitted.manual$submitted.data
  trend.data <- trend.values$trends
  
  
  nicht.arima.forecast <- sapply(required.names, function(x) x %in% arima.names)
  
  
  
  # Sollten fuer verschiedene Variablen schon ARIMA-Modelle bestehen, werden diese aus den required.names herausgerechnet
  if(length(which(nicht.arima.forecast == TRUE)) != 0){
    
    ergebnis.tabelle <- data.frame("Independet variable" = required.names[which(nicht.arima.forecast == TRUE)],
                                   "Forecast kind" = rep("ARIMA", length(required.names[which(nicht.arima.forecast == TRUE)])))
    
    required.names <- required.names[- which(nicht.arima.forecast == TRUE)]
    
  }
  
  names.manual <- character()
  for(i in 1:length(manual.data)){
    
    if(dim(manual.data[[i]])[1] != 0){
      
      if(length(names.manual) == 0){
        names.manual <- c(names(manual.data)[i])
      } else {
        names.manual <- c(names.manual, names(manual.data)[i])
      }
      
    }
  }
  
  # In der Variable "nicht.arima.forecast" befindet sich nun die Matches von manuellen Eingaben
  # mit den benoetigten Variablen.
  if(length(names.manual) > 0){
    
    nicht.arima.forecast <- sapply(required.names, function(x) x %in% names.manual)
    
    if(length(which(nicht.arima.forecast == TRUE)) != 0){
      
      ergebnis.tabelle.temp <- data.frame("Independet variable" = required.names[which(nicht.arima.forecast == TRUE)],
                                          "Forecast kind" = rep("Manual Input", length(required.names[which(nicht.arima.forecast == TRUE)])))
      
      if(dim(ergebnis.tabelle)[1] == 0){
        ergebnis.tabelle <- ergebnis.tabelle.temp
      } else {
        ergebnis.tabelle <- rbind(ergebnis.tabelle, ergebnis.tabelle.temp)
      }
      
      required.names <- required.names[- which(nicht.arima.forecast == TRUE)]
    }
    
  }
  
  # In der Variable "names.trend" befinden sich anschlie�end die Namen der Variablen mit
  # mit trend-Input
  names.trend <- character()
  
  for(i in 1:length(trend.data)){
    
    if(is.null(dim(trend.data[[i]]))){
      
      if(length(names.trend) == 0){
        names.trend <- c(names(trend.data)[i])
      } else {
        names.trend <- c(names.trend, names(manual.data)[i])
      }
      
    }
  }
  
  
  if(length(names.trend) > 0){
    
    nicht.arima.forecast <- sapply(required.names, function(x) x %in% names.trend)
    
    if(length(which(nicht.arima.forecast == TRUE)) != 0){
      
      ergebnis.tabelle.temp <- data.frame("Independet variable" = required.names[which(nicht.arima.forecast == TRUE)],
                                          "Forecast kind" = rep("Trend Input", length(required.names[which(nicht.arima.forecast == TRUE)])))
      
      if(dim(ergebnis.tabelle)[1] == 0){
        ergebnis.tabelle <- ergebnis.tabelle.temp
      } else {
        ergebnis.tabelle <- rbind(ergebnis.tabelle, ergebnis.tabelle.temp)
      }
      
      required.names <- required.names[- which(nicht.arima.forecast == TRUE)]
    }
    
  }
  
  # In required.names befinden sich anschlieÃend die uebrigen Variablen fuer die
  # noch keine Vorhersage getroffen wurde.
  
  if(length(required.names) > 0){
    
    ergebnis.tabelle.temp <- data.frame("Independet variable" = required.names,
                                        "Forecast kind" = rep("Outstanding", length(required.names)))
    
    if(dim(ergebnis.tabelle)[1] == 0){
      ergebnis.tabelle <- ergebnis.tabelle.temp
    } else {
      ergebnis.tabelle <- rbind(ergebnis.tabelle, ergebnis.tabelle.temp)
    }
    
  }
  
  arima.values$tabelle.variablen <- ergebnis.tabelle
  
})

output$verteilungVar <- renderTable({
  
  if(is.null(dim(arima.values$tabelle.variablen))) return()
  #as.tbl(mtcars)
  arima.values$tabelle.variablen
})

# Auflistung der im Forecast-Modell benoetigten Variabelen
output$indVarFor <- renderUI({
  
  input$storeReg
  input$storeArima
  input$storeRegAuto
  
  regression.modell <- regression.modelle$gespeichertes.modell
  validate({
    need(length(regression.modell) != 1, "Complete and store a regression model")
  })
  
  ind.var.names <- names(regression.modell[[1]]$coefficients)[-1][names(regression.modell[[1]]$coefficients[-1])
                                                                  %in% (attributes(regression.modell[[2]])$names)]
  return(list(selectInput("varFor", h4(strong("1. Variable forecast for following independent variables are required")),
                          choices = ind.var.names),
              p("The drop-down above displays the", strong("independent variables contained"), "in the calculated",
                strong("prediction model.")),
              p("To", strong("simulate"), "the", strong("future development"), "of the", strong("dependent variable"), "prospective data
                from all is requested. So be sure to", strong("complete"), "a", strong("manual input"), "or determine an
                appropriate", strong("ARIMA-Model."))))
  
})

# Ausgabe des numerischen Auswahlfeldes fuer die zu vorhersagenden Zeitschritte im Reiter "Forecast"
inputPred <- reactive({
  
  input$storeReg
  input$storeRegAuto
  input$storeArima
  input$submit
  
  regression.modell <- regression.modelle$gespeichertes.modell
  
  validate({
    need(length(regression.modell) != 1, "")
  })
  
  # Filtern der Namen der unabhaengigen Variablen, die fuer den Forecast bereitstehen muessen.
  arima.temp <- store.graph$saveArima
  arima.names <- arima.temp$Variable.Name
  required.names <- names(regression.modell[[1]]$coefficients)[-1][names(regression.modell[[1]]$coefficients[-1])
                                                                   %in% (attributes(regression.modell[[2]])$names)]
  
  forecast.tabelle <- arima.values$tabelle.variablen
  required.names.temp <- required.names
  manual.forecast <- sapply(required.names, function(x) x %in% arima.names)
  
  # In dieser Variable liegen nun die unabhÃ¤ngigen Variablen fuer die eine manuelle Eingabe erforderlich ist
  if(length(which(manual.forecast == TRUE)) != 0){
    required.names <- required.names[- which(manual.forecast == TRUE)]
  }
  
  if(!is.null(arima.names)){
    # Sollten fuer alle unabhaengigen Variablen Arima-Modelle bereitstehen, muss kein Maximalwert fuer die "Timesteps" gesetzt werden
    if(length(required.names) == 0){
      arima.values$max.steps.predict <- -1
      return(list(numericInput("steps", h4(strong("Select time steps to predict")), value = 5, min = 0),
                  p("Select the amount of", strong("time steps to predict"),". Be aware that the", strong("maximum of time steps"), "to 
                    predict is", strong("restricted"), "to the", strong("amount of avaiable data.")),
                  numericInput("sim", label = h4(strong("Choose number of simulations")), value = 100, min = 0),
                  radioButtons("CIregression", label = h4(strong("Consider uncertainty of regression model:")), choices = list("Yes" = 1, "No" = 0), selected = 0),
                  numericInput("uncertainty", label = h4(strong("Choose confidence interval")),value = 0.9, min = 0, max = 1),
                  checkboxInput("testdata", "Show test data", value = FALSE),
                  actionButton("startSim", label = "Simulate"),
                  p("")))
    }
  }
  
  lags <- regression.modell[[4]][attributes(regression.modell[[2]])$names %in% required.names.temp]
  lag.names <- data.frame("Independent variables" = required.names.temp, "Lags" = lags)
  
  manual.data <- submitted.manual$submitted.data
  
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
  # Challange des Maximums fuer die Trend-Forecasting-Variablen
  trend.data <- trend.values$trends
  
  # Die Variable "trend.data" beinhaltet nun die Trend-Forecasting-Variablen
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
  arima.values$max.steps.predict <- max.steps
  list(numericInput("steps", h4(strong("Select time steps to predict")), value = 5, min = 0, max = max.steps),
       p("Select the amount of", strong("time steps to predict"),". Be aware that the", strong("maximum of time steps"), "to 
         predict is", strong("restricted"), "to the", strong("amount of avaiable data.")),
       numericInput("sim", label = h4(strong("Choose number of simulations")), value = 100, min = 0),
       radioButtons("CIregression", label = h4(strong("Consider uncertainty of regression model:")), choices = list("Yes" = 1, "No" = 0), selected = 0),
       numericInput("uncertainty", label = h4(strong("Choose confidence interval")), value = 0.9, min = 0, max = 1),
       checkboxInput("testdata", h4("Show test data"), value = FALSE),
       actionButton("startSim", label = "Simulate"),
       p("")) 
})


output$inputPredout1 <- renderUI({
  
  if(identical(arima.values$tabelle.variablen, 0) || any(arima.values$tabelle.variablen[ ,2] == "Outstanding")) {return()} 
  inputPred()[[1]]
  
  
})

output$inputPredout2 <- renderUI({
  
  if(identical(arima.values$tabelle.variablen, 0) || any(arima.values$tabelle.variablen[ ,2] == "Outstanding")) {return()} 
  inputPred()[[2]]
  
  
})

output$inputPredout3 <- renderUI({
  
  if(identical(arima.values$tabelle.variablen, 0) || any(arima.values$tabelle.variablen[ ,2] == "Outstanding")) {return()} 
  inputPred()[[3]]
  
  
})

output$inputPredout4 <- renderUI({
  
  if(identical(arima.values$tabelle.variablen, 0) || any(arima.values$tabelle.variablen[ ,2] == "Outstanding")) {return()} 
  inputPred()[[4]]
  
  
})

output$inputPredout5 <- renderUI({
  
  if(identical(arima.values$tabelle.variablen, 0) || any(arima.values$tabelle.variablen[ ,2] == "Outstanding")) {return()} 
  inputPred()[[5]]
  
  
})

output$inputPredout6 <- renderUI({
  
  if(identical(arima.values$tabelle.variablen, 0) || any(arima.values$tabelle.variablen[ ,2] == "Outstanding")) {return()} 
  
  if (splitindex$splittruefalse == 1){
    return(inputPred()[[6]])
  }else if(splitindex$splittruefalse == 0){
    return()
  }
  
  
})

output$inputPredout7 <- renderUI({
  
  if(identical(arima.values$tabelle.variablen, 0) || any(arima.values$tabelle.variablen[ ,2] == "Outstanding")) {return()} 
  inputPred()[[7]]
  
  
})

# Ausgabe des Dygraphen mit Konfidenzintervallen fuer die durchgefuehrten Simulationen
output$simCI <- renderDygraph({
  
  graph.forecast()[[1]]
  
})

output$headerCI <- renderUI({
  
  conditionalPanel("input.startSim", h4(strong("Evaluation of resulting confidence intervals for forecasted time steps")))
  
})

# Ausgabe der Tabelle mit Mittelwert und Konfidenzintervallgrenzen
output$CI.table <- renderDataTable({
  
  if(identical(arima.values$tabelle.variablen, 0) || any(arima.values$tabelle.variablen[ ,2] == "Outstanding")) {return()} 
  
  if(identical(graph.forecast()[[2]], NULL)){return()}
  
  a <- 1
  
  pred.dates <- seq(tail(daten.under$base[ ,1], n = 1)[[1]],
                    by = start$freq,
                    length.out = isolate(input$steps) + 1)[2:(isolate(input$steps) + 1)]
  
  prediction.result <- cbind(pred.dates, round(as.data.frame(graph.forecast()[[2]]), digits = 3))
  colnames(prediction.result) <- isolate(c("Date", "Mean value", paste("Empirical",((1-input$uncertainty)/2)*100," % quantile") ,paste("Empirical",(100-(((1-input$uncertainty)/2)*100))," % quantile")))
  
  report$prediction.results<-prediction.result
  return(prediction.result)
  
}) 