tabItem(tabName = "forecastdepvar",
        
        conditionalPanel("input.saveEST", box(
          width = 15,
          title = "Choose forecast settings", status = "warning", solidHeader = TRUE, collapsible = TRUE,  
          numericInput("HORIZ",
                       label = h4(strong("Forecast horizon (h-step ahead)")),
                       value = 3,
                       min = 1),
          actionButton("FCST", "Forecast VAR-Model"),
          actionButton("saveFCST", "Save VAR-Model")
        )
        ),
        conditionalPanel("input.saveEST", box(
          width = 15,
          title = "Show forecast", status = "warning", solidHeader = TRUE, collapsible = TRUE, 
          dygraphOutput("VARfittedPlotforecast"),
          dataTableOutput("VARforecast")
        )
        )
)




