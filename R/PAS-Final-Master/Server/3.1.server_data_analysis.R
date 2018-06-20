# Determinierung der globalen Variablen für die Generierung der Timeseries-Plots 
plot.variable <- reactiveValues(
  
  tabelle.relation = data.frame(),
  tabelle.korrelation = data.frame()
  
)

# index2 reactive Values sind für die Sidebar, d.h. die Anzeige Actual Stored Model in der schwarzen Box in der Sidebar (hier Anzeige der ausgewählten abhängigen Variable)
observe({
  index2$depVar<-input$depVar

})

# hier im Tab Data Analysis via visualisation:
# Diese renderUI gibt einen selectInput mit den waehlbaren unabhaengigen Variablen zurueck 
# Die gewaehlte unabhaengige Variable kann dann bezueglich der moeglichen Lags untersucht werden
output$independent_variable <- renderUI({
  
  input$depVar
  # Indes abhaengige Variable in cor.data DataFrame
  cor.data <- daten.under$base[ ,sapply(daten.under$base, is.numeric)]
  cor.data <- dplyr::select(cor.data, - which(attributes(cor.data)$names == input$depVar))
  colnames <- names(cor.data)
  selectInput("indepVar", h4("Choose independent variable"),
              choices = colnames)
  
})

################################################################################### ab hier Scatter Plots
######################################################################################################################################################################
# hier im Tab Data Analysis via visualisation:
# dieser Output gibt die Auswahl der Variablen im linken Scatter-Plot-Fenster wieder (dort können alle Variablen gewählt werden, die im Datensatz vorhanden sind)
output$dependent_variable_scatter1<-renderUI({

  cor.data <- daten.under$base[ ,sapply(daten.under$base, is.numeric)]
  colnames <- names(cor.data)
  selectInput("depscattereins", NULL,
              choices = colnames)
  
})

# hier im Tab Data Analysis via visualisation:
# dieser Output gibt die Auswahl der Variablen im rechten Scatter-Plot-Fenster wieder (dort können alle Variablen gewählt werden, die im Datensatz vorhanden sind)
output$dependent_variable_scatter2<-renderUI({
  
  cor.data <- daten.under$base[ ,sapply(daten.under$base, is.numeric)]
  colnames <- names(cor.data)
  selectInput("depscatterzwei", NULL,
              choices = colnames)
  
})


# hier im Tab Data Analysis via visualisation:
# Diese renderUI hat ebenso ein Drop-Down-Menue mit den verschiedenen unabhaengigen Variablen zur Auswahl (es sind auch alle Variablen auswählbar)
output$independent_variable_scatter1 <- renderUI({
  
  
  cor.data <- daten.under$base[ ,sapply(daten.under$base, is.numeric)]
  colnames <- names(cor.data)
  selectInput("indepscattereins", NULL,
              choices = colnames)
  
})


# hier im Tab Data Analysis via visualisation:
# Siehe "indenpendent_variable_scatter1"
output$independent_variable_scatter2 <- renderUI({
  
  cor.data <- daten.under$base[ ,sapply(daten.under$base, is.numeric)]
  colnames <- names(cor.data)
  selectInput("indepscatterzwei", NULL,
              choices = colnames)
})



# hier im Tab Data Analysis via visualisation:
# Diese Funktion organisiert die Ausgabe des oberen (1. linker Scatterplot) einer unabhaengigen Variable gegen die Abhaengige.
output$scatterPlots1 <- renderPlot({
  
  input$printscatter1
  
  isolate({
    
    if(is.null(input$indepscattereins) | is.null(input$linNon.1) | identical(input$indepscattereins, NA)){return()}
    
    scatter.data <- as.tbl(daten.under$data.temp.1)
    index.depVar <- which(attributes(scatter.data)$names == input$depscattereins)
    index.scatter1 <- which(attributes(scatter.data)$names == input$indepscattereins)
    
    lags.scatter <- input$scatter.1.lags
    depVar.data <- scatter.data[ , index.depVar]
    indepVar.data <- scatter.data[ , - index.depVar]
    
    if(lags.scatter > 0){
      indepVar.data <- indepVar.data[ -((length(indepVar.data[[1]]) - lags.scatter + 1):length(indepVar.data[[1]])), ]
      depVar.data <- depVar.data[-(1:lags.scatter), ]
      scatter.data <- cbind(depVar.data, indepVar.data)
      index.depVar <- 1
      index.scatter1 <- which(attributes(scatter.data)$names == input$indepscattereins)
    }
    
  })
  
  keep <- as.tbl(scatter.data[ daten.under$keeprows.1, , drop = FALSE])
  exclude <- as.tbl(scatter.data[ !daten.under$keeprows.1, , drop = FALSE])
  
  
  par(mfrow=c(2,2))
  if(isolate(input$linNon.1 == "Linear")){
    report$scattereins<-ggplot(keep[complete.cases(keep), ], aes_string(x = attributes(scatter.data)$names[index.scatter1], y = attributes(scatter.data)$names[index.depVar])) + geom_point(size = 3) +
      geom_smooth(method = lm, fullrange = TRUE, color = "black")  + 
      geom_point(data = exclude, fill = NA, color = "black", alpha = 0.25, size = 3) +
      xlab(attributes(scatter.data)$names[index.scatter1]) + ylab(attributes(scatter.data)$names[index.depVar])
    return(ggplot(keep[complete.cases(keep), ], aes_string(x = attributes(scatter.data)$names[index.scatter1], y = attributes(scatter.data)$names[index.depVar])) + geom_point(size = 3) +
             geom_smooth(method = lm, fullrange = TRUE, color = "black")  + 
             geom_point(data = exclude, fill = NA, color = "black", alpha = 0.25, size = 3) +
             xlab(attributes(scatter.data)$names[index.scatter1]) + ylab(attributes(scatter.data)$names[index.depVar]))
  } else if (isolate(input$linNon.1 == "Non-Linear")){
    report$scattereins<-ggplot(keep[complete.cases(keep), ], aes_string(x = attributes(scatter.data)$names[index.scatter1], y = attributes(scatter.data)$names[index.depVar])) + geom_point(size = 3) +
      geom_smooth(method = "loess", level = 0.95, fullrange = TRUE, color = "black")  + 
      geom_point(data = exclude, fill = NA, color = "black", alpha = 0.25, size = 3) +
      xlab(attributes(scatter.data)$names[index.scatter1]) + ylab(attributes(scatter.data)$names[index.depVar])
    return(ggplot(keep[complete.cases(keep), ], aes_string(x = attributes(scatter.data)$names[index.scatter1], y = attributes(scatter.data)$names[index.depVar])) + geom_point(size = 3) +
             geom_smooth(method = "loess", level = 0.95, fullrange = TRUE, color = "black")  + 
             geom_point(data = exclude, fill = NA, color = "black", alpha = 0.25, size = 3) +
             xlab(attributes(scatter.data)$names[index.scatter1]) + ylab(attributes(scatter.data)$names[index.depVar]))
  }
  
  
},height = 400, width = 500)

# hier im Tab Data Analysis via visualisation:
# Funktion die beim Klicken auf den 1. Scatterplot ausgefuehrt wird.
observeEvent(input$scatter1_click, {
  
  if(input$scatter.1.lags == ""){return()}
  
  scatter.data <- as.tbl(daten.under$data.temp.1)
  index.depVar <- which(attributes(scatter.data)$names == input$depscattereins)
  index.scatter1 <- which(attributes(scatter.data)$names == input$indepscattereins)
  
  lags.scatter <- input$scatter.1.lags
  depVar.data <- scatter.data[ , index.depVar]
  indepVar.data <- scatter.data[ , - index.depVar]
  
  if(lags.scatter > 0){
    indepVar.data <- indepVar.data[ -((length(indepVar.data[[1]]) - lags.scatter + 1):length(indepVar.data[[1]])), ]
    depVar.data <- depVar.data[-(1:lags.scatter), ]
    scatter.data <- cbind(depVar.data, indepVar.data)
    index.depVar <- 1
    index.scatter1 <- which(attributes(scatter.data)$names == input$indepscattereins)
  }
  
  res <- nearPoints(scatter.data, input$scatter1_click, allRows = TRUE)
  daten.under$keeprows.1 <- xor(daten.under$keeprows.1, res$selected_)
  
})

# hier im Tab Data Analysis via visualisation:
# Toggle points that are brushed, when button is clicked
observeEvent(input$exclude_toggle.1, {
  
  scatter.data <- as.tbl(daten.under$data.temp.1)
  index.depVar <- which(attributes(scatter.data)$names == input$depscattereins)
  index.scatter1 <- which(attributes(scatter.data)$names == input$indepscattereins)
  
  lags.scatter <- input$scatter.1.lags
  depVar.data <- scatter.data[ , index.depVar]
  indepVar.data <- scatter.data[ , - index.depVar]
  
  if(lags.scatter > 0){
    indepVar.data <- indepVar.data[ -((length(indepVar.data[[1]]) - lags.scatter + 1):length(indepVar.data[[1]])), ]
    depVar.data <- depVar.data[-(1:lags.scatter), ]
    scatter.data <- cbind(depVar.data, indepVar.data)
    index.depVar <- 1
    index.scatter1 <- which(attributes(scatter.data)$names == input$indepscattereins)
  }
  
  res <- brushedPoints(scatter.data, input$scatter1_brush, allRows = TRUE)
  
  daten.under$keeprows.1 <- xor(daten.under$keeprows.1, res$selected_)
})

# hier im Tab Data Analysis via visualisation:
# Funktion: Um alle entfernten Punkte  des 1. Scatter plots wiederherzustellen
observeEvent(input$exclude_reset.1, {
  daten.under$keeprows.1 <- rep(TRUE, nrow(daten.under$data.temp.1))
})

# hier im Tab Data Analysis via visualisation: 
# Dynamische Ueberschrift fuer den 1. Scatter-Plot
output$scatt.1 <- renderUI({
  input$printscatter1
  isolate({
    name <- input$indepscattereins
    namezwei <-input$depscattereins
    lags <- input$scatter.1.lags
    kind <- input$linNon.1
    h4(strong(paste(namezwei, " vs ", name, " with ", as.character(lags), "time lag(s) - ", kind, "Fit", sep = " ")))
  })
  
})

# hier im Tab Data Analysis via visualisation:
# Diese Funktion organisiert die Ausgabe des unteren (2. rechter Scatterplot) einer unabhaengigen Variable gegen die Abhaenngige.
output$scatterPlots2 <- renderPlot({
  
  input$printscatter2
  
  isolate({
    
    
    if(is.null(input$indepscatterzwei) | is.null(input$linNon.1) | identical(input$indepscatterzwei, NA)){return()}
    else {
      
      
      scatter.data <- as.tbl(daten.under$data.temp.2)
      index.depVar <- which(attributes(scatter.data)$names == input$depscatterzwei)
      index.scatter2 <- which(attributes(scatter.data)$names == input$indepscatterzwei)
      
      lags.scatter <- input$scatter.2.lags
      depVar.data <- scatter.data[ , index.depVar]
      indepVar.data <- scatter.data[ , - index.depVar]
      
      if(lags.scatter > 0){
        indepVar.data <- indepVar.data[ -((length(indepVar.data[[1]]) - lags.scatter + 1):length(indepVar.data[[1]])), ]
        depVar.data <- depVar.data[-(1:lags.scatter), ]
        scatter.data <- cbind(depVar.data, indepVar.data)
        index.depVar <- 1
        index.scatter2 <- which(attributes(scatter.data)$names == input$indepscatterzwei)
      }
    }
  })
  
  
  keep <- as.tbl(scatter.data[ daten.under$keeprows.2, , drop = FALSE])
  exclude <- as.tbl(scatter.data[ !daten.under$keeprows.2, , drop = FALSE])
  
  par(mfrow=c(2,2))
  
  if(isolate(input$linNon.2 == "Linear")){
    report$scatterzwei<-ggplot(keep[complete.cases(keep), ], aes_string(x = attributes(scatter.data)$names[index.scatter2], y = attributes(scatter.data)$names[index.depVar])) + geom_point(size = 3) +
      geom_smooth(method = lm, fullrange = TRUE, color = "black")  + 
      geom_point(data = exclude, fill = NA, color = "black", alpha = 0.25, size = 3) +
      xlab(attributes(scatter.data)$names[index.scatter2]) + ylab(attributes(scatter.data)$names[index.depVar])
    return(ggplot(keep[complete.cases(keep), ], aes_string(x = attributes(scatter.data)$names[index.scatter2], y = attributes(scatter.data)$names[index.depVar])) + geom_point(size = 3) +
             geom_smooth(method = lm, fullrange = TRUE, color = "black")  + 
             geom_point(data = exclude, fill = NA, color = "black", alpha = 0.25, size = 3) +
             xlab(attributes(scatter.data)$names[index.scatter2]) + ylab(attributes(scatter.data)$names[index.depVar]))
  } else if(isolate(input$linNon.2 == "Non-Linear")){
    report$scatterzwei<-ggplot(keep[complete.cases(keep), ], aes_string(x = attributes(scatter.data)$names[index.scatter2], y = attributes(scatter.data)$names[index.depVar])) + geom_point(size = 3) +
      geom_smooth(method = "loess", level = 0.95, fullrange = TRUE, color = "black")  + 
      geom_point(data = exclude, fill = NA, color = "black", alpha = 0.25, size = 3) +
      xlab(attributes(scatter.data)$names[index.scatter2]) + ylab(attributes(scatter.data)$names[index.depVar])
    return(ggplot(keep[complete.cases(keep), ], aes_string(x = attributes(scatter.data)$names[index.scatter2], y = attributes(scatter.data)$names[index.depVar])) + geom_point(size = 3) +
             geom_smooth(method = "loess", level = 0.95, fullrange = TRUE, color = "black")  + 
             geom_point(data = exclude, fill = NA, color = "black", alpha = 0.25, size = 3) +
             xlab(attributes(scatter.data)$names[index.scatter2]) + ylab(attributes(scatter.data)$names[index.depVar]))
  }
  
  
  
},height = 400, width = 500)


# hier im Tab Data Analysis via visualisation:
# Funktion die beim Klicken auf den 1. Scatterplot ausgefuehrt wird.
observeEvent(input$scatter2_click, {
  
  if(input$scatter.2.lags == ""){return()}
  
  
  scatter.data <- as.tbl(daten.under$data.temp.2)
  index.depVar <- which(attributes(scatter.data)$names == input$depscatterzwei)
  index.scatter2 <- which(attributes(scatter.data)$names == input$indepscatterzwei)
  
  lags.scatter <- input$scatter.2.lags
  depVar.data <- scatter.data[ , index.depVar]
  indepVar.data <- scatter.data[ , - index.depVar]
  
  if(lags.scatter > 0){
    indepVar.data <- indepVar.data[ -((length(indepVar.data[[1]]) - lags.scatter + 1):length(indepVar.data[[1]])), ]
    depVar.data <- depVar.data[-(1:lags.scatter), ]
    scatter.data <- cbind(depVar.data, indepVar.data)
    index.depVar <- 1
    index.scatter2 <- which(attributes(scatter.data)$names == input$indepscatterzwei)
  }
  
  
  res <- nearPoints(scatter.data, input$scatter2_click, allRows = TRUE)
  daten.under$keeprows.2 <- xor(daten.under$keeprows.2, res$selected_)
  
})

# hier im Tab Data Analysis via visualisation:
# Toggle points that are brushed, when button is clicked
observeEvent(input$exclude_toggle.2, {
  
  scatter.data <- as.tbl(daten.under$data.temp.2)
  index.depVar <- which(attributes(scatter.data)$names == input$depscatterzwei)
  index.scatter2 <- which(attributes(scatter.data)$names == input$indepscatterzwei)
  
  lags.scatter <- input$scatter.2.lags
  depVar.data <- scatter.data[ , index.depVar]
  indepVar.data <- scatter.data[ , - index.depVar]
  
  if(lags.scatter > 0){
    indepVar.data <- indepVar.data[ -((length(indepVar.data[[1]]) - lags.scatter + 1):length(indepVar.data[[1]])), ]
    depVar.data <- depVar.data[-(1:lags.scatter), ]
    scatter.data <- cbind(depVar.data, indepVar.data)
    index.depVar <- 1
    index.scatter2 <- which(attributes(scatter.data)$names == input$indepscatterzwei)
  }
  
  res <- brushedPoints(scatter.data, input$scatter2_brush, allRows = TRUE)
  daten.under$keeprows.2 <- xor(daten.under$keeprows.2, res$selected_)
})

# hier im Tab Data Analysis via visualisation:
# Funktion: Um alle entfernten Punkte  des 2. Scatter plots wiederherzustellen
observeEvent(input$exclude_reset.2, {
  daten.under$keeprows.2 <- rep(TRUE, nrow(daten.under$data.temp.2))
})

# hier im Tab Data Analysis via visualisation:
# Dynamische Ueberschrift fuer den 2. Scatter-Plot
output$scatt.2 <- renderUI({
  input$printscatter2
  isolate({
    
    name <- input$indepscatterzwei
    namezwei<-input$depscatterzwei
    lags <- input$scatter.2.lags
    kind <- input$linNon.2
    h4(strong(paste(namezwei, " vs ", name, " with ", as.character(lags), "time lag(s) - ", kind, "Fit", sep = " ")))
  })
})


############################################################################ ab hier Scatter Matrix
########################################################################################################################################################

# hier im Tab Data Analysis via visualisation: Scatter Matrix
# Auswahl der Variablen für die Scatter matrix
output$variablesscattermatrix <- renderUI({
  
  vis.data <- daten.under$base[ ,sapply(daten.under$base, is.numeric)]
  vis.names <- colnames(vis.data)
  selectizeInput("variablesscattermatrix", "Select variables for scatter matrix", vis.names, selected = NULL, multiple = TRUE,
                 options = NULL)
  
})

# hier im Tab Data Analysis via visualisation: Scatter Matrix
# nach dürcken des Buttons "Plot scatter matrix" wird Output der Scattermatrix berechnet (es müssen mindestens 2 und maximal 5 Variablen gewaelt werden)
scattermatrix <- eventReactive(input$plotmatrix,{
  
  if(length(input$variablesscattermatrix) < 2){return(withProgress(message = "Choose at least two variables", Sys.sleep(1.5)))}
  if(length(input$variablesscattermatrix) > 5){return(withProgress(message = "Too many variables", Sys.sleep(1.5)))}
  vis.data <- daten.under$base[ ,sapply(daten.under$base, is.numeric)]
  vis.data <- vis.data[, input$variablesscattermatrix]
  vis.data<-data.frame(vis.data)
  report$scattermatrix<-ggscatmat(vis.data, alpha=0.8)
  return(ggscatmat(vis.data, alpha=0.8))
})


# hier im Tab Data Analysis via visualisation: Scatter Matrix
# output des Scattermatrix
output$scattermatrix<- renderPlot({
  
  if(is.null(scattermatrix())){return()}
  scattermatrix()
  
})




############################################################################ab hier Data Analysis, Analysis via visualisation, Data visualisation
######################################################################################################################################################################

# hier im Tab Data Analysis via visualisation: Data visualisation
#diese renderUI gibt die Auswahl der Variablen (drop down menu) bei Data visualisation wieder (läuft alles unter plot all compare (plotallcomp))
output$depvarplotallcomp <- renderUI({
  
  cor.data <- daten.under$base[ ,sapply(daten.under$base, is.numeric)]
  colnames <- names(cor.data)
  selectInput("depvarplotallcomp", NULL,
              choices = colnames)
})

# hier im Tab Data Analysis via visualisation: Data visualisation
# Organisieren der Auswahlliste fuer die zu vergleichenden Variablen
output$comparePlot <- renderUI({
  
  vis.data <- daten.under$base[ ,sapply(daten.under$base, is.numeric)]
  vis.names <- colnames(vis.data)
  vis.names <- vis.names[-which(input$depvarplotallcomp == vis.names)]
  selectizeInput("compare", "Select variables to compare with target variable", vis.names, selected = NULL, multiple = TRUE,
                 options = NULL)
  
})

# hier im Tab Data Analysis via visualisation: Data visualisation
# Organisieren der Auswahlmoeglichkeiten der Variablen fuer die Visualisierung nicht-lineare Relations
output$nonLinearPlot <- renderUI({
  
  names <- input$compare
  names <- c(names,input$depvarplotallcomp)
  
  selectInput("nonLinVarPlot", "Select variable", choices = names)
  
})

# hier im Tab Data Analysis via visualisation: Data visualisation
# Sobald eine neue Anpassung der ausgewaehlten Daten erfolgt wird die Ausgabetabelle
# der modifizierten Variablen auf Default gesetzt
observeEvent(input$compare, {
  
  validate(
    need(!is.null(input$compare), "")
  )
  
  names.var <- input$compare
  names.var <- c(names.var, input$depvarplotallcomp)
  default.frame <- data.frame()
  
  for(i in 1:length(names.var)){
    if(i == 1){
      default.frame <- data.frame(Variable = as.character(names.var[i]), "Data modified" = "Original", Lag = 0) 
      default.frame[[1]] <- as.character(default.frame[[1]])
      default.frame[[2]] <- as.character(default.frame[[2]])
      default.frame[[3]] <- as.numeric(default.frame[[3]])
    }else {
      default.frame <- rbind(default.frame, c(names.var[i], "Original", 0))
      default.frame[[3]] <- as.numeric(default.frame[[3]])
    }
  }
  
  plot.variable$tabelle.relation <- default.frame
  daten.under$daten.non.linear <- daten.under$base[ ,sapply(daten.under$base, is.numeric)]
  plot.variable$tabelle.korrelation <- data.frame()
  
})

# hier im Tab Data Analysis via visualisation: Data visualisation
# Anpassung der Modifikationstabelle auf Basis der aktuellen Modifikation
# der ausgewaehlten Variable
observeEvent(input$accept, {
  
  validate(
    need(!is.null(input$compare), "")
  )
  
  name <- input$nonLinVarPlot
  pos.name <- which(plot.variable$tabelle.relation[[1]] == name)
  pos.data <- which(colnames(daten.under$daten.non.linear) == name)
  x <- daten.under$daten.non.linear.konstant[[pos.data]]
  
  
  if(grepl("x", input$nonLinRelation) == FALSE){return()}
  
  if(any(input$nonLinRelation,x))
    result <- tryCatch({
      eval(parse(text = input$nonLinRelation))
    }, error = function(e){
      x
    })
  
  if(!is.null(result)){
    daten.under$daten.non.linear[[pos.data]] <- result
  }
  
  if((!identical(result, x) || input$nonLinRelation == "x") && !is.null(result)){
    plot.variable$tabelle.relation[pos.name, 2] <- input$nonLinRelation
  }
  
  plot.variable$tabelle.relation[pos.name, 3] <- input$nonLinLag
})


# hier im Tab Data Analysis via visualisation: Data visualisation
# hier kann die nich-linear Beziehung wieder gelöscht werden nach drücken des Buttons Reset
observeEvent(input$resetnonlinear,{
  name <- input$nonLinVarPlot
  pos.name <- which(plot.variable$tabelle.relation[[1]] == name)
  daten.under$daten.non.linear[[input$nonLinVarPlot]] <- daten.under$base[[input$nonLinVarPlot]]
  plot.variable$tabelle.relation[pos.name,2] <-"Original"
  plot.variable$tabelle.relation[pos.name,3] <-0
  print(daten.under$non.linear)
  
})


# hier im Tab Data Analysis via visualisation: Data visualisation
# Ausgabe der Modifikationstabelle
output$modNOnLin <- renderDataTable({
  
  plot.variable$tabelle.relation
  
}, options = list(pagination = FALSE,searching = FALSE,paging = FALSE))

# hier im Tab Data Analysis via visualisation: Data visualisation
# Erstellung der Dygraphen und Ausgabe der dieser auf Basis der Non-Linear Relations und Time lags
non.linear.plots <- eventReactive(input$plotAllComp, {
  
  validate(
    need(!is.null(input$compare), "Please select variables to compare")
  )
  
  name.dep.var <- input$depvarplotallcomp
  
  dat.vis <- daten.under$daten.non.linear
  namen.relevant <- input$compare
  namen.relevant <- c(namen.relevant, input$depvarplotallcomp)
  index.var <- sapply(colnames(dat.vis), function(x) x %in% namen.relevant)
  
  # In der Variable "dat.vis.relevant" befinden sich nun die relevanten und gegebenenfalls modifizierten
  # Daten der ausgewÃƒÂ¤hlten Variablen.
  dat.vis.relevant <- dat.vis[ ,index.var]
  
  
  # Diese werden zur Vergleich- und Darstellbarkeit nun skaliert
  dat.vis.relevant <- as.data.frame(apply(dat.vis.relevant, 2, function(x) (x - mean(x, na.rm = TRUE))/sd(x, na.rm = TRUE)))
  
  index.dep.var <- which(colnames(dat.vis.relevant) == input$depvarplotallcomp)
  ts.iterativ <- xts(dplyr::select(dat.vis.relevant, index.dep.var), daten.under$base[[1]])
  
  for(i in 1:length(namen.relevant)){
    if(namen.relevant[i] != input$depvarplotallcomp){
      index.temp.name <- which(colnames(dat.vis.relevant) == namen.relevant[i])
      index.temp.lag <- which(plot.variable$tabelle.relation[[1]] == namen.relevant[i])
      ts.temp <- xts(dplyr::select(dat.vis.relevant, index.temp.name), daten.under$base[[1]])
      ts.iterativ <- cbind(ts.iterativ, ts.temp)
    }
  }
  colnames(ts.iterativ) <- c(input$depvarplotallcomp, namen.relevant[- which(namen.relevant == input$depvarplotallcomp)])
  
  regression.plot <- dygraph(ts.iterativ, main = "Data visualization") %>% dyRangeSelector() %>%
    dyLegend(width = 800) %>% dyOptions(drawPoints = TRUE, pointSize = 2)
  
  report$plotAllCompzwei<-ts.iterativ
  
  dat.vis.relevant <- as.data.frame(ts.iterativ)
  
  # Erstellen und Modifizieren der Korrleationstabelle basierend auf Data-Modifikation(z.B. exp(x)) und time-lags
  korrelation <- as.data.frame(apply(dplyr::select(dat.vis.relevant, -1), 2, function(x) cor(x, dplyr::select(dat.vis.relevant, 1), use = "complete.obs")))
  
  mod.temp <- character()
  lags.temp <- numeric()
  
  
  
  for(j in 1:length(korrelation[[1]])){
    index.temp.mod <- which(plot.variable$tabelle.relation[[1]] == rownames(korrelation)[j])
    mod.temp <- c(mod.temp, plot.variable$tabelle.relation[index.temp.mod, 2])
    lags.temp <- c(lags.temp, plot.variable$tabelle.relation[index.temp.mod,3])
  }
  
  korrelation <- cbind(korrelation, mod.temp, lags.temp)
  
  report$plotAllComp<-regression.plot
  
  
  colnames(korrelation) <- c("Correlation", "Data modified", "Time lags")
  plot.variable$tabelle.korrelation <- korrelation
  
  regression.plot
})

# hier im Tab Data Analysis via visualisation: Data visualisation
# Ausgabe des Graphen auf Basis der ausgewÃƒÂ¤hlten Variablen und deren Modifikationen
output$compGraph <- renderDygraph({
  
  non.linear.plots()
  
})

# hier im Tab Data Analysis via visualisation: Data visualisation
# Ausgabe der Korrelations, Modifikations, Lag -Tabelle unter dem resultierenden Dygraph
output$tableCor <- renderDataTable({
  
  if(dim(plot.variable$tabelle.korrelation)[1] == 0) return()
  
  correlation.time.lag <- cbind(rownames(plot.variable$tabelle.korrelation), plot.variable$tabelle.korrelation)
  colnames(correlation.time.lag)[1] <- "Variable"
  
  return(correlation.time.lag)
  
},options = list(pagination = FALSE,searching = FALSE,paging = FALSE))



###################################################################################ab hier Data Analysis, Analysis via correlation
######################################################################################################################################################################

# hier im Tab Data Analysis via correlation:
# reactive Value für lag_cor_table
lag<-reactiveValues(cortable = 0)

# hier im Tab Data analysis, Analysis via correlation
# Diese Funktion erstellt eine Tabelle mit Lags einer gewaehlten unabhaengigen Variable ("Choose dependent variable") und deren resultierende
# Korrelation mit der abhaebgigen Variable.
output$lag_cor_table <- renderTable({
  if(lag$cortable == 0){return()}
  lag$cortable
})

# hier im Tab Data analysis, Analysis via correlation
# Event nach drücken des buttons "Show Table" wird Correlations Tabelle unter Time lag analysis angezeigt
observeEvent(input$cortablebutton,{
  if(is.null(input$depVar)){return()}
  if(is.null(input$indepVar)){return()}
  if(!is.numeric(input$lag)){return()}
  if(input$lag == 0) return()
  if(input$indepVar == ""){return()}
  cor.data <- daten.under$base[ ,sapply(daten.under$base, is.numeric)]
  index.dep.var <- which(attributes(cor.data)$names == input$depVar)
  index.indep.var <- which(attributes(cor.data)$names == input$indepVar)
  lag$cortable<-cor.lag(cor.data[[index.dep.var]], cor.data[[index.indep.var]], input$lag)
  
})



# hier im Tab Data analysis, Analysis via correlation, Correlation analysis
# Berechnung der Korrelationsmatrix in Abhaengigkeit der gewaehlten unabhaengigen Variablen
# sowie 9 timelags
cortables <- reactive({
  
  # Berechnung Lag-Korrelationsmatrix
  cor.data <- daten.under$base[ ,sapply(daten.under$base, is.numeric)]
  index.dep.var <- which(attributes(cor.data)$names == input$depVar)
  cor.data <- as.tbl(cor.data)
  reg.daten <- cor.data[ ,-index.dep.var]
  dep.daten <- cor.data[ ,index.dep.var]
  
  cor.table <- data.frame()
  for(i in 1:length(reg.daten)){
    cor.temp <- cor.lag(cor.data[[index.dep.var]], reg.daten[[i]], 0)[[1]]
    for(j in 1:9){
      
      cor.temp <- c(cor.lag(cor.data[[index.dep.var]], reg.daten[[i]], j)[[1]])
    }
    cor.table <- rbind(cor.table, cor.temp)
  }
  colnames(cor.table) <- 0:9
  rownames(cor.table) <- attributes(reg.daten)$names
  
  # Berechnung Kollinearitätsmatrix
  cor.ind.var <- cor(cor.data, use = "pairwise.complete.obs")
  
  # Berechnung Max-Kollinearität
  cor.ind.var.temp <- cor.ind.var
  
  for(i in 1:ncol(cor.ind.var.temp)){
    cor.ind.var.temp[i, i] <- 0 
  }
  
  corresp.var <- apply(cor.ind.var.temp, 2, function(x) return(which.max(abs(x))))
  
  val <- c()
  for(j in 1:ncol(cor.ind.var.temp)){
    val <- c(val, cor.ind.var.temp[j, corresp.var[j]])
  }
  
  max.col <- data.frame("Variable" = colnames(cor.ind.var.temp),
                        "Corresponding variable" = colnames(cor.ind.var.temp)[corresp.var],
                        "Kollinearität" = round(val, 2))
  
  
  return(list(cor.table, cor.ind.var, max.col))
  
})

# hier im Tab Data analysis, Analysis via correlation
# Ausgabe der Time-Lag/Korrelationstabelle für alle moeglichen unabhaengigen Variablen
output$lag.all <- renderDataTable({
  input$depVar
  report$correlationtablehole<-cbind("Variable" = rownames(cortables()[[1]]), round(cortables()[[1]], digits = 2))
  
  #corrr<<-  cbind("Variable" = rownames(cortables()[[1]]), round(cortables()[[1]], digits = 2))
  cbind("Variable" = rownames(cortables()[[1]]), round(cortables()[[1]], digits = 2))
  
})


# hier im Tab Data analysis, Analysis via correlation
# Ausgabe der höchsten Correlationen unter Tab correlation Analysis (Tab highest correlation)
output$lag.highest.all<-renderDataTable({
  corrtable<-cbind("Variable" = rownames(cortables()[[1]]), round(cortables()[[1]], digits = 2))
  corresp.var <- apply(corrtable[,2:11], 1, function(x) return(which.max(abs(x))))
  corresp.var.lag<-apply(corrtable[,2:11], 1, function(x) return(max(abs(x))))
  corresp.var<-as.data.frame(corresp.var)
  for(i in 1: nrow(corrtable)){corresp.var[i,1]<-corresp.var[i,1]-1}
  corresp.var<-cbind(corrtable[,1], corresp.var.lag, corresp.var)
  names(corresp.var)<-c("Variables", "Correlation" ,"Lag")
  corresp.var
  
})

# hier im Tab Data analysis, Analysis via correlation
# Ausgabe der Korrleationen der moeglichen unabhaengigen Variablen (unter Collinearity analysis)
output$korrelation_ind <- renderDataTable({
   
  cbind("Variable" = rownames(cortables()[[2]]), round(cortables()[[2]], digits = 2))
  
}, options = list(scrollX = TRUE))

# hier im Tab Data analysis, Analysis via correlation
# Ausgabe der hoechsten Kollinearitaet einer jeden moeglichen
# unabhaengigen Variable.
output$maxKol <- renderDataTable({
  
  cortables()[[3]]
  
})

###################################################### ab hier Automatische Reportgenerierung unter Reporting
###################################################### ###################################################### ###################################################### 

# diese reactive Values dienen alle der Reportgenerierung unter 7.Reporting
report<-reactiveValues(
  plots = list(),
  zwischenspeicher = 0, 
  scattereins = 0,
  scatterzwei = 0,
  scattermatrix = 0,
  plotAllComp = 0,
  plotAllCompzwei = 0,
  matrices = list(),
  timeseriesplotAllComp = list(),
  korrelationtableplotAllComp = 0,
  correlationtablehole = 0,
  regression.store.plot = 0,
  prediction.results = 0,
  savedfinalforecastgraph = 0,
  collcorr = 0
  
)

# hier im Tab Data analysis, Analysis via visualisation, unter Scatter Plot
# hier wird durch drücken des Buttons "Add to Reportlist" des Scatterplot sowie der eingegebene Name als reactiver Value gespeichert. Es ist nur die Speicherung
# von 2 scatterplots möglich (falls schon 2 gespeichert sind folgt Meldung - ebenso wenn kein Name eingetragen wurde)
observeEvent(input$acceptscattereinsreport, {
  
  if(length(names(report$plots)) == 2){return(withProgress(message = "No more scatter plots possible", Sys.sleep(1.5)))}
  if(input$namescattereinsreport == ""){return(withProgress(message = "Please enter a name", Sys.sleep(1.5)))}
  
  withProgress(message = "Added to reportlist", Sys.sleep(1.5))
  report$plots[[input$namescattereinsreport]] <- report$scattereins  
  
})

# hier im Tab Data analysis, Analysis via visualisation, unter Scatter Plot
# analog scatter eins oben
observeEvent(input$acceptscatterzweireport, {
  
  if(input$namescatterzweireport == ""){return(withProgress(message = "Please enter a name", Sys.sleep(1.5)))}
  
  if(length(names(report$plots)) == 2){return(withProgress(message = "No more scatter plots possible", Sys.sleep(1.5)))}
  
  withProgress(message = "Added to reportlist", Sys.sleep(1.5))
  report$plots[[input$namescatterzweireport]] <- report$scatterzwei 
  
})

# hier im Tab Data analysis, Analysis via visualisation, unter Scatter Matrix
# analog zu scatter plots oben
observeEvent(input$acceptscattermatrixreport, {
  
  if(input$namescattermatrixreport == ""){return(withProgress(message = "Please enter a name", Sys.sleep(1.5)))}
  
  if(length(names(report$matrices)) == 2){return(withProgress(message = "No more matrix graphs possible", Sys.sleep(1.5)))}
  withProgress(message = "Added to reportlist", Sys.sleep(1.5))
  report$matrices[[input$namescattermatrixreport]] <- report$scattermatrix

})

# hier im Tab Data analysis, Analysis via visualisation, unter Data visualisation
# analog zu scatter plots und matrices kann hier eine timeseries abgespeichert werden (läuft im folgenden alles unter timeseriesplotallcomp)
observeEvent(input$acceptplotAllCompreport, {
  
  print(input$nameplotAllCompreport)
  
  if(input$nameplotAllCompreport == ""){return(withProgress(message = "Please enter a name", Sys.sleep(1.5)))}
  
  if(length(report$timeseriesplotAllComp) == 1){return(withProgress(message = "No more timeseries possible", Sys.sleep(1.5)))}
  withProgress(message = "Added to reportlist", Sys.sleep(1.5))
  report$timeseriesplotAllComp[[input$nameplotAllCompreport]] <- report$plotAllComp
  report$korrelationtableplotAllComp<- plot.variable$tabelle.korrelation
  
})


# hier im Tab Data analysis, Analysis via correlation
# durch drücken des Buttons "Add to reportlist" wird die Correlationstable zur Reportlist unter 7.Reporting hinzugefühgt (als reactiver Value gespeichert)
observeEvent(input$addreportcorrelation, {
  
  index<-which(report$collcorr == "Correlation table")
  
  if(length(index) >0){return(withProgress(message = "Table already added to reportlist", Sys.sleep(1.5)))}
  if(report$collcorr == 0){
    withProgress(message = "Added to reportlist", Sys.sleep(1.5))
    return(report$collcorr<-"Correlation table")
    
  }
  withProgress(message = "Added to reportlist", Sys.sleep(1.5))
  report$collcorr<-c(report$collcorr, "Correlation table")
  
})


# hier im Tab Data analysis, Analysis via correlation
# durch drücken des Buttons "Add to reportlist" wird die Collinearity Table zur Reportlist unter 7.Reporting hinzugefühgt (als reactiver Value gespeichert)
observeEvent(input$addreportcollinearity, {
  print(report$collcorr)

  index<-which(report$collcorr == "Collinearity table")
  
  if(length(index) >0){return(withProgress(message = "Table already added to reportlist", Sys.sleep(1.5)))}
  if(report$collcorr == 0){
    withProgress(message = "Added to reportlist", Sys.sleep(1.5))
    return(report$collcorr<-"Collinearity table")
    
  }
  withProgress(message = "Added to reportlist", Sys.sleep(1.5))
  report$collcorr<-c(report$collcorr, "Collinearity table")
  
})


######hier folgen die Hilfstexte nach drücken der jeweiligen Fragezeichen
#########################################################################

output$texthelp7<-renderUI({
  
  textInput("test", "Enter name for...")
  #  p("Visualize the corresponding data pairs of the dependent variable and an potential independent variable in a scatter plot. By choosing a time lag the belonging scatter plots will be automatically updated.
  #  A linear relation along with a confidence interval will be displayed as well."))
})



output$texthelp8<-renderUI({
  "Choose a potential independent variable and analyze possible time lags regarding the dependent 
  variable to use this information to determine a more sophisticated prediction model later on."
})

output$texthelp9<-renderUI({
  "Lags and related correlation:
  The table below displays the correlation between the chosen dependent variable and all potential independent variables for 9 time lags."
})


output$texthelp10<-renderUI({
  "Collinearity of independent variables: 
  The table below displays the correlation between the possible independent variables to detect Collinearity."
})

output$texthelp11<-renderUI({
  "The table below displays the highest collinearities between the possible independent variables"
})



output$texthelp12<-renderUI({
  "Select different variables to compare and make sure the dependent variable is included.Determine non-linear relation to 
  modify chosen variable for correlation analysis. Type formulas like log(x), x^2, exp(x) , x is handeled as a synonym of 
  the chosen variable. Then choose an amount of lags to visualize and measure related impact. The table above is automatically generated 
  whenever variables for comparison are selected.  Press the button below to accept manipulation (lags, non-linear-relation) of an single variable. 
  The table above will be automatically updated."
})


output$texthelp13<-renderUI({
  "Choose variable to analyze and visualize potential distribution. 
  If a larger value of bins is selected the corresponding Histogram will have a finer structure.
  If the button below is pressed, a distribution fitting based on the chosen variable is performed. "
})

output$texthelp132<-renderUI({
  "Choose the dependent variable. The dependent variable will be your target variable for the regression modell and will be forecasted at the end"
})


############################################## Ab hier Visualisierung der Verteilungen ########################################

# Aufbereitung eines Drop-Down-Menues, aus dem Variablen fuer eine Verteilungsbetrachtung ausgewaehlt werden koennen.
output$distVariabel <- renderUI({
    
    vis.data <- daten.under$base[ ,sapply(daten.under$base, is.numeric)]
    vis.names <- colnames(vis.data)
    
    selectInput("distVar",label = h4(strong("Select variable")), vis.names)
    
})

# Recative Generierung des Histograms sowie der Auswertung der Verteilungsbetrachtung fuer die ausgewaelte Variable
histoDist <- eventReactive(input$plotdistr, {
  
  hist.daten <- as.data.frame(daten.under$base[ ,sapply(daten.under$base, is.numeric)])
  name.data  <- input$distVar
  relevant.hist <- as.data.frame(hist.daten[ ,which(colnames(hist.daten) == name.data)])
  
  bins.hist <- (max(relevant.hist, na.rm = TRUE) - min(relevant.hist, na.rm = TRUE))/input$binsHist
  histogram.dens <- ggplot(hist.daten, aes_string(x = hist.daten[ ,which(colnames(hist.daten) == name.data)]))+
    xlab(name.data) +
    geom_histogram(binwidth = bins.hist, aes(y = ..density..), colour = "black", fill = "grey")
  
  verteilungen.temp <- verteilungsBetrachtung(relevant.hist)
  
  list(histogram.dens,
       h4(strong(paste("Histogram of", name.data, sep = " "))),
       verteilungen.temp[[1]],
       verteilungen.temp[[2]],
       h4(strong("Statistical evaluation")))
  
})

# Ausgabeplot (Histogram) der gewaehlten Variable "distVar" mit ueberlagerter Verteilungsfunktion
verteilung.overlay <- reactive({
  input$fitHisto
  input$plotdistr
  
  isolate({
    if(input$select.fit == "keine") return(histoDist()[[1]])
    distFuns <- histoDist()[[3]]
    if(!is.list(distFuns)) return(histoDist()[[1]])
    index <- 0
    
    for(i in seq(length(distFuns))){
      if(input$select.fit == distFuns[[i]]$distname){
        index <- i
        break()
      }
    }
    if(index == 0){
      return(histoDist()[[1]])
    } else {
      return(histoDist()[[1]] +
               stat_function(fun = paste("d",distFuns[[index]]$distname, sep = ""), args = c(distFuns[[index]]$estimate), colour = "red", size=1.5))
    }
  })
})

# Ausgabe des Histograms
output$histggPlot <- renderPlot({
  
  verteilung.overlay()
  
})

# Ausgabe Ueberschrift
output$headerHist <- renderUI({
  
  histoDist()[[2]]
  
})

# Ausgabe der Auswertung des Fitting-Ergebnisses
output$distEval <- renderTable({
  
  histoDist()[[4]]
  
})

# Ausgabe Ueberschrift Auswertungstabelle
output$headerEval <- renderUI({
  
  histoDist()[[5]]
  
})



output$namelagscattereins<-renderUI({
  
  if(is.null(input$indepscattereins)){return()}
  numericInput("scatter.1.lags", paste("Time lags of", input$indepscattereins) , min = 0, value = 0)
  
})



output$namelagscatterzwei<-renderUI({
  
  if(is.null(input$indepscatterzwei)){return()}
  numericInput("scatter.2.lags", paste("Time lags of", input$indepscatterzwei), min = 0, value = 0)
  
})

output$choosevariablesUnscaledtimeseries<-renderUI({
  
  cor.data <- daten.under$base[ ,sapply(daten.under$base, is.numeric)]
  colnames <- names(cor.data)
  selectInput("variablesUnscaledtimeseries", NULL, multiple = TRUE,
              choices = colnames)
  
})


unscaledtimeseriesdygraph<- eventReactive(input$plotAllunscaledComp, {
  
  
  validate(
    need(!is.null(input$variablesUnscaledtimeseries), "Please select variables to compare")
  )
  
  name.dep.var <- input$variablesUnscaledtimeseries
  
  dat.vis <- daten.under$base
  index.var <- sapply(colnames(dat.vis), function(x) x %in% name.dep.var)
  
  # In der Variable "dat.vis.relevant" befinden sich nun die relevanten und gegebenenfalls modifizierten
  # Daten der ausgewÃƒÂ¤hlten Variablen.
  dat.vis.relevant <- dat.vis[ ,index.var]
  
  hhh<<-xts(dat.vis.relevant, daten.under$base[[1]])
  
  datendygraph<- xts(dat.vis.relevant, daten.under$base[[1]])
  
  timeseriesplotUnscales<-dygraph(datendygraph, main = "Timeseries unscaled") %>% dyRangeSelector() %>%
    dyLegend(width = 800) %>% dyOptions(drawPoints = TRUE, pointSize = 2)
  
  
})

output$unscaledtimeseriesplot<-renderDygraph({
  
  unscaledtimeseriesdygraph()
  
})
##################
output$boxplotvariablesscaled<-renderUI({
  
  cor.data <- daten.under$base[ ,sapply(daten.under$base, is.numeric)]
  colnames <- names(cor.data)
  selectInput("variablesboxplotsscaled", h4("Choose variables"), multiple = TRUE,
              choices = colnames)
  
})

boxplotsgraphscaled<- reactive({
  
  input$plotboxplotsscaled
  input$showdatapointsboxplotscaled
  
  isolate({
    
    
    if(length(input$variablesboxplotsscaled) == 0 ){return(withProgress(message = "Please choose a variable", Sys.sleep(1.5)))}
    
    if(length(input$variablesboxplotsscaled) >5 ){return(withProgress(message = "No more than 5 variables possible", Sys.sleep(1.5)))}
    
    
    validate(
      need(!is.null(input$variablesboxplotsscaled), "Please select variables to compare")
    )
    
    
    name.dep.var <- input$variablesboxplotsscaled
    
    dat.vis <- daten.under$base
    index.var <- sapply(colnames(dat.vis), function(x) x %in% name.dep.var)
    
    dat.vis.relevant <- dat.vis[ ,index.var]
    
    dat.vis.relevant <- as.data.frame(apply(dat.vis.relevant, 2, function(x) (x - mean(x, na.rm = TRUE))/sd(x, na.rm = TRUE)))
    
    if(input$showdatapointsboxplotscaled == FALSE & length(input$variablesboxplotsscaled) == 1){
      
      
      allboxplots<-boxplot(dat.vis.relevant, main = paste("Box plot of ", input$variablesboxplotsscaled), varwidth = TRUE, horizontal = TRUE)
      
      allboxplots
      
    }
    
    else if(input$showdatapointsboxplotscaled == FALSE & length(input$variablesboxplotsscaled) > 1){
      
      allboxplots<-boxplot(dat.vis.relevant, main = "Box plots", varwidth = TRUE, horizontal = TRUE)
      
      allboxplots
      
    }
    
    
    else if(input$showdatapointsboxplotscaled == TRUE & length(input$variablesboxplotsscaled) > 1){
      
      allboxplots<-boxplot(dat.vis.relevant, main = "Box plots", varwidth = TRUE, horizontal = TRUE)
      
      allboxplots
      
      for(i in 1: length(input$variablesboxplotsscaled)){
        
        myjitter <- jitter(rep(i, nrow(dat.vis.relevant[i])), amount=0.1)
        points(t(dat.vis.relevant[i]), myjitter, pch=20, col=rgb(0,0,0,.5))
      }
      
    }
    
    else if(input$showdatapointsboxplotscaled == TRUE & length(input$variablesboxplotsscaled) == 1){
      
      allboxplots<-boxplot(dat.vis.relevant, main = paste("Box plot of ", input$variablesboxplotsscaled), varwidth = TRUE, horizontal = TRUE)
      
      allboxplots
      
      
      myjitter <- jitter(rep(1, nrow(dat.vis.relevant[1])), amount=0.1)
      points(t(dat.vis.relevant[1]), myjitter, pch=20, col=rgb(0,0,0,.5))
      
    }
    
  })
  
})


output$boxplotsAllscaled<-renderPlot({
  
  boxplotsgraphscaled()
  
})




###################################
output$boxplotvariables<-renderUI({
  
  cor.data <- daten.under$base[ ,sapply(daten.under$base, is.numeric)]
  colnames <- names(cor.data)
  selectInput("variablesboxplots", h4("Choose variables"), multiple = TRUE,
              choices = colnames)
  
})

boxplotsgraph<- reactive({
  
  input$plotboxplots
  input$showdatapointsboxplot
  
  isolate({
    
    
    if(length(input$variablesboxplots) == 0 ){return(withProgress(message = "Please choose a variable", Sys.sleep(1.5)))}
    
    if(length(input$variablesboxplots) >5 ){return(withProgress(message = "No more than 5 variables possible", Sys.sleep(1.5)))}
    
    
    validate(
      need(!is.null(input$variablesboxplots), "Please select variables to compare")
    )
    
    
    name.dep.var <- input$variablesboxplots
    
    dat.vis <- daten.under$base
    index.var <- sapply(colnames(dat.vis), function(x) x %in% name.dep.var)
    
    dat.vis.relevant <- dat.vis[ ,index.var]
    
    print(input$showdatapointsboxplot)
    
    if(input$showdatapointsboxplot == FALSE & length(input$variablesboxplots) == 1){
      
      
      allboxplots<-boxplot(dat.vis.relevant, main = paste("Box plot of ", input$variablesboxplots), varwidth = TRUE, horizontal = TRUE)
      
      allboxplots
      
    }
    
    else if(input$showdatapointsboxplot == FALSE & length(input$variablesboxplots) > 1){
      
      allboxplots<-boxplot(dat.vis.relevant, main = "Box plots",  varwidth = TRUE, horizontal = TRUE)
      
      allboxplots
      
    }
    
    
    else if(input$showdatapointsboxplot == TRUE & length(input$variablesboxplots) > 1){
      
      allboxplots<-boxplot(dat.vis.relevant, main = "Box plots",  varwidth = TRUE, horizontal = TRUE)
      
      allboxplots
      
      for(i in 1: length(input$variablesboxplots)){
        
        myjitter <- jitter(rep(i, nrow(dat.vis.relevant[i])), amount=0.1)
        points(t(dat.vis.relevant[i]), myjitter, pch=20, col=rgb(0,0,0,.5))
      }
      
    }
    
    else if(input$showdatapointsboxplot == TRUE & length(input$variablesboxplots) == 1){
      
      allboxplots<-boxplot(dat.vis.relevant, main = paste("Box plot of ", input$variablesboxplots), varwidth = TRUE, horizontal = TRUE)
      
      allboxplots
      
      
      myjitter <- jitter(rep(1, nrow(dat.vis.relevant[1])), amount=0.1)
      points(t(dat.vis.relevant[1]), myjitter, pch=20, col=rgb(0,0,0,.5))
      
    }
    
  })
  
})


output$boxplotsAll<-renderPlot({
  
  boxplotsgraph()
  
})














