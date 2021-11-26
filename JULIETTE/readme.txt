Liem pour toi : https://www.r-bloggers.com/2019/06/how-to-perform-ordinal-logistic-regression-in-r/

This dataframe has been created for marketing analysis purposes. It assembles various perosnal information about 2239 customers, such as their education level, income, age, maritla status, number of children at home... 
It also shows their consuming habits (amount spent on wine, on sweets...) and the number of purchases made on discounted products.

There is very few context concerning this dataframe, since the source is unknown.
It is not clear when these informations were registered, but probably by 2014 since "Dt_Customer" (Date of customer's enrollment with the company) doesn't go higher than 2014. So, by calculating age (2021 - data$Year_Birth) we would get their current age. It seems more correct to calculate "2014 - data$Year_Birth", although here we are only assuming that it was indeed registred in 2014.

Aims :
- To predict the customer's behavior (Number of purchases made with a discount) depending on the most significant personal attributes
- To categorize participants in a few typical profiles (probably with PCA)


ATTRIBUTES : 

People

ID: Customer's unique identifier
Year_Birth: Customer's birth year
Education: Customer's education level
Marital_Status: Customer's marital status
Income: Customer's yearly household income
Kidhome: Number of children in customer's household
Teenhome: Number of teenagers in customer's household
Dt_Customer: Date of customer's enrollment with the company
Recency: Number of days since customer's last purchase
Complain: 1 if customer complained in the last 2 years, 0 otherwise

Products

MntWines: Amount spent on wine in last 2 years
MntFruits: Amount spent on fruits in last 2 years
MntMeatProducts: Amount spent on meat in last 2 years
MntFishProducts: Amount spent on fish in last 2 years
MntSweetProducts: Amount spent on sweets in last 2 years
MntGoldProds: Amount spent on gold in last 2 years

Promotion

NumDealsPurchases: Number of purchases made with a discount
AcceptedCmp1: 1 if customer accepted the offer in the 1st campaign, 0 otherwise
AcceptedCmp2: 1 if customer accepted the offer in the 2nd campaign, 0 otherwise
AcceptedCmp3: 1 if customer accepted the offer in the 3rd campaign, 0 otherwise
AcceptedCmp4: 1 if customer accepted the offer in the 4th campaign, 0 otherwise
AcceptedCmp5: 1 if customer accepted the offer in the 5th campaign, 0 otherwise
Response: 1 if customer accepted the offer in the last campaign, 0 otherwise
Place

NumWebPurchases: Number of purchases made through the company’s web site
NumCatalogPurchases: Number of purchases made using a catalogue
NumStorePurchases: Number of purchases made directly in stores
NumWebVisitsMonth: Number of visits to company’s web site in the last month
