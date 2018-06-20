tabItem(tabName = "savedVAR",
        
        conditionalPanel("input.saveEST", box(
          width = 15,
          title = "Show saved VAR explanation model", status = "warning", solidHeader = TRUE, collapsible = TRUE, 
          dygraphOutput("savedvarexplmodelZwei"),
          tableOutput("savedvarexplmodelDrei"),
          tableOutput("savedvarexplmodelVier")
        )
        ),
        box(
          width = 15,
          title = "Show saved VAR forecast", status = "warning", solidHeader = TRUE, collapsible = TRUE,
          conditionalPanel("input.saveFCST", dygraphOutput("savedforecastvargraph")),
          conditionalPanel("input.saveFCST", dataTableOutput("savedforecastgraphtable"))
        
        )
)