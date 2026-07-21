#!/bin/bash
# ------------------------------------------------------
# Stable high-performance QFF processing
# Files processed in parallel
# One output per worker
# ------------------------------------------------------

set -euo pipefail

CODE_DIR="/ichec/work/glamod/land_project_workspace/code/r8.1_202602/hourly"
DATA_DIR="/ichec/work/glamod/land_project_workspace/data/level1/level1c_sub_daily_data_qff/release_8.1"

# File that contains FULL PATHS to .qff.gz files
FILE_LIST="qff_psv.txt"

OUT_DIR="outputs_qff"
LOG_DIR="logs_qff"

cd "$CODE_DIR" || exit 1

NCORES=70
export OMP_NUM_THREADS=1

mkdir -p "$OUT_DIR" "$LOG_DIR"

rm -f "$OUT_DIR"/*.csv "$LOG_DIR"/*.log

echo "Reading file list from $FILE_LIST..."

# ✅ Keep only .qff.gz files from the list (ignore anything else)
grep "\.qff\.gz$" "$FILE_LIST" | sort > all_files.txt

TOTAL=$(wc -l < all_files.txt)
echo "Total files to process: $TOTAL"

if [ "$TOTAL" -eq 0 ]; then
    echo "No valid .qff.gz files found."
    exit 1
fi

echo "Running parallel across $NCORES cores..."

parallel -j "$NCORES" --bar --halt soon,fail=1 \
"python count_qff_observations_vars.py {} $OUT_DIR/{/.}.csv" \
:::: all_files.txt

echo "Merging outputs..."

CSV_FILES=$(ls "$OUT_DIR"/*.csv 2>/dev/null || true)

if [ -z "$CSV_FILES" ]; then
    echo "No CSV files generated."
    exit 1
fi

FIRST=$(echo "$CSV_FILES" | head -n 1)

head -n 1 "$FIRST" > final_qff_count.csv

for f in $CSV_FILES; do
    tail -n +2 "$f" >> final_qff_count.csv
done

echo "Cleaning temporary files..."
rm -f "$OUT_DIR"/*.csv all_files.txt

echo "DONE ✅"
echo "Final file: final_qff_count.csv"