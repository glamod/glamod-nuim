# -*- coding: utf-8 -*-
"""
Created on Thu Aug 21 10:53:35 2025

@author: snoone
"""

import os
import glob
import gzip

# ==============================
# Configuration
# ==============================
DATA_DIR = "/ichec/work/glamod/land_project_workspace/data/level2/Ed_hawkins_pressure_r8"
OUTPUT_TXT = "/ichec/work/glamod/land_project_workspace/code/r8_pq_code/ed__psv_rows.txt"

# Find all .psv and .psv.gz files
files = glob.glob(os.path.join(DATA_DIR, "*.psv*"))

total_rows = 0

# Open log file for writing
with open(OUTPUT_TXT, "w", encoding="utf-8") as log:
    log.write("File,Rows\n")

    for f in files:
        if f.endswith(".gz"):
            with gzip.open(f, "rt") as fh:
                rows = sum(1 for _ in fh)
        else:
            with open(f, "r") as fh:
                rows = sum(1 for _ in fh)

        total_rows += rows
        # Write individual file count to log
        log.write(f"{os.path.basename(f)},{rows}\n")
        print(f"{f}: {rows} rows")

    # Write grand total at the end
    log.write(f"\nTOTAL,{total_rows}\n")

print(f"\n🧮 Total rows across all .psv files: {total_rows}")
print(f"✔ Row counts saved to {OUTPUT_TXT}")

