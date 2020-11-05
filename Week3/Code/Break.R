#!/usr/bin/env R

#### Script that demonstrates use of break in while loop

# delete everything
rm(list=ls(all=TRUE))

i <- 0 #Initialize i
while(i < Inf) {
  if (i == 10) {
    break 
  } # Break out of the while loop! 
  else { 
    cat("i equals " , i , " \n")
    i <- i + 1 # Update i
  }
}