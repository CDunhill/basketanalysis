
# Trying this tutorial
# http://www.salemmarafi.com/code/market-basket-analysis-with-r/

# NB. Can we bring the SQL query into the R code? Would be great to make it dynamic with selectable params
# Here's the query I used:
# "Documents\SQL Server Management Studio\Basket or Transaction Analysis\TX Query for ARULES analysis (simpler).sql"

# Load the libraries
library(arules)
library(arulesViz)
library(datasets) # is this necessary?

# Load the data set
library(readr)
mwlw = read.transactions("LW_TX_data.csv", sep = ",")
View(mwlw)

itemFrequencyPlot(mwlw,topN=40,type="absolute")

## Let's do some mining...

# Get the rules and sort in order of 'likelihood'
rules <- apriori(mwlw, parameter = list(supp = 0.001, conf = 0.8,maxlen=3))  # max len makes for more concise rules
rules<-sort(rules, by="confidence", decreasing=TRUE)

# Show the top 5 rules, but only 2 digits
options(digits=2)
inspect(rules[1:20])



