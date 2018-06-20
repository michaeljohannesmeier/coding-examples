# Ausgabe des Dygraphen der Modellierung
output$timeseriesarima <- renderDygraph({
  
  if(arima.global$index2 == 1){return()}
  
  if(is.null(arima.global$current.graph)) return()
  
  arima.global$current.graph
  
})


# Dygraph-Plot fuer ausgewaehlte unabhaengige Variable + ARIMA Modell (Gegenueberstellung historischer Werte und 
# gefitteter Werte)
observeEvent(input$tsarima, {
  
  if(is.na(input$forecastarima)){return(
    withProgress(value=0.1,message = "Choose proper range to forecast", Sys.sleep(2.5), setProgress(1)))}
  if(input$forecastarima<1){return(
    withProgress(value=0.1,message = "Choose proper range to forecast", Sys.sleep(2.5), setProgress(1)))}
  
  arima.global$index<-0
  arima.global$index2<-0
  ts.data <- timeseriesarima()
  
  if(input$arimaSelected == 1 && input$forecastarima == 0){
    ts.data <- cbind("Historical values" = timeseriesarima(), "ARIMA for historical values" =  fitted(arima.model.auto()))
    arima.global$current.graph <- dygraph(ts.data, main = input$updateInd) %>% dyRangeSelector() %>%
      dyLegend(width = 800) %>% dyOptions(drawPoints = TRUE, pointSize = 2)
  }
  
  if(input$arimaSelected == 0 && input$forecastarima == 0){
    ts.data <- cbind("Historical values" = timeseriesarima(), "ARIMA for historical values" = fitted(arima.model.manual()))
    arima.global$current.graph <- dygraph(ts.data, main = input$updateInd) %>% dyRangeSelector()%>%
      dyLegend(width = 800) %>% dyOptions(drawPoints = TRUE, pointSize = 2)
  }
  
  arima.global$boolArima = TRUE
  
  if(input$forecastarima > 0){
    
    pred.data <- 0
    arima.model.temp <- 0
    if(input$arimaSelected == 1){
      arima.model.temp <- arima.model.auto()
    } else if(input$arimaSelected == 0){
      arima.model.temp <- arima.model.manual()
    }
    
    pred.data  <- forecast(arima.model.temp, h = input$forecastarima, level = c(0.90))
    pred.fore  <- pred.data$mean
    pred.lower <- (pred.data$mean - pred.data$mean) + pred.data$lower
    pred.upper <- (pred.data$mean - pred.data$mean) + pred.data$upper
    pred.data  <- list(pred.fore, pred.lower, pred.upper)
    
    if(objects$frequencyName == "day" & objects$weekendForecast == "0"){
      pred.dates <- seq(tail(objects$lmDatengrundlage[ ,1], n = 1)[[1]], by = objects$frequencyName, length.out = isolate(input$forecastarima) + 1)[2:(isolate(input$forecastarima) + 1)]
      # Solange ein Wochenendtag in der Reihe ist, wiederholt er die "while"-Schleife
      while(sum(as.numeric(xor(weekdays(pred.dates)=="Samstag",weekdays(pred.dates)=="Sonntag")))!=0){
        pred.dates.temp <- pred.dates[-which(xor(weekdays(pred.dates)=="Samstag",weekdays(pred.dates)=="Sonntag"))]
        pred.date.temp.we <- seq(tail(pred.dates,n=1), by = objects$frequencyName, length.out=sum(xor(weekdays(pred.dates)=="Samstag",weekdays(pred.dates)=="Sonntag"))+1)[1:sum(xor(weekdays(pred.dates)=="Samstag",weekdays(pred.dates)=="Sonntag"))+1]
        pred.dates <- c(pred.dates.temp,pred.date.temp.we)
      }
    }else{
      pred.dates <- seq(tail(objects$lmDatengrundlage[ ,1], n = 1)[[1]], by = objects$frequencyName, length.out = isolate(input$forecastarima) + 1)[2:(isolate(input$forecastarima) + 1)]
    }
    
    # Output der Konfidenzintervalle
    arima.global$arimaPredData <- cbind("Date" = pred.dates, 
                                        round(as.data.frame(cbind("Expectation forecast" = pred.data[[1]],
                                                                  "5%-Quantile forecast" = pred.data[[2]],
                                                                  "95%-Upper bound forecast" = pred.data[[3]])), digits = 3))
    
    
    ts.data <- cbind("Historical values" = timeseriesarima(),
                     "ARIMA for historical values" = xts(fitted(arima.model.temp), objects$lmDatengrundlage_Default[[1]]),
                     "Expectation forecast" = xts(pred.data[[1]], pred.dates),
                     "Lower bound forecast" = xts(pred.data[[2]], pred.dates), 
                     "Upper bound forecast" = xts(pred.data[[3]], pred.dates))
    
    colnames(ts.data) <- c("Historical values", "ARIMA for historical values",
                           "Expectation forecast", "Lower bound forecast", "Upper bound forecast")
    
    ts.data[dim(ts.data)[1] - (input$forecastarima), (3:5)] <- ts.data[dim(ts.data)[1] - (input$forecastarima), 2]
    
    arima.global$current.graph <- dygraph(ts.data, main = input$updateInd) %>% 
      dySeries(c("Lower bound forecast", "Expectation forecast", "Upper bound forecast")) %>%
      dyRangeSelector() %>% dyLegend(width = 1000) %>% dyOptions(drawPoints = TRUE, pointSize = 2)
    
  }
  
})

# Erstellung der Summary des aktuellen ARIMA-Modells (Koeffizienten, Standardfehler)
summaryArima <- eventReactive(input$tsarima, {
  
  if(!arima.global$boolArima) return()
  
  current.arima <- current.Arima()
  if(length(coef(current.arima)) > 0){
    coef.arima <- as.data.frame(coef(current.arima))
    colnames(coef.arima) <- "Coefficients"
    sd.arima <- as.data.frame(sqrt(diag(current.arima$var.coef)))
    colnames(sd.arima) <- "Standard deviation"
    erg.a <- cbind(coef.arima, sd.arima)
    return(erg.a)
  }else{
    return()
  }
})

# Ausgabe des aktuellenn Arima-Modells
current.Arima <- eventReactive(input$tsarima, {
  
  arima.model <- 0
  
  if(input$arimaSelected == 1){
    arima.model <- arima.model.auto()
  } else if(input$arimaSelected == 0){
    arima.model <- arima.model.manual()
  }
  
  return(arima.model)
})

# Ausgabe der Qualitaetstabelle des entsprechenden Arima-Modells
qual.arima <- eventReactive(input$tsarima, {
  
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

# Auslesen der Art des ARIMA-Models ((1,1,1) oder (1,2,0)...)
arimaKind <- eventReactive(input$tsarima, {
  
  if(!arima.global$boolArima) return()
  
  h3(strong(capture.output(current.Arima())[2]))
  
})

# Erstellung der Fehlerterm-Tabelle des aktuellen ARIMA-Modells
errorMeasureArima <- eventReactive(input$tsarima, {
  
  if(is.null(arima.global$current.graph)) return()
  
  if(!arima.global$boolArima) return()
  
  t(as.data.frame(accuracy(current.Arima())))
  
})

# Logik hinter Speicherfunktion des Buttons "Store Arima-Model for chosen independent variable"
observeEvent(input$storeArima, {
  
  if(arima.global$index == 1 || identical(arima.global$name.current.model, 0)){return(withProgress(message = "Store not possible", Sys.sleep(1.5)))}
  
  arima.global$index <-1
  arima.global$index2<-1
  
  withProgress(message = "ARIMA forecast stored",value=0.1,{
    
    #  Zu Beginn wird in der Variable "arima.model" das aktuell zu betrachtende Arima-Modell gespeichert
    # "arima.graph" beinhaltet den aktuellen ARIMA Dygraph
    # "arima.quality" beinhaltet die Guetekriterien des zu speicherenden Modells
    arima.model <- 0
    arima.graph <- arima.global$current.graph
    arima.quality <- qual.arima()
    
    datum <- objects$lmDatengrundlage_Default[[1]][1]
    
    if(input$arimaSelected == 1){
      arima.model <- arima.model.auto()
    } else if(input$arimaSelected == 0){
      arima.model <- arima.model.manual()
    }
    
    # Sollte noch kein Modell gespeichert sein, wird die Informationstabelle und die Liste der gewaehlten Modelle
    # auf Basis dieses "ersten" Modells aktualisiert.
    if(length(objects$lmArimaModels) == 0){
      
      objects$lmArimaModels[[1]] <- list("Independent variable" = arima.global$name.current.model, "ARIMA-Model" = arima.model)
      objects$lmArimaGraphs[[1]] <- list("Independent variable" = arima.global$name.current.model, "ARIMA-Model-Graph" = arima.graph, "Quality" = arima.quality,
                                         "Coefficients" = summaryArima(), "ArimaKind" = arimaKind(), "Forecast" = arima.global$arimaPredData, "Error" = errorMeasureArima())
      
      p <- length(which(objects$lmArimaModels[[1]][[2]]$model$phi != 0))
      d <- length(objects$lmArimaModels[[1]][[2]]$model$Delta)
      q <- tryCatch({
        length(which(objects$lmArimaModels[[1]][[2]]$model$theta != 0))
      }, warning = function(w) {
        0
      }, error = function(e){
        0
      })
      
      objects$lmArimaSave <- data.frame("Variable-Name" = arima.global$name.current.model, "p" =  p, "d" = d, "q" = q,
                                        "Start-Month" = month(datum), "Start-Year" = year(datum), "Frequence" = objects$frequencyName)
      
      objects$lmArimaSave[[1]] <- as.character(objects$lmArimaSave[[1]])
      objects$lmArimaSave[[7]] <- as.character(objects$lmArimaSave[[7]])
      
      objects$updateTableIndVariables[which(objects$updateTableIndVariables[,1] == arima.global$name.current.model), 2] <- "Up to date"
      
      return(objects$lmArimaSave)
    }
    
    
    saved <- objects$lmArimaSave
    
    loop <- length(saved[ ,2])
    
    changed <- 0
    
    # Sollten schon Modelle gespeichert sein, wird ueberprueft, ob sich schon ein Modell fuer die
    # gewaehlte independent variable in der Liste (arima.modells) befindet, wenn ja, wird dieser 
    # Eintrag ueberschrieben und der Index wird in der variable "changed" gespeichert.
    # Ansonsten wird das aktuelle Modell an das Ende der Liste gehaengt.
    
    for(i in 1:loop){
      if(saved[i, 1] == arima.global$name.current.model){
        objects$lmArimaModels[[i]] <- list("Independent variable" = arima.global$name.current.model, "ARIMA-Model" = arima.model)
        objects$lmArimaGraphs[[i]] <- list("Independent variable" = arima.global$name.current.model, "ARIMA-Model-Graph" = arima.graph, "Quality" = arima.quality,
                                           "Coefficients" = summaryArima(), "ArimaKind" = arimaKind(), "Forecast" = arima.global$arimaPredData, "Error" = errorMeasureArima())
        changed <- i
        break
      }
      if(i == loop){
        objects$lmArimaModels[[loop + 1]] <- list("Independent variable" = arima.global$name.current.model, "ARIMA-Model" = arima.model)
        objects$lmArimaGraphs[[loop + 1]] <- list("Independent variable" = arima.global$name.current.model, "ARIMA-Model-Graph" = arima.graph, "Quality" = arima.quality,
                                                  "Coefficients" = summaryArima(), "ArimaKind" = arimaKind(), "Forecast" = arima.global$arimaPredData, "Error" = errorMeasureArima())
      }
    }
    
    # Sollte das Modell des 1. ersten und einzigen Listenelements geaendert werden, wird folgender If-Block
    # durchlaufen, da die ueberschriftzeile der Auswertungstabelle angepasst werden muss.
    if(length(objects$lmArimaModels) == 1 && changed == 1){
      
      objects$lmArimaModels[[1]] <- list("Independent variable" = arima.global$name.current.model, "ARIMA-Model" = arima.model)
      objects$lmArimaGraphs[[1]] <- list("Independent variable" = arima.global$name.current.model, "ARIMA-Model-Graph" = arima.graph, "Quality" = arima.quality,
                                         "Coefficients" = summaryArima(), "ArimaKind" = arimaKind(), "Forecast" = arima.global$arimaPredData, "Error" = errorMeasureArima())
      
      p <- length(which(objects$lmArimaModels[[1]][[2]]$model$phi != 0))
      d <- length(objects$lmArimaModels[[1]][[2]]$model$Delta)
      q <- tryCatch({
        length(which(objects$lmArimaModels[[1]][[2]]$model$theta != 0))
      }, warning = function(w) {
        0
      }, error = function(e){
        0
      })
      
      objects$lmArimaSave <- data.frame("Variable-Name" = arima.global$name.current.model, "p" =  p, "d" = d, "q" = q,
                                        "Start-Month" = month(datum), "Start-Year" = year(datum), "Frequence" = objects$frequencyName)
      
      objects$lmArimaSave[[1]] <- as.character(objects$lmArimaSave[[1]])
      objects$lmArimaSave[[7]] <- as.character(objects$lmArimaSave[[7]])
      
      # Sollte ein Regressions-Update vorgenommen worden sein, wird in der Status-Tabelle, der Status für die entsprechende Variable auf "Up to date" gesetzt
      print(objects$updateTableIndVariables)
      print(arima.global$name.current.model)
      objects$updateTableIndVariables[which(objects$updateTableIndVariables[,1] == arima.global$name.current.model), 2] <- "Up to date"
      
      print(objects$updateTableIndVariables)
      print(arima.global$name.current.model)
      
      return(objects$lmArimaSave)
    }
    
    # Sollte fuer die unabhaengige Variable das 1. Mal ein Modell hinzugefuegt werden, werden die diesbezueglichen Informationen 
    # an die Informationentabelle (saveArima) unten angehangen.
    if(length(objects$lmArimaModels) > 1 && changed == 0){
      
      for.loop <- length(objects$lmArimaModels)
      
      p <- length(which(objects$lmArimaModels[[for.loop]][[2]]$model$phi != 0))
      d <- length(objects$lmArimaModels[[for.loop]][[2]]$model$Delta)
      q <- tryCatch({
        length(which(objects$lmArimaModels[[for.loop]][[2]]$model$theta != 0))
      }, warning = function(w) {
        0
      }, error = function(e){
        0
      })
      
      objects$lmArimaSave <- rbind(objects$lmArimaSave, c(arima.global$name.current.model, p, d, q, month(datum), year(datum), objects$frequencyName))
      
    } else if(length(objects$lmArimaModels) > 1 && changed > 0){
      # Die folgenden beiden Bloecke organisieren die Informationstabelle, wenn sich eine Aenderung an einer Stelle zwischen letztem und
      # und 2. Modell ereignet.
      if(changed == 1){
        
        p <- length(which(objects$lmArimaModels[[1]][[2]]$model$phi != 0))
        d <- length(objects$lmArimaModels[[1]][[2]]$model$Delta)
        q <- tryCatch({
          length(which(objects$lmArimaModels[[1]][[2]]$model$theta != 0))
        }, warning = function(w) {
          0
        }, error = function(e){
          0
        })
        
        saveArima.temp <- data.frame("Variable-Name" = arima.global$name.current.model, "p" =  p, "d" = d, "q" = q,
                                     "Start-Month" = month(datum), "Start-Year" = year(datum), "Frequence" = objects$frequencyName)
        
        objects$lmArimaSave <- rbind(saveArima.temp, objects$lmArimaSave[2:length(objects$lmArimaSave[ ,2]), ])
        
        objects$lmArimaSave[[1]] <- as.character(objects$lmArimaSave[[1]])
        objects$lmArimaSave[[7]] <- as.character(objects$lmArimaSave[[7]])
        
      } else if(changed > 1) {
        
        p <- length(which(objects$lmArimaModels[[changed]][[2]]$model$phi != 0))
        d <- length(objects$lmArimaModels[[changed]][[2]]$model$Delta)
        q <- tryCatch({
          length(which(objects$lmArimaModels[[changed]][[2]]$model$theta != 0))
        }, warning = function(w) {
          0
        }, error = function(e){
          0
        })
        
        saveArima.temp <- c(arima.global$name.current.model, p, d, q, month(datum), year(datum), objects$frequencyName)
        
        if(changed < length(objects$lmArimaSave[ ,1])){
          objects$lmArimaSave <- rbind(objects$lmArimaSave[1:(changed-1), ], saveArima.temp, objects$lmArimaSave[(changed + 1):length(objects$lmArimaSave[ ,1]), ])
        } else {
          objects$lmArimaSave <- rbind(objects$lmArimaSave[1:(changed-1), ], saveArima.temp)
        }
        
        objects$lmArimaSave[[1]] <- as.character(objects$lmArimaSave[[1]])
        objects$lmArimaSave[[7]] <- as.character(objects$lmArimaSave[[7]])
      }
    }
    
    # Der current Graph wird auf NULL gesetzt, da das speichern abgeschlossen wurde
    arima.global$current.graph <- NULL
    
    # Sollte ein Regressions-Update vorgenommen worden sein, wird in der Status-Tabelle, der Status für die entsprechende Variable auf "Up to date" gesetzt
    print(objects$updateTableIndVariables)
    print(arima.global$name.current.model)
    
    objects$updateTableIndVariables[which(objects$updateTableIndVariables[,1] == arima.global$name.current.model), 2] <- "Up to date"
    
    print(objects$updateTableIndVariables)
    print(arima.global$name.current.model)
    setProgress(1)
    Sys.sleep(1.5)
  })
})