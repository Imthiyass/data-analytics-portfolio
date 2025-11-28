/*
===============================================================================
Measures Exploration
===============================================================================
Purpose:
    - To explore key measures in the dataset: sales_amount, quantity, and price.
    - To calculate basic statistics like total, average, min, and max.
    
SQL Functions Used:
    - SUM
    - AVG
    - MIN
    - MAX
    - ORDER BY
===============================================================================
*/

-- Total and average sales, quantity, and price
SELECT
    SUM(sales_amount) AS total_sales,
    AVG(sales_amount) AS avg_sales,
    MIN(sales_amount) AS min_sales,
    MAX(sales_amount) AS max_sales,
    SUM(quantity) AS total_quantity,
    AVG(quantity) AS avg_quantity,
    MIN(quantity) AS min_quantity,
    MAX(quantity) AS max_quantity,
    AVG(price) AS avg_price,
    MIN(price) AS min_price,
    MAX(price) AS max_price
FROM gold.fact_sales;

-- Sales and quantity by order date
SELECT
    order_date,
    SUM(sales_amount) AS total_sales,
    SUM(quantity) AS total_quantity,
    AVG(price) AS avg_price
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY order_date
ORDER BY order_date;
