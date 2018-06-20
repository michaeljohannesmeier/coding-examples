# In diesem Skript befinden sich alle wichtigen Funktionen, die Methodenuebergreifend aufgerufen werden
# 1. TimeStepsPredict
# 2. retransform

###########################################################################################################

# Diese Funktion berechnet die naechsten Zeitschritte, fuer die der Forecast erstellt wird
TimeStepsPredict <- function(startDate,
                             frequency,
                             ForecastForWeekend,
                             timeSteps){
  # startDate...Das Datum ab wann die Zeitreihe erstellt werden soll
  # frequency...Die Frequenz in der die Zeitschritte erstellt werden (taeglich,woechentlich...)
  # ForecastForWeekend...eine 0-1 Eingabe, die angibt, ob der Forecast auch fuer das Wochenenden erstellt werden soll
  # timeSteps...Anzahl an zu erstellenden Datums fuer die Zeitreihe
  
  if(frequency == "day" & ForecastForWeekend == "0"){
    timePred <- seq(startDate, by = frequency, length.out = timeSteps + 1)[2:(timeSteps + 1)]
    # Solange ein Wochenendtag in der Reihe ist, wiederholt er die "while"-Schleife
    while (sum(as.numeric(xor(
      weekdays(timePred) == "Samstag",
      weekdays(timePred) == "Sonntag"
    ))) != 0) {
      timePred.temp <-
        timePred[-which(xor(
          weekdays(timePred) == "Samstag",
          weekdays(timePred) == "Sonntag"
        ))]
      timePred.temp.we <-
        seq(tail(timePred, n = 1),
            by = start$freq,
            length.out = sum(xor(
              weekdays(timePred) == "Samstag",
              weekdays(timePred) == "Sonntag"
            )) + 1)[1:sum(xor(
              weekdays(timePred) == "Samstag",
              weekdays(timePred) == "Sonntag"
            )) + 1]
      timePred <- c(timePred.temp, timePred.temp.we)
    }
  }else{
    timePred <- seq(startDate, by = frequency, length.out = timeSteps + 1)[2:(timeSteps + 1)]
  }
  
  return(timePred)
}

############################ 2. retransform ###############################################################
# Diese Funktion fuehrt eine Ruecktransformierung der gewahelten Variable aus, sollten Differenzen gebildet wurden
# sein oder eine Box-Cox-Transformation durchgefuehrt wurden sein
retransform <- function(variable_name,
                        historic_data,
                        base_data,
                        transformation_list,
                        modelType,
                        uncertainty = 0.95){

  # variable_name - Variable fuer die auf eine Transform gecheckt werden soll
  # historic_data - Daten die einen moeglichen fit, forecast oder quantiles enthalten
  # base_data - Ausgangsdaten
  # transformation_list - Eine Liste mit den Informationen zu den in der PAS durchgefuerhten Transformations
  # modelType - Welche Art des Modells zurecktransformiert werden soll - MReg, VAR, ARIMA...
  
  names_transformation <- names(transformation_list)

  # Check ob eine Transformation durchegfuehrt wurde
  if(!(variable_name %in% names_transformation)){
    return(historic_data)
  }

  while(variable_name %in% names_transformation){
    
    # Get Art der Transformation
    kind_transformation <- transformation_list[[variable_name]]$Transformation
    
    # Get Ausgangsdaten
    previous_variable <- as.character(transformation_list[[variable_name]]$Previous_Variable)
    
    # Build cumulative Sum of differenced value
    reversed_ts <- xts(, index(historic_data))
    
    if(kind_transformation == "Differencing"){
      
    if(modelType != "VAR_Expl" && modelType != "Backtest_Cross"){
      if(modelType == "ARIMA" || modelType == "EXPSM" || modelType == "VAR"){
        meanIndex <- 3
        lowerBoundIndex <- 4
        upperBoundIndex <- 5
      }else if(modelType == "MReg"){
        meanIndex <- 2
        lowerBoundIndex <- 3
        upperBoundIndex <- 4
      }else if(modelType == "Backtest_Comp"){
        meanIndex <- 1
        lowerBoundIndex <- 2
        upperBoundIndex <- 3
      }
    
      # Simulation des Forecasts
      if(modelType == "Backtest_Comp"){
        meanValuesMReg <- na.omit(historic_data[,meanIndex])
        sdValuesMReg <- (na.omit(historic_data[,upperBoundIndex]) - na.omit(historic_data[,meanIndex]))/qnorm(uncertainty)
        sdValuesMReg <- sdValuesMReg
      }else{
        meanValuesMReg <- na.omit(historic_data[,meanIndex])[-1]
        sdValuesMReg <- (na.omit(historic_data[,upperBoundIndex]) - na.omit(historic_data[,meanIndex]))/qnorm(uncertainty)
        sdValuesMReg <- sdValuesMReg[-1]
      }
      
      
      # Simulation dieser Werte
      simulationDifferenzen <- sapply(1:length(meanValuesMReg), FUN = function(x){
                                                                            rnorm(10000, 
                                                                                  mean = meanValuesMReg[x],
                                                                                  sd = sdValuesMReg[x])
                                                                        })
      
      # De-Differenzierung der simulierten Werte
      reverse_diff_Mreg <- apply(simulationDifferenzen, 1, FUN = function(x){
                                             cumsum(x) + tail(na.omit(base_data[,previous_variable])[[1]], n = 1)
                                                                  })
      # Bestimmen der benoetigten Quantile
      quantil_diff_reverse <- t(apply(reverse_diff_Mreg, 1,
                                      FUN = function(x){
                                        quantile(x, probs = c((1 - uncertainty)/2,
                                                              uncertainty + (1 - uncertainty)/2))
                                      }
                                ))
      
    }else{
      meanIndex <- 3
      lowerBoundIndex <- 4
      upperBoundIndex <- 5
    }
      
      for(i in 1:dim(historic_data)[2]){
        if(i %in% c(lowerBoundIndex, upperBoundIndex)){
          if(i == lowerBoundIndex){
            qunatileIndex <- 1
          }else{
            qunatileIndex <- 2
          }
          if(modelType == "Backtest_Comp"){
            reverse_diff_temp <- xts(quantil_diff_reverse[, qunatileIndex],
                                     order.by = index(na.omit(reversed_ts[,meanIndex])))
          }else{
            reverse_diff_temp <- xts(c(as.numeric(na.omit(reversed_ts[,meanIndex]))[1], quantil_diff_reverse[, qunatileIndex]),
                                     order.by = index(na.omit(reversed_ts[,meanIndex])))
          }
        }else if(tail(index(na.omit(historic_data[,i])), n = 1) > tail(base_data[,1], n = 1)[[1]]){
          if(modelType == "Backtest_Cross" || modelType == "Backtest_Comp"){
            tail_n <- 1
          }else{
            tail_n <- 2
          }
          reverse_diff_temp <- cumsum(na.omit(historic_data[,i])) + tail(na.omit(base_data[,previous_variable])[[1]], n = tail_n)[1]
        }else{
          # Oder um einen Historischen Fit bzw. zugehoerigen Daten
          if((modelType == "ARIMA" || modelType == "EXPSM") && i == 2){
            reverse_diff_temp <- na.omit(historic_data[,i]) +
                                      na.omit(base_data[,previous_variable])[[1]][-length(na.omit(base_data[,previous_variable])[[1]])]
          }else{
            if((modelType == "VAR" || modelType == "VAR_Expl") && i == 2){
              # na_values_skip wird benoetigt um den korrekten ersten Datenpunkt der orginalen Zeitreihe zu finden
              # da durch die Lags im VAR model eventuell einige der ersten Datenpunkte nicht gefittet werden koennen
              na_values_skip <- length(base_data[,previous_variable][[1]]) - length(na.omit(historic_data[,i])) - 1
              reverse_diff_temp <- cumsum(na.omit(historic_data[,i])) + na.omit(base_data[,previous_variable])[[1]][na_values_skip]
            }else{
              reverse_diff_temp <- cumsum(na.omit(historic_data[,i])) + na.omit(base_data[,previous_variable])[[1]][1]
            }
          }
        }
        
        reversed_ts <- cbind(reversed_ts, reverse_diff_temp)
        colnames(reversed_ts)[i] <- colnames(historic_data)[i]
      }

      historic_data <- reversed_ts

    }else if(kind_transformation == "Box-Cox"){
      # Vorgehen kann hier gefunden werden http://robjhyndman.com/hyndsight/backtransforming/
      lambda_temp <- transformation_list[[variable_name]]$Lambda
      minshift <- transformation_list[[variable_name]]$Min.Shift
      
      for(i in 1:dim(historic_data)[2]){
        # Checke ob es sich um einen Forecast oder zugehoerige Quantile handelt
        reverse_diff_temp <- InvBoxCox(na.omit(historic_data[,i]),
                                        lambda = lambda_temp) - minshift
        
        reversed_ts <- cbind(reversed_ts, reverse_diff_temp)
        colnames(reversed_ts)[i] <- colnames(historic_data)[i]
      }
      
      historic_data <- reversed_ts
    
    }
    
    variable_name <- previous_variable
    
  }
  
  return(historic_data)

}


