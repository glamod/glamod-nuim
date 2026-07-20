# -*- coding: utf-8 -*-
"""
Created on Tue Jan 27 10:57:52 2026

@author: snoone
"""

# -*- coding: utf-8 -*-
"""
 Counts per (year_month, observed_variable):
- total observations
- quality_flag pass (0)
- quality_flag fail (1)
- number of unique source_id
for plotting locally for checks
"""

import os
import re
from glob import glob
from collections import defaultdict

import pyarrow.parquet as pq
import pandas as pd

# ------------------------------------------------------------
# Paths
# ------------------------------------------------------------
INPUT_DIR = (
    "/ichec/work/glamod/land_project_workspace/data/level2/"
    "cdm_obs_core/monthly_data/r8.2/final_merged_pq/"
)

OUTPUT_DIR = (
    "/ichec/work/glamod/land_project_workspace/code/git_code/bastion_cdm_core_convert_code_062026/all_cdm-core_to_parquet/plot_outputs"
)

os.makedirs(OUTPUT_DIR, exist_ok=True)

# ------------------------------------------------------------
# Variable mapping
# ------------------------------------------------------------
VAR_MAP = {
    44: "precipitation",
    55: "snow_water_equivalent",
    85: "temperature",
    107: "wind_direction",
    106: "wind_speed",
    45: "fresh_snow",
    53: "snow_depth",
}

TARGET_VARS = set(VAR_MAP.keys())

# ------------------------------------------------------------
# Regex to extract YYYY_MM
# ------------------------------------------------------------
PATTERN = re.compile(r"_(\d{4}_\d{2})\.pq$")

# ------------------------------------------------------------
# Storage dictionaries
# ------------------------------------------------------------
n_obs = defaultdict(int)
n_pass = defaultdict(int)
n_fail = defaultdict(int)
source_ids = defaultdict(set)
latitudes = defaultdict(set)
longitudes = defaultdict(set)

# ------------------------------------------------------------
# Process parquet files (memory safe)
# ------------------------------------------------------------
pq_files = sorted(glob(os.path.join(INPUT_DIR, "*.pq")))
print(f"Found {len(pq_files)} monthly parquet files")

for f in pq_files:
    name = os.path.basename(f)
    m = PATTERN.search(name)
    if not m:
        continue

    yyyy_mm = m.group(1)

    # Read only needed columns
    table = pq.read_table(
        f,
        columns=[
            "observed_variable",
            "quality_flag",
            "source_id",
            "latitude",
            "longitude",
        ]
    )

    df = table.to_pandas()

    # Keep only target variables
    df = df[df["observed_variable"].isin(TARGET_VARS)]

    if df.empty:
        continue

    # --------------------------------------------------------
    # Counts
    # --------------------------------------------------------
    for var_id, g in df.groupby("observed_variable"):
        key = (yyyy_mm, var_id)

        n_obs[key] += len(g)
        n_pass[key] += (g["quality_flag"] == 0).sum()
        n_fail[key] += (g["quality_flag"] == 1).sum()
        source_ids[key].update(g["source_id"].dropna().unique())
        latitudes[key].update(g["latitude"].dropna().unique())
        longitudes[key].update(g["longitude"].dropna().unique())

    print(f"Processed {yyyy_mm}")

# ------------------------------------------------------------
# Build DataFrame
# ------------------------------------------------------------
rows = []
for (yyyy_mm, var_id) in n_obs.keys():
    rows.append({
        "year_month": yyyy_mm,
        "observed_variable": var_id,
        "variable_name": VAR_MAP[var_id],
        "n_observations": n_obs[(yyyy_mm, var_id)],
        "n_pass": n_pass[(yyyy_mm, var_id)],
        "n_fail": n_fail[(yyyy_mm, var_id)],
        "n_source_id": len(source_ids[(yyyy_mm, var_id)]),
        "latitude": len(latitudes[(yyyy_mm, var_id)]),
        "longitude": len(longitudes[(yyyy_mm, var_id)]),
    })

df = pd.DataFrame(rows)

# Sort by date properly
df["year"] = df["year_month"].str.slice(0, 4).astype(int)
df["month"] = df["year_month"].str.slice(5, 7).astype(int)
df = df.sort_values(["observed_variable", "year", "month"])

# ------------------------------------------------------------
# Save CSV
# ------------------------------------------------------------
csv_path = os.path.join(OUTPUT_DIR, "monthly_observation_counts_extended_monthly.csv")
df.drop(columns=["year", "month"]).to_csv(csv_path, index=False)

print(f"Saved CSV: {csv_path}")
print("✅ All CSV written successfully")
