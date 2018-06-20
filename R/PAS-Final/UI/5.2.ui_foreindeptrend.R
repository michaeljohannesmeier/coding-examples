tab4B<-
  
  tabItem(tabName = "foreindeptrend",
        
          
            box(    
              width = 15,
              solidHeader = TRUE,
              collapsible = TRUE,
              status = "warning",
              title = "Independent variables",
              div(id="linkhelpid20", style = "float:right; font-size: 25px; color:orange; display: inline-block",actionLink("linkhelp20", label = "?")),
              bsModal("modalExample20", "Independent Variables", "linkhelp20", size = "large",
                      uiOutput("texthelp20")),
              
              uiOutput("trendForcast"),
              actionButton("plotts2", "Choose variable")
              
            ),
            
          
          conditionalPanel(condition = "input.trendFor != ''", box(
            
                title = "Trend estimation",
                width = 15,
                solidHeader = TRUE,
                collapsible = TRUE,
                collapsed = FALSE, 
                status = "warning",
                div(id="linkhelpid21", style = "float:right; font-size: 25px; color:orange; display: inline-block",actionLink("linkhelp21", label = "?")),
                bsModal("modalExample21", "Trend Estimation", "linkhelp21", size = "large",
                        uiOutput("texthelp21")),
                
                
                fluidRow(
                  box(
                    width = 4,
                    selectInput("trend", "Determine trend", choices = c("Increasing", "Stagnating", "Decreasing")),
                    uiOutput("trendEntry")
                  ),
                  box(
                    width = 2,
                    numericInput("trendSteps", "Time steps", value = 1, min = 1, width = '250px')
                  ),
                  box(
                    width = 2,
                    actionButton("prevTrend", "Calculate forecast"),
                    br(),br(),
                    actionButton("subTrend", "Save forecast")
                  )
                ),
                
                fluidRow(
                  box(
                    width = 12,
                    uiOutput("headerTrend"),
                    dygraphOutput("plotDefaultTrend"),
                    br(),
                    dataTableOutput("conditions"),
                    br(),
                    uiOutput("headerValues"),
                    dataTableOutput("werte")
                  )
                )
          )
          )
          
  )


