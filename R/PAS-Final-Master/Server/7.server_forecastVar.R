#######################################################################
#######################################################################

VAR<-reactiveValues (
  model = 0,
  modelres = 0,
  fcst = 0,
  fcstres = 0,
  zeit = 0,
  namesVar_data = 0,
  namesResVar_data = 0,
  old = 0
)


dygraph<-reactiveValues(
  indexforecast = FALSE,
  indexforecastres = FALSE
)


## 7.1 Preprocessing ##

## Data preprocessing (Remove NAs, Create ts-Object,...) ##
# Datengrundlage fuer die aktuell ausgewaehlten Variablen im Tab "Data preprocessing"
var_data <- eventReactive(input$PREP, {
  
  
  # Setze Forecast daten Null, um Prediction-Table zu reseten (Var und ResVar)
  VAR$fcst <- 0
  VAR$fcstres <- 0
  
  if(length(input$columns2) <= 1) return()
  
  var_data <- daten.under$base

  var_data = var_data[ ,c("Date", input$depVar, input$columns2)]
  var_data = na.omit(var_data)
  
  VAR$zeit<-var_data[[1]]
  
  var_data <-xts(var_data[,-1], VAR$zeit)
  
  return(var_data)

})

# Berechnung des VAR-Modells bei Betaetigung des Buttons "Estimate VAR-Model"
observeEvent(input$EST,{
  
  if(is.null(var_data())) return()
  
  if(is.null(input$LAGS) || input$LAGS == 0) return()
  
  VAR$model <- VAR(var_data(), p = input$LAGS, type = "const")
  
  VAR$namesVar_data <- colnames(var_data())
  
  dygraph$indexforecast = FALSE
})

# Berechnung des VAR-Modells bei Betaetigung des Buttons "Forecast VAR-Model"
observeEvent(input$FCST,{
  
  if(is.null(var_data())) return()
  
  if(is.null(input$LAGS) || input$LAGS == 0) return()
  
  VAR$model <- VAR(var_data(), p = input$LAGS, type = "const")
  
  VAR$namesVar_data <- colnames(var_data())
  
  dygraph$indexforecast = TRUE
})



output$var_data <- renderDataTable({
  
  if (is.null(var_data())) { return() }
  
  var_data <- daten.under$base
  
  var_data = var_data[ ,c("Date", input$depVar, input$columns2)]
  var_data = na.omit(var_data)
  var_data
  
},options = list(lengthMenu = c(6, 12, 24, 36), pageLength = 6))




observeEvent(input$saveEST, {
  
  withProgress(message = "Explanation model saved", Sys.sleep(1.5))
  
  var_data <- daten.under$base
  
  var_data = var_data[ ,c("Date", input$depVar, input$columns2)]
  var_data = na.omit(var_data)
  var_data
  
  var.modelle$gespeicherte.expl.modelle.var[[1]] <- var_data
  var.modelle$gespeicherte.expl.modelle.var[[2]] <- varDygraph() 
  
  
  coef = summary(VAR$model)
  coef = coef[[2]]
  coef = coef[[isolate(input$depVar)]]
  coef = coef[[4]]
  
  var.modelle$gespeicherte.expl.modelle.var[[3]] <- coef 
  
  R.sq = summary(VAR$model)
  R.sq = R.sq[[2]]
  R.sq = R.sq[[input$depVar]]
  R.sq = R.sq[[8]]
  
  adj.R.sq = summary(VAR$model)
  adj.R.sq = adj.R.sq[[2]]
  adj.R.sq = adj.R.sq[[input$depVar]]
  adj.R.sq = adj.R.sq[[9]]
  
  qual = cbind(R.sq,adj.R.sq)
  
  
  var.modelle$gespeicherte.expl.modelle.var[[4]] <- qual 
  
  var.modelle$gespeicherte.expl.modelle.var[[5]] <- input$LAGS
  
  index2$VARcompletecases <- nrow( var.modelle$gespeicherte.expl.modelle.var[[1]])
  index2$VARregressors <- nrow( var.modelle$gespeicherte.expl.modelle.var[[3]]) -1
  index2$VARleglength <- var.modelle$gespeicherte.expl.modelle.var[[5]]
  index2$VARnumberindepvar <- ncol( var.modelle$gespeicherte.expl.modelle.var[[1]])-1
  
})

observeEvent(input$saveresEST, {

  withProgress(message = "Explanation model saved", Sys.sleep(1.5))
  
  
  var_data <- daten.under$base
  
  var_data = var_data[ ,c("Date", input$depVar, input$columns2)]
  var_data = na.omit(var_data)
  var_data
  
  var.modelle$gespeicherte.expl.modelle.restvar[[1]] <- var_data
  
  var.modelle$gespeicherte.expl.modelle.restvar[[2]] <- restVARDygraph()
  
  res.coef = summary(VAR$modelres)
  res.coef = res.coef[[2]]
  res.coef = res.coef[[input$depVar]]
  res.coef = res.coef[[4]]
  
  var.modelle$gespeicherte.expl.modelle.restvar[[3]] <- res.coef
  
  
  R.sq = summary(VAR$modelres)
  R.sq = R.sq[[2]]
  R.sq = R.sq[[input$depVar]]
  R.sq = R.sq[[8]]
  
  adj.R.sq = summary(VAR$modelres)
  adj.R.sq = adj.R.sq[[2]]
  adj.R.sq = adj.R.sq[[input$depVar]]
  adj.R.sq = adj.R.sq[[9]]
  
  qual = cbind(R.sq,adj.R.sq)
  
  var.modelle$gespeicherte.expl.modelle.restvar[[4]] <- qual
  var.modelle$gespeicherte.expl.modelle.restvar[[5]] <- input$resLAGS
  
  index2$restVARcompletecases <- nrow( var.modelle$gespeicherte.expl.modelle.restvar[[1]])
  index2$restVARregressors <- nrow( var.modelle$gespeicherte.expl.modelle.restvar[[3]]) -1
  index2$restVARleglength <- var.modelle$gespeicherte.expl.modelle.restvar[[5]]
  index2$restVARnumberindepvar <- ncol( var.modelle$gespeicherte.expl.modelle.restvar[[1]])-1
  

})


## Lag-length selection ##

# Berechnung der VAR-Modelle fuer bis zu 6 Timelags
AIC_BIC_HQ <- eventReactive(input$PREP, {
  
  if (is.null(var_data())) { return() }
  
  VARselect <- VARselect(var_data(), lag.max = 6, type = "const")
})

# Ausgabe der Guetekriterien der Modelle
output$lag.length <- renderDataTable({
  
  validate({
    need(!is.null(var_data()), "Choose at leats two variables to compute VAR-models.")
  })
  
  validate({
    need(ncol(var_data()) > 1, "Choose at leats two variables to compute VAR-models.")
  })
  
  if (is.null(AIC_BIC_HQ())) { return() }
  
  IC = AIC_BIC_HQ()
  IC = data.frame(IC$criteria)
  IC = IC[-c(1,2,4), ]
  
  colnames(IC) = seq(1, 6, by=1)
  rownames(IC) = c("BIC")
  
  IC<-round(IC, digits = 2)
  
}, options = list(pagination = FALSE,searching = FALSE,paging = FALSE))


observe({
  
  BIC.values = as.numeric(AIC_BIC_HQ()$criteria[3,])
  min.BIC = which.min(BIC.values)
  
  num.input = if (is.null(AIC_BIC_HQ())) {1} else {min.BIC}
  
  updateNumericInput(
    session,
    "LAGS",
    value = num.input
  )
  
})

#######################################################################
#######################################################################

## 7.2 Forecasting via VAR-Model ##

# Ausgabe der GUI fuer den Tab "Forecasting via VAR model"
output$text.est <- renderText({ 
  
  if (!is.list(VAR$model)) { return() }
  
  if(!identical(isolate(VAR$namesVar_data), 0) && !identical(colnames(var_data()), isolate(VAR$namesVar_data))) return()
  
  paste("Estimation results for", isolate(input$depVar))
  
})


output$text.est.qual <- renderText({ 
  
  if (!is.list(VAR$model)) { return() }
  
  if(!identical(isolate(VAR$namesVar_data), 0) && !identical(colnames(var_data()), isolate(VAR$namesVar_data))) return()
  
  paste("Coefficients of determination", isolate(input$depVar))
  
})

# Ausgabe der Koeffiziententabelle des aktuell berechneten VAR-Modells
output$VARest <- renderTable({
  
  if (!is.list(VAR$model)) { return() }
  
  if(!identical(isolate(VAR$namesVar_data), 0) && !identical(colnames(var_data()), isolate(VAR$namesVar_data))) return()
  
  coef = summary(VAR$model)
  coef = coef[[2]]
  coef = coef[[isolate(input$depVar)]]
  coef = coef[[4]]
  
  return(coef)
  
})

# Ausgabe der statistischen Guetekritereien des aktuell berechneten Modells
output$VARest.qual <- renderTable({
  
  if (!is.list(VAR$model)) { return() }
  
  if(!identical(isolate(VAR$namesVar_data), 0) && !identical(colnames(var_data()), isolate(VAR$namesVar_data))) return()
  
  R.sq <- summary(VAR$model)
  R.sq <- R.sq[[2]]
  R.sq <- R.sq[[input$depVar]]
  R.sq <- R.sq[[8]]
  
  adj.R.sq <- summary(VAR$model)
  adj.R.sq <- adj.R.sq[[2]]
  adj.R.sq <- adj.R.sq[[input$depVar]]
  adj.R.sq <- adj.R.sq[[9]]
  
  qual <- cbind(R.sq,adj.R.sq)
  
  return(qual)
  
})

# Ausgabe der Forecast-Daten sowie der gefitteten historischen Daten in einem Dygraphen
varDygraph <- reactive({
  
  input$EST

  if (!is.list(VAR$model)) return()
  
  if(!identical(isolate(VAR$namesVar_data), 0) && !identical(colnames(var_data()), isolate(VAR$namesVar_data))) return()
    
    fitted.VAR <- fitted(VAR$model)
    fitted.VAR <- fitted.VAR[,isolate(input$depVar)]
    
    lags <- isolate(input$LAGS)
    
    timeS <- isolate(VAR$zeit[-c(1:lags)])
    
    fitted.VAR <- xts(fitted.VAR, timeS)
    
    actual <- var_data()[,isolate(input$depVar)]
    
    seriesfit <- cbind(actual,fitted.VAR)
    colnames(seriesfit) <- c("actual", "fitted.VAR")
    
    
    return(dygraph(seriesfit, isolate(input$depVar)) %>%
             dySeries("actual", label = "Actual") %>%
             dySeries("fitted.VAR", label = "Fitted") %>%
             dyRangeSelector() %>%
             dyOptions(drawPoints = TRUE, pointSize = 2))
    
})

varDygraphforecast<- eventReactive(input$FCST,{

    VAR$fcst <- 0
    VAR$fcst <- predict(VAR$model, n.ahead = isolate(input$HORIZ), ci = 0.90)
    
    fitted.VAR <- fitted(VAR$model)
    fitted.VAR <- fitted.VAR[,isolate(input$depVar)]
    
    lags <- isolate(input$LAGS)
    
    timeS <- isolate(VAR$zeit[-c(1:lags)])
    
    fitted.VAR <- xts(fitted.VAR, timeS)
    
    actual <- var_data()[,isolate(input$depVar)]
    
    # Erstelle Zeitserie für historische und historisch gefittete Werte
    seriesfit <- cbind(actual,fitted.VAR)
    colnames(seriesfit) <- c("actual", "fitted.VAR")
    
    VARfcst <- VAR$fcst$fcst
    VARfcst <- VARfcst[isolate(input$depVar)]
    VARfcst <- data.frame(VARfcst)
    VARfcst <- VARfcst[,-c(4)]
    
    predicted <- VARfcst[,1]
    lower <- VARfcst[,2]
    upper <- VARfcst[,3]
    
    # Setze Zeitserie fuer den Forecast
    timePred <- tail(VAR$zeit, n=1)
    timePred <- seq(timePred, by = start$freq, length.out = isolate(input$HORIZ)+ 1)[2:(isolate(input$HORIZ)+1)]
    predictedTS <- xts(cbind(lower, predicted, upper), timePred)
     
    seriesforecastandfit <- cbind(predictedTS, seriesfit)
    
    seriesforecastandfit[nrow(seriesforecastandfit)-isolate(input$HORIZ),2]<-seriesforecastandfit[nrow(seriesforecastandfit)-isolate(input$HORIZ),5]
    
    dygraph(seriesforecastandfit, isolate(input$depVar)) %>%
      dySeries("actual", label = "Actual") %>%
      dySeries("fitted.VAR", label = "Fitted") %>%
      dySeries(c("lower","predicted","upper"), label = "Predicted") %>%
      dyRangeSelector() %>%
      dyOptions(drawPoints = TRUE, pointSize = 2)
    
  
})

# Ausgabe der Zeitserie mit oder ohne Forecast-input (siehe varDygraph())
output$VARfittedPlot <- renderDygraph({
  
  varDygraph()  
  
})

output$VARfittedPlotforecast <- renderDygraph({
  
  varDygraphforecast()  
  
})


## Forecasting of VAR-Model ##

output$text.fcst <- renderText({ 
  
  if (dygraph$indexforecast == FALSE) { return() }
  
  if(!identical(isolate(VAR$namesVar_data), 0) && !identical(colnames(var_data()), isolate(VAR$namesVar_data))) return()
  
  paste("Predicted values for", isolate(input$depVar))
  
})

# Ausgabe der Forecast-Werte des aktuellen VAR-Modells
tableVARforecast <- eventReactive(VAR$fcst, {
  
  if(!identical(isolate(VAR$namesVar_data), 0) && !identical(colnames(var_data()), isolate(VAR$namesVar_data))) return()
  
  if (dygraph$indexforecast ==FALSE) { return() }
  
  VARfcst = VAR$fcst$fcst

    VARfcst = VARfcst[isolate(input$depVar)]
    VARfcst = data.frame(VARfcst)
    VARfcst = VARfcst[,-c(4)]
    VARfcst = round(VARfcst,digits = 2)
    
    dates.predicted = seq(start$datum, by = start$freq, length.out = nrow(daten.under$base)+1)
    dates.predicted = tail(dates.predicted,n=1)
    dates.predicted = seq(dates.predicted, by = start$freq, length.out = isolate(input$HORIZ))
    dates.predicted = data.frame(dates.predicted)
    
    VARfcst = cbind(dates.predicted,VARfcst)
    
    colnames(VARfcst) <- c("Date","Predicted","Lower 90%-PI","Upper 90%-PI")
    
    VARfcst
  
})

output$VARforecast <- renderDataTable({
  
  tableVARforecast()
  
},options = list(pagination = FALSE,searching = FALSE,paging = FALSE))

#######################################################################
#######################################################################

## 7.3 Forecasting via restricted VAR-Model ##


observeEvent(input$resEST,{
  
  if(is.null(var_data())) return()
  
  VAR$namesResVar_data <- colnames(var_data())
  
  VAR$modelres <- isolate(restrict(VAR(var_data(), p = input$resLAGS, type = "const"), method = "ser", thresh = 2.0))
  
  dygraph$indexforecastres = FALSE
})

observeEvent(input$resFCST,{
  
  if(is.null(var_data())) return()
  
  VAR$namesResVar_data <- colnames(var_data())
  
  VAR$modelres <- isolate(restrict(VAR(var_data(), p = input$resLAGS, type = "const"), method = "ser", thresh = 2.0))
  
  dygraph$indexforecastres = TRUE
})


## Estimation of restricted VAR-Model ##

output$text.res.est.qual <- renderText({ 
  
  if (!is.list(VAR$modelres)) { return() }
  
  if(!identical(isolate(VAR$namesResVar_data), 0) && !identical(colnames(var_data()), isolate(VAR$namesResVar_data))) return()
  
  paste("Coefficients of determination", isolate(input$depVar))
  
})

output$text.res.est <- renderText({ 
  
  if (!is.list(VAR$modelres)) { return() }
  
  if(!identical(isolate(VAR$namesResVar_data), 0) && !identical(colnames(var_data()), isolate(VAR$namesResVar_data))) return()
  
  paste("Estimation results for", input$depVar)
})

# Ausgabe der Koeffizienten des aktuell berechneten restricted VAR-Models
output$restrVARest <- renderTable({
  
  if (!is.list(VAR$modelres)) { return() }
  
  if(!identical(isolate(VAR$namesResVar_data), 0) && !identical(colnames(var_data()), isolate(VAR$namesResVar_data))) return()

  res.coef = summary(VAR$modelres)
  res.coef = res.coef[[2]]
  res.coef = res.coef[[input$depVar]]
  res.coef = res.coef[[4]]
  
  res.coef
  
})

# Ausgabe der statistischen Guetekriterien des aktuell berechneten restricted VAR-Models
output$restrVARest.qual <- renderTable({
  
  if (!is.list(VAR$modelres)) { return() }
  
  if(!identical(isolate(VAR$namesResVar_data), 0) && !identical(colnames(var_data()), isolate(VAR$namesResVar_data))) return()
  
  R.sq = summary(VAR$modelres)
  R.sq = R.sq[[2]]
  R.sq = R.sq[[input$depVar]]
  R.sq = R.sq[[8]]
  
  adj.R.sq = summary(VAR$modelres)
  adj.R.sq = adj.R.sq[[2]]
  adj.R.sq = adj.R.sq[[input$depVar]]
  adj.R.sq = adj.R.sq[[9]]
  
  qual = cbind(R.sq,adj.R.sq)
  #qual = round(qual,4)
  #colnames(qual) <- c("R-squared","adj. R-squared")
  qual
  
})

# Generiere Zeitserien Graphen fuer restricted VAR-Modelle
restVARDygraph <- reactive({
  
  input$resFCST
  input$resEST
  
  if (!is.list(VAR$modelres)) { return() }
  
  if(!identical(isolate(VAR$namesResVar_data), 0) && !identical(colnames(var_data()), isolate(VAR$namesResVar_data))) return()
  
    res.fitted.VAR = fitted(VAR$modelres)
    res.fitted.VAR = res.fitted.VAR[,isolate(input$depVar)]
    
    lags <- isolate(input$resLAGS)
    
    timeS <- isolate(VAR$zeit[-c(1:lags)])
    
    res.fitted.VAR <- xts(res.fitted.VAR, timeS)
    
    actual = var_data()[,isolate(input$depVar)]
    
    seriesfit <- cbind(actual,res.fitted.VAR)
    colnames(seriesfit) <- c("actual", "fitted.VAR")
    
    return(dygraph(seriesfit, isolate(input$depVar)) %>%
             dySeries("actual", label = "Actual") %>%
             dySeries("fitted.VAR", label = "Fitted") %>%
             dyRangeSelector() %>%
             dyOptions(drawPoints = TRUE, pointSize = 2))
    
})

restVARDygraphforecast <- eventReactive(input$resFCST, {

  isolate({ 
    res.fitted.VAR = fitted(VAR$modelres)
    res.fitted.VAR = res.fitted.VAR[,isolate(input$depVar)]
    
    lags <- isolate(input$resLAGS)
    
    timeS <- isolate(VAR$zeit[-c(1:lags)])
    
    res.fitted.VAR <- xts(res.fitted.VAR, timeS)
    
    actual <- var_data()[,isolate(input$depVar)]
    
    # Erstelle Zeitserie für historische und historisch gefittete Werte
    seriesfit <- cbind(actual,res.fitted.VAR)
    colnames(seriesfit) <- c("actual", "fitted.VAR")
    
    # Predict Werte auf Basis restricted VAR-Modell
    VAR$fcstres <- 0
    VAR$fcstres <- isolate(predict(VAR$modelres, n.ahead = input$resHORIZ))
    
    restrVARfcst = VAR$fcstres$fcst
    restrVARfcst = restrVARfcst[isolate(input$depVar)]
    restrVARfcst = data.frame(restrVARfcst)
    restrVARfcst = restrVARfcst[,-c(4)]
    
    predicted.restr = restrVARfcst[,1]
    lower.restr = restrVARfcst[,2]
    upper.restr = restrVARfcst[,3]
    
    # Setze Zeitserie fuer den Forecast
    timePred <- tail(VAR$zeit, n=1)
    timePred <- seq(timePred, by = start$freq, length.out = isolate(input$resHORIZ)+ 1)[2:(isolate(input$resHORIZ)+1)]
    predictedRTS <- xts(cbind(lower.restr, predicted.restr, upper.restr), timePred)
    
    seriesforecastandfit <- cbind(predictedRTS, seriesfit)
    
    seriesforecastandfit[nrow(seriesforecastandfit)-isolate(input$resHORIZ),2]<-seriesforecastandfit[nrow(seriesforecastandfit)-isolate(input$resHORIZ),5]
    
    print(seriesforecastandfit)
    
    dygraph(seriesforecastandfit, isolate(input$depVar)) %>%
      dySeries("actual", label = "Actual") %>%
      dySeries("fitted.VAR", label = "Fitted") %>%
      dySeries(c("lower.restr","predicted.restr","upper.restr"), label = "Predicted") %>%
      dyRangeSelector() %>%
      dyOptions(drawPoints = TRUE, pointSize = 2)
    
  })
    
})

# Ausgabe des in der Funktion zuvor generierten Dygraphen
output$restrVARfittedPlot <- renderDygraph({
  
  restVARDygraph()
  
})

output$restrVARfittedPlotforecast <- renderDygraph({
  
  restVARDygraphforecast()
  
})

output$text.res.fcst <- renderText({ 
  
  if(!identical(isolate(VAR$namesResVar_data), 0) && !identical(colnames(var_data()), isolate(VAR$namesResVar_data))) return()
  
  if(dygraph$indexforecastres == FALSE) { return() }
  
  paste("Predicted values for", input$depVar)
  
})

# Berechnung der Forecast-Werte auf Basis des aktuell berecheneten restricted VAR-Models
# Wird ausgefuehrt bei der Betaetigung des Buttons "Forecast restricted VAR-Model"
tablerestrVARforecast <- eventReactive(VAR$fcstres, {
  
  if(!identical(isolate(VAR$namesResVar_data), 0) && !identical(colnames(var_data()), isolate(VAR$namesResVar_data))) return()
  
  if (dygraph$indexforecastres == FALSE) { return() }
 
  resVARfcst = VAR$fcstres$fcst
  resVARfcst = resVARfcst[input$depVar]
  resVARfcst = data.frame(resVARfcst)
  resVARfcst = resVARfcst[,-c(4)]
  resVARfcst = round(resVARfcst,digits = 2)
  
  res.dates.predicted = seq(start$datum, by = start$freq, length.out = nrow(daten.under$base)+1)
  res.dates.predicted = tail(res.dates.predicted,n=1)
  res.dates.predicted = seq(res.dates.predicted, by = start$freq, length.out = isolate(input$resHORIZ))
  res.dates.predicted = data.frame(res.dates.predicted)
  
  resVARfcst = cbind(res.dates.predicted,resVARfcst)
  
  colnames(resVARfcst) <- c("Date","Predicted","Lower 90%-PI","Upper 90%-PI")
  
  resVARfcst
  
})

output$restrVARforecast <- renderDataTable({
  
  tablerestrVARforecast()
  
},options = list(pagination = FALSE,searching = FALSE,paging = FALSE))


output$savedvarrestexplmodelZwei<-renderDygraph({
  
  var.modelle$gespeicherte.expl.modelle.restvar[[2]]

})

output$savedvarrestexplmodelDrei<-renderTable({
  
  var.modelle$gespeicherte.expl.modelle.restvar[[3]]
  
})

output$savedvarrestexplmodelVier<-renderTable({
  
  var.modelle$gespeicherte.expl.modelle.restvar[[4]]
  
})


output$savedvarexplmodelZwei<-renderDygraph({
  
  var.modelle$gespeicherte.expl.modelle.var[[2]]
  
})

output$savedvarexplmodelDrei<-renderTable({
  
  var.modelle$gespeicherte.expl.modelle.var[[3]]
  
})

output$savedvarexplmodelVier<-renderTable({
  
  var.modelle$gespeicherte.expl.modelle.var[[4]]
  
})



############################################################################
############################################################################



#session$onFlushed(function() {
#  session$sendCustomMessage(type='jsCode', list(value = script))
#}, FALSE)

#script <- "$('tbody tr td:nth-child(5)').each(function() {
#
#              var cellValue = $(this).text();
#
#              if (cellValue > 50) {
#                $(this).css('background-color', '#0c0');
#              }
#              else if (cellValue <= 50) {
#                $(this).css('background-color', '#f00');
#              }
#            })"



output$choose_columnsVar <- renderUI({
  
  reg.data <- daten.under$base[ ,sapply(daten.under$base, is.numeric)]
  index.depVar <- which(attributes(reg.data)$names == input$depVar)
  
  
  colnames <- names(reg.data)[- index.depVar]
  
  # Create the checkboxes and select them all by default
  selectInput("columns2", h4(strong("Choose independent variables")),
              choices  = colnames,
              multiple = TRUE)
})


observeEvent(input$saveFCST, {
  
  withProgress(message = "Forecast saved", Sys.sleep(1.5))
  
  var.modelle$gespeicherte.forecasts.var[[1]] <- varDygraphforecast() 
  var.modelle$gespeicherte.forecasts.var[[2]] <- tableVARforecast()
  var.modelle$gespeicherte.forecasts.var[[3]] <- nrow(tableVARforecast)
  
})

output$savedforecastvargraph<- renderDygraph({
  
  var.modelle$gespeicherte.forecasts.var[[1]]
  
})


output$savedforecastgraphtable<- renderDataTable({
  
  var.modelle$gespeicherte.forecasts.var[[2]]
  
})

observeEvent(input$saveresFCST, {
  
  withProgress(message = "Forecast saved", Sys.sleep(1.5))
  
  var.modelle$gespeicherte.forecasts.restvar[[1]] <- restVARDygraphforecast() 
  var.modelle$gespeicherte.forecasts.restvar[[2]] <- tablerestrVARforecast()
  var.modelle$gespeicherte.forecasts.restvar[[3]] <- nrow(tablerestrVARforecast)
  
})

output$savedforecastrestvargraph<- renderDygraph({
  
  var.modelle$gespeicherte.forecasts.restvar[[1]]
  
})


output$savedforecastgraphtablerest<- renderDataTable({
  
  var.modelle$gespeicherte.forecasts.restvar[[2]]
  
})



output$texthelpeins<-renderUI({

  "The vector autoregression is an econometric model used to capture interdependencies among multiple time series. 
    All variables are treated symmetrically and allow for feedback relationships, i.e. all variables affect each other. 
    The vector autoregressive model generalize the (univariate) autoregressive model to forecast a set of K variables, where 
    each variable is explained based on its own lags and the lags of the other variables (p lags). "
})

output$texthelpzwei<-renderUI({
  
  "In a VAR model all variables are treated symmetrically, irrespective of the significance of the estimated coefficients. 
    A restricted VAR model drops out insignificant variables/lags, i.e. it might include some variables in one equation, other 
    variables in another equation, depending on the t-values of the estimated coefficients. "
})



