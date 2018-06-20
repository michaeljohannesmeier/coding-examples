tab4C<-
  
  tabItem(tabName = "foreindepmdi",
          
          fluidRow(  
            
            box(    
              width = 12,
              solidHeader = TRUE,
              collapsible = TRUE,
              status = "warning",
              title = "Independent variables",
              
              div(id="linkhelpid22", style = "float:right; font-size: 25px; color:orange; display: inline-block",actionLink("linkhelp22", label = "?")),
              bsModal("modalExample22", "Independent variables", "linkhelp22", size = "large",
                      uiOutput("texthelp22")),
              
              fluidRow(
                box(
                  width = 6,
                  uiOutput("chooseVariablemanual"),
                  conditionalPanel(condition = "input.manualindvar != ''", actionButton("plottsManual", "Choose variable"))
                )
              )
            )
          ),
          
          conditionalPanel(condition = "input.manualindvar != ''", box(
            title = "Manual data input",
            width = 15,
            solidHeader = TRUE,
            collapsible = TRUE,
            collapsed = FALSE,
            status = "warning",
            
            div(id="linkhelpid23", style = "float:right; font-size: 25px; color:orange; display: inline-block",actionLink("linkhelp23", label = "?")),
            bsModal("modalExample23", "Manual data input", "linkhelp23", size = "large",
                    uiOutput("texthelp23")),
            
            fluidRow(
              
              box(
                width = 4,
                div(id="expValue",numericInput("expected", label = "Expected Value", value = 0)),
                tags$head(tags$style(type="text/css", "#expValue {display: inline-block}"),
                          tags$head(tags$style(type="text/css", "#xlimitsmax {max-width: 40px}"))),
                
                div(id="lowQuant",numericInput("lower", label = "Lower Quantile", value = 0)),
                tags$head(tags$style(type="text/css", "#lowQuant {display: inline-block}"),
                          tags$head(tags$style(type="text/css", "#xlimitsmax {max-width: 40px}"))),
                
                div(id="upQuant",numericInput("upper", label = "Upper Quantile", value = 0)),
                tags$head(tags$style(type="text/css", "#upQuant {display: inline-block}"),
                          tags$head(tags$style(type="text/css", "#xlimitsmax {max-width: 40px}")))
              ),
              box(
                width = 2,
                p(strong("Date to forecast:")),
                uiOutput("displayDate")
              ),
              box(
                width = 2,
                actionButton("acceptforecast", "Set next forecast"),
                br(),
                br(),
                actionButton("deleteforecast", "Delete last forecast"),
                br(),
                br(),
                actionButton("saveforecast", "Save forecast")
                
              )
            ),
            fluidRow(
              box(
                width = 4,
                uiOutput("manual.header"),
                dataTableOutput("manual.data")
              ),
              box(
                width = 8,
                dygraphOutput("graphmanual")
              )
              
              
            )
            
          )
          )
          
  )