# -*- coding: utf-8 -*-
"""
Monthly counts plotting script – linear and log plots

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
CSV_PATH = r"C:\Users\snoone\Dropbox\Copernicus_2025\admin\release_8.1\plots\monthly\monthly_observation_counts_extended_monthly.csv"
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
        vals = sub[col].fillna(0).astype(float)
        total_vals = vals.sum()
        linear_vals = vals.copy()
        scale_label = ""
        if linear_vals.max() > 1_000_000:
            linear_vals /= 1_000_000
            scale_label = " (millions)"

        plt.figure(figsize=(18,6))
        plt.bar(dates_num, linear_vals, width=width_days, color=color, edgecolor="black")
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
        vals = sub[col].fillna(0).astype(float)
        total_vals = vals.sum()
        linear_vals = vals.copy()
        scale_label = ""
        if linear_vals.max() > 1_000_000:
            linear_vals /= 1_000_000
            scale_label = " (millions)"

        plt.figure(figsize=(18,6))
        plt.bar(dates_num, linear_vals, width=width_days, color="steelblue", edgecolor="black")
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

    # --- Log plots: combined n_pass/n_fail ---
    # --- Log plots: combined n_pass/n_fail ---a
        if "n_pass" in VALUE_COLUMNS and "n_fail" in VALUE_COLUMNS:
            pass_values = sub["n_pass"].fillna(0).astype(float).clip(lower=0.001)
            fail_values = sub["n_fail"].fillna(0).astype(float)
            total_pass, total_fail = sub["n_pass"].sum(), sub["n_fail"].sum()
        
            plt.figure(figsize=(18,6))
            plt.bar(dates_num, pass_values, width=width_days, color="green", label="n_pass")
        
            # Only plot n_fail if there are actual fails
            if total_fail > 0:
                fail_values = fail_values.clip(lower=0.001)
                plt.bar(dates_num, fail_values, width=width_days, color="black", label="n_fail")
        
            plt.yscale("log")
            plt.ylabel("Counts (log scale)")
            plt.xlabel("Year")
            plt.title(f"{FREQ_LABEL} {var_name} – n_pass (green) & n_fail (black, log) | "
                      f"Total n_pass: {int(total_pass):,}, Total n_fail: {int(total_fail):,}")
            plt.grid(axis="y", alpha=0.3)
            plt.legend()
            ax = plt.gca()
            ax.xaxis_date()
            ax.xaxis.set_major_locator(mdates.YearLocator(base=5))
            ax.xaxis.set_major_formatter(mdates.DateFormatter("%Y"))
            plt.xticks(rotation=45)
            plt.xlim(dates_num.min()-width_days, dates_num.max()+width_days)
            plt.tight_layout()
            plt.savefig(os.path.join(LOG_DIR, f"{var_name}_pass_fail_log.pdf"))
            plt.close()


    # --- Log plots for other numeric columns ---
    for col in VALUE_COLUMNS:
        if col in ["n_pass", "n_fail"]:
            continue
        vals = sub[col].fillna(0).astype(float).clip(lower=0.001)
        total_vals = sub[col].sum()
        linear_vals = vals.copy()
        scale_label = ""
        if linear_vals.max() > 1_000_000:
            linear_vals /= 1_000_000
            scale_label = " (millions)"

        plt.figure(figsize=(18,6))
        plt.bar(dates_num, linear_vals, width=width_days, color="steelblue", edgecolor="black")
        plt.yscale("log")
        plt.ylabel(f"{col} (log scale){scale_label}")
        plt.xlabel("Year")
        plt.title(f"{FREQ_LABEL} {var_name} – {col} (log) | Total {col}: {int(total_vals):,}")
        plt.grid(axis="y", alpha=0.3)
        ax = plt.gca()
        ax.xaxis_date()
        ax.xaxis.set_major_locator(mdates.YearLocator(base=5))
        ax.xaxis.set_major_formatter(mdates.DateFormatter("%Y"))
        plt.xticks(rotation=45)
        plt.xlim(dates_num.min()-width_days, dates_num.max()+width_days)
        plt.tight_layout()
        plt.savefig(os.path.join(LOG_DIR, f"{var_name}_{col}_log.pdf"))
        plt.close()

print("✅ Monthly plots generated successfully!")
