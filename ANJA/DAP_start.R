df <- read.csv("C:/Users/anjap/OneDrive/Desktop/Neuroscience Semester III/Statistics and Probability/DAP/DAP_2021/ANJA/BiomarkersPD.csv", sep = ",", header = TRUE)
df[df == "-"] <- NA
# From https://statisticsglobe.com/split-data-frame-variable-into-multiple-columns-in-r
df.tmp <- data.frame(do.call("rbind", strsplit(as.character(df$Antidepressant_therapy), " ", fixed = TRUE)))
df$Antidepressant_therapy <- df.tmp$X1
df$Antidepressant <- df.tmp$X2
df$Antidepressant

# Replace parentheses with nothing (remove them)
# Replace "No" with "None"
df$Antidepressant <- gsub("\\(", "", df$Antidepressant)
df$Antidepressant <- gsub("\\)", "", df$Antidepressant)
df$Antidepressant <- gsub("No", "None", df$Antidepressant)


# Same for Benzos
df.tmp <- data.frame(do.call("rbind", strsplit(as.character(df$Benzodiazepine_medication), " ", fixed = TRUE)))
df$Benzodiazepine_medication <- df.tmp$X1
df$Benzodiazepine <- df.tmp$X2
df$Benzodiazepine <- gsub("\\(", "", df$Benzodiazepine)
df$Benzodiazepine <- gsub("\\)", "", df$Benzodiazepine)
df$Benzodiazepine <- gsub("No", "None", df$Benzodiazepine)

col.names <- c()
df[col.names] <- lapply(df[col.names], as.factor)

df$Overview_of_motor_examination._Hoehn_and_Yahr_scale <- as.numeric(df$Overview_of_motor_examination._Hoehn_and_Yahr_scale)

col.names <- c("Age_of_disease_onset", "Duration_of_disease_from_first_symptoms", "Overview_of_motor_examination._UPDRS_III_total")
# lapply: for each column in df[col.names] apply as.factor
df[col.names] <- lapply(df[col.names], as.integer)

col.names <- c("Gender", "Positive_history_of_Parkinson_disease_in_family", "Antidepressant_therapy", "Antiparkinsonian_medication", "Antipsychotic_medication", "Benzodiazepine_medication", "X18_Speech", "X19_Facial_Expression", "X20_Tremor_at_Rest_head", "X20_Tremor_at_Rest_RUE", "X20_Tremor_at_Rest_LUE", "X20_Tremor_at_Rest_RLE", "X20_Tremor_at_Rest_LLE", "X21_Action_or_Postural_Tremor_RUE", "X21_Action_or_Postural_Tremor_LUE", "X22_Rigidity_neck", "X22_Rigidity_RUE", "X22_Rigidity_LUE", "X22_Rigidity_RLE", "X22_Rigidity_LLE", "X23_Finger_Taps_RUE", "X23_Finger_Taps_LUE", "X24_Hand_Movements_RUE", "X24_Hand_Movements_LUE", "X25_Rapid_Alternating_Movements_RUE", "X25_Rapid_Alternating_Movements_LUE", "X26_Leg_Agility_RLE", "X26_Leg_Agility_LLE", "X27_Arising_from_Chair", "X28_Posture", "X29_Gait", "X30_Postural_Stability", "X31_Body_Bradykinesia_and_Hypokinesia")
df[col.names] <- lapply(df[col.names], as.factor)
df[col.names] <- lapply(df[col.names], addNA)

# This looks good, no outliers or obvious anomalies
plot(df$Age, df$Age_of_disease_onset)

for (name in names(Filter(is.numeric, df))) {
  boxplot(df[name], main=name)
}
