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

##code to convert daily ghnd files to cdm formatted cdmlite and qc tables

OUTDIR2= "D:/Python_CDM_conversion/daily/qc_out"
OUTDIR = "D:/Python_CDM_conversion/daily/cdm_out/lite"
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
    
    ##set the units for each variable
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
    df["report_id"]=df["date_time"]  
    df['primary_station_id_2']=df['primary_station_id'].astype(str)+'-'+df['source_id'].astype(str)
    df["observation_value"] = pd.to_numeric(df["observation_value"],errors='coerce')
    df = df.astype(str)                                       
    df['source_id'] = df['source_id'].astype(str).apply(lambda x: x.replace('.0',''))
    df['primary_station_id_2']=df['primary_station_id'].astype(str)+'-'+df['source_id'].astype(str)
    
   ##'add in location information for cdm lite station 
    df2=pd.read_csv("D:/Python_CDM_conversion/daily/config_files/record_id_dy.csv")
    df['primary_station_id_2'] = df['primary_station_id_2'].astype(str)
    df2 = df2.astype(str)
    df= df2.merge(df, on=['primary_station_id_2'])
    df['data_policy_licence'] = df['data_policy_licence_x']
    df['data_policy_licence'] = df['data_policy_licence'].astype(str).apply(lambda x: x.replace('.0',''))
    df["observation_value"] = pd.to_numeric(df["observation_value"],errors='coerce')
    df = df.fillna("null")
    df = df.replace({"null":""})
    
                                   
    ##set up master df to extract each variable
       
    df["latitude"] = pd.to_numeric(df["latitude"],errors='coerce')
    df["longitude"] = pd.to_numeric(df["longitude"],errors='coerce')
    df["latitude"]= df["latitude"].round(3)
    df["longitude"]= df["longitude"].round(3)
    ##add observation id to datafrme
    df["dates"]=""
    df["dates"]=df["report_id"].str[:-11]
    df['observation_id']=df['primary_station_id'].astype(str)+'-'+df['record_number'].astype(str)+'-'+df['dates'].astype(str)
    df['observation_id'] = df['observation_id'].str.replace(r' ', '-')
    df["observation_id"]=df["observation_id"]+df['observed_variable']+'-'+df['value_significance']

    
    
    #extract qc table information
   
    qct= df[["primary_station_id","report_id","record_number","qc_method","quality_flag","observed_variable","value_significance"]]
    qct = qct.astype(str)
    qct["dates"]=""
    qct["dates"]=qct["report_id"].str[:-11]
    qct['observation_id']=qct['primary_station_id'].astype(str)+'-'+qct['record_number'].astype(str)+'-'+qct['dates'].astype(str)
    qct['observation_id'] = qct['observation_id'].str.replace(r' ', '-')
    qct["observation_id"]=qct["observation_id"]+qct['observed_variable']+'-'+qct['value_significance']
    qct= qct[["report_id","observation_id","qc_method","quality_flag"]]
    qct["quality_flag"] = pd.to_numeric(qct["quality_flag"],errors='coerce')
    qct.loc[qct['quality_flag'].notnull(), "quality_flag"] = 1
    qct = qct.fillna("Null")
    qct.quality_flag[qct.quality_flag == "Null"] = 0
    qct.astype(str)
    qct['qc_method'] = qct['qc_method'].str.replace("D","16,")
    qct['qc_method'] = qct['qc_method'].str.replace("H","30,")
    qct['qc_method'] = qct['qc_method'].str.replace("G","17,")
    qct['qc_method'] = qct['qc_method'].str.replace("I","18,")
    qct['qc_method'] = qct['qc_method'].str.replace("K","19,")
    qct['qc_method'] = qct['qc_method'].str.replace("M","20,")
    qct['qc_method'] = qct['qc_method'].str.replace("N","22,")
    qct['qc_method'] = qct['qc_method'].str.replace("O","23,")
    qct['qc_method'] = qct['qc_method'].str.replace("R","24,")
    qct['qc_method'] = qct['qc_method'].str.replace("S","25,")
    qct['qc_method'] = qct['qc_method'].str.replace("T","26,")
    qct['qc_method'] = qct['qc_method'].str.replace("W","27,")
    qct['qc_method'] = qct['qc_method'].str.replace("X","28,")
    qct['qc_method'] = qct['qc_method'].str.replace("V","12,")
    qct['qc_method'] = qct['qc_method'].str.replace("Z","29,")
    qct['qc_method'] = qct['qc_method'].str.replace("P","30,")
    qct = qct.fillna("null")
    qct = qct[qct.qc_method != ""]
    qct = qct[qct.qc_method != "nan"]
    qct = qct[qct.quality_flag != 0]
    qct['qc_method'] = qct['qc_method'].str[:-1]
    qct.dropna(subset = ["qc_method"], inplace=True)
    qct["quality_flag"]=qct["quality_flag"].astype(int)
      
    ##reorder df columns
    df = df[["observation_id","report_type","date_time","date_time_meaning",
              "latitude","longitude","observation_height_above_station_surface"
              ,"observed_variable","units","observation_value",
              "value_significance","observation_duration","platform_type",
              "station_type","primary_station_id","station_name","quality_flag"
              ,"data_policy_licence","source_id"]]
    
    try:

        
        qc_station_id=df.iloc[1]["primary_station_id"]
        cdm_type=("qc_definition_202111_test_")
        print(qc_station_id+"_qc")
        b = qct['qc_method'].unique()
        print (b)
        outname2= os.path.join(OUTDIR2,cdm_type)
        qct.to_csv(outname2 + qc_station_id+ ".psv", index=False, sep="|")
        #with open(filename, "w") as outfile:
        


        
        station_id=df.iloc[1]["primary_station_id"]
        cdm_type=("cdm_lite_202111_test_")
        print(station_id+"_lite")
        a = df['observed_variable'].unique()
        print (a)
        outname = os.path.join(OUTDIR,cdm_type)
        df.to_csv(outname+ station_id+ ".psv", index=False, sep="|")
     
    except:
        # Continue to next iteration.
        continue           
      
        
                 
    

  
          
     #  df.to_csv("D:/Python_CDM_conversion/daily/.csv/dfdy.csv", index=False, sep=",")
     #  qct.to_csv("D:/Python_CDM_conversion/daily/.csv/qcdy.csv", index=False, sep=",")
       
       
       
       
    
    
   

