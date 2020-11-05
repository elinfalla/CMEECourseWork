#!/usr/bin/env R

#### Script that creates ggplot plot using PredatorPrey data and
#### saves regression results to csv file

#packages
require(ggplot2)
require(dplyr)
require(readr)

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

# create function that does a linear regression, and outputs regression values into a dataframe
create_lm_model <- function(data) {
  
  model <- lm(log10(Predator.mass) ~ log10(Prey.mass), data = data)
  anova.res <- anova(model)
  model.res <- summary(model)

  outputDF <- data.frame(intercept = model.res$coefficients[1],
                         slope = model.res$coefficients[2],
                         r_squared = model.res$r.squared,
                         F_val = anova.res$`F value`[1],
                         P_val = anova.res$`Pr(>F)`[1])
  
  return(outputDF)
}


#initialise dataframe
model_result <- data.frame()

#use piping to group data and perform create_lm_model() on it
model_result <-
  MyDF %>%
  group_by(Type.of.feeding.interaction, Predator.lifestage) %>%
  group_modify(~ create_lm_model(.))

#write model_result to csv
write_csv(model_result, "../Results/PP_Regress_Results.csv")
