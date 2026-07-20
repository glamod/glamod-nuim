import pandas as pd
""" Appends on local machine one new record with observed variable 165 to each station by duplicating a template row, assigning the next record number, and preserving all existing data."""
# ----------------------------
# 1. Load
# ----------------------------
path = r"C:/Users/snoone/Dropbox/Copernicus_2025/glamod-nuim/bastion_cdm_core_convert_code_062026/dy_qff_to_cdm_core_convert/record_id_dy.csv"

df = pd.read_csv(path, dtype=str, encoding="utf-8-sig")

df.columns = df.columns.str.strip()
df = df.apply(lambda x: x.str.strip() if x.dtype == "object" else x)

df["record_number"] = pd.to_numeric(df["record_number"], errors="coerce")


# ----------------------------
# 2. ADD ONE NEW ROW PER station_id (DO NOT TOUCH EXISTING)
# ----------------------------
new_rows = []

for station_id, group in df.groupby("station_id", sort=False):

    max_record = group["record_number"].max()

    new_row = group.iloc[0].copy()   # copy template row

    new_record = max_record + 1

    new_row["record_number"] = new_record
    new_row["primary_station_id_2"] = f"{station_id}-165"
    new_row["primary_station_id_3"] = f"{station_id}-165-{int(new_record)}"

    new_rows.append(new_row)


# ----------------------------
# 3. APPEND (THIS IS THE KEY FIX)
# ----------------------------
df_final = pd.concat([df, pd.DataFrame(new_rows)], ignore_index=True)


# ----------------------------
# 4. SORT ONLY (DO NOT REWRITE DATA)
# ----------------------------
df_final = df_final.sort_values(["station_id", "record_number"]).reset_index(drop=True)


# ----------------------------
# 5. SAVE
# ----------------------------
out_path = path.replace(".csv", "_with165_FINAL.csv")
df_final.to_csv(out_path, index=False)

print("DONE ✔ Added one 165 row per station (original data preserved)")
print("Saved to:", out_path)