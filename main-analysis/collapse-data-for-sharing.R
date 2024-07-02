# install and load the dplyr package if not already installed
#install.packages("dplyr")
library(dplyr)

# set working directory
setwd("/Users/jr/Dropbox/Research/A_Promotion Targeting CB Freemium/Data/Clean data rewrite 2024")

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

### dataset for experiment 1
# define grouping columns
grouping_columns <- c("test_bucket", "device_tier", "country_tier_new")

# define columns to be excluded from mean and sd calculations
excluded_columns <- c("unique_id", "join_date", "join_ts",
                      "country", "country_tier", "device_os", 
                      "device_make", "device_model", "device_gpu", "device_cpu",
                      "device_tierAndroid.tier.1", "device_tierAndroid.tier.2",
                      "device_tierAndroid.tier.3", 
                      "device_tierAndroid.tier.4", "device_tierAndroid.tier.5", 
                      "country_tierCountry.tier.2", "country_tierCountry.tier.3", 
                      "country_tierCountry.tier.4", "country_tierCountry.tier.5", 
                      "country_tierCountry.tier.1")

# define the variables to be collapsed
variables_to_collapse <- setdiff(names(data_1), c(grouping_columns, excluded_columns))

# collapse dataset by Category retaining mean and standard deviation
collapsed_data_1 <- data_1 %>%
  group_by(across(all_of(grouping_columns))) %>%
  summarise(
    unique_id_count = n(),
    across(all_of(variables_to_collapse), list(mean = ~ mean(.x, na.rm = TRUE), sd = ~ sd(.x, na.rm = TRUE)), .names = "{.col}_{.fn}")
  ) %>%
  ungroup()

### dataset for experiment 2
# define grouping columns
grouping_columns <- c("test_bucket", "country_tier")

# define columns to be excluded from mean and sd calculations
excluded_columns <- c("unique_id", "country_tierCountry.tier.2", "country_tierCountry.tier.3", 
                      "country_tierCountry.tier.4", "country_tierCountry.tier.1")

# define the variables to be collapsed
variables_to_collapse <- setdiff(names(data_2), c(grouping_columns, excluded_columns))

# collapse dataset by Category retaining mean and standard deviation
collapsed_data_2 <- data_2 %>%
  group_by(across(all_of(grouping_columns))) %>%
  summarise(
    unique_id_count = n(),
    across(all_of(variables_to_collapse), list(mean = ~ mean(.x, na.rm = TRUE), sd = ~ sd(.x, na.rm = TRUE)), .names = "{.col}_{.fn}")
  ) %>%
  ungroup()

### dataset for experiment 3b
# define grouping columns
grouping_columns <- c("test_bucket", "device_tier", "country_tier")

# define columns to be excluded from mean and sd calculations
excluded_columns <- c("unique_id", "device_os",
                      "device_tierAndroid.tier.1", "device_tierAndroid.tier.2",
                      "device_tierAndroid.tier.3", 
                      "device_tierAndroid.tier.4", "device_tierAndroid.tier.5", 
                      "country_tierCountry.tier.2", "country_tierCountry.tier.3", 
                      "country_tierCountry.tier.4", "country_tierCountry.tier.1")

# define the variables to be collapsed
variables_to_collapse <- setdiff(names(data_3b), c(grouping_columns, excluded_columns))

# collapse dataset by Category retaining mean and standard deviation
collapsed_data_3b <- data_3b %>%
  group_by(across(all_of(grouping_columns))) %>%
  summarise(
    unique_id_count = n(),
    across(all_of(variables_to_collapse), list(mean = ~ mean(.x, na.rm = TRUE), sd = ~ sd(.x, na.rm = TRUE)), .names = "{.col}_{.fn}")
  ) %>%
  ungroup()

# export csvs
write.csv(collapsed_data_1,"Experiment 1 - Low-Mid-High/experiment1_data_collapsed.csv")
write.csv(collapsed_data_2,"Experiment 2 - Simple-Skimming/experiment2_data_collapsed.csv")
write.csv(collapsed_data_3b,"Experiment 3 - Personalized-Skimming/Experiment 3b/experiment3b_data_collapsed.csv")

### for experiment 3a

# read in data
setwd("/Users/jr/Dropbox/Research/A_Promotion Targeting CB Freemium/Data/Clean data rewrite 2024/Experiment 3 - Personalized-Skimming/Experiment 3a")
for (d in c(2, 4, 6, 8, 10, 12)){
  eval(parse(text=paste0("d",d,"_data <- read.csv(file = 'price-path-experimentation_d",d,".csv')")))
}

# create a loop to process each dataset
for (d in c(2, 4, 6, 8, 10, 12)) {
  # convert relevant columns to factors
  eval(parse(text=paste0("d", d, "_data$device_tier <- as.factor(d", d, "_data$device_tier)")))
  eval(parse(text=paste0("d", d, "_data$country_tier <- as.factor(d", d, "_data$country_tier)")))
  
  # define the grouping columns and excluded columns
  grouping_columns <- c("action", "device_tier", "country_tier")
  excluded_columns <- c("prior_action", "probability")
  
  # define the variables to be collapsed
  variables_to_collapse <- setdiff(names(eval(parse(text=paste0("d", d, "_data")))), c(grouping_columns, excluded_columns))
  
  # collapse dataset by Category retaining mean and standard deviation
  collapsed_data <- eval(parse(text=paste0("d", d, "_data"))) %>%
    group_by(across(all_of(grouping_columns))) %>%
    summarise(
      unique_id_count = n(),
      across(all_of(variables_to_collapse), list(mean = ~ mean(.x, na.rm = TRUE), sd = ~ sd(.x, na.rm = TRUE)), .names = "{.col}_{.fn}")
    ) %>%
    ungroup()
  
  # assign the collapsed dataset back to a variable
  eval(parse(text=paste0("collapsed_d", d, "_data <- collapsed_data")))
  
  # export the collapsed dataset as a csv
  file_name <- paste0("experiment3a_d", d, "_data_collapsed.csv")
  write.csv(collapsed_data, file_name, row.names = FALSE)
}
