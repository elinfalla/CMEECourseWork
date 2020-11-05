#!/usr/bin/env R

### Demonstrates printing in loops and with if statements

# delete everything
rm(list=ls(all=TRUE))

#evaluates whether a is TRUE or FALSE
a <- TRUE
if (a == TRUE) {
  print ("a is true")
  } else {
  print("a is false")
  }

#prints if random number is less than or equal to 0.5
z <- runif(1) ## Generate a uniformly distributed random number
if (z <= 0.5) {print ("Less than a half")}

#for loop that squares a sequence of numbers and prints result
for (i in seq(10)) {
  j <- i * i
  print(paste(i, " squared is", j ))
}

#Prints a list of species
for(species in c('Heliodoxa rubinoides', 
                 'Boissonneaua jardini', 
                 'Sula nebouxii')) {
  print(paste('The species is', species))
}

#Prints out pre-existing vector
v1 <- c("a","bc","def")
for (i in v1) {
  print(i)
}

#While loop to print squares of numbers 1-10
i <- 0
while (i < 10) {
  i <- i+1
  print(i^2)
}

