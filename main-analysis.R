### set up and data loading

# load required packages and set up
pkgs <- list("glmnet", "doParallel", "foreach", "pROC", "gplots", "pwr", "dplyr","plyr", "caret", "sm", "ggplot2", "gridExtra", "qte", "scales", "reshape2", "Rmisc", "Hmisc", "bayesAB")
lapply(pkgs, require, character.only = T)
registerDoParallel(cores = 4)

# set working directory
setwd("NA")

# load datasets
data_1 <- read.csv("experiment-1/experiment1_data_prepped.csv", header=TRUE, sep=",")
data_1$X <- NULL
data_1$X.1 <- NULL
data_1$unique_id <- as.factor(data_1$unique_id)

data_2 <- read.csv("experiment-2/experiment2_data_prepped.csv", header=TRUE, sep=",")
data_2$X <- NULL
data_2$unique_id <- as.factor(data_2$unique_id)

data_3b <- read.csv("experiment-3/experiment-3b/experiment3b_data_prepped.csv", header=TRUE, sep=",")
data_3b$X <- NULL
data_3b$unique_id <- as.factor(data_3b$unique_id)


#################################################################
##### randomization checks using key background variables #####
#################################################################

### for experiment 1

# descriptive stats with confidence intervals
summarySE(data_1, "device_ram", groupvars = c("test_bucket"), na.rm = FALSE, conf.interval = 0.95, .drop = TRUE)
summarySE(data_1, "device_tierAndroid.tier.1", groupvars = c("test_bucket"), na.rm = FALSE, conf.interval = 0.95, .drop = TRUE)
summarySE(data_1, "device_tierAndroid.tier.2", groupvars = c("test_bucket"), na.rm = FALSE, conf.interval = 0.95, .drop = TRUE)
summarySE(data_1, "device_tierAndroid.tier.3", groupvars = c("test_bucket"), na.rm = FALSE, conf.interval = 0.95, .drop = TRUE)
summarySE(data_1, "device_tierAndroid.tier.4", groupvars = c("test_bucket"), na.rm = FALSE, conf.interval = 0.95, .drop = TRUE)
summarySE(data_1, "device_tierAndroid.tier.5", groupvars = c("test_bucket"), na.rm = FALSE, conf.interval = 0.95, .drop = TRUE)
summarySE(data_1, "country_tierCountry.tier.1", groupvars = c("test_bucket"), na.rm = FALSE, conf.interval = 0.95, .drop = TRUE)
summarySE(data_1, "country_tierCountry.tier.2", groupvars = c("test_bucket"), na.rm = FALSE, conf.interval = 0.95, .drop = TRUE)
summarySE(data_1, "country_tierCountry.tier.3", groupvars = c("test_bucket"), na.rm = FALSE, conf.interval = 0.95, .drop = TRUE)
summarySE(data_1, "country_tierCountry.tier.4", groupvars = c("test_bucket"), na.rm = FALSE, conf.interval = 0.95, .drop = TRUE)
summarySE(data_1, "country_tierCountry.tier.5", groupvars = c("test_bucket"), na.rm = FALSE, conf.interval = 0.95, .drop = TRUE)

# set $4.99 starter pack condition as reference
data_1$test_bucket <- factor(data_1$test_bucket)
data_1$test_bucket <- relevel(data_1$test_bucket, ref = "offer_on5")

# run models with different outcomes
random_ram <- lm(device_ram ~ test_bucket, data=data_1)
summary(random_ram)

random_device1 <- lm(data_1$"device_tierAndroid.tier.1" ~ data_1$test_bucket, data=data_1)
summary(random_device1)

random_device2 <- lm(data_1$"device_tierAndroid.tier.2" ~ data_1$test_bucket, data=data_1)
summary(random_device2)

random_device3 <- lm(data_1$"device_tierAndroid.tier.3" ~ data_1$test_bucket, data=data_1)
summary(random_device3)

random_device4 <- lm(data_1$"device_tierAndroid.tier.4" ~ data_1$test_bucket, data=data_1)
summary(random_device4)

random_device5 <- lm(data_1$"device_tierAndroid.tier.5" ~ data_1$test_bucket, data=data_1)
summary(random_device5)

random_country1 <- lm(data_1$"country_tierCountry.tier.1" ~ data_1$test_bucket, data=data_1)
summary(random_country1)

random_country2 <- lm(data_1$"country_tierCountry.tier.2" ~ data_1$test_bucket, data=data_1)
summary(random_country2)

random_country3 <- lm(data_1$"country_tierCountry.tier.3" ~ data_1$test_bucket, data=data_1)
summary(random_country3)

random_country4 <- lm(data_1$"country_tierCountry.tier.4" ~ data_1$test_bucket, data=data_1)
summary(random_country4)

random_country5 <- lm(data_1$"country_tierCountry.tier.5" ~ data_1$test_bucket, data=data_1)
summary(random_country5)


### for experiment 2

# set $4.99 starter pack condition as reference
data_2$test_bucket <- factor(data_2$test_bucket)
data_2$test_bucket <- relevel(data_2$test_bucket, ref = "Hold-out")

# run models with different outcomes
random_country1 <- lm(data_2$"country_tierCountry.tier.1" ~ data_2$test_bucket, data=data_2)
summary(random_country1)

random_country2 <- lm(data_2$"country_tierCountry.tier.2" ~ data_2$test_bucket, data=data_2)
summary(random_country2)

random_country3 <- lm(data_2$"country_tierCountry.tier.3" ~ data_2$test_bucket, data=data_2)
summary(random_country3)

random_country4 <- lm(data_2$"country_tierCountry.tier.4" ~ data_2$test_bucket, data=data_2)
summary(random_country4)


### for experiment 3b

# set $4.99 starter pack condition as reference
data_3b$test_bucket <- factor(data_3b$test_bucket)
data_3b$test_bucket <- relevel(data_3b$test_bucket, ref = "Hold-out")

# run models with different outcomes

random_device1 <- lm(data_3b$"device_tierAndroid.tier.1" ~ data_3b$test_bucket, data=data_3b)
summary(random_device1)

random_device2 <- lm(data_3b$"device_tierAndroid.tier.2" ~ data_3b$test_bucket, data=data_3b)
summary(random_device2)

random_device3 <- lm(data_3b$"device_tierAndroid.tier.3" ~ data_3b$test_bucket, data=data_3b)
summary(random_device3)

random_device4 <- lm(data_3b$"device_tierAndroid.tier.4" ~ data_3b$test_bucket, data=data_3b)
summary(random_device4)

random_device5 <- lm(data_3b$"device_tierAndroid.tier.5" ~ data_3b$test_bucket, data=data_3b)
summary(random_device5)

random_country1 <- lm(data_3b$"country_tierCountry.tier.1" ~ data_3b$test_bucket, data=data_3b)
summary(random_country1)

random_country2 <- lm(data_3b$"country_tierCountry.tier.2" ~ data_3b$test_bucket, data=data_3b)
summary(random_country2)

random_country3 <- lm(data_3b$"country_tierCountry.tier.3" ~ data_3b$test_bucket, data=data_3b)
summary(random_country3)

random_country4 <- lm(data_3b$"country_tierCountry.tier.4" ~ data_3b$test_bucket, data=data_3b)
summary(random_country4)



#################################################################
##### intent-to-treat values for outcome variables by condition #####
#################################################################

# set dataset to generate descriptives for
data <- data_1 # out of data_1, data_2, data_3b

# one-day measurement window

summarySE(data, "d1_offer_conversion", groupvars = c("test_bucket"), na.rm = FALSE, conf.interval = 0.95, .drop = TRUE)
summarySE(data, "d1_offer_revenue", groupvars = c("test_bucket"), na.rm = FALSE, conf.interval = 0.95, .drop = TRUE)
summarySE(data, "d1_conversion", groupvars = c("test_bucket"), na.rm = FALSE, conf.interval = 0.95, .drop = TRUE)
summarySE(data, "d1_revenue", groupvars = c("test_bucket"), na.rm = FALSE, conf.interval = 0.95, .drop = TRUE)
summarySE(data, "d1_rev_denoised", groupvars = c("test_bucket"), na.rm = FALSE, conf.interval = 0.95, .drop = TRUE)
summarySE(data, "d1_repeat_purchases", groupvars = c("test_bucket"), na.rm = FALSE, conf.interval = 0.95, .drop = TRUE)
summarySE(data, "d1_minutes", groupvars = c("test_bucket"), na.rm = FALSE, conf.interval = 0.95, .drop = TRUE)
summarySE(data, "d1_sessions", groupvars = c("test_bucket"), na.rm = FALSE, conf.interval = 0.95, .drop = TRUE)
summarySE(data, "d1_rounds_played", groupvars = c("test_bucket"), na.rm = FALSE, conf.interval = 0.95, .drop = TRUE)
summarySE(data, "d1_retention", groupvars = c("test_bucket"), na.rm = FALSE, conf.interval = 0.95, .drop = TRUE)
summarySE(data, "d1_ad_views", groupvars = c("test_bucket"), na.rm = FALSE, conf.interval = 0.95, .drop = TRUE)

# one-week measurement window

summarySE(data, "d7_offer_conversion", groupvars = c("test_bucket"), na.rm = FALSE, conf.interval = 0.95, .drop = TRUE)
summarySE(data, "d7_offer_revenue", groupvars = c("test_bucket"), na.rm = FALSE, conf.interval = 0.95, .drop = TRUE)
summarySE(data, "d7_conversion", groupvars = c("test_bucket"), na.rm = FALSE, conf.interval = 0.95, .drop = TRUE)
summarySE(data, "d7_revenue", groupvars = c("test_bucket"), na.rm = FALSE, conf.interval = 0.95, .drop = TRUE)
summarySE(data, "d7_rev_denoised", groupvars = c("test_bucket"), na.rm = FALSE, conf.interval = 0.95, .drop = TRUE)
summarySE(data, "d7_repeat_purchases", groupvars = c("test_bucket"), na.rm = FALSE, conf.interval = 0.95, .drop = TRUE)
summarySE(data, "d7_minutes", groupvars = c("test_bucket"), na.rm = FALSE, conf.interval = 0.95, .drop = TRUE)
summarySE(data, "d7_sessions", groupvars = c("test_bucket"), na.rm = FALSE, conf.interval = 0.95, .drop = TRUE)
summarySE(data, "d7_rounds_played", groupvars = c("test_bucket"), na.rm = FALSE, conf.interval = 0.95, .drop = TRUE)
summarySE(data, "d7_retention", groupvars = c("test_bucket"), na.rm = FALSE, conf.interval = 0.95, .drop = TRUE)
summarySE(data, "d7_ad_views", groupvars = c("test_bucket"), na.rm = FALSE, conf.interval = 0.95, .drop = TRUE)

# one-month measurement window

summarySE(data, "d30_offer_conversion", groupvars = c("test_bucket"), na.rm = FALSE, conf.interval = 0.95, .drop = TRUE)
summarySE(data, "d30_offer_revenue", groupvars = c("test_bucket"), na.rm = FALSE, conf.interval = 0.95, .drop = TRUE)
summarySE(data, "d30_conversion", groupvars = c("test_bucket"), na.rm = FALSE, conf.interval = 0.95, .drop = TRUE)
summarySE(data, "d30_revenue", groupvars = c("test_bucket"), na.rm = FALSE, conf.interval = 0.95, .drop = TRUE)
summarySE(data, "d30_rev_denoised", groupvars = c("test_bucket"), na.rm = FALSE, conf.interval = 0.95, .drop = TRUE)
summarySE(data, "d30_repeat_purchases", groupvars = c("test_bucket"), na.rm = FALSE, conf.interval = 0.95, .drop = TRUE)
summarySE(data, "d30_minutes", groupvars = c("test_bucket"), na.rm = FALSE, conf.interval = 0.95, .drop = TRUE)
summarySE(data, "d30_sessions", groupvars = c("test_bucket"), na.rm = FALSE, conf.interval = 0.95, .drop = TRUE)
summarySE(data, "d30_rounds_played", groupvars = c("test_bucket"), na.rm = FALSE, conf.interval = 0.95, .drop = TRUE)
summarySE(data, "d30_retention", groupvars = c("test_bucket"), na.rm = FALSE, conf.interval = 0.95, .drop = TRUE)
summarySE(data, "d30_ad_views", groupvars = c("test_bucket"), na.rm = FALSE, conf.interval = 0.95, .drop = TRUE)



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
qte_3vs5_1 <- ci.qtet(d30_revenue ~ treat_offer3,
                      data=filter(data_1,data_1$test_bucket=="offer_on3" | data_1$test_bucket=="offer_on5"),
                      probs=seq(.97,.9995,.0005), 
                      se=T,
                      iters=10)
summary(qte_3vs5_1)
plot_3vs5_1 <- ggqte(qte_3vs5_1, main = "97th ($0) to 99.95th (~$750) quantile") + xlim(.97,.9995) + ylim(-500,300) + xlab("Quantiles of one-month revenue distribution") + ylab("QTE in one-month revenue in $")


qte_3vs5_2 <- ci.qtet(d30_revenue ~ treat_offer3,
                      data=filter(data_1,data_1$test_bucket=="offer_on3" | data_1$test_bucket=="offer_on5"),
                      probs=seq(.97,.995,.0005), 
                      se=T,
                      iters=10)
summary(qte_3vs5_2)
plot_3vs5_2 <- ggqte(qte_3vs5_2, main = "97th ($0) to 99.5th (~$80) quantile") + xlim(.97,.995) + ylim(-20,30) + xlab("Quantiles of one-month revenue distribution") + ylab("QTE in one-month revenue in $")


qte_3vs5_3 <- ci.qtet(d30_revenue ~ treat_offer3,
                      data=filter(data_1,data_1$test_bucket=="offer_on3" | data_1$test_bucket=="offer_on5"),
                      probs=seq(.97,.985,.0005), 
                      se=T,
                      iters=10)
summary(qte_3vs5_3)
plot_3vs5_3 <- ggqte(qte_3vs5_3, main = "97th ($0) to 98.5th (~$9) quantile") + xlim(.97,.985) + ylim(-10,7) + xlab("Quantiles of one-month revenue distribution") + ylab("QTE in one-month revenue in $")


# get qte for comparison of $29.99 to $4.99 starter pack condition
qte_30vs5_1 <- ci.qtet(d30_revenue ~ treat_offer30,
                       data=filter(data_1,data_1$test_bucket=="offer_on30" | data_1$test_bucket=="offer_on5"),
                       probs=seq(.97,.9995,.0005), 
                       se=T,
                       iters=10)
summary(qte_30vs5_1)
plot_30vs5_1 <- ggqte(qte_30vs5_1, main = "97th ($0) to 99.95th (~$700) quantile") + xlim(.97,.9995) + ylim(-500,300) + xlab("Quantiles of one-month revenue distribution") + ylab("QTE in one-month revenue in $")


qte_30vs5_2 <- ci.qtet(d30_revenue ~ treat_offer30,
                       data=filter(data_1,data_1$test_bucket=="offer_on30" | data_1$test_bucket=="offer_on5"),
                       probs=seq(.97,.995,.0005), 
                       se=T,
                       iters=10)
summary(qte_30vs5_2)
plot_30vs5_2 <- ggqte(qte_30vs5_2, main = "97th ($0) to 99.5th (~$85) quantile") + xlim(.97,.995) + ylim(-20,30) + xlab("Quantiles of one-month revenue distribution") + ylab("QTE in one-month revenue in $")


qte_30vs5_3 <- ci.qtet(d30_revenue ~ treat_offer30,
                       data=filter(data_1,data_1$test_bucket=="offer_on30" | data_1$test_bucket=="offer_on5"),
                       probs=seq(.97,.985,.0005), 
                       se=T,
                       iters=10)
summary(qte_30vs5_3)
plot_30vs5_3 <- ggqte(qte_30vs5_3, main = "97th ($0) to 98.5th (~$10) quantile") + xlim(.97,.985) + ylim(-10,7) + xlab("Quantiles of one-month revenue distribution") + ylab("QTE in one-month revenue in $")

# arrange plots in one figure
grid.arrange(plot_3vs5_1, plot_30vs5_1, plot_3vs5_2, plot_30vs5_2, plot_3vs5_3, plot_30vs5_3,
             ncol = 2, nrow = 3,
             top = ("$2.99 compared to $4.99                                                          $29.99 compared to $4.99"))



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
quantile(data_3b$d30_revenue, probs = .979)
quantile(data_3b$d30_revenue, probs = .983)
quantile(data_3b$d30_revenue, probs = .99)
quantile(data_3b$d30_revenue, probs = .999)

# get qte for comparison of $2.99 to $4.99 starter pack condition
qte_persvsflat_1 <- ci.qtet(d30_revenue ~ pers_skim,
                      data=data_3b,
                      probs=seq(.977,.999,.0005), 
                      se=T,
                      iters=30)
summary(qte_persvsflat_1)
plotpersvsflat_1 <- ggqte(qte_persvsflat_1, main = "97th ($0) to 99.9th (~$430) quantile") + xlim(.977,.998) + ylim(-70,100) + xlab("Quantiles of one-month revenue distribution") + ylab("QTE in one-month revenue in $")

qte_persvsflat_2 <- ci.qtet(d30_revenue ~ pers_skim,
                            data=data_3b,
                            probs=seq(.977,.995,.0005), 
                            se=T,
                            iters=30)
summary(qte_persvsflat_2)
plotpersvsflat_2 <- ggqte(qte_persvsflat_2, main = "97th ($0) to 99.5th (~$75) quantile") + xlim(.977,.995) + ylim(-20,40) + xlab("Quantiles of one-month revenue distribution") + ylab("QTE in one-month revenue in $")

qte_persvsflat_3 <- ci.qtet(d30_revenue ~ pers_skim,
                            data=data_3b,
                            probs=seq(.977,.983,.0005), 
                            se=T,
                            iters=30)
summary(qte_persvsflat_3)
plotpersvsflat_3 <- ggqte(qte_persvsflat_3, main = "97th ($0) to 98.3rd (~$6) quantile") + xlim(.977,.983) + ylim(-5,10) + xlab("Quantiles of one-month revenue distribution") + ylab("QTE in one-month revenue in $")

# arrange plots in one figure
grid.arrange(plotpersvsflat_1, plotpersvsflat_2, plotpersvsflat_3,
             ncol = 1, nrow = 3,
             top = ("Quantile treatment effects of personalized skimming versus $4.99 flat-price"))
grid.arrange(plotpersvsflat_1, plotpersvsflat_2, plotpersvsflat_3,
             ncol = 3, nrow = 1,
             top = ("Quantile treatment effects of personalized skimming versus $4.99 flat-price"))


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
