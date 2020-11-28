import pandas as pd
from re import search

## Author: Nick Hella
## Purpose: Adding lat & long values to specific receivingWater locations
## Receiving Water --> (Lat, Long) MAP:
##		Location:					Lat: 		Long:
## 		Winooski				--> 44.530598	-73.274215
## 		Pine St Barge Canal		--> 44.469254	-73.219233
## 		Shelburne Bay			--> 44.422171	-73.231547

# Reading CSV and creating our dataframe
df = pd.read_csv ('Sewage_Data_2015-2019.csv')

# Building up blank string lists for new columns "Lat" and "Long"
count = 0
lat_list = list(())
long_list = list(())
while count < len(df):
	lat_list.append("")
	long_list.append("")
	count += 1

df['Latitude'] = lat_list
df['Longitude'] = long_list

# Adding the appropriate lat and long vals
count = 0
while count < len(df):

	receiving_water_value = str(df['Receiving Water'].iloc[count])

	print("Receiving Water value: " + str(receiving_water_value))

	#if receiving_water_value.find("Winooski"):
	if "Winooski" in receiving_water_value:
		print("\tFound Winooski Receiving Water value!")
		df['Latitude'].iloc[count] = "44.530598"
		df['Longitude'].iloc[count] = "-73.274215"

	# if receiving_water_value.find("Pine St Barge Canal"):
	if "Pine" in receiving_water_value and "Barge Canal" in receiving_water_value:
		df['Latitude'].iloc[count] = "44.469254"
		df['Longitude'].iloc[count] = "-73.219233"

	# if receiving_water_value.find("Shelburne Bay"):
	if "Shelburne Bay" in receiving_water_value:
		df['Latitude'].iloc[count] = "44.422171"
		df['Longitude'].iloc[count] = "-73.231547"

	count += 1

df.to_csv('Sewage_Data_2015-2019_with_lats_and_longs.csv')