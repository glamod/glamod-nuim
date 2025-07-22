# -*- coding: utf-8 -*-
"""
Created on Wed Jun 25 15:56:28 2025

@author: snoone
"""

import pandas as pd
import numpy as np
from scipy.stats import gamma, norm

# Load the data
file_path = 'C:/Users/snoone/Dropbox/All publications/clidar_&_wmo_papers_2025/paper/paper1/data/precip.csv'
data = pd.read_csv(file_path, parse_dates=['datetime'], dayfirst=True)

# Set datetime as index
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

# Convert index to year-month string format
filtered_data.index = filtered_data.index.strftime('%Y-%m')

# Reorder stations as needed
station_order = ['Ambodifotatra', 'Andapa', 'Moramanga', 'Morombe', 'Nosy Varika']
filtered_data = filtered_data[station_order]

# Function to calculate SPI
def spi(series, scale=3):
    roll_precip = series.rolling(window=scale).sum()
    valid_data = roll_precip.dropna()
    positive_data = valid_data[valid_data > 0]

    if len(positive_data) < 10:
        return pd.Series(index=series.index, dtype=float)

    fit_alpha, fit_loc, fit_beta = gamma.fit(positive_data, floc=0)

    cdf = roll_precip.apply(lambda x: gamma.cdf(x, fit_alpha, loc=fit_loc, scale=fit_beta) if x >= 0 else np.nan)
    spi_values = cdf.apply(lambda x: norm.ppf(x) if 0 < x < 1 else np.nan)

    return spi_values

# Ensure index is datetime before SPI calculation
if not pd.api.types.is_datetime64_any_dtype(filtered_data.index):
    filtered_data.index = pd.to_datetime(filtered_data.index + '-01')

# Calculate SPI-3
spi_3 = filtered_data.apply(spi, scale=3)

# Identify severe droughts (SPI <= -1.5)
severe_droughts = spi_3 <= -1.5

# Identify severe wet periods (SPI >= 1.5)
severe_wet_periods = spi_3 >= 1.5

# Save severe drought periods to CSV
droughts_data = []
for station in severe_droughts.columns:
    drought_dates = severe_droughts.index[severe_droughts[station]]
    for date in drought_dates:
        droughts_data.append({
            'Station': station,
            'Date': date.strftime('%Y-%m'),
            'SPI-3': spi_3.loc[date, station]
        })
droughts_df = pd.DataFrame(droughts_data)
droughts_df.to_csv('C:/Users/snoone/Dropbox/All publications/clidar_&_wmo_papers_2025/paper/paper1/data/severe_drought_periods_spi3.csv', index=False)

# Save severe wet periods to CSV
wet_data = []
for station in severe_wet_periods.columns:
    wet_dates = severe_wet_periods.index[severe_wet_periods[station]]
    for date in wet_dates:
        wet_data.append({
            'Station': station,
            'Date': date.strftime('%Y-%m'),
            'SPI-3': spi_3.loc[date, station]
        })
wet_df = pd.DataFrame(wet_data)
wet_df.to_csv('C:/Users/snoone/Dropbox/All publications/clidar_&_wmo_papers_2025/paper/paper1/data/severe_wet_periods_spi3.csv', index=False)

print("Severe drought and wet period CSV files saved.")
