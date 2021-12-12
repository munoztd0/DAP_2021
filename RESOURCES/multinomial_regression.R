#this is to check to see if package are installed and if not to install them or just load them if they are installed!
if(!require(pacman)) {
  install.packages("pacman")
  library(pacman)
}
pacman::p_load(nnet, foreign, car) #this is all the packages with need here

# the multinom function from the nnet package to estimate a multinomial logistic regression model. There are other functions in other R packages capable of multinomial regression. We chose the multinom function because it does not require the data to be reshaped (as the mlogit package does) and to mirror the example code found in Hilbe’s Logistic Regression Models.



ml <- read.dta("https://stats.idre.ucla.edu/stat/data/hsbdemo.dta") #load dummy data

ml$prog2 <- relevel(ml$prog, ref = "academic") #  First, we need to choose the level of our outcome that we wish to use as our baseline and specify this in the relevel function. 

test <- nnet::multinom(prog2 ~ ses + write, data = ml) #Then, we run our model using multinom. The multinom package does not include p-value calculation for the regression coefficients, so we calculate p-values using Chi² tests.

summary(test)

options(contrasts=c("contr.sum","contr.poly"))  # use sum coding, necessary to make type III LR tests valid

car::Anova(test,type="III") #Likelihood ratio tests are generally regarded as more accurate though than Wald z tests (the latter use a normal approximation, LR tests do not)  

#If you would like to carry out pairwise Tukey posthoc tests, then these can be obtained using the lsmeans package
