# -*- coding: utf-8 -*-
"""
Read CDM Lite files (one per station) and extract information
needed to build station configuration files

Examples on how to run
>python extract_station_config_info.py --station ZI000067983 --time H
>python extract_station_config_info_2.py --subset  --time H  ls_1
>python extract_station_config_info_2.py --run_all --time H
>python extract_station_config_info.py --help

Created on Thu Apr 28 11:47:32 2022

@author: rjhd2
"""

import os
import pandas as pd
import numpy as np
import utils

pd.options.mode.chained_assignment = None  # default='warn'


def main(station="", subset="", run_all=False, clobber=False, time=""):
    """
    Run extraction of station configuration file information

    Parameters
    ----------

    station : `str`
        Single station ID to process

    subset : `str`
        Path to file containing subset of IDs to process

    run_all : `bool`
        Run all files in the directory defined in the config file

    clobber : `bool`
        Overwrite existing files if they exist.  If False, will skip existing ones

    time : `str`
        Which data type to select - must be one of H-hourly, D-daily, M-monthly.
    """

    # set up the input and output file types
    if time not in ["H", "D", "M"]:
        # just in case
        return
    elif time == "H":
        extension = ".psv"
        compression = ".gz"
        indir = utils.SUBDAILY_CDM_LITE_OUT_DIR
        # inroot = utils.SUBDAILY_CDM_LITE_FILE_ROOT
        outname = f"{indir}/sub_daily_station_config2.dat"
    elif time == "D":
        extension = ".psv"
        compression = ".gz"
        indir = utils.DAILY_CDM_LITE_OUT_DIR
        # inroot = utils.DAILY_CDM_LITE_FILE_ROOT
        outname = f"{indir}/daily_station_config.dat"
    elif time == "M":
        extension = ".psv"
        compression = ".gz"
        indir = utils.MONTHLY_CDM_LITE_OUT_DIR
        # inroot = utils.MONTHLY_CDM_LITE_FILE_ROOT
        outname = f"{indir}/monthly_station_config.dat"


    # check if output files exist
    if not clobber:
        # all output files exist
        if os.path.exists(outname):
            print(f"   Output files for {time} already exist:")
            print(f"     {outname}")
            print("   exiting")
            return

    # Read in either single file, list of files or run all
    # Check for sensible inputs
    if station != "" and subset != "" and run_all:
        print("Please select either single station, list of stations run or to run all")
        return
    elif station == "" and subset == "" and not run_all:
        print("Please select either single station, list of stations run or to run all")
        return

    # Obtain list of station(s) to process (single/subset/all)
    all_filenames = utils.get_station_list_to_process(f"{indir}",
                                                      f"{extension}{compression}",
                                                      station=station,
                                                      subset=subset,
                                                      prepend="cdm_core_r8.0_",
                                                      run_all=run_all,
                                                      )

    # Prepend added 4th July 2023.  Rerun needed to fix time order issue in config files
    
    config_df = pd.DataFrame(columns=["primary_id",
                                      "record_id",
                                      "station_name",
                                      "start_year",
                                      "end_year",
                                      "observed_variables",
                                  ])


    for filename in all_filenames:
        if not os.path.exists(filename):
            print(f"Input {extension} file missing: {filename}")
            continue
        else:
            print(f"Processing {filename}")

        # Read in the dataframe
        try:
            df = pd.read_csv(filename, sep="|", low_memory=False, compression="infer")
        except Exception as e:
            print(f"Error reading file {filename}: {e}")
            continue

        if df.shape[0] == 0:
            print(f"No data in file: {filename}")
            continue
        
        # Resort by datetime (4 July 2023)
        df.sort_values("report_timestamp", inplace=True)

        primary_id = df['primary_station_id'].iloc[0]
        record_id = df['observation_id'].str[12] # 13th char of obs_id with python's zero indexing

        unique_record_ids = record_id.unique()

        # spin through each record id, and extract information
        for rec_id in unique_record_ids:

            locs, = np.where(record_id == rec_id)

            temp_df = df.iloc[locs]
            station_name = temp_df['station_name'].iloc[0]
            start_year = temp_df['report_timestamp'].str[:4].iloc[0]
            end_year = temp_df['report_timestamp'].str[:4].iloc[-1]
            observed_variables = list(temp_df['observed_variable'].unique())

            temp_out_df = pd.DataFrame([[primary_id,
                                         rec_id,
                                         station_name,
                                         start_year,
                                         end_year,
                                         observed_variables
                                     ]],
                                       columns=["primary_id",
                                                "record_id",
                                                "station_name",
                                                "start_year",
                                                "end_year",
                                                "observed_variables",
                                            ])

            config_df = pd.concat([config_df, temp_out_df], ignore_index=True)

    print("")
    config_df.to_csv(outname, index=False, sep="|", compression="infer")
    print(f"Written outfile: {outname}")

    return  #  main

#****************************************
if __name__ == "__main__":

    import argparse

    # set up keyword arguments
    parser = argparse.ArgumentParser()
    parser.add_argument('--station', dest='station', action='store', default="",
                        help='Root of station ID to run')
    parser.add_argument('--subset', dest='subset', action='store', default="",
                        help='File containing subsets of stations to run (full path only)')
    parser.add_argument('--run_all', dest='run_all', action='store_true', default=False,
                        help='Run all stations in QFF directory')
    parser.add_argument('--clobber', dest='clobber', action='store_true', default=False,
                        help='Overwrite existing files')
    parser.add_argument('--time', dest='time', action='store', default="",
                        help='Select which data resolution needed (H-hourly/D-daily/M-monthly)')

    args = parser.parse_args()

    if args.time not in ["H", "D", "M"]:
        print("Select which data resolution to be run on - H-hourly/D-daily/M-monthly")
    else:
        main(station=args.station,
             subset=args.subset,
             run_all=args.run_all,
             clobber=args.clobber,
             time=args.time,
        )