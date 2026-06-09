# -*- coding: utf-8 -*-
"""
@author: snoone
"""

import os
import gzip
import csv
from collections import Counter

# Paths
input_dir = "D:/release_8/daily/csv"
file_list_txt = "D:/release_8/daily/daily_csv_list.txt"
output_csv = "D:/release_8/daily/daily-csv_countsr8.1.csv"

# Variables of interest
single_vars = {"SNWD", "PRCP", "SNOW", "AWND", "AWDR", "WESD"}
temp_vars = {"TMIN", "TMAX", "TAVG"}

# Global counter
counts = Counter()

# Read list of CSV files from text file
with open(file_list_txt, "r") as f:
    csv_files = [line.strip() for line in f if line.strip()]

# Loop through listed files (.csv or .csv.gz)
for fname in csv_files:
    fpath = os.path.join(input_dir, fname)

    if not os.path.isfile(fpath):
        print(f"Warning: {fpath} does not exist. Skipping.")
        continue

    # Choose correct open function
    if fname.endswith(".gz"):
        open_func = gzip.open
        open_kwargs = {"mode": "rt"}
    else:
        open_func = open
        open_kwargs = {"mode": "r"}

    try:
        with open_func(fpath, **open_kwargs) as f:
            reader = csv.reader(f)
            for row in reader:
                if len(row) < 3:
                    continue
                var = row[2]
                if var in single_vars:
                    counts[var] += 1
                elif var in temp_vars:
                    counts["TEMP"] += 1
    except Exception as e:
        print(f"Error reading {fpath}: {e}")

# Write results
with open(output_csv, "w", newline="") as out:
    writer = csv.writer(out)
    writer.writerow(["variable", "count"])
    writer.writerow(["TEMP (TMIN+TMAX+TAVG)", counts["TEMP"]])
    for v in sorted(single_vars):
        writer.writerow([v, counts[v]])

print("Counts written to:", output_csv)
