# Ausgabe des Dygraphen der Modellierung
output$timeseriesexpsm <- renderDygraph({
  
  if(expsm.global$index2 == 1){return()}
  
  if(is.null(expsm.global$current.graph)) return()
  
  expsm.global$current.graph
  
})


# Dygraph-Plot fuer ausgewaehlte unabhaengige Variable + expsm Modell (Gegenueberstellung historischer Werte und 
# gefitteter Werte)
observeEvent(input$tsexpsm, {
  
  if(is.na(input$forecastexpsm)){return(
    withProgress(value=0.1,message = "Choose proper range to forecast", Sys.sleep(2.5), setProgress(1)))}
  if(input$forecastexpsm<1){return(
    withProgress(value=0.1,message = "Choose proper range to forecast", Sys.sleep(2.5), setProgress(1)))}
  
  expsm.global$index<-0
  expsm.global$index2<-0
  ts.data <- timeseriesexpsm()
  
  if(input$expsmSelected == 1 && input$forecastexpsm == 0){
    ts.data <- cbind("Historical values" = timeseriesexpsm(), "Exponential Smoothing for historical values" =  fitted(expsm.model.auto()))
    expsm.global$current.graph <- dygraph(ts.data, main = input$updateInd) %>% dyRangeSelector() %>%
      dyLegend(width = 800) %>% dyOptions(drawPoints = TRUE, pointSize = 2)
  }
  
  if(input$expsmSelected == 0 && input$forecastexpsm == 0){
    ts.data <- cbind("Historical values" = timeseriesexpsm(), "expsm for historical values" = fitted(expsm.model.manual()))
    expsm.global$current.graph <- dygraph(ts.data, main = input$updateInd) %>% dyRangeSelector()%>%
      dyLegend(width = 800) %>% dyOptions(drawPoints = TRUE, pointSize = 2)
  }
  
  expsm.global$boolexpsm = TRUE
  
  if(input$forecastexpsm > 0){
    
    pred.data <- 0
    expsm.model.temp <- 0
    if(input$expsmSelected == 1){
      expsm.model.temp <- expsm.model.auto()
    } else if(input$expsmSelected == 0){
      expsm.model.temp <- expsm.model.manual()
    }
    
    pred.data  <- forecast(expsm.model.temp, h = input$forecastexpsm, level = c(0.90))
    pred.fore  <- pred.data$mean
    pred.lower <- (pred.data$mean - pred.data$mean) + pred.data$lower
    pred.upper <- (pred.data$mean - pred.data$mean) + pred.data$upper
    pred.data  <- list(pred.fore, pred.lower, pred.upper)
    
    if(objects$frequencyName == "day" & objects$weekendForecast == "0"){
      pred.dates <- seq(tail(objects$lmDatengrundlage[ ,1], n = 1)[[1]], by = objects$frequencyName, length.out = isolate(input$forecastexpsm) + 1)[2:(isolate(input$forecastexpsm) + 1)]
      # Solange ein Wochenendtag in der Reihe ist, wiederholt er die "while"-Schleife
      while(sum(as.numeric(xor(weekdays(pred.dates)=="Samstag",weekdays(pred.dates)=="Sonntag")))!=0){
        pred.dates.temp <- pred.dates[-which(xor(weekdays(pred.dates)=="Samstag",weekdays(pred.dates)=="Sonntag"))]
        pred.date.temp.we <- seq(tail(pred.dates,n=1), by = objects$frequencyName, length.out=sum(xor(weekdays(pred.dates)=="Samstag",weekdays(pred.dates)=="Sonntag"))+1)[1:sum(xor(weekdays(pred.dates)=="Samstag",weekdays(pred.dates)=="Sonntag"))+1]
        pred.dates <- c(pred.dates.temp,pred.date.temp.we)
      }
    }else{
      pred.dates <- seq(tail(objects$lmDatengrundlage[ ,1], n = 1)[[1]], by = objects$frequencyName, length.out = isolate(input$forecastexpsm) + 1)[2:(isolate(input$forecastexpsm) + 1)]
    }
    
    # Output der Konfidenzintervalle
    expsm.global$expsmPredData <- cbind("Date" = pred.dates, 
                                        round(as.data.frame(cbind("Expectation forecast" = pred.data[[1]],
                                                                  "5%-Quantile forecast" = pred.data[[2]],
                                                                  "95%-Upper bound forecast" = pred.data[[3]])), digits = 3))
    
    na.entrys <- sum(sapply(t(timeseriesexpsm()),function(x) NA%in%x))
    if(na.entrys!=0){
      ts.dummy <- ts(data=NA,start=1,end=na.entrys)
      expsm.model.temp.padded <- c(ts.dummy,fitted(expsm.model.temp))
    }else{
      expsm.model.temp.padded <- fitted(expsm.model.temp)
    }
    
    ts.data <- cbind("Historical values" = timeseriesexpsm(),
                     "expsm for historical values" = xts(expsm.model.temp.padded, objects$lmDatengrundlage_Default[[1]]),
                     "Expectation forecast" = xts(pred.data[[1]], pred.dates),
                     "Lower bound forecast" = xts(pred.data[[2]], pred.dates), 
                     "Upper bound forecast" = xts(pred.data[[3]], pred.dates))
    
    colnames(ts.data) <- c("Historical values", "Exponential Smoothing for historical values",
                           "Expectation forecast", "Lower bound forecast", "Upper bound forecast")
    
    ts.data[dim(ts.data)[1] - (input$forecastexpsm), (3:5)] <- ts.data[dim(ts.data)[1] - (input$forecastexpsm), 2]
    
    expsm.global$current.graph <- dygraph(ts.data, main = input$updateInd) %>% 
      dySeries(c("Lower bound forecast", "Expectation forecast", "Upper bound forecast")) %>%
      dyRangeSelector() %>% dyLegend(width = 1000) %>% dyOptions(drawPoints = TRUE, pointSize = 2)
    
  }
  
})

# Erstellung der Summary des aktuellen expsm-Modells (Koeffizienten, Standardfehler)
summaryexpsm <- eventReactive(input$tsexpsm, {
  
  if(!expsm.global$boolexpsm) return()
  
  current.expsm <- current.expsm()
  if(length(coef(current.expsm)) > 0){
    erg.a <- t(as.matrix(current.expsm$par))
    colnames <- c("alpha","beta","gamma","phi","l","s0","b")%in%colnames(erg.a)
    erg.a <- erg.a[1,1:sum(as.numeric(colnames))]
    erg.a <- t(as.data.frame(erg.a))
    return(erg.a)
  }else{
    return()
  }
})

# Ausgabe des aktuellenn expsm-Modells
current.expsm <- eventReactive(input$tsexpsm, {
  
  expsm.model <- 0
  
  if(input$expsmSelected == 1){
    expsm.model <- expsm.model.auto()
  } else if(input$expsmSelected == 0){
    expsm.model <- expsm.model.manual()
  }
  
  return(expsm.model)
})

# Ausgabe der Qualitaetstabelle des entsprechenden expsm-Modells
qual.expsm <- eventReactive(input$tsexpsm, {
  
  expsm.model <- 0
  if(input$expsmSelected == 1){
    expsm.model <- expsm.model.auto()
  } else if(input$expsmSelected == 0){
    expsm.model <- expsm.model.manual()
  }
  
  bic.expsm <- expsm.model$bic
  aic.expsm <- expsm.model$aic
  loglik.expsm <- expsm.model$loglik
  erg.vec <- rbind(aic.expsm, bic.expsm, loglik.expsm)
  rownames(erg.vec) <- c("Aikake's Information Criterion", "Bayesian Information Criterion", "Log-Likelihood")
  colnames(erg.vec) <- c("Value")
  
  return(erg.vec)
  
})

# Auslesen der Art des expsm-Models ((1,1,1) oder (1,2,0)...)
expsmKind <- eventReactive(input$tsexpsm, {
  
  if(!expsm.global$boolexpsm) return()
  
  h3(strong(capture.output(current.expsm())[1]))
  
})

# Erstellung der Fehlerterm-Tabelle des aktuellen expsm-Modells
errorMeasureexpsm <- eventReactive(input$tsexpsm, {
  
  if(identical(expsm.global$current.graph, 0)) return()
  
  if(!expsm.global$boolexpsm) return()
  
  t(as.data.frame(accuracy(current.expsm())))
  
})

# Logik hinter Speicherfunktion des Buttons "Store expsm-Model for chosen independent variable"
observeEvent(input$storeexpsm, {
  
  if(expsm.global$index == 1 || identical(expsm.global$name.current.model, 0)){return(withProgress(message = "Store not possible", Sys.sleep(1.5)))}
  
  expsm.global$index <-1
  expsm.global$index2<-1
  
  withProgress(message = "Exponential Smoothing forecast stored",value=0.1,{
    
    #  Zu Beginn wird in der Variable "expsm.model" das aktuell zu betrachtende expsm-Modell gespeichert
    # "expsm.graph" beinhaltet den aktuellen expsm Dygraph
    # "expsm.quality" beinhaltet die Guetekriterien des zu speicherenden Modells
    expsm.model <- 0
    expsm.graph <- expsm.global$current.graph
    expsm.quality <- qual.expsm()
    
    datum <- objects$lmDatengrundlage_Default[[1]][1]
    
    if(input$expsmSelected == 1){
      expsm.model <- expsm.model.auto()
    } else if(input$expsmSelected == 0){
      expsm.model <- expsm.model.manual()
    }
    
    # Sollte noch kein Modell gespeichert sein, wird die Informationstabelle und die Liste der gewaehlten Modelle
    # auf Basis dieses "ersten" Modells aktualisiert.
    if(length(objects$lmexpsmModels) == 0){
      
      objects$lmexpsmModels[[1]] <- list("Independent variable" = expsm.global$name.current.model, "Exponential Smoothing Model" = expsm.model)
      objects$lmexpsmGraphs[[1]] <- list("Independent variable" = expsm.global$name.current.model, "Exponential Smoothing Model Graph" = expsm.graph, "Quality" = expsm.quality,
                                            "Coefficients" = summaryexpsm(), "expsmKind" = expsmKind(), "Forecast" = expsm.global$expsmPredData, "Error" = errorMeasureexpsm())
      
      p <- length(which(objects$lmexpsmModels[[1]][[2]]$model$phi != 0))
      d <- length(objects$lmexpsmModels[[1]][[2]]$model$Delta)
      q <- tryCatch({
        length(which(objects$lmexpsmModels[[1]][[2]]$model$theta != 0))
      }, warning = function(w) {
        0
      }, error = function(e){
        0
      })
      
      objects$lmexpsmSave <- data.frame("Variable-Name" = expsm.global$name.current.model, "p" =  p, "d" = d, "q" = q,
                                                "Start-Month" = month(datum), "Start-Year" = year(datum), "Frequence" = start$freq)
      
      objects$lmexpsmSave[[1]] <- as.character(objects$lmexpsmSave[[1]])
      objects$lmexpsmSave[[7]] <- as.character(objects$lmexpsmSave[[7]])
      
      objects$updateTableIndVariables[which(objects$updateTableIndVariables[,1] == expsm.global$name.current.model), 2] <- "Up to date"
      
      return(objects$lmexpsmSave)
    }
    
    
    saved <- objects$lmexpsmSave
    
    loop <- length(saved[ ,2])
    
    changed <- 0
    
    # Sollten schon Modelle gespeichert sein, wird ueberprueft, ob sich schon ein Modell fuer die
    # gewaehlte independent variable in der Liste (expsm.modells) befindet, wenn ja, wird dieser
    # Eintrag ueberschrieben und der Index wird in der variable "changed" gespeichert.
    # Ansonsten wird das aktuelle Modell an das Ende der Liste gehaengt.
    
    for(i in 1:loop){
      if(saved[i, 1] == expsm.global$name.current.model){
        objects$lmexpsmModels[[i]] <- list("Independent variable" = expsm.global$name.current.model, "expsm-Model" = expsm.model)
        objects$lmexpsmGraphs[[i]] <- list("Independent variable" = expsm.global$name.current.model, "expsm-Model-Graph" = expsm.graph, "Quality" = expsm.quality,
                                           "Coefficients" = summaryexpsm(),"expsmKind" = expsmKind(), "Forecast" = expsm.global$expsmPredData, "Error" = errorMeasureexpsm())
        changed <- i
        break
      }
      if(i == loop){
        objects$lmexpsmModels[[loop + 1]] <- list("Independent variable" = expsm.global$name.current.model, "expsm-Model" = expsm.model)
        objects$lmexpsmGraphs[[loop + 1]] <- list("Independent variable" = expsm.global$name.current.model, "expsm-Model-Graph" = expsm.graph, "Quality" = expsm.quality,
                                                  "Coefficients" = summaryexpsm(),"expsmKind" = expsmKind(), "Forecast" = expsm.global$expsmPredData, "Error" = errorMeasureexpsm())
      }
    }
    
    # Sollte das Modell des 1. ersten und einzigen Listenelements geaendert werden, wird folgender If-Block
    # durchlaufen, da die ueberschriftzeile der Auswertungstabelle angepasst werden muss.
    if(length(objects$lmexpsmModels) == 1 && changed == 1){
      
      objects$lmexpsmModels[[1]] <- list("Independent variable" = expsm.global$name.current.model, "expsm-Model" = expsm.model)
      objects$lmexpsmGraphs[[1]] <- list("Independent variable" = expsm.global$name.current.model, "expsm-Model-Graph" = expsm.graph, "Quality" = expsm.quality,
                                         "Coefficients" = summaryexpsm(),"expsmKind" = expsmKind(), "Forecast" = expsm.global$expsmPredData, "Error" = errorMeasureexpsm())
      
      p <- length(which(objects$lmexpsmModels[[1]][[2]]$model$phi != 0))
      d <- length(objects$lmexpsmModels[[1]][[2]]$model$Delta)
      q <- tryCatch({
        length(which(objects$lmexpsmModels[[1]][[2]]$model$theta != 0))
      }, warning = function(w) {
        0
      }, error = function(e){
        0
      })
      
      objects$lmexpsmSave <- data.frame("Variable-Name" = expsm.global$name.current.model, "p" =  p, "d" = d, "q" = q,
                                        "Start-Month" = month(datum), "Start-Year" = year(datum), "Frequence" = objects$frequencyName)
      
      objects$lmexpsmSave[[1]] <- as.character(objects$lmexpsmSave[[1]])
      objects$lmexpsmSave[[7]] <- as.character(objects$lmexpsmSave[[7]])
      
      # Sollte ein Regressions-Update vorgenommen worden sein, wird in der Status-Tabelle, der Status für die entsprechende Variable auf "Up to date" gesetzt
      print(objects$updateTableIndVariables)
      print(expsm.global$name.current.model)
      objects$updateTableIndVariables[which(objects$updateTableIndVariables[,1] == expsm.global$name.current.model), 2] <- "Up to date"
      
      print(objects$updateTableIndVariables)
      print(expsm.global$name.current.model)
      
      return(objects$lmexpsmSave)
    }
    
    # Sollte fuer die unabhaengige Variable das 1. Mal ein Modell hinzugefuegt werden, werden die diesbezueglichen Informationen
    # an die Informationentabelle (saveexpsm) unten angehangen.
    if(length(objects$lmexpsmModels) > 1 && changed == 0){
      
      for.loop <- length(objects$lmexpsmModels)
      
      p <- length(which(objects$lmexpsmModels[[for.loop]][[2]]$model$phi != 0))
      d <- length(objects$lmexpsmModels[[for.loop]][[2]]$model$Delta)
      q <- tryCatch({
        length(which(objects$lmexpsmModels[[for.loop]][[2]]$model$theta != 0))
      }, warning = function(w) {
        0
      }, error = function(e){
        0
      })
      
      objects$lmexpsmSave <- rbind(objects$lmexpsmSave, c(expsm.global$name.current.model, p, d, q, month(datum), year(datum), objects$frequencyName))
      
    } else if(length(objects$lmexpsmModels) > 1 && changed > 0){
      # Die folgenden beiden Bloecke organisieren die Informationstabelle, wenn sich eine Aenderung an einer Stelle zwischen letztem und
      # und 2. Modell ereignet.
      if(changed == 1){
        
        p <- length(which(objects$lmexpsmModels[[1]][[2]]$model$phi != 0))
        d <- length(objects$lmexpsmModels[[1]][[2]]$model$Delta)
        q <- tryCatch({
          length(which(objects$lmexpsmModels[[1]][[2]]$model$theta != 0))
        }, warning = function(w) {
          0
        }, error = function(e){
          0
        })
        
        saveexpsm.temp <- data.frame("Variable-Name" = expsm.global$name.current.model, "p" =  p, "d" = d, "q" = q,
                                     "Start-Month" = month(datum), "Start-Year" = year(datum), "Frequence" = objects$frequencyName)
        
        objects$lmexpsmSave <- rbind(saveexpsm.temp, objects$lmexpsmSave[2:length(objects$lmexpsmSave[ ,2]), ])
        
        objects$lmexpsmSave[[1]] <- as.character(objects$lmexpsmSave[[1]])
        objects$lmexpsmSave[[7]] <- as.character(objects$lmexpsmSave[[7]])
        
      } else if(changed > 1) {
        
        p <- length(which(objects$lmexpsmModels[[changed]][[2]]$model$phi != 0))
        d <- length(objects$lmexpsmModels[[changed]][[2]]$model$Delta)
        q <- tryCatch({
          length(which(objects$lmexpsmModels[[changed]][[2]]$model$theta != 0))
        }, warning = function(w) {
          0
        }, error = function(e){
          0
        })
        
        saveexpsm.temp <- c(expsm.global$name.current.model, p, d, q, month(datum), year(datum), objects$frequencyName)
        
        if(changed < length(objects$lmexpsmSave[ ,1])){
          objects$lmexpsmSave <- rbind(objects$lmexpsmSave[1:(changed-1), ], saveexpsm.temp, objects$lmexpsmSave[(changed + 1):length(objects$lmexpsmSave[ ,1]), ])
        } else {
          objects$lmexpsmSave <- rbind(objects$lmexpsmSave[1:(changed-1), ], saveexpsm.temp)
        }
        
        objects$lmexpsmSave[[1]] <- as.character(objects$lmexpsmSave[[1]])
        objects$lmexpsmSave[[7]] <- as.character(objects$lmexpsmSave[[7]])
      }
    }
    
    # Der current Graph wird auf NULL gesetzt, da das speichern abgeschlossen wurde
    expsm.global$current.graph <- NULL
    
    # Sollte ein Regressions-Update vorgenommen worden sein, wird in der Status-Tabelle, der Status für die entsprechende Variable auf "Up to date" gesetzt
    print(objects$updateTableIndVariables)
    print(expsm.global$name.current.model)
    
    objects$updateTableIndVariables[which(objects$updateTableIndVariables[,1] == expsm.global$name.current.model), 2] <- "Up to date"
    
    print(objects$updateTableIndVariables)
    print(expsm.global$name.current.model)
    setProgress(1)
    Sys.sleep(1.5)
  })
})