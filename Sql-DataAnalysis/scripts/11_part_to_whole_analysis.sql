/*
===============================================================================
Part-to-Whole Analysis
===============================================================================
Purpose:
    - To measure how much each product category contributes to total sales.
    - To calculate absolute category sales and percentage contribution.
    - Useful for identifying major vs minor revenue drivers.

SQL Functions Used:
    - SUM()
    - ROUND()
    - CAST()
    - WINDOW FUNCTIONS (SUM() OVER())
===============================================================================
*/


/*
===============================================================================
1. Category Contribution to Total Sales
   - Computes:
        • total_sales per category
        • overall_sales (sum of all categories)
        • overall_percent contribution
   - Helps assess category importance in overall revenue.
===============================================================================
*/

WITH category_sales AS (
    SELECT
        category,
        SUM(sales_amount) AS total_sales
    FROM gold.fact_sales s
    LEFT JOIN gold.dim_products p
        ON s.product_key = p.product_key
    GROUP BY category
)
SELECT
    category,
    total_sales,
    SUM(total_sales) OVER() AS overall_sales,
    ROUND((CAST(total_sales AS FLOAT) / SUM(total_sales) OVER()) * 100, 1) AS overall_percent
FROM category_sales
ORDER BY overall_percent DESC;

