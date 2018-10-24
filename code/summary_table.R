#use the funtion moments in the code file
source("code/moments.R")
#apply this function for the specified periods
period1 <- moments("2008-12-31", "2006-05-18")
period2 <- moments("2013-12-31", "2009-12-31")
period3 <- moments("2015-07-31", "2013-12-31")
#create a dataframe combining the three dataframes above
summary_table <- data.frame(c(period1, period2 [,2:3], period3 [,2:3]))