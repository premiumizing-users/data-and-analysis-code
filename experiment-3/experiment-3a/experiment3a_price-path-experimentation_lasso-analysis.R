# load required packages
pkgs <- list("glmnet", "doParallel", "foreach", "pROC", "gplots", "bigrquery", "pwr", "dplyr", "caret", "sm", "ggplot2", "scales", "reshape2", "Hmisc", "bayesAB")
lapply(pkgs, require, character.only = T)
registerDoParallel(cores = 4)

# read in data
setwd("experiment-3/experiment-3a")
for (d in c(2, 4, 6, 8, 10, 12)){
  eval(parse(text=paste0("d",d,"_data <- read.csv(file = 'price-path-experimentation_d",d,".csv')")))
}

# format data
for (d in c(2, 4, 6, 8, 10, 12)){
  eval(parse(text=paste0("d",d,"_data$device_tier <- as.factor(d",d,"_data$device_tier)")))
  eval(parse(text=paste0("d",d,"_data$country_tier <- as.factor(d",d,"_data$country_tier)",sep="")))
  eval(parse(text=paste0("d",d,"_data$prior_action <- as.factor(d",d,"_data$prior_action)",sep="")))
  eval(parse(text=paste0("d",d,"_data$action_dummy <- as.factor(d",d,"_data$action-1)",sep="")))
}

# add "clean" outcome (revenue for first three decision points to skim, conversion for latter three decision points to price-penetrate)

for (d in c(2, 4, 6)) {
  eval(parse(text=paste0("d", d, "_data$outcome_clean <- 0")))
  eval(parse(text=paste0("d", d, "_data$outcome_clean[d", d, "_data$outcome > 0] <- d", d, "_data$outcome[d", d, "_data$outcome > 0]")))
}

for (d in c(8, 10, 12)){
  eval(parse(text=paste0("d",d,"_data$outcome_clean <- 0")))
  eval(parse(text=paste0("d",d,"_data$outcome_clean[d",d,"_data$outcome>0] <- 1")))
}

for (d in c(2, 4, 6, 8, 10, 12)){
  eval(parse(text=paste0("d",d,"_data <- within(d",d,"_data, device_tier <- relevel(device_tier, ref = 'android_tier5'))")))
  eval(parse(text=paste0("d",d,"_data <- within(d",d,"_data, country_tier <- relevel(country_tier, ref = 'tier4'))")))
}


### randomization check
# one hot encode device and country tiers
for (d in c(2, 4, 6, 8, 10, 12)){
  eval(parse(text=paste0("encoded_vars <- model.matrix(~ device_tier + country_tier - 1, data = d",d,"_data)")))
  eval(parse(text=paste0("encoded_df <- as.data.frame(encoded_vars)")))
  eval(parse(text=paste0("d",d,"_data <- cbind(d",d,"_data, encoded_df)")))
}

# full matrix model failed due to memory exhausted, add missing reference category manually
for (d in c(2, 4, 6, 8, 10, 12)){
  eval(parse(text=paste0("d",d,"_data$country_tiertier4 <- d",d,"_data$country_tiertier1 + d",d,"_data$country_tiertier2 + d",d,"_data$country_tiertier3")))
  eval(parse(text=paste0("d",d,"_data$country_tiertier4 <- d",d,"_data$country_tiertier4*2")))
  eval(parse(text=paste0("d",d,"_data$country_tiertier4[d",d,"_data$country_tiertier4==0] <- 4")))
  eval(parse(text=paste0("d",d,"_data$country_tiertier4[d",d,"_data$country_tiertier4==2] <- 0")))
}

for (d in c(2, 4, 6, 8, 10, 12)){
  eval(parse(text=paste0("random_country1_d",d," <- lm(country_tiertier1 ~ action_dummy, data=d",d,"_data)")))
  eval(parse(text=paste0("print(summary(random_country1_d",d,"))")))
}

for (d in c(2, 4, 6, 8, 10, 12)){
  eval(parse(text=paste0("random_country2_d",d," <- lm(country_tiertier2 ~ action_dummy, data=d",d,"_data)")))
  eval(parse(text=paste0("print(summary(random_country2_d",d,"))")))
}

for (d in c(2, 4, 6, 8, 10, 12)){
  eval(parse(text=paste0("random_country3_d",d," <- lm(country_tiertier3 ~ action_dummy, data=d",d,"_data)")))
  eval(parse(text=paste0("print(summary(random_country3_d",d,"))")))
}

for (d in c(2, 4, 6, 8, 10, 12)){
  eval(parse(text=paste0("random_country4_d",d," <- lm(country_tiertier4 ~ action_dummy, data=d",d,"_data)")))
  eval(parse(text=paste0("print(summary(random_country4_d",d,"))")))
}

for (d in c(2, 4, 6, 8, 10, 12)){
  eval(parse(text=paste0("random_device1_d",d," <- lm(device_tierandroid_tier1 ~ action_dummy, data=d",d,"_data)")))
  eval(parse(text=paste0("print(summary(random_device1_d",d,"))")))
}

for (d in c(2, 4, 6, 8, 10, 12)){
  eval(parse(text=paste0("random_device2_d",d," <- lm(device_tierandroid_tier2 ~ action_dummy, data=d",d,"_data)")))
  eval(parse(text=paste0("print(summary(random_device2_d",d,"))")))
}

for (d in c(2, 4, 6, 8, 10, 12)){
  eval(parse(text=paste0("random_device3_d",d," <- lm(device_tierandroid_tier3 ~ action_dummy, data=d",d,"_data)")))
  eval(parse(text=paste0("print(summary(random_device3_d",d,"))")))
}

for (d in c(2, 4, 6, 8, 10, 12)){
  eval(parse(text=paste0("random_device4_d",d," <- lm(device_tierandroid_tier4 ~ action_dummy, data=d",d,"_data)")))
  eval(parse(text=paste0("print(summary(random_device4_d",d,"))")))
}

for (d in c(2, 4, 6, 8, 10, 12)){
  eval(parse(text=paste0("random_device5_d",d," <- lm(device_tierandroid_tier5 ~ action_dummy, data=d",d,"_data)")))
  eval(parse(text=paste0("print(summary(random_device5_d",d,"))")))
}

##### run simple regression // action dummy: 0 --> drop, 1 --> keep

### see what action is recommended at each decision stage
for (d in c(2, 4, 6, 8, 10, 12)){
  eval(parse(text=paste0("action_matters",d," <- lm(outcome_clean ~ action_dummy, data=d",d,"_data)")))
  eval(parse(text=paste0("print(summary(action_matters",d,"))")))
}

### see what action is recommended at each decision stage by device and country segments
for (d in c(2, 4, 6, 8, 10, 12)){
  eval(parse(text=paste0("action_matters",d," <- lm(outcome_clean ~ action_dummy * device_tier + action_dummy * country_tier, data=d",d,"_data)")))
  eval(parse(text=paste0("print(summary(action_matters",d,"))")))
}


##### lasso using glmnet and caret
covar_lasso <- trainControl(method="cv", number=5, returnResamp="all")

set.seed(94104)
for (d in c(2, 4, 6, 8, 10, 12)){
  eval(parse(text=paste0("covariates_cv_lasso",d," <- train(outcome_clean ~
                             + device_tier * action_dummy
                             + country_tier * action_dummy
                             + sessions * action_dummy
                             + rounds * action_dummy
                             + ingame_transactions * action_dummy
                             + gift_claims * action_dummy
                             + ad_views * action_dummy
                             + friend_thanks * action_dummy
                             + messages * action_dummy
                             + boss_claims * action_dummy
                             + gifts_sent * action_dummy,
                             #+ event_rounds * action_dummy,
                             data=d",d,"_data,
                             method = 'glmnet', 
                             trControl = covar_lasso,
                             #metric = 'RMSE',
                             metric = 'Rsquared',
                             tuneGrid = expand.grid(alpha = 1,
                                                    lambda = seq(0.001,0.1,by = 0.001)))"
  )))
  
  eval(parse(text=paste0("print(summary(covariates_cv_lasso",d,"))")))
  eval(parse(text=paste0("print(covariates_cv_lasso",d,"$bestTune)")))
  eval(parse(text=paste0("print(coef(covariates_cv_lasso",d,"$finalModel, covariates_cv_lasso",d,"$bestTune$lambda))")))
}

for (d in c(2, 4, 6, 8, 10, 12)){
  eval(parse(text=paste0("segments_cv_lasso",d," <- train(outcome_clean ~
                             + device_tier * action_dummy
                             + country_tier * action_dummy,
                             data=d",d,"_data,
                             method = 'glmnet', 
                             trControl = covar_lasso,
                             #metric = 'RMSE',
                             metric = 'Rsquared',
                             tuneGrid = expand.grid(alpha = 1,
                                                    lambda = seq(0.001,0.1,by = 0.001)))"
  )))
  
  eval(parse(text=paste0("print(summary(segments_cv_lasso",d,"))")))
  eval(parse(text=paste0("print(segments_cv_lasso",d,"$bestTune)")))
  eval(parse(text=paste0("print(coef(segments_cv_lasso",d,"$finalModel, segments_cv_lasso",d,"$bestTune$lambda))")))
}
