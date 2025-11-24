📦 Data Warehouse Project – End-to-End (Bronze → Silver → Gold)

This repository contains a complete Data Warehouse project implemented using the Medallion Architecture.
It covers ingestion, cleaning, transformation, modelling, and data quality checks across Bronze, Silver, and Gold layers.
The design ensures scalable analytics, reliable reporting, and easy maintenance.

🚀 Project Overview

This project follows a structured, layered approach:

Bronze Layer → Raw data ingestion

Silver Layer → Cleaned, standardized data

Gold Layer → Final analytical data model (Star Schema)

This framework supports traceability, auditability, and reprocessing while delivering high-quality business-ready data.

🧱 Architecture Summary

SOURCE SYSTEMS → BRONZE (Raw) → SILVER (Clean) → GOLD (Analytics)

Bronze stores raw CRM and ERP tables.

Silver applies business cleaning rules, merges, and standardization.

Gold creates fact and dimension views for reporting.

📂 Repository Structure

/project-root
• bronze/
• load_bronze.sql
• silver/
• load_silver.sql
• gold/
• gold_layer_views.sql
• gold_quality_checks.sql
• data_catalogue.md
• README.md

📊 Final Data Model (Gold Layer)

The Gold layer uses a Star Schema consisting of:

Dimensions

• gold.dim_customers
• gold.dim_product

Fact Table

• gold.fact_sales

Relationships

dim_customers ─┐
└── fact_sales
dim_product ───┘

🧪 Data Quality Highlights

The project includes robust quality checks to ensure reliability:

• Missing or invalid dimension keys
• Null values in critical fields
• Invalid date sequences (order < ship < due)
• Duplicate customer/product business IDs
• Negative quantity, price, or amount
• Orphaned fact records

Scripts available in gold/gold_quality_checks.sql.

🛠️ Key Functional Components
1. Bronze Layer (Raw Ingestion)

• Bulk insert pattern
• No transformations
• Preserves original data for auditing
• Includes CRM and ERP source tables

2. Silver Layer (Cleaning & Standardization)

• Removes duplicates
• Standardizes date and text fields
• Merges CRM + ERP attributes
• Fixes missing values using business rules
• Prepares clean, reliable data for modelling

3. Gold Layer (Analytics)

• Builds surrogate keys using ROW_NUMBER
• Conformed dimensions
• Clean fact table referencing dimensions
• Ready for Power BI, Tableau, Looker, and advanced analytics

📘 Data Catalogue (Summary)

Full catalogue lives in gold/data_catalogue.md.

dim_customers

Customer details such as name, country, gender, create date, and business IDs.

dim_product

Product metadata including category, line, cost, maintenance flag, and start date.

fact_sales

Transaction-level data with order dates, quantities, sales amounts, and links to product and customer dimensions.

▶️ How to Run the Project

Run Bronze load
EXEC bronze.load_bronze;

Run Silver load
EXEC silver.load_silver;

Create Gold views
Run gold_layer_views.sql

Execute quality checks
Run gold_quality_checks.sql

📈 Possible Use Cases

• Sales analytics and dashboards
• Customer segmentation
• Product performance analysis
• Trend forecasting
• Executives reporting layer
• Feature generation for ML models

📌 Technologies Used

• SQL Server / T-SQL
• Medallion Architecture
• Star Schema modelling
• Data Quality Framework
• CRM + ERP integrated data sources
