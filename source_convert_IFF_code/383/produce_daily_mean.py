# -*- coding: utf-8 -*-
"""
Created on Fri Jul 28 09:44:10 2023

@author: snoone
"""


import pandas as pd

# Load the CSV file into a DataFrame
data = pd.read_csv("C:/Users/snoone/Dropbox/All publications/Clidar_africa_paper/data/Macenta/hourly/slp.csv")

# Combine Year, Month, Day into a single date column
data["Date"] = pd.to_datetime(data[["Year", "Month", "Day"]])

# Group data by date and calculate mean for 'slp' column
mean_slp_daily = data.groupby("Date")["slp"].mean().reset_index()

# Save the resulting DataFrame with mean daily values for 'slp' to a new CSV file
mean_slp_daily.to_csv("C:/Users/snoone/Dropbox/All publications/Clidar_africa_paper/data/Macenta/hourly/slp_out.csv", index=False)
