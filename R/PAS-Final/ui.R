library(htmltools)
library(shiny)
library(shinydashboard)
library(shinythemes)
library(ggplot2)
library(dygraphs)
library(forecast)
library(ISwR)
library(readxl)
library(dplyr)
library(MASS)
library(markdown)
library(QuantPsyc)
library(lubridate)
library(fmsb)
library(d3heatmap)
library(DAAG)
library(ggfortify)
library(metricsgraphics)
library(ggvis)
library(timeSeries)
library(fitdistrplus)
library(tictoc)
library(doParallel)
#library(RevoScaleR)
library(shinyBS)
#library(dynlm)
library(vars)
library(xts)
library(zoo)
#library(stringr)
library(GGally)
library(plotly)

###################################################################################################################################################################################
###############################################################USER INTERFACE######################################################################################################
###################################################################################################################################################################################

sidebar <- dashboardSidebar(
  width = 350,
  sidebarMenuOutput("MenuItem")
)


header <- dashboardHeader(
  titleWidth = 350,
  title = "PwC's Predictive Analytics Suite"
  
)





body <- dashboardBody(
  tabItems(
    source('UI/0.0.ui_home.R', local=TRUE)$value,
    source('UI/0.1.ui_password.R', local=TRUE)$value,
    source('UI/1.0.ui_dataimport.R', local=TRUE)$value,
    source('UI/1.1.ui_mainsettings.R', local=TRUE)$value,
    source('UI/2.1.ui_datarearrange.R', local=TRUE)$value,
    source('UI/2.2.ui_datasplit.R', local=TRUE)$value,
    source('UI/3.1.ui_analysistable.R', local=TRUE)$value,
    source('UI/3.2.ui_analysisvisual.R', local=TRUE)$value,
    source('UI/4.1.ui_explautomodel.R', local=TRUE)$value,
    source('UI/4.2.ui_explmanualmodel.R', local=TRUE)$value,
    source('UI/4.3.ui_explsavedmodel.R', local=TRUE)$value,
    source('UI/5.1.ui_foreindeptsa.R', local=TRUE)$value,
    source('UI/5.2.ui_foreindeptrend.R', local=TRUE)$value,
    source('UI/5.3.ui_foreindepmdi.R', local=TRUE)$value,
    source('UI/5.4.ui_foreindepsaved.R', local=TRUE)$value,
    source('UI/6.1.ui_forecastdepmontecarlo.R', local=TRUE)$value,
    source('UI/6.2.ui_savedforecastmreg.R', local=TRUE)$value,
    source('UI/7.1.ui_VARpreprocessing.R', local=TRUE)$value,
    source('UI/7.2.1.ui_explanationVAR.R', local=TRUE)$value,
    source('UI/7.2.2.ui_forecastVAR.R', local=TRUE)$value,
    source('UI/7.2.3.ui_savedVAR.R', local=TRUE)$value,
    source('UI/7.3.1.ui_explanationVARrestricted.R', local=TRUE)$value,
    source('UI/7.3.2.ui_forecastVARrestricted.R', local=TRUE)$value,
    source('UI/7.3.3.ui_savedVARrestricted.R', local=TRUE)$value,
    source('UI/8.1.ui_backtestingcrosssectional.R', local=TRUE)$value,
    source('UI/8.2.ui_backtestingonestepahead.R', local=TRUE)$value,
    source('UI/9.ui_reporting.R', local=TRUE)$value
    
    
  )
)

ui <- dashboardPage(
  skin = "red",
  header,
  sidebar,
  body
)