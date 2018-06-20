# Diese reactiveFunction wird ausgefuehrt sobald der Button "Simulate" gedrueckt wird,
# dabei werden zu Beginn die Daten aufbereitet.

observeEvent(input$startSim, {
  
  # Ueberpruefen ob ausreichend Daten fuer die Simulation zur Verfuegung stehen
  regression.modell <- objects$lmRegressionModell
  
  # Check for Saisonalitaet um Dummy-Variablen herauszufilter
  if(regression.modell[[8]] && object$frequencyValue == 12){
    names.needed <- names(regression.modell[[1]]$coefficients)[-1][names(regression.modell[[1]]$coefficients[-1])
                                                                   %in% (attributes(regression.modell[[2]])$names[-((ncol(regression.modell[[2]])-10): ncol(regression.modell[[2]]))])]
  }else if(regression.modell[[8]] && object$frequencyValue == 4){
    names.needed <- names(regression.modell[[1]]$coefficients)[-1][names(regression.modell[[1]]$coefficients[-1])
                                                                   %in% (attributes(regression.modell[[2]])$names[-((ncol(regression.modell[[2]])-2): ncol(regression.modell[[2]]))])]
  }else{
    names.needed <- names(regression.modell[[1]]$coefficients)[-1][names(regression.modell[[1]]$coefficients[-1])
                                                                   %in% (attributes(regression.modell[[2]])$names)]
  }
  
  
  arima.names <- objects$lmArimaSave$Variable.Name
  expsm.names <- objects$lmexpsmSave$Variable.Name
  manual.data <- objects$lmManualInput
  trend.data <- objects$lmTrendInput
  forecast.tabelle <- objects$usedForecastsInd
  
  # print("Hier1")
  pred <- input$steps
  
 
  if(pred > montecarlo.global$max.steps.predict && montecarlo.global$max.steps.predict != -1){
    pred <- montecarlo.global$max.steps.predict
  }
  
  # Wenn keine Zeitschritte uebergeben werden beende die Ausfuehrung
  if(pred == 0) return()
  
  # print("Hier2")
  #print(attributes(regression.modell[[2]])$names)
  #print(head(regression.modell[[4]]))
  lags <- regression.modell[[4]][attributes(regression.modell[[2]])$names %in% names.needed]
  lag.names <- data.frame("Independent variables" = objects$coeffNames, "Lags" = lags)
  
  reg.data <- objects$lmDatengrundlage[ ,sapply(objects$lmDatengrundlage, is.numeric)]
  #index.depVar <- which(attributes(reg.data)$names == input$depVar)
  
  # Erstellen der Zeitserie, welche die historischen Daten beinhaltet.
  ts.dat.reg <- xts(objects$lmDatengrundlage_Default[ ,objects$lmRegressionModell[[7]]], objects$lmDatengrundlage_Default[[1]])
  
  print(ts.dat.reg)
  
  # print("Hier3")
  # Speichern der durch die Timelags zur verfuegungstehenende Daten fuer den Forecast in der Variable "daten.lag"
  daten.lag <- list()
  for(j in 1:length(lag.names[ ,1])){
    if(lag.names[j, 2] > 0){
      index.temp <- which(attributes(reg.data)$names == lag.names[j, 1])
      
      length.dat <- length(as.data.frame(reg.data[ ,index.temp])[[1]])
      
      daten.lag[[j]] <-as.data.frame(reg.data[ ,index.temp])[[1]][(length.dat - lag.names[j, 2] + 1):length.dat]
      next
    }
    daten.lag[[j]] <- NA
  }
  
  # print("Hier4")
  names(daten.lag) <- names.needed
  
  norm.parameter <- list()
  norm.vert <- data.frame()
  
  # Berechnung der Paramter der Normalverteilung der verschiedenen Arima-Modelle der unabhaengigen Variablen fuer
  # die zu vorhersagenden Zeitschritte. Speichern dieser in der Variable "norm.parameter"
  if(length(objects$lmArimaModels) > 0){
    for(i in 1:length(objects$lmArimaModels)){
      
      norm.vert <- data.frame()
      name.temp <- objects$lmArimaModels[[i]][[1]]
      if(!(name.temp %in% names.needed)){
        next
      }
      index.lag <- which(name.temp == lag.names[ ,1])
      lag.temp <- lag.names[index.lag, 2]
      
      num.forecast <- pred - lag.temp
      if(num.forecast >= 1){
        if(num.forecast > 1){
          pred.data <- forecast(objects$lmArimaModels[[i]][[2]], h = num.forecast, level = c(0.90))
          pred.fore <- pred.data$mean
          pred.lower <- (pred.data$mean - pred.data$mean) + pred.data$lower
          pred.upper <- (pred.data$mean - pred.data$mean) + pred.data$upper
          norm.vert <- cbind(pred.fore, (pred.upper - pred.fore)/1.645)
          colnames(norm.vert) <- c("Mu", "Sigma")
          norm.parameter[[i]] <- norm.vert
        }else if(num.forecast == 1){
          # Umweg wegen Fehler bei TS Laenge 1, wenn ein Trainingsdatensatz abgesplittet wurde
          pred.data <- forecast(objects$lmArimaModels[[i]][[2]], h = num.forecast, level = c(0.90))
          pred.fore <- pred.data$mean
          pred.lower <- (pred.data$mean - pred.data$mean) + pred.data$lower
          pred.upper <- (pred.data$mean - pred.data$mean) + pred.data$upper
          pred.fore.whole <- cbind(pred.fore, pred.lower, pred.upper)
          norm.vert <- cbind(pred.fore, (pred.fore.whole[ ,3] - pred.fore.whole[ ,1])/1.645)
          colnames(norm.vert) <- c("Mu", "Sigma")
          norm.parameter[[i]] <- norm.vert
        }
      }else{
        norm.parameter[[i]] <- "NoInput"
      }
      names(norm.parameter)[i] <- name.temp
      
    }
  }
  
  if(length(objects$lmexpsmModels) > 0){
    for(i in 1:length(objects$lmexpsmModels)){
      
      norm.vert <- data.frame()
      name.temp <- objects$lmexpsmModels[[i]][[1]]
      if(!(name.temp %in% names.needed)){
        next
      }
      index.lag <- which(name.temp == lag.names[ ,1])
      lag.temp <- lag.names[index.lag, 2]
      num.forecast <- pred - lag.temp
      current.save <- length(norm.parameter) + 1
      
      if(num.forecast >= 1){
        if(num.forecast > 1){
          pred.data <- forecast(objects$lmexpsmModels[[i]][[2]], h = num.forecast, level = c(0.90))
          pred.fore <- pred.data$mean
          pred.lower <- (pred.data$mean - pred.data$mean) + pred.data$lower
          pred.upper <- (pred.data$mean - pred.data$mean) + pred.data$upper
          norm.vert <- cbind(pred.fore, (pred.upper - pred.fore)/1.645)
          colnames(norm.vert) <- c("Mu", "Sigma")
          norm.parameter[[current.save]] <- norm.vert
        }else if(num.forecast == 1){
          # Umweg wegen Fehler bei TS Laenge 1, wenn ein Trainingsdatensatz abgesplittet wurde
          pred.data <- forecast(daten.under$arima.modells[[i]][[2]], h = num.forecast, level = c(0.90))
          pred.fore <- pred.data$mean
          pred.lower <- (pred.data$mean - pred.data$mean) + pred.data$lower
          pred.upper <- (pred.data$mean - pred.data$mean) + pred.data$upper
          pred.fore.whole <- cbind(pred.fore, pred.lower, pred.upper)
          norm.vert <- cbind(pred.fore, (pred.fore.whole[ ,3] - pred.fore.whole[ ,1])/1.645)
          colnames(norm.vert) <- c("Mu", "Sigma")
          norm.parameter[[current.save]] <- norm.vert
        }
      }else{
        norm.parameter[[current.save]] <- "NoInput"
      }
      names(norm.parameter)[current.save] <- name.temp
      
    }
  }
  
  manual.data <- objects$lmManualInput
  variablen.manual <- as.character(dplyr::filter(forecast.tabelle, Forecast.kind == "Manual Input")[[1]])
  
  namen.filter <- sapply(names(manual.data), function(x) x %in% variablen.manual)
  # In der Variable "manual.data" befindet sich die Liste mit den unabhaengigen Variablen fuer die kein ARIMA-Modell vorhanden ist.
  # In den einzelnen Listeneintraegen befinden sich die etwaige manuell eingetragene Daten.
  
  if(length(which(namen.filter == TRUE)) > 0){
    manual.data <- manual.data[which(namen.filter == TRUE)]
    
    for(i in 1:length(manual.data)){
      
      norm.vert <- data.frame()
      name.temp <- names(manual.data[i])
      if(!(name.temp %in% names.needed)){
        next
      }
      index.lag <- which(name.temp == lag.names[ ,1])
      lag.temp <- lag.names[index.lag, 2]
      num.forecast <- pred - lag.temp
      current.save <- length(norm.parameter) + 1
      
      if(dim(manual.data[[i]])[1] >= 1 && num.forecast > 0){
        pred.mean <- manual.data[[i]]$Expected.Value[1:num.forecast]
        pred.lower <- manual.data[[i]]$Lower.Quantile[1:num.forecast]
        pred.upper <- manual.data[[i]]$Upper.Quantile[1:num.forecast]
        norm.vert <- cbind(pred.mean, (pred.upper - pred.lower)/1.645)
        colnames(norm.vert) <- c("Mu", "Sigma")
        norm.parameter[[current.save]] <- norm.vert
      } else {
        norm.parameter[[current.save]] <- "NoInput"
      }
      
      names(norm.parameter)[current.save] <- name.temp
    }
    
  }
  
  #Verarbeiten der Trendeingaben
  variablen.trend <- as.character(dplyr::filter(forecast.tabelle, Forecast.kind == "Trend Input")[[1]])
  namen.filter.trend <- sapply(names(trend.data), function(x) x %in% variablen.trend)
  
  if(length(which(namen.filter.trend == TRUE)) > 0){
    trend.data <- trend.data[which(namen.filter.trend == TRUE)]
    
    for(i in 1:length(trend.data)){
      
      norm.vert <- data.frame()
      name.temp <- names(trend.data[i])
      if(!(name.temp %in% names.needed)){
        next
      }
      index.lag <- which(name.temp == lag.names[ ,1])
      lag.temp <- lag.names[index.lag, 2]
      num.forecast <- pred - lag.temp
      current.save <- length(norm.parameter) + 1
      
      if(dim(trend.data[[i]][[2]])[1] >= 1 && num.forecast > 0){
        pred.mean  <- trend.data[[i]][[2]]$`Expected Value`[1:num.forecast]
        pred.lower <- trend.data[[i]][[2]]$`Lower Quantile`[1:num.forecast]
        pred.upper <- trend.data[[i]][[2]]$`Upper Quantile`[1:num.forecast]
        norm.vert <- cbind(pred.mean, (pred.upper - pred.lower)/1.645)
        colnames(norm.vert) <- c("Mu", "Sigma")
        norm.parameter[[current.save]] <- norm.vert
      } else {
        norm.parameter[[current.save]] <- "NoInput"
      }
      
      names(norm.parameter)[current.save] <- name.temp
      
    }
    
  }
  
  ############################## Ende Trend input
  sim.values <- c()
  
  # Berechnung der abhaengigen Variable auf Basis des Regressionsmodells und der zugehoerigen Arima-Modelle 
  # fuer die Anzahl der Zeitschritte sowie die Anzahl der Simulationsdurchlaeufe
  print("NORMALVERTEILUNGEN")
  print(norm.parameter)
  
  # Generiere Saison-Dummys bevor die Simulation durchgefuehrt wird
  saison_dummys <- 0
  
  if(regression.modell[[8]] && object$frequencyValue == 12){
    # Definieren erstes vorherzusagende Datum (Monatsdaten)
    pred.dates <- seq(tail(objects$lmDatengrundlage_Default[ ,1], n = 1)[[1]],
                      by = objects$frequencyName,
                      length.out = pred + 1)[2]
    
    # Hier werden die Saison-Dummys generiert
    saison_dummys <- seasonaldummy(ts(rep(NA, pred),
                                      start = c(year(pred.dates),
                                                month(pred.dates),
                                                day(pred.dates)),
                                      frequency = 12))
    
  }else if(regression.modell[[8]] && object$frequencyValue == 4){
    # Definieren erstes vorherzusagende Datum (Quartalsdaten)
    pred.dates <- seq(tail(objects$lmDatengrundlage_Default[ ,1], n = 1)[[1]],
                      by = objects$frequencyName,
                      length.out = pred + 1)[2]
    
    # Hier werden die Saison-Dummys generiert
    saison_dummys <- seasonaldummy(ts(rep(NA, pred),
                                      start = c(year(pred.dates),
                                                quarter(pred.dates)),
                                      frequency = 4))
    
  }
  
  # Starte Simulation
  withProgress(message = "Simulating",value=0.1,{
    for(i in 1:input$sim){
      
      daten.lag.temp <- list()
      
      for(k in 1:length(lag.names[ ,1])){
        name.lag <- lag.names[k, 1]
        index.arima <- which(names(norm.parameter) == name.lag)
        if(norm.parameter[[index.arima]][1] != "NoInput"){
          if(is.na(daten.lag[[k]])[1]){
            daten.lag.temp[[k]] <- c(rnorm(length(norm.parameter[[index.arima]][ ,1]), norm.parameter[[index.arima]][ ,1], norm.parameter[[index.arima]][ ,2]))
          } else {
            daten.lag.temp[[k]] <- c(daten.lag[[k]], rnorm(length(norm.parameter[[index.arima]][ ,1]), norm.parameter[[index.arima]][ ,1], norm.parameter[[index.arima]][ ,2]))
          }
          #daten.lag.temp[[k]][which(daten.lag.temp[[k]] < 0)] <- 0
        } else if(norm.parameter[[index.arima]][1] == "NoInput"){
          daten.lag.temp[[k]] <- c(daten.lag[[k]][1:pred])
        }
      }
      
      # Aufbereitung der gesampelten Werte der unabhaengigen Variablen
      data.temp <- c()
      for(m in 1:length(daten.lag)){
        data.temp <- cbind(data.temp, daten.lag.temp[[m]])
      }
      
      # Zuordnung der Namen fuer reibungslose Verwendung des gespeicherten linearen Modells.
      data.temp <- as.data.frame(data.temp)
      colnames(data.temp) <- names.needed
      
      if(regression.modell[[8]]){
        data.temp <- cbind(data.temp, saison_dummys)
      }
      
      # Anwendung des Regressionsmodells und speichern der Ergebnisse fuer die verschiedenen Zeitschritte 
      # in der Variable "sim.values" in der schon die Werte der vorhergehenden Simulationsdurchlaeufe liegen.
      sim.values.temp <- predict(regression.modell[[1]], data.temp)
      sim.values <- cbind(sim.values, sim.values.temp)
      
    }
  })
  
  # In der Variable "sim.values" befinden sich in diesem Moment die Simulationsergebnisse in den Spalten
  
  # In der Variable "confidence.sim" werden die empirischen Konfidenzintervalle gespeichert
  confidence.sim.mean <- list()
  
  # In der folgenden For-Schleife werden die Mittelwerte sowie die durch die time-Lags noch zur Verfuegung stehenden
  # Daten der unabhaengigen Variable in der Variable "confidence.sim.mean" gespeichert.
  for(l in 1:length(lag.names[ ,1])){
    name.lag <- lag.names[l, 1]
    index.arima <- which(names(norm.parameter) == name.lag)
    if(norm.parameter[[index.arima]][1] != "NoInput"){
      if(is.na(daten.lag[[l]])[1]){
        confidence.sim.mean[[l]] <- c(norm.parameter[[index.arima]][ ,1])
      } else {
        confidence.sim.mean[[l]] <- c(daten.lag[[l]], norm.parameter[[index.arima]][ ,1])
      }
    } else if(norm.parameter[[index.arima]][1] == "NoInput"){
      confidence.sim.mean[[l]] <- c(daten.lag[[l]][1:pred])
    }
  }
  

  # Die Daten werden analog wie in der Simulationsschleife aufbereitet
  confidence.sim.mean.1 <- c()
  for(m in 1:length(daten.lag)){
    confidence.sim.mean.1 <- cbind(confidence.sim.mean.1, confidence.sim.mean[[m]])
  }
  
  # Namen werden richtig gesetzt
  confidence.sim.mean.1 <- as.data.frame(confidence.sim.mean.1)
  colnames(confidence.sim.mean.1) <- names.needed

  # Setzen der Saisonalitaeten
  if(regression.modell[[8]]){
    confidence.sim.mean.1 <- cbind(confidence.sim.mean.1, saison_dummys)
  }

  # Setzen der Ergebniswerte der Simulation
  montecarlo.global$sim_values <- sim.values
  montecarlo.global$dep_var_data <- ts.dat.reg
  montecarlo.global$pred_timesteps <-  pred
  montecarlo.global$used_model <- regression.modell[[1]]
  montecarlo.global$mean_values_forcast <- confidence.sim.mean.1
  
})

observeEvent(montecarlo.global$sim_values, {
  
  if(is.null(montecarlo.global$sim_values)) return()
  
  sim.values <- montecarlo.global$sim_values
  ts.dat.reg <- montecarlo.global$dep_var_data
  pred <- montecarlo.global$pred_timesteps
  regmodell <- montecarlo.global$used_model
  confidence.sim.mean.1 <- montecarlo.global$mean_values_forcast
  
  # Beruecksichtigung der "Unsicherheit" des Regressionsmodells
  sim.values.mean <- predict(regmodell, confidence.sim.mean.1, interval = "confidence", level = input$uncertainty)
  sim.values.mean <- as.data.frame(sim.values.mean)
  
  # Fallunterscheidung falls eine der beiden Variablen den Input "NULL" hat
  if(objects$frequencyName == "day" & objects$weekendForecast == "0"){
    pred.dates <- seq(tail(objects$lmDatengrundlage[ ,1], n = 1)[[1]], by = objects$frequencyName, length.out = pred + 1)[2:(pred + 1)]
    # Solange ein Wochenendtag in der Reihe ist, wiederholt er die "while"-Schleife
    while(sum(as.numeric(xor(weekdays(pred.dates)=="Samstag",weekdays(pred.dates)=="Sonntag")))!=0){
      pred.dates.temp <- pred.dates[-which(xor(weekdays(pred.dates)=="Samstag",weekdays(pred.dates)=="Sonntag"))]
      pred.date.temp.we <- seq(tail(pred.dates,n=1), by = objects$frequencyName, length.out=sum(xor(weekdays(pred.dates)=="Samstag",weekdays(pred.dates)=="Sonntag"))+1)[1:sum(xor(weekdays(pred.dates)=="Samstag",weekdays(pred.dates)=="Sonntag"))+1]
      pred.dates <- c(pred.dates.temp,pred.date.temp.we)
    }
  }else{
    pred.dates <- seq(tail(objects$lmDatengrundlage[ ,1], n = 1)[[1]], by = objects$frequencyName, length.out = pred + 1)[2:(pred + 1)]
  }
  
  # Die Simulationswerte werden als Zeitreihe gespeichert
  sim.values <- xts(sim.values, pred.dates)
  
  # Berechnen der Quantile auf Basis der simulierten Werte
  quantile.ci <- t(apply(sim.values, 1, function(x) quantile(x, probs = c((1 - input$uncertainty)/2, input$uncertainty + (1 - input$uncertainty)/2))))
  
  if(input$CIregression == 1){
    quantile.ci[ ,1] <- quantile.ci[ ,1] - (sim.values.mean[ ,1] - sim.values.mean[ ,2])
    quantile.ci[ ,2] <- quantile.ci[ ,2] + (sim.values.mean[ ,3] - sim.values.mean[ ,1])
  }
  
  # In dieser Variable liegen die historischen Daten sowie die der Simulation
  #erg <- cbind(ts.dat.reg, sim.values)
  
  # Aufbereitung der Konfidenzintervallsdaten
  #if(input$tesdata = FALSE){
  
  
  ci.predict <- cbind(sim.values.mean[ ,1], quantile.ci)
  
 
  ci.predict.2 <- xts(ci.predict, pred.dates)
  ci.predict <- cbind(ts.dat.reg, ci.predict.2)
  

  # Setzen der Spaltennamen fuer die Tabelle mit den Grenzwerten der Kofidenzintervalle
  colnames(ci.predict.2) <- c("Mean value", paste("Empirical", 100-input$uncertainty*100, "quantile", sep=" "), paste("Empirical", input$uncertainty*100, "quantile", sep=" "))
  colnames(ci.predict) <- c("Historical values", "Mean value", "Empirical 10%-quantile", "Empirical 90%-quantile")

  ci.predict[dim(ci.predict)[1] - pred, (2:4)] <- ci.predict[dim(ci.predict)[1] - pred, 1]
  
  # if(splitindex$splittruefalse == TRUE && input$testdata == TRUE){
  #   
  #   reg.data <- daten.under$base[ ,sapply(daten.under$base, is.numeric)]
  #   index.depVar <- which(attributes(reg.data)$names == input$depVar)
  #   
  #   testdata <- daten.under$data.test[ ,index.depVar + 1]
  #   
  #   # Definieren der abgesplitteten Zeitwerte
  #   split.dates <- seq(tail(daten.under$base[ ,1], n = 1)[[1]],
  #                      by = start$freq,
  #                      length.out = nrow(testdata) + 1)[2:(nrow(testdata) + 1)]
  #   
  #   testdatats  <- xts(testdata, split.dates)
  #   
  #   ci.predict<-cbind(ci.predict, testdatats)
  #   
  #   colnames(ci.predict) <- c("Historical values", "Mean value", "Empirical 10%-quantile", "Empirical 90%-quantile","Test data")
  #   
  #   ci.predict[nrow(ci.predict) - splitindex$split, 5] <- ci.predict[nrow(ci.predict) - splitindex$split, 1]
  # }
  
  ergebnis.ci  <- dygraph(ci.predict, main = paste("Forecast of", objects$lmRegressionModell[[7]], sep = " ")) %>%
    dySeries(c("Empirical 10%-quantile","Mean value","Empirical 90%-quantile")) %>%
    dyRangeSelector()%>% dyLegend() %>% dyOptions(drawPoints = TRUE, pointSize = 2, colors = c("green", "blue", "orange"))
  
  montecarlo.global$current_graph <- ergebnis.ci
  montecarlo.global$current_prediction <- ci.predict.2
  
})

# Ausgabe der Ueberschrift fuer die Vorhersage-Tabelle resultierend aus der Monte-Carlo-Simulation
output$headerPredDepMOnte <- renderUI({
  
  if(is.null(montecarlo.global$current_graph)) return()
  
  if(is.null(objects$usedForecastsInd)  || any(objects$usedForecastsInd[ ,2] == "Outstanding") || any(objects$updateTableIndVariables[ ,2] == "Need update")) {return()} 
  
  return(h4(strong("Predicted values of", objects$lmRegressionModell[[7]], sep = " ")))
  
  
})

# Ausgabe des Dygraphen mit Konfidenzintervallen fuer die durchgefuehrten Simulationen
output$simCI <- renderDygraph({
  
  if(is.null(montecarlo.global$current_graph)) return()
  
  validate({
    need(!(is.null(objects$usedForecastsInd) || any(objects$usedForecastsInd[ ,2] == "Outstanding")), "Not all forecast methods of the corresponding independent variables are completed")
  })
  
  validate({
    need(!any(objects$updateTableIndVariables[ ,2] == "Need update"), "The prediction model was updated - Update forecast methods of the corresponding independent variables in the window above as well before continuing")
  })
  
  montecarlo.global$current_graph
  
})

# Ausgabe der Tabelle mit Mittelwert und Konfidenzintervallgrenzen
output$predForecastDepMonte <- renderDataTable({
  
  pred <- montecarlo.global$pred_timesteps
  
  if(is.null(montecarlo.global$current_graph)) return()
  
  if(is.null(objects$usedForecastsInd)  || any(objects$usedForecastsInd[ ,2] == "Outstanding") || any(objects$updateTableIndVariables[ ,2] == "Need update")) {return()} 
  
  CI_data <- montecarlo.global$current_prediction
  isolate({
    
    if(identical(objects$lmArimaModels, 0) || any(objects$usedForecastsInd[ ,2] == "Outstanding")) {return()} 
    
    if(identical(montecarlo.global$current_prediction, NULL)){return()}
    
    # Fallunterscheidung falls eine der beiden Variablen den Input "NULL" hat
    if(objects$frequencyName == "day" & objects$weekendForecast == "0"){
      pred.dates <- seq(tail(objects$lmDatengrundlage_Default[ ,1], n = 1)[[1]], by = objects$frequencyName, length.out = pred + 1)[2:(pred + 1)]
      # Solange ein Wochenendtag in der Reihe ist, wiederholt er die "while"-Schleife
      while(sum(as.numeric(xor(weekdays(pred.dates)=="Samstag",weekdays(pred.dates)=="Sonntag")))!=0){
        pred.dates.temp <- pred.dates[-which(xor(weekdays(pred.dates)=="Samstag",weekdays(pred.dates)=="Sonntag"))]
        pred.date.temp.we <- seq(tail(pred.dates,n=1), by = objects$frequencyName, length.out=sum(xor(weekdays(pred.dates)=="Samstag",weekdays(pred.dates)=="Sonntag"))+1)[1:sum(xor(weekdays(pred.dates)=="Samstag",weekdays(pred.dates)=="Sonntag"))+1]
        pred.dates <- c(pred.dates.temp,pred.date.temp.we)
      }
    }else{
      pred.dates <- seq(tail(objects$lmDatengrundlage_Default[ ,1], n = 1)[[1]], by = objects$frequencyName, length.out = pred + 1)[2:(pred + 1)]
    }
    
    prediction.result <- cbind(pred.dates, round(as.data.frame(CI_data), digits = 3))
    
    colnames(prediction.result) <- c("Dates", "Mean value", paste((1-input$uncertainty)/2*100,"% quantile") ,paste((1-(1-input$uncertainty)/2)*100,"% quantile"))

    return(prediction.result)
  })
}, options = list(scrollX = TRUE, searching = FALSE, pageLength = 5, lengthChange = FALSE))
