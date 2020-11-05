rm(list=ls())
graphics.off()
par(mfrow=c(1,1))
#### Model fitting using Non-linear least squares #####
require(minpack.lm)

powMod <- function(x,a,b) {
  return(a * x^b)
}

MyData <- read.csv("./Data/GenomeSize.csv")
head(MyData)

Data2Fit <- subset(MyData, Suborder == "Anisoptera")
Data2Fit <- Data2Fit[!is.na(Data2Fit$TotalLength),] #remove NAs

plot(Data2Fit$TotalLength, Data2Fit$BodyWeight)

library("ggplot2")
ggplot(Data2Fit, aes(x = TotalLength, y = BodyWeight)) +
  geom_point(size = (3), color = "red") +
  theme_bw() +
  labs(y = "Body mass (mg)", x = "Wing length (mm)")

#fit model to the data using NLLS
#powMod is function defined earlier that converts to power module
PowFit <- nlsLM(BodyWeight ~ powMod(TotalLength, a, b),
                data = Data2Fit,
                start = list(a = 0.1, b = 0.1)) #starting values for parameters
summary(PowFit)

#generate vector of body lengths for visualisation
Lengths <- seq(min(Data2Fit$TotalLength),
               max(Data2Fit$TotalLength),
               len = 200)

#extract coeffs
coef(PowFit)["a"]
coef(PowFit)["b"]

#put actual values of coeffs through formula with Lengths vector giving TotalLength vals
Predic2PlotPow <- powMod(Lengths, coef(PowFit)["a"], coef(PowFit)["b"])

#now plot the data
plot(Data2Fit$TotalLength, Data2Fit$BodyWeight)
#predic2plotpow allows us to plot the model line
lines(Lengths, Predic2PlotPow,
      col = 'blue',
      lwd = 2.5)

#confidence intervals on estimated params
confint(PowFit) #does not include a 0 = statistically significant


######## Comparing models ############
# compare fit to fit using quadratic curve


QuaFit <- lm(BodyWeight ~ poly(TotalLength, 2),
             data = Data2Fit) #poly computes polynomials, 2 = degree (ie x^2)

#use predict.lm to get predicted line of model
Predic2PlotQua <- predict.lm(QuaFit, data.frame(TotalLength = Lengths))

#now plot two different models together
plot(Data2Fit$TotalLength, Data2Fit$BodyWeight)
lines(Lengths, Predic2PlotPow,
      col = "blue",
      lwd = 2.5)
lines(Lengths, Predic2PlotQua,
      col = "red",
      lwd = 2.5)


### formal model comparison

#manually calculate R^2 values
RSS_Pow <- sum(residuals(PowFit)^2)  # Residual sum of squares
TSS_Pow <- sum((Data2Fit$BodyWeight - mean(Data2Fit$BodyWeight))^2)  # Total sum of squares
RSq_Pow <- 1 - (RSS_Pow/TSS_Pow)  # R-squared value

RSS_Qua <- sum(residuals(QuaFit)^2)  # Residual sum of squares
TSS_Qua <- sum((Data2Fit$BodyWeight - mean(Data2Fit$BodyWeight))^2)  # Total sum of squares
RSq_Qua <- 1 - (RSS_Qua/TSS_Qua)  # R-squared value

RSq_Pow 
RSq_Qua
#not very useful, both 0.9 - R^2 can't be used for model fit

#instead use AIC
#manually calculate AIC
n <- nrow(Data2Fit) #set sample size
pPow <- length(coef(PowFit)) # get number of parameters in power law model
pQua <- length(coef(QuaFit)) # get number of parameters in quadratic model

AIC_Pow <- n + 2 + n * log((2 * pi) / n) +  n * log(RSS_Pow) + 2 * pPow
AIC_Qua <- n + 2 + n * log((2 * pi) / n) + n * log(RSS_Qua) + 2 * pQua
AIC_Pow - AIC_Qua

#automatically calculate AIC
AIC(PowFit) - AIC(QuaFit) # = -2.15
#PowFit (ie. power law model) is better here, is 2.15 lower than other one

