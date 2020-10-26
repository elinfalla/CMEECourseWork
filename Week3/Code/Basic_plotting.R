#!/usr/bin/env R

# delete everything
rm(list=ls(all=TRUE))

MyDF <- read.csv("../Data/EcolArchives-E089-51-D1.csv")
dim(MyDF)
str(MyDF)
head(MyDF)

require(tidyverse)
dplyr::glimpse(MyDF)

#Change some columns to factor type
MyDF$Type.of.feeding.interaction <- as.factor(MyDF$Type.of.feeding.interaction)
MyDF$Location <- as.factor(MyDF$Location)
str(MyDF)

######### Scatterplots #########

plot(MyDF$Predator.mass, MyDF$Prey.mass)

#Plot on log scale
plot(log(MyDF$Predator.mass), log(MyDF$Prey.mass))
plot(log10(MyDF$Predator.mass), log10(MyDF$Prey.mass))

#Specify plot characters (pch)
plot(log10(MyDF$Predator.mass), log10(MyDF$Prey.mass), pch=10)

#Add axes labels
plot(log10(MyDF$Predator.mass), log10(MyDF$Prey.mass), pch=20,
     xlab = "Predator Mass (g)", ylab = "Prey mass (g)")


######### Histograms #########

#Basic histogram
hist(MyDF$Predator.mass)

#Plot on log scale with labels
hist(log10(MyDF$Predator.mass), 
     xlab = "log10(Predator mass (g))",
     ylab = "Count")

#Change bar and borer colours
hist(log10(MyDF$Predator.mass), 
     xlab = "log10(Predator mass (g))",
     ylab = "Count",
     col = "lightblue",
     border = "pink")

#Same for prey body masses
hist(log10(MyDF$Prey.mass), 
     xlab = "log10(Prey mass (g))",
     ylab = "Count",
     col = "red",
     border = "black")

#Adjust axes limits and set number of histogram bins (cols)
hist(log10(MyDF$Prey.mass), 
     breaks = 20,
     xlab = "log10(Prey mass (g))",
     ylab = "Count",
     col = "red",
     border = "black",
     xlim = c(min(log10(MyDF$Prey.mass)), max(log10(MyDF$Prey.mass)))
     )

hist(log10(MyDF$Predator.mass), 
     breaks = 20,
     xlab = "log10(Prey mass (g))",
     ylab = "Count",
     col = "blue",
     border = "black",
     xlim = c(min(log10(MyDF$Predator.mass)), max(log10(MyDF$Predator.mass)))
)

#Plot predator and prey masses in subplots
par(mfcol=c(2,1)) # initialise multi-paneled plot
par(mfg = c(1,1)) # specify which subplot to use first
hist(log10(MyDF$Predator.mass),
     xlab = "log10(Predator Mass (g))",
     ylab = "Count",
     col = "lightblue",
     border = "pink",
     main = "Predator"
     )
par(mfg = c(2,1)) #Second subplot
hist(log10(MyDF$Prey.mass),
     xlab = "log10(Prey Mass (g))",
     ylab = "Count",
     col = "lightgreen",
     border = "pink",
     main = "Prey"
     )

#See if predator and prey mass distribuations are similar by overlaying
par(mfcol=c(1,1))
hist(log10(MyDF$Predator.mass),
     xlab="log10(Body Mass (g))", 
     ylab="Count", 
     col = rgb(1, 0, 0, 0.5), #Note fourth value is transparency
     main = "Predator-prey size overlap"
     )
hist(log10(MyDF$Prey.mass),
     col = rgb(0, 0, 1, 0.5),
     add = T
     )
#Create legend
legend("topleft", c("Predators", "Prey"),
       fill = c(rgb(1, 0, 0, 0.5), rgb(0, 0, 1, 0.5))
       )

######### Boxplots #########

boxplot(log10(MyDF$Predator.mass),
        xlab = "Location",
        ylab = "log10(Predator.mass)",
        main = "Predator mass")

boxplot(log10(MyDF$Predator.mass) ~ MyDF$Location, #tilde=categorise by factor 'Location'
        xlab = "Location", ylab = "Predator Mass",
        main = "Predator mass by location")

boxplot(log10(MyDF$Predator.mass) ~ MyDF$Type.of.feeding.interaction,
        xlab = "Type of feeding interaction",
        ylab = "Predator mass",
        main = "Predator mass by type of feeding interaction")


######### Combining plot types #########

par(mfcol=c(1,1))
par(fig=c(0,0.85,0,0.85)) #specify figure size by proportion: x1,x2,y1,y2

plot(log10(MyDF$Predator.mass),log(MyDF$Prey.mass),
     xlab = "Predator Mass (g)", 
     ylab = "Prey Mass (g)")

#Horizontal predator boxplot above scatterplot
par(fig=c(0,0.85,0.5,1), new=TRUE)
boxplot(log10(MyDF$Predator.mass), horizontal=TRUE, axes=FALSE)

#Vertical prey boxplot beside scatterplot
par(fig=c(0.65,1,0,0.85), new=TRUE)
boxplot(log10(MyDF$Prey.mass), axes=FALSE)

#Title for figure
mtext("Fancy predator-prey scatterplot", side=3, outer=TRUE, line=-4) #side=3 means top, line=-4 brings title down closer to plot


######### Saving graphics #########

#Create empty PDF
pdf("../Results/Pred_Prey_Overlay.pdf", 11.7, 8.3) #numbers=page dimensions (inches)

#Plot predator mass (histogram)
hist(log(MyDF$Predator.mass),
     xlab="Body Mass (g)", 
     ylab="Count", 
     col = rgb(1, 0, 0, 0.5), #r, g, b, transparency
     main = "Predator-Prey Size Overlap")

#Plot prey mass (histogram) to same plot

hist(log(MyDF$Prey.mass),
     col = rgb(0, 0, 1, 0.5),
     add = TRUE)

#Add legend
legend('topleft',c('Predators','Prey'),
       fill=c(rgb(1, 0, 0, 0.5), rgb(0, 0, 1, 0.5)))

graphics.off() # can also use dev.off()
     
