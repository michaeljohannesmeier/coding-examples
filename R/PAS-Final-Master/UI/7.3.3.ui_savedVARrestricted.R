tabItem(tabName = "savedVARrest",
        
        conditionalPanel("input.saveresEST", box(
          width = 15,
          title = "Show saved rest.VAR explanation model", status = "warning", solidHeader = TRUE, collapsible = TRUE, 
          dygraphOutput("savedvarrestexplmodelZwei"),
          tableOutput("savedvarrestexplmodelDrei"),
          tableOutput("savedvarrestexplmodelVier")
        )
        ),
        conditionalPanel("input.saveresEST", box(
          width = 15,
          title = "Show saved VAR forecast", status = "warning", solidHeader = TRUE, collapsible = TRUE,
          conditionalPanel("input.saveresFCST", dygraphOutput("savedforecastrestvargraph")),
          conditionalPanel("input.saveresFCST", dataTableOutput("savedforecastgraphtablerest"))
        )
        )
)