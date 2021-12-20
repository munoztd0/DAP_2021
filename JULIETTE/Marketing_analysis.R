#this is to check to see if package are installed and if not to install them or just load them if they are installed!
if(!require(pacman)) {
  install.packages("pacman")
  library(pacman)
}
pacman::p_load(tidyverse, gtsummary, ggpubr, moments, here, sjPlot, parameters, effectsize) #this is all the packages with need here

#get relative path
path =  here("JULIETTE") #this is really important ! you juste need to put the name of YOUR folder and here() will find the relative path for you ! 
#or path =  dirname(rstudioapi::getActiveDocumentContext()$path) in R
setwd(path) #set working directory
# load data
data <- read.table("marketing_campaign.csv", header=T, sep="\t")


# 1) Overview
#View(data)
summary(data)
str(data)



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

data$Marital_Status <-  factor(data$Marital_Status, labels = c("Other", "Single", "Single", "Married", "Single", "Together", "Single", "Other"))
#here I remove "Other" because you only had 1% and that not enought information to model it a one factor
data$Marital_Status[data$Marital_Status=="Other"] <- NA; data$Marital_Status = droplevels( data$Marital_Status)
data$Education <- factor(data$Education, order = T)  #ordinal factor?
data$Kidhome <-  factor(data$Kidhome, labels = c("no", "yes", "yes"))
#here I fuse "1" and "2" because you only had 2% of "2"and that not enought information to model it a one separate factor, so no it is just a "yes or no" kids question
data$Teenhome <-  factor(data$Teenhome)
data$AcceptedCmpTotal <-  factor(data$AcceptedCmpTotal)


#plot tout
data %>% 
  keep(is.numeric) %>%
  gather() %>%
  ggplot(aes(value)) +
  facet_wrap(~key, scales = "free") + 
  geom_histogram()


# 3) Hypotheses 


ggplot(data, aes(Kidhome, MntSweetProducts)) + geom_boxplot()

data %>% 
      filter(!is.na(Marital_Status)) %>% # filter on non-missing values
      ggplot(aes(MntWines, Marital_Status)) + geom_boxplot(na.rm = TRUE)




ggplot(data, aes(Kidhome, MntSweetProducts))+ geom_boxplot(outlier.colour =  "red") #+  geom_point(position = position_jitter()) 

ggplot(data, aes(MntWines, Marital_Status)) + geom_boxplot(outlier.colour =  "red")

#alternative with violin plots
ggplot(data, aes(x=MntWines, y=Marital_Status)) +
  geom_violin(trim=FALSE, fill='#A4A4A4', color="darkred")+
  geom_boxplot(width=0.05) + theme_minimal()


#### Visual check normality #sans rcompanion
ggplot(data, aes(x = NumStorePurchases)) +
  geom_histogram(aes(y = ..density..),
                 colour = 1, fill = "white") +
  geom_density(adjust = 1) + labs(title = "Purchases",
 caption = paste("skewness =", round(moments::skewness(data$NumStorePurchases, na.rm = TRUE),2)))

ggplot(data, aes(x = NumDealsPurchases)) +
  geom_histogram(aes(y = ..density..),
                 colour = 1, fill = "white") +
  geom_density(adjust = 2) + labs(title = "Deals",
  caption = paste("skewness =", round(moments::skewness(data$NumDealsPurchases, na.rm = TRUE),2)))

ggplot(data, aes(x = sqrt(NumDealsPurchases))) +
  geom_histogram(aes(y = ..density..),
                 colour = 1, fill = "white") +
  geom_density(adjust = 2) + labs(title = "Square root Deals",
  caption = paste("skewness =", round(moments::skewness(sqrt(data$NumDealsPurchases), na.rm = TRUE),2))) # for NumDealsPurchases -> better but still not perfect!

#### Modeling

#1) creer full model
m1 <- lm(data=data, NumStorePurchases ~ Kidhome*Income*Education*age) #what about age ??
plot(m1, c(1:2,4), ask=F)

#check income outliers in more details
plot(Income ~NumStorePurchases, col="lightblue", pch=19, cex=2,data=newdf)
text(Income ~NumStorePurchases, labels=ID,data=newdf, cex=0.9, font=1)

#2) check assumptions  and assess outliers -> for example
data[c(2234),] #huge outlier and weird income = 666666 ? + weird effect after (Income > 150000 ) people dont respond !

newdf = data %>%
  filter(!ID %in% c(9432, 5555, 4619, 5336, 1501, 1503, 8475, 4931, 11181) ) #remove outliers

#3) reassess
m1 <- lm(data=newdf, NumStorePurchases ~ Kidhome*Income*Education) # without outlier
plot(m1, c(1:2,4), ask=F)

#4) choose variables/interactions to keep
ms <- MASS::stepAIC(m1, direction = "both", trace = FALSE) #il choisit le meilleur AIC
ms$anova

#5) compute final model
finalm1 <- lm(data=newdf, NumStorePurchases ~ Kidhome*Income*Education) #copier coller le model final

#5) and only then check inferences
parameters::model_parameters(anova(finalm1))
effectsize::eta_squared(finalm1) #everything that had 0.00 on the left og the 90% CI column has a "meaningless" effect size
sjPlot::plot_model(finalm1) #to plot all the estimates
sjPlot::plot_model(finalm1, type = "pred", terms = "Kidhome", show.data  = T, jitter = 1) # to plot only one term
sjPlot::plot_model(finalm1, type = "pred", terms = "Income", show.data  = T, jitter = 1) # to plot only one term
sjPlot::plot_model(finalm1, type = "pred", terms = c("Income", "Kidhome"), show.data  = T, jitter = 1) # to plot interactions

sjPlot::tab_model(finalm1, rm.terms = c("*Education.Q", "Education^4", "Income:Education.C", "Education.Q" , "Kidhomeyes:Education.Q", "Income:Education.Q", "Kidhomeyes:Income:Education.Q", "Education.C" ,              "Kidhomeyes:Education.C"  ,      "Income:Education.C"  ,"Kidhomeyes:Income:Education.C", "Education^4",  "Kidhomeyes:Education^4", "Income:Education^4" , "Kidhomeyes:Income:Education^4"))

#try to do the same for the other ones !

# m1 <- lm(data=data, SQRTNumDealsPurchases ~ Income + Education + Kidhome + MntGoldProds + MntWines + MntMeatProducts + MntFishProducts + MntSweetProducts + MntFruits)
# summary(m1) #not satisfying
# 
# m2 <- lm(data=data, Income ~ Education + Marital_Status + NumDealsPurchases + Kidhome + MntGoldProds + MntWines + MntMeatProducts + MntFishProducts + MntSweetProducts + MntFruits)
# summary(m2)

m3 <- lm(data=data, sqrt(NumDealsPurchases) ~ Income*Education + Kidhome + MntGoldProds)
summary(m2)

m4 <- lm(data=data, Income ~ Education + NumDealsPurchases + Kidhome + MntWines + MntMeatProducts + MntFishProducts + MntSweetProducts + MntFruits)
summary(m4)
 

# faire : 
#   plot assumptions (autoplot pour regarder les résidus) car summary n'est pas suffisant'
# déplacer sur Rmarkdown dès maintenant et y rester 
# PCA 
# p value + des intervalles de confiance pour les tailles d'effet
# la taille d'effet montre l'ampleur de l'effet, au delà de la p value
# le R2 est une taille d'effet pour tout le modèle. Intervalle de confiance pour le taille d'effet 
# 


ms <- MASS::stepAIC(m4) #il choisit la meilleure façon de faire le modèle m4


install.packages("sjPlot")
sjPlot::plot_model(m4, type = "diag")
# point a enlever


plot(m4, c(1:2,4), labels.id = data$ID)


data <- data[data$ID!=6168,] 
data <- data[data$ID!=3850,] 

m4 <- lm(data=data, Income ~ Education + NumDealsPurchases + Kidhome + MntWines + MntMeatProducts + MntFishProducts + MntSweetProducts + MntFruits)
summary(m4)

