# importing libraries
from sqlalchemy import create_engine
import pandas as pd
import matplotlib.pyplot as plt

# PostgreSQL connection details
username = '(...)'
password = '(...)'
host = '(...)'
port = '(...)'
database = 'ess'

# create connection using create_engine (which acts as the main interface between Python code and the database)
engine = create_engine(
    f'postgresql+pg8000://{username}:{password}@{host}:{port}/{database}'
    )

# fetch the data from PostgreSQL server - bronze layer (raw data)
# df_bronze = pd.read_sql(
#     'SELECT * FROM bronze.sap_ess',
#     con=engine # con=engine in pd.read_sql() tells pandas which database connection to use when executing the SQL query
# )
# validate the output
# expected result: (number of rows, number of columns)
# print(df_bronze.shape)
# # preview the data
# # output: first 5 rows of the table
# print(df_bronze.head())
# # inspect df
# print(df_bronze.info())

# fetch the data from PostgreSQL server - gold layer (processed data)
df_gold = pd.read_sql(
    'SELECT * FROM gold.fact_last_month',
    con=engine 
)

# count statuses for the gold layer
gold_count = df_gold['status'].value_counts()

# plot
gold_count.plot(
    kind='bar',
    color='skyblue',
    title="Last month's count of status"
)
plt.xlabel('Status')
plt.ylabel('Count')
plt.xticks(rotation=0)
plt.show()
