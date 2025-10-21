/*
============================================================================
Quality Checks – Gold Layer
============================================================================
Script Purpose:
    This script performs essential quality checks to ensure the integrity,
    accuracy, and consistency of data in the 'gold' layer, which serves as
    the foundation for reporting and analytics. It includes checks for:
    - Completeness and correctness of key business metrics.
    - Consistency between aggregated values and source data.
    - Validation of financial calculations (e.g., daily rates).
    - Detection of anomalies in date ranges and time-based aggregations.
    - Referential integrity between enriched dimensions and facts.

Usage Notes:
    - Run these checks after transforming and aggregating data into the Gold Layer.
    - Use results to validate business logic and ensure readiness for reporting.
    - Investigate any discrepancies or anomalies before publishing data.
============================================================================
*/
WITH subquery AS (
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
        TO_CHAR(time_registration_date, 'YYYY') = TO_CHAR(NOW(), 'YYYY')
)
SELECT 
    MIN(time_registration_date),
    MAX(time_registration_date)
FROM subquery;
