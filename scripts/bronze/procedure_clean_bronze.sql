/*
============================================================================
Stored Procedure: Truncate Bronze Layer
============================================================================
Script purpose:
  This stored procedure removes rows from the 'bronze' schema.
  It performs the following actions:
  - Truncates all bronze tables before loading new data.
  - Prints a custom message after execution.
============================================================================
Needed only when the procedure with the same name exists:
  DROP FUNCTION IF EXISTS bronze.clean_bronze(); 
============================================================================
*/

-- Invoke a procedure
CALL bronze.clean_bronze();

CREATE OR REPLACE PROCEDURE bronze.clean_bronze()
LANGUAGE plpgsql
AS $$
BEGIN
    TRUNCATE TABLE bronze.sap_mnp;
    TRUNCATE TABLE bronze.sap_inm;
    TRUNCATE TABLE bronze.wfm_employees;

    -- Custom message
    RAISE NOTICE 'Bronze tables have been successfully truncated.';
END;
$$;
