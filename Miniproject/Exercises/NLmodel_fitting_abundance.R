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
# taking logarithm is a nonlinear transformation - small numbers close to zero yield dispropotionately large
# deviations, allowing us to see inaccuracy in logistic growth model

#plot to demonstrate this
ggplot(data, aes(x = N, y = LogN)) +
  geom_point(size = 3) +
  theme(aspect.ratio = 1) +
  labs(x = "N", y = "log(N)")


############ OWN EXERCISE (NOT ON PAGE) ###################
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

# poly.points <- pow3Mod(x = timepoints,
#                        a = coef(model_poly)["a"],
#                        b = coef(model_poly)["b"],
#                        c = coef(model_poly)["c"],
#                        d = coef(model_poly)["d"])

poly.points <- predict.lm(model_poly, data.frame(Time = timepoints))

df3 <- data.frame(timepoints, poly.points)
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

############ END OF OWN EXERCISE (NOT ON PAGE) #################

### fit gompertz model, which takes lag phase into account

gompertz_model <- function(t, r_max, N_max, N_0, t_lag) { ## Modified gompertz growth model (Zwietering 1990)
  return(N_0 + (N_max - N_0) * exp(-exp(r_max * exp(1) * ((t_lag - t)/((N_max - N_0) * log(10))) + 1)))
  
}

#define starting values
N_0_start <- min(data$LogN) # lowest population size, note log scale
N_max_start <- max(data$LogN) # highest population size, note log scale
r_max_start <- 0.62 # use our previous estimate from the OLS fitting from above

#calculate t_lag = last timepoint of lagphase
differentials <- diff(diff(data$LogN)) #2nd order differentials = tells you how fast gradient is changing

#find the index of the max value (ie. when population starting to take off)
max_diff <- which.max(differentials)

#use this to get value of time at this index
t_lag_start <- data$Time[max_diff]

# can also be done in one:
# t_lag_start <- data$Time[which.max(diff(diff(data$LogN)))]

# fit the model using these start values
fit_gompertz <- nlsLM(LogN ~ gompertz_model(t = Time, r_max, N_max, N_0, t_lag), data = data,
                      start = list(t_lag=t_lag_start, r_max=r_max_start, N_0 = N_0_start, N_max = N_max_start))
summary(fit_gompertz)

#see how fits of two linear models compare
timepoints <- seq(0, 24, by = 0.1)

#need to get log of logistic points (beacuse gompertz uses logged data)
# log.logistic_points <- log(logistic_points) <- could do this if the timepoints were the same but they're not

logistic_points <- log(logistic_model(t = timepoints, 
                                      r_max = coef(fit_logistic)["r_max"], 
                                      N_max = coef(fit_logistic)["N_max"], 
                                      N_0 = coef(fit_logistic)["N_0"]))

#calculate points for fit curve of gompertz
gompertz_points <- gompertz_model(t = timepoints,
                                  r_max = coef(fit_gompertz)["r_max"],
                                  N_max = coef(fit_gompertz)["N_max"],
                                  N_0 = coef(fit_gompertz)["N_0"],
                                  t_lag = coef(fit_gompertz)["t_lag"])

df1 <- data.frame(timepoints, logistic_points)
df1$model <- "Logistic model"
names(df1) <- c("Time", "LogN", "model")

df2 <- data.frame(timepoints, gompertz_points)
df2$model <- "Gompertz model"
names(df2) <- c("Time", "LogN", "model")

model_frame <- rbind(df1, df2)

p <- ggplot(data, aes(x = Time, y = LogN)) +
  geom_point(size = 3) +
  geom_line(data = model_frame, aes(x = Time, y = LogN, col = model), size = 1) +
  theme_bw() + # make the background white
  theme(aspect.ratio=1)+ # make the plot square 
  labs(x = "Time", y = "log(Abundance)")
p  

#find AIC values (include 2 extras I did)
fits <- list(fit_logistic, fit_gompertz, model_poly, model_quad)
names(fits) <- c("logistic", "gompertz", "poly", "quad")
aics <- lapply(X = fits, FUN = AIC)

fits[which.min(aics)]
aics[which.min(aics)]

#check next best isn't within 2 - TODO

