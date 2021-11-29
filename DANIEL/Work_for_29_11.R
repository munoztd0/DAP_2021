#Context of the project
#According to the American Psychological Association (APA), emotion is defined as “a complex reaction pattern, involving experiential, behavioral and physiological elements.”
#Researchers have been studying the impact of emotions on cognitive functions, such as memory. Studies have shown that emotional activation, and specifically emotions of negative valence, favours the retrieval processes of associative memory for single items, but impairs it for associated items or contexts (Schmidt, Patnaik & Kensinger, 2010).
#It's believed that the neurobiological systems sustaining high emotional arousal and memory are linked, especially through the adrenal stress hormones, itself mediated by the amygdala activity (McGaugh, 2013).
#In the study the dataset came from, Riegel et al. (2020) used words to elicit emotions (disgust, fear or neutral). Each pair displayed the same emotion and when showed together, they had to imagine an interaction between them, forcing the creation of a meaningful association. To be sure that the displayed words showed the correct emotion, affective ratings were asked as controls. Each participant had to rate each pair on a Likert scale (1 to 7) of disgust and fear.
#In this project, we are going to use this dataset to analyse and compare three statistical methods. We will compare a repeated measures ANOVA, a ordinal polytomous logistic regression and a linear mixed model. 

#Data description
#Here is a description of the different variables:
#subjects: the subject's number in the experiment.
#wordpairs: the wordpairs presented
#emotion: the emotion elicited by the wordpairs (disgust, fear or neutral)
#gender: the gender of the subjects (man or woman)
#disgust: a Likert scale (1 to 7) of the subjects’ emotional subjective feeling of disgust 
#fear: a Likert scale (1 to 7) of the subjects’ emotional subjective feeling of fear

#data scanning 
Raw_data <- read.csv2("C:/Users/dsg96/OneDrive - unige.ch/Uni/Neuro M2 & Psycho M1/Automne/SP - Statistics and Probability/DAP_2021/DAP_2021/DANIEL/Raw_data.csv")

#Creating a working dataset
#Giving nice names to variables
subjects<-Raw_data$ï..code
wordpairs<-Raw_data$wordpair
emotion<-Raw_data$emotion
gender<-Raw_data$sex
disgust<-Raw_data$disgust
fear<-Raw_data$fear

#Creating a dataset
Data<-data.frame(subjects,wordpairs,emotion,gender,disgust,fear)

#Adapting the variables
Data$emotion<-as.factor(Data$emotion)
levels(Data$emotion) <- c("Disgust", "Fear","Neutral")
Data$gender<-as.factor(Data$gender)
levels(Data$gender) <- c("Women", "Men")
Data$disgustOrd<-as.numeric(Data$disgust)
Data$disgust<-as.factor(Data$disgust)
Data$fear<-as.factor(Data$fear)

str(Data)
summary(Data)

#Repeated measures anova
install.packages("rstatix")
library(rstatix)
anov <- anova_test(data = Data, dv = disgustOrd, wid = emotion, within = subjects)
get_anova_table(res.aov)



#logistic ordinal regression
install.packages("ordinal")
library(ordinal)
model = clmm(disgust ~ emotion + gender +  (emotion | subjects), data = Data)
summary(model)

