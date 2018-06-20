tab4A <- tabItem(tabName = "foreindeptsa",
          
                
         
            box(    
                  width = 15,
                  solidHeader = TRUE,
                  collapsible = TRUE,
                  status = "warning",
                  title = "Independent variables",
                  
                  div(id="linkhelpid18", style = "float:right; font-size: 25px; color:orange; display: inline-block",actionLink("linkhelp18", label = "?")),
                  bsModal("modalExample18", "Independent Variables", "linkhelp18", size = "large",
                          uiOutput("texthelp18")),
                  
                  uiOutput("chooseIndVar"),
                  conditionalPanel(condition = "input.acfIndVar != ''", actionButton("plotts1", "Choose variable"))
                  
                    
                  
            ),
            
          
            conditionalPanel(condition = "input.acfIndVar != ''", box(
                  width = 15,
                  solidHeader = TRUE,
                  collapsible = TRUE,
                  status = "warning",
                  title = "Time series analysis",
                  
                  div(id="linkhelpid19", style = "float:right; font-size: 25px; color:orange; display: inline-block",actionLink("linkhelp19", label = "?")),
                  bsModal("modalExample19", "Time Series Analysis", "linkhelp19", size = "large",
                          uiOutput("texthelp19")),
                  
                 fluidRow(

                   box(
                     width = 4,
                     
                     radioButtons("arimaSelected", label = "Select type of ARIMA-Model", choices = list("Automatic" = 1, "Manual" = 0), selected = 1),
                     conditionalPanel("input.arimaSelected == 0", 
                                      
                                      div(id="ar", numericInput("AR", label = "Auto-Regression (p)", value = 0, min = 0)),
                                      tags$head(tags$style(type="text/css", "#ar {display: inline-block}")),
                                      tags$head(tags$style(type="text/css", "#xlimitsmax {max-width: 50px}")),
                                      
                                      
                                      div(id="diff",numericInput("DIFF", label = "Differencing (d)", value = 0, min = 0)),
                                      tags$head(tags$style(type="text/css", "#diff {display: inline-block}"),
                                                tags$head(tags$style(type="text/css", "#xlimitsmax {max-width: 50px}"))),
                                      
                                      
                                      div(id="ma",numericInput("MA", label = "Moving-Average (q)", value = 0, min = 0)),
                                      tags$head(tags$style(type="text/css", "#ma {display: inline-block}"),
                                                tags$head(tags$style(type="text/css", "#xlimitsmax {max-width: 50px}")
                                                )
                                      )
                     )
                     
                     
                     
                     
                   ),
                   
                   
                   
                   
                   box(
                     width = 3,
                     numericInput("forecast", label = "Select number of time steps to predict", value = 5, min = 0),
                     actionButton("ts1", label = "Calculate forecast"),
                     br(),br(),
                     conditionalPanel(condition = "input.ts1", actionButton("storeArima", label = "Save forecast"))
                     
                     
                   )
                      
                 ),
                 #conditionalPanel(condition= "input.", strong("Preview of the Forecast")),
                 
                 br(),
                 dygraphOutput("timeseries"),
                 br(),
                 
                 uiOutput("headerArima"),
                 
                 conditionalPanel(condition =  "input.ts1", fluidRow(
                   box(
                     uiOutput("kindArima"),
                     tableOutput("sumArima")
                     
                   ),
                   
                   box(
                     uiOutput("headerqual"),
                     tableOutput("qual.model")
                     
                   )
                 ),
                 fluidRow(
                   box(
                     
                     uiOutput("headererror"),
                     tableOutput("errorArima")
                   ),
                   
                   box(
                     uiOutput("headerconfidenz"),
                     dataTableOutput("predArima")
                   )
                 )
                 )
            )
            )
)