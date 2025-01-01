The major aim of this project is to gain insight into Amazon's sales data to understand the different factors that affect sales of the different branches.

About Data:

This dataset contains sales transactions from three different branches of Amazon, respectively located in Mandalay, Yangon and Naypyitaw. The data contains 17 columns and 1000 rows:
![image](https://github.com/user-attachments/assets/285f0e17-8515-4e30-9f0a-cf91068f3fdf)

![image](https://github.com/user-attachments/assets/81e7a039-a5af-4f42-9223-9e44c22c9977)


Analysis List
Product Analysis

Conduct analysis on the data to understand the different product lines, the products lines performing best and the product lines that need to be improved.

Sales Analysis

This analysis aims to answer the question of the sales trends of product. The result of this can help us measure the effectiveness of each sales strategy the business applies and what modifications are needed to gain more sales.

Customer Analysis

This analysis aims to uncover the different customer segments, purchase trends and the profitability of each customer segment.


Approach Used

Data Wrangling: This is the first step where inspection of data is done to make sure NULL values and missing values are detected and data replacement methods are used to replace missing or NULL values.


1.1          Build a database

1.2          Create a table and insert the data.

1.3          Select columns with null values in them. There are no null values in our database as in creating the tables, we set NOT  NULL for each field, hence null values are filtered out.


Feature Engineering: This will help us generate some new columns from existing ones.


2.1           Add a new column named timeofday to give insight of sales in the Morning, Afternoon and Evening. This will help answer the question on which part of the day most sales are made.

2.2          Add a new column named dayname that contains the extracted days of the week on which the given transaction took place (Mon, Tue, Wed, Thur, Fri). This will help answer the question on which week of the day each branch is busiest.

2.3        Add a new column named monthname that contains the extracted months of the year on which the given transaction took place (Jan, Feb, Mar). Help determine which month of the year has the most sales and profit.

3. Exploratory Data Analysis (EDA): Exploratory data analysis is done to answer the listed questions and aims of this project.

Business Questions To Answer:
What is the count of distinct cities in the dataset?

For each branch, what is the corresponding city?

What is the count of distinct product lines in the dataset?

Which payment method occurs most frequently?

Which product line has the highest sales?

How much revenue is generated each month?

In which month did the cost of goods sold reach its peak?

Which product line generated the highest revenue?

In which city was the highest revenue recorded?

Which product line incurred the highest Value Added Tax?

For each product line, add a column indicating "Good" if its sales are above average, otherwise "Bad."

Identify the branch that exceeded the average number of products sold.

Which product line is most frequently associated with each gender?

Calculate the average rating for each product line.

Count the sales occurrences for each time of day on every weekday.

Identify the customer type contributing the highest revenue.

Determine the city with the highest VAT percentage.

Identify the customer type with the highest VAT payments.

What is the count of distinct customer types in the dataset?

What is the count of distinct payment methods in the dataset?

Which customer type occurs most frequently?

Identify the customer type with the highest purchase frequency.

Determine the predominant gender among customers.

Examine the distribution of genders within each branch.

Identify the time of day when customers provide the most ratings.

Determine the time of day with the highest customer ratings for each branch.

Identify the day of the week with the highest average ratings.

Determine the day of the week with the highest average ratings for each branch.

