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
-- Expected result: no result
SELECT name
FROM bronze.sap_inm
WHERE name != TRIM(name);

SELECT name
FROM bronze.sap_mnp
WHERE name != TRIM(name);


/* Data standardisation & consistency in the low cardinality columns */
-- Expectation: no results
SELECT DISTINCT status
FROM bronze.sap_mnp; 

SELECT DISTINCT status
FROM bronze.sap_inm;


-- Check high cardinality columns for NULLs
-- Expectation: no results
SELECT DISTINCT wbs
FROM bronze.sap_mnp
WHERE wbs IS NULL;

SELECT DISTINCT wbs
FROM bronze.sap_inm
WHERE wbs IS NULL;

SELECT DISTINCT wbs_description
FROM bronze.sap_inm
WHERE wbs_description IS NULL;

SELECT DISTINCT wbs_description
FROM bronze.sap_mnp
WHERE wbs_description IS NULL; 

SELECT DISTINCT nessie
FROM bronze.sap_inm
WHERE nessie IS NULL;

SELECT DISTINCT nessie
FROM bronze.sap_mnp
WHERE nessie IS NULL;


-- Check for NULLs or negative numbers
-- Expectation: no result
SELECT hours
FROM bronze.sap_inm
WHERE 
    hours IS NULL 
    OR hours > 24 
    OR hours < 0
    OR hours = 0; 

SELECT hours
FROM bronze.sap_mnp
WHERE 
    hours IS NULL 
    OR hours > 24 
    OR hours < 0
    OR hours = 0; 

-- Check for invalid dates
-- Expectation: no result
SELECT date
FROM bronze.sap_inm
WHERE
    date <= DATE '1900-01-01' OR
    LENGTH(TO_CHAR(date, 'YYYYMMDD')) != 8 OR -- Converts the date to a string to check its length
    date > CURRENT_DATE OR
    date < TO_DATE('20220101', 'YYYYMMDD');

SELECT date
FROM bronze.sap_mnp
WHERE
    date <= DATE '1900-01-01' OR
    LENGTH(TO_CHAR(date, 'YYYYMMDD')) != 8 OR -- Converts the date to a string to check its length
    date > CURRENT_DATE OR
    date < TO_DATE('20220101', 'YYYYMMDD');

SELECT
    nessie,
    internal_or_external,
    name,
    gcm_level,
    hourly_rate,
    competence
FROM bronze.wfm_employees
WHERE nessie IS NULL;

