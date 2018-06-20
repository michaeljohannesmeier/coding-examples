tab4D<-
  
  tabItem(tabName = "foreindepsaved",
          
          fluidRow(  
            
            box(    
              width = 12,
              solidHeader = TRUE,
              collapsible = TRUE,
              status = "warning",
              title = "Independent variables",
              
              fluidRow(
                box(
                  width = 6,
                  uiOutput("chooseSavedModel"),
                  actionButton("showModel", "Show details"),
                  actionButton("deleteModel", "Delete selected model")
                ),
                box(
                  width = 6,
                  dataTableOutput("currentModels") 
                )
              )
            )
          ), #fluidRow
          conditionalPanel(condition =  "input.showModel", box(
                          width = 15,
                          solidHeader = TRUE,
                          collapsible = TRUE,
                          status = "warning",
                          title = "Forecast of independent variables",
                          uiOutput("modelUI")
          ))
  )