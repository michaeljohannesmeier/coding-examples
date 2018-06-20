#library(htmltools)
library(shiny)
library(shinydashboard)
library(shinythemes)
#library(ggplot2)
library(dygraphs)
library(forecast)
#library(ISwR)
library(readxl)
library(dplyr)
#library(MASS)
#library(markdown)
#library(QuantPsyc)
library(lubridate)
#library(fmsb)
library(d3heatmap)
#library(DAAG)
#library(ggfortify)
#library(metricsgraphics)
#library(ggvis)
library(timeSeries)
#library(fitdistrplus)
library(tictoc)
#library(doParallel)
#library(RevoScaleR)
library(shinyBS)
#library(dynlm)
library(vars)
library(xts)
library(zoo)
#library(stringr)
#library(GGally)
library(plotly)
#library(devtools)
#library(archivist)
#library(mxnet)
# JavaVersion xxx
# Sys.setenv(JAVA_HOME='C:\\Program Files\\Java\\jreXXX')
#Sys.setenv(JAVA_HOME='C:\\Program Files\\Java\\jre-9.0.1')
#library(xlsx)
#library(Quandl)
library(DT)
#library(caret)
#library(glmnet)
library(broom)
library(googleVis)
#library(RColorBrewer)
#library(colourpicker)
# library(tsoutliers)
# library(funtimes)
# library(extrafont)
# library(lmtest)
# library(seasonal)
library(tseries)

###################################################################################################################################################################################
###############################################################USER INTERFACE######################################################################################################
###################################################################################################################################################################################



sidebar <- dashboardSidebar(
  width = 350,
  sidebarMenuOutput("MenuItem")
)


header <- dashboardHeader(
  titleWidth = 350,
  title = "Data Visualization Tool"

  
)


body <- dashboardBody(
  tags$head(tags$style(HTML('
      *{
        font-family: "Georgia",serif;
        font-size: 14px;
      }
      .main-header .logo{
        font-family: "Georgia",serif;
        font-size: 24px;
      }
      .box .box-title{
        font-family: "Georgia",serif;
        font-size: 18px;
      }
  '))),
  tabItems(
    #source('UI/0.General/0.0.ui_home.R', local=TRUE)$value,
    #source('UI/0.General/0.1.ui_password.R', local=TRUE)$value,
    #source('UI/0.General/0.6.ui_reporting.R', local=TRUE)$value,
    #source('UI/1.Dataimport/1.0.ui_dataimport.R', local=TRUE)$value,
    #
    source('UI/3.DataAnalysis/3.1.ui_analysistable.R', local=TRUE)$value,
    source('UI/3.DataAnalysis/3.2.ui_analysisvisual.R', local=TRUE)$value,
    source('UI/3.DataAnalysis/3.3.ui_analysisTSDecomposition.R', local=TRUE)$value
    # source('UI/8.Univariate Models/8.1.ui_univariateArima.R', local=TRUE)$value,
    # source('UI/8.Univariate Models/8.1.1.ui_univariateArimaSaved.R', local=TRUE)$value,
    # source('UI/8.Univariate Models/8.2.ui_univariateExpsm.R', local=TRUE)$value,
    # source('UI/8.Univariate Models/8.2.1.ui_univariateExpsmSaved.R', local=TRUE)$value,
    # source('UI/4.MReg/4.1.Regressionmodel/4.1.1.ui_explautomodel.R', local=TRUE)$value,
    # source('UI/4.MReg/4.1.Regressionmodel/4.1.2.ui_explmanualmodel.R', local=TRUE)$value,
    # source('UI/4.MReg/4.1.Regressionmodel/4.1.3.ui_explsavedmodel.R', local=TRUE)$value,
    # source('UI/4.MReg/4.1.Regressionmodel/4.1.4.ui_explcrossvalidation.R', local=TRUE)$value,
    # source('UI/4.MReg/4.2.ForecastIndepVariable/4.2.1.ui_foreindeparima.R', local=TRUE)$value,
    # source('UI/4.MReg/4.2.ForecastIndepVariable/4.2.2.ui_foreindepexpsm.R', local=TRUE)$value,
    # source('UI/4.MReg/4.2.ForecastIndepVariable/4.2.3.ui_foreindeptrend.R', local=TRUE)$value,
    # source('UI/4.MReg/4.2.ForecastIndepVariable/4.2.4.ui_foreindepmdi.R', local=TRUE)$value,
    # source('UI/4.MReg/4.2.ForecastIndepVariable/4.2.5.ui_foreindepVAR.R', local=TRUE)$value,
    # source('UI/4.MReg/4.2.ForecastIndepVariable/4.2.6.ui_foreindepsaved.R', local=TRUE)$value,
    # source('UI/4.MReg/4.3.Montecarlo/4.3.1.ui_forecastdepmontecarlo.R', local=TRUE)$value,
    # source('UI/4.MReg/4.3.Montecarlo/4.3.2.ui_savedforecastmreg.R', local=TRUE)$value,
    # source('UI/4.MReg/4.3.Montecarlo/4.3.3.ui_saveIntoDatabase.R', local=TRUE)$value,
    # source('UI/5.VAR/5.1.ui_VARpreprocessing.R', local=TRUE)$value,
    # source('UI/5.VAR/5.2.1.ui_explanationVAR.R', local=TRUE)$value,
    # source('UI/5.VAR/5.2.2.ui_forecastVAR.R', local=TRUE)$value,
    # source('UI/5.VAR/5.3.1.ui_explanationVARrestricted.R', local=TRUE)$value,
    # source('UI/5.VAR/5.3.2.ui_forecastVARrestricted.R', local=TRUE)$value,
    # source('UI/5.VAR/5.4.ui_savedVAR.R', local=TRUE)$value,
    # source('UI/6.Backtesting/6.0.ui_backtestingcompare.R', local=TRUE)$value,
    # source('UI/6.Backtesting/6.1.ui_backtestingcrosssectional.R', local=TRUE)$value,
    # source('UI/6.Backtesting/6.2.ui_backtestingonestepahead.R', local=TRUE)$value,
    # source('UI/7.NeuralNetwork/7.1.1.ui_trainANNforecasts.R', local=TRUE)$value,
    # source('UI/7.NeuralNetwork/7.1.2.ui_infoTrainedForecasts.R', local=TRUE)$value,
    # source('UI/7.NeuralNetwork/7.2.1.ui_finalANNforecast.R', local=TRUE)$value
    
  )
)

ui <- dashboardPage(
  skin = "blue",
  header,
  sidebar,
  body
)