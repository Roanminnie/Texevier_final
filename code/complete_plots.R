rtn <- (diff(
  log(dailydata %>% arrange(Date) %>% tbl_xts()), lag=1)
)*100 
rtn <- rtn[-1,]
rtn <- scale(rtn, center=T, scale=F)


Rtn <- log(1 + rtn/100)*100 
Rtn <- Rtn %>% xts_tbl() %>% gather(Ticker, Return, -date)
Rtn$date <-  as.Date(x = Rtn$date, format="%Y-%m-%d")

source("code/arch_calc.R")
ABSP <- arch_calc("JSE.ABSP.Close")
BVT <- arch_calc("JSE.BVT.Close")
FSR <- arch_calc("JSE.FSR.Close")
NBKP <- arch_calc("JSE.NBKP.Close")
RMH <- arch_calc("JSE.RMH.Close")
SBK <- arch_calc("JSE.SBK.Close")
SLM <- arch_calc("JSE.SLM.Close")

colnames(ABSP) = c("date","Returns", "Returns_sqd", "Returns_abs")
colnames(BVT) = c("date","Returns", "Returns_sqd", "Returns_abs")
colnames(FSR) = c("date","Returns", "Returns_sqd", "Returns_abs")
colnames(NBKP) = c("date","Returns", "Returns_sqd", "Returns_abs")
colnames(RMH) = c("date","Returns", "Returns_sqd", "Returns_abs")
colnames(SBK) = c("date","Returns", "Returns_sqd", "Returns_abs")
colnames(SLM) = c("date","Returns", "Returns_sqd", "Returns_abs")


source("code/arch_plot.R")
plot_absp <- arch_plot(ABSP)
plot_bvt <- arch_plot(BVT)
plot_fsr <- arch_plot(FSR)
plot_nbkp <- arch_plot(NBKP)
plot_rmh <- arch_plot(RMH)
plot_sbk <- arch_plot(SBK)
plot_slm <- arch_plot(SLM)



