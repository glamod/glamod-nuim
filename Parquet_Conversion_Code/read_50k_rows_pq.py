# -*- coding: utf-8 -*-
"""
Created on Tue Aug 12 09:16:08 2025

@author: snoone
"""


import pandas as pd

# Read the Parquet file into a DataFrame
df = pd.read_parquet("/ichec/work/glamod/land_project_workspace/data/level2/cdm_obs_core/sub_daily_data/r8/sub_daily_pq_tmp/job_02_tmp/insitu-observations-surface-land_sub_daily_2025_02.pq")

print(df.dtypes)

# Save the first 50k rows to CSV

df.head(50000).to_csv("/ichec/work/glamod/land_project_workspace/code/r8_pq_code/r8_50000_rows_check_1.txt", index=False)
df.tail(50000).to_csv("/ichec/work/glamod/land_project_workspace/code/r8_pq_code/r8_50000_rows_check_2.txt", index=False)

