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

# remove unrealistic device ram values
data$device_ram[data$device_ram>7871] <- 7871

# recode device ram to gigabyte
data$device_ram <- data$device_ram/1000

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

# format date structure
data$join_date <- as.Date(data$join_date, format = "%Y-%m-%d")

# add upper-end winsorized revenue
# set percentile for winsorization
d <- .98
data$d1_rev_denoised <- data$d1_revenue
data$d1_rev_denoised[data$d1_revenue > quantile(filter(data,d1_revenue > 0)$d1_revenue, c(d))] <- quantile(filter(data,d1_revenue > 0)$d1_revenue, c(d))
data$d7_rev_denoised <- data$d7_revenue
data$d7_rev_denoised[data$d7_revenue > quantile(filter(data,d7_revenue > 0)$d7_revenue, c(d))] <- quantile(filter(data,d7_revenue > 0)$d7_revenue, c(d))
data$d30_rev_denoised <- data$d30_revenue
data$d30_rev_denoised[data$d30_revenue > quantile(filter(data,d30_revenue > 0)$d30_revenue, c(d))] <- quantile(filter(data,d30_revenue > 0)$d30_revenue, c(d))

# add repeat purchases
data$d1_repeat_purchases <- data$d1_purchases-1
data$d1_repeat_purchases[data$d1_repeat_purchases<0] <- 0
data$d3_repeat_purchases <- data$d3_purchases-1
data$d3_repeat_purchases[data$d3_repeat_purchases<0] <- 0
data$d7_repeat_purchases <- data$d7_purchases-1
data$d7_repeat_purchases[data$d7_repeat_purchases<0] <- 0
data$d14_repeat_purchases <- data$d14_purchases-1
data$d14_repeat_purchases[data$d14_repeat_purchases<0] <- 0
data$d30_repeat_purchases <- data$d30_purchases-1
data$d30_repeat_purchases[data$d30_repeat_purchases<0] <- 0

# read in world development indicator gdp data
gdp_data <- read.csv("API_NY.GDP.PCAP.CD_DS2_en_csv_v2_10515199.csv",
                     header=TRUE,
                     sep=",",
                     skip=4)

gdp_data$Country.Code2 <- substr(gdp_data$Country.Code, 0, 2)

# subset to relevant vars
gdp_sub <- gdp_data[c("Country.Code2", "X2017")]

# delete rows with missing on 2017 gdp per capita
gdp_sub2 <- gdp_sub[complete.cases(gdp_sub), ]

# aggregate by duplicate country codes using mean
gdp_sub3 <- aggregate(gdp_sub2$X2017, list(gdp_sub2$Country.Code2), mean)

# merge gdp into analysis data and rename column
data <- merge(x=data, y=gdp_sub3, by.x="country", by.y="Group.1", all.x=TRUE)
colnames(data)[colnames(data)=="x"] <- "gdp_p_capita_2017"

# impute mean for missing gdp
data$gdp_p_capita_2017[is.na(data$gdp_p_capita_2017)==TRUE] <- mean(data$gdp_p_capita_2017, na.rm=TRUE)

# add new country tiers
data$country_tier_new <- "Country tier 4"
data$country_tier_new[data$country %in% c('CN','CY','NO','DK','HK','KW','NZ','CH','PR','TW','AT','US','JP','KR')] <- "Country tier 1"
data$country_tier_new[data$country %in% c('GB','QA','NL','GE','SG','MY','SE','IE','DE','AU','CA','LT','RS','SI','FR','FI','EE','BE','LU')] <- "Country tier 2"
data$country_tier_new[data$country %in% c('UZ','VN','HR','IT','IS','ZA','GR','IN','SK','IQ','PT','BH','KZ','TH','MM','CZ','AE','ES','KH','RU')] <- "Country tier 3"

# one hot encode (old) device and country tiers
encoded_vars <- model.matrix(~ device_tier + country_tier - 1, data = data)
encoded_df <- as.data.frame(encoded_vars)
data <- cbind(data, encoded_df)

# full matrix model failed due to memory exhausted, add missing reference category manually
data$"country_tierCountry tier 1" <- data$"country_tierCountry tier 2" + data$"country_tierCountry tier 3" + data$"country_tierCountry tier 4" + data$"country_tierCountry tier 5"
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

# drop control group where starter pack was off as not useful to or used in analysis
data <- subset(data, test_bucket != "offer_off")

# export csv
write.csv(data,"experiment1_data_prepped.csv")
