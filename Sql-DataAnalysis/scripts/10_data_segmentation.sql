/*
===============================================================================
Data Segmentation
===============================================================================
Purpose:
    - To segment customers based on spending behavior and activity lifespan.
    - To generate a reusable reporting view for customer analysis.

SQL Functions Used:
    - SUM()
    - MIN(), MAX()
    - DATEDIFF()
    - GROUP BY
    - CREATE VIEW
===============================================================================
*/


/*
===============================================================================
1. Customer Segmentation (Spending + Lifespan)
   - Calculates:
        • total_spending : Total revenue contributed by each customer
        • first_order    : First recorded purchase date
        • last_order     : Most recent purchase date
        • lifespan       : Active duration of the customer (in months)
   - Output is stored as a reporting view.
===============================================================================
*/

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
SELECT 
    customer_key,
    total_spending,
    first_order,
    last_order,
    lifespan
FROM customer_spending;
