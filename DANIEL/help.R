
Data$react = (Data$disgust + Data$fear) / 2

plotNormalHistogram(Data$react, main = "React", sub = paste("skewness =", skewness(Data$react, na.rm = TRUE))) 

Data$disgust = factor(Data$disgust, ordered = TRUE)


#Making frequency table
table(Data$disgust, Data$emotion)

library(readr)
Data$subjects = parse_number(Data$subjects)

#Build ordinal logistic regression model

library(ordinal)

model = clmm(disgust ~ emotion + gender +  (emotion | subjects), data = Data)


library(car)

library(RVAideMemoire)
#install.packages("BiocManager")  
#BiocManager::install('mixOmics')

RVAideMemoire::Anova.clmm(model, type = "II")



model.fixed = clm(disgust ~ emotion + gender,  data = Data)

anova(model, null = model.fixed)

#Plotting the effects 
library("effects")
Effect(focal.predictors = "emotion", model)
plot(Effect(focal.predictors = "emotion",model))
plot(Effect(focal.predictors = c("emotion", "gender"),model))
