tab3A<-

tabItem(tabName = "explmanualmodel",
        

          box(
            width = 15,
            title = "Independent variables",
            collapsible = TRUE,
            status = "warning",
            solidHeader = TRUE,
            div(id="linkhelpid16", style = "float:right; font-size: 25px; color:orange; display: inline-block",actionLink("linkhelp16", label = "?")),
            bsModal("modalExample16", "Choose independent variable", "linkhelp16", size = "large",
                    uiOutput("texthelp16")),
            
            uiOutput("choose_columns_manual")
          ),
        

          
       
        box(
          
          title = "Compute explanation model with manually specified time lags",
          collapsible = TRUE,    
          status = "warning", 
          solidHeader = TRUE,
          width = 15,
          
          div(id="linkhelpid17", style = "float:right; font-size: 25px; color:orange; display: inline-block",actionLink("linkhelp17", label = "?")),
          bsModal("modalExample17", "Compute Explanation Model with manually specified time lags", "linkhelp17", size = "large",
                  uiOutput("texthelp17")),
          
          fluidRow(
            box(
              width = 3,
              textInput("lagAll", "Select time lags",value = "")
            ),
            box(
              width = 4,
              radioButtons("interaction.2", label = "Compute interactions between independent variables?", choices = list("Yes" = 1, "No" = 0), selected = 1)
            ),
            box(
              width = 2,
              radioButtons("optimize", label = "Optimize model?", choices = list("Yes" = 1, "No" = 0), selected = 1)
            ),
            box(
              width = 2,
              actionButton("reg", label = "Calculate manual model"),
              br(),
              br(),
              conditionalPanel(condition = "input.reg", actionButton("storeReg", label = "Save manual model"))
            )
          ),#fluidRow
          
          uiOutput("headermanualfitmodel"),  
          conditionalPanel(condition = "input.reg", dygraphOutput("regErgebnis")),
          
          br(),
          br(),
          fluidRow(
            conditionalPanel(condition = "input.reg", box(
              width = 4,
              title = "Coefficient evaluation",
              conditionalPanel(condition = "input.reg",NULL),
              tableOutput("dataGrundlage")
            ),
            box(
              width = 4,
              title = "Quality of regression",
              tableOutput("qualityMat")
            ),
            box(
              width = 4,
              title = "Drivers and time lags",
              conditionalPanel("input.reg", tableOutput("manual.lag"))
            )
            )
          )
        ) 
        
        
)












