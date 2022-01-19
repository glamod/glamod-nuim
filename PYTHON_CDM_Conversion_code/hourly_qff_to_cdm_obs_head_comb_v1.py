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



OUTDIR2= "D:/Python_CDM_conversion/hourly/qff/cdm_out/observations_table"
OUTDIR = "D:/Python_CDM_conversion/hourly/qff/cdm_out/header_table"
os.chdir("D:/Python_CDM_conversion/hourly/qff/test")
extension = 'qff'
#my_file = open("D:/Python_CDM_conversion/hourly/qff/ls1.txt", "r")
#all_filenames = my_file.readlines()
#print(all_filenames)
##use  alist of file name sto run 5000 parallel
#with open("D:/Python_CDM_conversion/hourly/qff/ls.txt", "r") as f:
#    all_filenames = f.read().splitlines()
all_filenames = [i for i in glob.glob('*.{}'.format(extension))]
##to start at begining of files
for filename in all_filenames:
##to start at next file after last processe 
#for filename in all_filenames[all_filenames.index('SWM00002338.qff'):] :
    df=pd.read_csv(filename, sep="|")
     
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
               "advanced_assimilation_feedback","source_id","primary_station_id"]]
    
    ##change for each variable to convert to cdm compliant values
    dft["observation_value"]=df["temperature"]+273.15
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
    #df = df.astype(str)
    dft["source_id"] = pd.to_numeric(dft["source_id"],errors='coerce')
    #df = df.astype(str)
    #concatenate columns for joining df for next step
    dft['source_id'] = dft['source_id'].astype(str).apply(lambda x: x.replace('.0',''))
    dft['primary_station_id_2']=dft['primary_station_id'].astype(str)+'-'+dft['source_id'].astype(str)
    dft["observation_value"] = pd.to_numeric(dft["observation_value"],errors='coerce')
    #dft.to_csv("ttest.csv", index=False, sep=",")
    
     ###add data policy and record number to df
    df2=pd.read_csv("D:/Python_CDM_conversion/new recipe tables/record_id.csv")
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
               "advanced_assimilation_feedback","source_id","primary_station_id"]]
    
    ##change for each variable to convert to cdm compliant values
    dfdpt["observation_value"]=df["dew_point_temperature"]+273.15
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
    #df = df.astype(str)
    dfdpt["source_id"] = pd.to_numeric(dfdpt["source_id"],errors='coerce')
    #df = df.astype(str)
    #concatenate columns for joining df for next step
    dfdpt['source_id'] = dfdpt['source_id'].astype(str).apply(lambda x: x.replace('.0',''))
    dfdpt['primary_station_id_2']=dfdpt['primary_station_id'].astype(str)+'-'+dfdpt['source_id'].astype(str)
    dfdpt["observation_value"] = pd.to_numeric(dfdpt["observation_value"],errors='coerce')
    #dfdpt.to_csv("ttest.csv", index=False, sep=",")
    
     ###add data policy and record number to df
    df2=pd.read_csv("D:/Python_CDM_conversion/new recipe tables/record_id.csv")
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
               "advanced_assimilation_feedback","source_id","primary_station_id"]]
    
    ##change for each variable to convert to cdm compliant values
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
    #df = df.astype(str)
    dfslp["source_id"] = pd.to_numeric(dfslp["source_id"],errors='coerce')
    #df = df.astype(str)
    #concatenate columns for joining df for next step
    dfslp['source_id'] = dfslp['source_id'].astype(str).apply(lambda x: x.replace('.0',''))
    dfslp['primary_station_id_2']=dfslp['primary_station_id'].astype(str)+'-'+dfslp['source_id'].astype(str)
    #dfslp["observation_value"] = pd.to_numeric(dfslp["observation_value"],errors='coerce')
    #dfslp.to_csv("ttest.csv", index=False, sep=",")
    
     ###add data policy and record number to df
    df2=pd.read_csv("D:/Python_CDM_conversion/new recipe tables/record_id.csv")
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
    #dfslp.to_csv("slp.csv", index=False, sep=",")
   
    

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
               "advanced_assimilation_feedback","source_id","primary_station_id"]]
    
    ##change for each variable to convert to cdm compliant values
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
    #df = df.astype(str)
    dfmslp["source_id"] = pd.to_numeric(dfmslp["source_id"],errors='coerce')
    #df = df.astype(str)
    #concatenate columns for joining df for next step
    dfmslp['source_id'] = dfmslp['source_id'].astype(str).apply(lambda x: x.replace('.0',''))
    dfmslp['primary_station_id_2']=dfmslp['primary_station_id'].astype(str)+'-'+dfmslp['source_id'].astype(str)
   # dfmslp["observation_value"] = pd.to_numeric(dfmslp["observation_value"],errors='coerce')
    #dfmslp.to_csv("ttest.csv", index=False, sep=",")
    
     ###add data policy and record number to df
    df2=pd.read_csv("D:/Python_CDM_conversion/new recipe tables/record_id.csv")
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
               "advanced_assimilation_feedback","source_id","primary_station_id"]]
    
    ##change for each variable to convert to cdm compliant values
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
    #df = df.astype(str)
    dfwd["source_id"] = pd.to_numeric(dfwd["source_id"],errors='coerce')
    #df = df.astype(str)
    #concatenate columns for joining df for next step
    dfwd['source_id'] = dfwd['source_id'].astype(str).apply(lambda x: x.replace('.0',''))
    dfwd['primary_station_id_2']=dfwd['primary_station_id'].astype(str)+'-'+dfwd['source_id'].astype(str)
    dfwd["observation_value"] = pd.to_numeric(dfwd["observation_value"],errors='coerce')
    #dfwd.to_csv("ttest.csv", index=False, sep=",")
    
     ###add data policy and record number to df
    df2=pd.read_csv("D:/Python_CDM_conversion/new recipe tables/record_id.csv")
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
               "advanced_assimilation_feedback","source_id","primary_station_id"]]
    
    ##change for each variable to convert to cdm compliant values
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
    #df = df.astype(str)
    dfws["source_id"] = pd.to_numeric(dfws["source_id"],errors='coerce')
    #df = df.astype(str)
    #concatenate columns for joining df for next step
    dfws['source_id'] = dfws['source_id'].astype(str).apply(lambda x: x.replace('.0',''))
    dfws['primary_station_id_2']=dfws['primary_station_id'].astype(str)+'-'+dfws['source_id'].astype(str)
    dfws["observation_value"] = pd.to_numeric(dfws["observation_value"],errors='coerce')
    #dfws.to_csv("ttest.csv", index=False, sep=",")
    
     ###add data policy and record number to df
    df2=pd.read_csv("D:/Python_CDM_conversion/new recipe tables/record_id.csv")
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
    hdf=merged_df [["observation_id","latitude","longitude","report_id","source_id","date_time"]]
      
###produce headre table usi hdf = pd.DataFrame()  
    #hdf['observation_id'] = hdf['observation_id'].str[:11]
    hdf["application_area"]=""
    hdf["observing_programme"]=""
    hdf["report_type"]="0"
    hdf["station_type"]="1"
    hdf["platform_type"]=""
    hdf["primary_station_id"]=hdf["report_id"].str[:11]
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
    hdf["report_meaning_of_timestamp"]="2"
    hdf["report_timestamp"]=""
    hdf["report_duration"]="0"
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
    hdf["report_timestamp"]=hdf["date_time"]
    hdf['primary_station_id_2']=hdf['primary_station_id'].astype(str)+'-'+hdf['source_id'].astype(str)
    hdf["station_record_number"]=hdf["report_id"].str.slice(start=-18)
    hdf["station_record_number"]=hdf["station_record_number"].str[0:1:1]
    hdf["duplicates_report"]=hdf["report_id"]+'-'+hdf["station_record_number"].astype(str)
    ##save sttaion id for output fuilename later
    
    
  ###FAILLS HERE WITH READING DF2
            
    df2=pd.read_csv("D:/Python_CDM_conversion/new recipe tables/record_id.csv")
    hdf = hdf.astype(str)
    df2 = df2.astype(str)
    hdf= df2.merge(hdf, on=['primary_station_id_2'])
    hdf["station_name"]=hdf["Station_name"]
    hdf["station_record_number"]=hdf["record_number"]
    hdf['report_id']=hdf['primary_station_id'].astype(str)+'-'+hdf['station_record_number'].astype(str)+'-'+hdf['report_timestamp'].astype(str)
    hdf['report_id'] = hdf['report_id'].str.replace(r' ', '-')
    ##remove unwanted last twpo characters
    hdf['report_id'] = hdf['report_id'].str[:-6]
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
      
    hdf['region'] = hdf['region'].astype(str).apply(lambda x: x.replace('.0',''))
    hdf['sub_region'] = hdf['sub_region'].astype(str).apply(lambda x: x.replace('.0',''))
    
    #hdf.to_csv("hdf7.csv", index=False, sep=",")
    
    #copy columns needd for header table
    
       
    
    
    ##name the cdm_lite files e.g. cdm_lite _”insert date of run”_EG000062417.psv)
    
    ## table output
       ##header table output
    try:
        station_id=df.iloc[1]["Station_ID"]
        cdm_type=("cdm_head_202111_test_")
        print(station_id+"_"+"header")
        outname = os.path.join(OUTDIR,cdm_type)
        #with open(filename, "w") as outfile:
        hdf.to_csv(outname+ station_id+ ".psv", index=False, sep="|")
              
    
        # Continue to next iteration.
               
       
       
          
    ##name the cdm_lite files e.g. cdm_lite _”insert date of run”_EG000062417.psv)
    
        #station_id=df.iloc[1]["primary_station_id"]
        station_id=df.iloc[1]["Station_ID"]
        cdm_type=("cdm_obs_202111_test_")
        print(station_id+"_obs")
        a = merged_df['observed_variable'].unique()
        print (a)
        outname = os.path.join(OUTDIR2,cdm_type)
        #with open(filename, "w") as outfile:
        merged_df.to_csv(outname+ station_id+ ".psv", index=False, sep="|")
       
    except:
        # Continue to next iteration.
        continue   
    
    
    
    
    
    
    

