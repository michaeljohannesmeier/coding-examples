tab6 <- tabItem(tabName =  "forecastdepmontecarlo",
                 box(
                   width = 15, 
                   header = TRUE, 
                   collapsible = TRUE,
                   title = "Forecast settings",
                   status = "warning",
                   solidHeader = TRUE,
                   
                   div(id="linkhelpid24", style = "float:right; font-size: 25px; color:orange; display: inline-block",actionLink("linkhelp24", label = "?")),
                   bsModal("modalExample24", "Forecast Settings", "linkhelp24", size = "large",
                           uiOutput("texthelp24")),
                   
                   fluidRow(
                     box(
                       width = 4,
                       uiOutput("headerOutstanding"),
                       dataTableOutput("currentModels2")
                     ),
                     
                     box(
                       width = 4,
                       uiOutput("inputPredout1"),
                       uiOutput("inputPredout2"),
                       uiOutput("inputPredout3")
                       
                       
                     ),
                     
                     box(
                       width = 3,
                       uiOutput("inputPredout4"),
                       uiOutput("inputPredout5"),
                       uiOutput("inputPredout6"),
                       uiOutput("inputPredout7"),
                       conditionalPanel("input.startSim", actionButton("saveForecastMreg", "Save forecast"))
                       
                       
                     )
                   ) 
                 ),
                box(
                  width = 15, 
                  header = TRUE, 
                  collapsible = TRUE,
                  title = "Forecast results",
                  status = "warning",
                  solidHeader = TRUE,
                  
                  dygraphOutput("simCI"),
                  br(),br(),
                  uiOutput("headerCI"),
                  dataTableOutput("CI.table")
                  
                  
                )
                
                
)