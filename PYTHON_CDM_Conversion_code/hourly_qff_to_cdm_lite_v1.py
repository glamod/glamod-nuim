# -*- coding: utf-8 -*-
"""
Convert QFF files to CDM Lite .psv files (one per station).

CDM Lite files have all variables, one after another.

Call in one of three ways using:

>python hourly_qff_to_cdm_lite_v1.py --station STATIONID
>python hourly_qff_to_cdm_lite_v1.py --subset FILENAME
>python hourly_qff_to_cdm_lite_v1.py --run_all
>python hourly_qff_to_cdm_lite_v1.py --help

Created on Thu Nov 11 16:31:58 2021

@author: snoone

Edited: rjhd2, February 2022
"""

import os
import glob
import pandas as pd
import numpy as np
pd.options.mode.chained_assignment = None  # default='warn'
import utils

# Set the file extension for the subdaily psv files
EXTENSION = 'qff'

# Dictionaries to hold CDM codes.  In due course, read directly from those docs
HEIGHTS = {
    "temperature" : "2",
    "dew_point_temperature" : "2",
    "station_level_pressure" : "2",
    "sea_level_pressure" : "2",
    "wind_direction" : "10",
    "wind_speed" : "10",
}
UNITS = {
    "temperature" : "5",
    "dew_point_temperature" : "5",
    "station_level_pressure" : "32",
    "sea_level_pressure" : "32",
    "wind_direction" : "320",
    "wind_speed" : "731",
}
VARIABLE_ID = {
    "temperature" : "85",
    "dew_point_temperature" : "36",
    "station_level_pressure" : "57",
    "sea_level_pressure" : "58",
    "wind_direction" : "106",
    "wind_speed" : "107",
}
MISSING_DATA = {
    "temperature" : -99999,
    "dew_point_temperature" : -99999,
    "station_level_pressure" : -99999,
    "sea_level_pressure" : -99999,
    "wind_direction" : -999,
    "wind_speed" : -999,
}

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
    var_frame["report_type"] = var_frame["report_type"].str[:4].astype('str')
    # retain those matching "ICAO" and replace with "0" otherwise
    var_frame["report_type"] = np.where(var_frame["report_type"].isin(["ICAO"]), var_frame["report_type"] ,"0")
    # replace all ICAO with "4"
    var_frame["report_type"] = var_frame["report_type"].replace({'ICAO':'4',})
    
    return var_frame


def extract_qc_info(var_frame, all_frame, var_name):
    """
    Extract QC information for the QC tables

    var_frame : `dataframe`
        Dataframe for variable

    all_frame : `dataframe`
        Dataframe for station

    var_name : `str`
        Name of variable to use to extract QC information
    """

    var_frame["quality_flag"] = all_frame[f"{var_name}_QC_flag"]
    var_frame["qc_method"] = var_frame["quality_flag"]
    var_frame["report_id"] = var_frame["date_time"]

    # Set quality flag from master dataframe for variable
    #    and fill all nan with Null then change all nonnan to 1
    var_frame.loc[var_frame['quality_flag'].notnull(), "quality_flag"] = 1
    var_frame = var_frame.fillna("Null")
    var_frame.quality_flag[var_frame.quality_flag == "Null"] = 0

    return var_frame


def overwrite_variable_info(var_frame, var_name):
    """
    Replace information for variable with CDM codes

    var_frame : `dataframe`
        Dataframe for variable

    var_name : `str`
        Name of variable
    """

    var_frame["observation_height_above_station_surface"] = HEIGHTS[var_name]
    var_frame["units"] = UNITS[var_name]
    var_frame["observed_variable"] = VARIABLE_ID[var_name]
   
    return var_frame


def remove_missing_data_rows(var_frame, var_name):
    """
    Remove rows with no data

    var_frame : `dataframe`
        Dataframe for variable

    var_name : `str`
        Name of variable
    """

    var_frame = var_frame.fillna("null")
    var_frame = var_frame.replace({"null" : f"{MISSING_DATA[var_name]}"})
    var_frame = var_frame[var_frame.observation_value != MISSING_DATA[var_name]]
    var_frame = var_frame.dropna(subset=['secondary_id'])
    var_frame = var_frame.dropna(subset=['observation_value'])
    var_frame["source_id"] = pd.to_numeric(var_frame["source_id"], errors='coerce')

    return var_frame


def add_data_policy(var_frame, policy_frame):
    """
    Merge in data policy information from another dataframe

    var_frame : `dataframe`
        Dataframe for variable

    policy_frame : `dataframe`
        Dataframe for the data policy
    """

    var_frame = var_frame.astype(str)

    # merge policy frame into var_frame
    var_frame = policy_frame.merge(var_frame, on=['primary_station_id_2'])

    # rename column and remove ".0"
    var_frame['data_policy_licence'] = var_frame['data_policy_licence_x']

    var_frame['data_policy_licence'] = var_frame['data_policy_licence'].astype(str).apply(lambda x: x.replace('.0',''))

    return var_frame


def construct_obs_id(var_frame):
    """
    construct `observation_id` field

    var_frame : `dataframe`
        Dataframe for variable
    """

    # concatenate columns
    var_frame['observation_id'] = var_frame['primary_station_id'].astype(str) + "-" + \
                                  var_frame['record_number'].astype(str) + "-" + \
                                  var_frame['date_time'].astype(str)

    var_frame['observation_id'] = var_frame['observation_id'].str.replace(r' ', '-')
    
    # Remove unwanted last two characters
    var_frame['observation_id'] = var_frame['observation_id'].str[:-6]
    var_frame["observation_id"] = var_frame["observation_id"] + "-" + \
                                  var_frame['observed_variable'].astype(str) + "-" + \
                                  var_frame['value_significance'].astype(str)

    return var_frame


def construct_qc_df(var_frame):
    """
    Construct data frame for CDM-lite QC table

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


def fix_decimal_places(var_frame, do_obs_value=True):
    """
    Make sure no decimal places remain 
      or round value to required number of decimal places

    var_frame : `dataframe`
        Dataframe for variable
    """

    # remove the decimal places by editing string
    var_frame['source_id'] = var_frame['source_id'].astype(str).apply(lambda x: x.replace('.0', ''))
    var_frame["source_id"] = pd.to_numeric(var_frame["source_id"], errors='coerce')

    # remove decimal places by editing string
    var_frame['data_policy_licence'] = var_frame['data_policy_licence'].astype(str).apply(lambda x: x.replace('.0', ''))

    if do_obs_value:
        # Convert to float to allow rounding
        var_frame["observation_value"] = pd.to_numeric(var_frame["observation_value"], errors='coerce')
        var_frame["observation_value"] = var_frame["observation_value"].round(2)
    
    return var_frame


def construct_extra_ids(var_frame, all_frame, var_name):
    """
    Construct source_id and secondary_id fields

    var_frame : `dataframe`
        Dataframe for variable

    all_frame : `dataframe`
        Dataframe for station

    var_name : `str`
        Name of variable to use to extract QC information
    """
    
    var_frame["source_id"] = all_frame[f"{var_name}_Source_Code"]
    var_frame["secondary_id"] = all_frame[f"{var_name}_Source_Station_ID"].astype('str')
    var_frame['secondary_id'] = var_frame['secondary_id'].astype(str).apply(lambda x: x.replace('.0', ''))

    return var_frame


def main(station="", subset="", run_all=False, clobber=False):
    """
    Run processing of hourly QFF to CDM lite & QC tables

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
    if station != "":
        print(f"Single station run: {station}")
        all_filenames = [os.path.join(utils.SUBDAILY_QFF_IN_DIR, f"{station}.{EXTENSION}")]
    elif subset != "":
        print(f"Subset of stations run defined in: {subset}")
        # Allows for parallelisation
        try:
            with open(subset, "r") as f:
                filenames = f.read().splitlines()

                # now add the path to the front
                all_filenames = []
                for infile in filenames:
                    all_filenames += [os.path.join(utils.SUBDAILY_QFF_IN_DIR, f"{infile}.{EXTENSION}")]

            print(f"   N = {len(all_filenames)}")
        except IOError:
            print(f"Subset file {subset} cannot be found")
            return
        except OSError:
            print(f"Subset file {subset} cannot be found")
            return
    elif run_all:
        print(f"All stations run in {utils.SUBDAILY_QFF_IN_DIR}")
        all_filenames = [i for i in glob.glob(os.path.join(utils.SUBDAILY_QFF_IN_DIR, f'*.{EXTENSION}'))]    
        print(f"   N = {len(all_filenames)}")


    # Read in the data policy dataframe (only read in if needed)
    data_policy_df = pd.read_csv(utils.SUBDAILY_STATION_RECORD_ENTRIES_OBS_LITE, encoding='latin-1')
    data_policy_df = data_policy_df.astype(str)
              
    # To start at begining of files
    for filename in all_filenames:

        if not os.path.exists(os.path.join(utils.SUBDAILY_QFF_IN_DIR, filename)):
            print("Input QFF file missing: {}".format(os.path.join(utils.SUBDAILY_QFF_IN_DIR, filename)))
            continue
        else:
            print("Processing {}".format(os.path.join(utils.SUBDAILY_QFF_IN_DIR, filename)))

        # Read in the dataframe
        df=pd.read_csv(os.path.join(utils.SUBDAILY_QFF_IN_DIR, filename), sep="|", low_memory=False)

        # Set up the output filenames, and check if they exist
        station_id=df.iloc[1]["Station_ID"] # NOTE: this is renamed below to "primary_station_id"

        outroot_cdmlite = os.path.join(utils.SUBDAILY_CDM_LITE_OUT_DIR, utils.SUBDAILY_CDM_LITE_FILE_ROOT)
        cdmlite_outfile = f"{outroot_cdmlite}{station_id}.psv"

        outroot_qc= os.path.join(utils.SUBDAILY_QC_OUT_DIR, utils.SUBDAILY_QC_FILE_ROOT)
        qc_outfile = f"{outroot_qc}{station_id}.psv"

        # if not overwriting
        if not clobber:
            # and both output files exist
            if os.path.exists(cdmlite_outfile) and os.path.exists(qc_outfile):
                print(f"   Output files for {filename} already exist:")
                print(f"     {cdmlite_outfile}")
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
        df["date_time_meaning"] = "1"
        df["latitude"] = df["Latitude"]
        df["longitude"] = df["Longitude"]
        df["observed_variable"] = ""  
        df["value_significance"] = "12" 
        df["observation_duration"] = "0"
        df["observation_value"] = ""
        df["platform_type"] = ""
        df["station_type"] = "1"
        df["observation_id"] = ""
        df["data_policy_licence"] = ""
        df["primary_station_id"] = df["Station_ID"]
        df["secondary_id"] = ""                                   
        df["station_name"] = df["Station_name"]
        df["quality_flag"] = ""
        df["latitude"] = pd.to_numeric(df["Latitude"], errors='coerce')
        df["longitude"] = pd.to_numeric(df["Longitude"], errors='coerce')
        df["latitude"] = df["latitude"].round(3)
        df["longitude"]=  df["longitude"].round(3)
        df["Timestamp2"] = df["Year"].map(str) + "-" +\
                           df["Month"].map(str) + "-" +\
                           df["Day"].map(str)  
        df["Seconds"] = "00"
        df["offset"] = "+00"
        df["date_time"] = df["Timestamp2"].map(str) + " " +\
                          df["Hour"].map(str) + ":" + \
                          df["Minute"].map(str) + ":" + \
                          df["Seconds"].map(str) 
        df['date_time'] =  pd.to_datetime(df['date_time'], format="%Y/%m/%d %H:%M")
        df['date_time'] = df['date_time'].astype('str')
        df.date_time = df.date_time + '+00'

        # =========================================================================================
        # Convert temperature [fields used change for each variable]
        dft = df[INITIAL_COLUMNS]

        # set report type to 4 for ICAO or 0 for all other hourly stations
        dft = construct_report_type(dft, df, "temperature_Source_Station_ID")

        # Change for each variable to convert to CDM compliant values
        dft["observation_value"] = df["temperature"] + 273.15
        dft = construct_extra_ids(dft, df, "temperature")

        # Extract QC information for QC tables
        dft = extract_qc_info(dft, df, "temperature")

        # Change for each variable if required
        dft = overwrite_variable_info(dft, "temperature")

        # Remove unwanted missing data rows
        dft = remove_missing_data_rows(dft, "temperature")
        
        # Concatenate columns for joining dataframe in next step
        dft['source_id'] = dft['source_id'].astype(str).apply(lambda x: x.replace('.0', ''))
        dft['primary_station_id_2'] = dft['secondary_id'].astype(str) + '-' + \
                                      dft['source_id'].astype(str)
        dft["observation_value"] = pd.to_numeric(dft["observation_value"], errors='coerce')
        
        # Add data policy and record number to dataframe
        dft = add_data_policy(dft, data_policy_df)

        # Restrict to required columns
        dft = dft[INTERMED_COLUMNS]

        # Create observation_id field
        dft = construct_obs_id(dft)

        # Set up QC table
        qct = construct_qc_df(dft)

        # Restrict to required columns
        dft = dft[FINAL_COLUMNS]

        # Ensure correct number of decimal places
        dft = fix_decimal_places(dft)


        # =================================================================================
        # Convert dew point temperature
        dfdpt = df[INITIAL_COLUMNS]

        # set report type to 4 for ICAO or 0 for all other hourly stations
        dfdpt = construct_report_type(dfdpt, df, "dew_point_temperature_Source_Station_ID")

        # Change for each variable to convert to CDM compliant values
        dfdpt["observation_value"] = df["dew_point_temperature"] + 273.15
        dfdpt = construct_extra_ids(dfdpt, df, "dew_point_temperature")

        # Extract QC information for QC tables
        dfdpt = extract_qc_info(dfdpt, df, "dew_point_temperature")

        # Change for each variable if required
        dfdpt = overwrite_variable_info(dfdpt, "dew_point_temperature")

        # Remove unwanted mising data rows
        dfdpt = remove_missing_data_rows(dfdpt, "dew_point_temperature")
        
        # Concatenate columns for joining dataframe for next step
        dfdpt['source_id'] = dfdpt['source_id'].astype(str).apply(lambda x: x.replace('.0', ''))
        dfdpt['primary_station_id_2'] = dfdpt['secondary_id'].astype(str) + '-' + \
                                        dfdpt['source_id'].astype(str)
        dfdpt["observation_value"] = pd.to_numeric(dfdpt["observation_value"],errors='coerce')
        
        # Add data policy and record numbers to dataframe
        dfdpt = add_data_policy(dfdpt, data_policy_df)

        # Restrict to required columns
        dfdpt = dfdpt[INTERMED_COLUMNS]

        # Create observation_id field
        dfdpt = construct_obs_id(dfdpt)

        # Set up QC table
        qcdpt = construct_qc_df(dfdpt)

        # Restrict to required columns
        dfdpt = dfdpt[FINAL_COLUMNS]

        # Ensure correct number of decimal places
        dfdpt = fix_decimal_places(dfdpt)

        #====================================================================================
        # Convert station level pressure  to cdmlite
        dfslp = df[INITIAL_COLUMNS]

        # set report type to 4 for ICAO or 0 for all other hourly stations
        dfslp = construct_report_type(dfslp, df, "station_level_pressure_Source_Station_ID")

        # Change for each variable to convert to CDM compliant values
        dfslp["observation_value"] = df["station_level_pressure"]
        dfslp = construct_extra_ids(dfslp, df, "station_level_pressure")
 
        # Extract QC information for QC tables
        dfslp = extract_qc_info(dfslp, df, "station_level_pressure")

        # Change for each variable if required
        dfslp = overwrite_variable_info(dfslp, "station_level_pressure")

        # Remove unwanted missing data rows
        dfslp = remove_missing_data_rows(dfslp, "station_level_pressure")
        
        # Concatenate columns for joining dataframe for next step
        dfslp['source_id'] = dfslp['source_id'].astype(str).apply(lambda x: x.replace('.0', ''))
        dfslp['primary_station_id_2'] = dfslp['secondary_id'].astype(str) + '-' + \
                                        dfslp['source_id'].astype(str)
        
        # Add data policy and record numbers to dataframe
        dfslp = add_data_policy(dfslp, data_policy_df)

        # Restrict to required columns
        dfslp = dfslp[INTERMED_COLUMNS]

        # Create observation_id field
        dfslp = construct_obs_id(dfslp)

        # Set up QC table
        qcslp = construct_qc_df(dfslp)

        # Restrict to required columns
        dfslp = dfslp[FINAL_COLUMNS]
        dfslp = dfslp[dfslp.observation_value != "Null"]

        # Make sure no decimal places and round value to required number of decimal places
        dfslp['observation_value'] = dfslp['observation_value'].map(float)
        dfslp['observation_value'] = (dfslp['observation_value']*100)
        dfslp['observation_value'] = dfslp['observation_value'].map(int)

        dfslp = fix_decimal_places(dfslp, do_obs_value=False)

        #===========================================================================================
        # Convert sea level pressure to CDM lite
        dfmslp = df[INITIAL_COLUMNS]

        # set report type to 4 for ICAO or 0 for all other hourly stations
        dfmslp = construct_report_type(dfmslp, df, "sea_level_pressure_Source_Station_ID")

        # Change for each variable to convert to CDM compliant values
        dfmslp["observation_value"] = df["sea_level_pressure"]
        dfmslp = construct_extra_ids(dfmslp, df, "sea_level_pressure")

        # Extract QC information for QC tables
        dfmslp = extract_qc_info(dfmslp, df, "sea_level_pressure")

        # Change for each variable if required
        dfmslp = overwrite_variable_info(dfmslp, "sea_level_pressure")

        # Remove unwanted missing data rows
        dfmslp = remove_missing_data_rows(dfmslp, "sea_level_pressure")
        
        # Concatenate columns for joining dataframe for next step
        dfmslp['source_id'] = dfmslp['source_id'].astype(str).apply(lambda x: x.replace('.0', ''))
        dfmslp['primary_station_id_2'] = dfmslp['secondary_id'].astype(str) + '-' + \
                                         dfmslp['source_id'].astype(str)
        
        # Add data policy and record numbers to dataframe
        dfmslp = add_data_policy(dfmslp, data_policy_df)

        # Restrict to required columns
        dfmslp = dfmslp[INTERMED_COLUMNS]

        # Create observation_id field
        dfmslp = construct_obs_id(dfmslp)

        # Set up QC table
        qcmslp = construct_qc_df(dfmslp)

        # Restrict to required columns
        dfmslp = dfmslp[FINAL_COLUMNS]
        dfmslp = dfmslp[dfmslp.observation_value != "Null"]

        # Make sure no decimal places and round value to required number of decimal places
        dfmslp['observation_value'] = dfmslp['observation_value'].map(float)
        dfmslp['observation_value'] = (dfmslp['observation_value']*100)
        dfmslp['observation_value'] = dfmslp['observation_value'].map(int)

        dfmslp = fix_decimal_places(dfmslp, do_obs_value=False)

        #===================================================================================
        # Convert wind direction to CDM lite
        dfwd = df[INITIAL_COLUMNS]

        # set report type to 4 for ICAO or 0 for all other hourly stations
        dfwd = construct_report_type(dfwd, df, "wind_direction_Source_Station_ID")

        # Change for each variable to convert to CDM compliant values
        dfwd["observation_value"] = df["wind_direction"]
        dfwd = construct_extra_ids(dfwd, df, "wind_direction")

        # Extract QC information for QC tables
        dfwd = extract_qc_info(dfwd, df, "wind_direction")

        # Change for each variable if required
        dfwd = overwrite_variable_info(dfwd, "wind_direction")

        # Remove unwanted missing data rows
        dfwd = remove_missing_data_rows(dfwd, "wind_direction")
        
        # Concatenate columns for joining dataframe for next step
        dfwd['source_id'] = dfwd['source_id'].astype(str).apply(lambda x: x.replace('.0', ''))
        dfwd['primary_station_id_2'] = dfwd['secondary_id'].astype(str) + '-' + \
                                       dfwd['source_id'].astype(str)
        
        # Add data policy and record numbers to datframe
        dfwd = add_data_policy(dfwd, data_policy_df)

        # Restrict to required columns
        dfwd = dfwd[INTERMED_COLUMNS]

        # Create observation_id field
        dfwd = construct_obs_id(dfwd)

        # Set up QC table
        qcwd = construct_qc_df(dfwd)

        # Restrict to required columns
        dfwd = dfwd[FINAL_COLUMNS]

        # Make sure no decimal places and round value to reuquired number of decimal places
        dfwd['observation_value'] = dfwd['observation_value'].astype(str).apply(lambda x: x.replace('.0', ''))
        dfwd = fix_decimal_places(dfwd, do_obs_value=False)
        

        #===========================================================================
        # Convert wind speed to CDM lite
        dfws = df[INITIAL_COLUMNS]

        # set report type to 4 for ICAO or 0 for all other hourly stations
        dfws = construct_report_type(dfws, df, "wind_speed_Source_Station_ID")

        # Change for each variable to convert to CDM compliant values
        dfws["observation_value"] = df["wind_speed"]
        dfws = construct_extra_ids(dfws, df, "wind_speed")

        # Extract QC information for QC tables
        dfws = extract_qc_info(dfws, df, "wind_speed")

        # Change for each variable if required
        dfws = overwrite_variable_info(dfws, "wind_speed")

        # Remove unwanted missing data rows
        dfws = remove_missing_data_rows(dfws, "wind_speed")

        # Concatenate columns for joining dataframe for next step
        dfws['source_id'] = dfws['source_id'].astype(str).apply(lambda x: x.replace('.0', ''))
        dfws['primary_station_id_2'] = dfws['secondary_id'].astype(str) + '-' + \
                                       dfws['source_id'].astype(str)
        #dfws["observation_value"] = pd.to_numeric(dfws["observation_value"],errors='coerce')
        #dft.to_csv("ttest.csv", index=False, sep=",")

        # Add data policy and record numbers to datafram
        dfws = add_data_policy(dfws, data_policy_df)

        # Restrict to required columns
        dfws = dfws[INTERMED_COLUMNS]

        # Create observation_id field
        dfws = construct_obs_id(dfws)

        # QC flag tables
        qcws = construct_qc_df(dfws)

        #station_id=dfws.iloc[1]["primary_station_id"]

        # Restrict to required columns
        dfws = dfws[FINAL_COLUMNS]

        # Ensure correct number of decimal places
        dfws = fix_decimal_places(dfws)


        # =================================================================================
        # Merge all dataframes into one CDMlite frame
        merged_df=pd.concat([dfdpt,dft,dfslp,dfmslp,dfwd,dfws], axis=0)

        # Sort by date/times and fix metadata
        merged_df.sort_values("date_time", inplace=True)
        merged_df["latitude"] = pd.to_numeric(merged_df["latitude"],errors='coerce')
        merged_df["longitude"] = pd.to_numeric(merged_df["longitude"],errors='coerce')
        merged_df["latitude"]= merged_df["latitude"].round(3)
        merged_df["longitude"]= merged_df["longitude"].round(3)

        # Write the output files
        #   name the cdm_lite files e.g. cdm_lite _"insert date of run"_EG000062417.psv)
        try:
            # Save CDM lite table to directory
            unique_variables = merged_df['observed_variable'].unique()
            print(unique_variables)
            merged_df.to_csv(cdmlite_outfile, index=False, sep="|")
            print(f"    {cdmlite_outfile}")

            # Save QC table to directory
            qc_merged_df=pd.concat([qcdpt,qct,qcslp,qcmslp,qcwd,qcws], axis=0)
            qc_merged_df.astype(str)

            # Replace flag characters with numbers for CDM lite
            for qc_flag, qc_value in SUB_DAILY_QC_FLAGS.items():
                qc_merged_df['qc_method'] = qc_merged_df['qc_method'].str.replace(qc_flag, qc_value)

            # Remove unwanted "," from column
            qc_merged_df['qc_method'] = qc_merged_df['qc_method'].str[:-1]
            qc_station_id=merged_df.iloc[1]["primary_station_id"]
            unique_qc_methods = qc_merged_df['qc_method'].unique()
            print(unique_qc_methods)
            qc_merged_df.to_csv(qc_outfile, index=False, sep="|")
            print(f"   {qc_outfile}")
            print("    Done")
        except IOError:
            # something wrong with file paths, despite checking
            print(f"Cannot save datafile: {cdmlite_outfile}")
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
