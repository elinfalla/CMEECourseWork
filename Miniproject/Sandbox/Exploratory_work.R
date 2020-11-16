#!/usr/bin/env R

#packages
require(ggplot2)
require(minpack.lm)

rm(list = ls())

#import dataset
therm <- read.csv("../Data/ThermRespData.csv", header = T, stringsAsFactors = F)
head(therm)
colnames(therm)

unique(therm$OriginalTraitUnit) #units of response variable
unique(therm$ConTempUnit) #units of independent variable
unique(therm$ID) #units of independent variable (ie. analysis will be by ID)


briere <- function(t, t_0, t_m, b_0) {
  return(b_0 * t * (t - t_0) * sqrt(t_m - t))
}

all_aics <- vector(mode = "list", length = length(unique(therm$ID)))
best <- vector(length = length(unique(therm$ID)))
datasets <- subset(therm, therm$ID == 112 | therm$ID == 60 | therm$ID == 5)
for (count in c(5, 60, 112)) {
  subset <- therm[datasets$ID == count,]
  #subset <- datasets[count]
  fit_quad <- lm(OriginalTraitValue ~ poly(ConTemp, 2), data = subset)
  fit_cubic <- lm(OriginalTraitValue ~ poly(ConTemp, 3), data = subset)
  

  
  t_0_start <- min(subset$ConTemp)
  t_m_start <- max(subset$ConTemp)
  b_0_start <- 100
  
  fit_briere <- nlsLM(OriginalTraitValue ~ briere(t = ConTemp, t_0, t_m, b_0),
                      data = subset,
                      start = list(t_0 = t_0_start,
                                   t_m = t_m_start,
                                   b_0 = b_0_start))
  
  fits <- list(fit_briere, fit_cubic, fit_quad)
  names(fits) <- c("briere", "cubic", "quad")
  aics <- lapply(X = fits, FUN = AIC)
  print(paste("subset", subset, "BEST AIC:", aics[which.min(aics)])) #cubic
  
  #all_aics[[count]] <- aics
}

subset <- therm[therm$ID == 456,] #try 111 again, seems to break but also fit?
nrow(subset)
ggplot(subset, aes(x = ConTemp, y = OriginalTraitValue, col = as.factor(ID))) +
  geom_point() +
  facet_wrap(.~ ID)

## quadratic and cubic models
fit_quad <- lm(OriginalTraitValue ~ poly(ConTemp, 2), data = subset)
fit_cubic <- lm(OriginalTraitValue ~ poly(ConTemp, 3), data = subset)
AIC(fit_quad) # -9.53
AIC(fit_cubic) # -14.64 = better fit

#### briere model

briere <- function(t, t_0, t_m, b_0) {
  return(b_0 * t * (t - t_0) * sqrt(t_m - t))
}

t_0_start <- min(subset$ConTemp)
t_m_start <- max(subset$ConTemp)
b_0_start <- 1e-4

fit_briere <- nlsLM(OriginalTraitValue ~ briere(t = ConTemp, t_0, t_m, b_0),
                    data = subset,
                    start = list(t_0 = t_0_start,
                                 t_m = t_m_start,
                                 b_0 = b_0_start))

temp_points <- seq(min(subset$ConTemp), max(subset$ConTemp))

briere_points <- briere(t = temp_points, 
                        t_0 = coef(fit_briere)["t_0"],
                        t_m = coef(fit_briere)["t_m"],
                        b_0 = coef(fit_briere)["b_0"])
briereDF <- data.frame(temp_points, briere_points)
briereDF$model <- "Briere"
names(briereDF) <- c("Temp", "TraitVal", "model")

quad_points <- predict.lm(fit_quad, data.frame(ConTemp = temp_points))
quadDF <- data.frame(temp_points, quad_points)
quadDF$model <- "Quad"
names(quadDF) <- c("Temp", "TraitVal", "model")

cubic_points <- predict.lm(fit_cubic, data.frame(ConTemp = temp_points))
cubicDF <- data.frame(temp_points, cubic_points)
cubicDF$model <- "Cubic"
names(cubicDF) <- c("Temp", "TraitVal", "model")

models_to_plot <- rbind(briereDF, quadDF, cubicDF)                          
ggplot(subset, aes(x = ConTemp, y = OriginalTraitValue)) + 
  geom_point(size = 3) +
  geom_line(data = briereDF, aes(x = Temp, y = TraitVal, col = model))

#calculate AIC,BIC
fits <- list(fit_briere, fit_cubic, fit_quad)
names(fits) <- c("briere", "cubic", "quad")
aics <- lapply(X = fits, FUN = AIC)
print(aics)
print(paste("BEST AIC:", aics[which.min(aics)])) #cubic
