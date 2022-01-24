#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Nov 11 16:31:58 2021

@author: snoone
"""

import os
import glob
import pandas as pd
pd.options.mode.chained_assignment = None  # default='warn'



OUTDIR = "/work/scratch-pw/snoone/qff_cdm_test_2021/cdmobs_out_sbdy_202111"
os.chdir("/gws/nopw/j04/c3s311a_lot2/data/level1/land/level1c_sub_daily_data/v20210728")
#extension = 'qff'
#my_file = open("D:/Python_CDM_conversion/hourly/qff/ls1.txt", "r")
#all_filenames = my_file.readlines()
#print(all_filenames)
##use  alist of file name sto run 5000 parallel
with open("/work/scratch-pw/snoone/qff_cdm_test_2021/station_list/ls1.txt", "r") as f:
    all_filenames = f.read().splitlines()
#all_filenames = [i for i in glob.glob('*.{}'.format(extension))]
##to start at begining of files
for filename in all_filenames:
##to start at next file after last processe 
#for filename in all_filenames[all_filenames.index('SWM00002338.qff'):] :
    df=pd.read_csv(filename, sep="|", low_memory=False)
     
    ##set up master df to extrcat each variable
    df["report_id"]=""
    df["observation_id"]=""
    df["data_policy_licence"]=""
    df["date_time_meaning"]="1"
    df["observation_duration"]="0"
    df["latitude"]=df["Latitude"]
    df["longitude"]=df["Longitude"]
    df["crs"]=""
    df["z_coordinate"]=""
    df["z_coordinate_type"]=""
    df["observation_height_above_station_surface"]=""
    df["observed_variable"]=""  
    df["secondary_variable"]=""
    df["observation_value"]=""
    df["value_significance"]="12" 
    df["secondary_value"]=""
    df["units"]=""
    df["code_table"]=""
    df["conversion_flag"]=""
    df["location_method"]=""
    df["location_precision"]=""
    df["z_coordinate_method"]=""
    df["bbox_min_longitude"]=""
    df["bbox_max_longitude"]=""
    df["bbox_min_latitude"]=""
    df["bbox_max_latitude"]=""
    df["spatial_representativeness"]=""
    df["original_code_table"]=""
    df["quality_flag"]=""
    df["numerical_precision"]=""
    df["sensor_id"]=""
    df["sensor_automation_status"]=""
    df["exposure_of_sensor"]=""
    df["original_precision"]=""
    df["original_units"]=""
    df["original_code_table"]=""
    df["original_value"]=""
    df["conversion_method"]=""
    df["processing_code"]=""
    df["processing_level"]="0"
    df["adjustment_id"]=""
    df["traceability"]=""
    df["advanced_qc"]=""
    df["advanced_uncertainty"]=""
    df["advanced_homogenisation"]=""
    df["advanced_assimilation_feedback"]=""
    df["secondary_id"]=""  
    df["source_id"]=""
    df["source_record_id"]=""
    df["primary_station_id"]=df["Station_ID"]
    df["Timestamp2"] = df["Year"].map(str) + "-" + df["Month"].map(str)+ "-" + df["Day"].map(str)  
    df["Seconds"]="00"
    df["offset"]="+00"
    df["date_time"] = df["Timestamp2"].map(str)+ " " + df["Hour"].map(str)+":"+df["Minute"].map(str)+":"+df["Seconds"].map(str) 
    df['date_time'] =  pd.to_datetime(df['date_time'], format='%Y/%m/%d' " ""%H:%M")
    df['date_time'] = df['date_time'].astype('str')
    df.date_time = df.date_time + '+00'

    
#=========================================================================================
##convert temperature    changes for each variable    
    dft = df[["observation_id","report_id","data_policy_licence","date_time",
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
               "advanced_assimilation_feedback","source_id","primary_station_id","secondary_id"]]
    
    ##change for each variable to convert to cdm compliant values
    dft["observation_value"]=df["temperature"]+273.15
    dft["secondary_id"]=df["temperature_Source_Station_ID"].astype('str')
    dft['secondary_id'] = dft['secondary_id'].astype(str).apply(lambda x: x.replace('.0',''))
    dft["source_id"]=df["temperature_Source_Code"]
    dft["Seconds"]="00"
    dft["quality_flag"]=df["temperature_QC_flag"]
    dft["qc_method"]=dft["quality_flag"]
    dft["conversion_flag"]="0"
    dft["conversion_method"]="1"
    dft["numerical_precision"]="0.01"
    dft["original_precision"]="0.1"
    dft["original_units"]="60"
    dft["original_value"]=df["temperature"]
    dft["observation_height_above_station_surface"]="2"
    dft["units"]="5"
    dft["observed_variable"]="85"
    
    
    ##set quality flag from df master for variable and fill all nan with Null then change all nonnan to 
    dft.loc[dft['quality_flag'].notnull(), "quality_flag"] = 1
    dft = dft.fillna("Null")
    dft.quality_flag[dft.quality_flag == "Null"] = 0  
    #change for each variable if required

    ##remove unwanted mising data rows
    dft = dft.fillna("null")
    dft = dft.replace({"null":"-99999"})
    dft = dft[dft.observation_value != -99999]
    dft = dft.dropna(subset=['secondary_id'])
    dft = dft.dropna(subset=['observation_value'])
    #df = df.astype(str)
    dft["source_id"] = pd.to_numeric(dft["source_id"],errors='coerce')
    #df = df.astype(str)
    #concatenate columns for joining df for next step
    dft['source_id'] = dft['source_id'].astype(str).apply(lambda x: x.replace('.0',''))
    dft['primary_station_id_2']=dft['secondary_id'].astype(str)+'-'+dft['source_id'].astype(str)
    dft["observation_value"] = pd.to_numeric(dft["observation_value"],errors='coerce')
    #dft.to_csv("ttest.csv", index=False, sep=",")
    
     ###add data policy and record number to df
    df2=pd.read_csv("/work/scratch-pw/snoone/qff_cdm_test_2021/station_list/record_id.csv", encoding='latin-1')
    dft = dft.astype(str)
    df2 = df2.astype(str)
    dft= df2.merge(dft, on=['primary_station_id_2'])
    dft['data_policy_licence'] = dft['data_policy_licence_x']
    dft['data_policy_licence'] = dft['data_policy_licence'].astype(str).apply(lambda x: x.replace('.0',''))
    
    dft['observation_id']=dft['primary_station_id'].astype(str)+'-'+dft['record_number'].astype(str)+'-'+dft['date_time'].astype(str)
    dft['observation_id'] = dft['observation_id'].str.replace(r' ', '-')
    ##remove unwanted last twpo characters
    dft['observation_id'] = dft['observation_id'].str[:-6]
    dft["observation_id"]=dft["observation_id"]+'-'+dft['observed_variable'].astype(str)+'-'+dft['value_significance'].astype(str)
    dft["report_id"]=dft["observation_id"].str[:-6]
     ##set up qc table
            
    dft = dft[["observation_id","report_id","data_policy_licence","date_time",
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
    df.dropna(subset = ["observation_value"], inplace=True)
    dft['source_id'] = dft['source_id'].astype(str).apply(lambda x: x.replace('.0',''))
    dft['data_policy_licence'] = dft['data_policy_licence'].astype(str).apply(lambda x: x.replace('.0',''))
    dft["source_id"] = pd.to_numeric(dft["source_id"],errors='coerce')
    dft["observation_value"] = pd.to_numeric(dft["observation_value"],errors='coerce')
    dft["observation_value"]= dft["observation_value"].round(2)
    
    #dft.to_csv("isuest.csv", index=False, sep=",")
    

    #=================================================================================
    ##convert dew point temperature   changes for each variable    
    dfdpt= df[["observation_id","report_id","data_policy_licence","date_time",
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
               "advanced_assimilation_feedback","source_id","primary_station_id","secondary_id"]]
    
    ##change for each variable to convert to cdm compliant values
    dfdpt["observation_value"]=df["dew_point_temperature"]+273.15
    dfdpt["secondary_id"]=df["dew_point_temperature_Source_Station_ID"].astype(str)
    dfdpt['secondary_id'] = dfdpt['secondary_id'].astype(str).apply(lambda x: x.replace('.0',''))
    dfdpt["source_id"]=df["dew_point_temperature_Source_Code"]
    dfdpt["Seconds"]="00"
    dfdpt["quality_flag"]=df["dew_point_temperature_QC_flag"]
    dfdpt["conversion_flag"]="0"
    dfdpt["conversion_method"]="1"
    dfdpt["numerical_precision"]="0.01"
    dfdpt["original_precision"]="0.1"
    dfdpt["original_units"]="60"
    dfdpt["original_value"]=df["dew_point_temperature"]
    dfdpt["observation_height_above_station_surface"]="2"
    dfdpt["units"]="5"
    dfdpt["observed_variable"]="36"
    
    
    ##set quality flag from df master for variable and fill all nan with Null then change all nonnan to 
    dfdpt.loc[dfdpt['quality_flag'].notnull(), "quality_flag"] = 1
    dfdpt= dfdpt.fillna("Null")
    dfdpt.quality_flag[dfdpt.quality_flag == "Null"] = 0  

    ##remove unwanted mising data rows
    dfdpt= dfdpt.fillna("null")
    dfdpt= dfdpt.replace({"null":"-99999"})
    dfdpt= dfdpt[dfdpt.observation_value != -99999]
    dfdpt = dfdpt.dropna(subset=['secondary_id'])
    dfdpt = dfdpt.dropna(subset=['observation_value'])
    #df = df.astype(str)
    dfdpt["source_id"] = pd.to_numeric(dfdpt["source_id"],errors='coerce')
    #df = df.astype(str)
    #concatenate columns for joining df for next step
    dfdpt['source_id'] = dfdpt['source_id'].astype(str).apply(lambda x: x.replace('.0',''))
    dfdpt['primary_station_id_2']=dfdpt['secondary_id'].astype(str)+'-'+dfdpt['source_id'].astype(str)
    dfdpt["observation_value"] = pd.to_numeric(dfdpt["observation_value"],errors='coerce')
    #dfdpt.to_csv("ttest.csv", index=False, sep=",")
    
     ###add data policy and record number to df
    df2=pd.read_csv("/work/scratch-pw/snoone/qff_cdm_test_2021/station_list/record_id.csv", encoding='latin-1')
    dfdpt= dfdpt.astype(str)
    df2 = df2.astype(str)
    dfdpt= df2.merge(dfdpt, on=['primary_station_id_2'])
    dfdpt['data_policy_licence'] = dfdpt['data_policy_licence_x']
    dfdpt['data_policy_licence'] = dfdpt['data_policy_licence'].astype(str).apply(lambda x: x.replace('.0',''))
    
    dfdpt['observation_id']=dfdpt['primary_station_id'].astype(str)+'-'+dfdpt['record_number'].astype(str)+'-'+dfdpt['date_time'].astype(str)
    dfdpt['observation_id'] = dfdpt['observation_id'].str.replace(r' ', '-')
    ##remove unwanted last twpo characters
    dfdpt['observation_id'] = dfdpt['observation_id'].str[:-6]
    dfdpt["observation_id"]=dfdpt["observation_id"]+'-'+dfdpt['observed_variable'].astype(str)+'-'+dfdpt['value_significance'].astype(str)
    dfdpt["report_id"]=dfdpt["observation_id"].str[:-6]
     ##set up qc table
            
    dfdpt= dfdpt[["observation_id","report_id","data_policy_licence","date_time",
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
    dfdpt.dropna(subset = ["observation_value"], inplace=True)
    dfdpt['source_id'] = dfdpt['source_id'].astype(str).apply(lambda x: x.replace('.0',''))
    dfdpt['data_policy_licence'] = dfdpt['data_policy_licence'].astype(str).apply(lambda x: x.replace('.0',''))
    dfdpt["source_id"] = pd.to_numeric(dfdpt["source_id"],errors='coerce')
    dfdpt["observation_value"] = pd.to_numeric(dfdpt["observation_value"],errors='coerce')
    dfdpt["observation_value"]= dfdpt["observation_value"].round(2)
    
    

    #====================================================================================
    #convert station level  to cdmlite
    dfslp = df[["observation_id","report_id","data_policy_licence","date_time",
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
               "advanced_assimilation_feedback","source_id","primary_station_id","secondary_id"]]
    
    ##change for each variable to convert to cdm compliant values
    dfslp["secondary_id"]=df["station_level_pressure_Source_Station_ID"].astype(str)
    dfslp['secondary_id'] = dfslp['secondary_id'].astype(str).apply(lambda x: x.replace('.0',''))
    dfslp["observation_value"]=df["station_level_pressure"].map(float)
    dfslp = dfslp.dropna(subset=['observation_value'])
    dfslp["source_id"]=df["station_level_pressure_Source_Code"]
    dfslp["Seconds"]="00"
    dfslp["quality_flag"]=df["station_level_pressure_QC_flag"]
    dfslp["conversion_flag"]="0"
    dfslp["conversion_method"]="7"
    dfslp["numerical_precision"]="10"
    dfslp["original_precision"]="0.1"
    dfslp["original_units"]="530"
    dfslp["original_value"]=df["station_level_pressure"]
    dfslp["observation_height_above_station_surface"]="2"
    dfslp["units"]="32"
    dfslp["observed_variable"]="57"
    
    
    ##set quality flag from df master for variable and fill all nan with Null then change all nonnan to 
    dfslp.loc[dfslp['quality_flag'].notnull(), "quality_flag"] = 1
    dfslp = dfslp.fillna("Null")
    dfslp.quality_flag[dfslp.quality_flag == "Null"] = 0  
    #change for each variable if required

    ##remove unwanted mising data rows
    dfslp = dfslp.fillna("null")
    dfslp = dfslp.replace({"null":"-99999"})
    dfslp = dfslp[dfslp.observation_value != -99999]
    dfslp = dfslp.dropna(subset=['secondary_id'])
    dfslp = dfslp.dropna(subset=['observation_value'])
    #df = df.astype(str)
    dfslp["source_id"] = pd.to_numeric(dfslp["source_id"],errors='coerce')
    #df = df.astype(str)
    #concatenate columns for joining df for next step
    dfslp['source_id'] = dfslp['source_id'].astype(str).apply(lambda x: x.replace('.0',''))
    dfslp['primary_station_id_2']=dfslp['secondary_id'].astype(str)+'-'+dfslp['source_id'].astype(str)
    #dfslp["observation_value"] = pd.to_numeric(dfslp["observation_value"],errors='coerce')
    #dfslp.to_csv("ttest.csv", index=False, sep=",")
    
     ###add data policy and record number to df
    df2=pd.read_csv("/work/scratch-pw/snoone/qff_cdm_test_2021/station_list/record_id.csv", encoding='latin-1')
    dfslp = dfslp.astype(str)
    df2 = df2.astype(str)
    dfslp= df2.merge(dfslp, on=['primary_station_id_2'])
    dfslp['data_policy_licence'] = dfslp['data_policy_licence_x']
    dfslp['data_policy_licence'] = dfslp['data_policy_licence'].astype(str).apply(lambda x: x.replace('.0',''))
    
    dfslp['observation_id']=dfslp['primary_station_id'].astype(str)+'-'+dfslp['record_number'].astype(str)+'-'+dfslp['date_time'].astype(str)
    dfslp['observation_id'] = dfslp['observation_id'].str.replace(r' ', '-')
    ##remove unwanted last twpo characters
    dfslp['observation_id'] = dfslp['observation_id'].str[:-6]
    dfslp["observation_id"]=dfslp["observation_id"]+'-'+dfslp['observed_variable'].astype(str)+'-'+dfslp['value_significance'].astype(str)
    dfslp["report_id"]=dfslp["observation_id"].str[:-6]
     ##set up qc table
            
    dfslp = dfslp[["observation_id","report_id","data_policy_licence","date_time",
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


##make sure no decimal places an dround value to reuqred decimal places
    dfslp['observation_value'] = dfslp['observation_value'].map(float)
    dfslp['observation_value'] = (dfslp['observation_value']*100)
    dfslp['observation_value'] = dfslp['observation_value'].map(int)
    dfslp['source_id'] = dfslp['source_id'].astype(str).apply(lambda x: x.replace('.0',''))
    dfslp['data_policy_licence'] = dfslp['data_policy_licence'].astype(str).apply(lambda x: x.replace('.0',''))
    dfslp["source_id"] = pd.to_numeric(dfslp["source_id"],errors='coerce')
    dfslp["observation_value"] = pd.to_numeric(dfslp["observation_value"],errors='coerce')
    dfslp['observation_value'] = dfslp['observation_value'].astype(str).apply(lambda x: x.replace('.0',''))
    dfslp.to_csv("slp.csv", index=False, sep=",")
   
    

    #===========================================================================================
     #convert sea level presure to cdmlite
    dfmslp = df[["observation_id","report_id","data_policy_licence","date_time",
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
               "advanced_assimilation_feedback","source_id","primary_station_id","secondary_id"]]
    
    ##change for each variable to convert to cdm compliant values
    dfmslp["secondary_id"]=df["sea_level_pressure_Source_Station_ID"].astype(str)
    dfmslp['secondary_id'] = dfmslp['secondary_id'].astype(str).apply(lambda x: x.replace('.0',''))
    dfmslp["observation_value"]=df["sea_level_pressure"].map(float)
    dfmslp = dfmslp.dropna(subset=['observation_value'])
    dfmslp["source_id"]=df["sea_level_pressure_Source_Code"]
    dfmslp["Seconds"]="00"
    dfmslp["quality_flag"]=df["sea_level_pressure_QC_flag"]
    dfmslp["conversion_flag"]="0"
    dfmslp["conversion_method"]="7"
    dfmslp["numerical_precision"]="10"
    dfmslp["original_precision"]="0.1"
    dfmslp["original_units"]="530"
    dfmslp["original_value"]=df["sea_level_pressure"]
    dfmslp["observation_height_above_station_surface"]="2"
    dfmslp["units"]="32"
    dfmslp["observed_variable"]="58"
    
    
    ##set quality flag from df master for variable and fill all nan with Null then change all nonnan to 
    dfmslp.loc[dfmslp['quality_flag'].notnull(), "quality_flag"] = 1
    dfmslp = dfmslp.fillna("Null")
    dfmslp.quality_flag[dfmslp.quality_flag == "Null"] = 0  
    #change for each variable if required

    ##remove unwanted mising data rows
    dfmslp = dfmslp.fillna("null")
    dfmslp = dfmslp.replace({"null":"-99999"})
    dfmslp = dfmslp[dfmslp.observation_value != -99999]
    dfmslp = dfmslp.dropna(subset=['secondary_id'])
    dfmslp = dfmslp.dropna(subset=['observation_value'])
    #df = df.astype(str)
    dfmslp["source_id"] = pd.to_numeric(dfmslp["source_id"],errors='coerce')
    #df = df.astype(str)
    #concatenate columns for joining df for next step
    dfmslp['source_id'] = dfmslp['source_id'].astype(str).apply(lambda x: x.replace('.0',''))
    dfmslp['primary_station_id_2']=dfmslp['secondary_id'].astype(str)+'-'+dfmslp['source_id'].astype(str)
   # dfmslp["observation_value"] = pd.to_numeric(dfmslp["observation_value"],errors='coerce')
    #dfmslp.to_csv("ttest.csv", index=False, sep=",")
    
     ###add data policy and record number to df
    df2=pd.read_csv("/work/scratch-pw/snoone/qff_cdm_test_2021/station_list/record_id.csv", encoding='latin-1')
    dfmslp = dfmslp.astype(str)
    df2 = df2.astype(str)
    dfmslp= df2.merge(dfmslp, on=['primary_station_id_2'])
    dfmslp['data_policy_licence'] = dfmslp['data_policy_licence_x']
    dfmslp['data_policy_licence'] = dfmslp['data_policy_licence'].astype(str).apply(lambda x: x.replace('.0',''))
    
    dfmslp['observation_id']=dfmslp['primary_station_id'].astype(str)+'-'+dfmslp['record_number'].astype(str)+'-'+dfmslp['date_time'].astype(str)
    dfmslp['observation_id'] = dfmslp['observation_id'].str.replace(r' ', '-')
    ##remove unwanted last twpo characters
    dfmslp['observation_id'] = dfmslp['observation_id'].str[:-6]
    dfmslp["observation_id"]=dfmslp["observation_id"]+'-'+dfmslp['observed_variable'].astype(str)+'-'+dfmslp['value_significance'].astype(str)
    dfmslp["report_id"]=dfmslp["observation_id"].str[:-6]
     ##set up qc table
            
    dfmslp = dfmslp[["observation_id","report_id","data_policy_licence","date_time",
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

##make sure no decimal places and round value to required decimal places
    
    dfmslp['observation_value'] = dfmslp['observation_value'].map(float)
    dfmslp['observation_value'] = (dfmslp['observation_value']*100)
    dfmslp['observation_value'] = dfmslp['observation_value'].map(int)
    dfmslp['source_id'] = dfmslp['source_id'].astype(str).apply(lambda x: x.replace('.0',''))
    dfmslp["observation_value"] = pd.to_numeric(dfmslp["observation_value"],errors='coerce')
    dfmslp['data_policy_licence'] = dfmslp['data_policy_licence'].astype(str).apply(lambda x: x.replace('.0',''))
    dfmslp["source_id"] = pd.to_numeric(dfmslp["source_id"],errors='coerce')
    dfmslp['observation_value'] = dfmslp['observation_value'].astype(str).apply(lambda x: x.replace('.0',''))
   
    

    #========================================================================================================
    #wind direction convert to cdm lite
    dfwd = df[["observation_id","report_id","data_policy_licence","date_time",
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
               "advanced_assimilation_feedback","source_id","primary_station_id","secondary_id"]]
    
    ##change for each variable to convert to cdm compliant values
    dfwd["secondary_id"]=df["wind_direction_Source_Station_ID"].astype(str)
    dfwd['secondary_id'] = dfwd['secondary_id'].astype(str).apply(lambda x: x.replace('.0',''))
    dfwd["observation_value"]=df["wind_direction"]
    dfwd["source_id"]=df["wind_direction_Source_Code"]
    dfwd["Seconds"]="00"
    dfwd["quality_flag"]=df["wind_direction_QC_flag"]
    dfwd["conversion_flag"]="1"
    dfwd["conversion_method"]=""
    dfwd["numerical_precision"]="1"
    dfwd["original_precision"]="1"
    dfwd["original_units"]="110"
    dfwd["original_value"]=df["wind_direction"]
    dfwd["observation_height_above_station_surface"]="10"
    dfwd["units"]="110"
    dfwd["observed_variable"]="106"
    
    
    ##set quality flag from df master for variable and fill all nan with Null then change all nonnan to 
    dfwd.loc[dfwd['quality_flag'].notnull(), "quality_flag"] = 1
    dfwd = dfwd.fillna("Null")
    dfwd.quality_flag[dfwd.quality_flag == "Null"] = 0  
    #change for each variable if required

    ##remove unwanted mising data rows
    dfwd = dfwd.fillna("null")
    dfwd = dfwd.replace({"null":"-99999"})
    dfwd = dfwd[dfwd.observation_value != -99999]
    dfwd = dfwd.dropna(subset=['secondary_id'])
    dfwd = dfwd.dropna(subset=['observation_value'])
    #df = df.astype(str)
    dfwd["source_id"] = pd.to_numeric(dfwd["source_id"],errors='coerce')
    #df = df.astype(str)
    #concatenate columns for joining df for next step
    dfwd['source_id'] = dfwd['source_id'].astype(str).apply(lambda x: x.replace('.0',''))
    dfwd['primary_station_id_2']=dfwd['secondary_id'].astype(str)+'-'+dfwd['source_id'].astype(str)
    dfwd["observation_value"] = pd.to_numeric(dfwd["observation_value"],errors='coerce')
    #dfwd.to_csv("ttest.csv", index=False, sep=",")
    
     ###add data policy and record number to df
    df2=pd.read_csv("/work/scratch-pw/snoone/qff_cdm_test_2021/station_list/record_id.csv", encoding='latin-1')
    dfwd = dfwd.astype(str)
    df2 = df2.astype(str)
    dfwd= df2.merge(dfwd, on=['primary_station_id_2'])
    dfwd['data_policy_licence'] = dfwd['data_policy_licence_x']
    dfwd['data_policy_licence'] = dfwd['data_policy_licence'].astype(str).apply(lambda x: x.replace('.0',''))
    
    dfwd['observation_id']=dfwd['primary_station_id'].astype(str)+'-'+dfwd['record_number'].astype(str)+'-'+dfwd['date_time'].astype(str)
    dfwd['observation_id'] = dfwd['observation_id'].str.replace(r' ', '-')
    ##remove unwanted last twpo characters
    dfwd['observation_id'] = dfwd['observation_id'].str[:-6]
    dfwd["observation_id"]=dfwd["observation_id"]+'-'+dfwd['observed_variable'].astype(str)+'-'+dfwd['value_significance'].astype(str)
    dfwd["report_id"]=dfwd["observation_id"].str[:-7]
     ##set up qc table
            
    dfwd = dfwd[["observation_id","report_id","data_policy_licence","date_time",
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

    

##make sure no decimal places an dround value to reuqred decimal places
    dfwd.dropna(subset = ["observation_value"], inplace=True)
    dfwd['observation_value'] = dfwd['observation_value'].astype(str).apply(lambda x: x.replace('.0',''))
    dfwd['source_id'] = dfwd['source_id'].astype(str).apply(lambda x: x.replace('.0',''))
    dfwd['data_policy_licence'] = dfwd['data_policy_licence'].astype(str).apply(lambda x: x.replace('.0',''))
    dfwd["source_id"] = pd.to_numeric(dfwd["source_id"],errors='coerce')
    
    
    #===========================================================================
    ## wind speed convert to cdm lite
    dfws = df[["observation_id","report_id","data_policy_licence","date_time",
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
               "advanced_assimilation_feedback","source_id","primary_station_id","secondary_id"]]
    
    ##change for each variable to convert to cdm compliant values
    dfws["secondary_id"]=df["wind_speed_Source_Station_ID"].astype(str)
    dfws['secondary_id'] = dfws['secondary_id'].astype(str).apply(lambda x: x.replace('.0',''))
    dfws["observation_value"]=df["wind_speed"]
    dfws["source_id"]=df["wind_speed_Source_Code"]
    dfws["Seconds"]="00"
    dfws["quality_flag"]=df["wind_speed_QC_flag"]
    dfws["conversion_flag"]="2"
    dfws["conversion_method"]=""
    dfws["numerical_precision"]="0.1"
    dfws["original_precision"]="0.1"
    dfws["original_units"]="731"
    dfws["original_value"]=df["wind_speed"]
    dfws["observation_height_above_station_surface"]="10"
    dfws["units"]="731"
    dfws["observed_variable"]="107"
    
    
    ##set quality flag from df master for variable and fill all nan with Null then change all non-nan to 
    dfws.loc[dfws['quality_flag'].notnull(), "quality_flag"] = 1
    dfws = dfws.fillna("Null")
    dfws.quality_flag[dfws.quality_flag == "Null"] = 0  
    #change for each variable if required

    ##remove unwanted mising data rows
    dfws = dfws.fillna("null")
    dfws = dfws.replace({"null":"-99999"})
    dfws = dfws[dfws.observation_value != -99999]
    dfws = dfws.dropna(subset=['secondary_id'])
    dfws = dfws.dropna(subset=['observation_value'])
    #df = df.astype(str)
    dfws["source_id"] = pd.to_numeric(dfws["source_id"],errors='coerce')
    #df = df.astype(str)
    #concatenate columns for joining df for next step
    dfws['source_id'] = dfws['source_id'].astype(str).apply(lambda x: x.replace('.0',''))
    dfws['primary_station_id_2']=dfws['secondary_id'].astype(str)+'-'+dfws['source_id'].astype(str)
    dfws["observation_value"] = pd.to_numeric(dfws["observation_value"],errors='coerce')
    #dfws.to_csv("ttest.csv", index=False, sep=",")
    
     ###add data policy and record number to df
    df2=pd.read_csv("/work/scratch-pw/snoone/qff_cdm_test_2021/station_list/record_id.csv", encoding='latin-1')
    dfws = dfws.astype(str)
    df2 = df2.astype(str)
    dfws= df2.merge(dfws, on=['primary_station_id_2'])
    dfws['data_policy_licence'] = dfws['data_policy_licence_x']
    dfws['data_policy_licence'] = dfws['data_policy_licence'].astype(str).apply(lambda x: x.replace('.0',''))
    
    dfws['observation_id']=dfws['primary_station_id'].astype(str)+'-'+dfws['record_number'].astype(str)+'-'+dfws['date_time'].astype(str)
    dfws['observation_id'] = dfws['observation_id'].str.replace(r' ', '-')
    ##remove unwanted last twpo characters
    dfws['observation_id'] = dfws['observation_id'].str[:-6]
    dfws["observation_id"]=dfws["observation_id"]+'-'+dfws['observed_variable'].astype(str)+'-'+dfws['value_significance'].astype(str)
    dfws["report_id"]=dfws["observation_id"].str[:-7]
     ##set up qc table
            
    dfws = dfws[["observation_id","report_id","data_policy_licence","date_time",
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

##make sure no decimal places an dround value to reuqred decimal places
    dfws.dropna(subset = ["observation_value"], inplace=True)
    dfws['source_id'] = dfws['source_id'].astype(str).apply(lambda x: x.replace('.0',''))
    dfws['data_policy_licence'] = dfws['data_policy_licence'].astype(str).apply(lambda x: x.replace('.0',''))
    dfws["source_id"] = pd.to_numeric(dfws["source_id"],errors='coerce')
    dfws["observation_value"] = pd.to_numeric(dfws["observation_value"],errors='coerce')
    dfws["observation_value"]= dfws["observation_value"].round(2)
    ##merge all df into one cdmlite file
    merged_df=pd.concat([dfdpt,dft,dfslp,dfmslp,dfwd,dfws], axis=0)
    del dfdpt
    del dft
    del dfslp
    del dfmslp
    del dfwd
    del dfws
    
    merged_df.sort_values("date_time")
    
    merged_df["latitude"] = pd.to_numeric(merged_df["latitude"],errors='coerce')
    merged_df["longitude"] = pd.to_numeric(merged_df["longitude"],errors='coerce')
    merged_df["latitude"]= merged_df["latitude"].round(3)
    merged_df["longitude"]= merged_df["longitude"].round(3)
    
          
    ##name the cdm_lite files e.g. cdm_lite _”insert date of run”_EG000062417.psv)
    try:
        station_id=df.iloc[1]["primary_station_id"]
        cdm_type=("cdm_obs_202111_test_")
        print(station_id+"_obs")
        a = merged_df['observed_variable'].unique()
        print (a)
        outname = os.path.join(OUTDIR,cdm_type)
        #with open(filename, "w") as outfile:
        merged_df.to_csv(outname+ station_id+ ".psv", index=False, sep="|")
        ###save qc table to directory
    except:
        # Continue to next iteration.
        continue   
    
    
    
    
    
    
    

