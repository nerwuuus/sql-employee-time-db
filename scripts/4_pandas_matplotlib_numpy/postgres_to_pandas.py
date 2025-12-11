# ====================================================================================
# Install SQL libraries using PowerShell:
#   pip install sqlalchemy
#   pip install sqlalchemy pg8000
# SQLAlchemy: Python library for database access and ORM (Object Relational Mapping).
# PG8000: Pure-Python driver for connecting to PostgreSQL databases.
# ====================================================================================

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

# fetch the data from PostgreSQL ess server - bronze layer (raw data)
df_ess_bronze = pd.read_sql(
    'SELECT * FROM bronze.sap_ess',
    con=engine # con=engine in pd.read_sql() tells pandas which database connection to use when executing the SQL query
)
# validate the output
# expected result: (number of rows, number of columns)
print(df_ess_bronze.shape)
# preview the data
# output: first 5 rows of the table
print(df_ess_bronze.head())
# inspect df
print(df_ess_bronze.info())

# fetch the data from PostgreSQL server - gold layer (processed data)
df_ess_gold = pd.read_sql(
    'SELECT * FROM gold.fact_last_month',
    con=engine 
)
