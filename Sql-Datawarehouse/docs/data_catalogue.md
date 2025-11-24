📘 DATA CATALOGUE – GOLD LAYER

This document contains detailed metadata for all Gold Layer tables in the Data Warehouse.
Each table includes column names, data types, descriptions, and example values.
Suitable for GitHub documentation and analytics team reference.

🟦 1. Table: gold.dim_product
Type: Dimension
Grain: One row per unique product
Primary Key: product_key
| Column         | Data Type     | Description                            | Example              |
| -------------- | ------------- | -------------------------------------- | -------------------- |
| product_key    | INT           | Surrogate unique key for each product. | 101                  |
| product_id     | VARCHAR(50)   | Business product ID from CRM.          | PRD-7788             |
| product_number | INT / VARCHAR | Product key used in CRM.               | 50023                |
| product_name   | VARCHAR(200)  | Name of the product.                   | Ultra Laptop 15 inch |
| category_id    | INT           | Category reference ID.                 | 12                   |
| category       | VARCHAR(100)  | Category name from ERP.                | Electronics          |
| subcategory    | VARCHAR(100)  | Subcategory name.                      | Laptops              |
| maintenance    | VARCHAR(10)   | Maintenance indicator.                 | Yes                  |
| cost           | DECIMAL(10,2) | Cost of product.                       | 849.50               |
| product_line   | VARCHAR(100)  | Product line classification.           | Consumer Devices     |
| start_date     | DATE          | Product activation or launch date.     | 2022-05-14           |



🟩 2. Table: gold.dim_customers
Type: Dimension
Grain: One row per unique customer
Primary Key: customer_key
| Column          | Data Type     | Description                                 | Example    |
| --------------- | ------------- | ------------------------------------------- | ---------- |
| customer_key    | INT           | Surrogate key generated using ROW_NUMBER(). | 2001       |
| customer_id     | VARCHAR(50)   | CRM customer ID.                            | CST80045   |
| customer_number | INT / VARCHAR | Customer number used across systems.        | 33012      |
| first_name      | VARCHAR(100)  | First name of customer.                     | Rahul      |
| last_name       | VARCHAR(100)  | Last name of customer.                      | Nair       |
| country         | VARCHAR(100)  | Country from ERP location table.            | Singapore  |
| marital_status  | VARCHAR(20)   | Marital status.                             | Single     |
| gender          | VARCHAR(20)   | Gender after CRM → ERP merge logic.         | Male       |
| birthdate       | DATE          | Birthdate from ERP record.                  | 1998-11-20 |
| create_date     | DATE          | Customer profile creation date.             | 2021-06-12 |



🟨 3. Table: gold.fact_sales
Type: Fact Table
Grain: One row per sales transaction/order line
Foreign Keys: product_key, customer_key
| Column        | Data Type     | Description                      | Example    |
| ------------- | ------------- | -------------------------------- | ---------- |
| order_number  | VARCHAR(50)   | Sales order number from CRM.     | ORD-902133 |
| product_key   | INT           | FK → dim_product.product_key.    | 101        |
| customer_key  | INT           | FK → dim_customers.customer_key. | 2001       |
| order_date    | DATE          | Date the order was placed.       | 2024-08-10 |
| shipping_date | DATE          | Date the order was shipped.      | 2024-08-12 |
| due_date      | DATE          | Expected delivery date.          | 2024-08-15 |
| sales_amount  | DECIMAL(12,2) | Total sales for the order line.  | 2999.00    |
| quantity      | INT           | Number of units sold.            | 2          |
| price         | DECIMAL(10,2) | Unit price at time of sale.      | 1499.50    |



🔗 Data Model Relationships
| Fact Table | Dimension Table | Relationship                                         |
| ---------- | --------------- | ---------------------------------------------------- |
| fact_sales | dim_product     | fact_sales.product_key = dim_product.product_key     |
| fact_sales | dim_customers   | fact_sales.customer_key = dim_customers.customer_key |


