# -*- coding: utf-8 -*-
"""
Reshape station configuration data from wide to long format,
map source_ID -> C3S_Source_ID (case-sensitive),
assign record_ID so that src_1 -> N, src_2 -> N-1, ..., src_N -> 1 per primary_ID,
and save sorted by primary_ID with highest record_ID first.
"""

import re
import pandas as pd

# ---------------------------
# Paths
# ---------------------------
INPUT_CSV = r"C:/Users/snoone/Dropbox/Copernicus_2025/admin/8.2_data_release/station_configuration_files/daily/mingle_8.2.csv"
OUTPUT_CSV = r"C:/Users/snoone/Dropbox/Copernicus_2025/admin/8.2_data_release/station_configuration_files/daily/transformed_mingle_8.2.csv"

# ---------------------------
# Read input
# ---------------------------
data = pd.read_csv(INPUT_CSV, dtype=object)

# ---------------------------
# FIXED: safe pair extraction
# ---------------------------
def numeric_suffix(col):
    m = re.search(r"_(\d+)$", col)
    return int(m.group(1)) if m else -1

src_cols = sorted([c for c in data.columns if c.startswith("src_")], key=numeric_suffix)
id_cols  = sorted([c for c in data.columns if c.startswith("id_")],  key=numeric_suffix)

if not src_cols or not id_cols:
    raise ValueError("No src_* or id_* columns detected. Check CSV header names.")

# ---------------------------
# BUILD LONG FORMAT SAFELY (NO MERGE = NO DUPLICATES)
# ---------------------------
rows = []

for _, r in data.iterrows():
    primary = r["primary_ID"]

    for i in range(1, 15):
        src = r.get(f"src_{i}")
        sid = r.get(f"id_{i}")

        # keep row if either exists
        if pd.notna(src) or pd.notna(sid):
            rows.append((primary, i, src, sid))

merged = pd.DataFrame(rows, columns=["primary_ID", "pair", "source_ID", "secondary_ID"])

# ---------------------------
# drop fully empty rows
# ---------------------------
merged = merged.dropna(subset=["source_ID", "secondary_ID"], how="all").copy()

# ---------------------------
# Map source_ID -> C3S_Source_ID
# ---------------------------
c3s_map = {
    "Blank": "Blank",
    "0": "161","1":"409","2":"410", "6":"162", "7":"120",
    "A":"224","a":"225","B":"159","b":"226",
    "C":"227","D":"228","d":"411","E":"229","F":"230",
    "f":"408","G":"231","H":"160","I":"232","K":"233",
    "M":"234","m":"196","N":"235","Q":"236","R":"237",
    "r":"238","S":"166","s":"239","T":"240","U":"241",
    "u":"242","W":"163","X":"164","Z":"165","z":"243"
}

merged["source_ID_str"] = (
    merged["source_ID"]
    .where(merged["source_ID"].notna(), "Blank")
    .astype(str)
    .str.strip()
)

merged.loc[merged["source_ID_str"] == "", "source_ID_str"] = "Blank"

merged["C3S_Source_ID"] = merged["source_ID_str"].map(c3s_map)

# optional debug
unmapped = merged.loc[merged["C3S_Source_ID"].isna(), "source_ID_str"].unique()
if len(unmapped) > 0:
    print("Warning: unmapped source_ID values:", list(unmapped))

# ---------------------------
# Sort properly
# ---------------------------
merged_sorted = merged.sort_values(
    ["primary_ID", "pair"],
    ascending=[True, True]
).reset_index(drop=True)

# ---------------------------
# Assign descending record_ID per primary_ID
# ---------------------------
merged_sorted["record_ID"] = (
    merged_sorted.groupby("primary_ID")
    .cumcount(ascending=False)
    + 1
)

# ---------------------------
# Final output
# ---------------------------
final = merged_sorted[
    ["primary_ID", "record_ID", "C3S_Source_ID", "secondary_ID"]
].copy()

final = final.sort_values(
    ["primary_ID", "record_ID"],
    ascending=[True, False]
).reset_index(drop=True)

final.to_csv(OUTPUT_CSV, index=False)

print(f"Saved transformed data to: {OUTPUT_CSV}")