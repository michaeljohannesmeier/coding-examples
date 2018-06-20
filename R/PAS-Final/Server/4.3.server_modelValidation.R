# Wird gerade nicht in der App verwendet, aber bitte trotzdem anschauen (@Fraunhofer)

# Reactive Values dieses Tabs beinhalten zum einen die grafische Darstellung sowie ein data.frame zur statistischen Auswertung
crossfold <- reactiveValues(
  
  fold.graph = 0,
  fold.evaluation = data.frame()
  
)

# Dieses Drop-Down organisiert die Auswahl der verschiedenen zur Verfuegung stehenden Modelle (automatisch, manuell, stored)
output$chooseModelFold <- renderUI({
  
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
    erg.ui.list[[1]] <- (selectInput("modells.fold", label = h3(strong("Choose model to challenge")), choices = c("Automatic model", "Manual model", "Stored model")))
  } else if (length(regression.modelle$gespeichertes.modell) != 1 && length(regression.modelle$manuelles.modell) != 1){
    erg.ui.list[[1]] <- (selectInput("modells.fold", label = h3(strong("Choose model to challenge")), choices = c("Manual model", "Stored model")))
  } else if(length(regression.modelle$gespeichertes.modell) != 1 && length(regression.modelle$automatisches.modell) != 1){
    erg.ui.list[[1]] <- (selectInput("modells.fold", label = h3(strong("Choose model to challenge")), choices = c("Automatic model", "Stored model")))
  } else if(length(regression.modelle$manuelles.modell) != 1 && length(regression.modelle$automatisches.modell) != 1){
    erg.ui.list[[1]] <- (selectInput("modells.fold", label = h3(strong("Choose model to challenge")), choices = c("Automatic model", "Manual model")))
  } else if(length(regression.modelle$manuelles.modell) != 1){
    erg.ui.list[[1]] <- (selectInput("modells.fold", label = h3(strong("Choose model to challenge")), choices = c("Manual model")))
  } else if(length(regression.modelle$automatisches.modell) != 1){
    erg.ui.list[[1]] <- (selectInput("modells.fold", label = h3(strong("Choose model to challenge")), choices = c("Automatic model")))
  }
  
  erg.ui.list[[3]] <- numericInput("folds", "Choose amount of folds", min = 2, value = 2, width = "250px")
  erg.ui.list[[4]] <- actionButton("performCross", "Perform validation")
  
  return(erg.ui.list)
})

# Durchfuehrung der cross-fold-validation und Modifikation der reactiveValues
observeEvent(input$performCross, {
  
  regression.temp <- 0
  
  modell.type <- input$modells.fold
  
  if(modell.type == "Manual model"){
    regression.temp <- regression.modelle$manuelles.modell
  } else if(modell.type == "Automatic model"){
    regression.temp <- regression.modelle$automatisches.modell
  } else if(modell.type == "Stored model"){
    regression.temp <- regression.modelle$gespeichertes.modell
  }
  
  # Aufbereitung der noetigen Daten
  cross.fold <- regression.temp[[1]]
  cross.fold.data <- cross.fold$model
  lm.lags.max <- regression.temp[[3]][2]

  folds.amount <- input$folds
  
  # Durchfuehrung der Cross-Validation
  cv.evaluation <- DAAG::cv.lm(data = cross.fold.data, form.lm = cross.fold, m = folds.amount)
  prediction.location.cv <- dim(cv.evaluation)[2]

  # Vergleichbarkeit der Fittings schaffen
  abweichnung.all <- (sum((cv.evaluation[[1]] - cv.evaluation[[dim(cv.evaluation)[2] - 1]])^2, na.rm = TRUE))/attributes(cv.evaluation)$df
  abweichnung.fold <- (sum((cv.evaluation[[1]] - cv.evaluation[[dim(cv.evaluation)[2]]])^2, na.rm = TRUE))/attributes(cv.evaluation)$df

  relation.deviation <- abweichnung.fold/abweichnung.all
  
  evaluation.table <- as.tbl(data.frame(Figures =c("Deviation without cross-validation", "Deviation with cross-validation", "Relation"),
                                        Values = c(abweichnung.all, abweichnung.fold, relation.deviation)))
  
  crossfold$fold.evaluation <- evaluation.table
  
  datum <- input$reg.date

  freq <- 0
  
  if(input$FREQ.reg == "quarterly"){
    freq <- 4
  }else if(input$FREQ.reg == "monthly"){
    freq <- 12
  }
  
  # Sollten sich NA-Werte in einem Datensatz befinden, sind diese vorzugsweise zu Beginn der zeitlichen
  # Betrachtung der Variablen. Diese Zeitpunkte bei denen sich NA in zumindest einer Variablen befindet,
  # werden für die Modellberechnung auf Basis der ausgewählten Variable außen vor gelassen. Daher muss
  # die zu plottende Zeitserie der Cross-Folds entsprechend geshifted werden.
  time.shift <- dim(regression.temp[[2]])[1] - dim(cross.fold.data)[1]
  
  # Zusammensetzen der Zeitserie der Historischen Werte, der vom Modell nachtraeglich gefitteten Werte sowie
  # der via Cross-Validation durch Auslassen bei der Modellerstellung gefitteten Werte
  dat.reg <- daten.under$base[ ,sapply(daten.under$base, is.numeric)]
  index.depVar <- which(attributes(dat.reg)$names == input$depVar)
  ts.dat.reg <- ts(dat.reg[ ,index.depVar], start = c(year(datum), month(datum)), frequency = freq)
  ts.pred.all <- ts(cv.evaluation[[prediction.location.cv - 1]], start = c(year(datum), month(datum) + lm.lags.max + time.shift), frequency = freq)
  ts.pred.cv <- ts(cv.evaluation[[prediction.location.cv]], start = c(year(datum), month(datum) + lm.lags.max + time.shift), frequency = freq)
  
  ts.gesamt <- cbind(ts.dat.reg, ts.pred.all, ts.pred.cv)

  colnames(ts.gesamt) <- c("Historical data", "Prediction using all values", "Prediction using Cross-Validation")
  
  fold.plot <- dygraph(ts.gesamt, main = paste(folds.amount, "Fold-Cross-Validation", modell.type, sep = " ")) %>% dyRangeSelector() %>%
    dyLegend(width = 800) %>% dyOptions(drawPoints = TRUE, pointSize = 2)
  
  crossfold$fold.graph <- fold.plot
  
})

# Ausgabe des Cross-Validation-Ergebnisses
output$foldErg <- renderDygraph({
  
  if(!(class(crossfold$fold.graph) == "dygraphs")[1]) return()
  
  crossfold$fold.graph
  
})

# Ausgabe der Evaluationtabelle
output$eval.fold <- renderTable({
  
  if(dim(crossfold$fold.evaluation)[1] == 0) return()
  
  crossfold$fold.evaluation
})

# Ausgabe Erklaerungstext Tabelle
output$explain <- renderUI({
  
  if(dim(crossfold$fold.evaluation)[1] == 0) return()
  
  p("The table below displays the", strong("mean squared errors"), "of the predicted values of", strong("the model itself"), "and 
      the", strong("calculated cross-validation values"), "regarding the", strong("historical values"), "of the dependent variable.
      High values of", strong("Relation"), "indicate overfitting")
})