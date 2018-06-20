
tab3 <-
  
  tabItem(tabName = "explautomodel",
               
              box(
                width = 15,
                title = "Independent variables",
                collapsible = TRUE,
                status = "warning",
                solidHeader = TRUE,
                div(id="linkhelpid14", style = "float:right; font-size: 25px; color:orange; display: inline-block",actionLink("linkhelp14", label = "?")),
                bsModal("modalExample14", "Choose independent variable", "linkhelp14", size = "large",
                        uiOutput("texthelp14")),
                uiOutput("choose_columns")
                
              ),
          
          
          
          box(
            
            title = "Compute explanation model with automatic computed time lags",
            collapsible = TRUE,    
            status = "warning", 
            solidHeader = TRUE,
            width = 15,
            
            div(id="linkhelpid15", style = "float:right; font-size: 25px; color:orange; display: inline-block",actionLink("linkhelp15", label = "?")),
            bsModal("modalExample15", "Compute explanation model with automatic comuted time lags", "linkhelp15", size = "large",
                    uiOutput("texthelp15")),

                  
                  fluidRow(
                    box(
                      width = 4,
                      numericInput("range", label = "Range of lags to search:", value = 1, min = 1, max = 10)
                      ),
                      box(
                        width = 4,
                        radioButtons("interaction.1", label = "Compute interactions between independent variables?", choices = list("Yes" = 1, "No" = 0), selected = 1)
                      ),
                    box(
                      width = 3,
                      actionButton("autoReg", "Calculate automatic model"),
                        br(),
                        br(),
                        conditionalPanel(condition = "input.autoReg", actionButton("storeRegAuto", label = "Save automatic model"))
                    )
                  ),#fluidRow
            uiOutput("headerautofitmodel"),
            
            
            
            
            div(class = "span4", conditionalPanel(condition = "input.autoReg", dygraphOutput("regAuto"))),
            br(),
            br(),
            fluidRow(
              
              conditionalPanel(condition = "input.autoReg", box(
                width = 4,
                title = "Coefficient evaluation",
                conditionalPanel("input.autoReg", NULL),
                conditionalPanel("input.autoReg", tableOutput("auto.coef")),
                conditionalPanel("input.autoReg")
              ),
              box(
                width = 4,
                title = "Quality of regression",
                conditionalPanel("input.autoReg", NULL),
                conditionalPanel("input.autoReg", tableOutput("auto.qual")),
                conditionalPanel("input.autoReg")
              ),
              box(
                width = 4,
                title = "Drivers and time lags",
                conditionalPanel("input.autoReg", NULL),
                conditionalPanel("input.autoReg", tableOutput("auto.lag")),
                conditionalPanel("input.autoReg")
              )
              
              )  
            )
          )
          
          
  )


