# -*- coding: utf-8 -*-
"""
Check schema of a Parquet file and save first 50,000 rows to CSV/text for inspection.

Created on Tue Aug 12 09:16:08 2025
@author: snoone
"""

import pandas as pd

# ==============================
# INPUT PARQUET FILE
# ==============================
parquet_file = "C:/Users/snoone/Dropbox/PYTHON_TRAINING/Daily_updates_CDM_CORE_2026/cdm_core_daily_update_outputs/daily_cdm_core_updates_1897-02-13_2026-01-30.pq"


# ==============================
# READ PARQUET INTO DATAFRAME
# ==============================
df = pd.read_parquet(parquet_file, engine="pyarrow")  # specify engine for consistency

# ==============================
# CHECK COLUMN DATA TYPES
# ==============================
print("=== Column Data Types ===")
print(df.dtypes)

# ==============================
# SAVE FIRST N ROWS TO CSV/TXT
# ==============================
output_csv = "C:/Users/snoone/Dropbox/PYTHON_TRAINING/Daily_updates_CDM_CORE_2026/dy_updates_first_N_rows_check.txt"
#edit based on number of rows set to read
df.head().to_csv(output_csv, index=False)
print(f"/nSaved first N rows to: {output_csv}")
