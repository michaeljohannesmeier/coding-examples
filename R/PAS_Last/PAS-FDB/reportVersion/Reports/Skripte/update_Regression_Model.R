# Berechnen Datengrundlage
calculate.data.lags <- function(lag.vec, cur.max, cur.min, reg.daten, dep.temp){
  
  daten.grundlage <- vector()
  
  # Aufbereitung der Datengrundlage (Daten der unabhängigen Variable) fuer die Lags
  if((cur.max + abs(cur.min)) < length(reg.daten[[1]])){
    for(j in seq(length(reg.daten))){
      if(lag.vec[[j]] > 0){
        temp <- reg.daten[[j]][- ((length(reg.daten[[j]]) + 1 - lag.vec[[j]]):length(reg.daten[[j]]))]
        if(cur.max - lag.vec[[j]] != 0){
          temp <- temp[-(1:(cur.max - lag.vec[[j]]))]
        }
        if(cur.min < 0){
          temp <- temp[- ((length(reg.daten[[j]]) + 1 + cur.min - cur.max) : (length(reg.daten[[j]]) - cur.max))]
        }
        daten.grundlage <- cbind(daten.grundlage, temp)
      } else if(lag.vec[[j]] < 0){
        temp <- reg.daten[[j]][- (1:abs(lag.vec[[j]]))]
        if(cur.max > 0){
          temp <- temp[- (1:cur.max)]
        }
        if((lag.vec[[j]] - cur.min) != 0 && cur.max >= 0){
          temp <- temp[- ((length(reg.daten[[j]]) + 1 + lag.vec[[j]] + (cur.min - lag.vec[[j]]) - cur.max):(length(reg.daten[[j]]) + lag.vec[[j]] - cur.max))]
        } else if((lag.vec[[j]] - cur.min) != 0 && cur.max < 0){
          temp <- temp[- ((length(reg.daten[[j]]) + 1 + lag.vec[[j]] + (cur.min - lag.vec[[j]])):(length(reg.daten[[j]]) + lag.vec[[j]]))]
        }
        daten.grundlage <- cbind(daten.grundlage, temp)
      } else if(lag.vec[[j]] == 0){
        temp <- reg.daten[[j]]
        if(cur.max > 0){
          temp <- temp[- (1:cur.max)]
        }
        if(cur.min < 0 && cur.max >= 0){
          temp <- temp[- ((length(reg.daten[[j]]) + 1 + cur.min - cur.max): (length(reg.daten[[j]]) - cur.max))]
        } else if(cur.min < 0 && cur.max < 0){
          temp <- temp[- ((length(reg.daten[[j]]) + 1 + cur.min): length(reg.daten[[j]]))]
        }
        daten.grundlage <- cbind(daten.grundlage, temp)
      }
    }
  }
  
  if(cur.max > 0){
    dep.temp <- dep.temp[-(1:cur.max)]
  }
  
  if(cur.min < 0 && cur.max >= 0){
    dep.temp <- dep.temp[- ((length(dep.daten[[1]]) + 1 + cur.min - cur.max): (length(dep.daten[[1]]) - cur.max))]
  } else if(cur.min < 0 && cur.max < 0){
    dep.temp <- dep.temp[- ((length(dep.daten[[1]]) + 1 + cur.min): length(dep.daten[[1]]))]
  }
  
  return(list(daten.grundlage, dep.temp))
}

# Build linear model
linearRegressionUpdate<- function(daten.grundlage, dep.temp, interaction, nameDep, bigData){
  
  # Hier wird die Datengrundlage als auch die die abhaengige Variable so angepasst, dass
  # nur noch auf Basis der kompletten Daten gefittet wird.
  
  
  daten.grundlage.na.clean <- daten.grundlage[complete.cases(daten.grundlage), ]
  dep.temp.na.clean <- dep.temp[complete.cases(daten.grundlage)]
  
  if(bigData == TRUE){
    # Bauen der entsprechenden Formel fuer rxLinMod
    data_grundlage <- cbind(dep.temp.na.clean, daten.grundlage.na.clean)
    names(data_grundlage)[1] <- nameDep
    form_rx <- as.formula(paste(paste(names(data_grundlage)[1], "~", sep = ""),
                                paste(names(data_grundlage)[-1],collapse="+")))
    
    lm.lags <-  0
    
    if(!interaction){
      lm.lags <- tryCatch({
        rxLinMod(form_rx , data = data_grundlage,
                 variableSelection = rxStepControl(method="stepwise"), reportProgress = 0)
      }, error = function(e) {
        rxLinMod(form_rx , data = data_grundlage, reportProgress = 0)
      })
    }else if(interaction){
      form_rx <- as.formula(paste(paste(names(data_grundlage)[1], "~(", sep = ""),
                                  paste(names(data_grundlage)[-1],collapse="+"), ")^2"))
      lm.lags <- tryCatch({
        rxLinMod(form_rx , data = data_grundlage,
                 variableSelection = rxStepControl(method="stepwise"), reportProgress = 0)
      }, error = function(e) {
        rxLinMod(form_rx , data = data_grundlage, reportProgress = 0)
      })
    }
  }else if(bigData == FALSE){
    
    if(!interaction){
      lm.lags <- lm(dep.temp.na.clean ~., data = daten.grundlage.na.clean)
    } else {
      lm.lags <- lm(dep.temp.na.clean ~.^2, data = daten.grundlage.na.clean)
    }
    
    lm.lags <- tryCatch({
      stepAIC(lm.lags, direction = "both", trace = FALSE)
    }, error = function(e) {
      lm.lags
    })
    
  }
  
  return(lm.lags)
}