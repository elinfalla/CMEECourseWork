#!/usr/bin/env R

# packages
require(minpack.lm)

rm(list = ls())

##########################################
########### MODEL FITTING ################
##########################################

#import prepared dataset
therm <- read.csv("../Data/PreparedThermRespData.csv", header = T, stringsAsFactors = F)

#initiailise stats dataframe (for goodness of fit statistics)
num_models <- 5 
statsDF <- data.frame(matrix(NA, nrow = max(therm$ID) * num_models, ncol = 8))
names(statsDF) <- c("ID", "Model", "AIC", "AICc", "BIC", "Response.var", "Response.group", "Curve.classification")

#initialise model fits dataframe (for fit of models - to draw fit line on graph)
temp_points_out <- 50
rows_per_subset <- temp_points_out * num_models
model_fitsDF <- data.frame(ID = NA * max(therm$ID) * rows_per_subset,
                           Temperature = NA * max(therm$ID) * rows_per_subset,
                           Trait.points = NA * max(therm$ID) * rows_per_subset,
                           Model = NA * max(therm$ID) * rows_per_subset
                           )

# number of parameters of each model
num_param_quad <- 3
num_param_cubic <- 4
num_param_briere1 <- 3
num_param_briere2 <- 4
num_param_yan_hunt <- 4

### AICc function ###
AICc <- function(vals, p, n) {  # p = number of free parameters, n = sample size
  RSS <- sum(residuals(vals)^2)
  return(n + 2 + n * log((2 * pi) / n) + n * log(RSS) + (2 * p * (n / (n - p - 1))))
}


###### BRIERE 1 MODEL FUNCTIONS ###### 

# briere1 model
briere1 <- function(t, t_0, t_m, b_0) {
  
  return(b_0 * t * (t - t_0) * (abs(t_m - t)^(1/2)) * as.numeric(t<t_m) * as.numeric(t>t_0))
        
}

# briere1 try function: tries to fit model using given start values. returns AIC and AICc if successful, else returns NA
briere1_try_func <- function(subset, t_0_start, t_m_start, b_0_start) {
  out <- tryCatch(
    expr = {
      nlsLM(OriginalTraitValue ~ briere1(t = ConTemp, t_0, t_m, b_0),
                          data = subset,
                          start = list(t_0 = t_0_start,
                                       t_m = t_m_start,
                                       b_0 = b_0_start),
                          control = list(maxiter = 500))
    },
      error = function(cond) {
        return(NA)
    }
  )
  if (all(!is.na(out))) {
    AICc <- AICc(out, num_param_briere1, nrow(subset))
    return(c(AIC(out), AICc))
  }
  else {
    return(out)
  }
}

# returns the best starting values from an inputted range of values using briere1_try_func above. if no starting values yield a fit, return NA
get_briere1_start_vals <- function(subset, t_0_start, t_m_start, b_0_start, n_tests) {
  
  # apply try function to range of parameter values
  out <- lapply(1:n_tests, function(x) briere1_try_func(subset, t_0_start[x], t_m_start[x], b_0_start[x]))
  
  # if no fits, return NA
  if (all(is.na(out))) {
    return(NA)
  }
  
  # get AIC and AICc value returned (or NA value if no fit) for each start values sample
  AIC_vals <- lapply(out, function(x) if (all(!is.na(x))) x[1] else x)
  AICc_vals <- lapply(out, function(x) if (all(!is.na(x))) x[2] else x)
  
  # find index of lowest AIC and AICc
  lowest_AIC <- which.min(AIC_vals)
  lowest_AICc <- which.min(AICc_vals)

  # use AICc to define start vals (as better than AIC for small sample sizes), and return them
  final_t_0_start <- t_0_start[lowest_AICc]
  final_t_m_start <- t_m_start[lowest_AICc]
  final_b_0_start <- b_0_start[lowest_AICc]
  
  return(c(out[lowest_AICc], 
           final_t_0_start, 
           final_t_m_start, 
           final_b_0_start))
  
}

###### BRIERE 2 MODEL FUNCTIONS ###### 

# briere model with extra parameter
briere2 <- function(t, t_0, t_m, b_0, m) {
  
  return(b_0 * t * (t - t_0) * (abs(t_m - t)^(1/m)) * as.numeric(t<t_m) * as.numeric(t>t_0))
}

# briere2 try function: tries to fit model using given start values. returns AIC and AICc if successful, else returns NA
briere2_try_func <- function(subset, t_0_start, t_m_start, b_0_start, m_start) {
  out <- tryCatch(
    expr = {
      nlsLM(OriginalTraitValue ~ briere2(t = ConTemp, t_0, t_m, b_0, m),
            data = subset,
            start = list(t_0 = t_0_start,
                         t_m = t_m_start,
                         b_0 = b_0_start,
                         m = m_start),
            control = list(maxiter = 500))
    },
    error = function(cond) {
      return(NA)
    }
  )
  if (all(!is.na(out))) {
    AICc <- AICc(out, num_param_briere2, nrow(subset))
    return(c(AIC(out), AICc))  
    }
  
  else {
    return(out)
  }
}

# returns the best starting values from an inputted range of values using briere2_try_func above. if no starting values yield a fit, return NA
get_briere2_start_vals <- function(subset, t_0_start, t_m_start, b_0_start, m_start, n_tests) {
  
  out <- lapply(1:n_tests, function(x) briere2_try_func(subset, t_0_start[x], t_m_start[x], b_0_start[x], m_start[x]))

  if (all(is.na(out))) {
    return(NA)
  }
  
  AIC_vals <- lapply(out, function(x) if (all(!is.na(x))) x[1] else x)
  AICc_vals <- lapply(out, function(x) if (all(!is.na(x))) x[2] else x)
  
  lowest_AIC <- which.min(AIC_vals)
  lowest_AICc <- which.min(AICc_vals)
  
  final_t_0_start <- t_0_start[lowest_AICc]
  final_t_m_start <- t_m_start[lowest_AICc]
  final_b_0_start <- b_0_start[lowest_AICc]
  final_m_start <- m_start[lowest_AICc]
  
  return(c(out[lowest_AICc], 
           final_t_0_start, 
           final_t_m_start, 
           final_b_0_start,
           final_m_start))
  
}

#### YAN AND HUNT MODEL ####

# yan and hunt model
yan_hunt <- function(t, r_max, t_min, t_max, t_opt) {
  
  return(r_max * ((t_max - t)/(t_max - t_opt)) * (((t - t_min)/(t_opt - t_min))^((t_opt - t_min)/(t_max - t_opt))))
}

# yan_hunt try function: tries to fit model using given start values. returns AIC if successful, else returns NA
yan_hunt_try_func <- function(subset, r_max_start, t_min_start, t_max_start, t_opt_start) {
  out <- tryCatch(
    expr = {
      nlsLM(OriginalTraitValue ~ yan_hunt(t = ConTemp, r_max, t_min, t_max, t_opt),
            data = subset,
            start = list(r_max = r_max_start,
                         t_min = t_min_start,
                         t_max = t_max_start,
                         t_opt = t_opt_start),
            control = list(maxiter = 500))
    },
    error = function(cond) {
      return(NA)
    }
  )
  if (all(!is.na(out))) {
    AICc <- AICc(out, num_param_yan_hunt, nrow(subset))
    return(c(AIC(out), AICc))
    }
  else {
    return(out)
  }
}

# returns the best starting values from an inputted range of values using yan_hunt_try_func above. if no starting values yield a fit, return NA
get_yan_hunt_start_vals <- function(subset, r_max_start, t_min_start, t_max_start, t_opt_start, n_tests) {
  
  out <- lapply(1:n_tests, function(x) yan_hunt_try_func(subset, r_max_start[x], t_min_start[x], t_max_start[x], t_opt_start[x]))

  if (all(is.na(out))) {
    return(NA)
  }
  
  AIC_vals <- lapply(out, function(x) if (all(!is.na(x))) x[1] else x)
  AICc_vals <- lapply(out, function(x) if (all(!is.na(x))) x[2] else x)
  
  lowest_AIC <- which.min(AIC_vals)
  lowest_AICc <- which.min(AICc_vals)
  
  final_r_max_start <- r_max_start[lowest_AICc]
  final_t_min_start <- t_min_start[lowest_AICc]
  final_t_max_start <- t_max_start[lowest_AICc]
  final_t_opt_start <- t_opt_start[lowest_AICc]
  
  return(c(out[lowest_AICc], 
           final_r_max_start, 
           final_t_min_start, 
           final_t_max_start,
           final_t_opt_start))
  
}


### MODEL FITTING ###

# set number of times to run start vals
n_tests <- 100

# initialise progress bar
progress_bar <- txtProgressBar(min = 0, max = 1, style = 3)

# for loop to loop through all IDs and fit all models
for (count in 1:max(therm$ID)) {

  
  ### --- SET SUBSET OF DATA AND RANGE OF TEMP POINTS --- ###
  subset <- therm[therm$ID == count,]
  
  #create temperature points vector for creating model fit lines
  temp_points <- seq(min(subset$ConTemp), max(subset$ConTemp), length.out = temp_points_out)
  
  
  ### --- FIT QUADRATIC MODEL --- ###
  fit_quad <- lm(OriginalTraitValue ~ poly(ConTemp, 2), data = subset)
  quad_points <- predict.lm(fit_quad, data.frame(ConTemp = temp_points))
  
  ### --- FIT CUBIC MODEL --- ###
  fit_cubic <- lm(OriginalTraitValue ~ poly(ConTemp, 3), data = subset)
  cubic_points <- predict.lm(fit_cubic, data.frame(ConTemp = temp_points))
  
  ### --- FIT BRIERE-1 MODEL --- ###
  
  ## -- Estimate T0 and TM and create ranges for sampling -- ##
  t_0_est <- min(subset$ConTemp)
  t_m_est <- max(subset$ConTemp)
  t_scale <- 5
  
  t_0_range <- runif(n_tests, t_0_est - (abs(t_0_est)/t_scale), t_0_est + (abs(t_0_est)/t_scale))
  t_m_range <- runif(n_tests, t_m_est - (abs(t_m_est)/t_scale), t_m_est + (abs(t_m_est)/t_scale))
  
  ## -- Estimate B0 and create ranges for sampling -- ##
  
  # rearrange briere1 model to make b0 the subject to get a b0 value for each data point (trait value) in subset
  b_0_est <- (subset$OriginalTraitValue) / (subset$ConTemp * (subset$ConTemp - t_0_est) * ((t_m_est - subset$ConTemp)^(0.5)))
  
  # remove NA values and infinite values
  b_0_est <- b_0_est[!is.na(b_0_est) & is.finite(b_0_est)]
  
  # get mean b0 value for the subset
  b_0_mean <- mean(b_0_est)
  
  # create range around mean b0 to test values
  b_0_scale <- 3
  b_0_range <- runif(n_tests, b_0_mean/(10^(b_0_scale)), b_0_mean*(10^(b_0_scale)))

  ## -- Sample parameters and produce fit -- ##

  # use parameter ranges to sample all parameters
  briere1_start_vals <- get_briere1_start_vals(subset, t_0_range, t_m_range, b_0_range, n_tests)
  
  # if no starting values gave fits, set AIC, BIC, AICc and predicted values to NA
  if (all(is.na(briere1_start_vals))) {
    briere1_AIC <- NA
    briere1_AICc <- NA
    briere1_BIC <- NA
    briere1_points <- rep(NA, length(temp_points))
  }
  
  # else set parameters at optimal starting values and produce fit
  else {
    t_0_start <- briere1_start_vals[[2]]
    t_m_start <- briere1_start_vals[[3]]
    b_0_start <- briere1_start_vals[[4]]
    
    # fit optimal model
    fit_briere1 <- nlsLM(OriginalTraitValue ~ briere1(t = ConTemp, t_0, t_m, b_0),
                        data = subset,
                        start = list(t_0 = t_0_start,
                                     t_m = t_m_start,
                                     b_0 = b_0_start),
                        control = list(maxiter = 500))
    
    # generate AIC, BIC, AICc and predicted fit values
    briere1_AIC <- AIC(fit_briere1)
    briere1_AICc <- AICc(fit_briere1, num_param_briere1, nrow(subset))
    briere1_BIC <- BIC(fit_briere1)
    
    briere1_points <- 
      briere1(t = temp_points, 
           t_0 = coef(fit_briere1)["t_0"],
           t_m = coef(fit_briere1)["t_m"],
           b_0 = coef(fit_briere1)["b_0"])
  }
  
  
  ### --- FIT BRIERE-2 MODEL --- ###
  
  # use same estimates for T0, Tm and B0 as Briere-1
  
  ## -- Estimate M and create ranges for sampling -- ##
  m_est <- 2
  m_scale <- 2
  m_range <- runif(n_tests, m_est^(-m_scale), m_est^(m_scale))
  
  ## -- Sample parameters and produce fit -- ##
  briere2_start_vals <- get_briere2_start_vals(subset, t_0_range, t_m_range, b_0_range, m_range, n_tests)
  
  if (all(is.na(briere2_start_vals))) {
    briere2_AIC <- NA
    briere2_AICc <- NA
    briere2_BIC <- NA
    briere2_points <- rep(NA, length(temp_points))
  }
  else {
    t_0_start <- briere2_start_vals[[2]]
    t_m_start <- briere2_start_vals[[3]]
    b_0_start <- briere2_start_vals[[4]]
    m_start <- briere2_start_vals[[5]]
    
    fit_briere2 <- nlsLM(OriginalTraitValue ~ briere2(t = ConTemp, t_0, t_m, b_0, m),
                        data = subset,
                        start = list(t_0 = t_0_start,
                                     t_m = t_m_start,
                                     b_0 = b_0_start,
                                     m = m_start),
                        control = list(maxiter = 500))
    
    briere2_AIC <- AIC(fit_briere2)
    briere2_AICc <- AICc(fit_briere2, num_param_briere2, nrow(subset))
    briere2_BIC <- BIC(fit_briere2)
    
    briere2_points <- 
      briere2(t = temp_points, 
             t_0 = coef(fit_briere2)["t_0"],
             t_m = coef(fit_briere2)["t_m"],
             b_0 = coef(fit_briere2)["b_0"],
             m = coef(fit_briere2)["m"]
             )
  }

  ### --- FIT YAN AND HUNT MODEL --- ###
  
  ## -- Estimate R_max and create range for sampling -- ##
  r_max_est <- max(subset$OriginalTraitValue)
  yan_hunt_scale <- 2

  # this range skews estimates to being larger than r_max (note / vs * for lower vs upper limit)
  r_max_range <- runif(n_tests, r_max_est - (abs(r_max_est)/yan_hunt_scale), r_max_est + (abs(r_max_est)*yan_hunt_scale))

  ## -- Estimate T_min, T_max and T_opt and create ranges for sampling -- ##
  t_min_est <- min(subset$ConTemp)
  t_min_range <- runif(n_tests, t_min_est - (abs(t_min_est)/yan_hunt_scale), t_min_est + (abs(t_min_est)/yan_hunt_scale))

  t_max_est <- max(subset$ConTemp)
  t_max_range <- runif(n_tests, t_max_est - (abs(t_max_est)/yan_hunt_scale), t_max_est + (abs(t_max_est)/yan_hunt_scale))

  t_opt_est <- subset[which.max(subset$OriginalTraitValue), "ConTemp"] # temperature at which rate was highest
  t_opt_range <- runif(n_tests, t_opt_est - (abs(t_opt_est)/yan_hunt_scale), t_opt_est + (abs(t_opt_est)/yan_hunt_scale))

  ## -- Sample parameters and produce fit -- ##
  
  yan_hunt_start_vals <- get_yan_hunt_start_vals(subset, r_max_range, t_min_range, t_max_range, t_opt_range, n_tests)

  if (all(is.na(yan_hunt_start_vals))) {
    yan_hunt_AIC <- NA
    yan_hunt_AICc <- NA
    yan_hunt_BIC <- NA
    yan_hunt_points <- rep(NA, length(temp_points))
  }
  else {
    r_max_start <- yan_hunt_start_vals[[2]]
    t_min_start <- yan_hunt_start_vals[[3]]
    t_max_start <- yan_hunt_start_vals[[4]]
    t_opt_start <- yan_hunt_start_vals[[5]]

    fit_yan_hunt <- nlsLM(OriginalTraitValue ~ yan_hunt(t = ConTemp, r_max, t_min, t_max, t_opt),
                         data = subset,
                         start = list(r_max = r_max_start,
                                      t_min = t_min_start,
                                      t_max = t_max_start,
                                      t_opt = t_opt_start),
                         control = list(maxiter = 500))

    yan_hunt_AIC <- AIC(fit_yan_hunt)
    yan_hunt_AICc <- AICc(fit_yan_hunt, num_param_yan_hunt, nrow(subset))
    yan_hunt_BIC <- BIC(fit_yan_hunt)

    yan_hunt_points <-
      yan_hunt(t = temp_points,
               r_max = coef(fit_yan_hunt)["r_max"],
               t_min = coef(fit_yan_hunt)["t_min"],
               t_max = coef(fit_yan_hunt)["t_max"],
               t_opt = coef(fit_yan_hunt)["t_opt"]
      )
  }
  
  ### --- DETERMINE WHETHER THIS DATASET IS RESPIRATION OR PHOTOSYNTHESIS (RESPONSE GROUP)--- ###
  
  if (is.na(unique(subset$StandardisedTraitName))) {
    response_group <- "NA"
  }
  else if (unique(subset$StandardisedTraitName) == "respiration rate") {
    response_group <- "Respiration"
  }
  else {
    response_group <- "Photosynthesis"
  }
  
  ### --- FILL STATISTICS DATAFRAME (statsDF) FOR THE DATASET --- ###
  # columns: ID, Model, AIC, AICc, BIC, Response name, Response type (Resp or Photo), Curve classification
  
  statsDF[count*num_models,] <- c(count, "Quadratic", AIC(fit_quad), AICc(fit_quad, num_param_quad, nrow(subset)), BIC(fit_quad), unique(subset$StandardisedTraitName), response_group, unique(subset$CurveClassification))
  statsDF[count*num_models - 1,] <- c(count, "Cubic", AIC(fit_cubic), AICc(fit_cubic, num_param_cubic, nrow(subset)), BIC(fit_cubic), unique(subset$StandardisedTraitName), response_group, unique(subset$CurveClassification))
  statsDF[count*num_models - 2,] <- c(count, "Briere-1", briere1_AIC, briere1_AICc, briere1_BIC, unique(subset$StandardisedTraitName), response_group, unique(subset$CurveClassification))
  statsDF[count*num_models - 3,] <- c(count, "Briere-2", briere2_AIC, briere2_AICc, briere2_BIC, unique(subset$StandardisedTraitName), response_group, unique(subset$CurveClassification))
  statsDF[count*num_models - 4,] <- c(count, "Yan and Hunt", yan_hunt_AIC, yan_hunt_AICc, yan_hunt_BIC, unique(subset$StandardisedTraitName), response_group, unique(subset$CurveClassification))
  
  
  ### --- FILL MODEL FIT POINTS DATAFRAME (model_fitsDF) FOR THE DATASET --- ###
  # columns: ID, Temperature points, Trait points, Model
  
  model_fitsDF[(count*rows_per_subset-(rows_per_subset-1)):(count*rows_per_subset),] <- 
    c(
      rep(count, rows_per_subset), # ID
      rep(temp_points, num_models), # Temperatures
      c(quad_points, cubic_points, briere1_points, briere2_points, yan_hunt_points), # Trait points
      c(rep("Quadratic", temp_points_out), 
        rep("Cubic", temp_points_out), 
        rep("Briere-1", temp_points_out), 
        rep("Briere-2", temp_points_out),
        rep("Yan and Hunt", temp_points_out)) # Model
      )
  
  # increment progress bar to keep track of progress
  fraction_done <- count / max(therm$ID)
  setTxtProgressBar(progress_bar, fraction_done)
  
}

# close progress bar
close(progress_bar)


### --- WRITE COMPLETED MODEL FITS AND STATISTICS DATAFRAMES TO CSV FILES --- ###

write.csv(statsDF, "../Data/StatsDF.csv")
write.csv(model_fitsDF, "../Data/Model_fitsDF.csv")
