# -*- coding: utf-8 -*-
"""
Convert QFF files to CDM Core .psv files (one per station).

CDM Core files have all variables, one after another.

Call in one of three ways using:

>python hourly_qff_to_cdm_core_v2.py --station STATIONID
>python hourly_qff_to_cdm_core_v2.py --subset FILENAME
>python hourly_qff_to_cdm_core_v2.py --run_all
>python hourly_qff_to_cdm_core_v2.py --help

Created on Thu Nov 11 16:31:58 2021

@author: snoone

Edited: rjhd2, February 2022
Edited: rjhd2, November 2024
"""

import os
import glob
import pandas as pd
import numpy as np
pd.options.mode.chained_assignment = None  # default='warn'
import utils
import hourly_qff_to_cdm_utils as h_utils

# Set the file extension for the subdaily psv files
IN_EXTENSION = ".qff"
OUT_EXTENSION = ".psv"
IN_COMPRESSION = ".gz"
OUT_COMPRESSION = ".gz"

# Dictionaries to hold CDM codes.  In due course, read directly from those docs
INITIAL_COLUMNS = ["observation_id","report_type","date_time","date_time_meaning",
                   "latitude","longitude","observation_height_above_station_surface",
                   "observed_variable","units","observation_value",
                   "value_significance","observation_duration","platform_type",
                   "station_type","primary_station_id","station_name","quality_flag",
                   "data_policy_licence","source_id","secondary_id",]

INTERMED_COLUMNS = ["observation_id","record_number","report_type","date_time","date_time_meaning",
                    "latitude","longitude","observation_height_above_station_surface",
                    "observed_variable","units","observation_value",
                    "value_significance","observation_duration","platform_type",
                    "station_type","primary_station_id","station_name","quality_flag",
                    "data_policy_licence","source_id","report_id","qc_method",]

FINAL_COLUMNS = ["observation_id","report_type","date_time","date_time_meaning",
                 "latitude","longitude","observation_height_above_station_surface",
                 "observed_variable","units","observation_value",
                 "value_significance","observation_duration","platform_type",
                 "station_type","primary_station_id","station_name","quality_flag",
                 "data_policy_licence","source_id",]


SUB_DAILY_QC_FLAGS = {
    "L" : "0,",  # Logical
    "o" : "1,",  # outlier
    "F" : "2,",  # Frequent
    "U" : "3,",  # diUrnal
    "D" : "4,",  # Distribution 1
    "d" : "5,",  # distribution 2
    "W" : "6,",  # World Records
    "K" : "7,",  # Streak
    "C" : "8,",  # Climatological
    "T" : "9,",  # Timestamp
    "S" : "10,",  # Spike
    "h" : "11,",  # humidity
    "V" : "12,",  # Variance
    "w" : "13,",  # winds
    "N" : "14,",  # Neighbour
    "E" : "15,",  # clEan up
    "p" : "16,",  # pressure
    "H" : "17,",  # High flag rate
}

def construct_report_type(var_frame, all_frame, id_field):
    """
    Construct the `report_type` field from station name information

    var_frame : `dataframe`
        Dataframe for variable

    all_frame : `dataframe`
        Dataframe for station

    id_field : `str`
        Field to use to construct report_type
    """

    var_frame["report_type"] = all_frame[id_field]

    # convert all missings to NULL
    var_frame["report_type"] = var_frame["report_type"].fillna("NULL")
    # extract first four characters
    try:
        var_frame["report_type"] = var_frame["report_type"].str[:4].astype('str')
        # retain those matching "ICAO" and replace with "0" otherwise
        var_frame["report_type"] = np.where(var_frame["report_type"].isin(["ICAO"]), var_frame["report_type"] ,"0")
        # replace all ICAO with "4"
        var_frame["report_type"] = var_frame["report_type"].replace({'ICAO':'4',})
    except AttributeError:
        # if Station ID is numbers only (misformed)
        var_frame["report_type"] = '0'

    return var_frame



def construct_qc_df(var_frame):
    """
    Construct data frame for CDM-Core QC table

    var_frame : `dataframe`
        Dataframe for variable
    """

    # Set up QC table
    qc_frame = var_frame[["primary_station_id",
                          "report_id",
                          "record_number",
                          "qc_method",
                          "quality_flag",
                          "observed_variable",
                          "value_significance",
                      ]]

    # QC observation_id not the same as for var_frame
    qc_frame["observation_id"] = qc_frame["primary_station_id"] + "-" + \
                                 qc_frame["record_number"] + "-" + \
                                 qc_frame["report_id"] + "-" + \
                                 qc_frame['observed_variable'].astype(str) + "-" + \
                                 qc_frame['value_significance'].astype(str)

    # create report_id
    qc_frame["report_id"] = qc_frame["primary_station_id"] + "-" + \
                            qc_frame["report_id"]
    qc_frame['report_id'] = qc_frame['report_id'].str[:-6]

    # restrict to required columns
    qc_frame = qc_frame[["report_id","observation_id","qc_method","quality_flag"]]

    # final changes
    qc_frame["quality_flag"] = pd.to_numeric(qc_frame["quality_flag"], errors='coerce')
    qc_frame = qc_frame.fillna("Null")
    qc_frame = qc_frame[qc_frame['quality_flag'] != 0]

    return qc_frame


def extract_report_id(obs_id):
    """
    Function to split observation id and return a new report id

    obs_id : `str`
        String to parse

    returns : `str`
    """

    parts = obs_id.split('-')
    report_id = '-'.join(parts[:-2])
    return report_id


def main(station="", subset="", run_all=False, clobber=False):
    """
    Run processing of hourly QFF to CDM Core & QC tables

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
    """
    # Read in either single file, list of files or run all

    # Check for sensible inputs
    if station != "" and subset != "" and all:
        print("Please select either single station, list of stations run or to run all")
        return
    elif station == "" and subset == "" and not all:
        print("Please select either single station, list of stations run or to run all")
        return

    # Obtain list of station(s) to process (single/subset/all)
    all_filenames = utils.get_station_list_to_process(utils.SUBDAILY_QFF_IN_DIR,
                                                      f"{IN_EXTENSION}{IN_COMPRESSION}",
                                                      station=station,
                                                      subset=subset,
                                                      run_all=run_all,
                                                      )


    # Read in the data policy dataframe (only read in if needed)
    data_policy_df = pd.read_csv(utils.SUBDAILY_STATION_RECORD_ENTRIES_OBS_CORE, encoding='latin-1')
    data_policy_df = data_policy_df.astype(str)


    # Read in the location dataframe (only read in if needed - Rel 7 fix)
    location_df = pd.read_csv(utils.SUBDAILY_STATION_RECORD_ENTRIES_LOCATION, encoding='latin-1')
    location_df = location_df.astype(str)

   # To start at begining of files
    for filename in all_filenames:

        if not os.path.exists(filename):
            print("Input {} file missing: {}".format(IN_EXTENSION, filename))
            # For logging, useful to know if there's a reason why its missing
            temp_id = filename.split("/")[-1]
            if os.path.exists(os.path.join(utils.SUBDAILY_QFF_IN_DIR, "bad_stations", temp_id)):
                print("    Withheld station due to high flagging.")
            continue
        else:
            print("Processing {}".format(filename))

        # Read in the dataframe
        df=pd.read_csv(filename, sep="|", low_memory=False, compression="infer")

        if df.shape[0] == 0:
            print(f"No data in file: {filename}")
            continue

        # Set up the output filenames, and check if they exist
        station_id=df.iloc[0]["STATION"] # NOTE: this is renamed below to "primary_station_id"

        outroot_cdmcore = os.path.join(utils.SUBDAILY_CDM_CORE_OUT_DIR, utils.SUBDAILY_CDM_CORE_FILE_ROOT)
        cdmcore_outfile = f"{outroot_cdmcore}{station_id}{OUT_EXTENSION}{OUT_COMPRESSION}"

        outroot_qc= os.path.join(utils.SUBDAILY_CDM_QC_OUT_DIR, utils.SUBDAILY_QC_FILE_ROOT)
        qc_outfile = f"{outroot_qc}{station_id}{OUT_EXTENSION}{OUT_COMPRESSION}"

        # if not overwriting
        if not clobber:
            # and both output files exist
            if os.path.exists(cdmcore_outfile) and os.path.exists(qc_outfile):
                print(f"   Output files for {filename} already exist:")
                print(f"     {cdmcore_outfile}")
                print(f"     {qc_outfile}")
                print("   Skipping to next station")
                continue
            #  to next file in the loop

        # Set up master dataframe to extract each variable
        #  Globally set some entries to
        df["report_type"] = "0"
        df["units"] = ""
        df["source_id"] = ""
        df["observation_height_above_station_surface"] = ""
        df["height_of_station_above_sea_level"]=""
        df["date_time_meaning"] = "1"
        df["latitude"] = ""
        df["longitude"] = ""
        df["observed_variable"] = ""
        df["value_significance"] = ""
        df["observation_duration"] = ""
        df["observation_value"] = ""
        df["platform_type"] = ""
        df["station_type"] = "1"
        df["observation_id"] = ""
        df["data_policy_licence"] = ""
        df["primary_station_id"] = df["STATION"]
        df["secondary_id"] = ""                                  
        df["station_name"] = df["Station_name"]
        df["quality_flag"] = ""
        df["latitude"] = pd.to_numeric(df["LATITUDE"], errors='coerce')
        df["longitude"] = pd.to_numeric(df["LONGITUDE"], errors='coerce')
        df["latitude"] = df["latitude"].round(3)
        df["longitude"]=  df["longitude"].round(3)
        df["Timestamp2"] = df["Year"].map(str) + "-" +\
                           df["Month"].map("{:02.0f}".format) + "-" +\
                           df["Day"].map("{:02.0f}".format)
        df["Seconds"] = "00"
        df["offset"] = "+00"
        df["date_time"] = df["Timestamp2"].map(str) + " " +\
                          df["Hour"].map("{:02.0f}".format) + ":" + \
                          df["Minute"].map("{:02.0f}".format) + ":" + \
                          df["Seconds"].map(str)
        df['date_time'] =  pd.to_datetime(df['date_time'], format="%Y-%m-%d %H:%M:%S")
        df['date_time'] = df['date_time'].dt.strftime("%Y-%m-%d %H:%M:%S")
        df.date_time = df.date_time + '+00'

        # =========================================================================================
        # Convert temperature [fields used change for each variable]
        dft = df[INITIAL_COLUMNS]

        # set report type to 4 for ICAO or 0 for all other hourly stations
        dft = construct_report_type(dft, df, "temperature_Source_Station_ID")

        # Change for each variable to convert to CDM compliant values
        dft["observation_value"] = df["temperature"] + 273.15
        dft = h_utils.construct_extra_ids(dft, df, "temperature")

        # Extract QC information for QC tables
        dft = h_utils.extract_qc_info(dft, df, "temperature", do_report_id=True)

        # Change for each variable if required
        dft = h_utils.overwrite_variable_info(dft, "temperature")

        # Remove unwanted missing data rows
        dft = h_utils.remove_missing_data_rows(dft, "temperature")

        # Concatenate columns for joining dataframe in next step
        dft['source_id'] = dft['source_id'].astype(str).apply(lambda x: x.replace('.0', ''))
        dft['primary_station_id_2'] = dft['secondary_id'].astype(str) + '-' + \
                                      dft['source_id'].astype(str)
        dft["observation_value"] = pd.to_numeric(dft["observation_value"], errors='coerce')

        # Add data policy and record number to dataframe
        dft = h_utils.add_data_policy(dft, data_policy_df)

        # Restrict to required columns
        dft = dft[INTERMED_COLUMNS]

        # Create observation_id field
        dft = h_utils.construct_obs_id(dft)

        # Set up QC table
        qct = construct_qc_df(dft)

        # Restrict to required columns
        dft = dft[FINAL_COLUMNS]

        # Ensure correct number of decimal places
        dft = h_utils.fix_decimal_places(dft)


        # =================================================================================
        # Convert dew point temperature
        dfdpt = df[INITIAL_COLUMNS]

        # set report type to 4 for ICAO or 0 for all other hourly stations
        dfdpt = construct_report_type(dfdpt, df, "dew_point_temperature_Source_Station_ID")

        # Change for each variable to convert to CDM compliant values
        dfdpt["observation_value"] = df["dew_point_temperature"] + 273.15
        dfdpt = h_utils.construct_extra_ids(dfdpt, df, "dew_point_temperature")

        # Extract QC information for QC tables
        dfdpt = h_utils.extract_qc_info(dfdpt, df, "dew_point_temperature", do_report_id=True)

        # Change for each variable if required
        dfdpt = h_utils.overwrite_variable_info(dfdpt, "dew_point_temperature")

        # Remove unwanted mising data rows
        dfdpt = h_utils.remove_missing_data_rows(dfdpt, "dew_point_temperature")

        # Concatenate columns for joining dataframe for next step
        dfdpt['source_id'] = dfdpt['source_id'].astype(str).apply(lambda x: x.replace('.0', ''))
        dfdpt['primary_station_id_2'] = dfdpt['secondary_id'].astype(str) + '-' + \
                                        dfdpt['source_id'].astype(str)
        dfdpt["observation_value"] = pd.to_numeric(dfdpt["observation_value"],errors='coerce')

        # Add data policy and record numbers to dataframe
        dfdpt = h_utils.add_data_policy(dfdpt, data_policy_df)

        # Restrict to required columns
        dfdpt = dfdpt[INTERMED_COLUMNS]

        # Create observation_id field
        dfdpt = h_utils.construct_obs_id(dfdpt)

        # Set up QC table
        qcdpt = construct_qc_df(dfdpt)

        # Restrict to required columns
        dfdpt = dfdpt[FINAL_COLUMNS]

        # Ensure correct number of decimal places
        dfdpt = h_utils.fix_decimal_places(dfdpt)

        #====================================================================================
        # Convert station level pressure  to cdmcore
        dfslp = df[INITIAL_COLUMNS]

        # set report type to 4 for ICAO or 0 for all other hourly stations
        dfslp = construct_report_type(dfslp, df, "station_level_pressure_Source_Station_ID")

        # Change for each variable to convert to CDM compliant values
        dfslp["observation_value"] = df["station_level_pressure"]
        dfslp = h_utils.construct_extra_ids(dfslp, df, "station_level_pressure")

        # Extract QC information for QC tables
        dfslp = h_utils.extract_qc_info(dfslp, df, "station_level_pressure", do_report_id=True)

        # Change for each variable if required
        dfslp = h_utils.overwrite_variable_info(dfslp, "station_level_pressure")

        # Remove unwanted missing data rows
        dfslp = h_utils.remove_missing_data_rows(dfslp, "station_level_pressure")

        # Concatenate columns for joining dataframe for next step
        dfslp['source_id'] = dfslp['source_id'].astype(str).apply(lambda x: x.replace('.0', ''))
        dfslp['primary_station_id_2'] = dfslp['secondary_id'].astype(str) + '-' + \
                                        dfslp['source_id'].astype(str)

        # Add data policy and record numbers to dataframe
        dfslp = h_utils.add_data_policy(dfslp, data_policy_df)

        # Restrict to required columns
        dfslp = dfslp[INTERMED_COLUMNS]

        # Create observation_id field
        dfslp = h_utils.construct_obs_id(dfslp)

        # Set up QC table
        qcslp = construct_qc_df(dfslp)

        # Restrict to required columns
        dfslp = dfslp[FINAL_COLUMNS]
        dfslp = dfslp[dfslp.observation_value != "Null"]

      
         # Make sure no decimal places and round value to required number of decimal places
        dfslp['observation_value'] = (dfslp['observation_value'].astype(float) * 100).round(0).astype(int)


        dfslp['observation_value'] = pd.to_numeric(dfslp['observation_value'], errors='coerce') \
                              .mul(100) \
                              .round(0) \
                              .astype('Int64') \
                              .astype(str)

        dfslp = h_utils.fix_decimal_places(dfslp, do_obs_value=False)


        #===========================================================================================
        # Convert sea level pressure to CDM Core
        dfmslp = df[INITIAL_COLUMNS]

        # set report type to 4 for ICAO or 0 for all other hourly stations
        dfmslp = construct_report_type(dfmslp, df, "sea_level_pressure_Source_Station_ID")

        # Change for each variable to convert to CDM compliant values
        dfmslp["observation_value"] = df["sea_level_pressure"]
        dfmslp = h_utils.construct_extra_ids(dfmslp, df, "sea_level_pressure")

        # Extract QC information for QC tables
        dfmslp = h_utils.extract_qc_info(dfmslp, df, "sea_level_pressure", do_report_id=True)

        # Change for each variable if required
        dfmslp = h_utils.overwrite_variable_info(dfmslp, "sea_level_pressure")

        # Remove unwanted missing data rows
        dfmslp = h_utils.remove_missing_data_rows(dfmslp, "sea_level_pressure")

        # Concatenate columns for joining dataframe for next step
        dfmslp['source_id'] = dfmslp['source_id'].astype(str).apply(lambda x: x.replace('.0', ''))
        dfmslp['primary_station_id_2'] = dfmslp['secondary_id'].astype(str) + '-' + \
                                         dfmslp['source_id'].astype(str)

        # Add data policy and record numbers to dataframe
        dfmslp = h_utils.add_data_policy(dfmslp, data_policy_df)

        # Restrict to required columns
        dfmslp = dfmslp[INTERMED_COLUMNS]

        # Create observation_id field
        dfmslp = h_utils.construct_obs_id(dfmslp)

        # Set up QC table
        qcmslp = construct_qc_df(dfmslp)

        # Restrict to required columns
        dfmslp = dfmslp[FINAL_COLUMNS]
        dfmslp = dfmslp[dfmslp.observation_value != "Null"]

        # Make sure no decimal places and round value to required number of decimal places
        dfmslp['observation_value'] = (dfmslp['observation_value'].astype(float) * 100).round(0).astype(int)

        dfmslp['observation_value'] = pd.to_numeric(dfmslp['observation_value'], errors='coerce') \
                              .mul(100) \
                              .round(0) \
                              .astype('Int64') \
                              .astype(str)

        dfmslp = h_utils.fix_decimal_places(dfmslp, do_obs_value=False)

        #===================================================================================
        # Convert wind direction to CDM Core
        dfwd = df[INITIAL_COLUMNS]

        # set report type to 4 for ICAO or 0 for all other hourly stations
        dfwd = construct_report_type(dfwd, df, "wind_direction_Source_Station_ID")

        # Change for each variable to convert to CDM compliant values
        dfwd["observation_value"] = df["wind_direction"]
        dfwd["measurement_code"] = df["wind_direction_Measurement_Code"]
        dfwd = h_utils.construct_extra_ids(dfwd, df, "wind_direction")

        # Mask wind_direction_Measurement_Code to retain only specified data
        dfwd = h_utils.apply_wind_measurement_codes(dfwd, ["", "N-Normal", "C-Calm", "V-Variable", "9-Missing"])

        # Extract QC information for QC tables
        dfwd = h_utils.extract_qc_info(dfwd, df, "wind_direction", do_report_id=True)

        # Change for each variable if required
        dfwd = h_utils.overwrite_variable_info(dfwd, "wind_direction")

        # Remove unwanted missing data rows
        dfwd = h_utils.remove_missing_data_rows(dfwd, "wind_direction")

        # Concatenate columns for joining dataframe for next step
        dfwd['source_id'] = dfwd['source_id'].astype(str).apply(lambda x: x.replace('.0', ''))
        dfwd['primary_station_id_2'] = dfwd['secondary_id'].astype(str) + '-' + \
                                       dfwd['source_id'].astype(str)

        # Add data policy and record numbers to datframe
        dfwd = h_utils.add_data_policy(dfwd, data_policy_df)
        # Restrict to required columns
        dfwd = dfwd[INTERMED_COLUMNS]

        # Create observation_id field
        dfwd = h_utils.construct_obs_id(dfwd)

        # Set up QC table
        qcwd = construct_qc_df(dfwd)

        # Restrict to required columns
        dfwd = dfwd[FINAL_COLUMNS]

        # Make sure no decimal places and round value to required number of decimal places
        dfwd['observation_value'] = dfwd['observation_value'].astype(str).apply(lambda x: x.replace('.0', ''))

        dfwd['observation_value'] = pd.to_numeric(dfwd['observation_value'], errors='coerce') \
                             .round(0) \
                             .astype('Int64') \
                             .astype(str)

        dfwd = h_utils.fix_decimal_places(dfwd, do_obs_value=False)

        #===========================================================================
        # Convert wind speed to CDM Core
        dfws = df[INITIAL_COLUMNS]

        # set report type to 4 for ICAO or 0 for all other hourly stations
        dfws = construct_report_type(dfws, df, "wind_speed_Source_Station_ID")

        # Change for each variable to convert to CDM compliant values
        dfws["observation_value"] = df["wind_speed"]
        dfws["measurement_code"] = df["wind_speed_Measurement_Code"]
        dfws = h_utils.construct_extra_ids(dfws, df, "wind_speed")

        # Mask wind_speed_Measurement_Code to retain only specified data
        dfws = h_utils.apply_wind_measurement_codes(dfws, ["", "N-Normal", "C-Calm", "V-Variable", "9-Missing"])

        # Extract QC information for QC tables
        dfws = h_utils.extract_qc_info(dfws, df, "wind_speed", do_report_id=True)

        # Change for each variable if required
        dfws = h_utils.overwrite_variable_info(dfws, "wind_speed")

        # Remove unwanted missing data rows
        dfws = h_utils.remove_missing_data_rows(dfws, "wind_speed")

        # Concatenate columns for joining dataframe for next step
        dfws['source_id'] = dfws['source_id'].astype(str).apply(lambda x: x.replace('.0', ''))
        dfws['primary_station_id_2'] = dfws['secondary_id'].astype(str) + '-' + \
                                       dfws['source_id'].astype(str)
        #dfws["observation_value"] = pd.to_numeric(dfws["observation_value"],errors='coerce')
        #dft.to_csv("ttest.csv", index=False, sep=",")

        # Add data policy and record numbers to datafram
        dfws = h_utils.add_data_policy(dfws, data_policy_df)

        # Restrict to required columns
        dfws = dfws[INTERMED_COLUMNS]

        # Create observation_id field
        dfws = h_utils.construct_obs_id(dfws)

        # QC flag tables
        qcws = construct_qc_df(dfws)

        #station_id=dfws.iloc[1]["primary_station_id"]

        # Restrict to required columns
        dfws = dfws[FINAL_COLUMNS]

        # Ensure correct number of decimal places
        dfws = h_utils.fix_decimal_places(dfws)

        # =================================================================================
        # Merge all dataframes into one CDM Core frame
        merged_df=pd.concat([dfdpt,dft,dfslp,dfmslp,dfwd,dfws], axis=0)

        if merged_df.shape[0] == 0:
            print(f"No data in merged CDM Core file for: {filename}")
            continue


        # rename merged_df columns to cdm-core and create report_id
        merged_df["height_of_station_above_sea_level"] = df["height_of_station_above_sea_level"]
        merged_df["report_timestamp"] = merged_df["date_time"]
        merged_df["report_meaning_of_time_stamp"] = merged_df["date_time_meaning"]
        merged_df["report_duration"] = merged_df["observation_duration"]

        # Apply the function to create the new column report_id
        merged_df['report_id'] = merged_df['observation_id'].apply(extract_report_id)

        # Sort by date/times and fix metadata
        merged_df.sort_values("date_time", inplace=True)
        merged_df["latitude"] = pd.to_numeric(merged_df["latitude"],errors='coerce')
        merged_df["longitude"] = pd.to_numeric(merged_df["longitude"],errors='coerce')
        merged_df["latitude"]= merged_df["latitude"].round(3)
        merged_df["longitude"]= merged_df["longitude"].round(3)

        # and only retain columns in specified order
        merged_df = merged_df[["station_name","primary_station_id","report_id","observation_id",
                                 "longitude","latitude","height_of_station_above_sea_level","report_timestamp",
                                 "report_meaning_of_time_stamp","report_duration","observed_variable",
                                 "units","observation_value","quality_flag","source_id","data_policy_licence",
                                 "report_type","value_significance"]]

        # Release 7 only
        # add location information  from location.csv to overwrite
        merged_df = h_utils.add_location(merged_df, location_df)

        # This duplication from 10 lines above is apparently needed.
        merged_df = merged_df[["station_name","primary_station_id","report_id","observation_id",
                                 "longitude","latitude","height_of_station_above_sea_level","report_timestamp",
                                 "report_meaning_of_time_stamp","report_duration","observed_variable",
                                 "units","observation_value","quality_flag","source_id","data_policy_licence",
                                 "report_type","value_significance"]]

        # Convert the column to numeric first
        merged_df['height_of_station_above_sea_level'] = pd.to_numeric(merged_df['height_of_station_above_sea_level'])

        # Then round or convert to integers
        merged_df['height_of_station_above_sea_level'] = merged_df['height_of_station_above_sea_level'].round(0).astype(int)

        merged_df["latitude"] = pd.to_numeric(merged_df["latitude"],errors='coerce')
        merged_df["longitude"] = pd.to_numeric(merged_df["longitude"],errors='coerce')
        merged_df["latitude"]= merged_df["latitude"].round(3)
        merged_df["longitude"]= merged_df["longitude"].round(3)

        # Write the output files
        #   name the cdm_core files e.g. cdm_core _"insert date of run"_EG000062417.psv)
        try:
            # Save CDM core table to directory
            unique_variables = merged_df['observed_variable'].unique()
            print(unique_variables)
            merged_df.to_csv(cdmcore_outfile, index=False, sep="|", compression="infer")
            print(f"    {cdmcore_outfile}")

            # Extract subsets of variables
            #    E.g.: slp and mslp for 20cr Ed Hawkins
            if len(utils.EXTRACTION_VARIABLE_IDS) != 0:
                # Some variables set for extracction

                # Filter the DataFrame to keep rows where 'observed_variable' is either "57" or "58"
                filtered_df = merged_df[merged_df['observed_variable'].isin(utils.EXTRACTION_VARIABLE_IDS)]

                # Iterate over each unique 'primary_station_id' and save filtered rows to separate files
                for station_id, group_df in filtered_df.groupby('primary_station_id'):
                    # Define the output file path
                    file_path = f"{utils.EXTRACTION_FILE_PATH}/{station_id}_{utils.EXTRACTION_FILE_NAME}.psv"

                    # Save the group to a pipe-separated file
                    group_df.to_csv(file_path, sep='|', index=False, compression="infer")


            # Save QC table to directory
            qc_merged_df=pd.concat([qcdpt,qct,qcslp,qcmslp,qcwd,qcws], axis=0)
            qc_merged_df.astype(str)

            # Replace flag characters with numbers for CDM core
            for qc_flag, qc_value in SUB_DAILY_QC_FLAGS.items():
                qc_merged_df['qc_method'] = qc_merged_df['qc_method'].str.replace(qc_flag, qc_value)

            # Remove unwanted "," from column
            qc_merged_df['qc_method'] = qc_merged_df['qc_method'].str[:-1]
            qc_station_id=merged_df.iloc[0]["primary_station_id"]
            unique_qc_methods = qc_merged_df['qc_method'].unique()
            print(unique_qc_methods)
            qc_merged_df.to_csv(qc_outfile, index=False, sep="|", compression="infer")
            print(f"   {qc_outfile}")
            print("    Done")
        except IOError:
            # something wrong with file paths, despite checking
            print(f"Cannot save datafile: {cdmcore_outfile}")
        except RuntimeError:
            print("Runtime error")
        # TODO add logging for these errors

    return # main

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

    args = parser.parse_args()

    main(station=args.station, subset=args.subset, run_all=args.run_all, clobber=args.clobber)
