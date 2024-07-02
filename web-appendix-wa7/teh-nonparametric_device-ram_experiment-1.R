##### non-parametric analysis of heterogeneous treatment effects in device memory for experiment 1 #####

# install and load necessary packages
install.packages("mgcv")
install.packages("ggplot2")
library(mgcv)
library(ggplot2)
library(dplyr)

# set working directory
setwd("NA")

# load dataset
data_1 <- read.csv("Experiment 1 - Low-Mid-High/experiment1_data_prepped.csv", header=TRUE, sep=",")
data_1$X <- NULL
data_1$unique_id <- as.factor(data_1$unique_id)

# create needed treatment dummies
data_1$treat_offer3 <- 0
data_1$treat_offer3[data_1$test_bucket=="offer_on3"] <- 1

data_1$treat_offer30 <- 0
data_1$treat_offer30[data_1$test_bucket=="offer_on30"] <- 1

# filter the dataset to compare $2.99 to $4.99 condition
filtered_data <- filter(data_1, data_1$test_bucket == "offer_on3" | data_1$test_bucket == "offer_on5")

# ensure that treat_offer3 is a factor
filtered_data$treat_offer3 <- as.factor(filtered_data$treat_offer3)

# fit a GAM model with reduced basis dimension and subset of the data
gam_model <- gam(d30_rev_denoised ~ s(device_ram, k = 13) + 
                   s(device_ram, by = treat_offer3, k = 13) + 
                   treat_offer3, 
                 data = filtered_data, method = "REML")

# define the range of the covariate for prediction
covariate_range <- seq(min(filtered_data$device_ram, na.rm = TRUE), 
                       max(filtered_data$device_ram, na.rm = TRUE), 
                       length.out = 100)

# predict outcomes for treatment and control with standard errors
pred_treated <- predict(gam_model, 
                        newdata = data.frame(device_ram = covariate_range, 
                                             treat_offer3 = factor(1, levels = levels(filtered_data$treat_offer3))),
                        type = "response", se.fit = TRUE)
pred_control <- predict(gam_model, 
                        newdata = data.frame(device_ram = covariate_range, 
                                             treat_offer3 = factor(0, levels = levels(filtered_data$treat_offer3))),
                        type = "response", se.fit = TRUE)

# check for any NA values in predictions
print(sum(is.na(pred_treated$fit)))
print(sum(is.na(pred_control$fit)))

# calculate the treatment effect and confidence intervals
treatment_effect <- pred_treated$fit - pred_control$fit
se_treatment_effect <- sqrt(pred_treated$se.fit^2 + pred_control$se.fit^2)

# create a data frame for plotting
plot_data <- data.frame(
  Covariate = covariate_range,
  TreatmentEffect = treatment_effect,
  LowerCI = treatment_effect - 1.96 * se_treatment_effect,
  UpperCI = treatment_effect + 1.96 * se_treatment_effect
)

# plot the treatment effects with confidence intervals
ggplot(plot_data, aes(x = Covariate, y = TreatmentEffect)) +
  geom_line() +
  geom_ribbon(aes(ymin = LowerCI, ymax = UpperCI), alpha = 0.2) +
  labs(#title = "Heterogeneous Treatment Effect",
       x = "Device RAM (in gigabyte)",
       y = "Treatment Effect Of $2.99 vs. $4.99 Pack in D30 Revenue (Wins.)") +
  xlim(0,10000) +
  ylim(-30,30)

# visualize the smooth terms
par(mfrow = c(2, 1))
plot(gam_model, pages = 1, se = TRUE, rug = TRUE)
