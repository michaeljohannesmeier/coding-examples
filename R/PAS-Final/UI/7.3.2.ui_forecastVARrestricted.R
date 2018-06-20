tabItem(tabName = "forecastdeprestrvar",
        conditionalPanel("input.saveresEST", box(
          width = 15,
          title = "Choose settings for restricted model", status = "warning", solidHeader = TRUE, collapsible = TRUE,  
          numericInput("resHORIZ",
                       label = h4(strong("Forecast horizon (h-step ahead)")),
                       value = 3,
                       min = 1),
          actionButton("resFCST", "Forecast restricted VAR-Model"),
          actionButton("saveresFCST", "Save forecast")
          )
          ),
          conditionalPanel("input.saveresEST", box(
            width = 15,
            title = "Show forecast", status = "warning", solidHeader = TRUE, collapsible = TRUE, 
            dygraphOutput("restrVARfittedPlotforecast"),
            dataTableOutput("restrVARforecast")
            
          )
          )
)

