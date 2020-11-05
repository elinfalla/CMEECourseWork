#!/usr/bin/env R

#### Test hypothesis that temperatures in successive years are correlated by 
#### calculating the correlation coefficient of random permutations of the 
#### dataset and comparing to the actual dataset to give a p-value


# delete everything
rm(list=ls(all=TRUE))

# load temperatures dataset (as "ats")
load("../Data/KeyWestAnnualMeanTemperature.RData")

# plot Years vs Temp
plot(ats$Year, ats$Temp, 
     xlab = "Year",
     ylab = "Temperature",
     pch = 4,
     ylim = c(23.5, 26.5))

cor_permutation <- function(ats) {
  # generates a random permutation of the dataset
  # calculates correlation coeff for pair-wise temperatures
  
  # assign ats with shuffled rows to new df: uses sample(replace=F) which randomly selects each element once
  permuteDF <- ats[sample(nrow(ats), replace=F),]
  
  # correlate the shuffled ats datasets without the first and last element - equivalent to pairing each yr with yr-1
  result <- cor(permuteDF$Temp[-nrow(ats)], permuteDF$Temp[-1])
  
  return(result)
}


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

# draw histogram to show significance of p-value
par(mfrow=c(1,1))
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
