#!/bin/bash
# -------------------------------------------------------
# Run daily CSV -> CDM core in parallel (ICHEC)
# -------------------------------------------------------

# Move to working directory
cd /ichec/work/glamod/land_project_workspace/code/r8.1_202602/daily || exit 1

# Settings
LIST_FILE="dy_list_r8.1.txt"
NCORES=80
BATCH_DIR="batches"
LOG_DIR="logs"

# Create clean directories
mkdir -p $BATCH_DIR
mkdir -p $LOG_DIR

# Clean old batches (optional)
rm -f $BATCH_DIR/batch_*

echo "Splitting station list into $NCORES batches..."

# Split list into 80 balanced files
split -n l/$NCORES $LIST_FILE $BATCH_DIR/batch_

echo "Total batches created:"
ls $BATCH_DIR/batch_* | wc -l

# Prevent oversubscription
export OMP_NUM_THREADS=1

echo "Launching parallel jobs..."

# Run batches in parallel
ls $BATCH_DIR/batch_* | parallel -j $NCORES \
    "python daily_to_cdm_core_v2.py --subset {} \
    > $LOG_DIR/{/.}.out 2>&1"

echo "All batches completed."
echo "Logs written to: $LOG_DIR/"
