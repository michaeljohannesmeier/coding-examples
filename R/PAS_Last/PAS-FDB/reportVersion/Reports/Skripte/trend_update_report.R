##################################################
# Ab hier Trend Procedures
trend.global <- reactiveValues(
  
  trends.temp = NULL,
  defaultOrTrendPlot = NULL,
  
  # Diese Variablen werden benoetigt, um die Ausgaben beim Speichern verschwinden zu lassen
  index = 0,
  index2 = 0,
  name.current = 0
  
)

# Aufbereiten der temporären Speicherstruktur (trend.global$trends.temp)
observeEvent(objects$lmRegressionModell, {
  
  ind.var.names <- names(objects$lmTrendInput)

  list.erg <- list()
  
  default.frame <- data.frame("Trend" = character(), "Percentage" = numeric(), "Lower Percentage" = numeric(), "Upper Percentage" = numeric(), "Time steps" = numeric())
  
  for(i in 1:length(ind.var.names)){
    list.erg[[i]] <- default.frame
  }
  
  names(list.erg) <- c(ind.var.names)
  trend.global$trends.temp <- list.erg

})

# Aufbereitung des Plots der Zeitreihe ohne Trend
observeEvent(input$plotHistTrend, {
  
  trend.global$index <- 0
  trend.global$index2 <- 1
  
  name.var  <- input$updateInd
  
  index.datengrundlage <- which(colnames(objects$lmDatengrundlage_Default) == name.var)
  
  # Aufbereiten der Zeitserie fuer die Dygraph-Plots
  ts.historical <- xts(dplyr::select(objects$lmDatengrundlage_Default, index.datengrundlage), objects$lmDatengrundlage_Default[[1]])
  
  colnames(ts.historical) <- c("Historical values")
  
  trend.global$defaultOrTrendPlot <- dygraph(ts.historical, main = name.var) %>% dyRangeSelector() %>% dyLegend(width = 800) %>% dyOptions(drawPoints = TRUE, pointSize = 2)
  
})

# Output Zeitserie mit bzw. ohne Trend
output$plotDefaultTrend <- renderDygraph({
  
  if(identical(trend.global$index, 0) && identical(trend.global$index2, 0)) {return()}
  
  trend.global$defaultOrTrendPlot
  
})

# Ausgabe der Tabelle mit den eingegebenen und verarbeiteten Conditions 
trend.condition <- eventReactive(trend.global$trends.temp, {
  
  if(is.null(isolate(input$updateInd))){return()}
  
  if(is.null(trend.global$trends.temp[[input$updateInd]]$conditions)){return()} 
  
  name.var  <- input$updateInd
  index.name <- which(names(trend.global$trends.temp) == name.var)
  
  validate(
    need(name.var, "No trend input so far")
  )
  
  validate(
    need(is.null(dim(trend.global$trends.temp[[index.name]])), "No trend input so far")
  )
  
  return(list(trend.global$trends.temp[[index.name]][[1]], h3(em("Resulting values"))))
  
})



# Ausgabe der auf den Eingaben berechneten Werten fuer die verschiedenen Schranken in Anzahl
# der uebergebenen TimeSteps
trend.values.forecast <- eventReactive(trend.global$trends.temp, {
  
  if(is.null(input$updateInd)){return()}
  
  if(is.null(trend.global$trends.temp[[input$updateInd]]$conditions)){return()} 
  
  name.var   <- input$updateInd
  index.name <- which(names(trend.global$trends.temp) == name.var)
  
  validate(
    need(name.var, "")
  )
  
  validate(
    need(is.null(dim(trend.global$trends.temp[[index.name]])), "")
  )
  
  return(trend.global$trends.temp[[index.name]][[2]])
  
})

# Ausgabe der Vorhergesagten Werte der gewaehlten Variable auf Basis des Trendinputs
output$forecasteValuesTrend <- renderDataTable({
  
  trend.values.forecast()
  
}, options = list(scrollX = TRUE, searching = FALSE, pageLength = 4, lengthChange = FALSE))

# Ausgabe des Dygraphen mit den erweiterten Daten (siehe Schranken)
observeEvent(input$prevTrend, {
  
  if(identical(input$trendSteps, NA)){return(withProgress(message = "Choose proper time steps", Sys.sleep(0.7)))}
  if(input$trendSteps < 1 ){return(withProgress(message = "Choose proper time steps", Sys.sleep(0.7)))}
  
  name.var <- input$updateInd
  trend.val <- input$trend
  
  exp.trend  <- input$expected.trend
  lower.perc <- input$lower.trend
  upper.perc <- input$upper.trend
  
  if(is.na(lower.perc) | is.na(exp.trend) | is.na(upper.perc)){return(
    withProgress(message = "Values not possible",value=0, {
      Sys.sleep(1)
    })
  )}
  
  if(lower.perc> exp.trend){
    withProgress(message = "Values not possible",value=0, {
      Sys.sleep(1)
    })
    return()
  }
  
  
  if(upper.perc < exp.trend){
    isolate(trend.global$index <-0)
    withProgress(message = "Values not possible",value=0, {
      Sys.sleep(1)
    })
    return()
  }
  
  trend.global$index  <- 1 
  trend.global$index2 <- 1
  
  time.steps <- input$trendSteps
  
  index.name <- which(names(trend.global$trends.temp) == name.var)
  
  conditions <- data.frame("Trend" = trend.val, "Percentage" = exp.trend, "Lower Percentage" = lower.perc,
                           "Upper Percentage" = upper.perc, "Time steps" = time.steps)
  
  index.datengundlage <- which(colnames(objects$lmDatengrundlage_Default) == name.var)
  
  # Vielleicht eine kritische Stelle bei Datens?tzen die mit NAs enden.
  last.val <- tail(objects$lmDatengrundlage_Default[[index.datengundlage]], n = 1)
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
  
  if(objects$frequencyName == "day" & objects$weekendForecast == "0"){
    pred.dates <- seq(tail(objects$lmDatengrundlage[ ,1], n = 1)[[1]], by = objects$frequencyName, length.out = isolate(input$trendSteps) + 1)[2:(isolate(input$trendSteps) + 1)]
    # Solange ein Wochenendtag in der Reihe ist, wiederholt er die "while"-Schleife
    while(sum(as.numeric(xor(weekdays(pred.dates)=="Samstag",weekdays(pred.dates)=="Sonntag")))!=0){
      pred.dates.temp <- pred.dates[-which(xor(weekdays(pred.dates)=="Samstag",weekdays(pred.dates)=="Sonntag"))]
      pred.date.temp.we <- seq(tail(pred.dates,n=1), by = objects$frequencyName, length.out=sum(xor(weekdays(pred.dates)=="Samstag",weekdays(pred.dates)=="Sonntag"))+1)[1:sum(xor(weekdays(pred.dates)=="Samstag",weekdays(pred.dates)=="Sonntag"))+1]
      pred.dates <- c(pred.dates.temp,pred.date.temp.we)
    }
  }else{
    pred.dates <- seq(tail(objects$lmDatengrundlage[ ,1], n = 1)[[1]], by = objects$frequencyName, length.out = isolate(input$trendSteps) + 1)[2:(isolate(input$trendSteps) + 1)]
  }
  
  erg.data <- cbind(pred.dates, round(erg.data, digits = 3))
  
  colnames(erg.data)[1] <- "Date"
  trend.global$trends.temp[[index.name]] <- list("conditions" = conditions, "trendValues" = erg.data)
  
  
  name.var  <- input$updateInd
  index.name <- which(names(trend.global$trends.temp) == name.var)
  
  index.datengrundlage <- which(colnames(objects$lmDatengrundlage_Default) == name.var)
  
  # Aufbereitung der historischen Zeitreihe sowie der ueber den Trendinput vorhergesagten Zeitschritte
  ts.historical <- xts(dplyr::select(objects$lmDatengrundlage_Default, index.datengrundlage), objects$lmDatengrundlage_Default[[1]])
  ts.trend <- xts(trend.global$trends.temp[[index.name]]$trendValues[ ,-1], pred.dates)
  
  ts.gesamt <- cbind(ts.historical, ts.trend)
  colnames(ts.gesamt) <- c("Historical values", "Expectation forecast", "Lower bound forecast", "Upper bound forecast")

  ts.gesamt[dim(ts.gesamt)[1] - (isolate(input$trendSteps)), (2:4)] <- ts.gesamt[dim(ts.gesamt)[1] - (isolate(input$trendSteps)), 1]
  
  trend.global$name.current <- input$updateInd
  trend.global$defaultOrTrendPlot <- dygraph(ts.gesamt, main = name.var) %>% 
    dySeries(c("Lower bound forecast", "Expectation forecast", "Upper bound forecast")) %>%
    dyRangeSelector() %>% dyLegend(width = 800) %>% dyOptions(drawPoints = TRUE, pointSize = 2)

})

# Sollte der eingegebende Trend so uebernommen werden, wird folgende Funktion bei der Betaetigung des "subTrend" Buttons ausgefuehrt.
observeEvent(input$subTrend,{
  
  if(trend.global$index == 0 || identical(trend.global$name.current, 0)){
    withProgress(message = "Save not possible", Sys.sleep(0.7))
    return()
  }
  
  trend.global$index <- 0
  trend.global$index2 <- 0
  
  index.name <- which(names(trend.global$trends.temp) == trend.global$name.current)
  objects$lmTrendInput[[index.name]] <- trend.global$trends.temp[[index.name]]
  objects$lmTrendInput[[index.name]]$plots <- trend.global$defaultOrTrendPlot
  
  trend.global$trends.temp[[index.name]] <- data.frame("Trend" = character(), "Percentage" = numeric(), "Lower Percentage" = numeric(), 
                                                       "Upper Percentage" = numeric(), "Time steps" = numeric())
  
  # Sollte ein Regressions-Update vorgenommen worden sein, wird in der Status-Tabelle, der Status für die entsprechende Variable auf "Up to date" gesetzt
  objects$updateTableIndVariables[which(objects$updateTableIndVariables[,1] == trend.global$name.current), 2] <- "Up to date"
})
