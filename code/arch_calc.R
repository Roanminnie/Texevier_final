arch_calc <- function(stockname){
    Rtn %>% 
    filter(Ticker== stockname) %>% 
    select(date, Return) %>% 
    mutate(Return_sqd = Return^2) %>% 
    mutate(Return_abs = abs(Return))
}

