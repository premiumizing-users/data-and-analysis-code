# load required packages and set up
pkgs <- list("glmnet", "doParallel", "foreach", "pROC", "gplots", "bigrquery", "pwr", "dplyr", "caret", "sm", "ggplot2", "scales", "reshape2", "Hmisc", "bayesAB")
lapply(pkgs, require, character.only = T)
registerDoParallel(cores = 4)

# pull data from database
sql <- gsub("[\r\n]", " ", sql)
sql_query_execute <- query_exec(sql, project = project, max_pages = Inf, use_legacy_sql=FALSE)
data <- sql_query_execute

# replace missings with 0 for null revenue value based calcs
data[is.na(data)] <- 0

# add combined offer revenue (from step1 and step2 of the offer)
data$d1_offer_revenue <- data$d1_offer_step1_revenue + data$d1_offer_step2_revenue
data$d3_offer_revenue <- data$d3_offer_step1_revenue + data$d3_offer_step2_revenue
data$d7_offer_revenue <- data$d7_offer_step1_revenue + data$d7_offer_step2_revenue
data$d14_offer_revenue <- data$d14_offer_step1_revenue + data$d14_offer_step2_revenue
data$d30_offer_revenue <- data$d30_offer_step1_revenue + data$d30_offer_step2_revenue

# add offer conversion
data$d1_offer_conversion <- 0
data$d1_offer_conversion[data$d1_offer_revenue > 0] <- 1
data$d3_offer_conversion <- 0
data$d3_offer_conversion[data$d3_offer_revenue > 0] <- 1
data$d7_offer_conversion <- 0
data$d7_offer_conversion[data$d7_offer_revenue > 0] <- 1
data$d14_offer_conversion <- 0
data$d14_offer_conversion[data$d14_offer_revenue > 0] <- 1
data$d30_offer_conversion <- 0
data$d30_offer_conversion[data$d30_offer_revenue > 0] <- 1

# add repeat purchases
data$d1_repeat_purchases <- data$d1_purchases-1
data$d1_repeat_purchases[data$d1_repeat_purchases<0] <- 0
data$d3_repeat_purchases <- data$d3_purchases-1
data$d3_repeat_purchases[data$d3_repeat_purchases<0] <- 0
data$d7_repeat_purchases <- data$d7_purchases-1
data$d7_repeat_purchases[data$d7_repeat_purchases<0] <- 0
data$d30_repeat_purchases <- data$d30_purchases-1
data$d30_repeat_purchases[data$d30_repeat_purchases<0] <- 0

# add upper-end winsorized revenue
# set percentile for winsorization
d <- .98
data$d1_rev_denoised <- data$d1_revenue
data$d1_rev_denoised[data$d1_revenue > quantile(filter(data,d1_revenue > 0)$d1_revenue, c(d))] <- quantile(filter(data,d1_revenue > 0)$d1_revenue, c(d))
data$d7_rev_denoised <- data$d7_revenue
data$d7_rev_denoised[data$d7_revenue > quantile(filter(data,d7_revenue > 0)$d7_revenue, c(d))] <- quantile(filter(data,d7_revenue > 0)$d7_revenue, c(d))
data$d30_rev_denoised <- data$d30_revenue
data$d30_rev_denoised[data$d30_revenue > quantile(filter(data,d30_revenue > 0)$d30_revenue, c(d))] <- quantile(filter(data,d30_revenue > 0)$d30_revenue, c(d))

# one hot encode device and country tiers
encoded_vars <- model.matrix(~ device_tier + country_tier - 1, data = data)
encoded_df <- as.data.frame(encoded_vars)
data <- cbind(data, encoded_df)

# full matrix model failed due to memory exhausted, add missing reference category manually
data$"country_tierCountry tier 1" <- data$"country_tierCountry tier 2" + data$"country_tierCountry tier 3" + data$"country_tierCountry tier 4"
data$"country_tierCountry tier 1" <- data$"country_tierCountry tier 1"*2
data$"country_tierCountry tier 1"[data$"country_tierCountry tier 1"==0] <- 1 
data$"country_tierCountry tier 1"[data$"country_tierCountry tier 1"==2] <- 0

# remove spaces from new column names
names(data)[names(data) == "device_tierAndroid tier 1"] <- "device_tierAndroid.tier.1"
names(data)[names(data) == "device_tierAndroid tier 2"] <- "device_tierAndroid.tier.2"
names(data)[names(data) == "device_tierAndroid tier 3"] <- "device_tierAndroid.tier.3"
names(data)[names(data) == "device_tierAndroid tier 4"] <- "device_tierAndroid.tier.4"
names(data)[names(data) == "device_tierAndroid tier 5"] <- "device_tierAndroid.tier.5"
names(data)[names(data) == "country_tierCountry tier 1"] <- "country_tierCountry.tier.1"
names(data)[names(data) == "country_tierCountry tier 2"] <- "country_tierCountry.tier.2"
names(data)[names(data) == "country_tierCountry tier 3"] <- "country_tierCountry.tier.3"
names(data)[names(data) == "country_tierCountry tier 4"] <- "country_tierCountry.tier.4"

# export csv
write.csv(data,"experiment3b_data_prepped.csv")
