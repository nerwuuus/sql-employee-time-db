/*
===============================================================================
Quality Checks
===============================================================================
Script Purpose:
    This script performs quality checks to validate the integrity, consistency, 
    and accuracy of the Gold Layer. These checks ensure:
    - Uniqueness of surrogate keys in dimension tables.
    - Referential integrity between fact and dimension tables.
    - Validation of relationships in the data model for analytical purposes.

Usage Notes:
    - Investigate and resolve any discrepancies found during the checks.
===============================================================================
*/

-- Compare the results of the silver.ess_mnp and silver.ess_inm tables using a UNION operation
-- Expectation: no results
WITH union_result AS (
    SELECT
        mnp.name,
        mnp.nessie,
        mnp.date,
        mnp.status,
        mnp.wbs,
        mnp.wbs_description,
        mnp.hours
    FROM silver.ess_mnp AS mnp
    UNION
    SELECT
        inm.name,
        inm.nessie,
        inm.date,
        inm.status,
        inm.wbs,
        inm.wbs_description,
        inm.hours
    FROM silver.ess_inm AS inm
),
union_all_result AS (
    SELECT
        mnp.name,
        mnp.nessie,
        mnp.date,
        mnp.status,
        mnp.wbs,
        mnp.wbs_description,
        mnp.hours
    FROM silver.ess_mnp AS mnp
    UNION ALL
    SELECT
        inm.name,
        inm.nessie,
        inm.date,
        inm.status,
        inm.wbs,
        inm.wbs_description,
        inm.hours
    FROM silver.ess_inm AS inm
)
SELECT * FROM union_all_result
EXCEPT
SELECT * FROM union_result;

SELECT * FROM union_result
EXCEPT
SELECT * FROM union_all_result;
