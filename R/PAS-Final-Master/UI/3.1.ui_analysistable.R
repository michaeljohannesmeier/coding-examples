tab2 <- tabItem(tabName = "tableanal",
                

                
                box(
                  title = "Time lag analysis",
                  status = "warning",
                  solidHeader = TRUE,
                  color = "orange",
                  collapsible = TRUE,
                  #collapsed = TRUE,
                  width = 15,
                  div(id="linkhelpid8", style = "float:right; font-size: 25px; color: Red; display: inline-block",actionLink("linkhelp8", label = "?")),
                  bsModal("modalExample8", "Time Lag Analysis", "linkhelp8", size = "large",
                          uiOutput("texthelp8")),
                  
                  br(),
                  br(),
                  
                  fluidRow(
                    box( 
                      uiOutput("independent_variable"),
                      numericInput("lag", "Lags", value = 1),
                      actionButton("cortablebutton", "Show table")
                    ),
                    box(
                      title = "Correlations",
                      conditionalPanel(condition = "input.lag != 0", tableOutput("lag_cor_table"))
                    )
                  )  
                  
                  
                ),
                
                
                
                box(
                  title = "Correlation analysis", color = "orange",
                  collapsible = TRUE,
                  solidHeader = TRUE,
                  status = "warning",
                  width = 15,
                  div(id="linkhelpid9", style = "float:right; font-size: 25px; color: Red; display: inline-block",actionLink("linkhelp9", label = "?")),
                  bsModal("modalExample9", "Correlation Analysis", "linkhelp9", size = "large",
                          uiOutput("texthelp9")),
                  
                  br(),
                  br(),
                  
                  
                  tabsetPanel(
                    tabPanel("Correlation table",    
                        dataTableOutput("lag.all"),
                        actionButton("addreportcorrelation", "Add to reportlist")
                    ),
                    tabPanel("Highest correlation",
                             h4(strong("Corresponding varialbe is")),
                             dataTableOutput("lag.highest.all")
                    )
                  )
                  
                  
                ),
                
                box(
                  title = "Collinearity analysis", color = "orange",
                  collapsible = TRUE,
                  solidHeader = TRUE,
                  status = "warning",
                  width = 15,
                  tabsetPanel(
                    tabPanel("Collinearity table",
                             div(id="linkhelpid10", style = "float:right; font-size: 25px; color: Red; display: inline-block",actionLink("linkhelp10", label = "?")),
                             bsModal("modalExample10", "Collinearity table", "linkhelp10", size = "large",
                                     uiOutput("texthelp10")),
                             br(),
                             
                             dataTableOutput("korrelation_ind"),
                             actionButton("addreportcollinearity", "Add to reportlist")
                             
                             
                             
                             
                    ),
                    tabPanel("Hightest collinearities",
                             
                             div(id="linkhelpid11", style = "float:right; font-size: 25px; color: Red; display: inline-block",actionLink("linkhelp11", label = "?")),
                             bsModal("modalExample11", "Hightest Collinearities", "linkhelp11", size = "large",
                                     uiOutput("texthelp11")),
                             br(),
                             dataTableOutput("maxKol")
                             
                    )
                  )
                )
                
                
)
