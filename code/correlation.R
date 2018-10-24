#First calculate the log returns
returns <- (
  diff(log(dailydata %>% arrange(Date) %>% tbl_xts()), lag=1)*100)

#now drop the first date of every series
returns <- returns[-1,]

#calculate the correlation table
correlation <- table.Correlation(Ra = returns, Rb = returns)