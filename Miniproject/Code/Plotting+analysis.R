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
#no_fit <- read.csv("../Data/No_fit.csv", header = F, stringsAsFactors = F)

cols <- c("red", "blue", "green", "darkblue", "pink")

pdf(paste("../Sandbox/fit_graph.pdf", sep = ""))
#for (i in 1:max(therm$ID)) {
for (i in 1:9) {
  subset <- therm[therm$ID == i,]
  print(i)

  # if ID is equal to any ID value in no_fit, then skip to next iteration
  # if (any(unique(subset$ID) == no_fit)) {
  #   next
  # }
  #pdf(paste("../Sandbox/fit_graph", i, ".pdf", sep = ""))

  print(ggplot(subset, aes(x = ConTemp, y = OriginalTraitValue)) +
    geom_point(size = 3) +
    geom_line(data = model_fitsDF[model_fitsDF$ID == i,], aes(x = Temperature, y = Trait.points, col = Model))
  )


}
dev.off() 
## TO DO : LOOK INTO AKAIKE WEIGHTS
AIC_result <- 
  statsDF %>%
  group_by(ID) %>%
  # subset(ID != "NA") %>%
  group_modify(~ .[which.min(.$AIC), "Model"]) %>%
  ungroup() %>%
  dplyr::count(Model)

BIC_result <-
  statsDF %>%
  group_by(ID) %>%
  group_modify(~ .[which.min(.$BIC), "Model"]) %>%
  ungroup() %>%
  dplyr::count(Model)

AIC_result
BIC_result

# Model         n
# <chr>     <int>
# 1 Briere       78
# 2 Briere2     150
# 3 Cubic       442
# 4 Quadratic   233
# > BIC_result

# Model         n
# <chr>     <int>
# 1 Briere       84
# 2 Briere2     145
# 3 Cubic       443
# 4 Quadratic   231

AICc <- statsDF[,"AIC"] 
## use akaike.weights func