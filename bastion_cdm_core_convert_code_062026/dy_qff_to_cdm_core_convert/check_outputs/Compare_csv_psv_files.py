# -*- coding: utf-8 -*-
"""
HPC-optimised CSV vs PSV row comparison
- 80 cores
- Streaming CSV output
- FIXED PSV header handling
"""

import os
import gzip
import csv
import csv as pycsv
from collections import Counter
from multiprocessing import Pool

# ---------------------------------------------------------------------
# CONFIG
# ---------------------------------------------------------------------
N_CORES = 80

csv_dir = "/ichec/work/glamod/land_project_workspace/data/level1/csv/daily"
psv_dir = "/ichec/work/glamod/land_project_workspace/data/level2/cdm_obs_core/daily_data/r8.1/cdm_core"
output_csv = "/ichec/work/glamod/land_project_workspace/code/r8.1_202602/daily/csv_vs_psv_counts_comparison.csv"

variables_of_interest = {
    "TMIN","TMAX","TAVG","SNWD","PRCP","SNOW","AWND","AWDR","WESD"
}

# CSV variable names -> PSV numeric codes
variable_codes = {
    "SNWD":"53",
    "PRCP":"44",
    "TMIN":"85",
    "TMAX":"85",
    "TAVG":"85",
    "SNOW":"45",
    "AWND":"107",
    "AWDR":"106",
    "WESD":"55"
}

# ---------------------------------------------------------------------
# CSV COUNTER
# ---------------------------------------------------------------------
def count_csv_rows(fpath):
    counts = Counter({v:0 for v in variables_of_interest})

    with gzip.open(fpath, "rt") as f:
        reader = csv.reader(f)

        first = next(reader, None)

        if first and len(first) > 2:
            if "observed_variable" not in first[2].lower():
                var = first[2].strip().upper()
                if var in counts:
                    counts[var] += 1

        for row in reader:
            if len(row) < 3:
                continue

            var = row[2].strip().upper()
            if var in counts:
                counts[var] += 1

    return counts

# ---------------------------------------------------------------------
# FIXED PSV COUNTER
# ---------------------------------------------------------------------
def count_psv_rows(fpath):
    counts = Counter()

    with gzip.open(fpath, "rt") as f:

        # Normalize header (IMPORTANT FIX)
        header = [h.strip().lower() for h in f.readline().split("|")]

        try:
            idx = header.index("observed_variable")
        except ValueError:
            print(f"ERROR: observed_variable not found in {fpath}")
            print("Header:", header)
            return counts

        for line in f:
            parts = line.rstrip("\n").split("|")

            if len(parts) <= idx:
                continue

            code = parts[idx].strip()

            if code:
                counts[code] += 1

    return counts

# ---------------------------------------------------------------------
# WORKER
# ---------------------------------------------------------------------
def process_station(args):
    station_id, csv_file, psv_file = args

    csv_counts = count_csv_rows(csv_file)
    psv_counts = count_psv_rows(psv_file)

    temp_csv = (
        csv_counts["TMIN"] +
        csv_counts["TMAX"] +
        csv_counts["TAVG"]
    )
    temp_psv = psv_counts.get("85", 0)

    row = {
        "station_id": station_id,

        "TEMP_CSV": temp_csv,
        "TEMP_PSV": temp_psv,

        "SNWD_CSV": csv_counts["SNWD"],
        "SNWD_PSV": psv_counts.get("53",0),

        "PRCP_CSV": csv_counts["PRCP"],
        "PRCP_PSV": psv_counts.get("44",0),

        "SNOW_CSV": csv_counts["SNOW"],
        "SNOW_PSV": psv_counts.get("45",0),

        "AWND_CSV": csv_counts["AWND"],
        "AWND_PSV": psv_counts.get("107",0),

        "AWDR_CSV": csv_counts["AWDR"],
        "AWDR_PSV": psv_counts.get("106",0),

        "WESD_CSV": csv_counts["WESD"],
        "WESD_PSV": psv_counts.get("55",0),
    }

    row["ALL_MATCH"] = all([
        row["TEMP_CSV"] == row["TEMP_PSV"],
        row["SNWD_CSV"] == row["SNWD_PSV"],
        row["PRCP_CSV"] == row["PRCP_PSV"],
        row["SNOW_CSV"] == row["SNOW_PSV"],
        row["AWND_CSV"] == row["AWND_PSV"],
        row["AWDR_CSV"] == row["AWDR_PSV"],
        row["WESD_CSV"] == row["WESD_PSV"]
    ])

    return row

# ---------------------------------------------------------------------
# BUILD STATION LIST
# ---------------------------------------------------------------------
csv_map = {
    f.replace(".csv.gz",""): os.path.join(csv_dir,f)
    for f in os.listdir(csv_dir)
    if f.endswith(".csv.gz")
}

psv_map = {
    f.replace(".psv.gz","").split("_")[-1]: os.path.join(psv_dir,f)
    for f in os.listdir(psv_dir)
    if f.endswith(".psv.gz")
}

common_ids = sorted(set(csv_map) & set(psv_map))
tasks = [(sid, csv_map[sid], psv_map[sid]) for sid in common_ids]

print(f"Processing {len(tasks)} stations...")

# ---------------------------------------------------------------------
# OUTPUT + SUMMARY
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
    "ALL_MATCH"
]

mismatch_counter = Counter()
total_stations = 0
all_match_count = 0

with open(output_csv, "w", newline="") as out_f:
    writer = pycsv.DictWriter(out_f, fieldnames=output_fields)
    writer.writeheader()

    with Pool(N_CORES) as pool:
        for row in pool.imap_unordered(process_station, tasks, chunksize=50):
            writer.writerow(row)

            total_stations += 1

            if row["ALL_MATCH"]:
                all_match_count += 1
            else:
                for var in ["TEMP","SNWD","PRCP","SNOW","AWND","AWDR","WESD"]:
                    if row[f"{var}_CSV"] != row[f"{var}_PSV"]:
                        mismatch_counter[var] += 1

# ---------------------------------------------------------------------
# SUMMARY
# ---------------------------------------------------------------------
print("\n=== SUMMARY ===")
print(f"Total stations processed: {total_stations}")
print(f"Stations with ALL_MATCH = True: {all_match_count}")
print(f"Stations with ALL_MATCH = False: {total_stations - all_match_count}")
print("Top mismatched variables:")

for var, count in mismatch_counter.most_common():
    print(f"  {var}: {count} mismatches")

print("\nDONE:", output_csv)
