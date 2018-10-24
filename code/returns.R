returns <- function(stockname, dfname){
  rtn <- tidydata %>% 
    filter(Ticker == stockname) %>% 
    arrange(Date) %>% 
    mutate(rtn = (diff(log(Price, lag(Price)))*100)) 

   dfname <-  rtn[-1,]
}

