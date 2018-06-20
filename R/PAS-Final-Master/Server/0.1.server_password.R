observeEvent(input$login,{
  
  if(input$username == "" & input$password == ""){
    start$password = TRUE
    withProgress(message = "Log in succesfull", Sys.sleep(1.5))
  }else{
  withProgress(message = "Log in denied", Sys.sleep(1.5))
  }
})
output$password<-renderUI({
  if(start$password == TRUE){return(h4(strong("Login sucessfull!")))}
    box(
      width = 6, 
      status = "warning", 
      solidHeader = TRUE,
      title = "Enter login data",
      textInput("username", "Username"), 
      passwordInput("password", "Password"),
      actionButton("login", "Log in")
    )
})