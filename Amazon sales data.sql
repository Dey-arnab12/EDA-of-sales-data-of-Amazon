Create database amazon; #database creation
use amazon;
--------------------------------------------------------------------------------------------------------------------------------------------
#Upload of data

select * from amazon;
describe amazon;
#Renaming the column
ALTER TABLE amazon       
rename COLUMN `Invoice ID` to invoice_id,
rename COLUMN `Customer type`to customer_type,
rename COLUMN `Product line` to product_line ,
rename COLUMN `Unit price` to unit_price ,
rename COLUMN `Tax 5%` to VAT , 
rename COLUMN `Payment` to payment_method ,
rename COLUMN `gross margin percentage` to gross_margin_percentage ,
rename COLUMN `gross income`to gross_income;

#Changing the data types of Date and time. 

select * from amazon;

-- Update the Date column values
UPDATE amazon
SET `Date` = STR_TO_DATE(`Date`, '%Y-%m-%d');

-- Change the column type to DATE
ALTER TABLE amazon
MODIFY COLUMN `Date` DATE;

ALTER TABLE amazon MODIFY COLUMN `Date` DATE;

-- Update the time column values
-- Step 1: Temporarily modify the column type to VARCHAR
ALTER TABLE amazon
MODIFY COLUMN `Time` VARCHAR(50);

-- Step 2: Update the column with converted values
SET SQL_SAFE_UPDATES = 0;
UPDATE amazon
SET `Time` = STR_TO_DATE(CONCAT('2023-01-01 ', `Time`), '%Y-%m-%d %H:%i:%s');

-- Step 3: Change the column type to TIMESTAMP
ALTER TABLE amazon
MODIFY COLUMN `Time` TIMESTAMP;
SET SQL_SAFE_UPDATES = 1;

----------------------------------------------------------------------------------------------------------------------------------------------
##Feature Engineering
#1. Adding dayname to give insight of sales in the Mon, Tue, Wed, Thur, Fri.
Select * from amazon;
#Adding the column
ALTER TABLE amazon
ADD timeofday Varchar(255);

#Inserting the values
SET SQL_SAFE_UPDATES = 0;
UPDATE amazon
SET timeofday = DAYNAME(`Date`);
SET SQL_SAFE_UPDATES = 1;

ALTER TABLE amazon       
rename COLUMN `timeofday` to dayname;

#2. Adding timeofday to give insight of sales in  Morning, Afternoon and Evening
#Adding the column
ALTER TABLE amazon
ADD timeofday Varchar(255);

##Inserting the values
SET SQL_SAFE_UPDATES = 0;
UPDATE amazon
SET timeofday = CASE 
    WHEN HOUR(time) BETWEEN 6 AND 11 THEN 'Morning'
    WHEN HOUR(time) BETWEEN 12 AND 17 THEN 'Afternoon'
    WHEN HOUR(time) BETWEEN 18 AND 21 THEN 'Evening'
    ELSE 'Night'
END;
SET SQL_SAFE_UPDATES = 1;

#3. Adding monthname that contains the extracted months of the year on which the given transaction took place (Jan, Feb, Mar).
#Adding the column
ALTER TABLE amazon
ADD monthname Varchar(255);

#inserting Values
SET SQL_SAFE_UPDATES = 0;
UPDATE amazon
SET monthname = monthname(`Date`);
SET SQL_SAFE_UPDATES = 1;

Select * from amazon;
---------------------------------------------------------------------------------------------------------------------------------------------------------
#Business problems :
#1. What is the count of distinct cities in the dataset?

select count(distinct city) from amazon
as count_of_distinct_cities;
--------------------------------------------------------------------------------
#2. For each branch, what is the corresponding city?

select distinct(branch), city from amazon
order by city desc;
-------------------------------------------------------------------------------------
#3 What is the count of distinct product lines in the dataset?

select count(distinct product_line) from amazon
as count_of_product_line;
----------------------------------------------------------------------------
#4 Which payment method occurs most frequently?

Select count(payment_method) as Frequent_method,payment_method from 
amazon group by payment_method
order by Frequent_method desc
Limit 1;
---------------------------------------------------------------------------
#5 Which product line has the highest sales?

Select count(product_line) as Highest_selling_product, product_line
from amazon
group by product_line
order by Highest_selling_product
limit 1;
----------------------------------------------------------------------------
#6 How much revenue is generated each month?

select sum(gross_income) as revenue, monthname
from amazon
group by monthname;
-------------------------------------------------------------------------------
#7 In which month did the cost of goods sold reach its peak?

Select sum(cogs) as total_cogs, monthname
from amazon
group by monthname
order by total_cogs
limit 1;
------------------------------------------------------------------------------
#8 Which product line generated the highest revenue?

select sum(gross_income) as revenue, product_line
from amazon
group by product_line
order by revenue desc
limit 1;
---------------------------------------------------------------------------------
#9 In which city was the highest revenue recorded?

select sum(total) as revenue, city
from amazon
group by city
order by revenue desc
limit 1;
-----------------------------------------------------------------------------------
#10 Which product line incurred the highest Value Added Tax?

select sum(VAT) as highest_VAT, product_line
from amazon
group by product_line
order by highest_vat desc
limit 1;
-------------------------------------------------------------------------------------------------------
#11 For each product line, add a column indicating "Good" if its sales are above average, otherwise "Bad."

ALter Table amazon #adding the column
add remarks varchar(255);

CREATE TEMPORARY TABLE temp_avg_revenue AS           #Creating a CTE to store avg value
SELECT product_line, AVG(total) AS avg_revenue
FROM amazon
GROUP BY product_line;

SET SQL_SAFE_UPDATES = 0;
UPDATE amazon a											#updating the value by joing the cte with current table to calculate the remarks
JOIN temp_avg_revenue t
ON a.product_line = t.product_line
SET a.remarks = CASE 
    WHEN a.total >= t.avg_revenue THEN 'Good'
    ELSE 'Bad'
END;
SET SQL_SAFE_UPDATES = 1;

Select * from amazon;
----------------------------------------------------------------------------------------------------------
#12 Identify the branch that exceeded the average number of products sold.

SELECT AVG(a.Quantity) AS avg_branch, a.branch
FROM amazon a
GROUP BY a.branch
HAVING avg_branch > (SELECT AVG(Quantity) FROM amazon)
ORDER BY a.branch
LIMIT 1;
--------------------------------------------------------------------------------------------------------------
#13 Which product line is most frequently associated with each gender?

(SELECT COUNT(product_line) AS count_of_product_line, product_line, gender
FROM amazon
WHERE product_line IN ("Electronic accessories", "Health and beauty", "Home and lifestyle",
 "Sports and travel", "Food and beverages", "Fashion accessories")
GROUP BY gender , product_line
having gender = "Male"
order by count_of_product_line desc
limit 1
)
union all
(
SELECT COUNT(product_line) AS count_of_product_line, product_line, gender
FROM amazon
WHERE product_line IN ("Electronic accessories", "Health and beauty", "Home and lifestyle", 
"Sports and travel", "Food and beverages", "Fashion accessories")
GROUP BY gender , product_line
having gender = "Female"
order by count_of_product_line desc
limit 1);
-------------------------------------------------------------------------------------------------------------------
#14 Calculate the average rating for each product line.

Select avg(rating) as avg_rating, 
product_line
from amazon
group by product_line;
---------------------------------------------------------------------------------------------------------------------
#15 Count the sales occurrences for each time of day on every weekday.

select count(timeofday) as sales_occurence,
dayname
from amazon
group by dayname
order by dayname desc ;
-------------------------------------------------------------------------------------------------------------------------
# 16 Identify the customer type contributing the highest revenue.

select sum(total) as total_revenue, customer_type 
from amazon
group by customer_type;
---------------------------------------------------------------------------------------------------------------------
#17 Determine the city with the highest VAT percentage.
select * from amazon;

create temporary table vat_percent(
SELECT vat, total, (vat / total) * 100 AS vat_percentage
FROM amazon);
select * from vat_percent;

select a.city, avg(b.vat_percentage) AS avg_vat_percent
from amazon a
join vat_percent b
on a.vat = b.vat
group by a.city
order by avg_vat_percent desc
;
---------------------------------------------------------------------------------------------------------------------
# 18 Identify the customer type with the highest VAT payments.
select sum(vat) as total_vat, 
customer_type
from amazon
group by customer_type
order by total_vat desc
limit 1;
--------------------------------------------------------------------------------------------------------------------
#19 What is the count of distinct customer types in the dataset?
SELECT COUNT(DISTINCT customer_type) AS distinct_customer_types
FROM amazon;

#20 What is the count of distinct payment methods in the dataset?
SELECT COUNT(DISTINCT payment_method) AS distinct_payment_types
FROM amazon;
-----------------------------------------------------------------------------------------------------------------------------
#21 Which customer type occurs most frequently?
select count(customer_type) as count_customer,
customer_type
from amazon
group by customer_type;
---------------------------------------------------------------------------------------------------------------------------
#22 Identify the customer type with the highest purchase frequency.

select * from amazon;
select sum(total) as total__purchase,
customer_type
from amazon
group by customer_type;
--------------------------------------------------------------------------------------------------------------------------
#23 Determine the predominant gender among customers.
SELECT gender, COUNT(gender) AS gender_predominant
FROM amazon
GROUP BY gender
ORDER BY gender_predominant DESC
LIMIT 1;
----------------------------------------------------------------------------------------------------------------------------------
#24 Examine the distribution of genders within each branch.

SELECT branch, gender, COUNT(gender) AS count_gender
FROM amazon
GROUP BY branch, gender
HAVING branch IN ("A", "B", "C")
ORDER BY branch, gender;
----------------------------------------------------------------------------------------------------------------------------------
#25 Identify the time of day when customers provide the most ratings.

select count(rating) as count_rating, timeofday
from amazon
group by timeofday
order by count_rating desc
;
-------------------------------------------------------------------------------------------------------------------------------------------
#26 Determine the time of day with the highest customer ratings for each branch.

select count(rating) as count_rating,branch,timeofday
from amazon
group by branch,timeofday
order by count_rating desc
limit 3
;
------------------------------------------------------------------------------------------------------------------------------
#27 Identify the day of the week with the highest average ratings.
select * from amazon;

select avg(rating) as avg_rating,
dayname
from amazon
group by dayname
order by avg_rating desc
limit 1
;
------------------------------------------------------------------------------------------------------------------------------------------
#28 Determine the day of the week with the highest average ratings for each branch.

select avg(rating) as avg_rating,branch,dayname
from amazon
group by branch,dayname
order by avg_rating desc
limit 3
;
