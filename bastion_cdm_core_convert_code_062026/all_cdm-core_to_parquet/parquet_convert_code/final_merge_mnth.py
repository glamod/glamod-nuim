#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Manually merge all PQ files in job_* subfolders into one final folder,
with a detailed log of rows merged.
"""

import os
from glob import glob
import pyarrow.parquet as pq
import pyarrow as pa
import pandas as pd

# -----------------------------
# Configuration
# -----------------------------
TEMP_DIR = "/ichec/work/glamod/land_project_workspace/data/level2/cdm_obs_core/monthly_data/r8.1/monthly_pq_tmp/A"
FINAL_DIR = "/ichec/work/glamod/land_project_workspace/data/level2/cdm_obs_core/monthly_data/r8.1/final_merged_pq/A"
LOG_FILE = ("/ichec/work/glamod/land_project_workspace/code/r8.1_pq_code/mnth_merge_log.txt")
FREQ = "monthly"

# -----------------------------
# Prepare final folder
# -----------------------------
os.makedirs(FINAL_DIR, exist_ok=True)

# -----------------------------
# Gather all PQ files from job_* folders
# -----------------------------
pq_files = glob(os.path.join(TEMP_DIR, "job_*", "*.pq"))

file_tags = {}
for pq_file in pq_files:
    base = os.path.basename(pq_file).split(f"{FREQ}_")[1].split(".pq")[0]
    file_tags.setdefault(base, []).append(pq_file)

# -----------------------------
# Merge per file_tag
# -----------------------------
total_rows = 0
failed_merges = []
log_lines = []

for tag, files in file_tags.items():
    try:
        tables = [pq.read_table(f) for f in files]
        combined = pa.concat_tables(tables, promote=True)
        final_path = os.path.join(FINAL_DIR, f"insitu-observations-surface-land_{FREQ}_{tag}.pq")
        pq.write_table(combined, final_path)
        n_rows = combined.num_rows
        total_rows += n_rows
        log_lines.append(f"{tag}: merged {len(files)} files → {n_rows} rows")
        print(f"✅ {tag}: {len(files)} files merged → {n_rows} rows")
    except Exception as e:
        failed_merges.append({"tag": tag, "error": str(e)})
        log_lines.append(f"{tag}: FAILED → {e}")
        print(f"⚠️ {tag}: FAILED → {e}")

# -----------------------------
# Save log
# -----------------------------
with open(LOG_FILE, "w") as f:
    f.write("\n".join(log_lines))
    f.write(f"\n\nTotal rows merged: {total_rows}\n")
    if failed_merges:
        f.write("\nFailed merges:\n")
        f.write(pd.DataFrame(failed_merges).to_string(index=False))

print(f"\n🎉 Merge complete. Log saved at: {LOG_FILE}")
print(f"Total rows merged: {total_rows}")
