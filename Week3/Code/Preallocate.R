#!/usr/bin/env R

# delete everything
rm(list=ls(all=TRUE))

NoPreallocFun <- function(x) {
  a <- vector() #empty vector
  for (i in 1:x) {
    a <- c(a, i)
    print(a)
    print(object.size(a))
  }
}

PreallocFun <- function(x) {
  a <- rep(NA, x) #preallocated vector, replicates NA x times into vector a
  for (i in 1:x) {
    a[i] <- i
    print(a)
    print(object.size(a))
  }
}

system.time(NoPreallocFun(10))
system.time(PreallocFun(10))

