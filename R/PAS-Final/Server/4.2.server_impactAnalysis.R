# Wird gerade nicht in der App verwendet, aber bitte trotzdem anschauen (@Fraunhofer)

# Dieses Drop-Down organisiert die Auswahl der verschiedenen zur Verfuegung stehenden Modelle (automatisch, manuell, stored)
output$chooseModel <- renderUI({
  
  input$storeReg
  input$storeRegAuto
  
  validate({
    need(length(regression.modelle$gespeichertes.modell) != 1 || length(regression.modelle$manuelles.modell) != 1 ||
           length(regression.modelle$automatisches.modell) != 1 , "No models determined until now")
  })
  
  erg.ui.list <- list()
  
  erg.ui.list[[2]] <- p("The", strong("Drop-Down above"), "contains all", strong("currently claculated"),
                        "prediction models stationed in the tab", strong("'Create a prediction model'."))
  if (length(regression.modelle$gespeichertes.modell) != 1 && length(regression.modelle$manuelles.modell) != 1 &&
      length(regression.modelle$automatisches.modell) != 1){
    erg.ui.list[[1]] <- (selectInput("modells", label = h3(strong("Choose model to analyze")), choices = c("Automatic model", "Manual model", "Stored model")))
  } else if (length(regression.modelle$gespeichertes.modell) != 1 && length(regression.modelle$manuelles.modell) != 1){
    erg.ui.list[[1]] <- (selectInput("modells", label = h3(strong("Choose model to analyze")), choices = c("Manual model", "Stored model")))
  } else if(length(regression.modelle$gespeichertes.modell) != 1 && length(regression.modelle$automatisches.modell) != 1){
    erg.ui.list[[1]] <- (selectInput("modells", label = h3(strong("Choose model to analyze")), choices = c("Automatic model", "Stored model")))
  } else if(length(regression.modelle$manuelles.modell) != 1 && length(regression.modelle$automatisches.modell) != 1){
    erg.ui.list[[1]] <- (selectInput("modells", label = h3(strong("Choose model to analyze")), choices = c("Automatic model", "Manual model")))
  } else if(length(regression.modelle$manuelles.modell) != 1){
    erg.ui.list[[1]] <- (selectInput("modells", label = h3(strong("Choose model to analyze")), choices = c("Manual model")))
  } else if(length(regression.modelle$automatisches.modell) != 1){
    erg.ui.list[[1]] <- (selectInput("modells", label = h3(strong("Choose model to analyze")), choices = c("Automatic model")))
  }

  erg.ui.list[[3]] <- actionButton("plotSpider", "Display heatmap")
  
  return(erg.ui.list)
})

# Wird nicht verwendet und muss nicht angeschaut werden (organisiert "nur" einen Spider-Plot)
# Folgender Reactive-Output handelt das Erstellen und Ausgeben der modellspezifischen Spider-Diagramme
spider.plot <- eventReactive(input$plotSpider, {
  
  regression.temp <- 0
  
  modell.type <- input$modells
  
  if(modell.type == "Manual model"){
    regression.temp <- regression.modelle$manuelles.modell
  } else if(modell.type == "Automatic model"){
    regression.temp <- regression.modelle$automatisches.modell
  } else if(modell.type == "Stored model"){
    regression.temp <- regression.modelle$gespeichertes.modell
  }
  
  
  beta.coefficients.temp.1 <- as.data.frame(t(regression.temp[[5]]))
  required.names <- names(regression.temp[[1]]$coefficients)[-1][names(regression.temp[[1]]$coefficients[-1])
                                                                 %in% (attributes(regression.temp[[2]])$names)]
  
  index.var <- sapply(required.names, function(x) x %in% colnames(beta.coefficients.temp.1))
  beta.coefficients.temp <- dplyr::select(beta.coefficients.temp.1, which(index.var == TRUE))
  
  # Erstellung des Radar Charts
  max.beta <- max(beta.coefficients.temp)
  min.beta <- min(beta.coefficients.temp)
  
  count.variables <- dim(beta.coefficients.temp)[2]
  
  beta.coefficients.temp <- rbind(rep(max.beta, count.variables), rep(min.beta, count.variables), beta.coefficients.temp)
  
  beta.coefficients.temp <- round(beta.coefficients.temp, 2)
  beta.coefficients.temp <- as.data.frame(beta.coefficients.temp)
  rownames(beta.coefficients.temp) <- c("Maximum", "Minimum", "Standardized coefficents")
  
  spider.graph <- radarchart(beta.coefficients.temp, axistype=1, pcol=1 , plty=1,
                             caxislabels = round(seq(min.beta, max.beta, length.out = 5), 1))
  
  # Aufbereitung barPlot
  beta.coefficients.temp <- dplyr::select(beta.coefficients.temp.1, which(index.var == TRUE))
  beta.coefficients.temp <- as.data.frame(round(beta.coefficients.temp, 2))
  beta.coefficients.temp <- rbind(colnames(beta.coefficients.temp), beta.coefficients.temp)
  beta.coefficients.temp.3 <- as.data.frame(t(beta.coefficients.temp))
  colnames(beta.coefficients.temp.3) <- c("Names", "Values")
  
  beta.coefficients.temp.3[[2]] <- as.numeric(levels(beta.coefficients.temp.3[[2]]))[beta.coefficients.temp.3[[2]]]
  beta.coefficients.temp.3$colour <- ifelse(beta.coefficients.temp.3$Values < 0, "firebrick1","steelblue")
  
  bar.plot.temp <- ggplot(beta.coefficients.temp.3, aes_string(x = "Names", y = "Values")) + geom_bar(stat="identity", width=.5, aes(fill = colour)) +
    xlab("Predictors") + ylab("Standardized coefficents") + coord_flip()
  
  return(list(spider.graph, bar.plot.temp))
})

# Organisation der Ausgabe des Spider-Diagramms
#   output$spider <- renderPlot({
#   
#     validate(
#       need(length(spider.plot()) != 0, "")
#     )
#     
#     if(isolate(input$plotKind) == "Radar chart"){
#       spider.plot()[[1]]
#     }else if(isolate(input$plotKind) == "Bar chart"){
#       spider.plot()[[2]]
#     }
#     
#   })

# Organisiert die Ausgabe der modellspezifischen Heatmap
output$heatMap <- renderD3heatmap({
  
  validate(
    need(length(table.beta()) != 0, "")
  )
  
  table.beta()[[2]]
})


# Ausgabe der berechneten Koeffizienten und sowie der standardisierten Koeffizienten in einer Heatmap
# In dieser koennen die einflussreichsten Predictoren ausgelesen werden.
table.beta <- eventReactive(input$plotSpider, {
  
  regression.temp <- 0
  
  modell.type <- input$modells
  
  if(modell.type == "Manual model"){
    regression.temp <- regression.modelle$manuelles.modell
  } else if(modell.type == "Automatic model"){
    regression.temp <- regression.modelle$automatisches.modell
  } else if(modell.type == "Stored model"){
    regression.temp <- regression.modelle$gespeichertes.modell
  }
  
  beta.coefficients.temp <- as.data.frame(t(regression.temp[[5]]))
  required.names <- names(regression.temp[[1]]$coefficients)[-1][names(regression.temp[[1]]$coefficients[-1])
                                                                 %in% (attributes(regression.temp[[2]])$names)]
  
  index.var <- sapply(required.names, function(x) x %in% colnames(beta.coefficients.temp))
  beta.coefficients.temp <- dplyr::select(beta.coefficients.temp, which(index.var == TRUE))
  
  coeff.model <- as.data.frame(t(regression.temp[[1]]$coefficients[-1]))
  coeff.model <- dplyr::select(coeff.model, which(index.var == TRUE))
  perc.coeff.model <- (coeff.model/regression.temp[[6]][length(regression.temp[[6]])]) * 100
  
  sd.variables <- as.data.frame(t(sapply(regression.temp[[2]], function(x) sd(x, na.rm = TRUE))))
  sd.index <- sapply(colnames(sd.variables), function(x) x %in% required.names)
  sd.variables <- dplyr::select(sd.variables, which(sd.index == TRUE))
  
  print(sd.variables)
  print(beta.coefficients.temp)
  change.ind.var <- beta.coefficients.temp * sd.variables
  change.dep.var <- beta.coefficients.temp * sd(regression.temp[[6]], na.rm = TRUE)
  perc.coeff.model.sd <- (change.dep.var/regression.temp[[6]][length(regression.temp[[6]])]) * 100
  
  #ratio.beta.sd <- beta.coefficients.temp / sd.variables
  #test.value <- change.dep.var / sd.variables
  erg.table <- rbind(coeff.model, perc.coeff.model, beta.coefficients.temp, sd.variables, change.dep.var, perc.coeff.model.sd)
  heat.is.on <- erg.table
  rownames(heat.is.on) <- c("Var. per unit", "Perc. var per unit",
                            "Stand. coeff.", "S.d.",
                            "Var. per s.d.", "Perc var. per s.d.")
  
  heatmap.erg <- d3heatmap(t(heat.is.on), scale = "column", Rowv =  FALSE, Colv = FALSE, xaxis_font_size = "10pt", yaxis_font_size = "10pt")
  
  rownames(erg.table) <- c("Variation per change of one unit", "Percent variation per change of one unit", "Standardized coefficients",
                           "Standard deviation independent variable", "Variation per change of one s.d", "Percent variation per change of one sd ")

  return(list(erg.table, heatmap.erg))
  
})

# Ausgabe der Auswertungstablellen-Ueberschrift
header.beta <- eventReactive(input$plotSpider,{
  
  model.kind <- input$modells
  return(h3(strong(paste("Impact analysis of", as.character(model.kind), sep = " "))))
})

# Ausgabe Heatmap-Ueberschrift
header.heat <- eventReactive(input$plotSpider, {
  
  model.kind <- input$modells
  return(h3(strong(paste("Corresponding Heatmap of", as.character(model.kind), sep =  " "))))
  
})

# Ausgabe der Heatmap-Ueberschrit in der UI
output$headerHeat <- renderUI({
  
  header.heat()
  
})
# Ausgabe der oben berechneten Tablle
output$betaCoeff <- renderTable({
  
  table.beta()[[1]]
  
})

# Ausgabe der zur Auswertungstabelle gehoerigen Ueberschrift
output$headerBeta <- renderUI({
  
  header.beta()
  
})