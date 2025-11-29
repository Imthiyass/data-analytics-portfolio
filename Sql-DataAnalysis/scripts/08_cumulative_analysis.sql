/*
===============================================================================
Cumulative Analysis
===============================================================================
Purpose:
    - To compute yearly sales per product.
    - To compare current sales with:
        • The product's historical average (diff_avg)
        • Previous year's sales (diff_py)
    - To identify performance trends over time.

SQL Functions Used:
    - YEAR()
    - AVG() OVER()
    - LAG() OVER()
    - PARTITION BY
    - ORDER BY
===============================================================================
*/


/*
===============================================================================
1. Prepare Yearly Product Sales
   - Aggregates total sales per product for each year.
===============================================================================
*/

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


/*
===============================================================================
2. Cumulative & Comparative Metrics
   - avg_sales:   Average yearly sales per product.
   - diff_avg:    Difference from product’s average performance.
   - py_sales:    Previous year's sales.
   - diff_py:     Difference compared to last year.
===============================================================================
*/

SELECT 
    order_date,
    product_name,
    current_sales,
    AVG(current_sales) OVER (PARTITION BY product_name) AS avg_sales,
    current_sales - AVG(current_sales) OVER (PARTITION BY product_name) AS diff_avg,
    LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_date) AS py_sales,
    current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_date) AS diff_py
FROM yearly_product_sales;
