# -*- coding: utf-8 -*-
"""
High-performance multi-core counter for large sub-daily .psv.gz files
Optimised for 80-core ICHEC node
"""

import os
import glob
import gzip
import csv
from collections import defaultdict
from multiprocessing import Pool

# ==============================
# CONFIG
# ==============================
DATA_DIR = "/ichec/work/glamod/land_project_workspace/data/level2/cdm_obs_core/daily_data/r8/cdm_core"
OUTPUT_TXT = "/ichec/work/glamod/land_project_workspace/code/r8.1_pq_code/daily_vars_counts_r8.txt"
ERROR_LOG = "/ichec/work/glamod/land_project_workspace/code/r8.1_pq_code/daily_vars_counts_r8_errors.log"

CODES_TO_COUNT = {"85", "107", "106", "58", "57", "36"}

N_WORKERS = 60        # Match SLURM allocation
BATCH_SIZE = 20       # Smaller batches (files are large)

# ==============================
# Worker
# ==============================
def process_batch(file_list):

    batch_totals = defaultdict(int)
    file_results = []
    errors = []

    for filepath in file_list:
        file_counts = defaultdict(int)

        try:
            with gzip.open(filepath, "rt") as fh:
                reader = csv.reader(fh, delimiter="|")
                header = next(reader)
                var_idx = header.index("observed_variable")

                for row in reader:
                    if len(row) <= var_idx:
                        continue
                    obs = row[var_idx]
                    if obs in CODES_TO_COUNT:
                        file_counts[obs] += 1
                        batch_totals[obs] += 1

            file_results.append((os.path.basename(filepath), dict(file_counts)))

        except Exception as e:
            errors.append((os.path.basename(filepath), repr(e)))

    return file_results, batch_totals, errors


# ==============================
# Main
# ==============================
if __name__ == "__main__":

    files = glob.glob(os.path.join(DATA_DIR, "*.psv.gz"))
    batches = [files[i:i+BATCH_SIZE] for i in range(0, len(files), BATCH_SIZE)]

    total_counts = defaultdict(int)
    bad_files = 0

    with Pool(N_WORKERS) as pool:
        results = pool.map(process_batch, batches)

    with open(OUTPUT_TXT, "w") as out, open(ERROR_LOG, "w") as err:

        sorted_codes = sorted(CODES_TO_COUNT)

        out.write("File," + ",".join(sorted_codes) + "\n")
        err.write("File,Error\n")

        for file_results, batch_totals, errors in results:

            for filename, file_counts in file_results:
                out.write(
                    filename + "," +
                    ",".join(str(file_counts.get(code, 0)) for code in sorted_codes)
                    + "\n"
                )

            for code, count in batch_totals.items():
                total_counts[code] += count

            for fname, error in errors:
                bad_files += 1
                err.write(f"{fname},{error}\n")

        out.write(
            "TOTAL," +
            ",".join(str(total_counts.get(code, 0)) for code in sorted_codes)
            + "\n"
        )

    print("\n==============================")
    print(f"Files processed: {len(files)}")
    print(f"Corrupt files: {bad_files}")
    print("✔ Output saved to:", OUTPUT_TXT)
