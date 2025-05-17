drop table if exists retail_sales;
CREATE TABLE retail_sales
	(
	transactions_id INT primary key,
	sale_date DATE,	
	sale_time TIME,	
	customer_id	INT,
	gender varchar(15),	
	age	int,
	category varchar(20),	
	quantiy	int,
	price_per_unit float,	
	cogs float,	
	total_sale float
	);

select * from retail_sales where transactions_id is null;
select * from retail_sales where
transactions_id is null or
	sale_date is null or	
	sale_time is null or	
	customer_id	is null or
	gender is null or	
	age	is null or
	category is null or	
	quantiy	is null or
	price_per_unit is null or	
	cogs is null or	
	total_sale is null;
delete from retail_sales where
	transactions_id is null or
	sale_date is null or	
	sale_time is null or	
	customer_id	is null or
	gender is null or	
	age	is null or
	category is null or	
	quantiy	is null or
	price_per_unit is null or	
	cogs is null or	
	total_sale is null;
--data exploration

--How many sales we have?
select count (*) as transactions_id from retail_sales;

--How  many unqiue customers?
select count (distinct customer_id) as transactions from retail_sales;

-- How many categories?
select count (distinct category) as transactions from retail_sales;

--List the category
select distinct category as t from retail_sales;

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
select * from retail_sales where sale_date = '2022-11-05'; 

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
select * from retail_sales where category ='Clothing' and quantiy >= 4 and TO_CHAR(sale_date, 'YYYY-MM')='2022-11';

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
select category, sum(total_sale) as netsale, count(*) as total from retail_sales group by 1;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select  round(avg(age),2) as average_age from retail_sales where category= 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select * from retail_sales where total_sale>1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select gender, category, count(*) as transactions from retail_sales group by gender,category order by 1;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT 
       year,
       month,
       avg_sale
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY 1, 2
) as t1
WHERE rank = 1

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales
select customer_id, sum(total_sale) as total_sales from retail_sales group by 1 order by 2 desc limit 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
select category, count(distinct customer_id)as cst_unique from retail_sales group by 1;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
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
GROUP BY shift