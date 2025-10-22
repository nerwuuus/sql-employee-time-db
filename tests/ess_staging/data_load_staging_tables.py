''' 
============================================================================
Open PowerShell and download psycopg2: pip install psycopg2.
Run the below script.
============================================================================ 
'''
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
