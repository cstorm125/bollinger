# Load/attach packages
require(quantmod)
require(PerformanceAnalytics)

symb='^GSPC'
dayMA=20
select='SMA'
from.dat='2008-01-01'
to.dat='2008-12-31'

#symbol
g<-getSymbols(symb,auto.assign = FALSE)
close <- Cl(g)
bbands <- BBands(close,n=dayMA,ma=select)
lower <- bbands$dn
upper<-bbands$up
signals<-Lag(ifelse(close<lower,1,ifelse(close>upper,-1,0)))
returns <- ROC(close, type = 'discrete')*signals
returns <- returns[paste(from.dat,'/',to.dat,sep='')]

#Chart summary
charts.PerformanceSummary(returns)
#Annualized return, sd, sharpe
ar<-table.AnnualizedReturns(returns)
ar
#Drawdowns
dd<-table.Drawdowns(returns)
dd
#Downside Risks
ds<-table.DownsideRisk(returns)
ds
# Buys, Sells, Totals
ts<-table(signals)
names(ts)<-c('Sell','Hold','Buy')
ts