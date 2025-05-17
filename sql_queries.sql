create database retail_db;
use retail_db;
CREATE TABLE retail_sales
            (
                transaction_id INT PRIMARY KEY,	
                sale_date DATE,	 
                sale_time TIME,	
                customer_id	INT,
                gender	VARCHAR(15),
                age	INT,
                category VARCHAR(15),	
                quantity	INT,
                price_per_unit FLOAT,	
                cogs	FLOAT,
                total_sale FLOAT
            );
SELECT * FROM retail_sales
LIMIT 10;

-- Data Cleaning------
SELECT * FROM retail_sales
WHERE transactions_id IS NULL;

SELECT * FROM retail_sales
WHERE sale_date IS NULL;

SELECT * FROM retail_sales
WHERE sale_time IS NULL;
SELECT * FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
DELETE FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;

-- Data Exploration

-- How many sales we have?
SELECT COUNT(*) as total_sale FROM retail_sales;

-- How many uniuque customers we have ?

SELECT COUNT(DISTINCT customer_id) as total_sale FROM retail_sales;

-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 What is the average quantity sold per transaction for each category.
-- Q.5 What is the most popular product category by number of transactions.
-- Q.6 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.7 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.8 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.9 Write a SQL query to find the top 5 customers based on the highest total sales.
-- Q.10 Which age group contributes the most to total sales.
-- Q.11 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.12 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
-- Q.13 What is the average number of items sold per transaction (across all data).
-- Q.14 What is the total revenue and average unit price per category.
-- Q.15 On which day of the week do we have the highest number of sales.
 

 -- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

SELECT 
  *
FROM retail_sales
WHERE 
    category = 'Clothing'
    AND 
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND
    quantity >= 4;


-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT 
    category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1;

 -- Q.4 What is the average quantity sold per transaction for each category.
SELECT 
    category,
    ROUND(AVG(quantity), 2) AS avg_quantity
FROM retail_sales
GROUP BY category
ORDER BY avg_quantity DESC;

-- Q.5 What is the most popular product category by number of transactions.
SELECT 
    category,
    COUNT(*) AS total_transactions
FROM retail_sales
GROUP BY category
ORDER BY total_transactions DESC
LIMIT 1;

-- Q.6 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT
    ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty';


-- Q.7 Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT * FROM retail_sales
WHERE total_sale > 1000;

-- Q.8 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT 
    category,
    gender,
    COUNT(*) as total_trans
FROM retail_sales
GROUP 
    BY 
    category,
    gender
ORDER BY 1;

-- Q.9 Write a SQL query to find the top 5 customers based on the highest total sales 

SELECT 
    customer_id,
    SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- Q.10 Which age group contributes the most to total sales.
SELECT 
    CASE 
        WHEN age BETWEEN 18 AND 25 THEN '18-25'
        WHEN age BETWEEN 26 AND 35 THEN '26-35'
        WHEN age BETWEEN 36 AND 50 THEN '36-50'
        ELSE '51+'
    END AS age_group,
    SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY age_group
ORDER BY total_sales DESC;

-- Q.11 Write a SQL query to find the number of unique customers who purchased items from each category.


SELECT 
    category,    
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category;



-- Q.12 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift;

 -- Q.13 What is the average number of items sold per transaction (across all data).
SELECT 
    ROUND(AVG(quantity), 2) AS avg_items_per_transaction
FROM retail_sales;

 -- Q.14 What is the total revenue and average unit price per category.
SELECT 
    category,
    ROUND(SUM(total_sale), 2) AS total_revenue,
    ROUND(AVG(price_per_unit), 2) AS avg_unit_price
FROM retail_sales
GROUP BY category
ORDER BY total_revenue DESC;

-- Q.15 On which day of the week do we have the highest number of sales.
SELECT 
    TO_CHAR(sale_date, 'Day') AS day_of_week,
    COUNT(*) AS total_transactions
FROM retail_sales
GROUP BY day_of_week
ORDER BY total_transactions DESC;





