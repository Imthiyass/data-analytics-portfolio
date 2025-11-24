/************************************************************
-- Description:
--     Data Quality Checks for Gold Layer Views:
--         1. Dimensional Tables (dim_customers, dim_product)
--         2. Fact Table (fact_sales)
--         3. Referential Integrity Checks
--         4. Null / Duplicate / Data-Type Rule Checks
************************************************************/


/*******************************************************
 * 1. CHECK: Missing Surrogate Keys in Dimensions
 *******************************************************/
-- Customers missing customer_key
SELECT *
FROM gold.dim_customers
WHERE customer_key IS NULL;

-- Products missing product_key
SELECT *
FROM gold.dim_product
WHERE product_key IS NULL;



/*******************************************************
 * 2. CHECK: Null Values in Essential Dimension Columns
 *******************************************************/
-- Customer Dimension Null Checks
SELECT * 
FROM gold.dim_customers
WHERE first_name IS NULL
   OR last_name IS NULL
   OR country IS NULL;

-- Product Dimension Null Checks
SELECT *
FROM gold.dim_product
WHERE product_name IS NULL
   OR category IS NULL
   OR start_date IS NULL;



/*******************************************************
 * 3. CHECK: Duplicates in Business Keys
 *******************************************************/
-- Duplicate Customer IDs
SELECT customer_id, COUNT(*) AS cnt
FROM gold.dim_customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- Duplicate Product Numbers
SELECT product_number, COUNT(*) AS cnt
FROM gold.dim_product
GROUP BY product_number
HAVING COUNT(*) > 1;



/*******************************************************
 * 4. CHECK: Fact Table Missing Dimension References
 *******************************************************/
-- Missing Dimension Customer Reference
SELECT f.*
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON f.customer_key = c.customer_key
WHERE c.customer_key IS NULL;

-- Missing Dimension Product Reference
SELECT f.*
FROM gold.fact_sales f
LEFT JOIN gold.dim_product p
    ON f.product_key = p.product_key
WHERE p.product_key IS NULL;



/*******************************************************
 * 5. CHECK: Fact Table Nulls in Critical Fields
 *******************************************************/
SELECT *
FROM gold.fact_sales
WHERE order_number IS NULL
   OR order_date IS NULL
   OR price IS NULL
   OR quantity IS NULL;



/*******************************************************
 * 6. CHECK: Outliers & Invalid Values
 *******************************************************/
-- Negative Quantity or Sales Amount
SELECT *
FROM gold.fact_sales
WHERE quantity < 0
   OR sales_amount < 0;

-- Price Zero / Null (Potential Data Issue)
SELECT *
FROM gold.fact_sales
WHERE price <= 0;



/*******************************************************
 * 7. CHECK: Date Logic Validation
 *******************************************************/
-- Ship date before order date
SELECT *
FROM gold.fact_sales
WHERE shipping_date < order_date;

-- Due date earlier than order date
SELECT *
FROM gold.fact_sales
WHERE due_date < order_date;
