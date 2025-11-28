/*
===============================================================================
Measures Exploration
===============================================================================
Purpose:
    - To explore key numeric measures in the fact table, such as sales amount, quantity, and price.
    - To calculate basic aggregates for analysis.
	
SQL Functions Used:
    - SUM
    - AVG
    - COUNT
===============================================================================
*/

-- Total sales, total quantity, and average price for all orders
SELECT 
    SUM(sales_amount) AS total_sales,
    SUM(quantity) AS total_quantity,
    AVG(price) AS average_price
FROM gold.fact_sales;

-- Total sales and total quantity by year and month
SELECT 
    YEAR(order_date) AS order_year,
    MONTH(order_date) AS order_month,
    SUM(sales_amount) AS total_sales,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY YEAR(order_date), MONTH(order_date);
