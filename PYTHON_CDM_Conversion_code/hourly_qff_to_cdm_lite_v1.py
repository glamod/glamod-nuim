# -*- coding: utf-8 -*-
"""
Convert QFF files to CDM Lite .psv files (one per station).

CDM Lite files have all variables, one after another.

Created on Thu Nov 11 16:31:58 2021

@author: snoone
"""

import os
import glob
import pandas as pd
pd.options.mode.chained_assignment = None  # default='warn'


# Set the paths
OUTDIR2= "/work/scratch-pw/snoone/qff_cdm_test_2021/qc_tables_sbdy_202111"
OUTDIR = "/work/scratch-pw/snoone/qff_cdm_test_2021/cdmLite_out_sbdy_202111"
os.chdir("/gws/nopw/j04/c3s311a_lot2/data/level1/land/level1c_sub_daily_data/v20210728")

# Read in either single file, list of files or run all
#extension = 'qff'
# = [i for i in glob.glob('*.{}'.format(extension))]
# Read filenames form a list of 5000 to parallel
with open("/work/scratch-pw/snoone/qff_cdm_test_2021/station_list/ls1.txt", "r") as f:
    all_filenames = f.read().splitlines()
# To start at begining of files
for filename in all_filenames:

# To start at next file after last processes 
#for filename in all_filenames[all_filenames.index('FRI0000LFBF.qff'):] :
    df=pd.read_csv(filename, sep="|",low_memory=False)
     
    ##set up master dataframe to extract each variable
    
    df["report_type"]="0"
    df["units"]=""
    df["source_id"]=""
    df["Minute"]="00"
    df["observation_height_above_station_surface"]=""
    df["date_time_meaning"]="1"
    df["latitude"]=df["Latitude"]
    df["longitude"]=df["Longitude"]
    df["observed_variable"]=""  
    df["value_significance"]="12" 
    df["observation_duration"]="0"
    df["observation_value"]=""
    df["platform_type"]=""
    df["station_type"]="1"
    df["observation_id"]=""
    df["data_policy_licence"]=""
    df["primary_station_id"]=df["Station_ID"]
    df["secondary_id"]=""                                   
    df["station_name"]=df["Station_name"]
    df["quality_flag"]=""
    df["latitude"] = pd.to_numeric(df["Latitude"],errors='coerce')
    df["longitude"] = pd.to_numeric(df["Longitude"],errors='coerce')
    df["latitude"]= df["latitude"].round(3)
    df["longitude"]= df["longitude"].round(3)
    df["Timestamp2"] = df["Year"].map(str) + "-" + df["Month"].map(str)+ "-" + df["Day"].map(str)  
    df["Seconds"]="00"
    df["offset"]="+00"
    df["date_time"] = df["Timestamp2"].map(str)+ " " + df["Hour"].map(str)+":"+df["Minute"].map(str)+":"+df["Seconds"].map(str) 
    df['date_time'] =  pd.to_datetime(df['date_time'], format='%Y/%m/%d' " ""%H:%M")
    df['date_time'] = df['date_time'].astype('str')
    df.date_time = df.date_time + '+00'
    
    # =========================================================================================
    # Convert temperature [fields used change for each variable]
    dft = df[["observation_id","report_type","date_time","date_time_meaning",
              "latitude","longitude","observation_height_above_station_surface"
              ,"observed_variable","units","observation_value",
              "value_significance","observation_duration","platform_type",
              "station_type","primary_station_id","station_name","quality_flag"
              ,"data_policy_licence","source_id","secondary_id"]]

    # Change for each variable to convert to CDM compliant values
    dft["observation_value"]=df["temperature"]+273.15
    dft["source_id"]=df["temperature_Source_Code"]
    dft["secondary_id"]=df["temperature_Source_Station_ID"].astype('str')
    dft['secondary_id'] = dft['secondary_id'].astype(str).apply(lambda x: x.replace('.0',''))
    
    # Extract QC information for QC tables
    dft["quality_flag"]=df["temperature_QC_flag"]
    dft["qc_method"]=dft["quality_flag"]
    dft["report_id"]=dft["date_time"]
    
    # Set quality flag from master dataframe for variable
    #    and fill all nan with Null then change all nonnan to 1
    dft.loc[dft['quality_flag'].notnull(), "quality_flag"] = 1
    dft = dft.fillna("Null")
    dft.quality_flag[dft.quality_flag == "Null"] = 0
    
    # Change for each variable if required
    dft["observation_height_above_station_surface"]="2"
    dft["units"]="5"
    dft["observed_variable"]="85"
    
    # Remove unwanted missing data rows
    dft = dft.fillna("null")
    dft = dft.replace({"null":"-99999"})
    dft = dft[dft.observation_value != -99999]
    dft = dft.dropna(subset=['secondary_id'])
    dft = dft.dropna(subset=['observation_value'])
    #df = df.astype(str)
    dft["source_id"] = pd.to_numeric(dft["source_id"],errors='coerce')
    #df = df.astype(str)
    
    # Concatenate columns for joining dataframe in next step
    dft['source_id'] = dft['source_id'].astype(str).apply(
        lambda x: x.replace('.0',''))
    dft['primary_station_id_2']=dft['secondary_id'].astype(str)+'-'+dft['source_id'].astype(str)
    dft["observation_value"] = pd.to_numeric(dft["observation_value"], errors='coerce')
    #dft.to_csv("ttest.csv", index=False, sep=",")
    
    # Add data policy and record number to dataframe
    df2=pd.read_csv("/work/scratch-pw/snoone/qff_cdm_test_2021/station_list/record_id.csv", encoding='latin-1')
    dft = dft.astype(str)
    df2 = df2.astype(str)
    dft= df2.merge(dft, on=['primary_station_id_2'])
    dft['data_policy_licence'] = dft['data_policy_licence_x']
    dft['data_policy_licence'] = dft['data_policy_licence'].astype(str).apply(lambda x: x.replace('.0',''))

    # Restrict to required columns
    dft = dft[["observation_id","record_number","report_type","date_time","date_time_meaning",
              "latitude","longitude","observation_height_above_station_surface"
              ,"observed_variable","units","observation_value",
              "value_significance","observation_duration","platform_type",
              "station_type","primary_station_id","station_name","quality_flag"
              ,"data_policy_licence","source_id","report_id","qc_method"]]

    # Concatenate more columns together
    dft['observation_id']=dft['primary_station_id'].astype(str)+'-'+dft['record_number'].astype(str)+'-'+dft['date_time'].astype(str)
    dft['observation_id'] = dft['observation_id'].str.replace(r' ', '-')

    # Remove unwanted last two characters
    dft['observation_id'] = dft['observation_id'].str[:-6]
    dft["observation_id"]=dft["observation_id"]+'-'+dft['observed_variable'].astype(str)+'-'+dft['value_significance'].astype(str)
    
    # Set up QC table
    qct= dft[["primary_station_id","report_id","record_number","qc_method","quality_flag","observed_variable","value_significance"]]

    # Concatentate more columns together
    qct["observation_id"] = qct["primary_station_id"]+"-"+ qct["record_number"] +"-"+ qct["report_id"]+'-'+qct['observed_variable'].astype(str)+'-'+qct['value_significance'].astype(str)
    qct["report_id"] = qct["primary_station_id"]+"-"+ qct["report_id"] 
    qct['report_id'] = qct['report_id'].str[:-6]
    qct= qct[["report_id","observation_id","qc_method","quality_flag"]]
    qct["quality_flag"] = pd.to_numeric(qct["quality_flag"],errors='coerce')
    qct = qct.fillna("Null")
    qct= qct[qct['quality_flag'] != 0]

    # Restrict to required columns
    dft = dft[["observation_id","report_type","date_time","date_time_meaning",
              "latitude","longitude","observation_height_above_station_surface"
              ,"observed_variable","units","observation_value",
              "value_significance","observation_duration","platform_type",
              "station_type","primary_station_id","station_name","quality_flag"
              ,"data_policy_licence","source_id",]]
    
    # Make sure no decimal places and round value to required number of decimal places
    dft['source_id'] = dft['source_id'].astype(str).apply(lambda x: x.replace('.0',''))
    dft['data_policy_licence'] = dft['data_policy_licence'].astype(str).apply(lambda x: x.replace('.0',''))
    dft["source_id"] = pd.to_numeric(dft["source_id"],errors='coerce')
    dft["observation_value"] = pd.to_numeric(dft["observation_value"],errors='coerce')
    dft["observation_value"]= dft["observation_value"].round(2)


    # =================================================================================
    # Convert dew point temperature
    dfdpt = df[["observation_id","report_type","date_time","date_time_meaning",
              "latitude","longitude","observation_height_above_station_surface"
              ,"observed_variable","units","observation_value",
              "value_significance","observation_duration","platform_type",
              "station_type","primary_station_id","station_name","quality_flag"
              ,"data_policy_licence","source_id","secondary_id"]]
    
    # Change for each variable to convert to CDM compliant values
    dfdpt["secondary_id"]=df["dew_point_temperature_Source_Station_ID"].astype(str)
    dfdpt['secondary_id'] = dfdpt['secondary_id'].astype(str).apply(lambda x: x.replace('.0',''))
    dfdpt["observation_value"]=df["dew_point_temperature"]+273.15
    dfdpt["source_id"]=df["dew_point_temperature_Source_Code"]

    # Extract QC information for QC tables
    dfdpt["quality_flag"]=df["dew_point_temperature_QC_flag"]
    dfdpt["qc_method"]=dfdpt["quality_flag"]
    dfdpt["report_id"]=dfdpt["date_time"]
    
    # Set quality flag from master dataframe for variable
    #    and fill all nan with Null then change all nonnan to 1
    dfdpt.loc[dfdpt['quality_flag'].notnull(), "quality_flag"] = 1
    dfdpt = dfdpt.fillna("Null")
    dfdpt.quality_flag[dfdpt.quality_flag == "Null"] = 0  

    # Change for each variable if required
    dfdpt["observation_height_above_station_surface"]="2"
    dfdpt["units"]="5"
    dfdpt["observed_variable"]="36"

    # Remove unwanted mising data rows
    dfdpt = dfdpt.fillna("null")
    dfdpt = dfdpt.replace({"null":"-99999"})
    dfdpt = dfdpt[dfdpt.observation_value != -99999]
    dfdpt = dfdpt.dropna(subset=['secondary_id'])
    dfdpt = dfdpt.dropna(subset=['observation_value'])
    #df = df.astype(str)
    dfdpt["source_id"] = pd.to_numeric(dfdpt["source_id"],errors='coerce')
    #df = df.astype(str)
    
    # Concatenate columns for joining dataframe for next step
    dfdpt['source_id'] = dfdpt['source_id'].astype(str).apply(lambda x: x.replace('.0',''))
    dfdpt['primary_station_id_2']=dfdpt['secondary_id'].astype(str)+'-'+dfdpt['source_id'].astype(str)
    dfdpt["observation_value"] = pd.to_numeric(dfdpt["observation_value"],errors='coerce')
    #dft.to_csv("ttest.csv", index=False, sep=",")
    
    # Add data policy and record numbers to dataframe
    df2=pd.read_csv("/work/scratch-pw/snoone/qff_cdm_test_2021/station_list/record_id.csv", encoding='latin-1')
    dfdpt = dfdpt.astype(str)
    df2 = df2.astype(str)
    dfdpt= df2.merge(dfdpt, on=['primary_station_id_2'])
    dfdpt['data_policy_licence'] = dfdpt['data_policy_licence_x']
    dfdpt['data_policy_licence'] = dfdpt['data_policy_licence'].astype(str).apply(lambda x: x.replace('.0',''))

    # Restrict to required columns
    dfdpt = dfdpt[["observation_id","record_number","report_type","date_time","date_time_meaning",
              "latitude","longitude","observation_height_above_station_surface"
              ,"observed_variable","units","observation_value",
              "value_significance","observation_duration","platform_type",
              "station_type","primary_station_id","station_name","quality_flag"
              ,"data_policy_licence","source_id","report_id","qc_method"]]

    # Concatenate more columns together
    dfdpt['observation_id']=dfdpt['primary_station_id'].astype(str)+'-'+dfdpt['record_number'].astype(str)+'-'+dfdpt['date_time'].astype(str)
    dfdpt['observation_id'] = dfdpt['observation_id'].str.replace(r' ', '-')
    
    # Remove unwanted last two characters
    dfdpt['observation_id'] = dfdpt['observation_id'].str[:-6]
    dfdpt["observation_id"]=dfdpt["observation_id"]+'-'+dfdpt['observed_variable'].astype(str)+'-'+dfdpt['value_significance'].astype(str)

    # Set up QC table
    qcdpt=dfdpt[["primary_station_id","report_id","record_number","qc_method","quality_flag","observed_variable","value_significance"]]
    qcdpt["observation_id"] = qcdpt["primary_station_id"]+"-"+ qcdpt["record_number"] +"-"+ qcdpt["report_id"]+'-'+qcdpt['observed_variable'].astype(str)+'-'+qcdpt['value_significance'].astype(str)
    qcdpt["report_id"] = qcdpt["primary_station_id"]+"-"+ qcdpt["report_id"] 
    qcdpt['report_id'] = qcdpt['report_id'].str[:-6]
    qcdpt= qcdpt[["report_id","observation_id","qc_method","quality_flag"]]
    qcdpt["quality_flag"] = pd.to_numeric(qcdpt["quality_flag"],errors='coerce')
    qcdpt = qcdpt.fillna("Null")
    qcdpt= qcdpt[qcdpt['quality_flag'] != 0]
  
    # Restrict to required columns
    dfdpt = dfdpt[["observation_id","report_type","date_time","date_time_meaning",
              "latitude","longitude","observation_height_above_station_surface"
              ,"observed_variable","units","observation_value",
              "value_significance","observation_duration","platform_type",
              "station_type","primary_station_id","station_name","quality_flag"
              ,"data_policy_licence","source_id"]]

    
    dfdpt['source_id'] = dfdpt['source_id'].astype(str).apply(lambda x: x.replace('.0',''))
    dfdpt['data_policy_licence'] = dfdpt['data_policy_licence'].astype(str).apply(lambda x: x.replace('.0',''))
    dfdpt["source_id"] = pd.to_numeric(dfdpt["source_id"],errors='coerce')
    dfdpt["observation_value"] = pd.to_numeric(dfdpt["observation_value"],errors='coerce')
    dfdpt["observation_value"]= dfdpt["observation_value"].round(2)
    
    #====================================================================================
    # Convert station level pressure  to cdmlite
    dfslp = df[["observation_id","report_type","date_time","date_time_meaning",
              "latitude","longitude","observation_height_above_station_surface"
              ,"observed_variable","units","observation_value",
              "value_significance","observation_duration","platform_type",
              "station_type","primary_station_id","station_name","quality_flag"
              ,"data_policy_licence","source_id","secondary_id"]]
    
    # Change for each variable to convert to CDM compliant values
    dfslp["secondary_id"]=df["station_level_pressure_Source_Station_ID"].astype(str)
    dfslp['secondary_id'] = dfslp['secondary_id'].astype(str).apply(lambda x: x.replace('.0',''))
    dfslp["observation_value"]=df["station_level_pressure"]
   
    dfslp["source_id"]=df["station_level_pressure_Source_Code"]
    
    # Extract QC information for QC tables
    dfslp["quality_flag"]=df["station_level_pressure_QC_flag"]
    dfslp["qc_method"]=dfslp["quality_flag"]
    dfslp["report_id"]=dfslp["date_time"]

    # Set quality flag from master dataframe for variable
    #    and fill all nan with Null then change all nonnan to 1
    dfslp.loc[dfslp['quality_flag'].notnull(), "quality_flag"] = 1
    dfslp = dfslp.fillna("Null")
    dfslp.quality_flag[dfslp.quality_flag == "Null"] = 0
    
    # Change for each variable if required
    dfslp["observation_height_above_station_surface"]="2"
    dfslp["units"]="32"
    dfslp["observed_variable"]="57"
    
    # Remove unwanted missing data rows
    dfslp = dfslp.fillna("null")
    dfslp = dfslp.replace({"null":"-99999"})
    dfslp = dfslp[dfslp.observation_value != -99999]
    dfslp = dfslp.dropna(subset=['secondary_id'])
    dfslp = dfslp.dropna(subset=['observation_value'])
    #df = df.astype(str)
    dfslp["source_id"] = pd.to_numeric(dfslp["source_id"],errors='coerce')
    #df = df.astype(str)
    
    # Concatenate columns for joining dataframe for next step
    dfslp['source_id'] = dfslp['source_id'].astype(str).apply(lambda x: x.replace('.0',''))
    dfslp['primary_station_id_2']=dfslp['secondary_id'].astype(str)+'-'+dfslp['source_id'].astype(str)
    #dfslp["observation_value"] = pd.to_numeric(dfslp["observation_value"],errors='coerce')
    #dft.to_csv("ttest.csv", index=False, sep=",")
    
    # Add data policy and record numbers to dataframe
    df2=pd.read_csv("/work/scratch-pw/snoone/qff_cdm_test_2021/station_list/record_id.csv", encoding='latin-1')
    dfslp = dfslp.astype(str)
    df2 = df2.astype(str)
    dfslp= df2.merge(dfslp, on=['primary_station_id_2'])
    dfslp['data_policy_licence'] = dfslp['data_policy_licence_x']
    dfslp['data_policy_licence'] = dfslp['data_policy_licence'].astype(str).apply(lambda x: x.replace('.0',''))

    # Restrict to required columns
    dfslp = dfslp[["observation_id","record_number","report_type","date_time","date_time_meaning",
              "latitude","longitude","observation_height_above_station_surface"
              ,"observed_variable","units","observation_value",
              "value_significance","observation_duration","platform_type",
              "station_type","primary_station_id","station_name","quality_flag"
              ,"data_policy_licence","source_id","report_id","qc_method"]]

    # Concatenate more columns together
    dfslp['observation_id']=dfslp['primary_station_id'].astype(str)+'-'+dfslp['record_number'].astype(str)+'-'+dfslp['date_time'].astype(str)
    dfslp['observation_id'] = dfslp['observation_id'].str.replace(r' ', '-')

    # Remove wunwanted last two characters
    dfslp['observation_id'] = dfslp['observation_id'].str[:-6]
    dfslp["observation_id"]=dfslp["observation_id"]+'-'+dfslp['observed_variable'].astype(str)+'-'+dfslp['value_significance'].astype(str)

    # Set up QC table
    qcslp=dfslp[["primary_station_id","report_id","record_number","qc_method","quality_flag","observed_variable","value_significance"]]

    # Concatenate more columns together
    qcslp["observation_id"] = qcslp["primary_station_id"]+"-"+ qcslp["record_number"] +"-"+ qcslp["report_id"]+'-'+qcslp['observed_variable'].astype(str)+'-'+qcslp['value_significance'].astype(str)
    qcslp["report_id"] = qcslp["primary_station_id"]+"-"+ qcslp["report_id"] 
    qcslp['report_id'] = qcslp['report_id'].str[:-6]
    qcslp= qcslp[["report_id","observation_id","qc_method","quality_flag"]]
    qcslp["quality_flag"] = pd.to_numeric(qcslp["quality_flag"],errors='coerce')
    qcslp = qcslp.fillna("Null")
    qcslp= qcslp[qcslp['quality_flag'] != 0]
 
    # Restrict to required columns
    dfslp = dfslp[["observation_id","report_type","date_time","date_time_meaning",
              "latitude","longitude","observation_height_above_station_surface"
              ,"observed_variable","units","observation_value",
              "value_significance","observation_duration","platform_type",
              "station_type","primary_station_id","station_name","quality_flag"
              ,"data_policy_licence","source_id"]]
    dfslp = dfslp[dfslp.observation_value != "Null"]
    
    # Make sure no decimal places and round value to required number of decimal places
    dfslp['observation_value'] = dfslp['observation_value'].map(float)
    dfslp['observation_value'] = (dfslp['observation_value']*100)
    dfslp['observation_value'] = dfslp['observation_value'].map(int)
    dfslp['source_id'] = dfslp['source_id'].astype(str).apply(lambda x: x.replace('.0',''))
    dfslp['data_policy_licence'] = dfslp['data_policy_licence'].astype(str).apply(lambda x: x.replace('.0',''))
    dfslp["source_id"] = pd.to_numeric(dfslp["source_id"],errors='coerce')
    dfslp['observation_value'] = dfslp['observation_value'].astype(str).apply(lambda x: x.replace('.0',''))
    
    #===========================================================================================
    # Convert sea level pressure to CDM lite
    dfmslp = df[["observation_id","report_type","date_time","date_time_meaning",
              "latitude","longitude","observation_height_above_station_surface"
              ,"observed_variable","units","observation_value",
              "value_significance","observation_duration","platform_type",
              "station_type","primary_station_id","station_name","quality_flag"
              ,"data_policy_licence","source_id","secondary_id"]]

    # Change for each variable to convert to CDM compliant values
    dfmslp["secondary_id"]=df["sea_level_pressure_Source_Station_ID"].astype(str)
    dfmslp['secondary_id'] = dfmslp['secondary_id'].astype(str).apply(lambda x: x.replace('.0',''))
    dfmslp["observation_value"]=df["sea_level_pressure"]
   
    dfmslp["source_id"]=df["sea_level_pressure_Source_Code"]
    
    # Extract QC information for QC tables
    dfmslp["quality_flag"]=df["sea_level_pressure_QC_flag"]
    dfmslp["qc_method"]=dfmslp["quality_flag"]
    dfmslp["report_id"]=dfmslp["date_time"]
    
    # Set quality flag from master dataframe for variable
    #    and fill all nan with Null then change all nonnan to  
    dfmslp.loc[dfmslp['quality_flag'].notnull(), "quality_flag"] = 1
    dfmslp = dfmslp.fillna("Null")
    dfmslp.quality_flag[dfmslp.quality_flag == "Null"] = 0
    
    # Change for each variable if required
    dfmslp["observation_height_above_station_surface"]="2"
    dfmslp["units"]="32"
    dfmslp["observed_variable"]="58"
    
    # Remove unwanted missing data rows
    dfmslp = dfmslp.fillna("null")
    dfmslp = dfmslp.replace({"null":"-99999"})
    dfmslp = dfmslp[dfmslp.observation_value != -99999]
    dfmslp = dfmslp.dropna(subset=['secondary_id'])
    dfmslp = dfmslp.dropna(subset=['observation_value'])
    #df = df.astype(str)
    dfmslp["source_id"] = pd.to_numeric(dfmslp["source_id"],errors='coerce')
    #df = df.astype(str)
    
    # Concatenate columns for joining dataframe for next step
    dfmslp['source_id'] = dfmslp['source_id'].astype(str).apply(lambda x: x.replace('.0',''))
    dfmslp['primary_station_id_2']=dfmslp['secondary_id'].astype(str)+'-'+dfmslp['source_id'].astype(str)
    #dfmslp["observation_value"] = pd.to_numeric(dfmslp["observation_value"],errors='coerce')
    #dft.to_csv("ttest.csv", index=False, sep=",")
    
    # Add data policy and record numbers to dataframe
    df2=pd.read_csv("/work/scratch-pw/snoone/qff_cdm_test_2021/station_list/record_id.csv", encoding='latin-1')
    dfmslp = dfmslp.astype(str)
    df2 = df2.astype(str)
    dfmslp= df2.merge(dfmslp, on=['primary_station_id_2'])
    dfmslp['data_policy_licence'] = dfmslp['data_policy_licence_x']
    dfmslp['data_policy_licence'] = dfmslp['data_policy_licence'].astype(str).apply(lambda x: x.replace('.0',''))

    # Restrict to required columns
    dfmslp = dfmslp[["observation_id","record_number","report_type","date_time","date_time_meaning",
              "latitude","longitude","observation_height_above_station_surface"
              ,"observed_variable","units","observation_value",
              "value_significance","observation_duration","platform_type",
              "station_type","primary_station_id","station_name","quality_flag"
              ,"data_policy_licence","source_id","report_id","qc_method"]]

    # Concatenate more columns together
    dfmslp['observation_id']=dfmslp['primary_station_id'].astype(str)+'-'+dfmslp['record_number'].astype(str)+'-'+dfmslp['date_time'].astype(str)
    dfmslp['observation_id'] = dfmslp['observation_id'].str.replace(r' ', '-')
    
    # Remove unwanted last two characters
    dfmslp['observation_id'] = dfmslp['observation_id'].str[:-6]
    dfmslp["observation_id"]=dfmslp["observation_id"]+'-'+dfmslp['observed_variable'].astype(str)+'-'+dfmslp['value_significance'].astype(str)
    
    # Set up QC table
    qcmslp=dfmslp[["primary_station_id","report_id","record_number","qc_method","quality_flag","observed_variable","value_significance"]]

    # Concatenate more columns together
    qcmslp["observation_id"] = qcmslp["primary_station_id"]+"-"+ qcmslp["record_number"] +"-"+ qcmslp["report_id"]+'-'+qcmslp['observed_variable'].astype(str)+'-'+qcmslp['value_significance'].astype(str)
    qcmslp["report_id"] = qcmslp["primary_station_id"]+"-"+ qcmslp["report_id"] 
    qcmslp['report_id'] = qcmslp['report_id'].str[:-6]
    qcmslp= qcmslp[["report_id","observation_id","qc_method","quality_flag"]]
    qcmslp["quality_flag"] = pd.to_numeric(qcmslp["quality_flag"],errors='coerce')
    qcmslp = qcmslp.fillna("Null")
    qcmslp= qcmslp[qcmslp['quality_flag'] != 0]

    # Restrict to required columns
    dfmslp = dfmslp[["observation_id","report_type","date_time","date_time_meaning",
              "latitude","longitude","observation_height_above_station_surface"
              ,"observed_variable","units","observation_value",
              "value_significance","observation_duration","platform_type",
              "station_type","primary_station_id","station_name","quality_flag"
              ,"data_policy_licence","source_id"]]
    
    dfmslp = dfmslp[dfmslp.observation_value != "Null"]
    
    # Make sure no decimal places and round value to required number of decimal places
    dfmslp['observation_value'] = dfmslp['observation_value'].map(float)
    dfmslp['observation_value'] = (dfmslp['observation_value']*100)
    dfmslp['observation_value'] = dfmslp['observation_value'].map(int)
    dfmslp['source_id'] = dfmslp['source_id'].astype(str).apply(lambda x: x.replace('.0',''))
    dfmslp['data_policy_licence'] = dfmslp['data_policy_licence'].astype(str).apply(lambda x: x.replace('.0',''))
    dfmslp["source_id"] = pd.to_numeric(dfmslp["source_id"],errors='coerce')
    dfmslp['observation_value'] = dfmslp['observation_value'].astype(str).apply(lambda x: x.replace('.0',''))
    
    #===================================================================================
    # Convert wind direction to CDM lite
    dfwd = df[["observation_id","report_type","date_time","date_time_meaning",
              "latitude","longitude","observation_height_above_station_surface"
              ,"observed_variable","units","observation_value",
              "value_significance","observation_duration","platform_type",
              "station_type","primary_station_id","station_name","quality_flag"
              ,"data_policy_licence","source_id","secondary_id"]]

    # Change for each variable to convert to CDM compliant values
    dfwd["secondary_id"]=df["wind_direction_Source_Station_ID"].astype(str)
    dfwd['secondary_id'] = dfwd['secondary_id'].astype(str).apply(lambda x: x.replace('.0',''))
    dfwd["observation_value"]=df["wind_direction"]
   
    dfwd["source_id"]=df["wind_direction_Source_Code"]
    
    # Extract QC information for QC tables
    dfwd["quality_flag"]=df["wind_direction_QC_flag"]
    dfwd["qc_method"]=dfwd["quality_flag"]
    dfwd["report_id"]=dfwd["date_time"]

    # Set quality flag from master dataframe for variable
    #    and fill all nan with Null then change all nonnan to 1
    dfwd.loc[dfwd['quality_flag'].notnull(), "quality_flag"] = 1
    dfwd = dfwd.fillna("Null")
    dfwd.quality_flag[dfwd.quality_flag == "Null"] = 0
    
    # Change for each variable if required
    dfwd["observation_height_above_station_surface"]="10"
    dfwd["units"]="320"
    dfwd["observed_variable"]="106"
    
    # Remove unwanted missing data rows
    dfwd = dfwd.fillna("null")
    dfwd = dfwd.replace({"null":"-999"})
    dfwd = dfwd[dfwd.observation_value != -999]
    dfwd = dfwd.dropna(subset=['secondary_id'])
    dfwd = dfwd.dropna(subset=['observation_value'])
    #df = df.astype(str)
    dfwd["source_id"] = pd.to_numeric(dfwd["source_id"],errors='coerce')
    #df = df.astype(str)
    
    # Concatenate columns for joining dataframe for next step
    dfwd['source_id'] = dfwd['source_id'].astype(str).apply(lambda x: x.replace('.0',''))
    dfwd['primary_station_id_2']=dfwd['secondary_id'].astype(str)+'-'+dfwd['source_id'].astype(str)
    #dfwd["observation_value"] = pd.to_numeric(dfwd["observation_value"],errors='coerce')
    #dft.to_csv("ttest.csv", index=False, sep=",")
    
    # Add data policy and record numbers to datframe
    df2=pd.read_csv("/work/scratch-pw/snoone/qff_cdm_test_2021/station_list/record_id.csv", encoding='latin-1')
    dfwd = dfwd.astype(str)
    df2 = df2.astype(str)
    dfwd= df2.merge(dfwd, on=['primary_station_id_2'])
    dfwd['data_policy_licence'] = dfwd['data_policy_licence_x']
    dfwd['data_policy_licence'] = dfwd['data_policy_licence'].astype(str).apply(lambda x: x.replace('.0',''))

    # Restrict to required columns
    dfwd = dfwd[["observation_id","record_number","report_type","date_time","date_time_meaning",
              "latitude","longitude","observation_height_above_station_surface"
              ,"observed_variable","units","observation_value",
              "value_significance","observation_duration","platform_type",
              "station_type","primary_station_id","station_name","quality_flag"
              ,"data_policy_licence","source_id","report_id","qc_method"]]

    # Concatenate columns together
    dfwd['observation_id']=dfwd['primary_station_id'].astype(str)+'-'+dfwd['record_number'].astype(str)+'-'+dfwd['date_time'].astype(str)
    dfwd['observation_id'] = dfwd['observation_id'].str.replace(r' ', '-')
    
    # Remove unwanted last two characters
    dfwd['observation_id'] = dfwd['observation_id'].str[:-6]
    dfwd["observation_id"]=dfwd["observation_id"]+'-'+dfwd['observed_variable'].astype(str)+'-'+dfwd['value_significance'].astype(str)
    
    # Set up QC table
    qcwd=dfwd[["primary_station_id","report_id","record_number","qc_method","quality_flag","observed_variable","value_significance"]]
    qcwd["observation_id"] = qcwd["primary_station_id"]+"-"+ qcwd["record_number"] +"-"+ qcwd["report_id"]+'-'+qcwd['observed_variable'].astype(str)+'-'+qcwd['value_significance'].astype(str)
    qcwd["report_id"] = qcwd["primary_station_id"]+"-"+ qcwd["report_id"] 
    qcwd['report_id'] = qcwd['report_id'].str[:-6]
    qcwd= qcwd[["report_id","observation_id","qc_method","quality_flag"]]
    qcwd["quality_flag"] = pd.to_numeric(qcwd["quality_flag"],errors='coerce')
    qcwd = qcwd.fillna("Null")
    qcwd= qcwd[qcwd['quality_flag'] != 0]
  
    # Restrict to required columns
    dfwd = dfwd[["observation_id","report_type","date_time","date_time_meaning",
              "latitude","longitude","observation_height_above_station_surface"
              ,"observed_variable","units","observation_value",
              "value_significance","observation_duration","platform_type",
              "station_type","primary_station_id","station_name","quality_flag"
              ,"data_policy_licence","source_id"]]
    
    # Make sure no decimal places and round value to reuquired number of decimal places
    dfwd['observation_value'] = dfwd['observation_value'].astype(str).apply(lambda x: x.replace('.0',''))
    dfwd['source_id'] = dfwd['source_id'].astype(str).apply(lambda x: x.replace('.0',''))
    dfwd['data_policy_licence'] = dfwd['data_policy_licence'].astype(str).apply(lambda x: x.replace('.0',''))
    dfwd["source_id"] = pd.to_numeric(dfwd["source_id"],errors='coerce')
    
    #===========================================================================
    # Convert wind speed to CDM lite
    dfws = df[["observation_id","report_type","date_time","date_time_meaning",
              "latitude","longitude","observation_height_above_station_surface"
              ,"observed_variable","units","observation_value",
              "value_significance","observation_duration","platform_type",
              "station_type","primary_station_id","station_name","quality_flag"
              ,"data_policy_licence","source_id","secondary_id"]]

    # Change for each variable to convert to CDM compliant values
    dfws["secondary_id"]=df["wind_speed_Source_Station_ID"].astype(str)
    dfws['secondary_id'] = dfws['secondary_id'].astype(str).apply(lambda x: x.replace('.0',''))
    dfws["observation_value"]=df["wind_speed"]
   
    dfws["source_id"]=df["wind_speed_Source_Code"]
    # Extract QC information for QC tables
    dfws["quality_flag"]=df["wind_speed_QC_flag"]
    dfws["qc_method"]=dfws["quality_flag"]
    dfws["report_id"]=dfws["date_time"]

    
    # Set quality flag from master dataframe for variable
    #    and fill all nan with Null then change all nonnan to 1
    dfws.loc[dfws['quality_flag'].notnull(), "quality_flag"] = 1
    dfws = dfws.fillna("Null")
    dfws.quality_flag[dfws.quality_flag == "Null"] = 0
    
    # Change for each variable if required
    dfws["observation_height_above_station_surface"]="10"
    dfws["units"]="32"
    dfws["observed_variable"]="107"
    
    # Remove unwanted missing data rows
    dfws = dfws.fillna("null")
    dfws = dfws.replace({"null":"-999"})
    dfws = dfws[dfws.observation_value != -999]
    dfws = dfws.dropna(subset=['secondary_id'])
    dfws = dfws.dropna(subset=['observation_value'])
    #df = df.astype(str)
    dfws["source_id"] = pd.to_numeric(dfws["source_id"],errors='coerce')
    #df = df.astype(str)
    
    # Concatenate columns for joining dataframe for next step
    dfws['source_id'] = dfws['source_id'].astype(str).apply(lambda x: x.replace('.0',''))
    dfws['primary_station_id_2']=dfws['secondary_id'].astype(str)+'-'+dfws['source_id'].astype(str)
    #dfws["observation_value"] = pd.to_numeric(dfws["observation_value"],errors='coerce')
    #dft.to_csv("ttest.csv", index=False, sep=",")
    
    # Add data policy and record numbers to datafram
    df2=pd.read_csv("/work/scratch-pw/snoone/qff_cdm_test_2021/station_list/record_id.csv", encoding='latin-1')
    dfws = dfws.astype(str)
    df2 = df2.astype(str)
    dfws= df2.merge(dfws, on=['primary_station_id_2'])
    dfws['data_policy_licence'] = dfws['data_policy_licence_x']
    dfws['data_policy_licence'] = dfws['data_policy_licence'].astype(str).apply(lambda x: x.replace('.0',''))

    # Restrict to required columns
    dfws = dfws[["observation_id","record_number","report_type","date_time","date_time_meaning",
              "latitude","longitude","observation_height_above_station_surface"
              ,"observed_variable","units","observation_value",
              "value_significance","observation_duration","platform_type",
              "station_type","primary_station_id","station_name","quality_flag"
              ,"data_policy_licence","source_id","report_id","qc_method"]]

    # Concatenate more columns together
    dfws['observation_id']=dfws['primary_station_id'].astype(str)+'-'+dfws['record_number'].astype(str)+'-'+dfws['date_time'].astype(str)
    dfws['observation_id'] = dfws['observation_id'].str.replace(r' ', '-')
    
    # Remove unwanted last two characters
    dfws['observation_id'] = dfws['observation_id'].str[:-6]
    dfws["observation_id"]=dfws["observation_id"]+'-'+dfws['observed_variable'].astype(str)+'-'+dfws['value_significance'].astype(str)
    
    # QC flag tables
    qcws=dfws[["primary_station_id","report_id","record_number","qc_method","quality_flag","observed_variable","value_significance"]]

    # Concatenate more columns together
    qcws["observation_id"] = qcws["primary_station_id"]+"-"+ qcws["record_number"] +"-"+ qcws["report_id"]+'-'+qcws['observed_variable'].astype(str)+'-'+qcws['value_significance'].astype(str)
    qcws["report_id"] = qcws["primary_station_id"]+"-"+ qcws["report_id"] 
    qcws['report_id'] = qcws['report_id'].str[:-6]
    qcws= qcws[["report_id","observation_id","qc_method","quality_flag"]]
    qcws["quality_flag"] = pd.to_numeric(qcws["quality_flag"],errors='coerce')
    qcws = qcws.fillna("Null")
    qcws= qcws[qcws['quality_flag'] != 0]

    #station_id=dfws.iloc[1]["primary_station_id"]

    # Restrict to required columns
    dfws = dfws[["observation_id","report_type","date_time","date_time_meaning",
              "latitude","longitude","observation_height_above_station_surface"
              ,"observed_variable","units","observation_value",
              "value_significance","observation_duration","platform_type",
              "station_type","primary_station_id","station_name","quality_flag"
              ,"data_policy_licence","source_id"]]
    
    # Make sure no decimal places and round value to required number of decimal places
    dfws['source_id'] = dfws['source_id'].astype(str).apply(lambda x: x.replace('.0',''))
    dfws['data_policy_licence'] = dfws['data_policy_licence'].astype(str).apply(lambda x: x.replace('.0',''))
    dfws["source_id"] = pd.to_numeric(dfws["source_id"],errors='coerce')
    dfws["observation_value"] = pd.to_numeric(dfws["observation_value"],errors='coerce')
    dfws["observation_value"]= dfws["observation_value"].round(2)
   
      
    # =================================================================================
    # Merge all dataframes into one CDMlite frame
    merged_df=pd.concat([dfdpt,dft,dfslp,dfmslp,dfwd,dfws], axis=0)

    # Sort by date/times and fix metadata
    merged_df.sort_values("date_time", inplace=True)
    merged_df["latitude"] = pd.to_numeric(merged_df["latitude"],errors='coerce')
    merged_df["longitude"] = pd.to_numeric(merged_df["longitude"],errors='coerce')
    merged_df["latitude"]= merged_df["latitude"].round(3)
    merged_df["longitude"]= merged_df["longitude"].round(3)

    # Write the output files
    #   name the cdm_lite files e.g. cdm_lite _”insert date of run”_EG000062417.psv)
    try:
        # Save CDM lite table to directory
        station_id=merged_df.iloc[1]["primary_station_id"]
        cdm_type=("cdm_lite_202111_test_")
        print(station_id+"_lite")
        a = merged_df['observed_variable'].unique()
        print (a)
        outname = os.path.join(OUTDIR,cdm_type)
        #with open(filename, "w") as outfile:
        merged_df.to_csv(outname+ station_id+ ".psv", index=False, sep="|")

        # Save QC table to directory
        qc_merged_df=pd.concat([qcdpt,qct,qcslp,qcmslp,qcwd,qcws], axis=0)
        qc_merged_df.astype(str)
        qc_merged_df['qc_method'] = qc_merged_df['qc_method'].str.replace("L","0,")
        qc_merged_df['qc_method'] = qc_merged_df['qc_method'].str.replace("o","1,")
        qc_merged_df['qc_method'] = qc_merged_df['qc_method'].str.replace("F","2,")
        qc_merged_df['qc_method'] = qc_merged_df['qc_method'].str.replace("U","3,")
        qc_merged_df['qc_method'] = qc_merged_df['qc_method'].str.replace("D","4,")
        qc_merged_df['qc_method'] = qc_merged_df['qc_method'].str.replace("d","5,")
        qc_merged_df['qc_method'] = qc_merged_df['qc_method'].str.replace("W","6,")
        qc_merged_df['qc_method'] = qc_merged_df['qc_method'].str.replace("K","7,")
        qc_merged_df['qc_method'] = qc_merged_df['qc_method'].str.replace("C","8,")
        qc_merged_df['qc_method'] = qc_merged_df['qc_method'].str.replace("T","9,")
        qc_merged_df['qc_method'] = qc_merged_df['qc_method'].str.replace("S","10,")
        qc_merged_df['qc_method'] = qc_merged_df['qc_method'].str.replace("h","11,")
        qc_merged_df['qc_method'] = qc_merged_df['qc_method'].str.replace("V","12,")
        qc_merged_df['qc_method'] = qc_merged_df['qc_method'].str.replace("w","13,")
        qc_merged_df['qc_method'] = qc_merged_df['qc_method'].str.replace("N","14,")
        qc_merged_df['qc_method'] = qc_merged_df['qc_method'].str.replace("E","15,")
        qc_merged_df['qc_method'] = qc_merged_df['qc_method'].str.replace("p","16,")
        qc_merged_df['qc_method'] = qc_merged_df['qc_method'].str.replace("H","17,")

        # Remove unwnated "," from column
        qc_merged_df['qc_method'] = qc_merged_df['qc_method'].str[:-1]
        qc_station_id=merged_df.iloc[1]["primary_station_id"]
        cdm_type=("qc_definition_202111_test_")
        print(qc_station_id+"_qc")
        b = qc_merged_df['qc_method'].unique()
        print (b)
        outname2= os.path.join(OUTDIR2,cdm_type)
        qc_merged_df.to_csv(outname2 + qc_station_id+ ".psv", index=False, sep="|")
        
    except:
        # Continue to next iteration.
        continue
