/*

============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
============================================================================
Script Purpose:
  This stored procedure performs the ETL (Extract, Transform, Load) process to
  populate the 'silver' schema tables from the 'bronze' schema.
Actions Performed:
  - Truncates Silver tables.
  - Inserts transformed and cleansed data from Bronze into Silver tables.
============================================================================

*/

-- Invoke a procedure
CALL silver.load_silver();

CREATE OR REPLACE PROCEDURE silver.load_silver()
LANGUAGE pgplsql
AS $$
BEGIN
    TRUNCATE TABLE silver.ess_mnp;
    INSERT INTO silver.ess_mnp (
    name VARCHAR(255),
    nessie INT,
    date DATE,
    status VARCHAR(255),
    wbs VARCHAR(255),
    wbs_description VARCHAR(255),
    hours NUMERIC(4,2)  
    )
    SELECT 
        -- Here will be added columns after data cleaning
    FROM bronze.ess_mnp;

    TRUNCATE TABLE silver.ess_inm;
    INSERT INTO silver.ess_inm (
    name VARCHAR(255),
    nessie INT,
    date DATE,
    status VARCHAR(255),
    wbs VARCHAR(255),
    wbs_description VARCHAR(255),
    hours NUMERIC(4,2)
    )
    SELECT
        -- Here will be added columns after data cleaning
    FROM bronze.ess_inm;

    TRUNCATE TABLE silver.wfm_employees;
    INSERT INTO silver.wfm_employees (
    name VARCHAR(50),
    nessie INT,
    hourly_rate NUMERIC(4,2),
    GCM_level INT,
    position VARCHAR(50)     
    )
    SELECT
        -- Here will be added columns after data cleaning
    FROM silver.wfm_employees;

    -- Custom message
    RAISE NOTICE 'Silver tables have been successfully updated.'
END;
$$;
