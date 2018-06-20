tabItem(tabName = "datarearrange",
        
       
       fluidRow(
         box(
           title = "Scale Variable",
           width= 6, 
           collapsible = TRUE,
           collapsed = TRUE,
           status = "warning", 
           solidHeader = TRUE,
           
           
           div(id="monthreg", 
               uiOutput("scale.var", width = 300),
               tags$head(tags$style(type="text/css", "#monthreg {display: inline-block}"))),
           div(id="linkhelpid2", style = "float:right; font-size: 25px; color:orange;",actionLink("linkhelp2", label = "?")),
           bsModal("modalExample2", "Scale Variable", "linkhelp2", size = "large",
                   uiOutput("texthelp2")),
           
           br(),
           actionButton("scale.data", "Scale choosen variable")
  
         ),
      
        box(
          title = "Tweak individual data points",
          width= 6, 
          collapsible = TRUE,
          collapsed = TRUE,
          status = "warning", 
          solidHeader = TRUE,
          uiOutput("tweak.var", width = 300),
          
          div(id="monthreg",
              dateInput("tweak.date",
                        label = h4(strong("Choose date to tweak: yyyy-mm-dd")),
                        value = Sys.Date(),
                        width = 300
              ), 
              tags$head(tags$style(type="text/css", "#monthreg {display: inline-block}"))),

          div(id="linkhelpid4", style = "float:right; font-size: 25px; color:#f4b943",actionLink("linkhelp4", label = "?")),
          bsModal("modalExample4", "Tweak individual data points", "linkhelp4", size = "large",
                  uiOutput("texthelp4")),


          numericInput("tweak.value", h4(strong("New value")), value = 0, width = 300),
          
          #actionButton("tweak", "Tweak data", width = '200px'),
          actionButton("tweak", "Tweak data")

         )
        ),
       box(
         title = "Show data", 
         collapsible = TRUE,
         collapsed = FALSE,
         width = 15, 
         status = "warning", 
         solidHeader = TRUE,
              dataTableOutput('contents2')
         )
       
    
)
