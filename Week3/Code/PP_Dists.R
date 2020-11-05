#!/usr/bin/env R

### Script that plots density subplots for predator mass, prey mass and mass ratio by 
### feeding interaction type and outputs their means and medians to a csv

rm(list=ls())

#read in dataframe
MyDF <- read.csv("../Data/EcolArchives-E089-51-D1.csv")

#define the types of feeding interaction and colour for each
types_feed_interac <- levels(MyDF$Type.of.feeding.interaction)
cols <- c("Red", "Orange", "Green", "Blue", "Purple")

### Initialise output dataframe (to write means and medians to csv)
outputDF <- data.frame(Type.of.feeding.interaction = factor(length(types_feed_interac)),
                       Prey.mean = numeric(length(types_feed_interac)),
                       Predator.mean = numeric(length(types_feed_interac)),
                       Size.ratio.mean = numeric(length(types_feed_interac)),
                       Prey.median = numeric(length(types_feed_interac)),
                       Predator.median = numeric(length(types_feed_interac)),
                       Size.ratio.median = numeric(length(types_feed_interac)))
outputDF$Type.of.feeding.interaction <- types_feed_interac

##### Predator mass by feeding type #####

pdf("../Results/Pred_Subplots.pdf", 11.7, 8.3)

par(mfrow=c(2,3))
par(mar=c(4,4,4,4))
par(oma=c(2,2,4,2))

for (run in 1:length(types_feed_interac)) {
  
  #calculate log predator mass for each feeding interaction type
  log.pred.mass <- log(MyDF$Predator.mass[MyDF$Type.of.feeding.interaction == types_feed_interac[run]])
  
  #plot density graph for each
  plot(density(log.pred.mass),
       main = types_feed_interac[run],
       xlab = "log(Predator mass) (g)",
       col = cols[run])
  
  #output mean and median to outputDF
  outputDF[run, "Predator.mean"] <- mean(log.pred.mass)
  outputDF[run, "Predator.median"] <- median(log.pred.mass)
}

mtext(text = "Predator mass by feeding interaction", 
      side = 3, #top side
      outer = TRUE,
      cex = 2)  #in outer margin

graphics.off()


##### Prey mass by feeding type #####

pdf("../Results/Prey_Subplots.pdf", 11.7, 8.3)

par(mfrow=c(2,3))
par(mar=c(4,4,4,4))
par(oma=c(2,2,4,2))


for (run in 1:length(types_feed_interac)) {
  
  #calculate log prey mass for each feeding interaction type
  log.prey.mass <- log(MyDF$Prey.mass[MyDF$Type.of.feeding.interaction == types_feed_interac[run]])
  
  #plot density graph for each
  plot(density(log.prey.mass),
       main = types_feed_interac[run],
       xlab = "log(Prey mass) (g)",
       col = cols[run])
  
  #output mean and median to outputDF
  outputDF[run, "Prey.mean"] <- mean(log.prey.mass)
  outputDF[run, "Prey.median"] <- median(log.prey.mass)
}

mtext(text = "Prey mass by feeding interaction", 
      side = 3, #top side
      outer = TRUE,
      cex = 2)  #in outer margin

graphics.off()


##### Prey predator mass ratio by feeding type #####

pdf("../Results/SizeRatio_Subplots.pdf", 11.7, 8.3)

par(mfrow=c(2,3))
par(mar=c(4,4,4,4))
par(oma=c(2,2,4,2))

#calculate size ratios
MyDF$Size.ratios <- MyDF$Prey.mass / MyDF$Predator.mass

for (run in 1:length(types_feed_interac)) {
  
  #calculate log size ratio for each feeding interaction type
  log.size.ratio <- log(MyDF$Size.ratios[MyDF$Type.of.feeding.interaction == types_feed_interac[run]])
  
  #plot density graph for each
  plot(density(log.size.ratio),
       main = types_feed_interac[run],
       xlab = " log(Prey/predator mass ratio) (g)",
       col = cols[run])
  
  #output mean and median to outputDF
  outputDF[run, "Size.ratio.mean"] <- mean(log.size.ratio)
  outputDF[run, "Size.ratio.median"] <- median(log.size.ratio)
}

mtext(text = "Prey/predator mass ratio by feeding interaction",
      side = 3, #top side
      outer = TRUE,
      cex = 2)  #in outer margin

graphics.off()

#write outputDF (containing means and medians) to csv file
write.csv(outputDF, "../Results/PP_Results.csv", row.names = FALSE)
