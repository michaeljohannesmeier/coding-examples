tabItem(tabName = "reporting", 
        
        box(
          title = "Reporting options",
          #collapsed  = TRUE,
          collapsible = TRUE,
          solidHeader = TRUE,
          status = "warning",
          width = 15,
          fluidRow(
              box(
                width = 4,
                  column(
                    width = 6,
                    uiOutput("checkboxreportplots"),
                    br(),
                    br(),
                    actionButton("deletegraph", "Delete selected graphs")
                  ),
                  column(
                    width = 6,
                    uiOutput("checkboxreportmatrix"),
                    br(),
                    uiOutput("checkboxreporttimeseriesplotAllComp")
                  )
              ),
              box(
                width = 2,
                    uiOutput("checkboxintroconclusionremarks"),
                    uiOutput("checkboxreportcorrelationablehole")
              ),
              conditionalPanel("input.startSim", 
                               box(
                width = 2, 
                    h4(strong("Download Report")),
                    radioButtons('format', 'Document format', c('PDF', 'HTML', 'Word'),
                                 inline = TRUE),
                    downloadButton('downloadReport')
                )
              )
          )
        ),
        
      box(
          title = "Report preview",
          #collapsed  = TRUE,
          collapsible = TRUE,
          solidHeader = TRUE,
          status = "warning",
          width = 15,
          column(
            width = 12, 
              uiOutput("headerReport", align = "center"),
              uiOutput("introductionremarks"),
              uiOutput("headervisual"),
              uiOutput("scatterheader"),
              uiOutput("reportplotsall", align = "center"),
              br(),
              uiOutput("matrixheadereins"),
              uiOutput("reportmatrixeinsoutput", align = "center"),
              uiOutput("matrixheaderzwei"),
              uiOutput("reportmatrixzweioutput", align = "center"),
              br(),
              uiOutput("headertimeseries"),
              uiOutput("reporttimeseriesplotAllComp", align = "center")
          ),
          conditionalPanel("input.startSim", column(
            width = 12, 
              h3(strong("Explanation Model")),
              p("The following explanation model shows a timeseries of the explanation model as well as some tabes for the
              evaluation of the model."),
              dygraphOutput("reportstoredexplanationmodel"),
              br(),
              p("In the following table you can see the independent variables of the model as well as ther coressponding beta
                 estimates, standard errors, t- and p-values.")
          ),
          fluidRow(
            column(
              width = 4
            ), 
            column(
              width = 4,
              tableOutput("reportstoredcoefficients")
            )
          ), 
            
          column(
            width = 12, 
              br(),
              p("For the explanation model the following lags of the dependet variables were used for the calculation:")
          ),
          fluidRow(
            column(
              width = 4
            ), 
            column(
              width = 4,
              tableOutput("reportstoredquality")
            )
          ),
          column(
            width = 12,
              br(),
              p("For the explanation model the following information criterias as well as coefficients of determination shows
                the quality of the regression:")
            ),
          fluidRow(
            column(
              width = 4
            ), 
            column(
              width = 4,
              tableOutput("reportstoredlag")
            )
          ),
          column(
            width = 12, 
              br(),
              uiOutput("headerforecastindep"),
              p("The independent variables were forecasted with the following methods:")
          ),
          fluidRow(
            column(
              width = 4
            ), 
            column(
              width = 4,
              tableOutput("reportforecasttable")
            )
          ),
          column(
            width = 12,
          uiOutput("headerforecastdep"),
          p("The following graph you can see the forecast of the dependent variable:"),
          dygraphOutput("reportstoredforecastfinal"),
          br(),
          p("The forecast results the following values:")
          ),
          fluidRow(
            column(
              width = 4
            ), 
            column(
              width = 4,
              tableOutput("reportpredictionresults")
            )
          )
        ),
          column(
            width = 12,
              uiOutput("conclusionremarks"),
              uiOutput("headerappendix"),
              uiOutput("textcorrtablereport"),
              uiOutput("reportuicorrtable", align = "center"),
              uiOutput("textcolltablereport"),
              uiOutput("reportuicolltable", align = "center")
          )
        )
)