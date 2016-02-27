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
		#Returns
		returns <- reactive({
		    g<-dataInput()
		    close <- Cl(g)
		    bbands <- BBands(close,n=input$dayMA,ma=input$select)
		    lower <- bbands$dn
		    upper<-bbands$up
		    signals<-Lag(ifelse(close<lower,1,ifelse(close>upper,-1,0)))
		    r<-ROC(close, type = 'discrete')*signals
		    result<-list(r,signals)
		    return(result)
		})
		#Output plot
		output$summary<-renderPlot({
		    par(mfrow=c(3,1))
		    charts.PerformanceSummary(returns()[[1]])
		})
		#Downside Risks
		output$ds <-renderTable({
		    ds<-table.DownsideRisk(returns()[[1]])
		    ds
		})
		#Drawdown
		output$dd <-renderTable({
		    dd<-table.Drawdowns(returns()[[1]])
		    dd
		})
		#Annualized
		output$ar <-renderTable({
		    ar<-table.AnnualizedReturns(returns()[[1]])
		    ar
		})
		#Trade
		output$ts <-renderTable({
		    signals<-returns()[[2]]
		    ts<-table(signals)
		    names(ts)<-c('Sell','Hold','Buy')
		    ts<-as.data.frame(ts)
		    colnames(ts)<-c('Actions','Frequency')
		    ts
		})
		
		
		
	}
)