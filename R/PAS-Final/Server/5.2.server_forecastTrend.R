# Erklaeuterungstexte

output$texthelp20<-renderUI({
  "Choose an independent variable to performe trend assumptions"
})
output$texthelp21<-renderUI({
  "Select trend assumption (Increasing, Stagnating, Decreasing) with corresponding 2.5% (Lower Percentage) 
  and 97.5% Quantile (Upper Percentage). Select future time steps the trend assumption is applicable for.  "
})


# In dem reactiveValue "trends" befinden sich die Resultierenden Werte in Abhaenigkeit
# der Trendeingaben und die Trendeingaben selber (Worst, Best, Expected case)
trend.values <- reactiveValues(
  
  trends = 0,
  trends.temp = 0,
  defaultOrTrendPlot = 0,
  
  # Diese Variablen werden benoetigt, um die Ausgaben beim Speichern verschwinden zu lassen
  index = 0,
  index2 = 0,
  name.current = 0
  
)

# Diese Funktion organisiert das Drop-Down im Reiter "Trend Estimation" fuer die Auswahl der zur Trendschaetzung zur Verfuegung 
# stehenden Vaiablen (Die Variablen, welche als Predictoren im Regressionsmodell verwendet wurden)
output$trendForcast <- renderUI({
  
  if(identical(arima.values$tabelle.variablen, 0)){
    selectInput("trendFor", "Choose variable to performe trend assumptions",
                choices = "")
  }else{
    selectInput("trendFor", "Choose variable to performe trend assumptions",
                choices = as.character(arima.values$tabelle.variablen[ ,1])[which(arima.values$tabelle.variablen[ ,2] == "Outstanding")])
  }
  
})

# Dieser EventHandler erstellt das Template (list) fuer alle moeglichen Variablen
# und das immer angepasst auf die gewaehlte abhaengige Variable
# Sobald die unabhaengige Variable geaendert wird, werden alle bisherigen Trendeingaben auf Anfang gesetzt
observe({
  
  validate({
    need(!is.null(input$depVar), "Choose dependent variable")
  })
  validate({
    need(input$depVar != "", "Choose dependent variable")
  })
  
  cor.data <- isolate(daten.under$base[ ,sapply(daten.under$base, is.numeric)])
  cor.data <- dplyr::select(cor.data, - which(attributes(cor.data)$names == input$depVar))
  colnames <- names(cor.data)
  

  ind.var.names <- colnames
  list.erg <- list()
  
  default.frame <- data.frame("Trend" = character(), "Percentage" = numeric(), "Lower Percentage" = numeric(), "Upper Percentage" = numeric(), "Time steps" = numeric())
 
  for(i in 1:length(ind.var.names)){
    list.erg[[i]]<-default.frame
  }
  
  names(list.erg) <- c(ind.var.names)
  trend.values$trends<-list.erg
  trend.values$trends.temp <- list.erg
  
})


# Ploten der Zeitreihe ohne Trend
observeEvent(input$plotts2, {
  
  trend.values$index <- 0
  trend.values$index2 <- 1
  
  name.var  <- input$trendFor
  index.name <- which(names(trend.values$trends.temp) == name.var)
  
  index.datengrundlage <- which(colnames(daten.under$base) == name.var)
  
  # Aufbereiten der Zeitserie fuer die Dygraph-Plots
  ts.historical <- xts(dplyr::select(daten.under$base, index.datengrundlage), daten.under$base[[1]])
  
  colnames(ts.historical) <- c("Historical values")
  
  trend.values$defaultOrTrendPlot <- dygraph(ts.historical, main = name.var) %>% dyRangeSelector() %>% dyLegend(width = 800) %>% dyOptions(drawPoints = TRUE, pointSize = 2)
  
})

# Output Zeitserie mit bzw. ohne Trend
output$plotDefaultTrend <- renderDygraph({
  
  
  if(identical(trend.values$index, 0) & identical(trend.values$index2, 0)) {return()}
  
  trend.values$defaultOrTrendPlot
  
  
})

# Es stehen 3 moegliche Trendentwicklungen zur Verfuegung (Increasing, Stagnating, Decreasing) und in 
# Abhaengigkeit dieser werden die numerischen Inputboxen "Expected Rate", "Lower Percentage" und
# "Upper Percentage" gestaltet.
output$trendEntry <- renderUI({
  
  trend.assumption <- input$trend
  
  if(trend.assumption == "Increasing"){
    
    return(list(div(id="trendExp",numericInput("expected.trend", label = "Rate of increase", value = 0, min = 0)),
                tags$head(tags$style(type="text/css", "#trendExp {display: inline-block}"),
                          tags$head(tags$style(type="text/css", "#xlimitsmax {max-width: 50px}"))),
                
                div(id="trendLow",numericInput("lower.trend", label = "Lower Percentage", value = 0)),
                tags$head(tags$style(type="text/css", "#trendLow {display: inline-block}"),
                          tags$head(tags$style(type="text/css", "#xlimitsmax {max-width: 50px}"))),
                
                div(id="trendUpp",numericInput("upper.trend", label = "Upper Percentage", value = 0, min = 0)),
                tags$head(tags$style(type="text/css", "#trendUpp {display: inline-block}"),
                          tags$head(tags$style(type="text/css", "#xlimitsmax {max-width: 50px}")))))
    
  } else if(trend.assumption == "Stagnating"){
    
    return(list(div(id="trendExp",numericInput("expected.trend", label = "Stagnating", value = 0, min = 0, max = 0)),
                tags$head(tags$style(type="text/css", "#trendExp {display: inline-block}"),
                          tags$head(tags$style(type="text/css", "#xlimitsmax {max-width: 50px}"))),
                
                div(id="trendLow",numericInput("lower.trend", label = "Lower Percentage", value = 0, max = 0)),
                tags$head(tags$style(type="text/css", "#trendLow {display: inline-block}"),
                          tags$head(tags$style(type="text/css", "#xlimitsmax {max-width: 50px}"))),
                
                div(id="trendUpp",numericInput("upper.trend", label = "Upper Percentage", value = 0, min = 0)),
                tags$head(tags$style(type="text/css", "#trendUpp {display: inline-block}"),
                          tags$head(tags$style(type="text/css", "#xlimitsmax {max-width: 50px}")))))
    
  } else if(trend.assumption == "Decreasing"){
    
    return(list(div(id="trendExp",numericInput("expected.trend", label = "Rate of decrease", value = 0, max = 0)),
                tags$head(tags$style(type="text/css", "#trendExp {display: inline-block}"),
                          tags$head(tags$style(type="text/css", "#xlimitsmax {max-width: 50px}"))),
                
                div(id="trendLow",numericInput("lower.trend", label = "Lower Quantile", value = 0, max = 0)),
                tags$head(tags$style(type="text/css", "#trendLow {display: inline-block}"),
                          tags$head(tags$style(type="text/css", "#xlimitsmax {max-width: 50px}"))),
                
                div(id="trendUpp",numericInput("upper.trend", label = "Upper Quantile", value = 0)),
                tags$head(tags$style(type="text/css", "#trendUpp {display: inline-block}"),
                          tags$head(tags$style(type="text/css", "#xlimitsmax {max-width: 50px}")))))
    
  }
})

# Anpassen der Ueberschrift basierend auf der gewaehlten Variable
output$headerTrend <- renderUI({
  
  if(is.null(isolate(input$trendFor))){return()}
  if(is.null(trend.values$trends.temp[[isolate(input$trendFor)]]$conditions)){return()} 
  
  
  if(identical(trend.values$defaultOrTrendPlot, 0)) return()
  
  name.var  <- isolate(input$trendFor)
  return(h3(strong(paste(name.var, "Trend", sep = " "))))
})


# Ausgabe der Tabelle mit den eingegebenen und verarbeiteten Conditions 
trend.condition <- eventReactive(trend.values$trends.temp, {
  
  if(is.null(isolate(input$trendFor))){return()}
  if(is.null(trend.values$trends.temp[[isolate(input$trendFor)]]$conditions)){return()} 
  
  name.var  <- isolate(input$trendFor)
  index.name <- which(names(trend.values$trends.temp) == name.var)
  
  validate(
    need(name.var, "No trend input so far")
  )
  
  validate(
    need(is.null(dim(trend.values$trends.temp[[index.name]])), "No trend input so far")
  )
  
  return(list(trend.values$trends.temp[[index.name]][[1]], h3(em("Resulting values"))))
  
})

# Ausgabe der Tabelle mit den eingegebenen und verarbeiteten Conditions 
output$conditions <- renderDataTable({
  
  trend.condition()[[1]]
  
})

# Ausgabe der Ueberschrift fuer die aus den Eingaben resultierenden Werten
output$headerValues <- renderUI({
  
  trend.condition()[[2]]
  
})

# Ausgabe der auf den Eingaben berechneten Werten fuer die verschiedenen Schranken in Anzahl
# der uebergebenen TimeSteps
trend.values.forecast <- eventReactive(trend.values$trends.temp, {
  
  if(is.null(isolate(input$trendFor))){return()}
  if(is.null(trend.values$trends.temp[[isolate(input$trendFor)]]$conditions)){return()} 
  name.var  <- isolate(input$trendFor)
  index.name <- which(names(trend.values$trends.temp) == name.var)
  
  validate(
    need(name.var, "")
  )
  
  validate(
    need(is.null(dim(trend.values$trends.temp[[index.name]])), "")
  )
  
  return(trend.values$trends.temp[[index.name]][[2]])
  
})

# Ausgabe der Vorhergesagten Werte der gewaehlten Variable auf Basis des Trendinputs
output$werte <- renderDataTable({
  
  trend.values.forecast()
    
})

# Ausgabe der Ueberschrift fuer den Graphen der Daten
output$headerGraph <- renderUI({
  
  if(trend.values$index == 0) return()
  
  name.var  <- isolate(input$trendFor)
  index.name <- which(names(trend.values$trends.temp) == name.var)
  
  validate(
    need(name.var, "")
  )
  
  validate(
    need(is.null(dim(trend.values$trends.temp[[index.name]])), "")
  )
  
  return(h4(em("Submission visualization")))
})

# Ausgabe des Dygraphen mit den erweiterten Daten (siehe Schranken)
observeEvent(input$prevTrend, {
  
  if(identical(input$trendSteps, NA)){return(withProgress(message = "Choose proper time steps", Sys.sleep(0.7)))}
  if(input$trendSteps <1 ){return(withProgress(message = "Choose proper time steps", Sys.sleep(0.7)))}

  name.var <- input$trendFor
  trend.val <- input$trend
  
  exp.trend  <- input$expected.trend
  lower.perc <- input$lower.trend
  upper.perc <- input$upper.trend
  
  if(is.na(lower.perc) | is.na(exp.trend) | is.na(upper.perc)){return(
    withProgress(message = "Values not possible",value=0, {
      Sys.sleep(1)
    })
  )}
  
  if(abs(lower.perc)> abs(exp.trend)){
    withProgress(message = "Values not possible",value=0, {
      Sys.sleep(1)
    })
    return()
  }
  
  
  if(abs(upper.perc) < abs(exp.trend)){
    isolate(trend.values$index <-0)
    withProgress(message = "Values not possible",value=0, {
      Sys.sleep(1)
    })
    return()
  }
  
  trend.values$index <-1
  trend.values$index2 <-1
  
  time.steps <- input$trendSteps
  
  index.name <- which(names(trend.values$trends.temp) == name.var)
  
  conditions <- data.frame("Trend" = trend.val, "Percentage" = exp.trend, "Lower Percentage" = lower.perc,
                           "Upper Percentage" = upper.perc, "Time steps" = time.steps)
  
  index.datengundlage <- which(colnames(daten.under$base) == name.var)
  
  # Vielleicht eine kritische Stelle bei Datensätzen die mit NAs enden.
  last.val <- tail(daten.under$base[[index.datengundlage]], n = 1)
  erg.data <- data.frame()
  
  worst.case <- 0
  best.case  <- 0
  
  # Berechnung der Konfidenzintervall auf Basis des Trendinputs
  if(time.steps > 0){
    
    for(i in 1:time.steps){
      if(i == 1){
        erg.data <- data.frame(last.val * (exp.trend/100 + 1), last.val * (lower.perc/100 + 1), last.val *(upper.perc/100 + 1))
        colnames(erg.data) <- c("Expected Value", "Lower Quantile", "Upper Quantile")
        temp <- last.val
        last.val   <- temp * (exp.trend/100 + 1)
        worst.case <- temp * (lower.perc/100 + 1)
        best.case  <- temp *(upper.perc/100 + 1)
      } else {
        new.data <- c(last.val * (exp.trend/100 + 1), worst.case * (lower.perc/100 + 1), best.case * (upper.perc/100 + 1))
        erg.data <- rbind(erg.data, new.data)
        last.val <- last.val * (exp.trend/100 + 1)
        worst.case <- worst.case * (lower.perc/100 + 1)
        best.case <- best.case * (upper.perc/100 + 1)
      }
    }
  }
  
  pred.dates = seq(tail(daten.under$base[ ,1], n = 1)[[1]], by = start$freq, length.out = isolate(input$trendSteps) + 1)[2:(isolate(input$trendSteps) + 1)]
  erg.data <- cbind(pred.dates, round(erg.data, digits = 3))
  colnames(erg.data)[1] <- "Date"
  trend.values$trends.temp[[index.name]] <- list("conditions" = conditions, "trendValues" = erg.data)
  
  name.var  <- isolate(input$trendFor)
  index.name <- which(names(trend.values$trends.temp) == name.var)
  
  index.datengrundlage <- which(colnames(daten.under$base) == name.var)
  
  # Aufbereitung der historischen Zeitreihe sowie der ueber den Trendinput vorhergesagten Zeitschritte
  ts.historical <- xts(dplyr::select(daten.under$base, index.datengrundlage), daten.under$base[[1]])
  ts.trend <- xts(trend.values$trends.temp[[index.name]]$trendValues[ ,-1], pred.dates)
  
  ts.gesamt <- cbind(ts.historical, ts.trend)
  colnames(ts.gesamt) <- c("Historical values", "Expectation forecast", "Lower bound forecast", "Upper bound forecast")
  
  ts.gesamt[dim(ts.gesamt)[1] - (isolate(input$trendSteps)), (2:4)] <- ts.gesamt[dim(ts.gesamt)[1] - (isolate(input$trendSteps)), 1]

  trend.values$name.current <- isolate(input$trendFor)
  trend.values$defaultOrTrendPlot <- dygraph(ts.gesamt, main = name.var) %>% 
    dySeries(c("Lower bound forecast", "Expectation forecast", "Upper bound forecast")) %>%
    dyRangeSelector() %>% dyLegend(width = 800) %>% dyOptions(drawPoints = TRUE, pointSize = 2)
  

})


# Sollte der eingegebende Trend so uebernommen werden, wird folgende Funktion bei der Betaetigung des "subTrend" Buttons ausgefuehrt.
observeEvent(input$subTrend,{
  
  isolate(if(trend.values$index == 0 || identical(trend.values$name.current, 0)){return(withProgress(message = "Save not possible", Sys.sleep(0.7)))})
  
  isolate(trend.values$index <- 0)
  isolate(trend.values$index2 <- 0)
  
  isolate({
      name <- trend.values$name.current
      
      data.trend <- trend.values$trends.temp
      
      index.name <- which(names(data.trend) == name)
      trend.values$trends[[index.name]] <- trend.values$trends.temp[[index.name]]
      trend.values$trends[[index.name]]$plots <- trend.values$defaultOrTrendPlot
      
      trend.values$trends.temp[[index.name]] <- data.frame("Trend" = character(), "Percentage" = numeric(), "Lower Percentage" = numeric(), 
                                                           "Upper Percentage" = numeric(), "Time steps" = numeric())
  })
})