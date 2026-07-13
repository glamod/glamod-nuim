# -*- coding: utf-8 -*-

"""
Unified GSOM Monthly Update Pipeline
Created on Fri May 12 10:30:32 2026

Combines:

1. Monthly GSOM download/extraction
2. Multi-month filtering
3. CDM Lite conversion
4. PSV + Parquet output
5. Cleanup

@author: snoone
"""

import os
import gc
import glob
import stat
import time
import shutil
import tarfile
import requests
import calendar
import datetime
import pandas as pd
import logging
from multiprocessing import Pool, cpu_count
pd.options.mode.chained_assignment = None
#---------------------------------------------
def process_wrapper(args):

    infile, target_months = args

    try:

        out = process_station_file(
            infile,
            target_months
        )

        logger.info(
            f"{os.path.basename(infile)} "
            f"-> {len(out):,} rows"
        )

        return out

    except Exception:

        logger.exception(
            f"FAILED processing file: {infile}"
        )

        return pd.DataFrame()
# =========================================================
# LOGGING
# =========================================================

LOG_FILE = "monthly_update_pipeline.log"

logging.basicConfig(
    level=logging.INFO,
    format=(
        "%(asctime)s | "
        "%(levelname)s | "
        "%(message)s"
    ),
    handlers=[
        logging.FileHandler(LOG_FILE),
        logging.StreamHandler()
    ]
)

logger = logging.getLogger(__name__)

# =========================================================
# IMPORT MONTHLY UTILS
# =========================================================

import mnth_utils as utils

# =========================================================
# SETTINGS
# =========================================================

AUTO_MODE = False

N_MONTHS_BACK = 1

MANUAL_MONTHS = [
    (2024, 1),
    (2024, 2),
    (2024, 3),
    (2024, 4),
    (2024, 5),
]

REMOVE_TAR_FILES = True
REMOVE_EXTRACTED_FOLDERS = True

SAVE_PSV = True
SAVE_PARQUET = True

# =========================================================
# PATHS
# =========================================================

DOWNLOAD_DIR = utils.MONTHLY_UPDATE_OUTDIR
EXTRACT_DIR = utils.MONTHLY_UPDATE_EXTRACTDIR
OUTPUT_DIR = utils.MONTHLY_UPDATE_CDM_LITE_OUTDIR

os.makedirs(DOWNLOAD_DIR, exist_ok=True)
os.makedirs(EXTRACT_DIR, exist_ok=True)
os.makedirs(OUTPUT_DIR, exist_ok=True)

# =========================================================
# URL
# =========================================================

BASE_URL = (
    f"{utils.MONTHLY_URL_HOST}"
    f"{utils.MONTHLY_URL_DIR}"
)

UPDATE_FILE = utils.MONTHLY_UPDATE_FILE

# =========================================================
# INPUT VARIABLES
# =========================================================

LITE_COLS = [
    "STATION",
    "LATITUDE",
    "LONGITUDE",
    "ELEVATION",
    "DATE",
    "NAME",
    "PRCP",
    "TMIN",
    "TMAX",
    "TAVG",
    "SNOW",
    "AWND"
]

# =========================================================
# VARIABLE SETTINGS
# =========================================================

UNITS = {
    "PRCP": "710",
    "TMIN": "5",
    "TMAX": "5",
    "TAVG": "5",
    "SNOW": "710",
    "AWND": "731",
}

VALUE_SIGNIFICANCE = {
    "PRCP": "13",
    "TMIN": "1",
    "TMAX": "0",
    "TAVG": "2",
    "SNOW": "13",
    "AWND": "2",
}

VARIABLE_ID = {
    "PRCP": "44",
    "TMIN": "85",
    "TMAX": "85",
    "TAVG": "85",
    "SNOW": "45",
    "AWND": "107",
}

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
# LOAD DATA POLICY
# =========================================================

DATA_POLICY_DF = pd.read_csv(
    utils.MONTHLY_STATION_RECORD_ENTRIES_OBS_LITE,
    encoding='latin-1'
)

# ---------------------------------------------------------
# CLEAN IDS
# ---------------------------------------------------------

DATA_POLICY_DF['record_id'] = (
    DATA_POLICY_DF['record_id']
    .astype(str)
    .str.replace('.0', '', regex=False)
    .str.strip()
    .str.upper()
)

DATA_POLICY_DF['station_id'] = (
    DATA_POLICY_DF['station_id']
    .astype(str)
    .str.replace('.0', '', regex=False)
    .str.strip()
    .str.upper()
)

DATA_POLICY_DF['source_id'] = (
    DATA_POLICY_DF['source_id']
    .astype(str)
    .str.replace('.0', '', regex=False)
    .str.strip()
)

DATA_POLICY_DF = DATA_POLICY_DF.astype(str)

logger.info(
    f"Loaded data policy rows: "
    f"{len(DATA_POLICY_DF):,}"
)
# =========================================================
# DATE HELPERS
# =========================================================

def add_months(sourcedate, months):

    month = sourcedate.month - 1 + months

    year = sourcedate.year + month // 12

    month = month % 12 + 1

    day = min(
        sourcedate.day,
        calendar.monthrange(year, month)[1]
    )

    return datetime.date(year, month, day)

# =========================================================
# TARGET MONTHS
# =========================================================

def get_target_months():

    if AUTO_MODE:

        currentdate = datetime.date.today()

        now = pd.to_datetime(
            str(currentdate),
            format='%Y-%m-%d'
        )

        months = []

        for i in range(1, N_MONTHS_BACK + 1):

            date = add_months(now, -i)

            months.append(
                (date.year, date.month)
            )

        return months

    return MANUAL_MONTHS

# =========================================================
# DOWNLOAD FILE
# =========================================================

def download_update_file():

    url = f"{BASE_URL}{UPDATE_FILE}"

    outpath = os.path.join(
        DOWNLOAD_DIR,
        UPDATE_FILE
    )

    logger.info(f"Downloading: {url}")

    r = requests.get(
        url,
        allow_redirects=True,
        timeout=300
    )

    r.raise_for_status()

    with open(outpath, 'wb') as f:
        f.write(r.content)

    return outpath

# =========================================================
# EXTRACT TAR
# =========================================================

def extract_tar(tar_path):

    extract_path = os.path.join(
        EXTRACT_DIR,
        "gsom_latest"
    )

    os.makedirs(extract_path, exist_ok=True)

    logger.info(f"Extracting: {tar_path}")

    with tarfile.open(tar_path) as tf:

        for member in tf.getmembers():

            member_path = os.path.join(
                extract_path,
                member.name
            )

            abs_extract = os.path.abspath(extract_path)
            abs_member = os.path.abspath(member_path)

            if not abs_member.startswith(abs_extract):
                raise Exception("Unsafe tar file")

        tf.extractall(
            path=extract_path,
            filter="data"
        )

    return extract_path

# =========================================================
# FIND CSV FILES
# =========================================================

def find_station_files(root_dir):

    files = glob.glob(
        os.path.join(root_dir, "**", "*.csv"),
        recursive=True
    )

    return sorted(files)

# =========================================================
# CONVERT TO KELVIN
# =========================================================

def convert_to_kelvin(df):

    df["observation_value"] = pd.to_numeric(
        df["observation_value"],
        errors='coerce'
    )

    df["observation_value"] = (
        df["observation_value"] + 273.15
    )

    df["observation_value"] = (
        df["observation_value"].round(2)
    )

    return df

# =========================================================
# APPLY SCHEMA
# =========================================================

def apply_schema(df):

    df = df.copy()

    df["report_timestamp"] = pd.to_datetime(
        df["report_timestamp"],
        errors="coerce",
        utc=True
    )

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

        except Exception:

            logger.exception(
                f"Schema conversion failed "
                f"for column: {col}"
            )

    return df

def process_variable(df, variable):

    if variable not in df.columns:

        return pd.DataFrame()

    # -----------------------------------------------------
    # CREATE OUTPUT DF
    # -----------------------------------------------------

    out = pd.DataFrame(index=df.index)

    out["station_name"] = df["NAME"]

    out["primary_station_id"] = (
        df["STATION"]
        .astype(str)
        .str.replace('.0', '', regex=False)
        .str.strip()
        .str.upper()
    )

    # -----------------------------------------------------
    # KEEP ONLY STATIONS IN DATA POLICY TABLE
    # -----------------------------------------------------

    valid_station_ids = set(
        DATA_POLICY_DF["station_id"]
        .astype(str)
        .str.strip()
        .str.upper()
    )

    out = out[
        out["primary_station_id"]
        .isin(valid_station_ids)
    ].copy()

    if len(out) == 0:

        return pd.DataFrame()

    # -----------------------------------------------------
    # METADATA
    # -----------------------------------------------------

    out["longitude"] = pd.to_numeric(
        df.loc[out.index, "LONGITUDE"],
        errors="coerce"
    ).round(3)

    out["latitude"] = pd.to_numeric(
        df.loc[out.index, "LATITUDE"],
        errors="coerce"
    ).round(3)

    out[
        "height_of_station_above_sea_level"
    ] = pd.to_numeric(
        df.loc[out.index, "ELEVATION"],
        errors="coerce"
    )

    # -----------------------------------------------------
    # TIMESTAMP
    # -----------------------------------------------------

    out["report_timestamp"] = pd.to_datetime(
        df.loc[out.index, "DATE_DT"],
        utc=True,
        errors="coerce"
    )

    out = out[
        out["report_timestamp"].notna()
    ].copy()

    if len(out) == 0:

        return pd.DataFrame()

    out["date"] = (
        out["report_timestamp"]
        .dt.strftime("%Y-%m-%d")
    )

    # -----------------------------------------------------
    # FIXED METADATA
    # -----------------------------------------------------

    out["report_meaning_of_time_stamp"] = "1"

    out["report_duration"] = "14"

    out["observed_variable"] = str(
        VARIABLE_ID[variable]
    )

    out["units"] = str(
        UNITS[variable]
    )

    out["quality_flag"] = "0"

    out["data_policy_licence"] = "0"

    out["report_type"] = "2"

    out["value_significance"] = str(
        VALUE_SIGNIFICANCE[variable]
    )

    # -----------------------------------------------------
    # OBSERVATION VALUES
    # -----------------------------------------------------

    out["observation_value"] = pd.to_numeric(
        df.loc[out.index, variable],
        errors="coerce"
    )

    out = out[
        out["observation_value"].notna()
    ].copy()

    if len(out) == 0:

        return pd.DataFrame()

    # -----------------------------------------------------
    # TEMPERATURE CONVERSION
    # -----------------------------------------------------

    if variable in [
        "TMIN",
        "TMAX",
        "TAVG"
    ]:

        out = convert_to_kelvin(out)

    # -----------------------------------------------------
    # WIND ROUNDING
    # -----------------------------------------------------

    if variable == "AWND":

        out["observation_value"] = (
            out["observation_value"]
            .round(2)
        )

    # -----------------------------------------------------
    # MERGE SOURCE IDS
    # -----------------------------------------------------

# -----------------------------------------------------
# MERGE SOURCE IDS + STANDARD STATION NAME
# -----------------------------------------------------

    out = out.merge(
    
        DATA_POLICY_DF[
            [
                "station_id",
                "source_id",
                "station_name"
            ]
        ],
    
        how="left",
    
        left_on="primary_station_id",
    
        right_on="station_id"
    
    )
    
    # overwrite GSOM station name
    # using controlled station metadata
    
    out["station_name"] = (
        out["station_name_y"]
        .fillna(out["station_name_x"])
    )
    
    out["source_id"] = (
        out["source_id"]
        .fillna("0")
        .astype(str)
    )
    
    out = out.drop(
        columns=[
            "station_id",
            "station_name_x",
            "station_name_y"
        ]
    )

    # -----------------------------------------------------
    # IDS
    # -----------------------------------------------------

    out["report_id"] = (

        out["primary_station_id"]

        + "-1-"

        + out["date"]

    )

    out["observation_id"] = (

        out["report_id"]

        + "-"

        + out["observed_variable"]

        + "-"

        + out["value_significance"]

    )

    # -----------------------------------------------------
    # FINAL COLUMNS
    # -----------------------------------------------------

    out = out[[

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

    return out


# =========================================================
# PROCESS STATION FILE
# =========================================================

def process_station_file(infile, target_months):

    logger.info(f"Processing: {infile}")

    try:

        df = pd.read_csv(
            infile,
            sep=",",
            usecols=lambda c: c in LITE_COLS,
            low_memory=False
        )

    except Exception:

        logger.exception(
            f"Could not read file: {infile}"
        )

        return pd.DataFrame()

    # -----------------------------------------------------
    # PARSE GSOM MONTHLY DATE
    # FORMAT = YYYY-MM
    # -----------------------------------------------------

    df["DATE"] = (
        df["DATE"]
        .astype(str)
        .str.strip()
    )

    df["DATE_DT"] = pd.to_datetime(
        df["DATE"],
        format="%Y-%m",
        errors="coerce"
    )

    # -----------------------------------------------------
    # DEBUG LOGGING
    # -----------------------------------------------------

    if df["DATE_DT"].notna().sum() == 0:
    
        return pd.DataFrame()

    # -----------------------------------------------------
    # FILTER TARGET MONTHS
    # -----------------------------------------------------

    keep_mask = pd.Series(
        False,
        index=df.index
    )

    for year, month in target_months:

        keep_mask |= (

            (df["DATE_DT"].dt.year == year) &

            (df["DATE_DT"].dt.month == month)

        )

    df = df[keep_mask]

    # =====================================================
    # CRITICAL FIX
    # =====================================================

    df = df.reset_index(drop=True)

    
    if len(df) == 0:

        del df

        gc.collect()

        return pd.DataFrame()

    # -----------------------------------------------------
    # PROCESS VARIABLES
    # -----------------------------------------------------

    outputs = []

    variables = [
        "PRCP",
        "TMIN",
        "TMAX",
        "TAVG",
        "SNOW",
        "AWND"
    ]

    for var in variables:

        try:

            out = process_variable(
                df,
                var
            )

            if len(out) > 0:

                outputs.append(out)

             
        except Exception:

            logger.exception(
                f"Failed variable: {var}"
            )

    # -----------------------------------------------------
    # NO OUTPUTS
    # -----------------------------------------------------

    if len(outputs) == 0:

        logger.warning(
            f"No valid variable outputs: {infile}"
        )

        del df

        gc.collect()

        return pd.DataFrame()

    # -----------------------------------------------------
    # CONCAT
    # -----------------------------------------------------

    final = pd.concat(
        outputs,
        ignore_index=True
    )


    del df
    del outputs

    gc.collect()

    return final

# =========================================================
# CLEANUP
# =========================================================

# =========================================================
# CLEANUP
# =========================================================

def cleanup_files(tar_path, extract_dir):

    def remove_readonly(func, path, _):

        try:

            os.chmod(path, stat.S_IWRITE)

            func(path)

        except Exception:

            logger.exception(
                f"Could not remove: {path}"
            )

    # -----------------------------------------------------
    # REMOVE TAR
    # -----------------------------------------------------

    if REMOVE_TAR_FILES:

        try:

            if os.path.exists(tar_path):

                os.remove(tar_path)

                logger.info(
                    f"Removed tar: {tar_path}"
                )

        except Exception:

            logger.exception(
                f"Could not remove tar: "
                f"{tar_path}"
            )

    # -----------------------------------------------------
    # REMOVE EXTRACTED DIRECTORY
    # -----------------------------------------------------

    if REMOVE_EXTRACTED_FOLDERS:

        if not os.path.exists(extract_dir):
            return

        # Release memory/file handles
        gc.collect()

        # Windows/Dropbox delay
        time.sleep(5)

        success = False

        for attempt in range(1, 6):

            try:

                shutil.rmtree(
                    extract_dir,
                    ignore_errors=False,
                    onerror=remove_readonly
                )

                logger.info(
                    f"Removed extracted: "
                    f"{extract_dir}"
                )

                success = True

                break

            except Exception:

                logger.exception(
                    f"Attempt {attempt}/5 failed "
                    f"removing extracted dir: "
                    f"{extract_dir}"
                )

                # Give Windows/Dropbox time
                time.sleep(5)

                gc.collect()

        if not success:

            logger.error(
                f"FAILED removing extracted dir "
                f"after retries: {extract_dir}"
            )
# =========================================================
# OUTPUT NAME
# =========================================================
def make_output_name(year, month):

    return (
        f"insitu-observations-surface-land_monthly_"
        f"{year}_{month:02d}.psv"
    )
#=============================================
# PIPELINE
# =========================================================

def run_pipeline():

    target_months = get_target_months()

    logger.info(
        f"Target months: {target_months}"
    )

    # Download once
    tar_path = download_update_file()

    extract_dir = extract_tar(tar_path)

    station_files = find_station_files(extract_dir)

    logger.info(
        f"Station files found: {len(station_files):,}"
    )

    logger.info(
        f"Using {min(80, cpu_count())} workers"
    )

    # Process one month at a time
    for year, month in target_months:

        logger.info(
            f"Processing {year}-{month:02d}"
        )

        tasks = [
            (infile, [(year, month)])
            for infile in station_files
        ]

        with Pool(processes=min(50, cpu_count())) as pool:

            results = pool.map(
                process_wrapper,
                tasks,
                chunksize=250
            )

        all_outputs = [

            df for df in results

            if len(df) > 0

        ]

        if len(all_outputs) == 0:

            logger.warning(
                f"No output data for {year}-{month:02d}"
            )

            continue

        # -----------------------------------------------------
        # CONCAT FINAL OUTPUT
        # -----------------------------------------------------
    
        final_df = pd.concat(
            all_outputs,
            ignore_index=True
        )
        del all_outputs
    
        gc.collect()
    
        final_df = final_df.drop_duplicates()
    
        final_df = final_df.sort_values(
            "report_timestamp"
        )
    
        final_df = final_df.reset_index(drop=True)
    
        final_df = apply_schema(final_df)
    
        base_name = make_output_name(year, month)
    
        psv_out = os.path.join(
            OUTPUT_DIR,
            f"{base_name}.psv"
        )
    
        pq_out = os.path.join(
            OUTPUT_DIR,
            f"{base_name}.pq"
        )
    
        if SAVE_PSV:
    
            final_df.to_csv(
                psv_out,
                sep="|",
                index=False
            )
    
            logger.info(
                f"Saved PSV: {psv_out}"
            )
    
        if SAVE_PARQUET:
    
            final_df.to_parquet(
                pq_out,
                index=False,
                engine="pyarrow"
            )
    
            logger.info(
                f"Saved Parquet: {pq_out}"
            )
    
        del final_df
    
        gc.collect()

    cleanup_files(
        tar_path,
        extract_dir
    )

    logger.info("DONE")

# =========================================================

if __name__ == "__main__":

    run_pipeline()