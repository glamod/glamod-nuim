ubmit script for sub_daily PSV → Parquet
# ------------------------------------------
# --- CONFIGURATION ---
NUM_JOBS=6            # Parallel jobs; adjust based on RAM & file sizes
CHUNK_SIZE=120000     # Rows per chunk in Python script
FREQ=sub_daily
INPUT_DIR=/ichec/work/glamod/land_project_workspace/data/level2/cdm_obs_core/sub_daily_data/r8/r8_core
OUTPUT_DIR=/ichec/work/glamod/land_project_workspace/data/level2/cdm_obs_core/sub_daily_data/r8/sub_daily_pq_tmp
FINAL_DIR=/ichec/work/glamod/land_project_workspace/data/level2/cdm_obs_core/sub_daily_data/r8/final_merged_pq
LOG_DIR=/ichec/work/glamod/land_project_workspace/data/level2/cdm_obs_core/sub_daily-logs
STATION_LIST=/ichec/work/glamod/land_project_workspace/code/r8_pq_code/sub_daily_station_list.txt
PYTHON_SCRIPT=/ichec/work/glamod/land_project_workspace/code/r8_pq_code/sub_daily_psv_to_pq_memory_eff_v2.py
# Python environment
PYTHON_ENV=/ichec/work/glamod/land_project_workspace/code/r8_202508/hourly/muenv/bin/python
# Ensure log and output directories exist
mkdir -p "$LOG_DIR"
mkdir -p "$OUTPUT_DIR"
mkdir -p "$FINAL_DIR"
echo "Launching $NUM_JOBS parallel jobs..."
# Launch parallel jobs
for i in $(seq 0 $((NUM_JOBS-1))); do
    echo "Launching job $i of $NUM_JOBS..."
    $PYTHON_ENV "$PYTHON_SCRIPT" \
        --freq "$FREQ" \
        --input_dir "$INPUT_DIR" \
        --output_dir "$OUTPUT_DIR" \
        --station_list_file "$STATION_LIST" \
        --batch_size 50 \
        --job_id "$i" \
        --num_jobs "$NUM_JOBS" \
        --log_dir "$LOG_DIR" \
        --chunk_size "$CHUNK_SIZE" \
        &
done
# Wait for all jobs to finish
wait
echo "✅ All parallel jobs completed."
# Trigger merge only once (after all jobs)
echo "Starting final merge..."
$PYTHON_ENV "$PYTHON_SCRIPT" \
    --freq "$FREQ" \
    --output_dir "$OUTPUT_DIR" \
    --final_dir "$FINAL_DIR" \
    --log_dir "$LOG_DIR" \
    --merge_only
echo "✅ Merge completed."
