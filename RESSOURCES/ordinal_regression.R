#this is to check to see if package are installed and if not to install them or just load them if they are installed!
if(!require(pacman)) {
  install.packages("pacman")
  library(pacman)
}
pacman::p_load(ordinal, car, RVAideMemoire) #this is all the packages with need here

#if the things go south #install.packages("BiocManager")  
#BiocManager::install('mixOmics')


options(contrasts = c("contr.treatment", "contr.poly")) # use treatment coding here
data(soup)

## More manageable data set:
dat <- subset(soup, as.numeric(as.character(RESP)) <=  24)
dat$RESP <- dat$RESP[drop=TRUE]

m1 <- clmm(SURENESS ~ PROD + (1 | RESP), data = dat, link="probit",
           Hess = TRUE, threshold = "symmetric")

m1
summary(m1)
extractAIC(m1)[2]


RVAideMemoire::Anova.clmm(m1, type = "II") #or type = "III" depending on the context


