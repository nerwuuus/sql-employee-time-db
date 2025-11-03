# ============================================================================
# Install SQl libraries using Power Shell:
#   pip install sqlalchemy
#   pip install sqlalchemy pg8000
# SQL Alchemy provides an abstraction layer for database connections.   
# PG8000 a lightweight library to connect Python with Postgres.
# ============================================================================

# importing libraries
from sqlalchemy import create_engine
import pandas as pd
import matplotlib.pyplot as plt

# PostgreSQL connection details
username = 'postgres'
password = 'admin'
host = 'localhost'
port = '5432'
database = 'ess'

# create connection using create_engine (which acts as the main interface between Python code and the database)
engine = create_engine(
    f'postgresql+pg8000://{username}:{password}@{host}:{port}/{database}'
    )

# fetch the data from PostgreSQL server - bronze layer (raw data)
df_bronze = pd.read_sql(
    'SELECT * FROM bronze.sap_ess',
    con=engine # con=engine in pd.read_sql() tells pandas which database connection to use when executing the SQL query
)
# validate the output
# expected result: (number of rows, number of columns)
print(df_bronze.shape)
# preview the data
# output: first 5 rows of the table
print(df_bronze.head())
# inspect df
print(df_bronze.info())

# fetch the data from PostgreSQL server - gold layer (processed data)
df_gold_last_month = pd.read_sql(
    'SELECT * FROM gold.fact_last_month',
    con=engine 
)
