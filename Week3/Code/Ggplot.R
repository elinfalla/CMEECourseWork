#!/usr/bin/env R

### Exercises demonstrating use of ggplot() function

#packages
require(ggplot2)
#note: reshape2 and ggthemes used later

# delete everything
rm(list=ls(all=TRUE))

MyDF <- as.data.frame(read.csv("../Data/EcolArchives-E089-51-D1.csv"))

#specify data and aesthetics (this would plot an empty graph)
p <- ggplot(MyDF, aes(x = log(Predator.mass),
                      y = log(Prey.mass),
                      colour = Type.of.feeding.interaction))

#Plot as scatterplot by specifying 'geometry'
p + geom_point()

#specify plotting environment
q <- p + 
  geom_point(size = I(2), shape = I(10)) +
  theme_bw() + #white background
  theme(aspect.ratio=1) # make the plot square
q

#remove legend
q + 
  theme(legend.position = "none") + #no legend
  theme(aspect.ratio=1)

#density plot by feeding interaction
p <- ggplot(MyDF, aes(x = log(Prey.mass/Predator.mass), 
                      fill = Type.of.feeding.interaction )) + 
  geom_density()
p

#increase transparency
p <- ggplot(MyDF, aes(x = log(Prey.mass/Predator.mass), 
                      fill = Type.of.feeding.interaction)) + 
  geom_density(alpha=0.5)
p

#multi-faceted plot
p <- ggplot(MyDF, aes(x = log(Prey.mass/Predator.mass), 
                      fill = Type.of.feeding.interaction )) + 
  geom_density() +
  facet_wrap(.~ Type.of.feeding.interaction)
p

#use scales = free to avoid having same xlim for all subplots (also possible to free up just x or y axis)
p <- ggplot(MyDF, aes(x = log(Prey.mass/Predator.mass), 
                      fill = Type.of.feeding.interaction )) + 
  geom_density() +
  facet_wrap(.~ Type.of.feeding.interaction, scales = "free")
p

#change facet to by location
p <- ggplot(MyDF, aes(x = log(Prey.mass/Predator.mass))) +  
  geom_density() + 
  facet_wrap( .~ Location, scales = "free")
p

#same but using points not density (predator + prey as x + y)
p <- ggplot(MyDF, aes(x = log(Prey.mass), y = log(Predator.mass))) +  
  geom_point() + 
  facet_wrap( .~ Location, scales = "free")
p

#can also combine categories (big plot!)
p <- ggplot(MyDF, aes(x = log(Prey.mass), y = log(Predator.mass))) +
  geom_point() +
  facet_wrap(.~ Type.of.feeding.interaction + Location, scales = "free")
p

#can change order of the combination
p <- ggplot(MyDF, aes(x = log(Prey.mass), y = log(Predator.mass))) +
  geom_point() +
  facet_wrap(.~ Location + Type.of.feeding.interaction, scales = "free")
p

###############
# Useful ggplot examples
###############

###### Plotting a matrix ###### 
require(reshape2) #ggplot only accepts dataframes - this package can melt a matrix into a df

#function to generate a matrix
GenerateMatrix <- function(N) {
  M <- matrix(runif(N * N), N, N)
  return(M)
}

M <- GenerateMatrix(10)
Melt <- melt(M) #melts matrix into dataframe

#create tile plot
p <- ggplot(Melt, aes(Var1, Var2, fill= value)) +
  geom_tile() +
  theme(aspect.ratio = 1)
p

#Add a black line dividing the cells
p + geom_tile(colour = "black") + 
  theme(aspect.ratio = 1)

#remove legend
p + theme(legend.position = "none", aspect.ratio = 1)

#remove everything else
p + theme(legend.position = "none", 
          panel.background = element_blank(),
          axis.ticks = element_blank(), 
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          axis.text.x = element_blank(),
          axis.title.x = element_blank(),
          axis.text.y = element_blank(),
          axis.title.y = element_blank())

#explore some colours
p + scale_fill_continuous(low = "yellow", high = "darkgreen")

#purple rather than the default blue shades
p + scale_fill_gradient2()

### scale_fill_gradientn to specify own gradient
#greyscale
p + scale_fill_gradientn(colours = grey.colors(10))

#rainbow
p + scale_fill_gradientn(colours = rainbow(10))

#own combo
p + scale_fill_gradientn(colours = c("red", "white", "blue"))

####### Plotting two dataframes together #########
# According to Girko’s circular law, the eigenvalues of a matrix 𝑀 of size 𝑁×𝑁 are
# approximately contained in a circle in the complex plane with radius 𝑁‾‾√. Let’s draw
# the results of a simulation displaying this result.

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
p

#### Annotating plots using geom text #####

a <- read.table("../Data/Results.txt", header = TRUE)
head(a)

#append a column of zeros called ymin
a$ymin <- rep(0, dim(a)[1]) #dim(a)[1] is equivalent to nrow(a)

#Print first line range
p <- ggplot(a)
p <- p + 
  geom_linerange(data = a, aes(
                     x = x,
                     ymin = ymin,
                     ymax = y1,
                     size = (0.5)),
                 colour = "#E69F00",
                 alpha = 1/2,
                 show.legend = FALSE)

# Print the second linerange
p <- p + 
  geom_linerange(data = a, aes(
                    x = x,
                    ymin = ymin,
                    ymax = y2,
                    size = (0.5)
                  ),
                  colour = "#56B4E9",
                  alpha = 1/2, show.legend = FALSE)

# Print the third linerange:
p <- p +
  geom_linerange(data = a, aes(
                  x = x,
                  ymin = ymin,
                  ymax = y3,
                  size = (0.5)
                ),
                colour = "#D55E00",
                alpha = 1/2, show.legend = FALSE)

# Annotate plot with labels
p <- p +
  geom_text(data = a, 
            aes(x = x, y = -500, label = Label))


# now set the axis labels, remove the legend, and prepare for bw printing
p <- p + 
  scale_x_continuous("My x axis",
                            breaks = seq(3, 5, by = 0.05)) + 
  scale_y_continuous("My y axis") + 
  theme_bw() + 
  theme(legend.position = "none") 
p


######## Mathematical display #########
#Mathematical annotation on axes and in plot area

#Create linear regression data
x <- seq(0, 100, by = 0.1)
y <- -4. + 0.25 * x +
  rnorm(length(x), mean = 0., sd = 2.5)

# and put them in a dataframe
my_data <- data.frame(x = x, y = y)

#perform linear regression
my_lm <- summary(lm(y ~ x, data = my_data))

#plot the data
p <- ggplot(my_data, aes(x = x, y = y,
                         colour = abs(my_lm$residual))) +
  geom_point() +
  scale_colour_gradient(low = "black", high = "red") +
  theme(legend.position = "none") +
  scale_x_continuous(
    expression(alpha^2 * pi / beta * sqrt(Theta)) #x axis name
  )

#add the regression line
p <- p +
  geom_abline(
    intercept = my_lm$coefficients[1],
    slope = my_lm$coefficients[2],
    colour = "red"
  )

#put some maths on the plot
p <- p + geom_text(aes(x = 60, y = 0, #position of text
                       label = "sqrt(alpha) * 2* pi"), 
                   parse = TRUE, size = 6, 
                   colour = "blue")
p


######## ggthemes package ########
# package has additional geoms, themes and scales for ggplot

require("ggthemes")

p <- ggplot(MyDF, aes(x = log(Predator.mass), y = log(Prey.mass),
                      colour = Type.of.feeding.interaction )) +
  geom_point(size=I(2), shape=I(10)) + theme_bw()

p + geom_rangeframe() + # now fine tune the geom to Tufte's range frame
  theme_tufte() # and theme to Tufte's minimal ink theme    
p
