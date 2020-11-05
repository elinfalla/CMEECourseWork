#!/usr/bin/env R

#### Script demonstrating use of a user-written function with apply() function

# delete everything
rm(list=ls(all=TRUE))

SomeOperation <- function(v) {
  if (sum(v) > 0) {
    return (v * 100)
  }
  return (v)
}

M <- matrix(rnorm(100), 10, 10)
#Apply SomeOperation to each row of the matrix (v=a row)
print(apply(M, 1, SomeOperation))
