# load required packages and set up
pkgs <- list("glmnet", "doParallel", "foreach", "pROC", "gplots", "bigrquery", "pwr", "dplyr", "caret", "sm", "ggplot2", "scales", "reshape2", "Hmisc", "bayesAB")
lapply(pkgs, require, character.only = T)
registerDoParallel(cores = 4)

# get output data
project <- 'XXXXXXXXXXXXX'

sql2 <- "SELECT * FROM `app-schema-analytics.price-path-experimentation.d2_experiment`"

sql4 <- "SELECT * FROM `app-schema-analytics.price-path-experimentation.d4_experiment`"

sql6 <- "SELECT * FROM `app-schema-analytics.price-path-experimentation.d6_experiment`"

sql8 <- "SELECT * FROM `app-schema-analytics.price-path-experimentation.d8_experiment`"

sql10 <- "SELECT * FROM `app-schema-analytics.price-path-experimentation.d10_experiment`"

sql12 <- "SELECT * FROM `app-schema-analytics.price-path-experimentation.d12_experiment`"

sql2 <- gsub("[\r\n]", " ", sql2)
sql4 <- gsub("[\r\n]", " ", sql4)
sql6 <- gsub("[\r\n]", " ", sql6)
sql8 <- gsub("[\r\n]", " ", sql8)
sql10 <- gsub("[\r\n]", " ", sql10)
sql12 <- gsub("[\r\n]", " ", sql12)

sql_query_execute2 <- query_exec(sql2, project = project, max_pages = Inf, use_legacy_sql=FALSE)
sql_query_execute4 <- query_exec(sql4, project = project, max_pages = Inf, use_legacy_sql=FALSE)
sql_query_execute6 <- query_exec(sql6, project = project, max_pages = Inf, use_legacy_sql=FALSE)
sql_query_execute8 <- query_exec(sql8, project = project, max_pages = Inf, use_legacy_sql=FALSE)
sql_query_execute10 <- query_exec(sql10, project = project, max_pages = Inf, use_legacy_sql=FALSE)
sql_query_execute12 <- query_exec(sql12, project = project, max_pages = Inf, use_legacy_sql=FALSE)

d2_experiment_data <- sql_query_execute2
d4_experiment_data <- sql_query_execute4
d6_experiment_data <- sql_query_execute6
d8_experiment_data <- sql_query_execute8
d10_experiment_data <- sql_query_execute10
d12_experiment_data <- sql_query_execute12

# export data as csvs
setwd("NA")
for (d in c(2, 4, 6, 8, 10, 12)){
  eval(parse(text=paste0("write.csv(d",d,"_experiment_data, file = 'price-path-experimentation_d",d,".csv')")))
}
