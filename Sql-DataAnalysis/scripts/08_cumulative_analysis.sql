-- 08_cumulative_analysis.sql
-- Yearly sales per product with differences from average and previous year

WITH yearly_product_sales AS (
    SELECT 
        YEAR(s.order_date) AS order_date,
        p.product_name,
        SUM(s.sales_amount) AS current_sales
    FROM gold.fact_sales s
    LEFT JOIN gold.dim_products p
        ON s.product_key = p.product_key
    WHERE s.order_date IS NOT NULL
    GROUP BY YEAR(s.order_date), p.product_name
)
SELECT 
    order_date,
    product_name,
    current_sales,
    AVG(current_sales) OVER (PARTITION BY product_name) AS avg_sales,
    current_sales - AVG(current_sales) OVER (PARTITION BY product_name) AS diff_avg,
    LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_date) AS py_sales,
    current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_date) AS diff_py
FROM yearly_product_sales;
