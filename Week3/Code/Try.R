#!/usr/bin/env R

# delete everything
rm(list=ls(all=TRUE))

doit <- function(x) {
  
  temp_x <- sample(x, replace = TRUE) #by default number of samples = number of x
  #replace = true means you don't remove the number from x after it's chosen for the sample, 
  #so the same number can be chosen twice (this is how you will get duplicates in your sample)
  if (length(unique(temp_x)) > 30) { #only take mean if sample was sufficient (ie. not too many repeats)
    print(paste("Mean of this sample was:", as.character(mean(temp_x))))
  }
  else {
    stop("Couldn't calculate mean: too few unique values!")
  }
}

popn <- rnorm(50)
#very unlikely that these numbers generated will be the same, but when you sample from them 
#in the doit function, the same one could be chosen twice
hist(popn)

result <- lapply(1:15, function(i) try(doit(popn), FALSE)) # silent=F ie. don't suppress error messages
