# -*- coding: utf-8 -*-
"""
Created on Wed Nov 24 10:26:06 2021

@author: snoone
"""


import os
import glob
import pandas as pd
pd.options.mode.chained_assignment = None  # default='warn'



OUTDIR = "/work/scratch-pw/snoone/csv_cdm_test_2021/cdmhead_out_dy_202111"
os.chdir("/work/scratch-pw/snoone/csv_cdm_test_2021/cdmobs_out_dy_202111")

col_list = ["observation_id", "report_id", "longitude", "latitude", "source_id","date_time"]
extension = 'psv'
#my_file = open("D:/Python_CDM_conversion/hourly/qff/ls_dy.txt", "r")
#all_filenames = my_file.readlines()
#print(all_filenames)
##use  a list of file name sto run 5000 parallel
#with open("/work/scratch-pw/snoone/csv_cdm_test_2021/station_list/ls_dy.txt", "r") as f:
 #   all_filenames = f.read().splitlines()
all_filenames = [i for i in glob.glob('*.{}'.format(extension))]
##to start at begining of files
for filename in all_filenames:
##to start at next file after last processe 
#for filename in all_filenames[all_filenames.index('SWM00002338.qff'):] :
    merged_df=pd.read_csv(filename, sep="|", usecols=col_list)
    
###produce headre table using some of obs table column information 
    hdf = pd.DataFrame() 

    ##need to separtate obervation id by "-" to extract station id    
    hdf[['primary_station_id', 'station_record_number', '1',"2,","3"]] = merged_df['report_id'].str.split('-', expand=True)                                                    
    #hdf["observation_id"]=merged_df["observation_id"]                                                  
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
    hdf["source_id"]=merged_df["source_id"]
    hdf['record_timestamp'] = pd.to_datetime('now').strftime("%Y-%m-%d %H:%M:%S")
    hdf.record_timestamp = hdf.record_timestamp + '+00'
    hdf["history"]=""
    hdf["processing_level"]="0"
    hdf["report_timestamp"]=merged_df["date_time"]
    hdf['primary_station_id_2']=hdf['primary_station_id'].astype(str)+'-'+hdf['source_id'].astype(str)
    hdf["duplicates_report"]=hdf["report_id"]+'-'+hdf["station_record_number"].astype(str)
    try:
     station_id=hdf.iloc[1]["primary_station_id"]
    except:
      pass
    
    #del merged_df
    
            
    df2=pd.read_csv("/work/scratch-pw/snoone/csv_cdm_test_2021/station_list/record_id_dy.csv")
    hdf = hdf.astype(str)
    df2 = df2.astype(str)
    hdf= df2.merge(hdf, on=['primary_station_id_2'])
    hdf["station_name"]=hdf["station_name"]
    hdf["station_record_number"]=hdf["record_number"]
    #hdf['report_id']=hdf['primary_station_id'].astype(str)+'-'+hdf['station_record_number'].astype(str)+'-'+hdf['report_timestamp'].astype(str)
    #hdf['report_id'] = hdf['report_id'].str.replace(r' ', '-')
    ##remove unwanted last twpo characters
   # hdf['report_id'] = hdf['report_id'].str[:-6]
    hdf['height_of_station_above_sea_level'] = hdf['height_of_station_above_sea_level'].astype(str).apply(lambda x: x.replace('.0',''))
    hdf["latitude"] = pd.to_numeric(hdf["latitude"],errors='coerce')
    hdf["longitude"] = pd.to_numeric(hdf["longitude"],errors='coerce')
    hdf["latitude"]= hdf["latitude"].round(3)
    hdf["longitude"]= hdf["longitude"].round(3)
    
    
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
    #hdf.to_csv("hdf7.csv", index=False, sep=",")
    
    ##name the cdm_lite files e.g. cdm_lite _”insert date of run”_EG000062417.psv)
    try:
        ## table output
       ##header table output
        
        cdm_type=("cdm_head_202111_test_")
        print(station_id+"-"+"header")
        outname = os.path.join(OUTDIR,cdm_type)
        #with open(filename, "w") as outfile:
        hdf.to_csv(outname+ station_id+ ".psv", index=False, sep="|")
              
    except:
        # Continue to next iteration.
        continue   
    
