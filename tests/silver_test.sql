/*
============================================================================
Quality Checks
============================================================================
Script Purpose:
    This script performs various quality checks for data consistency, accuracy,
    and standardisation across the 'silver' schemas. It includes checks for:
    - Null or duplicate primary keys.
    - Unwanted spaces in string fields.
    - Data standardisation and consistency.
    - Invalid date ranges and orders.
    - Data consistency between related fields.

Usage Notes:
    - Run these checks after loading the Silver Layer.
    - Investigate and resolve any discrepancies found during the checks.
============================================================================
*/
-- Check for leading or trailing whitespaces in the 'name' column
SELECT name
FROM bronze.sap_ess
WHERE name != TRIM(name);
-- Expected result: no result
SELECT name
FROM silver.sap_ess
WHERE name != TRIM(name);



-- Data standardisation & consistency in the low cardinality columns
SELECT DISTINCT status
FROM bronze.sap_ess; 
-- Expectation: no results
SELECT DISTINCT status
FROM silver.sap_ess; 



-- Check high cardinality columns for NULLs
SELECT DISTINCT wbs
FROM bronze.sap_ess
WHERE wbs IS NULL;
-- Expectation: no results
SELECT DISTINCT wbs
FROM silver.sap_ess
WHERE wbs IS NULL;

SELECT DISTINCT wbs_description
FROM bronze.sap_ess
WHERE wbs_description IS NULL; 
-- Expectation: no results
SELECT DISTINCT wbs_description
FROM silver.sap_ess
WHERE wbs_description IS NULL; 

SELECT DISTINCT nessie
FROM bronze.sap_ess
WHERE nessie IS NULL;
-- Expectation: no results
SELECT DISTINCT nessie
FROM silver.sap_ess
WHERE nessie IS NULL;



-- Check for NULLs or negative numbers
SELECT hours
FROM bronze.sap_ess
WHERE 
    hours IS NULL 
    OR hours > 24 
    OR hours < 0
    OR hours = 0; 
-- Expectation: no result
SELECT hours
FROM silver.sap_ess
WHERE 
    hours IS NULL 
    OR hours > 24 
    OR hours < 0
    OR hours = 0; 



-- Check for invalid dates
SELECT time_registration_date
FROM bronze.sap_ess
WHERE
    time_registration_date <= DATE '1900-01-01' OR
    LENGTH(TO_CHAR(time_registration_date, 'YYYYMMDD')) != 8 OR -- Converts the date to a string to check its length
    time_registration_date > CURRENT_DATE OR
    time_registration_date < TO_DATE('20220101', 'YYYYMMDD');
-- Expectation: no result
SELECT time_registration_date
FROM silver.sap_ess
WHERE
    time_registration_date <= DATE '1900-01-01' OR
    LENGTH(TO_CHAR(time_registration_date, 'YYYYMMDD')) != 8 OR -- Converts the date to a string to check its length
    time_registration_date > CURRENT_DATE OR
    time_registration_date < TO_DATE('20220101', 'YYYYMMDD');

-- Check for leading/trailing spaces in names
SELECT name
FROM bronze.wfm_employees
WHERE name != TRIM(name);
-- Expected result: no result
SELECT name
FROM silver.wfm_employees
WHERE name != TRIM(name);

SELECT DISTINCT nessie
FROM bronze.wfm_employees
WHERE nessie IS NULL;
-- Expectation: no results
SELECT DISTINCT nessie
FROM silver.wfm_employees
WHERE nessie IS NULL;
