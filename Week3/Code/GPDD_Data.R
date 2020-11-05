#!/usr/bin/env R

### Script that maps out all the locations from GPDD dataset onto a world map

#packages
require(maps)

#remove everything
rm(list=ls())

#load dataset
load("../Data/GPDDFiltered.RData")

#draw world map
map(database = "world")

#plot lat and long of each observation on the map
points(x = gpdd$long, y = gpdd$lat, 
       col = 'blue', 
       cex = 1, 
       pch = 16)


##### Biases:
## Nearly all recorded species are from the northern hemisphere and far from the equator (at a similar latitude), 
## so likely a bias of temperate species. Also, results will be biased towards Europe and North America
## specifically, as the majority of observations come from these continents.
