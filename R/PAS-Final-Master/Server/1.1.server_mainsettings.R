###diese Server-Datei regelt die Ausgabe des Tabs Main-Settings 



# diese DataTable zeigt den Output in der Box Show data im Tab Main settings -> es wird Hauptdatensatz angezeigt (daten.under$base)
# hier im Kartenreiter Data
output$contentsEins <- renderDataTable({
  
  withProgress(message = "Reading data, please wait",value=0.1,{
    
    validate(
      need(!identical(daten.under$base, daten.start), "Choose file to upload")
    )
    
    
    incProgress(0.2)
    
    
    validate(
      need(!identical(daten.under$base, data.frame(Test.x = c(-1:1), Test.y = c(-1:1)^2)), "Check Seperator, Header and Quote settings")
    )
    
    incProgress(0.5)
    
    daten.under$base
    
  })
  
}, options = list(pageLength = 10, scrollX = TRUE))



# diese DataTable zeigt den Output in der Box Show data im Tab Main settings  -> es wird Hauptdatensatz angezeigt (daten.under$base)
# hier im Kartenreiter Structure
output$structureEins <- renderPrint({
  
  validate(
    need(!identical(daten.under$base, daten.start), "Choose file to upload")
  )
  
  validate(
    need(!identical(daten.under$base, data.frame(Test.x = c(-1:1), Test.y = c(-1:1)^2)), "Check Seperator, Header and Quote settings")
  )
  
  str(daten.under$default)
})


# durch dr?cken des Buttons Change dataset wird der Datensatz zur?ckgesetzt, d.h. alle reactive Values werden auf "Null" gesetzt -> dadurch wird auch die 
# sidebar ver?ndert und man gelangt zum Ausgangsbildschirm
observeEvent(input$restart1dataset, {

  start$accepteddataset = FALSE
  start$datum <- Sys.Date()
  start$dates <- vector()
  start$date.index <- FALSE
  start$freq <- 0
  start$freq2 <- 0
  start$method1 <- FALSE
  start$method2 <- FALSE 
  start$ci.predict.2 <- 0
  start$freqchange1 <- 0
  start$freqchange2 <- 0
  
  daten.under$base = daten.start
  daten.under$default = daten.start
  daten.under$default2 = 0
  daten.under$data.scale = daten.start
  daten.under$data.hole = daten.start
  daten.under$data.train = 0
  daten.under$data.test = 0
  daten.under$scale.values = list()
  daten.under$data.temp.1 = daten.start
  daten.under$keeprows.1 = rep(TRUE, nrow(daten.start))
  daten.under$data.temp.2 = daten.start
  daten.under$keeprows.2 = rep(TRUE, nrow(daten.start))
  daten.under$daten.non.linear.konstant = daten.start
  daten.under$daten.non.linear= daten.start
  daten.under$arima.modells = list()
  
  index2$inputfilename = 0
  index2$indepVar = ""
  index2$depVar = ""
  index2$anzahlregressoren = "not choosen yet"
  index2$range = ""
  
  report$plots = list()
  report$zwischenspeicher = 0 
  report$scattereins = 0
  report$scatterzwei = 0
  report$scattermatrix = 0
  report$plotAllComp = 0
  report$plotAllCompzwei = 0
  report$matrices = list()
  report$timeseriesplotAllComp = list()
  report$korrelationtableplotAllComp = 0
  report$correlationtablehole = 0
  report$regression.store.plot = 0
  report$prediction.results = 0
  report$savedfinalforecastgraph = 0
  report$collcorr = 0
    
  splitindex$splittruefalse = 0
  splitindex$split = 0
  
  lag$cortable = 0
    
  plot.variable$tabelle.relation = data.frame()
  plot.variable$tabelle.korrelation = data.frame()
    
  regression.modelle$automatisches.modell = 0
  regression.modelle$manuelles.modell = 0 
  regression.modelle$gespeichertes.modell = 0
  regression.modelle$art.gespeichertes.modell = ""
  regression.modelle$regression.quality = 0
  regression.modelle$regression.coefficent = 0
  regression.modelle$indexcalculateauto = 0
  regression.modelle$indexcalculatemanual = 0
    
  regression.values$save.reg = 0
    
  crossfold$fold.graph = 0
  crossfold$fold.evaluation = data.frame()
    
  store.graph$graphs = list()
  store.graph$saveArima = data.frame()
  store.graph$boolArima = FALSE
  store.graph$current.graph = 0
  store.graph$arimaPredData = 0
  store.graph$manualPredData = 0
  store.graph$index = 0
  store.graph$index2 = 0
    
  trend.values$trends = 0
  trend.values$trends.temp = 0
  trend.values$defaultOrTrendPlot = 0
  trend.values$index = 0
  trend.values$index2 = 0
    
  submitted.manual$submitted.data = 0
  submitted.manual$submitted.temp = 0
  submitted.manual$bindeddata = 0
  submitted.manual$store.graph = list()
  submitted.manual$store.graph.saved = list()

  index$deleted = 1
  
  arima.values$tabelle.variablen = 0
  arima.values$max.steps.predict = 0
  
  VAR$model = 0
  VAR$modelres = 0
  VAR$fcst = 0
  VAR$fcstres = 0
  
  dygraph$indexforecast = FALSE
  dygraph$indexforecastres = FALSE
  
})

# Auswahl der abhaengigen Variable fuer die Regressionsanalyse
# Hat ein Drop-Down-Menue mit allen moeglichen numerischen Variablen als Ergbnis 


# nach dr?cken des Buttons Change method werden hier die reactiven Values ge?ndert, sodass sich die sidebar wie gew?nscht anpasst
observeEvent(input$change1methodbutton,{

  if(input$change1methodradio == "varmodell"){return(
    list(
      start$method1 <- FALSE,
      start$method2 <- TRUE
    )
  )}
  
  if(input$change1methodradio == "mreg"){return(
    list(
      start$method1 <- TRUE,
      start$method2 <- FALSE
    )  
    )}
})

######################################################################################################################
#############################################Ab hier beginnt der UI Teil########################################################
######################################################################################################################
# der komplette UI-Teil wird hier in einem renderUI dargestellt, um ihn nach dr?cken von Change method oder Change dataset "verschwinden" zu lassen
output$mainsettings<-renderUI({

 
#  list( 
#         box(
#           width = 15,
#           title = "Dependent variable", status = "warning", solidHeader = TRUE, collapsible = TRUE,
#           div(id="linkhelpid132", style = "float:right; font-size: 25px; color:orange; display: inline-block",actionLink("linkhelp132", label = "?")),
#           bsModal("modalExample132", "Choose independent variable", "linkhelp132", size = "large",
#                   uiOutput("texthelp132")),
#           uiOutput("dependent_variable_eins")
#         ),
#     
        #box(
        #  title = "Restart and upload new dataset", 
        #  collapsible = TRUE,
        #  collapsed = FALSE,
        #  width = 15, 
        #  status = "warning", 
        #  solidHeader = TRUE,
        #  fluidRow(
        #    box(
        #      width = 6,
        ##      height = 200,
        #      h4(strong("Restart with new dataset")),
      #        br(),
      #        p("By pressing 'Change Dataset' the compplete datas will be resetet."),
       #       p("Be sure you saved the results first!"),
      #        br(),
      #        actionButton("restart1dataset", "Change dataset")
       #     )
      #    )
          
       # ),
        
        box(
          title = "Show data", 
          collapsible = TRUE,
          collapsed = FALSE,
          width = 15, 
          status = "warning", 
          solidHeader = TRUE,
          tabsetPanel(
            tabPanel("Data", dataTableOutput('contentsEins')),
            tabPanel("Structure",  verbatimTextOutput("structureEins"))
          )
        )
})





