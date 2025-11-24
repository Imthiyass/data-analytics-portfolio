/************************************************************
-- DQ TESTS FOR: silver.load_silver
-- Purpose : Validate data correctness after loading Silver layer
-- Author  : Mohamed Imthiyas
************************************************************/


/* ==========================================================
    1. CRM_CUST_INFO
========================================================== */

-- Check row count > 0
SELECT COUNT(*) AS row_count
FROM silver.crm_cust_info;

-- All cst_id must be unique
SELECT cst_id, COUNT(*) AS dup_count
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1;

-- Marital status domain check
SELECT DISTINCT cst_marital_status
FROM silver.crm_cust_info;

-- Gender domain check
SELECT DISTINCT cst_gndr
FROM silver.crm_cust_info;



/* ==========================================================
    2. CRM_PRD_INFO
========================================================== */

-- Check row count
SELECT COUNT(*) AS row_count
FROM silver.crm_prd_info;

-- Check prd_id uniqueness
SELECT prd_id, COUNT(*) AS dup_count
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1;

-- Check cost >= 0
SELECT COUNT(*) AS negative_cost_count
FROM silver.crm_prd_info
WHERE prd_cost < 0;

-- Check prd_end_dt is always after prd_start_dt
SELECT *
FROM silver.crm_prd_info
WHERE prd_end_dt IS NOT NULL
  AND prd_end_dt < prd_start_dt;



/* ==========================================================
    3. CRM_SALES_DETAILS
========================================================== */

-- Row count
SELECT COUNT(*) AS row_count
FROM silver.crm_sales_details;

-- Check uniqueness of (order, product, customer)
SELECT sls_ord_num, sls_prd_key, sls_cust_id, COUNT(*) AS dup_count
FROM silver.crm_sales_details
GROUP BY sls_ord_num, sls_prd_key, sls_cust_id
HAVING COUNT(*) > 1;

-- Check sales = quantity * price
SELECT *
FROM silver.crm_sales_details
WHERE sls_sales <> sls_quantity * ABS(sls_price);

-- Check all date columns are valid
SELECT *
FROM silver.crm_sales_details
WHERE sls_order_dt IS NULL
   OR sls_ship_dt IS NULL
   OR sls_due_dt IS NULL;



/* ==========================================================
    4. ERP_PX_CAT_G1V2
========================================================== */

-- Row count
SELECT COUNT(*) AS row_count
FROM silver.erp_px_cat_g1v2;

-- ID duplicates
SELECT id, COUNT(*) AS dup_count
FROM silver.erp_px_cat_g1v2
GROUP BY id
HAVING COUNT(*) > 1;



/* ==========================================================
    5. ERP_CUST_AZ12
========================================================== */

-- Row count
SELECT COUNT(*) AS row_count
FROM silver.erp_cust_az12;

-- Unique cid
SELECT cid, COUNT(*) AS dup_count
FROM silver.erp_cust_az12
GROUP BY cid
HAVING COUNT(*) > 1;

-- Birthdate must not be future
SELECT *
FROM silver.erp_cust_az12
WHERE bdate > GETDATE();

-- Gender domain check
SELECT DISTINCT gen
FROM silver.erp_cust_az12;



/* ==========================================================
    6. ERP_LOC_A101
========================================================== */

-- Row count
SELECT COUNT(*) AS row_count
FROM silver.erp_loc_a101;

-- Unique cid
SELECT cid, COUNT(*) AS dup_count
FROM silver.erp_loc_a101
GROUP BY cid
HAVING COUNT(*) > 1;

-- Country domain check
SELECT DISTINCT cntry
FROM silver.erp_loc_a101;
