tab3save<-
  
  tabItem(tabName = "explsavedmodel",
          
          conditionalPanel(condition = "input.storeReg || input.storeRegAuto", box(
            title = "Stored regression model",
            collapsible = TRUE,    
            status = "warning", 
            solidHeader = TRUE,
            width = 15,
            
            conditionalPanel(condition = "input.storeReg || input.storeRegAuto", strong(h2("Saved model", align = "center"))),
            conditionalPanel(condition = "input.storeReg || input.storeRegAuto", dygraphOutput("storedModel")),
            
            br(),
            br(),
            fluidRow(
              box(
                width = 4,
                title = "Coefficient evaluation",
                tableOutput("storeCoefficent")
              ),
              box(
                width = 4,
                title = "Quality of regression",
                tableOutput("storeQuality")
              ),
              box(
                width = 4,
                title = "Drivers and time lags",
                tableOutput("storeLag")
              )
            )
          ))
)