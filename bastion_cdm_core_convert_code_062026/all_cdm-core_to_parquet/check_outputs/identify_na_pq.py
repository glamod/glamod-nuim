# -*- coding: utf-8 -*-
"""
Created on Fri Mar 20 16:21:10 2026

@author: snoone
"""

import pandas as pd
import os
import glob
from concurrent.futures import ProcessPoolExecutor, as_completed

# === Paths ===
input_dir = "/ichec/work/glamod/land_project_workspace/data/level2/cdm_obs_core/monthly_data/r8.1/final_merged_pq/all/"
output_file = "/ichec/work/glamod/land_project_workspace/code/r8.1_pq_code/source_id_NA_rows.csv"

files = glob.glob(os.path.join(input_dir, "*.pq"))

# === Worker function ===
def process_file(file):
    try:
        # Read only source_id first (fast)
        df = pd.read_parquet(file, columns=["source_id"])

        mask = df["source_id"].isna()

        if mask.any():
            # Only read full file if needed
            full_df = pd.read_parquet(file)
            bad_rows = full_df.loc[mask].copy()
            bad_rows["file_name"] = os.path.basename(file)
            return bad_rows

        return None

    except Exception as e:
        print(f"Error: {file} → {e}")
        return None


# === Parallel execution ===
results = []

max_workers = 40   # ⚠️ start with 40 (not 60) to avoid I/O bottleneck

with ProcessPoolExecutor(max_workers=max_workers) as executor:
    futures = {executor.submit(process_file, f): f for f in files}

    for i, future in enumerate(as_completed(futures), 1):
        res = future.result()
        if res is not None:
            results.append(res)

        if i % 100 == 0:
            print(f"Processed {i}/{len(files)} files")

# === Combine + save ===
if results:
    final_df = pd.concat(results, ignore_index=True)
    final_df.to_csv(output_file, index=False)
    print(f"✅ Done. Output saved to: {output_file}")
else:
    print("✅ No <NA> source_id values found.")