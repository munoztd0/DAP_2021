#Characterization of the dataset and useful variables
#This dataset comes from an experiment that aimed to study the impact of emotion elicitation through words on associative memory.
#For this project, we will focus on the affective part of the dataset. 
#for that, we will keep only some variables that are determinant for this analysis:
#Independent variables: the subjects, the wordpairs, the emotion elicited and the sex
#Dependent variables: the disgust and the fear (Likert scales)

#Creating a working dataset
#Giving nice names to variables
subjects<-Raw_data$code
wordpairs<-Raw_data$wordpair
emotion<-Raw_data$emotion
gender<-Raw_data$sex
disgust<-Raw_data$disgust
fear<-Raw_data$fear
arousal<-Raw_data$arousal

#Creating a dataset
Data<-data.frame(subjects,wordpairs,emotion,gender,disgust,fear, arousal)

#Adapting the variables
Data$emotion<-as.factor(Data$emotion)
Data$gender<-as.factor(Data$gender)

#Description of the variables
#The "subjects" and the "wordpairs" variables are characters
#The "emotion" and the "gender" variables are factors
#The "disgust" and the "fear" variables are integers

#The emotion factors are coded as 1=disgust, 2=fear and 3=neutral
#The gender factors are coded as m=man and f=woman
#The disgust and the fear variables are coded form 1 to 7, 1 being feeling "not at all" the emotion and 7 being feeling "very much" the emotion

#data scanning 
str(Data)
summary(Data) #emotion and gender not equal number of observations. Disgust and fear ok, but low means. 
sum(is.na(Data)) #no NAs

Data$react = (Data$disgust + Data$fear) / 2
Data$sd = Data$disgust - Data$fear

plotNormalHistogram(Data$react, main = "React", sub = paste("skewness =", skewness(Data$react, na.rm = TRUE))) 

Data$react = factor(Data$react, ordered = TRUE)


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

#check this out #https://jakec007.github.io/2021-06-23-R-likert/
