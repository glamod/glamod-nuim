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
import pandas as pd
pd.options.mode.chained_assignment = None  # default='warn'
import utils
import numpy as np

# Set the file extension for the subdaily psv files
EXTENSION = 'csv'

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
    if station != "":
        print(f"Single station run: {station}")
        all_filenames = [os.path.join(utils.DAILY_CSV_IN_DIR, f"{station}.{EXTENSION}")]
    elif subset != "":
        print(f"Subset of stations run defined in: {subset}")
        # allows parrallelisation
        try:
            
            with open(subset, "r") as f:
                filenames = f.read().splitlines()

                # now add the path to the front
                all_filenames = []
                for infile in filenames:
                    all_filenames += [os.path.join(utils.DAILY_CSV_IN_DIR, f"{infile}")]

            print(f"   N = {len(all_filenames)}")
        except IOError:
            print(f"Subset file {subset} cannot be found")
            return
        except OSError:
            print(f"Subset file {subset} cannot be found")
            return
    elif all:
        print(f"All stations run in {utils.DAILY_CSV_IN_DIR}")
        all_filenames = [i for i in glob.glob(os.path.join(utils.DAILY_CSV_IN_DIR, f'*.{EXTENSION}'))]    
        print(f"   N = {len(all_filenames)}")
              
    # To start at begining of files
    for filename in all_filenames:
        print(f"Processing {filename}")

        # Read in the dataframe
        df=pd.read_csv(os.path.join(utils.DAILY_CSV_IN_DIR, filename), sep=",",low_memory=False)
        ##add column headers to df
        df.columns=["Station_ID", "Date", "observed_variable", "observation_value","quality_flag","Measurement_flag","Source_flag","hour"]
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

    df = df[df["observed_variable"].isin(["SNWD", "PRCP", "TMIN", "TMAX", "TAVG", "SNOW", "AWND", "AWDR", "WESD"])]
    df["Source_flag"]=df["Source_flag"]. astype(str) 
    df['Source_flag'] = df['Source_flag'].str.replace("0","c")
    df['Source_flag'] = df['Source_flag'].str.replace("6","n")
    df['Source_flag'] = df['Source_flag'].str.replace("7","t")
    df['Source_flag'] = df['Source_flag'].str.replace("A","224")
    df['Source_flag'] = df['Source_flag'].str.replace("c","161")
    df['Source_flag'] = df['Source_flag'].str.replace("n","162")
    df['Source_flag'] = df['Source_flag'].str.replace("t","120")
    df['Source_flag'] = df['Source_flag'].str.replace("A","224")
    df['Source_flag'] = df['Source_flag'].str.replace("a","225")
    df['Source_flag'] = df['Source_flag'].str.replace("B","159")
    df['Source_flag'] = df['Source_flag'].str.replace("b","226")
    df['Source_flag'] = df['Source_flag'].str.replace("C","227")
    df['Source_flag'] = df['Source_flag'].str.replace("D","228")
    df['Source_flag'] = df['Source_flag'].str.replace("E","229")
    df['Source_flag'] = df['Source_flag'].str.replace("F","230")
    df['Source_flag'] = df['Source_flag'].str.replace("G","231")
    df['Source_flag'] = df['Source_flag'].str.replace("H","160")
    df['Source_flag'] = df['Source_flag'].str.replace("I","232")
    df['Source_flag'] = df['Source_flag'].str.replace("K","233")
    df['Source_flag'] = df['Source_flag'].str.replace("M","234")
    df['Source_flag'] = df['Source_flag'].str.replace("N","235")
    df['Source_flag'] = df['Source_flag'].str.replace("Q","236")
    df['Source_flag'] = df['Source_flag'].str.replace("R","237")
    df['Source_flag'] = df['Source_flag'].str.replace("r","238")
    df['Source_flag'] = df['Source_flag'].str.replace("S","166")
    df['Source_flag'] = df['Source_flag'].str.replace("s","239")
    df['Source_flag'] = df['Source_flag'].str.replace("T","240")
    df['Source_flag'] = df['Source_flag'].str.replace("U","241")
    df['Source_flag'] = df['Source_flag'].str.replace("u","242")
    df['Source_flag'] = df['Source_flag'].str.replace("W","163")
    df['Source_flag'] = df['Source_flag'].str.replace("X","164")
    df['Source_flag'] = df['Source_flag'].str.replace("Z","165")
    df['Source_flag'] = df['Source_flag'].str.replace("z","243")
    df['Source_flag'] = df['Source_flag'].str.replace("m","196")
    
    
    station_id=df.iloc[1]["Station_ID"]
    
    # set the value significnace for each variable
    df["value_significance"]="" 
    df['observed_variable'] = df['observed_variable'].str.replace("SNWD","53")
    df.loc[df['observed_variable'] == "53", 'value_significance'] = '13'
    df['observed_variable'] = df['observed_variable'].str.replace("PRCP","44")
    df.loc[df['observed_variable'] == "44", 'value_significance'] = "13" 
    df.loc[df['observed_variable'] == "TMIN", 'value_significance'] = '1'
    df['observed_variable'] = df['observed_variable'].str.replace("TMIN","85")
    df.loc[df['observed_variable'] == "TMAX", 'value_significance'] = '0'
    df['observed_variable'] = df['observed_variable'].str.replace("TMAX","85")
    df.loc[df['observed_variable'] == "TAVG", 'value_significance'] = '2'
    df['observed_variable'] = df['observed_variable'].str.replace("TAVG","85")
    df['observed_variable'] = df['observed_variable'].str.replace("SNOW","45")
    df.loc[df['observed_variable'] == "45", 'value_significance'] = '13'
    df['observed_variable'] = df['observed_variable'].str.replace("AWND","107")
    df.loc[df['observed_variable'] == "107", 'value_significance'] = '2'
    df['observed_variable'] = df['observed_variable'].str.replace("AWDR","106")
    df.loc[df['observed_variable'] == "106", 'value_significance'] = '2'
    df['observed_variable'] = df['observed_variable'].str.replace("WESD","55")
    df.loc[df['observed_variable'] == "55", 'value_significance'] = '13' 
    
    
    df["observation_value"] = pd.to_numeric(df["observation_value"],errors='coerce')
    df["original_value"]=df["observation_value"]
    df['original_value'] = np.where(df['observed_variable'] == "44",
                                           df['original_value'] / 10,
                                           df['original_value']).round(2)
    df['original_value'] = np.where(df['observed_variable'] == "53",
                                           df['original_value'] / 10,
                                           df['original_value']).round(2)
    df['original_value'] = np.where(df['observed_variable'] == "85",
                                           df['original_value'] / 10,
                                           df['original_value']).round(2)
    df["original_value"] = np.where(df['observed_variable'] == '45',
                                           df['original_value'] / 10,
                                           df['original_value']).round(2)
    df['original_value'] = np.where(df['observed_variable'] == '55',
                                           df['original_value'] / 10,
                                           df['original_value']).round(2)
    
    # set the observation values to cdm compliant values
    df["observation_value"] = pd.to_numeric(df["observation_value"],errors='coerce')
    df['observation_value'] = np.where(df['observed_variable'] == "44",
                                           df['observation_value'] / 10,
                                           df['observation_value']).round(2)
    df['observation_value'] = np.where(df['observed_variable'] == "53",
                                           df['observation_value'] / 10,
                                           df['observation_value']).round(2)
    df['observation_value'] = np.where(df['observed_variable'] == "85",
                                           df['observation_value'] / 10 + 273.15,
                                           df['observation_value']).round(2)
    df['observation_value'] = np.where(df['observed_variable'] == '45',
                                           df['observation_value'] / 10,
                                           df['observation_value']).round(2)
    df['observation_value'] = np.where(df['observed_variable'] == '55',
                                           df['observation_value'] / 10,
                                           df['observation_value']).round(2)
    df['observation_value'] = np.where(df['observed_variable'] == '107',
                                           df['observation_value'] / 10,
                                           df['observation_value']).round(2)
  
    
    
    # set the units for each variable
    df["original_units"]=""
    df.loc[df['observed_variable'] == "85", 'original_units'] = '350' 
    df.loc[df['observed_variable'] == "44", 'original_units'] = '710'
    df.loc[df['observed_variable'] == "45", 'original_units'] = '710'
    df.loc[df['observed_variable'] == "55", 'original_units'] = '710' 
    df.loc[df['observed_variable'] == "106", 'original_units'] = '731' 
    df.loc[df['observed_variable'] == "107", 'original_units'] = "320"
    df.loc[df['observed_variable'] == "53", 'original_units'] = '715'
        
    # set the original units for each variable
    df["units"]=""
    df.loc[df['observed_variable'] == "85", 'units'] = '5' 
    df.loc[df['observed_variable'] == "44", 'units'] = '710'
    df.loc[df['observed_variable'] == "45", 'units'] = '710'
    df.loc[df['observed_variable'] == "55", 'units'] = '710' 
    df.loc[df['observed_variable'] == "106", 'units'] = '731' 
    df.loc[df['observed_variable'] == "107", 'units'] = "320"
    df.loc[df['observed_variable'] == "53", 'units'] = '715'

             
    # set each height above station surface for each variable
    df["observation_height_above_station_surface"]=""
    df.loc[df['observed_variable'] == "85", 'observation_height_above_station_surface'] = '2' 
    df.loc[df['observed_variable'] == "44", 'observation_height_above_station_surface'] = '1'
    df.loc[df['observed_variable'] == "45", 'observation_height_above_station_surface'] = '1'
    df.loc[df['observed_variable'] == "55", 'observation_height_above_station_surface'] = '1' 
    df.loc[df['observed_variable'] == "106", 'observation_height_above_station_surface'] = '10' 
    df.loc[df['observed_variable'] == "107", 'observation_height_above_station_surface'] = "10"
    df.loc[df['observed_variable'] == "53", 'observation_height_above_station_surface'] = "1"
    
    # set conversion flags for variables
    df["conversion_flag"]=""
    df.loc[df['observed_variable'] == "85", 'conversion_flag'] = '0' 
    df.loc[df['observed_variable'] == "44", 'conversion_flag'] = '2'
    df.loc[df['observed_variable'] == "45", 'conversion_flag'] = '2'
    df.loc[df['observed_variable'] == "55", 'conversion_flag'] = '2' 
    df.loc[df['observed_variable'] == "106", 'conversion_flag'] = '2' 
    df.loc[df['observed_variable'] == "107", 'conversion_flag'] = "2"
    df.loc[df['observed_variable'] == "53", 'conversion_flag'] = "2"
    
    # set conversion method for variables
    df["conversion_method"]=""
    df.loc[df['observed_variable'] == "85", 'conversion_method'] = '1' 
    
    
    # set numerical precision for variables
    df["numerical_precision"]=""
    df.loc[df['observed_variable'] == "85", 'numerical_precision'] = '0.01' 
    df.loc[df['observed_variable'] == "44", 'numerical_precision'] = '0.1'
    df.loc[df['observed_variable'] == "45", 'numerical_precision'] = '0.1'
    df.loc[df['observed_variable'] == "55", 'numerical_precision'] = '0.1' 
    df.loc[df['observed_variable'] == "106", 'numerical_precision'] = '0.1' 
    df.loc[df['observed_variable'] == "107", 'numerical_precision'] = "0.1"
    df.loc[df['observed_variable'] == "53", 'numerical_precision'] = "1"
    df["original_precision"]=""
    df.loc[df['observed_variable'] == "85", 'original_precision'] = '0.1' 
    df.loc[df['observed_variable'] == "44", 'original_precision'] = '0.1'
    df.loc[df['observed_variable'] == "45", 'original_precision'] = '0.1'
    df.loc[df['observed_variable'] == "55", "original_precision"] = '0.1' 
    df.loc[df['observed_variable'] == "106", 'original_precision'] = '1' 
    df.loc[df['observed_variable'] == "107", 'original_precision'] = "0.1"
    df.loc[df['observed_variable'] == "53", 'original_precision'] = "1"
    
    # add all columns for cdmlite
    df['year'] = df['Date'].str[:4]
    df['month'] = df['Date'].map(lambda x: x[4:6])
    df['day'] = df['Date'].map(lambda x: x[6:8])
    df["hour"] ="00"
    df["Minute"]="00"
    df["report_type"]="3"
    df["source_id"]=df["Source_flag"]
    df["date_time_meaning"]="1"
    df["observation_duration"]="13"
    df["platform_type"]=""
    df["station_type"]="1"
    df["observation_id"]=""
    df["data_policy_licence"]=""
    df["primary_station_id"]=df["Station_ID"]
    df["qc_method"]=df["quality_flag"].astype(str)
    df["quality_flag"]=df["quality_flag"].astype(str)
    df["crs"]=""
    df["z_coordinate"]=""
    df["z_coordinate_type"]=""
    df["secondary_variable"]=""
    df["secondary_value"]=""
    df["code_table"]=""
    df["sensor_id"]=""
    df["sensor_automation_status"]=""
    df["exposure_of_sensor"]=""
    df["processing_code"]=""
    df["processing_level"]="0"
    df["adjustment_id"]=""
    df["traceability"]=""
    df["advanced_qc"]=""
    df["advanced_uncertainty"]=""
    df["advanced_homogenisation"]=""
    df["advanced_assimilation_feedback"]=""
    df["source_record_id"]=""
    df["location_method"]=""
    df["location_precision"]=""
    df["z_coordinate_method"]=""
    df["bbox_min_longitude"]=""
    df["bbox_max_longitude"]=""
    df["bbox_min_latitude"]=""
    df["bbox_max_latitude"]=""
    df["spatial_representativeness"]=""
    df["original_code_table"]=""
    df["report_id"]=""

    
    
    # set quality flag to pass 0 or fail 1
    df.quality_flag[df.quality_flag == "nan"] = "0"
    df.quality_flag = df.quality_flag.str.replace('D', '1') \
    .str.replace('G', '1') \
        .str.replace('I', '1')\
            .str.replace('K', '1')\
                .str.replace('L', '1')\
                    .str.replace('M', '1')\
                        .str.replace('N', '1')\
                            .str.replace('O', '1')\
                                .str.replace('R', '1')\
                                    .str.replace('S', '1')\
                                        .str.replace('T', '1')\
                                            .str.replace('W', '1')\
                                                .str.replace('X', '1')\
                                                    .str.replace('Z', '1')\
                                                      .str.replace('H', '1')\
                                                          .str.replace('P', '1')
                           
    # add timestamp to df and create report id
    df["Timestamp2"] = df["year"].map(str) + "-" + df["month"].map(str)+ "-" + df["day"].map(str)  
    df["Seconds"]="00"
    df["offset"]="+00"
    df["date_time"] = df["Timestamp2"].map(str)+ " " + df["hour"].map(str)+":"+df["Minute"].map(str)+":"+df["Seconds"].map(str) 
    df.date_time = df.date_time + '+00'
    df["dates"]=df["date_time"].str[:-11]
    df['primary_station_id_2']=df['primary_station_id'].astype(str)+'-'+df['source_id'].astype(str)
    df["observation_value"] = pd.to_numeric(df["observation_value"],errors='coerce')
    df = df.astype(str)                                       
    df['source_id'] = df['source_id'].astype(str).apply(lambda x: x.replace('.0',''))
    df['primary_station_id_2']=df['primary_station_id'].astype(str)+'-'+df['source_id'].astype(str)
    
    # add in location information for cdm lite station 
    df2 = pd.read_csv(utils.DAILY_STATION_RECORD_ENTRIES_OBS_LITE, encoding='latin-1')
    df['primary_station_id_2'] = df['primary_station_id_2'].astype(str)
    df2 = df2.astype(str)
    df= df2.merge(df, on=['primary_station_id_2'])
    df['data_policy_licence'] = df['data_policy_licence_x']
    df['data_policy_licence'] = df['data_policy_licence'].astype(str).apply(lambda x: x.replace('.0',''))
    df["observation_value"] = pd.to_numeric(df["observation_value"],errors='coerce')
    df = df.fillna("null")
    df = df.replace({"null":""})
    
                                   
    # set up master df to extract each variable
       
    df["latitude"] = pd.to_numeric(df["latitude"],errors='coerce')
    df["longitude"] = pd.to_numeric(df["longitude"],errors='coerce')
    df["latitude"]= df["latitude"].round(3)
    df["longitude"]= df["longitude"].round(3)
    
    # add observation id to datafrme
    df['observation_id']=df['primary_station_id'].astype(str)+'-'+df['record_number'].astype(str)+'-'+df['dates'].astype(str)
    df['observation_id'] = df['observation_id'].str.replace(r' ', '-')
    df["observation_id"]=df["observation_id"]+df['observed_variable']+'-'+df['value_significance']
    df['report_id']=df['primary_station_id'].astype(str)+'-'+df['record_number'].astype(str)+'-'+df['dates'].astype(str)
    
      
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

    unique_variables = df['observed_variable'].unique()
        print(unique_variables)
        df.to_csv(cdmobs_outfile, index=False, sep="|")
        print(f"    {cdmobs_outfile}")



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



     
   

