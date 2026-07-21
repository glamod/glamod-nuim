# NCEI SuperGHCND Monthly Update Pipeline

## Overview

This script downloads and processes NCEI SuperGHCND daily update (`superghcnd_diff`) files and converts them into CDM Lite PSV and Parquet (`.pq`) files.

The pipeline now processes data **one calendar month at a time**. Each monthly output contains **only observations from the requested month**, even if an input update file spans two months.

Example output:

```
insitu-observations-surface-land_daily_2026_01.pq
insitu-observations-surface-land_daily_2026_02.pq
insitu-observations-surface-land_daily_2026_03.pq
```

---

# Operating Modes

The script supports three operating modes.

## 1. AUTO_MODE (recommended for operational updates)

Processes the **previous calendar month** only.

Example:

If today's date is **6 July 2026**, the script will automatically process **June 2026**.

### Settings

```python
AUTO_MODE = True

MANUAL_MONTHS = []
```

Run the script normally.

Output:

```
insitu-observations-surface-land_daily_2026_06.pq
```

---

## 2. MANUAL_MONTHS (recommended for historical processing)

Set:

```python
AUTO_MODE = False
```

Specify the months to process:

```python
MANUAL_MONTHS = [
    (2026, 1),
    (2026, 2),
    (2026, 3),
    (2026, 4),
]
```

The script will process each month independently.

Output:

```
insitu-observations-surface-land_daily_2026_01.pq
insitu-observations-surface-land_daily_2026_02.pq
insitu-observations-surface-land_daily_2026_03.pq
insitu-observations-surface-land_daily_2026_04.pq
```

Months may be listed in any order.

Example:

```python
MANUAL_MONTHS = [
    (2025, 12),
    (2026, 5),
    (2024, 8),
]
```

---

## 3. SPECIFIC_FILES_MODE

Use this mode when only selected NCEI update files should be processed.

Enable:

```python
SPECIFIC_FILES_MODE = True
```

Specify the files:

```python
SPECIFIC_FILES = [
    "superghcnd_diff_20260125_to_20260126.tar.gz",
    "superghcnd_diff_20260126_to_20260127.tar.gz",
]
```

The script ignores AUTO_MODE and MANUAL_MONTHS when this mode is enabled.

---

# Monthly Processing Workflow

For each requested month the pipeline performs the following steps:

1. Identify all SuperGHCND update files covering the requested month.
2. Download missing files.
3. Extract each archive.
4. Read `insert.csv`.
5. Convert observations to CDM Lite.
6. Filter observations to the requested calendar month only.
7. Combine all files for that month.
8. Remove duplicate observations.
9. Sort by `report_timestamp`.
10. Apply the Parquet schema.
11. Save PSV.
12. Save Parquet.
13. Remove downloaded archives and extracted folders.
14. Continue to the next month.

---

# Output Files

For each month the pipeline produces:

```
insitu-observations-surface-land_daily_YYYY_MM.psv
insitu-observations-surface-land_daily_YYYY_MM.pq
```

Example:

```
insitu-observations-surface-land_daily_2026_01.psv
insitu-observations-surface-land_daily_2026_01.pq
```

---

# Processed File Tracking

The pipeline maintains:

```
processed_files.txt
```

Each successfully processed NCEI update file is recorded.

If the script is run again, previously processed files are skipped automatically.

Delete `processed_files.txt` if a complete reprocessing of all selected files is required.

---

# Boundary Files

Some NCEI update files span two calendar months.

Example:

```
superghcnd_diff_20260131_to_20260201.tar.gz
```

These files are downloaded for both months when required.

The pipeline filters observations internally, ensuring that:

* January output contains only January observations.
* February output contains only February observations.

No observations from neighbouring months are included in the final monthly outputs.

---

# Typical Usage

## Operational monthly update

```python
AUTO_MODE = True
SPECIFIC_FILES_MODE = False
```

Run once each month.

---

## Backfill several months

```python
AUTO_MODE = False

MANUAL_MONTHS = [
    (2025, 11),
    (2025, 12),
    (2026, 1),
    (2026, 2),
]
```

Run once to generate all requested monthly files.

---

## Process individual update files

```python
SPECIFIC_FILES_MODE = True
```

Populate the `SPECIFIC_FILES` list with the required NCEI update archives.

---

# Notes

* Each monthly Parquet file contains observations from one calendar month only.
* Duplicate observations are removed before output.
* Output is sorted chronologically by `report_timestamp`.
* Temporary downloads and extracted folders are automatically removed after processing.
* Processed NCEI update files are tracked to prevent reprocessing unless the tracking file is deleted.
