# -*- coding: utf-8 -*-
"""
Created on Fri Mar 20 16:54:05 2026

@author: snoone
"""

import pandas as pd
import os
import glob
from concurrent.futures import ProcessPoolExecutor, as_completed

# === Paths ===
input_dir = "/ichec/work/glamod/land_project_workspace/data/level2/cdm_obs_core/monthly_data/r8.1/final_merged_pq/all/"

files = glob.glob(os.path.join(input_dir, "*.pq"))

# === Worker function ===
def process_file(file):
    try:
        # Read the full file (needed to update)
        df = pd.read_parquet(file)

        # Identify <NA> in source_id
        mask = df["source_id"].isna()

        if mask.any():
            # Replace <NA> with 232
            df.loc[mask, "source_id"] = 232

            # Save back to the same parquet file
            df.to_parquet(file, index=False)
            return os.path.basename(file), mask.sum()  # filename and number of replacements

        return None

    except Exception as e:
        print(f"Error: {file} → {e}")
        return None

# === Parallel execution ===
max_workers = 40  # Adjust to your HPC node

with ProcessPoolExecutor(max_workers=max_workers) as executor:
    futures = {executor.submit(process_file, f): f for f in files}

    for i, future in enumerate(as_completed(futures), 1):
        res = future.result()
        if res is not None:
            fname, count = res
            print(f"✅ Updated {count} <NA> in {fname}")

        if i % 100 == 0:
            print(f"Processed {i}/{len(files)} files")

print("✅ All files processed and <NA> replaced with 232.")