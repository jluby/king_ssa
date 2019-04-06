#####################################################################
#Step 1.  load Human Mortality Database (HMD) historical mortality
#rates,our mortality forecasts, the linear projections.  Both the
#forecast and projections are for males with smoking and obesity
#lagged 25 years in age and 25 years in time to account for the
#cohort's earlier experience.
#####################################################################
hmd.lt.con <- read.table("worse_than_you_think_dataverse_files/input/hmd.lt.con.txt",header=TRUE,sep="")
load("worse_than_you_think_dataverse_files/input/forecast.Rdata")
load("worse_than_you_think_dataverse_files/input/linear.projections.Rdata")


#####################################################################
#Step 2.  Plot linear projections and our forecasts of male mortality
#that both include historical smoking and obesity.  Botht the linear
#projection and forecasts are in the natural log scale, so we
#exponentiate to return to the true scale.
#####################################################################
year <- 1986:2030
age.labels <- c("50-54","55-59","60-64","65-69",
                "70-74","75-79","80-84","85-89","90-94","95-99")
                
pdf("worse_than_you_think_dataverse_files/output/linear_projections_and_forecasts.pdf",width=11,height=5.5)
par (mfrow=c(1,2),mgp=c(2.75,1,0)*0.55, mar=c(1.6,1.5,0.5,1)*1.6,omi=c(0.2,0.5,0.4,0), tcl=-0.25, bg="white", cex=0.8)
matplot(year,t(exp(linear.projections[12:21,])),type="l",lty=1,col=1,xlab=NA,ylab=NA,bty="l",las=1,xlim=c(min(year)-4,max(year)),ylim=c(0,1))
text(rep(min(year)-3,length(age.labels)),exp(linear.projections[12:21,1]),paste(c(age.labels)),cex=0.8)
matplot(year,t(exp(forecast[12:21,as.character(year)])),type="l",lty=1,col=1,xlab=NA,ylab=NA,bty="l",las=1,xlim=c(min(year)-4,max(year)),ylim=c(0,1))
text(rep(min(year)-3,length(age.labels)),exp(forecast[12:21,1]),paste(c(age.labels)),cex=0.8)
mtext("Year",side=1,line=0,outer=TRUE,at=c(1,3)/4)
mtext("5_q_x",side=2,line=,outer=TRUE,at=1/2,las=1,cex=0.8)
mtext("Linear Model: \n Time+Smoking+Obesity",side=3,line=-1,outer=TRUE,at=1/4)
mtext("Our Forecasts: \n Time+Smoking+Obesity",side=3,line=-1,outer=TRUE,at=3/4)
dev.off()

#############################################################
#Step 3.  Write the values plotted in panel4.pdf to .csv files
#############################################################
write.csv(exp(linear.projections),file="worse_than_you_think_dataverse_files/output/linear.projections.csv")
write.csv(exp(forecast),file="worse_than_you_think_dataverse_files/output/forecast.csv")

