#!/usr/bin/env R

################################################################
## Wrangling the Pound Hill Dataset using Tidyverse
################################################################

require(tidyr)
require(dplyr)

rm(list = ls())

# delete everything
rm(list=ls(all=TRUE))

############# Load the dataset ###############
# header = false because the raw data don't have real headers

MyData <- as_tibble(read.csv("../data/PoundHillData.csv", header = FALSE, stringsAsFactors = FALSE))

# header = true because we do have metadata headers
MyMetaData <- read.csv("../data/PoundHillMetaData.csv", header = TRUE, sep = ";", stringsAsFactors = FALSE)

############# Inspect the dataset ###############
glimpse(MyData)

############# Transpose ###############
# To get those species into columns and treatments into rows 

MyData <-
  MyData %>%
    rownames_to_column %>% 
    gather(var, value, -rowname) %>% 
    spread(rowname, value) 

############# Replace species absences with zeros ###############

MyData <-
  mutate_all(MyData, list(~replace(., . == "", "0")))

############# Convert raw matrix to data frame ###############
#Creates temp dataframe without col names (-1 means not row 1)

TempData <- MyData[-1,-1] #stringsAsFactors = F is important!
colnames(TempData) <- MyData[1,-1] # assign column names from original data
rownames(TempData) <- NULL

############# Convert from wide to long format  ###############

#Change data to long format (ie. put 'species' as a col rather than each species having a col)
MyWrangledData <-
  TempData %>%
    pivot_longer(cols = !Cultivation &
                   !Block &
                   !Plot &
                   !Quadrat, 
                 names_to = "Species", 
                 values_to = "Count")
 
#Assign correct data types to each column
MyWrangledData$Cultivation <- MyWrangledData$Cultivation %>% as.factor
MyWrangledData$Block <- MyWrangledData$Block %>% as.factor
MyWrangledData$Plot <- MyWrangledData$Plot %>% as.factor
MyWrangledData$Quadrat <- MyWrangledData$Quadrat %>% as.factor
MyWrangledData$Count <- MyWrangledData$Count %>% as.integer