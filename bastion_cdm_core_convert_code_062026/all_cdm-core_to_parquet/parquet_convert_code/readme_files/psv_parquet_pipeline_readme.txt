GLAMOD PSV  Parquet Processing Pipeline (Full End-to-End Workflow)
Overview:
This pipeline converts GLAMOD observational datasets from PSV format into partitioned Parquet
files using a scalable HPC workflow.

Supports: sub_daily, daily, monthly, hourly

Designed for HPC environments, large datasets, and crash recovery.

PIPELINE ARCHITECTURE:
STEP 1: PSV ® Parquet conversion (parallel processing)

STEP 2: Intermediate merge (job_* ® folder-level A–E consolidation)

STEP 3: Final merge (A–E ® global YYYY_MM datasets)

STEP 1 - CONVERSION:
- Reads PSV / PSV.GZ files in chunks
- Applies schema enforcement
- Assigns YYYY_MM partitions
- Writes Parquet outputs per station batch

Parallel Model:
Folder level: A, B, C, D, E
Job level: job_0...job_n inside each folder
Each job writes isolated outputs to prevent overwrite and ensure safe parallel execution.

Output format:
insitu-observations-surface-land__.pq
Stored in OUTPUT_BASE//job_/

Checkpointing:
Each job stores progress in log_dir/job_.checkpoint for restartability.

STEP 2 - INTERMEDIATE MERGE:
- Reads all job_* outputs inside each folder A–E
- Groups files by YYYY_MM
- Merges Parquet fragments
- Produces folder-level clean datasets

Output:
final_merged_pq/A ... E/
Each contains monthly Parquet files.

STEP 3 - FINAL MERGE:
- Combines A–E outputs per YYYY_MM
- Produces final consolidated dataset per month

FINAL OUTPUT:
One Parquet file per YYYY_MM per frequency.

KEY FEATURES:
- Chunked processing for memory safety
- Parallel execution across HPC cores
- Crash recovery via checkpoints
- Hierarchical processing (folder ® job ® station)
- Time-based partitioning (YYYY_MM)

RESULT:
Scalable, fault-tolerant ETL pipeline for large climate datasets.