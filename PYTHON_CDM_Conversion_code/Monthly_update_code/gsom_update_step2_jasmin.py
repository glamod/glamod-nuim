#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Jul 17 14:22:41 2019

@author: snoone
"""

# step 2 converts the monthly GSOM update into files for the CDM

import os
import glob
import pandas as pd
import sys
pd.options.mode.chained_assignment = None  # default='warn'

# add parent directory to access daily conversion scripts
sys.path.append("../")
import utils
import monthly_to_cdm_all_v1 as m_utils


EXTENSION = 'csv'

# Read in the data policy dataframe (only read in if needed)
data_policy_df = pd.read_csv(utils.MONTHLY_STATION_RECORD_ENTRIES_OBS_LITE, encoding='latin-1')
data_policy_df = data_policy_df.astype(str)


all_filenames = [i for i in glob.glob(f"{utils.MONTHLY_UPDATE_STNDIR}*.{EXTENSION}")]

# just run through all filenames
for filename in all_filenames:

    # pull out the columns we need
    usecols = m_utils.LITE_COLS

    df = pd.read_csv(filename, sep=",", usecols=lambda c: c in set(usecols))
    month_date_id = df.iloc[1]["DATE"]
    
    # add required columnns
    df["report_type"]="2"
    df["units"]=""
    df["minute"]= "00"
    df["day"]= "01"
    df["hour"]= "00"
    df["seconds"]="00"
    df[['year', 'month']] = df['DATE'].str.split('-', expand=True)
    df["observation_height_above_station_surface"]=""
    df["date_time_meaning"]="1"
    df["latitude"]=df["LATITUDE"]
    df["longitude"]=df["LONGITUDE"]
    df["observed_variable"]=""  
    df["value_significance"]="13" 
    df["observation_duration"]="14"
    df["observation_value"]=""
    df["platform_type"]=""
    df["station_type"]="1"
    df["observation_id"]=""
    df["data_policy_licence"]="0"
    df["primary_station_id"]=df["STATION"]
    df["station_name"]=df["NAME"]
    df["quality_flag"]="0"
    df["latitude"] = pd.to_numeric(df["latitude"],errors='coerce')
    df["longitude"] = pd.to_numeric(df["longitude"],errors='coerce')
    df["latitude"]= df["latitude"].round(3)
    df["longitude"]= df["longitude"].round(3)
    df["Timestamp2"] = df["year"].map(str) + "-" + df["month"].map(str)+ "-" + df["day"].map(str)
    df["offset"]="+00"
    df["date_time"] = df["Timestamp2"].map(str)+ " " + df["hour"].map(str)+":"+df["minute"].map(str)+":"+df["seconds"].map(str) 
    df['date_time'] = df['date_time'].astype('str')
    df.date_time = df.date_time + '+00'
    
    # extract precip
    try:
        dfprc = df[m_utils.INITIAL_VAR_COLUMNS]

        # change for each variable to convert to cdm compliant values
        dfprc["observation_value"] = df["PRCP"]

        # change for each variable if required
        dfprc = m_utils.set_units_etc(dfprc, "PRCP")

        # merge with record_id_mnth.csv to add source id
        dfprc = m_utils.add_data_policy(dfprc, data_policy_df, rename=True)

        dfprc = m_utils.build_observation_id(dfprc)

        # reorder columns and drop unwanted columns
        dfprc = dfprc[m_utils.FINAL_VAR_COLUMNS]
    except KeyError:
        # this variable doesn't exist in the file
        pass
    except RuntimeError:
        # station not available because of upstream QC
        # continue to next station
        continue
  
   
    # extract SNOW
    try:
        dfsnow = df[m_utils.INITIAL_VAR_COLUMNS]

        # change for each variable to convert to cdm compliant values
        dfsnow["observation_value"] = df["SNOW"]
        dfsnow = dfsnow.fillna("Null")
        dfsnow = dfsnow[dfsnow.observation_value != "Null"]

        #change for each variable if required
        dfsnow = m_utils.set_units_etc(dfsnow, "SNOW")

        # merge with record_id_mnth.csv to add source id
        dfsnow = m_utils.add_data_policy(dfsnow, data_policy_df, rename=True)

        dfsnow = m_utils.build_observation_id(dfsnow)

        # reorder columns and drop unwanted columns
        dfsnow = dfsnow[m_utils.FINAL_VAR_COLUMNS]
    except KeyError:
        # this variable doesn't exist in the file
        pass
    except RuntimeError:
        # station not available because of upstream QC
        # continue to next station
        continue

   
    # extract tmax
    try:
        dftmax = df[m_utils.INITIAL_VAR_COLUMNS]

        # change for each variable to convert to cdm compliant values
        dftmax["observation_value"] = df["TMAX"]
        dftmax = dftmax.fillna("Null")
        dftmax = dftmax[dftmax.observation_value != "Null"]
        dftmax = m_utils.convert_to_kelvin(dftmax)

        #change for each variable if required
        dftmax = m_utils.set_units_etc(dftmax, "TMAX")
        dftmax["value_significance"] = "0" 

        # merge with record_id_mnth.csv to add source id
        dftmax = m_utils.add_data_policy(dftmax, data_policy_df, rename=True)

        dftmax = m_utils.build_observation_id(dftmax)

        # reorder columns and drop unwanted columns
        dftmax = dftmax[m_utils.FINAL_VAR_COLUMNS]

    except KeyError:
        # this variable doesn't exist in the file
        pass
    except RuntimeError:
        # station not available because of upstream QC
        # continue to next station
        continue
    

    # extract tmin
    try:
        dftmin = df[m_utils.INITIAL_VAR_COLUMNS]

        # change for each variable to convert to cdm compliant values
        dftmin["observation_value"] = df["TMIN"]
        dftmin = dftmin.fillna("Null")
        dftmin = dftmin[dftmin.observation_value != "Null"]
        dftmin = m_utils.convert_to_kelvin(dftmin)

        # change for each variable if required
        dftmin = m_utils.set_units_etc(dftmin, "TMIN")
        dftmin["value_significance"] = "1" 

        # merge with record_id_mnth.csv to add source id
        dftmin = m_utils.add_data_policy(dftmin, data_policy_df, rename=True)

        dftmin = m_utils.build_observation_id(dftmin)

        # reorder columns and drop unwanted columns
        dftmin = dftmin[m_utils.FINAL_VAR_COLUMNS]
    except KeyError:
        # this variable doesn't exist in the file
        pass
    except RuntimeError:
        # station not available because of upstream QC
        # continue to next station
        continue


    # extract tavg
    try:
        dftavg = df[m_utils.INITIAL_VAR_COLUMNS]

        # change for each variable to convert to cdm compliant values
        dftavg["observation_value"]=df["TAVG"]
        dftavg = dftavg.fillna("Null")
        dftavg = dftavg[dftavg.observation_value != "Null"]
        dftavg = m_utils.convert_to_kelvin(dftavg)

        # change for each variable if required
        dftavg = m_utils.set_units_etc(dftavg, "TAVG")
        dftavg["value_significance"]="2" 

        # merge with record_id_mnth.csv to add source id
        dftavg = m_utils.add_data_policy(dftavg, data_policy_df, rename=True)

        dftavg = m_utils.build_observation_id(dftavg)

        # reorder columns and drop unwanted columns
        dftavg = dftavg[m_utils.FINAL_VAR_COLUMNS]
    except KeyError:
        # this variable doesn't exist in the file
        pass
    except RuntimeError:
        # station not available because of upstream QC
        # continue to next station
        continue



    # extract wind speed avge
    try:
        dftws = df[m_utils.INITIAL_VAR_COLUMNS]

        # change for each variable to convert to cdm compliant values
        dftws["observation_value"] = df["AWND"]
        dftws = dftws.fillna("Null")
        dftws = dftws[dftws.observation_value != "Null"]

        # fix observation_value
        dftws["observation_value"] = pd.to_numeric(dftws["observation_value"],errors='coerce')
        dftws["observation_value"] = dftws["observation_value"].round(2)

        # change for each variable if required
        dftws = m_utils.set_units_etc(dftws, "AWND")
        dftws["value_significance"] = "2" 

        # merge with record_id_mnth.csv to add source id
        dftws = m_utils.add_data_policy(dftws, data_policy_df, rename=True)

        dftws = m_utils.build_observation_id(dftws)

        # reorder columns and drop unwanted columns
        dftws = dftws[m_utils.FINAL_VAR_COLUMNS]
    except KeyError:
        # this variable doesn't exist in the file
        pass 
    except RuntimeError:
        # station not available because of upstream QC
        # continue to next station
        continue

               
    try:
        merged_df=pd.concat([dftmax,dftavg,dftmin,dftws,dfprc], axis=0)
        merged_df.sort_values("date_time")
        merged_df["latitude"] = pd.to_numeric(merged_df["latitude"],errors='coerce')
        merged_df["longitude"] = pd.to_numeric(merged_df["longitude"],errors='coerce')
        merged_df["latitude"]= merged_df["latitude"].round(3)
        merged_df["longitude"]= merged_df["longitude"].round(3)
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
        df2=pd.read_csv("/gws/nopw/j04/c3s311a_lot2/data/incoming/code/record_id_mnth.csv")
        dfobs = dfobs.astype(str)
        df2 = df2.astype(str)
        dfobs= df2.merge(dfobs, on=['primary_station_id_2'])
        
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
        dfobs["conversion_method"]=""
        dfobs.loc[dfobs['observed_variable'] == "85", 'conversion_method'] = '1' 
        # add all columns for obs table
        dfobs["date_time_meaning"]="1"
        dfobs["crs"]=""
        dfobs["z_coordinate"]=""
        dfobs["z_coordinate_type"]=""
        dfobs["secondary_variable"]=""
        dfobs["secondary_value"]=""
        dfobs["code_table"]=""
        dfobs["sensor_id"]=""
        dfobs["sensor_automation_status"]=""
        dfobs["exposure_of_sensor"]=""
        dfobs["processing_code"]=""
        dfobs["processing_level"]="0"
        dfobs["adjustment_id"]=""
        dfobs["traceability"]=""
        dfobs["advanced_qc"]=""
        dfobs["advanced_uncertainty"]=""
        dfobs["advanced_homogenisation"]=""
        dfobs["advanced_assimilation_feedback"]=""
        dfobs["source_record_id"]=""
        dfobs["location_method"]=""
        dfobs["location_precision"]=""
        dfobs["z_coordinate_method"]=""
        dfobs["bbox_min_longitude"]=""
        dfobs["bbox_max_longitude"]=""
        dfobs["bbox_min_latitude"]=""
        dfobs["bbox_max_latitude"]=""
        dfobs["spatial_representativeness"]=""
        dfobs["original_code_table"]=""
        dfobs["source_id"]=dfobs["source_id_x"]
        dfobs['date1'] = dfobs["date_time"].str[:-11]
        dfobs['date1'] = dfobs['date1'].str.strip()
        dfobs["observation_value"] = pd.to_numeric(dfobs["observation_value"],errors='coerce')
        dfobs["report_id"]=dfobs["station_id"].astype(str)+'-'+dfobs["record_id"].astype(str)+'-'+dfobs["date1"].astype(str)
        dfobs["original_value"]=dfobs["observation_value"]
        dfobs["original_units"]=dfobs["units"]
        dfobs["onversion_method"]=""
        dfobs.loc[dfobs['observed_variable'] == "85", 'original_units'] = '350'
        dfobs.loc[dfobs['observed_variable'] == "85", 'original_value'] = dfobs["observation_value"]-273.15
        dfobs.loc[dfobs['observed_variable'] == "85", 'conversion_method'] ="1"
        dfobs["original_value"]= dfobs["original_value"].round(1)
       
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
        col_list=dfobs [["observation_id","latitude","longitude","report_id","source_id","date_time"]]
        hdf=col_list.copy()
        
        
        # add required columns and set up values etc
        hdf[['primary_station_id', 'station_record_number', '1',"2,","3"]] = hdf['report_id'].str.split('-', expand=True)                                                    
        # hdf["observation_id"]=merged_df["observation_id"]                                                  
        hdf["report_id"]=dfobs["report_id"]
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
        hdf["report_timestamp"]=dfobs["date_time"]
        hdf['primary_station_id_3']=hdf['primary_station_id'].astype(str)+'-'+hdf['source_id'].astype(str)
        hdf["duplicates_report"]=hdf["report_id"]+'-'+hdf["station_record_number"].astype(str)
        
            
              
        df2=pd.read_csv("/gws/nopw/j04/c3s311a_lot2/data/incoming/code/record_id_mnth.csv")
        hdf = hdf.astype(str)
        df2 = df2.astype(str)
        hdf= df2.merge(hdf, on=['primary_station_id_3'])
        hdf['height_of_station_above_sea_level'] = hdf['height_of_station_above_sea_level'].astype(str).apply(lambda x: x.replace('.0',''))
        hdf["source_id"]=hdf["source_id_x"]
            #added in thsi bit of code#
        hdf = hdf.rename(columns={"latitude_x":"latitude",})
        hdf = hdf.rename(columns={"longitude_x":"longitude",})
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
                  "primary_station_id_3", "duplicates_report"]]
        
        
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
            # Continue to next iteration.
            continue

    

    # output merged cdmlite file

    
    try:
      
                     
        
        cdm_type=("cdm_lite_monthly_update_")
        outname = os.path.join(utils.MONTHLY_UPDATE_CDM_LITE_OUTDIR,cdm_type)
        df_lite_out.to_csv(outname+ month_date_id + ".psv", index=False, sep="|")
     
    except:
        # Continue to next iteration.
        continue  
    
    # output of cdm observations files
    try:
                          
        
        cdm_type=("cdm_obs_monthly_update_")
        outname = os.path.join(utils.MONTHLY_UPDATE_CDM_OBS_OUTDIR, cdm_type)
        dfobs.to_csv(outname+ month_date_id + ".psv", index=False, sep="|")
     
    except:
        # Continue to next iteration.
        continue  
    
    # output of cdm header files
    try:
       #  table output
       # header table output
        
        cdm_type=("cdm_head_monthly_update")
        outname = os.path.join(utils.MONTHLY_UPDATE_CDM_HEADER_OUTDIR, cdm_type)
        hdf.to_csv(outname+ month_date_id + ".psv", index=False, sep="|")
              
    except:
        # Continue to next iteration.
        continue
    


 

    
