import io
import requests
import pandas as pd

# Load Data
url = 'http://data.gdeltproject.org/normfiles/monthly_country.csv'
urlData = requests.get(url).content
df = pd.read_csv(io.StringIO(urlData.decode('utf-8')), names=["Data", "Country", "Value"])
print("Head Elements")
print(df.head())
print("Describe Database")
print(df.describe())
print("Unique Elements")
print(df.nunique())

# Show Memory
print("Memory Usate")
df.info(memory_usage='deep')

# Convert to int
print("Convert to Int")
df_int = df.copy()
df_int['Value'] =  pd.to_numeric(df_int.Value, downcast='unsigned')
print("New Memory Usage")
df_int.info(memory_usage='deep')

# Categorical
df_cat = df.copy()
print("Create Category")
df_cat['Country'] = df_cat.Country.astype('category')
df_cat.info(memory_usage='deep')

# Optimize Read
print("Read and optimize")
column_types={"Data":"category", "Country":"category", "Value":"int32"}
read_and_optimized = pd.read_csv(io.StringIO(urlData.decode('utf-8')), names=["Data", "Country", "Value"], dtype=column_types)
print(read_and_optimized.info(memory_usage='deep'))

