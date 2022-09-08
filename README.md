# LSE-DA301-Assignment-Repository
This repository contains my LSE Advanced Analytics for Organisational Impact assignment. 

We were tasked with using advanced anlytical methods in both Python and R to provide fictional company Turtle Games with insights that will improve overall sales performance. 


Assignment Week One Insights: 

Questions for next time:
- must outliers be removed? 
- must a cleaning of the data be conducted as in assignment one? 
- could renumeration and spending score be used in a multiple linear regression to more accurately explain how loyalty points are accumulated? 
       
Summary: 
- Age cannot be used to explain loyalty points. 
- Renumeration and spending score are averagly good at predicting spending score. Both of their model's F-tests indicate that there is a significant relationship between these variables and how customers accumulate loyalty points. 

Assignment week 2 Insights: 
- attached to excel spreadsheet summarising cluster characteristics. 

Assignment week 4 Insights:
 Exploratory analysis in R
First look at the data
•	X360 is the most frequently used platform in the data set, then PS3 and then PC. 
•	2600 and GEN is the least frequently used platform to launch games. 
•	The relationship between Global, EU and NA sales is roughly linear, as expected. 
•	EU, NA and Global sales were all skewed towards the right before removal of outliers. 
•	There were five outlying observations. 
•	The distribution of Global Sales is still skewed towards the right, but less extreme. 
•	After removing the outliers, the data points do not seem as tightly clustered around the smoothing curve (ex: Global sales versus NA sales). The relationship between the variables is still linear. There are large amounts of deviation. 
o	This could be due to the fact that global sales is made up of EU, NA and ‘Other’ undefined sales.
o	That means that NA sales could make up a smaller/larger proportion of global sales when global sales are high. 
•	Before removing outliers, NA_sales and EU_sales had a positive upward trEND. There were many data points that were far from the trend line indicating a large variance. This also implies that the variables are not very strongly correlated. 
•	After removing outliers, the trend line has a parabolic shape. The points on the graph do not have a clear linear relationship, implying that NA_sales and EU_sales are not strongly correlated. 
o	It would be interesting to observe which products differ significantly in sales. 
•	The is a high frequency of products with the same number of sales in North American and Europe. 
•	The difference between the sales in the two countries has a median slightly set towards the left of the data values but there is a small tail towards the left. 
o	There are more positive differences than negative. Turtle games sold more products in North America than in Europe. 

Impact per product
•	Global sales per prod:
o	Slightly skewed towards the right.
•	NA sales per product:
o	Slightly skewed towards the right. 
o	Many outliers. 
•	EU sales:
o	Also skewed towards the right with many outliers. 
•	Product with the highest sales:
o	Globally: 515
o	EU: 515
o	NA: 948
•	Product with the lowest sales:
o	Globally: 518
o	EU: 51510
o	NA: 4491
•	Aside from a few outliers, EU sales make up less than fifty percent of that product’s global sales. 
•	75% of NA sales make up greater than 40% of that product’s global sales. 
o	North America on spends more with Turtle Games than the EU. 
•	Of the top ten products for Europe, North America and Global sales:
o	515, 876, 948, 979, 1945 appear in the top ten for all sales. 
o	Identified top ‘money-makers’ for Turtle games. 
•	Of the bottom ten product:
o	None appeared in global, European and north American sales as well. 
o	At most, a bottom ranking product appeared in two out the three graphs.
o	For business, this could mean that further research is required to determine why certain products are unpopular. 
