# -*- coding: utf-8 -*-
"""
Created on Mon Mar  9 12:40:56 2026

@author: snoone
"""

# -*- coding: utf-8 -*-
"""
Counter for multiple large sub-daily .psv.gz files
Only processes files listed in asn_list.txt
"""

import os
import gzip
import csv
from collections import defaultdict

# ==============================
# CONFIG
# ==============================
DATA_DIR = "/ichec/work/glamod/land_project_workspace/data/level2/cdm_obs_core/sub_daily_data/r8.1/r8.1_core"
FILE_LIST = "asn_list.txt"  # list of filenames, one per line
OUTPUT_DIR = "/ichec/work/glamod/land_project_workspace/code/r8.1_pq_code/outputs_single"
ERROR_LOG = "/ichec/work/glamod/land_project_workspace/code/r8.1_pq_code/sub_daily_vars_counts_r8.1_errors.log"

CODES_TO_COUNT = {"85", "107", "106", "58", "57", "36"}

os.makedirs(OUTPUT_DIR, exist_ok=True)

# ==============================
# Main
# ==============================
if __name__ == "__main__":

    # Clear previous error log
    if os.path.exists(ERROR_LOG):
        os.remove(ERROR_LOG)

    with open(FILE_LIST, "r") as f:
        files_to_process = [line.strip() for line in f if line.strip()]

    print(f"Total files to process: {len(files_to_process)}")

    for INPUT_FILE in files_to_process:

        filepath = os.path.join(DATA_DIR, INPUT_FILE)
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

            sorted_codes = sorted(CODES_TO_COUNT)
            output_file = os.path.join(OUTPUT_DIR, f"{INPUT_FILE}.csv")

            with open(output_file, "w") as out:
                out.write("File," + ",".join(sorted_codes) + "\n")
                out.write(
                    INPUT_FILE + "," +
                    ",".join(str(file_counts.get(code, 0)) for code in sorted_codes)
                    + "\n"
                )

            print(f"✔ Processed: {INPUT_FILE} -> {output_file}")

        except Exception as e:
            with open(ERROR_LOG, "a") as err:
                err.write(f"{INPUT_FILE},{repr(e)}\n")
            print(f"❌ Error processing {INPUT_FILE}, see {ERROR_LOG}")