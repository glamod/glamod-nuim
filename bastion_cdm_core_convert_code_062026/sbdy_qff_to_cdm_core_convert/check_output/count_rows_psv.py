# -*- coding: utf-8 -*-
"""
Created on Thu Aug 21 10:53:35 2025

@author: snoone
"""Counts rows in all sub-daily CDM Core PSV files, logs per-file and total row counts, and records any unreadable or corrupt files encountered during processing."""

import os
import glob
import gzip
import traceback

# ==============================
# Configuration
# ==============================
DATA_DIR = "/ichec/work/glamod/land_project_workspace/data/level2/cdm_obs_core/sub_daily_data/r8.1/r8.1_core"
OUTPUT_TXT = "/ichec/work/glamod/land_project_workspace/code/r8.1_202602/hourly/row_counts_sbdy_r8.1.txt"
ERROR_LOG = "/ichec/work/glamod/land_project_workspace/code/r8.1_202602/hourly/row_counts_sbdy_r8.1_errors.log"

# Find all .psv and .psv.gz files
files = glob.glob(os.path.join(DATA_DIR, "*.psv*"))

total_rows = 0
bad_files = 0

with open(OUTPUT_TXT, "w", encoding="utf-8") as out, \
     open(ERROR_LOG, "w", encoding="utf-8") as err:

    out.write("File,Rows\n")
    err.write("File,Error\n")

    for f in files:
        try:
            if f.endswith(".gz"):
                with gzip.open(f, "rt") as fh:
                    rows = sum(1 for _ in fh)
            else:
                with open(f, "r", encoding="utf-8", errors="ignore") as fh:
                    rows = sum(1 for _ in fh)

            total_rows += rows
            out.write(f"{os.path.basename(f)},{rows}\n")
            print(f"{f}: {rows} rows")

        except Exception as e:
            bad_files += 1
            err.write(f"{os.path.basename(f)},{repr(e)}\n")
            print(f"⚠️  Skipping corrupt file: {f}")

    out.write(f"\nTOTAL,{total_rows}\n")

print("\n==============================")
print(f"🧮 Total rows counted: {total_rows}")
print(f"⚠️  Corrupt files skipped: {bad_files}")
print(f"✔ Row counts saved to {OUTPUT_TXT}")
print(f"✔ Errors logged to {ERROR_LOG}")
