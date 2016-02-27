library(shiny)
library(markdown)

shinyUI(navbarPage("Bollinger Backtest",
                   
    tabPanel('App',
             sidebarLayout(
                 sidebarPanel(
                     helpText("Enter the symbol, date range and other Bollinger Bands parameters."),
                     textInput("symb", "Symbol", "SPY"),
                     dateRangeInput("dates", 
                                    "Date range",
                                    start = "2013-01-01", 
                                    end = as.character(Sys.Date())),
                     selectInput("select", label = h3("Method"), 
                                 choices = list("SMA" = "SMA", "WMA" = "WMA", "EMA" = "EMA"), 
                                 selected = 1),
                     sliderInput("dayMA", "Moving Average Days", value=20, min=5,max=100,step=5)
                 ),
                 mainPanel(
                     tabsetPanel(
                         tabPanel("Bands", plotOutput("plot")),
                         tabPanel("Summary",plotOutput('summary')),
                         tabPanel("Stats",
                                  h3('Annualized'),
                                  tableOutput('ar'),
                                  h3('Trades'),
                                  tableOutput('ts')),
                         tabPanel("Downside",
                                  h3('Risks'),
                                  tableOutput('ds'),
                                  h3('Drawdowns'),
                                  tableOutput('dd'))
                 ))
             )),
    tabPanel('About',
             includeMarkdown('README.md')
             )

))