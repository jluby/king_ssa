# SET working directory to inacc_replication here 
setwd("~/Desktop/Git/inacc_replication")


library(simpleboot)
load("systematic_bias_dataverse_files/data/ex_ssa.dta")
load("systematic_bias_dataverse_files/data/tfr_ssa.dta")
load("systematic_bias_dataverse_files/data/observed/obs.ex.dta")
load("systematic_bias_dataverse_files/data/observed/obs.tfr.dta")
rownames(obs.tfr) <- rownames(obs.ex)

# we will only look at forecasts made for 1980 to 2010, every 5 years (1980 only available for OADR)
main_years <- seq(1980,2010,5)
tfr.use <- tfr.ssa[tfr.ssa$forecast.year %in% main_years,]
ex.use <- ex.ssa[ex.ssa$forecast.year %in% main_years,]

########################
##### calculate distance from forecast
########################
ex.use$years.from.forecast <- ex.use$forecast.year-ex.use$TR
tfr.use$years.from.forecast <- tfr.use$forecast.year-tfr.use$TR

ex.residual <- ex.use[,c("TR","forecast.year","years.from.forecast","hmd_residual","ssa_residual")]
ex.residual$type <- NA
ex.residual$type[ex.use$age==0 & ex.use$sex=="Male"] <- "Male Life Expectancy at Birth"
ex.residual$type[ex.use$age==0 & ex.use$sex=="Female"] <- "Female Life Expectancy at Birth"
ex.residual$type[ex.use$age==65 & ex.use$sex=="Male"] <- "Male Life Expectancy at 65"
ex.residual$type[ex.use$age==65 & ex.use$sex=="Female"] <- "Female Life Expectancy at 65"
colnames(ex.residual)[4:5] <- c("residual","ssa_residual")

tfr.residual <- tfr.use[c("TR","forecast.year","years.from.forecast","hfd_residual","ssa_residual")]
tfr.residual$type <- "TFR"
colnames(tfr.residual)[4:5] <- c("residual","ssa_residual")

residual.df <- rbind(ex.residual,tfr.residual)

# reorder factors
residual.df$type_order <- 1
residual.df$type_order[residual.df$type=="Female Life Expectancy at Birth"] <- 2
residual.df$type_order[residual.df$type=="Male Life Expectancy at 65"] <- 3
residual.df$type_order[residual.df$type=="Female Life Expectancy at 65"] <- 4
residual.df$type_order[residual.df$type=="TFR"] <- 5
residual.df$type <- reorder(residual.df$type, residual.df$type_order)


residual.df$weight <- 1/residual.df$years.from.forecast
residual.df$weight[residual.df$weight==Inf] <- 1
types <- unique(residual.df$type)



######### WEIGHTED LOESS - HMD / HFD #########
bs.results <- list()
set.seed(02138)
R <- 10000

for(t in 1:length(types)){
temp <- residual.df[residual.df$type==types[t],]
temp <- temp[temp$years.from.forecast>=0,]
ord <- order(temp$TR)
tr <- temp$TR[ord]
res <- temp$residual[ord] # residual
wts <-  temp$weight[ord]

# run loess and bootstrap (on HMD or HFD data)
lout <- loess(res~tr,weights=wts,span=0.9)
lboot <- loess.boot(lout, R=R, row=T,new.xpts=tr)
                
# final output
lboot.mat <- sapply(lboot$boot.list,function(x) x$fitted)
std <- apply(lboot.mat,1,sd,na.rm=T)
lb <- lout$fitted-qnorm(0.975)*std
ub <- lout$fitted+qnorm(0.975)*std
loess.df <- data.frame(TR=tr,fit=lout$fitted, lb=lb, ub=ub, type=types[t])
bs.results[[t]] <- loess.df
print(paste("Done with",t,sep=" "))
}

demog_loess_boot <- do.call(rbind,bs.results)


######### WEIGHTED LOESS - SSA #########
bs.results.ssa <- list()
set.seed(02138)
R <- 10000


for(t in 1:length(types)){
temp <- residual.df[residual.df$type==types[t],]
temp <- temp[temp$years.from.forecast>=0,]
ord <- order(temp$TR)
tr <- temp$TR[ord]
res <- temp$ssa_residual[ord] # residual
wts <-  temp$weight[ord]

# run loess and bootstrap (on HMD or HFD data)
lout <- loess(res~tr,weights=wts,span=0.9)
lboot <- loess.boot(lout, R=R, row=T,new.xpts=tr)
                
# final output
lboot.mat <- sapply(lboot$boot.list,function(x) x$fitted)
std <- apply(lboot.mat,1,sd,na.rm=T)
lb <- lout$fitted-qnorm(0.975)*std
ub <- lout$fitted+qnorm(0.975)*std
loess.df <- data.frame(TR=tr,fit=lout$fitted, lb=lb, ub=ub, type=types[t])
bs.results.ssa[[t]] <- loess.df
print(paste("Done with",t,sep=" "))
}

demog_loess_ssa_boot <- do.call(rbind,bs.results.ssa)


##### save files #####
save(demog_loess_boot, demog_loess_ssa_boot, file="data/demog_loess_boot.RData")