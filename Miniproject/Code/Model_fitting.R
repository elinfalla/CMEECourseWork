#!/usr/bin/env R

#packages
require(minpack.lm)

rm(list = ls())

##########################################
########### MODEL FITTING ################
##########################################

#import prepared dataset
therm <- read.csv("../Data/PreparedThermRespData.csv", header = T, stringsAsFactors = F)

#set number of models being tested
num_models <- 3

#initiailise stats dataframe (for goodness of fit statistics)
statsDF <- data.frame(matrix(NA, nrow = length(unique(therm$ID)) * num_models, ncol = 5))
names(statsDF) <- c("ID", "Model", "AIC", "BIC", "R.squared")

#initialise model fits dataframe (for fit of models - to draw fit line on graph)
temp_points <- seq(min(therm$ConTemp), max(therm$ConTemp), by = 2)
model_fitsDF <- data.frame(ID = NA * length(temp_points) * max(therm$ID),
                           Temperature = rep(temp_points,max(therm$ID)),
                           Quadratic.points = NA * length(temp_points) * max(therm$ID),
                           Cubic.points = NA * length(temp_points) * max(therm$ID),
                           Briere.points = NA * length(temp_points) * max(therm$ID)
                           )

briere <- function(t, t_0, t_m, b_0) {
  return(b_0 * t * (t - t_0) * sqrt(t_m - t))
}


for (count in 1:max(therm$ID)) {
  
  subset <- therm[therm$ID == count,]

  fit_quad <- lm(OriginalTraitValue ~ poly(ConTemp, 2), data = subset)
  fit_cubic <- lm(OriginalTraitValue ~ poly(ConTemp, 3), data = subset)
  
  t_0_start <- min(subset$ConTemp)
  t_m_start <- max(subset$ConTemp)
  b_0_start <- 1e-4 #reasonable starting point based on literature
  
  fit_briere <- nlsLM(OriginalTraitValue ~ briere(t = ConTemp, t_0, t_m, b_0),
                      data = subset,
                      start = list(t_0 = t_0_start,
                                   t_m = t_m_start,
                                   b_0 = b_0_start))
  
  statsDF[count*num_models,] <- c(count, "Quadratic", AIC(fit_quad), BIC(fit_quad), summary(fit_quad)$r.squared)
  statsDF[count*num_models - 1,] <- c(count, "Cubic", AIC(fit_cubic), BIC(fit_cubic), summary(fit_cubic)$r.squared)
  statsDF[count*num_models - 2,] <- c(count, "Briere", AIC(fit_briere), BIC(fit_briere), NA)
  
  print(count)
  
  #TODO - CHANGE TO EXPLORATORY PLOT WAY - ALLOWS DIFFERENT TEMP_POINTS FOR EACH GRAPH
  #ALTHO EXTENSIONS SHOW USEFULNESS OF MATHEMATICAL MODEL???? GUESS NOT AS NO MORE POINTS??
  model_fitsDF[(count*length(temp_points)-(length(temp_points)-1)):(count*length(temp_points)),-2] <- 
    c(rep(count, length(temp_points)), 
      predict.lm(fit_quad, data.frame(ConTemp = temp_points)),
      predict.lm(fit_cubic, data.frame(ConTemp = temp_points)),
      briere(t = temp_points, 
             t_0 = coef(fit_briere)["t_0"],
             t_m = coef(fit_briere)["t_m"],
             b_0 = coef(fit_briere)["b_0"]))

  
}


write.csv(statsDF, "../Data/StatsDF.csv")
write.csv(model_fitsDF, "../Data/Model_fitsDF.csv")