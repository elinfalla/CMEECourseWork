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
  #print(paste("Tree height is:", height))
  
  return(height)
}

#Read in trees dataset
trees <- read.csv("../Data/trees.csv")

#Use vectorisation to create list of heights
height <- TreeHeight(trees$Angle.degrees, trees$Distance.m)

# Assign heights to new column in trees database
trees["Tree.Height.m"] <- height

#Write output to CSV file
write.csv(trees, "../Results/TreeHts.csv", row.names = FALSE)


### FUNCTIONS DEMONSTRATING DIFFERENT WAYS TO IMPLEMENT, AND SPEED TEST OF EACH ###
# use_loop <- function(trees, treesOutput) {
#   for (i in (1:nrow(trees))) {
#     height <- TreeHeight(trees[i, "Angle.degrees"], trees[i, "Distance.m"])
#     treesOutput[i, "Tree.Height.m"] <- height
#   }
#   return(treesOutput)
# }
# 
# use_lapply <- function(trees,treesOutput) {
#   height <- lapply(1:nrow(trees), function(i) TreeHeight(trees$Angle.degrees, trees$Distance.m))
#   treesOutput["Tree.Height.m"] <- height
#   #print(treesOutput)
#   return(treesOutput)
# }
# 
# use_vector <- function(trees, treesOutput) {
#   height <- TreeHeight(trees$Angle.degrees, trees$Distance.m)
# treesOutput["Tree.Height.m"] <- height
# #print(treesOutput)
# return(treesOutput)
# }
# 
# 
# print("LOOP RUN TIME:")
# print(system.time(use_loop(trees,treesOutput)))
# 
# print("LAPPLY RUN TIME:")
# print(system.time(use_lapply(trees,treesOutput)))
# 
# print("VECTOR RUN TIME:")
# print(system.time(use_vector(trees,treesOutput)))









