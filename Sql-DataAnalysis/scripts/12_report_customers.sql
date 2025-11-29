/*
===============================================================================
Customer Report – Segmented Metrics & Profile Insights
===============================================================================
Purpose:
    - To build a detailed customer-level report view.
    - To calculate spending, order behavior, product variety, recency,
      lifespan, and customer segmentation.
    - To classify customers by:
        • Age group
        • Engagement segment (VIP / Regular / New)

SQL Functions Used:
    - SUM(), MAX(), MIN(), COUNT()
    - CONCAT()
    - DATEDIFF()
    - CASE
    - GROUP BY
    - CREATE VIEW
===============================================================================
*/


/*
===============================================================================
1. Base Query
   - Selects core customer, order, and product-level information.
   - Computes basic attributes like age.
===============================================================================
*/

CREATE VIEW gold.report_customers AS
WITH base_query AS (
    SELECT
        s.order_number,
        s.product_key,
        s.order_date,
        s.sales_amount,
        s.quantity,
        c.customer_key,
        c.customer_number,
        CONCAT(c.first_name,' ', c.last_name) AS customer_name,
        DATEDIFF(year, c.birthdate, GETDATE()) AS age
    FROM gold.fact_sales s
    LEFT JOIN gold.dim_customers c
        ON s.customer_key = c.customer_key
    WHERE order_date IS NOT NULL
),


/*
===============================================================================
2. Customer Aggregation
   - Aggregates metrics per customer:
        • total sales
        • total quantities
        • number of unique products
        • total orders
        • last order date
        • lifespan (months active)
===============================================================================
*/

customer_aggregation AS (
    SELECT
        customer_key,
        customer_number,
        customer_name,
        age,
        SUM(sales_amount) AS total_sales,
        SUM(quantity) AS total_quantity,
        COUNT(DISTINCT product_key) AS total_products,
        COUNT(DISTINCT order_number) AS total_orders,
        MAX(order_date) AS last_order_date,
        DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan
    FROM base_query
    GROUP BY 
        customer_key,
        customer_number,
        customer_name,
        age
)


/*
===============================================================================
3. Final Customer Report
   - Adds:
        • age_group segmentation
        • customer_segment (VIP / Regular / New)
        • recency
        • avg order value
        • avg monthly spend
===============================================================================
*/

SELECT
    customer_key,
    customer_number,
    customer_name,
    age,

    -- Age grouping
    CASE 
        WHEN age < 20 THEN 'Under 20'
        WHEN age BETWEEN 20 AND 29 THEN '20-29'
        WHEN age BETWEEN 30 AND 39 THEN '30-39'
        WHEN age BETWEEN 40 AND 49 THEN '40-49'
        ELSE '50 and above'
    END AS age_group,

    -- Engagement segment
    CASE 
        WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
        WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
        ELSE 'New'
    END AS customer_segment,

    total_sales,
    total_quantity,
    total_products,
    total_orders,
    last_order_date,

    -- Months since last purchase
    DATEDIFF(month, last_order_date, GETDATE()) AS recency,

    lifespan,

    -- Average order value
    CASE 
        WHEN total_orders = 0 THEN 0
        ELSE total_sales * 1.0 / total_orders
    END AS avg_order,

    -- Monthly average spend
    CASE 
        WHEN lifespan = 0 THEN total_sales
        ELSE total_sales * 1.0 / lifespan
    END AS avg_monthly_spend

FROM customer_aggregation;
