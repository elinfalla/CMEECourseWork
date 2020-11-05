#!/usr/bin/env R

#packages
require(ggplot2)
require(minpack.lm)

rm(list=ls())

# Generate data - a bacterial population over time
t <- seq(0, 22, 2)
N <- c(32500, 33000, 38000, 105000, 445000, 1430000, 3020000, 4720000, 5670000, 5870000, 5930000, 5940000)

set.seed(1234) #set seed to ensure get the same random sequence

data <- data.frame(t, N + rnorm(length(time), sd = 0.1)) #add some random error

names(data) <- c("Time", "N")

head(data)

#plot the data
ggplot(data, aes(x = Time, y = N)) +
  geom_point(size = 3) +
  labs(x = "Time (Hours)", y = "Population size (cells)")

######## Basic linear approach - applying linear model to exponential phase only
data$LogN <- log(data$N) #add column of log of population at each time point

#visualise
ggplot(data, aes(x = t, y = LogN)) +
  geom_point(size = 3) +
  labs(x = "Time (Hours)", y = "log(cell number)")

#based on the graph, logged data looks fairly linear between 4 and 10
r <- (data[data$Time == 10,]$LogN - data[data$Time == 4,]$LogN) / (10 - 4)
r # = 0.605

### Better version - fit lm through exponential part
lm_growth <- lm(LogN ~ Time, data = data[data$Time > 2 & data$Time < 12,])
summary(lm_growth)
r <- coef(lm_growth)[[2]]
r # = 0.616

#visualise lm_growth
plot(x = t, y = data$LogN)
abline(coef(lm_growth)[[1]], coef(lm_growth)[[2]])


########## Fitting non-linear models for growth trajectories
logistic_model <- function(t, r_max, N_max, N_0) { #the classic logistical equation
  return(N_0 * N_max * exp(r_max * t)/(N_max + N_0 * (exp(r_max * t) - 1)))
}

#define starting paramenters
N_0_start <- min(data$N) # lowest population size
N_max_start <- max(data$N) # lowest population size
r_max_start <- 0.62 # use our linear estimate from before

fit_logistic <- nlsLM(N ~ logistic_model(t = Time, r_max, N_max, N_0), data,
                      start = list(r_max=r_max_start, N_0 = N_0_start, N_max = N_max_start))
summary(fit_logistic)

#plot the fit

##first create dataframe that will be used to draw the model fit line
timepoints <- seq(0, 22, 0.1)

logistic_points <- logistic_model(t = timepoints, 
                                  r_max = coef(fit_logistic)["r_max"],
                                  N_max = coef(fit_logistic)["N_max"],
                                  N_0 = coef(fit_logistic)["N_0"])
df1 <- data.frame(timepoints, logistic_points)
df1$model <- "Logistic equation"
names(df1) <- c("Time", "N", "model")

ggplot(data, aes(x = Time, y = N)) +
  geom_point(size = 3) +
  geom_line(data = df1, #here we use the dataframe we just created
            aes(x = Time, y = N, col = model),
            size = 1) +
  theme(aspect.ratio = 1) + #make the plot square
  labs(x = "Time", y = "Cell number")

r <- coef(fit_logistic)[["r_max"]]
r # = 0.638


## try same plot on log transformed axis (like for original linear examples)
ggplot(data, aes(x = Time, y = LogN)) +
  geom_point(size = 3) +
  geom_line(data = df1,
            aes(x = Time, y = log(N), col = model),
            size = 1) +
  theme(aspect.ratio = 1) +
  labs(x = "Time", y = "log(Cell number)")
# doesn't fit the lag phase of the model as the logistic model 
# assumes population is growing from the start

#taking log exposes deviation from the data - when the values are very small, the fit might be 
#visually fine, but that's just becuase the numbers are so small that you can't tell it's deviating

#once done, fit a linear model to the curve = try quadratic or cubic

powMod <- function(x, a, b) {
  return(a * x^b)
}

model_quad <- nlsLM(N ~ powMod(x = Time, a, b), data = data,
                    start = c(a = 2, b = 2))
summary(model_quad)

timepoints <- timepoints <- seq(0, 22, 0.1)

quadratic.points <- powMod(x = timepoints,
                    a = coef(model_quad)["a"],
                    b = coef(model_quad)["b"])
df2 <- data.frame(timepoints, quadratic.points)
df2$model <- "Quadratic equation"
names(df2) <- c("Time", "N", "model")

ggplot(data, aes(x = Time, y = N)) +
  geom_point(size = 3) +
  geom_line(data = df1, #here we use the dataframe we just created
            aes(x = Time, y = N, col = model),
            size = 1) +
  geom_line(data = df2,
            aes(x = Time, y = N, col = model),
            size = 1) +
  theme(aspect.ratio = 1) + #make the plot square
  labs(x = "Time", y = "Cell number")



model_poly <- lm(N ~ poly(Time, 3), data = data)

summary(model_poly)

timepoints <- seq(0, 22, 0.1)

poly.points <- pow3Mod(x = timepoints,
                       a = coef(model_poly)["a"],
                       b = coef(model_poly)["b"],
                       c = coef(model_poly)["c"],
                       d = coef(model_poly)["d"])

df3 <- data.frame(timepoints, poly)
df3$model <- "Polynomial equation"
names(df3) <- c("Time", "N", "model")

ggplot(data, aes(x = Time, y = N)) +
  geom_point(size = 3) +
  geom_line(data = df1, #here we use the dataframe we just created
            aes(x = Time, y = N, col = model),
            size = 1) +
  geom_line(data = df2,
            aes(x = Time, y = N, col = model),
            size = 1) +
  geom_line(data = df3,
            aes(x = Time, y = N, col = model),
            size = 1) +
  theme(aspect.ratio = 1) + #make the plot square
  labs(x = "Time", y = "Cell number")
