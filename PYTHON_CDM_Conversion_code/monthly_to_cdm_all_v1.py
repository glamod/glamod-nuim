#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
@author snoone
edited 8/03/2022 snnone

Convert monthly OBSERVATIONS files to Lite, Obs and hedaer .psv files (one per station).

s
Call in one of three ways using:

>python monthly_to_cdm_all_v1.py --station STATIONID
>python monthly_to_cdm_all_v1.py --subset FILENAME
>python monthly_to_cdm_all_v1.py --run_all
>python monthly_to_cdm_all_v1.py --help

#Created on Thu Nov 11 16:31:58 2021

@author: snoone

edited: snoone, February 2022
edited snoone 8/03/2022
"""

import os
import glob
import pandas as pd
pd.options.mode.chained_assignment = None  # default='warn'
import utils


# Set the file extension for the monthly obs psv files
IN_EXTENSION = ".csv"
OUT_EXTENSION = ".psv"
COMPRESSION = ""

LITE_COLS = ["STATION", "LATITUDE", "LONGITUDE", "ELEVATION", "DATE", "NAME", "PRCP", "TMIN", "TMAX", "TAVG", "SNOW", "AWND"]


INITIAL_VAR_COLUMNS = ["observation_id","report_type","date_time","date_time_meaning",
                      "latitude","longitude","observation_height_above_station_surface"
                      ,"observed_variable","units","observation_value",
                      "value_significance","observation_duration","platform_type",
                      "station_type","primary_station_id","station_name","quality_flag"
                      ,"data_policy_licence"]

FINAL_VAR_COLUMNS = ["observation_id","report_type","date_time","date_time_meaning",
                      "latitude","longitude","observation_height_above_station_surface"
                      ,"observed_variable","units","observation_value",
                      "value_significance","observation_duration","platform_type",
                      "station_type","primary_station_id","station_name","quality_flag"
                      ,"data_policy_licence","source_id","primary_station_id_2"]

UNITS = {
    "SNWD" : "715",
    "PRCP" : "710",
    "TMIN" : "5",
    "TMAX" : "5",
    "TAVG" : "5",
    "SNOW" : "710",
    "AWND" : "320",
    "AWDR" : "731",
    "WESD" : "710",
}

HEIGHTS = {
    "SNWD" : "1",
    "PRCP" : "1",
    "TMIN" : "2",
    "TMAX" : "2",
    "TAVG" : "2",
    "SNOW" : "0",
    "AWND" : "10",
    "AWDR" : "10",
    "WESD" : "1",
}

VARIABLE_ID = {
    "SNWD" : "53",
    "PRCP" : "44",
    "TMIN" : "85",
    "TMAX" : "85",
    "TAVG" : "85",
    "SNOW" : "45",
    "AWND" : "107",
    "AWDR" : "106",
    "WESD" : "55",
}


CONVERSION_FLAGS = {
    "SNWD" : "2",
    "PRCP" : "2",
    "TMIN" : "0",
    "TMAX" : "0",
    "TAVG" : "0",
    "SNOW" : "2",
    "AWND" : "2",
    "AWDR" : "2",
    "WESD" : "2",
}

NUMERICAL_PRECISION = {
    "SNWD" : "1",
    "PRCP" : "0.1",
    "TMIN" : "0.01",
    "TMAX" : "0.01",
    "TAVG" : "0.01",
    "SNOW" : "0.1",
    "AWND" : "0.1",
    "AWDR" : "0.1",
    "WESD" : "0.1",
}

ORIGINAL_PRECISION = {
    "SNWD" : "1",
    "PRCP" : "0.1",
    "TMIN" : "0.1",
    "TMAX" : "0.1",
    "TAVG" : "0.1",
    "SNOW" : "0.1",
    "AWND" : "0.1",
    "AWDR" : "1",
    "WESD" : "0.1",
}

def set_units_etc(var_frame, var_name):
    """
    Merge in data policy information from another dataframe

    var_frame : `dataframe`
        Dataframe for variable

    var_name : `str`
        Name of variable
    """
    
    var_frame["observation_height_above_station_surface"] = HEIGHTS[var_name]
    var_frame["units"] = UNITS[var_name]
    var_frame["observed_variable"] = VARIABLE_ID[var_name]
    # set up matching values for merging with record_id_month to add information source_id for first configuration only due to lakc of information
    var_frame["record_number"] = "1"   
    var_frame['primary_station_id_2'] = var_frame['primary_station_id'].astype(str)+'-'+var_frame['record_number'].astype(str)
    var_frame["report_id"] = var_frame["date_time"]

    return var_frame


def add_data_policy(var_frame, policy_frame, rename=False):
    """
    Merge in data policy information from another dataframe

    var_frame : `dataframe`
        Dataframe for variable

    policy_frame : `dataframe`
        Dataframe for the data policy

    rename : `bool`
        Rename some of the columns
    """

    var_frame = var_frame.astype(str)

    # merge policy frame into var_frame
    if var_frame['primary_station_id_2'].unique()[0] not in policy_frame['primary_station_id_2'].values:
        print("  Station not available in final records list")
        # this station didn't make it through upstream QC
        raise RuntimeError
    else:
        var_frame = policy_frame.merge(var_frame, on=['primary_station_id_2'])
    
    if rename:
        # rename columns
        var_frame = var_frame.rename(columns={"station_name_x":"station_name",})
        var_frame = var_frame.rename(columns={"source_id_x":"source_id",})

    return var_frame


def build_observation_id(var_frame):
    """
    Build observation_id column

    var_frame : `dataframe`
        Dataframe for variable
    """

    var_frame['observation_id'] = var_frame['primary_station_id'].astype(str) + '-' +\
        var_frame['record_number'].astype(str) + '-' + var_frame['date_time'].astype(str)
    var_frame['observation_id'] = var_frame['observation_id'].str.replace(r' ', '-')
    # remove unwanted last two characters
    var_frame['observation_id'] = var_frame['observation_id'].str[:-12]
    var_frame["observation_id"] = var_frame["observation_id"] + '-' +\
        var_frame['observed_variable'].astype(str) + '-' + var_frame['value_significance'].astype(str)

    return var_frame


def convert_to_kelvin(var_frame):
    """
    Convert observation_value to kelvin

    var_frame : `dataframe`
        Dataframe for variable
    """

    var_frame["observation_value"] = pd.to_numeric(var_frame["observation_value"], errors='coerce')
    var_frame["observation_value"] = var_frame["observation_value"] + 273.15
    var_frame["observation_value"] = pd.to_numeric(var_frame["observation_value"], errors='coerce')
    var_frame["observation_value"] = var_frame["observation_value"].round(2)
    return var_frame


def main(station="", subset="", run_all=False, clobber=False):
    """
    Run processing of monthly OBSERVATIONS files to Lite, Obs and hedaer 

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
    if station != "" and subset != "" and run_all:
        print("Please select either single station, list of stations run or to run all")
        return
    elif station == "" and subset == "" and not run_all:
        print("Please select either single station, list of stations run or to run all")
        return

    # Obtain list of station(s) to process (single/subset/all)
    all_filenames = utils.get_station_list_to_process(utils.MONTHLY_CSV_IN_DIR,
                                                      f"{IN_EXTENSION}{COMPRESSION}",
                                                      station=station,
                                                      subset=subset,
                                                      run_all=run_all,
                                                      )
 
    # Read in the data policy dataframe (only read in if needed)
    data_policy_df = pd.read_csv(utils.MONTHLY_STATION_RECORD_ENTRIES_OBS_LITE, encoding='latin-1')
    data_policy_df = data_policy_df.astype(str)
       
    for filename in all_filenames:
        if not os.path.exists(filename):
            print("Input {} file missing: {}".format(IN_EXTENSION, filename))
            continue
        else:
            print(f"Processing {filename}")

        # using lambda as no all columns present in each file
        df = pd.read_csv(filename, sep=",", usecols=lambda c: c in LITE_COLS, compression='infer')

        # set output filenames
        station_id = df.iloc[0]["STATION"] # NOTE: this is renamed below to "primary_station_id"
        outroot_cdmlite = os.path.join(utils.MONTHLY_CDM_LITE_OUT_DIR, utils.MONTHLY_CDM_LITE_FILE_ROOT) 
        outroot_cdmobs = os.path.join(utils.MONTHLY_CDM_OBS_OUT_DIR, utils.MONTHLY_CDM_OBS_FILE_ROOT) 
        outroot_cdmhead = os.path.join(utils.MONTHLY_CDM_HEAD_OUT_DIR, utils.MONTHLY_CDM_HEAD_FILE_ROOT) 
        cdmlite_outfile = f"{outroot_cdmlite}{station_id}{OUT_EXTENSION}{COMPRESSION}"
        cdmobs_outfile = f"{outroot_cdmobs}{station_id}{OUT_EXTENSION}{COMPRESSION}"
        cdmhead_outfile = f"{outroot_cdmhead}{station_id}{OUT_EXTENSION}{COMPRESSION}"

        if not clobber:
            # all output files exist
            if os.path.exists(cdmlite_outfile) and os.path.exists(cdmobs_outfile) and os.path.exists(cdmhead_outfile):
                print(f"   Output files for {filename} already exist:") 
                print(f"     {cdmlite_outfile}") 
                print(f"     {cdmobs_outfile}") 
                print(f"     {cdmhead_outfile}") 
                print("   Skipping to next station")  
                continue    #  to next file in the loop

        # set common values
        df["report_type"] = "2"
        df["units"] = ""
        df["minute"] = "00"
        df["day"] = "01"
        df["hour"] = "00"
        df["seconds"] = "00"
        df[['year', 'month']] = df['DATE'].str.split('-', expand=True)
        df["observation_height_above_station_surface"] = ""
        df["date_time_meaning"] = "1"
        df["latitude"] = df["LATITUDE"]
        df["longitude"] = df["LONGITUDE"]
        df["observed_variable"] = ""  
        df["value_significance"] = "13" 
        df["observation_duration"] = "14"
        df["observation_value"] = ""
        df["platform_type"] = ""
        df["station_type"] = "1"
        df["observation_id"] = ""
        df["data_policy_licence"] = "0"
        df["primary_station_id"] = df["STATION"]
        df["station_name"] = df["NAME"]
        df["quality_flag"] = "0"
        df["latitude"] = pd.to_numeric(df["latitude"],errors='coerce')
        df["longitude"] = pd.to_numeric(df["longitude"],errors='coerce')
        df["latitude"] = df["latitude"].round(3)
        df["longitude"] = df["longitude"].round(3)
        df["Timestamp2"] = df["year"].map(str) + "-" + df["month"].map(str)+ "-" + df["day"].map(str)
        df["offset"]="+00"
        df["date_time"] = df["Timestamp2"].map(str)+ " " + df["hour"].map(str)+":"+df["minute"].map(str)+":"+df["seconds"].map(str) 
        df['date_time'] = df['date_time'].astype('str')
        df.date_time = df.date_time + '+00'

        # extract precip
        try:
            dfprc = df[INITIAL_VAR_COLUMNS]

            # change for each variable to convert to cdm compliant values
            dfprc["observation_value"] = df["PRCP"]

            # change for each variable if required
            dfprc = set_units_etc(dfprc, "PRCP")

            # merge with record_id_mnth.csv to add source id
            dfprc = add_data_policy(dfprc, data_policy_df, rename=True)
        
            dfprc = build_observation_id(dfprc)
        
            # reorder columns and drop unwanted columns
            dfprc = dfprc[FINAL_VAR_COLUMNS]
        except KeyError:
            # this variable doesn't exist in the file
            pass
        except RuntimeError:
            # station not available because of upstream QC
            # continue to next station
            continue
           



        # extract SNOW
        try:
            dfsnow = df[INITIAL_VAR_COLUMNS]

            # change for each variable to convert to cdm compliant values
            dfsnow["observation_value"] = df["SNOW"]
            dfsnow = dfsnow.fillna("Null")
            dfsnow = dfsnow[dfsnow.observation_value != "Null"]

            #change for each variable if required
            dfsnow = set_units_etc(dfsnow, "SNOW")

            # merge with record_id_mnth.csv to add source id
            dfsnow = add_data_policy(dfsnow, data_policy_df, rename=True)

            dfsnow = build_observation_id(dfsnow)

            # reorder columns and drop unwanted columns
            dfsnow = dfsnow[FINAL_VAR_COLUMNS]
        except KeyError:
            # this variable doesn't exist in the file
            pass
        except RuntimeError:
            # station not available because of upstream QC
            # continue to next station
            continue
            

        # extract tmax
        try:
            dftmax = df[INITIAL_VAR_COLUMNS]

            # change for each variable to convert to cdm compliant values
            dftmax["observation_value"] = df["TMAX"]
            dftmax = dftmax.fillna("Null")
            dftmax = dftmax[dftmax.observation_value != "Null"]
            dftmax = convert_to_kelvin(dftmax)

            #change for each variable if required
            dftmax = set_units_etc(dftmax, "TMAX")
            dftmax["value_significance"] = "0" 

            # merge with record_id_mnth.csv to add source id
            dftmax = add_data_policy(dftmax, data_policy_df, rename=True)

            dftmax = build_observation_id(dftmax)

            # reorder columns and drop unwanted columns
            dftmax = dftmax[FINAL_VAR_COLUMNS]

        except KeyError:
            # this variable doesn't exist in the file
            pass
        except RuntimeError:
            # station not available because of upstream QC
            # continue to next station
            continue


        # extract tmin
        try:
            dftmin = df[INITIAL_VAR_COLUMNS]

            # change for each variable to convert to cdm compliant values
            dftmin["observation_value"] = df["TMIN"]
            dftmin = dftmin.fillna("Null")
            dftmin = dftmin[dftmin.observation_value != "Null"]
            dftmin = convert_to_kelvin(dftmin)

            # change for each variable if required
            dftmin = set_units_etc(dftmin, "TMIN")
            dftmin["value_significance"] = "1" 

            # merge with record_id_mnth.csv to add source id
            dftmin = add_data_policy(dftmin, data_policy_df, rename=True)

            dftmin = build_observation_id(dftmin)
    
            # reorder columns and drop unwanted columns
            dftmin = dftmin[FINAL_VAR_COLUMNS]
        except KeyError:
            # this variable doesn't exist in the file
            pass
        except RuntimeError:
            # station not available because of upstream QC
            # continue to next station
            continue



        # extract tavg
        try:
            dftavg = df[INITIAL_VAR_COLUMNS]

            # change for each variable to convert to cdm compliant values
            dftavg["observation_value"]=df["TAVG"]
            dftavg = dftavg.fillna("Null")
            dftavg = dftavg[dftavg.observation_value != "Null"]
            dftavg = convert_to_kelvin(dftavg)

            # change for each variable if required
            dftavg = set_units_etc(dftavg, "TAVG")
            dftavg["value_significance"]="2" 

            # merge with record_id_mnth.csv to add source id
            dftavg = add_data_policy(dftavg, data_policy_df, rename=True)

            dftavg = build_observation_id(dftavg)

            # reorder columns and drop unwanted columns
            dftavg = dftavg[FINAL_VAR_COLUMNS]
        except KeyError:
            # this variable doesn't exist in the file
            pass
        except RuntimeError:
            # station not available because of upstream QC
            # continue to next station
            continue



        # extract wind speed avge
        try:
            dftws = df[INITIAL_VAR_COLUMNS]

            # change for each variable to convert to cdm compliant values
            dftws["observation_value"] = df["AWND"]
            dftws = dftws.fillna("Null")
            dftws = dftws[dftws.observation_value != "Null"]

            # fix observation_value
            dftws["observation_value"] = pd.to_numeric(dftws["observation_value"],errors='coerce')
            dftws["observation_value"] = dftws["observation_value"].round(2)

            # change for each variable if required
            dftws = set_units_etc(dftws, "AWND")
            dftws["value_significance"] = "2" 

            # merge with record_id_mnth.csv to add source id
            dftws = add_data_policy(dftws, data_policy_df, rename=True)

            dftws = build_observation_id(dftws)

            # reorder columns and drop unwanted columns
            dftws = dftws[FINAL_VAR_COLUMNS]
        except KeyError:
            # this variable doesn't exist in the file
            pass 
        except RuntimeError:
            # station not available because of upstream QC
            # continue to next station
            continue


        # merge all the separate variable df togther into one df
        merged_df=pd.concat([dftmax, dftavg, dftmin, dftws, dfprc, dfsnow], axis=0)
        # if no data that's being converted present in the input data frame
        #    then no "observation_value" entry in final
        if len(merged_df["observation_value"].unique()) == 1 and \
           merged_df["observation_value"].unique() == "":
            # all are blank strings, so don't output
            print("No observations in the file, skipping output")
            continue

        merged_df.sort_values("date_time", inplace=True)

        # sort locational metadata
        merged_df["latitude"] = pd.to_numeric(merged_df["latitude"], errors='coerce')
        merged_df["longitude"] = pd.to_numeric(merged_df["longitude"], errors='coerce')
        merged_df["latitude"] = merged_df["latitude"].round(3)
        merged_df["longitude"] = merged_df["longitude"].round(3)

        merged_df = merged_df[merged_df.observation_value != "nan"]
        merged_df["observation_value"] = pd.to_numeric(merged_df["observation_value"], errors='coerce')
        merged_df.dropna(subset = ["observation_value"], inplace=True)
        merged_df.dropna(subset = ["observation_id"], inplace=True)
        # and store the CDM Lite dateframe
        df_lite_out = merged_df[["observation_id","report_type","date_time","date_time_meaning",
                      "latitude","longitude","observation_height_above_station_surface"
                      ,"observed_variable","units","observation_value",
                      "value_significance","observation_duration","platform_type",
                      "station_type","primary_station_id","station_name","quality_flag"
                      ,"data_policy_licence","source_id"]]

        # extract columns for CDM Obs dataframe
        dfobs=merged_df[["observation_id","report_type","date_time","date_time_meaning",
                  "latitude","longitude","observation_height_above_station_surface"
                  ,"observed_variable","units","observation_value",
                  "value_significance","observation_duration","platform_type",
                  "station_type","primary_station_id","station_name","quality_flag"
                  ,"data_policy_licence","source_id","primary_station_id_2"]]

        # add region and sub region
        dfobs = add_data_policy(dfobs, data_policy_df)

        dfobs["numerical_precision"] = ""
        # so that the look up tables don't use the variable ID value, but the name
        for obs_var, var_id in VARIABLE_ID.items():
            df.loc[df['observed_variable'] == var_id, 'numerical_precision'] = NUMERICAL_PRECISION[obs_var]

        dfobs["original_precision"] = ""
        for obs_var, var_id in VARIABLE_ID.items():
            df.loc[df['observed_variable'] == var_id, 'original_precision'] = ORIGINAL_PRECISION[obs_var]

        # add conversion flags
        dfobs["conversion_flag"] = ""
        for obs_var, var_id in VARIABLE_ID.items():
            df.loc[df['observed_variable'] == var_id, 'original_precision'] = CONVERSION_FLAGS[obs_var]


        # add all columns for obs table
        dfobs["date_time_meaning"] = "1"
        dfobs["crs"] = ""
        dfobs["z_coordinate"] = ""
        dfobs["z_coordinate_type"] = ""
        dfobs["secondary_variable"] = ""
        dfobs["secondary_value"] = ""
        dfobs["code_table"] = ""
        dfobs["sensor_id"] = ""
        dfobs["sensor_automation_status"] = ""
        dfobs["exposure_of_sensor"] = ""
        dfobs["processing_code"] = ""
        dfobs["processing_level"] = "0"
        dfobs["adjustment_id"] = ""
        dfobs["traceability"] = ""
        dfobs["advanced_qc"] = ""
        dfobs["advanced_uncertainty"] = ""
        dfobs["advanced_homogenisation"] = ""
        dfobs["advanced_assimilation_feedback"] = ""
        dfobs["source_record_id"] = ""
        dfobs["location_method"] = ""
        dfobs["location_precision"] = ""
        dfobs["z_coordinate_method"] = ""
        dfobs["bbox_min_longitude"] = ""
        dfobs["bbox_max_longitude"] = ""
        dfobs["bbox_min_latitude"] = ""
        dfobs["bbox_max_latitude"] = ""
        dfobs["spatial_representativeness"] = ""
        dfobs["original_code_table"] = ""
        dfobs["source_id"] = dfobs["source_id_x"]
        dfobs['date1'] = dfobs["date_time"].str[:-11]
        dfobs['date1'] = dfobs['date1'].str.strip()
        dfobs["observation_value"] = pd.to_numeric(dfobs["observation_value"],errors='coerce')
        dfobs["report_id"] = dfobs["station_id"].astype(str)+'-'+dfobs["record_id"].astype(str)+'-'+dfobs["date1"].astype(str)
        dfobs["original_value"] = dfobs["observation_value"]
        dfobs["original_units"] = dfobs["units"]
        # set conversion method for variables
        dfobs["conversion_method"] = ""
        dfobs.loc[dfobs['observed_variable'] == "85", 'original_units'] = '350'
        dfobs.loc[dfobs['observed_variable'] == "85", 'original_value'] = dfobs["observation_value"]-273.15
        dfobs.loc[dfobs['observed_variable'] == "85", 'conversion_method'] ="1"

        # and store the final set of columns
        dfobs=dfobs[["observation_id","report_id","data_policy_licence","date_time",
                  "date_time_meaning","observation_duration","longitude","latitude",
              "crs","z_coordinate","z_coordinate_type","observation_height_above_station_surface",
               "observed_variable","secondary_variable","observation_value",
               "value_significance","secondary_value","units","code_table",
               "conversion_flag","location_method","location_precision",
               "z_coordinate_method","bbox_min_longitude","bbox_max_longitude",
               "bbox_min_latitude","bbox_max_latitude","spatial_representativeness",
               "quality_flag","numerical_precision","sensor_id","sensor_automation_status",
               "exposure_of_sensor","original_precision","original_units",
               "original_code_table","original_value","conversion_method",
               "processing_code","processing_level","adjustment_id","traceability",
               "advanced_qc","advanced_uncertainty","advanced_homogenisation",
               "advanced_assimilation_feedback","source_id"]]



        # set up the header table from the obs table
        col_list = dfobs[["observation_id","latitude","longitude","report_id","source_id","date_time"]]
        hdf = col_list.copy()


        # add required columns and set up values etc
        #   extra steps to handle files with dashes in them
        hdf['extract_record'] = dfobs['report_id'].str[:-11]
        hdf['station_record_number'] = hdf['extract_record'].str[12:]
        hdf['primary_station_id'] = hdf['extract_record'].str[:11]

        # hdf[['primary_station_id', 'station_record_number', '1', "2", "3"]] = hdf['report_id'].str.split('-', expand=True)
        hdf["report_id"] = dfobs["report_id"]
        hdf["application_area"] = ""
        hdf["observing_programme"] = ""
        hdf["report_type"] = "3"
        hdf["station_type"] = "1"
        hdf["platform_type"] = ""
        hdf["primary_station_id_scheme"] = "13"
        hdf["location_accuracy"] = "0.1"
        hdf["location_method"] = ""
        hdf["location_quality"] = "3"
        hdf["crs"] = "0"
        hdf["station_speed"] = ""  
        hdf["station_course"] = ""
        hdf["station_heading"] = ""
        hdf["height_of_station_above_local_ground"] = ""
        hdf["height_of_station_above_sea_level_accuracy"] = ""
        hdf["sea_level_datum"] = ""
        hdf["report_meaning_of_timestamp"] = "1"
        hdf["report_timestamp"] = ""
        hdf["report_duration"] = "13"
        hdf["report_time_accuracy"] = ""
        hdf["report_time_quality"] = ""
        hdf["report_time_reference"] = "0"
        hdf["platform_subtype"] = ""
        hdf["profile_id"] = ""
        hdf["events_at_station"] = ""
        hdf["report_quality"] = ""
        hdf["duplicate_status"] = "4"
        hdf["duplicates"] = ""
        hdf["source_record_id"] = ""
        hdf ["processing_codes"] = ""
        hdf['record_timestamp'] = pd.to_datetime('now').strftime("%Y-%m-%d %H:%M:%S")
        hdf.record_timestamp = hdf.record_timestamp + '+00'
        hdf["history"] = ""
        hdf["processing_level"] = "0"
        hdf["report_timestamp"] = dfobs["date_time"]
        hdf['primary_station_id_3'] = hdf['primary_station_id'].astype(str) + '-' +\
            hdf['source_id'].astype(str)
        hdf["duplicates_report"] = hdf["report_id"] + '-' + hdf["station_record_number"].astype(str)


        hdf = data_policy_df.merge(hdf, on=['primary_station_id_3'])
        hdf = hdf.rename(columns={"latitude_x":"latitude",})
        hdf = hdf.rename(columns={"longitude_x":"longitude",})
        hdf['height_of_station_above_sea_level'] = hdf['height_of_station_above_sea_level'].astype(str).apply(lambda x: x.replace('.0',''))
        hdf["source_id"] = hdf["source_id_x"]
        hdf["latitude"] = pd.to_numeric(hdf["latitude"],errors='coerce')
        hdf["longitude"] = pd.to_numeric(hdf["longitude"],errors='coerce')
        hdf["latitude"] = hdf["latitude"].round(3)
        hdf["longitude"] = hdf["longitude"].round(3)


        hdf = hdf[["report_id","region","sub_region","application_area",
                  "observing_programme","report_type","station_name",
                  "station_type","platform_type","platform_subtype","primary_station_id","station_record_number",
                  "primary_station_id_scheme","longitude","latitude","location_accuracy","location_method",
                  "location_quality","crs","station_speed","station_course",
                  "station_heading","height_of_station_above_local_ground",
                  "height_of_station_above_sea_level",
                  "height_of_station_above_sea_level_accuracy",
                  "sea_level_datum","report_meaning_of_timestamp","report_timestamp",
                  "report_duration","report_time_accuracy","report_time_quality",
                  "report_time_reference","profile_id","events_at_station","report_quality",
                  "duplicate_status","duplicates","record_timestamp","history",
                  "processing_level","processing_codes","source_id","source_record_id",
                  "primary_station_id_2", "duplicates_report"]]


        hdf=hdf.drop_duplicates(subset=['duplicates_report'])



        hdf = hdf[["report_id","region","sub_region","application_area",
                  "observing_programme","report_type","station_name",
                  "station_type","platform_type","platform_subtype","primary_station_id",
                  "station_record_number","primary_station_id_scheme",
                  "longitude","latitude","location_accuracy","location_method",
                  "location_quality","crs","station_speed","station_course",
                  "station_heading","height_of_station_above_local_ground",
                  "height_of_station_above_sea_level","height_of_station_above_sea_level_accuracy",
                  "sea_level_datum","report_meaning_of_timestamp","report_timestamp",
                  "report_duration","report_time_accuracy","report_time_quality",
                  "report_time_reference","profile_id","events_at_station","report_quality",
                  "duplicate_status","duplicates","record_timestamp","history",
                  "processing_level","processing_codes","source_id","source_record_id"]]

        hdf.sort_values("report_timestamp")
        hdf['report_id'] = hdf['report_id'].str.strip()

        hdf['region'] = hdf['region'].astype(str).apply(lambda x: x.replace('.0',''))
        hdf['sub_region'] = hdf['sub_region'].astype(str).apply(lambda x: x.replace('.0',''))


        try:
            df_lite_out.to_csv(cdmlite_outfile, index=False, sep="|", compression='infer')
            print(f"    {cdmlite_outfile}") 
        except IOError:
            print(f"Cannot save datafile: {cdmlite_outfile}")
            continue

        try:
            unique_variables = dfobs['observed_variable'].unique()
            print(unique_variables)
            dfobs.to_csv(cdmobs_outfile, index=False, sep="|", compression='infer')
            print(f"    {cdmobs_outfile}") 
        except IOError:
            print(f"Cannot save datafile: {cdmobs_outfile}")
            continue

        try: 
            hdf.to_csv(cdmhead_outfile, index=False, sep="|", compression='infer')
            print(f"    {cdmhead_outfile}") 
        except IOError:
            print(f"Cannot save datafile: {cdmhead_outfile}")
            continue
                          
                            
    #  to next file in the loop
                     
                  

    #    return # main

    #***************************************
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

            

        
        
