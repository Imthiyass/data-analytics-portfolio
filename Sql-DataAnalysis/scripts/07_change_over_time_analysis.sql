/*
===============================================================================
Change Over Time Analysis
===============================================================================
Purpose:
    - To analyze sales trends over months and years.
    - To compute running totals and moving averages for sales insights.
    - To observe long-term growth patterns using window functions.

SQL Functions Used:
    - YEAR()
    - MONTH()
    - DATE_TRUNC()
    - SUM() OVER()
    - AVG() OVER()
    - ORDER BY
    - GROUP BY
===============================================================================
*/


/*
===============================================================================
1. Monthly Trend Analysis
   - Total sales, customers, and quantity by month.
===============================================================================
*/

SELECT 
    YEAR(order_date) AS order_year,
    MONTH(order_date) AS order_month,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY YEAR(order_date), MONTH(order_date);



/*
===============================================================================
2. Yearly Running Total & Moving Average
   - Running totals show cumulative growth.
   - Moving averages smooth out yearly price trends.
===============================================================================
*/

SELECT 
    order_date,
    total_sales,
    SUM(total_sales) OVER (ORDER BY order_date) AS running_total_sales,
    AVG(avg_price) OVER (ORDER BY avg_price) AS moving_avg_price
FROM (
    SELECT 
        DATE_TRUNC('year', order_date) AS order_date,
        SUM(sales_amount) AS total_sales,
        AVG(price) AS avg_price
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATE_TRUNC('year', order_date)
) t;
