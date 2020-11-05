#!/usr/bin/env R

### Stochastic implementation of the Ricker model and a vectorised version

# delete everything
rm(list=ls(all=TRUE))


# Runs the stochastic Ricker equation with gaussian fluctuations

stochrick<-function(p0=runif(10000,.5,1.5),r=1.2,K=1,sigma=0.2,numyears=10) #sigma = scale of fluctuation to impose
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


# Now write another function called stochrickvect that vectorizes the above 
# to the extent possible, with improved performance:

stochrickvect <- function(p0=runif(10000,.5,1.5),r=1.2,K=1,numyears=10,sigma=0.2) {
  N<-matrix(NA,numyears,length(p0)) #empty, with numyears nrows and length(p0) ncolumns
  
  #Assign first row to random p0 values (random starting populations)
  N[1,]<-p0
  
  #iterate over the rows starting from the second and compute the ricker model
  for (yr in 2:numyears) {
    
    #note: rnorm creates a vector of random variables of length p0 and applies one to each value in the row
    N[yr,] <- N[yr-1,] * exp(r * (1 - N[yr - 1,] / K) + rnorm(length(p0),0,sigma)) 
  }
  return(N)
}

 

print("stoch rick takes:")
print(system.time(res2<-stochrick()))

print("Vectorized Stochastic Ricker takes:")
print(system.time(res2<-stochrickvect()))