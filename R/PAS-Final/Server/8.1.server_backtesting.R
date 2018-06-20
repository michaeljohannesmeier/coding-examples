#######################################################################
#######################################################################

## 8. Backtesting ##

backtest<-reactiveValues(
  
  
  choosemodelbacktest = 0,
  hstepmeans = 0,
  tsfitted = 0, 
  dyevents = 0
)

output$checkboxgroupbacktest<- renderUI({
  

  
  if(length(var.modelle$gespeicherte.expl.modelle.var) == 0 &
     length(var.modelle$gespeicherte.expl.modelle.restvar) == 0 & 
     length(regression.modelle$gespeichertes.modell) == 1){
    return(checkboxGroupInput("choosebacktestmodel", "Choose forecasts for backtest:",
                              c("RW" = "RW",
                                "ARIMA" = "ARIMA")))
    }
   
  if(length(var.modelle$gespeicherte.expl.modelle.var) == 0 &
     length(var.modelle$gespeicherte.expl.modelle.restvar) == 0 & 
     length(regression.modelle$gespeichertes.modell) > 1){
          return(checkboxGroupInput("choosebacktestmodel", "Choose forecasts for backtest:",
                       c("RW" = "RW",
                         "ARIMA" = "ARIMA",
                         "MReg" = "MReg")))
  }
          
    if(length(var.modelle$gespeicherte.expl.modelle.var) > 0 &
       length(var.modelle$gespeicherte.expl.modelle.restvar) == 0 & 
       length(regression.modelle$gespeichertes.modell) == 1){
      return(checkboxGroupInput("choosebacktestmodel", "Choose forecasts for backtest:",
                                c("RW" = "RW",
                                  "ARIMA" = "ARIMA",
                                  "VAR" = "VAR")))
    }
  
  if(length(var.modelle$gespeicherte.expl.modelle.var) > 0 &
     length(var.modelle$gespeicherte.expl.modelle.restvar) == 0 & 
     length(regression.modelle$gespeichertes.modell) > 1){
    return(checkboxGroupInput("choosebacktestmodel", "Choose forecasts for backtest:",
                              c("RW" = "RW",
                                "ARIMA" = "ARIMA",
                                "MReg" = "MReg", 
                                "VAR" = "VAR")))
  }
  
  if(length(var.modelle$gespeicherte.expl.modelle.var) == 0 &
     length(var.modelle$gespeicherte.expl.modelle.restvar) > 0 & 
     length(regression.modelle$gespeichertes.modell) > 1){
    return(checkboxGroupInput("choosebacktestmodel", "Choose forecasts for backtest:",
                              c("RW" = "RW",
                                "ARIMA" = "ARIMA",
                                "MReg" = "MReg",
                                "Restr.VAR" = "Restr.VAR")))
  }
  
  if(length(var.modelle$gespeicherte.expl.modelle.var) > 0 &
     length(var.modelle$gespeicherte.expl.modelle.restvar) > 0 & 
     length(regression.modelle$gespeichertes.modell) == 1){
    return(checkboxGroupInput("choosebacktestmodel", "Choose forecasts for backtest:",
                              c("RW" = "RW",
                                "ARIMA" = "ARIMA",
                                "VAR" = "VAR",
                                "Restr.VAR" = "Restr.VAR")))
  }
  
  if(length(var.modelle$gespeicherte.expl.modelle.var) == 0 &
     length(var.modelle$gespeicherte.expl.modelle.restvar) > 0 & 
     length(regression.modelle$gespeichertes.modell) == 1){
    return(checkboxGroupInput("choosebacktestmodel", "Choose forecasts for backtest:",
                              c("RW" = "RW",
                                "ARIMA" = "ARIMA",
                                "Restr.VAR" = "Restr.VAR")))
  }
  
  
    if(length(var.modelle$gespeicherte.expl.modelle.var) > 0 &
       length(var.modelle$gespeicherte.expl.modelle.restvar) > 0 & 
       length(regression.modelle$gespeichertes.modell) > 1){
      return(checkboxGroupInput("choosebacktestmodel", "Choose forecasts for backtest:",
                                c("RW" = "RW",
                                  "ARIMA" = "ARIMA",
                                  "MReg" = "MReg",
                                  "VAR" = "VAR",
                                  "Restr.VAR" = "Restr.VAR")))
    }
  
})



RMSE <- eventReactive(input$BACK, {

  if(is.null(input$selectHorizont)){return(withProgress(message = "Choose proper horizont",Sys.sleep(2)))}
  if(input$selectHorizont < 1 | is.numeric(input$selectHorizont == FALSE)){return(withProgress(message = "Choose proper horizont",Sys.sleep(2)))}
  if(input$selectHorizont > nrow(daten.under$data.train)){return(withProgress(message = "Choose proper horizont",Sys.sleep(2)))}
  
  
  if(is.null(input$choosebacktestmodel)){return(withProgress(message = "No explanation models saved",Sys.sleep(2)))}
  
  collapsedinput<- paste(input$choosebacktestmodel, collapse = " ")
  
  if(collapsedinput == "RW"){backtest$choosemodelbacktest <-1}
  if(collapsedinput == "ARIMA"){backtest$choosemodelbacktest <-2}
  if(collapsedinput == "MReg"){backtest$choosemodelbacktest <-3}
  if(collapsedinput == "VAR"){backtest$choosemodelbacktest <-4}
  if(collapsedinput == "Restr.VAR"){backtest$choosemodelbacktest <-5}
  if(collapsedinput == "RW ARIMA"){backtest$choosemodelbacktest <-6}
  if(collapsedinput == "RW MReg"){backtest$choosemodelbacktest <-7}
  if(collapsedinput == "RW VAR"){backtest$choosemodelbacktest <-8}
  if(collapsedinput == "RW Restr.VAR"){backtest$choosemodelbacktest <-9}
  if(collapsedinput == "ARIMA MReg"){backtest$choosemodelbacktest <-10}
  if(collapsedinput == "ARIMA VAR"){backtest$choosemodelbacktest <-11}
  if(collapsedinput == "ARIMA Restr.VAR"){backtest$choosemodelbacktest <-12}
  if(collapsedinput == "MReg VAR"){backtest$choosemodelbacktest <-13}
  if(collapsedinput == "MReg Restr.VAR"){backtest$choosemodelbacktest <-14}
  if(collapsedinput == "VAR Restr.VAR"){backtest$choosemodelbacktest <-15}
  if(collapsedinput == "RW ARIMA MReg"){backtest$choosemodelbacktest <-16}
  if(collapsedinput == "RW ARIMA VAR"){backtest$choosemodelbacktest <-17}
  if(collapsedinput == "RW ARIMA Restr.VAR"){backtest$choosemodelbacktest <-18}
  if(collapsedinput == "RW MReg VAR"){backtest$choosemodelbacktest <-19}
  if(collapsedinput == "RW MReg Restr.VAR"){backtest$choosemodelbacktest <-20}
  if(collapsedinput == "RW VAR Restr.VAR"){backtest$choosemodelbacktest <-21}
  if(collapsedinput == "MReg VAR Restr.VAR"){backtest$choosemodelbacktest <-22}
  if(collapsedinput == "ARIMA MReg VAR Restr.VAR"){backtest$choosemodelbacktest <-23}
  if(collapsedinput == "RW MReg VAR Restr.VAR"){backtest$choosemodelbacktest <-24}
  if(collapsedinput == "RW ARIMA VAR Restr.VAR"){backtest$choosemodelbacktest <-25}
  if(collapsedinput == "RW ARIMA MReg Restr.VAR"){backtest$choosemodelbacktest <-26}
  if(collapsedinput == "RW ARIMA MReg VAR"){backtest$choosemodelbacktest <-27}
  if(collapsedinput == "ARIMA VAR Restr.VAR"){backtest$choosemodelbacktest <-28}
  if(collapsedinput == "ARIMA MReg Restr.VAR"){backtest$choosemodelbacktest <-29}
  if(collapsedinput == "ARIMA MReg VAR"){backtest$choosemodelbacktest <-30}
  if(collapsedinput == "RW ARIMA MReg VAR Restr.VAR"){backtest$choosemodelbacktest <-31}

  rw.diff <- vector()
  rw.forecast <- vector()
  arima.diff <- vector()
  arima.forecast <- vector()
  mreg.diff<-vector()
  mreg.forecast<-vector()
  var.diff <- vector()
  var.forecast <- vector()
  restvar.diff <- vector()
  restvar.forecast <- vector()
  ARIMAindep <- list()

  
  if(backtest$choosemodelbacktest  == 1){
    
    backtest_data<-daten.under$base
    loops<- as.integer(nrow(daten.under$data.test)/input$selectHorizont)
    rest<-nrow(daten.under$data.test)-loops*input$selectHorizont
    
    for(i in 1:loops){
        
        withProgress(min = 0, max = 100, setProgress(value = round(i/loops*100,0)))
    
    
        print(i)
        
        if(i == 1){window<- backtest_data}
        
        if(i > 1){
            window <- rbind(backtest_data, daten.under$data.test[1:((i-1)*input$selectHorizont), colnames(backtest_data)])
        }
            
            
        windowTs<-xts(window[,-1], window[[1]])
        
        forecasting <- daten.under$data.test[(1-input$selectHorizont+i*input$selectHorizont):(-input$selectHorizont+i*input$selectHorizont+input$selectHorizont),]
        
        if(i == 1){backtest$dyevents<-forecasting[[1,1]]}
        if(i > 1){backtest$dyevents<- c(backtest$dyevents, forecasting[[1,1]])}
        
        forecastingTs <-xts(forecasting[,-1], forecasting[[1]])
        
        
        
        
        RWfcst = rwf(windowTs[,input$depVar], h=input$selectHorizont, drift=FALSE)
        RWfcstTs<-xts(as.data.frame(RWfcst), forecasting[[1]])
        rw.diff <- c(rw.diff, RWfcstTs[,1]-forecastingTs[,input$depVar])
        rw.forecast <- c(rw.forecast, RWfcstTs[,1] )
    
    }
    
    backtest$timeseries <-rw.forecast
    timetestdata <- daten.under$data.test[1:(nrow(daten.under$data.test)-rest),][[1]]
    backtest$timeseriesTs <- xts(backtest$timeseries, timetestdata)
    backtest$timeseriesTs <- cbind(xts(daten.under$default[, input$depVar],start$dates), backtest$timeseriesTs)
    colnames(backtest$timeseriesTs)<-c(input$depVar, "RW")
    
    rmse.rw = abs(rw.diff)
    RMSE = rmse.rw
    RMSE <- xts(RMSE, timetestdata)
    colnames(RMSE)<-"RW"
    
  }
    
    if(backtest$choosemodelbacktest == 2){
      
      backtest_data<-daten.under$base
      loops<- as.integer(nrow(daten.under$data.test)/input$selectHorizont)
      rest<-nrow(daten.under$data.test)-loops*input$selectHorizont
      
      for(i in 1:loops){
        
        withProgress(min = 0, max = 100, setProgress(value = round(i/loops*100,0),
                                                     message = paste('Calculating loop ',i)))
        
        
        print(i)
        
        if(i == 1){window<- backtest_data}
        
        if(i > 1){
          window <- rbind(backtest_data, daten.under$data.test[1:((i-1)*input$selectHorizont), colnames(backtest_data)])
        }
        
        
        windowTs<-xts(window[,-1], window[[1]])
        
        forecasting <- daten.under$data.test[(1-input$selectHorizont+i*input$selectHorizont):(-input$selectHorizont+i*input$selectHorizont+input$selectHorizont),]
        if(i == 1){backtest$dyevents<-forecasting[[1,1]]}
        if(i > 1){backtest$dyevents<- c(backtest$dyevents, forecasting[[1,1]])}
        forecastingTs <-xts(forecasting[,-1], forecasting[[1]])
        
        
        ARIMAmodel = auto.arima(windowTs[,input$depVar],seasonal = FALSE)
        ARIMAfcast <- forecast(ARIMAmodel, h=input$selectHorizont)
        ARIMAfcastTs <- xts(as.data.frame(ARIMAfcast), forecasting[[1]])
        arima.diff <- c(arima.diff, ARIMAfcastTs[,1] -forecastingTs[,input$depVar])
        arima.forecast <- c(arima.forecast, ARIMAfcastTs[,1])

        
      }

    
    backtest$timeseries <-arima.forecast
    timetestdata <- daten.under$data.test[1:(nrow(daten.under$data.test)-rest),][[1]]
    backtest$timeseriesTs <- xts(backtest$timeseries, timetestdata)
    backtest$timeseriesTs <- cbind(xts(daten.under$default[, input$depVar],start$dates), backtest$timeseriesTs)
    colnames(backtest$timeseriesTs)<-c(input$depVar, "ARIMA")
    
    rmse.arima = abs(arima.diff)
    RMSE = rmse.arima
    RMSE <- xts(RMSE, timetestdata)
    colnames(RMSE)<-"ARIMA"
    
  }
  
  if(backtest$choosemodelbacktest == 3){
    
    backtest_data <-daten.under$base
    backtest_data <- backtest_data[ ,c("Date", regression.modelle$gespeichertes.modell[[7]], names(regression.modelle$gespeichertes.modell[[2]]))]
    
    loops<- as.integer(nrow(daten.under$data.test)/input$selectHorizont)
    rest<-nrow(daten.under$data.test)-loops*input$selectHorizont
    
    for(i in 1:loops){
      
      withProgress(min = 0, max = 100, setProgress(value = round(i/loops*100,0),
                                                   message = paste('Calculating loop ',i)))
      
      
      print(i)
      
      if(i == 1){window<- backtest_data}
      
      if(i > 1){
        window <- rbind(backtest_data, daten.under$data.test[1:((i-1)*input$selectHorizont), colnames(backtest_data)])
      }
      
      
      windowTs<-xts(window[,-1], window[[1]])
      
      forecasting <- daten.under$data.test[(1-input$selectHorizont+i*input$selectHorizont):(-input$selectHorizont+i*input$selectHorizont+input$selectHorizont),]
      
      if(i == 1){backtest$dyevents<-forecasting[[1,1]]}
      if(i > 1){backtest$dyevents<- c(backtest$dyevents, forecasting[[1,1]])}
      forecastingTs <-xts(forecasting[,-1], forecasting[[1]])
      
      fit.reg <- regression.modelle$gespeichertes.modell[[1]]
      
      # Anzahl der beteiligten Variablen am Regressionsmodell
      count_variable <- length(regression.modelle$gespeichertes.modell[[4]])
      lm_lags        <- regression.modelle$gespeichertes.modell[[4]]
      
      # Berechne Arima-Modell fuer aktuelle Datengundlage
      ARIMAindep      <- lapply(windowTs[ ,-1], function(x) auto.arima(x))
      
      daten.lag <- list()
      for(j in 1:count_variable){
        if(lm_lags[j] > 0 && (input$selectHorizont-lm_lags[j] > 0)){
          daten.lag[[j]] <- as.vector(unlist(c(tail(window[ , j+2], n = lm_lags[j]), forecast(ARIMAindep[[j]], h=input$selectHorizont-lm_lags[j])[["mean"]])))
          next
        }else if(input$selectHorizont-lm_lags[j] <= 0){
          daten.lag[[j]] <- as.vector(unlist(tail(window[ , j+2], n = input$selectHorizont)))
        }else if(lm_lags[j] == 0 ){
          daten.lag[[j]] <- as.vector(forecast(ARIMAindep[[j]], h=input$selectHorizont-lm_lags[j])[["mean"]])  
        }
      }
      
      names(daten.lag) <- names(regression.modelle$gespeichertes.modell[[2]])
      

      
      # Vorhersage die naechsten "selectHorizont" steps
      mregfcast <- predict(fit.reg, daten.lag)
      
      # Definieren der Zeitserien fuer die Vorhergesagten Werte
      mregfcastTs <- xts(mregfcast, forecasting[[1]])
      
      # AUslesen der abhaengigen Variable des Regressionsmodells
      dependent_var <- regression.modelle$gespeichertes.modell[[7]]
      
      
      # Speichern der Differenzen vom tatsaechlichen und gefitteten Werten
      mreg.diff <- c(mreg.diff, mregfcastTs[,1]-forecastingTs[,input$depVar])
      
      # Speichern der historisch gefitteten Werte
      mreg.forecast<- c(mreg.forecast, mregfcastTs)
      
      
    }
    
    
    backtest$timeseries <-mreg.forecast
    timetestdata <- daten.under$data.test[1:(nrow(daten.under$data.test)-rest),][[1]]
    backtest$timeseriesTs <- xts(backtest$timeseries, timetestdata)
    backtest$timeseriesTs <- cbind(xts(daten.under$default[, input$depVar],start$dates), backtest$timeseriesTs)
    colnames(backtest$timeseriesTs)<-c(input$depVar, "MReg")
    
    rmse.mreg = abs(mreg.diff)
    RMSE = rmse.mreg
    RMSE <- xts(RMSE, timetestdata)
    colnames(RMSE)<-"MReg"
    
  }
  
  
  if(backtest$choosemodelbacktest == 4){
    
    backtest_data<-var.modelle$gespeicherte.expl.modelle.var[[1]]
    loops<- as.integer(nrow(daten.under$data.test)/input$selectHorizont)
    rest<-nrow(daten.under$data.test)-loops*input$selectHorizont
    
    for(i in 1:loops){
      
      withProgress(min = 0, max = 100, setProgress(value = round(i/loops*100,0),
                                                   message = paste('Calculating loop ',i)))
      
      
      print(i)
      
      if(i == 1){window<- backtest_data}
      
      if(i > 1){
        window <- rbind(backtest_data, daten.under$data.test[1:((i-1)*input$selectHorizont), colnames(backtest_data)])
      }
      
      
      windowTs<-xts(window[,-1], window[[1]])
      
      forecasting <- daten.under$data.test[(1-input$selectHorizont+i*input$selectHorizont):(-input$selectHorizont+i*input$selectHorizont+input$selectHorizont),]
      
      if(i == 1){backtest$dyevents<-forecasting[[1,1]]}
      if(i > 1){backtest$dyevents<- c(backtest$dyevents, forecasting[[1,1]])}
      forecastingTs <-xts(forecasting[,-1], forecasting[[1]])
      
      VARmodel <- VAR(windowTs,p=var.modelle$gespeicherte.expl.modelle.var[[5]],type = "const")
      VARfcst <- predict(VARmodel, n.ahead=input$selectHorizont)
      var.diff <- c(var.diff, VARfcst$fcst[[input$depVar]][,1] -forecasting[,input$depVar][[1]])
      var.forecast <- c(var.forecast , VARfcst$fcst[[input$depVar]][,1])
      rmse.var = abs(var.diff)
      
      
    }
    
    
    backtest$timeseries <-var.forecast
    timetestdata <- daten.under$data.test[1:(nrow(daten.under$data.test)-rest),][[1]]
    backtest$timeseriesTs <- xts(backtest$timeseries, timetestdata)
    backtest$timeseriesTs <- cbind(xts(daten.under$default[, input$depVar],start$dates), backtest$timeseriesTs)
    colnames(backtest$timeseriesTs)<-c(input$depVar, "VAR")
    
    rmse.var = abs(var.diff)
    RMSE = rmse.var
    RMSE <- xts(RMSE, timetestdata)
    colnames(RMSE)<-"VAR"
    
  }  
  
  if(backtest$choosemodelbacktest == 5){
    
    backtest_data<-var.modelle$gespeicherte.expl.modelle.restvar[[1]]
    loops<- as.integer(nrow(daten.under$data.test)/input$selectHorizont)
    rest<-nrow(daten.under$data.test)-loops*input$selectHorizont
    
    for(i in 1:loops){
      
      withProgress(min = 0, max = 100, setProgress(value = round(i/loops*100,0),
                                                   message = paste('Calculating loop ',i)))
      
      
      print(i)
      
      if(i == 1){window<- backtest_data}
      
      if(i > 1){
        window <- rbind(backtest_data, daten.under$data.test[1:((i-1)*input$selectHorizont), colnames(backtest_data)])
      }
      
      
      windowTs<-xts(window[,-1], window[[1]])
      
      forecasting <- daten.under$data.test[(1-input$selectHorizont+i*input$selectHorizont):(-input$selectHorizont+i*input$selectHorizont+input$selectHorizont),]
      
      if(i == 1){backtest$dyevents<-forecasting[[1,1]]}
      if(i > 1){backtest$dyevents<- c(backtest$dyevents, forecasting[[1,1]])}
      forecastingTs <-xts(forecasting[,-1], forecasting[[1]])
      
      restVARmodel <- restrict(VAR(windowZweiTs,p=var.modelle$gespeicherte.expl.modelle.restvar[[5]],type = "const"))
      restVARfcst <- predict(restVARmodel, n.ahead=input$selectHorizont)
      restvar.diff <- c(restvar.diff, restVARfcst$fcst[[input$depVar]][,1] -forecasting[,input$depVar][[1]])
      restvar.forecast <- c(restvar.forecast , restVARfcst$fcst[[input$depVar]][,1])
      rmse.restvar = abs(restvar.diff)
      
    }
    
    
    backtest$timeseries <-restvar.forecast
    timetestdata <- daten.under$data.test[1:(nrow(daten.under$data.test)-rest),][[1]]
    backtest$timeseriesTs <- xts(backtest$timeseries, timetestdata)
    backtest$timeseriesTs <- cbind(xts(daten.under$default[, input$depVar],start$dates), backtest$timeseriesTs)
    colnames(backtest$timeseriesTs)<-c(input$depVar, "Restr.VAR")
    
    rmse.restvar = abs(restvar.diff)
    RMSE = rmse.restvar
    RMSE <- xts(RMSE, timetestdata)
    colnames(RMSE)<-"Restr.VAR"
    
  }  
  
  if(backtest$choosemodelbacktest  == 6){
    
    backtest_data<-daten.under$base
    loops<- as.integer(nrow(daten.under$data.test)/input$selectHorizont)
    rest<-nrow(daten.under$data.test)-loops*input$selectHorizont
    
    for(i in 1:loops){
      
      withProgress(min = 0, max = 100, setProgress(value = round(i/loops*100,0),
                                                   message = paste('Calculating loop ',i)))
      
      
      print(i)
      
      if(i == 1){window<- backtest_data}
      
      if(i > 1){
        window <- rbind(backtest_data, daten.under$data.test[1:((i-1)*input$selectHorizont), colnames(backtest_data)])
      }
      
      
      windowTs<-xts(window[,-1], window[[1]])
      
      forecasting <- daten.under$data.test[(1-input$selectHorizont+i*input$selectHorizont):(-input$selectHorizont+i*input$selectHorizont+input$selectHorizont),]
      
      if(i == 1){backtest$dyevents<-forecasting[[1,1]]}
      if(i > 1){backtest$dyevents<- c(backtest$dyevents, forecasting[[1,1]])}
      forecastingTs <-xts(forecasting[,-1], forecasting[[1]])
      
      RWfcst = rwf(windowTs[,input$depVar], h=input$selectHorizont, drift=FALSE)
      RWfcstTs<-xts(as.data.frame(RWfcst), forecasting[[1]])
      rw.diff <- c(rw.diff, RWfcstTs[,1]-forecastingTs[,input$depVar])
      rw.forecast <- c(rw.forecast, RWfcstTs[,1] )
      
      ARIMAmodel = auto.arima(windowTs[,input$depVar],seasonal = FALSE)
      ARIMAfcast <- forecast(ARIMAmodel, h=input$selectHorizont)
      ARIMAfcastTs <- xts(as.data.frame(ARIMAfcast), forecasting[[1]])
      arima.diff <- c(arima.diff, ARIMAfcastTs[,1] -forecastingTs[,input$depVar])
      arima.forecast <- c(arima.forecast, ARIMAfcastTs[,1])
      
    }
    
    backtest$timeseries <- cbind(rw.forecast,arima.forecast)
    
    timetestdata <- daten.under$data.test[1:(nrow(daten.under$data.test)-rest),][[1]]
    backtest$timeseriesTs <- xts(backtest$timeseries, timetestdata)
    backtest$timeseriesTs <- cbind(xts(daten.under$default[, input$depVar],start$dates), backtest$timeseriesTs)
    
    colnames(backtest$timeseriesTs)<-c(input$depVar, "RW", "ARIMA")
    
    rmse.rw = abs(rw.diff)
    rmse.arima <- abs(arima.diff)
    
    RMSE = cbind(rmse.rw, rmse.arima)
    RMSE <- xts(RMSE, timetestdata)
    colnames(RMSE)<-c("RW", "ARIMA")
    
    
  }
  
  if(backtest$choosemodelbacktest == 7){
    
    backtest_data <-daten.under$base
    backtest_data <- backtest_data[ ,c("Date", regression.modelle$gespeichertes.modell[[7]], names(regression.modelle$gespeichertes.modell[[2]]))]
    
    loops<- as.integer(nrow(daten.under$data.test)/input$selectHorizont)
    rest<-nrow(daten.under$data.test)-loops*input$selectHorizont
    
    for(i in 1:loops){
      
      withProgress(min = 0, max = 100, setProgress(value = round(i/loops*100,0),
                                                   message = paste('Calculating loop ',i)))
      
      
      print(i)
      
      if(i == 1){window<- backtest_data}
      
      if(i > 1){
        window <- rbind(backtest_data, daten.under$data.test[1:((i-1)*input$selectHorizont), colnames(backtest_data)])
      }
      
      
      windowTs<-xts(window[,-1], window[[1]])
      
      forecasting <- daten.under$data.test[(1-input$selectHorizont+i*input$selectHorizont):(-input$selectHorizont+i*input$selectHorizont+input$selectHorizont),]
      
      if(i == 1){backtest$dyevents<-forecasting[[1,1]]}
      if(i > 1){backtest$dyevents<- c(backtest$dyevents, forecasting[[1,1]])}
      forecastingTs <-xts(forecasting[,-1], forecasting[[1]])
      
      fit.reg <- regression.modelle$gespeichertes.modell[[1]]
      
      # Anzahl der beteiligten Variablen am Regressionsmodell
      count_variable <- length(regression.modelle$gespeichertes.modell[[4]])
      lm_lags        <- regression.modelle$gespeichertes.modell[[4]]
      
      # Berechne Arima-Modell fuer aktuelle Datengundlage
      ARIMAindep      <- lapply(windowTs[ ,-1], function(x) auto.arima(x))
      
      daten.lag <- list()
      for(j in 1:count_variable){
        if(lm_lags[j] > 0 && (input$selectHorizont-lm_lags[j] > 0)){
          daten.lag[[j]] <- as.vector(unlist(c(tail(window[ , j+2], n = lm_lags[j]), forecast(ARIMAindep[[j]], h=input$selectHorizont-lm_lags[j])[["mean"]])))
          next
        }else if(input$selectHorizont-lm_lags[j] <= 0){
          daten.lag[[j]] <- as.vector(unlist(tail(window[ , j+2], n = input$selectHorizont)))
        }else if(lm_lags[j] == 0 ){
          daten.lag[[j]] <- as.vector(forecast(ARIMAindep[[j]], h=input$selectHorizont-lm_lags[j])[["mean"]])  
        }
      }
      
      names(daten.lag) <- names(regression.modelle$gespeichertes.modell[[2]])
      
      
      
      # Vorhersage die naechsten "selectHorizont" steps
      mregfcast <- predict(fit.reg, daten.lag)
      
      # Definieren der Zeitserien fuer die Vorhergesagten Werte
      mregfcastTs <- xts(mregfcast, forecasting[[1]])
      
      # AUslesen der abhaengigen Variable des Regressionsmodells
      dependent_var <- regression.modelle$gespeichertes.modell[[7]]
      
      
      # Speichern der Differenzen vom tatsaechlichen und gefitteten Werten
      mreg.diff <- c(mreg.diff, mregfcastTs[,1]-forecastingTs[,input$depVar])
      
      # Speichern der historisch gefitteten Werte
      mreg.forecast<- c(mreg.forecast, mregfcastTs)
      
      
      RWfcst = rwf(windowTs[,input$depVar], h=input$selectHorizont, drift=FALSE)
      RWfcstTs<-xts(as.data.frame(RWfcst), forecasting[[1]])
      rw.diff <- c(rw.diff, RWfcstTs[,1]-forecastingTs[,input$depVar])
      rw.forecast <- c(rw.forecast, RWfcstTs[,1] )
      
      
    }
    
    
    backtest$timeseries <-cbind(rw.forecast, mreg.forecast)
    timetestdata <- daten.under$data.test[1:(nrow(daten.under$data.test)-rest),][[1]]
    backtest$timeseriesTs <- xts(backtest$timeseries, timetestdata)
    backtest$timeseriesTs <- cbind(xts(daten.under$default[, input$depVar],start$dates), backtest$timeseriesTs)
    colnames(backtest$timeseriesTs)<-c(input$depVar, "RW", "MReg")
    
    rmse.mreg = abs(mreg.diff)
    rmse.rw = abs(rw.diff)
    
    RMSE = cbind(rmse.rw, rmse.mreg)
    RMSE <- xts(RMSE, timetestdata)
    colnames(RMSE)<-c("RW","MReg")
    
  }
  
  if(backtest$choosemodelbacktest == 8){
    
    backtest_data<-var.modelle$gespeicherte.expl.modelle.var[[1]]
    loops<- as.integer(nrow(daten.under$data.test)/input$selectHorizont)
    rest<-nrow(daten.under$data.test)-loops*input$selectHorizont
    
    for(i in 1:loops){
      
      withProgress(min = 0, max = 100, setProgress(value = round(i/loops*100,0),
                                                   message = paste('Calculating loop ',i)))
      
      
      print(i)
      
      if(i == 1){window<- backtest_data}
      
      if(i > 1){
        window <- rbind(backtest_data, daten.under$data.test[1:((i-1)*input$selectHorizont), colnames(backtest_data)])
      }
      
      
      windowTs<-xts(window[,-1], window[[1]])
      
      forecasting <- daten.under$data.test[(1-input$selectHorizont+i*input$selectHorizont):(-input$selectHorizont+i*input$selectHorizont+input$selectHorizont),]
      if(i == 1){backtest$dyevents<-forecasting[[1,1]]}
      if(i > 1){backtest$dyevents<- c(backtest$dyevents, forecasting[[1,1]])}
      
      forecastingTs <-xts(forecasting[,-1], forecasting[[1]])
      
      RWfcst = rwf(windowTs[,input$depVar], h=input$selectHorizont, drift=FALSE)
      RWfcstTs<-xts(as.data.frame(RWfcst), forecasting[[1]])
      rw.diff <- c(rw.diff, RWfcstTs[,1]-forecastingTs[,input$depVar])
      rw.forecast <- c(rw.forecast, RWfcstTs[,1] )
      
      
      
      VARmodel <- VAR(windowTs,p=var.modelle$gespeicherte.expl.modelle.var[[5]],type = "const")
      VARfcst <- predict(VARmodel, n.ahead=input$selectHorizont)
      var.diff <- c(var.diff, VARfcst$fcst[[input$depVar]][,1] -forecasting[,input$depVar][[1]])
      var.forecast <- c(var.forecast , VARfcst$fcst[[input$depVar]][,1])
      rmse.var = abs(var.diff)
      
      
    }
    
    
    backtest$timeseries <-cbind(rw.forecast, var.forecast)
    timetestdata <- daten.under$data.test[1:(nrow(daten.under$data.test)-rest),][[1]]
    backtest$timeseriesTs <- xts(backtest$timeseries, timetestdata)
    backtest$timeseriesTs <- cbind(xts(daten.under$default[, input$depVar],start$dates), backtest$timeseriesTs)
    colnames(backtest$timeseriesTs)<-c(input$depVar, "RW", "VAR")
    
    rmse.rw = abs(rw.diff)
    rmse.var = abs(var.diff)
    RMSE = cbind(rmse.rw, rmse.var)
    RMSE <- xts(RMSE, timetestdata)
    colnames(RMSE)<-c("RW","VAR")
    
  }  
  
  if(backtest$choosemodelbacktest == 9){
    
    backtest_data<-var.modelle$gespeicherte.expl.modelle.restvar[[1]]
    loops<- as.integer(nrow(daten.under$data.test)/input$selectHorizont)
    rest<-nrow(daten.under$data.test)-loops*input$selectHorizont
    
    for(i in 1:loops){
      
      withProgress(min = 0, max = 100, setProgress(value = round(i/loops*100,0),
                                                   message = paste('Calculating loop ',i)))
      
      
      print(i)
      
      if(i == 1){window<- backtest_data}
      
      if(i > 1){
        window <- rbind(backtest_data, daten.under$data.test[1:((i-1)*input$selectHorizont), colnames(backtest_data)])
      }
      
      
      windowTs<-xts(window[,-1], window[[1]])
      
      forecasting <- daten.under$data.test[(1-input$selectHorizont+i*input$selectHorizont):(-input$selectHorizont+i*input$selectHorizont+input$selectHorizont),]
      
      if(i == 1){backtest$dyevents<-forecasting[[1,1]]}
      if(i > 1){backtest$dyevents<- c(backtest$dyevents, forecasting[[1,1]])}
      forecastingTs <-xts(forecasting[,-1], forecasting[[1]])
      
      RWfcst = rwf(windowTs[,input$depVar], h=input$selectHorizont, drift=FALSE)
      RWfcstTs<-xts(as.data.frame(RWfcst), forecasting[[1]])
      rw.diff <- c(rw.diff, RWfcstTs[,1]-forecastingTs[,input$depVar])
      rw.forecast <- c(rw.forecast, RWfcstTs[,1] )
      
      restVARmodel <- restrict(VAR(windowZweiTs,p=var.modelle$gespeicherte.expl.modelle.restvar[[5]],type = "const"))
      restVARfcst <- predict(restVARmodel, n.ahead=input$selectHorizont)
      restvar.diff <- c(restvar.diff, restVARfcst$fcst[[input$depVar]][,1] -forecasting[,input$depVar][[1]])
      restvar.forecast <- c(restvar.forecast , restVARfcst$fcst[[input$depVar]][,1])
      rmse.restvar = abs(restvar.diff)
    }
    
    
    backtest$timeseries <-cbind(rw.forecast, restvar.forecast)
    timetestdata <- daten.under$data.test[1:(nrow(daten.under$data.test)-rest),][[1]]
    backtest$timeseriesTs <- xts(backtest$timeseries, timetestdata)
    backtest$timeseriesTs <- cbind(xts(daten.under$default[, input$depVar],start$dates), backtest$timeseriesTs)
    colnames(backtest$timeseriesTs)<-c(input$depVar, "RW", "Restr.VAR")
    
    rmse.rw = abs(rw.diff)
    rmse.var = abs(restvar.diff)
    RMSE = cbind(rmse.rw, rmse.restvar)
    RMSE <- xts(RMSE, timetestdata)
    colnames(RMSE)<-c("RW","Restr.VAR")
    
  }  
  
  if(backtest$choosemodelbacktest == 10){
    
    backtest_data <-daten.under$base
    backtest_data <- backtest_data[ ,c("Date", regression.modelle$gespeichertes.modell[[7]], names(regression.modelle$gespeichertes.modell[[2]]))]
    
    loops<- as.integer(nrow(daten.under$data.test)/input$selectHorizont)
    rest<-nrow(daten.under$data.test)-loops*input$selectHorizont
    
    for(i in 1:loops){
      
      withProgress(min = 0, max = 100, setProgress(value = round(i/loops*100,0),
                                                   message = paste('Calculating loop ',i)))
      
      
      print(i)
      
      if(i == 1){window<- backtest_data}
      
      if(i > 1){
        window <- rbind(backtest_data, daten.under$data.test[1:((i-1)*input$selectHorizont), colnames(backtest_data)])
      }
      
      
      windowTs<-xts(window[,-1], window[[1]])
      
      forecasting <- daten.under$data.test[(1-input$selectHorizont+i*input$selectHorizont):(-input$selectHorizont+i*input$selectHorizont+input$selectHorizont),]
      
      if(i == 1){backtest$dyevents<-forecasting[[1,1]]}
      if(i > 1){backtest$dyevents<- c(backtest$dyevents, forecasting[[1,1]])}
      forecastingTs <-xts(forecasting[,-1], forecasting[[1]])
      
      fit.reg <- regression.modelle$gespeichertes.modell[[1]]
      
      # Anzahl der beteiligten Variablen am Regressionsmodell
      count_variable <- length(regression.modelle$gespeichertes.modell[[4]])
      lm_lags        <- regression.modelle$gespeichertes.modell[[4]]
      
      # Berechne Arima-Modell fuer aktuelle Datengundlage
      ARIMAindep      <- lapply(windowTs[ ,-1], function(x) auto.arima(x))
      
      daten.lag <- list()
      for(j in 1:count_variable){
        if(lm_lags[j] > 0 && (input$selectHorizont-lm_lags[j] > 0)){
          daten.lag[[j]] <- as.vector(unlist(c(tail(window[ , j+2], n = lm_lags[j]), forecast(ARIMAindep[[j]], h=input$selectHorizont-lm_lags[j])[["mean"]])))
          next
        }else if(input$selectHorizont-lm_lags[j] <= 0){
          daten.lag[[j]] <- as.vector(unlist(tail(window[ , j+2], n = input$selectHorizont)))
        }else if(lm_lags[j] == 0 ){
          daten.lag[[j]] <- as.vector(forecast(ARIMAindep[[j]], h=input$selectHorizont-lm_lags[j])[["mean"]])  
        }
      }
      
      names(daten.lag) <- names(regression.modelle$gespeichertes.modell[[2]])
      
      
      
      # Vorhersage die naechsten "selectHorizont" steps
      mregfcast <- predict(fit.reg, daten.lag)
      
      # Definieren der Zeitserien fuer die Vorhergesagten Werte
      mregfcastTs <- xts(mregfcast, forecasting[[1]])
      
      # AUslesen der abhaengigen Variable des Regressionsmodells
      dependent_var <- regression.modelle$gespeichertes.modell[[7]]
      
      
      # Speichern der Differenzen vom tatsaechlichen und gefitteten Werten
      mreg.diff <- c(mreg.diff, mregfcastTs[,1]-forecastingTs[,input$depVar])
      
      # Speichern der historisch gefitteten Werte
      mreg.forecast<- c(mreg.forecast, mregfcastTs)
      
      ARIMAmodel = auto.arima(windowTs[,input$depVar],seasonal = FALSE)
      ARIMAfcast <- forecast(ARIMAmodel, h=input$selectHorizont)
      ARIMAfcastTs <- xts(as.data.frame(ARIMAfcast), forecasting[[1]])
      arima.diff <- c(arima.diff, ARIMAfcastTs[,1] -forecastingTs[,input$depVar])
      arima.forecast <- c(arima.forecast, ARIMAfcastTs[,1])
      
      
    }
    
    
    backtest$timeseries <-cbind(arima.forecast, mreg.forecast)
    timetestdata <- daten.under$data.test[1:(nrow(daten.under$data.test)-rest),][[1]]
    backtest$timeseriesTs <- xts(backtest$timeseries, timetestdata)
    backtest$timeseriesTs <- cbind(xts(daten.under$default[, input$depVar],start$dates), backtest$timeseriesTs)
    colnames(backtest$timeseriesTs)<-c(input$depVar, "ARIMA", "MReg")
    
    rmse.mreg = abs(mreg.diff)
    rmse.arima = abs(arima.diff)
    
    RMSE = cbind(rmse.arima, rmse.mreg)
    RMSE <- xts(RMSE, timetestdata)
    colnames(RMSE)<-c("ARIMA","MReg")
    
  }
  
  if(backtest$choosemodelbacktest == 11){
    
    backtest_data<-var.modelle$gespeicherte.expl.modelle.var[[1]]
    loops<- as.integer(nrow(daten.under$data.test)/input$selectHorizont)
    rest<-nrow(daten.under$data.test)-loops*input$selectHorizont
    
    for(i in 1:loops){
      
      withProgress(min = 0, max = 100, setProgress(value = round(i/loops*100,0),
                                                   message = paste('Calculating loop ',i)))
      
      
      print(i)
      
      if(i == 1){window<- backtest_data}
      
      if(i > 1){
        window <- rbind(backtest_data, daten.under$data.test[1:((i-1)*input$selectHorizont), colnames(backtest_data)])
      }
      
      
      windowTs<-xts(window[,-1], window[[1]])
      
      forecasting <- daten.under$data.test[(1-input$selectHorizont+i*input$selectHorizont):(-input$selectHorizont+i*input$selectHorizont+input$selectHorizont),]
      
      if(i == 1){backtest$dyevents<-forecasting[[1,1]]}
      if(i > 1){backtest$dyevents<- c(backtest$dyevents, forecasting[[1,1]])}
      forecastingTs <-xts(forecasting[,-1], forecasting[[1]])
      
      ARIMAmodel = auto.arima(windowTs[,input$depVar],seasonal = FALSE)
      ARIMAfcast <- forecast(ARIMAmodel, h=input$selectHorizont)
      ARIMAfcastTs <- xts(as.data.frame(ARIMAfcast), forecasting[[1]])
      arima.diff <- c(arima.diff, ARIMAfcastTs[,1] -forecastingTs[,input$depVar])
      arima.forecast <- c(arima.forecast, ARIMAfcastTs[,1])
      
      VARmodel <- VAR(windowTs,p=var.modelle$gespeicherte.expl.modelle.var[[5]],type = "const")
      VARfcst <- predict(VARmodel, n.ahead=input$selectHorizont)
      var.diff <- c(var.diff, VARfcst$fcst[[input$depVar]][,1] -forecasting[,input$depVar][[1]])
      var.forecast <- c(var.forecast , VARfcst$fcst[[input$depVar]][,1])
      rmse.var = abs(var.diff)
      
      
    }
    
    
    backtest$timeseries <-cbind(arima.forecast, var.forecast)
    timetestdata <- daten.under$data.test[1:(nrow(daten.under$data.test)-rest),][[1]]
    backtest$timeseriesTs <- xts(backtest$timeseries, timetestdata)
    backtest$timeseriesTs <- cbind(xts(daten.under$default[, input$depVar],start$dates), backtest$timeseriesTs)
    colnames(backtest$timeseriesTs)<-c(input$depVar, "ARIMA","VAR")
    
    rmse.arima = abs(arima.diff)
    rmse.var = abs(var.diff)
    RMSE = cbind(rmse.arima, rmse.var)
    RMSE <- xts(RMSE, timetestdata)
    colnames(RMSE)<-c("ARIMA" ,"VAR")
    
  } 
  
  if(backtest$choosemodelbacktest == 12){
    
    backtest_data<-var.modelle$gespeicherte.expl.modelle.restvar[[1]]
    loops<- as.integer(nrow(daten.under$data.test)/input$selectHorizont)
    rest<-nrow(daten.under$data.test)-loops*input$selectHorizont
    
    for(i in 1:loops){
      
      withProgress(min = 0, max = 100, setProgress(value = round(i/loops*100,0),
                                                   message = paste('Calculating loop ',i)))
      
      
      print(i)
      
      if(i == 1){window<- backtest_data}
      
      if(i > 1){
        window <- rbind(backtest_data, daten.under$data.test[1:((i-1)*input$selectHorizont), colnames(backtest_data)])
      }
      
      
      windowTs<-xts(window[,-1], window[[1]])
      
      forecasting <- daten.under$data.test[(1-input$selectHorizont+i*input$selectHorizont):(-input$selectHorizont+i*input$selectHorizont+input$selectHorizont),]
      
      if(i == 1){backtest$dyevents<-forecasting[[1,1]]}
      if(i > 1){backtest$dyevents<- c(backtest$dyevents, forecasting[[1,1]])}
      forecastingTs <-xts(forecasting[,-1], forecasting[[1]])
      
      ARIMAmodel = auto.arima(windowTs[,input$depVar],seasonal = FALSE)
      ARIMAfcast <- forecast(ARIMAmodel, h=input$selectHorizont)
      ARIMAfcastTs <- xts(as.data.frame(ARIMAfcast), forecasting[[1]])
      arima.diff <- c(arima.diff, ARIMAfcastTs[,1] -forecastingTs[,input$depVar])
      arima.forecast <- c(arima.forecast, ARIMAfcastTs[,1])
      
      restVARmodel <- restrict(VAR(windowZweiTs,p=var.modelle$gespeicherte.expl.modelle.restvar[[5]],type = "const"))
      restVARfcst <- predict(restVARmodel, n.ahead=input$selectHorizont)
      restvar.diff <- c(restvar.diff, restVARfcst$fcst[[input$depVar]][,1] -forecasting[,input$depVar][[1]])
      restvar.forecast <- c(restvar.forecast , restVARfcst$fcst[[input$depVar]][,1])
      rmse.restvar = abs(restvar.diff)
      
      
    }
    
    
    backtest$timeseries <-cbind(arima.forecast, restvar.forecast)
    timetestdata <- daten.under$data.test[1:(nrow(daten.under$data.test)-rest),][[1]]
    backtest$timeseriesTs <- xts(backtest$timeseries, timetestdata)
    backtest$timeseriesTs <- cbind(xts(daten.under$default[, input$depVar],start$dates), backtest$timeseriesTs)
    colnames(backtest$timeseriesTs)<-c(input$depVar, "ARIMA","Restr.VAR")
    
    rmse.arima = abs(arima.diff)
    rmse.restvar = abs(restvar.diff)
    RMSE = cbind(rmse.arima, rmse.restvar)
    RMSE <- xts(RMSE, timetestdata)
    colnames(RMSE)<-c("ARIMA" ,"Restr.VAR")
    
  } 
  
  if(backtest$choosemodelbacktest == 13){
    
    backtest_data_var <-var.modelle$gespeicherte.expl.modelle.var[[1]]
    
    backtest_data <- daten.under$base[ ,c("Date", regression.modelle$gespeichertes.modell[[7]], names(regression.modelle$gespeichertes.modell[[2]]))]
    
    loops<- as.integer(nrow(daten.under$data.test)/input$selectHorizont)
    rest<-nrow(daten.under$data.test)-loops*input$selectHorizont
    
    for(i in 1:loops){
      
      withProgress(min = 0, max = 100, setProgress(value = round(i/loops*100,0),
                                                   message = paste('Calculating loop ',i)))
      
      
      print(i)
      
      if(i == 1){
        window<- backtest_data
        windowZwei<-backtest_data_var
      }
      

      if(i > 1){
        window <- rbind(backtest_data, daten.under$data.test[1:((i-1)*input$selectHorizont), colnames(backtest_data)])
        windowZwei <- rbind(backtest_data_var, daten.under$data.test[1:((i-1)*input$selectHorizont), colnames(backtest_data_var)])
      }
      
      
      windowTs<-xts(window[,-1], window[[1]])
      windowZweiTs<-xts(windowZwei[,-1], windowZwei[[1]])
      
      forecasting <- daten.under$data.test[(1-input$selectHorizont+i*input$selectHorizont):(-input$selectHorizont+i*input$selectHorizont+input$selectHorizont),]
      
      if(i == 1){backtest$dyevents<-forecasting[[1,1]]}
      if(i > 1){backtest$dyevents<- c(backtest$dyevents, forecasting[[1,1]])}
      forecastingTs <-xts(forecasting[,-1], forecasting[[1]])
      
      fit.reg <- regression.modelle$gespeichertes.modell[[1]]
      
      # Anzahl der beteiligten Variablen am Regressionsmodell
      count_variable <- length(regression.modelle$gespeichertes.modell[[4]])
      lm_lags        <- regression.modelle$gespeichertes.modell[[4]]
      
      # Berechne Arima-Modell fuer aktuelle Datengundlage
      ARIMAindep      <- lapply(windowTs[ ,-1], function(x) auto.arima(x))
      
      daten.lag <- list()
      for(j in 1:count_variable){
        if(lm_lags[j] > 0 && (input$selectHorizont-lm_lags[j] > 0)){
          daten.lag[[j]] <- as.vector(unlist(c(tail(window[ , j+2], n = lm_lags[j]), forecast(ARIMAindep[[j]], h=input$selectHorizont-lm_lags[j])[["mean"]])))
          next
        }else if(input$selectHorizont-lm_lags[j] <= 0){
          daten.lag[[j]] <- as.vector(unlist(tail(window[ , j+2], n = input$selectHorizont)))
        }else if(lm_lags[j] == 0 ){
          daten.lag[[j]] <- as.vector(forecast(ARIMAindep[[j]], h=input$selectHorizont-lm_lags[j])[["mean"]])  
        }
      }
      
      names(daten.lag) <- names(regression.modelle$gespeichertes.modell[[2]])
      
      
      
      # Vorhersage die naechsten "selectHorizont" steps
      mregfcast <- predict(fit.reg, daten.lag)
      
      # Definieren der Zeitserien fuer die Vorhergesagten Werte
      mregfcastTs <- xts(mregfcast, forecasting[[1]])
      
      # AUslesen der abhaengigen Variable des Regressionsmodells
      dependent_var <- regression.modelle$gespeichertes.modell[[7]]
      
      
      # Speichern der Differenzen vom tatsaechlichen und gefitteten Werten
      mreg.diff <- c(mreg.diff, mregfcastTs[,1]-forecastingTs[,input$depVar])
      
      # Speichern der historisch gefitteten Werte
      mreg.forecast<- c(mreg.forecast, mregfcastTs)
      
      
      VARmodel <- VAR(windowZweiTs,p=var.modelle$gespeicherte.expl.modelle.var[[5]],type = "const")
      VARfcst <- predict(VARmodel, n.ahead=input$selectHorizont)
      var.diff <- c(var.diff, VARfcst$fcst[[input$depVar]][,1] -forecasting[,input$depVar][[1]])
      var.forecast <- c(var.forecast , VARfcst$fcst[[input$depVar]][,1])
      
      
      
    }
    
    
    backtest$timeseries <-cbind(mreg.forecast, var.forecast)
    timetestdata <- daten.under$data.test[1:(nrow(daten.under$data.test)-rest),][[1]]
    backtest$timeseriesTs <- xts(backtest$timeseries, timetestdata)
    backtest$timeseriesTs <- cbind(xts(daten.under$default[, input$depVar],start$dates), backtest$timeseriesTs)
    colnames(backtest$timeseriesTs)<-c(input$depVar, "MReg", "VAR")
    
    rmse.mreg = abs(mreg.diff)
    rmse.var = abs(var.diff)
    
    RMSE = cbind(rmse.mreg, rmse.var)
    RMSE <- xts(RMSE, timetestdata)
    colnames(RMSE)<-c("MReg", "VAR")
    
  }
  
  if(backtest$choosemodelbacktest == 14){
    
    backtest_data_restvar <-var.modelle$gespeicherte.expl.modelle.restvar[[1]]
    
    backtest_data <- daten.under$base[ ,c("Date", regression.modelle$gespeichertes.modell[[7]], names(regression.modelle$gespeichertes.modell[[2]]))]
    
    loops<- as.integer(nrow(daten.under$data.test)/input$selectHorizont)
    rest<-nrow(daten.under$data.test)-loops*input$selectHorizont
    
    for(i in 1:loops){
      
      withProgress(min = 0, max = 100, setProgress(value = round(i/loops*100,0),
                                                   message = paste('Calculating loop ',i)))
      
      
      print(i)
      
      if(i == 1){
        window<- backtest_data
        windowZwei<-backtest_data_restvar
      }
      
      if(i > 1){
        window <- rbind(backtest_data, daten.under$data.test[1:((i-1)*input$selectHorizont), colnames(backtest_data)])
        windowZwei <- rbind(backtest_data_var, daten.under$data.test[1:((i-1)*input$selectHorizont), colnames(backtest_data_var)])
      }
      
      
      windowTs<-xts(window[,-1], window[[1]])
      windowZweiTs<-xts(windowZwei[,-1], windowZwei[[1]])
      
      forecasting <- daten.under$data.test[(1-input$selectHorizont+i*input$selectHorizont):(-input$selectHorizont+i*input$selectHorizont+input$selectHorizont),]
      if(i == 1){backtest$dyevents<-forecasting[[1,1]]}
      if(i > 1){backtest$dyevents<- c(backtest$dyevents, forecasting[[1,1]])}
      
      forecastingTs <-xts(forecasting[,-1], forecasting[[1]])
      
      fit.reg <- regression.modelle$gespeichertes.modell[[1]]
      
      # Anzahl der beteiligten Variablen am Regressionsmodell
      count_variable <- length(regression.modelle$gespeichertes.modell[[4]])
      lm_lags        <- regression.modelle$gespeichertes.modell[[4]]
      
      # Berechne Arima-Modell fuer aktuelle Datengundlage
      ARIMAindep      <- lapply(windowTs[ ,-1], function(x) auto.arima(x))
      
      daten.lag <- list()
      for(j in 1:count_variable){
        if(lm_lags[j] > 0 && (input$selectHorizont-lm_lags[j] > 0)){
          daten.lag[[j]] <- as.vector(unlist(c(tail(window[ , j+2], n = lm_lags[j]), forecast(ARIMAindep[[j]], h=input$selectHorizont-lm_lags[j])[["mean"]])))
          next
        }else if(input$selectHorizont-lm_lags[j] <= 0){
          daten.lag[[j]] <- as.vector(unlist(tail(window[ , j+2], n = input$selectHorizont)))
        }else if(lm_lags[j] == 0 ){
          daten.lag[[j]] <- as.vector(forecast(ARIMAindep[[j]], h=input$selectHorizont-lm_lags[j])[["mean"]])  
        }
      }
      
      names(daten.lag) <- names(regression.modelle$gespeichertes.modell[[2]])
      
      
      
      # Vorhersage die naechsten "selectHorizont" steps
      mregfcast <- predict(fit.reg, daten.lag)
      
      # Definieren der Zeitserien fuer die Vorhergesagten Werte
      mregfcastTs <- xts(mregfcast, forecasting[[1]])
      
      # AUslesen der abhaengigen Variable des Regressionsmodells
      dependent_var <- regression.modelle$gespeichertes.modell[[7]]
      
      
      # Speichern der Differenzen vom tatsaechlichen und gefitteten Werten
      mreg.diff <- c(mreg.diff, mregfcastTs[,1]-forecastingTs[,input$depVar])
      
      # Speichern der historisch gefitteten Werte
      mreg.forecast<- c(mreg.forecast, mregfcastTs)
      
      
      restVARmodel <- restrict(VAR(windowZweiTs,p=var.modelle$gespeicherte.expl.modelle.restvar[[5]],type = "const"))
      restVARfcst <- predict(restVARmodel, n.ahead=input$selectHorizont)
      restvar.diff <- c(restvar.diff, restVARfcst$fcst[[input$depVar]][,1] -forecasting[,input$depVar][[1]])
      restvar.forecast <- c(restvar.forecast , restVARfcst$fcst[[input$depVar]][,1])

      
    }
    
    
    backtest$timeseries <-cbind(mreg.forecast, restvar.forecast)
    timetestdata <- daten.under$data.test[1:(nrow(daten.under$data.test)-rest),][[1]]
    backtest$timeseriesTs <- xts(backtest$timeseries, timetestdata)
    backtest$timeseriesTs <- cbind(xts(daten.under$default[, input$depVar],start$dates), backtest$timeseriesTs)
    colnames(backtest$timeseriesTs)<-c(input$depVar, "MReg", "Restr.VAR")
    
    rmse.mreg = abs(mreg.diff)
    rmse.restvar = abs(restvar.diff)
    
    RMSE = cbind(rmse.mreg, rmse.restvar)
    RMSE <- xts(RMSE, timetestdata)
    colnames(RMSE)<-c("MReg", "Rest.VAR")
    
  }
  
  if(backtest$choosemodelbacktest == 15){
    
    backtest_data<-var.modelle$gespeicherte.expl.modelle.var[[1]]
    loops<- as.integer(nrow(daten.under$data.test)/input$selectHorizont)
    rest<-nrow(daten.under$data.test)-loops*input$selectHorizont
    
    for(i in 1:loops){
      
      withProgress(min = 0, max = 100, setProgress(value = round(i/loops*100,0),
                                                   message = paste('Calculating loop ',i)))
      
      
      print(i)
      
      if(i == 1){window<- backtest_data}
      
      if(i > 1){
        window <- rbind(backtest_data, daten.under$data.test[1:((i-1)*input$selectHorizont), colnames(backtest_data)])
      }
      
      
      windowTs<-xts(window[,-1], window[[1]])
      
      forecasting <- daten.under$data.test[(1-input$selectHorizont+i*input$selectHorizont):(-input$selectHorizont+i*input$selectHorizont+input$selectHorizont),]
      if(i == 1){backtest$dyevents<-forecasting[[1,1]]}
      if(i > 1){backtest$dyevents<- c(backtest$dyevents, forecasting[[1,1]])}
      forecastingTs <-xts(forecasting[,-1], forecasting[[1]])
      
      VARmodel <- VAR(windowTs,p=var.modelle$gespeicherte.expl.modelle.var[[5]],type = "const")
      VARfcst <- predict(VARmodel, n.ahead=input$selectHorizont)
      var.diff <- c(var.diff, VARfcst$fcst[[input$depVar]][,1] -forecasting[,input$depVar][[1]])
      var.forecast <- c(var.forecast , VARfcst$fcst[[input$depVar]][,1])

      restVARmodel <- restrict(VAR(windowTs,p=var.modelle$gespeicherte.expl.modelle.restvar[[5]],type = "const"))
      restVARfcst <- predict(restVARmodel, n.ahead=input$selectHorizont)
      restvar.diff <- c(restvar.diff, restVARfcst$fcst[[input$depVar]][,1] -forecasting[,input$depVar][[1]])
      restvar.forecast <- c(restvar.forecast , restVARfcst$fcst[[input$depVar]][,1])
      
    }
    
    
    backtest$timeseries <-cbind(var.forecast, restvar.forecast)
    timetestdata <- daten.under$data.test[1:(nrow(daten.under$data.test)-rest),][[1]]
    backtest$timeseriesTs <- xts(backtest$timeseries, timetestdata)
    backtest$timeseriesTs <- cbind(xts(daten.under$default[, input$depVar],start$dates), backtest$timeseriesTs)
    colnames(backtest$timeseriesTs)<-c(input$depVar, "VAR", "Restr.VAR")
    
    rmse.var = abs(var.diff)
    rmse.restvar = abs(restvar.diff)
    RMSE = cbind(rmse.var, rmse.restvar)
    RMSE <- xts(RMSE, timetestdata)
    colnames(RMSE)<-c("VAR", "Rest.VAR")
    
  }  
  
  
  if(backtest$choosemodelbacktest == 16){
    
    backtest_data <-daten.under$base
    backtest_data <- backtest_data[ ,c("Date", regression.modelle$gespeichertes.modell[[7]], names(regression.modelle$gespeichertes.modell[[2]]))]
    
    loops<- as.integer(nrow(daten.under$data.test)/input$selectHorizont)
    rest<-nrow(daten.under$data.test)-loops*input$selectHorizont
    
    for(i in 1:loops){
      
      withProgress(min = 0, max = 100, setProgress(value = round(i/loops*100,0),
                                                   message = paste('Calculating loop ',i)))
      
      
      print(i)
      
      if(i == 1){window<- backtest_data}
      
      if(i > 1){
        window <- rbind(backtest_data, daten.under$data.test[1:((i-1)*input$selectHorizont), colnames(backtest_data)])
      }
      
      
      windowTs<-xts(window[,-1], window[[1]])
      
      forecasting <- daten.under$data.test[(1-input$selectHorizont+i*input$selectHorizont):(-input$selectHorizont+i*input$selectHorizont+input$selectHorizont),]
      
      if(i == 1){backtest$dyevents<-forecasting[[1,1]]}
      if(i > 1){backtest$dyevents<- c(backtest$dyevents, forecasting[[1,1]])}
      forecastingTs <-xts(forecasting[,-1], forecasting[[1]])
      
      fit.reg <- regression.modelle$gespeichertes.modell[[1]]
      
      # Anzahl der beteiligten Variablen am Regressionsmodell
      count_variable <- length(regression.modelle$gespeichertes.modell[[4]])
      lm_lags        <- regression.modelle$gespeichertes.modell[[4]]
      
      # Berechne Arima-Modell fuer aktuelle Datengundlage
      ARIMAindep      <- lapply(windowTs[ ,-1], function(x) auto.arima(x))
      
      daten.lag <- list()
      for(j in 1:count_variable){
        if(lm_lags[j] > 0 && (input$selectHorizont-lm_lags[j] > 0)){
          daten.lag[[j]] <- as.vector(unlist(c(tail(window[ , j+2], n = lm_lags[j]), forecast(ARIMAindep[[j]], h=input$selectHorizont-lm_lags[j])[["mean"]])))
          next
        }else if(input$selectHorizont-lm_lags[j] <= 0){
          daten.lag[[j]] <- as.vector(unlist(tail(window[ , j+2], n = input$selectHorizont)))
        }else if(lm_lags[j] == 0 ){
          daten.lag[[j]] <- as.vector(forecast(ARIMAindep[[j]], h=input$selectHorizont-lm_lags[j])[["mean"]])  
        }
      }
      
      names(daten.lag) <- names(regression.modelle$gespeichertes.modell[[2]])
      
      
      
      # Vorhersage die naechsten "selectHorizont" steps
      mregfcast <- predict(fit.reg, daten.lag)
      
      # Definieren der Zeitserien fuer die Vorhergesagten Werte
      mregfcastTs <- xts(mregfcast, forecasting[[1]])
      
      # AUslesen der abhaengigen Variable des Regressionsmodells
      dependent_var <- regression.modelle$gespeichertes.modell[[7]]
      
      
      # Speichern der Differenzen vom tatsaechlichen und gefitteten Werten
      mreg.diff <- c(mreg.diff, mregfcastTs[,1]-forecastingTs[,input$depVar])
      
      # Speichern der historisch gefitteten Werte
      mreg.forecast<- c(mreg.forecast, mregfcastTs)
      
      
      RWfcst = rwf(windowTs[,input$depVar], h=input$selectHorizont, drift=FALSE)
      RWfcstTs<-xts(as.data.frame(RWfcst), forecasting[[1]])
      rw.diff <- c(rw.diff, RWfcstTs[,1]-forecastingTs[,input$depVar])
      rw.forecast <- c(rw.forecast, RWfcstTs[,1] )
      
      ARIMAmodel = auto.arima(windowTs[,input$depVar],seasonal = FALSE)
      ARIMAfcast <- forecast(ARIMAmodel, h=input$selectHorizont)
      ARIMAfcastTs <- xts(as.data.frame(ARIMAfcast), forecasting[[1]])
      arima.diff <- c(arima.diff, ARIMAfcastTs[,1] -forecastingTs[,input$depVar])
      arima.forecast <- c(arima.forecast, ARIMAfcastTs[,1])
      
      
    }
    
    
    backtest$timeseries <-cbind(rw.forecast, arima.forecast, mreg.forecast)
    timetestdata <- daten.under$data.test[1:(nrow(daten.under$data.test)-rest),][[1]]
    backtest$timeseriesTs <- xts(backtest$timeseries, timetestdata)
    backtest$timeseriesTs <- cbind(xts(daten.under$default[, input$depVar],start$dates), backtest$timeseriesTs)
    colnames(backtest$timeseriesTs)<-c(input$depVar, "RW", "ARIMA","MReg")
    
    rmse.mreg = abs(mreg.diff)
    rmse.rw = abs(rw.diff)
    rmse.arima= abs(arima.diff)
    
    RMSE = cbind(rmse.rw, rmse.arima, rmse.mreg)
    RMSE <- xts(RMSE, timetestdata)
    colnames(RMSE)<-c("RW","ARIMA","MReg")
    
  }
  
  if(backtest$choosemodelbacktest == 17){
    
    backtest_data<-var.modelle$gespeicherte.expl.modelle.var[[1]]
    loops<- as.integer(nrow(daten.under$data.test)/input$selectHorizont)
    rest<-nrow(daten.under$data.test)-loops*input$selectHorizont
    
    for(i in 1:loops){
      
      withProgress(min = 0, max = 100, setProgress(value = round(i/loops*100,0),
                                                   message = paste('Calculating loop ',i)))
      
      
      print(i)
      
      if(i == 1){window<- backtest_data}
      
      if(i > 1){
        window <- rbind(backtest_data, daten.under$data.test[1:((i-1)*input$selectHorizont), colnames(backtest_data)])
      }
      
      
      windowTs<-xts(window[,-1], window[[1]])
      
      forecasting <- daten.under$data.test[(1-input$selectHorizont+i*input$selectHorizont):(-input$selectHorizont+i*input$selectHorizont+input$selectHorizont),]
      
      if(i == 1){backtest$dyevents<-forecasting[[1,1]]}
      if(i > 1){backtest$dyevents<- c(backtest$dyevents, forecasting[[1,1]])}
      forecastingTs <-xts(forecasting[,-1], forecasting[[1]])
      
      ARIMAmodel = auto.arima(windowTs[,input$depVar],seasonal = FALSE)
      ARIMAfcast <- forecast(ARIMAmodel, h=input$selectHorizont)
      ARIMAfcastTs <- xts(as.data.frame(ARIMAfcast), forecasting[[1]])
      arima.diff <- c(arima.diff, ARIMAfcastTs[,1] -forecastingTs[,input$depVar])
      arima.forecast <- c(arima.forecast, ARIMAfcastTs[,1])
      
      VARmodel <- VAR(windowTs,p=var.modelle$gespeicherte.expl.modelle.var[[5]],type = "const")
      VARfcst <- predict(VARmodel, n.ahead=input$selectHorizont)
      var.diff <- c(var.diff, VARfcst$fcst[[input$depVar]][,1] -forecasting[,input$depVar][[1]])
      var.forecast <- c(var.forecast , VARfcst$fcst[[input$depVar]][,1])

      
      RWfcst = rwf(windowTs[,input$depVar], h=input$selectHorizont, drift=FALSE)
      RWfcstTs<-xts(as.data.frame(RWfcst), forecasting[[1]])
      rw.diff <- c(rw.diff, RWfcstTs[,1]-forecastingTs[,input$depVar])
      rw.forecast <- c(rw.forecast, RWfcstTs[,1] )
      
      
    }
    
    
    backtest$timeseries <-cbind(rw.forecast, arima.forecast, var.forecast)
    timetestdata <- daten.under$data.test[1:(nrow(daten.under$data.test)-rest),][[1]]
    backtest$timeseriesTs <- xts(backtest$timeseries, timetestdata)
    backtest$timeseriesTs <- cbind(xts(daten.under$default[, input$depVar],start$dates), backtest$timeseriesTs)
    colnames(backtest$timeseriesTs)<-c(input$depVar, "RW", "ARIMA","VAR")
    
    rmse.rw = abs(rw.diff)
    rmse.arima = abs(arima.diff)
    rmse.var = abs(var.diff)
    RMSE = cbind(rmse.rw, rmse.arima, rmse.var)
    RMSE <- xts(RMSE, timetestdata)
    colnames(RMSE)<-c("RW","ARIMA" ,"VAR")
    
  } 
  
  
  if(backtest$choosemodelbacktest == 18){
    
    backtest_data<-var.modelle$gespeicherte.expl.modelle.restvar[[1]]
    loops<- as.integer(nrow(daten.under$data.test)/input$selectHorizont)
    rest<-nrow(daten.under$data.test)-loops*input$selectHorizont
    
    for(i in 1:loops){
      
      withProgress(min = 0, max = 100, setProgress(value = round(i/loops*100,0),
                                                   message = paste('Calculating loop ',i)))
      
      
      print(i)
      
      if(i == 1){window<- backtest_data}
      
      if(i > 1){
        window <- rbind(backtest_data, daten.under$data.test[1:((i-1)*input$selectHorizont), colnames(backtest_data)])
      }
      
      
      windowTs<-xts(window[,-1], window[[1]])
      
      forecasting <- daten.under$data.test[(1-input$selectHorizont+i*input$selectHorizont):(-input$selectHorizont+i*input$selectHorizont+input$selectHorizont),]
      
      if(i == 1){backtest$dyevents<-forecasting[[1,1]]}
      if(i > 1){backtest$dyevents<- c(backtest$dyevents, forecasting[[1,1]])}
      forecastingTs <-xts(forecasting[,-1], forecasting[[1]])
      
      ARIMAmodel = auto.arima(windowTs[,input$depVar],seasonal = FALSE)
      ARIMAfcast <- forecast(ARIMAmodel, h=input$selectHorizont)
      ARIMAfcastTs <- xts(as.data.frame(ARIMAfcast), forecasting[[1]])
      arima.diff <- c(arima.diff, ARIMAfcastTs[,1] -forecastingTs[,input$depVar])
      arima.forecast <- c(arima.forecast, ARIMAfcastTs[,1])
      
      restVARmodel <- restrict(VAR(windowZweiTs,p=var.modelle$gespeicherte.expl.modelle.restvar[[5]],type = "const"))
      restVARfcst <- predict(restVARmodel, n.ahead=input$selectHorizont)
      restvar.diff <- c(var.diff, restVARfcst$fcst[[input$depVar]][,1] -forecasting[,input$depVar][[1]])
      restvar.forecast <- c(restvar.forecast , restVARfcst$fcst[[input$depVar]][,1])
      
      
      RWfcst = rwf(windowTs[,input$depVar], h=input$selectHorizont, drift=FALSE)
      RWfcstTs<-xts(as.data.frame(RWfcst), forecasting[[1]])
      rw.diff <- c(rw.diff, RWfcstTs[,1]-forecastingTs[,input$depVar])
      rw.forecast <- c(rw.forecast, RWfcstTs[,1] )
      
      
    }
    
    
    backtest$timeseries <-cbind(rw.forecast, arima.forecast, restvar.forecast)
    timetestdata <- daten.under$data.test[1:(nrow(daten.under$data.test)-rest),][[1]]
    backtest$timeseriesTs <- xts(backtest$timeseries, timetestdata)
    backtest$timeseriesTs <- cbind(xts(daten.under$default[, input$depVar],start$dates), backtest$timeseriesTs)
    colnames(backtest$timeseriesTs)<-c(input$depVar, "RW", "ARIMA","Restr.VAR")
    
    rmse.rw = abs(rw.diff)
    rmse.arima = abs(arima.diff)
    rmse.restvar = abs(restvar.diff)
    RMSE = cbind(rmse.rw, rmse.arima, rmse.restvar)
    RMSE <- xts(RMSE, timetestdata)
    colnames(RMSE)<-c("RW","ARIMA" ,"Restr.VAR")
    
  } 
  
  if(backtest$choosemodelbacktest == 19){
    
    backtest_data_var <-var.modelle$gespeicherte.expl.modelle.var[[1]]
    
    backtest_data <- daten.under$base[ ,c("Date", regression.modelle$gespeichertes.modell[[7]], names(regression.modelle$gespeichertes.modell[[2]]))]
    
    loops<- as.integer(nrow(daten.under$data.test)/input$selectHorizont)
    rest<-nrow(daten.under$data.test)-loops*input$selectHorizont
    
    for(i in 1:loops){
      
      withProgress(min = 0, max = 100, setProgress(value = round(i/loops*100,0),
                                                   message = paste('Calculating loop ',i)))
      
      
      print(i)
      
      if(i == 1){
        window<- backtest_data
        windowZwei<-backtest_data_var
      }
      
      if(i > 1){
        window <- rbind(backtest_data, daten.under$data.test[1:((i-1)*input$selectHorizont), colnames(backtest_data)])
        windowZwei <- rbind(backtest_data_var, daten.under$data.test[1:((i-1)*input$selectHorizont), colnames(backtest_data_var)])
      }
      
      
      windowTs<-xts(window[,-1], window[[1]])
      windowZweiTs<-xts(windowZwei[,-1], windowZwei[[1]])
      
      forecasting <- daten.under$data.test[(1-input$selectHorizont+i*input$selectHorizont):(-input$selectHorizont+i*input$selectHorizont+input$selectHorizont),]
      if(i == 1){backtest$dyevents<-forecasting[[1,1]]}
      if(i > 1){backtest$dyevents<- c(backtest$dyevents, forecasting[[1,1]])}
      forecastingTs <-xts(forecasting[,-1], forecasting[[1]])
      
      fit.reg <- regression.modelle$gespeichertes.modell[[1]]
      
      # Anzahl der beteiligten Variablen am Regressionsmodell
      count_variable <- length(regression.modelle$gespeichertes.modell[[4]])
      lm_lags        <- regression.modelle$gespeichertes.modell[[4]]
      
      # Berechne Arima-Modell fuer aktuelle Datengundlage
      ARIMAindep      <- lapply(windowTs[ ,-1], function(x) auto.arima(x))
      
      daten.lag <- list()
      for(j in 1:count_variable){
        if(lm_lags[j] > 0 && (input$selectHorizont-lm_lags[j] > 0)){
          daten.lag[[j]] <- as.vector(unlist(c(tail(window[ , j+2], n = lm_lags[j]), forecast(ARIMAindep[[j]], h=input$selectHorizont-lm_lags[j])[["mean"]])))
          next
        }else if(input$selectHorizont-lm_lags[j] <= 0){
          daten.lag[[j]] <- as.vector(unlist(tail(window[ , j+2], n = input$selectHorizont)))
        }else if(lm_lags[j] == 0 ){
          daten.lag[[j]] <- as.vector(forecast(ARIMAindep[[j]], h=input$selectHorizont-lm_lags[j])[["mean"]])  
        }
      }
      
      names(daten.lag) <- names(regression.modelle$gespeichertes.modell[[2]])
      
      
      
      # Vorhersage die naechsten "selectHorizont" steps
      mregfcast <- predict(fit.reg, daten.lag)
      
      # Definieren der Zeitserien fuer die Vorhergesagten Werte
      mregfcastTs <- xts(mregfcast, forecasting[[1]])
      
      # AUslesen der abhaengigen Variable des Regressionsmodells
      dependent_var <- regression.modelle$gespeichertes.modell[[7]]
      
      
      # Speichern der Differenzen vom tatsaechlichen und gefitteten Werten
      mreg.diff <- c(mreg.diff, mregfcastTs[,1]-forecastingTs[,input$depVar])
      
      # Speichern der historisch gefitteten Werte
      mreg.forecast<- c(mreg.forecast, mregfcastTs)
      
      
      RWfcst = rwf(windowTs[,input$depVar], h=input$selectHorizont, drift=FALSE)
      RWfcstTs<-xts(as.data.frame(RWfcst), forecasting[[1]])
      rw.diff <- c(rw.diff, RWfcstTs[,1]-forecastingTs[,input$depVar])
      rw.forecast <- c(rw.forecast, RWfcstTs[,1] )
      
      VARmodel <- VAR(windowZweiTs,p=var.modelle$gespeicherte.expl.modelle.var[[5]],type = "const")
      VARfcst <- predict(VARmodel, n.ahead=input$selectHorizont)
      var.diff <- c(var.diff, VARfcst$fcst[[input$depVar]][,1] -forecasting[,input$depVar][[1]])
      var.forecast <- c(var.forecast , VARfcst$fcst[[input$depVar]][,1])
      
      
      
    }
    
    
    backtest$timeseries <-cbind(rw.forecast, mreg.forecast, var.forecast)
    timetestdata <- daten.under$data.test[1:(nrow(daten.under$data.test)-rest),][[1]]
    backtest$timeseriesTs <- xts(backtest$timeseries, timetestdata)
    backtest$timeseriesTs <- cbind(xts(daten.under$default[, input$depVar],start$dates), backtest$timeseriesTs)
    colnames(backtest$timeseriesTs)<-c(input$depVar, "RW", "MReg", "VAR")
    
    rmse.rw = abs(rw.diff)
    rmse.mreg = abs(mreg.diff)
    rmse.var = abs(var.diff)
    
    RMSE = cbind(rmse.rw, rmse.mreg, rmse.var)
    RMSE <- xts(RMSE, timetestdata)
    colnames(RMSE)<-c("RW", "MReg", "VAR")
    
  }
  
  if(backtest$choosemodelbacktest == 20){
    
    backtest_data_var <-var.modelle$gespeicherte.expl.modelle.restvar[[1]]
    
    backtest_data <- daten.under$base[ ,c("Date", regression.modelle$gespeichertes.modell[[7]], names(regression.modelle$gespeichertes.modell[[2]]))]
    
    loops<- as.integer(nrow(daten.under$data.test)/input$selectHorizont)
    rest<-nrow(daten.under$data.test)-loops*input$selectHorizont
    
    for(i in 1:loops){
      
      withProgress(min = 0, max = 100, setProgress(value = round(i/loops*100,0),
                                                   message = paste('Calculating loop ',i)))
      
      
      print(i)
      
      if(i == 1){
        window<- backtest_data
        windowZwei<-backtest_data_var
      }
      
      if(i > 1){
        window <- rbind(backtest_data, daten.under$data.test[1:((i-1)*input$selectHorizont), colnames(backtest_data)])
        windowZwei <- rbind(backtest_data_var, daten.under$data.test[1:((i-1)*input$selectHorizont), colnames(backtest_data_var)])
      }
      
      
      windowTs<-xts(window[,-1], window[[1]])
      windowZweiTs<-xts(windowZwei[,-1], windowZwei[[1]])
      
      forecasting <- daten.under$data.test[(1-input$selectHorizont+i*input$selectHorizont):(-input$selectHorizont+i*input$selectHorizont+input$selectHorizont),]
      
      if(i == 1){backtest$dyevents<-forecasting[[1,1]]}
      if(i > 1){backtest$dyevents<- c(backtest$dyevents, forecasting[[1,1]])}
      forecastingTs <-xts(forecasting[,-1], forecasting[[1]])
      
      fit.reg <- regression.modelle$gespeichertes.modell[[1]]
      
      # Anzahl der beteiligten Variablen am Regressionsmodell
      count_variable <- length(regression.modelle$gespeichertes.modell[[4]])
      lm_lags        <- regression.modelle$gespeichertes.modell[[4]]
      
      # Berechne Arima-Modell fuer aktuelle Datengundlage
      ARIMAindep      <- lapply(windowTs[ ,-1], function(x) auto.arima(x))
      
      daten.lag <- list()
      for(j in 1:count_variable){
        if(lm_lags[j] > 0 && (input$selectHorizont-lm_lags[j] > 0)){
          daten.lag[[j]] <- as.vector(unlist(c(tail(window[ , j+2], n = lm_lags[j]), forecast(ARIMAindep[[j]], h=input$selectHorizont-lm_lags[j])[["mean"]])))
          next
        }else if(input$selectHorizont-lm_lags[j] <= 0){
          daten.lag[[j]] <- as.vector(unlist(tail(window[ , j+2], n = input$selectHorizont)))
        }else if(lm_lags[j] == 0 ){
          daten.lag[[j]] <- as.vector(forecast(ARIMAindep[[j]], h=input$selectHorizont-lm_lags[j])[["mean"]])  
        }
      }
      
      names(daten.lag) <- names(regression.modelle$gespeichertes.modell[[2]])
      
      
      
      # Vorhersage die naechsten "selectHorizont" steps
      mregfcast <- predict(fit.reg, daten.lag)
      
      # Definieren der Zeitserien fuer die Vorhergesagten Werte
      mregfcastTs <- xts(mregfcast, forecasting[[1]])
      
      # AUslesen der abhaengigen Variable des Regressionsmodells
      dependent_var <- regression.modelle$gespeichertes.modell[[7]]
      
      
      # Speichern der Differenzen vom tatsaechlichen und gefitteten Werten
      mreg.diff <- c(mreg.diff, mregfcastTs[,1]-forecastingTs[,input$depVar])
      
      # Speichern der historisch gefitteten Werte
      mreg.forecast<- c(mreg.forecast, mregfcastTs)
      
      
      RWfcst = rwf(windowTs[,input$depVar], h=input$selectHorizont, drift=FALSE)
      RWfcstTs<-xts(as.data.frame(RWfcst), forecasting[[1]])
      rw.diff <- c(rw.diff, RWfcstTs[,1]-forecastingTs[,input$depVar])
      rw.forecast <- c(rw.forecast, RWfcstTs[,1] )
      
      restVARmodel <- restrict(VAR(windowZweiTs,p=var.modelle$gespeicherte.expl.modelle.restvar[[5]],type = "const"))
      restVARfcst <- predict(restVARmodel, n.ahead=input$selectHorizont)
      restvar.diff <- c(restvar.diff, restVARfcst$fcst[[input$depVar]][,1] -forecasting[,input$depVar][[1]])
      restvar.forecast <- c(restvar.forecast , restVARfcst$fcst[[input$depVar]][,1])
      
      
      
    }
    
    
    backtest$timeseries <-cbind(rw.forecast, mreg.forecast, restvar.forecast)
    timetestdata <- daten.under$data.test[1:(nrow(daten.under$data.test)-rest),][[1]]
    backtest$timeseriesTs <- xts(backtest$timeseries, timetestdata)
    backtest$timeseriesTs <- cbind(xts(daten.under$default[, input$depVar],start$dates), backtest$timeseriesTs)
    colnames(backtest$timeseriesTs)<-c(input$depVar, "RW", "MReg", "Restr.VAR")
    
    rmse.rw = abs(rw.diff)
    rmse.mreg = abs(mreg.diff)
    rmse.restvar = abs(restvar.diff)
    
    RMSE = cbind(rmse.rw, rmse.mreg, rmse.restvar)
    RMSE <- xts(RMSE, timetestdata)
    colnames(RMSE)<-c("RW", "MReg", "Rest.VAR")
    
  }
  
  if(backtest$choosemodelbacktest == 21){
    
    backtest_data<-var.modelle$gespeicherte.expl.modelle.var[[1]]
    loops<- as.integer(nrow(daten.under$data.test)/input$selectHorizont)
    rest<-nrow(daten.under$data.test)-loops*input$selectHorizont
    
    for(i in 1:loops){
      
      withProgress(min = 0, max = 100, setProgress(value = round(i/loops*100,0),
                                                   message = paste('Calculating loop ',i)))
      
      
      print(i)
      
      if(i == 1){window<- backtest_data}
      
      if(i > 1){
        window <- rbind(backtest_data, daten.under$data.test[1:((i-1)*input$selectHorizont), colnames(backtest_data)])
      }
      
      
      windowTs<-xts(window[,-1], window[[1]])
      
      forecasting <- daten.under$data.test[(1-input$selectHorizont+i*input$selectHorizont):(-input$selectHorizont+i*input$selectHorizont+input$selectHorizont),]
      
      if(i == 1){backtest$dyevents<-forecasting[[1,1]]}
      if(i > 1){backtest$dyevents<- c(backtest$dyevents, forecasting[[1,1]])}
      forecastingTs <-xts(forecasting[,-1], forecasting[[1]])
      
      
      RWfcst = rwf(windowTs[,input$depVar], h=input$selectHorizont, drift=FALSE)
      RWfcstTs<-xts(as.data.frame(RWfcst), forecasting[[1]])
      rw.diff <- c(rw.diff, RWfcstTs[,1]-forecastingTs[,input$depVar])
      rw.forecast <- c(rw.forecast, RWfcstTs[,1] )
      
      VARmodel <- VAR(windowTs,p=var.modelle$gespeicherte.expl.modelle.var[[5]],type = "const")
      VARfcst <- predict(VARmodel, n.ahead=input$selectHorizont)
      var.diff <- c(var.diff, VARfcst$fcst[[input$depVar]][,1] -forecasting[,input$depVar][[1]])
      var.forecast <- c(var.forecast , VARfcst$fcst[[input$depVar]][,1])
      
      restVARmodel <- restrict(VAR(windowTs,p=var.modelle$gespeicherte.expl.modelle.restvar[[5]],type = "const"))
      restVARfcst <- predict(restVARmodel, n.ahead=input$selectHorizont)
      restvar.diff <- c(restvar.diff, restVARfcst$fcst[[input$depVar]][,1] -forecasting[,input$depVar][[1]])
      restvar.forecast <- c(restvar.forecast , restVARfcst$fcst[[input$depVar]][,1])
      
    }
    
    
    backtest$timeseries <-cbind(rw.forecast, var.forecast, restvar.forecast)
    timetestdata <- daten.under$data.test[1:(nrow(daten.under$data.test)-rest),][[1]]
    backtest$timeseriesTs <- xts(backtest$timeseries, timetestdata)
    backtest$timeseriesTs <- cbind(xts(daten.under$default[, input$depVar],start$dates), backtest$timeseriesTs)
    colnames(backtest$timeseriesTs)<-c(input$depVar, "RW","VAR", "Restr.VAR")
    
    rmse.rw = abs(rw.diff)
    rmse.var = abs(var.diff)
    rmse.restvar = abs(restvar.diff)
    RMSE = cbind(rmse.rw, rmse.var, rmse.restvar)
    RMSE <- xts(RMSE, timetestdata)
    colnames(RMSE)<-c("RW","VAR", "Rest.VAR")
    
  }  
  
  if(backtest$choosemodelbacktest == 22){
    
    backtest_data_var <-var.modelle$gespeicherte.expl.modelle.var[[1]]
    
    backtest_data <- daten.under$base[ ,c("Date", regression.modelle$gespeichertes.modell[[7]], names(regression.modelle$gespeichertes.modell[[2]]))]
    
    loops<- as.integer(nrow(daten.under$data.test)/input$selectHorizont)
    rest<-nrow(daten.under$data.test)-loops*input$selectHorizont
    
    for(i in 1:loops){
      
      withProgress(min = 0, max = 100, setProgress(value = round(i/loops*100,0),
                                                   message = paste('Calculating loop ',i)))
      
      
      print(i)
      
      if(i == 1){
        window<- backtest_data
        windowZwei<-backtest_data_var
      }
      
      if(i > 1){
        window <- rbind(backtest_data, daten.under$data.test[1:((i-1)*input$selectHorizont), colnames(backtest_data)])
        windowZwei <- rbind(backtest_data_var, daten.under$data.test[1:((i-1)*input$selectHorizont), colnames(backtest_data_var)])
      }
      
      
      windowTs<-xts(window[,-1], window[[1]])
      windowZweiTs<-xts(windowZwei[,-1], windowZwei[[1]])
      
      forecasting <- daten.under$data.test[(1-input$selectHorizont+i*input$selectHorizont):(-input$selectHorizont+i*input$selectHorizont+input$selectHorizont),]
      
      if(i == 1){backtest$dyevents<-forecasting[[1,1]]}
      if(i > 1){backtest$dyevents<- c(backtest$dyevents, forecasting[[1,1]])}
      forecastingTs <-xts(forecasting[,-1], forecasting[[1]])
      
      fit.reg <- regression.modelle$gespeichertes.modell[[1]]
      
      # Anzahl der beteiligten Variablen am Regressionsmodell
      count_variable <- length(regression.modelle$gespeichertes.modell[[4]])
      lm_lags        <- regression.modelle$gespeichertes.modell[[4]]
      
      # Berechne Arima-Modell fuer aktuelle Datengundlage
      ARIMAindep      <- lapply(windowTs[ ,-1], function(x) auto.arima(x))
      
      daten.lag <- list()
      for(j in 1:count_variable){
        if(lm_lags[j] > 0 && (input$selectHorizont-lm_lags[j] > 0)){
          daten.lag[[j]] <- as.vector(unlist(c(tail(window[ , j+2], n = lm_lags[j]), forecast(ARIMAindep[[j]], h=input$selectHorizont-lm_lags[j])[["mean"]])))
          next
        }else if(input$selectHorizont-lm_lags[j] <= 0){
          daten.lag[[j]] <- as.vector(unlist(tail(window[ , j+2], n = input$selectHorizont)))
        }else if(lm_lags[j] == 0 ){
          daten.lag[[j]] <- as.vector(forecast(ARIMAindep[[j]], h=input$selectHorizont-lm_lags[j])[["mean"]])  
        }
      }
      
      names(daten.lag) <- names(regression.modelle$gespeichertes.modell[[2]])
      
      
      
      # Vorhersage die naechsten "selectHorizont" steps
      mregfcast <- predict(fit.reg, daten.lag)
      
      # Definieren der Zeitserien fuer die Vorhergesagten Werte
      mregfcastTs <- xts(mregfcast, forecasting[[1]])
      
      # AUslesen der abhaengigen Variable des Regressionsmodells
      dependent_var <- regression.modelle$gespeichertes.modell[[7]]
      
      
      # Speichern der Differenzen vom tatsaechlichen und gefitteten Werten
      mreg.diff <- c(mreg.diff, mregfcastTs[,1]-forecastingTs[,input$depVar])
      
      # Speichern der historisch gefitteten Werte
      mreg.forecast<- c(mreg.forecast, mregfcastTs)
      
      
      VARmodel <- VAR(windowZweiTs,p=var.modelle$gespeicherte.expl.modelle.var[[5]],type = "const")
      VARfcst <- predict(VARmodel, n.ahead=input$selectHorizont)
      var.diff <- c(var.diff, VARfcst$fcst[[input$depVar]][,1] -forecasting[,input$depVar][[1]])
      var.forecast <- c(var.forecast , VARfcst$fcst[[input$depVar]][,1])
      
      restVARmodel <- restrict(VAR(windowZweiTs,p=var.modelle$gespeicherte.expl.modelle.restvar[[5]],type = "const"))
      restVARfcst <- predict(restVARmodel, n.ahead=input$selectHorizont)
      restvar.diff <- c(restvar.diff, restVARfcst$fcst[[input$depVar]][,1] -forecasting[,input$depVar][[1]])
      restvar.forecast <- c(restvar.forecast , restVARfcst$fcst[[input$depVar]][,1])
      
      
    }
    
    
    backtest$timeseries <-cbind(mreg.forecast, var.forecast, restvar.forecast)
    timetestdata <- daten.under$data.test[1:(nrow(daten.under$data.test)-rest),][[1]]
    backtest$timeseriesTs <- xts(backtest$timeseries, timetestdata)
    backtest$timeseriesTs <- cbind(xts(daten.under$default[, input$depVar],start$dates), backtest$timeseriesTs)
    colnames(backtest$timeseriesTs)<-c(input$depVar, "MReg", "VAR", "Rest.VAR")
    
    rmse.restvar = abs(restvar.diff)
    rmse.mreg = abs(mreg.diff)
    rmse.var = abs(var.diff)
    
    RMSE = cbind(rmse.mreg, rmse.var, rmse.restvar)
    RMSE <- xts(RMSE, timetestdata)
    colnames(RMSE)<-c("MReg", "VAR", "Rest.VAR")
    
  }
  
  if(backtest$choosemodelbacktest == 23){
    
    backtest_data_var <-var.modelle$gespeicherte.expl.modelle.var[[1]]
    
    backtest_data <- daten.under$base[ ,c("Date", regression.modelle$gespeichertes.modell[[7]], names(regression.modelle$gespeichertes.modell[[2]]))]
    
    loops<- as.integer(nrow(daten.under$data.test)/input$selectHorizont)
    rest<-nrow(daten.under$data.test)-loops*input$selectHorizont
    
    for(i in 1:loops){
      
      withProgress(min = 0, max = 100, setProgress(value = round(i/loops*100,0),
                                                   message = paste('Calculating loop ',i)))
      
      
      print(i)
      
      if(i == 1){
        window<- backtest_data
        windowZwei<-backtest_data_var
      }
      
      if(i > 1){
        window <- rbind(backtest_data, daten.under$data.test[1:((i-1)*input$selectHorizont), colnames(backtest_data)])
        windowZwei <- rbind(backtest_data_var, daten.under$data.test[1:((i-1)*input$selectHorizont), colnames(backtest_data_var)])
      }
      
      
      windowTs<-xts(window[,-1], window[[1]])
      windowZweiTs<-xts(windowZwei[,-1], windowZwei[[1]])
      
      forecasting <- daten.under$data.test[(1-input$selectHorizont+i*input$selectHorizont):(-input$selectHorizont+i*input$selectHorizont+input$selectHorizont),]
      
      if(i == 1){backtest$dyevents<-forecasting[[1,1]]}
      if(i > 1){backtest$dyevents<- c(backtest$dyevents, forecasting[[1,1]])}
      forecastingTs <-xts(forecasting[,-1], forecasting[[1]])
      
      fit.reg <- regression.modelle$gespeichertes.modell[[1]]
      
      # Anzahl der beteiligten Variablen am Regressionsmodell
      count_variable <- length(regression.modelle$gespeichertes.modell[[4]])
      lm_lags        <- regression.modelle$gespeichertes.modell[[4]]
      
      # Berechne Arima-Modell fuer aktuelle Datengundlage
      ARIMAindep      <- lapply(windowTs[ ,-1], function(x) auto.arima(x))
      
      daten.lag <- list()
      for(j in 1:count_variable){
        if(lm_lags[j] > 0 && (input$selectHorizont-lm_lags[j] > 0)){
          daten.lag[[j]] <- as.vector(unlist(c(tail(window[ , j+2], n = lm_lags[j]), forecast(ARIMAindep[[j]], h=input$selectHorizont-lm_lags[j])[["mean"]])))
          next
        }else if(input$selectHorizont-lm_lags[j] <= 0){
          daten.lag[[j]] <- as.vector(unlist(tail(window[ , j+2], n = input$selectHorizont)))
        }else if(lm_lags[j] == 0 ){
          daten.lag[[j]] <- as.vector(forecast(ARIMAindep[[j]], h=input$selectHorizont-lm_lags[j])[["mean"]])  
        }
      }
      
      names(daten.lag) <- names(regression.modelle$gespeichertes.modell[[2]])
      
      
      
      # Vorhersage die naechsten "selectHorizont" steps
      mregfcast <- predict(fit.reg, daten.lag)
      
      # Definieren der Zeitserien fuer die Vorhergesagten Werte
      mregfcastTs <- xts(mregfcast, forecasting[[1]])
      
      # AUslesen der abhaengigen Variable des Regressionsmodells
      dependent_var <- regression.modelle$gespeichertes.modell[[7]]
      
      
      # Speichern der Differenzen vom tatsaechlichen und gefitteten Werten
      mreg.diff <- c(mreg.diff, mregfcastTs[,1]-forecastingTs[,input$depVar])
      
      # Speichern der historisch gefitteten Werte
      mreg.forecast<- c(mreg.forecast, mregfcastTs)
      
      ARIMAmodel = auto.arima(windowTs[,input$depVar],seasonal = FALSE)
      ARIMAfcast <- forecast(ARIMAmodel, h=input$selectHorizont)
      ARIMAfcastTs <- xts(as.data.frame(ARIMAfcast), forecasting[[1]])
      arima.diff <- c(arima.diff, ARIMAfcastTs[,1] -forecastingTs[,input$depVar])
      arima.forecast <- c(arima.forecast, ARIMAfcastTs[,1])
      
      VARmodel <- VAR(windowZweiTs,p=var.modelle$gespeicherte.expl.modelle.var[[5]],type = "const")
      VARfcst <- predict(VARmodel, n.ahead=input$selectHorizont)
      var.diff <- c(var.diff, VARfcst$fcst[[input$depVar]][,1] -forecasting[,input$depVar][[1]])
      var.forecast <- c(var.forecast , VARfcst$fcst[[input$depVar]][,1])
      
      restVARmodel <- restrict(VAR(windowZweiTs,p=var.modelle$gespeicherte.expl.modelle.restvar[[5]],type = "const"))
      restVARfcst <- predict(restVARmodel, n.ahead=input$selectHorizont)
      restvar.diff <- c(restvar.diff, restVARfcst$fcst[[input$depVar]][,1] -forecasting[,input$depVar][[1]])
      restvar.forecast <- c(restvar.forecast , restVARfcst$fcst[[input$depVar]][,1])
      
      
    }
    
    
    backtest$timeseries <-cbind(arima.forecast, mreg.forecast, var.forecast, restvar.forecast)
    timetestdata <- daten.under$data.test[1:(nrow(daten.under$data.test)-rest),][[1]]
    backtest$timeseriesTs <- xts(backtest$timeseries, timetestdata)
    backtest$timeseriesTs <- cbind(xts(daten.under$default[, input$depVar],start$dates), backtest$timeseriesTs)
    colnames(backtest$timeseriesTs)<-c(input$depVar, "ARIMA","MReg", "VAR", "Rest.VAR")
    
    rmse.arima = abs(arima.diff)
    rmse.restvar = abs(restvar.diff)
    rmse.mreg = abs(mreg.diff)
    rmse.var = abs(var.diff)
    
    RMSE = cbind(rmse.arima, rmse.mreg, rmse.var, rmse.restvar)
    RMSE <- xts(RMSE, timetestdata)
    colnames(RMSE)<-c("ARIMA","MReg", "VAR", "Rest.VAR")
    
  }
  
  if(backtest$choosemodelbacktest == 24){
    
    backtest_data_var <-var.modelle$gespeicherte.expl.modelle.var[[1]]
    
    backtest_data <- daten.under$base[ ,c("Date", regression.modelle$gespeichertes.modell[[7]], names(regression.modelle$gespeichertes.modell[[2]]))]
    
    loops<- as.integer(nrow(daten.under$data.test)/input$selectHorizont)
    rest<-nrow(daten.under$data.test)-loops*input$selectHorizont
    
    for(i in 1:loops){
      
      withProgress(min = 0, max = 100, setProgress(value = round(i/loops*100,0),
                                                   message = paste('Calculating loop ',i)))
      
      
      print(i)
      
      if(i == 1){
        window<- backtest_data
        windowZwei<-backtest_data_var
      }
      
      if(i > 1){
        window <- rbind(backtest_data, daten.under$data.test[1:((i-1)*input$selectHorizont), colnames(backtest_data)])
        windowZwei <- rbind(backtest_data_var, daten.under$data.test[1:((i-1)*input$selectHorizont), colnames(backtest_data_var)])
      }
      
      
      windowTs<-xts(window[,-1], window[[1]])
      windowZweiTs<-xts(windowZwei[,-1], windowZwei[[1]])
      
      forecasting <- daten.under$data.test[(1-input$selectHorizont+i*input$selectHorizont):(-input$selectHorizont+i*input$selectHorizont+input$selectHorizont),]
      
      if(i == 1){backtest$dyevents<-forecasting[[1,1]]}
      if(i > 1){backtest$dyevents<- c(backtest$dyevents, forecasting[[1,1]])}
      forecastingTs <-xts(forecasting[,-1], forecasting[[1]])
      
      fit.reg <- regression.modelle$gespeichertes.modell[[1]]
      
      # Anzahl der beteiligten Variablen am Regressionsmodell
      count_variable <- length(regression.modelle$gespeichertes.modell[[4]])
      lm_lags        <- regression.modelle$gespeichertes.modell[[4]]
      
      # Berechne Arima-Modell fuer aktuelle Datengundlage
      ARIMAindep      <- lapply(windowTs[ ,-1], function(x) auto.arima(x))
      
      daten.lag <- list()
      for(j in 1:count_variable){
        if(lm_lags[j] > 0 && (input$selectHorizont-lm_lags[j] > 0)){
          daten.lag[[j]] <- as.vector(unlist(c(tail(window[ , j+2], n = lm_lags[j]), forecast(ARIMAindep[[j]], h=input$selectHorizont-lm_lags[j])[["mean"]])))
          next
        }else if(input$selectHorizont-lm_lags[j] <= 0){
          daten.lag[[j]] <- as.vector(unlist(tail(window[ , j+2], n = input$selectHorizont)))
        }else if(lm_lags[j] == 0 ){
          daten.lag[[j]] <- as.vector(forecast(ARIMAindep[[j]], h=input$selectHorizont-lm_lags[j])[["mean"]])  
        }
      }
      
      names(daten.lag) <- names(regression.modelle$gespeichertes.modell[[2]])
      
      
      
      # Vorhersage die naechsten "selectHorizont" steps
      mregfcast <- predict(fit.reg, daten.lag)
      
      # Definieren der Zeitserien fuer die Vorhergesagten Werte
      mregfcastTs <- xts(mregfcast, forecasting[[1]])
      
      # AUslesen der abhaengigen Variable des Regressionsmodells
      dependent_var <- regression.modelle$gespeichertes.modell[[7]]
      
      
      # Speichern der Differenzen vom tatsaechlichen und gefitteten Werten
      mreg.diff <- c(mreg.diff, mregfcastTs[,1]-forecastingTs[,input$depVar])
      
      # Speichern der historisch gefitteten Werte
      mreg.forecast<- c(mreg.forecast, mregfcastTs)
      
      RWfcst = rwf(windowTs[,input$depVar], h=input$selectHorizont, drift=FALSE)
      RWfcstTs<-xts(as.data.frame(RWfcst), forecasting[[1]])
      rw.diff <- c(rw.diff, RWfcstTs[,1]-forecastingTs[,input$depVar])
      rw.forecast <- c(rw.forecast, RWfcstTs[,1] )
      
      VARmodel <- VAR(windowZweiTs,p=var.modelle$gespeicherte.expl.modelle.var[[5]],type = "const")
      VARfcst <- predict(VARmodel, n.ahead=input$selectHorizont)
      var.diff <- c(var.diff, VARfcst$fcst[[input$depVar]][,1] -forecasting[,input$depVar][[1]])
      var.forecast <- c(var.forecast , VARfcst$fcst[[input$depVar]][,1])
      
      restVARmodel <- restrict(VAR(windowZweiTs,p=var.modelle$gespeicherte.expl.modelle.restvar[[5]],type = "const"))
      restVARfcst <- predict(restVARmodel, n.ahead=input$selectHorizont)
      restvar.diff <- c(restvar.diff, restVARfcst$fcst[[input$depVar]][,1] -forecasting[,input$depVar][[1]])
      restvar.forecast <- c(restvar.forecast , restVARfcst$fcst[[input$depVar]][,1])
      
      
    }
    
    
    backtest$timeseries <-cbind(rw.forecast, mreg.forecast, var.forecast, restvar.forecast)
    timetestdata <- daten.under$data.test[1:(nrow(daten.under$data.test)-rest),][[1]]
    backtest$timeseriesTs <- xts(backtest$timeseries, timetestdata)
    backtest$timeseriesTs <- cbind(xts(daten.under$default[, input$depVar],start$dates), backtest$timeseriesTs)
    colnames(backtest$timeseriesTs)<-c(input$depVar, "RW","MReg", "VAR", "Rest.VAR")
    
    rmse.rw = abs(rw.diff)
    rmse.restvar = abs(restvar.diff)
    rmse.mreg = abs(mreg.diff)
    rmse.var = abs(var.diff)
    
    RMSE = cbind(rmse.rw, rmse.mreg, rmse.var, rmse.restvar)
    RMSE <- xts(RMSE, timetestdata)
    colnames(RMSE)<-c("RW","MReg", "VAR", "Rest.VAR")
    
  }
  
  if(backtest$choosemodelbacktest == 25){
    
    backtest_data<-var.modelle$gespeicherte.expl.modelle.var[[1]]
    loops<- as.integer(nrow(daten.under$data.test)/input$selectHorizont)
    rest<-nrow(daten.under$data.test)-loops*input$selectHorizont
    
    for(i in 1:loops){
      
      withProgress(min = 0, max = 100, setProgress(value = round(i/loops*100,0),
                                                   message = paste('Calculating loop ',i)))
      
      
      print(i)
      
      if(i == 1){window<- backtest_data}
      
      if(i > 1){
        window <- rbind(backtest_data, daten.under$data.test[1:((i-1)*input$selectHorizont), colnames(backtest_data)])
      }
      
      
      windowTs<-xts(window[,-1], window[[1]])
      
      forecasting <- daten.under$data.test[(1-input$selectHorizont+i*input$selectHorizont):(-input$selectHorizont+i*input$selectHorizont+input$selectHorizont),]
      if(i == 1){backtest$dyevents<-forecasting[[1,1]]}
      if(i > 1){backtest$dyevents<- c(backtest$dyevents, forecasting[[1,1]])}
      forecastingTs <-xts(forecasting[,-1], forecasting[[1]])
      
      
      RWfcst = rwf(windowTs[,input$depVar], h=input$selectHorizont, drift=FALSE)
      RWfcstTs<-xts(as.data.frame(RWfcst), forecasting[[1]])
      rw.diff <- c(rw.diff, RWfcstTs[,1]-forecastingTs[,input$depVar])
      rw.forecast <- c(rw.forecast, RWfcstTs[,1] )
      
      ARIMAmodel = auto.arima(windowTs[,input$depVar],seasonal = FALSE)
      ARIMAfcast <- forecast(ARIMAmodel, h=input$selectHorizont)
      ARIMAfcastTs <- xts(as.data.frame(ARIMAfcast), forecasting[[1]])
      arima.diff <- c(arima.diff, ARIMAfcastTs[,1] -forecastingTs[,input$depVar])
      arima.forecast <- c(arima.forecast, ARIMAfcastTs[,1])
      
      VARmodel <- VAR(windowTs,p=var.modelle$gespeicherte.expl.modelle.var[[5]],type = "const")
      VARfcst <- predict(VARmodel, n.ahead=input$selectHorizont)
      var.diff <- c(var.diff, VARfcst$fcst[[input$depVar]][,1] -forecasting[,input$depVar][[1]])
      var.forecast <- c(var.forecast , VARfcst$fcst[[input$depVar]][,1])
      
      restVARmodel <- restrict(VAR(windowTs,p=var.modelle$gespeicherte.expl.modelle.restvar[[5]],type = "const"))
      restVARfcst <- predict(restVARmodel, n.ahead=input$selectHorizont)
      restvar.diff <- c(restvar.diff, restVARfcst$fcst[[input$depVar]][,1] -forecasting[,input$depVar][[1]])
      restvar.forecast <- c(restvar.forecast , restVARfcst$fcst[[input$depVar]][,1])
      
    }
    
    
    backtest$timeseries <-cbind(rw.forecast, arima.forecast, var.forecast, restvar.forecast)
    timetestdata <- daten.under$data.test[1:(nrow(daten.under$data.test)-rest),][[1]]
    backtest$timeseriesTs <- xts(backtest$timeseries, timetestdata)
    backtest$timeseriesTs <- cbind(xts(daten.under$default[, input$depVar],start$dates), backtest$timeseriesTs)
    colnames(backtest$timeseriesTs)<-c(input$depVar, "RW","ARIMA","VAR", "Restr.VAR")
    
    rmse.arima = abs(arima.diff)
    rmse.rw = abs(rw.diff)
    rmse.var = abs(var.diff)
    rmse.restvar = abs(restvar.diff)
    RMSE = cbind(rmse.rw, rmse.arima, rmse.var, rmse.restvar)
    RMSE <- xts(RMSE, timetestdata)
    colnames(RMSE)<-c("RW","ARIMA","VAR", "Rest.VAR")
    
  } 
  
  if(backtest$choosemodelbacktest == 26){
    
    backtest_data_var <-var.modelle$gespeicherte.expl.modelle.restvar[[1]]
    
    backtest_data <- daten.under$base[ ,c("Date", regression.modelle$gespeichertes.modell[[7]], names(regression.modelle$gespeichertes.modell[[2]]))]
    
    loops<- as.integer(nrow(daten.under$data.test)/input$selectHorizont)
    rest<-nrow(daten.under$data.test)-loops*input$selectHorizont
    
    for(i in 1:loops){
      
      withProgress(min = 0, max = 100, setProgress(value = round(i/loops*100,0),
                                                   message = paste('Calculating loop ',i)))
      
      
      print(i)
      
      if(i == 1){
        window<- backtest_data
        windowZwei<-backtest_data_var
      }
      
      if(i > 1){
        window <- rbind(backtest_data, daten.under$data.test[1:((i-1)*input$selectHorizont), colnames(backtest_data)])
        windowZwei <- rbind(backtest_data_var, daten.under$data.test[1:((i-1)*input$selectHorizont), colnames(backtest_data_var)])
      }
      
      
      windowTs<-xts(window[,-1], window[[1]])
      windowZweiTs<-xts(windowZwei[,-1], windowZwei[[1]])
      
      forecasting <- daten.under$data.test[(1-input$selectHorizont+i*input$selectHorizont):(-input$selectHorizont+i*input$selectHorizont+input$selectHorizont),]
      
      if(i == 1){backtest$dyevents<-forecasting[[1,1]]}
      if(i > 1){backtest$dyevents<- c(backtest$dyevents, forecasting[[1,1]])}
      forecastingTs <-xts(forecasting[,-1], forecasting[[1]])
      
      fit.reg <- regression.modelle$gespeichertes.modell[[1]]
      
      # Anzahl der beteiligten Variablen am Regressionsmodell
      count_variable <- length(regression.modelle$gespeichertes.modell[[4]])
      lm_lags        <- regression.modelle$gespeichertes.modell[[4]]
      
      # Berechne Arima-Modell fuer aktuelle Datengundlage
      ARIMAindep      <- lapply(windowTs[ ,-1], function(x) auto.arima(x))
      
      daten.lag <- list()
      for(j in 1:count_variable){
        if(lm_lags[j] > 0 && (input$selectHorizont-lm_lags[j] > 0)){
          daten.lag[[j]] <- as.vector(unlist(c(tail(window[ , j+2], n = lm_lags[j]), forecast(ARIMAindep[[j]], h=input$selectHorizont-lm_lags[j])[["mean"]])))
          next
        }else if(input$selectHorizont-lm_lags[j] <= 0){
          daten.lag[[j]] <- as.vector(unlist(tail(window[ , j+2], n = input$selectHorizont)))
        }else if(lm_lags[j] == 0 ){
          daten.lag[[j]] <- as.vector(forecast(ARIMAindep[[j]], h=input$selectHorizont-lm_lags[j])[["mean"]])  
        }
      }
      
      names(daten.lag) <- names(regression.modelle$gespeichertes.modell[[2]])
      
      
      
      # Vorhersage die naechsten "selectHorizont" steps
      mregfcast <- predict(fit.reg, daten.lag)
      
      # Definieren der Zeitserien fuer die Vorhergesagten Werte
      mregfcastTs <- xts(mregfcast, forecasting[[1]])
      
      # AUslesen der abhaengigen Variable des Regressionsmodells
      dependent_var <- regression.modelle$gespeichertes.modell[[7]]
      
      
      # Speichern der Differenzen vom tatsaechlichen und gefitteten Werten
      mreg.diff <- c(mreg.diff, mregfcastTs[,1]-forecastingTs[,input$depVar])
      
      # Speichern der historisch gefitteten Werte
      mreg.forecast<- c(mreg.forecast, mregfcastTs)
      
      ARIMAmodel = auto.arima(windowTs[,input$depVar],seasonal = FALSE)
      ARIMAfcast <- forecast(ARIMAmodel, h=input$selectHorizont)
      ARIMAfcastTs <- xts(as.data.frame(ARIMAfcast), forecasting[[1]])
      arima.diff <- c(arima.diff, ARIMAfcastTs[,1] -forecastingTs[,input$depVar])
      arima.forecast <- c(arima.forecast, ARIMAfcastTs[,1])
      
      RWfcst = rwf(windowTs[,input$depVar], h=input$selectHorizont, drift=FALSE)
      RWfcstTs<-xts(as.data.frame(RWfcst), forecasting[[1]])
      rw.diff <- c(rw.diff, RWfcstTs[,1]-forecastingTs[,input$depVar])
      rw.forecast <- c(rw.forecast, RWfcstTs[,1] )
      
      restVARmodel <- restrict(VAR(windowZweiTs,p=var.modelle$gespeicherte.expl.modelle.restvar[[5]],type = "const"))
      restVARfcst <- predict(restVARmodel, n.ahead=input$selectHorizont)
      restvar.diff <- c(restvar.diff, restVARfcst$fcst[[input$depVar]][,1] -forecasting[,input$depVar][[1]])
      restvar.forecast <- c(restvar.forecast , restVARfcst$fcst[[input$depVar]][,1])
      
      
    }
    
    
    backtest$timeseries <-cbind(rw.forecast, arima.forecast, mreg.forecast, restvar.forecast)
    timetestdata <- daten.under$data.test[1:(nrow(daten.under$data.test)-rest),][[1]]
    backtest$timeseriesTs <- xts(backtest$timeseries, timetestdata)
    backtest$timeseriesTs <- cbind(xts(daten.under$default[, input$depVar],start$dates), backtest$timeseriesTs)
    colnames(backtest$timeseriesTs)<-c(input$depVar, "RW","ARIMA","MReg", "Rest.VAR")
    
    rmse.arima = abs(arima.diff)
    rmse.restvar = abs(restvar.diff)
    rmse.mreg = abs(mreg.diff)
    rmse.rw = abs(rw.diff)
    
    RMSE = cbind(rmse.rw, rmse.arima, rmse.mreg, rmse.restvar)
    RMSE <- xts(RMSE, timetestdata)
    colnames(RMSE)<-c("RW","ARIMA","MReg", "Rest.VAR")
    
  }
  
  if(backtest$choosemodelbacktest == 27){
    
    backtest_data_var <-var.modelle$gespeicherte.expl.modelle.var[[1]]
    
    backtest_data <- daten.under$base[ ,c("Date", regression.modelle$gespeichertes.modell[[7]], names(regression.modelle$gespeichertes.modell[[2]]))]
    
    loops<- as.integer(nrow(daten.under$data.test)/input$selectHorizont)
    rest<-nrow(daten.under$data.test)-loops*input$selectHorizont
    
    for(i in 1:loops){
      
      withProgress(min = 0, max = 100, setProgress(value = round(i/loops*100,0),
                                                   message = paste('Calculating loop ',i)))
      
      
      print(i)
      
      if(i == 1){
        window<- backtest_data
        windowZwei<-backtest_data_var
      }
      
      if(i > 1){
        window <- rbind(backtest_data, daten.under$data.test[1:((i-1)*input$selectHorizont), colnames(backtest_data)])
        windowZwei <- rbind(backtest_data_var, daten.under$data.test[1:((i-1)*input$selectHorizont), colnames(backtest_data)])
      }
      
      
      windowTs<-xts(window[,-1], window[[1]])
      windowZweiTs<-xts(windowZwei[,-1], windowZwei[[1]])
      
      forecasting <- daten.under$data.test[(1-input$selectHorizont+i*input$selectHorizont):(-input$selectHorizont+i*input$selectHorizont+input$selectHorizont),]
      if(i == 1){backtest$dyevents<-forecasting[[1,1]]}
      if(i > 1){backtest$dyevents<- c(backtest$dyevents, forecasting[[1,1]])}
      forecastingTs <-xts(forecasting[,-1], forecasting[[1]])
      
      fit.reg <- regression.modelle$gespeichertes.modell[[1]]
      
      # Anzahl der beteiligten Variablen am Regressionsmodell
      count_variable <- length(regression.modelle$gespeichertes.modell[[4]])
      lm_lags        <- regression.modelle$gespeichertes.modell[[4]]
      
      # Berechne Arima-Modell fuer aktuelle Datengundlage
      ARIMAindep      <- lapply(windowTs[ ,-1], function(x) auto.arima(x))
      
      daten.lag <- list()
      for(j in 1:count_variable){
        if(lm_lags[j] > 0 && (input$selectHorizont-lm_lags[j] > 0)){
          daten.lag[[j]] <- as.vector(unlist(c(tail(window[ , j+2], n = lm_lags[j]), forecast(ARIMAindep[[j]], h=input$selectHorizont-lm_lags[j])[["mean"]])))
          next
        }else if(input$selectHorizont-lm_lags[j] <= 0){
          daten.lag[[j]] <- as.vector(unlist(tail(window[ , j+2], n = input$selectHorizont)))
        }else if(lm_lags[j] == 0 ){
          daten.lag[[j]] <- as.vector(forecast(ARIMAindep[[j]], h=input$selectHorizont-lm_lags[j])[["mean"]])  
        }
      }
      
      names(daten.lag) <- names(regression.modelle$gespeichertes.modell[[2]])
      
      
      
      # Vorhersage die naechsten "selectHorizont" steps
      mregfcast <- predict(fit.reg, daten.lag)
      
      # Definieren der Zeitserien fuer die Vorhergesagten Werte
      mregfcastTs <- xts(mregfcast, forecasting[[1]])
      
      # AUslesen der abhaengigen Variable des Regressionsmodells
      dependent_var <- regression.modelle$gespeichertes.modell[[7]]
      
      
      # Speichern der Differenzen vom tatsaechlichen und gefitteten Werten
      mreg.diff <- c(mreg.diff, mregfcastTs[,1]-forecastingTs[,input$depVar])
      
      # Speichern der historisch gefitteten Werte
      mreg.forecast<- c(mreg.forecast, mregfcastTs)
      
      ARIMAmodel = auto.arima(windowTs[,input$depVar],seasonal = FALSE)
      ARIMAfcast <- forecast(ARIMAmodel, h=input$selectHorizont)
      ARIMAfcastTs <- xts(as.data.frame(ARIMAfcast), forecasting[[1]])
      arima.diff <- c(arima.diff, ARIMAfcastTs[,1] -forecastingTs[,input$depVar])
      arima.forecast <- c(arima.forecast, ARIMAfcastTs[,1])
      
      RWfcst = rwf(windowTs[,input$depVar], h=input$selectHorizont, drift=FALSE)
      RWfcstTs<-xts(as.data.frame(RWfcst), forecasting[[1]])
      rw.diff <- c(rw.diff, RWfcstTs[,1]-forecastingTs[,input$depVar])
      rw.forecast <- c(rw.forecast, RWfcstTs[,1] )
      
      VARmodel <- VAR(windowZweiTs,p=var.modelle$gespeicherte.expl.modelle.var[[5]],type = "const")
      VARfcst <- predict(VARmodel, n.ahead=input$selectHorizont)
      var.diff <- c(var.diff, VARfcst$fcst[[input$depVar]][,1] -forecasting[,input$depVar][[1]])
      var.forecast <- c(var.forecast , VARfcst$fcst[[input$depVar]][,1])
      
      
      
    }
    
    
    backtest$timeseries <-cbind(rw.forecast, arima.forecast, mreg.forecast, var.forecast)
    timetestdata <- daten.under$data.test[1:(nrow(daten.under$data.test)-rest),][[1]]
    backtest$timeseriesTs <- xts(backtest$timeseries, timetestdata)
    backtest$timeseriesTs <- cbind(xts(daten.under$default[, input$depVar],start$dates), backtest$timeseriesTs)
    colnames(backtest$timeseriesTs)<-c(input$depVar, "RW","ARIMA","MReg", "VAR")
    
    rmse.arima = abs(arima.diff)
    rmse.var = abs(var.diff)
    rmse.mreg = abs(mreg.diff)
    rmse.rw = abs(rw.diff)
    
    RMSE = cbind(rmse.rw, rmse.arima, rmse.mreg, rmse.var)
    RMSE <- xts(RMSE, timetestdata)
    colnames(RMSE)<-c("RW","ARIMA","MReg", "VAR")
    
  }
  
  if(backtest$choosemodelbacktest == 28){
    
    backtest_data<-var.modelle$gespeicherte.expl.modelle.var[[1]]
    loops<- as.integer(nrow(daten.under$data.test)/input$selectHorizont)
    rest<-nrow(daten.under$data.test)-loops*input$selectHorizont
    
    for(i in 1:loops){
      
      withProgress(min = 0, max = 100, setProgress(value = round(i/loops*100,0),
                                                   message = paste('Calculating loop ',i)))
      
      
      print(i)
      
      if(i == 1){window<- backtest_data}
      
      if(i > 1){
        window <- rbind(backtest_data, daten.under$data.test[1:((i-1)*input$selectHorizont), colnames(backtest_data)])
      }
      
      
      windowTs<-xts(window[,-1], window[[1]])
      
      forecasting <- daten.under$data.test[(1-input$selectHorizont+i*input$selectHorizont):(-input$selectHorizont+i*input$selectHorizont+input$selectHorizont),]
      
      if(i == 1){backtest$dyevents<-forecasting[[1,1]]}
      if(i > 1){backtest$dyevents<- c(backtest$dyevents, forecasting[[1,1]])}
      forecastingTs <-xts(forecasting[,-1], forecasting[[1]])
      
      ARIMAmodel = auto.arima(windowTs[,input$depVar],seasonal = FALSE)
      ARIMAfcast <- forecast(ARIMAmodel, h=input$selectHorizont)
      ARIMAfcastTs <- xts(as.data.frame(ARIMAfcast), forecasting[[1]])
      arima.diff <- c(arima.diff, ARIMAfcastTs[,1] -forecastingTs[,input$depVar])
      arima.forecast <- c(arima.forecast, ARIMAfcastTs[,1])
      
      VARmodel <- VAR(windowTs,p=var.modelle$gespeicherte.expl.modelle.var[[5]],type = "const")
      VARfcst <- predict(VARmodel, n.ahead=input$selectHorizont)
      var.diff <- c(var.diff, VARfcst$fcst[[input$depVar]][,1] -forecasting[,input$depVar][[1]])
      var.forecast <- c(var.forecast , VARfcst$fcst[[input$depVar]][,1])
      rmse.var = abs(var.diff)
      
      restVARmodel <- restrict(VAR(windowTs,p=var.modelle$gespeicherte.expl.modelle.restvar[[5]],type = "const"))
      restVARfcst <- predict(restVARmodel, n.ahead=input$selectHorizont)
      restvar.diff <- c(restvar.diff, restVARfcst$fcst[[input$depVar]][,1] -forecasting[,input$depVar][[1]])
      restvar.forecast <- c(restvar.forecast , restVARfcst$fcst[[input$depVar]][,1])
      
      
    }
    
    
    backtest$timeseries <-cbind(arima.forecast, var.forecast, restvar.forecast)
    timetestdata <- daten.under$data.test[1:(nrow(daten.under$data.test)-rest),][[1]]
    backtest$timeseriesTs <- xts(backtest$timeseries, timetestdata)
    backtest$timeseriesTs <- cbind(xts(daten.under$default[, input$depVar],start$dates), backtest$timeseriesTs)
    colnames(backtest$timeseriesTs)<-c(input$depVar, "ARIMA","VAR", "Restr.VAR")
    
    rmse.restvar = abs(restvar.diff)
    rmse.arima = abs(arima.diff)
    rmse.var = abs(var.diff)
    RMSE = cbind(rmse.arima, rmse.var, rmse.restvar)
    RMSE <- xts(RMSE, timetestdata)
    colnames(RMSE)<-c("ARIMA" ,"VAR", "Restr.VAR")
    
  } 
  
  if(backtest$choosemodelbacktest == 29){
    
    backtest_data_restvar <-var.modelle$gespeicherte.expl.modelle.restvar[[1]]
    
    backtest_data <- daten.under$base[ ,c("Date", regression.modelle$gespeichertes.modell[[7]], names(regression.modelle$gespeichertes.modell[[2]]))]
    
    loops<- as.integer(nrow(daten.under$data.test)/input$selectHorizont)
    rest<-nrow(daten.under$data.test)-loops*input$selectHorizont
    
    for(i in 1:loops){
      
      withProgress(min = 0, max = 100, setProgress(value = round(i/loops*100,0),
                                                   message = paste('Calculating loop ',i)))
      
      
      print(i)
      
      if(i == 1){window<- backtest_data}
      
      if(i == 1){
        window<- backtest_data
        windowZwei<-backtest_data_restvar
      }
      
      if(i > 1){
        window <- rbind(backtest_data, daten.under$data.test[1:((i-1)*input$selectHorizont), colnames(backtest_data)])
        windowZwei <- rbind(backtest_data_var, daten.under$data.test[1:((i-1)*input$selectHorizont), colnames(backtest_data_var)])
      }
      
      
      windowTs<-xts(window[,-1], window[[1]])
      windowZweiTs<-xts(windowZwei[,-1], windowZwei[[1]])
      
      forecasting <- daten.under$data.test[(1-input$selectHorizont+i*input$selectHorizont):(-input$selectHorizont+i*input$selectHorizont+input$selectHorizont),]
      
      if(i == 1){backtest$dyevents<-forecasting[[1,1]]}
      if(i > 1){backtest$dyevents<- c(backtest$dyevents, forecasting[[1,1]])}
      forecastingTs <-xts(forecasting[,-1], forecasting[[1]])
      
      fit.reg <- regression.modelle$gespeichertes.modell[[1]]
      
      # Anzahl der beteiligten Variablen am Regressionsmodell
      count_variable <- length(regression.modelle$gespeichertes.modell[[4]])
      lm_lags        <- regression.modelle$gespeichertes.modell[[4]]
      
      # Berechne Arima-Modell fuer aktuelle Datengundlage
      ARIMAindep      <- lapply(windowTs[ ,-1], function(x) auto.arima(x))
      
      daten.lag <- list()
      for(j in 1:count_variable){
        if(lm_lags[j] > 0 && (input$selectHorizont-lm_lags[j] > 0)){
          daten.lag[[j]] <- as.vector(unlist(c(tail(window[ , j+2], n = lm_lags[j]), forecast(ARIMAindep[[j]], h=input$selectHorizont-lm_lags[j])[["mean"]])))
          next
        }else if(input$selectHorizont-lm_lags[j] <= 0){
          daten.lag[[j]] <- as.vector(unlist(tail(window[ , j+2], n = input$selectHorizont)))
        }else if(lm_lags[j] == 0 ){
          daten.lag[[j]] <- as.vector(forecast(ARIMAindep[[j]], h=input$selectHorizont-lm_lags[j])[["mean"]])  
        }
      }
      
      names(daten.lag) <- names(regression.modelle$gespeichertes.modell[[2]])
      
      
      
      # Vorhersage die naechsten "selectHorizont" steps
      mregfcast <- predict(fit.reg, daten.lag)
      
      # Definieren der Zeitserien fuer die Vorhergesagten Werte
      mregfcastTs <- xts(mregfcast, forecasting[[1]])
      
      # AUslesen der abhaengigen Variable des Regressionsmodells
      dependent_var <- regression.modelle$gespeichertes.modell[[7]]
      
      
      # Speichern der Differenzen vom tatsaechlichen und gefitteten Werten
      mreg.diff <- c(mreg.diff, mregfcastTs[,1]-forecastingTs[,input$depVar])
      
      # Speichern der historisch gefitteten Werte
      mreg.forecast<- c(mreg.forecast, mregfcastTs)
      
      
      restVARmodel <- restrict(VAR(windowZweiTs,p=var.modelle$gespeicherte.expl.modelle.restvar[[5]],type = "const"))
      restVARfcst <- predict(restVARmodel, n.ahead=input$selectHorizont)
      restvar.diff <- c(restvar.diff, restVARfcst$fcst[[input$depVar]][,1] -forecasting[,input$depVar][[1]])
      restvar.forecast <- c(restvar.forecast , restVARfcst$fcst[[input$depVar]][,1])
      
      ARIMAmodel = auto.arima(windowTs[,input$depVar],seasonal = FALSE)
      ARIMAfcast <- forecast(ARIMAmodel, h=input$selectHorizont)
      ARIMAfcastTs <- xts(as.data.frame(ARIMAfcast), forecasting[[1]])
      arima.diff <- c(arima.diff, ARIMAfcastTs[,1] -forecastingTs[,input$depVar])
      arima.forecast <- c(arima.forecast, ARIMAfcastTs[,1])
      
      
    }
    
    
    backtest$timeseries <-cbind(arima.forecast, mreg.forecast, restvar.forecast)
    timetestdata <- daten.under$data.test[1:(nrow(daten.under$data.test)-rest),][[1]]
    backtest$timeseriesTs <- xts(backtest$timeseries, timetestdata)
    backtest$timeseriesTs <- cbind(xts(daten.under$default[, input$depVar],start$dates), backtest$timeseriesTs)
    colnames(backtest$timeseriesTs)<-c(input$depVar, "ARIMA", "MReg", "Restr.VAR")
    
    rmse.arima = abs(arima.diff)
    rmse.mreg = abs(mreg.diff)
    rmse.restvar = abs(restvar.diff)
    
    RMSE = cbind(rmse.arima, rmse.mreg, rmse.restvar)
    RMSE <- xts(RMSE, timetestdata)
    colnames(RMSE)<-c("ARIMA","MReg", "Rest.VAR")
    
  }
  
  
  if(backtest$choosemodelbacktest == 30){
    
    backtest_data_var <-var.modelle$gespeicherte.expl.modelle.var[[1]]
    
    backtest_data <- daten.under$base[ ,c("Date", regression.modelle$gespeichertes.modell[[7]], names(regression.modelle$gespeichertes.modell[[2]]))]
    
    loops<- as.integer(nrow(daten.under$data.test)/input$selectHorizont)
    rest<-nrow(daten.under$data.test)-loops*input$selectHorizont
    
    for(i in 1:loops){
      
      withProgress(min = 0, max = 100, setProgress(value = round(i/loops*100,0),
                                                   message = paste('Calculating loop ',i)))
      
      
      print(i)
      
      if(i == 1){
        window<- backtest_data
        windowZwei<-backtest_data_var
      }
      
      if(i > 1){
        window <- rbind(backtest_data, daten.under$data.test[1:((i-1)*input$selectHorizont), colnames(backtest_data)])
        windowZwei <- rbind(backtest_data_var, daten.under$data.test[1:((i-1)*input$selectHorizont), colnames(backtest_data_var)])
      }
      
      
      windowTs<-xts(window[,-1], window[[1]])
      windowZweiTs<-xts(windowZwei[,-1], windowZwei[[1]])
      
      forecasting <- daten.under$data.test[(1-input$selectHorizont+i*input$selectHorizont):(-input$selectHorizont+i*input$selectHorizont+input$selectHorizont),]
      
      if(i == 1){backtest$dyevents<-forecasting[[1,1]]}
      if(i > 1){backtest$dyevents<- c(backtest$dyevents, forecasting[[1,1]])}
      forecastingTs <-xts(forecasting[,-1], forecasting[[1]])
      
      fit.reg <- regression.modelle$gespeichertes.modell[[1]]
      
      # Anzahl der beteiligten Variablen am Regressionsmodell
      count_variable <- length(regression.modelle$gespeichertes.modell[[4]])
      lm_lags        <- regression.modelle$gespeichertes.modell[[4]]
      
      # Berechne Arima-Modell fuer aktuelle Datengundlage
      ARIMAindep      <- lapply(windowTs[ ,-1], function(x) auto.arima(x))
      
      daten.lag <- list()
      for(j in 1:count_variable){
        if(lm_lags[j] > 0 && (input$selectHorizont-lm_lags[j] > 0)){
          daten.lag[[j]] <- as.vector(unlist(c(tail(window[ , j+2], n = lm_lags[j]), forecast(ARIMAindep[[j]], h=input$selectHorizont-lm_lags[j])[["mean"]])))
          next
        }else if(input$selectHorizont-lm_lags[j] <= 0){
          daten.lag[[j]] <- as.vector(unlist(tail(window[ , j+2], n = input$selectHorizont)))
        }else if(lm_lags[j] == 0 ){
          daten.lag[[j]] <- as.vector(forecast(ARIMAindep[[j]], h=input$selectHorizont-lm_lags[j])[["mean"]])  
        }
      }
      
      names(daten.lag) <- names(regression.modelle$gespeichertes.modell[[2]])
      
      
      
      # Vorhersage die naechsten "selectHorizont" steps
      mregfcast <- predict(fit.reg, daten.lag)
      
      # Definieren der Zeitserien fuer die Vorhergesagten Werte
      mregfcastTs <- xts(mregfcast, forecasting[[1]])
      
      # AUslesen der abhaengigen Variable des Regressionsmodells
      dependent_var <- regression.modelle$gespeichertes.modell[[7]]
      
      
      # Speichern der Differenzen vom tatsaechlichen und gefitteten Werten
      mreg.diff <- c(mreg.diff, mregfcastTs[,1]-forecastingTs[,input$depVar])
      
      # Speichern der historisch gefitteten Werte
      mreg.forecast<- c(mreg.forecast, mregfcastTs)
      
      ARIMAmodel = auto.arima(windowTs[,input$depVar],seasonal = FALSE)
      ARIMAfcast <- forecast(ARIMAmodel, h=input$selectHorizont)
      ARIMAfcastTs <- xts(as.data.frame(ARIMAfcast), forecasting[[1]])
      arima.diff <- c(arima.diff, ARIMAfcastTs[,1] -forecastingTs[,input$depVar])
      arima.forecast <- c(arima.forecast, ARIMAfcastTs[,1])
      
      VARmodel <- VAR(windowZweiTs,p=var.modelle$gespeicherte.expl.modelle.var[[5]],type = "const")
      VARfcst <- predict(VARmodel, n.ahead=input$selectHorizont)
      var.diff <- c(var.diff, VARfcst$fcst[[input$depVar]][,1] -forecasting[,input$depVar][[1]])
      var.forecast <- c(var.forecast , VARfcst$fcst[[input$depVar]][,1])
      
    }
    
    
    backtest$timeseries <-cbind(arima.forecast, mreg.forecast, var.forecast)
    timetestdata <- daten.under$data.test[1:(nrow(daten.under$data.test)-rest),][[1]]
    backtest$timeseriesTs <- xts(backtest$timeseries, timetestdata)
    backtest$timeseriesTs <- cbind(xts(daten.under$default[, input$depVar],start$dates), backtest$timeseriesTs)
    colnames(backtest$timeseriesTs)<-c(input$depVar, "ARIMA","MReg", "VAR")
    
    rmse.arima = abs(arima.diff)
    rmse.mreg = abs(mreg.diff)
    rmse.var = abs(var.diff)
    
    RMSE = cbind(rmse.arima, rmse.mreg, rmse.var)
    RMSE <- xts(RMSE, timetestdata)
    colnames(RMSE)<-c("ARIMA","MReg", "VAR")
    
  }
  
  if(backtest$choosemodelbacktest == 31){
    
    backtest_data_var <-var.modelle$gespeicherte.expl.modelle.var[[1]]
    
    backtest_data <- daten.under$base[ ,c("Date", regression.modelle$gespeichertes.modell[[7]], names(regression.modelle$gespeichertes.modell[[2]]))]
    
    loops<- as.integer(nrow(daten.under$data.test)/input$selectHorizont)
    rest<-nrow(daten.under$data.test)-loops*input$selectHorizont
    
    for(i in 1:loops){
      
      withProgress(min = 0, max = 100, setProgress(value = round(i/loops*100,0),
                                                   message = paste('Calculating loop ',i)))
      
      
      print(i)
      
      if(i == 1){
        window<- backtest_data
        windowZwei<-backtest_data_var
      }
      
      if(i > 1){
        window <- rbind(backtest_data, daten.under$data.test[1:((i-1)*input$selectHorizont), colnames(backtest_data)])
        windowZwei <- rbind(backtest_data_var, daten.under$data.test[1:((i-1)*input$selectHorizont), colnames(backtest_data_var)])
      }
      
      
      windowTs<-xts(window[,-1], window[[1]])
      windowZweiTs<-xts(windowZwei[,-1], windowZwei[[1]])
      
      forecasting <- daten.under$data.test[(1-input$selectHorizont+i*input$selectHorizont):(-input$selectHorizont+i*input$selectHorizont+input$selectHorizont),]
      
      if(i == 1){backtest$dyevents<-forecasting[[1,1]]}
      if(i > 1){backtest$dyevents<- c(backtest$dyevents, forecasting[[1,1]])}
      forecastingTs <-xts(forecasting[,-1], forecasting[[1]])
      
      fit.reg <- regression.modelle$gespeichertes.modell[[1]]
      
      # Anzahl der beteiligten Variablen am Regressionsmodell
      count_variable <- length(regression.modelle$gespeichertes.modell[[4]])
      lm_lags        <- regression.modelle$gespeichertes.modell[[4]]
      
      # Berechne Arima-Modell fuer aktuelle Datengundlage
      ARIMAindep      <- lapply(windowTs[ ,-1], function(x) auto.arima(x))
      
      daten.lag <- list()
      for(j in 1:count_variable){
        if(lm_lags[j] > 0 && (input$selectHorizont-lm_lags[j] > 0)){
          daten.lag[[j]] <- as.vector(unlist(c(tail(window[ , j+2], n = lm_lags[j]), forecast(ARIMAindep[[j]], h=input$selectHorizont-lm_lags[j])[["mean"]])))
          next
        }else if(input$selectHorizont-lm_lags[j] <= 0){
          daten.lag[[j]] <- as.vector(unlist(tail(window[ , j+2], n = input$selectHorizont)))
        }else if(lm_lags[j] == 0 ){
          daten.lag[[j]] <- as.vector(forecast(ARIMAindep[[j]], h=input$selectHorizont-lm_lags[j])[["mean"]])  
        }
      }
      
      names(daten.lag) <- names(regression.modelle$gespeichertes.modell[[2]])
      
      
      
      # Vorhersage die naechsten "selectHorizont" steps
      mregfcast <- predict(fit.reg, daten.lag)
      
      # Definieren der Zeitserien fuer die Vorhergesagten Werte
      mregfcastTs <- xts(mregfcast, forecasting[[1]])
      
      # AUslesen der abhaengigen Variable des Regressionsmodells
      dependent_var <- regression.modelle$gespeichertes.modell[[7]]
      
      
      # Speichern der Differenzen vom tatsaechlichen und gefitteten Werten
      mreg.diff <- c(mreg.diff, mregfcastTs[,1]-forecastingTs[,input$depVar])
      
      # Speichern der historisch gefitteten Werte
      mreg.forecast<- c(mreg.forecast, mregfcastTs)
      
      ARIMAmodel = auto.arima(windowTs[,input$depVar],seasonal = FALSE)
      ARIMAfcast <- forecast(ARIMAmodel, h=input$selectHorizont)
      ARIMAfcastTs <- xts(as.data.frame(ARIMAfcast), forecasting[[1]])
      arima.diff <- c(arima.diff, ARIMAfcastTs[,1] -forecastingTs[,input$depVar])
      arima.forecast <- c(arima.forecast, ARIMAfcastTs[,1])
      
      RWfcst = rwf(windowTs[,input$depVar], h=input$selectHorizont, drift=FALSE)
      RWfcstTs<-xts(as.data.frame(RWfcst), forecasting[[1]])
      rw.diff <- c(rw.diff, RWfcstTs[,1]-forecastingTs[,input$depVar])
      rw.forecast <- c(rw.forecast, RWfcstTs[,1] )
      
      VARmodel <- VAR(windowTs,p=var.modelle$gespeicherte.expl.modelle.var[[5]],type = "const")
      VARfcst <- predict(VARmodel, n.ahead=input$selectHorizont)
      var.diff <- c(var.diff, VARfcst$fcst[[input$depVar]][,1] -forecasting[,input$depVar][[1]])
      var.forecast <- c(var.forecast , VARfcst$fcst[[input$depVar]][,1])
      
      restVARmodel <- restrict(VAR(windowZweiTs,p=var.modelle$gespeicherte.expl.modelle.restvar[[5]],type = "const"))
      restVARfcst <- predict(restVARmodel, n.ahead=input$selectHorizont)
      restvar.diff <- c(restvar.diff, restVARfcst$fcst[[input$depVar]][,1] -forecasting[,input$depVar][[1]])
      restvar.forecast <- c(restvar.forecast , restVARfcst$fcst[[input$depVar]][,1])
      
      
      
    }
    
    
    backtest$timeseries <-cbind(rw.forecast, arima.forecast, mreg.forecast, var.forecast, restvar.forecast)
    timetestdata <- daten.under$data.test[1:(nrow(daten.under$data.test)-rest),][[1]]
    backtest$timeseriesTs <- xts(backtest$timeseries, timetestdata)
    backtest$timeseriesTs <- cbind(xts(daten.under$default[, input$depVar],start$dates), backtest$timeseriesTs)
    colnames(backtest$timeseriesTs)<-c(input$depVar, "RW","ARIMA","MReg", "VAR", "Restr.VAR")
    
    rmse.restvar = abs(restvar.diff)
    rmse.arima = abs(arima.diff)
    rmse.var = abs(var.diff)
    rmse.mreg = abs(mreg.diff)
    rmse.rw = abs(rw.diff)
    
    RMSE = cbind(rmse.rw, rmse.arima, rmse.mreg, rmse.var, rmse.restvar)
    RMSE <- xts(RMSE, timetestdata)
    colnames(RMSE)<-c("RW","ARIMA","MReg", "VAR", "Restr.VAR")
    
  }
  
  
    hstepmeans <-data.frame()
    
    for(i in 1:loops){
      
      hstepmeans <- rbind(hstepmeans, apply(RMSE[(i*input$selectHorizont-input$selectHorizont + 1):(i*input$selectHorizont) , ], 2, mean))
      
    }
    
    colnames(hstepmeans)<-input$choosebacktestmodel
    
    backtest$hstepmeans<-hstepmeans
    
    
    for(i in 1:(length(input$choosebacktestmodel))){
      backtest$timeseriesTs[nrow(backtest$timeseriesTs) - (nrow(RMSE)+rest),i+1] <- backtest$timeseriesTs[nrow(backtest$timeseriesTs) - (nrow(RMSE)+rest),1][[1]]
    }
    
    backtest$hstepmeans<-round(backtest$hstepmeans, digits = 2)
    backtest$hstepmeans<-cbind("Loop" = c(1:nrow(backtest$hstepmeans)), backtest$hstepmeans)
    backtest$hstepmeans<- rbind(backtest$hstepmeans, apply(backtest$hstepmeans, 2, mean))
    backtest$hstepmeans[nrow(backtest$hstepmeans),1]<-"Mean"
    
  
    
  return(RMSE)
        
})

output$infoBacktesting<-renderUI({

  
  if(is.null(input$selectHorizont)){return()}
  if(input$selectHorizont < 1 | is.numeric(input$selectHorizont == FALSE)){return(withProgress(message = "Choose proper horizont",Sys.sleep(2)))}
  
  
  if(is.null(input$choosebacktestmodel)){return()}
  
  collapsedinput<- paste(input$choosebacktestmodel, collapse = " ")
 
  loops<- as.integer(nrow(daten.under$data.test)/input$selectHorizont)
  
  return(
    list(
      p(strong("Calculation informations:")),
      br(),
      p(paste("Train data from ", daten.under$data.test[[1,1]] , " to ", daten.under$data.test[[nrow(daten.under$data.test),1]])),
      p(paste("Loops to calculate: ", loops))
      
      
    ) 
  )
  
  
})


output$text.VAR.lag <- renderText({ 
  if (is.null(VARmodel())) { return() }
  
  paste("VAR(",input$LAGS,")")
  
})



output$rmse <- renderPlot({
  if (identical(backtest$hstepmeans, 0)) { return() }
  
  #ggplot(as.data.frame(backtest$hstepmeans), aes(order(Loop), RW)) + geom_bar(stat= "identity")
  
  
  barplot(t(backtest$hstepmeans[,-1]), main="Mean RMSE per loop", xlab="Number of loop", ylab = "RMSE",
          legend = rownames(t(backtest$hstepmeans[,-1])), beside=TRUE, names.arg = c(backtest$hstepmeans[,1]))      
  
}) 




observeEvent(input$BACK,{
      output$graph.rmse <- renderDygraph({
        if (is.null(RMSE())) { return()}
        
      
          outgraph <- dygraph(RMSE(),
                      main = "Root Mean Squared Error") %>%
                dyAxis("y", label = "RMSE") %>%
                dyLegend(width = 600) %>%
                dyRangeSelector()
          
          for(i in 1: length(backtest$dyevents)){
            
            outgraph <- outgraph %>% dyEvent(as.character(backtest$dyevents)[i])
            
          }
                
       
            
        return(outgraph)
        
      })
})

observeEvent(input$BACK,{
  
    
  
    output$fittedbacktest <- renderDygraph({
    
      if(identical(backtest$timeseriesTs, NULL)) return()
      
      if(identical(backtest$timeseriesTs, 0)) return()

    
      outgraph <- dygraph(backtest$timeseriesTs,
                          main = "Actual model compared to forecasts") %>%
        dyLegend(width = 600) %>%
        dyAxis("y", label = input$depVar) %>%
        dyRangeSelector()
      
      
      return(outgraph)
  
    })
})













