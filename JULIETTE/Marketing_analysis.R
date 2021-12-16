#this is to check to see if package are installed and if not to install them or just load them if they are installed!
if(!require(pacman)) {
  install.packages("pacman")
  library(pacman)
}
pacman::p_load(tidyverse, gtsummary, rcompanion, moments) #this is all the packages with need here



# 1) Overview

data <- read.table("marketing_campaign.csv", header=T, sep="\t")
View(data)
summary(data)
str(data)


#plot tout
data %>% 
  keep(is.numeric) %>%
  gather() %>%
  ggplot(aes(value)) +
  facet_wrap(~key, scales = "free") + 
  geom_histogram()



data[c("Marital_Status")] %>% gtsummary::tbl_summary()



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

install.packages("moments")
library(ggpubr)
library(moments)
#assymetric data
skewness(data$NumDealsPurchases, na.rm = TRUE)

# data$InvNumDealsPurchases <- 1/data$NumDealsPurchases
# hist(data$InvNumDealsPurchases)

#data$LogNumDealsPurchases <- log10(data$NumDealsPurchases)
# hist(data$LogNumDealsPurchases)

data$SQRTNumDealsPurchases <- sqrt(data$NumDealsPurchases)
hist(data$SQRTNumDealsPurchases)
skewness(data$SQRTNumDealsPurchases)
str(data$SQRTNumDealsPurchases)
hist(data$SQRTNumDealsPurchases)
boxplot(data$SQRTNumDealsPurchases)
max(data$SQRTNumDealsPurchases)


# 3) Hypotheses 


library(ggplot2)
ggplot(data, aes(Kidhome, MntSweetProducts)) + geom_point()
ggplot(data, aes(MntWines, Marital_Status)) + geom_boxplot()


m1 <- lm(data=data, SQRTNumDealsPurchases ~ Income + Education + Kidhome + MntGoldProds + MntWines + MntMeatProducts + MntFishProducts + MntSweetProducts + MntFruits)
summary(m1) #not satisfying

m2 <- lm(data=data, Income ~ Education + Marital_Status + NumDealsPurchases + Kidhome + MntGoldProds + MntWines + MntMeatProducts + MntFishProducts + MntSweetProducts + MntFruits)
summary(m2)

ggplot(data, aes(Kidhome, MntSweetProducts))+ geom_boxplot(outlier.colour =  "red") #+  geom_point(position = position_jitter()) 

ggplot(data, aes(MntWines, Marital_Status)) + geom_boxplot(outlier.colour =  "red")

#alternative with violin plots
ggplot(data, aes(x=MntWines, y=Marital_Status)) +
  geom_violin(trim=FALSE, fill='#A4A4A4', color="darkred")+
  geom_boxplot(width=0.05) + theme_minimal()


#### Visual check normality
rcompanion::plotNormalHistogram(data$NumStorePurchases, main = "Purchases", sub = paste("skewness =", round(moments::skewness(data$NumStorePurchases, na.rm = TRUE),2))) # for NumStorePurchases

rcompanion::plotNormalHistogram(data$NumDealsPurchases, main = "Deals", sub = paste("skewness =", round(moments::skewness(data$NumDealsPurchases, na.rm = TRUE),2))) # for NumDealsPurchases -> Bad!

rcompanion::plotNormalHistogram(sqrt(data$NumDealsPurchases), main = "Deals", sub = paste("skewness =", round(moments::skewness(sqrt(data$NumDealsPurchases), na.rm = TRUE),2))) # for NumDealsPurchases -> Much better!


#### Modeling
m1 <- lm(data=data, NumStorePurchases ~ Kidhome + Income*Education)
summary(m1)

m3 <- lm(data=data, sqrt(NumDealsPurchases) ~ Income*Education + Kidhome + MntGoldProds)
summary(m2)

m4 <- lm(data=data, Income ~ Education + NumDealsPurchases + Kidhome + MntWines + MntMeatProducts + MntFishProducts + MntSweetProducts + MntFruits)
summary(m4)

autoplot 
MASS::stepAIC()