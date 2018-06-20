output$checkboxreportplots<-renderUI({
  
  if(length(names(report$plots)) == 0){return(
    list(p(strong("Add saved scatter plots")),
         p("No scatter plot graph saved yet")))}
  checkboxGroupInput("reportlistplots", "Add saved scatter plots", choices = names(report$plots))

  
})

output$checkboxreportmatrix<-renderUI({
  
  if(length(names(report$matrices)) == 0){return(
    list(p(strong("Add saved matrix plots")),
        p("No matrix plot graph saved yet")))}
  checkboxGroupInput("reportlistmatrix", "Add saved scatter matrices", choices = names(report$matrices))
  
})

output$checkboxreporttimeseriesplotAllComp<-renderUI({
  
  if(length(report$timeseriesplotAllComp) == 0){return(
    list(p(strong("Add saved timeseries graph")),
        p("No timeseries graph saved yet")))}
  checkboxGroupInput("reportlisttimeseriesplotAllComp", "Add saved timeseries", choices = names(report$timeseriesplotAllComp))
  
})

output$checkboxreportcorrelationablehole<-renderUI({
  if(report$collcorr == 0){return(
    list(p(strong("Add appendix")),
         p("No appendix saved yet")))}
  checkboxGroupInput("reportlistcorrcolltable", "Add appendix tables", choices = report$collcorr)
  
})

output$checkboxintroconclusionremarks<-renderUI({

  checkboxGroupInput("introconclucheckbox", "Add remarks", choices = c("Introduction remarks", "Conclusion remarks"))
  
})





output$downloadReport <- downloadHandler(
  filename = function() {
    paste('my-report', sep = '.', switch(
      input$format, PDF = 'pdf', HTML = 'html', Word = 'docx'
    ))
  },
  
  content = function(file) {
    src <- normalizePath('Reports\\report.Rmd')
    
    file.copy(src, 'Reports\\report.Rmd')
    
    library(rmarkdown)
    out <- render('Report\\report.Rmd', switch(
      input$format,
      PDF = pdf_document(), HTML = html_document(), Word = word_document()
    ))
    file.rename(out, file)
  }
)

output$reportploteins<-renderPlot({

  if(is.null(input$reportlistplots)){return()}
  if(is.null(report$plots[[input$reportlistplots[1]]])){return()}
  plot(report$plots[[input$reportlistplots[1]]])
  
})

output$reportplotzwei<-renderPlot({
  
  if(is.null(report$plots[[input$reportlistplots[2]]])){return()}
  plot(report$plots[[input$reportlistplots[2]]])
  
})

output$reportmatrixeins<-renderPlot({
  
  if(is.null(report$matrices[[input$reportlistmatrix[1]]])){return()}
  plot(report$matrices[[input$reportlistmatrix[1]]])
  
})

output$reportmatrixzwei<-renderPlot({
  
  if(is.null(report$matrices[[input$reportlistmatrix[2]]])){return()}
  plot(report$matrices[[input$reportlistmatrix[2]]])
  
})


output$timeseriesreportgraph <-renderDygraph({
  
  if(is.null(input$reportlisttimeseriesplotAllComp)){return()}
  
  if(length(report$timeseriesplotAllComp) == 0){return()}
  report$timeseriesplotAllComp[[1]]

  
})

output$reporttimeseriestableplotAllComp <-renderTable({
  
  if(is.null(input$reportlisttimeseriesplotAllComp)){return()}
  
  if(length(report$timeseriesplotAllComp) == 0){return()}
  report$korrelationtableplotAllComp
  
})

output$correlationtableholereport<-renderTable({
  
  cbind("Variable" = rownames(cortables()[[1]]), round(cortables()[[1]], digits = 2))[,-1]
  
})


output$collinearitytableholereport<-renderDataTable({
  
  cbind("Variable" = rownames(cortables()[[2]]), round(cortables()[[2]], digits = 2))[,-1]
  
}, options = list(pageLength = 10, scrollX = TRUE))

observeEvent(input$deletegraph, {
  if(length(input$reportlistplots) == 1){
    report$plots[[input$reportlistplots[1]]]<-NULL
  }  
  
  if(length(input$reportlistplots) == 2){
    report$plots<-list()
  }
  
  if(length(input$reportlistmatrix) == 1){
    report$matrices[[input$reportlistmatrix[1]]]<-NULL
  }
  if(length(input$reportlistmatrix) == 2){
    report$matrices<-list()
  }
  if(length(input$reportlisttimeseriesplotAllComp) == 1){
    report$timeseriesplotAllComp = list()
    report$korrelationtableplotAllComp = 0
    report$correlationtablehole = 0
  }
  
  withProgress(message = "Saved items removed", Sys.sleep(1.5))
  
  
})

output$reportstoredexplanationmodel<-renderDygraph({
  
  regression.values$save.reg
  
  regression.mod <- regression.modelle$gespeichertes.modell
  
  if(length(regression.mod) == 1)return()
  
  s2 <- regression.mod[[4]]
  
  dat.reg <- daten.under$base[ ,sapply(daten.under$base, is.numeric)]
  count <- 1:length(dat.reg[[1]])
  dat.reg <- cbind(count, dat.reg)
  index.depVar <- which(attributes(dat.reg)$names == isolate(input$depVar))
  
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
  
  if(lags[2] >= 0){
    count.2 <- as.data.frame((lags[1] + 1):(length(dat.reg[[1]])))
  } else if(lags[1] <= 0){
    count.2 <- as.data.frame(1:(length(dat.reg[[1]]) - abs(lags[2])))
  } else {
    count.2 <- as.data.frame((lags[1] + 1):(length(dat.reg[[1]]) - abs(lags[2])))
  }
  
  
  ts.daten.predict <- xts(predict.depVar, daten.under$base[[1]][(max(lags) + 1):length(daten.under$base[[1]])])
  ts.daten.ges <- cbind("Initial data" = ts.dat.reg,"Fitted data via regression" = ts.daten.predict)
  
  regression.store.plot <- dygraph(ts.daten.ges, main = isolate(input$depVar)) %>% dyRangeSelector() %>%
    dyLegend(width = 800) %>% dyOptions(drawPoints = TRUE, pointSize = 2)
  
  report$regression.store.plotzwei<-ts.daten.ges
  regression.store.plot 
})

output$reportstoredcoefficients<-renderTable({
  regression.modelle$regression.coefficent
})

output$reportstoredquality<-renderTable(
  
    regression.modelle$regression.quality
)

output$reportstoredlag<-renderTable(
      
    if(regression.values$save.reg != 0){
      
      lags <- regression.modelle$gespeichertes.modell[[4]]
      lags.store <- data.frame(lags)
      
      rownames(lags.store) <- attributes(regression.modelle$gespeichertes.modell[[2]])$names
      
      lags.store
    }
)

output$reportforecasttable<-renderTable(
    arima.values$tabelle.variablen
)
output$reportstoredforecastfinal<-renderDygraph(
  
    graph.forecast()[[1]]
)
output$reportpredictionresults<-renderTable(
  
    report$prediction.results
)

output$headerReport<-renderUI({
  
  h2(strong(paste("Evaluation of the explanation model and forecast for", input$depVar)))
  
})

output$headervisual<-renderUI({
  print("222333rrrr")
  print(input$reportlisttimeseriesplotAllComp)

  if(length(report$timeseriesplotAllComp) == 0 & length(report$plots) == 0 & length(report$matrices) == 0){return()}
     
  if(is.null(input$reportlistplots) & is.null(input$reportlistmatrix) & is.null(input$reportlisttimeseriesplotAllComp)){return()}
  print("hierhierhiersss")
  h3(strong("Visualisation of data"))
  
})



################################################################################################################


output$scatterheader<-renderUI({
  
  indexplot<-0
  
  if(!is.null(input$reportlistplots)){
    if(is.null(report$plots[[input$reportlistplots[1]]]) & is.null(report$plots[[input$reportlistplots[2]]])  ){indexplot<-0}
    if(!is.null(report$plots[[input$reportlistplots[1]]]) & is.null(report$plots[[input$reportlistplots[2]]])  ){indexplot<-1}
    if(!is.null(report$plots[[input$reportlistplots[1]]]) & !is.null(report$plots[[input$reportlistplots[2]]])  ){indexplot<-2}
  }
  
  if(is.null(input$reportlistplots)){return()}
  
  if(!is.null(report$plots[[input$reportlistplots[1]]]) & length(input$reportlistplots) == 1){return(
  list(
  h4(strong("Scatter plots")),
  p("The following scatter plot can give you a first impression of the relationship of the two respectively choosen
            quantitive variables. Be aware that the detected relationship may not hold in a multivariate context."),
  p(paste("The scatter plot shows the relationship between",report$plots[[input$reportlistplots[1]]]$labels[1],
          "and" ,report$plots[[input$reportlistplots[1]]]$labels[2]))
  )
  )}
    
  if(length(input$reportlistplots) == 2){return(
    list(
    h4(strong("Scatter plots")),
    p("The following scatter plot can give you a first impression of the relationship of the two respectively choosen
      quantitive variables. Be aware that the detected relationship may not hold in a multivariate context."),
    p(paste("The left scatter plot shows the relationship between", report$plots[[input$reportlistplots[1]]]$labels[1], 
            "and", report$plots[[input$reportlistplots[1]]]$labels[2],". The right scatter plot the relationship between", 
            report$plots[[input$reportlistplots[2]]]$labels[1], "and", report$plots[[input$reportlistplots[2]]]$labels[2]),".")
    )
  )}
    
    
})

output$matrixheadereins<-renderUI({
  
  indexmatrix<-0
  
  if(!is.null(input$reportlistmatrix)){
    if(is.null(report$matrices[[input$reportlistmatrix[1]]]) & is.null(report$matrices[[input$reportlistmatrix[2]]])){indexmatrix<-0}
    if(!is.null(report$matrices[[input$reportlistmatrix[1]]]) & is.null(report$matrices[[input$reportlistmatrix[2]]])){indexmatrix<-1}
    if(!is.null(report$matrices[[input$reportlistmatrix[1]]]) & !is.null(report$matrices[[input$reportlistmatrix[2]]])){indexmatrix<-2}
  }
  
  if(is.null(input$reportlistmatrix)){return()}
  
  if(!is.null(report$matrices[[input$reportlistmatrix[1]]])){

    
    if(indexmatrix > 0){
      if(length(levels(report$matrices[[input$reportlistmatrix[1]]]$data[,5])) == 2){return(
        list(
          h4(strong("Scatter matrix")),
          p("The following scatter matrix shows you a more comprehensive view of some repectiveley choosen variables. 
            In the upper left part ot the matrix you see the scatter plots of the corresponding variables. The diagonla 
            line shows you the distribution of the associated variables. On the upper right part of the matrix  the correlation 
            of the variables are shown."),
        p(paste("The following scatter matrix gives an overview of the relations of the variables", 
                levels(report$matrices[[input$reportlistmatrix[1]]]$data[,5])[1], "and", 
                levels(report$matrices[[input$reportlistmatrix[1]]]$data[,5])[2],"."))
        )
      )}
    }
    if(indexmatrix > 0){
      if(length(levels(report$matrices[[input$reportlistmatrix[1]]]$data[,5])) == 3){return(
        list(
          h4(strong("Scatter matrix")),
          p("The following scatter matrix shows you a more comprehensive view of some repectiveley choosen variables. 
            In the upper left part ot the matrix you see the scatter plots of the corresponding variables. The diagonla 
            line shows you the distribution of the associated variables. On the upper right part of the matrix  the correlation 
            of the variables are shown."),
        p(paste("The following scatter matrix gives an overview of the relations of the variables", 
                levels(report$matrices[[input$reportlistmatrix[1]]]$data[,5])[1], ",", 
                levels(report$matrices[[input$reportlistmatrix[1]]]$data[,5])[2]," and", 
                levels(report$matrices[[input$reportlistmatrix[1]]]$data[,5])[3],"."))
        )
        )}
    }
    if(indexmatrix > 0){
      if(length(levels(report$matrices[[input$reportlistmatrix[1]]]$data[,5])) == 4){return(
        list(
          h4(strong("Scatter matrix")),
          p("The following scatter matrix shows you a more comprehensive view of some repectiveley choosen variables. 
            In the upper left part ot the matrix you see the scatter plots of the corresponding variables. The diagonla 
            line shows you the distribution of the associated variables. On the upper right part of the matrix  the correlation 
            of the variables are shown."),
        p(paste("The following scatter matrix gives an overview of the relations of the variables",
                levels(report$matrices[[input$reportlistmatrix[1]]]$data[,5])[1], ",", 
                levels(report$matrices[[input$reportlistmatrix[1]]]$data[,5])[2],",", 
                levels(report$matrices[[input$reportlistmatrix[1]]]$data[,5])[3],"and", 
                levels(report$matrices[[input$reportlistmatrix[1]]]$data[,5])[4], "."))
        )
      )}
    }
    if(indexmatrix > 0){
      if(length(levels(report$matrices[[input$reportlistmatrix[1]]]$data[,5])) == 5){return(
        list(
          h4(strong("Scatter matrix")),
          p("The following scatter matrix shows you a more comprehensive view of some repectiveley choosen variables. 
            In the upper left part ot the matrix you see the scatter plots of the corresponding variables. The diagonla 
            line shows you the distribution of the associated variables. On the upper right part of the matrix  the correlation 
            of the variables are shown."),
        p(paste("The following scatter matrix gives an overview of the relations of the variables",
                levels(report$matrices[[input$reportlistmatrix[1]]]$data[,5])[1], ",", 
                levels(report$matrices[[input$reportlistmatrix[1]]]$data[,5])[2],",", 
                levels(report$matrices[[input$reportlistmatrix[1]]]$data[,5])[3],",", 
                levels(report$matrices[[input$reportlistmatrix[1]]]$data[,5])[4], "and", 
                levels(report$matrices[[input$reportlistmatrix[1]]]$data[,5])[5], "."))
        )
      )}
    }
  
  }
  
})


output$matrixheaderzwei<-renderUI({
  
  indexmatrix<-0
  
  if(!is.null(input$reportlistmatrix)){
    if(is.null(report$matrices[[input$reportlistmatrix[1]]]) & is.null(report$matrices[[input$reportlistmatrix[2]]])){indexmatrix<-0}
    if(!is.null(report$matrices[[input$reportlistmatrix[1]]]) & is.null(report$matrices[[input$reportlistmatrix[2]]])){indexmatrix<-1}
    if(!is.null(report$matrices[[input$reportlistmatrix[1]]]) & !is.null(report$matrices[[input$reportlistmatrix[2]]])){indexmatrix<-2}
  }
  
  if(indexmatrix == 2){
    if(length(levels(report$matrices[[input$reportlistmatrix[2]]]$data[,5])) == 2){return(
      p(paste("The following scatter matrix gives an overview of the relations of the variables",
              levels(report$matrices[[input$reportlistmatrix[2]]]$data[,5])[1], "and", 
              levels(report$matrices[[input$reportlistmatrix[2]]]$data[,5])[2],"."))
    )}
  }
  
  
  if(indexmatrix == 2){
    if(length(levels(report$matrices[[input$reportlistmatrix[2]]]$data[,5])) == 3){return(
      p(paste("The following scatter matrix gives an overview of the relations of the variables", 
              levels(report$matrices[[input$reportlistmatrix[2]]]$data[,5])[1], ",", 
              levels(report$matrices[[input$reportlistmatrix[2]]]$data[,5])[2]," and",
              levels(report$matrices[[input$reportlistmatrix[2]]]$data[,5])[3],"."))
      )}
  }
  if(indexmatrix == 2){
    if(length(levels(report$matrices[[input$reportlistmatrix[2]]]$data[,5])) == 4){return(
      p(paste("The following scatter matrix gives an overview of the relations of the variables", 
              levels(report$matrices[[input$reportlistmatrix[2]]]$data[,5])[1], ",", 
              levels(report$matrices[[input$reportlistmatrix[2]]]$data[,5])[2],",", 
              levels(report$matrices[[input$reportlistmatrix[2]]]$data[,5])[3],"and", 
              levels(report$matrices[[input$reportlistmatrix[2]]]$data[,5])[4], "."))
      )}
  }
  
  if(indexmatrix == 2){
    if(length(levels(report$matrices[[input$reportlistmatrix[2]]]$data[,5])) == 5){return(
      p(paste("The following scatter matrix gives an overview of the relations of the variables", 
              levels(report$matrices[[input$reportlistmatrix[2]]]$data[,5])[1], ",", 
              levels(report$matrices[[input$reportlistmatrix[2]]]$data[,5])[2],",", 
              levels(report$matrices[[input$reportlistmatrix[2]]]$data[,5])[3],",", 
              levels(report$matrices[[input$reportlistmatrix[2]]]$data[,5])[4], "and", 
              levels(report$matrices[[input$reportlistmatrix[2]]]$data[,5])[5], "."))
    )}
  }
})


output$reportplotsall<-renderUI({
  
  if(is.null(input$reportlistplots)){return()}
  if(!is.null(report$plots[[input$reportlistplots[1]]]) & length(input$reportlistplots) == 1){return(
    
   list(  
      column(
        width = 12,
        plotOutput("reportploteins", width = 500, height = 400)
      )
   )
  )}
  
  
  if(length(input$reportlistplots) == 2){return(
    
    list(
        fluidRow(
          column(
            width = 6,
              plotOutput("reportploteins", width = 500, height = 400)
          ),
          column(
            width = 6,
              plotOutput("reportplotzwei", width = 500, height = 400)
          )
        )
    )
  )}
})

output$reportmatrixeinsoutput<-renderUI({
  
  if(is.null(input$reportlistmatrix)){return()}
  
  
  if(!is.null(report$matrices[[input$reportlistmatrix[1]]])){return(
  
    
    list(
        column(
          width = 12,
          plotOutput("reportmatrixeins", width = 800, height = 800)
        )
    )
  )}
})
  
output$reportmatrixzweioutput<-renderUI({ 
  
  if(length(input$reportlistmatrix) == 2){return(
    list(
      column(
        width = 12,
        plotOutput("reportmatrixzwei", width = 800, height = 800)
      )
    )
  )}
})

output$headertimeseries<-renderUI({
  

  if(is.null(input$reportlisttimeseriesplotAllComp)){return()}
  if(length(report$timeseriesplotAllComp) == 0){return()}
  
  
  if(length(input$reportlisttimeseriesplotAllComp) == 1){return(
    list(
      h4(strong("Timeseries")),
      p("The timeseries plot shows the scaled data of the corresponding variables. The data were scaled because of
        comparison by substracting the mean and dividing through the standard deviation"),
      p(paste("The table underneath the timeseries plot show the correlation regarding to", input$depVar))
    )
  )}
  
  
})


output$reporttimeseriesplotAllComp<-renderUI({
  
  if(is.null(input$reportlisttimeseriesplotAllComp)){return()}
  if(length(report$timeseriesplotAllComp) == 0){return()}
  
  if(length(input$reportlisttimeseriesplotAllComp) == 1){return(
    
    list(
        column(
          width = 12,
            dygraphOutput("timeseriesreportgraph"),
            tableOutput("reporttimeseriestableplotAllComp")
        )
    )
  )}
  
})

output$headerforecastindep<-renderUI({
  
  namevalues <<- arima.values$tabelle.variablen
  namevalues <- paste(namevalues[,1], collapse = ",")
  
  h3(strong(paste("Forecast of:" , namevalues)))
})

output$headerforecastdep<-renderUI({
  
  h3(strong(paste("Forecast of" , input$depVar)))
})


output$headerappendix<-renderUI({
  
  indexcollcorr <- 0
  if(!is.null(input$reportlistcorrcolltable)){
    names<-input$reportlistcorrcolltable
    if(length(names) == 1 & names[1] == "Correlation table"){indexcollcorr<-1}
    if(length(names) == 1 & names[1] == "Collinearity table"){indexcollcorr<-2}
    if(length(names) == 2){indexcollcorr<-3}
  }
  
  if(indexcollcorr >0){return(
    h3(strong("Appendix"))
  )}
})

output$reportuicorrtable<-renderUI({
  
  indexcollcorr <- 0
  if(!is.null(input$reportlistcorrcolltable)){
    names<-input$reportlistcorrcolltable
    if(length(names) == 1 & names[1] == "Correlation table"){indexcollcorr<-1}
    if(length(names) == 1 & names[1] == "Collinearity table"){indexcollcorr<-2}
    if(length(names) == 2){indexcollcorr<-3}
  }
  
  if(is.null(input$reportlistcorrcolltable)){return()}
  names<-input$reportlistcorrcolltable
  if(indexcollcorr == 1 | indexcollcorr == 3) {return(
      tableOutput("correlationtableholereport")
  )}
})

  
output$reportuicolltable<-renderUI({
  
  indexcollcorr <- 0
  if(!is.null(input$reportlistcorrcolltable)){
    names<-input$reportlistcorrcolltable
    if(length(names) == 1 & names[1] == "Correlation table"){indexcollcorr<-1}
    if(length(names) == 1 & names[1] == "Collinearity table"){indexcollcorr<-2}
    if(length(names) == 2){indexcollcorr<-3}
  }
    
  if(indexcollcorr == 2 | indexcollcorr == 3){return(
        dataTableOutput("collinearitytableholereport")
        
    )}
})
  
  
output$textcorrtablereport<-renderUI({
  
  indexcollcorr <- 0
  if(!is.null(input$reportlistcorrcolltable)){
    names<-input$reportlistcorrcolltable
    if(length(names) == 1 & names[1] == "Correlation table"){indexcollcorr<-1}
    if(length(names) == 1 & names[1] == "Collinearity table"){indexcollcorr<-2}
    if(length(names) == 2){indexcollcorr<-3}
  }
  if(indexcollcorr == 1 | indexcollcorr == 3){return(
    list(
      h4(strong("Correlation table")),
      p(paste('In the following table you see the correlations of all dependent variables regarding to',
            input$depVar, 'and with the corresponding time lags.'))
    )
  )}
})



output$textcolltablereport<-renderUI({
  
  indexcollcorr <- 0
  if(!is.null(input$reportlistcorrcolltable)){
    names<-input$reportlistcorrcolltable
    if(length(names) == 1 & names[1] == "Correlation table"){indexcollcorr<-1}
    if(length(names) == 1 & names[1] == "Collinearity table"){indexcollcorr<-2}
    if(length(names) == 2){indexcollcorr<-3}
  }
  if(indexcollcorr == 2 | indexcollcorr == 3){return(
    list(
        h4(strong("Collinearity table")), 
        p("In the following table you see the collinearity of all variables")
    )
  )}
})

output$introductionremarks<-renderUI({
  
  if(length(input$introconclucheckbox) == 0){return()}
  if(input$introconclucheckbox == "Introduction remarks"){return(
      list(
        h3(strong("Introduction remarks")),
        textareaInput("introremarks", "", columns = 200, rows = 3)
      )
  )}
  
  if(length(input$introconclucheckbox) == 2){return(
    list(
      h3(strong("Introduction remarks")),
      textareaInput("introremarks", "", columns = 200, rows = 3)
    )
    
  )}
  
})

output$conclusionremarks<-renderUI({
  
  if(length(input$introconclucheckbox) == 0){return()}
  
  print("ooo")
  print(length(input$introconclucheckbox))
  print(input$introconclucheckbox)
  if(input$introconclucheckbox == "Conclusion remarks"){return(
  
      list(
        h3(strong("Conclusion remarks")),
        textareaInput("concluremarks", "", columns = 200, rows = 3)
      )
  )}
  
  if(length(input$introconclucheckbox) == 2){return(
    
    
    list(
      h3(strong("Conclusion remarks")),
      textareaInput("concluremarks", "", columns = 200, rows = 3)
    )
    
  )}
})




textareaInput <- function(inputID, label, value="", rows=5, columns=50) {
  HTML(paste0('<div class="form-group shiny-input-container">
              <label for="', inputID, '">', label,'</label>
              <textarea id="', inputID, '" rows="', rows,'" cols="', 
              columns,'">', value, '</textarea></div>'))
}


  
