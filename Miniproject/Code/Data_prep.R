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


###### CLASSIFY CURVE TYPES FOR EACH ID #######

newDF$CurveClassification <- rep("NA", length(newDF$ID)) # NA as string so char type
newDF$ConTemp2<- therm$ConTemp^2

# initialise progress bar
progress_bar <- txtProgressBar(min = 0, max = 1, style = 3)

for (ID in 1:length(unique(newDF$ID))) {

  # subset data to one ID
  ID_subset <- newDF[newDF$ID == ID,]
  
  # fit quadratic curve to data (note: not using poly func)
  fit_quad <- lm(OriginalTraitValue ~ ConTemp + ConTemp2, data = ID_subset)
  
  # calculate critical point (minimum/maximum) using formula x = -b/2a
  crit_point <- -coef(fit_quad)[["ConTemp"]] / (2*coef(fit_quad)[["ConTemp2"]])
  
  min_temp <- min(ID_subset$ConTemp)
  max_temp <- max(ID_subset$ConTemp)
  
  # IF BAD FIT
  if (summary(fit_quad)["r.squared"] < 0.5) {
    newDF[newDF$ID == ID, "CurveClassification"] <- "non-typical"
  }
  # IF CURVE IS CONCAVE
  else if (coef(fit_quad)[["ConTemp2"]] < 0) {
    
    if (crit_point > min_temp & crit_point < max_temp) {
      newDF[newDF$ID == ID, "CurveClassification"] <- "unimodal"
    }
    else if (crit_point > max_temp) {
      newDF[newDF$ID == ID, "CurveClassification"] <- "rising"
    }
    else if (crit_point < min_temp) {
      newDF[newDF$ID == ID, "CurveClassification"] <- "falling"
    }
  }
  # IF CURVE IS CONVEX
  else if (coef(fit_quad)[["ConTemp2"]] > 0) {
    if (crit_point > max_temp) {
      newDF[newDF$ID == ID, "CurveClassification"] <- "falling"
    }
    else if (crit_point < min_temp) {
      newDF[newDF$ID == ID, "CurveClassification"] <- "rising"
    }
    else {
      newDF[newDF$ID == ID, "CurveClassification"] <- "non-typical"
    }
  }
  else {
    newDF[newDF$ID == ID, "CurveClassification"] <- "non-typical"
  }
  
  # increment progress bar to keep track of progress
  fraction_done <- ID / length(unique(newDF$ID))
  setTxtProgressBar(progress_bar, fraction_done)
  
}

# close progress bar
close(progress_bar)

# write prepared data to csv
write.csv(newDF, "../Data/PreparedThermRespData.csv")
