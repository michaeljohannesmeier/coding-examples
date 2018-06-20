## diese Server Datei bezieht sich auf den Punkt Rearrange Data unter Data preparation


# Automatisches generieren einer Auswahlliste der möglichen skalierbaren Variablen
output$scale.var <- renderUI({
  
  input$scale.data 
  input$rescale.data 
  
  cor.data <- daten.under$base[ ,sapply(daten.under$base, is.numeric)]
  colnames <- names(cor.data)
  scale.names <- row.names(daten.under$scale.values)
  colnames <- colnames[!(colnames %in% scale.names)]
  
  selectInput("scale", h4(strong("Choose variable to scale")),
              choices = colnames, width = 300)
  
})

# Bei Betaetigung des Buttons "scale.data" werden die ausgewaehlten Daten um die 0 im Intervall -1 bis 1 zentriert
# Dabei wird von den Daten der Mittelwert abgezogen und durch die Range geteilt (Max-Min)
observeEvent(input$scale.data, {
  
  if(index$split.true.false == TRUE){
    withProgress(message = "First unsplit Data",value=0.1, {
      setProgress(1)
      Sys.sleep(1.5)
    })
  }
  
  var.name <- input$scale
  
  if(var.name == "") return()
  
  daten.temp <- daten.under$base
  var.index<- which(attributes(daten.temp)$names == var.name)
  mean.temp <- mean(daten.temp[[var.index]], na.rm = TRUE)
  
  
  sd.temp <- sd(daten.temp[[var.index]], na.rm = TRUE)
  var.index.numeric <- which(attributes(daten.under$data.temp.1)$names == var.name)
  
  if(!(var.name %in% row.names(daten.under$scale.values))){
    if(length(daten.under$scale.values) == 0){
      daten.under$data.temp.1[[var.index.numeric]] <- (daten.under$data.temp.1[[var.index.numeric]] - mean.temp)/sd.temp
      daten.under$data.temp.2[[var.index.numeric]] <- (daten.under$data.temp.2[[var.index.numeric]] - mean.temp)/sd.temp
      daten.under$base[[var.index]] <- (daten.under$base[[var.index]] - mean.temp)/sd.temp
      daten.under$scale.values <- as.tbl(data.frame(Mean = mean.temp, Sd = sd.temp))
      row.names(daten.under$scale.values)[1] <- var.name
    }else {
      daten.under$data.temp.1[[var.index.numeric]] <- (daten.under$data.temp.1[[var.index.numeric]] - mean.temp)/sd.temp
      daten.under$data.temp.2[[var.index.numeric]] <- (daten.under$data.temp.2[[var.index.numeric]] - mean.temp)/sd.temp
      daten.under$base[[var.index]] <- (daten.under$base[[var.index]] - mean.temp)/sd.temp
      daten.under$scale.values <- rbind(daten.under$scale.values, c(mean.temp, sd.temp))
      row.names(daten.under$scale.values)[dim(daten.under$scale.values)[1]] <- var.name
    }
  }
  
  daten.under$data.scale <- daten.under$base
  
})


# Die Moeglichkeit der Rescalierung besteht ebenfalls. Diese Funktion organisiert eine Liste, die die schon skalierten Variablen
# enthaelt, um eine Entsprechende fuer die Rescalierung auszuwaehlen.
output$rescale.var <- renderUI({
  
  input$scale.data
  input$rescale.data
  
  names <- row.names(daten.under$scale.values)
  
  if(length(names) == 0) return()
  
  list(selectInput("rescale", h4(strong("Choose variable to rescale")), choices = names),
       p("By pressing the", strong("Rescale-Button"), "the chosen data will be set to the", strong("Default-State.")),
       actionButton("rescale.data", "Rescale chosen variable"))
})

# Durch BetÃƒÂ¤tigung des "rescale" Buttons wird die ausgewaehlt Variable wieder auf ihre Ausgangsform gebracht. Dabei werden 
# die skalierten Daten mit der Range (Max-Min) multipliziert und mit dem Mittelwert addiert
observeEvent(input$rescale.data, {
  
  if(index$split.true.false == TRUE){
    return(withProgress(message = "First unsplit Data",value=0.1, {
      setProgress(1)
      Sys.sleep(1.5)
      })
    )}
  
  var.name <- input$rescale
  daten.temp <- daten.under$base
  var.index<- which(attributes(daten.temp)$names == var.name)
  var.index.numeric <- which(attributes(daten.under$data.temp.1)$names == var.name)
  var.index.scale.values <- which(row.names(daten.under$scale.values) == var.name)
  
  daten.under$base[[var.index]] <- (daten.under$base[[var.index]] * daten.under$scale.values[var.index.scale.values, 2][[1]]) + daten.under$scale.values[var.index.scale.values, 1][[1]]
  daten.under$data.temp.1[[var.index.numeric]] <- (daten.under$data.temp.1[[var.index.numeric]]* daten.under$scale.values[var.index.scale.values, 2][[1]]) + daten.under$scale.values[var.index.scale.values, 1][[1]]
  daten.under$data.temp.2[[var.index.numeric]] <- (daten.under$data.temp.2[[var.index.numeric]]* daten.under$scale.values[var.index.scale.values, 2][[1]]) + daten.under$scale.values[var.index.scale.values, 1][[1]]
  
  daten.under$data.scale <- daten.under$base
  names <- row.names(daten.under$scale.values)[- var.index.scale.values]
  daten.under$scale.values <- daten.under$scale.values[- var.index.scale.values, ]
  row.names(daten.under$scale.values) <- names
  
})



# Erstellen einer Auswahlliste fuer die Variable die punktuell verÃƒÂ¤ndert werden soll
output$tweak.var <- renderUI({
  
  cor.data <- daten.under$base[ ,sapply(daten.under$base, is.numeric)]
  colnames <- names(cor.data)
  selectInput("tweak.variable", h4(strong("Choose variable to tweak")),
              choices = colnames)
  
})

#nach betätigen des Buttons Tweak Data werden einzelne Datenwerte verädnert werden
observeEvent(input$tweak, {
  
  if(index$split.true.false == TRUE){
    withProgress(message = "First unsplit Data",value=0.1, {
      setProgress(1)
      Sys.sleep(1.5)
    })
  }
  
  daten.temp <- daten.under$base
  index.var <- which(attributes(daten.temp)$names == input$tweak.variable)
  
  if(class(daten.temp[[1]]) != "Date") return()
  
  datum.tweak <- input$tweak.date
  is.in.date.range <- datum.tweak %in% daten.temp[[1]]
  new.value <- input$tweak.value
  
  if(is.in.date.range == FALSE){
    return
  } else {
    index.tweak <- which(daten.temp[[1]] == datum.tweak)
    daten.temp[index.tweak, index.var] <- new.value
    daten.under$data.scale <- daten.temp
    daten.under$base <- daten.temp
    daten.under$default2 <-daten.temp
    daten.under$data.temp.1 <- daten.under$data.scale[ ,sapply(daten.under$data.scale, is.numeric)]
    daten.under$data.temp.2 <- daten.under$data.scale[ ,sapply(daten.under$data.scale, is.numeric)]
  }
  
})



# hier wird der Datensatz unter Show data wiedergegeben
output$contents2 <- renderDataTable({
  
  withProgress(message = "reading data, please wait",value=0.1,{
    
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


############################################################################################
########### Hier folgen die "Hilfstexte nach drücken der blauen Fragezeichen#################
#############################################################################################


output$texthelp2<-renderUI({
  "By pressing the button 'Scale choosen Variable' the chosen variable will be scaled by subtracting the mean and dividing by the standard deviation of the data. "
})

output$texthelp3<-renderUI({
  list(p("Select", strong("current time format"), "of the data set (e.g. saved as year-data, quartal-data, etc.)."),
       p("Select", strong("desired time format"), "of the data set (e.g. want to", strong("convert data layout"), "year to quartal, quartal to month)."),
       p("Select", strong("start date"), "of underlying data."))
})



output$texthelp4<-renderUI({
  p("If the layout of the underlying data is in", strong("desired shape"), "the following inputfields enable the possibility
    to", strong("tweak individual data points"), "of an arbitrary variable.")
  
}) 


output$texthelp5<-renderUI({
  list(p("If the layout of the underlying data is in", strong("desired shape"), "the following inputfields enable the possibility
         to", strong("interpolate"), "the underlying data", strong("based"), "on the",strong("current time format"), "(e.g. yearly or quartaly data) and the", strong("desired time"),
         "format."),
       p(strong("Pay attention"),"to choose the same formats as selected in section", strong("'2. Customizing of whole data set'")," and
         to the necessary", strong("completeness of the current formated data"), "(e.g. data needs to be provided for all quartals in range.)."),
       p("Sometimes data need to be", strong("divided between the inserted time steps"), "(quartal revenue to monthly revenue) so,",
         strong("Split"),"is the right choice."),
       p("If the data is",strong("continous"),"(e.g. Index)",strong("linear interpolation (Linear Fill)"),"is one possibility to", strong("fill up"), "inserted time steps."),
       p("If the data should be split it es necessary that the" , strong("weights"), "below", strong("sum up to 1."))
       
       
       )
}) 

output$texthelp6<-renderUI({
  p("In case that the", strong("underlying data"), "should be", strong("reset to its initial state"), "press the button 'Reset to initial data set'")
}) 

