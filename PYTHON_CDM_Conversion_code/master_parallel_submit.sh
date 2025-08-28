#!/bin/bash

# =====================================================
# Master Parallel Submit Script for PSV -> Parquet
# Handles: sub-daily (hourly), daily, monthly
# =====================================================

# -----------------------------
# User Settings
# -----------------------------
PY_SCRIPT="/ichec/work/glamod/land_project_workspace/code/r8_pq_code/master_psv_to_pq_v6.py"
BASE_DIR="/ichec/work/glamod/land_project_workspace/data/level2/cdm_obs_core"

# Frequency settings: freq_name NUM_JOBS BATCH_SIZE INPUT_DIR TMP_OUTPUT_DIR FINAL_OUTPUT_DIR STATION_LIST
declare -A JOB_SETTINGS

# sub-daily / hourly
JOB_SETTINGS[sub-daily]="40 40 $BASE_DIR/sub_daily_data/r8/pq_test $BASE_DIR/sub_daily_data/r8/parquet_output_sub_daily_tmp $BASE_DIR/sub_daily_data/r8/parquet_output_sub_daily /ichec/work/glamod/land_project_workspace/code/r8_pq_code/sub_daily_station_list.txt"

# daily
JOB_SETTINGS[daily]="64 500 $BASE_DIR/daily_data/r8/cdm_core $BASE_DIR/daily_data/r8/parquet_output_daily_tmp $BASE_DIR/daily_data/r8/parquet_output_daily /ichec/work/glamod/land_project_workspace/code/r8_pq_code/daily_station_list.txt"

# monthly
JOB_SETTINGS[monthly]="32 5000 $BASE_DIR/monthly_data/r8/cdm_core $BASE_DIR/monthly_data/r8/parquet_output_monthly_tmp $BASE_DIR/monthly_data/r8/parquet_output_monthly /ichec/work/glamod/land_project_workspace/code/r8_pq_code/mnth_station_list.txt"


# -----------------------------
# Parse input: freq (sub-daily, daily, monthly)
# -----------------------------
if [ -z "$1" ]; then
    echo "Usage: $0 {sub-daily|daily|monthly}"
    exit 1
fi

FREQ="$1"

if [[ -z "${JOB_SETTINGS[$FREQ]}" ]]; then
    echo "Invalid frequency: $FREQ"
    exit 1
fi

# Read settings
read NUM_JOBS BATCH_SIZE INPUT_DIR TMP_OUTPUT_DIR FINAL_OUTPUT_DIR STATION_LIST <<< "${JOB_SETTINGS[$FREQ]}"

# -----------------------------
# Verify station list exists
# -----------------------------
if [[ ! -f "$STATION_LIST" ]]; then
    echo "❌ Station list not found: $STATION_LIST"
    exit 1
fi

# -----------------------------
# Logs
# -----------------------------
LOG_DIR="$BASE_DIR/${FREQ}_logs"
mkdir -p "$TMP_OUTPUT_DIR" "$FINAL_OUTPUT_DIR" "$LOG_DIR"

echo "Frequency   : $FREQ"
echo "Num Jobs    : $NUM_JOBS"
echo "Batch Size  : $BATCH_SIZE"
echo "Input Dir   : $INPUT_DIR"
echo "Temp Dir    : $TMP_OUTPUT_DIR"
echo "Final Dir   : $FINAL_OUTPUT_DIR"
echo "Station List: $STATION_LIST"
echo "Logs Dir    : $LOG_DIR"

# -----------------------------
# Environment setup
# -----------------------------
source /ichec/work/glamod/land_project_workspace/code/r8_202508/hourly/muenv/bin/activate

START_TIME=$(date +%s)

# -----------------------------
# Split station list into NUM_JOBS chunks
# -----------------------------
split -n l/$NUM_JOBS -d "$STATION_LIST" "$TMP_OUTPUT_DIR/stations_"
CHUNKS=($TMP_OUTPUT_DIR/stations_*)
echo "Found ${#CHUNKS[@]} station chunk(s) to process."

# -----------------------------
# Launch parallel jobs
# -----------------------------
for i in "${!CHUNKS[@]}"; do
    STATION_CHUNK="${CHUNKS[$i]}"
    JOB_ID="job_$(printf "%02d" $i)"
    JOB_TMP_DIR="$TMP_OUTPUT_DIR/$JOB_ID"
    mkdir -p "$JOB_TMP_DIR"

    echo "Starting $JOB_ID with ${STATION_CHUNK}"
    nohup python3 "$PY_SCRIPT" \
        --freq "$FREQ" \
        --input_dir "$INPUT_DIR" \
        --output_dir "$JOB_TMP_DIR" \
        --station_list_file "$STATION_CHUNK" \
        --job_id "$JOB_ID" \
        --batch_size "$BATCH_SIZE" \
        > "${LOG_DIR}/${JOB_ID}_pq_processed_log.txt" 2>&1 &
done

# Wait for all parallel jobs to finish
wait
echo "✅ All parallel jobs finished!"

# -----------------------------
# Merge final files
# -----------------------------
echo "Starting merge..."
python3 "$PY_SCRIPT" \
    --freq "$FREQ" \
    --output_dir "$TMP_OUTPUT_DIR" \
    --merge_only \
    --final_dir "$FINAL_OUTPUT_DIR" \
    > "${LOG_DIR}/merge_log.txt" 2>&1

echo "✅ Merge complete! Final files saved to $FINAL_OUTPUT_DIR"

# -----------------------------
# Summary
# -----------------------------
SUMMARY_FILE="${LOG_DIR}/summary.txt"
END_TIME=$(date +%s)
ELAPSED=$((END_TIME - START_TIME))

{
    echo "=============================="
    echo " Processing Summary ($FREQ)"
    echo "=============================="
    echo "Start Time : $(date -d @$START_TIME)"
    echo "End Time   : $(date -d @$END_TIME)"
    echo "Elapsed    : $((ELAPSED/3600))h $(((ELAPSED/60)%60))m $((ELAPSED%60))s"
    echo

    if [[ -f "${LOG_DIR}/processed_merge_pq.txt" ]]; then
        echo "✅ Total rows processed:"
        cat "${LOG_DIR}/processed_merge_pq.txt"
        echo
    else
        echo "⚠️  No processed_merge_pq.txt found"
    fi

    if [[ -f "${LOG_DIR}/failed_rows.pq" ]]; then
        echo "⚠️  Failed rows saved to: failed_rows.pq"
    else
        echo "✅ No failed rows"
    fi

    if [[ -f "${LOG_DIR}/failed_merge_pq.txt" ]]; then
        echo "⚠️  Failed merge list saved to: failed_merge_pq.txt"
    else
        echo "✅ No merge failures"
    fi
    echo "=============================="
} > "$SUMMARY_FILE"

echo "📑 Logs available in $LOG_DIR"
echo "📄 Summary written to $SUMMARY_FILE"

echo "✅ Master submit finished for $FREQ!"

