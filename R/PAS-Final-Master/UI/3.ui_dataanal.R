tab2 <- tabItem(tabName = "dataanal",
                
                box(
                  width = 15,
                  title = "Dependent variable", status = "warning", solidHeader = TRUE, collapsible = TRUE,
                  div(id="linkhelpid132", style = "float:right; font-size: 25px; color:orange; display: inline-block",actionLink("linkhelp132", label = "?")),
                  bsModal("modalExample132", "Choose independent variable", "linkhelp132", size = "large",
                          uiOutput("texthelp132")),
                  uiOutput("dependent_variable")
                ),
                
                
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
                  title = "Scatter plots",
                  #collapsed  = TRUE,
                  collapsible = TRUE,
                  solidHeader = TRUE,
                  status = "warning",
                  width = 15,

                  div(id="linkhelpid7", style = "float:right; font-size: 25px; color: Red; display: inline-block",actionLink("linkhelp7", label = "?")),
                  bsModal("modalExample7", "Scatter Plots", "linkhelp7", size = "large",
                          uiOutput("texthelp7")),
                      
                      br(),
                      br(),
                          fluidRow(

                             box(
                               title = "Left scatter plot", 

                               uiOutput("independent_variable_scatter1"),
                               
                               numericInput("scatter.1.lags", "Time lags left scatter plot", min = 0, value = 0),
                               selectInput("linNon.1", "Smooth method left scatter plot", choices = c("Linear", "Non-Linear")),
                               
                               actionButton("printscatter1","Print scatter plot"),
                               br(),
                               conditionalPanel("input.printscatter1", uiOutput("scatt.1")),
                               conditionalPanel("input.printscatter1", plotOutput("scatterPlots1",
                                          click = "scatter1_click" ,
                                          brush = brushOpts(id = "scatter1_brush")
                               )),
                               
                               conditionalPanel("input.printscatter1", actionButton("exclude_toggle.1", "Toggle points")),
                               conditionalPanel("input.printscatter1", actionButton("exclude_reset.1", "Reset"))
                               
                               
                             ),
                             
                             
                             box( 
                               title = "Right scatter plot", 
                               uiOutput("independent_variable_scatter2"),
                               
                               numericInput("scatter.2.lags", "Time lags right scatter plot", min = 0, value = 0),
                               selectInput("linNon.2", "Smooth method right scatter plot", choices = c("Linear", "Non-Linear")),
                               
                               actionButton("printscatter2","Print scatter plot"),
                               br(),
                               conditionalPanel("input.printscatter2", uiOutput("scatt.2")),
                               conditionalPanel("input.printscatter2", plotOutput("scatterPlots2",
                                          click = "scatter2_click" ,
                                          brush = brushOpts(
                                            id = "scatter2_brush"
                                          )
                               )),
                               conditionalPanel("input.printscatter2", actionButton("exclude_toggle.2", "Toggle points")),
                               conditionalPanel("input.printscatter2", actionButton("exclude_reset.2", "Reset"))
                               
                             )
                            
                           )
                  
                  
                  ),

                  
                
                box(
                  title = "Correlation analysis", color = "orange",
                  collapsible = TRUE,
                  solidHeader = TRUE,
                  status = "warning",
                  collapsed = TRUE, 
                  width = 15,
                  div(id="linkhelpid9", style = "float:right; font-size: 25px; color: Red; display: inline-block",actionLink("linkhelp9", label = "?")),
                  bsModal("modalExample9", "Correlation Analysis", "linkhelp9", size = "large",
                          uiOutput("texthelp9")),
                  
                  br(),
                  br(),
                  
                           
                           
                  dataTableOutput("lag.all")
                  
                  
                ),
                
                box(
                  title = "Collinearity analysis", color = "orange",
                  collapsible = TRUE,
                  solidHeader = TRUE,
                  status = "warning",
                  collapsed = TRUE, 
                  width = 15,
                  tabsetPanel(
                      tabPanel("Collinearity table",
                               div(id="linkhelpid10", style = "float:right; font-size: 25px; color: Red; display: inline-block",actionLink("linkhelp10", label = "?")),
                               bsModal("modalExample10", "Collinearity table", "linkhelp10", size = "large",
                                       uiOutput("texthelp10")),
                               br(),
                           
                              dataTableOutput("korrelation_ind")
                  
                        


                  ),
                      tabPanel("Hightest collinearities",
                
                               div(id="linkhelpid11", style = "float:right; font-size: 25px; color: Red; display: inline-block",actionLink("linkhelp11", label = "?")),
                               bsModal("modalExample11", "Hightest Collinearities", "linkhelp11", size = "large",
                                       uiOutput("texthelp11")),
                               br(),
                               dataTableOutput("maxKol")
                   
                  )
                  )
                  ),
                box(
                  title = "Data visualization", status = "warning",
                  width = 15,
                  collapsible = TRUE,
                  solidHeader = TRUE,
                  collapsed = TRUE,
                  side = "right",
                  
                  div(id="linkhelpid12", style = "float:right; font-size: 25px; color: Red; display: inline-block",actionLink("linkhelp12", label = "?")),
                  bsModal("modalExample12", "Data Visualization", "linkhelp12", size = "large",
                          uiOutput("texthelp12")),
                  
                           
                           
                            uiOutput("comparePlot", width = 300),
                          
                           fluidRow(
                             
                             column(
                               width = 3,
                               uiOutput("nonLinearPlot")
                             ),
                             column(
                               width = 3,
                               textInput("nonLinRelation", label = "Determine non-linear relation", width = "250px")
                             ),
                             column(
                               width = 3,
                               numericInput("nonLinLag", label = "Determine lag", min = 0, value = 0,  width = "250px"),
                               br(),
                               actionButton("accept", "Accept non-linear relation and time-lag")
                             ),
                             column(
                               width = 3,
                               br(),
                               actionButton("plotAllComp", label = "Plot current selection    ")
                             )
                           ),
                           fluidRow(
                              column(
                                h3("Summary of the current selected options"),
                              width = 5,
                                tableOutput("modNOnLin")
                             )
                             
                             
                           ),
                           
                           dygraphOutput("compGraph"),
                           br(),
                           dataTableOutput("tableCor")
                           
                           
                  ),
                
                box(
                  title = "Distribution analysis", color = "orange",
                  status = "warning",
                  collapsible = TRUE,
                  solidHeader = TRUE,
                  collapsed = TRUE, 
                  width = 15,
                  
                  div(id="linkhelpid13", style = "float:right; font-size: 25px; color:#f4b943; display: inline-block",actionLink("linkhelp13", label = "?")),
                  bsModal("modalExample13", "Distribution Analysis", "linkhelp13", size = "large",
                          uiOutput("texthelp13")),
                  
                           fluidRow(
                             box(
                               width = 2,
                               
                               uiOutput("distVariabel")
                             ),
                             box(
                               width = 2,
                               sliderInput("binsHist", label = h4(strong("Number of bins:")),
                                           min = 1, max = 50, value = 25),
                               actionButton("fitHisto", "Fit distributions")
                             ),
                             box(
                               width = 2,
                               conditionalPanel(condition = "input.fitHisto" , h4(strong("Choose distribution function")),
                                                
                                                selectInput("select.fit", label = "",
                                                            choices = list("No Distribution" = "keine", "Normal distribution" = "norm", "Logarithmic normal distribution" = "lnorm",
                                                                           "Exponential distribution" = "exp", "Logistic distribution" = "logis",
                                                                           "Cauchy distribution" = "cauchy", "Gamma distribution" = "gamma",
                                                                           "Equal distribution" = "unif", "Weibull distribution" = "weibull", "Pareto distribution" = "pareto"), selected = 1))
                             )
                           ),
                           uiOutput("headerHist"),
                           plotOutput("histggPlot"),
                           uiOutput("headerEval"),
                           tableOutput("distEval")
                           
                  )
                  
                
)
