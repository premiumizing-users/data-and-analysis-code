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
