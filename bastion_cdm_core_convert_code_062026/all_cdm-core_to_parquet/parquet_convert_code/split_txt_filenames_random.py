# -*- coding: utf-8 -*-
"""
Created on Wed Jan 21 09:53:19 2026

@author: snoone
"""

import pandas as pd
import numpy as np

# Load the station list
stations = pd.read_csv("/ichec/work/glamod/land_project_workspace/code/r8_pq_code/sub_daily_station_list.txt", header=None, names=["station"])

# Shuffle randomly
stations = stations.sample(frac=1, random_state=42)  # random_state ensures reproducibility

# Split into 5 roughly equal parts
n_parts = 5
split_stations = np.array_split(stations, n_parts)

# Save each part to separate file
file_labels = ["A", "B", "C", "D", "E"]
for i, df in enumerate(split_stations):
    filename = f"sub_daily_station_list_{file_labels[i]}.txt"
    df.to_csv(filename, index=False, header=False)
    print(f"Saved {len(df)} stations → {filename}")
