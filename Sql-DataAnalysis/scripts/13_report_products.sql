/*
===============================================================================
Product Report – Performance, Segmentation & Revenue Insights
===============================================================================
Purpose:
    - To generate a detailed product-level performance report.
    - To compute key metrics such as:
        • total sales, orders, quantities
        • customer reach
        • first & last sale dates
        • product lifespan and recency
        • revenue segmentation (High / Mid / Low performer)
    - To provide product-level KPIs for dashboarding and analysis.

SQL Functions Used:
    - SUM(), MIN(), MAX(), COUNT()
    - ROUND()
    - CASE
    - DATEDIFF()
    - CREATE VIEW
    - GROUP BY
===============================================================================
*/


/*
===============================================================================
1. Base Query
   - Combines product details with sales transactions.
   - Includes category, subcategory, cost, and customer interactions.
===============================================================================
*/

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


/*
===============================================================================
2. Product Aggregation
   - Computes:
        • total orders
        • revenue
        • quantity sold
        • customer count
        • first & last sale dates
        • lifespan (months active)
===============================================================================
*/

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


/*
===============================================================================
3. Product-Level Metrics & Segmentation
   - performance_segment: Classification based on total sales.
   - recency: Months since last sale.
   - avg_order_revenue: Avg revenue per order.
   - avg_monthly_revenue: Avg revenue per active month.
===============================================================================
*/

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


/*
===============================================================================
4. Final Output
===============================================================================
*/

SELECT *
FROM final_report;
