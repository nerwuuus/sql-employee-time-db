# Work instruction
## 1. Update ess.xlsx
Instructions on how to update ess.xlsx report: https://atos365.sharepoint.com/:w:/r/sites/EurocontrolMNPAMO/Shared%20Documents/AMO/MNP%20Time%20Management/Eurocontrol%20MNP%20Time%20Management%20Reporting.docx?d=w4bf064b9ffa24bd4a72edd7579cfa302&csf=1&web=1&e=XmjI6i

## 2. Export ess.xlsx and wfm.xlsx
* Save ess.xlsx file as ess.csv file. Do the same with the WFM file.
* Open ess.xlsx file and change data format (column C) to YYYY-MM-DD. Ensure that in the column G floats use '.' as separator instead of ',', and column nessie (column B) is INT data type - remove any floats if necessary.
* Run this Python script to truncate bronze layer tables and load data into bronze layer tables:
```Python
# ============================================================================
# Open PowerShell and download psycopg2: pip install psycopg2.
# Run the below script.
# ============================================================================ 

# Importing the psycopg2 library
import psycopg2

# Connecting to the PostgreSQL database
conn = psycopg2.connect(
    "host=localhost dbname=ess_staging user=postgres password=admin"
)
cur = conn.cursor() # Creates a cursor object (cur) to execute PostgreSQL commands

# Truncating the first table bronze.sap_ess
cur.execute(
    "TRUNCATE TABLE bronze.sap_ess;"
)

# Load new data from the ess.csv file
with open(r"C:\Users\a817628\OneDrive - ATOS\Desktop\ess.csv", "r", encoding="utf-8") as f:
    cur.copy_expert("""
        COPY bronze.sap_ess
        FROM STDIN
        WITH (
            FORMAT csv,
            HEADER true,
            DELIMITER ';',
            ENCODING 'UTF8'
        )
    """, f)

# Truncating the second table bronze.wfm_employees
cur.execute(
    "TRUNCATE TABLE bronze.wfm_employees;"
)

# Loading new data from the wfm.csv file
with open(r"C:\Users\a817628\OneDrive - ATOS\Desktop\wfm.csv", "r", encoding="utf-8") as f:
    cur.copy_expert("""
        COPY bronze.wfm_employees
        FROM STDIN
        WITH (
            FORMAT csv,
            HEADER true,
            DELIMITER ';',
            ENCODING 'UTF8'
        )
    """, f)

# Truncating the third table bronze.sap_wbs
cur.execute(
    "TRUNCATE TABLE bronze.sap_wbs;"
)

# Loading new data from bronze.sap_ess table into bronze.sap_wbs
cur.execute(
    """INSERT INTO bronze.sap_wbs (
        wbs,
        wbs_description
    )
    SELECT DISTINCT
        wbs,
        wbs_description
    FROM bronze.sap_ess;"""
)

# Committing changes and closing the connection
conn.commit() # commit all changes made
cur.close() # close the cursor 
conn.close() # close the connection to the PostgreSQL database

# Printing a success message
table_name1 = "bronze.sap_ess"
table_name2 = "bronze.wfm_employees"
table_name3 = "bronze.sap_wbs"
print(f"Data was loaded successfully to the table {table_name1}, {table_name2} and {table_name3}.")
```
## 3. Call the below procedure to truncate silver tables and load a new data into silver layer

```sql
CALL silver.truncate_and_load_silver();

CREATE OR REPLACE PROCEDURE silver.truncate_and_load_silver()
LANGUAGE plpgsql
AS $$
BEGIN
    -- Step 1: Truncate and load data into silver.sap_ess table
    TRUNCATE TABLE silver.sap_ess;
    INSERT INTO silver.sap_ess (
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
    FROM bronze.sap_ess
    WHERE COALESCE(hours, 0) != 0;

    -- Step 2: Truncate and load data into silver.wfm_employees table
    TRUNCATE TABLE silver.wfm_employees;
    INSERT INTO silver.wfm_employees (
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
    FROM bronze.wfm_employees;

    -- Step 3: Truncate and load data into silver.sap_wbs table
    TRUNCATE TABLE silver.sap_wbs;
    INSERT INTO silver.sap_wbs (
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
    FROM bronze.sap_wbs;

    -- Final message
    RAISE NOTICE 'Silver tables have been successfully updated.';
END;
$$;

```
