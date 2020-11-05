#!/usr/bin/env R

### Script that shows a graphical representation of Girko's circular law

#packages
require(ggplot2)

#remove everything
rm(list=ls())

#First build function that will calculate and return ellipse (predicted boundary of eigenvalues)
build_ellipse <- function(hradius, vradius) {
  npoints = 250
  a <- seq(0, 2*pi, length = npoints + 1)
  x <- hradius * cos(a)
  y <- vradius * sin(a)  
  return(data.frame(x = x, y = y))
}

N <- 250 #Assign size of matrix
M <- matrix(rnorm(N * N), N, N) # Build the matrix
eigvals <- eigen(M)$values #Find eigenvalues

#Build dataframe, splitting eigvals into real and imaginary numbers
eigDF <- data.frame("Real" = Re(eigvals), "Imaginary" = Im(eigvals))

#radius of circle = sqrt(N)
my_radius <- sqrt(N)

#Build ellipse dataframe
ellDF <- build_ellipse(my_radius, my_radius)

#rename columns
names(ellDF) <- c("Real", "Imaginary")

## plotting ##

pdf("../Results/Girko.pdf")

#plot eigvals
p <- ggplot(eigDF, aes(x = Real, y = Imaginary))

#add geom and remove legend
p <- p +
  geom_point(shape = I(3)) + 
  theme(legend.position = "none")

#add vertical and horizontal line
p <- p + geom_hline(aes(yintercept = 0)) #horizontal line
p <- p + geom_vline(aes(xintercept = 0)) #vertical line

#now add ellipse (boundaries of eigvals)
p <- p + geom_polygon(data = ellDF,
                      aes(x = Real, y = Imaginary, 
                          alpha = 1/20, fill = "red"))
print(p)

dev.off()
