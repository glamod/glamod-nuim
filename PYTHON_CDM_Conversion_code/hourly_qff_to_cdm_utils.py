#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Subroutines for sub-daily QFF to CDM conversion scripts

@author: rjhd2
"""

import pandas as pd

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
VALUE_SIGNIFICANCE = {
    "temperature" : "12",
    "dew_point_temperature" : "12",
    "station_level_pressure" : "12",
    "sea_level_pressure" : "12",
    "wind_direction" : "2",
    "wind_speed" : "2",
}
OBSERVATION_DURATION = {
    "temperature" : "0",
    "dew_point_temperature" : "0",
    "station_level_pressure" : "0",
    "sea_level_pressure" : "0",
    "wind_direction" : "8",
    "wind_speed" : "8",
}



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

def extract_qc_info(var_frame, all_frame, var_name, do_report_id=False):
    """
    Extract QC information for the QC tables

    var_frame : `dataframe`
        Dataframe for variable

    all_frame : `dataframe`
        Dataframe for station

    var_name : `str`
        Name of variable to use to extract QC information

    do_report_id : `bool`
        Process the report_id field too (CDM Lite only)
    """

    var_frame["quality_flag"] = all_frame[f"{var_name}_QC_flag"]
    var_frame["qc_method"] = var_frame["quality_flag"]
    if do_report_id:
        # CDM Lite version has report_id entry here (not needed for OBS)
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
    var_frame["value_significance"] = VALUE_SIGNIFICANCE[var_name]
    var_frame["observation_duration"] = OBSERVATION_DURATION[var_name]
   
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


def apply_wind_measurement_codes(var_frame, retained_measurement_codes_list):
    """
    Remove values associated with all measurement codes except those specified

    var_frame : `dataframe`
        Dataframe for variable
    retained_measurement_codes_list : `list`
        List of strings outlining the codes to be retained
    """

    for c, code in enumerate(retained_measurement_codes_list):
        if code == "":
            # Empty flags converted to NaNs on reading
            code = float("nan")
        if c == 0:
            # Initialise
            mask = (var_frame["measurement_code"] == code)
        else:
            # Combine using or
            #   If code = "N-Normal" or "C-Calm" or "" set True
            mask = (var_frame["measurement_code"] == code) |\
                   mask

    # Now invert mask using "~"      
    var_frame.loc[~mask, "observation_value"] = float("nan")

    return var_frame
