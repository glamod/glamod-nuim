# -*- coding: utf-8 -*-
"""
Created on Fri Jan 30 09:11:29 2026

@author: snoone
"""

import os
import gzip
import csv
from collections import Counter

# Paths
input_dir = "/ichec/work/glamod/land_project_workspace/data/level1/csv/daily"
file_list_txt = "/ichec/work/glamod/land_project_workspace/code/r8.1_pq_code/daily_csv_list.txt"
output_csv = "/ichec/work/glamod/land_project_workspace/code/r8.1_pq_code/daily-csv_counts.csv"

# Variables of interest
single_vars = {"SNWD", "PRCP", "SNOW", "AWND", "AWDR", "WESD"}
temp_vars = {"TMIN", "TMAX", "TAVG"}

# Global counter
counts = Counter()

# Read list of CSV files from text file
with open(file_list_txt, "r") as f:
    csv_files = [line.strip() for line in f if line.strip()]

# Loop through listed .csv.gz files
for fname in csv_files:
    # Construct full path
    fpath = os.path.join(input_dir, fname)

    # Check if file exists
    if not os.path.isfile(fpath):
        print(f"Warning: {fpath} does not exist. Skipping.")
        continue

    # Read gzip CSV
    with gzip.open(fpath, "rt") as f:
        reader = csv.reader(f)
        for row in reader:
            if len(row) < 3:
                continue
            var = row[2]
            if var in single_vars:
                counts[var] += 1
            elif var in temp_vars:
                counts["TEMP"] += 1

# Write results
with open(output_csv, "w", newline="") as out:
    writer = csv.writer(out)
    writer.writerow(["variable", "count"])
    writer.writerow(["TEMP (TMIN+TMAX+TAVG)", counts["TEMP"]])
    for v in sorted(single_vars):
        writer.writerow([v, counts[v]])

print("Counts written to:", output_csv)
