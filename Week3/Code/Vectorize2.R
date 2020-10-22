#!/usr/bin/env R

# delete everything
rm(list=ls(all=TRUE))


# Runs the stochastic Ricker equation with gaussian fluctuations

rm(list=ls())

stochrick<-function(p0=runif(10,.5,1.5),r=1.2,K=1,sigma=0.2,numyears=10)
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
  print(N)
  return(N)
  
}

output <- stochrick()
# plot(output[], type = "l")
#stochrickvect <- function()

# Now write another function called stochrickvect that vectorizes the above 
# to the extent possible, with improved performance: 

# print("Vectorized Stochastic Ricker takes:")
# print(system.time(res2<-stochrickvect()))