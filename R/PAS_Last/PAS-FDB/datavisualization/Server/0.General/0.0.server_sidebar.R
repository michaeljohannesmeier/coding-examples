

# Sidebar wechselt nachdem Daten eingelesen wurden ausgew?hlt wurde

output$MenuItem <- renderMenu({
  sidebarMenu(id = "sidebarmenu",
    
                 menuItem("Analysis via Time-Series-Properties", tabName = "tabtscomp", icon = icon("random")),
                 menuItem("Analysis via Correlation", tabName = "tableanal", icon = icon("random")),
                 menuItem("Analysis via Visualisation", tabName = "visualanal", icon = icon("random"))
        
      )

})


output$actualModell<-renderUI({
  

  list(
        strong(paste("Data set information:")),br(),
        paste("- Uploaded data: ", index2$inputfilename),br(),
        paste("- Start date: ", start$datum),br(),
        paste("- End date: ", start$endedatum),br(),
        paste("- Frequency by: ", start$freq),br(),
        if(is.null(start$weekend.forecast)){
        }else{
          if((start$freq == "day" & start$weekend.forecast == "0")){
            paste("- No forecast for Weekend")
            # Falls nicht daily + weekend.for ausgew?hlt wurde (entweder aut oder man) geht ?berspringt er den if-Schritt
            # Es werden einfach die Anzahl an Tagen an den letzten Datenpunkt angeh?ngt.
          }
        },br(),
        paste("- Number of variables: ", ncol(daten.under$default)-1),br(),
        paste("- Number of observations: ", nrow(daten.under$default)),br(),
        paste("- Dependent variable: ", index2$depVar),br(),
        if(splitindex$splittruefalse == 0){
          list(
            tags$div(HTML(paste("- Modus: ", tags$span(style="color:green", "unsplitted")))),br()
          )
          
        },
        if(splitindex$splittruefalse == 1){
          list(
          tags$div(HTML(paste("- Modus: ", tags$span(style="color:orange", "splitted")))),
          paste("- Train data: ", (nrow(daten.under$default) - splitindex$split), " observations"),br(),
          paste("- Test data: ", splitindex$split, " observations", if(splitindex$splittruefalse == 1){paste(" (starting ", daten.under$data.test[[1,1]],")" )}),br()
          )
        },
        br(),
        strong(paste("MReg model:")),br(),
        if(length(regression.modelle$gespeichertes.modell) == 1){
           list(paste("- No model saved"),br())
        },
        if(length(regression.modelle$gespeichertes.modell) > 1){
          list(
          strong(paste("Saved explanation model:")),br(),
          paste("- Number of independent variables: ", index2$indepVar),br(),
          paste("- Model type: ", regression.modelle$art.gespeichertes.modell, if(regression.modelle$art.gespeichertes.modell == "auto"){paste(" (", input$range,")" )}),br(),
          paste("- Number of regressors: ", index2$anzahlregressoren),br()
          )
        },
        if(length(regression.modelle$gespeicherte.forecasts) > 1){
          list(
            strong(paste("Saved forecast:")),br(),
            paste("- Horizont: ", nrow(regression.modelle$gespeicherte.forecasts$HORIZ)),br()
          )
        },
        br(),
        strong(paste("VAR models:")), br(),
        if(length(var.modelle$gespeicherte.expl.modelle.var) == 0 & length(var.modelle$gespeicherte.expl.modelle.restvar) == 0){
          list(paste("- No model saved"),br())
        },
        if(length(var.modelle$gespeicherte.expl.modelle.var) > 0){
          list(
          strong(paste("Simple VAR model:")), br(),
          strong(paste("Saved explanation model:")),br(),
          paste("- complete cases: ", index2$VARcompletecases),br(),
          paste("- Number of variables: ", ncol(var.modelle$gespeicherte.expl.modelle.var$Datengrundlage)),br(),
          paste("- Lag length: ", index2$VARlaglength),br()
          )
        },
        if(length(var.modelle$gespeicherte.forecasts.var) > 1){
          list(
            strong(paste("Saved forecast:")),br(),
            paste("- Horizont: ", var.modelle$gespeicherte.forecasts.var$HORIZ),br()
          )
        },
        if(length(var.modelle$gespeicherte.expl.modelle.restvar) > 0){
          list(
          strong(paste("Restr. VAR model:")), br(),
          strong(paste("Saved explanation model:")),br(),
          paste("- complete cases: ", index2$restVARcompletecases),br(),
          paste("- Number of variables: ", ncol(var.modelle$gespeicherte.expl.modelle.restvar$Datengrundlage)),br(),
          paste("- Lag length: ", index2$restVARlaglength),br()
          )
        },
        if(length(var.modelle$gespeicherte.forecasts.restvar) > 1){
          list(
            strong(paste("Saved forecast:")),br(),
            paste("- Horizont: ", var.modelle$gespeicherte.forecasts.restvar$resHORIZ),br()
          )
        }
        
  )
  
})