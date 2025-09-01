/* 

=====================================
            WARNING !!!
=====================================
Error 'Permission denied' while uploading data. Paste the code below in pgAdmin4, PSQL Tool to load data manually:
  \copy bronze.ess_mnp_info FROM 'C:\Users\a817628\OneDrive - ATOS\Desktop\mnp.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
  \copy bronze.ess_inm FROM 'C:\Users\a817628\OneDrive - ATOS\Desktop\inm.csv';
  \copy bronze.wfm_employees FROM 'C:\Users\a817628\OneDrive - ATOS\Desktop\wfm.csv'

*/

-- Perform the full load on bronze ess and wfm tables
TRUNCATE TABLE bronze.ess_mnp;
COPY bronze.ess_mnp
FROM 'C:\Users\a817628\OneDrive - ATOS\Desktop\mnp.csv'
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ',',
    ENCODING 'UTF8'
);

TRUNCATE TABLE bronze.ess_inm;
COPY bronze.ess_mnp
FROM 'C:\Users\a817628\OneDrive - ATOS\Desktop\inm.csv'
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ',',
    ENCODING 'UTF8'
);

TRUNCATE TABLE bronze.wfm_employees;
COPY bronze.wfm_employees
FROM 'C:\Users\a817628\OneDrive - ATOS\Desktop\wfm.csv'
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ',',
    ENCODING 'UTF8'
);

