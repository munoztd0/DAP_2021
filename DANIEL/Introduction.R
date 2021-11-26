Raw_data <- read.csv2("C:/Users/dsg96/OneDrive - unige.ch/Uni/Neuro M2 & Psycho M1/Automne/SP - Statistics and Probability/DAP_2021/DAP_2021/DANIEL/Raw_data.csv")

#Characterization of the dataset and useful variables
#This dataset comes from an experiment that aimed to study the impact of emotion elicitation through words on associative memory.
#For this project, we will focus on the affective part of the dataset. 
#for that, we will keep only some variables that are determinant for this analysis:
#Independent variables: the subjects, the wordpairs, the emotion elicited and the sex
#Dependent variables: the disgust and the fear (Likert scales)

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
summary(Data)
