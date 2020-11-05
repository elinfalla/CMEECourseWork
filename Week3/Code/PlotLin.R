#!/usr/bin/env R

require(ggplot2)

### Plots linear regression and demonstrates use of mathematical display

rm(list = ls())

#Create linear regression data
x <- seq(0, 100, by = 0.1)
y <- -4. + 0.25 * x +
  rnorm(length(x), mean = 0., sd = 2.5)

# and put them in a dataframe
my_data <- data.frame(x = x, y = y)

#perform linear regression
my_lm <- summary(lm(y ~ x, data = my_data))

#plot the data
p <- ggplot(my_data, aes(x = x, y = y,
                         colour = abs(my_lm$residual))) +
  geom_point() +
  scale_colour_gradient(low = "black", high = "red") +
  theme(legend.position = "none") +
  scale_x_continuous(
    expression(alpha^2 * pi / beta * sqrt(Theta)) #x axis name
  )

#add the regression line
p <- p +
  geom_abline(
    intercept = my_lm$coefficients[1],
    slope = my_lm$coefficients[2],
    colour = "red"
  )

#put some maths on the plot
p <- p + geom_text(aes(x = 60, y = 0, #position of text
                       label = "sqrt(alpha) * 2* pi"), 
                   parse = TRUE, size = 6, 
                   colour = "blue")

pdf("../Results/MyLinReg.pdf")
p
dev.off()