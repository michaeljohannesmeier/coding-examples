# Globale Variablen fuer den Tab "View and delete forecast procedures"
viewDelete.global <- reactiveValues(
  deleted = 1
)

# Definiere Liste moeglicher gespeicherter Modelle auf Basis des gespeicherten Regressiosmodells
output$chooseSavedModelInd <- renderUI({
  
  if(is.null(objects$usedForecastsInd)){
    selectInput("savedModelsInd", "Choose independent variable",
                choices = "")
  }else{
    selectInput("savedModelsInd", "Choose independent variable",
                choices = as.character(objects$usedForecastsInd[ ,1])[which(objects$usedForecastsInd[ ,2] != "Outstanding")])
  } 
  
})

# Setzen der globalen Anzeige Variable
observeEvent(input$showModelInd,{
  
  if(input$savedModelsInd == ""){return()}
  
  viewDelete.global$deleted <- 0
  
})

# Daneben die Ausgabe der Tabelle der verschiedenen Modelle
output$currentModelsInd <- renderDataTable({
  
  if(is.null(objects$usedForecastsInd)) return()
  
  objects$usedForecastsInd
  
}, options = list(pagination = FALSE, pageLength = 5, searching = FALSE,paging = FALSE))

# Organisieren der Modell-Ausgabe, wenn eines der moeglichen Modelle ausgewaehlt wird
choosenModelInd <- eventReactive(input$showModelInd, {
  
  evaluationTable <- objects$usedForecastsInd
  modelKind <- as.character(evaluationTable[which(evaluationTable[ ,1] == input$savedModelsInd) ,2])
  
  if(modelKind == "ARIMA"){
    index <- which(objects$lmArimaSave$Variable.Name == input$savedModelsInd)
    return(list(Model = "ARIMA", Graph = objects$lmArimaGraphs[[index]][[2]], Quality = objects$lmArimaGraphs[[index]][[3]],
                Coefficients = objects$lmArimaGraphs[[index]][[4]], Kind = objects$lmArimaGraphs[[index]][[5]], Forecast = objects$lmArimaGraphs[[index]][[6]],
                Error = objects$lmArimaGraphs[[index]][[7]]))
  }else if(modelKind == "Exponential Smoothing"){
    index <- which(objects$lmexpsmave$Variable.Name == input$savedModelsInd)
    return(list(Model = "Exponential Smoothing", Graph = objects$lmexpsmGraphs[[index]][[2]], Quality = objects$lmexpsmGraphs[[index]][[3]],
                Coefficients = objects$lmexpsmGraphs[[index]][[4]], Kind = objects$lmexpsmGraphs[[index]][[5]], Forecast = objects$lmexpsmGraphs[[index]][[6]],
                Error = objects$lmexpsmGraphs[[index]][[7]]))
  }else if(modelKind == "Trend Input"){
    index.name <- which(names(objects$lmTrendInput) == input$savedModelsInd)
    return(list(Model = "Trend Input", "Graph" = objects$lmTrendInput[[index.name]]$plots, "Trend" =  objects$lmTrendInput[[index.name]][[1]],
                "Forecast" = objects$lmTrendInput[[index.name]][[2]]))
  }else if(modelKind == "Manual Input"){
    index.name <- which(names(objects$lmManualInput) == input$savedModelsInd)
    return(list(Model = "Manual Input",
                #"Graph" = submitted.manual$store.graph.saved[[input$savedModelsInd]], 
                "Data" = objects$lmManualInput[[input$savedModelsInd]]))
  }else{
    return(list(Model = "Outstanding"))
  }
  
  return(modelKind)
})

# Ausgabe zugehoeriger Graph
output$graphForecastInd <- renderDygraph({

  if(viewDelete.global$deleted == 1){return()}

  choosenModelInd()[[2]]
  
})

# Ausgabe Quality Arima
output$arimaQualityModelInd <- renderDataTable({
  
  
  if(viewDelete.global$deleted == 1){return()}
  
  if(choosenModelInd()[[1]] == "ARIMA"){
    return(cbind(ID = rownames(choosenModelInd()[[3]]), round(choosenModelInd()[[3]], digits = 3)))
  }
  
}, options = list(scrollX = TRUE, searching = FALSE, pageLength = 4, info = FALSE, lengthChange = FALSE))

# Ausgabe Arima kind
output$kindModelArimaInd <- renderUI({
  if(viewDelete.global$deleted == 1){return()}
  
  if(choosenModelInd()[[1]] == "ARIMA"){
    return(choosenModelInd()[[5]])
  }
  
})

# Ausgabe Arima forecast
output$arimaModelForecastInd <- renderDataTable({
  if(viewDelete.global$deleted == 1){return()}
  
  if(choosenModelInd()[[1]] == "ARIMA"){
    return(choosenModelInd()[[6]])
  }
  
}, options = list(scrollX = TRUE, searching = FALSE, pageLength = 4, info = FALSE, lengthChange = FALSE))

# Ausgabe Arima coefficents
output$arimaCoefModelInd <- renderDataTable({
  
  if(viewDelete.global$deleted == 1){return()}
  
  if(choosenModelInd()[[1]] == "ARIMA"){
    return(cbind(ID = rownames(choosenModelInd()[[4]]), round(choosenModelInd()[[4]], digits = 3)))
  }
  
}, options = list(scrollX = TRUE, searching = FALSE, pageLength = 4, info = FALSE, lengthChange = FALSE))


# Ausgabe Arima Error
output$arimaErrorInd <- renderDataTable({
  
  if(viewDelete.global$deleted == 1){return()}

  if(choosenModelInd()[[1]] == "ARIMA"){
    return(cbind(Measure = rownames(choosenModelInd()[[7]]), round(choosenModelInd()[[7]], digits = 3)))
  }
}, options = list(scrollX = TRUE, searching = FALSE, pageLength = 4, info = FALSE, lengthChange = FALSE))

# Ausgabe Quality Exponential Smoothing
output$expsmQualityModelInd <- renderDataTable({
  
  
  if(viewDelete.global$deleted == 1){return()}
  
  if(choosenModelInd()[[1]] == "Exponential Smoothing"){
    return(cbind(ID = rownames(choosenModelInd()[[3]]), round(choosenModelInd()[[3]], digits = 3)))
  }
  
}, options = list(scrollX = TRUE, searching = FALSE, pageLength = 4, info = FALSE, lengthChange = FALSE))

# Ausgabe Exponential Smoothing kind
output$kindModelexpsmInd <- renderUI({
  if(viewDelete.global$deleted == 1){return()}
  
  if(choosenModelInd()[[1]] == "Exponential Smoothing"){
    return(choosenModelInd()[[5]])
  }
  
})

# Ausgabe Exponential Smoothing forecast
output$expsmModelForecastInd <- renderDataTable({
  if(viewDelete.global$deleted == 1){return()}
  
  if(choosenModelInd()[[1]] == "Exponential Smoothing"){
    return(choosenModelInd()[[6]])
  }
  
}, options = list(scrollX = TRUE, searching = FALSE, pageLength = 4, info = FALSE, lengthChange = FALSE))

# Ausgabe Exponential Smoothing coefficents
output$expsmCoefModelInd <- renderDataTable({
  
  if(viewDelete.global$deleted == 1){return()}
  
  if(choosenModelInd()[[1]] == "Exponential Smoothing"){
    return(cbind(ID = rownames(choosenModelInd()[[4]]), round(choosenModelInd()[[4]], digits = 3)))
  }
  
}, options = list(scrollX = TRUE, searching = FALSE, pageLength = 4, info = FALSE, lengthChange = FALSE))


# Ausgabe Exponential Smoothing Error
output$expsmErrorInd <- renderDataTable({
  
  if(viewDelete.global$deleted == 1){return()}
  
  if(choosenModelInd()[[1]] == "Exponential Smoothing"){
    return(cbind(Measure = rownames(choosenModelInd()[[7]]), round(choosenModelInd()[[7]], digits = 3)))
  }
}, options = list(scrollX = TRUE, searching = FALSE, pageLength = 4, info = FALSE, lengthChange = FALSE))

# Ausgabe Trend-Settings
output$trendSettingsInd <- renderDataTable({
  if(viewDelete.global$deleted == 1){return()}
  
  if(choosenModelInd()[[1]] == "Trend Input"){
    return(choosenModelInd()[[3]])
  }
  
}, options = list(scrollX = TRUE, searching = FALSE, pageLength = 4, info = FALSE, lengthChange = FALSE))

# Ausgabe predicted Time-Steps
output$predTimeStepsInd <- renderDataTable({
  if(viewDelete.global$deleted == 1){return()}
  
  if(choosenModelInd()[[1]] == "Trend Input"){
    return(choosenModelInd()[[4]])
  }
  
})

# Anpassen der Ueberschrift basierend auf der gewaehlten Variable
output$headerTrendsavedInd <- renderUI({
  
  if(viewDelete.global$deleted == 1){return()}
  name.var  <- isolate(input$savedModelsInd)
  return(h3(strong(paste(name.var, "Trend", sep = " "))))
})


# Ausgabe Optionen fue manuelle Daten
output$manual.header.savedInd <- renderUI({
  
  if(viewDelete.global$deleted == 1){return()}
  
  name.manual <- isolate(input$savedModelsInd)
  
  h4(name.manual)
  
})

# Ausgabe der bisher getaetigten Eingaben der gewaelten unabhaengigen Variable
output$manual.data.savedInd <- renderDataTable({
  
  if(choosenModelInd()[[1]] == "Manual Input"){
    return(choosenModelInd()[[2]])
  }
  
}, options = list(pagination = FALSE, pageLength = 5, searching = FALSE, paging = FALSE))

# output$manual.graph.savedInd <- renderDygraph({
#   
#   if(viewDelete.global$deleted == 1){return()}
#   
#   if(choosenModelInd()[[1]] == "Manual Input"){
#     return(choosenModelInd()[[2]])
#   }
#   
# })

# Organisiere UI-Output fuer alle moeglichen forecast-Modelle
modelUiOrganizerInd <- eventReactive(choosenModelInd(), {
  
  outputList <- choosenModelInd()
  modelKind <- outputList[[1]]
  
  if(modelKind == "ARIMA"){
    
    print("hier")
    return(list(fluidRow(
                   column(
                     width = 5,
                     style = "overflow-y:scroll; max-height: 400px",
                     uiOutput("kindModelArimaInd"),
                     dataTableOutput("arimaCoefModelInd"),
                     h3(strong("Error Measures")),
                     dataTableOutput("arimaErrorInd")
                   ),
                   
                   column(
                      width = 7,
                      style = "overflow-y:scroll; max-height: 400px",
                      h3(strong("Quality criteria of current fitted model")),
                      dataTableOutput("arimaQualityModelInd"),
                      h3(strong("Predicted confidence intervals")),
                      dataTableOutput("arimaModelForecastInd")
                  )
                 )
            ))
    
  }else if(modelKind == "Exponential Smoothing"){
    
    print("hier")
    return(list(fluidRow(
      column(
        width = 5,
        style = "overflow-y:scroll; max-height: 400px",
        uiOutput("kindModelexpsmInd"),
        dataTableOutput("expsmCoefModelInd"),
        h3(strong("Error Measures")),
        dataTableOutput("expsmErrorInd")
      ),
      
      column(
        width = 7,
        style = "overflow-y:scroll; max-height: 400px",
        h3(strong("Quality criteria of current fitted model")),
        dataTableOutput("expsmQualityModelInd"),
        h3(strong("Predicted confidence intervals")),
        dataTableOutput("expsmModelForecastInd")
      )
    )
    ))
    
  }else if(modelKind == "Trend Input"){
    
    return(list(column(
                  width = 12,
                  style = "overflow-y:scroll; max-height: 400px",
                  uiOutput("headerTrendsavedInd"),
                  #dygraphOutput("graphForecastInd"),
                  br(),
                  dataTableOutput("trendSettingsInd"),
                  br(),
                  h3(em("Resulting values")),
                  dataTableOutput("predTimeStepsInd")
                )
          ))
  }else if(modelKind == "Manual Input"){
    
    return(list(uiOutput("manual.header.savedInd"),
                br(),
                #dygraphOutput("manual.graph.savedInd"),
                dataTableOutput("manual.data.savedInd"))
    )
  }
})

# Ausgabe der spezifischen UI
output$modelUIInd <- renderUI({
  
  if(viewDelete.global$deleted == 1){return()}
  
  modelUiOrganizerInd()
  
})

output$test1Ind <- renderText({
  if(viewDelete.global$deleted == 1){return()}
  
  choosenModelInd()
})

############################ Folgende Funktionen befassen sich mit dem Loeschen von Modellen ###################

observeEvent(input$deleteModel, {
  
  viewDelete.global$deleted <- 1
  
  if(input$savedModelsInd == ""){return()}
  
  evaluationTable <- objects$usedForecastsInd
  modelKind <- as.character(evaluationTable[which(evaluationTable[ ,1] == input$savedModelsInd) ,2])
  
  if(modelKind == "ARIMA"){
    
    name <- input$savedModelsInd
    names.saved <- objects$lmArimaSave [[1]]
    index.saved <- which(names.saved == name)
    
    objects$lmArimaSave  <- objects$lmArimaSave[- index.saved, ]
    
    objects$lmArimaGraphs <- objects$lmArimaGraphs[-index.saved]
    
    objects$lmArimaModels <- objects$lmArimaModels[-index.saved]
    
  }else if(modelKind == "Exponential Smoothing"){
    
    name <- input$savedModelsInd
    names.saved <- objects$lmexpsmSave [[1]]
    index.saved <- which(names.saved == name)
    
    objects$lmexpsmSave  <- objects$lmexpsmSave[- index.saved, ]
    
    objects$lmexpsmGraphs <- objects$lmexpsmGraphs[-index.saved]
    
    objects$lmexpsmModels <- objects$lmexpsmModels[-index.saved]
    
  }else if(modelKind == "Trend Input"){
    
    name <- input$savedModelsInd
    index.name <- which(names(objects$lmTrendInput) == name)
    
    objects$lmTrendInput[[index.name]] <- data.frame("Trend" = character(), "Percentage" = numeric(), "Lower Percentage" = numeric(), 
                                                     "Upper Percentage" = numeric(), "Time steps" = numeric())
  }else if(modelKind == "Manual Input"){
    
    objects$lmManualInput[[input$savedModelsInd]] <- data.frame("Date" = character(), "Expected Value" = numeric(), "Lower Quantile" = numeric(), "Upper Quantile" = numeric())
    
  }
  
})


##################################### Download-Settings fuer die Forecast-Values ###################################################################

output$downloadForecastsInd <- renderUI({
  
  if(is.null(objects$lmRegressionModell)) return()
  
  if(!any(objects$usedForecastsInd[ ,2] != "Outstanding")) return()
  
  return(downloadButton('downloadARIMAPred', 'Download Prediction as Excel-File'))
  
})

# Speichern der ARIMA-Vorhersagen in einer CSV-Datei
output$downloadARIMAPred <- downloadHandler(
  filename = function() {
    
    evaluationTable <- objects$usedForecastsInd
    modelKind <- as.character(evaluationTable[which(evaluationTable[ ,1] == input$savedModelsInd) ,2])
    
    if(modelKind == "ARIMA"){
      index <- which(objects$lmArimaSave$Variable.Name == input$savedModelsInd)
      return(paste("arima_forecast_", input$savedModelsInd , '.xlsx', sep=''))
    }else if(modelKind == "Exponential Smoothing"){
      index <- which(objects$lmexpsmSave$Variable.Name == input$savedModelsInd)
      return(paste("expsm_forecast_", input$savedModelsInd , '.xlsx', sep=''))
    }else if(modelKind == "Trend Input"){
      index.name <- which(names(objects$lmTrendInput) == input$savedModelsInd)
      return(paste("trend_forecast_", input$savedModelsInd , '.xlsx', sep=''))
      write.xlsx(objects$lmTrendInput[[index.name]][[2]], file)
    }else if(modelKind == "Manual Input"){
      index.name <- which(names(objects$lmManualInput) == input$savedModelsInd)
      return(paste("manual_forecast_", input$savedModelsInd , '.xlsx', sep=''))
    }
  },
  content = function(file) {
    
    evaluationTable <- objects$usedForecastsInd
    modelKind <- as.character(evaluationTable[which(evaluationTable[ ,1] == input$savedModelsInd) ,2])
    
    if(modelKind == "ARIMA"){
      index <- which(objects$lmArimaSave$Variable.Name == input$savedModelsInd)
      write.xlsx(objects$lmArimaGraphs[[index]][[6]], file)
    }else if(modelKind == "Exponential Smoothing"){
      index <- which(objects$lmexpsmSave$Variable.Name == input$savedModelsInd)
      write.xlsx(objects$lmexpsmGraphs[[index]][[6]], file)
    }else if(modelKind == "Trend Input"){
      index.name <- which(names(objects$lmTrendInput) == input$savedModelsInd)
      write.xlsx(objects$lmTrendInput[[index.name]][[2]], file)
    }else if(modelKind == "Manual Input"){
      index.name <- which(names(objects$lmManualInput) == input$savedModelsInd)
      write.xlsx(objects$lmManualInput[[input$savedModelsInd]], file)
    }
  
  }
)

