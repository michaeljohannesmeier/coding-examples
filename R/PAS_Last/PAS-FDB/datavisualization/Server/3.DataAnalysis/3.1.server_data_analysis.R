

########################################################################################################################################################
######################################### reactive Values ##################################################################################
####################################################################################################################################################################


# Determinierung der globalen Variablen fuer die Generierung der Timeseries-Plots 
plot.variable <- reactiveValues(
  
  tabelle.relation = data.frame(),
  tabelle.korrelation = data.frame()
  
)


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

############################################################################ ab hier Scatterplots (2-5D Scatterplots)
########################################################################################################################################################
#das ist die UI, die erscheint, falls die Dimension 2 gew?hlt wurde. 
#es wird ?berpr?ft, ob ein Haken bei "Show second scatter" gemacht wurde (je nachdem wird nur die Eingabe von 2 Variablen und 2 Lags oder die Eingabe von 4 Variablen und
#4 Lags m?glich)

output$switchVariablesTwoFour <- renderUI({
  cor.data <- daten.under$base[,-1]
  colnames <- names(cor.data)
  if(input$scatterSecond == TRUE){
    return(list(
      fluidRow(
        column(width = 6,
               fluidRow(
                 column(width = 4,
                        selectInput("threeDvariableOne", "Choose x axis",
                                    choices = colnames),
                        numericInput("lagThreeDScatterOne", "Number of Lags", value = "0")
                 ),
                 column(width = 4,
                        selectInput("threeDvariableTwo", "Choose y axis",
                                    choices = colnames),
                        numericInput("lagThreeDScatterTwo", "Number of Lags", value = "0")
                 ),
                 column(width =4,
                        radioButtons("loessLm", "Choose fit", c("Linear" = "lm", "Loess" = "loess"))
                 )
               )
        ),
        column(width = 6,
               fluidRow(
                 column(width = 4,
                        selectInput("threeDvariableOneSecond", "Choose x axis",
                                    choices = colnames),
                        numericInput("lagThreeDScatterOneSecond", "Number of Lags", value = "0")
                 ),
                 column(width = 4,
                        selectInput("threeDvariableTwoSecond", "Choose y axis",
                                    choices = colnames),
                        numericInput("lagThreeDScatterTwoSecond", "Number of Lags", value = "0")
                 ),
                 column(width =4,
                        radioButtons("loessLmSecond", "Choose fit", c("Linear" = "lm", "Loess" = "loess"))
                 )
               )
        )
      )
    ))
  }
  if(input$scatterSecond == FALSE){
    return(list(
      fluidRow(
        column(width = 6,
               fluidRow(
                 column(width = 4,
                        selectInput("threeDvariableOne", "Choose x axis",
                                    choices = colnames),
                        numericInput("lagThreeDScatterOne", "Number of Lags", value = "0")
                 ),
                 column(width = 4,
                        selectInput("threeDvariableTwo", "Choose y axis",
                                    choices = colnames),
                        numericInput("lagThreeDScatterTwo", "Number of Lags", value = "0")
                 ),
                 column(width =4,
                        radioButtons("loessLm", "Choose fit", c("Linear" = "lm", "Loess" = "loess"))
                 )
               )
        )
      )
    ))
  }
  
})
# hier wird die Eingabe der Lags der Variablen bei den Scatterplots ausgeblendet, sobald das Datum als Variable gew?hlt wurde
output$lagDate <- renderUI({
  if(is.null(input$threeDvariableThree)){return()}
  scatter.data <- daten.under$base
  indexVarThree <- which(attributes(scatter.data)$names == input$threeDvariableThree)
  if(is.Date(scatter.data[, indexVarThree]) == TRUE){return()}
  numericInput("lagThreeDScatterThree", "Number of Lags", value = "0")
  
})

# hier ist die eigentliche HauptUI.
#Die UI ver?ndert ihre SelectInput Felder, je nachdem, wie viele Dimensionen ?ber den SliderInput gew?hlt wurden
output$chooseVariablesThreeDScatter <- renderUI({
  
  # hier werden colnames minus Date, Md = minus date und alle colnames generiert
  cor.data <- daten.under$base[,-1]
  colnamesMd <- names(cor.data)
  colnamesAll <- names(daten.under$base)
  
  #hier wird ?berpr?ft, ob kategoriale Variablen im Datensatz vorkommen 
  minusCategor <- vector()
  for(i in 1:ncol(daten.under$base)){
    if(is.factor(daten.under$base[,i])){
      minusCategor <- c(minusCategor, i)
    }
  }
  
  #falls kategoriale Variablen vorkommen, dann werden die nicht bei allen SelectInputs angezeigt (Mc = minus categorial, Md = minus date)
  ifelse(length(minusCategor)==0, colnamesPlusDateMc <- names(daten.under$base), colnamesPlusDateMc <- names(daten.under$base)[-minusCategor])
  ifelse(length(minusCategor)==0, colnamesMdMc <- names(daten.under$base)[-1], colnamesMdMc <- names(daten.under$base)[-c(1,minusCategor)])
  
  if(input$chooseDimsScatter3d == 2){
    return(list(
      checkboxInput("scatterSecond", "Show second scatter", value = FALSE),
      uiOutput("switchVariablesTwoFour")
    ))
  }
  
  if(input$chooseDimsScatter3d == 3){
    return(list(
      fluidRow(
        column(width = 4,
               selectInput("threeDvariableOne", "Choose x axis",
                           choices = colnamesMd),
               numericInput("lagThreeDScatterOne", "Number of Lags", value = "0")
        ),
        column(width = 4,
               selectInput("threeDvariableTwo", "Choose y axis",
                           choices = colnamesMd),
               numericInput("lagThreeDScatterTwo", "Number of Lags", value = "0")
        ),
        column(width = 4,
               selectInput("threeDvariableThree", "Choose z axis/color (categorial/date)",
                           choices = colnamesAll),
               uiOutput("lagDate")
        )
      ),
      fluidRow(column(width = 12, checkboxInput("showColorScatter", "3rd dimension as color", value = FALSE)))
    ))
  }
  
  if(input$chooseDimsScatter3d == 4){
    
    return(list(
      fluidRow(
        column(width = 3,
               selectInput("threeDvariableOne", "Choose x axis",
                           choices = colnamesMd),
               numericInput("lagThreeDScatterOne", "Number of Lags", value = "0")
               
        ),
        column(width = 3,
               selectInput("threeDvariableTwo", "Choose y axis",
                           choices = colnamesMd),
               numericInput("lagThreeDScatterTwo", "Number of Lags", value = "0")
        ),
        column(width = 3,
               selectInput("threeDvariableThree", "Choose z axis (date)",
                           choices = colnamesPlusDateMc),
               uiOutput("lagDate")
        ),
        column(width = 3,
               selectInput("threeDvariableFour", "Choose color (categorial)",
                           choices = colnamesMd),
               numericInput("lagThreeDScatterFour", "Number of Lags", value = "0")
        )
      )
    ))
    
  }
  
  if(input$chooseDimsScatter3d == 5){
    
    return(list(
      fluidRow(
        column(width = 2,
               selectInput("threeDvariableOne", "Choose x axis",
                           choices = colnamesMd),
               numericInput("lagThreeDScatterOne", "Number of Lags", value = "0")
               
        ),
        column(width = 2,
               selectInput("threeDvariableTwo", "Choose y axis",
                           choices = colnamesMd),
               numericInput("lagThreeDScatterTwo", "Number of Lags", value = "0")
        ),
        column(width = 2,
               selectInput("threeDvariableThree", "Choose z axis (date)",
                           choices = colnamesPlusDateMc),
               uiOutput("lagDate")
        ),
        column(width = 2,
               selectInput("threeDvariableFour", "Choose color (categorial)",
                           choices = colnamesMd),
               numericInput("lagThreeDScatterFour", "Number of Lags", value = "0")
        ),
        column(width = 2,
               selectInput("threeDvariableFife", "Choose size",
                           choices = colnamesMdMc),
               numericInput("lagThreeDScatterFife", "Number of Lags", value = "0")
        )
      )
    ))
    
  }
  
})


# der Output f?r den Scattergraph wird jeweils in einem reactiven Wert gespeichert (dadurch kann man gut mit ObserveEvent arbeiten)
scatter <- reactiveValues(graph = 0)

output$ThreeDScatterPlot <- renderPlotly({
  if(is.numeric(scatter$graph)){return()}
  scatter$graph
})

# nach Dr?cken der Taste "Print" werden Scatterplots berechnet
observeEvent(input$printThreeDPlot,{
  
  if(!is.numeric(input$lagThreeDScatterOne) | !is.numeric(input$lagThreeDScatterTwo)){
    return(withProgress(message = "Lags must be a positive integer", Sys.sleep(1.5)))
  }
  if(input$lagThreeDScatterOne < 0 | input$lagThreeDScatterTwo < 0 | grepl("[^0-9]",input$lagThreeDScatterOne) | grepl("[^0-9]",input$lagThreeDScatterTwo)){
    return(withProgress(message = "Lags must be a positive integer", Sys.sleep(1.5)))
  }
  
  scatter.data <- data.frame(daten.under$base)
  scatter.dataSecond <- data.frame(daten.under$base)
  indexVarOne <- which(attributes(scatter.data)$names == input$threeDvariableOne)
  indexVarTwo <- which(attributes(scatter.data)$names == input$threeDvariableTwo)
  nameOne<-names(scatter.data)[indexVarOne]
  nameTwo<-names(scatter.data)[indexVarTwo]
  
  #falls eine Lag-Eingabe vorgenommen wird, werden die Daten verschoben (am Anfang werden NAs eingef?gt)
  varOne<- c(rep(NA,input$lagThreeDScatterOne),scatter.data[1:(nrow(scatter.data)-input$lagThreeDScatterOne),indexVarOne])
  dateOne <- c(rep(NA,input$lagThreeDScatterOne),as.character(scatter.data$Date[1:(nrow(scatter.data)-input$lagThreeDScatterOne)]))
  varTwo <- c(rep(NA,input$lagThreeDScatterTwo),scatter.data[1:(nrow(scatter.data)-input$lagThreeDScatterTwo),indexVarTwo])
  dateTwo <- c(rep(NA,input$lagThreeDScatterTwo),as.character(scatter.data$Date[1:(nrow(scatter.data)-input$lagThreeDScatterTwo)]))
  
  #falls zweiter Scater gew?hlt wurde
  if(input$chooseDimsScatter3d == 2 & input$scatterSecond == TRUE){
    if(!is.numeric(input$lagThreeDScatterOneSecond) | !is.numeric(input$lagThreeDScatterTwoSecond)){
      return(withProgress(message = "Lags must be a positive integer", Sys.sleep(1.5)))
    }
    if(input$lagThreeDScatterOneSecond < 0 | input$lagThreeDScatterTwoSecond < 0 | grepl("[^0-9]",input$lagThreeDScatterOneSecond) | grepl("[^0-9]",input$lagThreeDScatterTwoSecond)){
      return(withProgress(message = "Lags must be a positive integer", Sys.sleep(1.5)))
    }
    indexVarOneSecond <- which(attributes(scatter.dataSecond)$names == input$threeDvariableOneSecond)
    indexVarTwoSecond <- which(attributes(scatter.dataSecond)$names == input$threeDvariableTwoSecond)
    nameOneSecond<-names(scatter.dataSecond)[indexVarOneSecond]
    nameTwoSecond<-names(scatter.dataSecond)[indexVarTwoSecond]
    varOneSecond<- c(rep(NA,input$lagThreeDScatterOneSecond),scatter.dataSecond[1:(nrow(scatter.data)-input$lagThreeDScatterOneSecond),indexVarOneSecond])
    dateOneSecond <- c(rep(NA,input$lagThreeDScatterOneSecond),as.character(scatter.data$Date[1:(nrow(scatter.data)-input$lagThreeDScatterOneSecond)]))
    varTwoSecond<- c(rep(NA,input$lagThreeDScatterTwoSecond),scatter.dataSecond[1:(nrow(scatter.data)-input$lagThreeDScatterTwoSecond),indexVarTwoSecond])
    dateTwoSecond <- c(rep(NA,input$lagThreeDScatterTwoSecond),as.character(scatter.data$Date[1:(nrow(scatter.data)-input$lagThreeDScatterTwoSecond)]))
    
  }
  
  if(input$chooseDimsScatter3d > 2){
    if(!is.null(input$lagThreeDScatterThree)){
      if(!is.numeric(input$lagThreeDScatterThree)){
        return(withProgress(message = "Lags must be a positive integer", Sys.sleep(1.5)))
      }
      if(input$lagThreeDScatterThree < 0 | grepl("[^0-9]",input$lagThreeDScatterThree)){
        return(withProgress(message = "Lags must be a positive integer", Sys.sleep(1.5)))
      }
    }
    indexVarThree <- which(attributes(scatter.data)$names == input$threeDvariableThree)
    nameThree<-names(scatter.data)[indexVarThree]
    if(!is.null(input$lagThreeDScatterThree)){
      dateThree <- c(rep(NA,input$lagThreeDScatterThree),as.character(scatter.data$Date[1:(nrow(scatter.data)-input$lagThreeDScatterThree)]))
    }
    if(is.null(input$lagThreeDScatterThree)){
      dateThree <- as.character(scatter.data$Date)
    }
    # hier wird ?berpr?ft, ob als 3.Variable ein Datum oder eine Kategoriale Variable eingegeben wurde, falls ja, dann werden Daten als as.character gespechert (sonst wird das Datum als Zahl angezeigt)
    if(is.Date(scatter.data[, indexVarThree]) == FALSE){
      if(is.factor(scatter.data[, indexVarThree]) == TRUE){
        varThree<- as.factor(c(rep(NA,input$lagThreeDScatterThree),as.character(scatter.data[1:(nrow(scatter.data)-input$lagThreeDScatterThree),indexVarThree])))
      }
      if(is.factor(scatter.data[, indexVarThree]) == FALSE){
        varThree<- c(rep(NA,input$lagThreeDScatterThree),scatter.data[1:(nrow(scatter.data)-input$lagThreeDScatterThree),indexVarThree])
      }
    }
    if(is.Date(scatter.data[, indexVarThree]) == TRUE){
      varThree<- as.character(scatter.data[, indexVarThree])
    }
    
  }
  
  if(input$chooseDimsScatter3d > 3){
    if(is.factor(scatter.data[, indexVarThree]) == FALSE){
      if(!is.numeric(input$lagThreeDScatterFour)){
        return(withProgress(message = "Lags must be a positive integer", Sys.sleep(1.5)))
      }
      if(input$lagThreeDScatterFour < 0 | grepl("[^0-9]",input$lagThreeDScatterFour)){
        return(withProgress(message = "Lags must be a positive integer", Sys.sleep(1.5)))
      }
    }
    indexVarFour <- which(attributes(scatter.data)$names == input$threeDvariableFour)
    nameFour<-names(scatter.data)[indexVarFour]
    dateFour <- c(rep(NA,input$lagThreeDScatterFour),as.character(scatter.data$Date[1:(nrow(scatter.data)-input$lagThreeDScatterFour)]))
    
    # falls eine kategoriale Variable ausgew?hlt wurde, wird diese auch als as.character gespeichert (dadurch wird interaktive Legende m?glich)
    if(is.factor(scatter.data[, indexVarFour]) == TRUE){
      varFour<- as.factor(c(rep(NA,input$lagThreeDScatterFour),as.character(scatter.data[1:(nrow(scatter.data)-input$lagThreeDScatterFour),indexVarFour])))
    }
    if(is.factor(scatter.data[, indexVarFour]) == FALSE){
      varFour<- c(rep(NA,input$lagThreeDScatterFour),scatter.data[1:(nrow(scatter.data)-input$lagThreeDScatterFour),indexVarFour])
    }
    
    if(input$chooseDimsScatter3d > 4){
      if(!is.numeric(input$lagThreeDScatterFife)){
        return(withProgress(message = "Lags must be a positive integer", Sys.sleep(1.5)))
      }
      if(input$lagThreeDScatterFife < 0 | grepl("[^0-9]",input$lagThreeDScatterFife)){
        return(withProgress(message = "Lags must be a positive integer", Sys.sleep(1.5)))
      }
      indexVarFife <- which(attributes(scatter.data)$names == input$threeDvariableFife)
      nameFife <-names(scatter.data)[indexVarFife]
      dateFife <- c(rep(NA,input$lagThreeDScatterFife),as.character(scatter.data$Date[1:(nrow(scatter.data)-input$lagThreeDScatterFife)]))
      if(is.factor(scatter.data[, indexVarFife]) == TRUE){
        varFife<- as.factor(c(rep(NA,input$lagThreeDScatterFife), as.character(scatter.data[1:(nrow(scatter.data)-input$lagThreeDScatterFife),indexVarFife])))
      }
      if(is.factor(scatter.data[, indexVarFife]) == FALSE){
        varFife<- c(rep(NA,input$lagThreeDScatterFife),scatter.data[1:(nrow(scatter.data)-input$lagThreeDScatterFife),indexVarFife])
      }
    }
  }
  
  #im oberen Teil wurden die Variablen gespeichert (ja nach Lag etc.). Ab hier beginnt jetzt die Berechnung der Ausgabe f?r die Plots. Dabei wird wieder ?berpr?ft, 
  # welche Dimension ausgw?hlt wurde
  if(input$chooseDimsScatter3d == 2){
    
    #both Vars ist n?tig, da die Smoother (LM oder Loess) nur complete cases "ausspucken" und es beim Dr?berlegen der Smoother sonst zu Problemen kam
    bothVars <- data.frame(varOne, varTwo, as.character(dateOne), as.character(dateTwo))
    bothVars <- bothVars[complete.cases(bothVars),]
    varOne <- bothVars[,1]
    varTwo <- bothVars[,2]
    dateOne <- bothVars[,3]
    dateTwo <- bothVars[,4]
    if(input$loessLm == "loess"){
      Model<-loess(varTwo ~ varOne)
      nameFit <- "Loess fit"
    }
    if(input$loessLm == "lm"){
      Model <- lm(varTwo ~ varOne)
      nameFit <- "Linear fit"
    }
    # der Teil wiederholt sich hier f?r den 2.ScatterPlot (falls ausgew?hlt)
    if(input$scatterSecond == TRUE){
      bothVars <- data.frame(varOneSecond, varTwoSecond, as.character(dateOneSecond), as.character(dateTwoSecond))
      bothVars <- bothVars[complete.cases(bothVars),]
      varOneSecond <- bothVars[,1]
      varTwoSecond <- bothVars[,2]
      dateOneSecond <- bothVars[,3]
      dateTwoSecond <- bothVars[,4]     
      if(input$loessLmSecond == "loess"){
        ModelSecond<-loess(varTwoSecond ~ varOneSecond)
        nameFitSecond <- "Loess fit (right)"
      }
      
      if(input$loessLmSecond == "lm"){
        ModelSecond <- lm(varTwoSecond ~ varOneSecond)
        nameFitSecond <- "Linear fit (right)"
      }
    } 
    #hier wirde der 1. Plot gebaut
    plot1<-plot_ly(x = varOne, y = varTwo, 
                   hoverinfo = "text",
                   text = ~paste("Date:", dateOne, "<br>", nameOne, ":", varOne, 
                                 "<br>", "Date:", dateTwo, "<br>",nameTwo, ":", varTwo)) %>%
      add_markers(y = varTwo, name = "Scatter points (right)", marker = list(color = input$col1)) %>%
      add_lines(y = Model$fitted,
                line = list(color = input$col2),
                name = nameFit)%>%
      add_ribbons(data = augment(Model),
                  ymin = ~.fitted - 1.96 * .se.fit,
                  ymax = ~.fitted + 1.96 * .se.fit,
                  line = list(color = input$col3),
                  fillcolor = paste0("#50", substr(input$col3, 2, 7)),
                  name = "Standard Error") %>%
      layout(font = list(family = input$ownFont, size = input$sizeOwnFont), xaxis = list(title = nameOne),
             yaxis = list(title = nameTwo))
    
    #hier wird der 2.Scatterplot gebaut
    if(input$scatterSecond == TRUE){
      plot2<-plot_ly(x = varOneSecond, y = varTwoSecond,
                     hoverinfo = "text",
                     text = ~paste("Date:", dateOneSecond, "<br>",nameOneSecond, ":", varOneSecond, "<br>",
                                   "Date:", dateTwoSecond, "<br>",nameTwoSecond, ":", varTwoSecond))%>%
        add_markers(y = varTwoSecond, name = "Scatter points (right)", marker = list(color = input$col4)) %>%
        add_lines(y = ModelSecond$fitted,
                  line = list(color = input$col5),
                  name = nameFitSecond) %>%
        add_ribbons(data = augment(ModelSecond),
                    ymin = ~.fitted - 1.96 * .se.fit,
                    ymax = ~.fitted + 1.96 * .se.fit,
                    line = list(color = input$col6),
                    fillcolor = paste0("#50", substr(input$col6, 2, 7)),
                    name = "Standard Error (right)") %>%
        layout(font = list(family = input$ownFont, size = input$sizeOwnFont), xaxis = list(title = nameOneSecond),
               yaxis = list(title = nameTwoSecond))
    }
    if(input$scatterSecond == FALSE){
      scatter$graph <- plot1
    }
    if(input$scatterSecond == TRUE){
      scatter$graph <- subplot(plot1, plot2, titleX = TRUE, titleY = TRUE)
    }
    
    return(scatter$graph)
  }
  
  # ab hier falls gew?hlte Dimension = 3. Dabei gibt es noch zwei M?glichkeiten. A) 3. Dimension = Farbe oder B) 3. Dimension = z Achse. Zudem wird je noch unterschieden, 
  # ob es sich dabei um eine kategoriale Variable handelt. Dann speichern als as.character (da dann interaktive Legende m?glich wird)
  if(!is.null(input$showColorScatter)){
    
    if(input$chooseDimsScatter3d == 3 & input$showColorScatter == FALSE){
      
      scatter$graph<-plot_ly(x = varOne, y = varTwo, z = varThree, hoverinfo = "text", mode = "markers",
                             marker = list(color = input$col1), text = ~paste("Date:", dateOne, "<br>", nameOne, ":", varOne, "<br>", 
                                                                              "Date:", dateTwo, "<br>", nameTwo, ":", varTwo, "<br>",
                                                                              "Date:", dateThree, "<br>", nameThree, ":", varThree))%>%
        layout(font = list(family = input$ownFont, size = input$sizeOwnFont), scene = list(xaxis = list(title = nameOne),
                                                                                           yaxis = list(title = nameTwo),
                                                                                           zaxis = list(title = nameThree)))
      return(scatter$graph)
    }
    
    if(input$chooseDimsScatter3d == 3 & input$showColorScatter == TRUE & is.factor(scatter.data[, indexVarThree]) == TRUE){
      scatter$graph<-plot_ly(x = varOne, y = varTwo, color = as.factor(varThree), colors = colorRampPalette(c("blue", "black"))(10),
                             hoverinfo = "text",
                             text = ~paste("Date:", dateOne, "<br>", nameOne, ":", varOne, "<br>",
                                           "Date:", dateTwo, "<br>",nameTwo, ":", varTwo, "<br>", 
                                           "Date:", dateThree))%>%
        layout(font = list(family = input$ownFont, size = input$sizeOwnFont), xaxis = list(title = nameOne),
               yaxis = list(title = nameTwo))
      return(scatter$graph)
    }
    if(input$chooseDimsScatter3d == 3 & input$showColorScatter == TRUE & is.factor(scatter.data[, indexVarThree]) == FALSE){
      scatter$graph<-plot_ly(x = varOne, y = varTwo, color = varThree, colors = colorRampPalette(c("blue", "black"))(10),
                             hoverinfo = "text",
                             text = ~paste("Date:", dateOne, "<br>", nameOne, ":", varOne, "<br>",
                                           "Date:", dateTwo, "<br>", nameTwo, ":", varTwo, "<br>",
                                           "Date:", dateThree, "<br>", nameThree, ":", varThree))%>%
        layout(font = list(family = input$ownFont, size = input$sizeOwnFont), xaxis = list(title = nameOne),
               yaxis = list(title = nameTwo))
      return(scatter$graph)
    }
    # if(input$chooseDimsScatter3d == 3){
    #   print("sdlkfsldkfjsdlfklfdslsdjf?lksdfj")
    #   scatter$graph<-plot_ly(x = varOne, y = varTwo, z = varThree, color = I("red"), hoverinfo = "text",
    #                        text = ~paste("Date:", dateOne, "<br>", nameOne, ":", varOne, "<br>", 
    #                        "Date:", dateTwo, "<br>", nameTwo, ":", varTwo, "<br>",
    #                        "Date:", dateThree, "<br>", nameThree, ":", varThree))%>%
    #   layout(scene = list(xaxis = list(title = nameOne),
    #                       yaxis = list(title = nameTwo),
    #                       zaxis = list(title = nameThree)))
    # return(scatter$graph)
    # }
  }
  
  #hier falls Dim = 4. Wieder wird ?berpr?ft, ob kategoriale Variablen dabei sind
  if(input$chooseDimsScatter3d == 4 & is.factor(scatter.data[, indexVarFour]) == FALSE){
    scatter$graph<-plot_ly(x = varOne, y = varTwo, z = varThree, colors = colorRampPalette(c("blue", "black"))(10),
                           color = varFour, hoverinfo = "text",
                           text = ~paste("Date:", dateOne, "<br>", nameOne, ":", varOne, "<br>", 
                                         "Date:", dateTwo, "<br>", nameTwo, ":", varTwo, "<br>",
                                         "Date:", dateThree, "<br>", nameThree, ":", varThree, "<br>", 
                                         "Date:", dateFour, "<br>", nameFour, ":", varFour)) %>%
      add_markers() %>%
      layout(font = list(family = input$ownFont, size = input$sizeOwnFont), scene = list(xaxis = list(title = nameOne),
                                                                                         yaxis = list(title = nameTwo),
                                                                                         zaxis = list(title = nameThree)))
    return(scatter$graph)
  }
  if(input$chooseDimsScatter3d == 4 & is.factor(scatter.data[, indexVarFour]) == TRUE){
    scatter$graph<-plot_ly(x = varOne, y = varTwo, z = varThree, colors = colorRampPalette(c("blue", "black"))(10),
                           color = as.factor(varFour), hoverinfo = "text",
                           text = ~paste("Date:", dateOne, "<br>", nameOne, ":", varOne, "<br>", 
                                         "Date:", dateTwo, "<br>", nameTwo, ":", varTwo, "<br>",
                                         "Date:", dateThree, "<br>", nameThree, ":", varThree, "<br>", 
                                         "Date:", dateFour, "<br>", nameFour, ":", as.character(varFour))) %>%
      add_markers() %>%
      layout(font = list(family = input$ownFont, size = input$sizeOwnFont), scene = list(xaxis = list(title = nameOne),
                                                                                         yaxis = list(title = nameTwo),
                                                                                         zaxis = list(title = nameThree)))
    return(scatter$graph)
  }
  
  # Dim = 5. Wieder check ob categorial variables
  if(input$chooseDimsScatter3d == 5 & is.factor(scatter.data[, indexVarFour]) == TRUE){
    scatter$graph<-plot_ly(x = varOne, y = varTwo, z = varThree, colors = colorRampPalette(c("blue", "black"))(10),
                           color = as.factor(varFour), size = varFife, hoverinfo = "text",
                           marker = list(symbol = 'circle', sizemode = 'diameter'), sizes = c(5, 50),
                           text = ~paste("Date:", dateOne, "<br>", nameOne, ":", varOne, "<br>",
                                         "Date:", dateTwo, "<br>", nameTwo, ":", varTwo, "<br>",
                                         "Date:", dateThree, "<br>", nameThree, ":", varThree, "<br>",
                                         "Date:", dateFour, "<br>", nameFour, ":", varFour, "<br>", 
                                         "Date:", dateFife, "<br>", nameFife, ":", as.character(varFife))) %>%
      add_markers() %>%
      layout(font = list(family = input$ownFont, size = input$sizeOwnFont), scene = list(xaxis = list(title = nameOne),
                                                                                         yaxis = list(title = nameTwo),
                                                                                         zaxis = list(title = nameThree)))
    return(scatter$graph)
  }
  if(input$chooseDimsScatter3d == 5 & is.factor(scatter.data[, indexVarFour]) == FALSE){
    scatter$graph<-plot_ly(x = varOne, y = varTwo, z = varThree, colors = colorRampPalette(c("blue", "black"))(10),
                           color = varFour, size = varFife, hoverinfo = "text",
                           marker = list(symbol = 'circle', sizemode = 'diameter'), sizes = c(5, 50),
                           text = ~paste("Date:", dateOne, "<br>", nameOne, ":", varOne, "<br>", 
                                         "Date:", dateTwo, "<br>", nameTwo, ":", varTwo, "<br>",
                                         "Date:", dateThree, "<br>", nameThree, ":", varThree, "<br>", 
                                         "Date:", dateFour, "<br>", nameFour, ":", varFour, "<br>",
                                         "Date:", dateFife, "<br>", nameFife, ":", varFife)) %>%
      add_markers() %>%
      layout(font = list(family = input$ownFont, size = input$sizeOwnFont), scene = list(xaxis = list(title = nameOne),
                                                                                         yaxis = list(title = nameTwo),
                                                                                         zaxis = list(title = nameThree)))
    return(scatter$graph)
  }
})


########################################################################################################################################################################
############################################################################ Scatter Matrix ########################################################
########################################################################################################################################################

# hier im Tab Data Analysis via visualisation: Scatter Matrix
# Auswahl der Variablen f?r die Scatter matrix
output$variablesscattermatrix <- renderUI({
  
  vis.data <- daten.under$base[ ,sapply(daten.under$base, is.numeric)]
  vis.names <- colnames(vis.data)
  categorialIndex <- vector()


  selectizeInput("variablesscattermatrix", "Select variables for scatter matrix", vis.names, selected = NULL, multiple = TRUE,
                     options = NULL)

})

# hier im Tab Data Analysis via visualisation: Scatter Matrix
# nach d?rcken des Buttons "Plot scatter matrix" wird Output der Scattermatrix berechnet 
scattermatrix <- eventReactive(input$plotmatrix,{

  
  vis.data <- daten.under$base[ ,sapply(daten.under$base, is.numeric)]
  vis.dataDate <- daten.under$base
  vis.data <- vis.data[, input$variablesscattermatrix]
  vis.data <- data.frame(vis.data)
  
  # falls es Probleme gibt, kann hier die alte Version der ScatterMatrizen verwendet werden (ist auch reaktiv)
  #return(ggplotly(ggscatmat(vis.data, alpha=0.8)))
  
  namesPlots <- names(vis.data)
  countPlots <- 1
  plots<- list()
  helpBool <- FALSE

  #i = reihe, j= spalte
  # je nachdem, ob 1. Spalte oder letzte Zeile (oder dazwischen) werden Achsenbeschriftungen ein- oder ausgeblendet
  for(i in 1: length(input$variablesscattermatrix)){
    for(j in 1: length(input$variablesscattermatrix)){
      if(i != j & i > j){
        if(j == 1 & i != length(input$variablesscattermatrix)){
          count <- paste0(i,j)
          if(helpBool == FALSE){
            assign(paste0("datavis", count,1), vis.data[, c(i,j)])
          }
          if(helpBool == TRUE){
            for(k in  1:length(levels(daten.under$base[, indexCategorial]))){
              assign(paste0("datavis", count,k), vis.data[daten.under$base[, indexCategorial] == levels(daten.under$base[, indexCategorial])[k], c(i,j)])
            }
          }
          if(helpBool == FALSE){ 
            plots[[countPlots]] <- plot_ly(x = eval(parse(text = paste0("datavis",count,1, "[,",2,"]"))), y = eval(parse(text = paste0("datavis", count,1,"[,",1,"]"))), 
                                           marker = list(color = eval(parse(text = paste0("input$col",1)))), type = "scatter", mode = "markers", hoverinfo = "text", name = "",
                      text = paste("Date:", vis.dataDate[,1][[1]], "<br>", names(eval(parse(text = paste0("datavis",count,1))))[2], ":",
                                                                eval(parse(text = paste0("datavis",count,1,"[,",2,"]"))), "<br>", names(eval(parse(text = paste0("datavis",count,1))))[1], ":",
                                                                eval(parse(text = paste0("datavis",count,1,"[,",1,"]"))))) %>%
                     layout(font = list(family = input$ownFont, size = input$sizeOwnFont), showlegend = FALSE, xaxis = list(showticklabels = FALSE, zeroline = FALSE))
          }
          if(helpBool == TRUE){
            plots[[countPlots]] <- plot_ly(x = eval(parse(text = paste0("datavis",count,1, "[,",2,"]"))), y = eval(parse(text = paste0("datavis", count,1,"[,",1,"]"))),
                                           showlegend = F, legendgroup = paste0("group",1), marker = list(color = colorRampPalette(c("blue", "black"))(length(levels(daten.under$base[, indexCategorial])))[1]), type = "scatter", mode = "markers", hoverinfo = "text", name = levels(daten.under$base[, indexCategorial])[1],
                      text = paste("Date:", vis.dataDate[daten.under$base[, indexCategorial][[1]] == levels(daten.under$base[, indexCategorial])[1],1], "<br>", names(eval(parse(text = paste0("datavis",count,1))))[2], ":",
                                                        eval(parse(text = paste0("datavis",count,1,"[,",2,"]"))), "<br>", names(eval(parse(text = paste0("datavis",count,1))))[1], ":",
                                                        eval(parse(text = paste0("datavis",count,1,"[,",1,"]")))))%>%
              layout(font = list(family = input$ownFont, size = input$sizeOwnFont), xaxis = list(showticklabels = FALSE, zeroline = FALSE))
            for(k in  2:length(levels(daten.under$base[, indexCategorial]))){
              plots[[countPlots]] <- add_trace(plots[[countPlots]],x = eval(parse(text = paste0("datavis",count,k, "[,",2,"]"))), y = eval(parse(text = paste0("datavis", count,k,"[,",1,"]"))),
                                               showlegend = F, legendgroup = paste0("group",k), marker = list(color = colorRampPalette(c("blue", "black"))(length(levels(daten.under$base[, indexCategorial])))[k]), type = "scatter", mode = "markers", hoverinfo = "text", name = levels(daten.under$base[, indexCategorial])[k],
                      text = paste("Date:", vis.dataDate[daten.under$base[, indexCategorial][[1]] == levels(daten.under$base[, indexCategorial])[k],1], "<br>", names(eval(parse(text = paste0("datavis",count,k))))[2], ":",
                                                          eval(parse(text = paste0("datavis",count,k,"[,",2,"]"))), "<br>", names(eval(parse(text = paste0("datavis",count,k))))[1], ":",
                                                          eval(parse(text = paste0("datavis",count,k,"[,",1,"]")))))%>%
                layout(font = list(family = input$ownFont, size = input$sizeOwnFont), xaxis = list(showticklabels = FALSE, zeroline = FALSE))
            }
          }
        }else if(j == 1 & i == length(input$variablesscattermatrix)){
          count <- paste0(i,j)
          if(helpBool == FALSE){
            assign(paste0("datavis", count,1), vis.data[, c(i,j)])
          }
          if(helpBool == TRUE){
            for(k in  1:length(levels(daten.under$base[, indexCategorial]))){
              assign(paste0("datavis", count,k), vis.data[daten.under$base[, indexCategorial] == levels(daten.under$base[, indexCategorial])[k], c(i,j)])
            }
          }
          if(helpBool == FALSE){ 
            plots[[countPlots]] <- plot_ly(x = eval(parse(text = paste0("datavis",count,1, "[,",2,"]"))), y = eval(parse(text = paste0("datavis", count,1,"[,",1,"]"))),marker = list(color = eval(parse(text = paste0("input$col",1)))), type = "scatter", mode = "markers", hoverinfo = "text", name = "",
                     text = paste("Date:", vis.dataDate[,1][[1]], "<br>", names(eval(parse(text = paste0("datavis",count,1))))[2], ":",
                                                        eval(parse(text = paste0("datavis",count,1,"[,",2,"]"))), "<br>", names(eval(parse(text = paste0("datavis",count,1))))[1], ":",
                                                        eval(parse(text = paste0("datavis",count,1,"[,",1,"]"))))) %>%
                 layout(font = list(family = input$ownFont, size = input$sizeOwnFont), showlegend = TRUE, yaxis = list(zeroline = FALSE), xaxis = list(title = namesPlots[j], zeroline = FALSE))
          }
          if(helpBool == TRUE){
            plots[[countPlots]] <- plot_ly(x = eval(parse(text = paste0("datavis",count,1, "[,",2,"]"))), y = eval(parse(text = paste0("datavis", count,1,"[,",1,"]"))),
                                           legendgroup = paste0("group",1), marker = list(color = colorRampPalette(c("blue", "black"))(length(levels(daten.under$base[, indexCategorial])))[1]), type = "scatter", mode = "markers", hoverinfo = "text", name = levels(daten.under$base[, indexCategorial])[1],
                      text = paste("Date:", vis.dataDate[daten.under$base[, indexCategorial][[1]] == levels(daten.under$base[, indexCategorial])[1],1], "<br>", names(eval(parse(text = paste0("datavis",count,1))))[2], ":",
                                                        eval(parse(text = paste0("datavis",count,1,"[,",2,"]"))), "<br>", names(eval(parse(text = paste0("datavis",count,1))))[1], ":",
                                                        eval(parse(text = paste0("datavis",count,1,"[,",1,"]")))))%>%
              layout(font = list(family = input$ownFont, size = input$sizeOwnFont), yaxis = list(zeroline = FALSE), xaxis = list(title = namesPlots[j], zeroline = FALSE))
            for(k in  2:length(levels(daten.under$base[, indexCategorial]))){
              plots[[countPlots]] <- add_trace(plots[[countPlots]],x = eval(parse(text = paste0("datavis",count,k, "[,",2,"]"))), y = eval(parse(text = paste0("datavis", count,k,"[,",1,"]"))),
                                               legendgroup = paste0("group",k), marker = list(color = colorRampPalette(c("blue", "black"))(length(levels(daten.under$base[, indexCategorial])))[k]), type = "scatter", mode = "markers", hoverinfo = "text", name = levels(daten.under$base[, indexCategorial])[k],
                      text = paste("Date:", vis.dataDate[daten.under$base[, indexCategorial][[1]] == levels(daten.under$base[, indexCategorial])[k],1], "<br>", names(eval(parse(text = paste0("datavis",count,k))))[2], ":",
                                                            eval(parse(text = paste0("datavis",count,k,"[,",2,"]"))), "<br>", names(eval(parse(text = paste0("datavis",count,k))))[1], ":",
                                                            eval(parse(text = paste0("datavis",count,k,"[,",1,"]")))))%>%
                layout(font = list(family = input$ownFont, size = input$sizeOwnFont), yaxis = list(zeroline = FALSE), xaxis = list(title = namesPlots[j], zeroline = FALSE))
            }
          }
        }else if(j!=1 & i != length(input$variablesscattermatrix)){
          count <- paste0(i,j)
          if(helpBool == FALSE){
            assign(paste0("datavis", count,1), vis.data[, c(i,j)])
          }
          if(helpBool == TRUE){
            for(k in  1:length(levels(daten.under$base[, indexCategorial]))){
              assign(paste0("datavis", count,k), vis.data[daten.under$base[, indexCategorial] == levels(daten.under$base[, indexCategorial])[k], c(i,j)])
            }
          }
          if(helpBool == FALSE){ 
              plots[[countPlots]] <- plot_ly(x = eval(parse(text = paste0("datavis",count,1, "[,",2,"]"))), y = eval(parse(text = paste0("datavis", count,1,"[,",1,"]"))),
                                             marker = list(color = eval(parse(text = paste0("input$col",1)))), type = "scatter", mode = "markers", hoverinfo = "text", name = "",
                        text = paste("Date:", vis.dataDate[,1][[1]], "<br>", names(eval(parse(text = paste0("datavis",count,1))))[2], ":",
                                                          eval(parse(text = paste0("datavis",count,1,"[,",2,"]"))), "<br>", names(eval(parse(text = paste0("datavis",count,1))))[1], ":",
                                                          eval(parse(text = paste0("datavis",count,1,"[,",1,"]"))))) %>%
                   layout(font = list(family = input$ownFont, size = input$sizeOwnFont), showlegend = FALSE, xaxis = list(showticklabels = FALSE, zeroline = FALSE), yaxis = list(showticklabels = FALSE, zeroline = FALSE))
          }
          if(helpBool == TRUE){
              plots[[countPlots]] <- plot_ly(x = eval(parse(text = paste0("datavis",count,1, "[,",2,"]"))), y = eval(parse(text = paste0("datavis", count,1,"[,",1,"]"))),
                                             showlegend = F, legendgroup = paste0("group",1), marker = list(color = colorRampPalette(c("blue", "black"))(length(levels(daten.under$base[, indexCategorial])))[1]), type = "scatter", mode = "markers", hoverinfo = "text", name = levels(daten.under$base[, indexCategorial])[1],
                        text = paste("Date:", vis.dataDate[daten.under$base[, indexCategorial][[1]] == levels(daten.under$base[, indexCategorial])[1],1], "<br>", names(eval(parse(text = paste0("datavis",count,1))))[2], ":",
                                                          eval(parse(text = paste0("datavis",count,1,"[,",2,"]"))), "<br>", names(eval(parse(text = paste0("datavis",count,1))))[1], ":",
                                                          eval(parse(text = paste0("datavis",count,1,"[,",1,"]")))))%>%
                layout(font = list(family = input$ownFont, size = input$sizeOwnFont), xaxis = list(showticklabels = FALSE, zeroline = FALSE), yaxis = list(showticklabels = FALSE, zeroline = FALSE))
              for(k in  2:length(levels(daten.under$base[, indexCategorial]))){
                plots[[countPlots]] <- add_trace(plots[[countPlots]],x = eval(parse(text = paste0("datavis",count,k, "[,",2,"]"))), y = eval(parse(text = paste0("datavis", count,k,"[,",1,"]"))),
                                                 showlegend = F, legendgroup = paste0("group",k), marker = list(color = colorRampPalette(c("blue", "black"))(length(levels(daten.under$base[, indexCategorial])))[k]), type = "scatter", mode = "markers", hoverinfo = "text", name = levels(daten.under$base[, indexCategorial])[k],
                        text = paste("Date:", vis.dataDate[daten.under$base[, indexCategorial][[1]] == levels(daten.under$base[, indexCategorial])[k],1], "<br>", names(eval(parse(text = paste0("datavis",count,k))))[2], ":",
                                                              eval(parse(text = paste0("datavis",count,k,"[,",2,"]"))), "<br>", names(eval(parse(text = paste0("datavis",count,k))))[1], ":",
                                                              eval(parse(text = paste0("datavis",count,k,"[,",1,"]")))))%>%
                  layout(font = list(family = input$ownFont, size = input$sizeOwnFont), xaxis = list(showticklabels = FALSE, zeroline = FALSE), yaxis = list(showticklabels = FALSE, zeroline = FALSE))
              }
          }
        }else if(j!=1 & i == length(input$variablesscattermatrix)){
          count <- paste0(i,j)
          if(helpBool == FALSE){
            assign(paste0("datavis", count,1), vis.data[, c(i,j)])
          }
          if(helpBool == TRUE){
            for(k in  1:length(levels(daten.under$base[, indexCategorial]))){
              assign(paste0("datavis", count,k), vis.data[daten.under$base[, indexCategorial] == levels(daten.under$base[, indexCategorial])[k], c(i,j)])
            }
          }
          if(helpBool == FALSE){ 
            plots[[countPlots]] <- plot_ly(x = eval(parse(text = paste0("datavis",count,1, "[,",2,"]"))), y = eval(parse(text = paste0("datavis", count,1,"[,",1,"]"))),marker = list(color = eval(parse(text = paste0("input$col",1)))), type = "scatter", mode = "markers", hoverinfo = "text", name = "",
                       text = paste("Date:", vis.dataDate[,1][[1]], "<br>", names(eval(parse(text = paste0("datavis",count,1))))[2], ":",
                                                        eval(parse(text = paste0("datavis",count,1,"[,",2,"]"))), "<br>", names(eval(parse(text = paste0("datavis",count,1))))[1], ":",
                                                        eval(parse(text = paste0("datavis",count,1,"[,",1,"]"))))) %>%
                 layout(font = list(family = input$ownFont, size = input$sizeOwnFont), showlegend = FALSE, yaxis = list(showticklabels = FALSE, zeroline = FALSE), xaxis = list(title = namesPlots[j], zeroline = FALSE))
          }
          if(helpBool == TRUE){
            plots[[countPlots]] <- plot_ly(x = eval(parse(text = paste0("datavis",count,1, "[,",2,"]"))), y = eval(parse(text = paste0("datavis", count,1,"[,",1,"]"))),
                                           showlegend = F, legendgroup = paste0("group",1), marker = list(color = colorRampPalette(c("blue", "black"))(length(levels(daten.under$base[, indexCategorial])))[1]), type = "scatter", mode = "markers", hoverinfo = "text", name = levels(daten.under$base[, indexCategorial])[1],
                       text = paste("Date:", vis.dataDate[daten.under$base[, indexCategorial][[1]] == levels(daten.under$base[, indexCategorial])[1],1], "<br>", names(eval(parse(text = paste0("datavis",count,1))))[2], ":",
                                                        eval(parse(text = paste0("datavis",count,1,"[,",2,"]"))), "<br>", names(eval(parse(text = paste0("datavis",count,1))))[1], ":",
                                                        eval(parse(text = paste0("datavis",count,1,"[,",1,"]"))))) %>%
              layout(font = list(family = input$ownFont, size = input$sizeOwnFont), yaxis = list(showticklabels = FALSE, zeroline = FALSE), xaxis = list(title = namesPlots[j], zeroline = FALSE))
            for(k in  2:length(levels(daten.under$base[, indexCategorial]))){
              plots[[countPlots]] <- add_trace(plots[[countPlots]],x = eval(parse(text = paste0("datavis",count,k, "[,",2,"]"))), y = eval(parse(text = paste0("datavis", count,k,"[,",1,"]"))),
                                               showlegend = F, legendgroup = paste0("group",k), marker = list(color = colorRampPalette(c("blue", "black"))(length(levels(daten.under$base[, indexCategorial])))[k]), type = "scatter", mode = "markers", hoverinfo = "text", name = levels(daten.under$base[, indexCategorial])[k],
                        text = paste("Date:", vis.dataDate[daten.under$base[, indexCategorial][[1]] == levels(daten.under$base[, indexCategorial])[k],1], "<br>", names(eval(parse(text = paste0("datavis",count,k))))[2], ":",
                                                            eval(parse(text = paste0("datavis",count,k,"[,",2,"]"))), "<br>", names(eval(parse(text = paste0("datavis",count,k))))[1], ":",
                                                            eval(parse(text = paste0("datavis",count,k,"[,",1,"]")))))%>%
                layout(font = list(family = input$ownFont, size = input$sizeOwnFont), yaxis = list(showticklabels = FALSE, zeroline = FALSE), xaxis = list(title = namesPlots[j], zeroline = FALSE))
            }
          }
        }

      }
      if(i == j){
        if(helpBool == TRUE){
          for(k in  1:length(levels(daten.under$base[, indexCategorial]))){
            datafit <- vis.data[daten.under$base[, indexCategorial] == levels(daten.under$base[, indexCategorial])[k],i]
            if(length(datafit[!is.na(datafit)]) > 1){
              assign(paste0("fit", i, k), density(datafit, na.rm = TRUE))
              assign(paste0("fit", i, k, "y"), eval(parse(text = paste0("fit", i, k,"$y"))))
              assign(paste0("fit", i, k, "x"), eval(parse(text = paste0("fit", i, k,"$x"))))
            }
            datafit <- vis.data[daten.under$base[, indexCategorial] == levels(daten.under$base[, indexCategorial])[k],i]
            if(length(datafit[!is.na(datafit)]) < 2){
              datafit <- vis.data[,i]
              assign(paste0("fit", i, k), density(datafit, na.rm = TRUE))
              assign(paste0("fit", i, k, "y"), rep(0, length(eval(parse(text = paste0("fit", i, k,"$y"))))))
              assign(paste0("fit", i, k, "x"), eval(parse(text = paste0("fit", i, k,"$x"))))
            }
          }
        }
        if(helpBool == FALSE){ 
          assign(paste0("fit", i, 1), density(vis.data[,i], na.rm = TRUE))
          assign(paste0("fit", i, 1, "y"), eval(parse(text = paste0("fit", i, 1,"$y"))))
          assign(paste0("fit", i, 1, "x"), eval(parse(text = paste0("fit", i, 1,"$x"))))
        }
        assign(paste0("nameshist",i), names(vis.data))
        if(i != 1 & i != length(input$variablesscattermatrix)){
          if(helpBool == FALSE){ 
            plots[[countPlots]] <- plot_ly(x = eval(parse(text= paste0("fit",i, 1,"x"))), y = eval(parse(text= paste0("fit",i,1,"y"))), type = "scatter", mode = "lines", fill = "tozeroy", hoverinfo = "text",
                line = list(color = eval(parse(text = paste0("input$col",1)))), text = ~paste(eval(parse(text=paste0("nameshist", i)))[i], ":", eval(parse(text= paste0("fit",i,1,"x"))), "<br>", "Density:", eval(parse(text= paste0("fit",i,1,"y"))))) %>%
              layout(font = list(family = input$ownFont, size = input$sizeOwnFont), showlegend = FALSE, xaxis = list(showticklabels = FALSE, zeroline = FALSE), yaxis = list(showticklabels = FALSE))
          }
          if(helpBool == TRUE){ 
            plots[[countPlots]] <- plot_ly(x = eval(parse(text= paste0("fit",i, 1,"x"))), y = eval(parse(text= paste0("fit",i,1,"y"))), type = "scatter", mode = "lines", fill = "tozeroy", hoverinfo = "text",
                   showlegend = F, legendgroup = paste0("group",1), line=list(color = colorRampPalette(c("blue", "black"))(length(levels(daten.under$base[, indexCategorial])))[1]), 
                  name = levels(daten.under$base[, indexCategorial])[1], text = ~paste(eval(parse(text=paste0("nameshist", i)))[i], ":", eval(parse(text= paste0("fit",i,1,"x"))), "<br>", "Density:", eval(parse(text= paste0("fit",i,1,"y")))))%>%
              layout(font = list(family = input$ownFont, size = input$sizeOwnFont), xaxis = list(showticklabels = FALSE, zeroline = FALSE), yaxis = list(showticklabels = FALSE))
            for(k in 2:length(levels(daten.under$base[, indexCategorial]))){
              plots[[countPlots]]<- add_trace(plots[[countPlots]], x = eval(parse(text= paste0("fit",i, k,"x"))), y = eval(parse(text= paste0("fit",i,k,"y"))), type = "scatter", mode = "lines", fill = "tozeroy", hoverinfo = "text",
                     showlegend = F, legendgroup = paste0("group",k), line= list(color = colorRampPalette(c("blue", "black"))(length(levels(daten.under$base[, indexCategorial])))[k]), 
                    name = levels(daten.under$base[, indexCategorial])[k], text = ~paste(eval(parse(text=paste0("nameshist", i)))[i], ":", eval(parse(text= paste0("fit",i,k,"x"))), "<br>", "Density:", eval(parse(text= paste0("fit",i,k,"y"))))) %>%
              layout(font = list(family = input$ownFont, size = input$sizeOwnFont), xaxis = list(showticklabels = FALSE, zeroline = FALSE), yaxis = list(showticklabels = FALSE))
          
            }
          }
        } else if(i == 1){
            if(helpBool == FALSE){ 
              plots[[countPlots]] <- plot_ly(x = eval(parse(text= paste0("fit",i, 1,"x"))), y = eval(parse(text= paste0("fit",i,1,"y"))), type = "scatter", mode = "lines", fill = "tozeroy", hoverinfo = "text",
                   line = list(color = eval(parse(text = paste0("input$col",1)))), text = ~paste(eval(parse(text=paste0("nameshist", i)))[i], ":", eval(parse(text= paste0("fit",i,1,"x"))), "<br>", "Density:", eval(parse(text= paste0("fit",i,1,"y"))))) %>%
                       layout(font = list(family = input$ownFont, size = input$sizeOwnFont), showlegend = FALSE, xaxis = list(showticklabels = FALSE, zeroline = FALSE), yaxis = list(zeroline = FALSE))
            }
            if(helpBool == TRUE){
              plots[[countPlots]] <- plot_ly(x = eval(parse(text= paste0("fit",i, 1,"x"))), y = eval(parse(text= paste0("fit",i,1,"y"))), type = "scatter", mode = "lines", fill = "tozeroy", hoverinfo = "text",
                  showlegend = F, legendgroup = paste0("group",1), line = list(color = colorRampPalette(c("blue", "black"))(length(levels(daten.under$base[, indexCategorial])))[1]), 
                 name = levels(daten.under$base[, indexCategorial])[1], text = ~paste(eval(parse(text=paste0("nameshist", i)))[i], ":", eval(parse(text= paste0("fit",i,1,"x"))), "<br>", "Density:", eval(parse(text= paste0("fit",i,1,"y")))))%>%
                layout(font = list(family = input$ownFont, size = input$sizeOwnFont), xaxis = list(showticklabels = FALSE, zeroline = FALSE), yaxis = list(zeroline = FALSE))
              for(k in 2:length(levels(daten.under$base[, indexCategorial]))){
                plots[[countPlots]]<- add_trace(plots[[countPlots]], x = eval(parse(text= paste0("fit",i, k,"x"))), y = eval(parse(text= paste0("fit",i,k,"y"))), type = "scatter", mode = "lines", fill = "tozeroy", hoverinfo = "text",
                    showlegend = F, legendgroup = paste0("group",k), line = list(color = colorRampPalette(c("blue", "black"))(length(levels(daten.under$base[, indexCategorial])))[k]), 
                    name = levels(daten.under$base[, indexCategorial])[k], text = ~paste(eval(parse(text=paste0("nameshist", i)))[i], ":", eval(parse(text= paste0("fit",i,k,"x"))), "<br>", "Density:", eval(parse(text= paste0("fit",i,k,"y")))))%>%
                  layout(font = list(family = input$ownFont, size = input$sizeOwnFont), xaxis = list(showticklabels = F, zeroline = FALSE), yaxis = list(zeroline = FALSE))
              }
            }
          } else if(i != 1 & i == length(input$variablesscattermatrix)){
            if(helpBool == FALSE){   
              plots[[countPlots]] <- plot_ly(x = eval(parse(text= paste0("fit",i, 1,"x"))), y = eval(parse(text= paste0("fit",i,1,"y"))), type = "scatter", mode = "lines", fill = "tozeroy", hoverinfo = "text",
                  line = list(color = eval(parse(text = paste0("input$col",1)))), text = ~paste(eval(parse(text=paste0("nameshist", i)))[i], ":", eval(parse(text= paste0("fit",i,1,"x"))), "<br>", "Density:", eval(parse(text= paste0("fit",i,1,"y"))))) %>%
                layout(font = list(family = input$ownFont, size = input$sizeOwnFont), margin = list(l= 160, b = 100), showlegend = FALSE, xaxis = list(title = namesPlots[length(input$variablesscattermatrix)], zeroline = FALSE), yaxis = list(zeroline = FALSE, showticklabels = FALSE))
            }  
            if(helpBool == TRUE){
              plots[[countPlots]] <- plot_ly(x = eval(parse(text= paste0("fit",i, 1,"x"))), y = eval(parse(text= paste0("fit",i,1,"y"))), type = "scatter", mode = "lines", fill = "tozeroy", hoverinfo = "text",
                  showlegend = F, legendgroup = paste0("group",1), line = list(color = colorRampPalette(c("blue", "black"))(length(levels(daten.under$base[, indexCategorial])))[1]), 
                 name = levels(daten.under$base[, indexCategorial])[1], text = ~paste(eval(parse(text=paste0("nameshist", i)))[i], ":", eval(parse(text= paste0("fit",i,1,"x"))), "<br>", "Density:", eval(parse(text= paste0("fit",i,1,"y")))))%>%
                layout(font = list(family = input$ownFont, size = input$sizeOwnFont), margin = list(l= 160, b = 100), xaxis = list(title = namesPlots[length(input$variablesscattermatrix)], zeroline = FALSE), yaxis = list(zeroline = FALSE, showticklabels = FALSE))
              for(k in 2:length(levels(daten.under$base[, indexCategorial]))){
                plots[[countPlots]]<- add_trace(plots[[countPlots]], x = eval(parse(text= paste0("fit",i, k,"x"))), y = eval(parse(text= paste0("fit",i,k,"y"))), type = "scatter", mode = "lines", fill = "tozeroy", hoverinfo = "text",
                    showlegend = F, legendgroup = paste0("group",k), line = list(color = colorRampPalette(c("blue", "black"))(length(levels(daten.under$base[, indexCategorial])))[k]), 
                   name = levels(daten.under$base[, indexCategorial])[k], text = ~paste(eval(parse(text=paste0("nameshist", i)))[i], ":", eval(parse(text= paste0("fit",i,k,"x"))), "<br>", "Density:", eval(parse(text= paste0("fit",i,k,"y")))))%>%
                  layout(font = list(family = input$ownFont, size = input$sizeOwnFont), margin = list(l= 160, b = 100), xaxis = list(title = namesPlots[length(input$variablesscattermatrix)], zeroline = FALSE), yaxis = list(zeroline = FALSE, showticklabels = FALSE))
              }
            }
          }
      }
      if(i != j & i < j){
        if(helpBool == FALSE){
          assign(paste0("corNumber", 1), cor(vis.data[,j], vis.data[,i], use="p"))
        }
        if(helpBool == TRUE){
          for(k in  1:length(levels(daten.under$base[, indexCategorial]))){
            assign(paste0("corNumber", k), cor(vis.data[daten.under$base[, indexCategorial] == levels(daten.under$base[, indexCategorial])[k],j],vis.data[daten.under$base[, indexCategorial] == levels(daten.under$base[, indexCategorial])[k],i], use = "p"))
          }
        }
      
        plot<-plot_ly()
        if(helpBool == TRUE){
          textForTick <- vector()
          for(k in 1:length(levels(daten.under$base[, indexCategorial]))){
            textForTick <-c(textForTick, round(eval(parse(text = paste0("corNumber", k))), 2))
            if(k == length(levels(daten.under$base[, indexCategorial]))){
              textForTick <- paste(textForTick, collapse = ", ")
            }
            plot <- add_trace(plot, x = 0, y= eval(parse(text = paste0("corNumber",k))), type = "bar", 
                              name = levels(daten.under$base[, indexCategorial])[k], showlegend = F, legendgroup = paste0("group",k), 
                              marker = list(color = colorRampPalette(c("blue", "black"))(length(levels(daten.under$base[, indexCategorial])))[k]), hoverinfo = "y")%>%
              layout(font = list(family = input$ownFont, size = input$sizeOwnFont), yaxis = list(range = c(-1,1)), xaxis= list(range = c(-1,1),  autotick = FALSE, 
                                                                tickmode = "array", tickvals = 0, ticktext = textForTick, ticks ="outside"))
          }
        }
        if(helpBool == FALSE){
          textForTick <- paste0("Corr: ", round(corNumber1,3))
          plot <- add_trace(plot, x = 0, y= eval(parse(text = paste0("corNumber",1))), type = "bar", 
                            marker = list(color = eval(parse(text = paste0("input$col",1)))), hoverinfo = "y")%>%
            layout(font = list(family = input$ownFont, size = input$sizeOwnFont), showlegend = FALSE, yaxis = list(range = c(-1,1)), xaxis= list(range = c(-1,1),  autotick = FALSE, 
                                                              tickmode = "array", tickvals = 0, ticktext = textForTick, ticks ="outside"))
        }


        plots[[countPlots]] <- plot

      }
      countPlots <- countPlots +1
    }
  }
  countPlots <- 1
  for(i in 1: length(input$variablesscattermatrix)){
    plotSub <- list()
    for(j in 1: length(input$variablesscattermatrix)){
      plotSub[[j]] <- plots[[countPlots]]
      countPlots <- countPlots +1
      
    }
    zwischenSave <- subplot(plotSub, titleX = TRUE) %>% layout(yaxis = list(title = names(vis.data)[i]))
    assign(paste0("rowSubs", i), zwischenSave)
  }

  subGesamt <- list()
  subGesamt[[1]] <- rowSubs1
  for(i in 2: length(input$variablesscattermatrix)){
    subGesamt[[i]] <- eval(parse(text = paste0("rowSubs", i)))
  }
  return(subplot(subGesamt, nrows = length(input$variablesscattermatrix), titleX = TRUE, titleY = TRUE))

})

# hier im Tab Data Analysis via visualisation: Scatter Matrix
# output des Scattermatrix
output$scattermatrix<- renderPlotly({
  if(is.null(scattermatrix())){return()}
  #if(is.null(matrixScatter$scatterMatrix)){return()}
  #plotly_POST(scattermatrix(), filename = "Scattermatrix")
  scattermatrix()
  
})

output$scattermatrixUi <- renderUI({
  plotlyOutput("scattermatrix", width = 1000, height = 800)
})
########################################################################################################################################################################
############################################################################ Google Motion chart ########################################################
######################################################################################################################################################################
output$scatterMotion <- renderGvis({
  daten.under$base["Date"] <- seq(as.Date("1991/01/01"), length.out = nrow(daten.under$base), by = "month")
  data <- daten.under$base
  data[, ncol(data)+1]<- factor(rep("Value", nrow(data)))
  names(data)[ncol(data)]<- " "
  
  gvisMotionChart(data,
                idvar=" ",
                timevar="Date")
})

########################################################################################################################################################################
############################################################################ Data Analysis, Analysis via visualisation, Data visualisation ############################
######################################################################################################################################################################

# hier im Tab Data Analysis via visualisation: Data visualisation
#diese renderUI gibt die Auswahl der Variablen (drop down menu) bei Data visualisation wieder (l?uft alles unter plot all compare (plotallcomp))
output$depvarplotallcomp <- renderUI({
  
  cor.data <- daten.under$base[ ,sapply(daten.under$base, is.numeric)]
  colnames <- names(cor.data)
  selectInput("depvarplotallcomp", NULL,
              choices = colnames)
})

# hier im Tab Data Analysis via visualisation: Data visualisation
# Organisieren der Auswahlliste fuer die zu vergleichenden Variablen
output$comparePlot <- renderUI({
  
  isolate(vis.data <- daten.under$base[ ,sapply(daten.under$base, is.numeric)])
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
  pos.data <- which(colnames(daten.under$base) == name)
  
  daten.under$daten.non.linear[[(pos.data-1)]] <- daten.under$base[[pos.data]]
  
  if(!is.numeric(input$nonLinLag)){return()}
  
  if(input$nonLinLag >0){
    #c(rep(NA, xxxnonLinLag), xxxdatenunderbase[1:((nrow(xxxdatenunderbase)- xxxnonLinLag)), xxxpos.data][[1]])
    daten.under$daten.non.linear[[(pos.data-1)]]<- c(rep(NA,input$nonLinLag),daten.under$base[1:((nrow(daten.under$base)-input$nonLinLag)),pos.data][[1]])
    plot.variable$tabelle.relation[pos.name, 3] <- input$nonLinLag
  }
  
  x <- daten.under$daten.non.linear[[(pos.data-1)]]
  
  if(grepl("x", input$nonLinRelation) == FALSE){return()}
  
  if(any(input$nonLinRelation,x))
    result <- tryCatch({
      eval(parse(text = input$nonLinRelation))
    }, error = function(e){
      x
    })
  
  
  if(!is.null(result)){
    daten.under$daten.non.linear[[(pos.data-1)]] <- result
  }
  
  if((!identical(result, x) || input$nonLinRelation == "x") && !is.null(result)){
    plot.variable$tabelle.relation[pos.name, 2] <- input$nonLinRelation
  }

})


# hier im Tab Data Analysis via visualisation: Data visualisation
# hier kann die nich-linear Beziehung wieder gel?scht werden nach dr?cken des Buttons Reset
observeEvent(input$resetnonlinear,{
  if(nrow(plot.variable$tabelle.relation)==0){return()}
  name <- input$nonLinVarPlot
  pos.name <- which(plot.variable$tabelle.relation[[1]] == name)
  daten.under$daten.non.linear[[input$nonLinVarPlot]] <- daten.under$base[[input$nonLinVarPlot]]
  plot.variable$tabelle.relation[pos.name,2] <-"Original"
  plot.variable$tabelle.relation[pos.name,3] <-0
  
})


# hier im Tab Data Analysis via visualisation: Data visualisation
# Ausgabe der Modifikationstabelle
output$modNOnLin <- renderDataTable({
  
  plot.variable$tabelle.relation
  
}, options = list(scrollX = TRUE, pagination = FALSE,searching = FALSE,paging = FALSE))

# hier im Tab Data Analysis via visualisation: Data visualisation
# Erstellung der Dygraphen und Ausgabe der dieser auf Basis der Non-Linear Relations und Time lags
non.linear.plots <- eventReactive(input$plotAllComp, {
  daten.under$base["Date"] <- seq(as.Date("1991/01/01"), length.out = nrow(daten.under$base), by = "month")
  #isolate({
      validate(
        need(!is.null(input$compare), "Please select variables to compare")
      )
      
      name.dep.var <- input$depvarplotallcomp
      
      dat.vis <- daten.under$daten.non.linear
      namen.relevant <- input$compare
      namen.relevant <- c(namen.relevant, input$depvarplotallcomp)
      index.var <- sapply(colnames(dat.vis), function(x) x %in% namen.relevant)
      
  #})
  # In der Variable "dat.vis.relevant" befinden sich nun die relevanten und gegebenenfalls modifizierten
  # Daten der ausgewÃ¤hlten Variablen.
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
  
  plot1 <- plot_ly()
  for(i in 1: ncol(ts.iterativ)){
    plot1<-add_trace(plot1, y = coredata(ts.iterativ)[,i], line = list(color = eval(parse(text = paste0("input$col",i)))), 
                     x=time(ts.iterativ), name = names(ts.iterativ)[i], type = "scatter", mode = "lines+markers") %>% 
      layout(font = list(family = input$ownFont, size = input$sizeOwnFont))
  }
  
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
  
  korrelation <- cbind(round(korrelation, digits = 2), mod.temp, lags.temp)
  
  report$plotAllComp<-plot1
  
  
  colnames(korrelation) <- c("Correlation", "Data modified", "Time lags")
  plot.variable$tabelle.korrelation <- korrelation
  
  plot1
})

# hier im Tab Data Analysis via visualisation: Data visualisation
# Ausgabe des Graphen auf Basis der ausgewÃ¤hlten Variablen und deren Modifikationen
output$compGraph <- renderPlotly({
  
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


# je nachdem, ob checkbox sureface chart on ist, wird UI ge?ndert
output$switchLineSurface <- renderUI({
  
  if(input$selectLineSurface == "lineChart"){
   return(list(
    fluidRow(
      column(width = 4,
             p(strong("Choose target variable")),
             uiOutput("depvarplotallcomp"),
             uiOutput("comparePlot"),
             br(),
             br(),
             br(),
             actionButton("plotAllComp", label = "Plot current selection")
      ),
      column(width = 4,
             uiOutput("nonLinearPlot"),
             textInput("nonLinRelation", label = "Determine non-linear relation"),
             numericInput("nonLinLag", label = "Determine lag", min = 0, value = 0),
             actionButton("accept", "Accept non-linear relation and time-lag"),
             actionButton("resetnonlinear", "Reset")
             
      ),
      conditionalPanel("input.plotAllComp", column(
        width = 4,
        h4(strong("Summary of the current selected options")),
        dataTableOutput("modNOnLin")
      )
      )
      
    ),
    
    conditionalPanel("input.plotAllComp", plotlyOutput("compGraph")),
    br(),
    conditionalPanel("input.plotAllComp", dataTableOutput("tableCor")),
    conditionalPanel("input.plotAllComp", hr()),
    conditionalPanel("input.plotAllComp",
                     textInput("nameplotAllCompreport", "Choose name for reportlist", width = 200),
                     actionButton("acceptplotAllCompreport", "Add to reportlist")
    )
   ))
  }
  
  if(input$selectLineSurface == "surfaceChart"){
    return(list(
      checkboxInput("surface2d3d", "3d surface", value = TRUE),
      fluidRow(column(width = 6, 
        uiOutput("varsSurfacePlot")
      )),
      actionButton("plotSurface", "Plot surface"),
      plotlyOutput("surfaceOutput", width = 1600, height = 600)
    ))
  }
  
})

# falls show variable as color ausgw?hlt wurde, dann Auswahl categorial variable m?glich
output$catInputTimeSeries <- renderUI({
  if(input$switchCategorialAsColor == TRUE){
      selectInput("unscaledTimeSeriesPlotCat", label = "Choose variable as color", 
                  choices= names(daten.under$base)[-1], selected = "")
  }
      
})


output$switchRadioButtonsCat<- renderUI({
  if(input$switchCategorialAsColor == TRUE){return()}
  
  if(input$switchCategorialAsColor == FALSE){
    return(radioButtons("unscaledSelectLineSurface", " ", choices = c("Line chart" = "lineChart", "Surface chart" = "surfaceChart")))
  }
})

output$unscaledSwitchLineSurface <- renderUI({
  
  if(input$switchCategorialAsColor == FALSE & !is.null(input$unscaledSelectLineSurface)){
  
      if(input$unscaledSelectLineSurface == "lineChart"){
        return(list(
            fluidRow(
              column(width = 3,
                     sliderInput("numerOfColsPlotly", "Choose number of columns", min = 1, max =2, value = 1, step = 1)
              ),
              column(width = 3,
                     sliderInput("numerOfRowsPlotly", "Choose number of rows", min = 1, max =2, value = 1, step = 1)
              )
            ),
            uiOutput("choosevariablesUnscaledtimeseries"),
            actionButton("plotAllunscaledComp","Plot timeseries"),
            plotlyOutput("unscaledtimeseriesplot")
        ))
      }
      if(input$unscaledSelectLineSurface == "surfaceChart"){
        return(list(
          checkboxInput("unscaledSurface2d3d", "3d surface", value = TRUE),
          fluidRow(column(width = 6, 
                          uiOutput("unscaledVarsSurfacePlot")
          )),
          actionButton("unscaledPlotSurface", "Plot surface"),
          plotlyOutput("unscaledSurfaceOutput", width = "100%", height = "auto")
        ))
      }
  }
  
  if(input$switchCategorialAsColor == TRUE){
      vis.data <- daten.under$base[ ,sapply(daten.under$base, is.numeric)]
      vis.names <- colnames(vis.data)
      return(list(
        selectizeInput("timeSeriesCatVariables", "Select variable to plot", vis.names, selected = NULL,
                       options = NULL),
        actionButton("plotTimeSeriesCat", "Plot time series"),
        conditionalPanel("input.plotTimeSeriesCat", plotlyOutput("timeSeriesCatplotOutput", width = "100%", height = "auto"))
      ))
  }
})

# plot der time series, falls show categorial as color ausgew?hlt wurde
observeEvent(input$plotTimeSeriesCat, {
  
    indexVariable <- which(attributes(daten.under$base)$names == input$timeSeriesCatVariables)
    indexCategorial <- which(names(daten.under$base)%in%input$unscaledTimeSeriesPlotCat)
    plot1<-plot_ly()
    plot1<- add_trace(plot1, x = as.character(daten.under$base[,1][[1]]), y=daten.under$base[,indexVariable][[1]], type = "bar", 
                      color = daten.under$base[,indexCategorial][[1]],
                      colors = colorRampPalette(c("blue", "black"))(10),
                      hoverinfo = "text", text = paste("Date: ", daten.under$base[,1][[1]], "<br>",
                                                       input$unscaledTimeSeriesPlotCat, ": ",daten.under$base[,indexVariable][[1]], "<br>",
                                                       input$timeSeriesCatVariables, ": ",daten.under$base[,indexCategorial][[1]])) %>% 
                      layout(font = list(family = input$ownFont, size = input$sizeOwnFont), margin = list(b = 80), 
                             title = paste0("Time series plot of ", input$timeSeriesCatVariables, " (colors indicating values for ",input$timeSeriesCatVariables, ")"))
    plotTsCat$plot<- plot1
  
  
})
# reactive Values f?r time series plot mit categorial
plotTsCat <- reactiveValues(plot = 0)

output$timeSeriesCatplotOutput <- renderPlotly({
  
  plotTsCat$plot
  
})


# reactive value f?r surface plot
surface <- reactiveValues(
  plot = 0,
  unscaledPlot = 0
)

output$surfaceOutput <- renderPlotly({
  if(identical(surface$plot,0)){return()}
  withProgress(message = "Plotting surface, pleas wait",value=0.3, {
    surface$plot
  })
})

output$unscaledSurfaceOutput <- renderPlotly({
  if(identical(surface$unscaledPlot,0)){return()}
  withProgress(message = "Plotting surface, pleas wait",value=0.3, {
    surface$unscaledPlot
  })
})

output$varsSurfacePlot <- renderUI({
  
  vis.data <- daten.under$base[ ,sapply(daten.under$base, is.numeric)]
  vis.names <- colnames(vis.data)
  selectizeInput("surfaceVarsInput", "Select variables", vis.names, selected = NULL, multiple = TRUE,
                 options = NULL)
  
})

output$unscaledVarsSurfacePlot <- renderUI({
  
  vis.data <- daten.under$base[ ,sapply(daten.under$base, is.numeric)]
  vis.names <- colnames(vis.data)
  selectizeInput("unscaledSurfaceVarsInput", "Select variables", vis.names, selected = NULL, multiple = TRUE,
                 options = NULL)
  
})

# plotet den sureface plot
observeEvent(input$plotSurface, {
  
  if(is.null(input$surfaceVarsInput)){return(withProgress(message = "Please enter variables", Sys.sleep(1.5)))}
  if(input$surfaceVarsInput == ""){return(withProgress(message = "Please enter variables", Sys.sleep(1.5)))}
  
  withProgress(message = "Plotting surface, pleas wait",value=0.3, {
    
    indexVars <- sapply(colnames(daten.under$base), function(x) x %in% input$surfaceVarsInput)
    Value <- as.matrix(daten.under$base[, indexVars])
    Value <- scale(Value)
    dates <- daten.under$base[,1][[1]]
    namesCol <- colnames(daten.under$base)[indexVars]
    if(input$surface2d3d == TRUE){
      newNumberofCols <- (ncol(Value)-1)*2+ncol(Value)
      emptyMatrix<-matrix(rep(min(Value, na.rm=TRUE), newNumberofCols*nrow(Value)), nrow(Value), newNumberofCols)
      dataSeq <- seq(1,newNumberofCols, by = 3)
      j = 1
      for(i in dataSeq){
        emptyMatrix[,i]<- Value[,j]
        j = j+1
      }
      Value <- emptyMatrix
      surface$plot <- plot_ly(z = ~Value, type = "surface", colors = colorRampPalette(c("blue", "black"))(10)) %>% 
        layout( font = list(family = input$ownFont, size = input$sizeOwnFont), scene = list(yaxis = list(title = paste0(dates[1], " to ", dates[length(dates)]), ticks = "outside",
                             autoticks = T, showticklabels = FALSE, tickmode = "array", ticktext = dates,tickvals = c(1:nrow(Value))), 
                            xaxis = list(title = "", ticks = "outside", tickmode = "array", ticktext = namesCol, tickvals = dataSeq-1)))
    }
    if(input$surface2d3d == FALSE){
      surface$plot <- plot_ly(z = ~Value, colors = colorRampPalette(c("blue", "black"))(10)) %>% 
        layout(font = list(family = input$ownFont, size = input$sizeOwnFont), 
          showgrid = FALSE, yaxis = list(showgrid = FALSE, title = paste0(dates[1], " to ", dates[length(dates)]), ticks = "outside",
                           autoticks = T, showticklabels = FALSE, ticklen = 0, tickmode = "array", ticktext = dates,tickvals = c(1:nrow(Value))), 
                           xaxis = list(zeroline = FALSE, showgrid = FALSE, title = "", ticks = "outside", tickmode = "array", ticktext = namesCol, tickvals = c(0:(length(namesCol)-1))))
    }
    setProgress(0.9)
  })
  
})


observeEvent(input$unscaledPlotSurface, {
  
  if(is.null(input$unscaledSurfaceVarsInput)){return(withProgress(message = "Please enter variables", Sys.sleep(1.5)))}
  if(input$unscaledSurfaceVarsInput == ""){return(withProgress(message = "Please enter variables", Sys.sleep(1.5)))}
  
  withProgress(message = "Plotting surface, pleas wait",value=0.3, {
    
    indexVars <- sapply(colnames(daten.under$base), function(x) x %in% input$unscaledSurfaceVarsInput)
    Value <- as.matrix(daten.under$base[, indexVars])
    dates <- daten.under$base[,1][[1]]
    namesCol <- colnames(daten.under$base)[indexVars]
    if(input$unscaledSurface2d3d == TRUE){
      newNumberofCols <- (ncol(Value)-1)*2+ncol(Value)
      emptyMatrix<-matrix(rep(min(Value, na.rm=TRUE), newNumberofCols*nrow(Value)), nrow(Value), newNumberofCols)
      dataSeq <- seq(1,newNumberofCols, by = 3)
      j = 1
      for(i in dataSeq){
        emptyMatrix[,i]<- Value[,j]
        j = j+1
      }
      Value <- emptyMatrix
      surface$unscaledPlot <- plot_ly(z = ~Value, type = "surface", colors = colorRampPalette(c("blue", "black"))(10)) %>% 
        layout(font = list(family = input$ownFont, size = input$sizeOwnFont), 
               scene = list(yaxis = list(title = paste0(dates[1], " to ", dates[length(dates)]), ticks = "outside",
                        autoticks = T, showticklabels = FALSE, tickmode = "array", ticktext = dates,tickvals = c(1:nrow(Value))), 
                        xaxis = list(title = "", ticks = "outside", tickmode = "array", ticktext = namesCol, tickvals = dataSeq-1)))
    }
    if(input$unscaledSurface2d3d == FALSE){
      surface$unscaledPlot <- plot_ly(z = ~Value, colors = colorRampPalette(c("blue", "black"))(10)) %>% 
        layout(font = list(family = input$ownFont, size = input$sizeOwnFont), showgrid = FALSE, 
               yaxis = list(showgrid = FALSE, title = paste0(dates[1], " to ", dates[length(dates)]), ticks = "outside",
                                                                                    autoticks = T, showticklabels = FALSE, ticklen = 0, tickmode = "array", ticktext = dates,tickvals = c(1:nrow(Value))), 
                                                     xaxis = list(zeroline = FALSE, showgrid = FALSE, title = "", ticks = "outside", tickmode = "array", ticktext = namesCol, tickvals = c(0:(length(namesCol)-1))))
    }
    setProgress(0.9)
  })
  
})

########################################################################################################################################################################
################################################################################### Data Analysis, Analysis via correlation ##########################################
######################################################################################################################################################################

# hier im Tab Data Analysis via correlation:
# reactive Value f?r lag_cor_table
lag<-reactiveValues(
  cortable = 0,
  BestCorrelationChoosen = list(),
  bestCorrTableAutomaticSelection = 0
)

# hier im Tab Data analysis, Analysis via correlation
# Diese Funktion erstellt eine Tabelle mit Lags einer gewaehlten unabhaengigen Variable ("Choose dependent variable") und deren resultierende
# Korrelation mit der abhaebgigen Variable.
output$lag_cor_table <- renderTable({
  if(lag$cortable == 0){return()}
  lag$cortable
})

# hier im Tab Data analysis, Analysis via correlation
# Event nach dr?cken des buttons "Show Table" wird Correlations Tabelle unter Time lag analysis angezeigt
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
  
  withProgress(message = "Calculating correlation table, pleas wait",value=0.3, {
  
    # Berechnung Lag-Korrelationsmatrix
    cor.data <- daten.under$base[ ,sapply(daten.under$base, is.numeric)]
    index.dep.var <- which(attributes(cor.data)$names == input$depVar)
    cor.data <- as.tbl(cor.data)
    lag <- input$LagForCorrelationTable
    if(is.na(lag)){lag <- 1}
    if(lag == 0){lag <- 1}
    reg.daten <- cor.data[ ,-index.dep.var]
    dep.daten <- cor.data[ ,index.dep.var]
    
    cor.table <- data.frame()
    for(i in 1:length(reg.daten)){
      cor.temp <- cor.lag(cor.data[[index.dep.var]], reg.daten[[i]], 0)[[1]]
      for(j in 1:lag){
        
        cor.temp <- c(cor.lag(cor.data[[index.dep.var]], reg.daten[[i]], j)[[1]])
      }
      cor.table <- rbind(cor.table, cor.temp)
    }
    colnames(cor.table) <- 0:lag
    rownames(cor.table) <- attributes(reg.daten)$names
    
    # Berechnung Kollinearitaetsmatrix
    cor.ind.var <- cor(cor.data, use = "pairwise.complete.obs")
    
    # Berechnung Max-Kollinearitaet
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
                          "Kollinearitaet" = round(val, 2))
  })  
  
  return(list(cor.table, cor.ind.var, max.col))
  
})

# hier im Tab Data analysis, Analysis via correlation
# Ausgabe der Time-Lag/Korrelationstabelle f?r alle moeglichen unabhaengigen Variablen
output$CorrelationTableComplete <- renderDataTable({
  
    input$depVar
    input$chooseTablevsHeader
    report$correlationtablehole<- round(cortables()[[1]], digits = 2)
    #corrr<-  cbind("Variable" = rownames(cortables()[[1]]), round(cortables()[[1]], digits = 2))
    report$correlationtablehole
})

# Download-Button-CSV-Datei fuer die Korrelationstabelle
output$DownloadCorrelationTableComplete <- renderUI({
  
  #if(is.null(cortables()[[1]])) return()
  
  return(downloadButton('DownloadCorrelationTableCompleteButton', 'Download correlation table as xlsx'))
})

# Speichern der Restricted-VAR-Vorhersagen in einer CSV-Datei
output$DownloadCorrelationTableCompleteButton <- downloadHandler(
  filename = function() { paste("Correlation_table_", input$LagForCorrelationTable , '.xlsx', sep='') },
  content = function(file) {
    write.xlsx(round(cortables()[[1]],digits=2), file)
  }
)


# hier im Tab Data analysis, Analysis via correlation
# Ausgabe der h?chsten Correlationen unter Tab correlation Analysis (Tab highest correlation)
output$CorrelationTableHighest <- DT::renderDataTable({
  
  
  corrtable <- round(cortables()[[1]], digits = 2)
  corresp.var <- apply(corrtable, 1, function(x)
                      return(which.max(abs(x))))
  corresp.var.lag <- apply(corrtable, 1, function(x)
                          return(max(abs(x))))
  corresp.var <- as.data.frame(corresp.var)
  for (i in 1:nrow(corrtable)) {
    corresp.var[i, 1] <- corresp.var[i, 1] - 1
  }
  corresp.var <- cbind(corresp.var.lag, corresp.var)
  corresp.var <- corresp.var[order(-corresp.var[, 1]), ]
  names(corresp.var) <- c("Correlation" , "Lag")
  lag$BestCorrelationChoosen[["HighestCorrelations"]] <- corresp.var
  return(corresp.var)
})

observeEvent(input$SaveChoosenVariablesHighestCorrelation, {
  if(is.null(input$CorrelationTableHighest_rows_selected)){
    withProgress(message = "No variables selected!", Sys.sleep(1.5))
    return()
  }
  
  # In den folgenden Variablen werden die ausgew?hlten Timelags und die Tabelle selbst nochmal abgespeichert
  SelectedTimelags <- input$CorrelationTableHighest_rows_selected
  TabelleTimelags <- lag$BestCorrelationChoosen$HighestCorrelations
  chosenLags <- TabelleTimelags$Lag[SelectedTimelags]
  VariablesChoosen <- rownames(TabelleTimelags)[SelectedTimelags]
  sorting <- paste(VariablesChoosen, chosenLags, sep = "///")
  
  
  colnames <- colnames(daten.under$base)
  varsAndLags <- vector()
  sortedOrder <- colnames(daten.under$base)[which(colnames%in%VariablesChoosen)]
  for(i in 1: length(sortedOrder)){
    for(j in 1: length(sorting)){
      targeVariable <- sub("///.*", "", sorting[j])
      if(targeVariable == sortedOrder[i]){
        chosenLags <- as.numeric(sub("^.*///", "", sorting[j]))
        varsAndLags <- c(varsAndLags, paste(targeVariable, chosenLags, sep = "///"))
      }
    }
  }

  VariablesChoosen <- sub("///.*", "", varsAndLags)
  chosenLags <- as.numeric(sub("^.*///", "", varsAndLags))
  
  # In den folgenden globalen Variablen wird festgelegt, ob ein Model in den manuellen Bereich ?bernommen werden soll
  lag$BestCorrelationChoosen[["VariablesSelected"]] <- TRUE
  lag$BestCorrelationChoosen[["Lags"]] <- chosenLags
  lag$BestCorrelationChoosen[["VariablesChoosen"]] <- VariablesChoosen
  
  withProgress(message = "Saving lag-combination for this model", Sys.sleep(1.5))
})

# hier im Tab Data analysis, Analysis via correlation
# Ausgabe der Korrleationen der moeglichen unabhaengigen Variablen (unter Collinearity analysis)
output$korrelation_ind <- renderDataTable({
   
  round(cortables()[[2]], digits = 2)
  
}, options = list(scrollX = TRUE))

# Download-Button-CSV-Datei fuer die Kollinearitaetstabelle
output$DownloadCollinearityTableComplete <- renderUI({
  
  if(is.null(cortables()[[1]])) return()
  
  return(downloadButton('DownloadCollinearityTableCompleteButton', 'Download collinearity table as xlsx'))
})

# Speichern der Restricted-VAR-Vorhersagen in einer CSV-Datei
output$DownloadCollinearityTableCompleteButton <- downloadHandler(
  filename = function() { paste("Collinearity_table", '.xlsx', sep='') },
  content = function(file) {
    write.xlsx(round(cortables()[[2]],digits=2), file)
  }
)


# hier im Tab Data analysis, Analysis via correlation
# Ausgabe der hoechsten Kollinearitaet einer jeden moeglichen
# unabhaengigen Variable.
output$maxKol <- renderDataTable({
  
  cortables()[[3]]
  
})

observeEvent(input$showChoosenVariableCorrTable, {
  
  if(length(input$CorrelationTableHighest_rows_selected) < 2){
    toggleModal(session, modalId = "chosenVariablesCorrTable", toggle = "close")
    withProgress(message = "Select at least 2 variables", Sys.sleep(1.5))
  }
  
})

output$corrTableChosenVariables <- renderDataTable({
  
  if(length(input$CorrelationTableHighest_rows_selected) < 2){return(data.frame())}
  rows <- input$CorrelationTableHighest_rows_selected
  
  selectedNames <- rownames(lag$BestCorrelationChoosen[["HighestCorrelations"]])[rows]
  colNumbersData <- which(names(daten.under$base)%in%selectedNames)
  round(cor(daten.under$base[,colNumbersData], use = "pairwise.complete.obs"),4)

}, options = list(pageLength = 10, scrollX = TRUE))

observeEvent(input$automaticFeatureSelection, {
  minCorr <- input$minCorrInput
  minLag <- input$minLagInput
  bedingungTooSelect <- lag$BestCorrelationChoosen[["HighestCorrelations"]][1]>minCorr & lag$BestCorrelationChoosen[["HighestCorrelations"]][2]>=minLag
  selectedNames <- rownames(lag$BestCorrelationChoosen[["HighestCorrelations"]][bedingungTooSelect,])
  lagsOfSelectedNames <- lag$BestCorrelationChoosen[["HighestCorrelations"]][bedingungTooSelect,2]
  colNumbersData <- which(names(daten.under$base)%in%selectedNames)
  dataShiftedLags <- daten.under$base[,colNumbersData]
  print(length(selectedNames))
  if(length(selectedNames) == 0){
    lag$bestCorrTableAutomaticSelection <- data.frame()
    toggleModal(session, modalId = "autoSelectionCorrTable", toggle = "close")
    return(withProgress(message = "No features selected", Sys.sleep(1.5)))
  }
  print(lagsOfSelectedNames)
  for(i in 1:length(selectedNames)){
    dataShiftedLags[,i][[1]] <- c(rep(NA,lagsOfSelectedNames[i]), dataShiftedLags[,i][[1]][1:(length(dataShiftedLags[,i][[1]])-lagsOfSelectedNames[i])])
  }
  subCoreTable <- as.matrix(cor(dataShiftedLags, use = "pairwise.complete.obs"))
  subCoreTable <- subCoreTable - diag(nrow(subCoreTable))
  subCoreTable <- abs(subCoreTable)
  selectedNames <- colnames(subCoreTable)
  if(length(selectedNames) > input$numOfAutoSelectedFeatures){
    for(i in 1:(length(selectedNames)-input$numOfAutoSelectedFeatures)){
        print(i)
        highestColRow <- which(subCoreTable == max(subCoreTable), arr.ind = TRUE)[1,]
        nameRow <- rownames(subCoreTable)[highestColRow[1][[1]]]
        nameCol <- rownames(subCoreTable)[highestColRow[2][[1]]]
        corrRow <- lag$BestCorrelationChoosen[["HighestCorrelations"]][nameRow, "Correlation"]
        corrCol <- lag$BestCorrelationChoosen[["HighestCorrelations"]][nameCol, "Correlation"]
        if(corrRow > corrCol){
          rowColNumberToDelete <- which(selectedNames %in% nameCol)
          selectedNames <- selectedNames[-which(selectedNames %in% nameCol)]
          subCoreTable <- subCoreTable[-rowColNumberToDelete,-rowColNumberToDelete]
        } else {
          rowColNumberToDelete <- which(selectedNames %in% nameRow)
          selectedNames <- selectedNames[-which(selectedNames %in% nameRow)]
          subCoreTable <- subCoreTable[-rowColNumberToDelete,-rowColNumberToDelete]
        }
    }
  }
  subCoreTable <- round(subCoreTable + diag(nrow(subCoreTable)), 4)
  rowsOfSelectedVars <- which(rownames(lag$BestCorrelationChoosen[["HighestCorrelations"]]) %in% colnames(subCoreTable))
  lagsOfSelectedVars <- lag$BestCorrelationChoosen[["HighestCorrelations"]][rowsOfSelectedVars,2]
  corrOfSelectedVars <- lag$BestCorrelationChoosen[["HighestCorrelations"]][rowsOfSelectedVars,1]
  subCoreTable <- data.frame(subCoreTable)
  colnames(subCoreTable) <- paste0(colnames(subCoreTable), "_Lag_", lagsOfSelectedVars)
  rownames(subCoreTable) <- paste0(rownames(subCoreTable), "_Lag_", lagsOfSelectedVars)
  colnames(subCoreTable) <- paste0(colnames(subCoreTable), "_Corr_", corrOfSelectedVars)
  rownames(subCoreTable) <- paste0(rownames(subCoreTable), "_Corr_", corrOfSelectedVars)
  lag$bestCorrTableAutomaticSelection <- subCoreTable
  
})






output$corrTableAutomaticSelection <- renderDataTable({
  
  lag$bestCorrTableAutomaticSelection
  
}, options = list(pageLength = 10, scrollX = TRUE))

# Durchfuehrung vom Granger-Causality Test, um eine erste Idee der Abhaengigkeiten zu bekommen
############################### Granger Causality ###################################################################
grangerCausality <- eventReactive(input$depVar, {
  
  if(is.null(input$depVar)){
    return()
  }
  
  # Get required predictor names
  requiredNames <- daten.under$base[ ,sapply(daten.under$base, is.numeric)]
  requiredNames <- colnames(requiredNames)[- which(colnames(requiredNames) == input$depVar)]
  
  if(length(requiredNames) == 0){
    return()
  }
  
  # Get relevant Data to perform univariate Granger-Tests
  grangerData <- na.omit(daten.under$base[ ,c(input$depVar, requiredNames)])
  
  dataFrameXdepY <- data_frame()
  dataFrameYdepX <- data_frame()
  
  # Get Best Correlations
  corrtable <- round(cortables()[[1]], digits = 2)
  corresp.var <- apply(corrtable, 1, function(x)
    return(which.max(abs(x))))
  corresp.var.lag <- apply(corrtable, 1, function(x)
    return(max(abs(x))))
  corresp.var <- as.data.frame(corresp.var)
  for (i in 1:nrow(corrtable)) {
    corresp.var[i, 1] <- corresp.var[i, 1] - 1
  }
  corresp.var <- cbind(corresp.var.lag, corresp.var)
  corresp.var <- corresp.var[order(-corresp.var[, 1]), ]
  names(corresp.var) <- c("Correlation" , "Lag")
  
  for(i in 1:length(requiredNames)){
    # Teste zuerest y ~ x dependencie
    orderToCheck <- corresp.var[which(rownames(corresp.var) == requiredNames[i]), 2]
    grangertestYdepX <- tryCatch({
                          grangertest(as.formula(paste(input$depVar, "~", requiredNames[i])),
                                                        order = orderToCheck + 5,
                                                        data = grangerData)
                        }, error = function(e){
                            list("Pr(>F)" = 1)                  
                        })
    
    resultTemp <- data.frame("Variable" = requiredNames[i], "P_Value" = round(na.omit(grangertestYdepX$`Pr(>F)`),
                                                                              digits = 4))
    dataFrameYdepX <- rbind(dataFrameYdepX, resultTemp) 
    
    # Teste x ~ y dependencie
    grangertestXdepY <- tryCatch({
                          grangertest(as.formula(paste(requiredNames[i], "~", input$depVar)),
                                    order = 10,
                                    data = grangerData)
                        }, error = function(e){
                          list("Pr(>F)" = 1)                  
                        })
    
    resultTemp <- data.frame("Variable" = requiredNames[i], "P_Value" = round(na.omit(grangertestXdepY$`Pr(>F)`),
                                                                              digits = 4))
    dataFrameXdepY <- rbind(dataFrameXdepY, resultTemp) 
  }
  
  # Fazit Y dependent on X
  dataFrameYdepX <- dataFrameYdepX %>% mutate(Conculsion = ifelse(P_Value < 0.05,
                                                                  paste("Variable is possibly relevant in modelling",
                                                                        input$depVar, sep = " "),
                                                                  paste("Variable is possibly not relevant in modelling",
                                                                        input$depVar, sep = " ")))
  
  # Fazit X dependent on Y
  dataFrameXdepY <- dataFrameXdepY %>% mutate(Conculsion = ifelse(P_Value < 0.05,
                                                                  "Granger-causality detected - Possibly use VAR approach.",
                                                                  "No Granger-causality detected - Possibly use MREG approach."))
  
  return(list(YdependentX = dataFrameYdepX,
              XdependentY = dataFrameXdepY))
})

# Ausgabe Conculsion Tabel Granger Causality X dependent on Y
output$grangerCausalityXdepY <- renderDataTable({
  
  if(is.null(grangerCausality())){
    return()
  }else{
    return(grangerCausality()[[2]])
  }
  
}, rownames = FALSE, options = list(scrollX = TRUE, searching = TRUE))

# Ausgabe Conculsion Tabel Granger Causality Y dependent on X
output$grangerCausalityYdepX <- renderDataTable({
  
  if(is.null(grangerCausality())){
    return()
  }else{
    return(grangerCausality()[[1]])
  }
  
} , rownames = FALSE, options = list(scrollX = TRUE, searching = TRUE))

########################################################################################################################################
###################################################### Automatische Reportgenerierung unter Reporting ############################################################
################################################################################################################################################################## 

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
# hier wird durch dr?cken des Buttons "Add to Reportlist" des Scatterplot sowie der eingegebene Name als reactiver Value gespeichert. Es ist nur die Speicherung
# von 2 scatterplots m?glich (falls schon 2 gespeichert sind folgt Meldung - ebenso wenn kein Name eingetragen wurde)
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
# analog zu scatter plots und matrices kann hier eine timeseries abgespeichert werden (l?uft im folgenden alles unter timeseriesplotallcomp)
observeEvent(input$acceptplotAllCompreport, {
  
  
  if(input$nameplotAllCompreport == ""){return(withProgress(message = "Please enter a name", Sys.sleep(1.5)))}
  
  if(length(report$timeseriesplotAllComp) == 1){return(withProgress(message = "No more timeseries possible", Sys.sleep(1.5)))}
  withProgress(message = "Added to reportlist", Sys.sleep(1.5))
  report$timeseriesplotAllComp[[input$nameplotAllCompreport]] <- report$plotAllComp
  report$korrelationtableplotAllComp<- plot.variable$tabelle.korrelation
  
})


# hier im Tab Data analysis, Analysis via correlation
# durch dr?cken des Buttons "Add to reportlist" wird die Correlationstable zur Reportlist unter 7.Reporting hinzugef?hgt (als reactiver Value gespeichert)
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
# durch dr?cken des Buttons "Add to reportlist" wird die Collinearity Table zur Reportlist unter 7.Reporting hinzugef?hgt (als reactiver Value gespeichert)
observeEvent(input$addreportcollinearity, {

  index<-which(report$collcorr == "Collinearity table")
  
  if(length(index) >0){return(withProgress(message = "Table already added to reportlist", Sys.sleep(1.5)))}
  if(report$collcorr == 0){
    withProgress(message = "Added to reportlist", Sys.sleep(1.5))
    return(report$collcorr<-"Collinearity table")
    
  }
  withProgress(message = "Added to reportlist", Sys.sleep(1.5))
  report$collcorr<-c(report$collcorr, "Collinearity table")
  
})
######################################################################################################################################################
############################################## Visualisierung der Verteilungen ######################################################################
######################################################################################################################################################

# Aufbereitung eines Drop-Down-Menues, aus dem Variablen fuer eine Verteilungsbetrachtung ausgewaehlt werden koennen.
output$distVariabel <- renderUI({
    
  categorialIndex <- vector()
  for(i in 1: ncol(daten.under$base)){
    if(is.factor(daten.under$base[,i])){
      categorialIndex <- c(categorialIndex, i)
    }
  }
  
  vis.data <- daten.under$base[ ,sapply(daten.under$base, is.numeric)]
  vis.names <- colnames(vis.data)
  

    return(selectInput("distVar",label = "Select variable", vis.names))

  

    
})

#hier wird die Anzeige der Bins angepasst. Jenachdem, wie breit die Variable ist, wird die Anzeige der Bins angepasst (d.h. die Anzeige, die ?ber SliderInput m?glich wird, 
# ?ber welche man die Bins einstellen kann)
observeEvent(input$distVar,{
  
  hist.daten <- as.data.frame(daten.under$base[ ,sapply(daten.under$base, is.numeric)])
  name.data  <- input$distVar
  relevant.hist <- hist.daten[ ,which(colnames(hist.daten) == name.data)]
  binHist$sizeBinMax <- max(relevant.hist, na.rm=T)/2
  binHist$sizeBinMin <- round((max(relevant.hist, na.rm=T) - min(relevant.hist, na.rm=T))/length(relevant.hist),2)
})

binHist <- reactiveValues(
  sizeBinMax = 50,
  sizeBinMin = 1
)

output$sliderBinBreite <- renderUI({

  if(is.null(input$autoBinBreite)){return()}
  if(input$autoBinBreite == TRUE){return()}
  sliderInput("binsHist", label = "Size of bins:",
              min = binHist$sizeBinMin, max = binHist$sizeBinMax, value = binHist$sizeBinMax/100)
  
})


output$binWidthAuto <- renderUI({


  checkboxInput("autoBinBreite", "Bin width auto", value = TRUE)
  
})

# Recative Generierung des Histograms sowie der Auswertung der Verteilungsbetrachtung fuer die ausgewaelte Variable
histoDist <- eventReactive(input$plotdistr, {
  
  helpBool <- FALSE

  
  if(helpBool == FALSE){
    
    hist.daten <- as.data.frame(daten.under$base[ ,sapply(daten.under$base, is.numeric)])
    name.data  <- input$distVar
    relevant.hist <- hist.daten[ ,which(colnames(hist.daten) == name.data)]
    colorOne <- "#4286f4"
    
    if(input$select.fit != "keine"){
      if(input$autoBinBreite == TRUE){
        histogram.dens <- plot_ly(x= relevant.hist, color = eval(parse(text = paste0("I('", colorOne, "')"))), histnorm = "probability density", name = "Prop density", type = "histogram", autobinx =T) %>% 
          layout(font = list(family = input$ownFont, size = input$sizeOwnFont), bargap = 0.1, yaxis = list(title = "Probability density"))
      }
      if(input$autoBinBreite == FALSE){
        histogram.dens <- plot_ly(x= relevant.hist, color = eval(parse(text = paste0("I('", colorOne, "')"))), histnorm = "probability density", name = "Prop density", type = "histogram", autobinx =F,xbins=list(start=min(relevant.hist, na.rm=T), 
            end = max(relevant.hist, na.rm=T), size=input$binsHist))%>% layout(font = list(family = input$ownFont, size = input$sizeOwnFont), bargap = 0.1, yaxis = list(title = "Probability density"))
      }
    }
    if(input$select.fit == "keine"){

      if(input$autoBinBreite == TRUE){
        histogram.dens <- plot_ly(x= relevant.hist, color = eval(parse(text = paste0("I('", colorOne, "')"))), type = "histogram", autobinx =T, name = "Frequency") %>% 
          layout(font = list(family = input$ownFont, size = input$sizeOwnFont), bargap = 0.1, yaxis = list(title = "Frequency"))
      }
      if(input$autoBinBreite == FALSE){
        histogram.dens <- plot_ly(x= relevant.hist, color = eval(parse(text = paste0("I('", colorOne, "')"))), type = "histogram", autobinx =F,name = "Frequency", xbins=list(start=min(relevant.hist, na.rm=T), 
            end = max(relevant.hist, na.rm=T), size=input$binsHist))%>% layout(font = list(family = input$ownFont, size = input$sizeOwnFont), bargap = 0.1, yaxis = list(title = "Frequency"))
      }
    }
    verteilungen.temp <- verteilungsBetrachtung(as.data.frame(relevant.hist))
    colnames(verteilungen.temp[[2]]) <-c("Dist 1", "IC 1","Dist 2", "IC 2","Dist 3", "IC 3","Dist 4", "IC 4","Dist 5", "IC 5")
    
    allList <- list(histogram.dens,
         h3(strong(paste("Histogram of", name.data, sep = " "))),
         verteilungen.temp[[2]],
         h4(strong("Statistical evaluation")))
  
    if(input$select.fit != "keine"){
      distFuns <- verteilungen.temp[[1]]
  
      for(i in seq(length(distFuns))){
        if(input$select.fit == distFuns[[i]]$distname){
          index <- i
          break()
        }
      }
      inputselectfit <-input$select.fit
      minmax <- max(relevant.hist, na.rm = TRUE) - min(relevant.hist, na.rm=TRUE)
      minmax <-minmax *0.2
      xfit <- seq(min(relevant.hist, na.rm = TRUE)-minmax, max(relevant.hist, na.rm=TRUE)+minmax, length=100)
      yfit<- eval(parse(text= paste0("d", distFuns[[index]]$distname,"(","xfit",",", distFuns[[index]]$estimate[1],",",distFuns[[index]]$estimate[2],")")))
      allList[[1]] <- allList[[1]] %>% add_lines(y= yfit,x = xfit, line = list(color = eval(parse(text = paste0("input$col",2)))), name = "Fit")
    }
  }
  if(helpBool == TRUE){
    name.data  <- input$distVar
    colorOne <- input$col1
    relevantHistComplete <- daten.under$base[ ,which(colnames(daten.under$base) == name.data)]
    verteilungen.temp <- data.frame()
    histogramDens <- list()
    counter <- 1
    for(k in 1:length(levels(daten.under$base[, indexCategorial]))){
      relevant.hist <- relevantHistComplete[daten.under$base[, indexCategorial] == levels(daten.under$base[, indexCategorial])[k]]
      checkIfNA <- relevant.hist[!is.na(relevant.hist)]
      if(length(checkIfNA) > 0){
        colorOne <- eval(parse(text = paste0("input$col", k)))
        histogramDens[[k]] <- plot_ly(x= relevant.hist, color = eval(parse(text = paste0("I('", colorOne, "')"))), histnorm = "probability density", 
                                  name = paste0("Prop density ",levels(daten.under$base[, indexCategorial])[k]), type = "histogram", autobinx =T) %>% 
          layout(font = list(family = input$ownFont, size = input$sizeOwnFont), bargap = 0.1)
        verteilungenZwischenSave <- verteilungsBetrachtung(as.data.frame(relevant.hist))
        rownames(verteilungenZwischenSave[[2]]) <- paste0(rownames(verteilungenZwischenSave[[2]])," ", levels(daten.under$base[, indexCategorial])[k])
        verteilungen.temp <- rbind(verteilungen.temp, verteilungenZwischenSave[[2]])
        if(input$select.fit != "keine"){
          distFuns <- verteilungenZwischenSave[[1]]
          
          for(i in seq(length(distFuns))){
            if(input$select.fit == distFuns[[i]]$distname){
              index <- i
              break()
            }
          }
          inputselectfit <-input$select.fit
          minmax <- max(relevant.hist, na.rm = TRUE) - min(relevant.hist, na.rm=TRUE)
          minmax <-minmax *0.2
          xfit <- seq(min(relevant.hist, na.rm = TRUE)-minmax, max(relevant.hist, na.rm=TRUE)+minmax, length=100)
          yfit<- eval(parse(text= paste0("d", distFuns[[index]]$distname,"(","xfit",",", distFuns[[index]]$estimate[1],",",distFuns[[index]]$estimate[2],")")))
          histogramDens[[k]] <- histogramDens[[k]] %>% add_lines(y= yfit,x = xfit, line = list(color = eval(parse(text = paste0("input$col",length(levels(daten.under$base[, indexCategorial]))+k)))), name = "Fit")
        }
        if(counter > 1){
          histogram.dens <- subplot(histogram.dens, histogramDens[[k]], nrows= 2, shareX=TRUE, shareY = T)
        }
        if(counter == 1){
          histogram.dens <- histogramDens[[k]]
        }
        counter <- counter+1
      }
    }
    allList <- list(histogram.dens,
                  h3(strong(paste("Histogram of", name.data, sep = " "))),
                  verteilungen.temp,
                  h4(strong("Statistical evaluation"))) 
    
  }
    
  return(allList)
})

# Ausgabe des Histograms
output$histggPlot <- renderPlotly({
  
  histoDist()[[1]]
  
})

# Ausgabe Ueberschrift
output$headerHist <- renderUI({
  
  histoDist()[[2]]
  
})

# Ausgabe der Auswertung des Fitting-Ergebnisses
output$distEval <- renderDataTable({
  
  data.frame(histoDist()[[3]])
  
},options = list(pagination = FALSE,searching = FALSE,paging = FALSE))

# Ausgabe Ueberschrift Auswertungstabelle
output$headerEval <- renderUI({
  
  histoDist()[[4]]
  
})
#####################################################################################################################################
############################# Heatmaps (bei Korrelationtable und Collinearity Table) ##############################################
##########################################################################################################################################

# Krrelationtable Output
output$heatmapCorrelationTable <- renderPlotly({
  
  if(is.null(input$LagForCorrelationTable)){return()}
  input$chooseTablevsHeader
  Values <- as.matrix(round(cortables()[[1]], digits = 2))
  plot_ly(z = ~Values, colors = colorRampPalette(c("blue", "black"))(10)) %>%
    layout(font = list(family = input$ownFont, size = input$sizeOwnFont), margin = list(l= 160), yaxis = list(tickfont = list(size = 10), title = "", ticks = "outside",
                                                        autoticks = T, tickmode = "array", ticktext = rownames(Values),tickvals = c(0:(nrow(Values)-1))), 
           xaxis = list(tickfont = list(size = 10), titlefont= list(size = 10), title = "Lags", tickangle = 45, ticks = "outside", tickmode = "array", ticktext = colnames(Values), 
                        tickvals = c(0:(nrow(Values)-1))))
  
})

#Collinearity Table Output
output$heatmapCollTable <- renderPlotly({
  
  Values <-round(cortables()[[2]], digits = 2)
  plot_ly(z = ~Values, colors = colorRampPalette(c("blue", "black"))(10)) %>%
    layout(font = list(family = input$ownFont, size = input$sizeOwnFont), margin = list(l= 160, b = 100), yaxis = list(tickfont = list(size = 10), title = "", ticks = "outside",
                        autoticks = T, tickmode = "array", ticktext = rownames(Values),tickvals = c(0:(nrow(Values)-1))), 
           xaxis = list(tickfont = list(size = 10), title = "", tickangle = 45, ticks = "outside", tickmode = "array", ticktext = colnames(Values), 
                        tickvals = c(0:(nrow(Values)-1))))
  
})

# hier ist die UI, die sich ver?ndert, je nach dem, ob RadioButton auf Table oder auf Heatmap ausgew?hlt wurde
output$TableHeatmap <- renderUI({
  
  if(input$chooseTablevsHeat == "table") {
    return(dataTableOutput("CorrelationTableComplete"))
  }
  
  if(input$chooseTablevsHeat == "heatmap"){
    return(plotlyOutput("heatmapCorrelationTable"))
  }
  
})

# hier ist die UI, die sich ver?ndert, je nach dem, ob RadioButton auf Table oder auf Heatmap ausgew?hlt wurde
output$TableHeatmapColl <- renderUI({
  
  withProgress(message = "Calculating correlation table, please wait",value=0.3, {
  
    if(input$chooseTablevsHeatColl == "table") {
      return(dataTableOutput("korrelation_ind"))
    }
    
    if(input$chooseTablevsHeatColl == "heatmap"){
      return(plotlyOutput("heatmapCollTable"))
    }
  })
  
}) 

##########################################################################################################################################
############################################################################ unscaled Time Series plot ##############################################
##########################################################################################################################################
#(hier sind 4 Plots m?glich, je nachdem, welche Dimensionengew?hlt wurden). Die UI ver?ndert sich, je nachdem, welche Dim gew?hlt wurde. (dann werden mehrere Input Eingaben
# m?glich)
output$choosevariablesUnscaledtimeseries<-renderUI({
  
  if(input$numerOfColsPlotly == 1 & input$numerOfRowsPlotly == 1){
      cor.data <- daten.under$base[ ,sapply(daten.under$base, is.numeric)]
      colnames <- names(cor.data)
      return(fluidRow(column(width = 6,
                    selectInput("variablesUnscaledtimeseriesOne", NULL, multiple = TRUE,
                    choices = colnames)
            ))
      )
  }
  if(input$numerOfColsPlotly == 2 & input$numerOfRowsPlotly == 1){
    cor.data <- daten.under$base[ ,sapply(daten.under$base, is.numeric)]
    colnames <- names(cor.data)
    return(list(fluidRow(
            column(width = 3,
              selectInput("variablesUnscaledtimeseriesOne", NULL, multiple = TRUE,
                          choices = colnames)
            ),
            column(width = 3,
              selectInput("variablesUnscaledtimeseriesTwo", NULL, multiple = TRUE,
                          choices = colnames)
            ))
    ))
  }
  if(input$numerOfColsPlotly == 1 & input$numerOfRowsPlotly == 2){
    cor.data <- daten.under$base[ ,sapply(daten.under$base, is.numeric)]
    colnames <- names(cor.data)
    return(list(fluidRow(
            column(width = 3,
              selectInput("variablesUnscaledtimeseriesOne", NULL, multiple = TRUE,
                          choices = colnames)
            ),
            column(width = 3,
              selectInput("variablesUnscaledtimeseriesTwo", NULL, multiple = TRUE,
                          choices = colnames)
            ))
    ))
  }
  if(input$numerOfColsPlotly == 2 & input$numerOfRowsPlotly == 2){
    cor.data <- daten.under$base[ ,sapply(daten.under$base, is.numeric)]
    colnames <- names(cor.data)
    return(list(fluidRow(
      column(width = 3,
        selectInput("variablesUnscaledtimeseriesOne", NULL, multiple = TRUE,
                    choices = colnames)
      ),
      column(width = 3,
        selectInput("variablesUnscaledtimeseriesTwo", NULL, multiple = TRUE,
                    choices = colnames)
      ),
      column(width = 3,
        selectInput("variablesUnscaledtimeseriesThree", NULL, multiple = TRUE,
                    choices = colnames)
      ),
      column(width = 3,
        selectInput("variablesUnscaledtimeseriesFour", NULL, multiple = TRUE,
                    choices = colnames)
      ))
    ))
  }
  
  
})

# Teil, der ausgef?hrt wird, wenn der Button Plot Time Series gew?hlt wurde. Hier wirde auch gepr?ft, wie viele Subplots erstellt 
# werden (Dim = 1-4 ?ber Rows und Columsn = 1 oder 2)
unscaledtimeseriesdygraph<- eventReactive(input$plotAllunscaledComp, {
  
  if(input$numerOfColsPlotly == 1 & input$numerOfRowsPlotly == 1){
    
    validate(
      need(!is.null(input$variablesUnscaledtimeseriesOne), "Please select variables to compare")
    )
    name.dep.varOne <- input$variablesUnscaledtimeseriesOne
    dat.vis <- daten.under$base
    index.varOne <- sapply(colnames(dat.vis), function(x) x %in% name.dep.varOne)
    dat.vis.relevantOne <- dat.vis[ ,index.varOne]
    namesOne <-names(dat.vis)[index.varOne] 
    datenOne<- xts(dat.vis.relevantOne, daten.under$base[[1]])
    plot1<-plot_ly()
    for(i in 1: ncol(datenOne)){
      plot1<-add_trace(plot1, y = coredata(datenOne)[,i], x=time(datenOne), line = list(color = eval(parse(text = paste0("input$col",i)))), name = namesOne[i], type = "scatter", mode = "lines+markers") %>% 
        layout(font = list(family = input$ownFont, size = input$sizeOwnFont), showlegend = TRUE)
    }
    return(plot1)
    
  }
  
  if(input$numerOfColsPlotly == 2 & input$numerOfRowsPlotly == 1){
    
    validate(
      need(!is.null(input$variablesUnscaledtimeseriesOne), "Please select variables to compare")
    )
    validate(
      need(!is.null(input$variablesUnscaledtimeseriesTwo), "Please select variables to compare")
    )
    
    name.dep.varOne <- input$variablesUnscaledtimeseriesOne
    dat.vis <- daten.under$base
    index.varOne <- sapply(colnames(dat.vis), function(x) x %in% name.dep.varOne)
    dat.vis.relevantOne <- dat.vis[ ,index.varOne]
    namesOne <-names(dat.vis)[index.varOne] 
    datenOne<- xts(dat.vis.relevantOne, daten.under$base[[1]])
    name.dep.varTwo <- input$variablesUnscaledtimeseriesTwo
    dat.vis <- daten.under$base
    index.varTwo <- sapply(colnames(dat.vis), function(x) x %in% name.dep.varTwo)
    dat.vis.relevantTwo <- dat.vis[ ,index.varTwo]
    namesTwo <-names(dat.vis)[index.varTwo]
    datenTwo<- xts(dat.vis.relevantTwo, daten.under$base[[1]])
    counterColor <- 1
    plot1 <- plot_ly()
    for(i in 1: ncol(datenOne)){
      plot1<-add_trace(plot1, y = coredata(datenOne)[,i], line = list(color = eval(parse(text = paste0("input$col",i)))), x=time(datenOne), name = namesOne[i], type = "scatter", mode = "lines+markers") %>% 
        layout(font = list(family = input$ownFont, size = input$sizeOwnFont))
      counterColor <- counterColor +1
    }
    plot2<- plot_ly()
    for(i in 1:ncol(datenTwo)){
      plot2<-add_trace(plot2, y = coredata(datenTwo)[,i], x=time(datenTwo), line = list(color = eval(parse(text = paste0("input$col",counterColor)))), name = namesTwo[i], type = "scatter", mode = "lines+markers") %>%
        layout(font = list(family = input$ownFont, size = input$sizeOwnFont))
      counterColor <- counterColor +1
    }
    return(subplot(plot1, plot2, shareY = T))
  }
  
  if(input$numerOfColsPlotly == 1 & input$numerOfRowsPlotly == 2){
    
    validate(
      need(!is.null(input$variablesUnscaledtimeseriesOne), "Please select variables to compare")
    )
    validate(
      need(!is.null(input$variablesUnscaledtimeseriesTwo), "Please select variables to compare")
    )
    
    name.dep.varOne <- input$variablesUnscaledtimeseriesOne
    dat.vis <- daten.under$base
    index.varOne <- sapply(colnames(dat.vis), function(x) x %in% name.dep.varOne)
    dat.vis.relevantOne <- dat.vis[ ,index.varOne]
    namesOne <-names(dat.vis)[index.varOne] 
    datenOne<- xts(dat.vis.relevantOne, daten.under$base[[1]])
    name.dep.varTwo <- input$variablesUnscaledtimeseriesTwo
    dat.vis <- daten.under$base
    index.varTwo <- sapply(colnames(dat.vis), function(x) x %in% name.dep.varTwo)
    dat.vis.relevantTwo <- dat.vis[ ,index.varTwo]
    namesTwo <-names(dat.vis)[index.varTwo] 
    datenTwo<- xts(dat.vis.relevantTwo, daten.under$base[[1]])
    counterColor <- 1
    plot1 <- plot_ly()
    for(i in 1: ncol(datenOne)){
      plot1<-add_trace(plot1, y = coredata(datenOne)[,i], x=time(datenOne), line = list(color = eval(parse(text = paste0("input$col",i)))), x=time(datenOne), name = namesOne[i], type = "scatter", mode = "lines+markers") %>%
        layout(font = list(family = input$ownFont, size = input$sizeOwnFont))
      counterColor <- counterColor +1
    }
    plot2<- plot_ly()
    for(i in 1:ncol(datenTwo)){
      plot2<-add_trace(plot2, y = coredata(datenTwo)[,i], x=time(datenTwo), line = list(color = eval(parse(text = paste0("input$col",counterColor)))), x=time(datenOne), name = namesTwo[i], type = "scatter", mode = "lines+markers") %>% 
        layout(font = list(family = input$ownFont, size = input$sizeOwnFont))
    }
    return(subplot(plot1, plot2, nrows = 2, shareX = T, shareY = F))
  }
  
  if(input$numerOfColsPlotly == 2 & input$numerOfRowsPlotly == 2){
    
    validate(
      need(!is.null(input$variablesUnscaledtimeseriesOne), "Please select variables to compare")
    )
    validate(
      need(!is.null(input$variablesUnscaledtimeseriesTwo), "Please select variables to compare")
    )
    validate(
      need(!is.null(input$variablesUnscaledtimeseriesThree), "Please select variables to compare")
    )
    validate(
      need(!is.null(input$variablesUnscaledtimeseriesFour), "Please select variables to compare")
    )
    
    
    name.dep.varOne <- input$variablesUnscaledtimeseriesOne
    dat.vis <- daten.under$base
    index.varOne <- sapply(colnames(dat.vis), function(x) x %in% name.dep.varOne)
    dat.vis.relevantOne <- dat.vis[ ,index.varOne]
    namesOne <-names(dat.vis)[index.varOne] 
    datenOne<- xts(dat.vis.relevantOne, daten.under$base[[1]])
    
    name.dep.varTwo <- input$variablesUnscaledtimeseriesTwo
    dat.vis <- daten.under$base
    index.varTwo <- sapply(colnames(dat.vis), function(x) x %in% name.dep.varTwo)
    dat.vis.relevantTwo <- dat.vis[ ,index.varTwo]
    namesTwo <-names(dat.vis)[index.varTwo] 
    datenTwo<- xts(dat.vis.relevantTwo, daten.under$base[[1]])
    
    name.dep.varThree <- input$variablesUnscaledtimeseriesThree
    dat.vis <- daten.under$base
    index.varThree <- sapply(colnames(dat.vis), function(x) x %in% name.dep.varThree)
    dat.vis.relevantThree <- dat.vis[ ,index.varThree]
    namesThree <-names(dat.vis)[index.varThree] 
    datenThree<- xts(dat.vis.relevantThree, daten.under$base[[1]])
    
    name.dep.varFour <- input$variablesUnscaledtimeseriesFour
    dat.vis <- daten.under$base
    index.varFour <- sapply(colnames(dat.vis), function(x) x %in% name.dep.varFour)
    dat.vis.relevantFour <- dat.vis[ ,index.varFour]
    namesFour <-names(dat.vis)[index.varFour] 
    datenFour<- xts(dat.vis.relevantFour, daten.under$base[[1]])
    counterColor <- 1
    plot1 <- plot_ly()
    for(i in 1: ncol(datenOne)){
      plot1<-add_trace(plot1, y = coredata(datenOne)[,i], x=time(datenOne), line = list(color = eval(parse(text = paste0("input$col",i)))), name = namesOne[i], type = "scatter", mode = "lines+markers") %>%
        layout(font = list(family = input$ownFont, size = input$sizeOwnFont))
      counterColor <- counterColor +1
    }
    plot2<- plot_ly()
    for(i in 1:ncol(datenTwo)){
      plot2<-add_trace(plot2, y = coredata(datenTwo)[,i], x=time(datenTwo), line = list(color = eval(parse(text = paste0("input$col",counterColor)))), name = namesTwo[i], type = "scatter", mode = "lines+markers") %>% 
        layout(font = list(family = input$ownFont, size = input$sizeOwnFont))
      counterColor <- counterColor +1
    }
    plot3<- plot_ly()
    for(i in 1:ncol(datenThree)){
      plot3<-add_trace(plot3, y = coredata(datenThree)[,i], x=time(datenThree), line = list(color = eval(parse(text = paste0("input$col",counterColor)))), name = namesThree[i], type = "scatter", mode = "lines+markers") %>%
        layout(font = list(family = input$ownFont, size = input$sizeOwnFont))
      counterColor <- counterColor +1
    }
    plot4<- plot_ly()
    for(i in 1:ncol(datenFour)){
      plot4<-add_trace(plot4, y = coredata(datenFour)[,i], x=time(datenFour), line = list(color = eval(parse(text = paste0("input$col",counterColor)))), x=time(datenOne), name = namesFour[i], type = "scatter", mode = "lines+markers") %>%
        layout(font = list(family = input$ownFont, size = input$sizeOwnFont))
      counterColor <- counterColor +1    
    }
    return(subplot(plot1, plot2,plot3, plot4, nrows = 2, shareX = T, shareY = F))
  }
  
})

output$unscaledtimeseriesplot<-renderPlotly({
  
  unscaledtimeseriesdygraph()
  
})

##########################################################################################################################################
#################################################################### Box Plots################################
##########################################################################################################################################
# eingabe der Variable f?r Boxplots scaled
output$boxplotvariablesscaled<-renderUI({
  
  categorialIndex <- vector()
  for(i in 1: ncol(daten.under$base)){
    if(is.factor(daten.under$base[,i])){
      categorialIndex <- c(categorialIndex, i)
    }
  }
  
  vis.data <- daten.under$base[ ,sapply(daten.under$base, is.numeric)]
  vis.names <- colnames(vis.data)
  

    return(selectInput("variablesboxplotsscaled", label = "Select variable", multiple = TRUE,
                         choices = vis.names))


})

# Erstellung der Box-Plots. Hier wird noch gep?ft, ob die Datenpunkte (jitter) auch noch angezeigt werden. Je nachdem werden verschiedene Plots generiert
output$boxplotsAllscaled<-renderPlotly({
  
  input$plotboxplotsscaled
  
  isolate({
    
    helpBool <- FALSE

    
    if(length(input$variablesboxplotsscaled) == 0 ){return(withProgress(message = "Please choose a variable", Sys.sleep(1.5)))}
    
    validate(
      need(!is.null(input$variablesboxplotsscaled), "Please select variables to compare")
    )

    
    if(helpBool == FALSE){
      
      namesVariables <- input$variablesboxplotsscaled
      
      dat.vis <- daten.under$base
      index.var <- sapply(colnames(dat.vis), function(x) x %in% namesVariables)
      dat.vis.relevant <- dat.vis[ ,index.var]
      
      if(!is.null(ncol(dat.vis.relevant))){
        datVisRelevant <- as.data.frame(apply(dat.vis.relevant, 2, function(x) (x - mean(x, na.rm = TRUE))/sd(x, na.rm = TRUE)))
      }
      if(is.null(ncol(dat.vis.relevant))){
        datVisRelevant <- data.frame((dat.vis.relevant - mean(dat.vis.relevant, na.rm = TRUE))/sd(dat.vis.relevant, na.rm = TRUE))
      }
    
      if(input$showdatapointsboxplotscaled == TRUE){
        plot1 <- plot_ly()
        for(i in 1:length(namesVariables)){
          colorNr <- colorRampPalette(c("blue", "black"))(length(namesVariables))[i]
          plot1 <- add_trace(plot1, y = na.omit(datVisRelevant[,i]), color = eval(parse(text = paste0("I('", colorNr,"')"))),  boxpoints = "all", jitter = 0.3, type = "box", name = namesVariables[i]) %>%
            layout(font = list(family = input$ownFont, size = input$sizeOwnFont))
        }
        return(plot1)
      }
      if(input$showdatapointsboxplotscaled == FALSE){
        plot1 <- plot_ly()
        for(i in 1:length(namesVariables)){
          colorNr <- colorRampPalette(c("blue", "black"))(length(namesVariables))[i]
          plot1 <- add_trace(plot1, y = na.omit(datVisRelevant[,i]), color = eval(parse(text = paste0("I('", colorNr,"')"))), type = "box", name = namesVariables[i]) %>%
            layout(font = list(family = input$ownFont, size = input$sizeOwnFont))
        }
        return(plot1)
      }
    }
    
    if(helpBool == TRUE){
      
      namesAllVariables <- c(input$variablesboxplotsscaled, input$boxScaledChooseCat)
      namesVariablesNum <- input$variablesboxplotsscaled
      nameVariableCat <- input$boxScaledChooseCat
      
      dat.vis <- daten.under$base
      indexAll <- sapply(colnames(dat.vis), function(x) x %in% namesAllVariables)
      dat.vis.relevant <- dat.vis[ ,indexAll]
      indexVarNum <- which(names(dat.vis.relevant)%in%input$variablesboxplotsscaled)
      indexVarCat <- which(names(dat.vis.relevant)%in%input$boxScaledChooseCat)

      if(!is.null(ncol(dat.vis.relevant))){
        dat.vis.relevant[,indexVarNum] <- as.data.frame(apply(dat.vis.relevant[,indexVarNum], 2, function(x) (x - mean(x, na.rm = TRUE))/sd(x, na.rm = TRUE)))
      }
      if(is.null(ncol(dat.vis.relevant))){
        dat.vis.relevant[,indexVarNum] <- data.frame((dat.vis.relevant - mean(dat.vis.relevant, na.rm = TRUE))/sd(dat.vis.relevant, na.rm = TRUE))
      }
      
      dataForBoxpot<-dat.vis.relevant
      dataForBoxpot<-data.frame(xVariable = dataForBoxpot[,indexVarNum[1]], category = dat.vis.relevant[,indexVarCat], variable = rep(namesVariablesNum[1], nrow(dat.vis.relevant)))
      if(length(namesVariablesNum)>1){
        for(i in 2:length(namesVariablesNum)){
          dataForBoxpot<- rbind(dataForBoxpot, data.frame(xVariable = dat.vis.relevant[,indexVarNum[i]], category = dat.vis.relevant[,indexVarCat], variable = rep(namesVariablesNum[i], nrow(dat.vis.relevant))))
        }
      }

      if(input$showdatapointsboxplotscaled == TRUE){
        plot1<- plot_ly(data = dataForBoxpot, y = ~xVariable, color = ~category, x=~variable, boxpoints = "all", 
                  jitter = 0.3, type = "box",colors = colorRampPalette(c("blue", "black"))(10)) %>%
                  layout(font = list(family = input$ownFont, size = input$sizeOwnFont), boxmode = "group", xaxis = list(title = ""), yaxis = list(title = ""))
        return(plot1)
      }
      
      if(input$showdatapointsboxplotscaled == FALSE){
        plot1<- plot_ly(data = dataForBoxpot, y = ~xVariable, color = ~category, x=~variable, type = "box",
                  colors = colorRampPalette(c("blue", "black"))(10)) %>% 
                  layout(font = list(family = input$ownFont, size = input$sizeOwnFont), boxmode = "group", xaxis = list(title = ""), yaxis = list(title = ""))
        return(plot1)
      }
    }
      
  })
  
  
})


# ab hier Box Plots unscaled
output$boxplotvariables<-renderUI({
  
  categorialIndex <- vector()
  for(i in 1: ncol(daten.under$base)){
    if(is.factor(daten.under$base[,i])){
      categorialIndex <- c(categorialIndex, i)
    }
  }
  
  vis.data <- daten.under$base[ ,sapply(daten.under$base, is.numeric)]
  vis.names <- colnames(vis.data)
  

  return(selectInput("variablesboxplots", label = "Select variable", multiple = TRUE,
                       choices = vis.names))
  

  
})


# Erstellung der Box-Plots. Hier wird noch gep?ft, ob die Datenpunkte (jitter) auch noch angezeigt werden. Je nachdem werden verschiedene Plots generiert
output$boxplotsAll<-renderPlotly({
  
  input$plotboxplots
  
  isolate({
    
    helpBool <- FALSE

    if(length(input$variablesboxplots) == 0 ){return(withProgress(message = "Please choose a variable", Sys.sleep(1.5)))}
    
    validate(
      need(!is.null(input$variablesboxplots), "Please select variables to compare")
    )
    
    
    if(helpBool == FALSE){
      
      namesVariables <- input$variablesboxplots
      
      dat.vis <- daten.under$base
      index.var <- sapply(colnames(dat.vis), function(x) x %in% namesVariables)
      dat.vis.relevant <- dat.vis[ ,index.var]
      
      if(input$showdatapointsboxplot == TRUE){
        plot1 <- plot_ly()
        for(i in 1:length(namesVariables)){
          colorNr <- colorRampPalette(c("blue", "black"))(length(namesVariables))[i]
          plot1 <- add_trace(plot1, y = na.omit(dat.vis.relevant[,i][[1]]), color = eval(parse(text = paste0("I('", colorNr,"')"))),  boxpoints = "all", jitter = 0.3, type = "box", name = namesVariables[i]) %>%
            layout(font = list(family = input$ownFont, size = input$sizeOwnFont))
        }
        return(plot1)
      }
      if(input$showdatapointsboxplot == FALSE){
        plot1 <- plot_ly()
        for(i in 1:length(namesVariables)){
          colorNr <- colorRampPalette(c("blue", "black"))(length(namesVariables))[i]
          plot1 <- add_trace(plot1, y = na.omit(dat.vis.relevant[,i][[1]]), color = eval(parse(text = paste0("I('", colorNr,"')"))), type = "box", name = namesVariables[i]) %>% 
            layout(font = list(family = input$ownFont, size = input$sizeOwnFont))
        }
        return(plot1)
      }
    }
    
    if(helpBool == TRUE){
      
      namesAllVariables <- c(input$variablesboxplots, input$boxUnscaledChooseCat)
      namesVariablesNum <- input$variablesboxplots
      nameVariableCat <- input$boxUnscaledChooseCat
      
      dat.vis <- daten.under$base
      indexAll <- sapply(colnames(dat.vis), function(x) x %in% namesAllVariables)
      dat.vis.relevant <- dat.vis[ ,indexAll]
      indexVarNum <- which(names(dat.vis.relevant)%in%input$variablesboxplots)
      indexVarCat <- which(names(dat.vis.relevant)%in%input$boxUnscaledChooseCat)
      
      dataForBoxpot<-dat.vis.relevant
      dataForBoxpot<-data.frame(xVariable = dataForBoxpot[,indexVarNum[1]], category = dat.vis.relevant[,indexVarCat], variable = rep(namesVariablesNum[1], nrow(dat.vis.relevant)))
      if(length(namesVariablesNum)>1){
        for(i in 2:length(namesVariablesNum)){
          dataForBoxpot<- rbind(dataForBoxpot, data.frame(xVariable = dat.vis.relevant[,indexVarNum[i]], category = dat.vis.relevant[,indexVarCat], variable = rep(namesVariablesNum[i], nrow(dat.vis.relevant))))
        }
      }
      
      if(input$showdatapointsboxplot == TRUE){
        plot1<- plot_ly(data = dataForBoxpot, y = ~xVariable, color = ~category, x=~variable, boxpoints = "all", 
                        jitter = 0.3, type = "box",colors = colorRampPalette(c("blue", "black"))(10)) %>%
          layout(font = list(family = input$ownFont, size = input$sizeOwnFont), boxmode = "group", xaxis = list(title = ""), yaxis = list(title = ""))
        return(plot1)
      }
      
      if(input$showdatapointsboxplot == FALSE){
        plot1<- plot_ly(data = dataForBoxpot, y = ~xVariable, color = ~category, x=~variable, type = "box",
                        colors = colorRampPalette(c("blue", "black"))(10)) %>% 
          layout(font = list(family = input$ownFont, size = input$sizeOwnFont), boxmode = "group", xaxis = list(title = ""), yaxis = list(title = ""))
        return(plot1)
      }
    }
    
  })
  
  
})

output$depVar <- renderUI({
  
  selectInput("depVar", "Choose dependent Variable", choices = names(daten.under$base[, -1]))
})

