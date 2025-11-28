-- 10_data_segmentation.sql
-- This file can include segmentation logic; example given below

-- Customer segmentation example based on sales and lifespan
CREATE VIEW gold.report_customers AS
WITH customer_spending AS (
    SELECT
        c.customer_key,
        SUM(s.sales_amount) AS total_spending,
        MIN(order_date) AS first_order,
        MAX(order_date) AS last_order,
        DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan
    FROM gold.fact_sales s
    LEFT JOIN gold.dim_customers c
        ON s.customer_key = c.customer_key
    GROUP BY c.customer_key
)
SELECT * FROM customer_spending;
