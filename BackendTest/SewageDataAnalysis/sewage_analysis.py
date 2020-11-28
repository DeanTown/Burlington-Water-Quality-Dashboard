import pandas as pd
import sys


# Reading CSV and creating our dataframe
df = pd.read_csv ('~/Downloads/Sewage_Data_2015-2019.csv')

print("Columns from our CSV dataframe:")
print(df.columns.values.tolist())

# Print the unique receivingWater values
print("\nUnique receivingWater Values: ")
unique_receivingWater = df['Receiving Water'].unique().tolist()
for el in unique_receivingWater:
	print(el)

# Print the unique location values
print("\nUnique location Values: ")
location = df['Location'].unique().tolist()
for el in location:
	print(el)
# print("\n")
# print(location)
# print(len(location))
# print("\n")

# Print the locations associated with the unique receiving water values
for el in unique_receivingWater:
	print("\nLocations associated with the receiving water body: " + str(el))
	tmp_df = df[df['Receiving Water'] == str(el)]
	associated_locations = tmp_df['Location'].tolist()
	associated_locations = list(set(associated_locations))
	for el2 in associated_locations:
		print(el)

blanks = []
for el in unique_receivingWater:
	blanks.append("")

# Create a sub-dataframe containing the two columns and "location"
data = {"Receiving Water": unique_receivingWater, "Latitude": blanks, "Longitude": blanks}
df = pd.DataFrame.from_dict(data)
df.to_csv('unique_receiving_waters.csv')
