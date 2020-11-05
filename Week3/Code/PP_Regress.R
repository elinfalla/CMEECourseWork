#!/usr/bin/env R

#packages
require(ggplot2)
require(dplyr)

#### Script that creates ggplot plot using PredatorPrey data and
#### saves regression results to csv file

MyDF <- as.data.frame(read.csv("../Data/EcolArchives-E089-51-D1.csv"))

pdf("../Results/PP_Regress_Graph.pdf", 8, 11)
print(
qplot(x = Prey.mass, y = Predator.mass, data = MyDF,
            geom = "point",
            shape = I(3),
            log = "xy",
            xlab = "Prey mass in grams",
            ylab = "Predator mass in grams",
            colour = Predator.lifestage,
            facets = Type.of.feeding.interaction ~.
            ) +
  geom_smooth(method = "lm", fullrange = TRUE) +
  theme_bw() + 
  theme(legend.position = "bottom",
        legend.title = element_text(face = "bold"),
        aspect.ratio = 0.5) +
  guides(color = guide_legend(nrow = 1)) + #makes legend one line rather than 2
  scale_fill_discrete(breaks = c("adult", "juvenile", "larva", "larva / juvenile", "postlarva", "postlarva / juvenile"))
)
dev.off()

# reg_data <- ggplot_build(p)$data[[2]]
# subset <- reg_data[reg_data$PANEL == 3 & reg_data$group == 4,]
# subsetDF <-MyDF[MyDF$Type.of.feeding.interaction == "" & MyDF$Predator.lifestage == 4,]
lm <- lm(y~x, data = subset)
# plot(x = subset$x, 
#      y = subset$y)
# abline(lm$coefficients[1], lm$coefficients[2])

#r <- qplot(x = Prey.mass, y = Predator.mass, data = MyDF[MyDF$Type.of.feeding.interaction == "predacious" & MyDF$Predator.lifestage == ,])

# plot(reg_data$x["PANEL" == 1 & "group" == 1], reg_data$y["PANEL" == 1 & "group" == 1])

create_lm_model <- function(data) {
  model <- lm(Predator.mass ~ Prey.mass, data = data)
  anova.res <- anova(model)
  model.res <- summary(model)
  
  intercept <- model.res$coefficients[1]
  slope <- model.res$coefficients[2]
  r_squared <- model.res$r.squared
  F_val <- anova.res$`F value`[1]
  P_val <- anova.res$`Pr(>F)`[1]
  
  return(c(intercept, slope, r_squared, F_val, P_val))
}

model_result <- data.frame()
model_result <-
  MyDF %>%
  group_by(Type.of.feeding.interaction, Predator.lifestage) %>%
  group_modify(.f = create_lm_model(MyDF))

# feeding.type <- data$Type.of.feeding.interaction
# lifestage <- data$Predator.lifestage
# intercept <- model$coefficients[1]
# slope <- model$coefficients[2]
# output <- tapply(reg_data$x, reg_data$group,
#                  FUN = lapply(1:5, function(i) {create_lm_model(i)}
#                               ))
