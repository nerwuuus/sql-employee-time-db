/*
============================================================================
DDL Script: Create Gold Views
============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse.
    The Gold layer represents the final dimension and fact tables (Star Schema)

    Each view performs transformations and combines data from the Silver layer
    to produce a clean, enriched, and business-ready dataset.

Usage:
- These views can be queried directly for analytics and reporting.
============================================================================
*/

DROP VIEW IF EXISTS gold.fact_time_all;
CREATE OR REPLACE VIEW gold.fact_time_all AS
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
    FROM silver.ess_inm AS inm;


-- Filter out last month's approved hours (dynamic script)
DROP VIEW IF EXISTS gold.fact_recent_approved_hours;
CREATE VIEW gold.fact_recent_approved_hours AS
    SELECT
        name,
        nessie,
        date,
        wbs,
        hours AS daily_approved_hours,
        SUM(hours) OVER (PARTITION BY name) AS total_approved_hours
    FROM gold.fact_time_all
    WHERE
        TO_CHAR(date, 'MM-YYYY') = TO_CHAR(CURRENT_DATE - INTERVAL '1 month', 'MM-YYYY')
        AND status = 'Approved';


DROP VIEW IF EXISTS gold.dim_employees;
CREATE VIEW gold.dim_employees AS
    SELECT
        nessie,
        name,
        seniority,
        hourly_rate,
        competence
    FROM silver.wfm_employees

SELECT *
FROM gold.dim_employees