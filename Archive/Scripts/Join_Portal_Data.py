import pandas as pd

# Import datasets
base_data = pd.read_csv("Real_Estate_Base_Data.csv")
residential = pd.read_csv("Real_Estate_Residential_Details.csv")
commercial = pd.read_csv("Real_Estate_Commercial_Details.csv")

# Print first few rows of each dataset
print(base_data.head())
print(residential.head())
print(commercial.head())

# Print columns in each dataset
print(base_data.columns)
print(residential.columns)
print(commercial.columns)

# Join base data, residential data, and commercial data together into one large dataset
# Join on RecordID_Int
df = base_data.join(residential, how = "left", on = "RecordID_Int", rsuffix = "R")
df = df.join(commercial, how = "left", on = "RecordID_Int", rsuffix = "C")

# Print first few rows of the combined dataset
print(df.head())
print(df.tail())

# Export dataset
df.to_csv("dataset.csv")
