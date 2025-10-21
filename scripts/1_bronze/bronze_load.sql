/* 
=====================================
            WARNING !!!
=====================================
Error 'Permission denied' while uploading data. Paste the code below in pgAdmin4, PSQL Tool to load data manually:
    \copy bronze.sap_ess FROM 'C:\Users\(...)\OneDrive - (...)\Desktop\ess.csv' WITH (FORMAT csv, HEADER true, DELIMITER ';', ENCODING 'UTF8');
    \copy bronze.wfm_employees FROM 'C:\Users\(...)\OneDrive - (...)\Desktop\wfm.csv' WITH (FORMAT csv, HEADER true, DELIMITER ';', ENCODING 'UTF8'); 
*/

-- Perform the full load on bronze tables 
TRUNCATE TABLE bronze.sap_ess;
COPY bronze.sap_ess
FROM 'C:\Users\(...)\OneDrive - (...)\Desktop\mnp.csv'
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ';',
    ENCODING 'UTF8'
);

TRUNCATE TABLE bronze.wfm_employees;
COPY bronze.wfm_employees
FROM 'C:\Users\(...)\OneDrive - (...)\Desktop\wfm.csv'
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ';',
    ENCODING 'UTF8'
);

INSERT INTO bronze.sap_wbs (
        wbs,
        wbs_description
    )
    SELECT DISTINCT
        wbs,
        wbs_description
    FROM bronze.sap_ess;

