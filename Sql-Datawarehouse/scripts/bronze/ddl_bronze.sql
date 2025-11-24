/* ===========================================
   DataWarehouse Setup
   - Creates DB if not exists
   - Creates bronze, silver, gold schemas if not exists
   =========================================== */

USE master;
GO

-- Create database if not exists
IF NOT EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
    CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

-- Create schemas if not exist
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'bronze')
    EXEC('CREATE SCHEMA bronze');
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'silver')
    EXEC('CREATE SCHEMA silver');
GO

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'gold')
    EXEC('CREATE SCHEMA gold');
GO
