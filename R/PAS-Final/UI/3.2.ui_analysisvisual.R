tab2 <- tabItem(tabName = "visualanal",
                

                box(
                  title = "Scatter plots",
                  #collapsed  = TRUE,
                  collapsible = TRUE,
                  solidHeader = TRUE,
                  status = "warning",
                  width = 15,
                  
                  div(id="linkhelpid7", style = "float:right; font-size: 25px;" , actionLink("linkhelp7", label = "?")),
                  bsModal("modalExample7", "Scatter Plots", "linkhelp7", size = "large",
                          uiOutput("texthelp7")),
                  
            tabsetPanel(
              tabPanel("Singles",
                  fluidRow(
                    
                    box(
                      title = "Left scatter plot", 
                      fluidRow(
                        column(
                          width = 6,
                          uiOutput("dependent_variable_scatter1")
                        ),
                        column(
                          width = 6,
                          uiOutput("independent_variable_scatter1")
                        )
                      ),
                      fluidRow(
                        column(
                          width = 6,
                            uiOutput("namelagscattereins")  
                        ),
                        column(
                          width = 6,
                          selectInput("linNon.1", "Smooth method left scatter plot", choices = c("Linear", "Non-Linear"))
                        )
                          ),
                      actionButton("printscatter1","Print scatter plot"),
                      br(),
                      br(),
                      conditionalPanel("input.printscatter1", uiOutput("scatt.1")),
                      conditionalPanel("input.printscatter1", plotOutput("scatterPlots1",
                                                                         click = "scatter1_click" ,
                                                                         brush = brushOpts(id = "scatter1_brush")
                      )),
                      
                      conditionalPanel("input.printscatter1", actionButton("exclude_toggle.1", "Toggle points")),
                      conditionalPanel("input.printscatter1", actionButton("exclude_reset.1", "Reset")),
                      conditionalPanel("input.printscatter1", hr()),
                      conditionalPanel("input.printscatter1",
                                           textInput("namescattereinsreport", "Choose name for reportlist", width = 200),
                                           actionButton("acceptscattereinsreport", "Add to reportlist")
                                         
                                       
                      )
                      
                      
                    ),
                    
                    
                    box( 
                      title = "Right scatter plot",
                      fluidRow(
                        column(
                          width =6,
                            uiOutput("dependent_variable_scatter2")
                        ),
                        column(
                          width = 6,
                          uiOutput("independent_variable_scatter2")
                        )
                      ),
                      fluidRow(
                        column(
                          width = 6,
                            uiOutput("namelagscatterzwei") 
                        ),
                        column(
                          width = 6,
                            selectInput("linNon.2", "Smooth method right scatter plot", choices = c("Linear", "Non-Linear"))
                        )
                      ),
                      actionButton("printscatter2","Print scatter plot"),
                      br(),
                      br(),
                      conditionalPanel("input.printscatter2", uiOutput("scatt.2")),
                      conditionalPanel("input.printscatter2", plotOutput("scatterPlots2",
                                                                         click = "scatter2_click" ,
                                                                         brush = brushOpts(
                                                                           id = "scatter2_brush"
                                                                         )
                      )),
                      conditionalPanel("input.printscatter2", actionButton("exclude_toggle.2", "Toggle points")),
                      conditionalPanel("input.printscatter2", actionButton("exclude_reset.2", "Reset")),
                      conditionalPanel("input.printscatter2", hr()),
                      conditionalPanel("input.printscatter2",
                                           textInput("namescatterzweireport", "Choose name for reportlist", width = 200),
                                           actionButton("acceptscatterzweireport", "Add to reportlist")
                                       
                      )
                      
                      
                    )
                    
                  )
                 ),
                tabPanel("Matrix",
                         br(),
                         uiOutput("variablesscattermatrix"),
                         actionButton("plotmatrix", "Plot scatter matrix"),
                         plotOutput("scattermatrix", width = 1000, height = 800),
                         conditionalPanel("input.plotmatrix", hr()),
                         conditionalPanel("input.plotmatrix",
                                             textInput("namescattermatrixreport", "Choose name for reportlist", width = 200),
                                             actionButton("acceptscattermatrixreport", "Add to reportlist")
                                         
                        )
                   )
                            
                  
                )
            ),
                box(
                  title = "Time series", status = "warning",
                  width = 15,
                  collapsible = TRUE,
                  solidHeader = TRUE,
                  side = "right",
                
                  div(id="linkhelpid12", style = "float:right; font-size: 25px; color: Red; display: inline-block",actionLink("linkhelp12", label = "?")),
                  bsModal("modalExample12", "Data Visualization", "linkhelp12", size = "large",
                          uiOutput("texthelp12")),
                  br(),
                  br(),
                  tabsetPanel(
                    tabPanel("Scaled",
                          fluidRow(
                            box(
                                width = 4,
                                height = 280,
                                p(strong("Choose target variable")),
                                uiOutput("depvarplotallcomp"),
                                uiOutput("comparePlot", width = 300),
                                br(),
                                br(),
                                br(),
                                actionButton("plotAllComp", label = "Plot current selection")
                          ),
                            box(
                                width = 4,
                                height = 280,
                                uiOutput("nonLinearPlot"),
                                textInput("nonLinRelation", label = "Determine non-linear relation"),
                                numericInput("nonLinLag", label = "Determine lag", min = 0, value = 0),
                                fluidRow(
                                  actionButton("accept", "Accept non-linear relation and time-lag"),
                                  actionButton("resetnonlinear", "Reset")
                                )
                                
                            ),
                            conditionalPanel("input.plotAllComp", box(
                              width = 4,
                                h4(strong("Summary of the current selected options")),
                                dataTableOutput("modNOnLin")
                               )
                              )
                             
                            ),
                        
                            conditionalPanel("input.plotAllComp", dygraphOutput("compGraph")),
                            br(),
                            conditionalPanel("input.plotAllComp", dataTableOutput("tableCor")),
                            conditionalPanel("input.plotAllComp", hr()),
                            conditionalPanel("input.plotAllComp",
                                             textInput("nameplotAllCompreport", "Choose name for reportlist", width = 200),
                                             actionButton("acceptplotAllCompreport", "Add to reportlist")
                            )
                        
                      ),
                    tabPanel("Unscaled",
                             br(),
                             uiOutput("choosevariablesUnscaledtimeseries"),
                             actionButton("plotAllunscaledComp","Plot timeseries"),
                             dygraphOutput("unscaledtimeseriesplot")
                             )
                    )
                  ),
                box(
                  title = "Distribution analysis", color = "orange",
                  status = "warning",
                  collapsible = TRUE,
                  solidHeader = TRUE,
                  width = 15,
                  
                  div(id="linkhelpid13", style = "float:right; font-size: 25px; color:#f4b943; display: inline-block",actionLink("linkhelp13", label = "?")),
                  bsModal("modalExample13", "Distribution Analysis", "linkhelp13", size = "large",
                          uiOutput("texthelp13")),
                  
                  fluidRow(
                    br(),
                    br(),
                    box(
                      width = 6,
                      height = 180,
                      column(
                        width = 6,
                        uiOutput("distVariabel"),
                        actionButton("plotdistr", "Plot distribution")
                      ),
                      column(
                        width = 6,
                        sliderInput("binsHist", label = h4(strong("Number of bins:")),
                                    min = 1, max = 50, value = 25)
                      )    
                    ),
                    box(
                      width = 6, 
                      height = 180,
                      h4(strong("Choose distribution function")),
                      selectInput("select.fit", label = "",
                                  choices = list("No Distribution" = "keine", "Normal distribution" = "norm", "Logarithmic normal distribution" = "lnorm",
                                                 "Exponential distribution" = "exp", "Logistic distribution" = "logis",
                                                 "Cauchy distribution" = "cauchy", "Gamma distribution" = "gamma",
                                                 "Equal distribution" = "unif", "Weibull distribution" = "weibull", "Pareto distribution" = "pareto"), selected = 1),
                      
                      actionButton("fitHisto", "Fit distributions")  
                    )
                  ),
                  conditionalPanel("input.plotdistr", box(
                    width = 12, 
                    uiOutput("headerHist"),
                    plotOutput("histggPlot"),
                    box(
                      title = "Statistical evaluation",
                      collapsible = TRUE,
                      solidHeader = TRUE,
                      width = 15,
                        tableOutput("distEval")
                    )
                  )
                  )
                ),
            box(
              title = "Box plots", color = "orange",
              status = "warning",
              collapsible = TRUE,
              solidHeader = TRUE,
              width = 15,
              tabsetPanel(
                tabPanel("Scaled",
                         br(),
                         uiOutput("boxplotvariablesscaled"),
                         checkboxInput("showdatapointsboxplotscaled", "Show datapoints", FALSE),
                         actionButton("plotboxplotsscaled", "Plot boxplots"),
                         conditionalPanel("input.plotboxplotsscaled", plotOutput("boxplotsAllscaled", height = 800))
                       
                ),
                tabPanel("Unscaled",
                         br(),
                         uiOutput("boxplotvariables"),
                         checkboxInput("showdatapointsboxplot", "Show datapoints", FALSE),
                         actionButton("plotboxplots", "Plot boxplots"),
                         conditionalPanel("input.plotboxplots", plotOutput("boxplotsAll", height = 800))
                         )
              )
            )
                
)
