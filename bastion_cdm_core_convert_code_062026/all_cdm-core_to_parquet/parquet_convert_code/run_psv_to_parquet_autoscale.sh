#!/bin/bash
# Auto-scaling master launcher for PSV → PQ or PQ → PQ
# Detects input type, frequency, memory usage, and launches safe parallel jobs
# Labels outputs with correct freq + YYYY_MM

# -----------------------------
# USAGE
# ./run_psv_to_parquet_autoscale.sh INPUT_DIR OUTPUT_DIR FINAL_DIR LOG_DIR STATION_LIST PYTHON_ENV
# -----------------------------

INPUT_DIR=$1
OUTPUT_DIR=$2
FINAL_DIR=$3
LOG_DIR=$4
STATION_LIST=$5
PYTHON_ENV=$6

# -----------------------------
# System resources
# -----------------------------
TOTAL_CORES=$(nproc)
TOTAL_MEM_MB=$(free -m | awk '/Mem:/ {print $2}')
echo "Detected $TOTAL_CORES cores, $TOTAL_MEM_MB MB total RAM"

# -----------------------------
# Detect input type and frequency
# -----------------------------
FIRST_FILE=$(head -n 1 "$STATION_LIST")
FREQ="daily"  # default

if [[ "$FIRST_FILE" == *.psv* ]]; then
    if [[ "$INPUT_DIR" == *sub_daily* ]]; then
        FREQ="sub_daily"
    elif [[ "$INPUT_DIR" == *monthly* ]]; then
        FREQ="monthly"
    else
        FREQ="daily"
    fi
    PYTHON_SCRIPT=/ichec/work/glamod/land_project_workspace/code/r8.1_pq_code/sub_daily_psv_to_pq_memory_eff_v3.py
    echo "Detected PSV input. Frequency set to $FREQ."
elif [[ "$FIRST_FILE" == *.pq ]]; then
    FREQ="sub_daily"
    PYTHON_SCRIPT=/ichec/work/glamod/land_project_workspace/code/r8.1_pq_code/sub_daily_psv_to_pq_memory_eff_v3.py
    echo "Detected PQ input. Frequency assumed $FREQ."
else
    echo "❌ Unknown input type: $FIRST_FILE"
    exit 1
fi

# -----------------------------
# Set safe cores and memory buffers per freq
# -----------------------------
case $FREQ in
    sub_daily)
        CORES_RESERVED=8
        MEM_BUFFER_PERCENT=10
        ;;
    daily)
        CORES_RESERVED=2
        MEM_BUFFER_PERCENT=5
        ;;
    monthly)
        CORES_RESERVED=2
        MEM_BUFFER_PERCENT=5
        ;;
    *)
        CORES_RESERVED=2
        MEM_BUFFER_PERCENT=5
        ;;
esac

AVAIL_MEM_MB=$(( TOTAL_MEM_MB * (100 - MEM_BUFFER_PERCENT)/100 ))
echo "Adjusted safe RAM: $AVAIL_MEM_MB MB, leaving $CORES_RESERVED cores free"

# -----------------------------
# Test job to estimate memory per job
# -----------------------------
TEST_DIR="$OUTPUT_DIR/job_test"
mkdir -p "$TEST_DIR"

START_MEM=$(free -m | awk '/Mem:/ {print $7}')
$PYTHON_ENV "$PYTHON_SCRIPT" \
    --freq "$FREQ" \
    --input_dir "$INPUT_DIR" \
    --output_dir "$TEST_DIR" \
    --station_list_file "$STATION_LIST" \
    --job_id 0 \
    --num_jobs 1 \
    --log_dir "$LOG_DIR" \
    --merge_only &> /dev/null
END_MEM=$(free -m | awk '/Mem:/ {print $7}')
MEM_USED=$(( START_MEM - END_MEM ))
if [ "$MEM_USED" -le 0 ]; then MEM_USED=4000; fi
rm -rf "$TEST_DIR"
echo "Estimated memory per job: $MEM_USED MB"

# -----------------------------
# Compute number of parallel jobs
# -----------------------------
MAX_JOBS_CPU=$(( TOTAL_CORES - CORES_RESERVED ))
MAX_JOBS_MEM=$(( AVAIL_MEM_MB / MEM_USED ))
NUM_JOBS=$(( MAX_JOBS_CPU < MAX_JOBS_MEM ? MAX_JOBS_CPU : MAX_JOBS_MEM ))
if [ "$NUM_JOBS" -lt 1 ]; then NUM_JOBS=1; fi
echo "Launching $NUM_JOBS parallel jobs"

# -----------------------------
# Ensure directories exist
# -----------------------------
mkdir -p "$LOG_DIR" "$OUTPUT_DIR" "$FINAL_DIR"

# -----------------------------
# Launch parallel jobs
# -----------------------------
for i in $(seq 0 $((NUM_JOBS-1))); do
    JOB_TEMP_DIR="$OUTPUT_DIR/job_$i"
    mkdir -p "$JOB_TEMP_DIR"
    $PYTHON_ENV "$PYTHON_SCRIPT" \
        --freq "$FREQ" \
        --input_dir "$INPUT_DIR" \
        --output_dir "$JOB_TEMP_DIR" \
        --station_list_file "$STATION_LIST" \
        --job_id "$i" \
        --num_jobs "$NUM_JOBS" \
        --log_dir "$LOG_DIR" &
done

wait
echo "✅ All parallel jobs completed."

# -----------------------------
# Final merge
# -----------------------------
echo "Starting final merge..."
$PYTHON_ENV "$PYTHON_SCRIPT" \
    --freq "$FREQ" \
    --output_dir "$OUTPUT_DIR" \
    --final_dir "$FINAL_DIR" \
    --log_dir "$LOG_DIR" \
    --merge_only
echo "✅ Merge completed."
