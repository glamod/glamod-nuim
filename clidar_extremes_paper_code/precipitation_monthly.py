# -*- coding: utf-8 -*-
"""
Created on Wed Jun 25 15:14:03 2025

@author: snoone
"""
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

# Load the data
file_path = 'C:/Users/snoone/Dropbox/All publications/clidar_&_wmo_papers_2025/paper/paper1/data/precip.csv'
data = pd.read_csv(file_path, parse_dates=['datetime'], dayfirst=True)

# Set the datetime as the index
data.set_index('datetime', inplace=True)

# Resample to monthly and sum daily precipitation
monthly_precip = data.resample('M').sum()

# Count the number of missing days per month
daily_count = data.resample('M').count()

# Threshold for missing days (10% of days in the month)
days_in_month = daily_count.index.days_in_month
missing_threshold = days_in_month * 0.1

# Filter out months with >10% missing days for each station
filtered_data = monthly_precip.copy()
for station in data.columns:
    mask = daily_count[station] >= (days_in_month - missing_threshold)
    filtered_data[station] = filtered_data[station].where(mask)

# Convert index to year-month format
filtered_data.index = filtered_data.index.strftime('%Y-%m')

# Reorder stations (bottom to top on the plot)
station_order = ['Ambodifotatra', 'Andapa', 'Moramanga', 'Morombe', 'Nosy Varika']
filtered_data = filtered_data[station_order]

# Create heatmap
plt.figure(figsize=(14, 8))
ax = sns.heatmap(
    filtered_data.T, 
    cmap='coolwarm', 
    annot=False, 
    fmt=".1f", 
    cbar_kws={'label': 'Monthly Precipitation (mm)'}
)

# Add horizontal lines between stations and at top and bottom
plt.axhline(0, color='black', linewidth=0.5)  # Top border
for i in range(1, len(station_order)):
    plt.axhline(i, color='black', linewidth=0.5)
plt.axhline(len(station_order), color='black', linewidth=0.5)  # Bottom border

# Set titles and labels with bigger fonts
#plt.title('Monthly Summed Precipitation by Station', fontsize=20)
plt.xlabel('Year-Month', fontsize=12)
plt.ylabel('Station', fontsize=12)

# Increase font size for station names and x-axis ticks
plt.yticks(fontsize=14)  # Station names font size
plt.xticks(ha='right', fontsize=14)  # X-axis tick labels font size

plt.tight_layout()

# Save the plot
plt.savefig('C:/Users/snoone/Dropbox/All publications/clidar_&_wmo_papers_2025/paper/paper1/data/monthly_precipitation_heatmap.jpg', dpi=300, format='jpeg')
plt.show()
