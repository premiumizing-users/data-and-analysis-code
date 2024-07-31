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
