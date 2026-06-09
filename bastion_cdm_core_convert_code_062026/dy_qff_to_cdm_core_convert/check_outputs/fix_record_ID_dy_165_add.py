# -*- coding: utf-8 -*-
"""
Created on Sun Feb 15 12:26:51 2026

@author: snoone
"""
import pandas as pd

# Path to your record_id_dy.csv
record_id_path = r"C:\Users\snoone\Dropbox\Copernicus_2025\admin\release_8.1\r8.1_202602\daily\record_id_dy.csv"

# Read CSV
df = pd.read_csv(record_id_path, dtype=str)

# Strip whitespace
df = df.apply(lambda x: x.str.strip() if x.dtype == "object" else x)

# Prepare list to hold new 165 rows
new_rows = []

for station_id, group in df.groupby('station_id', sort=False):
    # Find max record_number for this station
    max_record = group['record_number'].astype(int).max()
    
    # Create new row for 165
    new_row = group.iloc[0].copy()
    new_row['record_number'] = str(max_record + 1)  # sequential
    new_row['primary_station_id_3'] = f"{station_id}-165-{max_record + 1}"
    new_row['primary_station_id_2'] = f"{station_id}-165"
    
    new_rows.append(new_row)

# Append new rows
df_165 = pd.concat([df, pd.DataFrame(new_rows)], ignore_index=True)

# Re-sequence record_number for each station_id to ensure sequential numbering
def resequence_records(group):
    group = group.sort_values('record_number').reset_index(drop=True)
    group['record_number'] = [str(i+1) for i in range(len(group))]
    # Update primary_station_id_3 to match new record_number
    group['primary_station_id_3'] = group.apply(
        lambda row: f"{row['station_id']}-{row['primary_station_id_2'].split('-')[-1]}-{row['record_number']}", axis=1
    )
    return group

df_165 = df_165.groupby('station_id', group_keys=False).apply(resequence_records)

# Optional: sort by station_id then record_number
df_165 = df_165.sort_values(['station_id','record_number']).reset_index(drop=True)

# Save to a new CSV
out_path = record_id_path.replace('.csv','_with165.csv')
df_165.to_csv(out_path, index=False)

print(f"Added 165 rows and ensured sequential record_numbers for each station. Saved to {out_path}")
