# -*- coding: utf-8 -*-
"""
Monthly counts plotting script – linear and log plots-ran locally not om bastion

- Linear plots: separate n_pass and n_fail, plus other numeric columns
- Log plots: combined n_pass/n_fail AND separate log plots for all numeric columns
- Total counts included in plot titles
- Frequency label included
- Linear plots saved in counts/, log plots in log/
- X-axis shows only the year
"""

import pandas as pd
import matplotlib.pyplot as plt
import os
import matplotlib.dates as mdates
from matplotlib.ticker import FuncFormatter

# -----------------------------
# USER SETTINGS
# -----------------------------
CSV_PATH = r"C:\Users\snoone\Dropbox\Copernicus_2025\admin\release_8.2\plots\monthly\monthly_observation_counts_extended_monthly.csv"
FREQ_LABEL = "Monthly"

# Variable ID to name mapping for monthly data
VAR_MAP = {
    44: "precipitation",
    55: "snow_water_equivalent",
    85: "temperature",
    106: "wind_direction",
    107: "wind_speed",
    45: "fresh_snow",
    53: "snow_depth"
}

# -----------------------------
# OUTPUT FOLDERS
# -----------------------------
OUTPUT_DIR = os.path.dirname(CSV_PATH)
COUNT_DIR = os.path.join(OUTPUT_DIR, "counts")
LOG_DIR = os.path.join(OUTPUT_DIR, "log")
os.makedirs(COUNT_DIR, exist_ok=True)
os.makedirs(LOG_DIR, exist_ok=True)

# -----------------------------
# READ CSV
# -----------------------------
df = pd.read_csv(CSV_PATH)
df["year_month"] = pd.to_datetime(df["year_month"], format="%Y_%m")

META_COLUMNS = {"year_month", "observed_variable", "variable_name"}
VALUE_COLUMNS = [c for c in df.columns if c not in META_COLUMNS and pd.api.types.is_numeric_dtype(df[c])]

# -----------------------------
# PLOTTING
# -----------------------------
for var_id, var_name in VAR_MAP.items():
    sub = df[df["observed_variable"] == var_id].copy()
    if sub.empty:
        print(f"No data for {var_name}")
        continue

    sub = sub.sort_values("year_month")
    dates = sub["year_month"]
    dates_num = mdates.date2num(dates)
    width_days = (dates_num.max()-dates_num.min())/len(dates)*0.8 if len(dates) > 1 else 1.0

    # --- Linear plots: separate n_pass and n_fail ---
    for col, color in [("n_pass", "green"), ("n_fail", "black")]:
        if col not in VALUE_COLUMNS:
            continue
        missing = sub[col].isna()
        vals = sub[col].fillna(0).astype(float)
        total_vals = vals.sum()
        linear_vals = vals.copy()
        scale_label = ""
        if linear_vals.max() > 1_000_000:
            linear_vals /= 1_000_000
            scale_label = " (millions)"

        plt.figure(figsize=(18,6))
        bar_colors = ["red" if m else color for m in missing]

        plt.bar(
            dates_num,
            linear_vals,
            width=width_days,
            color=bar_colors,
            edgecolor="black",
        )
        plt.ylabel(f"{col}{scale_label}")
        plt.xlabel("Year")
        plt.title(f"{FREQ_LABEL} {var_name} – {col} (linear) | Total {col}: {int(total_vals):,}")
        plt.grid(axis="y", alpha=0.3)
        ax = plt.gca()
        ax.xaxis_date()
        ax.xaxis.set_major_locator(mdates.YearLocator(base=5))
        ax.xaxis.set_major_formatter(mdates.DateFormatter("%Y"))
        if scale_label:
            ax.yaxis.set_major_formatter(FuncFormatter(lambda x,_: f"{x:,.1f}M"))
        else:
            ax.yaxis.set_major_formatter(FuncFormatter(lambda x,_: f"{int(x):,}"))
        plt.xticks(rotation=45)
        plt.xlim(dates_num.min()-width_days, dates_num.max()+width_days)
        plt.ylim(bottom=0)
        plt.tight_layout()
        plt.savefig(os.path.join(COUNT_DIR, f"{var_name}_{col}_linear.pdf"))
        plt.close()

    # --- Linear plots for other numeric columns ---
    for col in VALUE_COLUMNS:
        if col in ["n_pass", "n_fail"]:
            continue
        missing = sub[col].isna()
        vals = sub[col].fillna(0).astype(float)
        total_vals = vals.sum()
        linear_vals = vals.copy()
        scale_label = ""
        if linear_vals.max() > 1_000_000:
            linear_vals /= 1_000_000
            scale_label = " (millions)"

        plt.figure(figsize=(18,6))
        bar_colors = ["red" if m else color for m in missing]

        plt.bar(
            dates_num,
            linear_vals,
            width=width_days,
            color=bar_colors,
            edgecolor="black",
        )
        plt.ylabel(f"{col}{scale_label}")
        plt.xlabel("Year")
        plt.title(f"{FREQ_LABEL} {var_name} – {col} (linear) | Total {col}: {int(total_vals):,}")
        plt.grid(axis="y", alpha=0.3)
        ax = plt.gca()
        ax.xaxis_date()
        ax.xaxis.set_major_locator(mdates.YearLocator(base=5))
        ax.xaxis.set_major_formatter(mdates.DateFormatter("%Y"))
        if scale_label:
            ax.yaxis.set_major_formatter(FuncFormatter(lambda x,_: f"{x:,.1f}M"))
        else:
            ax.yaxis.set_major_formatter(FuncFormatter(lambda x,_: f"{int(x):,}"))
        plt.xticks(rotation=45)
        plt.xlim(dates_num.min()-width_days, dates_num.max()+width_days)
        plt.ylim(bottom=0)
        plt.tight_layout()
        plt.savefig(os.path.join(COUNT_DIR, f"{var_name}_{col}_linear.pdf"))
        plt.close()

print("✅ Monthly plots generated successfully!")
