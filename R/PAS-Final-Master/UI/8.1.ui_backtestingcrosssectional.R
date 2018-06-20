tabItem(tabName = "backtestingsavedexpl",

        
        box(
          width = 15,
          title = "Backtesting settings", status = "warning", solidHeader = TRUE, collapsible = TRUE, 
                fluidRow(
                  column(
                    width = 4,
                    uiOutput("checkboxgroupbacktest")
                      
                  ), 
                  column(
                    width = 4,
                      numericInput("selectHorizont", "Select forecast horizont", value = 5, min = 2, max = 12)
                  ),
                  column(
                    width = 4,
                      uiOutput("infoBacktesting")
                  )
                ),
                 br(),
                 actionButton("BACK", "Start backtesting")
                 
        ),
        box(
          width = 15,
          title = "Backtesting results", status = "warning", solidHeader = TRUE, collapsible = TRUE, 
                 h4(textOutput("text.rmse")),
                 dygraphOutput("graph.rmse"),
                 br(),
                 plotOutput("rmse"), 
                 br(),
                 dygraphOutput("fittedbacktest", height = 700)
        )
  
)