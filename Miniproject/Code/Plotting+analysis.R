#!/usr/bin/env R

#packages
require(ggplot2)
require(dplyr)
require(plyr)

rm(list = ls())

#import datasets
therm <- read.csv("../Data/PreparedThermRespData.csv", header = T, stringsAsFactors = F)
statsDF <- read.csv("../Data/StatsDF.csv", header = T, stringsAsFactors = F)
model_fitsDF <- read.csv("../Data/Model_fitsDF.csv", header = T, stringsAsFactors = F)
i <-45
#for (i in 1:max(therm$ID)) {
  subset <- therm[therm$ID == i,]
  
  pdf(paste("../Sandbox/fit_graph", i, ".pdf", sep = ""))
  print(ggplot(subset, aes(x = ConTemp, y = OriginalTraitValue)) + 
    geom_point(size = 3) +
    geom_line(data = model_fitsDF[model_fitsDF$ID == i,], aes(x = Temperature, y = Cubic.points, col = "red")) +
    geom_line(data = model_fitsDF[model_fitsDF$ID == i,], aes(x = Temperature, y = Quadratic.points, col = "blue")) +
    geom_line(data = model_fitsDF[model_fitsDF$ID == i,], aes(x = Temperature, y = Briere.points, col = "green"))  
  )
  dev.off()
 

#}
  
## TO DO : LOOK INTO AKAIKE WEIGHTS
AIC_result <- 
  statsDF %>%
  group_by(ID) %>%
  group_modify(~ .[which.min(.$AIC), "Model"]) %>%
  ungroup() %>%
  count(Model)

BIC_result <-
  statsDF %>%
  group_by(ID) %>%
  group_modify(~ .[which.min(.$BIC), "Model"]) %>%
  ungroup() %>%
  count(Model)
