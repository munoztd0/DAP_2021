
# 1) Overview

data <- read.table("marketing_campaign.csv", header=T, sep="\t")
View(data)
summary(data)
str(data)
mean(data$age)
mean(data$income)

#plot tout
data %>% 
  keep(is.numeric) %>%
  gather() %>%
  ggplot(aes(value)) +
  facet_wrap(~key, scales = "free") + 
  geom_histogram()


library(gtsummary)
data[c("Marital_Status")] %>% tbl_summary()



# 2) Clearing

data$Complain <- data$NumWebVisitsMonth <- data$NumWebPurchases <- data$NumCatalogPurchases <- data$Z_Revenue <- data$Z_CostContact <- NULL

data$AcceptedCmpTotal <- data$AcceptedCmp1 + data$AcceptedCmp2 + data$AcceptedCmp3 + data$AcceptedCmp4 + data$AcceptedCmp5 + data$Response 
data$AcceptedCmp1 <- data$AcceptedCmp2 <- data$AcceptedCmp3 <- data$AcceptedCmp4 <- data$AcceptedCmp5 <- data$Response <- NULL

data$age <- 2014 - data$Year_Birth
max(data$age)
which(data$age==121)
data$Year_Birth[240] <- 1993
# data$Marital_Status[data$Marital_Status=="Absurd"] <- NA
# which(is.na(data))

data$Marital_Status <-  as.factor(data$Marital_Status)
data$Education <- as.factor(data$Education)
data$Kidhome <-  as.factor(data$Kidhome)
data$Teenhome <-  as.factor(data$Teenhome)
data$AcceptedCmpTotal <-  as.factor(data$AcceptedCmpTotal)
levels(data$Marital_Status) <- c("Other", "Single", "Single", "Married", "Single", "Together", "Single", "Other")
levels(data$AcceptedCmpTotal)


# 3) Hypotheses 

library(ggplot2)
ggplot(data, aes(KidHome, MntSweetProducts)) + geom_point()
ggplot(data, aes(MntWines, Marital_Status)) + geom_boxplot()


m1 <- lm(data=data, NumStorePurchases ~ Kidhome + Income*Education)
summary(m1)

m2 <- lm(data=data, NumDealsPurchases ~ Income*Education + Kidhome + MntGoldProds)
summary(m2)
