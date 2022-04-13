# -*- coding: utf-8 -*-
"""
Convert daily csv files to CDM Lite .psv files (one per station).

CDM Lite files have all variables, one after another.

Call in one of three ways using:

>python daily_to_cdm_lite_v1.py --station STATIONID
>python daily_to_cdm_lite_v1.py --subset FILENAME
>python daily_to_cdm_lite_v1.py --run_all
>python daily_to_cdm_lite_v1.py --help

Created on Thu Nov 11 16:31:58 2021

@author: snoone

Edited: rjhd2, February 2022
Edited snoone February 2022
"""

import os
import glob
import pandas as pd
import numpy as np
pd.options.mode.chained_assignment = None  # default='warn'
import utils
import daily_csv_to_cdm_utils as d_utils

# Set the file extension for the subdaily psv files
IN_EXTENSION = ".csv"
OUT_EXTENSION = ".psv"
COMPRESSION = ".gz"

QC_METHODS = {
        "D" : "16,",
        "H" : "30,",
        "G" : "17,",
        "I" : "18,",
        "K" : "19,",
        "M" : "20,",
        "N" : "22,",
        "O" : "23,",
        "R" : "24,",
        "S" : "25,",
        "T" : "26,",
        "W" : "27,",
        "X" : "28,",
        "V" : "12,",
        "Z" : "29,",
        "P" : "30,",

}

def main(station="", subset="", run_all=False, clobber=False):
    """
    Run processing of daily csv to CDM lite & QC tables

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

    gzip : `bool`
        Do not expect or output compressed files 
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
                                                      f"{IN_EXTENSION}{COMPRESSION}",
                                                      station=station,
                                                      subset=subset,
                                                      run_all=run_all,
                                                      )

    # Read in the data policy dataframe (only read in if needed)
    data_policy_df = pd.read_csv(utils.DAILY_STATION_RECORD_ENTRIES_OBS_LITE, encoding='latin-1')
    data_policy_df = data_policy_df.astype(str)
              
    # To start at begining of files
    for filename in all_filenames:

        if not os.path.exists(filename):
            print("Input {} file missing: {}".format(IN_EXTENSION, filename))
            continue
        else:
            print("Processing {}".format(filename))

        # Read in the dataframe
        df = pd.read_csv(os.path.join(utils.DAILY_CSV_IN_DIR, filename), sep=",", low_memory=False, compression='infer', header=None)

        # add column headers to df
        df.columns=["Station_ID", "Date", "observed_variable", "observation_value","quality_flag","Measurement_flag","Source_flag","hour"]
        df = df.astype(str)

        # Set up the output filenames, and check if they exist
        station_id = df.iloc[1]["Station_ID"] # NOTE: this is renamed below to "primary_station_id"

        outroot_cdmlite = os.path.join(utils.DAILY_CDM_LITE_OUT_DIR, utils.DAILY_CDM_LITE_FILE_ROOT)
        cdmlite_outfile = f"{outroot_cdmlite}{station_id}{OUT_EXTENSION}{COMPRESSION}"

        outroot_qc= os.path.join(utils.DAILY_CDM_QC_OUT_DIR, utils.DAILY_QC_FILE_ROOT)
        qc_outfile = f"{outroot_qc}{station_id}{OUT_EXTENSION}{COMPRESSION}"

        # if not overwriting
        if not clobber:
            # and both output files exist
            if os.path.exists(cdmlite_outfile) and os.path.exists(qc_outfile):
                print(f"   Output files for {filename} already exist:")
                print(f"     {cdmlite_outfile}")
                print(f"     {qc_outfile}")
                print("   Skipping to next station")
                continue #  to next file in the loop

        # Just retain the variables required
        df = df[df["observed_variable"].isin(d_utils.VARIABLE_NAMES)]
        # TODO - add cross check to ensure that all are tested for in the various steps

        # set the source_flag
        df["Source_flag"] = df["Source_flag"]. astype(str) 
        for source_flag, source_value in d_utils.SOURCE_FLAGS.items():
            df['Source_flag'] = df['Source_flag'].str.replace(source_flag, source_value)

        # set the value significance for each variable
        df["value_significance"] = "" 
        for obs_var, val_signif in d_utils.VALUE_SIGNIFICANCE.items():
            df.loc[df['observed_variable'] == obs_var, 'value_significance'] = val_signif


        # SET OBSERVED VALUES TO CDM COMPLIANT values
        df["observation_value"] = pd.to_numeric(df["observation_value"], errors='coerce')
        for var_name in d_utils.VARIABLE_NAMES:
            df = d_utils.convert_values(df, var_name, "observation_value", kelvin=True)

        # set the units for each variable
        df["units"] = ""
        for obs_var, unit in d_utils.UNITS.items():
            df.loc[df['observed_variable'] == obs_var, 'units'] = unit

        # set each height above station surface for each variable
        df["observation_height_above_station_surface"] = ""
        for obs_var, height in d_utils.HEIGHTS.items():
            df.loc[df['observed_variable'] == obs_var, 'observation_height_above_station_surface'] = height

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

        # set quality flag to pass 0 or fail 1
        #    loop allows for option to include more information in future
        df.quality_flag[df.quality_flag == "nan"] = "0"
        for flag, new_flag in d_utils.QUALITY_FLAGS.items():
            df.quality_flag = df.quality_flag.str.replace(flag, new_flag)

        # add timestamp to df and create report id
        df["Timestamp2"] = df["year"].map(str) + "-" + df["month"].map(str)+ "-" + df["day"].map(str)  
        df["Seconds"] = "00"
        df["offset"] = "+00"
        df["date_time"] = df["Timestamp2"].map(str)+ " " + df["hour"].map(str) + ":" + \
                          df["Minute"].map(str)+":"+df["Seconds"].map(str) 
        df.date_time = df.date_time + '+00'
        df["report_id"] = df["date_time"]

        df = df.astype(str)                                       

        # Concatenate columns for joining dataframe in next step
        df['source_id'] = df['source_id'].astype(str).apply(lambda x: x.replace('.0', ''))
        df['primary_station_id_2'] = df['primary_station_id'].astype(str) + '-' + df['source_id'].astype(str)
        df['primary_station_id_2'] = df['primary_station_id_2'].astype(str)
        df["observation_value"] = pd.to_numeric(df["observation_value"], errors='coerce')

        # add data policy information
        df = d_utils.add_data_policy(df, data_policy_df)

        # Remove NAs
        df = df.fillna("null")
        df = df.replace({"null":""})    

        # sort out the locational metadata
        df["latitude"] = pd.to_numeric(df["latitude"], errors='coerce')
        df["longitude"] = pd.to_numeric(df["longitude"], errors='coerce')
        df["latitude"] = df["latitude"].round(3)
        df["longitude"] = df["longitude"].round(3)

        # add observation id to dataframe
        df["dates"] = ""
        df["dates"] = df["report_id"].str[:-11]
        df['observation_id'] = df['primary_station_id'].astype(str) + '-' +\
                               df['record_number'].astype(str) + '-' + df['dates'].astype(str)
        df['observation_id'] = df['observation_id'].str.replace(r' ', '-')
        df["observation_id"] = df["observation_id"] + '-' + df['observed_variable'] + '-' + df['value_significance']



        # extract QC table information   
        qct = df[["primary_station_id", "report_id", "record_number", "qc_method", "quality_flag", "observed_variable", "value_significance"]]

        qct = qct.astype(str)
        qct["dates"]=""
        qct["dates"]=qct["report_id"].str[:-11]
        # set the QC observation_id
        qct['observation_id'] = qct['primary_station_id'].astype(str) + '-' +\
                                qct['record_number'].astype(str) + '-' +\
                                qct['dates'].astype(str)
        qct['observation_id'] = qct['observation_id'].str.replace(r' ', '-')
        qct["observation_id"] = qct["observation_id"] + qct['observed_variable'] +\
                                '-' + qct['value_significance']

        # restrict to requried columns
        qct = qct[["report_id", "observation_id", "qc_method", "quality_flag"]]
        qct["quality_flag"] = pd.to_numeric(qct["quality_flag"], errors='coerce')
        qct.loc[qct['quality_flag'].notnull(), "quality_flag"] = 1
        qct = qct.fillna("Null")
        qct.quality_flag[qct.quality_flag == "Null"] = 0
        qct.astype(str)

        # replace observed variable name by appropriate code
        for qc_method, qc_code in QC_METHODS.items():
            qct['qc_method'] = qct['qc_method'].str.replace(qc_method, qc_code)

        qct = qct.fillna("null")
        qct = qct[qct.qc_method != ""]
        qct = qct[qct.qc_method != "nan"]
        qct = qct[qct.quality_flag != 0]
        # remove final comma
        qct['qc_method'] = qct['qc_method'].str[:-1]
        qct.dropna(subset = ["qc_method"], inplace=True)
        qct["quality_flag"] = qct["quality_flag"].astype(int)

        # reorder df columns
        df = df[["observation_id","report_type","date_time","date_time_meaning",
                  "latitude","longitude","observation_height_above_station_surface"
                  ,"observed_variable","units","observation_value",
                  "value_significance","observation_duration","platform_type",
                  "station_type","primary_station_id","station_name","quality_flag"
                  ,"data_policy_licence","source_id"]]

        # Write the output files
        try:
            # Save CDM lite table to directory
            unique_variables = df['observed_variable'].unique()
            print(unique_variables)
            df.sort_values("date_time", inplace=True)
            df.to_csv(cdmlite_outfile, index=False, sep="|", compression="infer")
            print(f"    {cdmlite_outfile}")
            
            # and the QC table
            qct.sort_values("report_id", inplace=True)
            qct['qc_method'] = qct['qc_method'].str[:-1]
            unique_qc_methods = qct['qc_method'].unique()
            print(unique_qc_methods)
            qct.to_csv(qc_outfile, index=False, sep="|", compression="infer")
            print(f"   {qc_outfile}")
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
      
        
                 
    

  
       
       
       
       
    
    
   

