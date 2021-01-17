#!/usr/bin/env R

#packages
require(ggplot2)
require(dplyr)
require(plyr)
require(gridExtra)
require(grid)

rm(list = ls())

#import datasets
therm <- read.csv("../Data/PreparedThermRespData.csv", header = T, stringsAsFactors = F)
statsDF <- read.csv("../Data/StatsDF.csv", header = T, stringsAsFactors = F)
model_fitsDF <- read.csv("../Data/Model_fitsDF.csv", header = T, stringsAsFactors = F)
#no_fit <- read.csv("../Data/No_fit.csv", header = F, stringsAsFactors = F)


# pdf(paste("../Sandbox/fit_graph_S.pdf", sep = ""))
# for (i in 1:max(therm$ID)) {
# #for (i in 1:9) {
#   
#   subset <- therm[therm$ID == i,]
#   print(i)
# 
#   #pdf(paste("../Sandbox/fit_graph", i, ".pdf", sep = ""))
#   grob <- grobTree(textGrob(unique(subset$CurveClassification), x=0.8,  y=0.95, hjust=0,
#                             gp=gpar(col="red", fontsize=13)))
# 
#   print(ggplot(subset, aes(x = ConTemp, y = OriginalTraitValue)) +
#     geom_point(size = 3) +
#     geom_line(data = model_fitsDF[model_fitsDF$ID == i,], aes(x = Temperature, y = Trait.points, col = Model)) +
#     annotation_custom(grob)
#   )
# }
# dev.off()

#function to extract and save a legend from a ggplot
get_legend <- function(myggplot) {
  tmp <- ggplot_gtable(ggplot_build(myggplot))
  leg <- which(sapply(tmp$grobs, function(x) x$name) == "guide-box")
  legend <- tmp$grobs[[leg]]
  
  return(legend)
}


#IDs <- c(118,22,52,7,53,456,99,323)
IDs <- c(118, 22, 52, 99)
titles <- c("a)", "b)", "c)", "d)", "e)", "f)", "g)", "h)")

# create plot with legend so can extract and save it
with_legend_plot <- ggplot(data = therm[therm$ID == IDs[1],], aes(x = ConTemp, y = OriginalTraitValue)) +
  geom_line(data = model_fitsDF[model_fitsDF$ID == IDs[1],], mapping = aes(x = Temperature, y = Trait.points, col = Model)) +
  geom_point(size = 3) +
  theme_bw() +
  theme(legend.position = "bottom", legend.title = element_text(face = "bold"))

model_legend <- get_legend(with_legend_plot)

pdf("../Figures/Shapes_of_curves.pdf", 9,7)

# create all plots with no legends
all_curve_plots <- lapply(1:length(IDs), function(i)
                 ggplot(data = therm[therm$ID == IDs[i],], aes(x = ConTemp, y = OriginalTraitValue)) +
                 geom_line(data = model_fitsDF[model_fitsDF$ID == IDs[i],], mapping = aes(x = Temperature, y = Trait.points, col = Model)) +
                 geom_point(size = 3) +
                 theme_bw() +
                 
                 scale_y_continuous("Rate") + 
                 scale_x_continuous("Temperature (Celcius)") +
                 
                 ggtitle(titles[i]) +
                 theme(legend.position = "none")# +
                 #theme_bw()
                 )

# lay <- rbind(c(1,1,2,2,3,3,4,4),
#              c(1,1,2,2,3,3,4,4),
#              c(5,5,6,6,7,7,8,8),
#              c(5,5,6,6,7,7,8,8),
#              c(9,9,9,9,9,9,9,9))

lay <- rbind(c(1,1,2,2),
            c(3,3,4,4),
            c(5,5,5,5))
            
            
# arrange them with legend at the bottom
gridExtra::grid.arrange(all_curve_plots[[1]], 
                        all_curve_plots[[2]], 
                        all_curve_plots[[3]],
                        all_curve_plots[[4]],
                        #all_curve_plots[[5]],
                        #all_curve_plots[[6]],
                        #all_curve_plots[[7]],
                        #all_curve_plots[[8]],
                        model_legend, 
                        layout_matrix = lay,
                        heights = (c(2.5,2.5,0.3)))

dev.off()


## OPTIMAL MODELS ACCORDING TO EACH SELECTION CRITERIA

## AIC ##
# Best model for each ID according to AIC
AIC_wins <- statsDF %>%
  group_by(ID) %>%
  group_modify(~ .[which.min(.$AIC), "Model"])

# Total wins for each model according to AIC
AIC_result <- 
  AIC_wins %>%
  ungroup() %>%
  dplyr::count(Model)

## AICc ##
# Best model for each ID according to AICc
AICc_wins <-
  statsDF %>%
  group_by(ID) %>%
  group_modify(~ .[which.min(.$AICc), "Model"])

# Total wins for each model according to AICc
AICc_result <- 
  AICc_wins %>%
  ungroup() %>%
  dplyr::count(Model)

## BIC ##
# Best model for each ID according to BIC
BIC_wins <-
  statsDF %>%
  group_by(ID) %>%
  group_modify(~ .[which.min(.$BIC), "Model"]) 

# Total wins for each model according to BIC
BIC_result <-
  BIC_wins %>%
  ungroup() %>%
  dplyr::count(Model)

## BARCHART OF WINS FOR EACH MODEL UNDER EACH SELECTION CRITERIA
all_wins_DF <- data.frame(
  Model = rep(AIC_result$Model, 3),
  Wins = c(AIC_result$n, AICc_result$n, BIC_result$n),
  Method = c(rep("AIC", 5), rep("AICc", 5), rep("BIC", 5)))

all_wins_matrix = matrix(data = all_wins_DF$Wins, 
                         ncol = 5, 
                         nrow = 3, 
                         byrow = T,
                         dimnames = list(c("AIC", "AICc", "AICc"), AICc_result$Model))


# pdf("../Figures/Wins_barplot.pdf")  
par(mfrow=c(1,1))
barplot(all_wins_matrix,
        col = c("green", "blue", "red"), 
        legend = c("AIC", "AICc", "BIC"),
        names.arg = AICc_result$Model,
        beside = T,
        xlab = "Model",
        ylab = "Number of winssss")
# dev.off()


### IS AIC SO DIFFERENT FROM AICC BECAUSE OF SMALL SAMPLE SIZES - YES

# find sample size for each ID
ID_sample_sizes <- 
  therm %>%
  group_by(ID) %>%
  group_map(~ nrow(.))

# add sample sizes to AICc_wins and AIC_wins
AICc_wins$Sample.size <- as.numeric(ID_sample_sizes)
AIC_wins$Sample.size <- as.numeric(ID_sample_sizes)
BIC_wins$Sample.size <- as.numeric(ID_sample_sizes)

# Number of wins at each sample size PER MODEL (for AICc, AIC and BIC respectively)
AICc_SS_per_model <-
  AICc_wins %>%
  group_by(Model) %>%
  dplyr::count(Sample.size)

AIC_SS_per_model <-
  AIC_wins %>%
  group_by(Model) %>%
  dplyr::count(Sample.size)

BIC_SS_per_model <-
  BIC_wins %>%
  group_by(Model) %>%
  dplyr::count(Sample.size)

# new column 'prop' = proportion of total wins at each sample size per model
AICc_SS_per_model$prop <- sapply(1:length(AICc_SS_per_model$Model), function(x) as.numeric(AICc_SS_per_model[x, "n"] / AICc_result[AICc_result$Model == as.character(AICc_SS_per_model[x, "Model"]), "n"]))
AIC_SS_per_model$prop <- sapply(1:length(AIC_SS_per_model$Model), function(x) as.numeric(AIC_SS_per_model[x, "n"] / AIC_result[AIC_result$Model == as.character(AIC_SS_per_model[x, "Model"]), "n"]))
BIC_SS_per_model$prop <- sapply(1:length(BIC_SS_per_model$Model), function(x) as.numeric(BIC_SS_per_model[x, "n"] / BIC_result[BIC_result$Model == as.character(BIC_SS_per_model[x, "Model"]), "n"]))

all_SS_DFs <- list(AICc_SS_per_model[AICc_SS_per_model$Sample.size < 30,],
                   AIC_SS_per_model[AIC_SS_per_model$Sample.size < 30,],
                   BIC_SS_per_model[BIC_SS_per_model$Sample.size < 30,])

selection_methods <- c("AICc", "AIC", "BIC")

## MULTIPLOT: wins against sample size for each model, one plot per model selection criteria

pdf("../Figures/Sample_size_per_model.pdf", 8, 10)
plots <- lapply(1:3, function(x) ggplot(data = all_SS_DFs[[x]], aes(x = Sample.size, y = prop, col = Model)) +
                  geom_point(size = 1) +
                  geom_smooth(se = FALSE) + 
                  theme_bw() +
                  theme(legend.position = "none") +
                  scale_x_continuous("Sample size") +
                  scale_y_continuous("Proportion of wins",
                                     limits = c(0,0.4),
                                     breaks = c(0.0, 0.1, 0.2, 0.3, 0.4)) +
                  ggtitle(paste(titles[x], selection_methods[x])))

lay <- rbind(c(1,1,1),
             c(2,2,2),
             c(3,3,3),
             c(4,4,4))

gridExtra::grid.arrange(plots[[1]],
                        plots[[2]],
                        plots[[3]],
                        model_legend,
                        layout_matrix = lay,
                        heights = c(2.5, 2.5, 2.5, 0.3))

dev.off()




# sample_sizeDF <- data.frame(Sample.size = NA * vector(length = length(therm$ID)),
                            # Model = NA * vector(length = length(therm$ID)))
# start_row <- 1
# for (model in unique(AICc_wins$Model)) {
#   print(model)
#   ID_sample_sizes <- vector()
#   IDs <- as.data.frame(AICc_wins[AICc_wins$Model == model, "ID"])
#   
#   for (ID in 1:nrow(IDs)) {
#     ID_sample_sizes <- c(ID_sample_sizes, Sample.size[[IDs[ID,]]])
#   }
#   end_row <- start_row + length(ID_sample_sizes) - 1
#   
#   sample_sizeDF[start_row:end_row,] <- c(ID_sample_sizes, rep(model, length(ID_sample_sizes)))
#   
#   start_row <- end_row + 1
#     
#     
#     
#   print(ID_sample_sizes)
#   print(paste("MEAN", model, "SAMPLE SIZE:", mean(ID_sample_sizes)))
#   print(paste("MEDIAN", model, "SAMPLE SIZE:", median(ID_sample_sizes)))
#   print("***************")
# }
# 



pdf("../Figures/Sample_size_boxplot.pdf", 11, 6)

sample_size_full <-
  qplot(Model, Sample.size, data = AICc_wins, fill = Model, geom = "boxplot") +
  theme_bw() +
  theme(legend.position = "none", aspect.ratio = 1) +   
  scale_y_continuous("Sample size") +
  ggtitle(titles[1])

sample_size_cropped <-
qplot(Model, Sample.size, data = AICc_wins[AICc_wins$Sample.size < 60, ], fill = Model, geom = "boxplot") +
  theme_bw() +
  theme(legend.position = "none", aspect.ratio = 1) +   
  scale_y_continuous("Sample size") +
  ggtitle(titles[2])

gridExtra::grid.arrange(sample_size_full, sample_size_cropped, ncol = 2)


dev.off()

#### PLOT WINS BY CURVE TYPE ####

AICc_wins$Curve.class <- sapply(AICc_wins$ID, function(x) unique(statsDF[statsDF$ID == x, "Curve.classification"]))
AIC_wins$Curve.class <- sapply(AIC_wins$ID, function(x) unique(statsDF[statsDF$ID == x, "Curve.classification"]))
BIC_wins$Curve.class <- sapply(AIC_wins$ID, function(x) unique(statsDF[statsDF$ID == x, "Curve.classification"]))

AICc_curve_wins <-
  AICc_wins %>%
    group_by(Model) %>%
    dplyr::count(Curve.class)

AIC_curve_wins <- 
  AIC_wins %>%
  group_by(Model) %>%
  dplyr::count(Curve.class)

BIC_curve_wins <- 
  BIC_wins %>%
  group_by(Model) %>%
  dplyr::count(Curve.class)

with_legend_plot <- ggplot(data = BIC_curve_wins, aes(x = Model, y = n, fill = Curve.class)) +
  geom_bar(position = "stack", stat = "identity") +
  theme(legend.position = "bottom",
        legend.title = element_text(face = "bold")) 

curve_legend <- get_legend(with_legend_plot)

curveDFs <- list(AICc_curve_wins, AIC_curve_wins, BIC_curve_wins)

pdf("../Figures/Curve_type_wins.pdf", 8, 10)

curve_plots <- lapply(1:length(curveDFs), function(x) 
  ggplot(data = curveDFs[[x]], aes(x = Model, y = n, fill = Curve.class)) +
    geom_bar(position = "stack", stat = "identity") +
    theme_bw() +
    ggtitle(paste(titles[x], selection_methods[x])) +
    theme(legend.position = "none") +
    scale_y_continuous("Number of wins", 
                       limits = c(0,530),
                       breaks = c(100,200,300,400,500),
                       n.breaks = 5)) 

lay <- rbind(c(1,1,1),
             c(2,2,2),
             c(3,3,3),
             c(4,4,4))

gridExtra::grid.arrange(curve_plots[[1]],
                        curve_plots[[2]],
                        curve_plots[[3]],
                        curve_legend,
                        layout_matrix = lay,
                        heights = c(2.5, 2.5, 2.5, 0.3))
dev.off()


# COMPARISON OF CURVE CLASSIFICATION VERSUS SAMPLE SIZE

# Number of datasets at each sample size per curve class (selection method being AIC is irrelevant, same for all methods)
AIC_SS_per_curve_class <-
  AICc_wins %>%
  group_by(Curve.class) %>%
  dplyr::count(Sample.size)

curve_counts <- AICc_wins %>% ungroup() %>% dplyr::count(Curve.class)

AIC_SS_per_curve_class$Prop <- sapply(1:length(AIC_SS_per_curve_class$Curve.class),
                                      function(x) as.numeric(AIC_SS_per_curve_class[x, "n"] / curve_counts[curve_counts$Curve.class == as.character(AIC_SS_per_curve_class[x, "Curve.class"]), "n"]))

pdf("../Figures/Sample_size_per_curve.pdf")

SS_curve_number <- 
  ggplot(data = AIC_SS_per_curve_class[AIC_SS_per_curve_class$Sample.size < 50,], aes(x = Sample.size, y = n, col = Curve.class)) +
    geom_point(size = 1) +
    geom_smooth(se = FALSE) + 
    theme_bw() +
    theme(legend.position = "none") +
    scale_x_continuous("Sample size") +
    scale_y_continuous("Number of datasets") +
    ggtitle(titles[1])


SS_curve_prop <-
  ggplot(data = AIC_SS_per_curve_class[AIC_SS_per_curve_class$Sample.size < 50,], aes(x = Sample.size, y = Prop, col = Curve.class)) +
    geom_point(size = 1) +
    geom_smooth(se = FALSE) + 
    theme_bw() +
    theme(legend.position = "none") +
    scale_x_continuous("Sample size") +
    scale_y_continuous("Proportion of datasets") +
    ggtitle(titles[2])

lay <- rbind(c(1,1,1),
             c(2,2,2),
             c(3,3,3))

gridExtra::grid.arrange(SS_curve_number, 
                        SS_curve_prop,
                        curve_legend,
                        layout_matrix = lay,
                        heights = c(2.5, 2.5, 0.3))
                        
dev.off()

# relationship between weight and sample size?

### CALCULATE AKAIKE WEIGHTS ###  

# remove infinite values from statsDF
statsDF[sapply(statsDF, is.infinite)] <- NA

#calculate Akaike weights based on AICc
AICc_weights <-
  statsDF %>%
  group_by(ID) %>%
  dplyr::mutate(Best=min(AICc, na.rm = T)) %>%
  dplyr::mutate(Goodness = exp(-0.5 * (AICc - Best))) %>%
  dplyr::mutate(Sum.goodness = sum(Goodness, na.rm = T)) %>%
  dplyr::mutate(AICc.weight = Goodness / Sum.goodness) %>%
  dplyr::mutate(adding = sum(AICc.weight, na.rm = T))

AICc_weights$Sample.size <- sapply(AICc_weights$ID, function(x) ID_sample_sizes[[x]])

# calculate average AICc Akaike weight per model
AICc_weights_average <- 
  AICc_weights %>%
  group_by(Model) %>%
  group_map(~ mean(.$AICc.weight, na.rm = T)) %>%
  setNames(unique(sort(AICc_weights$Model)))

#calculate Akaike weights based on AIC
AIC_weights <-
  statsDF %>%
  group_by(ID) %>%
  dplyr::mutate(Best=min(AIC, na.rm = T)) %>%
  dplyr::mutate(Goodness = exp(-0.5 * (AIC - Best))) %>%
  dplyr::mutate(Sum.goodness = sum(Goodness, na.rm = T)) %>%
  dplyr::mutate(AIC.weight = Goodness / Sum.goodness) %>%
  dplyr::mutate(adding = sum(AIC.weight, na.rm = T))

AIC_weights$Sample.size <- sapply(AIC_weights$ID, function(x) ID_sample_sizes[[x]])

# calculate average AIC Akaike weight per model
AIC_weights_average <- 
  AIC_weights %>%
  group_by(Model) %>%
  group_map(~ mean(.$AIC.weight, na.rm = T)) %>%
  setNames(unique(sort(AIC_weights$Model)))


head(AICc_weights)
AICc_weights_average
head(AIC_weights)
AIC_weights_average


# hist(AICc_weights$AICc.weight)
# hist(AIC_weights$AIC.weight)
# boxplot(AICc.weight~Model, data = AICc_weights[!is.na(AICc_weights$AICc.weight),])
# boxplot(AIC.weight~Model, data = AIC_weights[!is.na(AIC_weights$AIC.weight),])


pdf("../Figures/Weights_boxplot.pdf", 10, 6)

AIC_weights_boxplot <- 
  qplot(Model, AIC.weight, data = AIC_weights[!is.na(AIC_weights$AIC.weight),], geom = "boxplot", fill = Model) +
  theme_bw() +
  theme(legend.position = "none") +
  scale_y_continuous("Akaike weight") +
  ggtitle(paste(titles[1], "AIC"))

AICc_weights_boxplot <- 
  qplot(Model, AICc.weight, data = AICc_weights[!is.na(AICc_weights$AICc.weight),], geom = "boxplot", fill = Model) +
  theme_bw() +
  theme(legend.position = "none") +
  scale_y_continuous("Akaike weight") +
  ggtitle(paste(titles[2], "AICc"))

gridExtra::grid.arrange(AIC_weights_boxplot, AICc_weights_boxplot, ncol = 2)

dev.off()

pdf("../Figures/Weights_boxplot_SS.pdf", 10, 6)

AIC_weights_boxplot_ss <- 
  qplot(Model, AIC.weight, data = AIC_weights[!is.na(AIC_weights$AIC.weight) & AIC_weights$Sample.size > 10,], geom = "boxplot", fill = Model) +
  theme_bw() +
  theme(legend.position = "none") +
  scale_y_continuous("Akaike weight") +
  ggtitle(paste(titles[1], "AIC"))

AICc_weights_boxplot_ss <- 
  qplot(Model, AICc.weight, data = AICc_weights[!is.na(AICc_weights$AICc.weight) & AIC_weights$Sample.size > 10,], geom = "boxplot", fill = Model) +
  theme_bw() +
  theme(legend.position = "none") +
  scale_y_continuous("Akaike weight") +
  ggtitle(paste(titles[2], "AICc"))

gridExtra::grid.arrange(AIC_weights_boxplot_ss, AICc_weights_boxplot_ss, ncol = 2)

dev.off()

#### IS MODEL CHOICE DIFFERENT FOR RESPIRATION VERUS PHOTOSYNTHESIS?

AIC_response.var <- 
  statsDF[!is.na(statsDF$Response.group),] %>%
  group_by(ID, Response.group) %>%
  group_modify(~ .[which.min(.$AIC), "Model"]) %>%
  ungroup() %>%
  dplyr::count(Model, Response.group) %>%
  group_by(Response.group) %>%
  dplyr::mutate(Total = sum(n, na.rm = T)) %>%
  dplyr::mutate(Proportion = n / Total)

AICc_response.var <- 
  statsDF[!is.na(statsDF$Response.group),] %>%
  group_by(ID, Response.group) %>%
  group_modify(~ .[which.min(.$AICc), "Model"]) %>%
  ungroup() %>%
  dplyr::count(Model, Response.group) %>%
  group_by(Response.group) %>%
  dplyr::mutate(Total = sum(n, na.rm = T)) %>%
  dplyr::mutate(Proportion = n / Total) 

BIC_response.var <-
  statsDF[!is.na(statsDF$Response.group),] %>%
  group_by(ID, Response.group) %>%
  group_modify(~ .[which.min(.$BIC), "Model"]) %>%
  ungroup() %>%
  dplyr::count(Model, Response.group) %>%
  group_by(Response.group) %>%
  dplyr::mutate(Total = sum(n, na.rm = T)) %>%
  dplyr::mutate(Proportion = n / Total)


# PLOT WINS FOR EACH MODEL AS A PROPORTION OF PHOTO AND RESP CURVES

all_response_vars <- list(AICc_response.var, AIC_response.var, BIC_response.var)

photo_resp_prop_wins <- lapply(1:length(all_response_vars),
                           function(x) 
                             ggplot(data = all_response_vars[[x]],
                                    aes(x = Response.group, y = Proportion, fill = Model)) +
                             geom_bar(position = "stack", stat = "identity") +
                             theme_bw() +
                             ggtitle(paste(titles[x], selection_methods[x])) +
                             theme(legend.position = "none") +
                             xlab("") +
                             scale_y_continuous("Proportion of wins"))

lay <- rbind(c(1,1,1),
             c(2,2,2),
             c(3,3,3),
             c(4,4,4))

pdf("../Figures/Photo_resp_model_wins.pdf", 8, 10)
gridExtra::grid.arrange(photo_resp_prop_wins[[1]],
                        photo_resp_prop_wins[[2]],
                        photo_resp_prop_wins[[3]],
                        model_legend,
                        layout_matrix = lay,
                        heights = c(2.5, 2.5, 2.5, 0.3))
dev.off()

## PLOT SAMPLE SIZE OF DATASETS FOR RESP VERSUS PHOTO CURVES

AIC_wins$Response.group <- sapply(AIC_wins$ID, function(x) unique(statsDF[statsDF$ID == x, "Response.group"]))
AIC_SS_per_response <-
  AIC_wins %>%
  group_by(Response.group) %>%
  dplyr::count(Sample.size)
AIC_SS_per_response <- AIC_SS_per_response[!is.na(AIC_SS_per_response$Response.group),]


response_counts <- AIC_wins %>% ungroup() %>% dplyr::count(Response.group)
response_counts <- response_counts[!is.na(response_counts$Response.group),]

AIC_SS_per_response$prop <- sapply(1:length(AIC_SS_per_response$Response.group), function(x) as.numeric(AIC_SS_per_response[x, "n"] / response_counts[response_counts$Response.group == as.character(AIC_SS_per_response[x, "Response.group"]), "n"]))

pdf("../Figures/Photo_resp_sample_size.pdf", 10, 5)
#sample_size_per_response_plot <-
  ggplot(data = AIC_SS_per_response[AIC_SS_per_response$Sample.size < 50,], aes(x = Sample.size, y = prop, col = Response.group)) +
  geom_point(size = 1) +
  geom_smooth(se = FALSE) + 
  theme_bw() +
  theme(legend.position = c(0.9,0.85), 
        legend.title = element_blank(),
        legend.key.size = unit(1, "cm"),
        legend.text = element_text(size = 10)) +
  scale_x_continuous("Sample size") +
  scale_y_continuous("Proportion of datasets",
                     limits = c(0,0.3),
                     breaks = c(0.0, 0.1, 0.2, 0.3))
dev.off()
# PLOT CURVE TYPES FOR PHOTO AND RESP

curve_types_per_responseDF <- 
  AIC_wins[!is.na(AIC_wins$Response.group),] %>%
  group_by(Response.group) %>%
  dplyr::count(Curve.class)

pdf("../Figures/Photo_resp_curve_type.pdf", 10, 6)
#curve_type_per_response_plot <-
  ggplot(data = curve_types_per_responseDF, aes(x = Response.group, y = n, fill = Curve.class)) +
    geom_bar(position = "stack", stat = "identity") +
    theme_bw() +
    theme(legend.position = c(0.92,0.85),
          legend.title = element_text(face = "bold"),
          #legend.text = element_text(size = 10),
          axis.text.x = element_text(size = 12)
          ) +
    xlab("") +
    scale_y_continuous("Number of datasets", 
                       limits = c(0,600),
                       breaks = c(100,200,300,400,500,600),
                       n.breaks = 5)
dev.off()
# gridExtra::grid.arrange(sample_size_per_response_plot,
#                         curve_type_per_response_plot,
#                         nrow = 2)
  
  
