
# Trying this tutorial
# http://www.salemmarafi.com/code/market-basket-analysis-with-r/

# Here's a great guide to visNetwork library http://datastorm-open.github.io/visNetwork/nodes.html

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

# Let's take a look at the data with a plot
itemFrequencyPlot(mwlw,topN=40,type="absolute")

## Mining...

# Get the rules and sort in order of 'likelihood'

# The SUPPORT is how many times the product combination appears in our transaction list.
# So 0.01 would only show where the particular combination ('LHS', or antecedent) appears in >=1% transactions.
# The CONFIDENCE is simply how often the rule is shown to be true
rules <- apriori(mwlw, parameter = list(supp = 0.002, conf = 0.7,maxlen=3))  # max len makes for more concise rules
rules<-sort(rules, by="confidence", decreasing=TRUE)

ig <- plot( rules, method="graph", control=list(type="items"))

# saveAsGraph seems to render bad DOT for this case
tf <- tempfile( )
saveAsGraph( rules, file = tf, format = "dot" )
# clean up temp file if desired
#unlink(tf)

# let's bypass saveAsGraph and just use our igraph
ig_df <- get.data.frame( ig, what = "both" )

visNetwork(
  nodes = data.frame(id = ig_df$vertices$name,
                     color = c("darkred", "grey", "orange"),
                     shadow = c(FALSE, TRUE, FALSE),
                     value = ig_df$vertices$support,
                     title = ifelse(ig_df$vertices$label == "",ig_df$vertices$name, ig_df$vertices$label),
                     ig_df$vertices)
  ,edges = ig_df$edges
) %>%
  visOptions( highlightNearest = T )




