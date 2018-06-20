# Erlaeuterungstexte

output$texthelp14<-renderUI({
  "The chosen independent variables will be considered in determining the prediction model for the dependent variable. "
})
output$texthelp15<-renderUI({
  "Select a range of possible time lags to search the best fitted model in. The algorithm will systematically go through all possible 
  combinations of lags of the chosen independent variables and will select the best regression model based 
  on the AIC (Aikake´s Information Criterion). If interactions between independent variables should also be considered, then the product 
  of 2 different variables will also be regarded as a potential predictor.
  After pressing the 'Preview Explanation Model' the search algorithm will start . Be aware of the potentially long running time if there is large range of time lags,
  a huge famount of independent variables and interactions between them selected.
  \\\\\\ 1. Fuel.Energy.Index     2. Arca.Steel.Index      3. ArcelorMittal    4. Iron.ore    5. Metal.Index     -> range to search: 3 -> interactions: no"
})

output$texthelp16<-renderUI({
  "The chosen independent variables will be considered in determining the prediction model for the dependent variable. "
})
output$texthelp17<-renderUI({
  "Choose lags for selected variables. Type as much numbers as independent variables chosen and  separate them with spaces.
  If nothing is entered, 0 lags for all chosen independent variables are assumed. If interactions between independent variables
  should also be considered, then the product of 2 different variables will also be regarded as a potential predictor. 
  If optimize model (Yes) is selected an algorithm will search the best fitted model based on the possible independent variables 
  (using AIC as decision criteria). After pressing the 'Preview Explanation Model' only the regression model based on the lag input and interactions 
  input will be calculated. So the running time will be comparatively short. "
})

# Diese reactiveValues umfassen eine Variable die das aktuell automatisch erstellte Regressionsmodell
# das aktuell manuell erstellte Regressionsmodell und das aktuell gespeicherte Modell beinhaltem
regression.modelle <- reactiveValues(
  
  automatisches.modell = 0,
  manuelles.modell = 0, 
  gespeichertes.modell = 0,
  # Art (Manuel oder Automatisch)
  art.gespeichertes.modell = "",
  
  # Statistische Kennzahlen des aktuell gespeicherten Modells
  regression.quality = 0,
  # Koeffizienten des aktuell gespeicherten Modells
  regression.coefficent = 0,
  
  indexcalculateauto = 0,
  indexcalculatemanual = 0,
  
  gespeicherte.forecasts = list()
  
)

# Diese Funktion organisiert im Reiter "Parameterschaetzung" die Auswahlmoeglichkeiten der unabhaengigen Variablen fuer die Regressionsanalyse
# der abhaengigen Variable.
output$choose_columns <- renderUI({
  
  reg.data <- daten.under$base[ ,sapply(daten.under$base, is.numeric)]
  index.depVar <- which(attributes(reg.data)$names == input$depVar)
  
  
  colnames <- names(reg.data)[- index.depVar]
  
  # Create the checkboxes and select them all by default
  selectInput("columns", "Choose independent variables for regression", 
              choices  = colnames,
              multiple = TRUE)
})


# Diese Funktion organisiert im Reiter "Parameterschaetzung" die Auswahlmoeglichkeiten der unabhaengigen Variablen fuer die manuelle Regressionsanalyse
# der abhaengigen Variable.
output$choose_columns_manual <- renderUI({
  
  reg.data <- daten.under$base[ ,sapply(daten.under$base, is.numeric)]
  index.depVar <- which(attributes(reg.data)$names == input$depVar)
  
  colnames <- names(reg.data)[- index.depVar]
  
  # Create the checkboxes and select them all by default
  selectInput("columns_manual", "Choose independent variables for regression", 
              choices  = colnames,
              multiple = TRUE)
})


# Die Funktion "regression" fuehrt auf Basis der gewaehlten unabhaengigen Variablen im Reiter "Parameterschaetzung"
# und der entsprechend gewaehlten Lags eine lineare Regression fuer die abhaengige Variable durch.
regression <- eventReactive(input$reg, {
  
  # Zu Beginn werden viele Checks bezueglich des Inputs der Lags durchgefuehrt, um Fehleingaben abzufangen.
  if(is.null(input$columns_manual)){return()}
  
  s2 <- gsub(" ", "", input$lagAll)
  list.lags <- strsplit(input$lagAll, " ")
  
  diff <- length(which(list.lags[[1]] != ""))
  
  if(length(input$columns_manual)  != diff & length(input$lagAll) == 0){return()}
  
  isolate(s2 <- gsub(" ", "", input$lagAll))
  list.lags <- strsplit(input$lagAll, " ")
  diff <- length(which(list.lags[[1]] != ""))
  
  if(length(input$columns_manual) == 0){return()}
 
  withProgress(message = "Calculating manual model", value=0.1,{
    
    
    regression.modelle$indexcalculatemanual <- 1
    
    bigData = FALSE
    
    if(length(input$columns_manual) == 0)return()
    
    reg.daten <- daten.under$base[ ,sapply(daten.under$base, is.numeric)]
    reg.daten <- as.tbl(reg.daten)
    reg.daten <- reg.daten[ , - which(attributes(reg.daten)$names == input$depVar)]
    reg.daten <- reg.daten[ ,input$columns_manual]
    
    lag.vec <- c()
    
      if(input$lagAll != ""){
        s2 <- gsub(" ", "", input$lagAll)
        list.lags <- strsplit(input$lagAll, " ")
        
        diff <- length(which(list.lags[[1]] != ""))
        
        if(length(input$columns_manual) != diff || is.na(as.numeric(s2))) return()
        
        lag <- input$lagAll
        
        is.neg <- FALSE
        
        for(i in seq(length(list.lags[[1]]))){
          if(substr(list.lags[[1]][i], 1, 1) == "-"){
            is.neg <- TRUE
            temp <- (-1)*as.numeric(substr(list.lags[[1]][i], 2, nchar(list.lags[[1]][i])))
            lag.vec <- c(lag.vec, temp)
          } else {
            temp <- as.numeric(substr(list.lags[[1]][i], 1, nchar(list.lags[[1]][i])))
            lag.vec <- c(lag.vec, temp)
          }
          
        }
        
        lag.vec <- lag.vec[complete.cases(lag.vec)]
        
      } else {
        lag.vec <- rep(0, length(input$columns_manual))
      }
      
      daten.grundlage <- vector()
      cur.max <- max(lag.vec)
      cur.min <- min(lag.vec)
      
      if((cur.max + abs(cur.min)) < length(daten.under$base[[1]])){
        for(j in seq(length(input$columns_manual))){
          if(lag.vec[j] > 0){
            temp <- reg.daten[[j]][- ((length(reg.daten[[j]]) + 1 - lag.vec[j]):length(reg.daten[[j]]))]
            if(cur.max - lag.vec[j] != 0){
              temp <- temp[-(1:(cur.max - lag.vec[j]))]
            }
            if(cur.min < 0){
              temp <- temp[- ((length(reg.daten[[j]]) + 1 + cur.min - cur.max) : (length(reg.daten[[j]]) - cur.max))]
            }
            daten.grundlage <- cbind(daten.grundlage, temp)
          } else if(lag.vec[j] < 0){
            temp <- reg.daten[[j]][- (1:abs(lag.vec[j]))]
            if(cur.max > 0){
              temp <- temp[- (1:cur.max)]
            }
            if((lag.vec[j] - cur.min) != 0 && cur.max >= 0){
              temp <- temp[- ((length(reg.daten[[j]]) + 1 + lag.vec[j] + (cur.min - lag.vec[j]) - cur.max):(length(reg.daten[[j]]) + lag.vec[j] - cur.max))]
            } else if((lag.vec[j] - cur.min) != 0 && cur.max < 0){
              temp <- temp[- ((length(reg.daten[[j]]) + 1 + lag.vec[j] + (cur.min - lag.vec[j])):(length(reg.daten[[j]]) + lag.vec[j]))]
            }
            daten.grundlage <- cbind(daten.grundlage, temp)
          } else if(lag.vec[j] == 0){
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

    dep.daten <- daten.under$base[ ,sapply(daten.under$base, is.numeric)]
    index.dep.var <- which(attributes(dep.daten)$names == input$depVar)
    dep.daten <- as.data.frame(dep.daten[ , index.dep.var])
    dep.daten.temp <- dep.daten[[1]]
    
    if(cur.max > 0){
      dep.daten.temp <- dep.daten.temp[-(1:cur.max)]
    }
    if(cur.min < 0 && cur.max >= 0){
      dep.daten.temp <- dep.daten.temp[- ((length(dep.daten[[1]]) + 1 + cur.min - cur.max): (length(dep.daten[[1]]) - cur.max))]
    } else if(cur.min < 0 && cur.max < 0){
      dep.daten.temp <- dep.daten.temp[- ((length(dep.daten[[1]]) + 1 + cur.min): length(dep.daten[[1]]))]
    }
    
    daten.grundlage <- as.tbl(as.data.frame(daten.grundlage))
    colnames(daten.grundlage) <- attributes(reg.daten)$names
    lm.lags <- 0
    
    daten.grundlage.na.clean <- daten.grundlage[complete.cases(daten.grundlage), ]
    dep.temp.na.clean <- dep.daten.temp[complete.cases(daten.grundlage)]
    
    
    # Berechnung des Regressionsmodells auf Basis der oben modifizierten Datengrundlage
    # bigData == TRUE benoetigen kommerzielle R Server Version von Microsoft, wird bisher noch nicht genutzt
    if(bigData == TRUE){
      data_grundlage <- cbind(dep.temp.na.clean, daten.grundlage.na.clean)
      names(data_grundlage)[1] <- input$depVar
      form_rx <- as.formula(paste(paste(names(data_grundlage)[1], "~", sep = ""),
                                  paste(names(data_grundlage)[-1],collapse="+")))
      
      if(input$interaction.2 == 0 && isolate(input$optimize) == 1){
        lm.lags <- tryCatch({
          rxLinMod(form_rx , data = data_grundlage,
                   variableSelection = rxStepControl(method="stepwise"), reportProgress = 0)
        }, error = function(e) {
          rxLinMod(form_rx , data = data_grundlage, reportProgress = 0)
        })
      }else if(input$interaction.2 == 1 && isolate(input$optimize) == 1){
        form_rx <- as.formula(paste(paste(names(data_grundlage)[1], "~(", sep = ""),
                                    paste(names(data_grundlage)[-1],collapse="+"), ")^2"))
        lm.lags <- tryCatch({
          rxLinMod(form_rx , data = data_grundlage,
                   variableSelection = rxStepControl(method="stepwise"), reportProgress = 0)
        }, error = function(e) {
          rxLinMod(form_rx , data = data_grundlage, reportProgress = 0)
        })
      }else if(input$interaction.2 == 0){
        lm.lags <- rxLinMod(form_rx , data = data_grundlage, reportProgress = 0)
      }else if(input$interaction.2 == 1){
        form_rx <- as.formula(paste(paste(names(data_grundlage)[1], "~(", sep = ""),
                                    paste(names(data_grundlage)[-1],collapse="+"), ")^2"))
        lm.lags <- rxLinMod(form_rx , data = data_grundlage, reportProgress = 0)
      }
    }else if(bigData == FALSE){
      if(isolate(input$interaction.2) == 0){
        lm.lags <- lm(dep.temp.na.clean ~. ,data = daten.grundlage.na.clean)
      } else {
        lm.lags <- lm(dep.temp.na.clean ~.^2 ,data = daten.grundlage.na.clean)
      }
      
      if(isolate(input$optimize) == 1){
        lm.lags <- tryCatch({
          stepAIC(lm.lags, direction = "both", trace = FALSE)
        }, error = function(e) {
          lm.lags
        })
      }
    }
    
    #beta.coefficents <- suppressWarnings(lm.beta(lm.lags))
    # Werden aktuell nicht verwendet
    beta.coefficents <- 0
    
    daten.grundlage.data <- as.data.frame(daten.grundlage)
    colnames(daten.grundlage.data) <- c(attributes(reg.daten)$names)
    lags <- c(cur.min, cur.max)
    regression.modelle$manuelles.modell <- list(lm.lags, daten.grundlage.data, lags, lag.vec, beta.coefficents, dep.daten.temp, input$depVar)
    
    return(regression.modelle$manuelles.modell)
    
    setProgress(1)
    Sys.sleep(1.5)
  })
  
})



# Diese Funktion uebernimmt die automatische Modellselection in Abhaengigkeit des 
# Guetekrtiteriums AIC. Die enstprechenden Methoden (regression.auto(...)) befindet sich im Skript "lagFunctions.R"
reg.auto <- eventReactive(input$autoReg, {
  
  
  input.range.test <- input$range
  if(identical(input$range, NA) || input$range == "" || input$range < 1 || is.integer(input$range) == FALSE || input$range > 10 ){
    return(
      withProgress(message = "Choose proper range", Sys.sleep(1.5))
    )
  }
  if(is.null(input$columns)){
    return(withProgress(message = "Choose independent variables", Sys.sleep(1.5)))
  }
  
  
  
  withProgress(message = "Calculating automatic model",value=0.1,{
    regression.modelle$indexcalculateauto <-1
    
    
    reg.daten <- daten.under$base[ ,sapply(daten.under$base, is.numeric)]
    reg.daten <- as.tbl(reg.daten)
    reg.daten <- reg.daten[ , - which(attributes(reg.daten)$names == input$depVar)]
    reg.daten <- reg.daten[ ,input$columns]
    
    dep.daten <- daten.under$base[ , which(attributes(daten.under$base)$names == input$depVar)]
    dep.daten.temp <- as.data.frame(dep.daten)[[1]]
    
    bereich <- isolate(input$range)
    inter <- isolate(input$interaction.1)
    
    bigData = FALSE
    reg.ergebnis <- regression.auto(dep.daten, dep.daten.temp, reg.daten, bereich, inter, input$depVar, bigData)
    
    coef.matrix <- data.frame()
    erg.vec <- vector()
    modell <- reg.ergebnis[[1]]
    
    if(bigData == TRUE){
      coef.matrix <- as.data.frame(cbind(modell$coefficients,
                                         modell$coef.std.error,
                                         modell$coef.t.value,
                                         modell$coef.p.value))
      
      names(coef.matrix) <- c("Coeff.", "Std.Err.", "T.Value", "P.Value")
      
      aic.reg <- extractAIC(modell)[2]
      r.squ <- modell$r.squared
      adj.r.squ <- modell$adj.r.squared
      erg.vec <- rbind(aic.reg,  r.squ, adj.r.squ)
      rownames(erg.vec) <- c("Aikake's Information Criterion",  "R-squared", "Adjusted R-squared")
      colnames(erg.vec) <- c("Value")
    }else{
      coef.matrix <- summary(modell)[4][[1]]
      
      bic.reg <- BIC(modell)
      aic.reg <- extractAIC(modell)[2]
      r.squ <- summary(reg.ergebnis[[1]])[8][[1]]
      adj.r.squ <- summary(reg.ergebnis[[1]])[9][[1]]
      erg.vec <- rbind(aic.reg, bic.reg, r.squ, adj.r.squ)
      
      rownames(erg.vec) <- c("Aikake's Information Criterion", "Bayesian Information Criterion", "R-squared", "Adjusted R-squared")
      colnames(erg.vec) <- c("Value")
    }
    
    regression.modelle$automatisches.modell <- c(reg.ergebnis, list(coef.matrix, erg.vec, input$depVar))
    
    return(regression.modelle$automatisches.modell)
    
    setProgress(1)
    Sys.sleep(1.5)
  })
  
})

# Ausgabe der Koeffizienten des automatischen Modells
output$auto.coef <- renderTable({
  
  reg.auto()[[7]]
  
})

# Ausgabe der Guetekriterien des automatischen Modells
output$auto.qual <- renderTable({

  reg.auto()[[8]]
  
})

# Ausgabe der Lags des automatischen Modells
output$auto.lag <- renderTable({
  
  
  reg.erg <- reg.auto()
  
  lags <- reg.erg[[4]]
  
  if(identical(lags, NULL)) {return()}
  
  lags.store <- data.frame(lags)
  
  
  rownames(lags.store) <- attributes(reg.erg[[2]])$names
  colnames(lags.store) <- "Lags"
  
  lags.store
})

# Ausgabe der Time Series fuer das manuelle Modell
output$regAuto <- renderDygraph({
  
  regErgAuto()
  
})


# Erstellung einer Tabelle mit resultierenden Parameterwerten (Koeffizienten, Standardfehler, P-Value)
# als Inhalt (Manuelles Modell)
coefficient.table <- eventReactive(input$reg, {
  
  s2 <- gsub(" ", "", input$lagAll)
  list.lags <- strsplit(input$lagAll, " ")
  
  diff <- length(which(list.lags[[1]] != ""))
  
  if(length(input$columns_manual)  != diff & length(input$lagAll) == 0){return()}
  
  isolate(s2 <- gsub(" ", "", input$lagAll))
  list.lags <- strsplit(input$lagAll, " ")
  diff <- length(which(list.lags[[1]] != ""))
  
  if(is.null(input$columns_manual)){return(withProgress(message ="Choose independent variables", Sys.sleep(1.5)))}
  
  
  if(length(input$columns_manual) == 0){return(withProgress(message = "Choose independent variables", Sys.sleep(1.5)))}
  if(length(input$columns_manual)  != diff & length(input$lagAll) == 0){return(withProgress(message = "Choose proper lags", Sys.sleep(1.5)))}
  
  validate(
    need(length(input$columns_manual) != 0, "Choose some independent variables for regression"),
    need(length(input$columns_manual)  == diff || nchar(s2) == 0 , "Choose same amount of lags as quantity of independent variablen"),
    need(identical(regression(), NULL) == FALSE, "Not applicable lag-input")
  )
  
  modell <- regression()[[1]]
  bigData = FALSE
  coef.matrix <- data.frame()
  
  if(bigData == TRUE){
    coef.matrix <- as.data.frame(cbind(modell$coefficients,
                                       modell$coef.std.error,
                                       modell$coef.t.value,
                                       modell$coef.p.value))
    
    names(coef.matrix) <- c("Coeff.", "Std.Err.", "T.Value", "P.Value")
  }else if(bigData == FALSE){
    coef.matrix <- summary(modell)[4][[1]]
  }
  
  return(coef.matrix)
  
})

# Diese renderTable organisiert die Ausgabe der erhaltenen Ergbenisse der Regression und gibt diese Tabelle aus
# (unter Coefficent evaluation).
output$dataGrundlage <- renderTable({
  
  coefficient.table()
  
})

# Ausgabe der Lags fuer das manuell gefittete Modell 
output$manual.lag <- renderTable({
  
  s2 <- gsub(" ", "", input$lagAll)
  list.lags <- strsplit(input$lagAll, " ")
  
  diff <- length(which(list.lags[[1]] != ""))
  
  if(length(input$columns_manual)  != diff & length(input$lagAll) == 0){return()}
  
  
  reg.erg <- regression()
  lags <- reg.erg[[4]]
  
  if(identical(lags, NULL)) {return()}
  
  lags.store <- data.frame(lags)
  
  rownames(lags.store) <- attributes(reg.erg[[2]])$names
  colnames(lags.store) <- "Lags"
  
  lags.store
})


# Diese Funktion organisiert die Ausgabe der statistischen Guetekennzahlen der Regression und gibt diese Tabelle aus
# (unter Quality of Regression)
quality.table <- eventReactive(input$reg, {
  
  s2 <- gsub(" ", "", input$lagAll)
  list.lags <- strsplit(input$lagAll, " ")
  
  diff <- length(which(list.lags[[1]] != ""))
  
  if(length(input$columns_manual)  != diff & length(input$lagAll) == 0){return()}
  
  isolate(s2 <- gsub(" ", "", input$lagAll))
  #isolate(diff <- nchar(input$lagAll) - nchar(s2) + 1)
  list.lags <- strsplit(input$lagAll, " ")
  diff <- length(which(list.lags[[1]] != ""))
  
  if(is.null(input$columns_manual)){return()}
  
  
  validate(
    need(length(input$columns_manual) != 0, "Choose some independent variables for regression"),
    need(length(input$columns_manual) == diff || nchar(s2) == 0, "Choose same amount of lags as quantity of independent variablen"),
    need(identical(regression(), NULL) == FALSE, "Not applicable lag-input")
  )
  
  bigData = FALSE
  erg.vec <- vector()
  modell <- regression()[[1]]
  
  if(bigData == TRUE){
    aic.reg <- extractAIC(modell)[2]
    r.squ <- modell$r.squared
    adj.r.squ <- modell$adj.r.squared
    erg.vec <- rbind(aic.reg,  r.squ, adj.r.squ)
    rownames(erg.vec) <- c("Aikake's Information Criterion",  "R-squared", "Adjusted R-squared")
    colnames(erg.vec) <- c("Value")
  }else if(bigData == FALSE){
    bic.reg <- BIC(modell)
    aic.reg <- extractAIC(modell)[2]
    r.squ <- summary(modell)[8][[1]]
    adj.r.squ <- summary(modell)[9][[1]]
    erg.vec <- rbind(aic.reg, bic.reg, r.squ, adj.r.squ)
    rownames(erg.vec) <- c("Aikake's Information Criterion", "Bayesian Information Criterion", "R-squared", "Adjusted R-squared")
    colnames(erg.vec) <- c("Value")
  }
  
  return(erg.vec)
  
})

# Ausgabe der Tabelle mit statistischen Kennzahlen fuer das manuelle Modell
output$qualityMat <- renderTable({
  
  s2 <- gsub(" ", "", input$lagAll)
  list.lags <- strsplit(input$lagAll, " ")
  
  diff <- length(which(list.lags[[1]] != ""))
  
  if(length(input$columns_manual)  != diff & length(input$lagAll) == 0){return()}
  
  quality.table()
  
  
})

# Diese reactive-Function erstellt einen Plot fuer die historischen Werte gegen die gefitteten Werte der erhaltenen Regression.
# (manuelles Ergebnis (Function: regression(...)))
regErg <- eventReactive(input$reg, {
  
  s2 <- gsub(" ", "", input$lagAll)
  list.lags <- strsplit(input$lagAll, " ")
  
  diff <- length(which(list.lags[[1]] != ""))
  
  if(length(input$columns_manual)  != diff & length(input$lagAll) == 0){return()}
  
  if(is.null(input$columns_manual)){return()}
  
  
  if(is.null(input$columns_manual)){return(withProgress(message ="Choose independent variables" , Sys.sleep(1.5)))}
  
  isolate(s2 <- gsub(" ", "", input$lagAll))
  list.lags <- strsplit(input$lagAll, " ")
  diff <- length(which(list.lags[[1]] != ""))
  
  validate(
    need(length(input$columns_manual) != 0, "Choose some independent variables for regression"),
    need(length(input$columns_manual) == diff || nchar(s2) == 0, "Choose same amount of lags as quantity of independent variablen"),
    need(identical(regression(), NULL) == FALSE, "Not applicable lag-input")
  )
  
  dat.reg <- daten.under$base[ ,sapply(daten.under$base, is.numeric)]
  count <- 1:length(dat.reg[[1]])
  dat.reg <- cbind(count, dat.reg)
  index.depVar <- which(attributes(dat.reg)$names == input$depVar)
  
  # Setze Zeitserie auf
  ts.dat.reg <- xts(dat.reg[ ,index.depVar], daten.under$base[[1]])
  
  reg.modell <- regression()[[1]]
  daten.predict <- regression()[[2]]
  lags <- regression()[[3]]
  lags <- c(lags[2], lags[1])
  
  date.model <<- daten.predict
  reg.model <<- regression()
  
  bigData = FALSE
  predict.depVar <- numeric()
  if(bigData == TRUE){
    predict.depVar <- rxPredict(reg.modell, daten.predict)
  }else{
    predict.depVar <- predict(reg.modell, daten.predict)
  }
  
  # Determiniere Zeitserie der vorhergesagten Daten
  ts.daten.predict <- xts(predict.depVar, daten.under$base[[1]][(max(lags) + 1):length(daten.under$base[[1]])])
  ts.daten.ges <- cbind("Initial data" = ts.dat.reg,"Fitted data via regression" = ts.daten.predict)
  
  regression.plot <- dygraph(ts.daten.ges, main = input$depVar) %>% dyRangeSelector() %>%
    dyLegend(width = 800) %>% dyOptions(drawPoints = TRUE, pointSize = 2)
  
  return(regression.plot)
  
})

# Erstellung des Interaktiven Zeitserien-Graphens fuer das automatische Modell
regErgAuto <- eventReactive(input$autoReg, {
  
  if(identical(input$range, NA) || input$range == "" || input$range < 1 || is.integer(input$range) == FALSE || input$range > 10 ){
    return()
  }
  if(is.null(input$columns)){
    return()
  }

  regression.modell.auto <- regression.modelle$automatisches.modell
  
  s2 <- regression.modell.auto[[4]]
  
  dat.reg <- daten.under$base[ ,sapply(daten.under$base, is.numeric)]
  count <- 1:length(dat.reg[[1]])
  dat.reg <- cbind(count, dat.reg)
  index.depVar <- which(attributes(dat.reg)$names == input$depVar)
  
  # Setzen der Zeitserie
  ts.dat.reg <- xts(dat.reg[ ,index.depVar], daten.under$base[[1]])
  
  reg.modell <- regression.modell.auto[[1]]
  daten.predict <- regression.modell.auto[[2]]
  lags <- regression.modell.auto[[3]]
  lags <- c(lags[2], lags[1])
  
  bigData = FALSE
  predict.depVar <- numeric()
  if(bigData == TRUE){
    predict.depVar <- rxPredict(reg.modell, daten.predict)
  }else{
    predict.depVar <- predict(reg.modell, daten.predict)
  }

  ts.daten.predict <- xts(predict.depVar, daten.under$base[[1]][(max(lags) + 1):length(daten.under$base[[1]])])
  ts.daten.ges <- cbind("Initial data" = ts.dat.reg,"Fitted data via regression" = ts.daten.predict)
  
  regression.auto.plot <- dygraph(ts.daten.ges, main = input$depVar) %>% dyRangeSelector() %>%
    dyLegend(width = 800) %>% dyOptions(drawPoints = TRUE, pointSize = 2)
  
  regression.auto.plot
  
})

# Diese Funktion gibt den Ergebnisplot der Regression aus.
output$regErgebnis <- renderDygraph({
  
  validate(
    need(input$reg, "")
  )
  
  regErg()
  
})

# Indikator ob Speicherung stattgefunden hat (globale Variable), wird in folgenden Funktionen verwendet
regression.values <- reactiveValues(
  
  save.reg = 0
  
)

# Speichere manuell spezifiziertes Regressionsmodell
observeEvent(input$storeReg, {
  
  if(regression.modelle$indexcalculatemanual == 0 || identical(regression(), NULL)) {return(withProgress(message ="Save not possible", Sys.sleep(1.5)))}
  
  withProgress(message = "Manual explanation model saved",value=0.1,{
    
    regression.modelle$gespeichertes.modell <- regression()
    index2$indepVar<-nrow(as.data.frame(regression.modelle$gespeichertes.modell[[4]]))
    index2$range =""
    regression.modelle$regression.quality <- quality.table()
    regression.modelle$regression.coefficent <- coefficient.table()
    regression.values$save.reg <- regression.values$save.reg + 1
    regression.modelle$art.gespeichertes.modell <- "manual"
    setProgress(1)
    Sys.sleep(1.5)
    
  })
  
  
})


# Speichere automatisch spezifiziertes Regressionsmodell
observeEvent(input$storeRegAuto, {
  
  if(regression.modelle$indexcalculateauto == 0) {return(withProgress(message ="Save not possible", Sys.sleep(1.5)))}
  
  if(regression.modelle$indexcalculateauto == 0) {return(withProgress(message ="Save not possible", Sys.sleep(1.5)))}
  
  
  withProgress(message = "Automatic explanation model saved",value=0.1,{
    reg.temp <- reg.auto()
    regression.modelle$gespeichertes.modell <- reg.temp[c(1:6, 9)]
    
    index2$indepVar<-nrow(as.data.frame(regression.modelle$gespeichertes.modell[[4]]))
    isolate(index2$range <- input$range)
    regression.modelle$regression.quality <- reg.temp[[8]]
    regression.modelle$regression.coefficent <- reg.temp[[7]]
    regression.values$save.reg <- regression.values$save.reg + 1
    regression.modelle$art.gespeichertes.modell <- "auto"
    setProgress(1)
    Sys.sleep(1.5)
  })
  
})

# Ausgabe des gespeicherten Regressionsmodelle visualisiert in einem Dygraph
output$storedModel <- renderDygraph({
  

  #if(regression.values$save.reg != 0){
  
  regression.values$save.reg
  
  regression.mod <- regression.modelle$gespeichertes.modell
  
  if(length(regression.mod) == 1)return()
  
  s2 <- regression.mod[[4]]
  
  dat.reg <- daten.under$base[ ,sapply(daten.under$base, is.numeric)]
  count <- 1:length(dat.reg[[1]])
  dat.reg <- cbind(count, dat.reg)
  index.depVar <- which(attributes(dat.reg)$names == isolate(input$depVar))
  
  # Determinieren der Zeitserie der abhaengigen Variable
  ts.dat.reg  <- xts(dat.reg[ ,index.depVar], daten.under$base[[1]])
  
  reg.modell <- regression.mod[[1]]
  daten.predict <- regression.mod[[2]]
  lags <- regression.mod[[3]]
  lags <- c(lags[2], lags[1])
  
  bigData = FALSE
  predict.depVar <- numeric()
  if(bigData == TRUE){
    predict.depVar <- rxPredict(reg.modell, daten.predict)
  }else{
    predict.depVar <- predict(reg.modell, daten.predict)
  }
  
  ts.daten.predict <- xts(predict.depVar, daten.under$base[[1]][(max(lags) + 1):length(daten.under$base[[1]])])
  ts.daten.ges <- cbind("Initial data" = ts.dat.reg,"Fitted data via regression" = ts.daten.predict)
  
  regression.store.plot <- dygraph(ts.daten.ges, main = isolate(input$depVar)) %>% dyRangeSelector() %>%
    dyLegend(width = 800) %>% dyOptions(drawPoints = TRUE, pointSize = 2)
  
  
  return(regression.store.plot)

})


# Generierung der Ueberschrift des automatisch generierten Regressionsmodells
output$headerautofitmodel <- renderUI({
  
  isolate({
    if(identical(input$range, NULL)) {return()}
    if(identical(input$range, "")){return()}
    if(input$range <1){return()}
    if(identical(input$columns, NULL)){return()}
  })
     
  input$autoreg
  
  if(regression.modelle$indexcalculateauto == 0){return()}
  
  return(strong(h2("Automatic fitted model", align = "center", style = "blue")))
  
})


# Generierung der Ueberschrift des automatisch generierten Regressionsmodells
output$headermanualfitmodel <- renderUI({
  
  
  isolate(if(is.null(input$columns_manual)){return()})

  isolate(s2 <- nchar(gsub(" ", "", input$lagAll)))
  
  if(length(input$columns_manual) != s2) {return("Choose same amount of lags as quantity of independent variablen")}
  
  if(regression.modelle$indexcalculatemanual == 0){return()}
  
  strong(h2("Manual fitted model", align = "center"))
})


# Ausgabe der Koeffizienten des gespeicherten Regressionsmodells
output$storeCoefficent <- renderTable({
  
  regression.modelle$gespeichertes.modell
  
  if(regression.values$save.reg != 0){
    
    
    return(regression.modelle$regression.coefficent)
    
  }
  
})


# Globale Variable, die die Anzahl der verwendeten Variablen im gespeicherten Regressionsmodell zaehlt
observe({
  
  index2$anzahlregressoren <- nrow(regression.modelle$regression.coefficent)-1
  
})


# Ausgabe der Ueberschrift der Tabelle die die statistischen Guetekriterien des gespeicherten Modells enthaelt.
output$header.qual <- renderUI({
  
  if(regression.values$save.reg != 0){
    
    return(h4("Quality evaluation of stored model"))
    
  }    
  
})

# Ausgabe der Tabelle mit den statistischen Guetekriterien des gespeicherten Modells
output$storeQuality <- renderTable({
  
  regression.modelle$gespeichertes.modell
  
  if(regression.values$save.reg != 0){
    
    return(regression.modelle$regression.quality)
    
  }
})

# Ausgabe Ueberschrift der Lag-Tabelle des gespeicherten Modells
output$header.lag <- renderUI({
  
  if(regression.values$save.reg != 0){
    
    return(h4("Lags of independent variables of stored model"))
    
  }
  
})

# Ausgabe der Lagtabelle des gespeicherten Modells
output$storeLag <- renderTable({
  
  regression.modelle$gespeichertes.modell
  
  if(regression.values$save.reg != 0){
    
    lags <- regression.modelle$gespeichertes.modell[[4]]
    lags.store <- data.frame(lags)
    
    rownames(lags.store) <- attributes(regression.modelle$gespeichertes.modell[[2]])$names
    
    lags.store
    
  }
  
})

# Folgende Funktionen werden zur Zeit nicht genutzt
######### Automatische Reportgenerierung des gespeicherten Modells

# Ausgabe der Eingabefunktionen erst wenn ein Regressions-Modell gespeichert wurde.
output$reportRegression <- renderUI({
  
  input$storeReg
  input$storeRegAuto
  
  validate({
    need(length(regression.modelle$gespeichertes.modell) != 1 , "")
  })
  
  return(list(h3(strong("Download Report")),
              radioButtons('format_Regression', 'Document format', c('PDF', 'HTML', 'Word'), inline = TRUE),
              downloadButton('downloadReport_Regression')))
})

output$downloadReport_Regression <- downloadHandler(
  filename = function() {
    paste('my-report', sep = '.', switch(
      input$format_Regression, PDF = 'pdf', HTML = 'html', Word = 'docx'
    ))
  },
  
  content = function(file) {
    src <- normalizePath('Reports\\report_regression.Rmd')
    
    # temporarily switch to the temp dir, in case you do not have write
    # permission to the current working directory
    # owd <- setwd(tempdir())
    # on.exit(setwd(owd))
    file.copy(src, 'Reports\\report_regression.Rmd')
    
    library(rmarkdown)
    out <- render('Reports\\report_regression.Rmd', switch(
      input$format_Regression,
      PDF = pdf_document(), HTML = html_document(), Word = word_document()
    ))
    file.rename(out, file)
  }
)
