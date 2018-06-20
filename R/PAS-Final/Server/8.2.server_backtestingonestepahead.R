

backtest<-reactiveValues(
  
  choosemodelbacktestOnestep = 0,
  timeOnestepahead = 0
  
)

output$checkboxgroupbacktestOnestep<- renderUI({
  
  
  
  if(length(var.modelle$gespeicherte.forecasts.var) == 0 &
     length(var.modelle$gespeicherte.forecasts.restvar) == 0 & 
     length(regression.modelle$gespeicherte.forecasts) == 0){
    return(checkboxGroupInput("choosebacktestmodelOnestep", "Choose forecasts for backtest:",
                              c("RW" = "RW",
                                "ARIMA" = "ARIMA")))
  }
  
  if(length(var.modelle$gespeicherte.expl.modelle.var) == 0 &
     length(var.modelle$gespeicherte.expl.modelle.restvar) == 0 & 
     length(regression.modelle$gespeichertes.modell) > 0){
    return(checkboxGroupInput("choosebacktestmodelOnestep", "Choose forecasts for backtest:",
                              c("RW" = "RW",
                                "ARIMA" = "ARIMA",
                                "MReg" = "MReg")))
  }
  
  if(length(var.modelle$gespeicherte.expl.modelle.var) > 0 &
     length(var.modelle$gespeicherte.expl.modelle.restvar) == 0 & 
     length(regression.modelle$gespeichertes.modell) == 0){
    return(checkboxGroupInput("choosebacktestmodelOnestep", "Choose forecasts for backtest:",
                              c("RW" = "RW",
                                "ARIMA" = "ARIMA",
                                "VAR" = "VAR")))
  }
  
  if(length(var.modelle$gespeicherte.expl.modelle.var) > 0 &
     length(var.modelle$gespeicherte.expl.modelle.restvar) == 0 & 
     length(regression.modelle$gespeichertes.modell) > 0){
    return(checkboxGroupInput("choosebacktestmodelOnestep", "Choose forecasts for backtest:",
                              c("RW" = "RW",
                                "ARIMA" = "ARIMA",
                                "MReg" = "MReg", 
                                "VAR" = "VAR")))
  }
  
  if(length(var.modelle$gespeicherte.expl.modelle.var) == 0 &
     length(var.modelle$gespeicherte.expl.modelle.restvar) > 0 & 
     length(regression.modelle$gespeichertes.modell) > 0){
    return(checkboxGroupInput("choosebacktestmodelOnestep", "Choose forecasts for backtest:",
                              c("RW" = "RW",
                                "ARIMA" = "ARIMA",
                                "MReg" = "MReg",
                                "Restr.VAR" = "Restr.VAR")))
  }
  
  if(length(var.modelle$gespeicherte.expl.modelle.var) > 0 &
     length(var.modelle$gespeicherte.expl.modelle.restvar) > 0 & 
     length(regression.modelle$gespeichertes.modell) == 0){
    return(checkboxGroupInput("choosebacktestmodelOnestep", "Choose forecasts for backtest:",
                              c("RW" = "RW",
                                "ARIMA" = "ARIMA",
                                "VAR" = "VAR",
                                "Restr.VAR" = "Restr.VAR")))
  }
  
  if(length(var.modelle$gespeicherte.expl.modelle.var) == 0 &
     length(var.modelle$gespeicherte.expl.modelle.restvar) > 0 & 
     length(regression.modelle$gespeichertes.modell) == 0){
    return(checkboxGroupInput("choosebacktestmodelOnestep", "Choose forecasts for backtest:",
                              c("RW" = "RW",
                                "ARIMA" = "ARIMA",
                                "Restr.VAR" = "Restr.VAR")))
  }
  
  
  if(length(var.modelle$gespeicherte.expl.modelle.var) > 0 &
     length(var.modelle$gespeicherte.expl.modelle.restvar) > 0 & 
     length(regression.modelle$gespeichertes.modell) > 0){
    return(checkboxGroupInput("choosebacktestmodelOnestep", "Choose forecasts for backtest:",
                              c("RW" = "RW",
                                "ARIMA" = "ARIMA",
                                "MReg" = "MReg",
                                "VAR" = "VAR",
                                "Restr.VAR" = "Restr.VAR")))
  }
  
})



RMSEonestepahead <- eventReactive(input$startbacktestingonestepahead, {
  
  #print("hallo123")
  
  #if(is.null(input$choosebacktestmodel)){return(withProgress(message = "No explanation models choosen",Sys.sleep(2)))}
  
  collapsedinput<- paste(input$choosebacktestmodelOnestep, collapse = " ")
  
  if(collapsedinput == "RW"){backtest$choosemodelbacktestOnestep <-1}
  if(collapsedinput == "ARIMA"){backtest$choosemodelbacktestOnestep <-2}
  if(collapsedinput == "MReg"){backtest$choosemodelbacktestOnestep <-3}
  if(collapsedinput == "VAR"){backtest$choosemodelbacktestOnestep <-4}
  if(collapsedinput == "Restr.VAR"){backtest$choosemodelbacktestOnestep <-5}
  if(collapsedinput == "RW ARIMA"){backtest$choosemodelbacktestOnestep <-6}
  if(collapsedinput == "RW MReg"){backtest$choosemodelbacktestOnestep <-7}
  if(collapsedinput == "RW VAR"){backtest$choosemodelbacktestOnestep <-8}
  if(collapsedinput == "RW Restr.VAR"){backtest$choosemodelbacktestOnestep <-9}
  if(collapsedinput == "ARIMA MReg"){backtest$choosemodelbacktestOnestep <-10}
  if(collapsedinput == "ARIMA VAR"){backtest$choosemodelbacktestOnestep <-11}
  if(collapsedinput == "ARIMA Restr.VAR"){backtest$choosemodelbacktestOnestep <-12}
  if(collapsedinput == "MReg VAR"){backtest$choosemodelbacktestOnestep <-13}
  if(collapsedinput == "MReg Restr.VAR"){backtest$choosemodelbacktestOnestep <-14}
  if(collapsedinput == "VAR Restr.VAR"){backtest$choosemodelbacktestOnestep <-15}
  if(collapsedinput == "RW ARIMA MReg"){backtest$choosemodelbacktestOnestep <-16}
  if(collapsedinput == "RW ARIMA VAR"){backtest$choosemodelbacktestOnestep <-17}
  if(collapsedinput == "RW ARIMA Restr.VAR"){backtest$choosemodelbacktestOnestep <-18}
  if(collapsedinput == "RW MReg VAR"){backtest$choosemodelbacktestOnestep <-19}
  if(collapsedinput == "RW MReg Restr.VAR"){backtest$choosemodelbacktestOnestep <-20}
  if(collapsedinput == "RW VAR Restr.VAR"){backtest$choosemodelbacktestOnestep <-21}
  if(collapsedinput == "MReg VAR Restr.VAR"){backtest$choosemodelbacktestOnestep <-22}
  if(collapsedinput == "ARIMA MReg VAR Restr.VAR"){backtest$choosemodelbacktestOnestep <-23}
  if(collapsedinput == "RW MReg VAR Restr.VAR"){backtest$choosemodelbacktestOnestep <-24}
  if(collapsedinput == "RW ARIMA VAR Restr.VAR"){backtest$choosemodelbacktestOnestep <-25}
  if(collapsedinput == "RW ARIMA MReg Restr.VAR"){backtest$choosemodelbacktestOnestep <-26}
  if(collapsedinput == "RW ARIMA MReg VAR"){backtest$choosemodelbacktestOnestep <-27}
  if(collapsedinput == "ARIMA VAR Restr.VAR"){backtest$choosemodelbacktestOnestep <-28}
  if(collapsedinput == "ARIMA MReg Restr.VAR"){backtest$choosemodelbacktestOnestep <-29}
  if(collapsedinput == "ARIMA MReg VAR"){backtest$choosemodelbacktestOnestep <-30}
  if(collapsedinput == "RW ARIMA MReg VAR Restr.VAR"){backtest$choosemodelbacktestOnestep <-31}
  
  if(backtest$choosemodelbacktestOnestep  == 1){
    
    windowTs<-xts(daten.under$data.train[,-1], daten.under$data.train[[1]])
    forecastingTs <- xts(daten.under$data.test[,-1], daten.under$data.test[[1]])
    
    RWfcst = rwf(windowTs[,input$depVar], h=nrow(daten.under$data.test), drift=FALSE)
    Rw.forecastTs <-xts(as.data.frame(RWfcst$mean), daten.under$data.test[[1]])
    rw.diff <- abs(Rw.forecastTs[,1]-forecastingTs[,input$depVar])
    
    backtest$timeOnestepahead <- cbind(xts(daten.under$default[, input$depVar], start$dates), Rw.forecastTs) 
    
    RMSEonestepahead<-rw.diff
    
    colnames(RMSEonestepahead)<-"RW"
    colnames(backtest$timeOnestepahead)<-c(input$depVar, "RW")
  
  }
  
  
  if(backtest$choosemodelbacktestOnestep  == 2){
    
    windowTs<-xts(daten.under$data.train[,-1], daten.under$data.train[[1]])
    forecastingTs <- xts(daten.under$data.test[,-1], daten.under$data.test[[1]])
    
    
    ARIMAmodel = auto.arima(windowTs[,input$depVar],seasonal = FALSE)
    ARIMAfcast <- forecast(ARIMAmodel, h=nrow(daten.under$data.test))
    arima.forecastTs <- xts(as.data.frame(ARIMAfcast$mean), daten.under$data.test[[1]])
    arima.diff <- abs(arima.forecastTs[,1] -forecastingTs[,input$depVar])
    
    

    
    backtest$timeOnestepahead <- cbind(xts(daten.under$default[, input$depVar], start$dates), arima.forecastTs) 
    
    RMSEonestepahead<-arima.diff
    
    colnames(RMSEonestepahead)<-"ARIMA"
    colnames(backtest$timeOnestepahead)<-c(input$depVar, "ARIMA")
    
  }
  
  if(backtest$choosemodelbacktestOnestep  == 3){
    
    h<-nrow(regression.modelle$gespeicherte.forecasts[[2]])
    
    windowTs<-xts(daten.under$data.train[,-1], daten.under$data.train[[1]])
    forecastingTs <- xts(daten.under$data.test[,-1][1:h,], daten.under$data.test[[1]][1:h])
    
    mreg.forecastTs<- xts(regression.modelle$gespeicherte.forecasts[[2]][,2], regression.modelle$gespeicherte.forecasts[[2]][,1])
    mreg.diff <- abs(mreg.forecastTs[,1] -forecastingTs[,input$depVar])
    
    
    backtest$timeOnestepahead <- cbind(xts(daten.under$default[, input$depVar], start$dates), mreg.forecastTs) 
    
    RMSEonestepahead<-mreg.diff
    
    colnames(RMSEonestepahead)<-"MReg"
    colnames(backtest$timeOnestepahead)<-c(input$depVar, "MReg")
    
  }
  
  if(backtest$choosemodelbacktestOnestep  == 4){
    
    h<-nrow(var.modelle$gespeicherte.forecasts.var[[2]])
    
    windowTs<-xts(daten.under$data.train[,-1], daten.under$data.train[[1]])
    forecastingTs <- xts(daten.under$data.test[,-1][1:h,], daten.under$data.test[[1]][1:h])
    
    var.forecastTs<- xts(var.modelle$gespeicherte.forecasts.var[[2]][,2], var.modelle$gespeicherte.forecasts.var[[2]][,1])
    var.diff <- abs(var.forecastTs[,1] -forecastingTs[,input$depVar])
    
    
    backtest$timeOnestepahead <- cbind(xts(daten.under$default[, input$depVar], start$dates), var.forecastTs) 
    
    RMSEonestepahead<-var.diff
    
    colnames(RMSEonestepahead)<-"VAR"
    colnames(backtest$timeOnestepahead)<-c(input$depVar, "VAR")
    
  }
  
  if(backtest$choosemodelbacktestOnestep  == 5){
    
    h<-nrow(var.modelle$gespeicherte.forecasts.restvar[[2]])
    
    windowTs<-xts(daten.under$data.train[,-1], daten.under$data.train[[1]])
    forecastingTs <- xts(daten.under$data.test[,-1][1:h,], daten.under$data.test[[1]][1:h])
    
    restvar.forecastTs<- xts(var.modelle$gespeicherte.forecasts.restvar[[2]][,2], var.modelle$gespeicherte.forecasts.restvar[[2]][,1])
    restvar.diff <- abs(restvar.forecastTs[,1] -forecastingTs[,input$depVar])
    
    
    backtest$timeOnestepahead <- cbind(xts(daten.under$default[, input$depVar], start$dates), restvar.forecastTs) 
    
    RMSEonestepahead<-restvar.diff
    
    colnames(RMSEonestepahead)<-"Restr.VAR"
    colnames(backtest$timeOnestepahead)<-c(input$depVar, "Restr.VAR")
    
  }
  
  if(backtest$choosemodelbacktestOnestep  == 6){
    
    
    windowTs<-xts(daten.under$data.train[,-1], daten.under$data.train[[1]])
    forecastingTs <- xts(daten.under$data.test[,-1], daten.under$data.test[[1]])
    
    RWfcst = rwf(windowTs[,input$depVar], h=nrow(daten.under$data.test), drift=FALSE)
    Rw.forecastTs <-xts(as.data.frame(RWfcst$mean), daten.under$data.test[[1]])
    rw.diff <- abs(Rw.forecastTs[,1]-forecastingTs[,input$depVar])
    
    ARIMAmodel = auto.arima(windowTs[,input$depVar],seasonal = FALSE)
    ARIMAfcast <- forecast(ARIMAmodel, h=nrow(daten.under$data.test))
    arima.forecastTs <- xts(as.data.frame(ARIMAfcast$mean), daten.under$data.test[[1]])
    arima.diff <- abs(arima.forecastTs[,1] -forecastingTs[,input$depVar])
    
    backtest$timeOnestepahead <- cbind(xts(daten.under$default[, input$depVar], start$dates), Rw.forecastTs, arima.forecastTs) 
    
    RMSEonestepahead<-cbind(rw.diff, arima.diff)
    
    colnames(RMSEonestepahead)<-c("RW", "ARIMA")
    colnames(backtest$timeOnestepahead)<-c(input$depVar, "RW", "ARIMA")
    
  }
  
  if(backtest$choosemodelbacktestOnestep  == 7){
    
    h<-nrow(regression.modelle$gespeicherte.forecasts[[2]])
    
    windowTs<-xts(daten.under$data.train[,-1], daten.under$data.train[[1]])
    forecastingTs <- xts(daten.under$data.test[,-1][1:h,], daten.under$data.test[[1]][1:h])
    
    RWfcst = rwf(windowTs[,input$depVar], h=h, drift=FALSE)
    Rw.forecastTs <-xts(as.data.frame(RWfcst$mean), daten.under$data.test[[1]][1:h])
    rw.diff <- abs(Rw.forecastTs[,1]-forecastingTs[,input$depVar])
    
    mreg.forecastTs<- xts(regression.modelle$gespeicherte.forecasts[[2]][,2], regression.modelle$gespeicherte.forecasts[[2]][,1])
    mreg.diff <- abs(mreg.forecastTs[,1] -forecastingTs[,input$depVar])
    
    backtest$timeOnestepahead <- cbind(xts(daten.under$default[, input$depVar], start$dates), Rw.forecastTs, mreg.forecastTs) 
    
    RMSEonestepahead<-cbind(rw.diff, mreg.diff)
    
    colnames(RMSEonestepahead)<-c("RW", "MReg")
    colnames(backtest$timeOnestepahead)<-c(input$depVar, "RW", "MReg")
    
  }
  
  if(backtest$choosemodelbacktestOnestep  == 8){
    
    h<-nrow(var.modelle$gespeicherte.forecasts.var[[2]])
    
    windowTs<-xts(daten.under$data.train[,-1], daten.under$data.train[[1]])
    forecastingTs <- xts(daten.under$data.test[,-1][1:h,], daten.under$data.test[[1]][1:h])
    
    RWfcst = rwf(windowTs[,input$depVar], h=h, drift=FALSE)
    Rw.forecastTs <-xts(as.data.frame(RWfcst$mean), daten.under$data.test[[1]][1:h])
    rw.diff <- abs(Rw.forecastTs[,1]-forecastingTs[,input$depVar])
    
    var.forecastTs<- xts(var.modelle$gespeicherte.forecasts.var[[2]][,2], var.modelle$gespeicherte.forecasts.var[[2]][,1])
    var.diff <- abs(var.forecastTs[,1] -forecastingTs[,input$depVar])
    
    
    backtest$timeOnestepahead <- cbind(xts(daten.under$default[, input$depVar], start$dates), Rw.forecastTs, var.forecastTs) 
    
    RMSEonestepahead<-cbind(rw.diff, var.diff)
    
    colnames(RMSEonestepahead)<-c("RW", "VAR")
    colnames(backtest$timeOnestepahead)<-c(input$depVar, "RW","VAR")
    
  }
  
  if(backtest$choosemodelbacktestOnestep  == 9){
    
    h<-nrow(var.modelle$gespeicherte.forecasts.restvar[[2]])
    
    windowTs<-xts(daten.under$data.train[,-1], daten.under$data.train[[1]])
    forecastingTs <- xts(daten.under$data.test[,-1][1:h,], daten.under$data.test[[1]][1:h])
    
    RWfcst = rwf(windowTs[,input$depVar], h=h, drift=FALSE)
    Rw.forecastTs <-xts(as.data.frame(RWfcst$mean), daten.under$data.test[[1]][1:h])
    rw.diff <- abs(Rw.forecastTs[,1]-forecastingTs[,input$depVar])
    
    restvar.forecastTs<- xts(var.modelle$gespeicherte.forecasts.restvar[[2]][,2], var.modelle$gespeicherte.forecasts.restvar[[2]][,1])
    restvar.diff <- abs(restvar.forecastTs[,1] -forecastingTs[,input$depVar])
    
    
    backtest$timeOnestepahead <- cbind(xts(daten.under$default[, input$depVar], start$dates), Rw.forecastTs, restvar.forecastTs) 
    
    RMSEonestepahead<-cbind(rw.diff, restvar.diff)
    
    colnames(RMSEonestepahead)<-c("RW", "Restr.VAR")
    colnames(backtest$timeOnestepahead)<-c(input$depVar, "RW","Restr.VAR")
    
  }
  
  if(backtest$choosemodelbacktestOnestep  == 10){
    
    h<-nrow(regression.modelle$gespeicherte.forecasts[[2]])
    
    windowTs<-xts(daten.under$data.train[,-1], daten.under$data.train[[1]])
    forecastingTs <- xts(daten.under$data.test[,-1][1:h,], daten.under$data.test[[1]][1:h])
    
    ARIMAmodel = auto.arima(windowTs[,input$depVar],seasonal = FALSE)
    ARIMAfcast <- forecast(ARIMAmodel, h=h)
    arima.forecastTs <- xts(as.data.frame(ARIMAfcast$mean), daten.under$data.test[[1]][1:h])
    arima.diff <- abs(arima.forecastTs[,1] -forecastingTs[,input$depVar])
    
    
    mreg.forecastTs<- xts(regression.modelle$gespeicherte.forecasts[[2]][,2], regression.modelle$gespeicherte.forecasts[[2]][,1])
    mreg.diff <- abs(mreg.forecastTs[,1] -forecastingTs[,input$depVar])
    
    
    backtest$timeOnestepahead <- cbind(xts(daten.under$default[, input$depVar], start$dates), arima.forecastTs, mreg.forecastTs) 
    
    RMSEonestepahead<-cbind(arima.diff, mreg.diff)
    
    colnames(RMSEonestepahead)<-c("ARIMA","MReg")
    colnames(backtest$timeOnestepahead)<-c(input$depVar, "ARIMA","MReg")
    
  }
  
  if(backtest$choosemodelbacktestOnestep  == 11){
    
    h<-nrow(var.modelle$gespeicherte.forecasts.var[[2]])
    
    windowTs<-xts(daten.under$data.train[,-1], daten.under$data.train[[1]])
    forecastingTs <- xts(daten.under$data.test[,-1][1:h,], daten.under$data.test[[1]][1:h])
    
    ARIMAmodel = auto.arima(windowTs[,input$depVar],seasonal = FALSE)
    ARIMAfcast <- forecast(ARIMAmodel, h=h)
    arima.forecastTs <- xts(as.data.frame(ARIMAfcast$mean), daten.under$data.test[[1]][1:h])
    arima.diff <- abs(arima.forecastTs[,1] -forecastingTs[,input$depVar])
    
    var.forecastTs<- xts(var.modelle$gespeicherte.forecasts.var[[2]][,2], var.modelle$gespeicherte.forecasts.var[[2]][,1])
    var.diff <- abs(var.forecastTs[,1] -forecastingTs[,input$depVar])
    
    
    backtest$timeOnestepahead <- cbind(xts(daten.under$default[, input$depVar], start$dates), arima.forecastTs, var.forecastTs) 
    
    RMSEonestepahead<-cbind(arima.diff, var.diff)
    
    colnames(RMSEonestepahead)<-c("ARIMA", "VAR")
    colnames(backtest$timeOnestepahead)<-c(input$depVar, "ARIMA","VAR")
    
  }
  
  if(backtest$choosemodelbacktestOnestep  == 12){
    
    h<-nrow(var.modelle$gespeicherte.forecasts.restvar[[2]])
    
    windowTs<-xts(daten.under$data.train[,-1], daten.under$data.train[[1]])
    forecastingTs <- xts(daten.under$data.test[,-1][1:h,], daten.under$data.test[[1]][1:h])
    
    ARIMAmodel = auto.arima(windowTs[,input$depVar],seasonal = FALSE)
    ARIMAfcast <- forecast(ARIMAmodel, h=h)
    arima.forecastTs <- xts(as.data.frame(ARIMAfcast$mean), daten.under$data.test[[1]][1:h])
    arima.diff <- abs(arima.forecastTs[,1] -forecastingTs[,input$depVar])
    
    restvar.forecastTs<- xts(var.modelle$gespeicherte.forecasts.restvar[[2]][,2], var.modelle$gespeicherte.forecasts.restvar[[2]][,1])
    restvar.diff <- abs(restvar.forecastTs[,1] -forecastingTs[,input$depVar])
    
    
    backtest$timeOnestepahead <- cbind(xts(daten.under$default[, input$depVar], start$dates), arima.forecastTs, restvar.forecastTs) 
    
    RMSEonestepahead<-cbind(arima.diff, restvar.diff)
    
    colnames(RMSEonestepahead)<-c("ARIMA", "Restr.VAR")
    colnames(backtest$timeOnestepahead)<-c(input$depVar, "ARIMA","Restr.VAR")
    
  }
  
  if(backtest$choosemodelbacktestOnestep  == 13){
    
    hEins <- nrow(regression.modelle$gespeicherte.forecasts[[2]])
    hZwei <- nrow(var.modelle$gespeicherte.forecasts.var[[2]])
    h <- min(hEins, hZwei)
    
    
    
    windowTs<-xts(daten.under$data.train[,-1], daten.under$data.train[[1]])
    forecastingTs <- xts(daten.under$data.test[,-1][1:h,], daten.under$data.test[[1]][1:h])
    
    
    mreg.forecastTs<- xts(regression.modelle$gespeicherte.forecasts[[2]][,2][1:h], regression.modelle$gespeicherte.forecasts[[2]][,1][1:h])
    mreg.diff <- abs(mreg.forecastTs[,1] -forecastingTs[,input$depVar])
    
    var.forecastTs<- xts(var.modelle$gespeicherte.forecasts.var[[2]][,2][1:h], var.modelle$gespeicherte.forecasts.var[[2]][,1][1:h])
    var.diff <- abs(var.forecastTs[,1] -forecastingTs[,input$depVar])
    
    backtest$timeOnestepahead <- cbind(xts(daten.under$default[, input$depVar], start$dates), mreg.forecastTs, var.forecastTs) 
    
    RMSEonestepahead<-cbind(mreg.diff, var.diff)
    
    colnames(RMSEonestepahead)<-c("MReg", "VAR")
    colnames(backtest$timeOnestepahead)<-c(input$depVar, "MReg", "VAR")
    
  }
  
  if(backtest$choosemodelbacktestOnestep  == 14){
    
    hEins <- nrow(regression.modelle$gespeicherte.forecasts[[2]])
    hZwei <- nrow(var.modelle$gespeicherte.forecasts.restvar[[2]])
    h <- min(hEins, hZwei)
    
    
    
    windowTs<-xts(daten.under$data.train[,-1], daten.under$data.train[[1]])
    forecastingTs <- xts(daten.under$data.test[,-1][1:h,], daten.under$data.test[[1]][1:h])
    
    
    mreg.forecastTs<- xts(regression.modelle$gespeicherte.forecasts[[2]][,2][1:h], regression.modelle$gespeicherte.forecasts[[2]][,1][1:h])
    mreg.diff <- abs(mreg.forecastTs[,1] -forecastingTs[,input$depVar])
    
    restvar.forecastTs<- xts(var.modelle$gespeicherte.forecasts.restvar[[2]][,2][1:h], var.modelle$gespeicherte.forecasts.restvar[[2]][,1][1:h])
    restvar.diff <- abs(restvar.forecastTs[,1] -forecastingTs[,input$depVar])
    
    backtest$timeOnestepahead <- cbind(xts(daten.under$default[, input$depVar], start$dates), mreg.forecastTs, restvar.forecastTs) 
    
    RMSEonestepahead<-cbind(mreg.diff, restvar.diff)
    
    colnames(RMSEonestepahead)<-c("MReg", "Restr.VAR")
    colnames(backtest$timeOnestepahead)<-c(input$depVar, "MReg", "Restr.VAR")
    
  }
  
  if(backtest$choosemodelbacktestOnestep  == 15){
    
    hEins <- nrow(var.modelle$gespeicherte.forecasts.var[[2]])
    hZwei <- nrow(var.modelle$gespeicherte.forecasts.restvar[[2]])
    h <- min(hEins, hZwei)
    
    
    
    windowTs<-xts(daten.under$data.train[,-1], daten.under$data.train[[1]])
    forecastingTs <- xts(daten.under$data.test[,-1][1:h,], daten.under$data.test[[1]][1:h])
    
    var.forecastTs<- xts(var.modelle$gespeicherte.forecasts.var[[2]][,2][1:h], var.modelle$gespeicherte.forecasts.var[[2]][,1][1:h])
    var.diff <- abs(var.forecastTs[,1] -forecastingTs[,input$depVar])
    
    restvar.forecastTs<- xts(var.modelle$gespeicherte.forecasts.restvar[[2]][,2][1:h], var.modelle$gespeicherte.forecasts.restvar[[2]][,1][1:h])
    restvar.diff <- abs(restvar.forecastTs[,1] -forecastingTs[,input$depVar])
    
    backtest$timeOnestepahead <- cbind(xts(daten.under$default[, input$depVar], start$dates), var.forecastTs, restvar.forecastTs) 
    
    RMSEonestepahead<-cbind(var.diff, restvar.diff)
    
    colnames(RMSEonestepahead)<-c("VAR", "Restr.VAR")
    colnames(backtest$timeOnestepahead)<-c(input$depVar, "VAR", "Restr.VAR")
    
  }
  
  if(backtest$choosemodelbacktestOnestep  == 16){
    
    
    h<-nrow(regression.modelle$gespeicherte.forecasts[[2]])
    
    windowTs<-xts(daten.under$data.train[,-1], daten.under$data.train[[1]])
    forecastingTs <- xts(daten.under$data.test[,-1][1:h,], daten.under$data.test[[1]][1:h])
    
    RWfcst = rwf(windowTs[,input$depVar], h=h, drift=FALSE)
    Rw.forecastTs <-xts(as.data.frame(RWfcst$mean), daten.under$data.test[[1]][1:h])
    rw.diff <- abs(Rw.forecastTs[,1]-forecastingTs[,input$depVar])
    
    ARIMAmodel = auto.arima(windowTs[,input$depVar],seasonal = FALSE)
    ARIMAfcast <- forecast(ARIMAmodel, h=h)
    arima.forecastTs <- xts(as.data.frame(ARIMAfcast$mean), daten.under$data.test[[1]][1:h])
    arima.diff <- abs(arima.forecastTs[,1] -forecastingTs[,input$depVar])
    
    mreg.forecastTs<- xts(regression.modelle$gespeicherte.forecasts[[2]][,2], regression.modelle$gespeicherte.forecasts[[2]][,1])
    mreg.diff <- abs(mreg.forecastTs[,1] -forecastingTs[,input$depVar])
    
    backtest$timeOnestepahead <- cbind(xts(daten.under$default[, input$depVar], start$dates), Rw.forecastTs, arima.forecastTs, mreg.forecastTs) 
    
    RMSEonestepahead<-cbind(rw.diff, arima.diff, mreg.diff)
    
    colnames(RMSEonestepahead)<-c("RW", "ARIMA","MReg")
    colnames(backtest$timeOnestepahead)<-c(input$depVar, "RW", "ARIMA","MReg")
    
  }
  
  if(backtest$choosemodelbacktestOnestep  == 17){
    
    h<-nrow(var.modelle$gespeicherte.forecasts.var[[2]])
    
    windowTs<-xts(daten.under$data.train[,-1], daten.under$data.train[[1]])
    forecastingTs <- xts(daten.under$data.test[,-1][1:h,], daten.under$data.test[[1]][1:h])
    
    RWfcst = rwf(windowTs[,input$depVar], h=h, drift=FALSE)
    Rw.forecastTs <-xts(as.data.frame(RWfcst$mean), daten.under$data.test[[1]][1:h])
    rw.diff <- abs(Rw.forecastTs[,1]-forecastingTs[,input$depVar])
    
    ARIMAmodel = auto.arima(windowTs[,input$depVar],seasonal = FALSE)
    ARIMAfcast <- forecast(ARIMAmodel, h=h)
    arima.forecastTs <- xts(as.data.frame(ARIMAfcast$mean), daten.under$data.test[[1]][1:h])
    arima.diff <- abs(arima.forecastTs[,1] -forecastingTs[,input$depVar])
    
    var.forecastTs<- xts(var.modelle$gespeicherte.forecasts.var[[2]][,2], var.modelle$gespeicherte.forecasts.var[[2]][,1])
    var.diff <- abs(var.forecastTs[,1] -forecastingTs[,input$depVar])
    
    
    backtest$timeOnestepahead <- cbind(xts(daten.under$default[, input$depVar], start$dates), Rw.forecastTs, arima.forecastTs, var.forecastTs) 
    
    RMSEonestepahead<-cbind(rw.diff, arima.diff, var.diff)
    
    colnames(RMSEonestepahead)<-c("RW", "ARIMA","VAR")
    colnames(backtest$timeOnestepahead)<-c(input$depVar, "RW","ARIMA","VAR")
    
  }
  
  if(backtest$choosemodelbacktestOnestep  == 18){
    
    h<-nrow(var.modelle$gespeicherte.forecasts.restvar[[2]])
    
    windowTs<-xts(daten.under$data.train[,-1], daten.under$data.train[[1]])
    forecastingTs <- xts(daten.under$data.test[,-1][1:h,], daten.under$data.test[[1]][1:h])
    
    RWfcst = rwf(windowTs[,input$depVar], h=h, drift=FALSE)
    Rw.forecastTs <-xts(as.data.frame(RWfcst$mean), daten.under$data.test[[1]][1:h])
    rw.diff <- abs(Rw.forecastTs[,1]-forecastingTs[,input$depVar])
    
    ARIMAmodel = auto.arima(windowTs[,input$depVar],seasonal = FALSE)
    ARIMAfcast <- forecast(ARIMAmodel, h=h)
    arima.forecastTs <- xts(as.data.frame(ARIMAfcast$mean), daten.under$data.test[[1]][1:h])
    arima.diff <- abs(arima.forecastTs[,1] -forecastingTs[,input$depVar])
    
    restvar.forecastTs<- xts(var.modelle$gespeicherte.forecasts.restvar[[2]][,2], var.modelle$gespeicherte.forecasts.restvar[[2]][,1])
    restvar.diff <- abs(restvar.forecastTs[,1] -forecastingTs[,input$depVar])
    
    
    backtest$timeOnestepahead <- cbind(xts(daten.under$default[, input$depVar], start$dates), Rw.forecastTs, arima.forecastTs, restvar.forecastTs) 
    
    RMSEonestepahead<-cbind(rw.diff, arima.diff, restvar.diff)
    
    colnames(RMSEonestepahead)<-c("RW", "ARIMA","Restr.VAR")
    colnames(backtest$timeOnestepahead)<-c(input$depVar, "RW","ARIMA","Restr.VAR")
    
  }
  
  if(backtest$choosemodelbacktestOnestep  == 19){
    
    hEins <- nrow(regression.modelle$gespeicherte.forecasts[[2]])
    hZwei <- nrow(var.modelle$gespeicherte.forecasts.var[[2]])
    h <- min(hEins, hZwei)
    
    windowTs<-xts(daten.under$data.train[,-1], daten.under$data.train[[1]])
    forecastingTs <- xts(daten.under$data.test[,-1][1:h,], daten.under$data.test[[1]][1:h])
    
    RWfcst = rwf(windowTs[,input$depVar], h=h, drift=FALSE)
    Rw.forecastTs <-xts(as.data.frame(RWfcst$mean), daten.under$data.test[[1]][1:h])
    rw.diff <- abs(Rw.forecastTs[,1]-forecastingTs[,input$depVar])
    
    mreg.forecastTs<- xts(regression.modelle$gespeicherte.forecasts[[2]][,2][1:h], regression.modelle$gespeicherte.forecasts[[2]][,1][1:h])
    mreg.diff <- abs(mreg.forecastTs[,1] -forecastingTs[,input$depVar])
    
    var.forecastTs<- xts(var.modelle$gespeicherte.forecasts.var[[2]][,2][1:h], var.modelle$gespeicherte.forecasts.var[[2]][,1][1:h])
    var.diff <- abs(var.forecastTs[,1] -forecastingTs[,input$depVar])
    
    backtest$timeOnestepahead <- cbind(xts(daten.under$default[, input$depVar], start$dates), Rw.forecastTs, mreg.forecastTs, var.forecastTs) 
    
    RMSEonestepahead<-cbind(rw.diff, mreg.diff, var.diff)
    
    colnames(RMSEonestepahead)<-c("RW","MReg", "VAR")
    colnames(backtest$timeOnestepahead)<-c(input$depVar,"RW", "MReg", "VAR")
    
  }
  
  if(backtest$choosemodelbacktestOnestep  == 20){
    
    hEins <- nrow(regression.modelle$gespeicherte.forecasts[[2]])
    hZwei <- nrow(var.modelle$gespeicherte.forecasts.restvar[[2]])
    h <- min(hEins, hZwei)
    
    windowTs<-xts(daten.under$data.train[,-1], daten.under$data.train[[1]])
    forecastingTs <- xts(daten.under$data.test[,-1][1:h,], daten.under$data.test[[1]][1:h])
    
    RWfcst = rwf(windowTs[,input$depVar], h=h, drift=FALSE)
    Rw.forecastTs <-xts(as.data.frame(RWfcst$mean), daten.under$data.test[[1]][1:h])
    rw.diff <- abs(Rw.forecastTs[,1]-forecastingTs[,input$depVar])
    
    mreg.forecastTs<- xts(regression.modelle$gespeicherte.forecasts[[2]][,2][1:h], regression.modelle$gespeicherte.forecasts[[2]][,1][1:h])
    mreg.diff <- abs(mreg.forecastTs[,1] -forecastingTs[,input$depVar])
    
    restvar.forecastTs<- xts(var.modelle$gespeicherte.forecasts.restvar[[2]][,2][1:h], var.modelle$gespeicherte.forecasts.restvar[[2]][,1][1:h])
    restvar.diff <- abs(restvar.forecastTs[,1] -forecastingTs[,input$depVar])
    
    backtest$timeOnestepahead <- cbind(xts(daten.under$default[, input$depVar], start$dates), Rw.forecastTs, mreg.forecastTs, restvar.forecastTs) 
    
    RMSEonestepahead<-cbind(rw.diff, mreg.diff, restvar.diff)
    
    colnames(RMSEonestepahead)<-c("RW","MReg", "Restr.VAR")
    colnames(backtest$timeOnestepahead)<-c(input$depVar,"RW", "MReg", "Restr.VAR")
    
  }
  
  
  if(backtest$choosemodelbacktestOnestep  == 21){
    
    hEins <- nrow(var.modelle$gespeicherte.forecasts.var[[2]])
    hZwei <- nrow(var.modelle$gespeicherte.forecasts.restvar[[2]])
    h <- min(hEins, hZwei)
    
    
    
    windowTs<-xts(daten.under$data.train[,-1], daten.under$data.train[[1]])
    forecastingTs <- xts(daten.under$data.test[,-1][1:h,], daten.under$data.test[[1]][1:h])
    
    RWfcst = rwf(windowTs[,input$depVar], h=h, drift=FALSE)
    Rw.forecastTs <-xts(as.data.frame(RWfcst$mean), daten.under$data.test[[1]][1:h])
    rw.diff <- abs(Rw.forecastTs[,1]-forecastingTs[,input$depVar])
    
    var.forecastTs<- xts(var.modelle$gespeicherte.forecasts.var[[2]][,2][1:h], var.modelle$gespeicherte.forecasts.var[[2]][,1][1:h])
    var.diff <- abs(var.forecastTs[,1] -forecastingTs[,input$depVar])
    
    restvar.forecastTs<- xts(var.modelle$gespeicherte.forecasts.restvar[[2]][,2][1:h], var.modelle$gespeicherte.forecasts.restvar[[2]][,1][1:h])
    restvar.diff <- abs(restvar.forecastTs[,1] -forecastingTs[,input$depVar])
    
    backtest$timeOnestepahead <- cbind(xts(daten.under$default[, input$depVar], start$dates), Rw.forecastTs, var.forecastTs, restvar.forecastTs) 
    
    RMSEonestepahead<-cbind(rw.diff, var.diff, restvar.diff)
    
    colnames(RMSEonestepahead)<-c("RW","VAR", "Restr.VAR")
    colnames(backtest$timeOnestepahead)<-c(input$depVar, "RW","VAR", "Restr.VAR")
    
  }
  
  if(backtest$choosemodelbacktestOnestep  == 22){
    
    hEins <- nrow(var.modelle$gespeicherte.forecasts.var[[2]])
    hZwei <- nrow(var.modelle$gespeicherte.forecasts.restvar[[2]])
    hDrei <- nrow(regression.modelle$gespeicherte.forecasts[[2]])
    h <- min(hEins, hZwei, hDrei)
    
    
    
    windowTs<-xts(daten.under$data.train[,-1], daten.under$data.train[[1]])
    forecastingTs <- xts(daten.under$data.test[,-1][1:h,], daten.under$data.test[[1]][1:h])
    
    mreg.forecastTs<- xts(regression.modelle$gespeicherte.forecasts[[2]][,2][1:h], regression.modelle$gespeicherte.forecasts[[2]][,1][1:h])
    mreg.diff <- abs(mreg.forecastTs[,1] -forecastingTs[,input$depVar])
    
    var.forecastTs<- xts(var.modelle$gespeicherte.forecasts.var[[2]][,2][1:h], var.modelle$gespeicherte.forecasts.var[[2]][,1][1:h])
    var.diff <- abs(var.forecastTs[,1] -forecastingTs[,input$depVar])
    
    restvar.forecastTs<- xts(var.modelle$gespeicherte.forecasts.restvar[[2]][,2][1:h], var.modelle$gespeicherte.forecasts.restvar[[2]][,1][1:h])
    restvar.diff <- abs(restvar.forecastTs[,1] -forecastingTs[,input$depVar])
    
    backtest$timeOnestepahead <- cbind(xts(daten.under$default[, input$depVar], start$dates), mreg.forecastTs, var.forecastTs, restvar.forecastTs) 
    
    RMSEonestepahead<-cbind(mreg.diff, var.diff, restvar.diff)
    
    colnames(RMSEonestepahead)<-c("MReg","VAR", "Restr.VAR")
    colnames(backtest$timeOnestepahead)<-c(input$depVar, "MReg","VAR", "Restr.VAR")
    
  }
  
  if(backtest$choosemodelbacktestOnestep  == 23){
    
    hEins <- nrow(var.modelle$gespeicherte.forecasts.var[[2]])
    hZwei <- nrow(var.modelle$gespeicherte.forecasts.restvar[[2]])
    hDrei <- nrow(regression.modelle$gespeicherte.forecasts[[2]])
    h <- min(hEins, hZwei, hDrei)
    
    
    
    windowTs<-xts(daten.under$data.train[,-1], daten.under$data.train[[1]])
    forecastingTs <- xts(daten.under$data.test[,-1][1:h,], daten.under$data.test[[1]][1:h])
    
    ARIMAmodel = auto.arima(windowTs[,input$depVar],seasonal = FALSE)
    ARIMAfcast <- forecast(ARIMAmodel, h=h)
    arima.forecastTs <- xts(as.data.frame(ARIMAfcast$mean), daten.under$data.test[[1]][1:h])
    arima.diff <- abs(arima.forecastTs[,1] -forecastingTs[,input$depVar])
    
    mreg.forecastTs<- xts(regression.modelle$gespeicherte.forecasts[[2]][,2][1:h], regression.modelle$gespeicherte.forecasts[[2]][,1][1:h])
    mreg.diff <- abs(mreg.forecastTs[,1] -forecastingTs[,input$depVar])
    
    var.forecastTs<- xts(var.modelle$gespeicherte.forecasts.var[[2]][,2][1:h], var.modelle$gespeicherte.forecasts.var[[2]][,1][1:h])
    var.diff <- abs(var.forecastTs[,1] -forecastingTs[,input$depVar])
    
    restvar.forecastTs<- xts(var.modelle$gespeicherte.forecasts.restvar[[2]][,2][1:h], var.modelle$gespeicherte.forecasts.restvar[[2]][,1][1:h])
    restvar.diff <- abs(restvar.forecastTs[,1] -forecastingTs[,input$depVar])
    
    backtest$timeOnestepahead <- cbind(xts(daten.under$default[, input$depVar], start$dates), arima.forecastTs, mreg.forecastTs, var.forecastTs, restvar.forecastTs) 
    
    RMSEonestepahead<-cbind(arima.diff, mreg.diff, var.diff, restvar.diff)
    
    colnames(RMSEonestepahead)<-c("ARIMA","MReg","VAR", "Restr.VAR")
    colnames(backtest$timeOnestepahead)<-c(input$depVar, "ARIMA","MReg","VAR", "Restr.VAR")
    
  }
  
  if(backtest$choosemodelbacktestOnestep  == 24){
    
    hEins <- nrow(var.modelle$gespeicherte.forecasts.var[[2]])
    hZwei <- nrow(var.modelle$gespeicherte.forecasts.restvar[[2]])
    hDrei <- nrow(regression.modelle$gespeicherte.forecasts[[2]])
    h <- min(hEins, hZwei, hDrei)
    
    
    
    windowTs<-xts(daten.under$data.train[,-1], daten.under$data.train[[1]])
    forecastingTs <- xts(daten.under$data.test[,-1][1:h,], daten.under$data.test[[1]][1:h])
    
    RWfcst = rwf(windowTs[,input$depVar], h=h, drift=FALSE)
    Rw.forecastTs <-xts(as.data.frame(RWfcst$mean), daten.under$data.test[[1]][1:h])
    rw.diff <- abs(Rw.forecastTs[,1]-forecastingTs[,input$depVar])
    
    ARIMAmodel = auto.arima(windowTs[,input$depVar],seasonal = FALSE)
    ARIMAfcast <- forecast(ARIMAmodel, h=h)
    arima.forecastTs <- xts(as.data.frame(ARIMAfcast$mean), daten.under$data.test[[1]][1:h])
    arima.diff <- abs(arima.forecastTs[,1] -forecastingTs[,input$depVar])
    
    mreg.forecastTs<- xts(regression.modelle$gespeicherte.forecasts[[2]][,2][1:h], regression.modelle$gespeicherte.forecasts[[2]][,1][1:h])
    mreg.diff <- abs(mreg.forecastTs[,1] -forecastingTs[,input$depVar])
    
    var.forecastTs<- xts(var.modelle$gespeicherte.forecasts.var[[2]][,2][1:h], var.modelle$gespeicherte.forecasts.var[[2]][,1][1:h])
    var.diff <- abs(var.forecastTs[,1] -forecastingTs[,input$depVar])
    
    restvar.forecastTs<- xts(var.modelle$gespeicherte.forecasts.restvar[[2]][,2][1:h], var.modelle$gespeicherte.forecasts.restvar[[2]][,1][1:h])
    restvar.diff <- abs(restvar.forecastTs[,1] -forecastingTs[,input$depVar])
    
    backtest$timeOnestepahead <- cbind(xts(daten.under$default[, input$depVar], start$dates), Rw.forecastTs, arima.forecastTs, var.forecastTs, restvar.forecastTs) 
    
    RMSEonestepahead<-cbind(rw.diff, mreg.diff, var.diff, restvar.diff)
    
    colnames(RMSEonestepahead)<-c("RW","MReg","VAR", "Restr.VAR")
    colnames(backtest$timeOnestepahead)<-c(input$depVar, "RW","MReg","VAR", "Restr.VAR")
    
  }
  
  if(backtest$choosemodelbacktestOnestep  == 25){
    
    hEins <- nrow(var.modelle$gespeicherte.forecasts.var[[2]])
    hZwei <- nrow(var.modelle$gespeicherte.forecasts.restvar[[2]])
    h <- min(hEins, hZwei)
    
    
    
    windowTs<-xts(daten.under$data.train[,-1], daten.under$data.train[[1]])
    forecastingTs <- xts(daten.under$data.test[,-1][1:h,], daten.under$data.test[[1]][1:h])
    
    RWfcst = rwf(windowTs[,input$depVar], h=h, drift=FALSE)
    Rw.forecastTs <-xts(as.data.frame(RWfcst$mean), daten.under$data.test[[1]][1:h])
    rw.diff <- abs(Rw.forecastTs[,1]-forecastingTs[,input$depVar])
    
    ARIMAmodel = auto.arima(windowTs[,input$depVar],seasonal = FALSE)
    ARIMAfcast <- forecast(ARIMAmodel, h=h)
    arima.forecastTs <- xts(as.data.frame(ARIMAfcast$mean), daten.under$data.test[[1]][1:h])
    arima.diff <- abs(arima.forecastTs[,1] -forecastingTs[,input$depVar])
    
    var.forecastTs<- xts(var.modelle$gespeicherte.forecasts.var[[2]][,2][1:h], var.modelle$gespeicherte.forecasts.var[[2]][,1][1:h])
    var.diff <- abs(var.forecastTs[,1] -forecastingTs[,input$depVar])
    
    restvar.forecastTs<- xts(var.modelle$gespeicherte.forecasts.restvar[[2]][,2][1:h], var.modelle$gespeicherte.forecasts.restvar[[2]][,1][1:h])
    restvar.diff <- abs(restvar.forecastTs[,1] -forecastingTs[,input$depVar])
    
    backtest$timeOnestepahead <- cbind(xts(daten.under$default[, input$depVar], start$dates), Rw.forecastTs, arima.forecastTs, var.forecastTs, restvar.forecastTs) 
    
    RMSEonestepahead<-cbind(rw.diff, arima.diff, var.diff, restvar.diff)
    
    colnames(RMSEonestepahead)<-c("RW","ARIMA","VAR", "Restr.VAR")
    colnames(backtest$timeOnestepahead)<-c(input$depVar, "RW","ARIMA","VAR", "Restr.VAR")
    
  }
  
  if(backtest$choosemodelbacktestOnestep  == 26){
    
    hZwei <- nrow(var.modelle$gespeicherte.forecasts.restvar[[2]])
    hDrei <- nrow(regression.modelle$gespeicherte.forecasts[[2]])
    h <- min(hZwei, hDrei)
    
    
    
    windowTs<-xts(daten.under$data.train[,-1], daten.under$data.train[[1]])
    forecastingTs <- xts(daten.under$data.test[,-1][1:h,], daten.under$data.test[[1]][1:h])
    
    RWfcst = rwf(windowTs[,input$depVar], h=h, drift=FALSE)
    Rw.forecastTs <-xts(as.data.frame(RWfcst$mean), daten.under$data.test[[1]][1:h])
    rw.diff <- abs(Rw.forecastTs[,1]-forecastingTs[,input$depVar])
    
    ARIMAmodel = auto.arima(windowTs[,input$depVar],seasonal = FALSE)
    ARIMAfcast <- forecast(ARIMAmodel, h=h)
    arima.forecastTs <- xts(as.data.frame(ARIMAfcast$mean), daten.under$data.test[[1]][1:h])
    arima.diff <- abs(arima.forecastTs[,1] -forecastingTs[,input$depVar])
    
    mreg.forecastTs<- xts(regression.modelle$gespeicherte.forecasts[[2]][,2][1:h], regression.modelle$gespeicherte.forecasts[[2]][,1][1:h])
    mreg.diff <- abs(mreg.forecastTs[,1] -forecastingTs[,input$depVar])
    
    restvar.forecastTs<- xts(var.modelle$gespeicherte.forecasts.restvar[[2]][,2][1:h], var.modelle$gespeicherte.forecasts.restvar[[2]][,1][1:h])
    restvar.diff <- abs(restvar.forecastTs[,1] -forecastingTs[,input$depVar])
    
    backtest$timeOnestepahead <- cbind(xts(daten.under$default[, input$depVar], start$dates), Rw.forecastTs, arima.forecastTs, mreg.forecastTs, restvar.forecastTs) 
    
    RMSEonestepahead<-cbind(rw.diff, arima.diff, mreg.diff, restvar.diff)
    
    colnames(RMSEonestepahead)<-c("RW","ARIMA","MReg", "Restr.VAR")
    colnames(backtest$timeOnestepahead)<-c(input$depVar, "RW","ARIMA","MReg", "Restr.VAR")
    
  }
  
  if(backtest$choosemodelbacktestOnestep  == 27){
    
    hZwei <- nrow(var.modelle$gespeicherte.forecasts.var[[2]])
    hDrei <- nrow(regression.modelle$gespeicherte.forecasts[[2]])
    h <- min(hZwei, hDrei)
    
    
    
    windowTs<-xts(daten.under$data.train[,-1], daten.under$data.train[[1]])
    forecastingTs <- xts(daten.under$data.test[,-1][1:h,], daten.under$data.test[[1]][1:h])
    
    RWfcst = rwf(windowTs[,input$depVar], h=h, drift=FALSE)
    Rw.forecastTs <-xts(as.data.frame(RWfcst$mean), daten.under$data.test[[1]][1:h])
    rw.diff <- abs(Rw.forecastTs[,1]-forecastingTs[,input$depVar])
    
    ARIMAmodel = auto.arima(windowTs[,input$depVar],seasonal = FALSE)
    ARIMAfcast <- forecast(ARIMAmodel, h=h)
    arima.forecastTs <- xts(as.data.frame(ARIMAfcast$mean), daten.under$data.test[[1]][1:h])
    arima.diff <- abs(arima.forecastTs[,1] -forecastingTs[,input$depVar])
    
    mreg.forecastTs<- xts(regression.modelle$gespeicherte.forecasts[[2]][,2][1:h], regression.modelle$gespeicherte.forecasts[[2]][,1][1:h])
    mreg.diff <- abs(mreg.forecastTs[,1] -forecastingTs[,input$depVar])
    
    var.forecastTs<- xts(var.modelle$gespeicherte.forecasts.var[[2]][,2][1:h], var.modelle$gespeicherte.forecasts.var[[2]][,1][1:h])
    var.diff <- abs(var.forecastTs[,1] -forecastingTs[,input$depVar])
    
    backtest$timeOnestepahead <- cbind(xts(daten.under$default[, input$depVar], start$dates), Rw.forecastTs, arima.forecastTs, mreg.forecastTs, var.forecastTs) 
    
    RMSEonestepahead<-cbind(rw.diff, arima.diff, mreg.diff, var.diff)
    
    colnames(RMSEonestepahead)<-c("RW","ARIMA","MReg", "VAR")
    colnames(backtest$timeOnestepahead)<-c(input$depVar, "RW","ARIMA","MReg", "VAR")
    
  }
  
  if(backtest$choosemodelbacktestOnestep  == 27){
    
    hEins <- nrow(regression.modelle$gespeicherte.forecasts[[2]])
    hZwei <- nrow(var.modelle$gespeicherte.forecasts.var[[2]])
    h <- min(hEins, hZwei)
    
    windowTs<-xts(daten.under$data.train[,-1], daten.under$data.train[[1]])
    forecastingTs <- xts(daten.under$data.test[,-1][1:h,], daten.under$data.test[[1]][1:h])
    
    RWfcst = rwf(windowTs[,input$depVar], h=h, drift=FALSE)
    Rw.forecastTs <-xts(as.data.frame(RWfcst$mean), daten.under$data.test[[1]][1:h])
    rw.diff <- abs(Rw.forecastTs[,1]-forecastingTs[,input$depVar])
    
    ARIMAmodel = auto.arima(windowTs[,input$depVar],seasonal = FALSE)
    ARIMAfcast <- forecast(ARIMAmodel, h=h)
    arima.forecastTs <- xts(as.data.frame(ARIMAfcast$mean), daten.under$data.test[[1]][1:h])
    arima.diff <- abs(arima.forecastTs[,1] -forecastingTs[,input$depVar])
    
    mreg.forecastTs<- xts(regression.modelle$gespeicherte.forecasts[[2]][,2][1:h], regression.modelle$gespeicherte.forecasts[[2]][,1][1:h])
    mreg.diff <- abs(mreg.forecastTs[,1] -forecastingTs[,input$depVar])
    
    var.forecastTs<- xts(var.modelle$gespeicherte.forecasts.var[[2]][,2][1:h], var.modelle$gespeicherte.forecasts.var[[2]][,1][1:h])
    var.diff <- abs(var.forecastTs[,1] -forecastingTs[,input$depVar])
    
    backtest$timeOnestepahead <- cbind(xts(daten.under$default[, input$depVar], start$dates), Rw.forecastTs, arima.forecastTs, mreg.forecastTs, var.forecastTs) 
    
    RMSEonestepahead<-cbind(rw.diff, arima.diff, mreg.diff, var.diff)
    
    colnames(RMSEonestepahead)<-c("RW", "ARIMA","MReg", "VAR")
    colnames(backtest$timeOnestepahead)<-c(input$depVar,"RW","ARIMA", "MReg", "VAR")
    
  }
  
  
  if(backtest$choosemodelbacktestOnestep  == 28){
    
    hEins <- nrow(var.modelle$gespeicherte.forecasts.var[[2]])
    hZwei <- nrow(var.modelle$gespeicherte.forecasts.restvar[[2]])
    h <- min(hEins, hZwei)
    
    
    
    windowTs<-xts(daten.under$data.train[,-1], daten.under$data.train[[1]])
    forecastingTs <- xts(daten.under$data.test[,-1][1:h,], daten.under$data.test[[1]][1:h])
    
    ARIMAmodel = auto.arima(windowTs[,input$depVar],seasonal = FALSE)
    ARIMAfcast <- forecast(ARIMAmodel, h=h)
    arima.forecastTs <- xts(as.data.frame(ARIMAfcast$mean), daten.under$data.test[[1]][1:h])
    arima.diff <- abs(arima.forecastTs[,1] -forecastingTs[,input$depVar])
    
    var.forecastTs<- xts(var.modelle$gespeicherte.forecasts.var[[2]][,2][1:h], var.modelle$gespeicherte.forecasts.var[[2]][,1][1:h])
    var.diff <- abs(var.forecastTs[,1] -forecastingTs[,input$depVar])
    
    restvar.forecastTs<- xts(var.modelle$gespeicherte.forecasts.restvar[[2]][,2][1:h], var.modelle$gespeicherte.forecasts.restvar[[2]][,1][1:h])
    restvar.diff <- abs(restvar.forecastTs[,1] -forecastingTs[,input$depVar])
    
    backtest$timeOnestepahead <- cbind(xts(daten.under$default[, input$depVar], start$dates), arima.forecastTs, var.forecastTs, restvar.forecastTs) 
    
    RMSEonestepahead<-cbind(arima.diff, var.diff, restvar.diff)
    
    colnames(RMSEonestepahead)<-c("ARIMA","VAR", "Restr.VAR")
    colnames(backtest$timeOnestepahead)<-c(input$depVar, "ARIMA","VAR", "Restr.VAR")
    
  }
  
  
  if(backtest$choosemodelbacktestOnestep  == 29){
    
    hEins <- nrow(regression.modelle$gespeicherte.forecasts[[2]])
    hZwei <- nrow(var.modelle$gespeicherte.forecasts.restvar[[2]])
    h <- min(hEins, hZwei)
    
    windowTs<-xts(daten.under$data.train[,-1], daten.under$data.train[[1]])
    forecastingTs <- xts(daten.under$data.test[,-1][1:h,], daten.under$data.test[[1]][1:h])
    
    ARIMAmodel = auto.arima(windowTs[,input$depVar],seasonal = FALSE)
    ARIMAfcast <- forecast(ARIMAmodel, h=h)
    arima.forecastTs <- xts(as.data.frame(ARIMAfcast$mean), daten.under$data.test[[1]][1:h])
    arima.diff <- abs(arima.forecastTs[,1] -forecastingTs[,input$depVar])
    
    mreg.forecastTs<- xts(regression.modelle$gespeicherte.forecasts[[2]][,2][1:h], regression.modelle$gespeicherte.forecasts[[2]][,1][1:h])
    mreg.diff <- abs(mreg.forecastTs[,1] -forecastingTs[,input$depVar])
    
    restvar.forecastTs<- xts(var.modelle$gespeicherte.forecasts.restvar[[2]][,2][1:h], var.modelle$gespeicherte.forecasts.restvar[[2]][,1][1:h])
    restvar.diff <- abs(restvar.forecastTs[,1] -forecastingTs[,input$depVar])
    
    backtest$timeOnestepahead <- cbind(xts(daten.under$default[, input$depVar], start$dates), arima.forecastTs, mreg.forecastTs, restvar.forecastTs) 
    
    RMSEonestepahead<-cbind(arima.diff, mreg.diff, restvar.diff)
    
    colnames(RMSEonestepahead)<-c("ARIMA","MReg", "Restr.VAR")
    colnames(backtest$timeOnestepahead)<-c(input$depVar,"ARIMA", "MReg", "Restr.VAR")
    
  }
  
  
  if(backtest$choosemodelbacktestOnestep  == 30){
    
    hEins <- nrow(regression.modelle$gespeicherte.forecasts[[2]])
    hZwei <- nrow(var.modelle$gespeicherte.forecasts.var[[2]])
    h <- min(hEins, hZwei)
    
    windowTs<-xts(daten.under$data.train[,-1], daten.under$data.train[[1]])
    forecastingTs <- xts(daten.under$data.test[,-1][1:h,], daten.under$data.test[[1]][1:h])
    
    ARIMAmodel = auto.arima(windowTs[,input$depVar],seasonal = FALSE)
    ARIMAfcast <- forecast(ARIMAmodel, h=h)
    arima.forecastTs <- xts(as.data.frame(ARIMAfcast$mean), daten.under$data.test[[1]][1:h])
    arima.diff <- abs(arima.forecastTs[,1] -forecastingTs[,input$depVar])
    
    mreg.forecastTs<- xts(regression.modelle$gespeicherte.forecasts[[2]][,2][1:h], regression.modelle$gespeicherte.forecasts[[2]][,1][1:h])
    mreg.diff <- abs(mreg.forecastTs[,1] -forecastingTs[,input$depVar])
    
    var.forecastTs<- xts(var.modelle$gespeicherte.forecasts.var[[2]][,2][1:h], var.modelle$gespeicherte.forecasts.var[[2]][,1][1:h])
    var.diff <- abs(var.forecastTs[,1] -forecastingTs[,input$depVar])
    
    backtest$timeOnestepahead <- cbind(xts(daten.under$default[, input$depVar], start$dates), arima.forecastTs, mreg.forecastTs, var.forecastTs) 
    
    RMSEonestepahead<-cbind(arima.diff, mreg.diff, var.diff)
    
    colnames(RMSEonestepahead)<-c("ARIMA","MReg", "VAR")
    colnames(backtest$timeOnestepahead)<-c(input$depVar,"ARIMA", "MReg", "VAR")
    
  }
  
  if(backtest$choosemodelbacktestOnestep  == 31){
    
    hEins <- nrow(regression.modelle$gespeicherte.forecasts[[2]])
    hZwei <- nrow(var.modelle$gespeicherte.forecasts.var[[2]])
    h <- min(hEins, hZwei)
    
    windowTs<-xts(daten.under$data.train[,-1], daten.under$data.train[[1]])
    forecastingTs <- xts(daten.under$data.test[,-1][1:h,], daten.under$data.test[[1]][1:h])
    
    RWfcst = rwf(windowTs[,input$depVar], h=h, drift=FALSE)
    Rw.forecastTs <-xts(as.data.frame(RWfcst$mean), daten.under$data.test[[1]][1:h])
    rw.diff <- abs(Rw.forecastTs[,1]-forecastingTs[,input$depVar])
    
    ARIMAmodel = auto.arima(windowTs[,input$depVar],seasonal = FALSE)
    ARIMAfcast <- forecast(ARIMAmodel, h=h)
    arima.forecastTs <- xts(as.data.frame(ARIMAfcast$mean), daten.under$data.test[[1]][1:h])
    arima.diff <- abs(arima.forecastTs[,1] -forecastingTs[,input$depVar])
    
    mreg.forecastTs<- xts(regression.modelle$gespeicherte.forecasts[[2]][,2][1:h], regression.modelle$gespeicherte.forecasts[[2]][,1][1:h])
    mreg.diff <- abs(mreg.forecastTs[,1] -forecastingTs[,input$depVar])
    
    var.forecastTs<- xts(var.modelle$gespeicherte.forecasts.var[[2]][,2][1:h], var.modelle$gespeicherte.forecasts.var[[2]][,1][1:h])
    var.diff <- abs(var.forecastTs[,1] -forecastingTs[,input$depVar])
    
    restvar.forecastTs<- xts(var.modelle$gespeicherte.forecasts.restvar[[2]][,2][1:h], var.modelle$gespeicherte.forecasts.restvar[[2]][,1][1:h])
    restvar.diff <- abs(restvar.forecastTs[,1] -forecastingTs[,input$depVar])
    
    backtest$timeOnestepahead <- cbind(xts(daten.under$default[, input$depVar], start$dates), Rw.forecastTs, arima.forecastTs, mreg.forecastTs, var.forecastTs, restvar.forecastTs) 
    
    RMSEonestepahead<-cbind(rw.diff, arima.diff, mreg.diff, var.diff, restvar.diff)
    
    colnames(RMSEonestepahead)<-c("RW","ARIMA","MReg", "VAR", "Restr.VAR")
    colnames(backtest$timeOnestepahead)<-c(input$depVar,"RW","ARIMA", "MReg", "VAR", "Restr.VAR")
    
  }
  
  
  

  for(i in 1:(length(input$choosebacktestmodelOnestep))){
    backtest$timeOnestepahead[nrow(backtest$timeOnestepahead) - nrow(daten.under$data.test),i+1] <- backtest$timeOnestepahead[nrow(backtest$timeOnestepahead) - nrow(daten.under$data.test), 1]
  }
  
  RMSEonestepahead
  
})

output$graphOnestepahead.rmse <- renderDygraph({
  
    if (is.null(RMSEonestepahead())) { return()}
    
    
    outgraph <- dygraph(RMSEonestepahead(),
                        main = "Root Mean Squared Error") %>%
      dyAxis("y", label = "RMSE") %>%
      dyLegend(width = 600) %>%
      dyRangeSelector()
    
})


output$Onesteprmseplot <- renderPlotly({
  if (is.null(RMSEonestepahead())) { return()}  
  
  meanrmse<<- apply(RMSEonestepahead(), 2, mean)
  
  plot <- plot_ly(
    x = c(names(meanrmse)),
    y = meanrmse, 
    type = "bar"
  )
  
  layout(plot, title = "Mean RMSE", yaxis = list(title = ""), xaxis = list(title = "", autorange = F,
                         autotick = F))
  

  
})


output$graphtimeOnestepahead <- renderDygraph({
  
  if(identical(backtest$timeOnestepahead, 0)){ return()}
    outgraph <- dygraph(backtest$timeOnestepahead,
                        main = "Actual model compared to forecasts") %>%
      dyLegend(width = 600) %>%
      dyAxis("y", label = input$depVar) %>%
      dyRangeSelector()
})

