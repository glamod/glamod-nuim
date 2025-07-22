# -*- coding: utf-8 -*- 
"""
Created on Wed Jun 25 12:22:44 2025

@author: snoone
"""

import pandas as pd
import numpy as np

# Load the CSV file (adjust the file path if necessary)
file_path = "C:/Users/snoone/Dropbox/All publications/clidar_&_wmo_papers_2025/paper/paper1/data/tmax.csv"  # Replace with your file path
df = pd.read_csv(file_path)

# Ensure the datetime column is parsed as dates
df['datetime'] = pd.to_datetime(df['datetime'], dayfirst=True)

# Melt the dataframe to long format for analysis
df_long = df.melt(id_vars=["datetime"], 
                  var_name="Station", 
                  value_name="MaxTemp")

# Remove duplicate rows with same Station and datetime
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

# Convert to DataFrame
monthly_means_df = monthly_means.reset_index(name='MonthlyMeanTemp')

# Calculate the 90th percentile threshold for each station
thresholds = monthly_means_df.groupby('Station')['MonthlyMeanTemp'].quantile(0.9).rename('Threshold')

# Merge thresholds with monthly means
monthly_means_df = monthly_means_df.merge(thresholds, on='Station')

# Identify months exceeding the threshold
monthly_means_df['ExceedsThreshold'] = monthly_means_df['MonthlyMeanTemp'] > monthly_means_df['Threshold']

# Group consecutive periods of exceeding the threshold
def identify_consecutive_periods(df):
    df = df.sort_values('Year-Month')
    df['ExceedGroup'] = (df['ExceedsThreshold'] != df['ExceedsThreshold'].shift()).cumsum()
    exceed_periods = df[df['ExceedsThreshold']].groupby('ExceedGroup').filter(lambda g: len(g) >= 3)
    return exceed_periods

# Apply to each station
heatwave_periods = monthly_means_df.groupby('Station', group_keys=False).apply(identify_consecutive_periods)

# Save results to a CSV file
output_path = "C:/Users/snoone/Dropbox/All publications/clidar_&_wmo_papers_2025/paper/paper1/data/heatwave_periods.csv"
heatwave_periods.to_csv(output_path, index=False)

print(f"Heatwave periods saved to {output_path}")
