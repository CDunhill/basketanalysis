
# Trying this tutorial
# http://www.salemmarafi.com/code/market-basket-analysis-with-r/

# Load the libraries
library(arules)
library(arulesViz)
library(datasets)

# Load the data set
library(readr)
dataset <- read.csv('LW_TX_data.csv', header = FALSE, fileEncoding="UTF-8-BOM") # fileEncoding seemed to get rid of some odd characters
View(dataset)



data(LW_TX_data)