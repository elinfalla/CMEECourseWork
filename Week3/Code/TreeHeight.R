#!/usr/bin/env R

# delete everything
rm(list=ls(all=TRUE))

# This function calculates heights of trees given distance of each tree 
# from its base and angle to its top, using  the trigonometric formula 
#
# height = distance * tan(radians)
#
# ARGUMENTS
# degrees:   The angle of elevation of tree
# distance:  The distance from base of tree (e.g., meters)
#
# OUTPUT
# The heights of the tree, same units as "distance"

TreeHeight <- function(degrees, distance) {
  radians <- degrees * pi / 180 #turns degrees into radians
  height <- distance * tan(radians) #calculates height of tree
  print(paste("Tree height is:", height))
  
  return(height)
}

trees <- read.csv("../Data/trees.csv")
treesOutput <- trees
for (i in (1:nrow(trees))) {
  height <- TreeHeight(trees[i, "Angle.degrees"], trees[i, "Distance.m"])
  treesOutput[i, "Tree.Height.m"] <- height
}

write.csv(treesOutput, "../Results/TreeHts.csv")
