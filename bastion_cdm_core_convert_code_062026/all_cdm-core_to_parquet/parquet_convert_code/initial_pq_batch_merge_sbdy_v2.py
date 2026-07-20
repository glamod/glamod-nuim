#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
from glob import glob
import pyarrow.parquet as pq
import pyarrow as pa
import pandas as pd
#"""initial merge of pq files into sub job folder """

# -----------------------------
# Configuration
# -----------------------------
BASE_TEMP_DIR = "/ichec/work/glamod/land_project_workspace/data/level2/cdm_obs_core/sub_daily_data/r8.1/sub_daily_pq_tmp"
BASE_FINAL_DIR = "/ichec/work/glamod/land_project_workspace/data/level2/cdm_obs_core/sub_daily_data/r8.1/final_merged_pq"

SUBFOLDERS = ["A", "B", "C", "D", "E"]

LOG_DIR = "/ichec/work/glamod/land_project_workspace/code/r8.1_pq_code"

FREQ = "sub_daily"

total_rows_all = 0

# -----------------------------
# Process folders sequentially
# -----------------------------
for folder in SUBFOLDERS:

    print(f"\n==============================")
    print(f"Processing folder {folder}")
    print(f"==============================")

    TEMP_DIR = os.path.join(BASE_TEMP_DIR, folder)
    FINAL_DIR = os.path.join(BASE_FINAL_DIR, folder)

    LOG_FILE = os.path.join(LOG_DIR, f"sbdy_merge_log_{folder}.txt")

    os.makedirs(FINAL_DIR, exist_ok=True)

    pq_files = glob(os.path.join(TEMP_DIR, "job_*", "*.pq"))

    file_tags = {}
    for pq_file in pq_files:
        base = os.path.basename(pq_file).split(f"{FREQ}_")[1].split(".pq")[0]
        file_tags.setdefault(base, []).append(pq_file)

    total_rows = 0
    failed_merges = []
    log_lines = []

    for tag, files in file_tags.items():
        try:
            tables = [pq.read_table(f) for f in files]
            combined = pa.concat_tables(tables, promote=True)

            final_path = os.path.join(
                FINAL_DIR,
                f"insitu-observations-surface-land_{FREQ}_{tag}.pq"
            )

            pq.write_table(combined, final_path)

            n_rows = combined.num_rows
            total_rows += n_rows
            total_rows_all += n_rows

            msg = f"{folder} | {tag}: merged {len(files)} files → {n_rows} rows"
            log_lines.append(msg)

            print(f"✅ {msg}")

        except Exception as e:
            failed_merges.append({"folder": folder, "tag": tag, "error": str(e)})
            log_lines.append(f"{folder} | {tag}: FAILED → {e}")
            print(f"⚠️ {folder} | {tag}: FAILED → {e}")

    log_lines.append(f"{folder}: total rows merged = {total_rows}\n")

    # -----------------------------
    # Save per-folder log
    # -----------------------------
    with open(LOG_FILE, "w") as f:
        f.write("\n".join(log_lines))
        f.write(f"\nTotal rows merged in {folder}: {total_rows}\n")

        if failed_merges:
            f.write("\nFailed merges:\n")
            f.write(pd.DataFrame(failed_merges).to_string(index=False))

    print(f"📄 Log saved: {LOG_FILE}")

print("\n🎉 All folders complete.")
print(f"Grand total rows merged: {total_rows_all}")