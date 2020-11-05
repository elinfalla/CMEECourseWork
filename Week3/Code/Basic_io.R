#!/usr/bin/env R

#### A simple script to illustrate R input-output.

# delete everything
rm(list=ls(all=TRUE))

MyData <- read.csv("../data/trees.csv", header=T) #import with headers

write.csv(MyData, "../Results/MyData.csv") #write it out as new file

write.table(MyData[1,], file = "../Results/MyData.csv", append=T) #append to it

write.csv(MyData, "../Results/MyData.csv", row.names=T) #write row names

write.table(MyData, "../Results/MyData.csv", col.names=F) #ignore col names
