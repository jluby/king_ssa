#####################################################################
#Step 1.  Load our life expectancy forecasts and SSA life expectancy
#projections.  SSA life expectancy came from SSA-provided historical mortality
#rates [1979,2008] and projections.  Also load Human Mortality
#Database life table for historical values.
#####################################################################
load("worse_than_you_think_dataverse_files/input/our.life.expectancy.Rdata")
load("worse_than_you_think_dataverse_files/input/ssa.life.expectancy.Rdata")
hmd.lt <- read.table("worse_than_you_think_dataverse_files/input/hmd.lt.txt",header=TRUE)

######################################################################
#Step 2. Calculate historical and forecast Old-Age Dependency Ratio
#(expressed as the ratio of 20-64 year olds to 65+ year olds).
######################################################################
year.hist <- 1980:2006
oadr.hist <- rep(NA,length(year.hist))
for (y in 1:length(year.hist))
  oadr.hist[y] <- (sum(subset(hmd.lt,Year==year.hist[y] & Age==20)$Tx)-sum(subset(hmd.lt,Year==year.hist[y] & Age==65)$Tx))/sum(subset(hmd.lt,Year==year.hist[y] & Age==65)$Tx)
oadr.historical <- cbind(year=year.hist,oadr=oadr.hist)

year.list <- 1980:2031
oadr.forecast <- cbind(year=year.list,oadr=(Tx["20",]-Tx["65",])/Tx["65",])

oadr <- merge(oadr.historical,oadr.forecast,by="year",all.x=TRUE,all.y=TRUE)
names(oadr) <- c("year","historical","our.forecast")
write.csv(oadr, file="worse_than_you_think_dataverse_files/output/oadr.csv")

########################################################################
#Step 3. Write .csv file with the difference of 2030 life expectancy
#between our forecasts and SSA projections (calculated from SSA-provided
#[1979,2008] mortality rates).
########################################################################
age.select <- dimnames(ssa.life.exp.scenario)[[1]]
ex.difference <- cbind(our.male=life.exp[as.character(age.select),"2030","male"],
                       ssa.male=ssa.life.exp.scenario[,"2030","male","intermediate"],
                       difference.male=12*(life.exp[as.character(age.select),"2030","male"]-ssa.life.exp.scenario[,"2030","male","intermediate"]),
                       our.female=life.exp[as.character(age.select),"2030","female"],
                       ssa.female=ssa.life.exp.scenario[,"2030","female","intermediate"],
                       difference.female=12*(life.exp[as.character(age.select),"2030","female"]-ssa.life.exp.scenario[,"2030","female","intermediate"]))
write.csv(ex.difference, file="worse_than_you_think_dataverse_files/output/ex.difference.csv")
