# define dataset for merge
data <- data_3b # data_2

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

# create gdp per capita quintile variable
quantile(data$gdp_p_capita_2017, probs = .2)
quantile(data$gdp_p_capita_2017, probs = .4)
quantile(data$gdp_p_capita_2017, probs = .6)
quantile(data$gdp_p_capita_2017, probs = .8)

data$gdp_p_cap_quintiles <- 1
data$gdp_p_cap_quintiles[data$gdp_p_capita_2017>=10743.1 & data$gdp_p_capita_2017<14224.85] <- 2
data$gdp_p_cap_quintiles[data$gdp_p_capita_2017>=14224.85 & data$gdp_p_capita_2017<31952.98] <- 3
data$gdp_p_cap_quintiles[data$gdp_p_capita_2017>=31952.98 & data$gdp_p_capita_2017<48223.16] <- 4
data$gdp_p_cap_quintiles[data$gdp_p_capita_2017>=48223.16] <- 5

# delete actual gdp per capita
data$gdp_p_capita_2017 <- NULL

