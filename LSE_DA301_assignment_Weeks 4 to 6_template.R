## LSE Data Analytics Online Career Accelerator 

# DA301:  Advanced Analytics for Organisational Impact

###############################################################################

# Assignment template

## Scenario
## You are a data analyst working for Turtle Games, a game manufacturer and 
## retailer. They manufacture and sell their own products, along with sourcing
## and selling products manufactured by other companies. Their product range 
## includes books, board games, video games and toys. They have a global 
## customer base and have a business objective of improving overall sales 
##performance by utilising customer trends. 

## In particular, Turtle Games wants to understand:
## - how customers accumulate loyalty points (Week 1)
## - how useful are remuneration and spending scores data (Week 2)
## - can social data (e.g. customer reviews) be used in marketing 
##     campaigns (Week 3)
## - what is the impact on sales per product (Week 4)
## - the reliability of the data (e.g. normal distribution, Skewness, Kurtosis)
##     (Week 5)
## - if there is any possible relationship(s) in sales between North America,
##     Europe, and global sales (Week 6).

################################################################################

# Week 4 assignment: EDA using R

## The sales department of Turtle games prefers R to Python. As you can perform
## data analysis in R, you will explore and prepare the data set for analysis by
## utilising basic statistics and plots. Note that you will use this data set 
## in future modules as well and it is, therefore, strongly encouraged to first
## clean the data as per provided guidelines and then save a copy of the clean 
## data for future use.

# Instructions
# 1. Load and explore the data.
##  - Remove redundant columns (Ranking, Year, Genre, Publisher) by creating 
##      a subset of the data frame.
##  - Create a summary of the new data frame.
# 2. Create plots to review and determine insights into data set.
##  - Create scatterplots, histograms and boxplots to gain insights into
##      the Sales data.
##  - Note your observations and diagrams that could be used to provide
##      insights to the business.
# 3. Determine the impact on sales per product_id.
##  - Use the group_by and aggregate functions to sum the values grouped by
##      product.
##  - Create a summary of the new data frame.
# 4. Create plots to review and determine insights into the data set.
##  - Create scatterplots, histograms, and boxplots to gain insights into 
##     the Sales data.
##  - Note your observations and diagrams that could be used to provide 
##     insights to the business.
# 5. Include your insights and observations.

###############################################################################
# Reset the working directory
setwd('C:/Users/Alexandra/OneDrive/LSE Data Analytics/Course 3/Assignment 3/LSE_DA301_assignment_files')

# 1. Load and explore the data

# Install and import Tidyverse.
library(tidyverse)
library(ggplot2)
# Load and install the dataframe
sales <- read.csv('turtle_sales.csv')
dim(sales)
head(sales)

# Create a new data frame from a subset of the sales data frame.
# Remove unnecessary columns. 
sales2 <- select(sales, -Ranking, -Year, -Genre, -Publisher)
dim(sales2)

# View the data frame.
head(sales2)

# View the descriptive statistics.
summary(sales2)

## Product should be categorical (Factor)

# Transform Product into a factor variable
sales2 <- mutate(sales2, Product_factor = as_factor(Product))

# Sense check 
dim(sales2)
head(sales2)

# Check for missing values
sum(is.na(sales2))

## No missing values.

################################################################################

# 2. Review plots to determine insights into the data set.

# Visualize categorical variables
qplot(Product_factor, data=sales2)
qplot(Platform, colour= Product_factor, data=sales2)

## 2a) Scatterplots
# What is the relationship between global, EU and NA sales? 
qplot(Global_Sales, NA_Sales, data=sales2, geom=c('point', 'smooth'))
qplot(Global_Sales, EU_Sales, data=sales2)
qplot(EU_Sales, NA_Sales, data=sales2, geom=c('point', 'smooth'))
qplot(EU_Sales, facets=Platform, data=sales2)

## One clear outlier. 
sales2 %>% summarise_if(is.numeric, max)
which.max(sales2[,5])

#Which product is this? 
sales2[1,6]

## 2b) Histograms
# Create histograms.
qplot(Platform,colour=Product_factor, data=sales2)

## 2c) Boxplots
# Create boxplots and visualize the distribution of numerical variables.
qplot(NA_Sales, data=sales2, geom='boxplot')
qplot(EU_Sales, data=sales2, geom='boxplot')
qplot(Global_Sales, data=sales2, geom='boxplot')

# Remove outliers
Q1 <- quantile(sales2$Global_Sales, .25)
Q3 <- quantile(sales2$Global_Sales, .75)
IQR <- Q3-Q1

sales_clean <- subset(sales2, sales2$Global_Sales> (Q1 - 1.5*IQR) & sales2$Global_Sales < (Q3 + 1.5*IQR))

# Sense check 
dim(sales_clean)

# Check the distribution of the cleaned data
qplot(NA_Sales, data=sales_clean, geom='boxplot')
qplot(EU_Sales, data=sales_clean, geom='boxplot')
qplot(Global_Sales, data=sales_clean, geom='boxplot')

# Check the relationship of the cleaned data
qplot(Global_Sales,NA_Sales, data=sales_clean, geom=c('point', 'smooth'))
qplot(EU_Sales,NA_Sales, data=sales_clean, geom=c('point', 'smooth'))
###############################################################################

# 3. Determine the impact on sales per product_id.

# Add a difference col to calc the difference in sales per product in NA vs EU.
sales_clean <- mutate(sales_clean, diff_NA_EU = sales_clean$NA_Sales - sales_clean$EU_Sales)
# Plot diff_NA_EU to get a sense of the data
qplot(diff_NA_EU, data=sales_clean)
qplot(diff_NA_EU, data=sales_clean, geom='boxplot')

## 3a) Use the group_by and aggregate functions.
# Group data based on Product and determine the sum per Product.
Global_ <- aggregate(sales_clean$Global_Sales, by=list(sales_clean$Product_factor), FUN=sum)
NA_ <- aggregate(sales_clean$NA_Sales, by=list(sales_clean$Product_factor), FUN=sum)
EU_ <-aggregate(sales_clean$EU_Sales, by=list(sales_clean$Product_factor), FUN=sum)

sales_byProduct <-cbind(Global_, NA_$x, EU_$x) 
head(sales_byProduct)
colnames(sales_byProduct) <- c('Product_Id', 'global_sales', 'na_sales', 'eu_sales')

# View the data frame.
head(sales_byProduct)

# Explore the data frame.
summary(sales_byProduct)
qplot(global_sales, data=sales_byProduct, geom='boxplot')
qplot(na_sales, data=sales_byProduct, geom='boxplot')
qplot(eu_sales, data=sales_byProduct, geom='boxplot')

# Find the proportion of global sales that eu and na make up
sales_byProduct <- mutate(sales_byProduct, na_prop = (na_sales / global_sales)*100)
sales_byProduct <- mutate(sales_byProduct, eu_prop = (eu_sales / global_sales)*100)
sales_byProduct

# Which products had the highest sales amount globally?  
sales_byProduct <- arrange(sales_byProduct, desc(global_sales))
top_ten_global <- sales_byProduct[1:11,]
top_ten_global

# In the EU? 
sales_byProduct <- arrange(sales_byProduct, desc(eu_sales))
top_ten_eu <- sales_byProduct[1:11,]
top_ten_eu

# In the NA? 
sales_byProduct <- arrange(sales_byProduct, desc(na_sales))
top_ten_na <- sales_byProduct[1:11,]
top_ten_na

# Which products had the lowest sales amount globally?  
sales_byProduct <- arrange(sales_byProduct, global_sales)
bottom_ten_global <- sales_byProduct[1:11,]
bottom_ten_global

# In the EU? 
sales_byProduct <- arrange(sales_byProduct, eu_sales)
bottom_ten_eu <- sales_byProduct[1:11,]
bottom_ten_eu

# In the NA? 
sales_byProduct <- arrange(sales_byProduct, na_sales)
bottom_ten_na <- sales_byProduct[1:11,]
bottom_ten_na

 

## 3b) Determine which plot is the best to compare game sales.
# Create scatterplots.
qplot(global_sales,na_sales, data=top_ten_global)

# Create histograms.
qplot(eu_prop, data=sales_byProduct)
qplot(na_prop, data=sales_byProduct)

# Top ten Prod. Ids
toptens <- rbind(top_ten_global, top_ten_eu, top_ten_na)
toptens

qplot(Product_Id, data=toptens)

#Bottome ten prod
bottomtens <- rbind(bottom_ten_global, bottom_ten_eu, bottom_ten_na)
bottomtens

qplot(Product_Id, data=bottomtens)

# Create boxplots.
qplot(eu_prop, data=sales_byProduct, geom='boxplot')
qplot(na_prop, data=sales_byProduct, geom='boxplot')

###############################################################################

# 4. Observations and insights

## Your observations and insights here ......




###############################################################################
###############################################################################


# Week 5 assignment: Cleaning and maniulating data using R

## Utilising R, you will explore, prepare and explain the normality of the data
## set based on plots, Skewness, Kurtosis, and a Shapiro-Wilk test. Note that
## you will use this data set in future modules as well and it is, therefore, 
## strongly encouraged to first clean the data as per provided guidelines and 
## then save a copy of the clean data for future use.

## Instructions
# 1. Load and explore the data.
##  - Continue to use the data frame that you prepared in the Week 4 assignment. 
##  - View the data frame to sense-check the data set.
##  - Determine the `min`, `max` and `mean` values of all the sales data.
##  - Create a summary of the data frame.
# 2. Determine the normality of the data set.
##  - Create and explore Q-Q plots for all sales data.
##  - Perform a Shapiro-Wilk test on all the sales data.
##  - Determine the Skewness and Kurtosis of all the sales data.
##  - Determine if there is any correlation between the sales data columns.
# 3. Create plots to gain insights into the sales data.
##  - Compare all the sales data (columns) for any correlation(s).
##  - Add a trend line to the plots for ease of interpretation.
# 4. Include your insights and observations.

################################################################################

# 1. Load and explore the data

# View data frame created in Week 4.


# Check output: Determine the min, max, and mean values.


# View the descriptive statistics.


###############################################################################

# 2. Determine the normality of the data set.

## 2a) Create Q-Q Plots
# Create Q-Q Plots.



## 2b) Perform Shapiro-Wilk test
# Install and import Moments.


# Perform Shapiro-Wilk test.



## 2c) Determine Skewness and Kurtosis
# Skewness and Kurtosis.



## 2d) Determine correlation
# Determine correlation.


###############################################################################

# 3. Plot the data
# Create plots to gain insights into data.


###############################################################################

# 4. Observations and insights
# Your observations and insights here...


###############################################################################
###############################################################################

# Week 6 assignment: Making recommendations to the business using R

## The sales department wants to better understand if there is any relationship
## between North America, Europe, and global sales. Therefore, you need to
## investigate any possible relationship(s) in the sales data by creating a 
## simple and multiple linear regression model. Based on the models and your
## previous analysis (Weeks 1-5), you will then provide recommendations to 
## Turtle Games based on:
##   - Do you have confidence in the models based on goodness of fit and
##        accuracy of predictions?
##   - What would your suggestions and recommendations be to the business?
##   - If needed, how would you improve the model(s)?
##   - Explain your answers.

# Instructions
# 1. Load and explore the data.
##  - Continue to use the data frame that you prepared in the Week 5 assignment. 
# 2. Create a simple linear regression model.
##  - Determine the correlation between the sales columns.
##  - View the output.
##  - Create plots to view the linear regression.
# 3. Create a multiple linear regression model
##  - Select only the numeric columns.
##  - Determine the correlation between the sales columns.
##  - View the output.
# 4. Predict global sales based on provided values. Compare your prediction to
#      the observed value(s).
##  - NA_Sales_sum of 34.02 and EU_Sales_sum of 23.80.
##  - NA_Sales_sum of 3.93 and EU_Sales_sum of 1.56.
##  - NA_Sales_sum of 2.73 and EU_Sales_sum of 0.65.
##  - NA_Sales_sum of 2.26 and EU_Sales_sum of 0.97.
##  - NA_Sales_sum of 22.08 and EU_Sales_sum of 0.52.
# 5. Include your insights and observations.

###############################################################################

# 1. Load and explor the data
# View data frame created in Week 5.


# Determine a summary of the data frame.


###############################################################################

# 2. Create a simple linear regression model
## 2a) Determine the correlation between columns
# Create a linear regression model on the original data.



## 2b) Create a plot (simple linear regression)
# Basic visualisation.


###############################################################################

# 3. Create a multiple linear regression model
# Select only numeric columns from the original data frame.


# Multiple linear regression model.


###############################################################################

# 4. Predictions based on given values
# Compare with observed values for a number of records.



###############################################################################

# 5. Observations and insights
# Your observations and insights here...


###############################################################################
###############################################################################




