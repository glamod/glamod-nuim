##  Data Parquet Processing Pipeline (GLAMOD) 

This repository contains scripts used to process and merge daily/sbdy/mnth CDM Core observational data into Parquet format 

---

## Overview

The pipeline is split into two main stages:

1. **PSV → Parquet conversion (parallelised by station subsets A–E)**
2. **Post-processing merge of Parquet outputs into final datasets**

Processing is partitioned to improve scalability, fault tolerance, and memory efficiency.

---

## 1. Batch Execution Script

### `run_daily_pipeline.sh`

This script orchestrates the full daily processing workflow across five partitions (A–E).

### Workflow

For each partition:

* Reads a station list (`daily_station_list_<PART>.txt`)
* Converts CDM Core PSV input data into Parquet format
* Writes intermediate outputs to a temporary directory
* Produces logs for monitoring and debugging
* Writes final merged Parquet outputs

### Configuration Paths

* **Input data**
  `cdm_core` daily dataset

* **Temporary Parquet output**
  `daily_pq_tmp/<PART>/`

* **Final merged output**
  `final_merged_pq/<PART>/`

* **Logs**
  `r8.1_daily-logs/<PART>/`

* **Station lists**
  `daily_station_list_A.txt ... daily_station_list_E.txt`

* **Python environment**
  Dedicated virtual environment for Parquet processing

---

### Execution Flow

```bash
for PART in A B C D E
do
    ./run_psv_to_parquet_autoscale.sh ...
done
```

The script uses:

```bash
set -e
```

meaning execution will stop immediately if any partition fails.

---

## 2. Parquet Merge Logic

After conversion, intermediate Parquet files are merged into final datasets.

Each partition:

* Collects files from `job_*` subdirectories
* Groups files by station/tag identifier
* Reads all Parquet fragments using PyArrow
* Concatenates tables with schema promotion enabled
* Writes a single Parquet file per station/tag

### Output Naming Convention

```
insitu-observations-surface-land_daily_<tag>.pq
```

### Merge Logging

Each merge operation logs:

* Number of files merged
* Number of rows written
* Any failures (with error messages)

Logs are stored per partition.

---

## 3. Key Features

* Parallel processing via station partitioning (A–E)
* Robust failure handling per merge group
* Schema-safe Parquet concatenation (`promote=True`)
* Full audit logging of row counts and errors
* Modular design separating conversion and merge stages

---

## 4. Failure Handling

* Pipeline stops if any partition fails (`set -e`)
* Individual file merge failures are caught and logged without stopping execution
* Failed merges are recorded for post-run inspection

---

## 5. Outputs

Final outputs are structured as:

```
daily_data/r8.1/final_merged_pq/
    ├── A/
    ├── B/
    ├── C/
    ├── D/
    └── E/
```

Each folder contains one Parquet file per station/tag.

---

## 6. Notes

* Designed for large-scale climate observation datasets
* Optimised for distributed job execution environments
* Assumes consistent naming conventions across PSV input files
