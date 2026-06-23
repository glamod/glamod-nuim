# -*- coding: utf-8 -*-
"""
Convert daily csv files to CDM Lite .psv files (one per station).

CDM Lite files have all variables, one after another.

Call in one of three ways using:

>python daily_to_cdm_core_v3.py --station STATIONID
>python daily_to_cdm_core_v3.py --subset FILENAME
>python daily_to_cdm_core_v3.py --run_all
>python daily_to_cdm_core_v3.py --help

Created on Thu Nov 11 16:31:58 2021

@author: snoone

Edited: rjhd2, February 2022
Edited snoone February 2026
"""

import os
import pandas as pd
import numpy as np
pd.options.mode.chained_assignment = None  # default='warn'
import utils
import daily_csv_to_cdm_utils as d_utils

# Set the file extension for the subdaily psv files
IN_EXTENSION = ".csv"
OUT_EXTENSION = ".psv"
COMPRESSION = ".gz"
ERROR_LOG = "log_error.txt"

def main(station="", subset="", run_all=False, clobber=False):
    """
    Run processing of daily csv to CDM lite & QC tables
    """
    if station != "" and subset != "" and run_all:
        print("Please select either single station, subset file, or run_all")
        return
    elif station == "" and subset == "" and not run_all:
        print("Please select either single station, subset file, or run_all")
        return

    all_filenames = utils.get_station_list_to_process(
        utils.DAILY_CSV_IN_DIR,
        f"{IN_EXTENSION}{COMPRESSION}",
        station=station,
        subset=subset,
        run_all=run_all,
    )

    data_policy_df = pd.read_csv(utils.DAILY_STATION_RECORD_ENTRIES_OBS_LITE, encoding='latin-1').astype(str)
    height_of_station_above_sea_level_df = pd.read_csv(utils.DAILY_STATION_RECORD_ENTRIES_OBS_LITE, encoding='latin-1').astype(str)

    # Clear previous error log
    if os.path.exists(ERROR_LOG):
        os.remove(ERROR_LOG)

    for filename in all_filenames:
        full_path = os.path.join(utils.DAILY_CSV_IN_DIR, filename)
        if not os.path.exists(full_path):
            print(f"Input {IN_EXTENSION} file missing: {filename}")
            continue
        print(f"Processing {filename}")

        df = pd.read_csv(full_path, sep=",", low_memory=False, compression='infer', header=None)
        df.columns = ["Station_ID", "Date", "observed_variable", "observation_value",
                      "Measurement_flag", "quality_flag", "Source_flag", "hour"]
        df = df.astype(str)

        station_id = df.iloc[0]["Station_ID"]
        outroot_cdmlite = os.path.join(utils.DAILY_CDM_LITE_OUT_DIR, utils.DAILY_CDM_LITE_FILE_ROOT)
        cdmlite_outfile = f"{outroot_cdmlite}{station_id}{OUT_EXTENSION}{COMPRESSION}"
        outroot_qc = os.path.join(utils.DAILY_CDM_QC_OUT_DIR, utils.DAILY_QC_FILE_ROOT)
        qc_outfile = f"{outroot_qc}{station_id}{OUT_EXTENSION}{COMPRESSION}"

        if not clobber and os.path.exists(cdmlite_outfile) and os.path.exists(qc_outfile):
            print(f"   Output files for {filename} already exist, skipping")
            continue

        # --- Filter to allowed variables first ---
        df = df[df["observed_variable"].isin(d_utils.VARIABLE_NAMES)]

        # --- Strict Source_flag mapping ---
        df['Source_flag'] = df['Source_flag'].astype(str).str.strip()  # preserve case
        unmapped_flags = df[~df['Source_flag'].isin(d_utils.SOURCE_FLAGS.keys())]

        if not unmapped_flags.empty:
            with open(ERROR_LOG, "a") as log:
                for idx, row in unmapped_flags.iterrows():
                    log.write(
                        f"{filename}, row {idx}, Station_ID={row['Station_ID']}, Date={row['Date']}, Source_flag='{row['Source_flag']}'\n"
                    )
            # Remove rows with invalid flags
            df = df[df['Source_flag'].isin(d_utils.SOURCE_FLAGS.keys())]

        # Map valid flags
        df['Source_flag'] = df['Source_flag'].map(d_utils.SOURCE_FLAGS)
        df['source_id'] = df['Source_flag']

        # --- Add value significance ---
        df["value_significance"] = ""
        for obs_var, val_signif in d_utils.VALUE_SIGNIFICANCE.items():
            df.loc[df['observed_variable'] == obs_var, 'value_significance'] = val_signif

        # --- Convert observation values ---
        df["observation_value"] = pd.to_numeric(df["observation_value"], errors='coerce')
        for var_name in d_utils.VARIABLE_NAMES:
            df = d_utils.convert_values(df, var_name, "observation_value", kelvin=True)

        # --- Assign units ---
        df["units"] = ""
        for obs_var, unit in d_utils.UNITS.items():
            df.loc[df['observed_variable'] == obs_var, 'units'] = unit

        # --- Map variable IDs ---
        for obs_var, var_id in d_utils.VARIABLE_ID.items():
            df['observed_variable'] = df['observed_variable'].str.replace(obs_var, var_id)

        # --- Date splitting ---
        df['year'] = df['Date'].str[:4]
        df['month'] = df['Date'].str[4:6]
        df['day'] = df['Date'].str[6:8]

        # --- Standard columns ---
        df["hour"] = "00"
        df["Minute"] = "00"
        df["report_type"] = "3"
        df["report_meaning_of_time_stamp"] = "1"
        df["report_duration"] = "13"
        df["observation_id"] = ""
        df["data_policy_licence"] = ""
        df["primary_station_id"] = df["Station_ID"]
        df["qc_method"] = df["quality_flag"].astype(str)
        df["quality_flag"] = df["quality_flag"].astype(str)
        df["height_of_station_above_sea_level"] = ""

        # --- Quality flag replacements ---
        df.loc[df.quality_flag == "nan", "quality_flag"] = "0"
        for flag, new_flag in d_utils.QUALITY_FLAGS.items():
            df["quality_flag"] = df["quality_flag"].str.replace(flag, new_flag)

        # --- Timestamp ---
        df["Timestamp2"] = df["year"] + "-" + df["month"] + "-" + df["day"]
        df["Seconds"] = "00"
        df["offset"] = "+00"
        df["report_timestamp"] = df["Timestamp2"] + " " + df["hour"] + ":" + df["Minute"] + ":" + df["Seconds"] + "+00"
        df["report_id_a"] = df["report_timestamp"]

        df = df.astype(str)
        df['source_id'] = df['source_id'].apply(lambda x: x.replace('.0', ''))
        df['primary_station_id_2'] = df['primary_station_id'] + '-' + df['source_id']

        df = d_utils.add_data_policy(df, data_policy_df)

        # --- Fill missing ---
        df = df.fillna("").replace({"null": ""})
        df["latitude"] = pd.to_numeric(df.get("latitude", pd.Series()), errors='coerce').round(3)
        df["longitude"] = pd.to_numeric(df.get("longitude", pd.Series()), errors='coerce').round(3)

        # --- Observation IDs ---
        df["dates"] = df["report_id_a"].str[:-11].str.rstrip()
        df['observation_id'] = df['primary_station_id'] + '-' + df['record_number'].astype(str) + '-' + df['dates']
        df['observation_id'] = df['observation_id'].str.replace(r' ', '-', regex=True) + '-' + df['observed_variable'] + '-' + df['value_significance']
        df["report_id"] = df['primary_station_id'] + '-' + df['record_number'].astype(str) + '-' + df['dates']

                # --- QC table ---
        qct = df[[
            "report_id",
            "observation_id",
            "qc_method",
            "quality_flag"
        ]].copy()
        
        # --- QC method replacements (KEPT AS REQUESTED) ---
        for qc_method, qc_code in d_utils.QC_METHODS.items():
            qct["qc_method"] = qct["qc_method"].str.replace(qc_method, qc_code, regex=False)
        
        qct = qct[qct.qc_method.notnull() & (qct.qc_method != "")]
        
        # --- quality flag formatting ---
        qct["quality_flag"] = (
            pd.to_numeric(qct["quality_flag"], errors="coerce")
            .fillna(0)
            .astype(int)
        )

        # --- Final output columns ---
        df = df[["station_name","primary_station_id","report_id","observation_id",
                 "longitude","latitude","height_of_station_above_sea_level",
                 "report_timestamp","report_meaning_of_time_stamp","report_duration",
                 "observed_variable","units","observation_value","quality_flag",
                 "source_id","data_policy_licence","report_type","value_significance"]]

        # --- Sort & save ---
        df["date_time"] = pd.to_datetime(df["report_timestamp"], errors='coerce')
        try:
            if len(df) > 0:
                print("Variables in this file:", df['observed_variable'].unique())
                df.sort_values("date_time", inplace=True)
                df.drop(columns=["date_time"], inplace=True)

                # --- Save CDM Lite PSV ---
                df.to_csv(cdmlite_outfile, index=False, sep="|", compression="infer")
                print(f"Saved CDM Lite: {cdmlite_outfile}")
            else:
                print(f"No data to save for {filename}")

            if len(qct) > 0:
                qct.sort_values("report_id", inplace=True)
                qct.to_csv(qc_outfile, index=False, sep="|", compression="infer")
                print(f"Saved QC table: {qc_outfile}")
            else:
                print(f"No QC data to save for {filename}")

        except IOError:
            print(f"Cannot save datafile: {cdmlite_outfile}")
        except RuntimeError:
            print("Runtime error")

if __name__ == "__main__":

    import argparse

    parser = argparse.ArgumentParser()
    parser.add_argument('--station', dest='station', action='store', default="",
                        help='Root of station ID to run')
    parser.add_argument('--subset', dest='subset', action='store', default="",
                        help='File containing subsets of stations to run (full path only)')
    parser.add_argument('--run_all', dest='run_all', action='store_true', default=False,
                        help='Run all stations in QFF directory')
    parser.add_argument('--clobber', dest='clobber', action='store_true', default=False,
                        help='Overwrite existing files')

    args = parser.parse_args()

    main(station=args.station, subset=args.subset, run_all=args.run_all, clobber=args.clobber)
