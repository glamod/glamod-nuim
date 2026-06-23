# -*- coding: utf-8 -*-
"""
HPC-optimised CSV vs PSV row comparison
- includes ASLP + ASTP
- 80 cores
- streaming output
"""

import os
import gzip
import csv as pycsv
from csv import DictWriter
from collections import Counter
from multiprocessing import Pool, cpu_count

# ---------------------------------------------------------------------
# CONFIG
# ---------------------------------------------------------------------
N_CORES = min(80, cpu_count())

csv_dir = "/ichec/work/glamod/land_project_workspace/data/level1/csv/daily"
psv_dir = "/ichec/work/glamod/land_project_workspace/data/level2/cdm_obs_core/daily_data/r8.2/cdm_core"

output_csv = "/ichec/work/glamod/land_project_workspace/code/git_code/bastion_cdm_core_convert_code_062026/dy_qff_to_cdm_core_convert/csv_vs_psv_counts_comparison.csv"

variables_of_interest = {
    "TMIN","TMAX","TAVG",
    "SNWD","PRCP","SNOW",
    "AWND","AWDR","WESD",
    "ASLP","ASTP"
}

# ---------------------------------------------------------------------
# CSV COUNTER
# ---------------------------------------------------------------------
def count_csv_rows(fpath):
    counts = Counter({v: 0 for v in variables_of_interest})

    try:
        with gzip.open(fpath, "rt", errors="ignore") as f:
            reader = pycsv.reader(f)

            next(reader, None)  # skip header

            for row in reader:
                if len(row) < 3:
                    continue

                var = row[2].strip().upper()
                if var in counts:
                    counts[var] += 1

    except Exception as e:
        print(f"[CSV ERROR] {fpath}: {e}")

    return counts

# ---------------------------------------------------------------------
# PSV COUNTER
# ---------------------------------------------------------------------
def count_psv_rows(fpath):
    counts = Counter()

    try:
        with gzip.open(fpath, "rt", errors="ignore") as f:

            header = [h.strip().lower() for h in f.readline().split("|")]

            if "observed_variable" not in header:
                print(f"[PSV ERROR] missing observed_variable: {fpath}")
                return counts

            idx = header.index("observed_variable")

            for line in f:
                parts = line.rstrip("\n").split("|")

                if idx >= len(parts):
                    continue

                code = parts[idx].strip()
                if code:
                    counts[code] += 1

    except Exception as e:
        print(f"[PSV ERROR] {fpath}: {e}")

    return counts

# ---------------------------------------------------------------------
# WORKER
# ---------------------------------------------------------------------
def process_station(args):
    station_id, csv_file, psv_file = args

    csv_counts = count_csv_rows(csv_file)
    psv_counts = count_psv_rows(psv_file)

    row = {
        "station_id": station_id,

        # TEMP group
        "TEMP_CSV": csv_counts["TMIN"] + csv_counts["TMAX"] + csv_counts["TAVG"],
        "TEMP_PSV": psv_counts.get("85", 0),

        # single variables
        "SNWD_CSV": csv_counts["SNWD"],
        "SNWD_PSV": psv_counts.get("53", 0),

        "PRCP_CSV": csv_counts["PRCP"],
        "PRCP_PSV": psv_counts.get("44", 0),

        "SNOW_CSV": csv_counts["SNOW"],
        "SNOW_PSV": psv_counts.get("45", 0),

        "AWND_CSV": csv_counts["AWND"],
        "AWND_PSV": psv_counts.get("107", 0),

        "AWDR_CSV": csv_counts["AWDR"],
        "AWDR_PSV": psv_counts.get("106", 0),

        "WESD_CSV": csv_counts["WESD"],
        "WESD_PSV": psv_counts.get("55", 0),

        # NEW VARIABLES INCLUDED
        "ASLP_CSV": csv_counts["ASLP"],
        "ASLP_PSV": psv_counts.get("58", 0),

        "ASTP_CSV": csv_counts["ASTP"],
        "ASTP_PSV": psv_counts.get("57", 0),
    }

    row["ALL_MATCH"] = all(
        row[f"{v}_CSV"] == row[f"{v}_PSV"]
        for v in ["TEMP","SNWD","PRCP","SNOW","AWND","AWDR","WESD","ASLP","ASTP"]
    )

    return row

# ---------------------------------------------------------------------
# BUILD FILE LIST
# ---------------------------------------------------------------------
csv_map = {
    f.replace(".csv.gz", ""): os.path.join(csv_dir, f)
    for f in os.listdir(csv_dir)
    if f.endswith(".csv.gz")
}

psv_map = {
    f.replace(".psv.gz", "").split("_")[-1]: os.path.join(psv_dir, f)
    for f in os.listdir(psv_dir)
    if f.endswith(".psv.gz")
}

common_ids = sorted(csv_map.keys() & psv_map.keys())
tasks = [(sid, csv_map[sid], psv_map[sid]) for sid in common_ids]

print(f"Processing {len(tasks)} stations using {N_CORES} cores")

# ---------------------------------------------------------------------
# OUTPUT
# ---------------------------------------------------------------------
output_fields = [
    "station_id",

    "TEMP_CSV","TEMP_PSV",

    "SNWD_CSV","SNWD_PSV",
    "PRCP_CSV","PRCP_PSV",
    "SNOW_CSV","SNOW_PSV",
    "AWND_CSV","AWND_PSV",
    "AWDR_CSV","AWDR_PSV",
    "WESD_CSV","WESD_PSV",

    "ASLP_CSV","ASLP_PSV",
    "ASTP_CSV","ASTP_PSV",

    "ALL_MATCH"
]

mismatch_counter = Counter()
total = 0
matched = 0

# ---------------------------------------------------------------------
# RUN
# ---------------------------------------------------------------------
with open(output_csv, "w", newline="") as f:
    writer = DictWriter(f, fieldnames=output_fields)
    writer.writeheader()

    with Pool(N_CORES) as pool:
        for row in pool.imap_unordered(process_station, tasks, chunksize=50):
            writer.writerow(row)

            total += 1
            if row["ALL_MATCH"]:
                matched += 1
            else:
                for v in ["TEMP","SNWD","PRCP","SNOW","AWND","AWDR","WESD","ASLP","ASTP"]:
                    if row[f"{v}_CSV"] != row[f"{v}_PSV"]:
                        mismatch_counter[v] += 1

# ---------------------------------------------------------------------
# SUMMARY
# ---------------------------------------------------------------------
print("\n=== SUMMARY ===")
print("Total stations:", total)
print("Matched:", matched)
print("Mismatched:", total - matched)

print("\nTop mismatches:")
for v, c in mismatch_counter.most_common():
    print(f"{v}: {c}")

print("\nDONE:", output_csv)