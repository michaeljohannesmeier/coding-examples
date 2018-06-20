index <- reactiveValues(deleted = 1)

# Definiere Liste moeglicher gespeicherter Modelle auf Basis des gespeicherten Regressiosmodells
output$chooseSavedModel <- renderUI({
  
  if(identical(arima.values$tabelle.variablen, 0)){
    selectInput("savedModels", "Choose independent variable",
                choices = "")
  }else{
    selectInput("savedModels", "Choose independent variable",
                choices = as.character(arima.values$tabelle.variablen[ ,1])[which(arima.values$tabelle.variablen[ ,2] != "Outstanding")])
  } 
  
})

# Daneben die Ausgabe der Tabelle der verschiedenen Modelle
output$currentModels <- renderDataTable({
  

  if(identical(arima.values$tabelle.variablen, 0)) return()
  
  arima.values$tabelle.variablen

}, options = list(pagination = FALSE,searching = FALSE,paging = FALSE))

observeEvent(input$showModel,{
  
  if(input$savedModels == ""){return()}
  index$deleted<-0
  
})


# Organisieren der Modell-Ausgabe, wenn eines der moeglichen Modelle ausgewaehlt wird
choosenModel <- eventReactive(input$showModel, {
  
  evaluationTable <- arima.values$tabelle.variablen
  modelKind <- as.character(evaluationTable[which(evaluationTable[ ,1] == input$savedModels) ,2])
  
  if(modelKind == "ARIMA"){
    index <- which(store.graph$saveArima$Variable.Name == input$savedModels)
    return(list(Model = "ARIMA", Graph = store.graph$graphs[[index]][[2]], Quality = store.graph$graphs[[index]][[3]],
                Coefficents = store.graph$graphs[[index]][[4]], Kind = store.graph$graphs[[index]][[5]], Forecast = store.graph$graphs[[index]][[6]],
                Error = store.graph$graphs[[index]][[7]]))
  }else if(modelKind == "Trend Input"){
    index.name <- which(names(trend.values$trends) == input$savedModels)
    return(list(Model = "Trend Input", "Graph" = trend.values$trends[[index.name]]$plots, "Trend" =  trend.values$trends[[index.name]][[1]],
                "Forecast" = trend.values$trends[[index.name]][[2]]))
  }else if(modelKind == "Manual Input"){
    index.name <- which(names(submitted.manual$submitted.data) == input$savedModels)
    return(list(Model = "Manual Input",
                "Graph" = submitted.manual$store.graph.saved[[input$savedModels]], 
                "Data" = submitted.manual$submitted.data[[input$savedModels]]))
  }else{
    return(list(Model = "Outstanding"))
  }
  
  return(modelKind)
})

# Ausgabe zugeh�riger Graph
output$graphForecast <- renderDygraph({
  
  #print(choosenModel()[[2]])
  if(index$deleted == 1){return()}
  
  choosenModel()[[2]]
  
})

# Ausgabe Quality Arima
output$arimaQualityModel <- renderTable({
  
  
  if(index$deleted == 1){return()}
  
  if(choosenModel()[[1]] == "ARIMA"){
    return(choosenModel()[[3]])
  }
  
})

# Ausgabe Arima kind
output$kindModelArima <- renderUI({
  if(index$deleted == 1){return()}
  
  if(choosenModel()[[1]] == "ARIMA"){
    return(choosenModel()[[5]])
  }
  
})

# Ausgabe Arima forecast
output$arimaModelForecast <- renderDataTable({
  if(index$deleted == 1){return()}
  
  if(choosenModel()[[1]] == "ARIMA"){
    return(choosenModel()[[6]])
  }
  
})
# Ausgabe Arima coefficents
output$arimaCoefModel <- renderTable({
  if(index$deleted == 1){return()}
  
  if(choosenModel()[[1]] == "ARIMA"){
    return(choosenModel()[[4]])
  }
  
}) 

# Ausgabe Arima Error
output$arimaError <- renderTable({
  if(index$deleted == 1){return()}
  
  if(choosenModel()[[1]] == "ARIMA"){
    return(choosenModel()[[7]])
  }
  
})

# Ausgabe Trend-Settings
output$trendSettings <- renderDataTable({
  if(index$deleted == 1){return()}
  
  if(choosenModel()[[1]] == "Trend Input"){
    return(choosenModel()[[3]])
  }
  
})

# Ausgabe predicted Time-Steps
output$predTimeSteps <- renderDataTable({
  if(index$deleted == 1){return()}
  
  if(choosenModel()[[1]] == "Trend Input"){
    return(choosenModel()[[4]])
  }
  
})

# Anpassen der Ueberschrift basierend auf der gewaehlten Variable
output$headerTrendsaved <- renderUI({
  
  if(index$deleted == 1){return()}
  name.var  <- isolate(input$savedModels)
  return(h3(strong(paste(name.var, "Trend", sep = " "))))
})


# Ausgabe Optionen fue manuelle Daten
output$manual.header.saved <- renderUI({
  
  if(index$deleted == 1){return()}
  
  name.manual <- isolate(input$savedModels)
  
  h4(name.manual)
  
})

# Ausgabe der bisher getÃ¤tigen Eingaben der gewÃ¤hlten unabhÃ¤ngigen Variable
output$manual.data.saved <- renderDataTable({
  
  if(choosenModel()[[1]] == "Manual Input"){
    return(choosenModel()[[3]])
  }
  
})

output$manual.graph.saved <- renderDygraph({
  
  if(index$deleted == 1){return()}
  
  if(choosenModel()[[1]] == "Manual Input"){
    return(choosenModel()[[2]])
  }
  
})

# Organisiere UI-Output f�r alle moeglichen forecast-Modelle
modelUiOrganizer <- eventReactive(choosenModel(), {
  
  outputList <- choosenModel()
  modelKind <- outputList[[1]]
  
  if(modelKind == "ARIMA"){
    
    return(list(br(),
                dygraphOutput("graphForecast"),
                br(),
                fluidRow(
                  box(
                    uiOutput("kindModelArima"),
                    tableOutput("arimaCoefModel")
                    
                  ),
                  
                  box(
                    h3(strong("Quality criteria of current fitted model")),
                    tableOutput("arimaQualityModel")
                    
                  )
                ),
                fluidRow(
                  box(
                    h3(strong("Error Measures")),
                    tableOutput("arimaError")
                  ),
                  
                  box(
                    h3(strong("Predicted confidence intervals")),
                    dataTableOutput("arimaModelForecast")
                  )
                )))
    
  }else if(modelKind == "Trend Input"){
    
    return(list(uiOutput("headerTrendsaved"),
                dygraphOutput("graphForecast"),
                br(),
                dataTableOutput("trendSettings"),
                br(),
                h3(em("Resulting values")),
                dataTableOutput("predTimeSteps")))
  }else if(modelKind == "Manual Input"){

    return(list(uiOutput("manual.header.saved"),
                br(),
                dygraphOutput("manual.graph.saved"),
                dataTableOutput("manual.data.saved"))
    )
  }
})

# Ausgabe der spezifischen UI
output$modelUI <- renderUI({
  
  if(index$deleted == 1){return()}
  
  modelUiOrganizer()
  
})


output$test1 <- renderText({
  if(index$deleted == 1){return()}
  
  choosenModel()
})

############################ Folgende Funktionen befassen sich mit dem L�schen von Modellen ###################

observeEvent(input$deleteModel, {
  
  index$deleted <-1
  
  if(input$savedModels == ""){return()}
  
  evaluationTable <- arima.values$tabelle.variablen
  modelKind <- as.character(evaluationTable[which(evaluationTable[ ,1] == input$savedModels) ,2])
  
  if(modelKind == "ARIMA"){
    
    name <- input$savedModels
    names.saved <- store.graph$saveArima[[1]]
    index.saved <- which(names.saved == name)
    
    store.graph$saveArima <- store.graph$saveArima[- index.saved, ]
    
    store.graph$graphs <- store.graph$graphs[-index.saved]
    
    daten.under$arima.modells <- daten.under$arima.modells[-index.saved]
    
  }else if(modelKind == "Trend Input"){
    
    name <- input$savedModels
    index.name <- which(names(trend.values$trends) == name)
    
    trend.values$trends[[index.name]] <- data.frame("Trend" = character(), "Percentage" = numeric(), "Lower Percentage" = numeric(), 
                                                    "Upper Percentage" = numeric(), "Time steps" = numeric())
  }else if(modelKind == "Manual Input"){
    
    submitted.manual$submitted.data[[input$savedModels]] <- data.frame("Date" = character(), "Expected Value" = numeric(), "Lower Quantile" = numeric(), "Upper Quantile" = numeric())
    
  }
  
})