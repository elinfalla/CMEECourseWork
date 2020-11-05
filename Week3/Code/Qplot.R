#!/usr/bin/env R

#packages
require(ggplot2)

#### Exercises demonstrating use of qplot() - allows you to use only a single dataset 
#### and a single set of “aesthetics” (x, y, etc.)

# delete everything
rm(list=ls(all=TRUE))


MyDF <- read.csv("../Data/EcolArchives-E089-51-D1.csv")

###### Scatterplots ######

# Basic plot
qplot(Prey.mass, Predator.mass, data = MyDF)

# Log plot
qplot(log(Prey.mass), log(Predator.mass), data = MyDF)

# Colour by type of feeding interaction
qplot(log(Prey.mass), log(Predator.mass), data = MyDF,
      colour = Type.of.feeding.interaction)

#Change aspect ratio
qplot(log(Prey.mass), log(Predator.mass), data = MyDF,
      colour = Type.of.feeding.interaction,
      asp = 1)

#Change shape by type of feeding interaction
qplot(log(Prey.mass), log(Predator.mass), data = MyDF,
      shape = Type.of.feeding.interaction,
      asp = 1)

#Colours in qplot
qplot(log(Prey.mass), log(Predator.mass), 
      data = MyDF, colour = "red") #ggplots version of red
qplot(log(Prey.mass), log(Predator.mass),
      data = MyDF, colour = I("red")) #actual red

#Change size of points
qplot(log(Prey.mass), log(Predator.mass),
      data = MyDF, size = 3)
qplot(log(Prey.mass), log(Predator.mass),  
      data = MyDF, size = I(3)) #no mapping to ggplot

# Need to map with shapes as ggplot doesn't do it, so below (commmented) will give an error
#qplot(log(Prey.mass), log(Predator.mass), data = MyDF, shape = 3)
qplot(log(Prey.mass), log(Predator.mass), data = MyDF, shape= I(3))

####### Setting transparency
qplot(log(Prey.mass), log(Predator.mass), 
      data = MyDF, colour = Type.of.feeding.interaction,
      alpha = I(0.5)) #alpha is transparency of points (can also do without I() but will appear in legend)

##### Adding smoothers and regression lines

#Add smoother
qplot(log(Prey.mass), log(Predator.mass), 
      data = MyDF, geom = c("point", "smooth")) #plots points, then plots smoothed curve over them

#Add linear regression too
qplot(log(Prey.mass), log(Predator.mass), 
      data = MyDF, geom = c("point", "smooth")) +
    geom_smooth(method = "lm") #not in original qplot, added with '+'

#Add smoother and linear reg line for each type of interaction
qplot(log(Prey.mass), log(Predator.mass), 
      data = MyDF, geom = c("point", "smooth"),
      colour = Type.of.feeding.interaction) +
  geom_smooth(method = "lm")

#Extend each lm to the full range rather than range of subsets
qplot(log(Prey.mass), log(Predator.mass), data = MyDF, geom = c("point", "smooth"),
      colour = Type.of.feeding.interaction) +
  geom_smooth(method = "lm", fullrange = TRUE)

#How ratio of pred/prey mass changes according to interaction
qplot(Type.of.feeding.interaction, log(Prey.mass/Predator.mass), data = MyDF)

#jitter points to get a better feel of the spread
qplot(Type.of.feeding.interaction, log(Prey.mass/Predator.mass), 
      data = MyDF, geom = "jitter") # plots points jittered x-wards


######## Boxplots #########
qplot(Type.of.feeding.interaction, log(Prey.mass/Predator.mass),
      data = MyDF, geom = "boxplot")

####### Histograms and density plots #########

### Histogram
qplot(log(Prey.mass/Predator.mass), data = MyDF, geom =  "histogram")

# Colour histogram according to interaction type
qplot(log(Prey.mass/Predator.mass), data = MyDF, geom =  "histogram", 
      fill = Type.of.feeding.interaction)

#Define bin widths (in units of x axis)
qplot(log(Prey.mass/Predator.mass), data = MyDF, geom =  "histogram", 
      fill = Type.of.feeding.interaction, binwidth = 1)

### Density plots

qplot(log(Prey.mass/Predator.mass), data = MyDF, geom =  "density", 
      fill = Type.of.feeding.interaction)

# Increase transparency
qplot(log(Prey.mass/Predator.mass), data = MyDF, geom =  "density", 
      fill = Type.of.feeding.interaction, 
      alpha = I(0.5))

#Using colour instead of fill changes to lines only
qplot(log(Prey.mass/Predator.mass), data = MyDF, geom =  "density", 
      colour = Type.of.feeding.interaction)

##Note: geom = "bar" = barplot, geom = "line" = points joined by line


############ Multi-faceted plots ############
#An alternative way of displaying data beloinging to different classes

#By row (note ~. after) - ie. plots are in rows
qplot(log(Prey.mass/Predator.mass), facets = Type.of.feeding.interaction ~. ,
      data = MyDF, geom = "density")

#By column (note .~ before)
qplot(log(Prey.mass/Predator.mass), facets = .~ Type.of.feeding.interaction,
      data = MyDF, geom = "density")

############ Logarithmic axes ############
#Better way to plot log data
qplot(Prey.mass, Predator.mass, data = MyDF, log="xy")

########## Plot annotations ########## 
#Axes + main titles
qplot(Prey.mass, Predator.mass, data = MyDF, log="xy",
      main = "Relation between predator and prey mass",
      xlab = "log(Prey mass) (g)", 
      ylab = "log(Predator mass) (g)")

## Add  + theme_bw() to make suitable for black and white printing
qplot(Prey.mass, Predator.mass, data = MyDF, log="xy",
      main = "Relation between predator and prey mass", 
      xlab = "Prey mass (g)", 
      ylab = "Predator mass (g)") + 
  theme_bw() #makes black and white


##### Saving plots as pdf #####
pdf("../Results/MyFirst-ggplot2-Figure.pdf")
print(qplot(Prey.mass, Predator.mass, data = MyDF, log="xy",
            main = "Relation between predator and prey mass", 
            xlab = "log(Prey mass) (g)", 
            ylab = "log(Predator mass) (g)") + theme_bw())
dev.off() #same as graphics.off()

##### The geom argument - examples #####
qplot(Predator.lifestage, data = MyDF, geom = "bar")
qplot(Predator.lifestage, log(Prey.mass), data = MyDF, geom = "boxplot")
qplot(Predator.lifestage, log(Prey.mass), data = MyDF, geom = "violin")
qplot(log(Predator.mass), data = MyDF, geom = "density")
qplot(log(Predator.mass), data = MyDF, geom = "histogram")
qplot(log(Predator.mass), log(Prey.mass), data = MyDF, geom = "point")
qplot(log(Predator.mass), log(Prey.mass), data = MyDF, geom = "smooth")
qplot(log(Predator.mass), log(Prey.mass), data = MyDF, geom = "smooth", method = "lm")

