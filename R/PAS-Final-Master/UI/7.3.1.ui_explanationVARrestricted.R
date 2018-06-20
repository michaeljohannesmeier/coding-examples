tabItem(tabName = "explanationrestrvar",
        
        conditionalPanel("input.PREP", box(
          width = 15,
          title = "Choose forecast settings for restricted model", status = "warning", solidHeader = TRUE, collapsible = TRUE,  
          numericInput("resLAGS", label = h4(strong("Lag-length (p)")),"", min = 0, value = 2),
          actionButton("resEST", "Estimate restricted VAR-Model"),
          actionButton("saveresEST", "Save restr. VAR-Model")
          )
          ),
        conditionalPanel("input.PREP", box(
              width = 15,
              title = "Show estimation and forecast for restricted model", status = "warning", solidHeader = TRUE, collapsible = TRUE, 
              
              div(id="linkhelpidzwei", style = "float:right; font-size: 25px;" , actionLink("linkhelpzwei", label = "?")),
              bsModal("modalExamplezwei", "Restricted VAR model", "linkhelpzwei", size = "large",
                      uiOutput("texthelpzwei")),
              
              
              br(),
              dygraphOutput("restrVARfittedPlot"),
              br(),
              fluidRow(
                box(
                  width = 6,
                  h4(strong(textOutput("text.res.est"))),
                  tableOutput("restrVARest")
                  
                  
                ),
                box(
                  width = 6,
                  h4(strong(textOutput("text.res.est.qual"))),
                  tableOutput("restrVARest.qual")
                )
                
              )
          )
        )
        
)

