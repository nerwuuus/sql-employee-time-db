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

-- Registered hours from last month (dynamic script) integrated with WFM data
DROP VIEW IF EXISTS gold.fact_last_month;
CREATE OR REPLACE VIEW gold.fact_last_month AS
    SELECT
        s.name,
        s.nessie,
        s.time_registration_date,
        s.status,
        s.wbs,
        s.wbs_description,
        s.hours,
        w.contract,
        w.gcm_level,
        w.hourly_rate,
        ROUND((w.hourly_rate * s.hours), 2) AS daily_rate,
        w.competence,
        w.active_flag
    FROM silver.sap_ess AS s
    LEFT JOIN silver.wfm_employees AS w
        ON w.nessie = s.nessie
    WHERE 
        TO_CHAR(time_registration_date, 'YYYY-MM') = TO_CHAR(date_trunc('month', CURRENT_DATE) - INTERVAL '1 month', 'YYYY-MM');


-- Registered hours from 2022 until last month and integrated with WFM data
DROP VIEW IF EXISTS gold.fact_time_all;
CREATE OR REPLACE VIEW gold.fact_time_all AS
    SELECT
        s.name,
        s.nessie,
        s.time_registration_date,
        s.status,
        s.wbs,
        s.wbs_description,
        s.hours,
        w.contract,
        w.gcm_level,
        w.hourly_rate,
        ROUND((w.hourly_rate * s.hours), 2) AS daily_rate,
        w.competence,
        w.active_flag
    FROM silver.sap_ess AS s
    LEFT JOIN silver.wfm_employees AS w
        ON w.nessie = s.nessie;


-- Registered hours from the current year (dynamic script) integrated with WFM data
DROP VIEW IF EXISTS gold.fact_current_year;
CREATE OR REPLACE VIEW gold.fact_current_year AS
    SELECT
        s.name,
        s.nessie,
        s.time_registration_date,
        s.status,
        s.wbs,
        s.wbs_description,
        s.hours,
        w.contract,
        w.gcm_level,
        w.hourly_rate,
        ROUND((w.hourly_rate * s.hours), 2) AS daily_rate,
        w.competence,
        w.active_flag
    FROM silver.sap_ess AS s
    LEFT JOIN silver.wfm_employees AS w
        ON w.nessie = s.nessie
    WHERE 
        TO_CHAR(time_registration_date, 'YYYY') = TO_CHAR(NOW(), 'YYYY');


-- List of all WBS, WBS description and subcontract description (flag)
DROP VIEW IF EXISTS gold.dim_wbs;
CREATE OR REPLACE VIEW gold.dim_wbs AS
    SELECT *
    FROM silver.sap_wbs;


