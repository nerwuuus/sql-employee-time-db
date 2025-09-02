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
CALL silver.load_silver();

CREATE OR REPLACE PROCEDURE silver.load_silver()
LANGUAGE plpgsql
AS $$
BEGIN
    -- Step 1: Load sap_inm
    TRUNCATE TABLE silver.sap_inm;
    INSERT INTO silver.sap_inm (
        name,
        nessie,
        work_date,
        status,
        wbs,
        wbs_description,
        hours
    )
    SELECT
        TRIM(name),
        COALESCE(nessie, 0),
        work_date,
        CASE
            WHEN status = 'Approval rejected' THEN 'Rejected'
            WHEN status = 'In process' THEN 'Not released'
            WHEN status = 'Released for approval' THEN 'Released for approval'
            ELSE 'Approved'
        END,
        COALESCE(wbs, 'N/A'),
        COALESCE(wbs_description, 'N/A'),
        CASE
            WHEN COALESCE(hours, 0) <= 0 THEN 0
            ELSE hours
        END
    FROM bronze.sap_inm
    WHERE COALESCE(hours, 0) != 0;

    -- Step 2: Load sap_mnp
    TRUNCATE TABLE silver.sap_mnp;
    INSERT INTO silver.sap_mnp (
        name,
        nessie,
        work_date,
        status,
        wbs,
        wbs_description,
        hours
    )
    SELECT
        TRIM(name),
        COALESCE(nessie, 0),
        work_date,
        CASE  
            WHEN status = 'Approval rejected' THEN 'Rejected'
            WHEN status = 'In process' THEN 'Not released'
            WHEN status = 'Released for approval' THEN status
            ELSE 'Approved'
        END,
        COALESCE(wbs, 'N/A'),
        COALESCE(wbs_description, 'N/A'),
        CASE
            WHEN COALESCE(hours, 0) <= 0 THEN 0
            ELSE hours
        END
    FROM bronze.sap_mnp
    WHERE COALESCE(hours, 0) != 0;

    -- Step 3: Load wfm_employees
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
        END,
        name,
        CASE
            WHEN gcm_level <= 3 THEN 'Junior'
            WHEN gcm_level BETWEEN 4 AND 6 THEN 'Intermediate'
            ELSE 'Senior'
        END,
        hourly_rate,
        TRIM(SPLIT_PART(
            COALESCE(competence, 'Unknown'),
            ',',
            1
        )),
        hourly_rate * 8
    FROM bronze.wfm_employees
    WHERE
        nessie IS NOT NULL 
        AND gcm_level IS NOT NULL 
        AND hourly_rate IS NOT NULL;

    -- Final message
    RAISE NOTICE 'Silver tables have been successfully updated.';
END;
$$;
