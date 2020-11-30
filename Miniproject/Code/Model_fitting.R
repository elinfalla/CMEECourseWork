#!/usr/bin/env R

#packages
require(minpack.lm)

rm(list = ls())

##########################################
########### MODEL FITTING ################
##########################################

#import prepared dataset
therm <- read.csv("../Data/PreparedThermRespData.csv", header = T, stringsAsFactors = F)

#initiailise stats dataframe (for goodness of fit statistics)
num_models <- 5 
statsDF <- data.frame(matrix(NA, nrow = max(therm$ID) * num_models, ncol = 5))
names(statsDF) <- c("ID", "Model", "AIC", "BIC", "R.squared")

#initialise model fits dataframe (for fit of models - to draw fit line on graph)
temp_points_out <- 50
rows_per_subset <- temp_points_out * num_models
model_fitsDF <- data.frame(ID = NA * max(therm$ID) * rows_per_subset,
                           Temperature = NA * max(therm$ID) * rows_per_subset,
                           Trait.points = NA * max(therm$ID) * rows_per_subset,
                           Model = NA * max(therm$ID) * rows_per_subset
                           )

###### BRIERE 1 MODEL FUNCTIONS ###### 

# briere model
briere <- function(t, t_0, t_m, b_0) {
  
  return(b_0 * t * (t - t_0) * (abs(t_m - t)^(1/2)) * as.numeric(t<t_m) * as.numeric(t>t_0)) # add * t after b0
        
}

# briere try function: tries to fit model using given start values. returns AIC if successful, else returns NA
briere_try_func <- function(subset, t_0_start, t_m_start, b_0_start) {
  out <- tryCatch(
    expr = {
      nlsLM(OriginalTraitValue ~ briere(t = ConTemp, t_0, t_m, b_0),
                          data = subset,
                          start = list(t_0 = t_0_start,
                                       t_m = t_m_start,
                                       b_0 = b_0_start),
                          control = list(maxiter = 500)#,
                          #lower = c(-40, -40, 1e-7),
                          #upper = c(100, 100, 1e+7)
            )
    },
      error = function(cond) {
        # print("")
        # message("No fit possible. Error message:")
        # message(cond)
        return(NA)  # no output, if put NA then will output with NA
    }
  )
  if (all(!is.na(out))) {
    AICc <- AIC(out) + (2 * 3 * (nrow(subset) / (nrow(subset) - 3 - 1)))
    return(data.frame(AIC = AIC(out), AICc = AICc))
  }
  else {
    return(out)
  }
}

# returns the best starting values from an inputted range of values using briere_try_func above. if no starting values yield a fit, return NA
get_briere_start_vals <- function(subset, t_0_start, t_m_start, b_0_start, n_tests) {
  
  out <- lapply(1:n_tests, function(x) briere_try_func(subset, t_0_start[x], t_m_start[x], b_0_start[x]))
  
  # print("**************")
  # print(unique(subset$ID))
  # print(out)
  
  if (all(is.na(out))) {
    return(NA)
  }
  AIC_vals <- lapply(out, function(x) if (all(!is.na(x))) x["AIC"])
  AICc_vals <- lapply(out, function(x) if (all(!is.na(x))) x["AICc"])
  
  lowest_AIC <- which.min(AIC_vals)
  lowest_AICc <- which.min(AICc_vals)
  
  print(lowest_AIC)
  print(lowest_AICc)
  
  if (lowest_AIC != lowest_AICc) {
    print("lowest AIC:", AIC_vals[lowest_AIC])
    print("lowest AICc:", AICc_vals[lowest_AICc])
    
  }
  
  final_t_0_start <- t_0_start[lowest_AICc]
  final_t_m_start <- t_m_start[lowest_AICc]
  final_b_0_start <- b_0_start[lowest_AICc]
  
  return(c(out[lowest_AIC], 
           final_t_0_start, 
           final_t_m_start, 
           final_b_0_start))
  
}

###### BRIERE 2 MODEL FUNCTIONS ###### 

# briere model with extra parameter
briere2 <- function(t, t_0, t_m, b_0, m) {
  
  return(b_0 * t * (t - t_0) * (abs(t_m - t)^(1/m)) * as.numeric(t<t_m) * as.numeric(t>t_0))
}

# briere2 try function: tries to fit model using given start values. returns AIC if successful, else returns NA
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
      # print("")
      # message("No fit possible. Error message:")
      # message(cond)
      return(NA)  # no output, if put NA then will output with NA
    }
  )
  if (all(!is.na(out))) {
    return(AIC(out))
  }
  else {
    return(out)
  }
}

# returns the best starting values from an inputted range of values using briere_try_func above. if no starting values yield a fit, return NA
get_briere2_start_vals <- function(subset, t_0_start, t_m_start, b_0_start, m_start, n_tests) {
  
  out <- lapply(1:n_tests, function(x) briere2_try_func(subset, t_0_start[x], t_m_start[x], b_0_start[x], m_start[x]))
  
  # print("**************")
  # print(unique(subset$ID))
  # print(out)
  
  if (all(is.na(out))) {
    return(NA)
  }
  
  lowest_AIC <- which.min(out)
  
  final_t_0_start <- t_0_start[lowest_AIC]
  final_t_m_start <- t_m_start[lowest_AIC]
  final_b_0_start <- b_0_start[lowest_AIC]
  final_m_start <- m_start[lowest_AIC]
  
  return(c(out[lowest_AIC], 
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
      # print("")
      # message("No fit possible. Error message:")
      # message(cond)
      return(NA)  # no output, if put NA then will output with NA
    }
  )
  if (all(!is.na(out))) {
    return(AIC(out))
  }
  else {
    return(out)
  }
}

# returns the best starting values from an inputted range of values using briere_try_func above. if no starting values yield a fit, return NA
get_yan_hunt_start_vals <- function(subset, r_max_start, t_min_start, t_max_start, t_opt_start, n_tests) {
  
  out <- lapply(1:n_tests, function(x) yan_hunt_try_func(subset, r_max_start[x], t_min_start[x], t_max_start[x], t_opt_start[x]))
  
  # print("**************")
  # print(unique(subset$ID))
  # print(out)
  
  if (all(is.na(out))) {
    return(NA)
  }
  
  lowest_AIC <- which.min(out)
  
  final_r_max_start <- r_max_start[lowest_AIC]
  final_t_min_start <- t_min_start[lowest_AIC]
  final_t_max_start <- t_max_start[lowest_AIC]
  final_t_opt_start <- t_opt_start[lowest_AIC]
  
  return(c(out[lowest_AIC], 
           final_r_max_start, 
           final_t_min_start, 
           final_t_max_start,
           final_t_opt_start))
  
}


### MODEL FITTING ###

# set number of times to run start vals
n_tests <- 10

# initialise empty vector to hold IDs where no fit was possible
no_fit_briere <- vector()
no_fit_briere2 <- vector()
no_fit_yan_hunt <- vector()

#for (count in 1:max(therm$ID)) {
for (count in 1:9) {
  subset <- therm[therm$ID == count,]
  
  #create temperature points vector for creating model fit lines
  temp_points <- seq(min(subset$ConTemp), max(subset$ConTemp), length.out = temp_points_out)
  
  # fit quadratic model
  fit_quad <- lm(OriginalTraitValue ~ poly(ConTemp, 2), data = subset)
  quad_points <- predict.lm(fit_quad, data.frame(ConTemp = temp_points))
  
  # fit cubic model
  fit_cubic <- lm(OriginalTraitValue ~ poly(ConTemp, 3), data = subset)
  cubic_points <- predict.lm(fit_cubic, data.frame(ConTemp = temp_points))
  
  
  # runif is robust to negative values of contemp - if just divide then doesnt work for neg vals
  # here 1 is scaling factor, larger number = smaller range of starting values
  
  t_0_est <- min(subset$ConTemp)
  t_m_est <- max(subset$ConTemp)
  scale_factor <- 5
  
  set.seed(230)
  
  t_0_range <- runif(n_tests, t_0_est - (abs(t_0_est)/scale_factor), t_0_est + (abs(t_0_est)/scale_factor))
  t_m_range <- runif(n_tests, t_m_est - (abs(t_m_est)/scale_factor), t_m_est + (abs(t_m_est)/scale_factor))
  # t_0_range <- rnorm(n_tests, t_0_est, 1)
  # t_m_range <- rnorm(n_tests, t_m_est, 1)
  
  # rearrange briere model to make b0 the subject to get a b0 value for each data point (trait value) in subset
  b_0_est <- (subset$OriginalTraitValue) / (subset$ConTemp * (subset$ConTemp - t_0_est) * ((t_m_est - subset$ConTemp)^(0.5)))
  
  # remove NA values and infinite values
  b_0_est <- b_0_est[!is.na(b_0_est) & is.finite(b_0_est)]
  
  # get mean b0 value for the subset
  b_0_mean <- mean(b_0_est)
  
  # create range around mean b0 to test values
  b_0_scale <- 5
  #b_0_range <- runif(n_tests, 1e-6, 1e+6)
  b_0_range <- runif(n_tests, b_0_mean*(10^(-b_0_scale)), b_0_mean*(10^(b_0_scale)))
  #b_0_range <- rnorm(n_tests, b_0_mean, 10^(round(log10(abs(b_0_mean)))))
  
  briere_start_vals <- get_briere_start_vals(subset, t_0_range, t_m_range, b_0_range, n_tests)
  
  if (all(is.na(briere_start_vals))) {
    no_fit_briere <- c(no_fit_briere, unique(subset$ID))
    briere_AIC <- NA
    briere_BIC <- NA
    briere_points <- rep(NA, length(temp_points))
  }
  else {
    
    #print(paste("ID:", count, "lowest AIC:", briere_start_vals[[1]]))
    
    t_0_start <- briere_start_vals[[2]]
    t_m_start <- briere_start_vals[[3]]
    b_0_start <- briere_start_vals[[4]]
    
    fit_briere <- nlsLM(OriginalTraitValue ~ briere(t = ConTemp, t_0, t_m, b_0),
                        data = subset,
                        start = list(t_0 = t_0_start,
                                     t_m = t_m_start,
                                     b_0 = b_0_start),
                        control = list(maxiter = 500),
                        lower = c(-20, 0, 1e-7),
                        upper = c(20, 100 , 1e+7))
    
    briere_AIC <- AIC(fit_briere)
    briere_BIC <- BIC(fit_briere)
    
    briere_points <- 
      briere(t = temp_points, 
           t_0 = coef(fit_briere)["t_0"],
           t_m = coef(fit_briere)["t_m"],
           b_0 = coef(fit_briere)["b_0"])
  }
  
  
  # BRIERE 2
  m_est <- 2
  m_scale <- 2
  m_range <- runif(n_tests, m_est^(-m_scale), m_est^(m_scale))
  
  briere2_start_vals <- get_briere2_start_vals(subset, t_0_range, t_m_range, b_0_range, m_range, n_tests)
  
  if (all(is.na(briere2_start_vals))) {
    #UPDATE NO FIT TO INCLUDE MORE MODELS
    no_fit_briere2 <- c(no_fit_briere2, unique(subset$ID))
    briere2_AIC <- NA
    briere2_BIC <- NA
    briere2_points <- rep(NA, length(temp_points))
  }
  else {
    
    #print(paste("ID:", count, "lowest briere2 AIC:", briere2_start_vals[[1]]))
    
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
    briere2_BIC <- BIC(fit_briere2)
    
    briere2_points <- 
      briere2(t = temp_points, 
             t_0 = coef(fit_briere2)["t_0"],
             t_m = coef(fit_briere2)["t_m"],
             b_0 = coef(fit_briere2)["b_0"],
             m = coef(fit_briere2)["m"]
             )
  }

  ### YAN AND HUNT
  
  r_max_est <- max(subset$OriginalTraitValue)
  yan_hunt_scale <- 2

  # this range skews estimates to being larger than r_max (note / vs * for lower vs upper limit)
  r_max_range <- runif(n_tests, r_max_est - (abs(r_max_est)/yan_hunt_scale), r_max_est + (abs(r_max_est)*yan_hunt_scale))

  t_min_est <- min(subset$ConTemp)
  t_min_range <- runif(n_tests, t_min_est - (abs(t_min_est)/yan_hunt_scale), t_min_est + (abs(t_min_est)/yan_hunt_scale))

  t_max_est <- max(subset$ConTemp)
  t_max_range <- runif(n_tests, t_max_est - (abs(t_max_est)/yan_hunt_scale), t_max_est + (abs(t_max_est)/yan_hunt_scale))

  t_opt_est <- subset[which.max(subset$OriginalTraitValue), "ConTemp"]
  t_opt_range <- runif(n_tests, t_opt_est - (abs(t_opt_est)/yan_hunt_scale), t_opt_est + (abs(t_opt_est)/yan_hunt_scale))

  yan_hunt_start_vals <- get_yan_hunt_start_vals(subset, r_max_range, t_min_range, t_max_range, t_opt_range, n_tests)

  if (all(is.na(yan_hunt_start_vals))) {
    #UPDATE NO FIT TO INCLUDE MORE MODELS
    no_fit_yan_hunt <- c(no_fit_yan_hunt, unique(subset$ID))
    yan_hunt_AIC <- NA
    yan_hunt_BIC <- NA
    yan_hunt_points <- rep(NA, length(temp_points))
  }
  else {

    #print(paste("ID:", count, "lowest briere2 AIC:", briere2_start_vals[[1]]))

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
    yan_hunt_BIC <- BIC(fit_yan_hunt)

    yan_hunt_points <-
      yan_hunt(t = temp_points,
               r_max = coef(fit_yan_hunt)["r_max"],
               t_min = coef(fit_yan_hunt)["t_min"],
               t_max = coef(fit_yan_hunt)["t_max"],
               t_opt = coef(fit_yan_hunt)["t_opt"]
      )
  }
  
  
  statsDF[count*num_models,] <- c(count, "Quadratic", AIC(fit_quad), BIC(fit_quad), summary(fit_quad)$r.squared)
  statsDF[count*num_models - 1,] <- c(count, "Cubic", AIC(fit_cubic), BIC(fit_cubic), summary(fit_cubic)$r.squared)
  statsDF[count*num_models - 2,] <- c(count, "Briere", briere_AIC, briere_BIC, NA)
  statsDF[count*num_models - 3,] <- c(count, "Briere2", briere2_AIC, briere2_BIC, NA)
  statsDF[count*num_models - 4,] <- c(count, "Yan and Hunt", yan_hunt_AIC, yan_hunt_BIC, NA)
  

  
  print(count)
  

  
  #TO DO: change to long format? points col and model col
  # fill in model_fitsDF for the subset
  model_fitsDF[(count*rows_per_subset-(rows_per_subset-1)):(count*rows_per_subset),] <- 
    c(
      rep(count, rows_per_subset), # ID
      rep(temp_points, num_models), # Temperatures
      c(quad_points, cubic_points, briere_points, briere2_points, yan_hunt_points),
      c(rep("Quadratic", temp_points_out), 
        rep("Cubic", temp_points_out), 
        rep("Briere", temp_points_out), 
        rep("Briere2", temp_points_out),
        rep("Yan and Hunt", temp_points_out))
      )

  
}


write.csv(statsDF, "../Data/StatsDF.csv")
write.csv(model_fitsDF, "../Data/Model_fitsDF.csv")
# write.csv(no_fit, "../Data/No_fit.csv")