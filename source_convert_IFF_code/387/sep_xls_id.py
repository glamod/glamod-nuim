# -*- coding: utf-8 -*-
"""
Created on Fri Mar 24 12:04:28 2023

@author: snoone
"""
import pandas as pd
import os

# Set the directory path where the xlsx files are stored
directory_path = "C:/Users/snoone/Dropbox/ISRAEL_HOURLY/data/original_data/slp"

# Loop over all xlsx files in the directory
for filename in os.listdir(directory_path):
    if filename.endswith(".csv"):
        # Read the "My data" sheet from the xlsx file into a pandas dataframe
        filepath = os.path.join(directory_path, filename)
        df = pd.read_csv(filepath)

        # Group the dataframe by the "Station_ID" column and iterate over the groups
        for station_id, group in df.groupby("Station_ID"):
            # Create a new CSV file with the name of the station ID
            csv_filename = f"{station_id}.csv"
            csv_filepath = os.path.join(directory_path, csv_filename)

            # Save the group to the CSV file
            group.to_csv(csv_filepath, index=False)
