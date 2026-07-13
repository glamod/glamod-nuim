# -*- coding: utf-8 -*-
"""
Created on Fri May 1 09:12:02 2026

Download + process selected NCEI superghcnd diff files
and create PSV + Parquet outputs.

Features:
- AUTO mode = previous month only
- MANUAL month selection
- SPECIFIC FILES mode
- Tracks already processed files
- Skips duplicates automatically
- ALWAYS removes tar.gz + extracted folders
- Output filename based on actual report_timestamp range
- Final output sorted by report_timestamp
- Saves PSV + Parquet (.pq)
- Applies fixed parquet schema

@author: snoone
"""

import os
import re
import tarfile
import shutil
import requests
import pandas as pd
from datetime import datetime
import sys
import gc
import stat
import time

sys.path.append(
    r"C:\Users\snoone\Dropbox\PYTHON_TRAINING\Daily_updates_CDM_CORE_2026"
)

import utils
import daily_csv_to_cdm_utils as d_utils

pd.options.mode.chained_assignment = None


# =========================================================
# PARQUET SCHEMA
# =========================================================
SCHEMA_DTYPES = {

    'station_name': 'string',
    'primary_station_id': 'string',
    'report_id': 'string',
    'observation_id': 'string',

    'longitude': 'float64',
    'latitude': 'float64',
    'height_of_station_above_sea_level': 'float64',

    'report_timestamp': 'datetime64[ns, UTC]',

    'report_meaning_of_time_stamp': 'Int64',
    'report_duration': 'Int64',
    'observed_variable': 'Int64',
    'units': 'Int64',

    'observation_value': 'float64',

    'quality_flag': 'Int64',
    'source_id': 'Int64',
    'data_policy_licence': 'Int64',
    'report_type': 'Int64',
    'value_significance': 'Int64'
}


# =========================================================
# USER SETTINGS
# =========================================================

# ---------------------------------------------------------
# AUTO MODE
# True  = previous month only
# False = use MANUAL_MONTHS
# ---------------------------------------------------------
AUTO_MODE = False

# ---------------------------------------------------------
# MANUAL MONTHS
# ---------------------------------------------------------
MANUAL_MONTHS = [
    (2026, 1),
    (2026, 2),
    (2026, 3),
    (2026, 4),
    (2026, 5),
]

# ---------------------------------------------------------
# SPECIFIC FILES MODE True yes false no
# ---------------------------------------------------------
SPECIFIC_FILES_MODE = False

# ---------------------------------------------------------
# SPECIFIC FILES
# ---------------------------------------------------------
SPECIFIC_FILES = [

    "superghcnd_diff_20260125_to_20260126.tar.gz",
    "superghcnd_diff_20260126_to_20260127.tar.gz",
    "superghcnd_diff_20260127_to_20260128.tar.gz",
    "superghcnd_diff_20260129_to_20260130.tar.gz",
    "superghcnd_diff_20260130_to_20260131.tar.gz",



]



# =========================================================
# CLEANUP SETTINGS
# =========================================================
REMOVE_TAR_FILES = True
REMOVE_EXTRACTED_FOLDERS = True

# =========================================================
# PATHS
# =========================================================
DOWNLOAD_DIR = utils.DAILY_UPDATE_OUTDIR
PROCESSING_DIR = utils.DAILY_UPDATE_CDM_LITE_OUTDIR

os.makedirs(DOWNLOAD_DIR, exist_ok=True)
os.makedirs(PROCESSING_DIR, exist_ok=True)

BASE_URL = "https://www.ncei.noaa.gov/pub/data/ghcn/daily/superghcnd/"

# =========================================================
# TRACKING FILE
# =========================================================
PROCESSED_LOG = os.path.join(
    PROCESSING_DIR,
    "processed_files.txt"
)


# =========================================================
# SAFE STRING HELPER
# =========================================================
def force_str(df, cols):

    for c in cols:

        if c in df.columns:
            df[c] = df[c].fillna("").astype(str)

    return df


# =========================================================
# LOAD PROCESSED FILES
# =========================================================
def load_processed_files():

    if not os.path.exists(PROCESSED_LOG):
        return set()

    with open(PROCESSED_LOG, "r") as f:

        processed = {
            line.strip()
            for line in f
            if line.strip()
        }

    return processed


# =========================================================
# SAVE PROCESSED FILE
# =========================================================
def save_processed_file(filename):

    with open(PROCESSED_LOG, "a") as f:
        f.write(filename + "\n")


# =========================================================
# CLEANUP
# =========================================================
def cleanup_files(tar_path, extract_dir):

    # -----------------------------------------------------
    # HANDLE READONLY FILES
    # -----------------------------------------------------
    def remove_readonly(func, path, _):

        try:

            os.chmod(path, stat.S_IWRITE)

            func(path)

        except Exception:
            pass

    # -----------------------------------------------------
    # REMOVE TAR FILE
    # -----------------------------------------------------
    if REMOVE_TAR_FILES and tar_path:

        try:

            if os.path.isfile(tar_path):

                for _ in range(10):

                    try:

                        os.remove(tar_path)

                        if not os.path.exists(tar_path):
                            break

                    except Exception:

                        time.sleep(1)

                if os.path.exists(tar_path):

                    print("WARNING: tar still exists")

                else:

                    print("Removed tar:", tar_path)

        except Exception as e:

            print("Could not remove tar:")
            print(str(e))

    # -----------------------------------------------------
    # REMOVE EXTRACTED FOLDER
    # -----------------------------------------------------
    if REMOVE_EXTRACTED_FOLDERS and extract_dir:

        try:

            if os.path.exists(extract_dir):

                gc.collect()

                time.sleep(2)

                for _ in range(10):

                    try:

                        shutil.rmtree(
                            extract_dir,
                            onerror=remove_readonly
                        )

                        if not os.path.exists(extract_dir):
                            break

                    except Exception:

                        gc.collect()

                        time.sleep(2)

                if os.path.exists(extract_dir):

                    try:

                        shutil.rmtree(
                            extract_dir,
                            ignore_errors=True
                        )

                    except Exception:
                        pass

                if os.path.exists(extract_dir):

                    print(
                        "WARNING: extracted folder still exists:"
                    )

                    print(extract_dir)

                else:

                    print(
                        "Removed extracted folder:",
                        extract_dir
                    )

        except Exception as e:

            print("Could not remove extracted folder:")
            print(str(e))


# =========================================================
# GET FILES
# =========================================================
def get_monthly_files(year, month):

    # =====================================================
    # SPECIFIC FILES MODE
    # =====================================================
    if SPECIFIC_FILES_MODE:

        print("\n=================================================")
        print("SPECIFIC FILES MODE")
        print("=================================================")

        for f in SPECIFIC_FILES:
            print(f)

        return SPECIFIC_FILES

    # =====================================================
    # NORMAL MODES
    # =====================================================
    r = requests.get(BASE_URL, timeout=60)

    matches = re.findall(
        r"superghcnd_diff_(\d{8})_to_(\d{8})\.tar\.gz",
        r.text
    )

    if not matches:
        raise RuntimeError("No NCEI files found")

    selected_files = []

    
    for start_date, end_date in matches:
    
        start_dt = datetime.strptime(start_date, "%Y%m%d")
        end_dt = datetime.strptime(end_date, "%Y%m%d")
    
        keep = (
            (start_dt.year == year and start_dt.month == month)
            or
            (end_dt.year == year and end_dt.month == month)
        )
    
        if keep:
    
            fname = (
                f"superghcnd_diff_"
                f"{start_date}_to_{end_date}.tar.gz"
            )
    
            selected_files.append(fname)

    selected_files = sorted(
        list(set(selected_files))
    )

    print("\n=================================================")
    print(f"FILES SELECTED: {len(selected_files)}")
    print("=================================================")

    for f in selected_files:
        print(f)

    return selected_files


# =========================================================
# DOWNLOAD
# =========================================================
def download_file(filename):

    url = BASE_URL + filename

    outpath = os.path.join(
        DOWNLOAD_DIR,
        filename
    )

    if os.path.exists(outpath):

        print("Already downloaded:", filename)

        return outpath

    print("Downloading:", filename)

    r = requests.get(
        url,
        stream=True,
        timeout=120
    )

    with open(outpath, "wb") as f:

        for chunk in r.iter_content(8192):

            if chunk:
                f.write(chunk)

    return outpath


# =========================================================
# EXTRACT
# =========================================================
def extract_tar(filepath):

    outdir = os.path.join(
        PROCESSING_DIR,
        os.path.basename(filepath).replace(".tar.gz", "")
    )

    os.makedirs(outdir, exist_ok=True)

    print("Extracting:", os.path.basename(filepath))

    with tarfile.open(filepath, "r:gz") as tar:
        tar.extractall(outdir)

    return outdir


# =========================================================
# FIND insert.csv
# =========================================================
def find_insert_file(root_dir):

    for root, _, files in os.walk(root_dir):

        for f in files:

            if f == "insert.csv":

                return os.path.join(root, f)

    raise FileNotFoundError("insert.csv not found")


# =========================================================
# PROCESS INSERT
# =========================================================
def process_insert(insert_path, year, month):

    print("Processing:", insert_path)

    df = pd.read_csv(
        insert_path,
        header=None,
        sep=",",
        low_memory=False
    )

    df.columns = [
        "Station_ID",
        "Date",
        "observed_variable",
        "observation_value",
        "quality_flag",
        "Measurement_flag",
        "Source_flag",
        "hour"
    ]

    # =====================================================
    # LOAD METADATA
    # =====================================================
    station_meta_df = pd.read_csv(
        utils.DAILY_STATION_RECORD_ENTRIES_OBS_LITE,
        encoding="latin-1"
    )

    station_meta_df.columns = (
        station_meta_df.columns.str.strip()
    )

    station_meta_df["station_id"] = (
        station_meta_df["station_id"].astype(str)
    )

    station_meta_df["record_number"] = (
        station_meta_df["record_number"].astype(str)
    )

    df["Station_ID"] = (
        df["Station_ID"].astype(str)
    )

    # =====================================================
    # FILTER INVALID STATIONS EARLY
    # =====================================================
    valid_stations = set(
        station_meta_df["station_id"]
    )

    df = df[
        df["Station_ID"].isin(valid_stations)
    ]

    # =====================================================
    # FILTER VARIABLES
    # =====================================================
    df = df[
        df["observed_variable"].isin(
            d_utils.VARIABLE_NAMES
        )
    ]

    # =====================================================
    # SOURCE FLAGS
    # =====================================================
    df["Source_flag"] = (
        df["Source_flag"]
        .fillna("")
        .astype(str)
        .str.strip()
    )

    df = df[
        df["Source_flag"].isin(
            d_utils.SOURCE_FLAGS.keys()
        )
    ]

    df["Source_flag"] = (
        df["Source_flag"]
        .map(d_utils.SOURCE_FLAGS)
    )

    df["source_id"] = df["Source_flag"]

    # =====================================================
    # VALUE SIGNIFICANCE
    # =====================================================
    df["value_significance"] = ""

    for k, v in d_utils.VALUE_SIGNIFICANCE.items():

        df.loc[
            df["observed_variable"] == k,
            "value_significance"
        ] = v

    # =====================================================
    # VALUES
    # =====================================================
    df["observation_value"] = pd.to_numeric(
        df["observation_value"],
        errors="coerce"
    )

    for var in d_utils.VARIABLE_NAMES:

        df = d_utils.convert_values(
            df,
            var,
            "observation_value",
            kelvin=True
        )

    # =====================================================
    # UNITS
    # =====================================================
    df["units"] = ""

    for k, v in d_utils.UNITS.items():

        df.loc[
            df["observed_variable"] == k,
            "units"
        ] = v

    # =====================================================
    # VARIABLE MAPPING
    # =====================================================
    df = force_str(
        df,
        ["observed_variable"]
    )

    for k, v in d_utils.VARIABLE_ID.items():

        df["observed_variable"] = (
            df["observed_variable"]
            .str.replace(k, v, regex=False)
        )

    # =====================================================
    # DATE SPLIT
    # =====================================================
    df["year"] = (
        df["Date"].astype(str).str[:4]
    )

    df["month"] = (
        df["Date"].astype(str).str[4:6]
    )

    df["day"] = (
        df["Date"].astype(str).str[6:8]
    )
    # KEEP ONLY REQUESTED MONTH
    df["year"] = df["year"].astype(int)
    df["month"] = df["month"].astype(int)
    
    df = df[
        (df["year"] == year) &
        (df["month"] == month)
    ].copy()
    
    print(f"Rows after month filter: {len(df):,}")
    
    # Convert back to strings for timestamp creation
   # Convert back to strings for timestamp creation
    df["year"] = df["year"].astype(str)
    df["month"] = df["month"].astype(str).str.zfill(2)
    df["day"] = df["day"].astype(str).str.zfill(2)

    # =====================================================
    # CDM FIELDS
    # =====================================================
    df["hour"] = "00"
    df["Minute"] = "00"

    df["report_type"] = "3"
    df["report_duration"] = "13"
    df["report_meaning_of_time_stamp"] = "1"

    df["primary_station_id"] = (
        df["Station_ID"]
    )

    df["qc_method"] = (
        df["quality_flag"].astype(str)
    )

    df["quality_flag"] = (
        df["quality_flag"].astype(str)
    )

    df.loc[
        df["quality_flag"] == "nan",
        "quality_flag"
    ] = "0"

    for k, v in d_utils.QUALITY_FLAGS.items():

        df["quality_flag"] = (
            df["quality_flag"]
            .astype(str)
            .str.replace(k, v, regex=False)
        )

    # =====================================================
    # TIMESTAMP
    # =====================================================
    df["Timestamp2"] = (
        df["year"] + "-" +
        df["month"] + "-" +
        df["day"]
    )

    df["Seconds"] = "00"
    df["offset"] = "+00"

    df["report_timestamp"] = (
        df["Timestamp2"] + " " +
        df["hour"] + ":" +
        df["Minute"] + ":" +
        df["Seconds"] + "+00"
    )

    df["report_id_a"] = (
        df["report_timestamp"]
    )

    df["source_id"] = (
        df["source_id"]
        .astype(str)
        .str.replace(".0", "", regex=False)
    )

    # =====================================================
    # CREATE primary_station_id_2
    # =====================================================
    df = df.astype(str)

    df["source_id"] = (
        df["source_id"]
        .apply(lambda x: x.replace(".0", ""))
    )

    df["primary_station_id_2"] = (
        df["primary_station_id"].astype(str) + "-" +
        df["source_id"].astype(str)
    )

    # =====================================================
    # APPLY DATA POLICY
    # =====================================================
    data_policy_df = pd.read_csv(
        utils.DAILY_STATION_RECORD_ENTRIES_OBS_LITE,
        encoding="latin-1"
    ).astype(str)

    df = d_utils.add_data_policy(
        df,
        data_policy_df
    )

    df = force_str(df, [
        "station_name",
        "primary_station_id",
        "observed_variable",
        "source_id",
        "quality_flag",
        "record_number"
    ])

    df = df.fillna("")

    # =====================================================
    # FIXED OBSERVATION ID
    # =====================================================
    df["dates"] = (
        df["report_id_a"]
        .astype(str)
        .str[:10]
    )

    df["record_number"] = (
        df["record_number"]
        .astype(str)
    )

    df["observation_id"] = (
        df["primary_station_id"].astype(str).str.strip() + "-" +
        df["record_number"].astype(str).str.strip() + "-" +
        df["dates"].astype(str).str.strip() + "-" +
        df["observed_variable"].astype(str).str.strip() + "-" +
        df["value_significance"].astype(str).str.strip()
    )

    df["report_id"] = (
        df["primary_station_id"].astype(str).str.strip() + "-" +
        df["record_number"].astype(str).str.strip() + "-" +
        df["dates"].astype(str).str.strip()
    )

    # =====================================================
    # FINAL OUTPUT
    # =====================================================
    df = df[[
        "station_name",
        "primary_station_id",
        "report_id",
        "observation_id",
        "longitude",
        "latitude",
        "height_of_station_above_sea_level",
        "report_timestamp",
        "report_meaning_of_time_stamp",
        "report_duration",
        "observed_variable",
        "units",
        "observation_value",
        "quality_flag",
        "source_id",
        "data_policy_licence",
        "report_type",
        "value_significance"
    ]]

    return df


# =========================================================
# OUTPUT NAME
# =========================================================
def make_output_name(year, month):

    return (
        f"insitu-observations-surface-land_daily_"
        f"{year}_{month:02d}.psv"
    )

# =========================================================
# APPLY SCHEMA
# =========================================================
def apply_schema(df):

    df = df.copy()

    # -----------------------------------------------------
    # DATETIME
    # -----------------------------------------------------
    df["report_timestamp"] = pd.to_datetime(
        df["report_timestamp"],
        errors="coerce",
        utc=True
    )

    # -----------------------------------------------------
    # APPLY DTYPES
    # -----------------------------------------------------
    for col, dtype in SCHEMA_DTYPES.items():

        if col not in df.columns:
            continue

        try:

            if "datetime64" in dtype:
                continue

            elif dtype == "Int64":

                df[col] = pd.to_numeric(
                    df[col],
                    errors="coerce"
                ).astype("Int64")

            elif dtype == "float64":

                df[col] = pd.to_numeric(
                    df[col],
                    errors="coerce"
                ).astype("float64")

            elif dtype == "string":

                df[col] = df[col].astype("string")

            else:

                df[col] = df[col].astype(dtype)

        except Exception as e:

            print(f"WARNING: could not convert {col} to {dtype}")
            print(str(e))

    return df

# =========================================================
# PIPELINE
# =========================================================
def run_pipeline():

    # -----------------------------------------------------
    # MONTHS TO PROCESS
    # -----------------------------------------------------
    if AUTO_MODE:

        now = datetime.utcnow()

        year = now.year
        month = now.month - 1

        if month == 0:
            month = 12
            year -= 1

        months_to_process = [(year, month)]

    else:

        months_to_process = MANUAL_MONTHS

    # -----------------------------------------------------
    # LOAD PROCESSED FILES
    # -----------------------------------------------------
    processed_files = load_processed_files()

    print("\n=================================================")
    print(f"ALREADY PROCESSED: {len(processed_files)}")
    print("=================================================")

    # -----------------------------------------------------
    # PROCESS EACH MONTH
    # -----------------------------------------------------
    for year, month in months_to_process:

        print("\n=================================================")
        print(f"PROCESSING {year}-{month:02d}")
        print("=================================================")

        files = get_monthly_files(year, month)

        if not files:
            print(f"No files found for {year}-{month:02d}")
            continue

        all_dfs = []

        # -------------------------------------------------
        # PROCESS EACH FILE
        # -------------------------------------------------
        for i, filename in enumerate(files, start=1):

            print("\n=================================================")
            print(f"[{i}/{len(files)}] {filename}")
            print("=================================================")

            if filename in processed_files:

                print("SKIPPING (already processed)")
                continue

            tar_path = None
            extract_dir = None

            try:

                tar_path = download_file(filename)

                extract_dir = extract_tar(tar_path)

                insert_path = find_insert_file(extract_dir)

                df = process_insert(insert_path, year, month)

                if not df.empty:
                   all_dfs.append(df)

                rows = len(df)

                del df

                gc.collect()

                save_processed_file(filename)

                print(f"Rows processed: {rows:,}")

            except Exception as e:

                print(f"FAILED: {filename}")
                print(str(e))

            finally:

                cleanup_files(
                    tar_path,
                    extract_dir
                )

        # -------------------------------------------------
        # NO DATA FOR THIS MONTH
        # -------------------------------------------------
        if not all_dfs:

            print(f"No observations for {year}-{month:02d}")
            continue

        # -------------------------------------------------
        # COMBINE
        # -------------------------------------------------
        final_df = pd.concat(
            all_dfs,
            ignore_index=True
        )

        final_df = final_df.drop_duplicates()

        # -------------------------------------------------
        # SORT
        # -------------------------------------------------
        final_df["report_timestamp_dt"] = pd.to_datetime(
            final_df["report_timestamp"],
            errors="coerce"
        )

        final_df = final_df.sort_values(
            "report_timestamp_dt"
        )

        final_df = final_df.drop(
            columns=["report_timestamp_dt"]
        )

        final_df = final_df.reset_index(drop=True)

        # -------------------------------------------------
        # APPLY SCHEMA
        # -------------------------------------------------
        final_df = apply_schema(final_df)

        # -------------------------------------------------
        # OUTPUT
        # -------------------------------------------------
        base_filename = make_output_name(year, month)

        psv_outpath = os.path.join(
            PROCESSING_DIR,
            base_filename
        )

        pq_outpath = os.path.join(
            PROCESSING_DIR,
            base_filename.replace(".psv", ".pq")
        )

        # -------------------------------------------------
        # SAVE
        # -------------------------------------------------
        final_df.to_csv(
            psv_outpath,
            sep="|",
            index=False
        )

        final_df.to_parquet(
            pq_outpath,
            index=False
        )

        print("\n=================================================")
        print(f"FINISHED {year}-{month:02d}")
        print("=================================================")
        print(f"Rows: {len(final_df):,}")

        print(f"Saved PSV: {psv_outpath}")
        print(f"Saved PQ : {pq_outpath}")


# =========================================================
if __name__ == "__main__":

    run_pipeline()