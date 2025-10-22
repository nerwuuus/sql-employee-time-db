''' 
============================================================================
Database ess_staging was created to test Python script loading data into
database.
============================================================================ 
'''
CREATE SCHEMA bronze;
CREATE SCHEMA silver;
CREATE SCHEMA gold;

-- DDL bronze & silver staging
DROP TABLE IF EXISTS bronze.sap_ess_staging;
CREATE TABLE bronze.sap_ess_staging (
    name VARCHAR(255),
    nessie INT,
    time_registration_date DATE,
    status VARCHAR(255),
    wbs VARCHAR(255),
    wbs_description VARCHAR(255),
    hours NUMERIC(4, 2)
);

DROP TABLE IF EXISTS bronze.wfm_employees_staging;
CREATE TABLE bronze.wfm_employees_staging (
    nessie INT,
    employment_type VARCHAR(50),
    country VARCHAR(50),
    name VARCHAR(50),
    contract VARCHAR(50),
    gcm_level INT,
    hourly_rate NUMERIC(5,2),
    competence VARCHAR(255),
    daily_rate NUMERIC(6,2),
    active_flag INT
);

DROP TABLE IF EXISTS silver.sap_ess_staging;
CREATE TABLE silver.sap_ess_staging (
    name VARCHAR(255),
    nessie INT,
    time_registration_date DATE,
    status VARCHAR(255),
    wbs VARCHAR(255),
    wbs_description VARCHAR(255),
    hours NUMERIC(4,2),
    insert_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
); 

DROP TABLE IF EXISTS silver.wfm_employees_staging;
CREATE TABLE silver.wfm_employees_staging (
    nessie INT,
    employment_type VARCHAR(50),
    country VARCHAR(50),
    name VARCHAR(50),
    contract VARCHAR(50),
    gcm_level VARCHAR(50),
    hourly_rate NUMERIC(5,2),
    competence VARCHAR(255),
    daily_rate NUMERIC(6,2),
    active_flag VARCHAR(50),
    insert_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS silver.sap_wbs_staging;
CREATE TABLE silver.sap_wbs_staging (
    wbs VARCHAR(50),
    wbs_description VARCHAR(50),
    wbs_flag VARCHAR(10)
);

/* 
=====================================
            WARNING !!!
=====================================
Error 'Permission denied' while uploading data. Paste the code below in pgAdmin4, PSQL Tool to load data manually:
    \copy bronze.sap_ess FROM 'C:\Users\a817628\OneDrive - ATOS\Desktop\ess.csv' WITH (FORMAT csv, HEADER true, DELIMITER ';', ENCODING 'UTF8');
    \copy bronze.wfm_employees FROM 'C:\Users\a817628\OneDrive - ATOS\Desktop\wfm.csv' WITH (FORMAT csv, HEADER true, DELIMITER ';', ENCODING 'UTF8'); 
*/
-- -- Perform the full load on bronze tables 
-- TRUNCATE TABLE bronze.sap_ess_staging;
-- COPY bronze.sap_ess_staging
-- FROM 'C:\Users\(...)\OneDrive - (...)\Desktop\mnp.csv'
-- WITH (
--     FORMAT csv,
--     HEADER true,
--     DELIMITER ';',
--     ENCODING 'UTF8'
-- );

-- TRUNCATE TABLE bronze.wfm_employees_staging;
-- COPY bronze.wfm_employees_staging
-- FROM 'C:\Users\(...)\OneDrive - (...)\Desktop\wfm.csv'
-- WITH (
--     FORMAT csv,
--     HEADER true,
--     DELIMITER ';',
--     ENCODING 'UTF8'
-- );
-- TRUNCATE TABLE silver.sap_ess_staging;
-- INSERT INTO silver.sap_ess_staging (
--     name,
--     nessie,
--     time_registration_date,
--     status,
--     wbs,
--     wbs_description,
--     hours
-- )
-- SELECT
--     TRIM(name),
--     COALESCE(nessie, 0),
--     time_registration_date,
--     CASE
--         WHEN status = 'Approval rejected' THEN 'Rejected'
--         WHEN status = 'In process' THEN 'Not released'
--         WHEN status = 'Released for approval' THEN 'Released for approval'
--         ELSE 'Approved'
--     END,
--     TRIM(wbs),
--     TRIM(COALESCE(wbs_description, 'N/A')),
--     CASE
--         WHEN COALESCE(hours, 0) <= 0 THEN 0
--         ELSE hours
--     END
-- FROM bronze.sap_ess
-- WHERE COALESCE(hours, 0) != 0;

-- TRUNCATE TABLE silver.wfm_employees_staging;
-- INSERT INTO silver.wfm_employees_staging (
--     nessie,
--     employment_type,
--     country,
--     name,
--     contract,
--     gcm_level,
--     hourly_rate,
--     competence,
--     daily_rate,
--     active_flag
-- )
-- SELECT
--     COALESCE(nessie, 0) AS nessie,
--     TRIM(employment_type) AS employment_type,
--     TRIM(country) AS country,
--     TRIM(name) AS name,
--     TRIM(contract) AS contract,
--     CASE
--         WHEN gcm_level <= 3 THEN 'Junior'
--         WHEN gcm_level BETWEEN 4 AND 6 THEN 'Regular'
--         ELSE 'Senior'
--     END AS seniority,
--     hourly_rate,
--     TRIM(SPLIT_PART(
--         COALESCE(competence, 'Unknown'), ',',
--         1
--     )) AS competence,
--     NULLIF(daily_rate, 0) AS daily_rate,
--     CASE
--         WHEN active_flag = 0 THEN 'Inactive'
--         ELSE 'Active'
--     END AS active_flag
-- FROM bronze.wfm_employees_staging;

-- Create procedure
CALL silver.truncate_and_load_silver_staging();

CREATE OR REPLACE PROCEDURE silver.truncate_and_load_silver_staging()
LANGUAGE plpgsql
AS $$
BEGIN
    -- Step 1: Truncate and load data into silver.sap_ess_staging table
    TRUNCATE TABLE silver.sap_ess_staging;
    INSERT INTO silver.sap_ess_staging (
        name,
        nessie,
        time_registration_date,
        status,
        wbs,
        wbs_description,
        hours
    )
    SELECT
        TRIM(name),
        COALESCE(nessie, 0),
        time_registration_date,
        CASE
            WHEN status = 'Approval rejected' THEN 'Rejected'
            WHEN status = 'In process' THEN 'Not released'
            WHEN status = 'Released for approval' THEN 'Released for approval'
            ELSE 'Approved'
        END,
        TRIM(wbs),
        TRIM(COALESCE(wbs_description, 'N/A')),
        CASE
            WHEN COALESCE(hours, 0) <= 0 THEN 0
            ELSE hours
        END
    FROM bronze.sap_ess_staging
    WHERE COALESCE(hours, 0) != 0;

    -- Step 2: Truncate and load data into silver.wfm_employees_staging table
    TRUNCATE TABLE silver.wfm_employees_staging;
    INSERT INTO silver.wfm_employees_staging (
        nessie,
        employment_type,
        country,
        name,
        contract,
        gcm_level,
        hourly_rate,
        competence,
        daily_rate,
        active_flag
    )
    SELECT
        COALESCE(nessie, 0) AS nessie,
        TRIM(employment_type) AS employment_type,
        TRIM(country) AS country,
        TRIM(name) AS name,
        TRIM(contract) AS contract,
        CASE
            WHEN gcm_level <= 3 THEN 'Junior'
            WHEN gcm_level BETWEEN 4 AND 6 THEN 'Regular'
            ELSE 'Senior'
        END AS seniority,
        hourly_rate,
        TRIM(SPLIT_PART(
            COALESCE(competence, 'Unknown'), ',',
            1
        )) AS competence,
        NULLIF(daily_rate, 0) AS daily_rate,
        CASE
            WHEN active_flag = 0 THEN 'Inactive'
            ELSE 'Active'
        END AS active_flag
    FROM bronze.wfm_employees_staging;
    
    -- Step 3: Truncate and load data into silver.sap_wbs_staging table
    TRUNCATE TABLE silver.sap_wbs_staging;
    INSERT INTO silver.sap_wbs_staging (
        wbs,
        wbs_description,
        wbs_flag
    )
    SELECT
        TRIM(COALESCE(wbs, 'Unknown')) AS wbs,
        TRIM(COALESCE(wbs_description, 'No Description Available')) AS wbs_description,
        CASE
            WHEN LEFT(wbs, 8) IN (
                'BL740116',
                'BL740117',
                'BL740844',
                'BL740409',
                'BL742577',
                'BL742578',
                'BL742608'
                ) THEN 'MNP'
            WHEN LEFT(wbs, 8) IN (
                'BL740565',
                'BL743773',
                'BL743994',
                'BL743845'
            ) THEN 'iNM'
            WHEN LEFT(wbs, 8) = 'BL738948' THEN 'BIP'
            ELSE wbs
        END AS wbs_flag
    FROM bronze.sap_wbs_staging;

    -- Final message
    RAISE NOTICE 'Silver tables have been successfully updated.';
END;
$$;
