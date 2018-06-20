tabItem(tabName = "explanationvar",
        
        conditionalPanel("input.PREP", box(
          width = 15,
          title = "Choose model settings", status = "warning", solidHeader = TRUE, collapsible = TRUE,  
          numericInput("LAGS", label = h4(strong("Lag-length (p)")),"", min = 1, value = 2),
          actionButton("EST", "Estimate VAR-Model"),
          actionButton("saveEST", "Save explanation model")
         )
        ),
        conditionalPanel("input.PREP", box(
          width = 15,
          title = "Show estimation of explanation model", status = "warning", solidHeader = TRUE, collapsible = TRUE, 
          
          div(id="linkhelpideins", style = "float:right; font-size: 25px;" , actionLink("linkhelpeins", label = "?")),
          bsModal("modalExampleeins", "VAR model", "linkhelpeins", size = "large",
                  uiOutput("texthelpeins")),
            
           br(),
           dygraphOutput("VARfittedPlot"),
           br(),
          
          
            fluidRow(
              column(
                width = 6,
                     h4(strong(textOutput("text.est"))),
                     tableOutput("VARest")
              ),
              column(
                width = 6,
                    h4(strong((textOutput("text.est.qual")))),
                    tableOutput("VARest.qual")
              )
          
            ) 
        )
        )
)
