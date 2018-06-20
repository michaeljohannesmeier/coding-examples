tab3 <-
  
  tabItem(tabName = "savedforecastmontecarlo",

          
          conditionalPanel("input.saveForecastMreg", box(
            width = 15,
            title = "Show saved forecast", status = "warning", solidHeader = TRUE, collapsible = TRUE, 
            dygraphOutput("savedforecastmregdygraph"),
            br(),
            br(),
            dataTableOutput("savedvarforecastmregtable")
          )

  )    
          
)