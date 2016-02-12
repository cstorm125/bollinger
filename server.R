library(shiny)
library(quantmod)
library(TTR)
library(lubridate)
library(PerformanceAnalytics)

shinyServer(
	#at the start of each refresh
    
	function(input, output){
	    
	    #Download data
		dataInput <- reactive({  
		    getSymbols(input$symb, src = "yahoo", 
		               from = ymd(input$dates[1])-input$dayMA,
		               to = input$dates[2],
		               auto.assign = FALSE)
		})
		
		#Plot Bands
		output$plot <- renderPlot({
            chartSeries(dataInput(), theme = chartTheme("white"), 
		                type = "line", TA=c(addVo()))
		    addBBands(n=input$dayMA,sd=2,ma=input$select)
		})
		
		#Backtesting
		returns <- reactive({
		    g<-dataInput()
		    close <- Cl(g)
		    bbands <- BBands(close,n=input$dayMA,ma=input$select)
		    lower <- bbands$dn
		    upper<-bbands$up
		    signals<-Lag(ifelse(close<lower,1,ifelse(close>upper,-1,0)))
		    r<-ROC(close, type = 'discrete')*signals
		    return(r)
		})
		output$summary<-renderPlot({
		    par(mfrow=c(3,1))
		    charts.PerformanceSummary(returns())
		})
		
		
	}
)