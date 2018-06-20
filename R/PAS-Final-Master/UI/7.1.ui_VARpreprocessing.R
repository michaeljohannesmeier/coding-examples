tabItem(tabName = "preprocessing",
        
        box(
          width = 15,
          title = "Preselection of variables", status = "warning", solidHeader = TRUE, collapsible = TRUE,  
          
                  uiOutput("choose_columnsVar"),
                  actionButton("PREP", "Calculate")

                
              
        ),
        box(
          width = 15,
          title = "Show preprocessing", status = "warning", solidHeader = TRUE, collapsible = TRUE,
          fluidRow(
            column(
              width = 6,
                conditionalPanel(condition = "input.PREP", h4(strong("Information criteria BIC to corresponding lag", align = "left", style = "blue"))),
                dataTableOutput("lag.length")
            )
          ),
          fluidRow(
            column(
              width = 12, 
                br(),
                br(),
                conditionalPanel(condition = "input.PREP", h4(strong("Reduced data set due to necessarity of complete cases", align = "left", style = "blue"))),
                br(),
                dataTableOutput("var_data")
            )
          )
          
        )
          
)