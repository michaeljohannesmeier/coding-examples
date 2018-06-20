# Time-Series-Decomposition

# Dieser UI-Output organisiert die Auswahl der zur Verfuegung stehenden Variablen
output$chooseTSToDecompose <- renderUI({
  
  colnamesTSDecomp <- names(daten.under$base[ ,sapply(daten.under$base, is.numeric)])
  selectInput("chooseTSDecomp", h4(strong("Choose independent variable to decompose")),
              choices = colnamesTSDecomp, width = '400px')
  
})

# Decomposition der Time-Series
decomposedTimeseries <- eventReactive(input$decomposeTS, {
  
  startfreq2 = 12
  

  # Extract relevant data
  decompositionData <- daten.under$base[ ,input$chooseTSDecomp]
  daten.under$base["Date"] <- seq(as.Date("1991/01/01"), length.out = nrow(daten.under$base), by = "month")

  startdate <- c(year(daten.under$base[[1]][1]), month(daten.under$base[[1]][1]))

  
  tsTimeseries <- ts(decompositionData, start = startdate, frequency = startfreq2)
  
  # Decompose Time-Series
  decompositionTS <- decompose(tsTimeseries)
  
  plotOriginalTS <- plot_ly()
  plotOriginalTS <- add_trace(plotOriginalTS, y = decompositionTS$x, x = as.Date(decompositionTS$x), type ="scatter", mode = "lines+markers", line = list(color = input$col1)) %>%
    layout(font = list(family = input$ownFont, size = input$sizeOwnFont), title = paste0("Original time series of ", input$chooseTSDecomp))
  
  plotSeasonalTS <- plot_ly()
  plotSeasonalTS <- add_trace(plotSeasonalTS, y = decompositionTS$seasonal, x = as.Date(decompositionTS$seasonal), type ="scatter", mode = "lines+markers", line = list(color = input$col1)) %>%
    layout(font = list(family = input$ownFont, size = input$sizeOwnFont), title = paste0("Seasonal-component of ", input$chooseTSDecomp))
  
  plotTrendTS <- plot_ly()
  plotTrendTS <- add_trace(plotTrendTS, y = decompositionTS$trend, x = as.Date(decompositionTS$trend), type ="scatter", mode = "lines+markers", line = list(color = input$col1))%>%
    layout(font = list(family = input$ownFont, size = input$sizeOwnFont), title = paste0("Trend-component of ", input$chooseTSDecomp))
  
  plotErrorTS <- plot_ly()
  plotErrorTS <- add_trace(plotErrorTS, y = decompositionTS$random, x = as.Date(decompositionTS$random), type ="scatter", mode = "lines+markers", line = list(color = input$col1)) %>%
    layout(font = list(family = input$ownFont, size = input$sizeOwnFont), title = paste0("Error-component of ", input$chooseTSDecomp))
  
  return(list("OriginalTS" = plotOriginalTS,
              "SeasonalTS" = plotSeasonalTS,
              "TrendTS" = plotTrendTS,
              "ErrorTS" = plotErrorTS))
})

# Ausgabe der orginalen Zeitserie
output$plotOriginalTS <- renderPlotly({
  
  if(is.null(decomposedTimeseries())){
    return()
  }
  
  decomposedTimeseries()[[1]]
  
})

# Ausgabe der Saisonalen-Komponente
output$plotSeasonalTS <- renderPlotly({
  
  if(is.null(decomposedTimeseries())){
    return()
  }
  
  decomposedTimeseries()[[2]]
  
})

# Ausgabe der Trend-Komponente
output$plotTrendTS <- renderPlotly({
  
  if(is.null(decomposedTimeseries())){
    return()
  }
  
  decomposedTimeseries()[[3]]
  
})

# Ausgabe der Error-Komponente
output$plotErrorlTS <- renderPlotly({
  
  if(is.null(decomposedTimeseries())){
    return()
  }
  
  decomposedTimeseries()[[4]]
  
})

######################### Trend-Analyse (Um moeglich/noetige Differenzierung automatisch zu identifizieren) #############

# Auswahlmoeglichkeiten der Variablen die auf einen Trend getestet werden.
output$chooseVariablesTrendTest <- renderUI({
  
  if(input$testTrendAllcheckbox == TRUE){return()}
  
  colnamesTSTrendTest <- names(daten.under$base[ ,sapply(daten.under$base, is.numeric)])

  selectInput("columnsTrendTest", h4(strong("Choose variables to test for an existing Trend")), 
              choices  = colnamesTSTrendTest,
              multiple = TRUE,
              width = '1000px')
})

# Test Trend for selected variables
trendTestTables <- eventReactive(input$testTrend, {
  
  daten.under$base["Date"] <- seq(as.Date("1991/01/01"), length.out = nrow(daten.under$base), by = "month")
  if(input$testTrendAllcheckbox == TRUE){
    namesTSTrendTest <- colnames(daten.under$base)[-1]
  }else {
    namesTSTrendTest <- input$columnsTrendTest
  }
  
  tableNoEvidenceAgainstTrend <- data.frame()
  tableEvidenceAgainstTrend <- data.frame()
  
  progress <- 0
  
  withProgress(message = "Performing Trend Test", value=0.3,{
    
    for(i in 1:length(namesTSTrendTest)){
      tempName <- namesTSTrendTest[i]
      
      tempTestTrendB <- na.omit(daten.under$base[ ,tempName])
  
      # testOutput <- tryCatch({
      #                 wavk.test(tempTestTrendB ~ 1,
      #                           factor.length = "adaptive.selection", 
      #                           out = TRUE, 
      #                           B = 1000)
      #               }  , error = function(e) {
      #                 wavk.test(tempTestTrendB ~ 1,
      #                           factor.length = "user.defined", 
      #                           out = TRUE, 
      #                           B = 1000)
      #               })
      
      testOutput <- kpss.test(tempTestTrendB)
      
      if(testOutput$p.value > 0.05){
        if(dim(tableNoEvidenceAgainstTrend)[1] == 0){
          tableNoEvidenceAgainstTrend <- data.frame(Variable = tempName,
                                                    Conclusion = "Time-Series is propably stationary (constant level)",
                                                    P_Value = testOutput$p.value)
          
          tableNoEvidenceAgainstTrend$Variable <- as.character(tableNoEvidenceAgainstTrend$Variable)
          tableNoEvidenceAgainstTrend$Conclusion <- as.character(tableNoEvidenceAgainstTrend$Conclusion)
          tableNoEvidenceAgainstTrend$P_Value <- as.numeric(tableNoEvidenceAgainstTrend$P_Value)
          
        }else{
          tableNoEvidenceAgainstTrend <- rbind(tableNoEvidenceAgainstTrend,
                                               c(tempName, "Time-Series is propably stationary (constant level)", testOutput$p.value))
        
        }
      }else{
        if(dim(tableEvidenceAgainstTrend)[1] == 0){
          tableEvidenceAgainstTrend <- data.frame(Variable = tempName,
                                                  Conclusion = "Time-Series is propably not stationary (no constant level)",
                                                  P_Value = testOutput$p.value)
          
          tableEvidenceAgainstTrend$Variable <- as.character(tableEvidenceAgainstTrend$Variable)
          tableEvidenceAgainstTrend$Conclusion <- as.character(tableEvidenceAgainstTrend$Conclusion)
          tableEvidenceAgainstTrend$P_Value <- as.numeric(tableEvidenceAgainstTrend$P_Value)
          
        }else{
          tableEvidenceAgainstTrend <- rbind(tableEvidenceAgainstTrend,
                                             c(tempName, "Time-Series is propably not stationary (no constant level)", testOutput$p.value))
        }
      }
      
    }
  }) 
  setProgress(value = 1)
  tableNoEvidenceAgainstTrend$P_Value <- round(as.numeric(tableNoEvidenceAgainstTrend$P_Value),3)
  tableEvidenceAgainstTrend$P_Value <- round(as.numeric(tableEvidenceAgainstTrend$P_Value),3)
  return(list("Table_Stable" = tableNoEvidenceAgainstTrend,
              "Table_non_Stable" = tableEvidenceAgainstTrend))
  
  
})


# Ausgabe Ueberschrift der Tabelle mit wahrscheinlich nicht-konstanten Time-Series
output$headerNonStationaryTS <- renderUI({
  
  if(is.null(trendTestTables())){
    return()
  }
  
  if(dim(trendTestTables()$Table_non_Stable)[1] == 0){
    return()
  }
  
  h4(strong("Time-Series with probable non-constant level"))
  
})

# Ausgabe der Tabelle mit den Variablen die wahrscheinlich einen nicht-konstanten Trend enthalten
output$tableEvidenceAgainstTrend <- renderDataTable({
  
  if(is.null(trendTestTables())){
    return()
  }
  
  validate(
    need(dim(trendTestTables()$Table_non_Stable)[1] != 0, "No not stationary Time-Series detected")
  )
  
  return(trendTestTables()$Table_non_Stable)
  
}, rownames = FALSE)

# Ausgabe Ueberschrift der Tabelle mit wahrscheinlich konstanten Time-Series
output$headerStationaryTS <- renderUI({
  
  if(is.null(trendTestTables())){
    return()
  }
  
  if(dim(trendTestTables()$Table_Stable)[1] == 0){
    return()
  }
  
  h4(strong("Time-Series with probable constant level"))
  
})

# Ausgabe der Tabelle mit den Variablen die wahrscheinlich einen konstanten Trend enthalten
output$tableNoEvidenceAgainstTrend <- renderDataTable({
  
  withProgress(message = "Performing Trend Test", value=0.5,{
  
    if(is.null(trendTestTables())){
      return()
    }
    
    validate(
      need(dim(trendTestTables()$Table_Stable)[1] != 0, "No stationary Time-Series detected")
    )
    return(trendTestTables()$Table_Stable)
  })
  
}, rownames = FALSE)

# Ausgabe des Buttons fuer die Durchfuehrung der Differenzenbildung
output$performDifferencing <- renderUI({
  
  if(is.null(trendTestTables())){
    return()
  }
  
  if(dim(trendTestTables()$Table_non_Stable)[1] == 0){
    return()
  }
  
  return(actionButton("differenceTS", "Build differences of non stationary Time-Series"))
})

# Durchfuehren der Differenzen-Bildung bei der Betaetigung des Buttons "differenceTS"
observeEvent(input$differenceTS, {
  
  withProgress(message = "Differencing data, please wait", value=0.5,{
    if(is.null(trendTestTables())){
      return()
    }
    
    if(dim(trendTestTables()$Table_non_Stable)[1] == 0){
      return()
    }
    
    variablesToDiff <- trendTestTables()$Table_non_Stable[,1]
    
    for(i in 1:length(variablesToDiff)){
      
      tempDataToDiff <- c(NA, diff(daten.under$default[,variablesToDiff[i]][[1]]))
      tempDiffDataFrame <- data_frame("Diff" = tempDataToDiff)
      colnames(tempDiffDataFrame) <- paste("Diff", 1, variablesToDiff[i], sep = "_")
      
      # Get names der gepeicherten Transformationen
      namesSavedTransformations <- names(daten.under$Transformations)
      
      # Speichern des ARIMA-Modells in der globalen Variable "globalIndependentVariables$forecastsIndependentVariables"
      lengthSavedTransformations <- length(daten.under$Transformations) + 1
      
      # Sollte eine Exakte Transformation durchgefuehrt wurden sein, wird nichts gespeichert.
      if(!is.null(namesSavedTransformations) && paste("Diff", 1, variablesToDiff[i], sep = "_") %in% namesSavedTransformations){
        withProgress(message = "Transformation already saved", value = 0,{
          setProgress(value = 1)
          Sys.sleep(1)
        })
        return()
      }
      
      # Anhaengen der Transformierten Daten an den Basis-Datensatz
      if(splitindex$splittruefalse){
        daten.under$base <- as_data_frame(cbind(daten.under$base,
                                                tempDiffDataFrame[1:dim(daten.under$base)[1],]))
        daten.under$data.test <- as_data_frame(cbind(daten.under$data.test,
                                                     tempDiffDataFrame[(dim(daten.under$base)[1] + 1):dim(daten.under$default)[1],]))
        daten.under$default <- as_data_frame(cbind(daten.under$default, tempDiffDataFrame))
      }else{
        daten.under$base <- as_data_frame(cbind(daten.under$base, tempDiffDataFrame))
        daten.under$default <- as_data_frame(cbind(daten.under$default, tempDiffDataFrame))
      }
  
      
      # Speichern der aktuelle gewaehlten Transformation
      daten.under$Transformations[[lengthSavedTransformations]] <- data.frame("Transformation" = "Differencing",
                                                                              "Diff" = 1,
                                                                              "Previous_Variable" = variablesToDiff[i])
      
      # Setzen des Namens der gespeicherten Box-Cox-Transformation
      names(daten.under$Transformations)[lengthSavedTransformations] <-  paste("Diff", 1, variablesToDiff[i], sep = "_")
      
    }
  })
  withProgress(message = "Data differenced", value = 9.0, Sys.sleep(2))
})



##################### Box-Cox Transformationen - Varianz-Analyse ##################################################

# Auswahlmoeglichkeiten der Variablen die auf einen Trend getestet werden.
output$chooseVariablesBoxCoxTest <- renderUI({
  
  colnamesTSTrendTest <- names(daten.under$base[ ,sapply(daten.under$base, is.numeric)])
  
  selectInput("columnsBoxCoxTest", h4(strong("Choose variables to test for Variance Stabalization")), 
              choices  = colnamesTSTrendTest,
              multiple = TRUE,
              width = '1000px')
})

# Get "best" Box-Cox-Transformations
boxCoxBestTransformation <- eventReactive(input$testBoxCox, {
  
  if(is.null(input$columnsBoxCoxTest)){
    return()
  }
  
  namesTSBoxCoxTest <- input$columnsBoxCoxTest
  
  tableNoEvidenceAgainstTrend <- data.frame()
  tableEvidenceAgainstTrend <- data.frame()
  
  progress <- 0
  
  withProgress(message = "Determine best transformations", value = 0,{
    
    bestBoxCoxTransformation <- data.frame()
    
    for(i in 1:length(namesTSBoxCoxTest)){
      
      tempName <- namesTSBoxCoxTest[i]
      
      tempTestTrendB <- daten.under$default[ ,tempName][[1]]
      
      if(min(tempTestTrendB, na.rm = TRUE) <= 0){
        minShift <- abs(min(tempTestTrendB, na.rm = TRUE)) + 1
      }else{
        minShift <- 0
      }
      
      bestLambdaTestGuerrero <- BoxCox.lambda(tempTestTrendB + minShift, method = "guerrero")
      bestLambdaTestLoglik <- BoxCox.lambda(tempTestTrendB + minShift, method = "loglik")
      
      tempResult <- data.frame(Variable = tempName,
                               "Suggestion for Transformation Paramter 1." = round(bestLambdaTestGuerrero, digits = 2),
                               "Suggestion for Transformation Paramter 2." = round(bestLambdaTestLoglik, digits = 2),
                               "Time Series upwards shifted by" = minShift)
      
      bestBoxCoxTransformation <- rbind(bestBoxCoxTransformation,
                                        tempResult)
      
    }
    
    colnames(bestBoxCoxTransformation) <- c("Variable",
                                            "Suggestion for Transformation Paramter 1.",
                                            "Suggestion for Transformation Paramter 2.",
                                            "Time Series upwards shifted by")
    
    setProgress(value = 1)
  })
  
  return(bestBoxCoxTransformation)
})

# Ausgabe der Ueberschrift der Box-Cox-Transformation
output$headerBoxCoxResult <- renderUI({
  
  if(is.null(boxCoxBestTransformation())){
    return()
  }else{
    return(h4(strong("Time-Series with Transformation Suggestions")))
  }
})

# Ausgabe der Ergebnis-Tabelle der Transformations-Suggestions
output$tableBoxCoxResult <- renderDataTable({
  
  if(is.null(boxCoxBestTransformation())){
    return()
  }else{
    return(boxCoxBestTransformation())
  }
  
}, rownames = FALSE)

# Anhaengen der gewahlten Box-Cox-Transformation an den Basis-Datensatz
observeEvent(input$saveBoxBox, {
  
  req(boxCoxBestTransformation())
  
  nameBoxCoxTransform <- input$variablesVisualizeBoxCox
  lambdaChosen <- as.numeric(input$lambdaVisualizeBoxCox)
  minShift <- as.numeric(boxCoxBestTransformation()[which(boxCoxBestTransformation()[,1] == nameBoxCoxTransform),4])
  
  tempDataFrameTransform <- data_frame("Transform" = BoxCox(x = daten.under$default[,nameBoxCoxTransform][[1]] + minShift, 
                                                            lambda = lambdaChosen))
  colnames(tempDataFrameTransform) <- paste(nameBoxCoxTransform, "BoxCox", lambdaChosen, sep = "_")
  
  # Get names der gepeicherten Transformationen
  namesSavedTransformations <- names(daten.under$Transformations)
  
  # Speichern des ARIMA-Modells in der globalen Variable "globalIndependentVariables$forecastsIndependentVariables"
  lengthSavedTransformations <- length(daten.under$Transformations) + 1
  
  # Sollte eine Exakte Transformation durchgefuehrt wurden sein, wird nichts gespeichert.
  if(!is.null(namesSavedTransformations) && paste(nameBoxCoxTransform, "BoxCox", lambdaChosen, sep = "_") %in% namesSavedTransformations){
    withProgress(message = "Transformation already saved", value = 0,{
      setProgress(value = 1)
      Sys.sleep(1)
    })
    return()
  }
  
  # Anhaengen der Transformierten Daten an den Basis-Datensatz
  if(splitindex$splittruefalse){
    daten.under$base <- as_data_frame(cbind(daten.under$base,
                                            tempDataFrameTransform[1:dim(daten.under$base)[1],]))
    daten.under$data.test <- as_data_frame(cbind(daten.under$data.test,
                                                 tempDataFrameTransform[(dim(daten.under$base)[1] + 1):dim(daten.under$default)[1],]))
    daten.under$default <- as_data_frame(cbind(daten.under$default, tempDataFrameTransform))
  }else{
    daten.under$base <- as_data_frame(cbind(daten.under$base, tempDataFrameTransform))
    daten.under$default <- as_data_frame(cbind(daten.under$default, tempDataFrameTransform))
  }
  
  # Speichern der aktuelle gewaehlten Transformation
  daten.under$Transformations[[lengthSavedTransformations]] <- data.frame("Transformation" = "Box-Cox",
                                                                 "Lambda" = lambdaChosen,
                                                                 "Min-Shift" = minShift,
                                                                 "Previous_Variable" = input$variablesVisualizeBoxCox)
  
  # Setzen des Namens der gespeicherten Box-Cox-Transformation
  names(daten.under$Transformations)[lengthSavedTransformations] <-  paste(nameBoxCoxTransform, "BoxCox", lambdaChosen, sep = "_")
  
})


# Ausgabe einer dynamischen UI fuer die Visualisierung der Varianz-Stabilisierenden Box-Cox-Transformationen
output$uiBoxCoxVisualisierung <- renderUI({
  
  if(is.null(boxCoxBestTransformation())){
    return()
  }
  
  return(list(selectInput("variablesVisualizeBoxCox", h4(strong("Choose variable to visualize Transformation")), 
                          choices  = boxCoxBestTransformation()[,1],
                          multiple = FALSE,
                          width = '500px'),
              fluidRow(
                column(
                  width = 6,
                  br(),br(),br(),br(),br(),
                  plotlyOutput("originalTS")
                ),
                column(
                  width = 6,
                  uiOutput("chooseBoxCoxLambda"),
                  plotlyOutput("boxCoxTSPlot")
                )
              )
              ))
})

# UI-Output Auswahl Lambda 
output$chooseBoxCoxLambda <- renderUI({
  
  req(boxCoxBestTransformation())
  
  lambdaChoose <- as.numeric(boxCoxBestTransformation()[which(boxCoxBestTransformation()[,1] == input$variablesVisualizeBoxCox),2:3])
  
  return(selectInput("lambdaVisualizeBoxCox", h4(strong("Choose Box-Cox-Lambda")), 
                     choices  = lambdaChoose,
                     multiple = FALSE,
                     width = '200px'))
  
})

# Ausgabe der Orginalen Zeitserie
output$originalTS <- renderPlotly({
  
  req(boxCoxBestTransformation())
  
  plotOriginalTS <- plot_ly()
  plotOriginalTS <- add_trace(plotOriginalTS, y = daten.under$base[ ,input$variablesVisualizeBoxCox][[1]],
                              x = daten.under$base[ ,1][[1]],
                              type = "scatter",
                              mode = "lines+markers",
                              line = list(color = input$col1)) %>%
                    layout(font = list(family = input$ownFont, size = input$sizeOwnFont),
                           title = paste0("Original time series of ", input$variablesVisualizeBoxCox))
  
})

# Ausgabe Box-Transformierte Zeitserie 
output$boxCoxTSPlot <- renderPlotly({
  
  req(boxCoxBestTransformation())
  req(input$lambdaVisualizeBoxCox)
  
  plotOriginalTS <- plot_ly()
  plotOriginalTS <- add_trace(plotOriginalTS, y = BoxCox(daten.under$base[ ,input$variablesVisualizeBoxCox][[1]] +
                                                           boxCoxBestTransformation()[which(boxCoxBestTransformation()[,1] == input$variablesVisualizeBoxCox),4],
                                                         as.numeric(input$lambdaVisualizeBoxCox)),
                              x = daten.under$base[ ,1][[1]],
                              type = "scatter",
                              mode = "lines+markers",
                              line = list(color = input$col1)) %>%
    layout(font = list(family = input$ownFont, size = input$sizeOwnFont),
           title = paste0("Box-Cox-Transformation of ", input$variablesVisualizeBoxCox))
  
  
})