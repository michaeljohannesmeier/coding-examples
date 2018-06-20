# Ausgabe Erklaerungstexte

output$texthelp18<-renderUI({
  "Choose an independent variable ( predictor contained in current stored regression model)
to fit an ARIMA-Model (Auto-Regressive Integrated Moving Average)
  to be able to forecast this variable based on its historical data.  "
})
output$texthelp19<-renderUI({
  "If the type of Arima-Model is set to 'Automatic', the parameters of the ARIMA model will be automatically searched. If 'Manual' is selected, 
then 3 Parameters are needed to determine an ARIMA-Model: 
  Auto-Regression (p):  The idea is that values of an variable are based on historical values of the same variable. 
The parameter p represents the order of how many previous values influence the current one. i.e X(t) depends on X(t-1), X(t-2), (Xt-3), so p = 3. 
  Differencing (d):  Differencing is necessary to adjust trends and make time series stationary. The advantage of a stationary time series is that
  some characteristics hold not only for certain dates but for the whole differenced data set . This is important since nearly every statistical 
  procedure requires stationarity. 
  Moving-Average (q):  Moving average parameters relate what happens in period t only to the random errors that occurred in past time periods , i.e. 
  E(t-1), E(t-2) , etc. rather than to X(t-1), X(t-2), (Xt-3) as in the autoregressive approaches. 
  To have a look at the way the current fitted ARIMA-Model predicts the processed data, select an amount of time steps and place a check below. 
  The time series plot on the right will automatically display the expected value and resulting 90% confidence interval 
  The table above contains 3 statistical quality criterions of the current fitted ARIMA-Model . Low values of Aikake's Infomation Criterion (AIC) 
  and Bayesian Information Criterion (BIC) and larger values of Log-Likelihood indicate a good fit. "
})


# Die Variable graphs beinhaltet die korrespondierende Visualisierung der gespeicherten
# ARIMA-Modelle
store.graph <- reactiveValues(
  
  graphs = list(),
  saveArima = data.frame(),
  boolArima = FALSE,
  current.graph = 0,
  arimaPredData = 0,
  manualPredData = 0,
  
  # Diese Variablen werden benoetigt, um die Ausgaben beim Speichern verschwinden zu lassen
  index = 0,
  index2 = 0,
  
  name.current.model = 0
  
)

# Diese Funktion organisiert das Drop-Down im Reiter "Time series analysis" fuer die Auswahl der zur ARIMA-Modellierung zur Verfuegung 
# stehenden Vaiablen (Die Variablen, welche als Predictoren im Regressionsmodell verwendet wurden)
output$chooseIndVar <- renderUI({
  
  if(identical(arima.values$tabelle.variablen, 0)){
    selectInput("acfIndVar", "Choose independent variable to predict",
                choices = "")
  }else{
    selectInput("acfIndVar", "Choose independent variable to predict",
                choices = as.character(arima.values$tabelle.variablen[ ,1])[which(arima.values$tabelle.variablen[ ,2] == "Outstanding")])
  } 
  
})


# Diese Funktion bereitet die Daten fuer die ARIMA-Modellierung in Abhaengigkeit der gewaehlten Variable ("acfIndVar") auf.
dataACF <- reactive({
  
  reg.data <- daten.under$base[ ,sapply(daten.under$base, is.numeric)]
  index.depVar <- which(attributes(reg.data)$names == input$depVar)
  reg.data <- reg.data[ ,- index.depVar]
  index.acfVar <- which(attributes(reg.data)$names == input$acfIndVar)
  reg.data <- reg.data[ , index.acfVar]
  return(reg.data)
  
})


# Erstellen einer Zeitserie fuer die augewaehlte unabhaenngige Variable ("acfIndVar")
timeseries <- reactive({
  
  input$plotts1
  input$ts1
  
  if(isolate(input$acfIndVar) == "") return ()
  
  # Setzen der Zeitserie fuer aktuell ausgewaehlte unabhaengige Variable
  time.ind.var <- xts(isolate(dataACF()), daten.under$base[[1]])
  
  return(time.ind.var)
  
})

# Dygraph-Plot fuer ausgewaehlte unabhaengige Variable
observeEvent(input$plotts1, {
  
  store.graph$index<-1
  store.graph$index2<-0
  
  ts.data <- timeseries()
  
  store.graph$boolArima = FALSE
  store.graph$current.graph <- dygraph(ts.data, main = attributes(isolate(dataACF()))$names) %>% dyRangeSelector() %>%
    dyLegend(width = 800) %>% dyOptions(drawPoints = TRUE, pointSize = 2)
  
})

# Dygraph-Plot fuer ausgewaehlte unabhaengige Variable + ARIMA Modell (Gegenueberstellung historischer Werte und 
# gefitteter Werte)
observeEvent(input$ts1, {
  
  if(is.na(input$forecast)){return(
    withProgress(value=0.1,message = "Choose proper range to forecast", Sys.sleep(2.5), setProgress(1)))}
  if(input$forecast<1){return(
    withProgress(value=0.1,message = "Choose proper range to forecast", Sys.sleep(2.5), setProgress(1)))}
  
  store.graph$index<-0
  store.graph$index2<-0
  ts.data <- timeseries()
  
  if(input$arimaSelected == 1 && input$forecast == 0){
    ts.data <- cbind("Historical values" = timeseries(), "ARIMA for historical values" =  fitted(arima.model.auto()))
    store.graph$current.graph <- dygraph(ts.data, main = attributes(isolate(dataACF()))$names) %>% dyRangeSelector() %>%
      dyLegend(width = 800) %>% dyOptions(drawPoints = TRUE, pointSize = 2)
  }
  
  if(input$arimaSelected == 0 && input$forecast == 0){
    ts.data <- cbind("Historical values" = timeseries(), "ARIMA for historical values" = fitted(arima.model.manual()))
    store.graph$current.graph <- dygraph(ts.data, main = attributes(isolate(dataACF()))$names) %>% dyRangeSelector()%>%
      dyLegend(width = 800) %>% dyOptions(drawPoints = TRUE, pointSize = 2)
  }
  
  store.graph$boolArima = TRUE
  
  if(input$forecast > 0){
    
    pred.data <- 0
    arima.model.temp <- 0
    if(input$arimaSelected == 1){
      arima.model.temp <- arima.model.auto()
    } else if(input$arimaSelected == 0){
      arima.model.temp <- arima.model.manual()
    }
    
    pred.data  <- forecast(arima.model.temp, h = input$forecast, level = c(0.90))
    pred.fore  <- pred.data$mean
    pred.lower <- (pred.data$mean - pred.data$mean) + pred.data$lower
    pred.upper <- (pred.data$mean - pred.data$mean) + pred.data$upper
    pred.data  <- list(pred.fore, pred.lower, pred.upper)
    
    pred.dates <- seq(tail(daten.under$base[ ,1], n = 1)[[1]], by = start$freq, length.out = isolate(input$forecast) + 1)[2:(isolate(input$forecast) + 1)]
    
    # Output der Konfidenzintervalle
    store.graph$arimaPredData <- cbind("Date" = pred.dates, 
                                       round(as.data.frame(cbind("Expectation forecast" = pred.data[[1]],
                                                                 "5%-Quantile forecast" = pred.data[[2]],
                                                                 "95%-Upper bound forecast" = pred.data[[3]])), digits = 3))
    
    ts.data <- cbind("Historical values" = timeseries(),
                     "ARIMA for historical values" = xts(fitted(arima.model.temp), daten.under$base[[1]]),
                     "Expectation forecast" = xts(pred.data[[1]], pred.dates),
                     "Lower bound forecast" = xts(pred.data[[2]], pred.dates), 
                     "Upper bound forecast" = xts(pred.data[[3]], pred.dates))
    
    colnames(ts.data) <- c("Historical values", "ARIMA for historical values",
                           "Expectation forecast", "Lower bound forecast", "Upper bound forecast")
    
    ts.data[dim(ts.data)[1] - (input$forecast), (3:5)] <- ts.data[dim(ts.data)[1] - (input$forecast), 2]
    
    store.graph$current.graph <- dygraph(ts.data, main = attributes(isolate(dataACF()))$names) %>% 
      dySeries(c("Lower bound forecast", "Expectation forecast", "Upper bound forecast")) %>%
      dyRangeSelector() %>% dyLegend(width = 1000) %>% dyOptions(drawPoints = TRUE, pointSize = 2)
  }
  
})


# Ausgabe der aktuellen Zeitserie bzw. Zeitserie + Arima-Fit
output$timeseries <- renderDygraph({
  if(store.graph$index2 == 1){return()}
  
  if(identical(store.graph$current.graph, 0)) return()
  
  store.graph$current.graph
  
})

# Dynamische Ueberschrift Ausgabe der Ausertung des ARIMA-Models
output$headerArima <- renderUI({
  if(store.graph$index == 1){return()}
  
  if(identical(store.graph$current.graph, 0)) return()
  
  if(!store.graph$boolArima) return()
  
  return(h3(strong("Currently fitted model"), align = "center"))
  
})


# Ausgabe der Kofidenzintervall-Schranken (5% und 95%) fuer spezifisches Arima-Modell
output$predArima <- renderDataTable({
  if(store.graph$index == 1){return()}
  
  if(identical(store.graph$current.graph, 0)) return()
  
  if(!store.graph$boolArima) return()
  
  store.graph$arimaPredData
  
})

# Erstelle ein automatisches Arima-Modells basierend auf den ausgewaehlten Daten
arima.model.auto <- eventReactive(input$ts1, {
  
  if(input$arimaSelected == 0) return()
  
  store.graph$name.current.model <- input$acfIndVar
  
  auto.arima.model <- auto.arima(timeseries())
  
  return(auto.arima.model)
  
})

# Erstellen eines Arima-Modells basierend auf den manuell eingetragenen Parametern
arima.model.manual <- eventReactive(input$ts1, {
  
  if(input$arimaSelected == 1) return()
  
  store.graph$name.current.model <- input$acfIndVar
  
  manual.arima.model <- Arima(timeseries(), order = c(input$AR, input$DIFF, input$MA))
  
  return(manual.arima.model)
})

# Ausgabe der Qualitaetstabelle des entsprechenden Arima-Modells
qual.arima <- eventReactive(input$ts1, {
  
  if(identical(input$AR, NA) || input$AR == "" || input$AR < 0){
    return(
      withProgress(message = "Choose proper p for AR",value=0.1, Sys.sleep(1.5), setProgress (1))
    )
  }
  
  if(identical(input$DIFF, NA) || input$DIFF == "" || input$DIFF < 0){
    return(
      withProgress(message = "Choose proper d for differencing",value=0.1, Sys.sleep(1.5), setProgress (1))
    )
  }
  
  if(identical(input$MA, NA) || input$MA == "" || input$MA < 0){
    return(
      withProgress(message = "Choose proper q for MA",value=0.1, Sys.sleep(1.5), setProgress (1))
    )
  }
  
  arima.model <- 0
  if(input$arimaSelected == 1){
    arima.model <- arima.model.auto()
  } else if(input$arimaSelected == 0){
    arima.model <- arima.model.manual()
  }
  
  bic.arima <- arima.model$bic
  aic.arima <- arima.model$aic
  loglik.arima <- arima.model$loglik
  erg.vec <- rbind(aic.arima, bic.arima, loglik.arima)
  rownames(erg.vec) <- c("Aikake's Information Criterion", "Bayesian Information Criterion", "Log-Likelihood")
  colnames(erg.vec) <- c("Value")
  
  return(erg.vec)
  
})

# Ausgabe des aktuellenn Arima-Modells
current.Arima <- eventReactive(input$ts1, {
  
  arima.model <- 0
  
  if(input$arimaSelected == 1){
    arima.model <- arima.model.auto()
  } else if(input$arimaSelected == 0){
    arima.model <- arima.model.manual()
  }
  
  return(arima.model)
})

# Erstellung der Summary des aktuellen ARIMA-Modells (Koeffizienten, Standardfehler)
summaryArima <- eventReactive(input$ts1, {
  
  if(!store.graph$boolArima) return()
  
  current.arima <- current.Arima()
  coef.arima <- as.data.frame(coef(current.arima))
  colnames(coef.arima) <- "Coefficents"
  sd.arima <- as.data.frame(sqrt(diag(current.arima$var.coef)))
  colnames(sd.arima) <- "Standard deviation"
  erg.a <- cbind(coef.arima, sd.arima)
  
  return(erg.a)
})

# Ausgabe aktuelle Arima-Summary
output$sumArima <- renderTable({
  if(store.graph$index == 1){return()}
  
  if(identical(store.graph$current.graph, 0)) return()
  
  summaryArima()
  
})

# Auslesen der Art des ARIMA-Models ((1,1,1) oder (1,2,0)...)
arimaKind <- eventReactive(input$ts1, {
  
  if(!store.graph$boolArima) return()
  
  h3(strong(capture.output(current.Arima())[2]))
  
})

# Ausgabe einer Textausgabe für die Art des Arima-Modells
output$kindArima <- renderUI({
  if(store.graph$index == 1){return()}
  
  if(identical(store.graph$current.graph, 0)) return()
  
  arimaKind()
  
})

# Ausgabe der Ueberschrift fuer die Guetekriterien-Tabelle
output$headerqual <- renderUI({
  if(store.graph$index == 1){return()}
  
  if(identical(store.graph$current.graph, 0)) return()
  
  if(!store.graph$boolArima) return()
  return(h3(strong("Quality criteria of current fitted model")))
  
})

# Ausgabe der Ueberschrift fuer die Fehler-Term-Tabelle
output$headererror <- renderUI({
  if(store.graph$index == 1){return()}
  
  if(identical(store.graph$current.graph, 0)) return()
  
  if(!store.graph$boolArima) return()
  
  return(h3(strong("Error Measures")))
  
})

# Erstellung der Fehlerterm-Tabelle des aktuellen ARIMA-Modells
errorMeasureArima <- eventReactive(input$ts1, {
  
  if(identical(store.graph$current.graph, 0)) return()
  
  if(!store.graph$boolArima) return()
  
  t(as.data.frame(accuracy(current.Arima())))
  
})

# Ausgabe der Fehlerterm-Tabelle des Arima-Modells
output$errorArima <- renderTable({
  if(store.graph$index == 1){return()}
  
  if(identical(store.graph$current.graph, 0)) return()
  
  if(identical(store.graph$current.graph, 0)) return()
  
  errorMeasureArima()
  
})

# Ausgabe der Ueberschrift der vorhergesagten Zeitpunkte
output$headerconfidenz <- renderUI({
  if(store.graph$index == 1){return()}
  
  if(identical(store.graph$current.graph, 0)) return()
  
  if(!store.graph$boolArima) return()
  
  return(h3(strong("Predicted confidence intervals")))
  
})


# Ausgabe der Qualitaetsmatrix des berechneten ARIMA-Modells
output$qual.model <- renderTable({
  if(store.graph$index == 1){return()}
  
  if(identical(store.graph$current.graph, 0)) return()
  
  if(!store.graph$boolArima) return()
  
  qual.arima()
  
})

# Logik hinter Speicherfunktion des Buttons "Store Arima-Model for chosen independent variable"
observeEvent(input$storeArima, {
  
  if(store.graph$index == 1 || identical(store.graph$name.current.model, 0)){return(withProgress(message = "Store not possible", Sys.sleep(1.5)))}
  
  store.graph$index <-1
  store.graph$index2<-1
  
  withProgress(message = "ARIMA forecast stored",value=0.1,{
    
    #  Zu Beginn wird in der Variable "arima.model" das aktuell zu betrachtende Arima-Modell gespeichert
    # "arima.graph" beinhaltet den aktuellen ARIMA Dygraph
    # "arima.quality" beinhaltet die Guetekriterien des zu speicherenden Modells
    arima.model <- 0
    arima.graph <- store.graph$current.graph
    arima.quality <- qual.arima()
    
    datum <- start$datum
    
    if(input$arimaSelected == 1){
      arima.model <- arima.model.auto()
    } else if(input$arimaSelected == 0){
      arima.model <- arima.model.manual()
      
    }
    
    # Sollte noch kein Modell gespeichert sein, wird die Informationstabelle und die Liste der gewaehlten Modelle
    # auf Basis dieses "ersten" Modells aktualisiert.
    if(length(daten.under$arima.modells) == 0){
      daten.under$arima.modells[[1]] <- list("Independent variable" = store.graph$name.current.model, "ARIMA-Model" = arima.model)
      store.graph$graphs[[1]] <- list("Independent variable" = store.graph$name.current.model, "ARIMA-Model-Graph" = arima.graph, "Quality" = arima.quality,
                                      "Coefficent" = summaryArima(), "ArimaKind" = arimaKind(), "Forecast" = store.graph$arimaPredData, "Error" = errorMeasureArima())
      
      p <- length(which(daten.under$arima.modells[[1]][[2]]$model$phi != 0))
      d <- length(daten.under$arima.modells[[1]][[2]]$model$Delta)
      q <- tryCatch({
        length(which(daten.under$arima.modells[[1]][[2]]$model$theta != 0))
      }, warning = function(w) {
        0
      }, error = function(e){
        0
      })
      
      store.graph$saveArima <- data.frame("Variable-Name" = store.graph$name.current.model, "p" =  p, "d" = d, "q" = q,
                                          "Start-Month" = month(datum), "Start-Year" = year(datum), "Frequence" = start$freq)
      
      store.graph$saveArima[[1]] <- as.character(store.graph$saveArima[[1]])
      store.graph$saveArima[[7]] <- as.character(store.graph$saveArima[[7]])
      
      return(store.graph$saveArima)
    }
    
    
    saved <- store.graph$saveArima
    
    loop <- length(saved[ ,2])
    
    changed <- 0
    
    # Sollten schon Modelle gespeichert sein, wird ueberprueft, ob sich schon ein Modell fuer die
    # gewaehlte independent variable in der Liste (arima.modells) befindet, wenn ja, wird dieser 
    # Eintrag ueberschrieben und der Index wird in der variable "changed" gespeichert.
    # Ansonsten wird das aktuelle Modell an das Ende der Liste gehaengt.
    for(i in 1:loop){
      if(saved[i, 1] == store.graph$name.current.model){
        daten.under$arima.modells[[i]] <- list("Independent variable" = store.graph$name.current.model, "ARIMA-Model" = arima.model)
      store.graph$graphs[[i]] <- list("Independent variable" = store.graph$name.current.model, "ARIMA-Model-Graph" = arima.graph, "Quality" = arima.quality,
                                      "Coefficent" = summaryArima(), "ArimaKind" = arimaKind(), "Forecast" = store.graph$arimaPredData, "Error" = errorMeasureArima())
      changed <- i
      break
    }
    if(i == loop){
      daten.under$arima.modells[[loop + 1]] <- list("Independent variable" = store.graph$name.current.model, "ARIMA-Model" = arima.model)
      store.graph$graphs[[loop + 1]] <- list("Independent variable" = store.graph$name.current.model, "ARIMA-Model-Graph" = arima.graph, "Quality" = arima.quality,
                                             Coefficent = summaryArima(), ArimaKind = arimaKind(), Forecast = store.graph$arimaPredData, "Error" = errorMeasureArima())
    }
  }
  
  # Sollte das Modell des 1. ersten und einzigen Listenelements geaendert werden, wird folgender If-Block
  # durchlaufen, da die ueberschriftzeile der Auswertungstabelle angepasst werden muss.
  if(length(daten.under$arima.modells) == 1 && changed == 1){
    
    daten.under$arima.modells[[1]] <- list("Independent variable" = store.graph$name.current.model, "ARIMA-Model" = arima.model)
    store.graph$graphs[[1]] <- list("Independent variable" = store.graph$name.current.model, "ARIMA-Model-Graph" = arima.graph, "Quality" = arima.quality,
                                    Coefficent = summaryArima(), ArimaKind = arimaKind(), Forecast = store.graph$arimaPredData, "Error" = errorMeasureArima())
    
    p <- length(which(daten.under$arima.modells[[1]][[2]]$model$phi != 0))
    d <- length(daten.under$arima.modells[[1]][[2]]$model$Delta)
    q <- tryCatch({
      length(which(daten.under$arima.modells[[1]][[2]]$model$theta != 0))
    }, warning = function(w) {
      0
    }, error = function(e){
      0
    })
    
    store.graph$saveArima <- data.frame("Variable-Name" = store.graph$name.current.model, "p" =  p, "d" = d, "q" = q,
                                        "Start-Month" = month(datum), "Start-Year" = year(datum), "Frequence" = start$freq)
    
    store.graph$saveArima[[1]] <- as.character(store.graph$saveArima[[1]])
    store.graph$saveArima[[7]] <- as.character(store.graph$saveArima[[7]])
    
    return(store.graph$saveArima)
  }
  
  # Sollte fuer die unabhaengige Variable das 1. Mal ein Modell hinzugefuegt werden, werden die diesbezueglichen Informationen 
  # an die Informationentabelle (saveArima) unten angehangen.
  if(length(daten.under$arima.modells) > 1 && changed == 0){
    for.loop <- length(daten.under$arima.modells)
    
    p <- length(which(daten.under$arima.modells[[for.loop]][[2]]$model$phi != 0))
    d <- length(daten.under$arima.modells[[for.loop]][[2]]$model$Delta)
    q <- tryCatch({
      length(which(daten.under$arima.modells[[for.loop]][[2]]$model$theta != 0))
    }, warning = function(w) {
      0
    }, error = function(e){
      0
    })
    
    store.graph$saveArima <- rbind(store.graph$saveArima, c(store.graph$name.current.model, p, d, q, month(datum), year(datum), start$freq))
    
  } else if(length(daten.under$arima.modells) > 1 && changed > 0){
    # Die folgenden beiden Bloecke organisieren die Informationstabelle, wenn sich eine Aenderung an einer Stelle zwischen letztem und
    # und 2. Modell ereignet.
    if(changed == 1){
      
      
      p <- length(which(daten.under$arima.modells[[1]][[2]]$model$phi != 0))
      d <- length(daten.under$arima.modells[[1]][[2]]$model$Delta)
      q <- tryCatch({
        length(which(daten.under$arima.modells[[1]][[2]]$model$theta != 0))
      }, warning = function(w) {
        0
      }, error = function(e){
        0
      })
      
      saveArima.temp <- data.frame("Variable-Name" = store.graph$name.current.model, "p" =  p, "d" = d, "q" = q,
                                   "Start-Month" = month(datum), "Start-Year" = year(datum), "Frequence" = start$freq)
      
      store.graph$saveArima <- rbind(saveArima.temp, store.graph$saveArima[2:length(store.graph$saveArima[ ,2]), ])
      
      store.graph$saveArima[[1]] <- as.character(store.graph$saveArima[[1]])
      store.graph$saveArima[[7]] <- as.character(store.graph$saveArima[[7]])
      
    } else if(changed > 1) {
      
      p <- length(which(daten.under$arima.modells[[changed]][[2]]$model$phi != 0))
      d <- length(daten.under$arima.modells[[changed]][[2]]$model$Delta)
      q <- tryCatch({
        length(which(daten.under$arima.modells[[changed]][[2]]$model$theta != 0))
      }, warning = function(w) {
        0
      }, error = function(e){
        0
      })
      
      saveArima.temp <- c(store.graph$name.current.model, p, d, q, month(datum), year(datum), start$freq)
      
      if(changed < length(store.graph$saveArima[ ,1])){
        store.graph$saveArima <- rbind(store.graph$saveArima[1:(changed-1), ], saveArima.temp, store.graph$saveArima[(changed + 1):length(store.graph$saveArima[ ,1]), ])
      } else {
        store.graph$saveArima <- rbind(store.graph$saveArima[1:(changed-1), ], saveArima.temp)
      }
      
      store.graph$saveArima[[1]] <- as.character(store.graph$saveArima[[1]])
      store.graph$saveArima[[7]] <- as.character(store.graph$saveArima[[7]])
    }
  }
  
  
  store.graph$current.graph <- 0
  
  # Zu guter Letzt wird die aktuelle Informationstabelle ausgegeben.
  store.graph$saveArima
  
  
  setProgress(1)
  Sys.sleep(1.5)
  })
})

# Folgender EventHandler regelt das Loeschen eines ausgewaehlten Modells
observeEvent(input$delete.arima, {
  
  name <- input$dygraph.stored
  names.saved <- store.graph$saveArima[[1]]
  index.saved <- which(names.saved == name)
  store.graph$saveArima <- store.graph$saveArima[-index.saved, ]
  
})

