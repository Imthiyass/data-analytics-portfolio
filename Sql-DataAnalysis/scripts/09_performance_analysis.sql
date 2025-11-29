/*
===============================================================================
Performance Analysis
===============================================================================
Purpose:
    - To evaluate sales distribution by product category.
    - To calculate each category’s contribution to total sales.
    - To segment products based on cost ranges.

SQL Functions Used:
    - SUM()
    - ROUND()
    - CAST()
    - CASE
    - WINDOW FUNCTIONS (SUM() OVER())
===============================================================================
*/


/*
===============================================================================
1. Category Sales & Contribution (% of Total)
   - Calculates total sales per category.
   - Computes each category’s share of overall revenue.
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



/*
===============================================================================
2. Product Cost Segmentation
   - Groups products based on defined cost ranges.
   - Useful for pricing strategy and product distribution analysis.
===============================================================================
*/

WITH cost_range AS (
    SELECT
        product_key,
        product_name,
        cost,
        CASE 
            WHEN cost < 100 THEN 'below 100'
            WHEN cost BETWEEN 100 AND 500 THEN '100-500'
            WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
            ELSE 'above 1000'
        END AS cost_range
    FROM gold.dim_products
)
SELECT 
    cost_range,
    COUNT(product_key) AS total_products
FROM cost_range
GROUP BY cost_range
ORDER BY total_products DESC;
