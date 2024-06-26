##### This analysis was run by the industry partner at our request #####

# install and load necessary packages
install.packages("mgcv")
install.packages("ggplot2")
library(mgcv)
library(ggplot2)

# load dataset
data_3b <- read.csv("Experiment 3 - Personalized-Skimming/Experiment 3b/experiment3b_data_prepped.csv", header=TRUE, sep=",")
data_3b$X <- NULL
data_3b$unique_id <- as.factor(data_3b$unique_id)

# create needed treatment dummy
data_3b$pers_skim <- 0
data_3b$pers_skim[data_3b$test_bucket=="Personalized"] <- 1

# ensure that pers_skim is a factor
data_3b$pers_skim <- as.factor(data_3b$pers_skim)

# create 10k version of GDP per capita
data_3b$gdp_p_capita_2017_10k <- data_3b$gdp_p_capita_2017/10000

# fit a GAM model with reduced basis dimension and subset of the data
gam_model <- gam(d30_rev_denoised ~ s(gdp_p_capita_2017_10k, k = 8) + 
                   #d30_conversion ~ s(gdp_p_capita_2017_10k, k = 8) + 
                   s(gdp_p_capita_2017_10k, by = pers_skim, k = 8) + 
                   pers_skim, 
                 data = data_3b, method = "REML")

# define the range of the covariate for prediction
covariate_range <- seq(min(data_3b$gdp_p_capita_2017_10k, na.rm = TRUE), 
                       max(data_3b$gdp_p_capita_2017_10k, na.rm = TRUE), 
                       length.out = 100)

# predict outcomes for treatment and control with standard errors
pred_treated <- predict(gam_model, 
                        newdata = data.frame(gdp_p_capita_2017_10k = covariate_range, 
                                             pers_skim = factor(1, levels = levels(data_3b$pers_skim))),
                        type = "response", se.fit = TRUE)
pred_control <- predict(gam_model, 
                        newdata = data.frame(gdp_p_capita_2017_10k = covariate_range, 
                                             pers_skim = factor(0, levels = levels(data_3b$pers_skim))),
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
  #geom_ribbon(aes(ymin = LowerCI, ymax = UpperCI), alpha = 0.2) +
  labs(#title = "Heterogeneous Treatment Effect",
       x = "GDP per Capita (2017, in 10k USD)",
       y = "Treatment Effect in D30 Revenue (Winsorized)") +
       #y = "Treatment Effect in D30 Conversion") +
  ylim(-0.0025,0.0125)

# visualize the smooth terms
par(mfrow = c(2, 1))
plot(gam_model, pages = 1, se = TRUE, rug = TRUE)
