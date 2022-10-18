#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Convert QFF files to CDM obs .psv files (one per station).

CDM obs files have all variables, one after another.

Call in one of three ways using:

>python hourly_qff_to_cdm_obs_v1.py --station STATIONID
>python hourly_qff_to_cdm_obs_v1.py --subset FILENAME
>python hourly_qff_to_cdm_obs_v1.py --run_all
>python hourly_qff_to_cdm_obs_v1.py --help
#Created on Thu Nov 11 16:31:58 2021

@author: snoone

edited: snoone, February 2022
"""

import os
import glob
import pandas as pd
pd.options.mode.chained_assignment = None  # default='warn'
import utils
import hourly_qff_to_cdm_utils as h_utils

# Set the file extension for the subdaily psv files
IN_EXTENSION = ".qff"
OUT_EXTENSION = ".psv"
IN_COMPRESSION = ""
OUT_COMPRESSION = ".gz"


INITIAL_COLUMNS = ["observation_id","report_id","data_policy_licence","date_time",
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
                   "advanced_assimilation_feedback","source_id","primary_station_id","secondary_id"]

FINAL_COLUMNS = ["observation_id","report_id","data_policy_licence","date_time",
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
                   "advanced_assimilation_feedback","source_id"]

CONVERSION_FLAGS = {
    "temperature" : "0",
    "dew_point_temperature" : "0",
    "station_level_pressure" : "0",
    "sea_level_pressure" : "0",
    "wind_direction" : "1",
    "wind_speed" : "2",
}
CONVERSION_METHODS = {
    "temperature" : "1",
    "dew_point_temperature" : "1",
    "station_level_pressure" : "7",
    "sea_level_pressure" : "7",
    "wind_direction" : "",
    "wind_speed" : "",
}
NUMERICAL_PRECISION = {
    "temperature" : "0.01",
    "dew_point_temperature" : "0.01",
    "station_level_pressure" : "10",
    "sea_level_pressure" : "10",
    "wind_direction" : "1",
    "wind_speed" : "0.1",
}
ORIGINAL_PRECISION = {
    "temperature" : "0.1",
    "dew_point_temperature" : "0.1",
    "station_level_pressure" : "0.1",
    "sea_level_pressure" : "0.1",
    "wind_direction" : "1",
    "wind_speed" : "0.1",
}
ORIGINAL_UNITS = {
    "temperature" : "60",
    "dew_point_temperature" : "60",
    "station_level_pressure" : "530",
    "sea_level_pressure" : "530",
    "wind_direction" : "110",
    "wind_speed" : "731",
}

def overwrite_conversion_precision_info(var_frame, var_name):
    """
    Replace information for variable with CDM codes

    var_frame : `dataframe`
        Dataframe for variable

    var_name : `str`
        Name of variable
    """

    var_frame["conversion_flag"] = CONVERSION_FLAGS[var_name]
    var_frame["conversion_method"] = CONVERSION_METHODS[var_name]
    var_frame["numerical_precision"] = NUMERICAL_PRECISION[var_name]
    var_frame["original_precision"] = ORIGINAL_PRECISION[var_name]
    var_frame["original_units"] = ORIGINAL_UNITS[var_name]
   
    return var_frame



def main(station="", subset="", run_all=False, clobber=False):
    """
    Run processing of hourly QFF to CDM obs

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
    data_policy_df = pd.read_csv(utils.SUBDAILY_STATION_RECORD_ENTRIES_OBS_LITE, encoding='latin-1')
    data_policy_df = data_policy_df.astype(str)

    # To start at begining of files
    for filename in all_filenames:

        if not os.path.exists(filename):
            print("Input {} file missing: {}".format(IN_EXTENSION, filename))
            continue
        else:
            print("Processing {}".format(filename))

        # Read in the dataframe
        df = pd.read_csv(filename, sep="|", low_memory=False, compression="infer")
        
        if df.shape[0] == 0:
            print(f"No data in file: {filename}")
            continue

        # Set up the output filenames, and check if they exist
        station_id = df.iloc[0]["Station_ID"] # NOTE: this is renamed below to "primary_station_id"
        outroot_cdmobs = os.path.join(utils.SUBDAILY_CDM_OBS_OUT_DIR, utils.SUBDAILY_CDM_OBS_FILE_ROOT)
        cdmobs_outfile = f"{outroot_cdmobs}{station_id}{OUT_EXTENSION}{OUT_COMPRESSION}"

        # if not overwriting
        if not clobber:
            # and both output files exist
            if os.path.exists(cdmobs_outfile):
                print(f"   Output files for {filename} already exist:")
                print(f"     {cdmobs_outfile}")
                print("   Skipping to next station")  
                continue
            #  to next file in the loop

 
        # Set up master df to extract each variable
        #  Globally set some entries to 
        df["report_id"] = ""
        df["observation_id"] = ""
        df["data_policy_licence"] = ""
        df["date_time_meaning"] = "1"
        df["observation_duration"] = "0"
        df["latitude"] = df["Latitude"]
        df["longitude"] = df["Longitude"]
        df["crs"] = ""
        df["z_coordinate"] = ""
        df["z_coordinate_type"] = ""
        df["observation_height_above_station_surface"] = ""
        df["observed_variable"] = ""  
        df["secondary_variable"] = ""
        df["observation_value"] = ""
        df["value_significance"] = "12" 
        df["secondary_value"] = ""
        df["units"] = ""
        df["code_table"] = ""
        df["conversion_flag"] = ""
        df["location_method"] = ""
        df["location_precision"] = ""
        df["z_coordinate_method"] = ""
        df["bbox_min_longitude"] = ""
        df["bbox_max_longitude"] = ""
        df["bbox_min_latitude"] = ""
        df["bbox_max_latitude"] = ""
        df["spatial_representativeness"] = ""
        df["original_code_table"] = ""
        df["quality_flag"] = ""
        df["numerical_precision"] = ""
        df["sensor_id"] = ""
        df["sensor_automation_status"] = ""
        df["exposure_of_sensor"] = ""
        df["original_precision"] = ""
        df["original_units"] = ""
        df["original_code_table"] = ""
        df["original_value"] = ""
        df["conversion_method"] = ""
        df["processing_code"] = ""
        df["processing_level"] = "0"
        df["adjustment_id"] = ""
        df["traceability"] = ""
        df["advanced_qc"] = ""
        df["advanced_uncertainty"] = ""
        df["advanced_homogenisation"] = ""
        df["advanced_assimilation_feedback"] = ""
        df["secondary_id"] = ""  
        df["source_id"] = ""
        df["source_record_id"] = ""
        df["primary_station_id"] = df["Station_ID"]
        df["Timestamp2"] = df["Year"].map(str) + "-" +\
            df["Month"].map(str) + "-" +\
            df["Day"].map(str)
        df["Seconds"] = "00"
        df["offset"] = "+00"
        df["date_time"] = df["Timestamp2"].map(str) + " " + \
            df["Hour"].map(str) + ":" + \
            df["Minute"].map(str) + ":" + \
            df["Seconds"].map(str)
        df['date_time'] = pd.to_datetime(df['date_time'], format="%Y/%m/%d %H:%M:%S")
        df['date_time'] = df['date_time'].dt.strftime("%Y-%m-%d %H:%M:%S")
        df.date_time = df.date_time + '+00'


        # =========================================================================================
        # convert temperature changes for each variable    
        dft = df[INITIAL_COLUMNS]

        # change for each variable to convert to cdm compliant values
        dft["observation_value"] = df["temperature"] + 273.15
        dft["original_value"] = df["temperature"]

        dft = h_utils.construct_extra_ids(dft, df, "temperature")

        dft = overwrite_conversion_precision_info(dft, "temperature")
        
        # Extract QC information
        dft = h_utils.extract_qc_info(dft, df, "temperature")

        # Change for each variable if required
        dft = h_utils.overwrite_variable_info(dft, "temperature")

        # remove unwanted mising data rows
        dft = h_utils.remove_missing_data_rows(dft, "temperature")

        # concatenate columns for joining df for next step
        dft['source_id'] = dft['source_id'].astype(str).apply(lambda x: x.replace('.0', ''))
        dft['primary_station_id_2'] = dft['secondary_id'].astype(str) + '-' + dft['source_id'].astype(str)
        dft["observation_value"] = pd.to_numeric(dft["observation_value"], errors='coerce')

        # add data policy and record number to df
        dft = h_utils.add_data_policy(dft, data_policy_df)

        # Create observation_id field
        dft = h_utils.construct_obs_id(dft)
        
        dft["report_id"] = dft["observation_id"].str[:-6]

        dft = dft[FINAL_COLUMNS]
        
        df.dropna(subset = ["observation_value"], inplace=True)

        # Ensure correct number of decimal places
        dft = h_utils.fix_decimal_places(dft, do_obs_value=True)


        # =================================================================================
        # convert dew point temperature changes for each variable    
        dfdpt = df[INITIAL_COLUMNS]

        # change for each variable to convert to cdm compliant values
        dfdpt["observation_value"] = df["dew_point_temperature"] + 273.15
        dfdpt["original_value"] = df["dew_point_temperature"]

        dfdpt = h_utils.construct_extra_ids(dfdpt, df, "dew_point_temperature")

        dfdpt = overwrite_conversion_precision_info(dfdpt, "dew_point_temperature")

        # Extract QC information
        dfdpt = h_utils.extract_qc_info(dfdpt, df, "dew_point_temperature")

        # Change for each variable if required
        dfdpt = h_utils.overwrite_variable_info(dfdpt, "dew_point_temperature")

        # remove unwanted mising data rows
        dfdpt = h_utils.remove_missing_data_rows(dfdpt, "dew_point_temperature")

        # concatenate columns for joining df for next step
        dfdpt['source_id'] = dfdpt['source_id'].astype(str).apply(lambda x: x.replace('.0', ''))
        dfdpt['primary_station_id_2'] = dfdpt['secondary_id'].astype(str) + '-' + dfdpt['source_id'].astype(str)
        dfdpt["observation_value"] = pd.to_numeric(dfdpt["observation_value"], errors='coerce')

        # add data policy and record number to df
        dfdpt = h_utils.add_data_policy(dfdpt, data_policy_df)

        # Create observation_id field
        dfdpt = h_utils.construct_obs_id(dfdpt)

        dfdpt["report_id"] = dfdpt["observation_id"].str[:-6]

        dfdpt= dfdpt[FINAL_COLUMNS]
        
        dfdpt.dropna(subset = ["observation_value"], inplace=True)
 
        # Ensure correct number of decimal places
        dfdpt = h_utils.fix_decimal_places(dfdpt, do_obs_value=True)


        # ====================================================================================
        # convert station level pressure

        dfslp = df[INITIAL_COLUMNS]

        # change for each variable to convert to cdm compliant values
        dfslp["observation_value"] = df["station_level_pressure"].map(float)
        dfslp["original_value"] = df["station_level_pressure"]

        dfslp = h_utils.construct_extra_ids(dfslp, df, "station_level_pressure")

        dfslp = overwrite_conversion_precision_info(dfslp, "station_level_pressure")
        
        # Extract QC information
        dfslp = h_utils.extract_qc_info(dfslp, df, "station_level_pressure")

        # Change for each variable if required
        dfslp = h_utils.overwrite_variable_info(dfslp, "station_level_pressure")

        # remove unwanted mising data rows
        dfslp = h_utils.remove_missing_data_rows(dfslp, "station_level_pressure")
        
        # concatenate columns for joining df for next step
        dfslp['source_id'] = dfslp['source_id'].astype(str).apply(lambda x: x.replace('.0', ''))
        dfslp['primary_station_id_2'] = dfslp['secondary_id'].astype(str) + '-' + dfslp['source_id'].astype(str)

        # add data policy and record number to df
        dfslp = h_utils.add_data_policy(dfslp, data_policy_df)

        # Create observation_id field
        dfslp = h_utils.construct_obs_id(dfslp)
        
        dfslp["report_id"] = dfslp["observation_id"].str[:-6]

        dfslp = dfslp[FINAL_COLUMNS]

        dfslp.dropna(subset = ["observation_value"], inplace=True)

        null_index = dfslp[dfslp['observation_value'] == "Null"].index
        dfslp = dfslp.drop(index=null_index)
        dfslp['observation_value'] = dfslp['observation_value'].map(float)
        dfslp['observation_value'] = (dfslp['observation_value']*100)
        dfslp['observation_value'] = dfslp['observation_value'].map(int)

        # Ensure correct number of decimal places
        dfslp = h_utils.fix_decimal_places(dfslp, do_obs_value=True)


        # ===========================================================================================
        # convert sea level presure 

        dfmslp = df[INITIAL_COLUMNS]

        # change for each variable to convert to cdm compliant values
        dfmslp["observation_value"] = df["sea_level_pressure"].map(float)
        dfmslp["original_value"] = df["sea_level_pressure"]
        
        dfmslp = h_utils.construct_extra_ids(dfmslp, df, "sea_level_pressure")

        dfmslp = overwrite_conversion_precision_info(dfmslp, "sea_level_pressure")
        
        # Extract QC information
        dfmslp = h_utils.extract_qc_info(dfmslp, df, "sea_level_pressure")

        # Change for each variable if required
        dfmslp = h_utils.overwrite_variable_info(dfmslp, "sea_level_pressure")

        # remove unwanted mising data rows
        dfmslp = h_utils.remove_missing_data_rows(dfmslp, "sea_level_pressure")

        # concatenate columns for joining df for next step
        dfmslp['source_id'] = dfmslp['source_id'].astype(str).apply(lambda x: x.replace('.0', ''))
        dfmslp['primary_station_id_2'] = dfmslp['secondary_id'].astype(str) + '-' + dfmslp['source_id'].astype(str)

        # add data policy and record number to df
        dfmslp = h_utils.add_data_policy(dfmslp, data_policy_df)

        # Create observation_id field
        dfmslp = h_utils.construct_obs_id(dfmslp)
        
        dfmslp["report_id"] = dfmslp["observation_id"].str[:-6]

        dfmslp = dfmslp[FINAL_COLUMNS]

        dfmslp.dropna(subset = ["observation_value"], inplace=True) 
        null_index = dfmslp[dfmslp['observation_value'] == "Null"].index
        dfmslp = dfmslp.drop(index=null_index)
        dfmslp['observation_value'] = dfmslp['observation_value'].map(float)
        dfmslp['observation_value'] = (dfmslp['observation_value']*100)
        dfmslp['observation_value'] = dfmslp['observation_value'].map(int)

        # Ensure correct number of decimal places
        dfmslp = h_utils.fix_decimal_places(dfmslp, do_obs_value=True)
        

        # ===========================================================================
        # convert wind direction

        dfwd = df[INITIAL_COLUMNS]

        # change for each variable to convert to cdm compliant values
        dfwd["observation_value"] = df["wind_direction"]
        dfwd["original_value"] = df["wind_direction"]

        dfwd = h_utils.construct_extra_ids(dfwd, df, "wind_direction")

        dfwd = overwrite_conversion_precision_info(dfwd, "wind_direction")
        
        # Extract QC information
        dfwd = h_utils.extract_qc_info(dfwd, df, "wind_direction")

        # Change for each variable if required
        dfwd = h_utils.overwrite_variable_info(dfwd, "wind_direction")

        # remove unwanted mising data rows
        dfwd = h_utils.remove_missing_data_rows(dfwd, "wind_direction")

        # concatenate columns for joining df for next step
        dfwd['source_id'] = dfwd['source_id'].astype(str).apply(lambda x: x.replace('.0', ''))
        dfwd['primary_station_id_2'] = dfwd['secondary_id'].astype(str) + '-' + dfwd['source_id'].astype(str)
        dfwd["observation_value"] = pd.to_numeric(dfwd["observation_value"], errors='coerce')

        # add data policy and record number to df
        dfwd = h_utils.add_data_policy(dfwd, data_policy_df)

        # Create observation_id field
        dfwd = h_utils.construct_obs_id(dfwd)

        dfwd["report_id"] = dfwd["observation_id"].str[:-7] # WD is 3 digits

        dfwd = dfwd[FINAL_COLUMNS]

        # make sure no decimal places an dround value to reuqred decimal places
        dfwd.dropna(subset = ["observation_value"], inplace=True)
 
        # Ensure correct number of decimal places
        dfwd['observation_value'] = dfwd['observation_value'].astype(str).apply(lambda x: x.replace('.0', ''))
        dfwd = h_utils.fix_decimal_places(dfwd, do_obs_value=False)

        
        # ===========================================================================
        # convert wind speed

        dfws = df[INITIAL_COLUMNS]

        # change for each variable to convert to cdm compliant values
        dfws["secondary_id"]=df["wind_speed_Source_Station_ID"].astype(str)
        dfws['secondary_id'] = dfws['secondary_id'].astype(str).apply(lambda x: x.replace('.0', ''))

        dfws = h_utils.construct_extra_ids(dfws, df, "wind_speed")

        dfws = overwrite_conversion_precision_info(dfws, "wind_speed")
        
        # Extract QC information
        dfws = h_utils.extract_qc_info(dfws, df, "wind_speed")

        # Change for each variable if required
        dfws = h_utils.overwrite_variable_info(dfws, "wind_speed")

        # remove unwanted mising data rows
        dfws = h_utils.remove_missing_data_rows(dfws, "wind_speed")

        # concatenate columns for joining df for next step
        dfws['source_id'] = dfws['source_id'].astype(str).apply(lambda x: x.replace('.0', ''))
        dfws['primary_station_id_2']=dfws['secondary_id'].astype(str) + '-' + dfws['source_id'].astype(str)
        dfws["observation_value"] = pd.to_numeric(dfws["observation_value"], errors='coerce')

        # add data policy and record number to df
        dfws = h_utils.add_data_policy(dfws, data_policy_df)

        # Create observation_id field
        dfws = h_utils.construct_obs_id(dfws)
        
        dfws["report_id"] = dfws["observation_id"].str[:-7] # WS is 3 digits

        dfws = dfws[FINAL_COLUMNS]

        dfws.dropna(subset = ["observation_value"], inplace=True)

        # Ensure correct number of decimal places
        dfws = h_utils.fix_decimal_places(dfws, do_obs_value=True)

        # =================================================================================
        # Merge all dataframes into one CDMlite frame
        merged_df = pd.concat([dfdpt,dft,dfslp,dfmslp,dfwd,dfws], axis=0)
        del dfdpt
        del dft
        del dfslp
        del dfmslp
        del dfwd
        del dfws

        if merged_df.shape[0] == 0:
            print(f"No data in merged CDM Obs file for: {filename}")
            continue

        # Sort by date/times and fix metadata
        merged_df.sort_values("date_time", inplace=True)
        merged_df["latitude"] = pd.to_numeric(merged_df["latitude"],errors='coerce')
        merged_df["longitude"] = pd.to_numeric(merged_df["longitude"],errors='coerce')
        merged_df["latitude"] = merged_df["latitude"].round(3)
        merged_df["longitude"] = merged_df["longitude"].round(3)

        # Save CDM obs table to directory
        try:
            unique_variables = merged_df['observed_variable'].unique()
            print(unique_variables)
            merged_df.to_csv(cdmobs_outfile, index=False, sep="|", compression="infer")
            print(f"    {cdmobs_outfile}")
            
        except IOError:
            # something wrong with file paths, despite checking
            print(f"Cannot save datafile: {cdmlite_outfile}")
        except RuntimeError:
            print("Runtime error")
        # TODO add logging for these errors

        #  to next file in the loop


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
    
    
    
    
    
    
    

