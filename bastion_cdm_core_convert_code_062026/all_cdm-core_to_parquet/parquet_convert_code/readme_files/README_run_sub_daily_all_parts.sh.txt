— run_sub_daily_all_parts.sh
# Sub-Daily Full Pipeline Launcher (A–E)

## Overview

This script is the top-level orchestrator for the sub-daily ETL pipeline.  
It runs the full dataset in five partitions (A–E) to enable scalable processing across large station lists.

It does NOT process data directly. Instead, it calls the autoscaling pipeline for each partition.

---

## What it does

For each partition (A, B, C, D, E):

1. Selects a station subset file:
   - sub_daily_station_list_A.txt
   - sub_daily_station_list_B.txt
   - etc.

2. Calls the autoscaling pipeline:
   run_psv_to_parquet_autoscale.sh

3. Executes:
   - PSV → Parquet conversion
   - Parallel processing jobs
   - Monthly partitioning (YYYY_MM)
   - Final merge per partition

4. Writes logs and outputs per partition

---

## Inputs

- INPUT_DIR: Sub-daily CDM core dataset (PSV format)
- STATION_LIST_BASE: Directory containing station lists (A–E)
- PYTHON_ENV: Python environment used for execution

---

## Outputs

Temporary Parquet:
- daily_pq_tmp/A/
- daily_pq_tmp/B/
- daily_pq_tmp/C/
- daily_pq_tmp/D/
- daily_pq_tmp/E/

Final merged Parquet:
- final_merged_pq/A/
- final_merged_pq/B/
- final_merged_pq/C/
- final_merged_pq/D/
- final_merged_pq/E/

Logs:
- r8.1_sub_daily-logs/A/
- r8.1_sub_daily-logs/B/
- etc.

---

## Execution Flow

run_sub_daily_all_parts.sh  
→ run_psv_to_parquet_autoscale.sh  
→ psv_to_pq_memory_eff_v3.py  

---

## Notes

- Each partition runs independently
- Designed for HPC / multi-core environments
- Safe for large-scale batch execution