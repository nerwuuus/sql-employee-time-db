''' 
============================================================================
Open PowerShell and download psycopg2: pip install psycopg2.
Run the script below.
============================================================================ 
'''
# Importing the psycopg2 library
import psycopg2

# Connecting to the PostgreSQL database
conn = psycopg2.connect(
    "host=(..) dbname=ess_staging user=(..) password=(..)"
)
cur = conn.cursor() # Creates a cursor object (cur) to execute PostgreSQL commands

# Truncating the first table bronze.sap_ess_staging
cur.execute(
    "TRUNCATE TABLE bronze.sap_ess_staging;"
)

# Load new data from the ess.csv file
with open(r"C:\Users\(..)\OneDrive - (..)\Desktop\ess.csv", "r", encoding="utf-8") as f:
    cur.copy_expert("""
        COPY bronze.sap_ess_staging
        FROM STDIN
        WITH (
            FORMAT csv,
            HEADER true,
            DELIMITER ';',
            ENCODING 'UTF8'
        )
    """, f)

# Truncating the second table bronze.wfm_employees_staging
cur.execute(
    "TRUNCATE TABLE bronze.wfm_employees_staging;"
)

# Loading new data from the wfm.csv file
with open(r"C:\Users\(..)\OneDrive - (..)\Desktop\wfm.csv", "r", encoding="utf-8") as f:
    cur.copy_expert("""
        COPY bronze.wfm_employees_staging
        FROM STDIN
        WITH (
            FORMAT csv,
            HEADER true,
            DELIMITER ';',
            ENCODING 'UTF8'
        )
    """, f)

# Committing changes and closing the connection
conn.commit() # commit all changes made
cur.close() # close the cursor 
conn.close() # close the connection to the PostgreSQL database

# Printing a success message
table_name1 = "bronze.sap_ess_staging"
table_name2 = "bronze.wfm_employees_staging"
print(f"Data was loaded successfully to the table {table_name1} and {table_name2}")

