##################
#Step 1. Read data
##################
ssa.mx <- read.table("worse_than_you_think_dataverse_files/input/ssa.mx.rates.txt",header=TRUE)

####################################
#Step 2. Organize data into an array.  
####################################
year.list <- rownames(table(ssa.mx$year))
age.list <- rownames(table(ssa.mx$age))
cause.list <- rownames(table(ssa.mx$cause)) 
cost.list <- rownames(table(ssa.mx$cost))
sex.list <- rownames(table(ssa.mx$sex))
ssa.mx.array <- array(NA,dim=c(length(age.list),length(year.list),length(sex.list),length(cause.list),length(cost.list)),dimnames=list(age.list,year.list,sex.list,cause.list,cost.list))
for (j in 1:length(sex.list)) {
  for (k in 1:length(cause.list)) {
    for (l in 1:length(cost.list)) {
      for (m in 1:length(year.list)) {
        tmp <- subset(ssa.mx, sex==sex.list[j] &
                      year==year.list[m] & cause==cause.list[k] & cost==cost.list[l])
        ssa.mx.array[,year.list[m],sex.list[j],cause.list[k],cost.list[l]] <- tmp$rate
      }}}}

######################################################################################
#Step 3. Graph male vascular, ages 60-64 and 65-69 years, intermediate cost projection
######################################################################################
year.list <- as.numeric(year.list)

pdf("worse_than_you_think_dataverse_files/output/vascular_male_age_60_65.pdf", width=5.5, height=5.5, paper="special")
par (mfrow=c(1,1),mgp=c(2.75,1,0)*0.55,mar=c(1.6,1.5,0.5,1)*1.6,omi=c(0.2,0.5,0.4,0), tcl=-0.25,bg="white", cex=1.2)
matplot(year.list[1:24],t(ssa.mx.array[14:15,1:24,"male","vascular","intermediate"]),col=1:2,ylab=NA,xlab=NA,las=1,xlim=c(min(year.list),max(year.list)),ylim=c(0,300),pch=1,bty="l")
matpoints(year.list[25:47],t(ssa.mx.array[14:15,25:47,"male","vascular","intermediate"]),type="l",col=1:2,lty=1,lwd=2)
text(1995,60,"60-64 Years")
text(2015,200,"65-69 Years",col=2)
mtext("Year",side=1,line=-0.5,outer=TRUE,at=1/2,cex=1.2)
mtext("Deaths per 100,000 Person-Years",side=2,line=0,outer=TRUE,at=1/2,cex=1.2)
mtext("SSA Projection of Vascular Disease Mortality",side=3,line=-0.5,outer=TRUE,at=1/2,cex=1.2)
dev.off()

###################################################
#Step 4. Create .csv file of the values in the plot
###################################################
vascular.data1 <- cbind(year=year.list[1:27],age.60.64=ssa.mx.array[14,1:27,"male","vascular","intermediate"],
                       age.65.69=ssa.mx.array[15,1:27,"male","vascular","intermediate"],observed=1)
vascular.data2 <- cbind(year=year.list[28:47],age.60.64=ssa.mx.array[14,28:47,"male","vascular","intermediate"],
                       age.65.69=ssa.mx.array[15,28:47,"male","vascular","intermediate"],observed=0)
vascular.data <- rbind(vascular.data1,vascular.data2)

vasc1 <- cbind(year=year.list[1:24],observed.age.60.64=ssa.mx.array[14,1:24,"male","vascular","intermediate"],
               observed.age.65.69=ssa.mx.array[15,1:24,"male","vascular","intermediate"])
vasc2 <- cbind(year=year.list[25:47],
               ssa.age.60.64=ssa.mx.array[14,25:47,"male","vascular","intermediate"],
               ssa.age.65.69=ssa.mx.array[15,25:47,"male","vascular","intermediate"])
vasc <- merge(vasc1,vasc2,by="year",all.x=TRUE,all.y=TRUE)

write.csv(vasc,file="worse_than_you_think_dataverse_files/output/vascular_male_age_60_65.csv")
