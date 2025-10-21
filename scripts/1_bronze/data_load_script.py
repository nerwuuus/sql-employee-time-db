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
