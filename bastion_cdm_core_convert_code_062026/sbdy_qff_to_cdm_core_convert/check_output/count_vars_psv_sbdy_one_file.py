# -*- coding: utf-8 -*-
"""
Created on Mon Mar  9 09:04:54 2026

@author: snoone
"""

# -*- coding: utf-8 -*-
"""
Counter for a single large sub-daily .psv.gz file
"""

import os
import gzip
import csv
from collections import defaultdict

# ==============================
# CONFIG
# ==============================

DATA_DIR = "/ichec/work/glamod/land_project_workspace/data/level2/cdm_obs_core/sub_daily_data/r8.1/r8.1_core"

INPUT_FILE = "cdm_core_r8.1_CAW00064757.psv.gz"

OUTPUT_TXT = "/ichec/work/glamod/land_project_workspace/code/r8.1_pq_code/sub_daily_vars_counts_r8.1_single.txt"

ERROR_LOG = "/ichec/work/glamod/land_project_workspace/code/r8.1_pq_code/sub_daily_vars_counts_r8.1_single_errors.log"

CODES_TO_COUNT = {"85", "107", "106", "58", "57", "36"}


# ==============================
# Main
# ==============================

if __name__ == "__main__":

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

        with open(OUTPUT_TXT, "w") as out:

            out.write("File," + ",".join(sorted_codes) + "\n")

            out.write(
                INPUT_FILE + "," +
                ",".join(str(file_counts.get(code, 0)) for code in sorted_codes)
                + "\n"
            )

        print("\n==============================")
        print("File processed:", INPUT_FILE)
        print("✔ Output saved to:", OUTPUT_TXT)

    except Exception as e:

        with open(ERROR_LOG, "w") as err:
            err.write(f"{INPUT_FILE},{repr(e)}\n")

        print("Error processing file. See:", ERROR_LOG)