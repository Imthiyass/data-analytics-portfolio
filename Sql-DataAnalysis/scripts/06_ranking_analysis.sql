/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    - To rank products and customers based on sales performance.
    - To identify top performers using window functions.

SQL Functions Used:
    - RANK()
    - DENSE_RANK()
    - ORDER BY
    - PARTITION BY
===============================================================================
*/

-- Rank products by total sales
WITH product_sales AS (
    SELECT
        p.product_key,
        p.product_name,
        SUM(s.sales_amount) AS total_sales
    FROM gold.fact_sales s
    LEFT JOIN gold.dim_products p
        ON s.product_key = p.product_key
    GROUP BY p.product_key, p.product_name
)
SELECT
    product_key,
    product_name,
    total_sales,
    RANK() OVER (ORDER BY total_sales DESC) AS rank_sales,
    DENSE_RANK() OVER (ORDER BY total_sales DESC) AS dense_rank_sales
FROM product_sales;

-- Rank customers by total spending
WITH customer_spending AS (
    SELECT
        c.customer_key,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        SUM(s.sales_amount) AS total_sales
    FROM gold.fact_sales s
    LEFT JOIN gold.dim_customers c
        ON s.customer_key = c.customer_key
    GROUP BY c.customer_key, CONCAT(c.first_name, ' ', c.last_name)
)
SELECT
    customer_key,
    customer_name,
    total_sales,
    RANK() OVER (ORDER BY total_sales DESC) AS rank_sales,
    DENSE_RANK() OVER (ORDER BY total_sales DESC) AS dense_rank_sales
FROM customer_spending;
