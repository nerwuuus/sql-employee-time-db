SELECT 
    COUNT(nessie),
    nessie
FROM bronze.wfm_employees_staging
GROUP BY nessie
HAVING COUNT(*) > 1

