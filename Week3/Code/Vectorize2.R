#!/usr/bin/env R

# delete everything
rm(list=ls(all=TRUE))


# Runs the stochastic Ricker equation with gaussian fluctuations

rm(list=ls())

stochrick<-function(p0=runif(10000,.5,1.5),r=1.2,K=1,sigma=0.2,numyears=10)
{
  #initialize
  N<-matrix(NA,numyears,length(p0)) #empty, with numyears nrows and length(p0) ncolumns
  N[1,]<-p0
  # output <- apply(N, c(1,2), function(i) N[yr,pop] <- N[yr-1,pop] * exp(r * (1 - N[yr - 1,pop] / K) + rnorm(1,0,sigma)))
  
  for (pop in 1:length(p0)){ #loop through the populations

    for (yr in 2:numyears){ #for each pop, loop through the years

      N[yr,pop] <- N[yr-1,pop] * exp(r * (1 - N[yr - 1,pop] / K) + rnorm(1,0,sigma))

    }

  }
  return(N)
  
}



# plot(output[], type = "l")
stochrickvect <- function(p0=runif(10000,.5,1.5),r=1.2,K=1,numyears=10,sigma=0.2) {
  N<-matrix(NA,numyears,length(p0)) #empty, with numyears nrows and length(p0) ncolumns
  N[1,]<-p0
  for (yr in 2:numyears) {
    N[yr,] <- N[yr-1,] * exp(r * (1 - N[yr - 1,] / K) + rnorm(1,0,sigma))
    
  }
  #apply(N, 2, function(pop) apply(N, 1, function(yr) if(yr==1) {N[1,]<-p0} 
  #else if(yr>1) { N[yr,pop] <- N[yr-1,pop] * exp(r * (1 - N[yr - 1,pop] / K) + rnorm(1,0,sigma)
  # pop=1:length(p0)
  # yr=2:numyears
  # result <- apply(N, c(1,2), function(x) if(!is.na(x)) prevx <- x else 
  #   x <- prevx * exp(r * (1 - prevx / K) + rnorm(1,0,sigma)), prevx <- x)
  # 
  
  # for (col in 1:length(p0)) {
  #   lapply(N[,col], function(i))
  # }
  # row = numyears + 1
  # if (row == 1) {
  #   return(result)
  # }
  # lapply(N[row-1,], function(i))
  return(N)
}

# Now write another function called stochrickvect that vectorizes the above 
# to the extent possible, with improved performance: 

print("stoch rick takes:")
print(system.time(res2<-stochrick()))
print("Vectorized Stochastic Ricker takes:")
print(system.time(res2<-stochrickvect()))