# -*- coding: utf-8 -*-
"""
Created on Fri Mar 20 16:26:21 2026

@author: snoone
"""

# -*- coding: utf-8 -*-
"""
Created on Fri Mar 20 16:21:10 2026

@author: snoone
"""

import pandas as pd
import os

# === Paths ===
input_file = "/ichec/work/glamod/land_project_workspace/data/level2/cdm_obs_core/monthly_data/r8.1/final_merged_pq/all/insitu-observations-surface-land_monthly_1936_01.pq"
output_file = "/ichec/work/glamod/land_project_workspace/code/r8.1_pq_code/source_id_NA_rows_single.csv"

# === Read the parquet file ===
try:
    df = pd.read_parquet(input_file)

    # === Find rows where source_id is <NA> ===
    missing_rows = df[df["source_id"].isna()].copy()

    if not missing_rows.empty:
        # Add filename column
        missing_rows["file_name"] = os.path.basename(input_file)
        # Save to CSV
        missing_rows.to_csv(output_file, index=False)
        print(f"✅ Done. Output saved to: {output_file}")
    else:
        print("✅ No <NA> source_id values found in this file.")

except Exception as e:
    print(f"❌ Error processing {input_file} → {e}")