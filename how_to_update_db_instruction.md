# Work instruction
## 1. Update ess.xlsx
Instructions on how to update ess.xlsx report using PowerQuery: https://(...).sharepoint.com/:w:/r/sites/(...)

## 2. Export ess.xlsx 
* Save ess.xlsx file as ess.csv file. 
* Open ess.xlsx file and change the data format (column C) to YYYY-MM-DD. Ensure that in column G floats use '.' as a separator instead of ',', and column nessie (column B) is an INT data type - remove any floats if necessary.

## 3. Export WFM.xlsx file.
* Save WFM.xlsx file as wfm.csv file.
* Run the below script to clean up the data:
```python
import pandas as pd

# import CSV file
df = pd.read_csv(
    r"C:\Users\(...)\OneDrive - (...)\Desktop\WFM (...)2025.csv",
    delimiter=';')
# show the data
df.head(0).iloc[:, 5:]

# drop columns
df = df.drop(columns=[
    'DAS ID', 'FL/Subco', 'Subco Agency', 'FirstName', 'LastName', 'Employee Last name + First name', 'Gender',
    'StartDate', 'EndDate', 'Dummy\n/\nRoma Nr.', 'WBS',
    'Jan 25 FTE Count ', 'Feb 25 FTE Count ', 'Mar 25 FTE Count ',
    'Apr 25 FTE Count ', 'May 25 FTE Count ', 'Jun 25 FTE Count',
    'Jul 25 FTE Count ', 'Aug 25 FTE Count ', 'Sep 25 FTE Count ',
    'Oct 25 FTE Count ', 'Nov 25 FTE Count ', 'Dec 25 FTE Count ',
    'Customer n°', 'Customer', 'Contract Type', 'Hourly\nSales Rate', '% Margin',
    'Profile', 'Division', 'Location', 'Contractual Profile (10.A)',
    'Seniority', ' Sales ', 'Margin', 'Total cost/month',
    'Total sales/month', 'Organizational Unit', 'Replaceable', 'Note',
    'Email address', 'External (BE) Contract End Date', 'PM',
    'Clause Travel expense in SA', 'das profile', 'Overtime allowed',
    'Standby allowed'
])

# rename columns to match SQL bronze layer structure
df = df.rename(columns={
    'NESSIE ID':'nessie', 
    'Internal or external employee':'employment_type', 
    'Country':'country',
    'Employee First name + Last name (without "LEFT")':'name', 
    'Contract':'contract',
    'GCM Level':'gcm_level', 
    'Hourly PURCHASE PRICE':'hourly_rate', 
    'Competence':'competence', 
    ' Cost ':'daily_rate',
})

# check numeric columns, replace NaN and cast the data type if necessary
# ensure that column nessie is an object(!)
df['nessie'].dtype
# cast the data type from str to numeric, if necessary
df['nessie'] = pd.to_numeric(df['nessie'])
# count NaN values
df['nessie'].value_counts(dropna=False)
# replace NaN values with 0
df['nessie'] = df['nessie'].fillna(0)
# df['gcm_level'] = df['gcm_level'].fillna(0)

# format numeric columns (Copilot helped here 🫡)
df['nessie'] = df['nessie'].map(lambda x:'{:.0f}'.format(x) if x.is_integer() else str(x))
df['gcm_level'] = df['gcm_level'].map(lambda x:'{:.0f}'.format(x) if x.is_integer() else str(x))

# extract competence and drop unnecessary columns
df['competence'] = df['competence'].str.split(',', expand=True).drop([1, 2, 3, 4, 5], axis=1)
# contract should contain 3 letters - extract it
df['contract'] = df['contract'].str.split(' ', expand=True).drop([1, 2], axis=1)

# set employee number (nessie) as index
df.set_index('nessie')

# remove trailing spaces
df['name'] = df['name'].str.strip()
df['competence'] = df['competence'].str.strip()

# Remove '€' symbols and cast the data type from str to float. '\s' removes any whitespace, 'regex=True' ensures the pattern works as a regex.
df['hourly_rate'] = df['hourly_rate'].str.replace(r'[€\s]', '', regex=True).astype(float)
df['daily_rate'] = df['daily_rate'].str.replace(r'[€\s]', '', regex=True)

# save on desktop as wfm.csv
df.to_csv('wfm.csv', sep=',', encoding='utf-8', index=False, header=True)

```

## 4. Load data into the bronze layer
Run Python script to truncate bronze layer tables and load data into bronze layer tables:
```Python
# ============================================================================
# This script is a Python ETL (Extract, Transform, Load) process using 
# the psycopg2 library to interact with a PostgreSQL database.
# ============================================================================
# First time run:
#   1) Open PowerShell and download psycopg2: pip install psycopg2.
#   2) Run the below script.
# ============================================================================
# In short:
#   try: → Attempt the main logic.
#   except: → Handle errors and undo changes with rollback().
#   finally: → Close database resources safely.
# ============================================================================ 

# Importing the psycopg2 library
import psycopg2

# Define table names where data will be truncated and loaded
table_name1 = "bronze.sap_ess"
table_name2 = "bronze.wfm_employees"
table_name3 = "bronze.sap_wbs"

try: # try block contains a code that might raise an error. If everything runs fine, the except block is skipped
    # Connecting to the PostgreSQL database
    conn = psycopg2.connect(
        "host=(...) dbname=ess user=(...) password=(...)"
    )
    cur = conn.cursor()  # Creates a cursor object to execute PostgreSQL commands
    # Truncating and loading data into bronze.sap_ess
    cur.execute(f"TRUNCATE TABLE {table_name1};")
    with open(r"C:\Users\(...)\OneDrive - (...)\Desktop\ess.csv", "r", encoding="utf-8") as f:
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
    # Truncating and loading data into bronze.wfm_employees
    cur.execute(f"TRUNCATE TABLE {table_name2};")
    with open(r"C:\Users\(...)\OneDrive - (...)\Desktop\wfm.csv", "r", encoding="utf-8") as f:
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
    # Truncating and loading data into bronze.sap_wbs
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
    # Committing changes to the ess database
    conn.commit()
    print(f"Data was loaded successfully to the tables: {table_name1}, {table_name2}, and {table_name3}.")

except Exception as e: # Executes only if an error occurs inside the try block and captures the error details in the variable e
    # If something goes wrong before commit(), calling rollback() undoes all changes made in the current transaction, restoring the database to its previous state
    conn.rollback()
    print("An error occurred during the data load process:", e)

finally: # this block runs no matter what happens (success or error)
    # Closing the cursor and connection
    if 'cur' in locals():
        cur.close()
    if 'conn' in locals():
        conn.close()

```
## 5. Load data into the silver layer
Truncate and load the data into the silver layer using a procedure.

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













