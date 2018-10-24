#The moments function allows you to calculate the first and second moments for a given subperiod.
#The function takes as arguments the enddate and begindate of the period of interest.
#Note that data has to be tidy and called tidydata


moments <- function(enddate, begindate){
  tidydata %>% 
    filter(Date < enddate & Date > begindate) %>% 
    group_by(Ticker) %>% 
    mutate(dailyreturn = Price/lag(Price) - 1) %>% 
    summarise(mean = mean(dailyreturn, na.rm = TRUE), std_dev = sd(dailyreturn, na.rm = TRUE))
}