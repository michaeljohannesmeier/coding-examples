tab2 <- tabItem(tabName = "visualanal",
                

        box(
          title = "Scatter plots",
          #collapsed  = TRUE,
          collapsible = TRUE,
          solidHeader = TRUE,
          status = "primary",
          width = 15,
            tabsetPanel(
              tabPanel("Scatter plots",
                       fluidRow(
                         column(width = 3,
                                br(),
                                br(),
                                sliderInput("chooseDimsScatter3d", "Choose number of dimensions", min = 2, max = 5, value = 2)
                         )
                       ),
                       uiOutput("chooseVariablesThreeDScatter"),
                       actionButton("printThreeDPlot", "Print"),
                       conditionalPanel("input.printThreeDPlot", plotlyOutput("ThreeDScatterPlot", width = "100%", height = "auto"))
              ),
              tabPanel("Scatter matrices",
                         div(id="linkIDHelpScatterPlotsMatrix", style = "float:right; font-size: 25px;" , actionLink("linkHelpScatterPlotsMatrix", label = "?")),
                         bsModal("modalHelpScatterPlotsMatrix", "Scatter Plots", "linkHelpScatterPlotsMatrix", size = "large",
                                 uiOutput("HelpScatterPlotsMatrix")),
                         
                         br(),
                         uiOutput("variablesscattermatrix"),
                         actionButton("plotmatrix", "Plot scatter matrix"),
                         conditionalPanel("input.plotmatrix", fluidRow(column(12, align = "center", uiOutput("scattermatrixUi")))),
                         conditionalPanel("input.plotmatrix", hr()),
                         conditionalPanel("input.plotmatrix",
                                             textInput("namescattermatrixreport", "Choose name for reportlist", width = 200),
                                             actionButton("acceptscattermatrixreport", "Add to reportlist")
                                         
                        )
                  ),
              tabPanel("Scatter motion",
                       htmlOutput("scatterMotion", style = "width: 40%; height: auto")   
                       
                )
              )
            ),
              box(
                title = "Time series", status = "primary",
                width = 15,
                collapsible = TRUE,
                solidHeader = TRUE,
                side = "right",
              
                div(id="linkIDHelpTimeSeriesNL", style = "float:right; font-size: 25px; color: Red; display: inline-block",actionLink("linkHelpTimeSeriesNL", label = "?")),
                bsModal("modalHelpTimeSeriesNL", "Data Visualization", "linkhelp12", size = "large",
                        uiOutput("HelpTimeSeriesNL")),
                br(),
                br(),
                tabsetPanel(
                  tabPanel("Scaled",
                        br(),
                        radioButtons("selectLineSurface", " ", choices = c("Line chart" = "lineChart", "Surface chart" = "surfaceChart")),
                        uiOutput("switchLineSurface")
                      
                    ),
                  tabPanel("Unscaled",
                           br(),
                            checkboxInput("switchCategorialAsColor", "Show variable as color", FALSE),
                            uiOutput("catInputTimeSeries"),
                            uiOutput("switchRadioButtonsCat"),
                            uiOutput("unscaledSwitchLineSurface")
                           )
                  )
                ),
              box(
                title = "Distribution analysis", color = "orange",
                status = "primary",
                collapsible = TRUE,
                solidHeader = TRUE,
                width = 15,
                
                div(id="linkIDHelpDistributionAnalysis", style = "float:right; font-size: 25px; color:#f4b943; display: inline-block",actionLink("linkHelpDistributionAnalysis", label = "?")),
                bsModal("modalHelpDistributionAnalysis", "Distribution Analysis", "linkHelpDistributionAnalysis", size = "large",
                        uiOutput("HelpDistributionAnalysis")),
                
                fluidRow(
                  br(),
                  br(),
                  column(
                    width = 6,
                      uiOutput("distVariabel"),
                      uiOutput("binWidthAuto"),
                      strong("Choose distribution function"),
                      selectInput("select.fit", label = "",
                                  choices = list("No Distribution" = "keine", "Normal distribution" = "norm", "Logarithmic normal distribution" = "lnorm",
                                                 "Logistic distribution" = "logis","Cauchy distribution" = "cauchy", "Gamma distribution" = "gamma",
                                                 "Equal distribution" = "unif", "Weibull distribution" = "weibull"), selected = 1),
                    actionButton("plotdistr", "Plot distribution"),
                    br(),br()
                  ),
                  column(
                    width = 6, 
                    uiOutput("sliderBinBreite")
                  )
                ),
                conditionalPanel("input.plotdistr", box(
                  width = 12, 
                  uiOutput("headerHist"),
                  br(),
                  plotlyOutput("histggPlot"),
                  box(
                    title = "Statistical evaluation",
                    collapsible = TRUE,
                    solidHeader = TRUE,
                    width = 15,
                      dataTableOutput("distEval")
                  )
                )
                )
              ),
            box(
              title = "Box plots", color = "orange",
              status = "primary",
              collapsible = TRUE,
              solidHeader = TRUE,
              width = 15,
              tabsetPanel(
                tabPanel("Scaled",
                         br(),
                         uiOutput("boxplotvariablesscaled"),
                         checkboxInput("showdatapointsboxplotscaled", "Show datapoints", FALSE),
                         actionButton("plotboxplotsscaled", "Plot boxplots"),
                         conditionalPanel("input.plotboxplotsscaled", plotlyOutput("boxplotsAllscaled"))
                       
                ),
                tabPanel("Unscaled",
                         br(),
                         uiOutput("boxplotvariables"),
                         checkboxInput("showdatapointsboxplot", "Show datapoints", FALSE),
                         actionButton("plotboxplots", "Plot boxplots"),
                         conditionalPanel("input.plotboxplots", plotlyOutput("boxplotsAll"))
                         )
              )
            )
                
)
