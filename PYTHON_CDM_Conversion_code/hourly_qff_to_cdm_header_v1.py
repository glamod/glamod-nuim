 #!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Convert OBS files to CDM HEAD .psv files (one per station).


Call in one of three ways using:

>python hourly_qff_to_cdm_head_v1.py --station STATIONID
>python hourly_qff_to_cdm_head_v1.py --subset FILENAME
>python hourly_qff_to_cdm_head_v1.py --run_all
>python hourly_qff_to_cdm_head_v1.py --help

#Created on Thu Nov 11 16:31:58 2021

@author: snoone

edited: snoone, February 2022
"""

import os
import glob
import pandas as pd
pd.options.mode.chained_assignment = None  # default='warn'
import utils

# Set the file extension for the subdaily obs psv files
EXTENSION = 'psv'

def main(station="", subset="", run_all=False, clobber=False):
    """
    Run processing of hourly cdm obs to CDM head

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
        all_filenames = [os.path.join(utils.SUBDAILY_HEAD_IN_DIR, f"{station}.{EXTENSION}")]
    elif subset != "":
        print(f"Subset of stations run defined in: {subset}")
        # Read filenames form a list of 5000 to parallel
        try:
            # e.g. "/work/scratch-pw/snoone/qff_cdm_test_2021/station_list/ls1.txt"
            with open(subset, "r") as f:
                filenames = f.read().splitlines()

                # now add the path to the front
                all_filenames = []
                for infile in filenames:
                    all_filenames += [os.path.join(utils.SUBDAILY_HEAD_IN_DIR, f"{infile}")]

            print(f"   N = {len(all_filenames)}")
        except IOError:
            print(f"Subset file {subset} cannot be found")
            return
        except OSError:
            print(f"Subset file {subset} cannot be found")
            return
    elif all:
        print(f"All stations run in {utils.SUBDAILY_HEAD_IN_DIR}")
        all_filenames = [i for i in glob.glob(os.path.join(utils.SUBDAILY_HEAD_IN_DIR, f'*.{EXTENSION}'))]    
        print(f"   N = {len(all_filenames)}")
              
    # To start at next file after last processes 
    #for filename in all_filenames[all_filenames.index('FRI0000LFBF.qff'):] :

    # To start at begining of files
    for filename in all_filenames:
        print(f"Processing {filename}") 
        
        col_list = ["observation_id", "report_id", "latitude","longitude","source_id","date_time"] 
        merged_df=pd.read_csv(filename, sep="|", usecols=col_list)
        ##extract Station_ID from report_ID in obs table
        merged_df['Station_ID'] = merged_df['report_id'].str[:11]
        station_id=merged_df.iloc[1]["Station_ID"] # NOTE: this is renamed below to "primary_station_id" 
        outroot_cdmhead = os.path.join(utils.SUBDAILY_CDMHEAD_OUT_DIR, utils.SUBDAILY_CDMHEAD_FILE_ROOT) 
        cdmhead_outfile = f"{outroot_cdmhead}{station_id}.psv"
        if not clobber:
            # and both output files exist
            if os.path.exists(cdmhead_outfile):
                print(f"   Output files for {filename} already exist:")
                print(f"     {cdmhead_outfile}")
                print("   Skipping to next station")  
                continue#  to next file in the loop

    hdf = pd.DataFrame()  
    hdf['extract_record'] = merged_df['report_id'].str[:-17]
    hdf['station_record_number'] = hdf['extract_record'].str[12:]
    hdf['primary_station_id'] = hdf['extract_record'].str[:11]
    hdf["report_id"]=merged_df["report_id"]
    hdf["application_area"]=""
    hdf["observing_programme"]=""
    hdf["report_type"]="3"
    hdf["station_type"]="1"
    hdf["platform_type"]=""
    hdf["primary_station_id_scheme"]="13"
    hdf["location_accuracy"]="0.1"
    hdf["location_method"]=""
    hdf["location_quality"]="3"
    hdf["crs"]="0"
    hdf["station_speed"]=""  
    hdf["station_course"]=""
    hdf["station_heading"]=""
    hdf["height_of_station_above_local_ground"]=""
    hdf["height_of_station_above_sea_level_accuracy"]=""
    hdf["sea_level_datum"]=""
    hdf["report_meaning_of_timestamp"]="1"
    hdf["report_timestamp"]=""
    hdf["report_duration"]="13"
    hdf["report_time_accuracy"]=""
    hdf["report_time_quality"]=""
    hdf["report_time_reference"]="0"
    hdf["platform_subtype"]=""
    hdf["profile_id"]=""
    hdf["events_at_station"]=""
    hdf["report_quality"]=""
    hdf["duplicate_status"]="4"
    hdf["duplicates"]=""
    hdf["source_record_id"]=""
    hdf ["processing_codes"]=""
    hdf["longitude"]=merged_df["longitude"]
    hdf["latitude"]=merged_df["latitude"]
    hdf["source_id"]=merged_df["source_id"]
    hdf['record_timestamp'] = pd.to_datetime('now').strftime("%Y-%m-%d %H:%M:%S")
    hdf.record_timestamp = hdf.record_timestamp + '+00'
    hdf["history"]=""
    hdf["processing_level"]="0"
    hdf["report_timestamp"]=merged_df["date_time"]
    hdf['primary_station_id_3']=hdf['primary_station_id'].astype(str)+'-'+hdf['source_id'].astype(str)+'-'+hdf['station_record_number'].astype(str)
    hdf["duplicates_report"]=hdf["report_id"]
    
    
    del merged_df
       
         
    hdf["duplicates_report"]=hdf["report_id"]
              
            
    df2 = pd.read_csv(utils.STATION_RECORD_ENTRIES_H, encoding='latin-1')
    hdf = hdf.astype(str)
    df2 = df2.astype(str)
    hdf= df2.merge(hdf, on=['primary_station_id_3'])      
    hdf['height_of_station_above_sea_level'] = hdf['height_of_station_above_sea_level'].astype(str).apply(lambda x: x.replace('.0',''))
    hdf["latitude"] = pd.to_numeric(hdf["latitude"],errors='coerce')
    hdf["longitude"] = pd.to_numeric(hdf["longitude"],errors='coerce')
    hdf["latitude"]= hdf["latitude"].round(3)
    hdf["longitude"]= hdf["longitude"].round(3)
    
    del df2
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

    # Save CDM head table to directory
            try:

                    #with open(filename, "w") as outfile:
                hdf.to_csv(cdmhead_outfile, index=False, sep="|")
                print(f"    {cdmhead_outfile}")
            except:
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
     
    
   
