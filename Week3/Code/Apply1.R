#!/usr/bin/env R

#### Script demonstrating the use of the apply() function

# delete everything
rm(list=ls(all=TRUE))

## Build a random matrix
M <- matrix(rnorm(100), 10, 10)

#Take the mean of each row
RowMeans <- apply(M, 1, mean)
print(RowMeans)

#Take the variance of each row
RowVars <- apply(M, 1, var)
print(RowVars)

#Same by column
ColMeans <- apply(M, 2, mean)
print(ColMeans)
