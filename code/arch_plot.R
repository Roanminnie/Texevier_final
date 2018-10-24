arch_plot <- function(df_name){
    plotdata <- df_name %>% gather(Returntype, returns, -date)
    
    plot <- ggplot(plotdata)+
    geom_line(aes(x = date, y = returns, colour = Returntype, alpha = 0.5)) +
    ggtitle("Return Type Persistence") +
    facet_wrap(~Returntype, nrow = 3, ncol = 1, scales = "free") +
    guides(alpha=FALSE, colour = FALSE) +
    theme_fivethirtyeight()
    
}