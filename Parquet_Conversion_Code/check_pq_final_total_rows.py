# -*- coding: utf-8 -*-
"""
Created on Thu Aug 21 10:49:35 2025

@author: snoone
"""

# count_rows_metadata.py
import pyarrow.parquet as pq
import os
from glob import glob

# ===========================
# Directories
# ===========================
FINAL_DIR = "/ichec/work/glamod/land_project_workspace/data/level2/cdm_obs_core/sub_daily_data/r8/ed_final_merged_yearly_pq"

# ===========================
# Find all merged parquet files
# ===========================
merged_files = glob(os.path.join(FINAL_DIR, "*.pq"))

if not merged_files:
    print("⚠️ No merged parquet files found.")
    exit()

# ===========================
# Count rows using metadata only
# ===========================
total_rows = 0
for f in merged_files:
    pq_file = pq.ParquetFile(f)
    total_rows += pq_file.metadata.num_rows

print(f"🧮 Total rows in all merged Parquet files: {total_rows}")
