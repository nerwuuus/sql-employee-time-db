-- Expected result: table with all time recording
SELECT *
FROM bronze.sap_ess;



-- Expected result: table with employees data
SELECT *
FROM bronze.wfm_employees;



-- Expected result: number of rows == number of rows in .csv file
SELECT COUNT(*)
FROM bronze.sap_ess;



-- Expected result: last month's time registration available
/*
CURRENT_DATE gets today's date.
date_trunc('month', CURRENT_DATE) gives the first day of the current month.
Subtracting interval '1 month' gives the first day of the previous month.
TO_CHAR(..., 'YYYY-MM') formats it to match comparison string.
*/
SELECT *
FROM bronze.sap_ess
WHERE 
    TO_CHAR(time_registration_date, 'YYYY-MM') = TO_CHAR(date_trunc('month', CURRENT_DATE) - INTERVAL '1 month', 'YYYY-MM')



-- Run this query to see all column names in bronze.wfm_employees
SELECT column_name
FROM information_schema.columns
WHERE table_name = 'wfm_employees'
  AND table_schema = 'bronze';



-- Run this query to see all column names in bronze.sap_ess
SELECT column_name
FROM information_schema.columns
WHERE table_name = 'sap_ess'
  AND table_schema = 'bronze';
