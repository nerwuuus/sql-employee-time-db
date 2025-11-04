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
        "host=localhost dbname=ess user=postgres password=admin"
    )
    cur = conn.cursor()  # Creates a cursor object to execute PostgreSQL commands
    # Truncating and loading data into bronze.sap_ess
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
    # Truncating and loading data into bronze.wfm_employees
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
