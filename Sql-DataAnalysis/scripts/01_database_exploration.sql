/*
===============================================================================
Database Exploration
===============================================================================
Purpose:
    - Explore the database structure: list all tables and their schemas.
    - Inspect columns, data types, and metadata for specific tables.
    - Provide quick insights into table design for analysis.

Tables Used:
    - INFORMATION_SCHEMA.TABLES
    - INFORMATION_SCHEMA.COLUMNS
===============================================================================
*/

-- 1️⃣ List all tables in the current database
SELECT 
    TABLE_CATALOG AS DatabaseName, 
    TABLE_SCHEMA AS SchemaName, 
    TABLE_NAME AS TableName, 
    TABLE_TYPE AS TableType
FROM INFORMATION_SCHEMA.TABLES
ORDER BY TABLE_SCHEMA, TABLE_NAME;

-- 2️⃣ Inspect all columns of a specific table: dim_customers
SELECT 
    COLUMN_NAME AS ColumnName, 
    DATA_TYPE AS DataType, 
    IS_NULLABLE AS IsNullable, 
    CHARACTER_MAXIMUM_LENGTH AS MaxLength,
    COLUMN_DEFAULT AS DefaultValue
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers'
ORDER BY ORDINAL_POSITION;

-- 3️⃣ Inspect all columns of a specific table: dim_products
SELECT 
    COLUMN_NAME AS ColumnName, 
    DATA_TYPE AS DataType, 
    IS_NULLABLE AS IsNullable, 
    CHARACTER_MAXIMUM_LENGTH AS MaxLength,
    COLUMN_DEFAULT AS DefaultValue
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_products'
ORDER BY ORDINAL_POSITION;

-- 4️⃣ Inspect all columns of a specific table: fact_sales
SELECT 
    COLUMN_NAME AS ColumnName, 
    DATA_TYPE AS DataType, 
    IS_NULLABLE AS IsNullable, 
    CHARACTER_MAXIMUM_LENGTH AS MaxLength,
    COLUMN_DEFAULT AS DefaultValue
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'fact_sales'
ORDER BY ORDINAL_POSITION;
