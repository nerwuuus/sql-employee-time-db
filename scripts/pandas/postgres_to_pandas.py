# ============================================================================
# Install SQl libraries using Power Shell:
#   pip install sqlalchemy
#   pip install sqlalchemy pg8000
# SQL Alchemy provides an abstraction layer for database connections.   
# PG8000 a lightweight library to connect Python with Postgres.
# ============================================================================

# importing libraries
import pandas as pd
import matplotlib as plt
import numpy as np

# PostgreSQL connection details
username = 'postgres'
password = 'admin'
host = 'localhost'
port = '5432'
database = 'ess'

# create connection
database = f'postgresql+pg8000://{username}:{password}@{host}:{port}/{database}'

# fetch the data from PostgreSQL server
df = pd.read_sql(
    'SELECT *' 
    'FROM silver.sap_ess',
    database
)

print(df)
