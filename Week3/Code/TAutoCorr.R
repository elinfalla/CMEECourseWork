#!/usr/bin/env R

#### Test hypothesis that temperatures in successive years are correlated by 
#### calculating the correlation coefficient of random permutations of the 
#### dataset and comparing to the actual dataset to give a p-value


# delete everything
rm(list=ls(all=TRUE))

# load temperatures dataset (as "ats")
load("../Data/KeyWestAnnualMeanTemperature.RData")

cor_permutation <- function(ats) {
  # generates a random permutation of the dataset
  # calculates correlation coeff for pair-wise temperatures
  
  # assign ats with shuffled rows to new df: uses sample(replace=F) which randomly selects each element once
  permuteDF <- ats[sample(nrow(ats), replace=F),]
  
  # correlate the shuffled ats datasets without the first and last element - equivalent to pairing each yr with yr-1
  result <- cor(permuteDF$Temp[-nrow(ats)], permuteDF$Temp[-1])
  
  return(result)
}

#set a seed so results are reproducible
set.seed(75)

# assign number of permutations
num_runs <- 10000

# initialise empty vector with num_runs length
permutations <- rep(NA, num_runs)

# for loop that calculates corr for num_run permutations and saves each to vector
for (run in 1:num_runs) {
  permutations[run] <- cor_permutation(ats)
}

# calculate p-value: all permutations larger than cor(ats) (ie. in correct order) divided by all permutations
p_value <- sum(permutations > cor(ats$Temp[-nrow(ats)], ats$Temp[-1])) / length(permutations)

print("*************")
print(paste("P-VALUE:", p_value))
print("*************")

# plot Years vs Temp
pdf("../Results/ats_TempVSyear.pdf")

plot(ats$Year, ats$Temp, 
     xlab = "Year",
     ylab = "Temperature (Celcius)",
     pch = 16,
     ylim = c(23.5, 26.5))

dev.off()

# plot T vs T-1
pdf("../Results/ats_YearVSyear+1.pdf")

plot(ats$Temp[-nrow(ats)], ats$Temp[-1],
     xlab = "Temperature in year n (Celcius)",
     ylab = "Temperature in year n + 1 (Celcius)",
     pch = 16)

##### not including abline using lm as the variables are not independent
# model <- lm(ats$Temp[-nrow(ats)] ~ ats$Temp[-1])
# abline(model$coefficients[1], model$coefficients[2], 
#        col = "red")

dev.off()

# draw histogram to show significance of p-value
pdf("../Results/ats_Corr_hist.pdf")

hist(x = permutations, 
     breaks = 40, 
     main = "",
     xlim = c(-0.4, 0.4),
     xlab = "Correlation coefficient",
     col = "lightgreen")
abline(v = cor(ats$Temp[-nrow(ats)], ats$Temp[-1]), 
       col = "red",
       lwd = 2)
abline(v = quantile(permutations, probs = 0.95), 
       col = "blue",
       lwd = "2")
text(0.205, 790, "p = 0.05", col = "blue")

dev.off()