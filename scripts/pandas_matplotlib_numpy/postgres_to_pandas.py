# ============================================================================
# Install SQl libraries using Power Shell:
#   pip install sqlalchemy
#   pip install sqlalchemy pg8000
# SQL Alchemy provides an abstraction layer for database connections.   
# PG8000 a lightweight library to connect Python with Postgres.
# ============================================================================

# importing libraries
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

# PostgreSQL connection details
username = '(...)'
password = '(...)'
host = '(...)'
port = '(...)'
database = 'ess'

# create connection
database = f'postgresql+pg8000://{username}:{password}@{host}:{port}/{database}'

# fetch the data from PostgreSQL server - bronze layer (raw data)
df = pd.read_sql(
    'SELECT *' 
    'FROM bronze.sap_ess',
    database
)
# validate the output
# expected result: (number of rows, number of columns)
print(df.shape)
# preview the data
# output: first 5 rows of the table
print(df.head())
# inspect df
print(df.info())
