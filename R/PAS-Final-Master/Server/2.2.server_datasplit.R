#reactive Values für den Datensplit
splitindex<-reactiveValues(
  splittruefalse = 0,
  split = 0
  
)

#Ausfuehrung bei actionButton split werden die letzten xxx Datenpunkte des Datensatzes abgetrennt und dann in daten.under$data.hole, daten.under$data.train
#und daten.under$data.test gespeichert. Danach wird aber der train-Datensatz an daten.under$data.base weitergegeben. Mit daten.under$data.base werden die 
#weiteren Berechnungen ausgeführt
observeEvent(input$split,{
  
  
  splitindex$split<-input$numbersplit
  

  if(splitindex$splittruefalse == 1) {}
  else if(splitindex$splittruefalse == 0){
    

      daten.under$data.train <- daten.under$base[1:(nrow(daten.under$base)-splitindex$split),]
      daten.under$data.test<-daten.under$base[(nrow(daten.under$base)-splitindex$split+1):nrow(daten.under$base),]
      splitindex$splittruefalse <- 1
      splitindex$split = input$numbersplit
      daten.under$base <- daten.under$data.train
      
    withProgress(message = "Data splitted",value=0.1,{
      setProgress(1)
      Sys.sleep(1.5)
    })
    
  }
  
})

#Nach drücken des actionButtons unsplit wird der Datensplit rückgängig gemacht
observeEvent(input$unsplit,{
  
 
    daten.under$base <-daten.under$default[,-1]
    daten.under$base<-cbind(start$dates,daten.under$base)
    colnames(daten.under$base)[1]<-"Date"
  
    
    splitindex$split = 0
    splitindex$splittruefalse <-0
  
    daten.under$data.test = 0
    daten.under$data.train = 0
  
    withProgress(message = "Data unsplitted",value=0.1,{
      setProgress(1)
      Sys.sleep(1.5)
    })
  
  
})


#Anzeige der Tabelle "Show Data"
output$holedata <- renderDataTable({
  
  print("SPLIT TRUE FALSE")
  print(splitindex$splittruefalse)
  
  if(splitindex$splittruefalse == 1){return()}
  daten.under$base
  
  
}, options = list(pageLength = 10,scrollX = TRUE))


#Anzeige der Tablle "Test Data"
output$testdata <- renderDataTable({
  
  if(identical(daten.under$data.test, 0)) return()
  
  daten.under$data.test
  
}, options = list(pageLength = 10,scrollX = TRUE))



#Anzeige der Tabelle "Train Data"
output$traindata <- renderDataTable({
  
  if(identical(daten.under$data.test, 0)) return()
  
  daten.under$data.train
  
}, options = list(pageLength = 10,scrollX = TRUE))

output$datasplitcomplete <- renderUI({
  
        
  print(splitindex$splittruefalse)
        if(splitindex$splittruefalse == 0){return( 
          box(
            title = "Show unsplitted data",
            width= 15, 
            collapsible = TRUE,
            status = "warning", 
            solidHeader = TRUE,
            dataTableOutput("holedata")
          )
          
        )}
         
        if(splitindex$splittruefalse == 1){return(
          list(
              box(                 
                title = "Show train data",
                width= 15, 
                collapsible = TRUE,
                status = "warning", 
                solidHeader = TRUE,
                dataTableOutput("traindata")
                
              ),
    
              box(
                title = "Show test data",
                width= 15, 
                collapsible = TRUE,
                status = "warning", 
                solidHeader = TRUE,
                dataTableOutput("testdata")
              )
          )
        )} 

})







