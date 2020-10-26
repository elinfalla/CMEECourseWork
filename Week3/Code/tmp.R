#!/usr/bin/env R

MyData <- as.matrix(read.csv("../Data/PoundHillData.csv", header=F, stringsAsFactors=F))
class(MyData)

MyMetaData <- read.csv("../Data/PoundHillMetaData.csv", header=T, sep=";", stringsAsFactors=F)
class(MyMetaData)

head(MyData)