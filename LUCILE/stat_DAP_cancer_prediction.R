"""
INFORMATION ABOUT THE VARIABLES
1) 'radius'            num         distances from center to points on the perimeter
2) 'texture'           num         standard deviation of gray-scale values 
3) 'perimeter'         num         perimeter of the nucleus 
4) 'area'              num         area of the nucleus
5) 'smoothness'        num         local variation in radius lengths 
6) 'compactness'       num         perimeter^2 / area - 1.0 
7) 'concavity'         num         severity of concave portions of the contour 
8) 'concave.points'    num         number of concave portions of the contour 
9) 'symmetry'          num         symmetry of the nucleus 
10)'fractal_dimension' num         'coastline approximation' - 1

AIM Predict whether the cancer is benign or malignant
"""
# I. PREPROCESSING--------

## 1.Load ======================================================================

#load libraries
library(GGally)       # for ggpairs
library(ggfortify)    # for autoplot
library(ggplot2)      # for ggplot

# load data
df<-read.csv('/Users/lucile/Library/Mobile Documents/com~apple~CloudDocs/STUDY/NEURO/LECTURES/stat/data.csv',stringsAsFactors = 1)

## 2. First look into data =====================================================
str(df)
head(df)
summary(df) # There are a lot of variables, we should pick the most relevant ones 

# Delete X variable because not relevant
df<-df[,-33]

# Proportion of benign vs malignant cancer 
prop.table(table(df$diagnosis))   #  B : 0.6274165  M: 0.3725835 
#The two types of cancer are not represented in the same proportion, this can lead to a bias.

## 2. Selection of variables of interest =======================================

"""
According to the description of the data, some variables are likely to be correlated.
We will address this correlation with the mean group of variable.

Hypothesis about the correlation between variables :
- radius and smoothness should be correlated
- radius, perimeter, area and compactness should be perfectly correlated since
  it exists a formula between these variables
- concavity and symmetry should be correlated
- texture and fractal_dimension should not have any correlation 

"""

# create a new frame for a the variables of type mean
df_mean <-data.frame("diagnosis"          = df$diagnosis,
                     "radius"             = df$radius_mean,
                     "texture"            = df$texture_mean, 
                     "perimeter"          = df$perimeter_mean,
                     "area"               = df$area_mean, 
                     "smoothness"         = df$smoothness_mean, 
                     "compactness"        = df$compactness_mean,
                     "concavity"          = df$concavity_mean, 
                     "concave.points"     = df$concave.points_mean, 
                     "symmetry"           = df$symmetry_mean,
                     "fractal_dimension " = df$fractal_dimension_mean) 
str(df_mean)
ggpairs(data = df_mean,aes(color = diagnosis,alpha =0.5))
levels(df_mean$diagnosis)
"""
  By eye, the variables seem to be different according to the type of 'diagnosis' 
  (first row of the plot), the variables coming from malignant cancer seem 
  to be in general bigger than the data coming from bening cancer.
  
  As expected, radius, perimeter and area are highly correlated;  
  and texture and fractal_dimension don't have strong correlation.
  
  Surprisingly, radius and smoothness are not very correlated, 
  and the compactness doesn't show any strong correlation.
  
  Concavity and compactness have a strong correlation.

"""
#Let's see if we have the same correlations with the extreme group of variable

# create a new frame for a the variable of type extreme
df_extreme <-data.frame("diagnosis"          = df$diagnosis,
                        "radius"             = df$radius_worst,
                        "texture"            = df$texture_worst, 
                        "perimeter"          = df$perimeter_worst,
                        "area"               = df$area_worst, 
                        "smoothness"         = df$smoothness_worst, 
                        "compactness"        = df$compactness_worst,
                        "concavity"          = df$concavity_worst, 
                        "concave.points"     = df$concave.points_worst, 
                        "symmetry"           = df$symmetry_worst,
                        "fractal_dimension " = df$fractal_dimension_worst) 
str(df_extreme)
ggpairs(data = df_extreme,aes(color = diagnosis,alpha =0.5))

"""
  We get the same results as for the mean group.

"""

"""
TO DO : 
  - boxplot with mean, standard deviation and extreme values to choose 
    whether extreme values will be taken into account in the analysis
  - choose relevant variables 
  - glm model, family binomial (test if residual of not chosen values can improve the performance).
  - verification (if deviance/residual ==  dispersion parameter of the model)
  - model selection with AIC and anova
"""

# II. MODELE------


  