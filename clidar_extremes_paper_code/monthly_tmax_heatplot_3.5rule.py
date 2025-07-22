# -*- coding: utf-8 -*- 
"""
Created on Wed Jun 25 12:22:44 2025

@author: snoone
"""

# -*- coding: utf-8 -*- 
"""
Created on Wed Jun 25 12:22:44 2025

@author: snoone
"""

import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt

# Load the CSV file (adjust the file path if necessary)
file_path = "C:/Users/snoone/Dropbox/All publications/clidar_&_wmo_papers_2025/paper/paper1/data/tmax.csv"  # Replace with your file path
df = pd.read_csv(file_path)

# Ensure the datetime column is parsed as dates
df['datetime'] = pd.to_datetime(df['datetime'], dayfirst=True)

# Melt the dataframe to long format for heatmap plotting
df_long = df.melt(id_vars=["datetime"], 
                  var_name="Station", 
                  value_name="MaxTemp")

# Remove duplicate rows with same Station and datetime (fix for reindexing error)
df_long = df_long.drop_duplicates(subset=['Station', 'datetime'])

# Add 'Year-Month' for grouping
df_long['Year-Month'] = df_long['datetime'].dt.to_period('M')

def calc_monthly_mean_3_5_rule(group):
    group = group.sort_values('datetime')
    days_in_month = group['datetime'].dt.days_in_month.iloc[0]
    month_start = group['datetime'].iloc[0].replace(day=1)
    full_dates = pd.date_range(start=month_start, periods=days_in_month)

    # Reindex group to full dates to identify missing days
    group_full = group.set_index('datetime').reindex(full_dates)
    temps = group_full['MaxTemp']

    # Count total missing days
    total_missing = temps.isna().sum()

    # Identify consecutive missing days
    is_missing = temps.isna().astype(int).values
    # Run-length encoding to find consecutive NaNs
    diff = np.diff(np.concatenate(([0], is_missing, [0])))
    run_starts = np.where(diff == 1)[0]
    run_ends = np.where(diff == -1)[0]
    run_lengths = run_ends - run_starts
    max_consecutive_missing = run_lengths.max() if len(run_lengths) > 0 else 0

    # Apply 3/5 rule
    if total_missing > 5 or max_consecutive_missing > 3:
        return np.nan
    else:
        return temps.mean()

# Group by Station and Year-Month and apply the rule
monthly_means = df_long.groupby(['Station', 'Year-Month']).apply(calc_monthly_mean_3_5_rule)

# Pivot for heatmap
heatmap_data = monthly_means.unstack(level='Year-Month')

# Plot heatmap
plt.figure(figsize=(16, 6))
ax = sns.heatmap(heatmap_data,
                 cmap="coolwarm",
                 cbar_kws={'label': 'Max Temp (°C)'},
                 linecolor=None,
                 linewidths=0)
# Customize colorbar label font size and weight
cbar = ax.collections[0].colorbar
cbar.set_label('Max Temp (°C)', fontsize=12, )
cbar.ax.tick_params(labelsize=12)

# Add black horizontal lines between stations and at top/bottom edges
n_stations = heatmap_data.shape[0]

for y in range(1, n_stations):
    ax.hlines(y=y, xmin=0, xmax=heatmap_data.shape[1], colors='black', linewidth=1)

ax.hlines(y=0, xmin=0, xmax=heatmap_data.shape[1], colors='black', linewidth=1)
ax.hlines(y=n_stations, xmin=0, xmax=heatmap_data.shape[1], colors='black', linewidth=1)

# Labels and formatting
#plt.title("Monthly Average Maximum Temperatures by Station (3/5 rule applied)")
plt.xlabel("Year-Month", fontsize=12,)
plt.ylabel("Station", fontsize=12, )
#plt.xticks(rotation=45)
plt.tight_layout()

# Save as 300 dpi JPEG
plt.savefig("C:/Users/snoone/Dropbox/All publications/clidar_&_wmo_papers_2025/paper/paper1/data/heatmap_max_temp_3_5_rule.jpeg", dpi=300, format='jpeg')

plt.show()
