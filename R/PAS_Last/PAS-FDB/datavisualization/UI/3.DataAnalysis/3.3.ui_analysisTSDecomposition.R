tabItem(tabName = "tabtscomp",
        box(
          title = "Time-Series-Properties",
          #collapsed  = TRUE,
          collapsible = TRUE,
          solidHeader = TRUE,
          status = "primary",
          width = 15,
            tabsetPanel(
              tabPanel("Time-Series-Decomposition",
                uiOutput("chooseTSToDecompose"),
                actionButton("decomposeTS", "Decompose Time-Series"),
                br(),br(),
                fluidRow(
                  column(
                    width = 6,
                    plotlyOutput("plotOriginalTS"),
                    br(),
                    plotlyOutput("plotSeasonalTS")
                  ),
                  column(
                    width = 6,
                    plotlyOutput("plotTrendTS"),
                    br(),
                    plotlyOutput("plotErrorlTS")
                  )
                )
              ),
              tabPanel("Trend-Analyse",
                       uiOutput("chooseVariablesTrendTest"),
                       br(),
                       actionButton("testTrend", "Test for Trend"),
                       checkboxInput("testTrendAllcheckbox", "Test for Trend of all Variables", TRUE),
                       br(),br(),
                         fluidRow(
                           column(
                             width = 6,
                             uiOutput("headerStationaryTS"),
                             dataTableOutput("tableNoEvidenceAgainstTrend")
                           ),
                           column(
                             width = 6,
                             uiOutput("headerNonStationaryTS"),
                             dataTableOutput("tableEvidenceAgainstTrend"),
                             uiOutput("performDifferencing")
                           )
                         )
              ),
              tabPanel("Varianz-Analyse",
                       uiOutput("chooseVariablesBoxCoxTest"),
                       actionButton("testBoxCox", "Test for best variance stabilizing Transformation"),
                       br(), br(),
                       fluidRow(
                         column(
                           width = 10,
                           uiOutput("headerBoxCoxResult"),
                           dataTableOutput("tableBoxCoxResult")
                         )
                       ),
                       br(),br(),
                       uiOutput("uiBoxCoxVisualisierung")
              )
            )
        )
)