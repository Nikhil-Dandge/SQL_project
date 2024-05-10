
-- Cleaning of data

-- changing the datatype for date column
-- ------------------------------------------------------------------------------------------------------------------
ALTER TABLE sales
ADD COLUMN new_date_column DATE;

UPDATE sales
SET new_date_column = STR_TO_DATE(date, '%d-%m-%Y');

ALTER TABLE sales
DROP COLUMN date;

ALTER TABLE sales
CHANGE COLUMN new_date_column date DATE;

-- -----------------------------------------------------------------------------------------------------------------------
-- Changing the Datatype of Time column

ALTER TABLE sales
ADD COLUMN new_time_column TIME;

-- Step 2: Update the new column with the converted values
UPDATE sales
SET new_time_column = STR_TO_DATE(time, '%H:%i:%s');

-- Step 3: Drop the original column
ALTER TABLE sales
DROP COLUMN time;

-- Step 4: Rename the new column
ALTER TABLE sales
CHANGE COLUMN new_time_column time TIME;


-- ---------Add the time_of_day column------------

SELECT
	time,
	(CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END) AS time_of_day
FROM sales;


ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales
SET time_of_day = (
	CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END
);

-- ------------------------------------------------------------------------------------------------------------------------

-- how many cities does the table contain

SELECT DISTINCT city FROM sales;

-- Which city contains which branch

SELECT DISTINCT city,branch FROM sales;

-- How many unique product line does the data have 

-- ---------------------------- Product -------------------------------

SELECT DISTINCT Product_line FROM sales;

-- What is the most selling product line

SELECT SUM(quantity) AS qty, product_line 
    FROM sales 
      GROUP BY product_line 
      ORDER BY qty DESC; 

-- What is the most selling product line

SELECT SUM(quantity) AS qty, product_line
    FROM sales
       GROUP BY product_line
       ORDER BY qty DESC LIMIT 1;

-- What is the total revenue by month

SELECT SUM(total) AS total, MONTHNAME(date) 
	AS month 
    FROM sales GROUP BY month
    ORDER BY total DESC;

-- What month had the largest COGS?

SELECT SUM(cogs) as cogs,
      MONTHNAME(date) as month 
      FROM sales GROUP BY month
      ORDER BY cogs DESC LIMIT 1;
      
-- What product line had the largest revenue?

SELECT SUM(total) as rev,
      product_line 
      FROM sales GROUP BY product_line
      ORDER BY rev DESC LIMIT 1;
     
-- What is the city with the largest revenue?

SELECT city,SUM(total) as rev
      FROM sales
      GROUP BY city
      ORDER BY rev DESC LIMIT 1;
      
-- What product line had the largest VAT?

SELECT product_line, AVG(tax_pct) AS avg_tax 
     FROM sales
     GROUP BY Product_line
     ORDER BY avg_tax DESC LIMIT 1;

-- Fetch each product line and add a column to those product 
-- line showing "Good", "Bad". Good if its greater than average sales

SELECT 
	AVG(quantity) AS avg_qnty
FROM sales;

SELECT
	product_line,
	CASE
		WHEN AVG(quantity) > 6 THEN "Good"
        ELSE "Bad"
    END AS remark
FROM sales
GROUP BY product_line;

-- Which branch sold more products than average product sold?
SELECT 
	branch, 
    SUM(quantity) AS qnty
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales);


-- What is the most common product line by gender
SELECT
	gender,
    product_line,
    COUNT(gender) AS total_cnt
FROM sales
GROUP BY gender, product_line
ORDER BY total_cnt DESC;

-- What is the average rating of each product line
SELECT
	ROUND(AVG(rating), 2) as avg_rating,
    product_line
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;

-- -------------------------- Customers -------------------------------


-- How many unique customer types does the data have?
SELECT
	DISTINCT customer_type
FROM sales;

-- How many unique payment methods does the data have?
SELECT
	DISTINCT payment
FROM sales;


-- What is the most common customer type?
SELECT
	customer_type,
	count(*) as count
FROM sales
GROUP BY customer_type
ORDER BY count DESC;

-- Which customer type buys the most?
SELECT
	customer_type,
    COUNT(*) as count
FROM sales
GROUP BY customer_type 
ORDER BY count DESC LIMIT 1;


-- What is the gender of most of the customers?
SELECT
	gender,
	COUNT(*) as gender_cnt
FROM sales
GROUP BY gender
ORDER BY gender_cnt DESC;

-- What is the gender distribution per branch?
SELECT
	gender,
	COUNT(*) as gender_cnt,
    branch
FROM sales
GROUP BY gender,branch
ORDER BY gender_cnt DESC;

-- Gender per branch is more or less the same hence, no effect of the sales per branch and other factors.


-- Which time of the day do customers give most ratings?
SELECT
	time_of_day,
	AVG(rating) AS avg_rating
FROM sales
GROUP BY time_of_day
ORDER BY avg_rating DESC;

-- The average rating is same for all time of the data hence, it has no effect on sales

-- Which time of the day do customers give most ratings per branch?
SELECT
	branch,time_of_day,
	AVG(rating) AS avg_rating
FROM sales
GROUP BY time_of_day,branch
ORDER BY branch,avg_rating DESC;
-- Branch A and C are comparatively better than branch B which will need a slight improvement

SELECT
	DAYNAME(date) as day_name,
	AVG(rating) AS avg_rating
FROM sales
GROUP BY day_name 
ORDER BY avg_rating DESC;

-- Mon, Tue and Friday are the top best days for good ratings

-- why is that the case, how many sales are made on these days?

SELECT  DAYNAME(date) AS day, SUM(quantity) AS qty
     FROM sales
     GROUP BY day
     ORDER BY qty;

-- Which day of the week has the best average ratings per branch?

SELECT 
	branch,DAYNAME(date) AS day,
	COUNT(*) total_sales
FROM sales
-- WHERE branch = "C"
GROUP BY day,branch
ORDER BY branch,total_sales DESC;


-- ---------------------------- Sales ---------------------------------
-- --------------------------------------------------------------------

-- Number of sales made in each time of the day per weekday 
SELECT
	DAYNAME(date) as day,time_of_day,
	COUNT(*) AS total_sales
FROM sales
GROUP BY time_of_day,day
ORDER BY total_sales DESC;

-- Evenings experience most sales, the stores are 

-- Which of the customer types brings the most revenue?
SELECT
	customer_type,
	SUM(total) AS total_revenue
FROM sales
GROUP BY customer_type
ORDER BY total_revenue;

