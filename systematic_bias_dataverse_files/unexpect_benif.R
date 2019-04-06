# SET working directory to inacc_replication here 
setwd("~/Desktop/Git/inacc_replication")

ex.ssa <- read_dta("systematic_bias_dataverse_files/data/ex_ssa.dta")
tfr.ssa <- read_dta("systematic_bias_dataverse_files/data/tfr_ssa.dta")
popl <- read_dta("systematic_bias_dataverse_files/data/observed/hmd_population.dta")
flt <- read_dta("systematic_bias_dataverse_files/data/observed/hmd_fltper_1x1.dta")
mlt <- read_dta("systematic_bias_dataverse_files/data/observed/hmd_mltper_1x1.dta")
flt$sex <- "Female"
mlt$sex <- "Male"
lt <- rbind(flt, mlt)

### define life table function
life.table <- function(x, nMx){
   b0 <- 0.07;   b1<- 1.7;      
  nmax <- length(x)
   n <- c(diff(x),999)          #width of the intervals
 nax <- n / 2;		            # default to .5 of interval
 nax[1] <- b0 + b1 *nMx[1]    # from Keyfitz & Flieger(1968)
 nax[2] <- 0.5  ;              
 nax[nmax] <- 1/nMx[nmax] 	  # e_x at open age interval
 nqx <- (n*nMx) / (1 + (n-nax)*nMx)
 nqx<-ifelse( nqx > 1, 1, nqx); # necessary for high nMx
 nqx[nmax] <- 1.0
 lx <- c(1,cumprod(1-nqx)) ;  # survivorship lx
 lx <- lx[1:length(nMx)]
 ndx <- lx * nqx ;
 nLx <- n*lx - nax*ndx;       # equivalent to n*l(x+n) + (n-nax)*ndx
 nLx[nmax] <- lx[nmax]*nax[nmax]
 Tx <- rev(cumsum(rev(nLx)))
 ex <- ifelse( lx[1:nmax] > 0, Tx/lx[1:nmax] , NA);
 lt <- data.frame(x=x,nax=nax,nmx=nMx,nqx=nqx,lx=lx,ndx=ndx,nLx=nLx,Tx=Tx,ex=ex)
 return(lt)
}

# define delta function
delta.fxn <- function(delta, sex, year, resid, popl) {
  ex.65.obs <- life.table(0:110, lt[which(lt$Year==year & lt$sex==sex),]$mx)$ex[66]
  
  ex.65.alt <- rep(NA,length(delta))
  for (i in 1:length(delta)){
    delta.vec <- c(rep(0,65),rep(delta[i],length(65:110)))
    ex.65.alt[i] <- life.table(0:110, (1+delta.vec)*lt[which(lt$Year==year & lt$sex==sex),]$mx)$ex[66]
  }
  ex.65.ssa <- ex.65.obs + resid
  delta.keep <- delta[order(abs(ex.65.alt-ex.65.ssa))[1]]
  lt.obs <- life.table(0:110, lt[which(lt$Year==year & lt$sex==sex),]$mx)
  delta.vec <- c(rep(0,65),rep(delta.keep,length(65:110)))
  lt.alt <- life.table(0:110, (1+delta.vec)*lt[which(lt$Year==year & lt$sex==sex),]$mx)
  p <- popl[which(popl$Year==year),sex][66:111]
  count <- p * (lt.alt[66:111,"nmx"] - lt.obs[66:111,"nmx"]) 
  return(sum(count))  
}


delta <- seq(-0.2,0.2,0.0025)
year.tr <- 2000:2010
year.proj <- 2000:2010
sex.list <- c("Female","Male")
ub.mat <- array(NA,dim=c(length(year.tr),length(year.proj),length(sex.list)),
                dimnames=list(year.tr,year.proj,sex.list))
for (i in 1:length(year.tr)) {
  for (j in 1:length(year.proj)) {
    for (k in 1:length(sex.list)) {
      resid <- -1*diff(unlist(ex.ssa[ex.ssa$age==65 &
                                     ex.ssa$TR==year.tr[i] &
                                     ex.ssa$forecast.year==year.proj[j] &
                                     ex.ssa$sex==sex.list[k],c("forecast","hmd_observed")]))
      ub.mat[i,j,k] <- delta.fxn(delta,sex.list[k],year.proj[j],resid,popl)
    }}}
ub <- apply(ub.mat, c(1,2), sum)

save(ub, file="data/unexpect_benif.RData")