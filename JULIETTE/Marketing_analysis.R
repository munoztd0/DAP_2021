
data <- read.table("marketing_campaign.csv", header=T, sep="\t")
View(data)

data$age <- 2021 - data$Year_Birth
summary(data)
as.factor(data$Marital_Status)
which(data$Marital_Status=="absurd")
mean(data$age)
