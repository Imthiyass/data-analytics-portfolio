/*
===============================================================================
Date Range Exploration
===============================================================================
Purpose:
    - To explore the range of order dates in the fact table.
    - To identify the earliest and latest dates.
	
SQL Functions Used:
    - MIN
    - MAX
    - YEAR
    - MONTH
===============================================================================
*/

-- Find the earliest and latest order dates
SELECT 
    MIN(order_date) AS earliest_order_date,
    MAX(order_date) AS latest_order_date
FROM gold.fact_sales;

-- List of years and months present in the data
SELECT DISTINCT
    YEAR(order_date) AS order_year,
    MONTH(order_date) AS order_month
FROM gold.fact_sales
ORDER BY order_year, order_month;
