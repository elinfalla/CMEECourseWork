#!/usr/bin/env R

rm(list = ls())

##########################################
########### MODEL FITTING ################
##########################################

#import prepared dataset
therm <- read.csv("../Data/PreparedThermRespData.csv", header = T, stringsAsFactors = F)

for (count in 1:max(therm$ID)) {
  
  subset <- therm[therm$ID == count,]

  fit_quad <- lm(OriginalTraitValue ~ poly(ConTemp, 2), data = subset)
  fit_cubic <- lm(OriginalTraitValue ~ poly(ConTemp, 3), data = subset)
  
  
  
  fits <- list(fit_briere, fit_cubic, fit_quad)
  names(fits) <- c("briere", "cubic", "quad")
  aics <- lapply(X = fits, FUN = AIC)
  #print(paste("subset", subset, "BEST AIC:", aics[which.min(aics)])) #cubic
  
  #all_aics[[count]] <- aics
}


#calculate AIC,BIC
fits <- list(fit_briere, fit_cubic, fit_quad)
names(fits) <- c("briere", "cubic", "quad")
aics <- lapply(X = fits, FUN = AIC)
print(aics)
print(paste("BEST AIC:", aics[which.min(aics)])) #cubic