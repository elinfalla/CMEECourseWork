#!/usr/bin/env R

#A boilerplate R script

# delete everything
rm(list=ls(all=TRUE))

MyFunction <- function(Arg1, Arg2) {
  
  #Statements involving Arg1,Arg2:
  print(paste("Argument", as.character(Arg1), "is a", class(Arg1)))
  print(paste("Argument", as.character(Arg2), "is a", class(Arg2)))
  
  return (c(Arg1, Arg2))
}

MyFunction(1,2) #test function
MyFunction("Riki", "Tiki") #another test


