# Einbindung der Latex-Application als Voraussetzung der Generierung automatischer PDF-Reports
# sollte die Application auf andere Rechner gestreut werden, muss garantiert werdern, dass 
# pdflatex installiert ist.
# Sys.which('pdflatex')
# Sys.getenv('PATH')
# Sys.setenv(PATH=paste(Sys.getenv("PATH"),"C:\\Program Files (x86)\\MiKTeX 2.9\\miktex\\bin",sep=";"))
daten.under <- reactiveValues(
  base = read.csv("./Showcase/Stahlpreis.csv")
)

verteilungsBetrachtung <- function(punktwerte){
  # Diese Funktion ist daf?r verantwortlich ein gegebenes Histogramm einer Verteilung zuzuordnen
  
  # Falls der Input nicht vom Format data.frame ist, bricht die Funktion hier ab
  if(!is.data.frame(punktwerte)){
    stop("Bitte die zu fittenden Punktwerte als Data-Frame Uebergeben")
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
    
    # Fitdist ist fuer alle Verteilungsfunktionen ausser fuer Pareto-Verteilung implementiert
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
          #print("Using method mme")
          temp <- suppressWarnings(fitdist(temp.data[[j]], temp.verteilungsnamen[k], method = "mme"))
          return(temp)
        }, error = function(err){
          #print("Using method mge")
          temp <- suppressWarnings(fitdist(temp.data[[j]], temp.verteilungsnamen[k], method = "mge"))
          return(temp)
        }, error = function(err){
          #print(paste("Für", temp.verteilungsnamen[k], "keine Anpassung moeglich", sep = " "))
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
          #print("Using method mme")
          temp <- suppressWarnings(fitdist(temp.data[[j]], temp.verteilungsnamen[k], start = list(shape = 1, scale = 500), method = "mme"))
          return(temp)
        }, error = function(err){
          #print("Using method mge")
          temp <- suppressWarnings(fitdist(temp.data[[j]], temp.verteilungsnamen[k], start = list(shape = 1, scale = 500), method = "mge"))
          return(temp)
        }, error = function(err){
          #print(paste("Fuer", temp.verteilungsnamen[k], "keine Anpassung moeglich", sep = " "))
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
    
    # Nachdem die geschaetzten Verteilungsfunktionen erstellt worden sind werden diese nun grafisch und analystisch ausgewertet
    auswertung.verteilungen <- temp.verteilungen
    aenderungen <- 0
    bic.aic.data.frame <- data.frame()
    if(length(temp.verteilungen) == 1){
      #print(gofstat(temp.verteilungen[[1]], fitnames = plot.legend))
    } else {
      for(n in seq(length(temp.verteilungen))){
        tryCatch({
          suppressWarnings(gofstat(temp.verteilungen[[n]]))
        }, error = function(err){
          #print(paste("Fuer", temp.verteilungen[[n]]$distname, "keine Anpassungsauswertung moeglich", sep = " "))
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
        rownames(bic.aic.data.frame) <- c("Akaike's Information Criterion", "Bayesian Information Criterion")
        #print(bic.aic.data.frame)
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
        bind <- as_data_frame(round(rbind(kolmo, kramer, anderson, bic, aic), 3))
        bind.o <- rbind(order(grundlage$ks), order(grundlage$cvm) ,order(grundlage$ad), order(grundlage$bic), order(grundlage$aic))
        
        temp.anpassungstests <- as_data_frame(t(apply(bind.o, 1, function(x) x <- plot.legend[x])))
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
          temp.anpassungstests <- as_data_frame(erg[ ,1:10])
        } else {
          temp.anpassungstests <- as_data_frame(erg)
        }
        
        
        rownames(temp.anpassungstests) <- c("Kolmogorov-Smirnov", "Cramer-von Mises", "Anderson-Darling", "Aikake's Information Criterion", "Bayesian Information Criterion")
        colnames(temp.anpassungstests) <- c(rep(1:(length(temp.anpassungstests)/2), each = 2))
      }
      
    }
    erg.verteilungsfunktionen <- temp.verteilungen
  }
  
  final <- list(erg.verteilungsfunktionen, temp.anpassungstests)
  return(final)
  
}


cor.lag <- function(dep.var, indep.var, Lag){
  # Funktion zur Betrachtung der Korrelation zwischen abhaengiger und unabhaengiger Variable unter
  # Einbeziehung verschiedener Time-lags.
  
  # dep.var ... gewaehlte abhaengige Variable
  # indep.var ... gewaehlte unabhaengige Variable. Fliesst mit einem bestimmten Koeffizienten in die
  # Berechnung der abhaengigen Variable mit ein.
  # Lags ... zeitliche Verschiebung mit der die unabhaengige Variable auf die abhaengige einwirkt
  # Lag = 1 bedeutet, dass dep.var[i] von indep.var[i-1] beeinflusst wird usw.
  
  # Ausschluss von moeglichen Szenarien, fuer die keine Korrelationen bestimmt werden koennen.
  if(abs(Lag) >= (length(dep.var) - 2)){
    stop("Die Laganzahl sollte die Anzahl der Datenpunkte minus 2 nicht uebersteigen")
  }
  if(!is.numeric(dep.var)){
    stop("Die abhaengige Variable muss ein numerischer Vektor sein!")
  }
  if(!is.numeric(indep.var)){
    stop("Die unabhaengige Variable muss ein numerischer Vektor sein!")
  }
  if(!is.numeric(Lag)){
    stop("Laganzahl muss als ganze Zahl uebergeben werden!")
  }
  
  korrelations.data.frame <- data.frame(Cor = cor(dep.var, indep.var, use = "pairwise.complete.obs"), Lag = 0)
  
  if(Lag == 0){
    return(korrelations.data.frame)
  }
  
  if(Lag > 0){
    for(i in seq(Lag)){
      indep.var <- c(indep.var[- length(indep.var)])
      dep.var <- c(dep.var[-1])
      temp.data.frame <- data.frame(Cor = cor(dep.var, indep.var, use = "pairwise.complete.obs"), Lag = i)
      korrelations.data.frame <- rbind(korrelations.data.frame, temp.data.frame)
    }
  } else {
    for(i in -1:Lag){
      indep.var <- c(indep.var[-1])
      dep.var <- c(dep.var[- length(dep.var)])
      temp.data.frame <- data.frame(Cor = cor(dep.var, indep.var, use = "pairwise.complete.obs"), Lag = i)
      korrelations.data.frame <- rbind(korrelations.data.frame, temp.data.frame)
    }
  }
  
  korrelations.data.frame
}


server <- function(input, output, session) {
  
  source("Server/0.General/0.0.server_sidebar.R", local = TRUE)

  source('Server/0.General/0.4.server_functions.R', local = TRUE)

  #source('Server/1.Dataimport/1.0.server_dataimport.R', local=TRUE)

  source('Server/3.DataAnalysis/3.1.server_data_analysis.R', local=TRUE)
  source('Server/3.DataAnalysis/3.2.server_TSDecomposition.R', local=TRUE)

  
  onSessionEnded = function(callback) {
    "Registers the given callback to be invoked when the session is closed
    (i.e. the connection to the client has been severed). The return value
    is a function which unregisters the callback. If multiple callbacks are
    registered, the order in which they are invoked is not guaranteed."
    return(.closedCallbacks$register(callback))
  }
  
  session$onSessionEnded(function(){
    stopApp()
  })
}

