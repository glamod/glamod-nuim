#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
@author snoone
edited 8/03/2022 snnone

Convert monthly OBSERVATIONS files to Lite, Obs and hedaer .psv files (one per station).


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
EXTENSION = 'csv'
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
    if station != "" and subset != "" and all:
        print("Please select either single station, list of stations run or to run all")
        return
    elif station == "" and subset == "" and not all:
        print("Please select either single station, list of stations run or to run all")
        return

    # Obtain list of station(s) to process (single/subset/all)
    if station != "":
        print(f"Single station run: {station}")
        all_filenames = [os.path.join(utils.MONTHLY_CSV_IN_DIR, f"{station}.{EXTENSION}")]
    elif subset != "":
        print(f"Subset of stations run defined in: {subset}")
        # allows for parallelisation
        try:
           
            with open(subset, "r") as f:
                filenames = f.read().splitlines()

                # now add the path to the front
                all_filenames = []
                for infile in filenames:
                    all_filenames += [os.path.join(utils.MONTHLY_CSV_IN_DIR, f"{infile}")]

            print(f"   N = {len(all_filenames)}")
        except IOError:
            print(f"Subset file {subset} cannot be found")
            return
        except OSError:
            print(f"Subset file {subset} cannot be found")
            return
    elif all:
        print(f"All stations run in {utils.MONTHLY_IN_DIR}")
        all_filenames = [i for i in glob.glob(os.path.join(utils.MONTHLY_CSV_IN_DIR, f'*.{EXTENSION}'))]    
        print(f"   N = {len(all_filenames)}") 
        
        for filename in all_filenames:
            print(f"Processing {filename}") 
            usecols = ["STATION","LATITUDE","LONGITUDE","ELEVATION","DATE","NAME", "PRCP", "TMIN", "TMAX", "TAVG", "SNOW", "AWND"]
            df=pd.read_csv(filename, sep=",",usecols=lambda c: c in set(usecols))
            station_id=df.iloc[1]["STATION"] # NOTE: this is renamed below to "primary_station_id"
            outroot_cdmlite = os.path.join(utils.MONTHLY_CDM_LITE_OUT_DIR, utils.MONTHLY_CDM_LITE_FILE_ROOT) 
            outroot_cdmobs = os.path.join(utils.MONTHLY_CDM_OBS_OUT_DIR, utils.MONTHLY_CDM_OBS_FILE_ROOT) 
            outroot_cdmhead = os.path.join(utils.MONTHLY_CDM_HEAD_OUT_DIR, utils.MONTHLY_CDM_HEAD_FILE_ROOT) 
            cdmlite_outfile = f"{outroot_cdmlite}{station_id}.psv"
            cdmobs_outfile = f"{outroot_cdmobs}{station_id}.psv"
            cdmhead_outfile = f"{outroot_cdmhead}{station_id}.psv"
            
            if not clobber:
                if os.path.exists(cdmlite_outfile):
                    print(f"   Output files for {filename} already exist:") 
                    print(f"     {cdmlite_outfile}") 
                    print(f"     {cdmobs_outfile}") 
                    print(f"     {cdmhead_outfile}") 
                    print("   Skipping to next station")  
                    continue    #  to next file in the loop
            
            df["report_type"] = "2"
            df["units"] = ""
            df["minute"] = "00"
            df["day"] = "01"
            df["hour"] = "00"
            df["seconds"] = "00"
            df[['year', 'month']] = df['DATE'].str.split('-', expand=True)
            df["observation_height_above_station_surface"]=""
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
                dfprc = df[["observation_id","report_type","date_time","date_time_meaning",
                          "latitude","longitude","observation_height_above_station_surface"
                          ,"observed_variable","units","observation_value",
                          "value_significance","observation_duration","platform_type",
                          "station_type","primary_station_id","station_name","quality_flag"
                          ,"data_policy_licence"]]

                
                # change for each variable to convert to cdm compliant values
                dfprc["observation_value"] = df["PRCP"]
                # change for each variable if required
                dfprc["observation_height_above_station_surface"]="1"
                dfprc["units"] = "710"
                dfprc["observed_variable"] = "44"
                # set up matching values for merging with record_id_month to add information source_id for first configuration only due to lakc of information
                dfprc["record_number"] = "1"   
                dfprc['primary_station_id_2'] = dfprc['primary_station_id'].astype(str)+'-'+dfprc['record_number'].astype(str)
                dfprc["report_id"] = dfprc["date_time"]
                
                # merge with record_id_mnth.csv to add source id
                df2 = pd.read_csv(utils.MONTHLY_STATION_RECORD_ENTRIES_MONTHLY_OBS_LITE, encoding='latin-1')
                dfprc = dfprc.astype(str)
                df2 = df2.astype(str)
                dfprc = df2.merge(dfprc, on = ['primary_station_id_2'])
                dfprc = dfprc.rename(columns={"station_name_x":"station_name",})
                dfprc = dfprc.rename(columns={"source_id_x":"source_id",})
                dfprc['observation_id'] = dfprc['primary_station_id'].astype(str)+'-'+dfprc['record_number'].astype(str)+'-'+dfprc['date_time'].astype(str)
                dfprc['observation_id'] = dfprc['observation_id'].str.replace(r' ', '-')
                # remove unwanted last two characters
                dfprc['observation_id'] = dfprc['observation_id'].str[:-12]
                dfprc["observation_id"] = dfprc["observation_id"]+'-'+dfprc['observed_variable'].astype(str)+'-'+dfprc['value_significance'].astype(str)
                
                # reorder columns and drop unwanted columns
                dfprc = dfprc[["observation_id","report_type","date_time","date_time_meaning",
                          "latitude","longitude","observation_height_above_station_surface"
                          ,"observed_variable","units","observation_value",
                          "value_significance","observation_duration","platform_type",
                          "station_type","primary_station_id","station_name","quality_flag"
                          ,"data_policy_licence","source_id","primary_station_id_2"]]
            except:
                    pass
            
           
            
            # extract SNOW
            try:
                dfsnow = df[["observation_id","report_type","date_time","date_time_meaning",
                          "latitude","longitude","observation_height_above_station_surface"
                          ,"observed_variable","units","observation_value",
                          "value_significance","observation_duration","platform_type",
                          "station_type","primary_station_id","station_name","quality_flag"
                          ,"data_policy_licence"]]
                
                # change for each variable to convert to cdm compliant values
                
                dfsnow["observation_value"]=df["SNOW"]
                dfsnow = dfsnow.fillna("Null")
                dfsnow = dfsnow[dfsnow.observation_value != "Null"]
                #change for each variable if required
                dfsnow["observation_height_above_station_surface"] = "0"
                dfsnow["units"] = "710"
                dfsnow["observed_variable"]="45"
                #set up matching values for merging with record_id_month to add information source_id for first configuration only due to lack of information
                dfsnow["record_number"] = "1"   
                dfsnow['primary_station_id_2'] = dfsnow['primary_station_id'].astype(str)+'-'+dfsnow['record_number'].astype(str)
                dfsnow["report_id"] = dfsnow["date_time"]
                
                # merge with record_id_mnth.csv to add source id
                df2 = pd.read_csv(utils.MONTHLY_STATION_RECORD_ENTRIES_MONTHLY_OBS_LITE, encoding='latin-1')
                dfsnow = dfsnow.astype(str)
                df2 = df2.astype(str)
                dfsnow= df2.merge(dfsnow, on = ['primary_station_id_2'])
                dfsnow = dfsnow.rename(columns={"source_id_x":"source_id",})
                dfsnow = dfsnow.rename(columns={"station_name_x":"station_name",})
                dfsnow['observation_id'] = dfsnow['primary_station_id'].astype(str)+'-'+dfsnow['record_number'].astype(str)+'-'+dfsnow['date_time'].astype(str)
                dfsnow['observation_id'] = dfsnow['observation_id'].str.replace(r' ', '-')
                # remove unwanted last twpo characters
                dfsnow['observation_id'] = dfsnow['observation_id'].str[:-12]
                dfsnow["observation_id"] = dfsnow["observation_id"]+'-'+dfsnow['observed_variable'].astype(str)+'-'+dfsnow['value_significance'].astype(str)
                
                # reorder columns and drop unwanted columns
                dfsnow = dfsnow[["observation_id","report_type","date_time","date_time_meaning",
                          "latitude","longitude","observation_height_above_station_surface"
                          ,"observed_variable","units","observation_value",
                          "value_significance","observation_duration","platform_type",
                          "station_type","primary_station_id","station_name","quality_flag"
                          ,"data_policy_licence","source_id","primary_station_id_2"]]
            except:
                    pass
            
            

              # extract tmax
            try:
                dftmax = df[["observation_id","report_type","date_time","date_time_meaning",
                          "latitude","longitude","observation_height_above_station_surface"
                          ,"observed_variable","units","observation_value",
                          "value_significance","observation_duration","platform_type",
                          "station_type","primary_station_id","station_name","quality_flag"
                          ,"data_policy_licence"]]
                
                # change for each variable to convert to cdm compliant values
                dftmax["observation_value"] = df["TMAX"]
                dftmax = dftmax.fillna("Null")
                dftmax = dftmax[dftmax.observation_value != "Null"]
                dftmax["observation_value"] = pd.to_numeric(dftmax["observation_value"],errors='coerce')
                dftmax["observation_value"] = dftmax["observation_value"]+273.15
                dftmax["observation_value"] = pd.to_numeric(dftmax["observation_value"],errors='coerce')
                dftmax["observation_value"] = dftmax["observation_value"].round(2)
                #change for each variable if required
                dftmax["observation_height_above_station_surface"]="2"
                dftmax["units"]="5"
                dftmax["observed_variable"] = "85"
                dftmax["value_significance"] = "0" 
                #set up matching values for merging with record_id_month to add information source_id for first configuration only due yto lack of information
                dftmax["record_number"] ="1"   
                dftmax['primary_station_id_2'] = dftmax['primary_station_id'].astype(str)+'-'+dftmax['record_number'].astype(str)
                dftmax["report_id"] = dftmax["date_time"]
                
                # merge with record_id_mnth.csv to add source id
                df2 = pd.read_csv(utils.MONTHLY_STATION_RECORD_ENTRIES_MONTHLY_OBS_LITE, encoding='latin-1')
                dftmax = dftmax.astype(str)
                df2 = df2.astype(str)
                dftmax= df2.merge(dftmax, on = ['primary_station_id_2'])
                dftmax = dftmax.rename(columns={"station_name_x":"station_name",})
                dftmax = dftmax.rename(columns={"source_id_x":"source_id",})
                dftmax['observation_id'] = dftmax['primary_station_id'].astype(str)+'-'+dftmax['record_number'].astype(str)+'-'+dftmax['date_time'].astype(str)
                dftmax['observation_id'] = dftmax['observation_id'].str.replace(r' ', '-')
                # remove unwanted last twpo characters
                dftmax['observation_id'] = dftmax['observation_id'].str[:-12]
                dftmax["observation_id"] = dftmax["observation_id"]+'-'+dftmax['observed_variable'].astype(str)+'-'+dftmax['value_significance'].astype(str)
                
                # reorder columns and drop unwanted columns
                dftmax = dftmax[["observation_id","report_type","date_time","date_time_meaning",
                          "latitude","longitude","observation_height_above_station_surface"
                          ,"observed_variable","units","observation_value",
                          "value_significance","observation_duration","platform_type",
                          "station_type","primary_station_id","station_name","quality_flag"
                          ,"data_policy_licence","source_id","primary_station_id_2"]]
            except:
                pass
            
            
            
            # extract tmin
            try:
                 dftmin = df[["observation_id","report_type","date_time","date_time_meaning",
                           "latitude","longitude","observation_height_above_station_surface"
                           ,"observed_variable","units","observation_value",
                           "value_significance","observation_duration","platform_type",
                           "station_type","primary_station_id","station_name","quality_flag"
                           ,"data_policy_licence"]]
                 
                 # change for each variable to convert to cdm compliant values
                 dftmin["observation_value"] = df["TMIN"]
                 dftmin = dftmin.fillna("Null")
                 dftmin = dftmin[dftmin.observation_value != "Null"]
                 dftmin["observation_value"] = pd.to_numeric(dftmin["observation_value"],errors='coerce')
                 dftmin["observation_value"] = dftmin["observation_value"]+273.15
                 dftmin["observation_value"] = pd.to_numeric(dftmin["observation_value"],errors='coerce')
                 dftmin["observation_value"] = dftmin["observation_value"].round(2)
                 # change for each variable if required
                 dftmin["observation_height_above_station_surface"]="2"
                 dftmin["units"] = "5"
                 dftmin["observed_variable"] = "85"
                 dftmin["value_significance"] = "1" 
                 # set up matching values for merging with record_id_month to add information source_id for first configuration only due yto lack of information
                 dftmin["record_number"] = "1"   
                 dftmin['primary_station_id_2'] = dftmin['primary_station_id'].astype(str)+'-'+dftmin['record_number'].astype(str)
                 dftmin["report_id"] = dftmin["date_time"]
                 
                 # merge with record_id_mnth.csv to add source id
                 df2 = pd.read_csv(utils.MONTHLY_STATION_RECORD_ENTRIES_MONTHLY_OBS_LITE, encoding='latin-1')
                 dftmin = dftmin.astype(str)
                 df2 = df2.astype(str)
                 dftmin= df2.merge(dftmin, on = ['primary_station_id_2'])
                 dftmin = dftmin.rename(columns={"station_name_x":"station_name",})
                 dftmin = dftmin.rename(columns={"source_id_x":"source_id",})
                 dftmin['observation_id'] = dftmin['primary_station_id'].astype(str)+'-'+dftmin['record_number'].astype(str)+'-'+dftmin['date_time'].astype(str)
                 dftmin['observation_id'] = dftmin['observation_id'].str.replace(r' ', '-')
                 # remove unwanted last twpo characters
                 dftmin['observation_id'] = dftmin['observation_id'].str[:-12]
                 dftmin["observation_id"] = dftmin["observation_id"]+'-'+dftmin['observed_variable'].astype(str)+'-'+dftmin['value_significance'].astype(str)
                 
                # reorder columns and drop unwanted columns
                 dftmin = dftmin[["observation_id","report_type","date_time","date_time_meaning",
                           "latitude","longitude","observation_height_above_station_surface"
                           ,"observed_variable","units","observation_value",
                           "value_significance","observation_duration","platform_type",
                           "station_type","primary_station_id","station_name","quality_flag"
                           ,"data_policy_licence","source_id","primary_station_id_2"]]
            except:
                pass
               
           
            
            # extract tavg
            try:
                dftavg = df[["observation_id","report_type","date_time","date_time_meaning",
                          "latitude","longitude","observation_height_above_station_surface"
                          ,"observed_variable","units","observation_value",
                          "value_significance","observation_duration","platform_type",
                          "station_type","primary_station_id","station_name","quality_flag"
                          ,"data_policy_licence"]]
                
                # change for each variable to convert to cdm compliant values
                dftavg["observation_value"]=df["TAVG"]
                dftavg = dftavg.fillna("Null")
                dftavg = dftavg[dftavg.observation_value != "Null"]
                dftavg["observation_value"] = pd.to_numeric(dftavg["observation_value"],errors='coerce')
                dftavg["observation_value"] = dftavg["observation_value"]+273.15
                dftavg["observation_value"] = pd.to_numeric(dftavg["observation_value"],errors='coerce')
                dftavg["observation_value"] = dftavg["observation_value"].round(2)
                # change for each variable if required
                dftavg["observation_height_above_station_surface"]="2"
                dftavg["units"]="5"
                dftavg["observed_variable"]="85"
                dftavg["value_significance"]="2" 
                # set up matching values for merging with record_id_month to add information source_id for first configuration only due yto lack of information
                dftavg["record_number"]="1"   
                dftavg['primary_station_id_2'] = dftavg['primary_station_id'].astype(str)+'-'+dftavg['record_number'].astype(str)
                dftavg["report_id"] = dftavg["date_time"]
                
                # merge with record_id_mnth.csv to add source id
                df2 = pd.read_csv(utils.MONTHLY_STATION_RECORD_ENTRIES_MONTHLY_OBS_LITE, encoding='latin-1')
                dftavg = dftavg.astype(str)
                df2 = df2.astype(str)
                dftavg= df2.merge(dftavg, on = ['primary_station_id_2'])
                dftavg = dftavg.rename(columns={"station_name_x":"station_name",})
                dftavg = dftavg.rename(columns={"source_id_x":"source_id",})
                dftavg['observation_id'] = dftavg['primary_station_id'].astype(str)+'-'+dftavg['record_number'].astype(str)+'-'+dftavg['date_time'].astype(str)
                dftavg['observation_id'] = dftavg['observation_id'].str.replace(r' ', '-')
                dftavg["observation_id"] = dftavg["observation_id"]+'-'+dftavg['observed_variable'].astype(str)+'-'+dftavg['value_significance'].astype(str)
                
                # reorder columns and drop unwanted columns
                dftavg = dftavg[["observation_id","report_type","date_time","date_time_meaning",
                          "latitude","longitude","observation_height_above_station_surface"
                          ,"observed_variable","units","observation_value",
                          "value_significance","observation_duration","platform_type",
                          "station_type","primary_station_id","station_name","quality_flag"
                          ,"data_policy_licence","source_id","primary_station_id_2"]]
            except:
                pass
                       
            
           
            # extract wind speed avge
            try:
                dftws = df[["observation_id","report_type","date_time","date_time_meaning",
                          "latitude","longitude","observation_height_above_station_surface"
                          ,"observed_variable","units","observation_value",
                          "value_significance","observation_duration","platform_type",
                          "station_type","primary_station_id","station_name","quality_flag"
                          ,"data_policy_licence"]]
                
                # change for each variable to convert to cdm compliant values
                dftws["observation_value"] = df["AWND"]
                dftws = dftws.fillna("Null")
                dftws = dftws[dftws.observation_value != "Null"]
                dftws["observation_value"] = pd.to_numeric(dftws["observation_value"],errors='coerce')
                dftws["observation_value"] = dftws["observation_value"]
                dftws["observation_value"] = pd.to_numeric(dftws["observation_value"],errors='coerce')
                dftws["observation_value"] = dftws["observation_value"].round(2)
                # change for each variable if required
                dftws["observation_height_above_station_surface"]="2"
                dftws["units"] = "732"
                dftws["observed_variable"] = "107"
                dftws["value_significance"] = "2" 
                # set up matching values for merging with record_id_month to add information source_id for first configuration only due yto lack of information
                dftws["record_number"] = "1"   
                dftws['primary_station_id_2'] = dftws['primary_station_id'].astype(str)+'-'+dftws['record_number'].astype(str)
                dftws["report_id"] = dftws["date_time"]
                
                # merge with record_id_mnth.csv to add source id
                df2 = pd.read_csv(utils.MONTHLY_STATION_RECORD_ENTRIES_MONTHLY_OBS_LITE, encoding='latin-1')
                dftws = dftws.astype(str)
                df2 = df2.astype(str)
                dftws= df2.merge(dftws, on = ['primary_station_id_2'])
                dftws = dftws.rename(columns={"station_name_x":"station_name",})
                dftws = dftws.rename(columns={"source_id_x":"source_id",})
                dftws['observation_id'] = dftws['primary_station_id'].astype(str)+'-'+dftws['record_number'].astype(str)+'-'+dftws['date_time'].astype(str)
                dftws['observation_id'] = dftws['observation_id'].str.replace(r' ', '-')
                # remove unwanted last twpo characters
                dftws['observation_id'] = dftws['observation_id'].str[:-12]
                dftws["observation_id"] = dftws["observation_id"]+'-'+dftws['observed_variable'].astype(str)+'-'+dftws['value_significance'].astype(str)
                
                # reorder columns and drop unwanted columns
                dftws = dftws[["observation_id","report_type","date_time","date_time_meaning",
                          "latitude","longitude","observation_height_above_station_surface"
                          ,"observed_variable","units","observation_value",
                          "value_significance","observation_duration","platform_type",
                          "station_type","primary_station_id","station_name","quality_flag"
                          ,"data_policy_licence","source_id","primary_station_id_2"]]
            
            # merge all the sperate variable df togther into one df    
            except:
                pass 
                       
            try:
                merged_df=pd.concat([dftmax,dftavg,dftmin,dftws,dfprc], axis=0)
                merged_df.sort_values("date_time")
                merged_df["latitude"] = pd.to_numeric(merged_df["latitude"],errors='coerce')
                merged_df["longitude"] = pd.to_numeric(merged_df["longitude"],errors='coerce')
                merged_df["latitude"] = merged_df["latitude"].round(3)
                merged_df["longitude"] = merged_df["longitude"].round(3)
                merged_df = merged_df[merged_df.observation_value != "nan"]
                merged_df["observation_value"] = pd.to_numeric(merged_df["observation_value"],errors='coerce')
                merged_df.dropna(subset = ["observation_value"], inplace=True)
                merged_df.dropna(subset = ["observation_id"], inplace=True)
                df_lite_out = merged_df[["observation_id","report_type","date_time","date_time_meaning",
                              "latitude","longitude","observation_height_above_station_surface"
                              ,"observed_variable","units","observation_value",
                              "value_significance","observation_duration","platform_type",
                              "station_type","primary_station_id","station_name","quality_flag"
                              ,"data_policy_licence","source_id"]]
                
                
                dfobs=merged_df[["observation_id","report_type","date_time","date_time_meaning",
                          "latitude","longitude","observation_height_above_station_surface"
                          ,"observed_variable","units","observation_value",
                          "value_significance","observation_duration","platform_type",
                          "station_type","primary_station_id","station_name","quality_flag"
                          ,"data_policy_licence","source_id","primary_station_id_2"]]
                
                # add region and sub region
                df2 = pd.read_csv(utils.MONTHLY_STATION_RECORD_ENTRIES_MONTHLY_OBS_LITE, encoding='latin-1')
                dfobs = dfobs.astype(str)
                df2 = df2.astype(str)
                dfobs = df2.merge(dfobs, on=['primary_station_id_2'])
                
                dfobs["numerical_precision"]=""
                dfobs.loc[dfobs['observed_variable'] == "85", 'numerical_precision'] = '0.01' 
                dfobs.loc[dfobs['observed_variable'] == "44", 'numerical_precision'] = '0.1'
                dfobs.loc[dfobs['observed_variable'] == "45", 'numerical_precision'] = '0.1'
                dfobs.loc[dfobs['observed_variable'] == "55", 'numerical_precision'] = '0.1' 
                dfobs.loc[dfobs['observed_variable'] == "106", 'numerical_precision'] = '0.1' 
                dfobs.loc[dfobs['observed_variable'] == "107", 'numerical_precision'] = "0.1"
                dfobs.loc[dfobs['observed_variable'] == "53", 'numerical_precision'] = "1"

                dfobs["original_precision"]=""
                dfobs.loc[dfobs['observed_variable'] == "85", 'original_precision'] = '0.01' 
                dfobs.loc[dfobs['observed_variable'] == "44", 'original_precision'] = '0.1'
                dfobs.loc[dfobs['observed_variable'] == "45", 'original_precision'] = '0.1'
                dfobs.loc[dfobs['observed_variable'] == "55", "original_precision"] = '0.1' 
                dfobs.loc[dfobs['observed_variable'] == "106", 'original_precision'] = '1' 
                dfobs.loc[dfobs['observed_variable'] == "107", 'original_precision'] = "0.1"
                dfobs.loc[dfobs['observed_variable'] == "53", 'original_precision'] = "1"
                    
                # add conversion flags
                dfobs["conversion_flag"]=""
                dfobs.loc[dfobs['observed_variable'] == "85", 'conversion_flag'] = '0' 
                dfobs.loc[dfobs['observed_variable'] == "44", 'conversion_flag'] = '2'
                dfobs.loc[dfobs['observed_variable'] == "45", 'conversion_flag'] = '2'
                dfobs.loc[dfobs['observed_variable'] == "55", 'conversion_flag'] = '2' 
                dfobs.loc[dfobs['observed_variable'] == "106", 'conversion_flag'] = '2' 
                dfobs.loc[dfobs['observed_variable'] == "107", 'conversion_flag'] = "2"
                dfobs.loc[dfobs['observed_variable'] == "53", 'conversion_flag'] = "2"
              
                # set conversion method for variables
                dfobs["conversion_method"] = ""
                dfobs.loc[dfobs['observed_variable'] == "85", 'conversion_method'] = '1' 
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
                dfobs["onversion_method"] = ""
                dfobs.loc[dfobs['observed_variable'] == "85", 'original_units'] = '350'
                dfobs.loc[dfobs['observed_variable'] == "85", 'original_value'] = dfobs["observation_value"]-273.15
                dfobs.loc[dfobs['observed_variable'] == "85", 'conversion_method'] ="1"
                
               
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
            except:
                pass
                           
            
            
            # set up the header table from the obs table
            try:
                col_list = dfobs [["observation_id","latitude","longitude","report_id","source_id","date_time"]]
                hdf = col_list.copy()
                
                
                # add required columns and set up values etc
                hdf[['primary_station_id', 'station_record_number', '1',"2,","3"]] = hdf['report_id'].str.split('-', expand=True)                                                    
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
                hdf['primary_station_id_2'] = hdf['primary_station_id'].astype(str)+'-'+hdf['source_id'].astype(str)
                hdf["duplicates_report"] = hdf["report_id"]+'-'+hdf["station_record_number"].astype(str)
                
                    
                      
                df2 = pd.read_csv(utils.MONTHLY_STATION_RECORD_ENTRIES_MONTHLY_HEADER, encoding='latin-1')
                hdf = hdf.astype(str)
                df2 = df2.astype(str)
                hdf = df2.merge(hdf, on=['primary_station_id_2'])
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
                
            except:
                continue
            
            try:
                df_lite_out.to_csv(cdmlite_outfile, index=False, sep="|")
                print(f"    {cdmlite_outfile}") 
            except:
                continue
            
            try:
                unique_variables = dfobs['observed_variable'].unique()
                print(unique_variables)
                dfobs.to_csv(cdmobs_outfile, index=False, sep="|")
                print(f"    {cdmobs_outfile}") 
            except:
                continue
                
            try: 
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

            

        
        
