# Erklaerungstexte

output$texthelp22<-renderUI({
  "Choose independent variable to perform manaual data input "
})

output$texthelp23<-renderUI({
  "Please enter appropriate data sets for the chosen independent variable. Therefore an expected value , 
  a lower Quantile (5%) and an upper Quantile (95%) are requested. If the 'Preview-Forecast-Button' is pressed, the input will be verified
  as valid and the month/quartal counter will be increased automatically.  "
})


# Der reactiveValue "submitted.data" hält die manuell übergebenen Werte für die verschiedenen unabhängigen Variablen
submitted.manual <- reactiveValues(
  submitted.data = 0,
  submitted.temp = 0,
  bindeddata = 0,
  store.graph = list(),
  store.graph.saved = list(),
  current.name = 0,
  defaultOrTrendPlot = 0,
  current.timeseries = 0,
  current.name = 0
)


# Auswahl Drop-Down für die verschiedenen unabhängigen Variablen für die ein manueller Data Input
# durchgeführt werden soll.
output$chooseVariablemanual <- renderUI({
  
  if(identical(arima.values$tabelle.variablen, 0)){
    selectInput("manualindvar", "Choose independent variable to predict",
                choices = "")
  }else{
    selectInput("manualindvar", "Choose independent variable to predict",
                choices = as.character(arima.values$tabelle.variablen[ ,1])[which(arima.values$tabelle.variablen[ ,2] == "Outstanding")])
  }
  
})


# Hier wird die aktuelle manuelle Trendeingabe generiert. Dies geschieht wenn der Button "plottsManual" betaetigt wird.
observe({
  
  input$plottsManual
  if(is.null(input$manualindvar)){return()}
  if(nrow(daten.under$base) == 0){return()}
  if(is.null(input$depVar)){return()}
  if(isolate(input$manualindvar) == "") return ()
  
  isolate({
    reg.data <- daten.under$base[ ,sapply(daten.under$base, is.numeric)]
    index.depVar <- which(attributes(reg.data)$names == isolate(input$depVar))
    reg.data <- reg.data[ ,- index.depVar]
    index.manualVar <- which(attributes(reg.data)$names == isolate(input$manualindvar))
    reg.data <- reg.data[ , index.manualVar]
    
  })
  
  submitted.manual$current.name <- isolate(input$manualindvar)
  submitted.manual$current.timeseries <- xts(reg.data, daten.under$base[[1]])
  
})

# Auf Basis der aktuellen manuellen Eingabe wird der Zeitserien Dygraph generiert.
observeEvent(input$plottsManual, {
  
  time.ind.var <- submitted.manual$current.timeseries
  submitted.manual$defaultOrTrendPlot <- dygraph(time.ind.var, main = submitted.manual$current.name) %>% dyRangeSelector() %>%
    dyLegend(width = 800) %>% dyOptions(drawPoints = TRUE, pointSize = 2)
  
})

# Organisieren der Ausgabe des aktuellen Plots
output$graphmanual<-renderDygraph({
  
  if(!identical(submitted.manual$current.name, input$manualindvar)) return()
  
  if(identical(submitted.manual$defaultOrTrendPlot, 0)) return()
    
  submitted.manual$defaultOrTrendPlot
  
})

# Diese observe Funktion wird ausgefuehrt, wenn sich die unabhaengige Variable im Tab "2.1 Correlation
# and time lag analysis" aendert und macht nichts anderes als die Liste der derzeitigen Eingaben zurueckzusetzen.
observe({
  
  validate({
    need(!is.null(input$depVar), "Waehle unabhaenigige Variable")
  })
  validate({
    need(input$depVar != "", "Choose dependent variable")
  })
  
  cor.data <- isolate(daten.under$base[ ,sapply(daten.under$base, is.numeric)])
  cor.data <- dplyr::select(cor.data, - which(attributes(cor.data)$names == input$depVar))
  colnames <- names(cor.data)
  
  
  ind.var.names <- colnames
  list.erg <- list()
  default.frame <- data.frame("Date" = character(), "Expected Value" = numeric(), "Lower Quantile" = numeric(), "Upper Quantile" = numeric())
  for(i in 1:length(ind.var.names)){
    list.erg[[i]] <- default.frame
  }

  names(list.erg) <- c(ind.var.names)
  isolate(submitted.manual$submitted.data <- list.erg)
  isolate(submitted.manual$submitted.temp <-submitted.manual$submitted.data)
  
})

# Ausgabe des Dates fuer den naechsten manuellen Input
output$displayDate<-renderUI({
  
  if(is.null(submitted.manual$current.name)){return()}
  if(submitted.manual$current.name == 0){return()}
  if(is.null(submitted.manual$current.name)){return()}
  
  if(dim(submitted.manual$submitted.temp[[submitted.manual$current.name]])[1] == 0){
    
    datum<-tail(daten.under$base[,1], n = 1)[[1]]
    datum<-seq(datum, by = start$freq, length.out = 2)[2]

    return(strong(datum))
  }
  
  datum<-submitted.manual$submitted.temp[[submitted.manual$current.name]][dim(submitted.manual$submitted.temp[[submitted.manual$current.name]])[1],1]
  datum<-seq(datum, by = start$freq, length.out = 2)[2]

  return(strong(datum))
  
  
})


# Sobald der Submit-Button betaetigt wird, werden die eingetragenen Werte, sollten sie in der richtigen Groessenanordnung vorliegen,
# in die globale Variable "submitted.data" uebertragen.
observeEvent(input$acceptforecast, {
  
  validate({
    need(identical(submitted.manual$current.name, input$manualindvar), "If independent variable should 
            be changed - press button 'Plot historic timeseries'")
  })
  
  if(is.null(submitted.manual$current.name)){return()}
  if(submitted.manual$current.name == 0){return()}
  if(is.null(submitted.manual$current.name)){return()}
  
  # Auslesen des Datums fuer den naechsten manuellen Input
  if(dim(submitted.manual$submitted.temp[[submitted.manual$current.name]])[1] == 0){
    
    datum<-tail(daten.under$base[,1], n = 1)[[1]]
    datum<-seq(datum, by = start$freq, length.out = 2)[2]

  }else if(dim(submitted.manual$submitted.temp[[submitted.manual$current.name]])[1] > 0){
    
    datum <- submitted.manual$submitted.temp[[submitted.manual$current.name]][dim(submitted.manual$submitted.temp[[submitted.manual$current.name]])[1],1]
    datum<-seq(datum, by = start$freq, length.out = 2)[2]

  }  
  
  mean <- input$expected
  lower <- input$lower
  upper <- input$upper
  
  if(lower>mean){
    withProgress(message = "Values not possible",value=0.1, {
      setProgress(1) 
      Sys.sleep(1.5)
    })
    return()
  }
  
  if(upper<mean){
    withProgress(message = "Values not possible",value=0.1, {
      setProgress(1) 
      Sys.sleep(1.5)
    })
    return()
  }
  
  data.temp <- data.frame(datum, mean, lower, upper)
  colnames(data.temp) <- colnames(submitted.manual$submitted.temp[[1]])
  submitted.manual$submitted.temp[[submitted.manual$current.name]] <- rbind(submitted.manual$submitted.temp[[submitted.manual$current.name]], data.temp)
  
  ts.data <- submitted.manual$current.timeseries
  
  # Aufbereitung der Zeitserien zur Darstellung in einm Dygraphen
  forecastmanual <- xts(submitted.manual$submitted.temp[[submitted.manual$current.name]][,-1], submitted.manual$submitted.temp[[submitted.manual$current.name]][[1]])
  bindeddata <- cbind(ts.data,forecastmanual)
  bindeddata[nrow(ts.data),2:4]<-bindeddata[nrow(ts.data),1]
  
  submitted.manual$defaultOrTrendPlot <- dygraph(bindeddata, main = submitted.manual$current.name) %>% dyRangeSelector() %>%
    dyLegend(width = 800) %>% dyOptions(drawPoints = TRUE, pointSize = 2)%>% 
    dySeries(c("Lower.Quantile", "Expected.Value", "Upper.Quantile"))
  
})

# Speichern der aktuellen manuellen Forecasteingabe
observeEvent(input$saveforecast, {
  
  
  if(dim(submitted.manual$submitted.temp[[submitted.manual$current.name]])[1] == 0){
    return(withProgress(message = "Save not possible", Sys.sleep(1.5)))
  }
  
  submitted.manual$submitted.data[[submitted.manual$current.name]] <- submitted.manual$submitted.temp[[submitted.manual$current.name]]
  
  withProgress(message = "Manual data input saved", Sys.sleep(1.5))
  
  submitted.manual$store.graph.saved[[submitted.manual$current.name]] <- submitted.manual$defaultOrTrendPlot 
  submitted.manual$submitted.temp[[submitted.manual$current.name]] <- data.frame("Date" = character(), "Expected Value" = numeric(), "Lower Quantile" = numeric(), "Upper Quantile" = numeric())
  
  submitted.manual$defaultOrTrendPlot <- 0
})


# Loeschen der letzten manuellen Eingabe der aktuell ausgewaehlten unabhaengigen Variable
observeEvent(input$deleteforecast, {
  
  validate({
    need(identical(submitted.manual$current.name, input$manualindvar), "If independent variable should 
         be changed - press button 'Plot historic timeseries'")
  })
  
  ts.data <- submitted.manual$current.timeseries
  
  submitted.manual$submitted.temp[[submitted.manual$current.name]] <- submitted.manual$submitted.temp[[submitted.manual$current.name]][-dim(submitted.manual$submitted.temp[[submitted.manual$current.name]])[1],]

  if(dim(submitted.manual$submitted.temp[[submitted.manual$current.name]])[1] == 0){
    
    return(submitted.manual$defaultOrTrendPlot <- dygraph(ts.data, main = submitted.manual$current.name) %>% dyRangeSelector() %>%
             dyLegend(width = 800) %>% dyOptions(drawPoints = TRUE, pointSize = 2))
    
  }
  
  forecastmanual<-xts(submitted.manual$submitted.temp[[submitted.manual$current.name]][,-1], submitted.manual$submitted.temp[[submitted.manual$current.name]][[1]])
  
  bindeddata<-cbind(ts.data,forecastmanual)
  bindeddata[nrow(ts.data),2:4]<-bindeddata[nrow(ts.data),1]
  submitted.manual$defaultOrTrendPlot <- dygraph(bindeddata, main = submitted.manual$current.name) %>% dyRangeSelector() %>%
    dyLegend(width = 800) %>% dyOptions(drawPoints = TRUE, pointSize = 2)%>% 
    dySeries(c("Lower.Quantile", "Expected.Value", "Upper.Quantile"))
  
})

# Ausgabe der bisher getaetigen Eingaben der gewaehlten unabhae?ngigen Variable
data.manual <- eventReactive(submitted.manual$submitted.temp, {
  
  if(is.null(submitted.manual$current.name)){return()}
  if(submitted.manual$current.name == 0){return()}
  if(is.null(submitted.manual$current.name)){return()}
  
  name.manual <- submitted.manual$current.name
  
  data.manual <- submitted.manual$submitted.temp
  
  index.ind.var <- which(names(data.manual) == name.manual)
  
  if(dim(data.manual[[index.ind.var]])[1] == 0){
    return()
  }
  
  return(list(data.manual[[index.ind.var]], h4(name.manual)))
})

# Ausgabe des Variablennames der gewaehlten unabhaengigen Variable
output$manual.header <- renderUI({
  
  if(!identical(submitted.manual$current.name, input$manualindvar)) return()
  
  if(identical(data.manual(), NULL)) return()
  
  data.manual()[[2]]
  
})

# Ausgabe der fuer die ausgewaehlte unabhaengige Variable bisher eingegebenen Daten
output$manual.data <- renderDataTable({
  
  validate({
    need(!identical(submitted.manual$current.name, 0), "Press button 'Choose variable'")
  })
  
  validate({
    need(identical(submitted.manual$current.name, input$manualindvar), paste("If independent variable should 
         be changed - press button 'Choose varible', Current variable is", submitted.manual$current.name, sep = ":"))
  })
  
  if(identical(data.manual(), NULL)) return()
  
  data.manual()[[1]]
  
})

