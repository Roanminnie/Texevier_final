load_pkg("TTR")
data_adj <- dailydata %>% arrange(Date) %>% mutate_at(.vars = vars(-Date),
                                                      .funs = funs(ROC(., type = c("continuous", "discrete")[2]))) %>%
  mutate_at(.vars = vars(-Date), funs(na.locf(., na.rm = F, maxgap = 5)))

data_adj <- data_adj %>% 
  gather(Stocks, Returns, -Date)

RebMonths <- 7

RandomWeights <-
  data_adj %>%
  mutate(Months = as.double(format(Date, format = "%m")),
         YearMonths = as.double(format(Date, format = "%Y%m"))) %>%
  filter(Months %in% RebMonths) %>%
  group_by(YearMonths, Stocks) %>% filter(Date == last(Date)) %>% 
  ungroup() %>% 
  arrange(Date) 

Equal_weights <-
  RandomWeights %>%
  group_by(Date) %>%
  mutate(EqualWeights = 1/n()) %>% ungroup() %>% select(-Months, -YearMonths)

Fund_Size_at_Start <- 1000

EW_weights <- Equal_weights %>% 
  select(Date, Stocks, EqualWeights) %>% 
  spread(Stocks, EqualWeights) %>% tbl_xts()

df_Returns <- data_adj %>% spread(Stocks, Returns)
df_Returns[is.na(df_Returns)] <- 0
xts_df_Returns <- df_Returns %>% tbl_xts()

EW_RetPort <- Return.portfolio(xts_df_Returns, weights = EW_weights,
                               verbose = TRUE, contribution = TRUE, value = Fund_Size_at_Start,
                               geometric = TRUE)

EW_Contribution <- EW_RetPort$contribution %>% xts_tbl() %>%
  mutate(date = lag(date), date = coalesce(date, index(EW_weights)[1]))
EW_BPWeight <- EW_RetPort$BOP.Weight %>% xts_tbl() %>% mutate(date = lag(date),
                                                              date = coalesce(date, index(EW_weights)[1]))
EW_BPValue <- EW_RetPort$BOP.Value %>% xts_tbl() %>% mutate(date = lag(date),
                                                            date = coalesce(date, index(EW_weights)[1]))

df_port_return_EW <- left_join(data_adj %>% rename(date = Date),
                               EW_BPWeight %>% gather(Stocks, weight, -date), by = c("date",
                                                                                     "Stocks")) %>% left_join(., EW_BPValue %>% gather(Stocks,
                                                                                                                                       value_held, -date), by = c("date", "Stocks")) %>% left_join(.,
                                                                                                                                                                                                   EW_Contribution %>% gather(Stocks, Contribution, -date),
                                                                                                                                                                                                   by = c("date", "Stocks")) %>% 
  na.omit(df_port_return_EW)

df_Portf_EW <- df_port_return_EW %>% group_by(date) %>% summarise(PortfolioReturn = sum(Returns *
                                                                                          weight, na.rm = TRUE)) %>% filter(PortfolioReturn != 0)

Cum_EW <- df_Portf_EW %>% mutate(cumreturn_EW = (cumprod(1 +
                                                           PortfolioReturn) - 1)) %>% mutate(wealthindex_EW = 100 *
                                                                                               (cumprod(1 + PortfolioReturn))) %>% select(-PortfolioReturn)

portf_plot <- ggplot(data = Cum_EW)+
  geom_line(aes(x = date, y = wealthindex_EW)) +
  ggtitle("Portfolio returns") +
  guides(alpha=FALSE, colour = FALSE) +
  theme_fivethirtyeight()