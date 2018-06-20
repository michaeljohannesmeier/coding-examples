tab2 <- tabItem(tabName = "tableanal",
                box(
                  title = "Correlation analysis", color = "orange",
                  collapsible = TRUE,
                  solidHeader = TRUE,
                  status = "primary",
                  width = 15,
                  
                  uiOutput("depVar"),
                  tabsetPanel(
                    tabPanel("Correlation table",
                        div(id="linkIDHelpCorrelationTable", style = "float:right; font-size: 25px; color: Red; display: inline-block",actionLink("linkHelpCorrelationTable", label = "?")),
                        bsModal("modalHelpCorrelationTable", "Correlation Analysis", "linkHelpCorrelationTable", size = "large",
                                uiOutput("HelpCorrelationTable")),
                        br(),
                        numericInput("LagForCorrelationTable", "Lags to show in the correlation table", value = 13, width =400),

                        uiOutput("DownloadCorrelationTableComplete"),
                        br(),
                        radioButtons("chooseTablevsHeat", "Choose table or heatmap", c("Table" = "table", "Heatmap" = "heatmap")),
                        uiOutput("TableHeatmap"),
                        actionButton("addreportcorrelation", "Add to reportlist")
                    ),
                    tabPanel("Highest correlation",
                             h4(strong("Corresponding varialbe is")),
                             dataTableOutput("CorrelationTableHighest"),
                             actionButton("SaveChoosenVariablesHighestCorrelation","Save the chosen variables for further analyzation"),
                             actionButton("showChoosenVariableCorrTable", "Show correlation table for chosen variables"),
                             bsModal("chosenVariablesCorrTable", "Correlation table chosen variables", "showChoosenVariableCorrTable", size = "large",
                                     dataTableOutput("corrTableChosenVariables")),
                             br(),
                             br(),
                             br(),
                      
                             fluidRow(
                               column(
                                 width = 2,
                                 sliderInput("minCorrInput", "Choose minimum correlation", min = 0, max = 1,value = 0.6, step = 0.1)
                               ),
                               column(
                                 width = 2,
                                 sliderInput("minLagInput", "Choose minimum lag", min = 0, max = 20, value = 3, step = 1)
                               ),
                               column(
                                 width = 2,
                                 sliderInput("numOfAutoSelectedFeatures", "Choose number of features", min = 2, max = 20,value = 10)
                               ),
                               column(
                                 width = 2,
                                 br(),
                                 br()
                                 #actionButton("automaticFeatureSelection", "Automatically choose featues")
                               )
                             ),

                             bsModal("autoSelectionCorrTable", "Best automatically chosen features", "automaticFeatureSelection", size = "large",
                                      dataTableOutput("corrTableAutomaticSelection"))
                             
                    ),
                    tabPanel("Causality Tests",
                             fluidRow(
                               column(
                                 width = 6,
                                 h4("Granger Causality - X dependent on Y"),
                                 dataTableOutput("grangerCausalityXdepY")
                               ),
                               column(
                                 width = 1
                               ),
                               column(
                                 width = 6,
                                 h4("Granger Causality - Y dependent on X"),
                                 dataTableOutput("grangerCausalityYdepX")
                               )
                             )
                    )
                  )
                ),
                
                box(
                  title = "Collinearity analysis", color = "orange",
                  collapsible = TRUE,
                  collapsed = TRUE,
                  solidHeader = TRUE,
                  status = "primary",
                  width = 15,
                  tabsetPanel(
                    tabPanel("Collinearity table",
                             div(id="linkIDHelpCollinearityTable", style = "float:right; font-size: 25px; color: Red; display: inline-block",actionLink("linkHelpCollinearityTable", label = "?")),
                             bsModal("modalHelpCollinearityTable", "Collinearity table", "linkHelpCollinearityTable", size = "large",
                                     uiOutput("HelpCollinearityTable")),
                             br(),
                             
                             uiOutput("DownloadCollinearityTableComplete"),
                             br(),
                             radioButtons("chooseTablevsHeatColl", "Choose table or heatmap", c("Table" = "table", "Heatmap" = "heatmap")),
                             uiOutput("TableHeatmapColl"),
                             actionButton("addreportcollinearity", "Add to reportlist")
                    ),
                    tabPanel("Hightest collinearities",
                             
                             div(id="linkIDHelpHightestCollinearities", style = "float:right; font-size: 25px; color: Red; display: inline-block",actionLink("linkHelpHightestCollinearities", label = "?")),
                             bsModal("modalHelpHightestCollinearities", "Hightest Collinearities", "linkHelpHightestCollinearities", size = "large",
                                     uiOutput("HelpHightestCollinearities")),
                             br(),
                             dataTableOutput("maxKol")
                             
                    )
                  )
                )
)