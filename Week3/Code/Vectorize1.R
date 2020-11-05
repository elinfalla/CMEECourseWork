#!/usr/bin/env R

### Script demonstrating speed of using vectorisation when manipulating matrices

# delete everything
rm(list=ls(all=TRUE))


M <- matrix(runif(1000000),1000,1000)

SumAllElements <- function(M) {
  Dimensions <- dim(M)
  Tot <- 0
  for (i in 1:Dimensions[1]) {
    for (j in 1:Dimensions[2]) {
      Tot <- Tot + M[i,j]
    }
  }
  return(Tot)
}

print("Using loops, the time taken is:")
print(system.time(SumAllElements(M)))

print("Using built-in vectorised function, the time taken is:")
print(system.time(sum(M)))