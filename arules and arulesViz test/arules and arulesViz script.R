
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

itemFrequencyPlot(mwlw,topN=20,type="absolute")

