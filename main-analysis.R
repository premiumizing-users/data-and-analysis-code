### set up and data loading

# load required packages and set up
pkgs <- list("glmnet", "doParallel", "foreach", "pROC", "gplots", "pwr", "dplyr","plyr", "caret", "sm", "ggplot2", "gridExtra", "qte", "scales", "reshape2", "Rmisc", "Hmisc", "bayesAB")
lapply(pkgs, require, character.only = T)
registerDoParallel(cores = 4)

# set working directory
setwd("NA")

# load datasets
data_1 <- read.csv("Experiment 1 - Low-Mid-High/experiment1_data_prepped.csv", header=TRUE, sep=",")
data_1$X <- NULL
data_1$X.1 <- NULL
data_1$unique_id <- as.factor(data_1$unique_id)

data_2 <- read.csv("Experiment 2 - Simple-Skimming/experiment2_data_prepped.csv", header=TRUE, sep=",")
data_2$X <- NULL
data_2$unique_id <- as.factor(data_2$unique_id)

data_3b <- read.csv("Experiment 3 - Personalized-Skimming/Experiment 3b/experiment3b_data_prepped.csv", header=TRUE, sep=",")
data_3b$X <- NULL
data_3b$unique_id <- as.factor(data_3b$unique_id)


#################################################################
##### experiment 1: treatment effects #####
#################################################################

# set $4.99 starter pack condition as reference
data_1$test_bucket <- factor(data_1$test_bucket)
data_1$test_bucket <- relevel(data_1$test_bucket, ref = "offer_on5")

### regressions to quantify treatment effects for experiment 1

# 1-day measurement window
e1_d1_offer_conversion <- lm(d1_offer_conversion ~ test_bucket,
                          data=data_1)
summary(e1_d1_offer_conversion)

e1_d1_offer_revenue <- lm(d1_offer_revenue ~ test_bucket,
                       data=data_1)
summary(e1_d1_offer_revenue)

e1_d1_conversion <- lm(d1_conversion ~ test_bucket,
                    data=data_1)
summary(e1_d1_conversion)

e1_d1_revenue <- lm(d1_revenue ~ test_bucket,
                 data=data_1)
summary(e1_d1_revenue)

e1_d1_rev_denoised <- lm(d1_rev_denoised ~ test_bucket,
                      data=data_1)
summary(e1_d1_rev_denoised)

e1_d1_repeat_purchases <- lm(d1_repeat_purchases ~ test_bucket,
                          data=data_1)
summary(e1_d1_repeat_purchases)

e1_d1_minutes <- lm(d1_minutes ~ test_bucket,
                 data=data_1)
summary(e1_d1_minutes)

e1_d1_rounds_played <- lm(d1_rounds_played ~ test_bucket,
                       data=data_1)
summary(e1_d1_rounds_played)

e1_d1_retention <- lm(d1_retention ~ test_bucket,
                   data=data_1)
summary(e1_d1_retention)

e1_d1_ad_views <- lm(d1_ad_views ~ test_bucket,
                  data=data_1)
summary(e1_d1_ad_views)

# 7-day measurement window
e1_d7_offer_conversion <- lm(d7_offer_conversion ~ test_bucket,
                          data=data_1)
summary(e1_d7_offer_conversion)

e1_d7_offer_revenue <- lm(d7_offer_revenue ~ test_bucket,
                       data=data_1)
summary(e1_d7_offer_revenue)

e1_d7_conversion <- lm(d7_conversion ~ test_bucket,
                    data=data_1)
summary(e1_d7_conversion)

e1_d7_revenue <- lm(d7_revenue ~ test_bucket,
                 data=data_1)
summary(e1_d7_revenue)

e1_d7_rev_denoised <- lm(d7_rev_denoised ~ test_bucket,
                      data=data_1)
summary(e1_d7_rev_denoised)

e1_d7_repeat_purchases <- lm(d7_repeat_purchases ~ test_bucket,
                          data=data_1)
summary(e1_d7_repeat_purchases)

e1_d7_minutes <- lm(d7_minutes ~ test_bucket,
                 data=data_1)
summary(e1_d7_minutes)

e1_d7_rounds_played <- lm(d7_rounds_played ~ test_bucket,
                       data=data_1)
summary(e1_d7_rounds_played)

e1_d7_retention <- lm(d7_retention ~ test_bucket,
                   data=data_1)
summary(e1_d7_retention)

e1_d7_ad_views <- lm(d7_ad_views ~ test_bucket,
                  data=data_1)
summary(e1_d7_ad_views)

# 30-day measurement window
e1_d30_offer_conversion <- lm(d30_offer_conversion ~ test_bucket,
                          data=data_1)
summary(e1_d30_offer_conversion)

e1_d30_offer_revenue <- lm(d30_offer_revenue ~ test_bucket,
                       data=data_1)
summary(e1_d30_offer_revenue)

e1_d30_conversion <- lm(d30_conversion ~ test_bucket,
                    data=data_1)
summary(e1_d30_conversion)

e1_d30_revenue <- lm(d30_revenue ~ test_bucket,
                 data=data_1)
summary(e1_d30_revenue)

e1_d30_rev_denoised <- lm(d30_rev_denoised ~ test_bucket,
                      data=data_1)
summary(e1_d30_rev_denoised)

e1_d30_repeat_purchases <- lm(d30_repeat_purchases ~ test_bucket,
                          data=data_1)
summary(e1_d30_repeat_purchases)

e1_d30_minutes <- lm(d30_minutes ~ test_bucket,
                 data=data_1)
summary(e1_d30_minutes)

e1_d30_rounds_played <- lm(d30_rounds_played ~ test_bucket,
                       data=data_1)
summary(e1_d30_rounds_played)

e1_d30_retention <- lm(d30_retention ~ test_bucket,
                   data=data_1)
summary(e1_d30_retention)

e1_d30_ad_views <- lm(d30_ad_views ~ test_bucket,
                  data=data_1)
summary(e1_d30_ad_views)


#################################################################
##### exp. 1: treatment effect heterogeneity in device memory #####
#################################################################

# set dataset to analyze
data <- data_1 # out of data_1, data_2, data_3b

# set lowest device tier as reference
data$device_tier <- factor(data$device_tier)
data$device_tier <- relevel(data$device_tier, ref = "Android tier 5")

# regression of d30 revenue
teh_device1 <- lm(d30_revenue ~ test_bucket,
                  data=data)
summary(teh_device1)

teh_device2 <- lm(d30_revenue ~ device_tier,
                  data=data)
summary(teh_device2)

teh_device3 <- lm(d30_revenue ~ test_bucket * device_tier,
                  data=data)
summary(teh_device3)

teh_device4 <- lm(d30_revenue ~ device_ram,
                  data=data)
summary(teh_device4)

teh_device5 <- lm(d30_revenue ~ test_bucket * device_ram,
                  data=data)
summary(teh_device5)

# regression of d30 revenue denoised
teh_device1_denoised <- lm(d30_rev_denoised ~ test_bucket,
                  data=data)
summary(teh_device1_denoised)

teh_device2_denoised <- lm(d30_rev_denoised ~ device_tier,
                  data=data)
summary(teh_device2_denoised)

teh_device3_denoised <- lm(d30_rev_denoised ~ test_bucket * device_tier,
                  data=data)
summary(teh_device3_denoised)

teh_device4_denoised <- lm(d30_rev_denoised ~ device_ram,
                  data=data)
summary(teh_device4_denoised)

teh_device5_denoised <- lm(d30_rev_denoised ~ test_bucket * device_ram,
                  data=data)
summary(teh_device5_denoised)

# teh in complete combination of country and device segments
# set lowest country tier as reference
data$country_tier_new <- factor(data$country_tier_new)
data$country_tier_new <- relevel(data$country_tier_new, ref = "Country tier 4")

teh_device_country_denoised <- lm(d30_rev_denoised ~ test_bucket * device_tier * country_tier_new,
                           data=data)
summary(teh_device_country_denoised)


#################################################################
##### exp. 1: treatment effects along the distribution (qtes) #####
#################################################################

# create needed treatment dummies
data_1$treat_offer3 <- 0
data_1$treat_offer3[data_1$test_bucket=="offer_on3"] <- 1

data_1$treat_offer30 <- 0
data_1$treat_offer30[data_1$test_bucket=="offer_on30"] <- 1

# check values of quantiles in the respective joint distributions
quantile(filter(data_1,data_1$test_bucket=="offer_on3" | data_1$test_bucket=="offer_on5")$d30_revenue, probs = .995)
quantile(filter(data_1,data_1$test_bucket=="offer_on30" | data_1$test_bucket=="offer_on5")$d30_revenue, probs = .995)

# get qte for comparison of $2.99 to $4.99 starter pack condition
qte_3vs5 <- ci.qtet(d30_revenue ~ treat_offer3,
                      data=filter(data_1,data_1$test_bucket=="offer_on3" | data_1$test_bucket=="offer_on5"),
                      probs=seq(.97,.995,.0005), 
                      se=T,
                      iters=10)
summary(qte_3vs5)

plot_3vs5 <- ggqte(qte_3vs5, main = "$2.99 compared to $4.99 starter pack") + xlim(.97,.995) + ylim(-25,10)

plot_3vs5_2 <- plot_3vs5 + 
  geom_hline(yintercept = c(-20, -10, 10, 20), linetype = "dotted", color = "black") +
  labs(title = "$2.99 compared to $4.99 starter pack") +
  ylim(-25,25) +
  ylab("QTE in one-month revenue in $") +
  xlab("") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, size = 12))

# get qte for comparison of $29.99 to $4.99 starter pack condition
qte_30vs5 <- ci.qtet(d30_revenue ~ treat_offer30,
                       data=filter(data_1,data_1$test_bucket=="offer_on30" | data_1$test_bucket=="offer_on5"),
                       probs=seq(.97,.995,.0005), 
                       se=T,
                       iters=10)
summary(qte_30vs5)

plot_30vs5 <- ggqte(qte_30vs5, main = "$29.99 compared to $4.99 starter pack") + xlim(.97,.995) + ylim(-10,25)

plot_30vs5_2 <- plot_30vs5 + 
  geom_hline(yintercept = c(-20, -10, 10, 20), linetype = "dotted", color = "black") +
  labs(title = "$29.99 compared to $4.99 starter pack") +
  ylim(-25,25) +
  ylab("QTE in one-month revenue in $") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, size = 12))

# arrange plots in one figure
grid.arrange(plot_3vs5_2, plot_30vs5_2,
             ncol = 2, nrow = 1,
             bottom = ("Quantiles of the one-month revenue distribution; 97.5th ($0) to 99.5th (~$80) quantile"))


#################################################################
##### exp. 2&3b: treatment effects #####
#################################################################

# experiment 2

# set lowest country tier as reference
data_2$country_tier <- factor(data_2$country_tier)
data_2$country_tier <- relevel(data_2$country_tier, ref = "Country tier 4")

# regression to quantify treatment effects for experiment 2
e2_offer_conversion <- lm(d30_offer_conversion ~ test_bucket,
                      data=data_2)
summary(e2_offer_conversion)

e2_offer_revenue <- lm(d30_offer_revenue ~ test_bucket,
                       data=data_2)
summary(e2_offer_revenue)

e2_conversion <- lm(d30_conversion ~ test_bucket,
                      data=data_2)
summary(e2_conversion)

e2_revenue <- lm(d30_revenue ~ test_bucket,
                      data=data_2)
summary(e2_revenue)

e2_rev_denoised <- lm(d30_rev_denoised ~ test_bucket,
                 data=data_2)
summary(e2_rev_denoised)

e2_repeat_purchases <- lm(d30_repeat_purchases ~ test_bucket,
                      data=data_2)
summary(e2_repeat_purchases)

e2_minutes <- lm(d30_minutes ~ test_bucket,
                      data=data_2)
summary(e2_minutes)

e2_rounds_played <- lm(d30_rounds_played ~ test_bucket,
                      data=data_2)
summary(e2_rounds_played)

e2_retention <- lm(d30_retention ~ test_bucket,
                      data=data_2)
summary(e2_retention)

e2_ad_views <- lm(d30_ad_views ~ test_bucket,
                      data=data_2)
summary(e2_ad_views)


# experiment 3b

# set country and device tier references
data_3b$country_tier <- factor(data_3b$country_tier)
data_3b$country_tier <- relevel(data_3b$country_tier, ref = "Country tier 4")
data_3b$device_tier <- factor(data_3b$device_tier)
data_3b$device_tier <- relevel(data_3b$device_tier, ref = "Android tier 5")

# regression to quantify treatment effect w/o background data
e3b_offer_conversion <- lm(d30_offer_conversion ~ test_bucket,
                             data=data_3b)
summary(e3b_offer_conversion)

e3b_offer_revenue <- lm(d30_offer_revenue ~ test_bucket,
                          data=data_3b)
summary(e3b_offer_revenue)

e3b_conversion <- lm(d30_conversion ~ test_bucket,
                       data=data_3b)
summary(e3b_conversion)

e3b_revenue <- lm(d30_revenue ~ test_bucket,
                    data=data_3b)
summary(e3b_revenue)

e3b_rev_denoised <- lm(d30_rev_denoised ~ test_bucket,
                         data=data_3b)
summary(e3b_rev_denoised)

e3b_repeat_purchases <- lm(d30_repeat_purchases ~ test_bucket,
                             data=data_3b)
summary(e3b_repeat_purchases)

e3b_minutes <- lm(d30_minutes ~ test_bucket,
                    data=data_3b)
summary(e3b_minutes)

e3b_rounds_played <- lm(d30_rounds_played ~ test_bucket,
                          data=data_3b)
summary(e3b_rounds_played)

e3b_retention <- lm(d30_retention ~ test_bucket,
                      data=data_3b)
summary(e3b_retention)

e3b_ad_views <- lm(d30_ad_views ~ test_bucket,
                     data=data_3b)
summary(e3b_ad_views)


#################################################################
##### exp. 3b: qtes for pers. skimming effects in revenue #####
#################################################################

# set $4.99 starter pack condition as reference
data_3b$test_bucket <- factor(data_3b$test_bucket)
data_3b$test_bucket <- relevel(data_3b$test_bucket, ref = "Hold-out")

# create needed treatment dummy
data_3b$pers_skim <- 0
data_3b$pers_skim[data_3b$test_bucket=="Personalized"] <- 1

# check values of quantiles in the respective joint distributions
quantile(data_3b$d30_revenue, probs = .978)
quantile(data_3b$d30_revenue, probs = .983)
quantile(data_3b$d30_revenue, probs = .988)
quantile(data_3b$d30_revenue, probs = .992)

# get qte for comparison of the personalized dynamics to the $4.99 starter pack condition
qte_persvsflat <- ci.qtet(d30_revenue ~ pers_skim,
                      data=data_3b,
                      probs=seq(.975,.995,.0005), 
                      se=T,
                      iters=50)
summary(qte_persvsflat)

plotpersvsflat <- ggqte(qte_persvsflat) + xlim(.975,.995) + ylim(-20,40) + xlab("Quantiles of the one-month revenue distribution; 97.5th ($0) to 99.5th (~$80) quantile")

plotpersvsflat_2 <- plotpersvsflat + 
  geom_hline(yintercept = c(-20, -10, 10, 20, 30, 40), linetype = "dotted", color = "black") +
  labs(title = "Personalized dynamic compared to $4.99 flat-price strategy") +
  ylim(-10,35) +
  ylab("QTE in one-month revenue in $") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, size = 12))


#################################################################
##### discussion: inclusion in premium #####
#################################################################

# make a factor and set lowest quartile as reference
data_3b$gdp_p_cap_quintiles <- factor(data_3b$gdp_p_cap_quintiles)
data_3b$gdp_p_cap_quintiles <- relevel(data_3b$gdp_p_cap_quintiles, ref = "1")

# run regression of premiumization on gdp p. cap. quintiles
e3b_conversion_gdp_quin <- lm(d30_conversion ~ test_bucket * data_3b$gdp_p_cap_quintiles,
                         data=data_3b)
summary(e3b_conversion_gdp_quin)

e3b_rev_den_gdp_quin <- lm(d30_rev_denoised ~ test_bucket * data_3b$gdp_p_cap_quintiles,
                      data=data_3b)
summary(e3b_rev_den_gdp_quin)
