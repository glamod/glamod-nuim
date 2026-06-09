#!/bin/bash
set -e  # stop immediately if any part fails

INPUT_DIR=/ichec/work/glamod/land_project_workspace/data/level2/cdm_obs_core/monthly_data/r8.1/cdm_core
OUTPUT_BASE=/ichec/work/glamod/land_project_workspace/data/level2/cdm_obs_core/monthly_data/r8.1/daily_pq_tmp
FINAL_BASE=/ichec/work/glamod/land_project_workspace/data/level2/cdm_obs_core/monthly_data/r8.1/final_merged_pq
LOG_BASE=/ichec/work/glamod/land_project_workspace/data/level2/cdm_obs_core/r8.1_monthly-logs
STATION_LIST_BASE=/ichec/work/glamod/land_project_workspace/code/r8.1_pq_code
PYTHON_ENV=/ichec/work/glamod/land_project_workspace/code/r8.1_202602/hourly/muenv/bin/python

for PART in A B C D E
do
    echo "======================================"
    echo "🚀 Starting MONTHLY part $PART"
    echo "======================================"

    ./run_psv_to_parquet_autoscale.sh \
        "$INPUT_DIR" \
        "$OUTPUT_BASE/$PART" \
        "$FINAL_BASE/$PART" \
        "$LOG_BASE/$PART" \
        "$STATION_LIST_BASE/daily_station_list_${PART}.txt" \
        "$PYTHON_ENV"

    echo "✅ MONTHLY part $PART finished"
done

echo "🎉 ALL MONTHLY PARTS (A–E) COMPLETED"
