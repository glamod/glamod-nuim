# -*- coding: utf-8 -*-
"""
Detect duplicate rows in .csv.gz files (no header)
Duplicates defined as col1 + col2 + col3

Outputs:
- files_with_duplicates.txt
- duplicate_variable_totals.txt

Optimised for 80-core ICHEC node
"""

import os
import glob
import gzip
import csv
from multiprocessing import Pool
from collections import defaultdict

# =====================================================
# CONFIGURATION
# =====================================================

DATA_DIR = "/ichec/work/glamod/land_project_workspace/data/level1/csv/daily"

OUTPUT_DIR = "/ichec/work/glamod/land_project_workspace/code/r8.1_202602/daily"

OUTPUT_FILES = os.path.join(OUTPUT_DIR, "files_with_duplicates.txt")
OUTPUT_TOTALS = os.path.join(OUTPUT_DIR, "duplicate_variable_totals.txt")

VARIABLES = {
    "SNWD", "PRCP", "SNOW", "AWND", "AWDR",
    "WESD", "TMIN", "TMAX", "TAVG"
}

N_WORKERS = 80
BATCH_SIZE = 100   # Good balance for large files


# =====================================================
# WORKER FUNCTION
# =====================================================

def process_batch(file_list):

    files_with_dupes = []
    variable_dup_counts = defaultdict(int)
    total_dup_rows = 0

    for filepath in file_list:

        seen = set()
        file_has_duplicate = False

        try:
            with gzip.open(filepath, "rt") as fh:
                reader = csv.reader(fh)

                for row in reader:
                    if len(row) < 3:
                        continue

                    key = row[0] + "|" + row[1] + "|" + row[2]
                    var_id = row[2]

                    if key in seen:
                        total_dup_rows += 1
                        if var_id in VARIABLES:
                            variable_dup_counts[var_id] += 1
                        file_has_duplicate = True
                    else:
                        seen.add(key)

            if file_has_duplicate:
                files_with_dupes.append(os.path.basename(filepath))

        except Exception:
            continue

    return files_with_dupes, variable_dup_counts, total_dup_rows


# =====================================================
# MAIN
# =====================================================

if __name__ == "__main__":

    os.makedirs(OUTPUT_DIR, exist_ok=True)

    files = glob.glob(os.path.join(DATA_DIR, "*.csv.gz"))
    print(f"Found {len(files)} files")

    batches = [files[i:i+BATCH_SIZE] for i in range(0, len(files), BATCH_SIZE)]

    all_dup_files = []
    grand_variable_counts = defaultdict(int)
    grand_total_dup_rows = 0

    print(f"Using {N_WORKERS} cores...")

    with Pool(N_WORKERS) as pool:
        results = pool.map(process_batch, batches)

    for files_with_dupes, variable_counts, total_dup_rows in results:

        all_dup_files.extend(files_with_dupes)
        grand_total_dup_rows += total_dup_rows

        for var, count in variable_counts.items():
            grand_variable_counts[var] += count

    # =================================================
    # WRITE OUTPUTS
    # =================================================

    with open(OUTPUT_FILES, "w") as f:
        for filename in all_dup_files:
            f.write(filename + "\n")

    with open(OUTPUT_TOTALS, "w") as f:
        f.write("Variable,Duplicate_Row_Count\n")
        for var in sorted(VARIABLES):
            f.write(f"{var},{grand_variable_counts.get(var, 0)}\n")

        f.write(f"\nTOTAL_DUPLICATE_ROWS,{grand_total_dup_rows}\n")
        f.write(f"FILES_WITH_DUPLICATES,{len(all_dup_files)}\n")

    print("======================================")
    print(f"Files containing duplicates: {len(all_dup_files)}")
    print(f"Total duplicate rows: {grand_total_dup_rows}")
    print("Outputs written to:")
    print(" -", OUTPUT_FILES)
    print(" -", OUTPUT_TOTALS)
