# -*- coding: utf-8 -*-
"""
Created on Wed Jun 17 11:11:42 2026

@author: snoone
"""

import os
import pyarrow.parquet as pq

CHUNK_DIR = "/ichec/work/glamod/land_project_workspace/data/level2/cdm_obs_core/daily_data/r8.1/final_merged_pq/all"

chunk_files = [
    os.path.join(CHUNK_DIR, f)
    for f in os.listdir(CHUNK_DIR)
    if f.endswith(".pq")
]

total_rows = 0

for f in chunk_files:
    try:
        parquet_file = pq.ParquetFile(f)

        # Uses metadata only; does not load the file into memory
        nrows = parquet_file.metadata.num_rows

        total_rows += nrows
        print(f"{os.path.basename(f)}: {nrows:,} rows")

    except Exception as e:
        print(f"❌ Failed to read {f}: {e}")

print(f"\n✅ Total rows across all files: {total_rows:,}")