

# Sidebar wechselt nachdem Daten eingelesen wurden ausgewählt wurde


output$MenuItem <-renderMenu({
  sidebarMenu( 
    
    menuItem("Home", tabName ="home", icon = icon("home")),
    
    if(start$password == FALSE){
      menuItem("Log in", tabName = "password", icon = icon("user"))
    },
    if(start$password == TRUE & start$acceptdataset == FALSE){
      menuItem("Data import", tabName = "dataimport", icon = icon("upload"))
    },
    if(start$password == TRUE &  start$acceptdataset == TRUE){
      menuItem("Show data", tabName = "mainsettings", icon = icon("database"))
    },
    
    if(start$password == TRUE & start$date.index == TRUE & !is.null(input$depVar) & start$acceptdataset == TRUE){
      list(
        menuItem("Data preparation", tabName = "dataprep", icon = icon("sliders"),
                 menuSubItem("Rearrange data", tabName ="datarearrange", icon = icon("sliders")),
                 menuSubItem("Split data", tabName ="datasplit", icon = icon("sliders"))),
        menuItem("Data analysis", tabName = "dataanal", icon = icon("bar-chart"),
                 menuSubItem("Analysis via correlation", tabName = "tableanal", icon = icon("random")),
                 menuSubItem("Analysis via visualisation", tabName = "visualanal", icon = icon("random"))),
        menuItem("MReg forecasting", tabName = "mregforecasting", icon = icon("random"),
          menuItem("Explanation model", tabName = "explmodel", icon = icon("random"), 
                   menuSubItem("Automatic model", tabName = "explautomodel", icon = icon("random")),
                   menuSubItem("Manual model", tabName = "explmanualmodel", icon = icon("random")),
                   menuSubItem("Saved model", tabName = "explsavedmodel", icon = icon("info"))),
          menuItem("Forecast of independent variable", tabName = "forecastindep", icon = icon("area-chart"),
                   menuSubItem("Time series analysis", tabName= "foreindeptsa", icon= icon("area-chart")),
                   menuSubItem("Trend estimation", tabName = "foreindeptrend", icon=icon("area-chart")),
                   menuSubItem("Manual data input", tabName= "foreindepmdi", icon=icon("area-chart")),
                   menuSubItem("Saved forecasts", tabName = "foreindepsaved", icon = icon("info"))),
          menuItem("Forecast of dependent variable", tabName = "forecastdepvarmreg", icon = icon("line-chart"),
            menuSubItem("Via monte carlo simulation", tabName = "forecastdepmontecarlo", icon = icon("line-chart")),
            menuSubItem("Saved forecast", tabName = "savedforecastmontecarlo", icon = icon("info")))),
        menuItem("VAR forecasting", tabName = "varforecasting", icon = icon("random"),
              menuItem("Preprocessing", tabName = "preprocessing", icon = icon("line-chart")),
              menuItem("Forecast via VAR model", tabName = "varmodel", icon = icon("line-chart"),
                  menuSubItem("Explanation model", tabName = "explanationvar", icon = icon("line-chart")),
                  menuSubItem("Forecast of dependent variable", tabName = "forecastdepvar", icon = icon("line-chart")),
                  menuSubItem("Saved models and forecasts", tabName = "savedVAR", icon = icon("info"))),
              menuItem("Forecast via restr.VAR model", tabName = "restrvarmodel", icon = icon("line-chart"),
                  menuSubItem("Explanation model", tabName = "explanationrestrvar", icon = icon("line-chart")),
                  menuSubItem("Forecast of dependent variable", tabName = "forecastdeprestrvar", icon = icon("line-chart")),
                  menuSubItem("Saved models and forecasts", tabName = "savedVARrest", icon = icon("info")))),
        if(splitindex$splittruefalse == 0){
          menuSubItem("Compare forecasts", tabName ="explback", icon = icon("line-chart"))},
        if(splitindex$splittruefalse == 1){list(
          menuItem("Backtesting", tabName ="backtesting", icon = icon("line-chart"),
                 menuItem("Explanation models", tabName ="explback", icon = icon("line-chart")),
                 menuItem("Forecasts", tabName ="forecback", icon = icon("line-chart"),
                    menuSubItem("via saved explanation models (cross sectional)", tabName = "backtestingsavedexpl", icon = icon("line-chart")),
                    menuSubItem("via saved forecasts (1 step ahead)", tabName = "backtestingonestepahead", icon = icon("line-chart")))))},
        menuItem("Reporting", tabName = "reporting", icon = icon("file-text-o")),
        br(),
        br(),
        box(
          width = 12,
          height = 750,
          #status = "warning",
          background = "black",
          uiOutput("actualModell")
        )
      )
    }
  )
  
})


output$actualModell<-renderUI({
  

  list(
        strong(paste("Data set information:")),br(),
        paste("- Uploaded data: ", index2$inputfilename),br(),
        paste("- Start date: ", start$datum),br(),
        paste("- End date: ", start$endedatum),br(),
        paste("- Frequency by: ", start$freq),br(),
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
            paste("- Horizont: ", nrow(regression.modelle$gespeicherte.forecasts[[2]])),br()
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
          paste("- Number of independent variables: ", index2$VARnumberindepvar),br(),
          paste("- Number of regressors: ", index2$VARregressors),br(),
          paste("- Lag length: ", index2$VARleglength),br()
          )
        },
        if(length(var.modelle$gespeicherte.forecasts.var) > 1){
          list(
            strong(paste("Saved forecast:")),br(),
            paste("- Horizont: ", nrow(var.modelle$gespeicherte.forecasts.var[[2]])),br()
          )
        },
        if(length(var.modelle$gespeicherte.expl.modelle.restvar) > 0){
          list(
          strong(paste("Restr. VAR model:")), br(),
          strong(paste("Saved explanation model:")),br(),
          paste("- complete cases: ", index2$restVARcompletecases),br(),
          paste("- Number of independent variables: ", index2$restVARnumberindepvar),br(),
          paste("- Number of regressors: ", index2$restVARregressors),br(),
          paste("- Lag length: ", index2$restVARleglength),br()
          )
        },
        if(length(var.modelle$gespeicherte.forecasts.restvar) > 1){
          list(
            strong(paste("Saved forecast:")),br(),
            paste("- Horizont: ", nrow(var.modelle$gespeicherte.forecasts.restvar[[2]])),br()
          )
        }
        
  )
  
})