# GSOM Monthly Update Pipeline

## Overview

This pipeline downloads the latest GSOM monthly update archive, converts the data to CDM Lite format, and produces **one PSV and one Parquet file for each requested calendar month**.

Unlike previous versions, each output file contains observations from **one calendar month only**.

Example outputs:

```text
cdm_lite_monthly_update_2024_01.psv
cdm_lite_monthly_update_2024_01.pq

cdm_lite_monthly_update_2024_02.psv
cdm_lite_monthly_update_2024_02.pq

cdm_lite_monthly_update_2024_03.psv
cdm_lite_monthly_update_2024_03.pq
```

---

# Processing Modes

The pipeline supports two processing modes.

## 1. AUTO_MODE (Operational Processing)

Processes the previous calendar month automatically.

### Settings

```python
AUTO_MODE = True

N_MONTHS_BACK = 1
```

If today's date is **6 July 2026**, the pipeline will automatically process **June 2026**.

Output:

```text
cdm_lite_monthly_update_2026_06.pq
```

To process more than one previous month automatically:

```python
AUTO_MODE = True

N_MONTHS_BACK = 3
```

This will process:

* April 2026
* May 2026
* June 2026

Each month is processed separately and produces its own PSV and Parquet file.

---

## 2. MANUAL_MONTHS (Historical Processing)

Disable AUTO_MODE:

```python
AUTO_MODE = False
```

Specify the required months:

```python
MANUAL_MONTHS = [
    (2024, 1),
    (2024, 2),
    (2024, 3),
    (2024, 4),
]
```

The pipeline processes each month independently.

Output:

```text
cdm_lite_monthly_update_2024_01.pq
cdm_lite_monthly_update_2024_02.pq
cdm_lite_monthly_update_2024_03.pq
cdm_lite_monthly_update_2024_04.pq
```

Months can be listed in any order.

Example:

```python
MANUAL_MONTHS = [
    (2025, 12),
    (2026, 5),
    (2023, 8),
]
```

---

# Processing Workflow

The pipeline performs the following steps.

## Step 1

Download the latest GSOM monthly update archive.

This is performed **once only**, regardless of the number of months requested.

---

## Step 2

Extract the archive.

Extraction is also performed only once.

---

## Step 3

Locate all GSOM station CSV files.

---

## Step 4

For each requested month:

* Filter observations to the requested year and month.
* Convert to CDM Lite format.
* Remove duplicate observations.
* Sort by `report_timestamp`.
* Apply the CDM Lite Parquet schema.
* Save one PSV file.
* Save one Parquet file.

---

## Step 5

After all requested months have been processed:

* Delete the downloaded archive.
* Remove the extracted directory.
* Finish processing.

---

# Output Files

Each requested month produces two files.

Example:

```text
cdm_lite_monthly_update_2024_01.psv
cdm_lite_monthly_update_2024_01.pq
```

The filename format is:

```text
cdm_lite_monthly_update_YYYY_MM
```

---

# Monthly Filtering

Each monthly output contains observations from **one calendar month only**.

Example:

If processing January 2024:

```python
MANUAL_MONTHS = [
    (2024, 1),
]
```

The resulting output contains only observations where:

```text
Year = 2024
Month = 01
```

No observations from December 2023 or February 2024 are included.

---

# Parallel Processing

Station files are processed using Python multiprocessing.

Each worker processes one station file while filtering observations to the requested month.

The monthly outputs are then combined into a single CDM Lite dataset for that month.

---

# Cleanup

Temporary files are removed automatically after processing completes.

The following are deleted:

* Downloaded GSOM archive.
* Extracted temporary directory.

Cleanup occurs **once**, after all requested months have been processed.

---

# Example 1 — Operational Monthly Update

```python
AUTO_MODE = True

N_MONTHS_BACK = 1
```

Produces:

```text
cdm_lite_monthly_update_2026_06.pq
```

---

# Example 2 — Historical Backfill

```python
AUTO_MODE = False

MANUAL_MONTHS = [
    (2024, 1),
    (2024, 2),
    (2024, 3),
]
```

Produces:

```text
cdm_lite_monthly_update_2024_01.pq
cdm_lite_monthly_update_2024_02.pq
cdm_lite_monthly_update_2024_03.pq
```

---

# Notes

* One output file is created for each requested calendar month.
* Each output contains observations from one month only.
* Duplicate observations are removed before output.
* Outputs are sorted chronologically by `report_timestamp`.
* The GSOM archive is downloaded and extracted only once, regardless of the number of months requested.
* Temporary download and extraction directories are automatically removed after processing completes.
