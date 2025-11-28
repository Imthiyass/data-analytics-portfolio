-- 13_report_products.sql
-- Detailed product report with performance metrics

CREATE VIEW gold.report_products AS
WITH base_query AS (
    SELECT
        p.product_key,
        p.product_name,
        p.category,
        p.subcategory,
        p.cost,
        s.order_number,
        s.order_date,
        s.sales_amount,
        s.quantity,
        s.customer_key
    FROM gold.fact_sales s
    LEFT JOIN gold.dim_products p
        ON s.product_key = p.product_key
    WHERE s.order_date IS NOT NULL
),
product_agg AS (
    SELECT
        product_key,
        product_name,
        category,
        subcategory,
        cost,
        COUNT(DISTINCT order_number) AS total_orders,
        SUM(sales_amount) AS total_sales,
        SUM(quantity) AS total_quantity,
        COUNT(DISTINCT customer_key) AS total_customers,
        MIN(order_date) AS first_sale,
        MAX(order_date) AS last_sale,
        DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan
    FROM base_query
    GROUP BY
        product_key,
        product_name,
        category,
        subcategory,
        cost
),
final_report AS (
    SELECT
        *,
        CASE 
            WHEN total_sales >= 50000 THEN 'High Performer'
            WHEN total_sales BETWEEN 10000 AND 49999 THEN 'Mid-Range'
            ELSE 'Low Performer'
        END AS performance_segment,
        DATEDIFF(month, last_sale, GETDATE()) AS recency,
        ROUND(
            CASE WHEN total_orders = 0 THEN 0
                 ELSE total_sales * 1.0 / total_orders
            END, 2
        ) AS avg_order_revenue,
        ROUND(
            CASE WHEN lifespan = 0 THEN total_sales
                 ELSE total_sales * 1.0 / lifespan
            END, 2
        ) AS avg_monthly_revenue
    FROM product_agg
)
SELECT *
FROM final_report;
