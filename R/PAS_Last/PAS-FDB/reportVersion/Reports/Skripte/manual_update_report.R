manual.global <- reactiveValues(
  
  trends.temp = NULL,
  defaultOrTrendPlot = NULL,
  current.timeseries = NULL,
  submitted.temp = NULL,
  
  # Diese Variablen werden benoetigt, um die Ausgaben beim Speichern verschwinden zu lassen
  index = 0,
  index2 = 0,
  name.current = 0
  
)

# Diese Funktion organisiert die globale temporaere Speichervariablen (submitted.manual$submitted.temp)
observeEvent(objects$lmRegressionModell, {
  
  ind.var.names <- names(objects$lmManualInput)

  list.erg <- list()
  default.frame <- data.frame("Date" = character(), "Expected Value" = numeric(), "Lower Quantile" = numeric(), "Upper Quantile" = numeric())
  for(i in 1:length(ind.var.names)){
    list.erg[[i]] <- default.frame
  }
  
  names(list.erg) <- c(ind.var.names)
  manual.global$submitted.temp <- list.erg
  
})


# Auf Basis der aktuellen manuellen Eingabe wird der Zeitserien Dygraph generiert.
observeEvent(input$plotHistManual, {
  
  if(is.null(objects$lmDatengrundlage_Default )){return()}
  
  manual.global$index <- 0
  manual.global$index2 <- 1
  
  reg.data <- objects$lmDatengrundlage_Default[ ,input$updateInd]
  
  manual.global$current.name <- input$updateInd
  manual.global$current.timeseries <- xts(reg.data, objects$lmDatengrundlage_Default[[1]])
  
  manual.global$defaultOrTrendPlot <- dygraph(manual.global$current.timeseries, main = manual.global$name.current) %>% dyRangeSelector() %>%
    dyLegend(width = 800) %>% dyOptions(drawPoints = TRUE, pointSize = 2)
  
})

# Organisieren der Ausgabe des aktuellen Plots
output$graphManual <- renderDygraph({
  
  if(identical(manual.global$index, 0) && identical(manual.global$index2, 0)) {return()}
  
  manual.global$defaultOrTrendPlot
  
})

# Ausgabe des Dates fuer den naechsten manuellen Input
output$displayDateManual <- renderUI({
  
  if(is.null(input$updateInd)){return()}
  
  if(dim(manual.global$submitted.temp[[input$updateInd]])[1] == 0){
    
    datum <- tail(objects$lmDatengrundlage_Default[,1], n = 1)[[1]]
    # Fallunterscheidung falls eine der beiden Variablen den Input "NULL" hat
    if(objects$frequencyName == "day" & objects$weekendForecast == "0"){
      datum<-seq(datum, by = objects$frequencyName, length.out = 2)[2]
      # Solange der vorherzusagende Tag ein Wochenendtag ist, wird die While-Schleife durchlaufen
      while(sum(as.numeric(xor(weekdays(datum)=="Samstag",weekdays(datum)=="Sonntag")))!=0){
        datum<-seq(datum, by = objects$frequencyName, length.out = 2)[2]
      }
    }else{
      datum<-seq(datum, by = objects$frequencyName, length.out = 2)[2]
    }
    
    return(strong(datum))
  }
  
  datum <- manual.global$submitted.temp[[input$updateInd]][dim(manual.global$submitted.temp[[input$updateInd]])[1],1]
  # Fallunterscheidung falls eine der beiden Variablen den Input "NULL" hat
  if(objects$frequencyName == "day" & objects$weekendForecast == "0"){
    datum<-seq(datum, by = objects$frequencyName, length.out = 2)[2]
    # Solange der vorherzusagende Tag ein Wochenendtag ist, wird die While-Schleife durchlaufen
    while(sum(as.numeric(xor(weekdays(datum)=="Samstag",weekdays(datum)=="Sonntag")))!=0){
      datum<-seq(datum, by = objects$frequencyName, length.out = 2)[2]
    }
  }else{
    datum<-seq(datum, by = objects$frequencyName, length.out = 2)[2]
  } 
  
  return(strong(datum))
  
})

# Sobald der Submit-Button betaetigt wird, werden die eingetragenen Werte, sollten sie in der richtigen Groessenanordnung vorliegen,
# in die globale Variable "submitted.data" uebertragen.
observeEvent(input$acceptforecast, {
  
  validate({
    need(identical(manual.global$current.name, input$updateInd), "If independent variable should 
         be changed - press button 'Plot historical data'")
  })
  
  manual.global$index <- 1
  manual.global$index2 <- 1
  
  # Auslesen des Datums fuer den naechsten manuellen Input
  if(dim(manual.global$submitted.temp[[manual.global$current.name]])[1] == 0){
    
    datum <- tail(objects$lmDatengrundlage_Default[,1], n = 1)[[1]]
    # Fallunterscheidung falls eine der beiden Variablen den Input "NULL" hat
    if(objects$frequencyName == "day" & objects$weekendForecast == "0"){
      datum<-seq(datum, by = objects$frequencyName, length.out = 2)[2]
      # Solange der vorherzusagende Tag ein Wochenendtag ist, wird die While-Schleife durchlaufen
      while(sum(as.numeric(xor(weekdays(datum)=="Samstag",weekdays(datum)=="Sonntag")))!=0){
        datum<-seq(datum, by = objects$frequencyName, length.out = 2)[2]
      }
    }else{
      datum<-seq(datum, by = objects$frequencyName, length.out = 2)[2]
    }     
  }else if(dim(manual.global$submitted.temp[[manual.global$current.name]])[1] > 0){
 
    datum <- manual.global$submitted.temp[[manual.global$current.name]][dim(manual.global$submitted.temp[[manual.global$current.name]])[1],1]
    # Fallunterscheidung falls eine der beiden Variablen den Input "NULL" hat
    if(objects$frequencyName == "day" & objects$weekendForecast == "0"){
      datum<-seq(datum, by = objects$frequencyName, length.out = 2)[2]
      # Solange der vorherzusagende Tag ein Wochenendtag ist, wird die While-Schleife durchlaufen
      while(sum(as.numeric(xor(weekdays(datum)=="Samstag",weekdays(datum)=="Sonntag")))!=0){
        datum<-seq(datum, by = objects$frequencyName, length.out = 2)[2]
      }
    }else{
      datum<-seq(datum, by = objects$frequencyName, length.out = 2)[2]
    }     
  }  
  
  mean  <- input$expected
  lower <- input$lower
  upper <- input$upper
  
  if(lower > mean){
    withProgress(message = "Values not possible",value=0.1, {
      setProgress(1) 
      Sys.sleep(1.5)
    })
    return()
  }
  
  if(upper < mean){
    withProgress(message = "Values not possible",value=0.1, {
      setProgress(1) 
      Sys.sleep(1.5)
    })
    return()
  }

  data.temp <- data.frame(datum, mean, lower, upper)
  
  colnames(data.temp) <- colnames(manual.global$submitted.temp[[1]])
  manual.global$submitted.temp[[manual.global$current.name]] <- rbind(manual.global$submitted.temp[[manual.global$current.name]], data.temp)
  
  ts.data <- manual.global$current.timeseries

  # Aufbereitung der Zeitserien zur Darstellung in einm Dygraphen
  forecastmanual <- xts(manual.global$submitted.temp[[manual.global$current.name]][,-1], manual.global$submitted.temp[[manual.global$current.name]][[1]])
  bindeddata <- cbind(ts.data,forecastmanual)
  bindeddata[nrow(ts.data),2:4]<-bindeddata[nrow(ts.data),1]

  manual.global$defaultOrTrendPlot <- dygraph(bindeddata, main = manual.global$current.name) %>% dyRangeSelector() %>%
    dyLegend(width = 800) %>% dyOptions(drawPoints = TRUE, pointSize = 2)%>% 
    dySeries(c("Lower.Quantile", "Expected.Value", "Upper.Quantile"))
  
})

# Loeschen der letzten manuellen Eingabe der aktuell ausgewaehlten unabhaengigen Variable
observeEvent(input$deleteforecast, {
  
  validate({
    need(identical(manual.global$current.name, input$updateInd), "If independent variable should 
         be changed - press button 'Plot historic timeseries'")
  })
  
  ts.data <- manual.global$current.timeseries
  
  manual.global$submitted.temp[[manual.global$current.name]] <- manual.global$submitted.temp[[manual.global$current.name]][-dim(manual.global$submitted.temp[[manual.global$current.name]])[1],]
  
  if(dim(manual.global$submitted.temp[[manual.global$current.name]])[1] == 0){
    
    return(manual.global$defaultOrTrendPlot <- dygraph(ts.data, main = manual.global$current.name) %>% dyRangeSelector() %>%
             dyLegend(width = 800) %>% dyOptions(drawPoints = TRUE, pointSize = 2))
    
  }
  
  forecastmanual<-xts(manual.global$submitted.temp[[manual.global$current.name]][,-1], manual.global$submitted.temp[[manual.global$current.name]][[1]])
  
  bindeddata<-cbind(ts.data,forecastmanual)
  bindeddata[nrow(ts.data),2:4]<-bindeddata[nrow(ts.data),1]
  manual.global$defaultOrTrendPlot <- dygraph(bindeddata, main = manual.global$current.name) %>% dyRangeSelector() %>%
    dyLegend(width = 800) %>% dyOptions(drawPoints = TRUE, pointSize = 2)%>% 
    dySeries(c("Lower.Quantile", "Expected.Value", "Upper.Quantile"))
  
})

# Speichern der aktuellen manuellen Forecasteingabe
observeEvent(input$saveforecast, {
  
  if(dim(manual.global$submitted.temp[[manual.global$current.name]])[1] == 0){
    return(withProgress(message = "Save not possible", Sys.sleep(1.5)))
  }
  
  manual.global$index <- 0
  manual.global$index2 <- 0
  
  objects$lmManualInput[[manual.global$current.name]] <- manual.global$submitted.temp[[manual.global$current.name]]
  
  withProgress(message = "Manual data input saved", Sys.sleep(1.5))
  
  #submitted.manual$store.graph.saved[[submitted.manual$current.name]] <- submitted.manual$defaultOrTrendPlot 
  manual.global$submitted.temp[[manual.global$current.name]] <- data.frame("Date" = character(), "Expected Value" = numeric(), "Lower Quantile" = numeric(), "Upper Quantile" = numeric())
  
  manual.global$defaultOrTrendPlot <- 0
  
  objects$updateTableIndVariables[which(objects$updateTableIndVariables[,1] == manual.global$current.name), 2] <- "Up to date"
  
})

# Ausgabe der bisher getaetigen Eingaben der gewaehlten unabhae?ngigen Variable
data.manual <- eventReactive(manual.global$submitted.temp, {
  

  index.ind.var <- which(names(manual.global$submitted.temp) == manual.global$current.name)
  
  if(dim(manual.global$submitted.temp[[index.ind.var]])[1] == 0){
    return()
  }
  
  return(list(manual.global$submitted.temp[[index.ind.var]], h4(manual.global$current.name)))
})

# Ausgabe des Variablennames der gewaehlten unabhaengigen Variable
output$manual.header <- renderUI({
  
  if(!identical(manual.global$current.name, input$updateInd)) return()
  
  if(identical(data.manual(), NULL)) return()
  
  data.manual()[[2]]
  
})

# Ausgabe der fuer die ausgewaehlte unabhaengige Variable bisher eingegebenen Daten
output$manual.data <- renderDataTable({
  
  validate({
    need(!identical(manual.global$current.name, 0), "Press button 'Choose variable'")
  })
  
  validate({
    need(identical(manual.global$current.name, input$updateInd), paste("Press Button Plot historical or choose", manual.global$current.name, sep = " "))
  })
  
  if(identical(data.manual(), NULL)) return()
  
  data.manual()[[1]]
  
}, options = list(scrollX = TRUE, searching = FALSE, pageLength = 4, lengthChange = FALSE))
