#!/usr/bin/env R

#packages
require(dplyr)

rm(list = ls())

#########################################
########### DATA PREPARATION ############
#########################################


therm <- read.csv("../Data/ThermRespData.csv", header = T, stringsAsFactors = F)


##### SHIFT DATASETS WITH NEGATIVE VALUES #####

# define function to add minimum value to all values in a column if minimum value is > 0
rm_negatives <- function(data, col) {
  if (min(data[, col]) < 0) {
    data[, col] <- data[, col] - min(data[, col]) #as its a negative, need to take away as two negatives = positive
  }
  return(data)
}

#apply rm_negatives function to each dataset (ie. each ID)
newDF <-
  therm %>%
  group_by(ID) %>%
  group_modify(~ rm_negatives(.x, "OriginalTraitValue"))

write.csv(newDF, "../Data/PreparedThermRespData.csv")