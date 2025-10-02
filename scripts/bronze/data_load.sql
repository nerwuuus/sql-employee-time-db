/* 
=====================================
            WARNING !!!
=====================================
Error 'Permission denied' while uploading data. Paste the code below in pgAdmin4, PSQL Tool to load data manually:
  \copy bronze.sap_mnp FROM 'C:\Users\(...)\OneDrive - (...)\Desktop\mnp.csv' WITH (FORMAT csv, HEADER true, DELIMITER ';', ENCODING 'UTF8');
  \copy bronze.sap_inm FROM 'C:\Users\(...)\OneDrive - (...)\Desktop\inm.csv' WITH (FORMAT csv, HEADER true, DELIMITER ';', ENCODING 'UTF8');
  \copy bronze.wfm_employees FROM 'C:\Users\(...)\OneDrive - (...)\Desktop\wfm.csv' WITH (FORMAT csv, HEADER true, DELIMITER ';', ENCODING 'UTF8');
*/

-- Perform the full load on bronze ess and wfm tables
TRUNCATE TABLE bronze.sap_mnp;
COPY bronze.sap_mnp
FROM 'C:\Users\(...)\OneDrive - (...)\Desktop\mnp.csv'
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ';',
    ENCODING 'UTF8'
);

TRUNCATE TABLE bronze.sap_inm;
COPY bronze.sap_inm
FROM 'C:\Users\(...)\OneDrive - (...)\Desktop\inm.csv'
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

SELECT *
FROM bronze.wfm_employees
