# data.bth <- data.frame(names = c("Hallo", "Tach", "Tschau"), Values = c(5.2, -10.1, 7.2))
# ggplot(data.bth, aes(x = names, y = Values)) + geom_bar(stat="identity", width=.5)
# Funktion zur Lagbetrachtung

cor.lag <- function(abVar, unabVar, Lags){
  
  if(abs(Lags) >= (length(abVar) - 2)){
    stop("Die Laganzahl sollte die Anzahl der Datenpunkte minus 2 nicht uebersteigen")
  }
  if(!is.numeric(abVar)){
    stop("Die abhaengige Variable muss ein numerischer Vektor sein!")
  }
  if(!is.numeric(unabVar)){
    stop("Die unabhaengige Variable muss ein Vektor sein!")
  }
  if(!is.numeric(Lags)){
    stop("Laganzahl muss als ganze Zahl uebergeben werden!")
  }
  
  korrelations.data.frame <- data.frame(Cor = cor(abVar, unabVar, use = "pairwise.complete.obs"), Lag = 0)
  
  if(Lags == 0){
    return(korrelations.data.frame)
  }
  
  if(Lags > 0){
    for(i in seq(Lags)){
      unabVar <- c(unabVar[- length(unabVar)])
      abVar <- c(abVar[-1])
      temp.data.frame <- data.frame(Cor = cor(abVar, unabVar, use = "pairwise.complete.obs"), Lag = i)
      korrelations.data.frame <- rbind(korrelations.data.frame, temp.data.frame)
    }
  } else {
    for(i in -1:Lags){
      unabVar <- c(unabVar[-1])
      abVar <- c(abVar[- length(abVar)])
      temp.data.frame <- data.frame(Cor = cor(abVar, unabVar, use = "pairwise.complete.obs"), Lag = i)
      korrelations.data.frame <- rbind(korrelations.data.frame, temp.data.frame)
    }
  }
  
  korrelations.data.frame
}
#----------------------------------------------------------------------------------------------------------
# Berechnen Datengrundlage
calculate.data.lags <- function(lag.vec, cur.max, cur.min, reg.daten, dep.temp){
  
  daten.grundlage <- vector()
  
  # Aufbereitung der Datengrundlage (Daten der unabhÃ¤ngigen Variable) fuer die Lags
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

#-----------------------------------------------------------------------------------------------------------
# Build linear model
linear.regression.auto <- function(daten.grundlage, dep.temp, interaction, nameDep, bigData){
  
  # Hier wird die Datengrundlage als auch die die abhaengige Variable so angepasst, dass
  # nur noch auf Basis der kompletten Daten gefittet wird.

  
  daten.grundlage.na.clean <- daten.grundlage[complete.cases(daten.grundlage), ]
  dep.temp.na.clean <- dep.temp[complete.cases(daten.grundlage)]
  
  if(bigData == TRUE){
    # Bauen der entsprechenden Formel für rxLinMod
    data_grundlage <- cbind(dep.temp.na.clean, daten.grundlage.na.clean)
    names(data_grundlage)[1] <- nameDep
    form_rx <- as.formula(paste(paste(names(data_grundlage)[1], "~", sep = ""),
                                paste(names(data_grundlage)[-1],collapse="+")))
    
    lm.lags <-  0
    
    if(interaction == 0){
      lm.lags <- tryCatch({
        rxLinMod(form_rx , data = data_grundlage,
                 variableSelection = rxStepControl(method="stepwise"), reportProgress = 0)
      }, error = function(e) {
        rxLinMod(form_rx , data = data_grundlage, reportProgress = 0)
      })
    }else if(bigData == FALSE){
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

    if(interaction == 0){
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

#-----------------------------------------------------------------------------------------------------------
# Automatisierung Regressions-Modell

regression.auto <- function(dep.daten, dep.daten.temp, datengrundlage, range, interaction, nameDep, bigData = FALSE){
  
  reg.daten <- datengrundlage
  
  # In dieser Variable wird das "beste Modell" mit den zugehoerigen Informationen gespeichert
  erg <- 0
  
  # Count Anzahl der Durchlaeufe 
  durchlaeufe <- 0
  
  # Alle moeglichen Lag-Varianten in einer Matrix gespeichert.
  lag.vec.frame <- expand.grid(rep(list(0:range), length(datengrundlage)))
  lag.vec.frame.par <<- lag.vec.frame
  
  # Register cluster to run in paralle
  #detectCores()
  cl <- makeCluster(detectCores()) 
  registerDoParallel(cl)
  

  
  erg.eval <- foreach(k = 1:(dim(lag.vec.frame)[1]), .combine='cbind', .export = c("calculate.data.lags", "linear.regression.auto")) %dopar%{
    
    lag.vec <- lag.vec.frame[k, ]  
    cur.max <- max(lag.vec)
    cur.min <- min(lag.vec)
    dep.temp <- dep.daten.temp
    
    # Aufbereitung der Datengrundlage (Daten der unabhÃ¤ngigen Variable) fuer die Lags
    daten.grundlage.dep.ind <- calculate.data.lags(lag.vec, cur.max, cur.min, reg.daten, dep.temp)
    daten.grundlage <- daten.grundlage.dep.ind[[1]]
    
    # Aufbereitung der abhaengigen Variable in Abhaengigkeit der Lags fuer die Regression
    dep.temp <- daten.grundlage.dep.ind[[2]]
    
    # Erstellung des temporaeren Regressionsmodells
    daten.grundlage <- as.data.frame(daten.grundlage)
    colnames(daten.grundlage) <- attributes(reg.daten)$names
    
    # Berechnen des Regressionsmodells auf Basis der getaetigten Einstellungen
    lm.lags <- linear.regression.auto(daten.grundlage, dep.temp, interaction, nameDep, bigData)

    durchlaeufe <- durchlaeufe + 1
    
    if(bigData == TRUE){
      c(k, lm.lags$aic[1])
    }else if(bigData == FALSE){
      c(k, AIC(lm.lags))
    }
    
  }
  
  #print(erg.eval)
  erg.eval.par <<- erg.eval

  # Rueckgabe des "besten" Modells
  
  # Auslesen der timelags für das beste Modell

  
  lag.vec.erg <- lag.vec.frame[which.min(erg.eval[2, ]), ]  
  cur.max.erg <- max(lag.vec.erg)
  cur.min.erg <- min(lag.vec.erg)
  dep.temp.erg <- dep.daten.temp
  
  #Aufbereitung der Datengrunlage fuer die Berechnung des besten Modells
  daten.grundlage.dep.ind <- calculate.data.lags(lag.vec.erg, cur.max.erg, cur.min.erg, reg.daten, dep.daten.temp)
  daten.grundlage <- daten.grundlage.dep.ind[[1]]
  dep.temp <- daten.grundlage.dep.ind[[2]]
  
  # Erstellung des temporaeren Regressionsmodells
  daten.grundlage <- as.data.frame(daten.grundlage)
  colnames(daten.grundlage) <- attributes(reg.daten)$names
  
  # Berechnen des finalen Regressionsmodells auf Basis der getaetigten Einstellungen
  lm.lags <- linear.regression.auto(daten.grundlage, dep.temp, interaction, nameDep, bigData)
  
  beta.coefficents <- 0
  lags <- c(cur.min.erg, cur.max.erg)
  stopCluster(cl)
  
  return(list(lm.lags, daten.grundlage, lags, as.numeric(lag.vec.erg), beta.coefficents, dep.temp))
  
}

##############################################################################################
# Function to create spider-charts in r shiny

webplot = function(data, data.row = NULL, y.cols = NULL, main = NULL, add = F, 
                   col = "red", lty = 1, scale = T) {
  if (!is.matrix(data) & !is.data.frame(data)) 
    stop("Requires matrix or data.frame")
  if (is.null(y.cols)) 
    y.cols = colnames(data)[sapply(data, is.numeric)]
  if (sum(!sapply(data[, y.cols], is.numeric)) > 0) {
    out = paste0("\"", colnames(data)[!sapply(data, is.numeric)], "\"", 
                 collapse = ", ")
    stop(paste0("All y.cols must be numeric\n", out, " are not numeric"))
  }
  if (is.null(data.row)) 
    data.row = 1
  if (is.character(data.row)) 
    if (data.row %in% rownames(data)) {
      data.row = which(rownames(data) == data.row)
    } else {
      stop("Invalid value for data.row:\nMust be a valid rownames(data) or row-index value")
    }
  if (is.null(main)) 
    main = rownames(data)[data.row]
  if (scale == T) {
    data = scale(data[, y.cols])
    data = apply(data, 2, function(x) x/max(abs(x)))
  }
  data = as.data.frame(data)
  n.y = length(y.cols)
  min.rad = 360/n.y
  polar.vals = (90 + seq(0, 360, length.out = n.y + 1)) * pi/180
  
  if (add == F) {
    plot(0, xlim = c(-2.2, 2.2), ylim = c(-2.2, 2.2), type = "n", axes = F, 
         xlab = "", ylab = "")
    title(main)
    lapply(polar.vals, function(x) lines(c(0, 2 * cos(x)), c(0, 2 * sin(x))))
    lapply(1:n.y, function(x) text(2.15 * cos(polar.vals[x]), 2.15 * sin(polar.vals[x]), 
                                   y.cols[x], cex = 0.8))
    
    lapply(seq(0.5, 2, 0.5), function(x) lines(x * cos(seq(0, 2 * pi, length.out = 100)), 
                                               x * sin(seq(0, 2 * pi, length.out = 100)), lwd = 0.5, lty = 2, col = "gray60"))
    lines(cos(seq(0, 2 * pi, length.out = 100)), sin(seq(0, 2 * pi, length.out = 100)), 
          lwd = 1.2, col = "gray50")
  }
  
  
  r = 1 + data[data.row, y.cols]
  xs = r * cos(polar.vals)
  ys = r * sin(polar.vals)
  xs = c(xs, xs[1])
  ys = c(ys, ys[1])
  
  lines(xs, ys, col = col, lwd = 2, lty = lty)
  
}
############################################################################################################
verteilungsBetrachtung <- function(punktwerte){
  
  if(!is.data.frame(punktwerte)){
    stop("Bitte die zu fittenden Punktwerte als Data-Frame Ã¼bergeben")
  }
  
  # In dieser Liste werden die gefitteten Funktionen gespeichert
  erg.verteilungsfunktionen <- list()
  temp.anpassungstests <- data.frame()
  
  # Speichern der Punktwerte in einer Liste.
  temp.data <- list()
  temp.data <- as.list(punktwerte)
  for(i in seq(length(punktwerte))){
    temp.data[[i]] <- temp.data[[i]][!is.na(temp.data[[i]])]
  }
  
  
  # Hier beginnt das Verteilungsfitting
  for(j in seq(length(temp.data))){
    temp.verteilungsnamen <- c("norm", "lnorm", "exp", "pois", "cauchy", "gamma", "logis", "geom", "unif", "weibull", "pareto")
    
    # Fitdist ist fÃ¼r alle Verteilungsfunktionen auÃŸer fÃ¼r parteo - Pareto-Verteilung implementiert
    temp.verteilungen <- list()
    plot.legend <- c()
    error.count <- 0
    for(k in seq(length(temp.verteilungsnamen))){
      temp <- 0
      error.count <- 0
      if(temp.verteilungsnamen[k] != "pareto"){
        temp.fitdist <- tryCatch({
          temp <-suppressWarnings(fitdist(temp.data[[j]], temp.verteilungsnamen[k]))
        }, error = function(err){
          print("Using method mme")
          temp <- suppressWarnings(fitdist(temp.data[[j]], temp.verteilungsnamen[k], method = "mme"))
          return(temp)
        }, error = function(err){
          print("Using method mge")
          temp <- suppressWarnings(fitdist(temp.data[[j]], temp.verteilungsnamen[k], method = "mge"))
          return(temp)
        }, error = function(err){
          print(paste("F?r", temp.verteilungsnamen[k], "keine Anpassung m?glich", sep = " "))
          error.count <<- 1
        })
        error.count
        if(error.count == 0){
          temp.verteilungen <- c(temp.verteilungen, list(temp.fitdist))
        }
      } else if(temp.verteilungsnamen[k] == "pareto") {
        temp.fitdist <- tryCatch({
          fitdist(temp.data[[j]], temp.verteilungsnamen[k] ,start = list(shape = 1, scale = 500))
        }, error = function(err){
          print("Using method mme")
          temp <- suppressWarnings(fitdist(temp.data[[j]], temp.verteilungsnamen[k], start = list(shape = 1, scale = 500), method = "mme"))
          return(temp)
        }, error = function(err){
          print("Using method mge")
          temp <- suppressWarnings(fitdist(temp.data[[j]], temp.verteilungsnamen[k], start = list(shape = 1, scale = 500), method = "mge"))
          return(temp)
        }, error = function(err){
          print(paste("F?r", temp.verteilungsnamen[k], "keine Anpassung m?glich", sep = " "))
          error.count <<- 1
        })
        if(error.count == 0){
          temp.verteilungen <- c(temp.verteilungen, list(temp.fitdist))
        }
      }
      if(error.count == 0){
        plot.legend <- c(plot.legend, temp.verteilungsnamen[k])
      }
    }
    
    # Nachdem die geschÃ¤tzten Verteilungsfunktionen erstellt worden sind werden diese nun grafisch und analystisch ausgewertet
    auswertung.verteilungen <- temp.verteilungen
    aenderungen <- 0
    bic.aic.data.frame <- data.frame()
    if(length(temp.verteilungen) == 1){
      print(gofstat(temp.verteilungen[[1]], fitnames = plot.legend))
    } else {
      for(n in seq(length(temp.verteilungen))){
        tryCatch({
          suppressWarnings(gofstat(temp.verteilungen[[n]]))
        }, error = function(err){
          print(paste("Für", temp.verteilungen[[n]]$distname, "keine Anpassungsauswertung möglich", sep = " "))
          auswertung.verteilungen <<- auswertung.verteilungen[- n + aenderungen]
          plot.legend <<- plot.legend [- n + aenderungen]
          aenderungen <<- aenderungen + 1
          if(aenderungen == 1){
            bic.aic.data.frame <<- data.frame(c(temp.verteilungen[[n]]$aic, temp.verteilungen[[n]]$bic))
            colnames(bic.aic.data.frame)[aenderungen] <<- temp.verteilungen[[n]]$distname
          } else {
            bic.aic.data.frame <<- cbind(bic.aic.data.frame, c(temp.verteilungen[[n]]$aic, temp.verteilungen[[n]]$bic))
            colnames(bic.aic.data.frame)[aenderungen] <<- temp.verteilungen[[n]]$distname
          }
        })
      }
      
      temp.min.aic.bic <- data.frame()
      if(aenderungen != 0){
        rownames(bic.aic.data.frame) <- c("Aikake's Information Criterion", "Bayesian Information Criterion")
        print(bic.aic.data.frame)
        temp.min.aic.bic <- data.frame(Verteilung = attributes(bic.aic.data.frame)$names[which(bic.aic.data.frame[1, ] == min(bic.aic.data.frame[1, ], na.rm = TRUE))[1]],
                                       Value = bic.aic.data.frame[1, which(bic.aic.data.frame[1, ] == min(bic.aic.data.frame[1, ], na.rm = TRUE))[1]])
        temp.min.aic.bic[2, ] <- data.frame(attributes(bic.aic.data.frame)$names[which(bic.aic.data.frame[2, ] == min(bic.aic.data.frame[2, ], na.rm = TRUE))[1]],
                                            bic.aic.data.frame[2, which(bic.aic.data.frame[2, ] == min(bic.aic.data.frame[2, ], na.rm = TRUE))[1]])
        rownames(temp.min.aic.bic)[1:2] <- c("AIC", "BIC")
        
      }
      
      
      if(aenderungen < 11){
        
        grundlage <- gofstat(auswertung.verteilungen, fitnames = plot.legend)
        
        bic <- grundlage$bic[order(grundlage$bic)]
        aic <- grundlage$aic[order(grundlage$aic)]
        kolmo <- grundlage$ks[order(grundlage$ks)]
        kramer <- grundlage$cvm[order(grundlage$cvm)]
        anderson <- grundlage$ad[order(grundlage$ad)]
        bind <- as.data.frame(round(rbind(kolmo, kramer, anderson, bic, aic), 3))
        bind.o <- rbind(order(grundlage$ks), order(grundlage$cvm) ,order(grundlage$ad), order(grundlage$bic), order(grundlage$aic))
        
        temp.anpassungstests <- as.data.frame(t(apply(bind.o, 1, function(x) x <- plot.legend[x])))
        erg <- data.frame()
        for(i in seq(length(temp.anpassungstests))){
          temp.anpassungstests[ ,i] <- as.character(temp.anpassungstests[ ,i])
          if(i == 1){
            erg <- cbind(temp.anpassungstests[ ,i], bind[ ,i])
          } else {
            erg <- cbind(erg, temp.anpassungstests[ ,i], bind[ ,i])
          }
        }
        
        if(length(erg) > 10){
          temp.anpassungstests <- as.data.frame(erg[ ,1:10])
        } else {
          temp.anpassungstests <- as.data.frame(erg)
        }
        
        
        rownames(temp.anpassungstests) <- c("Kolmogorov-Smirnov", "Cramer-von Mises", "Anderson-Darling", "Aikake's Information Criterion", "Bayesian Information Criterion")
        colnames(temp.anpassungstests) <- c(rep(1:(length(temp.anpassungstests)/2), each = 2))
      }
      
    }
    erg.verteilungsfunktionen <- temp.verteilungen
  }
  
  final <- list(erg.verteilungsfunktionen, temp.anpassungstests)
  final
  
}