# The columns that will be kept
cols.to.keep <- c(
  "Participant_code",
  "Age",
  "Gender",
  "Positive_history_of_Parkinson_disease_in_family",
  "Overview_of_motor_examination._UPDRS_III_total",
  "Rate_of_speech_timing",
  "Rate_of_speech_timing.1"
)

# Above columns will be renamed to
rename.cols.to <- c(
  "Participant_code",
  "Age",
  "Gender",
  "Family_History",
  "UPDRS_III_Total",
  "Rate_Of_Speech_Reading",
  "Rate_Of_Speech_Monologue"
)

csv.path <- "C:/Users/anjap/OneDrive/Desktop/Neuroscience Semester III/Statistics and Probability/DAP/DAP_2021/ANJA/BiomarkersPD.csv"

df <- read.csv(csv.path, sep = ",", header = TRUE)

# Only keep required columns
df <- df[cols.to.keep]

# Change column names
colnames(df) <- rename.cols.to

# Replace "-" with NA
df[df == "-"] <- NA

# Get groups from participant codes
df$Group <- gsub('[[:digit:]]+', '', df$Participant_code)

# Participant codes no longer required, remove
df <- subset(df, select = -c(Participant_code))

# Convert column "UPDRS_III_Total" to integer
df$UPDRS_III_Total <- as.integer(df$UPDRS_III_Total)

# Convert columns to factors
col.names <- c("Group", "Gender", "Family_History")
df[col.names] <- lapply(df[col.names], as.factor)

# The two columns should be factors with NA values
col.names <- c("Family_History")
df[col.names] <- lapply(df[col.names], addNA)

str(df)

library(ggplot2)
library(GGally)
ggpairs(df)

str(df)
                            
# Models
m1 <- glm(data=df[df$Group != "HC",], Group ~ ., family = "binomial")
summary(m1)
# for 3 groups (ordinal) use polr

library(MASS)
m2 <- polr(data=df, Group~Family_History)
summary(m2)

anova(m1)

MASS::stepAIC(m1)
