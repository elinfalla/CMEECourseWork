#!/usr/bin/env R

################################################################
################## Wrangling the Pound Hill Dataset ############
################################################################


# delete everything
rm(list=ls(all=TRUE))

############# Load the dataset ###############
# header = false because the raw data don't have real headers
MyData <- as.matrix(read.csv("../data/PoundHillData.csv", header = FALSE, stringsAsFactors = FALSE))

# header = true because we do have metadata headers
MyMetaData <- read.csv("../data/PoundHillMetaData.csv", header = TRUE, sep = ";", stringsAsFactors = FALSE)

############# Inspect the dataset ###############
head(MyData)
dim(MyData) #dimensions
str(MyData) #display structure
#fix(MyData) #opens data in separate window in 'R data editor'
#fix(MyMetaData)

############# Transpose ###############
# To get those species into columns and treatments into rows 
MyData <- t(MyData) #transposes: swaps rows and cols, rows become cols and vice versa
head(MyData)
dim(MyData)

############# Replace species absences with zeros ###############
MyData[MyData == ""] = 0

############# Convert raw matrix to data frame ###############
#Creates temp dataframe without col names (-1 means not row 1)
TempData <- as.data.frame(MyData[-1,],stringsAsFactors = F) #stringsAsFactors = F is important!
colnames(TempData) <- MyData[1,] # assign column names from original data
rownames(TempData) <- NULL
############# Convert from wide to long format  ###############
require(reshape2) # load the reshape2 package

?melt #check out the melt function

#Change data to long format (ie. put 'species' as a col rather than each species having a col)
MyWrangledData <- melt(TempData, id=c("Cultivation", "Block", "Plot", "Quadrat"), variable.name = "Species", value.name = "Count")

#Assign correct data types to each column
MyWrangledData[, "Cultivation"] <- as.factor(MyWrangledData[, "Cultivation"])
MyWrangledData[, "Block"] <- as.factor(MyWrangledData[, "Block"])
MyWrangledData[, "Plot"] <- as.factor(MyWrangledData[, "Plot"])
MyWrangledData[, "Quadrat"] <- as.factor(MyWrangledData[, "Quadrat"])
MyWrangledData[, "Count"] <- as.integer(MyWrangledData[, "Count"])

str(MyWrangledData)
head(MyWrangledData)
dim(MyWrangledData)

############# Exploring the data (extend the script below)  ###############

require(tidyverse)

tibble::as_tibble(MyWrangledData) # tibble is tidyverse's equivalent of a dataframe
dplyr::glimpse(MyWrangledData) # like str (which shows structure) but nicer
#utils::View(MyWrangledData) # same as fix()

dplyr::filter(MyWrangledData, Count>100) #like subset() but nicer
dplyr::slice(MyWrangledData, 10:15) # Look at an arbitrary set of data rows