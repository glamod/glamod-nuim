# -*- coding: utf-8 -*-
"""
Convert daily csv files to CDM obs .psv files (one per station).

CDM Lite files have all variables, one after another.

Call in one of three ways using:

>python daily_to_obs_table_v1.py --station STATIONID
>python daily_to_obs_table_v1.py --subset FILENAME
>python daily_to_obs_table_v1.py --run_all
>python daily_to_obs_table_v1.py --help

Created on Thu Nov 11 16:31:58 2021

@author: snoone

Edited: rjhd2, February 2022
Edited snoone February 2022
Edited snoone 09/03/2022
"""

import os
import glob
import numpy as np
import pandas as pd
pd.options.mode.chained_assignment = None  # default='warn'
import utils
import daily_csv_to_cdm_utils as d_utils

# Set the file extension for the subdaily psv files
EXTENSION = 'csv.gz'

ORIGINAL_UNITS = {
    "SNWD" : "715",
    "PRCP" : "710",
    "TMIN" : "350",
    "TMAX" : "350",
    "TAVG" : "350",
    "SNOW" : "710",
    "AWND" : "320",
    "AWDR" : "731",
    "WESD" : "710",
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


def main(station="", subset="", run_all=False, clobber=False):
    """
    Run processing of daily csv to CDM Observations tables

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
    print(station)
    # Check for sensible inputs
    if station != "" and subset != "" and all:
        print("Please select either single station, list of stations run or to run all")
        return
    elif station == "" and subset == "" and not all:
        print("Please select either single station, list of stations run or to run all")
        return

    # Obtain list of station(s) to process (single/subset/all)
    all_filenames = utils.get_station_list_to_process(utils.DAILY_CSV_IN_DIR,
                                                      EXTENSION,
                                                      station=station,
                                                      subset=subset,
                                                      run_all=run_all,
                                                      )

            
    # Read in the data policy dataframe (only read in if needed)
    data_policy_df = pd.read_csv(utils.DAILY_STATION_RECORD_ENTRIES_OBS_LITE, encoding='latin-1')
    data_policy_df = data_policy_df.astype(str)

    # To start at begining of files
    for filename in all_filenames:
        print(f"Processing {filename}")

        # Read in the dataframe
        df = pd.read_csv(os.path.join(utils.DAILY_CSV_IN_DIR, filename), sep=",", low_memory=False, compression='gzip', header=None)

        # add column headers to df
        df.columns = ["Station_ID", "Date", "observed_variable", "observation_value", "quality_flag", "Measurement_flag", "Source_flag", "hour"]
        df = df.astype(str)

        # Set up the output filenames, and check if they exist
        station_id=df.iloc[1]["Station_ID"] # NOTE: this is renamed below to "primary_station_id"
        outroot_cdmobs = os.path.join(utils.DAILY_CDM_OBS_OUT_DIR, utils.DAILY_CDM_OBS_FILE_ROOT)
        cdmobs_outfile = f"{outroot_cdmobs}{station_id}.psv"

        # if not overwriting
        if not clobber:
            # and both output files exist
            if os.path.exists(cdmobs_outfile):
                print(f"   Output files for {filename} already exist:")
                print(f"     {cdmobs_outfile}")
                print("   Skipping to next station")
                
                continue #  to next file in the loop

        # Just retain the variables required
        df = df[df["observed_variable"].isin(d_utils.VARIABLE_NAMES)]


        # set the source_flag
        df["Source_flag"] = df["Source_flag"]. astype(str) 
        for source_flag, source_value in d_utils.SOURCE_FLAGS.items():
            df['Source_flag'] = df['Source_flag'].str.replace(source_flag, source_value)

        station_id = df.iloc[1]["Station_ID"]

        # set the value significance for each variable
        df["value_significance"] = "" 
        for obs_var, val_signif in d_utils.VALUE_SIGNIFICANCE.items():
            df.loc[df['observed_variable'] == obs_var, 'value_significance'] = val_signif


        # set the original values to cdm compliant values
        df["original_value"] = df["observation_value"]
        df["original_value"] = pd.to_numeric(df["original_value"], errors='coerce')
        for var_name in d_utils.VARIABLE_NAMES:
            df = d_utils.convert_values(df, var_name, "original_value", kelvin=False)

        # set the observation values to cdm compliant values
        df["observation_value"] = pd.to_numeric(df["observation_value"], errors='coerce')
        for var_name in d_utils.VARIABLE_NAMES:
            df = d_utils.convert_values(df, var_name, "observation_value", kelvin=True)


        # set the original units for each variable
        df["original_units"]=""
        for obs_var, unit in ORIGINAL_UNITS.items():
            df.loc[df['observed_variable'] == obs_var, 'original_units'] = unit

        # set the units for each variable
        df["units"] = ""
        for obs_var, unit in d_utils.UNITS.items():
            df.loc[df['observed_variable'] == obs_var, 'units'] = unit


        # set each height above station surface for each variable
        df["observation_height_above_station_surface"] = ""
        for obs_var, height in d_utils.HEIGHTS.items():
            df.loc[df['observed_variable'] == obs_var, 'observation_height_above_station_surface'] = height

        # set conversion flags for variables
        df["conversion_flag"] = ""
        for obs_var, conv_flag in CONVERSION_FLAGS.items():
            df.loc[df['observed_variable'] == obs_var, 'conversion_flag'] = conv_flag

        # set conversion method for variables
        df["conversion_method"] = ""
        df.loc[df['observed_variable'] == "TMIN", 'conversion_method'] = '1' 
        df.loc[df['observed_variable'] == "TMAX", 'conversion_method'] = '1' 
        df.loc[df['observed_variable'] == "TAVG", 'conversion_method'] = '1' 
        
        # set numerical precision for variables
        df["numerical_precision"]=""
        for obs_var, num_prec in NUMERICAL_PRECISION.items():
            df.loc[df['observed_variable'] == obs_var, 'numerical_precision'] = num_prec

        df["original_precision"]=""
        for obs_var, orig_prec in ORIGINAL_PRECISION.items():
            df.loc[df['observed_variable'] == obs_var, 'original_precision'] = orig_prec

        # replace observed variable name by appropriate ID
        for obs_var, var_id in d_utils.VARIABLE_ID.items():
            df['observed_variable'] = df['observed_variable'].str.replace(obs_var, var_id)


        # add all columns for cdmlite
        df['year'] = df['Date'].str[:4]
        df['month'] = df['Date'].map(lambda x: x[4:6])
        df['day'] = df['Date'].map(lambda x: x[6:8])
        df["hour"] = "00"
        df["Minute"] = "00"
        df["report_type"] = "3"
        df["source_id"] = df["Source_flag"]
        df["date_time_meaning"] = "1"
        df["observation_duration"] = "13"
        df["platform_type"] = ""
        df["station_type"] = "1"
        df["observation_id"] = ""
        df["data_policy_licence"] = ""
        df["primary_station_id"] = df["Station_ID"]
        df["qc_method"] = df["quality_flag"].astype(str)
        df["quality_flag"] = df["quality_flag"].astype(str)
        df["crs"] = ""
        df["z_coordinate"] = ""
        df["z_coordinate_type"] = ""
        df["secondary_variable"] = ""
        df["secondary_value"] = ""
        df["code_table"] = ""
        df["sensor_id"] = ""
        df["sensor_automation_status"] = ""
        df["exposure_of_sensor"] = ""
        df["processing_code"] = ""
        df["processing_level"] = "0"
        df["adjustment_id"] = ""
        df["traceability"] = ""
        df["advanced_qc"] = ""
        df["advanced_uncertainty"] = ""
        df["advanced_homogenisation"] = ""
        df["advanced_assimilation_feedback"] = ""
        df["source_record_id"] = ""
        df["location_method"] = ""
        df["location_precision"] = ""
        df["z_coordinate_method"] = ""
        df["bbox_min_longitude"] = ""
        df["bbox_max_longitude"] = ""
        df["bbox_min_latitude"] = ""
        df["bbox_max_latitude"] = ""
        df["spatial_representativeness"] = ""
        df["original_code_table"] = ""
        df["report_id"] = ""



        # set quality flag to pass 0 or fail 1
        #    loop allows for option to include more information in future
        df.quality_flag[df.quality_flag == "nan"] = "0"
        for flag, new_flag in d_utils.QUALITY_FLAGS.items():
            df.quality_flag = df.quality_flag.str.replace(flag, new_flag)
        df.quality_flag[df.quality_flag == "nan"] = "0"
    

        # add timestamp to df and create report id
        df["Timestamp2"] = df["year"].map(str) + "-" + df["month"].map(str) + "-" + df["day"].map(str)  
        df["Seconds"] = "00"
        df["offset"] = "+00"
        df["date_time"] = df["Timestamp2"].map(str) + " " + df["hour"].map(str) + ":" +\
                          df["Minute"].map(str) + ":" + df["Seconds"].map(str) 
        df.date_time = df.date_time + '+00'
        df["dates"] = df["date_time"].str[:-12]

        df['primary_station_id_2'] = df['primary_station_id'].astype(str) + '-' + df['source_id'].astype(str)

        df = df.astype(str)  
                                     
        # Concatenate columns for joining dataframe in next step
        df['source_id'] = df['source_id'].astype(str).apply(lambda x: x.replace('.0',''))
        df['primary_station_id_2']=df['primary_station_id'].astype(str)+'-'+df['source_id'].astype(str)
        df['primary_station_id_2'] = df['primary_station_id_2'].astype(str)
        df["observation_value"] = pd.to_numeric(df["observation_value"],errors='coerce')

        # add data policy information
        df = d_utils.add_data_policy(df, data_policy_df)
        
        # Remove NAs
        df = df.fillna("null")
        df = df.replace({"null":""})

        # sort out the locational metadata
        df["latitude"] = pd.to_numeric(df["latitude"],errors='coerce')
        df["longitude"] = pd.to_numeric(df["longitude"],errors='coerce')
        df["latitude"] = df["latitude"].round(3)
        df["longitude"] = df["longitude"].round(3)

        # add observation id to dataframe
        df['observation_id'] = df['primary_station_id'].astype(str) + '-' + df['record_number'].astype(str) + '-' + df['dates'].astype(str)
        df['observation_id'] = df['observation_id'].str.replace(r' ', '-')
        df["observation_id"] = df["observation_id"] + '-' + df['observed_variable'] + '-' + df['value_significance']
        df['report_id'] = df['primary_station_id'].astype(str) + '-' + df['record_number'].astype(str) + '-' + df['dates'].astype(str)

        # reorder df columns
        df = df[["observation_id","report_id","data_policy_licence","date_time",
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

        # Write the output files
        try:
            unique_variables = df['observed_variable'].unique()
            print(unique_variables)

            df.to_csv(cdmobs_outfile, index=False, sep="|")
            print(f"    {cdmobs_outfile}")
            print("Done")
        except IOError:
            # something wrong with file paths, despite checking
            print(f"Cannot save datafile: {cdmlite_outfile}")
        except RuntimeError:
            print("Runtime error")
        # TODO add logging for these errors



#    return # main

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



     
   

