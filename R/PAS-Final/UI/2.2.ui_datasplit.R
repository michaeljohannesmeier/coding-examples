tabItem(tabName = "datasplit",
        
        box(
          title = "Split data",
          width= 15, 
          collapsible = TRUE,
          status = "warning", 
          solidHeader = TRUE,
          
          fluidRow(
            box(
              
              
              width = 4,
              numericInput("numbersplit", label = "Choose number of observations", value = 100),
              br(),
              actionButton("split", "Split"),
              actionButton("unsplit", "Unsplit")
            )
          )
        ),
        
        uiOutput("datasplitcomplete")
        
)  
        