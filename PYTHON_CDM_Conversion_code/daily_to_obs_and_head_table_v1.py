# -*- coding: utf-8 -*-
"""
Created on Thu Nov 11 16:31:58 2021

@author: snoone
"""

import os
import glob
import pandas as pd
import numpy as np
pd.options.mode.chained_assignment = None  # default='warn'

OUTDIR2= "D:/Python_CDM_conversion/daily/cdm_out/head"
OUTDIR = "D:/Python_CDM_conversion/daily/cdm_out/obs"
os.chdir("D:/Python_CDM_conversion/daily/.csv/")
extension = 'csv'
#my_file = open("D:/Python_CDM_conversion/hourly/qff/ls1.txt", "r")
#all_filenames = my_file.readlines()
#print(all_filenames)
##use  a list of file name sto run 5000 parallel
#with open("D:/Python_CDM_conversion/hourly/qff/ls1.txt", "r") as f:
#all_filenames = f.read().splitlines()
all_filenames = [i for i in glob.glob('*.{}'.format(extension))]
##to start at begining of files
for filename in all_filenames:
##to start at next file after last processe 
#for filename in all_filenames[all_filenames.index('SWM00002338.qff'):] :
    df=pd.read_csv(filename, sep=",")
    ##add column headers
    df.columns=["Station_ID", "Date", "observed_variable", "observation_value","quality_flag","Measurement_flag","Source_flag","hour"]
    df = df.astype(str)
    
   # importing pandas as pd
 
# filtering the rows where Credit-Rating is Fair
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
    
    ##set the value significnace for each variable
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
    
    ##SET OBSERVED VALUES TO CDM COMPLIANT values
    df["observation_value"] = pd.to_numeric(df["observation_value"],errors='coerce')
    #df["observed_variable"] = pd.to_numeric(df["observed_variable"],errors='coerce')
    #df['observation_value'] = df['observation_value'].astype(int).round(2)
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
  
    
    
    ##set the units for each variable
    df["original_units"]=""
    df.loc[df['observed_variable'] == "85", 'original_units'] = '350' 
    df.loc[df['observed_variable'] == "44", 'original_units'] = '710'
    df.loc[df['observed_variable'] == "45", 'original_units'] = '710'
    df.loc[df['observed_variable'] == "55", 'original_units'] = '710' 
    df.loc[df['observed_variable'] == "106", 'original_units'] = '731' 
    df.loc[df['observed_variable'] == "107", 'original_units'] = "320"
    df.loc[df['observed_variable'] == "53", 'original_units'] = '715'
        
    ##set the original units for each variable
    df["units"]=""
    df.loc[df['observed_variable'] == "85", 'units'] = '5' 
    df.loc[df['observed_variable'] == "44", 'units'] = '710'
    df.loc[df['observed_variable'] == "45", 'units'] = '710'
    df.loc[df['observed_variable'] == "55", 'units'] = '710' 
    df.loc[df['observed_variable'] == "106", 'units'] = '731' 
    df.loc[df['observed_variable'] == "107", 'units'] = "320"
    df.loc[df['observed_variable'] == "53", 'units'] = '715'

             
    ##set each height above station surface for each variable
    df["observation_height_above_station_surface"]=""
    df.loc[df['observed_variable'] == "85", 'observation_height_above_station_surface'] = '2' 
    df.loc[df['observed_variable'] == "44", 'observation_height_above_station_surface'] = '1'
    df.loc[df['observed_variable'] == "45", 'observation_height_above_station_surface'] = '1'
    df.loc[df['observed_variable'] == "55", 'observation_height_above_station_surface'] = '1' 
    df.loc[df['observed_variable'] == "106", 'observation_height_above_station_surface'] = '10' 
    df.loc[df['observed_variable'] == "107", 'observation_height_above_station_surface'] = "10"
    df.loc[df['observed_variable'] == "53", 'observation_height_above_station_surface'] = "1"
    
    ##set conversion flags for variables
    df["conversion_flag"]=""
    df.loc[df['observed_variable'] == "85", 'conversion_flag'] = '0' 
    df.loc[df['observed_variable'] == "44", 'conversion_flag'] = '2'
    df.loc[df['observed_variable'] == "45", 'conversion_flag'] = '2'
    df.loc[df['observed_variable'] == "55", 'conversion_flag'] = '2' 
    df.loc[df['observed_variable'] == "106", 'conversion_flag'] = '2' 
    df.loc[df['observed_variable'] == "107", 'conversion_flag'] = "2"
    df.loc[df['observed_variable'] == "53", 'conversion_flag'] = "2"
    
    ##set conversion method for variables
    df["conversion_method"]=""
    df.loc[df['observed_variable'] == "85", 'conversion_method'] = '1' 
    
    
    ##set numerical precision for variables
    
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
    
    
    #add all columns for cdmlite
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

    
    
    ###set quality flag to pass 0 or fail 1
    #df.loc[df['quality_flag'].notnull(), "quality_flag"] = "1"
    #df = df.fillna("Null")
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
    #print (df.dtypes)                       
    ##add timestamp to df and cerate report id
    df["Timestamp2"] = df["year"].map(str) + "-" + df["month"].map(str)+ "-" + df["day"].map(str)  
    df["Seconds"]="00"
    df["offset"]="+00"
    df["date_time"] = df["Timestamp2"].map(str)+ " " + df["hour"].map(str)+":"+df["Minute"].map(str)+":"+df["Seconds"].map(str) 
    #df['date_time'] =  pd.to_datetime(df['date_time'], format='%Y/%m/%d' " ""%H:%M")
    #df['date_time'] = df['date_time'].astype('str')
    df.date_time = df.date_time + '+00'
    df["dates"]=df["date_time"].str[:-11]
    df['primary_station_id_2']=df['primary_station_id'].astype(str)+'-'+df['source_id'].astype(str)
    df["observation_value"] = pd.to_numeric(df["observation_value"],errors='coerce')
    df = df.astype(str)                                       
    df['source_id'] = df['source_id'].astype(str).apply(lambda x: x.replace('.0',''))
    df['primary_station_id_2']=df['primary_station_id'].astype(str)+'-'+df['source_id'].astype(str)
    
   ##'add in location infromatin ro cdm lite station 
    df2=pd.read_csv("D:/Python_CDM_conversion/daily/config_files/record_id_dy.csv")
    df['primary_station_id_2'] = df['primary_station_id_2'].astype(str)
    df2 = df2.astype(str)
    df= df2.merge(df, on=['primary_station_id_2'])
    df['data_policy_licence'] = df['data_policy_licence_x']
    df['data_policy_licence'] = df['data_policy_licence'].astype(str).apply(lambda x: x.replace('.0',''))
    df["observation_value"] = pd.to_numeric(df["observation_value"],errors='coerce')
    df = df.fillna("null")
    df = df.replace({"null":""})
    
                                   
    ##set up master df to extrcat each variable
       
    df["latitude"] = pd.to_numeric(df["latitude"],errors='coerce')
    df["longitude"] = pd.to_numeric(df["longitude"],errors='coerce')
    df["latitude"]= df["latitude"].round(3)
    df["longitude"]= df["longitude"].round(3)
    ##add observation id to datafrme
    df['observation_id']=df['primary_station_id'].astype(str)+'-'+df['record_number'].astype(str)+'-'+df['dates'].astype(str)
    df['observation_id'] = df['observation_id'].str.replace(r' ', '-')
    df["observation_id"]=df["observation_id"]+df['observed_variable']+'-'+df['value_significance']
    ##create report_id fom observation_id
    df['report_id']=df['primary_station_id'].astype(str)+'-'+df['record_number'].astype(str)+'-'+df['dates'].astype(str)
    station_id2=df.iloc[1]["primary_station_id"]

    
    df['report_id'] = df['report_id'].str.strip()
    
      
    ##reorder df columns
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
    col_list=df [["observation_id","latitude","longitude","report_id","source_id","date_time"]]
    hdf=col_list.copy()
    
    
    ##add required columns and set up values etc
    hdf[['primary_station_id', 'station_record_number', '1',"2,","3"]] = hdf['report_id'].str.split('-', expand=True)                                                    
    #hdf["observation_id"]=merged_df["observation_id"]                                                  
    hdf["report_id"]=df["report_id"]
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
    hdf['record_timestamp'] = pd.to_datetime('now').strftime("%Y-%m-%d %H:%M:%S")
    hdf.record_timestamp = hdf.record_timestamp + '+00'
    hdf["history"]=""
    hdf["processing_level"]="0"
    hdf["report_timestamp"]=df["date_time"]
    hdf['primary_station_id_2']=hdf['primary_station_id'].astype(str)+'-'+hdf['source_id'].astype(str)
    hdf["duplicates_report"]=hdf["report_id"]+'-'+hdf["station_record_number"].astype(str)
    station_id=hdf.iloc[1]["primary_station_id"]
        
          
    df2=pd.read_csv("D:/Python_CDM_conversion/daily/config_files/record_id_dy.csv")
    hdf = hdf.astype(str)
    df2 = df2.astype(str)
    hdf= df2.merge(hdf, on=['primary_station_id_2'])
    hdf['height_of_station_above_sea_level'] = hdf['height_of_station_above_sea_level'].astype(str).apply(lambda x: x.replace('.0',''))
    hdf["latitude"]=hdf["latitude_x"]
    hdf["longitude"]=hdf["longitude_x"]
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
  
   
        
         ##output of cdm observations files
    try:
        cdm_type=("cdm_obs_202111_test_")
        print(station_id2+"_obs")
        a = df['observed_variable'].unique()
        print (a)
        outname = os.path.join(OUTDIR,cdm_type)
        df.to_csv(outname+ station_id+ ".psv", index=False, sep="|")
    except:
       # Continue to next iteration 
        continue  

    
    ##output of cdm header files
    try:
        ## table output
       ##header table output
        
        cdm_type=("cdm_head_202111_test_")
        print(station_id+"_head")
        outname = os.path.join(OUTDIR2,cdm_type)
        #with open(filename, "w") as outfile:
        hdf.to_csv(outname+ station_id+ ".psv", index=False, sep="|")
              
    except:
        # Continue to next iteration.
        continue   

   
       
                                                               

                                                            
         
      
      
        
                 
    

  
        
                                                  
    
       
       
       
       
    
    
   

