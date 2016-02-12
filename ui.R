library(shiny)

shinyUI(fluidPage(
   titlePanel('Bollinger Backtest'),
    sidebarLayout(
        sidebarPanel(
            helpText("This app runs backtesting using Bollinger Bands with no commission
                     (Data from Yahoo)."),
            helpText("Enter the symbol, date range and other Bollinger Bands parameters."),
            helpText("Results include band plot and analysis of
                     the specified Bollinger Bands strategy."),
            helpText("Warning: You may have to wait for plots to load/reload."),
            textInput("symb", "Symbol", "SPY"),
            
            dateRangeInput("dates", 
                           "Date range",
                           start = "2013-01-01", 
                           end = as.character(Sys.Date())),

            selectInput("select", label = h3("Method"), 
                        choices = list("SMA" = "SMA", "WMA" = "WMA", "EMA" = "EMA"), 
                        selected = 1),
            
            sliderInput("dayMA", "Moving Average Days", value=20, min=5,max=100,step=5),
            helpText("Bollinger Bands is a strategy where one buys when price drops below
                     the lower band and sells when it pops over the upper band."),
            helpText("The upper and lower bands (red) are moving averages of type SMA (simple), 
                     WMA (weighted), or EMA (exponential) for a given days plus/minus 
                     two standard deviations."),
            helpText("Cumulative return is the total return since one begins trading. For example,
                     a cumulative return of 0.10 means 10% total return. "),
            helpText("Daily return is return on
                     a daily basis."),
            helpText("Drawdowns are periods where the portfolio is at loss. For instance, -0.1 drawdown
                     means one is losing 10%.")
            ),
        
        mainPanel(
            h4("Bollinger Bands in Action"),
            plotOutput("plot"),
            h4("Analysis"),
            plotOutput('summary')
        )
    )
))