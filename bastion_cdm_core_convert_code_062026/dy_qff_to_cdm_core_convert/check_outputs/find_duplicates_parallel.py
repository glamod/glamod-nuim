# -*- coding: utf-8 -*-
"""
Created on Thu Feb 12 08:11:20 2026

@author: snoone
"""

#!/usr/bin/env python3

import os
import gzip
import csv
from collections import defaultdict
from multiprocessing import Pool, cpu_count

INPUT_DIR = "/ichec/work/glamod/land_project_workspace/data/level2/cdm_obs_core/daily_data/r8.1/cdm_core/"
OUTPUT_DIR = "/ichec/work/glamod/land_project_workspace/code/r8.1_202602/daily/"
OUTPUT_FILE = os.path.join(
    OUTPUT_DIR,
    "duplicate_report_timestamp_observation_value_observed_variable_value_significance_files.csv"
)

DELIMITER = "|"


def process_file(filename):
    """
    Process one .psv.gz file.
    Duplicate key:
      (report_timestamp, observation_value, observed_variable, value_significance)
    """
    filepath = os.path.join(INPUT_DIR, filename)
    counts = defaultdict(int)

    try:
        with gzip.open(filepath, "rt") as f:
            reader = csv.reader(f, delimiter=DELIMITER)
            header = next(reader)

            ts_idx = header.index("report_timestamp")
            val_idx = header.index("observation_value")
            var_idx = header.index("observed_variable")
            vs_idx = header.index("value_significance")  # NEW

            for row in reader:
                if len(row) <= max(ts_idx, val_idx, var_idx, vs_idx):
                    continue

                key = (
                    row[ts_idx],
                    row[val_idx],
                    row[var_idx],
                    row[vs_idx]  # NEW
                )
                counts[key] += 1

    except Exception as e:
        return {
            "filename": filename,
            "error": str(e)
        }

    duplicate_pairs = 0
    duplicate_rows = 0

    for c in counts.values():
        if c > 1:
            duplicate_pairs += 1
            duplicate_rows += (c - 1)

    if duplicate_pairs == 0:
        return None

    return {
        "filename": filename,
        "duplicate_pairs": duplicate_pairs,
        "duplicate_rows": duplicate_rows
    }


def main():
    os.makedirs(OUTPUT_DIR, exist_ok=True)

    files = [f for f in os.listdir(INPUT_DIR) if f.endswith(".psv.gz")]
    nproc = min(cpu_count(), 32)  # avoid hammering the filesystem

    print(f"Processing {len(files)} files using {nproc} processes")

    results = []

    with Pool(processes=nproc) as pool:
        for i, result in enumerate(pool.imap_unordered(process_file, files), 1):
            if result and "error" not in result:
                results.append(result)

            if i % 2000 == 0:
                print(f"Processed {i}/{len(files)} files")

    with open(OUTPUT_FILE, "w", newline="") as out:
        writer = csv.DictWriter(
            out,
            fieldnames=[
                "filename",
                "duplicate_pairs",
                "duplicate_rows"
            ]
        )
        writer.writeheader()
        writer.writerows(results)

    print("\nDone.")
    print(f"Files with duplicates: {len(results)}")
    print(f"Output written to:\n{OUTPUT_FILE}")


if __name__ == "__main__":
    main()
