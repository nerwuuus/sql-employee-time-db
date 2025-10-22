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

# Table names for logging
table_name1 = "bronze.sap_ess_staging"
table_name2 = "bronze.wfm_employees_staging"
table_name3 = "bronze.sap_wbs_staging"

try:
    # Connecting to the PostgreSQL database
    conn = psycopg2.connect(
        "host=localhost dbname=ess_staging user=postgres password=admin"
    )
    cur = conn.cursor()  # Creates a cursor object to execute PostgreSQL commands

    # Truncating and loading data into bronze.sap_ess_staging
    cur.execute(f"TRUNCATE TABLE {table_name1};")
    with open(r"C:\Users\a817628\OneDrive - ATOS\Desktop\ess.csv", "r", encoding="utf-8") as f:
        cur.copy_expert(f"""
            COPY {table_name1}
            FROM STDIN
            WITH (
                FORMAT csv,
                HEADER true,
                DELIMITER ';',
                ENCODING 'UTF8'
            )
        """, f)

    # Truncating and loading data into bronze.wfm_employees_staging
    cur.execute(f"TRUNCATE TABLE {table_name2};")
    with open(r"C:\Users\a817628\OneDrive - ATOS\Desktop\wfm.csv", "r", encoding="utf-8") as f:
        cur.copy_expert(f"""
            COPY {table_name2}
            FROM STDIN
            WITH (
                FORMAT csv,
                HEADER true,
                DELIMITER ';',
                ENCODING 'UTF8'
            )
        """, f)

    # Truncating and loading data into bronze.sap_wbs_staging
    cur.execute(f"TRUNCATE TABLE {table_name3};")
    cur.execute(f"""
        INSERT INTO {table_name3} (
            wbs,
            wbs_description
        )
        SELECT DISTINCT
            wbs,
            wbs_description
        FROM {table_name1};
    """)

    # Committing changes
    conn.commit()
    print(f"Data was loaded successfully to the tables: {table_name1}, {table_name2}, and {table_name3}.")

except Exception as e:
    # Rollback in case of error
    conn.rollback()
    print("An error occurred during the data load process:", e)

finally:
    # Closing resources
    if 'cur' in locals():
        cur.close()
    if 'conn' in locals():
        conn.close()
```
## 3. Call the below procedure to truncate silver tables and load a new data into silver layer

```sql
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
```
