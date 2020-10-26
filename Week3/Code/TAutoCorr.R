#!/usr/bin/env R

# delete everything
#rm(list=ls(all=TRUE))

# load temperatures dataset (as "ats")
load("../Data/KeyWestAnnualMeanTemperature.RData")

# plot Years vs Temp
plot(ats$Year, ats$Temp)


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

#calculate p-value: all permutations larger than cor(ats) (ie. in correct order) divided by all permutations
p_value <- sum(permutations > cor(ats$Temp[-nrow(ats)], ats$Temp[-1])) / length(permutations)
#if (p_value == 0) {
  # print(paste(permutations[permutations > cor(ats$Temp[-nrow(ats)], ats$Temp[-1])]))
  # print(paste("cor(ats):", cor(ats$Temp[-nrow(ats)], ats$Temp[-1])))
  # print(paste("sum(permutations > cor(ats):", sum(permutations > cor(ats$Temp[-nrow(ats)], ats$Temp[-1]))))
  # print(paste("len(permutations):", length(permutations)))
  # print(format(round(p_value, 5), nsmall = 5))
#}
print("*************")
print(paste("P-VALUE:", p_value))
print("*************")

hist(#y=seq(0.9,1,length.out = length(permutations)),
     x = permutations)
abline(v = cor(ats$Temp[-nrow(ats)], ats$Temp[-1]), col = "red")
