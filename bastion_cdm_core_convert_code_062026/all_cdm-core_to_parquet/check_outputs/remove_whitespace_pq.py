# -*- coding: utf-8 -*-
"""
Created on Tue Feb 17 11:03:42 2026

@author: snoone
"""

import os
import glob
import pyarrow.parquet as pq
import pyarrow as pa
import pyarrow.compute as pc

# Folder containing parquet files
folder = "/ichec/work/glamod/land_project_workspace/data/level2/cdm_obs_core/daily_data/r8.1/final_merged_pq/all"

files = glob.glob(os.path.join(folder, "*.pq"))

for f in files:
    print(f"Processing {f}")

    # Read table
    table = pq.read_table(f)

    # Only modify if column exists
    if "report_id" in table.column_names:
        col = table["report_id"]

        # Strip whitespace (leading + trailing)
        cleaned = pc.utf8_trim_whitespace(col)

        # Replace column
        idx = table.column_names.index("report_id")
        table = table.set_column(idx, "report_id", cleaned)

        # Write back (overwrite)
        pq.write_table(table, f)

print("Done.")
