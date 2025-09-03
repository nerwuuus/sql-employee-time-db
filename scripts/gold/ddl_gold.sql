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
        mnp.nessie AS id,
        mnp.name,
        mnp.work_date,
        mnp.status,
        mnp.wbs,
        mnp.wbs_description,
        mnp.hours
    FROM silver.sap_mnp AS mnp
    UNION
    SELECT
        inm.nessie AS id,
        inm.name,
        inm.work_date,
        inm.status,
        inm.wbs,
        inm.wbs_description,
        inm.hours
    FROM silver.sap_inm AS inm;


-- Filter out last month's approved hours (dynamic script)
DROP VIEW IF EXISTS gold.fact_recent_approved_hours;
CREATE VIEW gold.fact_recent_approved_hours AS
    SELECT
        id,
        name,
        work_date,
        wbs,
        hours AS daily_approved_hours,
        SUM(hours) OVER (PARTITION BY name) AS total_approved_hours
    FROM gold.fact_time_all
    WHERE
        TO_CHAR(work_date, 'MM-YYYY') = TO_CHAR(CURRENT_DATE - INTERVAL '1 month', 'MM-YYYY')
        AND status = 'Approved';


DROP VIEW IF EXISTS gold.dim_employees;
CREATE VIEW gold.dim_employees AS
    SELECT
        nessie AS id,
        name,
        seniority,
        hourly_rate,
        competence
    FROM silver.wfm_employees;


DROP VIEW IF EXISTS gold.fact_employees_hours;
CREATE VIEW gold.fact_employees_hours AS
    SELECT
        frah.id,
        frah.name,
        frah.work_date,
        frah.wbs,
        frah.daily_approved_hours,
        frah.total_approved_hours,
        de.seniority,
        de.hourly_rate,
        de.competence
    FROM gold.fact_recent_approved_hours AS frah
    LEFT JOIN gold.dim_employees AS de
        ON frah.id = de.id
    WHERE de.hourly_rate IS NOT NULL;
