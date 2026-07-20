#!/usr/bin/env python3
#'## Counts valid observations for selected meteorological variables in a QFF file by station and outputs per-station totals to a CSV file.
import sys
import os
import gzip
import csv
from collections import defaultdict

# ============================================================
# CONFIG
# ============================================================

VARIABLES = [
    "temperature",
    "dew_point_temperature",
    "station_level_pressure",
    "sea_level_pressure",
    "wind_direction",
    "wind_speed",
]

# Columns in the QFF file (pipe separated)
# STATION is assumed to be column 0
STATION_INDEX = 0


# ============================================================
# FILE HANDLING
# ============================================================

def open_file(path):
    """Open normal or gzipped file safely."""
    if path.endswith(".gz"):
        return gzip.open(path, "rt", errors="ignore")
    return open(path, "r", errors="ignore")


# ============================================================
# PROCESS SINGLE QFF FILE
# ============================================================

def process_file(input_path):

    station_counts = defaultdict(lambda: defaultdict(int))

    try:
        with open_file(input_path) as f:

            # Read header
            header = f.readline().strip().split("|")

            # Find indexes of our variables dynamically
            var_indexes = {}

            for var in VARIABLES:
                if var in header:
                    var_indexes[var] = header.index(var)

            # Process rows
            for line in f:
                line = line.strip()
                if not line:
                    continue

                parts = line.split("|")

                if len(parts) < len(header):
                    continue

                station = parts[0]

                for var, idx in var_indexes.items():

                    if idx < len(parts):
                        value = parts[idx]

                        if value not in ("", "NA", "NULL"):
                            station_counts[station][var] += 1

    except Exception as e:
        print(f"Error processing file {input_path}: {e}", file=sys.stderr)

    return station_counts


# ============================================================
# WRITE OUTPUT CSV
# ============================================================

def write_output(output_path, counts):

    stations = sorted(counts.keys())

    # Prepare column totals
    column_totals = {var: 0 for var in VARIABLES}

    with open(output_path, "w", newline="") as csvfile:

        writer = csv.writer(csvfile)

        header = ["STATION_ID"] + VARIABLES
        writer.writerow(header)

        # Write station rows + accumulate totals
        for station in stations:

            row = [station]

            for var in VARIABLES:
                value = counts[station].get(var, 0)
                row.append(value)
                column_totals[var] += value

            writer.writerow(row)




# ============================================================
# MAIN
# ============================================================

def main():

    if len(sys.argv) != 3:
        print("Usage:")
        print("python count_qff_observations_vars.py <input_file.qff> <output.csv>")
        sys.exit(1)

    input_file = sys.argv[1]
    output_csv = sys.argv[2]

    if not os.path.exists(input_file):
        print(f"Input file does not exist: {input_file}")
        sys.exit(1)

    counts = process_file(input_file)

    write_output(output_csv, counts)

    print(f"Finished: {output_csv}")


# ============================================================

if __name__ == "__main__":
    main()