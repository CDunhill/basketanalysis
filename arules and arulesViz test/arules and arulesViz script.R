
# Trying this tutorial
# http://www.salemmarafi.com/code/market-basket-analysis-with-r/

# NB. Can we bring the SQL query into the R code? Would be great to make it dynamic with selectable params
# Here's the query I used:
# "Documents\SQL Server Management Studio\Basket or Transaction Analysis\TX Query for ARULES analysis (simpler).sql"

# Load the libraries
library(arules)
library(arulesViz)
library(datasets) # is this necessary?
library(vizNetwork) # a more fancy version of arulesViz

# Load the data set
library(readr)
mwlw = read.transactions("LW_TX_data excl SKI packages etc.csv", sep = ",")
View(mwlw)

itemFrequencyPlot(mwlw,topN=40,type="absolute")

## Mining...

# Get the rules and sort in order of 'likelihood'

# The SUPPORT is how many times the product combination appears in our transaction list.
# So 0.01 would only show where the particular combination ('LHS', or antecedent) appears in >=1% transactions.
# The CONFIDENCE is simply how often the rule is shown to be true
rules <- apriori(mwlw, parameter = list(supp = 0.0015, conf = 0.5,maxlen=5))  # max len makes for more concise rules
rules<-sort(rules, by="confidence", decreasing=TRUE)

# Show the top 5 rules, but only 2 digits
options(digits=2) # Part of base package; digits controls no. sig digits when printing numeric values
inspect(rules[1:10])

# Redundancies
# Sometimes, rules will repeat. Redundancy indicates that one item might be a given.
# As an analyst you can elect to drop the item from the dataset.
# Alternatively, you can remove redundant rules generated.
# Eliminate these repeated rules using the follow:

# (I DON'T THINK THIS WORKS IN ITS CURRENT FORM)

# DO NOT RUN...
subset.matrix <- is.subset(rules, rules)
subset.matrix[lower.tri(subset.matrix, diag=T)] <- NA
redundant <- colSums(subset.matrix, na.rm=T) >= 1
rules.pruned <- rules[!redundant]
rules<-rules.pruned

# TARGETING ITEMS
# EG. What are customers likely to buy before buying KID-ACC-GLO
#     What are customers likely to buy if they purchase KID-ACC-GLO?
rules<-apriori(data=mwlw, parameter=list(supp=0.0015,conf = 0.4), 
               appearance = list(default="lhs",rhs="KID-ACC-GLO"),
               control = list(verbose=F))
rules<-sort(rules, decreasing=TRUE,by="confidence")
inspect(rules[1:10])

# Likewise, we can set the left hand side to be “KID-ACC-GLO” and find its antecedents.
rules<-apriori(data=mwlw, parameter=list(supp=0.0015,conf = 0.05,minlen=2), 
               appearance = list(default="rhs",lhs="KID-ACC-GLO"),
               control = list(verbose=F))
rules<-sort(rules, decreasing=TRUE,by="confidence")
inspect(rules[1:5])


# VISUALISATION
library(arulesViz)
plot(rules, method = "graph", engine = "interactive")




