# -*- coding: utf-8 -*-
"""
Created on Fri Jul 25 09:58:41 2025

@author: snoone
"""

import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.dates as mdates
import os

# --- Load and prepare data ---
df = pd.read_csv("C:/Users/snoone/Dropbox/All publications/clidar_&_wmo_papers_2025/paper/paper1/data/works_data/nv_slp.csv")

# Create datetime column
df['Datetime'] = pd.to_datetime(df[['Year', 'Month', 'Day', 'Hour']])
df.sort_values('Datetime', inplace=True)

# Storm threshold
storm_threshold = 998.75 #threshold for storms uisng slp at 10m above sea level 1000 hPa - 1.25 hPa ≈ **998.75 hPa**

df['Storm'] = df['Pressure'] < storm_threshold

# Create 'Year-Month' column for grouping
df['YearMonth'] = df['Datetime'].dt.to_period('M')

# --- Main plot: Full time series with storms ---
plt.figure(figsize=(14, 6))
plt.plot(df['Datetime'], df['Pressure'], label='Pressure', color='blue')
plt.scatter(df.loc[df['Storm'], 'Datetime'],
            df.loc[df['Storm'], 'Pressure'],
            color='red', label='Potential cyclone', zorder=5)

plt.title("Nosy Varika Station Level Pressure 1951-1964",fontsize=14)
plt.xlabel("Date",fontsize=12)
plt.ylabel("Pressure (hPa)",fontsize=12)
plt.legend()
plt.grid(True)

# Format x-axis
plt.gca().xaxis.set_major_formatter(mdates.DateFormatter('%Y-%m-%d'))
plt.xticks(rotation=90)
plt.tight_layout()
plt.savefig("C:/Users/snoone/Dropbox/All publications/clidar_&_wmo_papers_2025/paper/paper1/data/works_data/monthly_storm_plots/nv_pressure_main_plot.jpg", dpi=300, format='jpeg')
plt.show()

# --- Monthly plots for storm months ---
output_folder = "C:/Users/snoone/Dropbox/All publications/clidar_&_wmo_papers_2025/paper/paper1/data/works_data/nv_monthly_storm_plots"
os.makedirs(output_folder, exist_ok=True)

storm_months = df[df['Storm']]['YearMonth'].unique()

for month in storm_months:
    month_str = str(month)  # e.g., '2025-07'
    month_df = df[df['YearMonth'] == month]

    plt.figure(figsize=(12, 5))
    plt.plot(month_df['Datetime'], month_df['Pressure'], label='Pressure', color='black', marker='o')
    plt.scatter(month_df.loc[month_df['Storm'], 'Datetime'],
                month_df.loc[month_df['Storm'], 'Pressure'],
                color='red', label='Potential cyclone', zorder=5)

    plt.title(f"Nosy Varika Station Level Pressure in {month_str} ",fontsize=14)
    plt.xlabel("Datetime",fontsize=12)
    plt.ylabel("Pressure (hPa)",fontsize=12)
    plt.legend()
    plt.grid(True)

    # Set daily ticks only (one per day)
    daily_ticks = month_df['Datetime'].dt.floor('D').drop_duplicates()

    plt.xticks(
        daily_ticks,
        daily_ticks.dt.strftime('%b %d'),  # e.g., 'Jul 25'
        rotation=90,
        fontsize=12
    )

    plt.tight_layout()

    # Save with unique filename for each stormy month
    output_path = os.path.join(output_folder, f"{month_str}_storm.jpeg")
    plt.savefig(output_path, dpi=300, format='jpeg')
    plt.close()













