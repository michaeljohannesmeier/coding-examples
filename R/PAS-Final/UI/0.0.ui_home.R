tabItem(tabName = "home", class = "active",

      box(
        width = 15,
        height = 1000,
            strong(div(id="aboutPASid", style = "font-size: 20px; color:#FF1111;",actionLink("aboutPAS", status = "warning", icon = icon("info"), 
                                                                                         label = "  About PwC PAS"))),
            bsModal("modalaboutPAS", "PwC Predictive Analytics Suit", "aboutPAS", size = "large",
                uiOutput("aboutPAS")),
            imageOutput("image1")
            
      ),
      box(
        width = 15,
        height = 830,
            HTML('<h1>PwC PAS Video</h1>
                <main role="main">
                 <video src="http://hlx00008sta.blob.core.windows.net/test/English.mp4" 
                        width = "900" height ="700"
                        controls preload="none" >Your browser does not support the video tag!</video>
                 </main>'),
        h4(strong(tags$a(href = "http://www.pwc.de/de/risk/effiziente-planung-und-steuerung-mit-der-pwc-predictive-analytics-suite.html",
                         "www.pwc-PAS.de")))
      )

          
)

