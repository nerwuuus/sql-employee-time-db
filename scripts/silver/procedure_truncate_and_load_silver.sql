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

CREATE OR REPLACE PROCEDURE silver.load_silver()
LANGUAGE plpgsql
AS $$
BEGIN
TRUNCATE TABLE silver.ess_inm;
INSERT INTO silver.ess_inm (
    name,
    nessie,
    date,
    status,
    wbs,
    wbs_description,
    hours
)
SELECT
    TRIM(name) AS name, -- Remove whitespaces
    COALESCE(nessie, 0) AS nessie, -- Replace NULLs with 0
    date,
    CASE
        WHEN status = 'Approval rejected' THEN 'Rejected'
        WHEN status = 'In process' THEN 'Not released'
        WHEN status = 'Released for approval' THEN 'Released for approval'
        ELSE 'Approved'
    END AS status, -- Normalize status field with clearer, user-friendly labels
    COALESCE(wbs, 'N/A') AS wbs,
    COALESCE(wbs_description, 'N/A') AS wbs_description,
    CASE
        WHEN COALESCE(hours, 0) <= 0 THEN 0
        ELSE hours
    END AS hours
FROM bronze.ess_inm
WHERE COALESCE(hours, 0) != 0;


TRUNCATE TABLE silver.ess_mnp;
INSERT INTO silver.ess_mnp (
    name,
    nessie,
    date,
    status,
    wbs,
    wbs_description,
    hours
)
SELECT
    TRIM(name) AS name, -- Remove whitespaces
    COALESCE(nessie, 0) AS nessie, -- Replace NULLs with 0
    date,
    CASE  
        WHEN status = 'Approval rejected' THEN 'Rejected'
        WHEN status = 'In process' THEN 'Not released'
        WHEN status = 'Released for approval' THEN status
        ELSE 'Approved'
    END AS status, -- Normalize status field with clearer, user-friendly labels
    COALESCE(wbs, 'N/A') AS wbs,
    COALESCE(wbs_description, 'N/A') AS wbs_description,
    CASE
        WHEN COALESCE(hours, 0) <= 0 THEN 0
        ELSE hours
    END AS hours
FROM bronze.ess_mnp
WHERE COALESCE(hours, 0) != 0;


TRUNCATE TABLE silver.wfm_employees;
INSERT INTO silver.wfm_employees (
    nessie,
    internal_or_external,
    name,
    seniority,
    hourly_rate,
    competence,
    daily_rate
)
SELECT
    nessie,
    CASE
        WHEN internal_or_external NOT IN ('External', 'Internal') THEN 'Unknown'
        ELSE internal_or_external
    END AS internal_or_external,
    name,
    CASE
        WHEN gcm_level <= 3 THEN 'Junior'
        WHEN gcm_level BETWEEN 4 AND 6 THEN 'Intermediate'
        ELSE 'Senior'
    END AS seniority,
    hourly_rate,
    TRIM(SPLIT_PART( -- Extract the part before the first comma from a string
        CASE
            WHEN competence IS NULL THEN 'Unknown'
            ELSE competence
        END,
        ',',
        1
    )) AS competence,
    hourly_rate * 8 AS daily_rate
FROM bronze.wfm_employees
WHERE
    nessie IS NOT NULL 
    AND gcm_level IS NOT NULL 
    AND hourly_rate IS NOT NULL;

    -- Custom message
    RAISE NOTICE 'Silver tables have been successfully updated.';
END;
$$;
