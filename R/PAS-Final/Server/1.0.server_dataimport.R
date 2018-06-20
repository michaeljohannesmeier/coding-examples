

# falls Daten nicht eingelsen werden wird hier ein Testdatensatz generiert
daten.start <- data.frame() 

#diese reactiven Values sind f?r die Datumsgenerierung (1. Spalte des Datensatzes) -> bei den weiteren time series Berechnungen wird oft darauf zur?ck-
#gegriffen
start<-reactiveValues(
  
  accepteddataset = FALSE,
  datum = "",
  endedatum = "",
  dates = vector(),
  date.index = FALSE,
  freq = "none",
  freq2 = 0,
  ci.predict.2 = 0,
  freqchange1 = 0,
  freqchange2 = 0,
  date_manual_auto = 0,
  password = FALSE,
  acceptdataset = FALSE,
  wwwQuandl = "www.quandl.com",
  variablenListeQuandl =c("Euribor3M_D99", "Euribor6M_D99", "Euribor12M_D99", "EuriborFuturesSep_D11", "EffectiveFedFundsRate_D54",
                          "12-MLondonLiborBP_D86", "12-MLondonLiborEuro_D99", "12-MLondonLiborYen_D86", "TreasuryYieldCurveRates_D90",
                          "USHighYieldBBCorpBondIndexYield_D96", "USCCC-ratedBondIndexYield_D96", "AAACorpBondYield_D83", "BaaCorpBondYield_D86", "TIPSYieldCurve_D99(more)",
                           "USTreasuryZeroCouponYieldCurve_D61","USTreasuryParYieldCurve_D61", "OvernightAANonFinancialPaperInterestRate_D98","OvernightAAFinancialPaperInterestRate_D98",
                           "DailyGuiltRepoInterestRate2WeekEngland_D96", "USTreasuryInstantaneousForewardRateCurve_D96"),

  typeListQuandl = "Value",
  tickVarQuandl=0,
  quandlUploadedTextDatum = ""
) 


var.modelle<-reactiveValues(
  
  gespeicherte.expl.modelle.var = list(),
  gespeicherte.expl.modelle.restvar = list(),
  gespeicherte.forecasts.var = list(),
  gespeicherte.forecasts.restvar = list()
  
)


#diese reactive Values dienen der Info-Box in der Sidebar
index2<-reactiveValues(
  
  inputfilename = "none",
  indepVar = "",
  depVar = "",
  anzahlregressoren = "not choosen yet",
  range = "",
  VARcompletecases = "",
  VARregressors = "",
  VARleglength = "",
  VARnumberindepvar = "",
  restVARcompletecases = "",
  restVARregressors = "",
  restVARleglength = "",
  restVARnumberindepvar = ""
  
)


# nach Auswahl Accept dataset wird die sidebar ge?ffnet
observeEvent(input$acceptdataset,{
  
  if(start$date.index == FALSE){return(withProgress(message = "Set date first",Sys.sleep(2)))}
  daten.under$base<-daten.under$base[complete.cases(daten.under$base),]
  
  isolate(daten.under$default <- daten.under$base)
  isolate(daten.under$default2 <-daten.under$base)
  isolate(daten.under$data.scale <-  daten.under$base)
  isolate(daten.under$data.hole <-daten.under$base)
  isolate(daten.under$data.train <- 0)
  isolate(daten.under$data.test <- 0)
  isolate(daten.under$data.temp.1 <- daten.under$base[ ,sapply(daten.under$base, is.numeric)])
  isolate(daten.under$keeprows.1 <- rep(TRUE, nrow(daten.under$base[ ,sapply(daten.under$base, is.numeric)])))
  isolate(daten.under$data.temp.2 <- daten.under$base[ ,sapply(daten.under$base, is.numeric)])
  isolate(daten.under$keeprows.2 <- rep(TRUE, nrow(daten.under$base[ ,sapply(daten.under$base, is.numeric)])))
  isolate(daten.under$daten.non.linear.konstant <- daten.under$base[ ,sapply(daten.under$base, is.numeric)])
  isolate(daten.under$daten.non.linear <- daten.under$base[ ,sapply(daten.under$base, is.numeric)])
  
  start$acceptdataset = TRUE

})  

# Data set informations
datasetinfo <- eventReactive(start$date.index, {
  
  if(start$date.index == FALSE){return()}
  if(length(names(daten.under$base)) <= 2){return()}

   
  return(list(strong(paste("Data set informations:")),
         br(),
         br(),
         paste("Filename: ", index2$inputfilename),
         br(),
         paste("Number of variables: ", ncol(daten.under$base)-1),
         br(),
         paste("Number of observations: ", nrow(daten.under$base)),
         br(),
         paste("Start date: ", start$datum),
         br(),
         paste("End date: ", start$endedatum),
         br(),
         paste("Frequency by: ", start$freq),
         br(),
         br(),
         br(),
         br(),
         br(),
         actionButton("acceptdataset", "Accept data set")
    ))
})

# AUsgabe Data set informations
output$datasetinfos<- renderUI({ 
  
  if(is.null(datasetinfo())) return()
  
  datasetinfo()
})



# Dieser reactive Value enthaelt die zugrundeliegenden Daten sobald diese eingelesen wurden,
# die als Grundlage fuer alle Berechnungen dienen.
# Sind als sog. globale Variablen zu verstehen.
daten.under <- reactiveValues(
  
 
  
  # Die Variable "base" beinhaltet die zugundeliegenden Daten fuer alle Berechnungen.
  base = daten.start,
  # Die Variable "default" beinhaltet die eingelesenen Daten in ihrer Rohform direkt
  # nach dem Einlesen.
  default = daten.start,
  default2 = 0,
  # Die Variable "data.scale" beinhaltet die gescalten Daten im Tab "Data preparation" und ist
  # der Anhaltspunkt fuer den Daten Scale und Rescale -> Koennte vielleicht in der Hinsicht optimiert werden,
  # dass alles nur auf Basis von "base" laeuft.
  data.scale = daten.start,
  
  # diese reactive Values sind f?r den Datensplit (unter data.hole sind die Gesamtdaten, under data.train der 
  # Trainingsdatensatzu und unter data.test der Test der Test-Datensatz)
  data.hole = daten.start,
  data.train = 0,
  data.test = 0,
  
  # Die Variable "scale.values" beinhaltet den Mittelwert und die Standardabweichung der bisher skalierten
  # Variablen.
  scale.values = list(),
  
  # Die Variable "data.temp.1" stellt die Datengrundlage fuer den 1. Scatter-Plot im Tab "Data Analysis"
  # und spielt mit der Variable "keeprows.1" zusammen, um die Interaktivitaet des Graphen zu gewaehrleisten.
  data.temp.1 = daten.start,
  keeprows.1 = rep(TRUE, nrow(daten.start)),
  
  # Siehe oben -> Nur fuer 2. Scatter-Plot
  data.temp.2 = daten.start,
  keeprows.2 = rep(TRUE, nrow(daten.start)),
  
  # Die folgenden Variablen werden fuer den Tab "Data Visualization" -> "Timeseries comparison"
  # benoetigt. Und dienen als temporaerer Speicher fuer die nichtlinearen Modifikationen der
  # der entsprechenden Variablen.
  # ToDO -> Uebernehmen sinnvoller nichtlinearer Modifikationen in "base", um diese als Grundlage
  # fuer die Regression zur Verfuegung zu stellen.
  daten.non.linear.konstant = daten.start,
  daten.non.linear= daten.start,
  
  # Diese Liste haelt die berechneten ARIMA-Modell auf die beim Forecast der abhaengigen Variable
  # Zurueckgegriffen wird.
  arima.modells = list()
)


# Sobald ein File eingelesen wird, wird in dieser Funktion die daten$base Variable
# entsprechend angepasst. Dieser Upload befindet sich im Kartenreiter Local im Tab Data import

observeEvent(input$showdataset, {
  
  
  # Ver?nderung der reactive Values zur Steuerung der Sidebar
  start$accepteddataset <-FALSE
  isolate(start$date.index <- TRUE)
  isolate(start$method1 <- FALSE)
  isolate(start$method2 <- FALSE)
  
  withProgress(message = "In progress",value=0.1,{
    
    inFile <- input$file1
    index2$inputfilename<-inFile$name
    
    if (is.null(inFile))
      return(NULL)
    
    file.data <-  tryCatch({
      as.data.frame(read.csv(inFile$datapath, header = input$header,sep = input$sep,
                      quote = input$quote, dec = input$decimalsep, stringsAsFactors = FALSE))
    }, error = function(e) {
      as.tbl(data.frame(Test.x = c(-1:1), Test.y = c(-1:1)^2))
    })
    
    file.data$Time<-as.Date(file.data$Time, format="%Y-%m-%d")
    
    
    incProgress(0.2)
    
    isolate(daten.under$base <- file.data)
    isolate(daten.under$default <- file.data)
    isolate(daten.under$default2 <-file.data)
    isolate(daten.under$data.scale <-  file.data)
    isolate(daten.under$data.hole <-file.data)
    isolate(daten.under$data.train <- 0)
    isolate(daten.under$data.test <- 0)
    
    
    incProgress(0.2)
    
    isolate(daten.under$data.temp.1 <- file.data[ ,sapply(file.data, is.numeric)])
    isolate(daten.under$keeprows.1 <- rep(TRUE, nrow(file.data[ ,sapply(file.data, is.numeric)])))
    
    incProgress(0.2)
    
    isolate(daten.under$data.temp.2 <- file.data[ ,sapply(file.data, is.numeric)])
    isolate(daten.under$keeprows.2 <- rep(TRUE, nrow(file.data[ ,sapply(file.data, is.numeric)])))
    
    incProgress(0.2)
    
    isolate(daten.under$daten.non.linear.konstant <- file.data[ ,sapply(file.data, is.numeric)])
    isolate(daten.under$daten.non.linear <- file.data[ ,sapply(file.data, is.numeric)])
    
    setProgress(1)
  })
  
})

# Einlesen des auf der Cloud gespeicherten Datensatzes Stahlpreis.csv. Dieser Event startet nach dem dr?cken des Upload Stahlpreis Showcase Buttons
# im Tab Data import im Kartenreiter PwC Datalake

observeEvent(input$stahlpreiscsv , {
  
  
  withProgress(message = "In progress",value=0.1,{
    
    # reactive Values f?r die Steuerung der Sidebar  
    start$accepteddataset <-FALSE
    isolate(start$date.index <- FALSE)
    isolate(start$method1 <- FALSE)
    isolate(start$method2 <- FALSE)
    
    index2$inputfilename<-"Stahlpreis_Showcase_Daten.csv"
  
    datapath <- as.character("http://hlx00008sta.blob.core.windows.net/test/Stahlpreis_Showcase_Daten.csv")
    
    file.data <- as.tbl(read.csv(datapath, header = TRUE, sep = ";", dec =",", stringsAsFactors = FALSE))
    
    incProgress(0.2)
    
    isolate(daten.under$base <- file.data)
    isolate(daten.under$default <- file.data)
    isolate(daten.under$default2 <-file.data)
    isolate(daten.under$data.scale <-  file.data)
    isolate(daten.under$data.hole <-file.data)
    isolate(daten.under$data.train <- 0)
    isolate(daten.under$data.test <- 0)
    
    incProgress(0.2)
    
    isolate(daten.under$data.temp.1 <- file.data[ ,sapply(file.data, is.numeric)])
    isolate(daten.under$keeprows.1 <- rep(TRUE, nrow(file.data[ ,sapply(file.data, is.numeric)])))
    
    incProgress(0.2)
    
    isolate(daten.under$data.temp.2 <- file.data[ ,sapply(file.data, is.numeric)])
    isolate(daten.under$keeprows.2 <- rep(TRUE, nrow(file.data[ ,sapply(file.data, is.numeric)])))
    
    incProgress(0.2)
    
    isolate(daten.under$daten.non.linear.konstant <- file.data[ ,sapply(file.data, is.numeric)])
    isolate(daten.under$daten.non.linear <- file.data[ ,sapply(file.data, is.numeric)])
    
    setProgress(1)
  })
  
})


#ActionButton Set Date -> das Datum in der ersten Spalte wird gesetzt (Anzeige der weiteren Sidebar erst nach Eingabe des Datums m?glich)
#zudem wird ?berpr?ft, ob schon ein Datensplit stattgefunden hat, falls ja, wird das Datum ge?ndert und der Split beibehalten 
observeEvent(input$setdatestartformat,{
  
  if(is.null(index2$inputfilename)){return()}
  else if(nrow(daten.under$base) == 0) {
    withProgress(message = "Uploade data first!",value=0.1, {
      setProgress(1) 
      Sys.sleep(1.5)
    })
    return()
  }
  
  # Testen ob das eingegebene Format valide ist
  test_date <- as.Date(daten.under$base[[1]][1], input$dateFormat)
  
  if(is.na(test_date)){
    withProgress(message = "Date format not applicable!",value=0.1, {
      setProgress(1) 
      Sys.sleep(1.5)
    })
    return()
  }
  
  # Determinieren der Art der zugrundliegenden Zeitserie
  if(input$FREQ.start.manual == "yearly"){start$freq<-"year"}
  else if(input$FREQ.start.manual == "monthly"){start$freq<-"month"}
  else if(input$FREQ.start.manual == "quarterly"){start$freq<-"quarter"}
  else if(input$FREQ.start.manual == "weekly"){start$freq<-"week"}
  else if(input$FREQ.start.manual == "daily"){start$freq<-"day"}
  
  # Setzen des Startdatums
  start$datum <- test_date
  
  # Setzen der Dates fuer den zugrundeliegenden Datensatz
  start$dates <- as.Date(daten.under$base[[1]], input$dateFormat)
  
  start$date.index <- TRUE
  start$date_manual_auto <- "manual"
  
  daten.under$base[[1]] <- start$dates
  colnames(daten.under$base)[1]<-"Time"
  
  start$endedatum<- tail(daten.under$base, n = 1)[[1,1]]
}) 

#ActionButton Set Date -> das Datum in der ersten Spalte wird gesetzt (Anzeige der weiteren Sidebar erst nach Eingabe des Datums m?glich)
#zudem wird ?berpr?ft, ob schon ein Datensplit stattgefunden hat, falls ja, wird das Datum ge?ndert und der Split beibehalten 
observeEvent(input$setdatestart,{
  
  if(is.null(index2$inputfilename)){return()}
  else if(nrow(daten.under$base) == 0) {
    withProgress(message = "Uploade data first!",value=0.1, {
      setProgress(1) 
      Sys.sleep(1.5)
    })
    return()
  }
  
  start$date.index <- TRUE
  start$datum <- input$reg.date.start
  
  # Determinieren der Art der zugrundliegenden Zeitserie
  if(input$FREQ.start == "yearly"){start$freq<-"year"}
  else if(input$FREQ.start == "monthly"){start$freq<-"month"}
  else if(input$FREQ.start == "quarterly"){start$freq<-"quarter"}
  else if(input$FREQ.start == "weekly"){start$freq<-"week"}
  else if(input$FREQ.start == "daily"){start$freq<-"day"}
  
  if(start$freq == "year"){start$freq2<-1}
  else if(start$freq == "month"){start$freq2<-12}
  else if(start$freq == "quarter"){start$freq2<-4}
  else if(start$freq == "week"){start$freq2<-51}
  else if(start$freq == "day"){start$freq2 <- 365}
  
  count <- dim(daten.under$base)[1]
  
  xts.datum <- start$datum
  
  # Setzen der Dates fuer den zugrundeliegenden Datensatz
  start$dates <- seq(xts.datum, by=  start$freq, length.out = count)
  
  start$date.index <- TRUE
  start$date_manual_auto <- "auto"
  
  if(start$freq2 == 4 && month(xts.datum)<= 3){
    withProgress(message = "Start date is january!",value=0.1, {
      setProgress(1) 
      Sys.sleep(1.5)
    })
  }
  else if(start$freq2 == 4 && month(xts.datum)<= 6){
    withProgress(message = "Start date is april!",value=0.1, {
      setProgress(1) 
      Sys.sleep(1.5)
    })
  }
  else if(start$freq2 == 4 && month(xts.datum)<= 9){
    withProgress(message = "Start dat is june!",value=0.1, {
      setProgress(1) 
      Sys.sleep(1.5)
    })
  }
  else if(start$freq2 == 4 && month(xts.datum)<= 12){
    withProgress(message = "Start date is october!",value=0.1, {
      setProgress(1) 
      Sys.sleep(1.5)
    })
  }
  
  withProgress(message = "Date set",value=0.1, {
    setProgress(1) 
    Sys.sleep(1.5)
  })
  
  daten.under$base[[1]] <- start$dates
  colnames(daten.under$base)[1]<-"Date"
  
  start$endedatum<- tail(daten.under$base, n = 1)[[1,1]]
}) 


#ActionButtons Choose Analysis method
choosemethod<-renderUI({
  actionButton("method1", "Analysis method 1")
  actionButton("method2", "Analysis method 2 (VAR)")
})

# Ausgabe der eingelesenen Daten
output$contentshome <- renderDataTable({

  withProgress(message = "Reading data, please wait",value=0.1,{
    
    validate(
      need(!identical(daten.under$base, daten.start), "Choose file to upload")
    )
    
    
    incProgress(0.2)
    
    
    validate(
      need(!identical(daten.under$base, data.frame(Test.x = c(-1:1), Test.y = c(-1:1)^2)), "Check Seperator, Header and Quote settings")
    )
    
    incProgress(0.5)
    
    daten.under$base
    
  })
  
}, options = list(pageLength = 10, scrollX = TRUE))

# Ausgabe der Struktur der eingelesenen Daten
output$structurehome <- renderPrint({
  
  validate(
    need(!identical(daten.under$base, daten.start), "Choose file to upload")
  )
  
  validate(
    need(!identical(daten.under$base, data.frame(Test.x = c(-1:1), Test.y = c(-1:1)^2)), "Check Seperator, Header and Quote settings")
  )
  
  str(daten.under$default)
})

#######Daten einlesen über Quandl


output$variableFromQuandl <- renderUI({
  
  colnames <- start$variablenListeQuandl

  selectInput("varInputQuandl", "Choose data",
              choices = colnames, selected = "")
})

reactive(start$wwwQuandl <- input$varInputQuandl)

output$typeVariableQuandl <- renderUI({
  
  colnames <- start$typeListQuandl
  
  selectInput("typeInputQuandl", "Choose type of data",
              choices = colnames, selected = "")
})

observeEvent(input$varInputQuandl,{
  
#   variablenListeQuandl =c("Euribor3M_D99", "Euribor6M_D99", "Euribor12M_D99", "EuriborFuturesSep_D11", "EffectiveFedFundsRate_D54",
#                           "12-MLondonLiborBP_D86", "12-MLondonLiborEuro_D86", "12-MLondonLiborEuro_D99", "12-MLondonLiborYen_D86"", "TreasuryYieldCurveRates_D90",
#                           "USHighYieldBBCorpBondIndexYield_D96", "USCCC-ratedBondIndexYield_D96", "AAACorpBondYield_D83", "BaaCorpBondYield_D86", "TIPSYieldCurve_D99(more)",
#                            "USTreasuryZeroCouponYieldCurve_D61","USTreasuryParYieldCurve_D61", "OvernightAANonFinancialPaperInterestRate_D98","OvernightAAFinancialPaperInterestRate_D98",
#                            "DailyGuiltRepoInterestRate2WeekEngland_D96", "USTreasuryInstantaneousForewardRateCurve_D96")
  
  isolate({
    if(input$varInputQuandl == "Euribor3M_D99"){
      start$typeListQuandl <- c("Value")
      start$wwwQuandl <- "https://www.quandl.com/data/BOE/IUDERB3-Daily-3-month-EURIBOR"
      start$tickVarQuandl <- "BOE/IUDERB3"
    }
    if(input$varInputQuandl == "Euribor6M_D99"){
      start$typeListQuandl <- c("Value")
      start$wwwQuandl <- "https://www.quandl.com/data/BOF/QS_D_IEUTIO6M-EURIBOR-6-Months-Daily"
      start$tickVarQuandl <- "BOF/QS_D_IEUTIO6M"
    }
    if(input$varInputQuandl == "Euribor12M_D99"){
      start$typeListQuandl <- c("Value")
      start$wwwQuandl <- "https://www.quandl.com/data/BOF/QS_D_IEUTIO1A-EURIBOR-12-Months-Daily"
      start$tickVarQuandl <- "BOF/QS_D_IEUTIO1A"
    }
    if(input$varInputQuandl == "EuriborFuturesSep_D11"){
      start$typeListQuandl <- c("Open", "High", "Low", "Settle", "Volume", "Prev.DayOpenInterest")
      start$wwwQuandl <- "https://www.quandl.com/data/LIFFE/IZ2004-EURIBOR-Futures-December-2004-IZ2004"
      start$tickVarQuandl <- "LIFFE/IU2017"
    }
    if(input$varInputQuandl == "EffectiveFedFundsRate_D54"){
      start$typeListQuandl <- c("Value")
      start$wwwQuandl <- "https://www.quandl.com/data/FRED/DFF-Effective-Federal-Funds-Rate"
      start$tickVarQuandl <- "FRED/DFF"
    }
    if(input$varInputQuandl == "12-MLondonLiborBP_D86"){
      start$typeListQuandl <- c("Value")
      start$wwwQuandl <- "https://www.quandl.com/data/FRED/GBP12MD156N-12-Month-London-Interbank-Offered-Rate-LIBOR-based-on-British-Pound"
      start$tickVarQuandl <- "FRED/GBP12MD156N"
    }
    if(input$varInputQuandl == "12-MLondonLiborEuro_D99"){
      start$typeListQuandl <- c("Value")
      start$wwwQuandl <- "https://www.quandl.com/data/FRED/EUR12MD156N-12-Month-London-Interbank-Offered-Rate-LIBOR-based-on-Euro"
      start$tickVarQuandl <- "FRED/EUR12MD156N"
    }
    if(input$varInputQuandl == "12-MLondonLiborYen_D86"){
      start$typeListQuandl <- c("Value")
      start$wwwQuandl <- "https://www.quandl.com/data/FRED/JPY12MD156N-12-Month-London-Interbank-Offered-Rate-LIBOR-based-on-Japanese-Yen"
      start$tickVarQuandl <- "FRED/JPY12MD156N"
    }
    if(input$varInputQuandl == "TreasuryYieldCurveRates_D90"){
      start$typeListQuandl <- c("1MO","3MO", "6MO", "1YR", "2YR", "3YR", "5YR", "7YR", "10YR", "20YR", "30YR")
      start$wwwQuandl <- "https://www.quandl.com/data/USTREASURY/YIELD-Treasury-Yield-Curve-Rates"
      start$tickVarQuandl <- "USTREASURY/YIELD"
    }
    if(input$varInputQuandl == "USHighYieldBBCorpBondIndexYield_D96"){
      start$typeListQuandl <- c("Value")
      start$wwwQuandl <- "https://www.quandl.com/data/ML/BBY-US-High-Yield-BB-Corporate-Bond-Index-Yield"
      start$tickVarQuandl <- "ML/BBY"
    }
    if(input$varInputQuandl == "USCCC-ratedBondIndexYield_D96"){
      start$typeListQuandl <- c("Value")
      start$wwwQuandl <- "https://www.quandl.com/data/ML/CCCY-US-CCC-rated-Bond-Index-Yield"
      start$tickVarQuandl <- "ML/CCCY"
    }
    if(input$varInputQuandl == "AAACorpBondYield_D83"){
      start$typeListQuandl <- c("Value")
      start$wwwQuandl <- "https://www.quandl.com/data/MOODY/DAAAYLD-Aaa-Corporate-Bond-Yield"
      start$tickVarQuandl <- "MOODY/DAAAYLD"
    }
    if(input$varInputQuandl == "BaaCorpBondYield_D86"){
      start$typeListQuandl <- c("Value")
      start$wwwQuandl <- "https://www.quandl.com/data/MOODY/DBAAYLD-Baa-Corporate-Bond-Yield"
      start$tickVarQuandl <- "MOODY/DBAAYLD"
    }
    if(input$varInputQuandl == "TIPSYieldCurve_D99(more)"){
      start$typeListQuandl <- c("TIPSY02", "TIPSY03","TIPSY04","TIPSY05","TIPSY06","TIPSY07","TIPSY08","TIPSY09",
                                "TIPSY10","TIPSY11","TIPSY12","TIPSY13","TIPSY14","TIPSY15","TIPSY16","TIPSY17",
                                "TIPSY18","TIPSY19","TIPSY20",
                                "TIPSPY02", "TIPSPY03","TIPSPY04","TIPSPY05","TIPSPY06","TIPSPY07","TIPSPY08","TIPSPY09",
                                "TIPSPY10","TIPSPY11","TIPSPY12","TIPSPY13","TIPSPY14","TIPSPY15","TIPSPY16","TIPSPY17",
                                "TIPSPY18","TIPSPY19","TIPSPY20",
                                "TIPSF02", "TIPSF03","TIPSF04","TIPSF05","TIPSF06","TIPSF07","TIPSF08","TIPSF09",
                                "TIPSF10","TIPSF11","TIPSF12","TIPSF13","TIPSF14","TIPSF15","TIPSF16","TIPSF17",
                                "TIPSF18","TIPSF19","TIPSF20")
      start$wwwQuandl <- "https://www.quandl.com/data/FED/TIPSY-TIPS-Yield-Curve-and-Inflation-Compensation"
      start$tickVarQuandl <- "FED/TIPSY"
    }
    if(input$varInputQuandl == "USTreasuryZeroCouponYieldCurve_D61"){
      start$typeListQuandl <- c("SVENY01", "SVENY02", "SVENY03","SVEN04","SVEN05","SVENY06","SVENY07","SVENY08","SVENY09",
                                "SVENY10","SVENY11","SVENY12","SVENY13","SVENY14","SVENY15","SVENY16","SVENY17",
                                "SVENY18","SVENY19","SVENY20","SVENY21","SVENY22","SVENY23","SVENY24","SVENY25",
                                "SVENY26","SVENY27","SVENY28","SVENY29","SVENY30")
      start$wwwQuandl <- "https://www.quandl.com/data/FED/SVENY-US-Treasury-Zero-Coupon-Yield-Curve"
      start$tickVarQuandl <- "FED/SVENY"
    }
    if(input$varInputQuandl == "USTreasuryParYieldCurve_D61"){
      start$typeListQuandl <- c("SVENPY01", "SVENPY02", "SVENPY03","SVEN04","SVEN05","SVENPY06","SVENPY07","SVENPY08","SVENPY09",
                                "SVENPY10","SVENPY11","SVENPY12","SVENPY13","SVENPY14","SVENPY15","SVENPY16","SVENPY17",
                                "SVENPY18","SVENPY19","SVENPY20","SVENPY21","SVENPY22","SVENPY23","SVENPY24","SVENPY25",
                                "SVENPY26","SVENPY27","SVENPY28","SVENPY29","SVENPY30")
      start$wwwQuandl <- "https://www.quandl.com/data/FED/SVENPY-US-Treasury-Par-Yield-Curve"
      start$tickVarQuandl <- "FED/SVENPY"
    }
    if(input$varInputQuandl == "OvernightAANonFinancialPaperInterestRate_D98"){
      start$typeListQuandl <- c("Value")
      start$wwwQuandl <- "https://www.quandl.com/data/FRED/RIFSPPFAAD01NB-Overnight-AA-Financial-Commercial-Paper-Interest-Rate"
      start$tickVarQuandl <- "FRED/RIFSPPNAAD01NB"
    }
    if(input$varInputQuandl == "OvernightAAFinancialPaperInterestRate_D98"){
      start$typeListQuandl <- c("Value")
      start$wwwQuandl <- "https://www.quandl.com/data/FRED/RIFSPPFAAD01NB-Overnight-AA-Financial-Commercial-Paper-Interest-Rate"
      start$tickVarQuandl <- "FRED/RIFSPPFAAD01NB"
    }
    if(input$varInputQuandl == "DailyGuiltRepoInterestRate2WeekEngland_D96"){
      start$typeListQuandl <- c("Value")
      start$wwwQuandl <- "https://www.quandl.com/data/BOE/IUDGR2W-Daily-Gilt-repo-interest-rate-2-week"
      start$tickVarQuandl <- "BOE/IUDGR2W"
    }
    if(input$varInputQuandl == "USTreasuryInstantaneousForewardRateCurve_D96"){
      start$typeListQuandl <- c("SVENF01", "SVENF02", "SVENF03","SVEN04","SVEN05","SVENF06","SVENF07","SVENF08","SVENF09",
                                "SVENF10","SVENF11","SVENF12","SVENF13","SVENF14","SVENF15","SVENF16","SVENF17",
                                "SVENF18","SVENF19","SVENF20","SVENF21","SVENF22","SVENF23","SVENF24","SVENF25",
                                "SVENF26","SVENF27","SVENF28","SVENF29","SVENF30")
      start$wwwQuandl <- "https://www.quandl.com/data/FED/SVENF-US-Treasury-Instantaneous-Forward-Rate-Curve"
      start$tickVarQuandl <- "FED/SVENF"
    }
    
    
    
  })
})

output$wwwQuandl<- renderUI({
  tags$a(href = start$wwwQuandl, target="_blank",
         "Click for details\nof selected data")
})


output$uploadQuandlInfo <- renderUI({
  
  helpText(start$quandlUploadedTextDatum)
  
})

observeEvent(input$getQuandlData,{
  
  withProgress(message = "Fetching data from quandl, please wait",value=0.1,{
      
      if(input$quandlSelectPreTick == "pre"){
        typeVarQuandl<-input$typeInputQuandl
        nameVarQuandl<-input$varInputQuandl
      }
      if(input$quandlSelectPreTick == "tick"){
        typeVarQuandl<-input$quandlTypeEingabe
        nameVarQuandl<-input$quandlNameEingabe
        
        nameVarQuandl<- gsub(" ", "", nameVarQuandl, fixed = TRUE)
        if(grepl("^[0-9]", nameVarQuandl) == TRUE){
          nameVarQuandl<-paste("x",nameVarQuandl, sep = "")
        }
        start$tickVarQuandl<- input$quandlTickEingabe
      }
      
      
      
      varQuandl<-Quandl(start$tickVarQuandl, start_date = input$quandlStartDate, end_date = input$quandlEndDate, type = "xts")
      names(varQuandl)<- gsub(" ", "", names(varQuandl), fixed = TRUE)
      if(length(names(varQuandl))==0){names(varQuandl) <- typeVarQuandl}
      if(grepl("^[0-9]", typeVarQuandl[1]) == TRUE){
        names(varQuandl)<- paste("x",names(varQuandl), sep = "")
        typeVarQuandl<-paste("x", typeVarQuandl, sep = "")
      }
      varQuandl<-eval(parse(text = paste("varQuandl$",typeVarQuandl, sep = "")))
      names(varQuandl)<-paste(nameVarQuandl,typeVarQuandl, sep = "_")
      
      start$quandlUploadedTextDatum = "Upload successful"
      if(head(time(varQuandl),1) != input$quandlStartDate | tail(time(varQuandl),1) != input$quandlEndDate){
        start$quandlUploadedTextDatum = "Upload successful, but start or end date not matching with choosen dates"
      }
      
          
      if(length(daten.under$base) == 0){
        daten.under$base<-varQuandl
      } else {
        names<-names(daten.under$base)[-1]
        daten.under$base<-xts(daten.under$base[,2:ncol(daten.under$base)], daten.under$base[,1])
        names(daten.under$base)<-names
        daten.under$base<-merge.xts(daten.under$base, varQuandl, join = "outer")
      }
      
      head(daten.under$base)
      daten.under$base<-data.frame(time(daten.under$base), coredata(daten.under$base))
      names(daten.under$base)[1]<-"Time"
      
      start$date.index <- FALSE
      start$date.index <- TRUE
      
      index2$inputfilename <- "Fetched from Quandl"
      start$datum <- head(daten.under$base$Time,1)
      start$endedatum <- tail(daten.under$base$Time, 1)
  })

})

observeEvent(input$exportQuandlCSV,{
  withProgress(message = "File exported",value=0.1,{
    write.csv(daten.under$base, paste('data-', Sys.Date(), '.csv', sep=''), row.names = FALSE)
  Sys.sleep(1)
  })
})

output$switchQuandlSelection <- renderUI({
  
  if(input$quandlSelectPreTick == "pre"){
    return(list(
        uiOutput("variableFromQuandl"),
        uiOutput("wwwQuandl")
        )
    )
  }
  if(input$quandlSelectPreTick == "tick"){
      return(list(
        fluidRow(
          column(
            width = 4,
            textInput("quandlTickEingabe", "Quandl Tick")
          ),
          column(
            width = 4,
            textInput("quandlTypeEingabe", "Name of entitiy")
          ),
          column(
            width = 4,
            textInput("quandlNameEingabe", "Variable name")
          )
        ),
        tags$a(href = "http://www.quandl.com", target="_blank",
               "www.quandl.com")
        
      ))
  }

})

output$dependent_variable_eins <- renderUI({
  
  if(length(daten.under$base) == 0){return()}
  if(length(names(daten.under$base)) <=2){return()}
  
  data <- daten.under$base[ ,sapply(daten.under$base, is.numeric)]
  
  if(length(data) == 0) return(h3("Formatierung der Daten ueberpruefen"))
  colnames <- names(data)
  
  selectInput("depVar", "Choose dependent variable",
              choices = colnames, selected = "")
  
})



######################################################################################################################
#############################################Ab hier beginnt der UI Teil########################################################
######################################################################################################################


# hier sieht man quasi eine UI - der UI - Output wird ?ber diesen renderUI ausgegeben, um ihn nach klicken auf Methode1 oder Methode2 verschwinden zu lassen
# in der zugeh?rigen UI findet sich dann der uiOutput("uploadDataimport")
output$uploadDataimport<-renderUI({
  
  if(start$acceptdataset == TRUE){return()}
    
  list(  
    box(
      
      title = "Upload data",
      width= 15, 
      collapsible = TRUE,
      status = "warning", 
      solidHeader = TRUE,
          tabBox(
            tabPanel("Quandl", 
                     radioButtons("quandlSelectPreTick", "Fething over:", c("Preselection" = "pre",
                                                                            "Quandl Tick" = "tick"),
                                  inline = TRUE),
                     uiOutput("switchQuandlSelection"),
                     br(),
                     br(),
                     fluidRow(
                       column(
                         width = 4,
                           dateInput("quandlStartDate",
                                     label = "Start date",
                                     value = Sys.Date()-365, width = 300)
                       ),
                       column(
                         width = 4,
                           dateInput("quandlEndDate",
                                     label = "End date",
                                     value = Sys.Date(), width = 300)
                       ),
                       column(
                         width = 4,
                           uiOutput("typeVariableQuandl")
                       )
                     ),
                     br(),
                     actionButton("getQuandlData", "Get/append data from Quandl"),
                     actionButton("exportQuandlCSV", "Export to CSV"),
                     br(),
                     br(),
                     uiOutput("uploadQuandlInfo")
                     
            ),
            tabPanel("PwC Datalake", 
                       br(), 
                       p("Description: Carbon steel prices (1992-2014)"),
                       actionButton("stahlpreiscsv", "Upload Stahlpreis Showcase"),
                       br(),
                       hr(),
                       p("Description: Oil prices (1995-2009) (noch ohne Funktion)"),
                       actionButton("datalakedaten2", "Upload Oil prices")
                 
             ),
             tabPanel("Local",
                       column(
                         width = 4,
                         fileInput('file1', h4(strong('Choose file to upload')),
                                   accept = c(
                                     'text/csv',
                                     'text/comma-separated-values',
                                     'text/tab-separated-values',
                                     'text/plain',
                                     '.csv',
                                     '.tsv'
                                   )
                         ),
                         
                         br(),
                         br(),
                         br(),
                         br(),
                         actionButton("showdataset", "Upload data")
                         
                       ),
                       
                       column(
                         width = 4,
                         
                         radioButtons('quote', h4(strong('Choose quote')),
                                      c(None='',
                                        'Double quote'='"',
                                        'Single quote'="'"),
                                      '"'),
                         h4(strong("Choose header")),
                         checkboxInput('header', 'Header', TRUE)  
                         
                       ),
                       column(
                         width = 4, 
                         radioButtons('sep', h4(strong('Choose separator')),
                                      c(Comma=',',
                                        Semicolon=';',
                                        Tab='\t'),
                                      ';'),
                         radioButtons('decimalsep', h4(strong('Choose decimal seperator')),
                                      c(Comma=',',
                                        Dot='.'))
                       )
              )
          ),
      
        tabBox(
          width= 3, 
          height = 300,
          tabPanel("Date automatically",
        
            div(id="monthregstart", dateInput("reg.date.start",
                                              label = h4(strong("Start date")),
                                              value = Sys.Date(), width = 300)),
            
             div(id="freqregstart",selectInput("FREQ.start", label = "Select frequency", 
                                                choices = c("daily","weekly","monthly","quarterly", "yearly"), 
                                                selected = "monthly", width = 300)),
          
            br(),
            actionButton("setdatestart", "Set date automatic")
          ),
          tabPanel("Date manual",
                  textInput("dateFormat", h4(strong("Determine date format")), value = ""),
                  div(id="freqregstart_manual",selectInput("FREQ.start.manual", label = "Select frequency", 
                                                    choices = c("daily","weekly","monthly","quarterly", "yearly"), 
                                                    selected = "monthly", width = 300)),
                  br(),
                  br(),
                  actionButton("setdatestartformat", "Set date manual")
                  
          )
        ),
      box(
        width = 3,
        height = 300,
        br(),
        uiOutput("dependent_variable_eins"),
        uiOutput("datasetinfos")

      )
      
    ),
    
    box(
      title = "Show data", 
      collapsible = TRUE,
      collapsed = FALSE,
      width = 15, 
      status = "warning", 
      solidHeader = TRUE,
      tabsetPanel(
        tabPanel("Data", dataTableOutput('contentshome')),
        tabPanel("Structure",  verbatimTextOutput("structurehome"))
      )
      
    )
  )
  
})