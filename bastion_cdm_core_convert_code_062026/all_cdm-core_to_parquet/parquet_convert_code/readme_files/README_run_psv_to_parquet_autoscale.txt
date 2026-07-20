— run_psv_to_parquet_autoscale.sh

# Auto-Scaling PSV → Parquet Pipeline Launcher

## Overview

This script is the auto-scaling execution engine for the PSV → Parquet pipeline.

It dynamically:
- Detects system CPU and RAM
- Estimates memory usage per job
- Computes optimal number of parallel workers
- Launches distributed Python jobs
- Performs final Parquet merge

---

## What it does

### 1. System detection
- Reads total CPU cores
- Reads total available RAM

---

### 2. Dataset detection
Determines frequency based on input path:

- sub_daily → sub_daily
- monthly → monthly
- other → daily (default)

---

### 3. Memory calibration run

Runs a test execution:

--merge_only

Used to estimate memory usage per job.

---

### 4. Parallel job calculation

Computes:

NUM_JOBS = min(CPU limit, RAM limit)

Applies safety buffers for stability.

---

### 5. Parallel execution

Launches multiple workers:

psv_to_pq_memory_eff_v3.py

Each worker processes:
- subset of stations
- chunked PSV ingestion
- Parquet writing

---

### 6. Final merge

After all jobs complete, merges Parquet files into:

insitu-observations-surface-land_{freq}_{YYYY_MM}.pq

---

## Inputs

- INPUT_DIR: raw PSV dataset
- OUTPUT_DIR: temporary Parquet output
- FINAL_DIR: final merged output
- LOG_DIR: logs and checkpoints
- STATION_LIST: station file list
- PYTHON_ENV: Python interpreter

---

## Outputs

Temporary outputs:
OUTPUT_DIR/job_*/

Final outputs:
FINAL_DIR/*.pq (monthly partitions)

Logs:
LOG_DIR/

---

## Execution Flow

run_psv_to_parquet_autoscale.sh  
→ system detection  
→ memory estimation run  
→ parallel job launch  
→ psv_to_pq_memory_eff_v3.py workers  
→ final merge  

---

## Key Features

- Auto-scaling based on hardware
- Memory-aware job splitting
- Crash-safe execution
- Parallel processing support
- Automatic final merge

---

## Important Notes

- Does NOT change data logic
- Only controls execution and scaling
- All outputs are always monthly (YYYY_MM)
- Frequency is only used for labeling outputs