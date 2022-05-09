# -*- coding: utf-8 -*-
"""
Using FTP, get the latest GHCND diff file, extract and make suitable
CDM compliant update files (Lite, QC, Obs & Header)

Created on Thu Nov 11 16:31:58 2021

@author: snoone
"""
import ftplib
import os 
import tarfile
import sys
import pandas as pd
import numpy as np
pd.options.mode.chained_assignment = None  # default='warn'

# add parent directory to access daily conversion scripts
sys.path.append("../")
import utils
import daily_csv_to_cdm_utils as d_utils


LAST_FILE = "last_file.txt"

def get_latest_ftp_file():
    """
    Obtain the most recent file from the FTP listing

    Returns
    -------

    latest_file :  `str`
        Most recent file on the FTP server
    """

    # log into FTP server and get list of files
    ftp = ftplib.FTP(utils.DAILY_FTP_SERVER)
    ftp.login(user='anonymous', passwd = 'anonymous')
    names = ftp.nlst(f"{utils.DAILY_FTP_DIR}*.tar.gz")

    names = sorted(names)
    # spin through the files and find the latest update
    latest_time = None
    latest_name = None

    # Goes through all 2k+ names - this will take longer and longer
    #  as time goes on.  Using the version below, this starts and the
    #  end and terminates the loop once an older file is found.

    # for name in names:
    #     print(name)
    #     time = ftp.voidcmd("MDTM " + name)
    #     if (latest_time is None) or (time > latest_time):
    #         latest_name = name
    #         latest_time = time

    # Using sorted list, start at the back
    #   presume that last filename is the most recent
    for name in names[::-1]:
        print(name)
        time = ftp.voidcmd("MDTM " + name)
        if (latest_time is None):
            latest_name = name
            latest_time = time
        elif time < latest_time:
            break           
        latest_name = name
        latest_time = time

    # extract the filename of the most recent file    
    latest_file = os.path.basename(latest_name)
    print(f"Most recent diff file: {latest_file}")

    return latest_file  # get_latest_ftp_file


def get_update(filename):
    """
    Pull down the latest diff file from the FTP server

    Parameters
    ----------

    filename :  `str`
        File to pull from FTP server
    """

    # retrieve the file
    ftp = ftplib.FTP(utils.DAILY_FTP_SERVER) 
    ftp.login(user="anonymous", passwd="anonymous") 
    ftp.cwd(utils.DAILY_FTP_DIR)
    ftp.retrbinary("RETR " + filename,
                   open(os.path.join(utils.DAILY_UPDATE_OUTDIR, filename), 'wb').write)

    # overwrite the last file downloaded
    with open(os.path.join(utils.DAILY_UPDATE_OUTDIR, LAST_FILE), "w") as outfile:
        outfile.write(str(filename))

    # and change to make globally r+w permissions
    os.chmod(os.path.join(utils.DAILY_UPDATE_OUTDIR, LAST_FILE), 0o777)
    ftp.quit()
    return  #  get_update


def extract_update():

    # Re-read what is the most recent file, and then untar archive
    last_file = open(os.path.join(utils.DAILY_UPDATE_OUTDIR, LAST_FILE), 'r').read()
    dir_name = last_file.split(".")[0]
    dir_path = os.path.join(utils.DAILY_UPDATE_OUTDIR, dir_name)

    # use last_file to untar the most recent file
    tar_gz = os.path.join(utils.DAILY_UPDATE_OUTDIR, last_file)
    print(f'[INFO] Untarring: {tar_gz} --> {dir_name}')

    tf = tarfile.open(tar_gz)
    tf.extractall(utils.DAILY_UPDATE_OUTDIR)

    return  #  extract_update


def delete_update_file_and_dir(dir_path):
    """
    Run processing of DAILY diff files for updates

    Parameters
    ----------

    dir_path : `str` 
        The directory and contents to delete
    """
    # delete processed folder from directory
    import shutil

    try:
        shutil.rmtree(dir_path)
    except OSError as e:
        print("Error: %s : %s" % (dir_path, e.strerror))

    return


def main(diagnostics=False):
    """
    Run processing of DAILY diff files for updates

    Parameters
    ----------

    diagnostics : `bool` 
        Turn on extra output (currently unused)
    """

    # what's the latest file on the server
    latest_file = get_latest_ftp_file()

    # get FTP file if new enough
    with open(os.path.join(utils.DAILY_UPDATE_OUTDIR, LAST_FILE), 'r') as infile:
        last_file = infile.read()
    # compare todays file name with yesterdays if same quit else continue
    if latest_file == last_file:
        print("not updated, not extracted")

    else:
        print(f"updating from {utils.DAILY_FTP_SERVER}")
        get_update(latest_file)
        print("updated")

        extract_update()
        print("extracted")

    # use last_file from step above to find extraction directory
    last_file_dir = last_file.split(".")[0]
    out_filename = last_file_dir.split("_diff_")[-1]

    # used in all stages, so read in here
    record_id_df = pd.read_csv(os.path.join(utils.DAILY_UPDATE_OUTDIR, "code", "record_id_dy.csv"))
    record_id_df = record_id_df.astype(str)


    # --------------------------------------------------
    # CDM Lite and QC tables

    # read in the insert.csv file for processing
    df = pd.read_csv(os.path.join(utils.DAILY_UPDATE_OUTDIR, last_file_dir, "insert.csv"),
                     sep=",", header = None)

    # add column headers
    df.columns=["Station_ID", "Date", "observed_variable", "observation_value","quality_flag","Measurement_flag","Source_flag","hour"]
    df = df.astype(str)

    # Just retain the variables require
    df = df[df["observed_variable"].isin(d_utils.VARIABLE_NAMES)]

    # set the source_flag
    df["Source_flag"] = df["Source_flag"]. astype(str) 
    for source_flag, source_value in d_utils.SOURCE_FLAGS.items():
        df['Source_flag'] = df['Source_flag'].str.replace(source_flag, source_value)

    # set the value significance for each variable
    df["value_significance"] = "" 
    for obs_var, val_signif in d_utils.VALUE_SIGNIFICANCE.items():
        df.loc[df['observed_variable'] == obs_var, 'value_significance'] = val_signif 


    # set the units for each variable
    df["units"] = ""
    for obs_var, unit in d_utils.UNITS.items():
        df.loc[df['observed_variable'] == obs_var, 'units'] = unit

    # set each height above station surface for each variable
    df["observation_height_above_station_surface"] = ""
    for obs_var, height in d_utils.HEIGHTS.items():
        df.loc[df['observed_variable'] == obs_var, 'observation_height_above_station_surface'] = height


    # add all columns for cdmlite [TODO: duplicated with daily_to_cdm_lite_v1.py]
    df['year'] = df['Date'].str[:4]
    df['month'] = df['Date'].map(lambda x: x[4:6])
    df['day'] = df['Date'].map(lambda x: x[6:8])
    df["hour"] = "00"
    df["Minute"] = "00"
    df["report_type"] = "3"
    df["source_id"] = df["Source_flag"]
    df["date_time_meaning"] = "1"
    df["observation_duration"] = "13"
    df["platform_type"] = ""
    df["station_type"] = "1"
    df["observation_id"] = ""
    df["data_policy_licence"] = "" 
    df["primary_station_id"] = df["Station_ID"]
    df["qc_method"] = df["quality_flag"].astype(str)
    df["quality_flag"] = df["quality_flag"].astype(str)

    # set quality flag to pass 0 or fail 1
    #    loop allows for option to include more information in future
    df.quality_flag[df.quality_flag == "nan"] = "0"
    for flag, new_flag in d_utils.QUALITY_FLAGS.items():
        df.quality_flag = df.quality_flag.str.replace(flag, new_flag)

    #at this point set up new df1 for cdm observations table later on
    obs_df = df.copy()

    # replace observed variable name by appropriate ID [after forking the Obs table DF]
    for obs_var, var_id in d_utils.VARIABLE_ID.items():
        df['observed_variable'] = df['observed_variable'].str.replace(obs_var, var_id)


    # SET OBSERVED VALUES TO CDM COMPLIANT values
    df["observation_value"] = pd.to_numeric(df["observation_value"],errors='coerce')
    # df["observed_variable"] = pd.to_numeric(df["observed_variable"],errors='coerce')
    # df['observation_value'] = df['observation_value'].astype(int).round(2)
    for var_name in d_utils.VARIABLE_NAMES:
        df = d_utils.convert_values(df, var_name, "observation_value", kelvin=True)

    # print (df.dtypes)                       
    # add timestamp to df and create report id
    df["Timestamp2"] = df["year"].map(str) + "-" + df["month"].map(str)+ "-" + df["day"].map(str)  
    df["Seconds"] = "00"
    df["offset"] = "+00"
    df["date_time"] = df["Timestamp2"].map(str)+ " " + df["hour"].map(str)+":"+df["Minute"].map(str)+":"+df["Seconds"].map(str) 
    df.date_time = df.date_time + '+00'
    df["report_id"] = df["date_time"]  
    df['primary_station_id_2'] = df['primary_station_id'].astype(str)+'-'+df['source_id'].astype(str)
    df["observation_value"] = pd.to_numeric(df["observation_value"],errors='coerce')
    df = df.astype(str)                                       
    df['source_id'] = df['source_id'].astype(str).apply(lambda x: x.replace('.0',''))
    df['primary_station_id_2'] = df['primary_station_id'].astype(str)+'-'+df['source_id'].astype(str)

    # add in location information to cdm lite station 
    df['primary_station_id_2'] = df['primary_station_id_2'].astype(str)

    df = d_utils.add_data_policy(df, record_id_df)

    df["observation_value"] = pd.to_numeric(df["observation_value"], errors='coerce')
    df = df.fillna("null")
    df = df.replace({"null":""})

    # sort out locational metadata   
    df["latitude"] = pd.to_numeric(df["latitude"], errors='coerce')
    df["longitude"] = pd.to_numeric(df["longitude"], errors='coerce')
    df["latitude"] = df["latitude"].round(3)
    df["longitude"] = df["longitude"].round(3)

    # add observation id to datafrme
    df["dates"] = ""
    df["dates"] = df["report_id"].str[:-11]
    df['observation_id'] = df['primary_station_id'].astype(str)+'-'+df['record_number'].astype(str)+'-'+df['dates'].astype(str)
    df['observation_id'] = df['observation_id'].str.replace(r' ', '-')
    df["observation_id"] = df["observation_id"]+df['observed_variable']+'-'+df['value_significance']
    df["primary_id"] = df["primary_station_id"]

    # merge in station list csv that contains the stations with multiple variables available for processing
    # this removes all stations with only one variable

    station_list = pd.read_csv(os.path.join(utils.DAILY_UPDATE_OUTDIR, "code", "station_list_dy.csv"))
    df['primary_id'] = df['primary_id'].astype(str)
    station_list = station_list.astype(str)
    df = df.merge(station_list, on=['primary_id'])


    # extract QC table information

    qct= df[["primary_station_id","report_id","record_number","qc_method","quality_flag","observed_variable","value_significance"]]

    qct = qct.astype(str)
    qct["dates"] = ""
    qct["dates"] = qct["report_id"].str[:-11]
    # set the QC observation_id
    qct['observation_id'] = qct['primary_station_id'].astype(str) + '-' +\
                            qct['record_number'].astype(str) + '-' +\
                            qct['dates'].astype(str)
    qct['observation_id'] = qct['observation_id'].str.replace(r' ', '-')
    qct["observation_id"] = qct["observation_id"] + qct['observed_variable'] + '-' +\
                            qct['value_significance']

    # restrict to requried columns
    qct= qct[["report_id","observation_id","qc_method","quality_flag"]]
    qct["quality_flag"] = pd.to_numeric(qct["quality_flag"],errors='coerce')
    qct.loc[qct['quality_flag'].notnull(), "quality_flag"] = 1
    qct = qct.fillna("Null")
    qct.quality_flag[qct.quality_flag == "Null"] = 0
    qct.astype(str)

    # replace observed variable name by appropriate code
    for qc_method, qc_code in d_utils.QC_METHODS.items():
        qct['qc_method'] = qct['qc_method'].str.replace(qc_method, qc_code)

    qct = qct.fillna("null")
    qct = qct[qct.qc_method != ""]
    qct = qct[qct.qc_method != "nan"]
    qct = qct[qct.quality_flag != 0]
    # remove final comma
    qct['qc_method'] = qct['qc_method'].str[:-1]
    qct.dropna(subset = ["qc_method"], inplace=True)
    qct["quality_flag"] = qct["quality_flag"].astype(int)

    # reorder df columns
    df = df[["observation_id","report_type","date_time","date_time_meaning",
               "latitude","longitude","observation_height_above_station_surface"
               ,"observed_variable","units","observation_value",
               "value_significance","observation_duration","platform_type",
               "station_type","primary_station_id","station_name","quality_flag"
               ,"data_policy_licence","source_id"]]

    # save to relevant directories
    try:
        lite_outname = os.path.join(utils.DAILY_UPDATE_CDM_LITE_OUTDIR, f"cdm_lite_{out_filename}.psv.gz")
        df.to_csv(lite_outname, index=False, sep="|", compression="infer")

        qc_outname = os.path.join(utils.DAILY_UPDATE_CDM_QC_OUTDIR, f"qc_definition_{out_filename}.psv.gz")
        qct.to_csv(qc_outname, index=False, sep="|", compression="infer")

    except IOError:
        # something wrong with file paths, despite checking
        print(f"Cannot save datafile: {lite_outname}")
    except RuntimeError:
        print("Runtime error")
        # TODO add logging for these errors


    # --------------------------------------------------
    # CDM Obs table
    # just retain the necessary columns

    obs_df = obs_df[["observation_id","report_type","year","day","month","date_time_meaning",
               "observation_height_above_station_surface","observed_variable","units"
               ,"observation_value","value_significance","observation_duration","platform_type",
               "station_type","primary_station_id","quality_flag"
               ,"data_policy_licence","source_id"]]


    #  set up original values            
    obs_df["observation_value"] = pd.to_numeric(obs_df["observation_value"],errors='coerce')
    obs_df["original_value"] = obs_df["observation_value"]
    for var_name in d_utils.VARIABLE_NAMES:
        obs_df = d_utils.convert_values(obs_df, var_name, "original_value", kelvin=False)


    # SET OBSERVED VALUES TO CDM COMPLIANT values
    obs_df["observation_value"] = pd.to_numeric(obs_df["observation_value"],errors='coerce')
    for var_name in d_utils.VARIABLE_NAMES:
        obs_df = d_utils.convert_values(obs_df, var_name, "observation_value", kelvin=True)

    # set the units for each variable
    obs_df["original_units"]=""
    for obs_var, unit in d_utils.ORIGINAL_UNITS.items():
        obs_df.loc[obs_df['observed_variable'] == obs_var, 'original_units'] = unit

    # set each height above station surface for each variable
    obs_df["observation_height_above_station_surface"]=""
    for obs_var, height in d_utils.HEIGHTS.items():
        obs_df.loc[obs_df['observed_variable'] == obs_var, 'observation_height_above_station_surface'] = height

    # set conversion flags for variables
    obs_df["conversion_flag"]=""
    for obs_var, conv_flag in d_utils.CONVERSION_FLAGS.items():
        obs_df.loc[obs_df['observed_variable'] == obs_var, 'conversion_flag'] = conv_flag

    # set conversion method for variables
    obs_df["conversion_method"]=""
    obs_df.loc[obs_df['observed_variable'] == "TMIN", 'conversion_method'] = '1' 
    obs_df.loc[obs_df['observed_variable'] == "TMAX", 'conversion_method'] = '1' 
    obs_df.loc[obs_df['observed_variable'] == "TAVG", 'conversion_method'] = '1' 

     # set numerical precision for variables
    obs_df["numerical_precision"]=""
    for obs_var, num_prec in d_utils.NUMERICAL_PRECISION.items():
        obs_df.loc[obs_df['observed_variable'] == obs_var, 'numerical_precision'] = num_prec

    obs_df["original_precision"]=""
    for obs_var, orig_prec in d_utils.ORIGINAL_PRECISION.items():
        obs_df.loc[obs_df['observed_variable'] == obs_var, 'original_precision'] = orig_prec

    # replace observed variable name by appropriate ID
    for obs_var, var_id in d_utils.VARIABLE_ID.items():
        obs_df['observed_variable'] = obs_df['observed_variable'].str.replace(obs_var, var_id)


    # add all columns for cdm_obs
    obs_df["hour"] ="00"
    obs_df["Minute"]="00"
    obs_df["report_type"]="3"
    obs_df["platform_type"]=""
    obs_df["station_type"]="1"
    obs_df["crs"]=""
    obs_df["z_coordinate"]=""
    obs_df["z_coordinate_type"]=""
    obs_df["secondary_variable"]=""
    obs_df["secondary_value"]=""
    obs_df["code_table"]=""
    obs_df["sensor_id"]=""
    obs_df["sensor_automation_status"]=""
    obs_df["exposure_of_sensor"]=""
    obs_df["processing_code"]=""
    obs_df["processing_level"]="0"
    obs_df["adjustment_id"]=""
    obs_df["traceability"]=""
    obs_df["advanced_qc"]=""
    obs_df["advanced_uncertainty"]=""
    obs_df["advanced_homogenisation"]=""
    obs_df["advanced_assimilation_feedback"]=""
    obs_df["source_record_id"]=""
    obs_df["location_method"]=""
    obs_df["location_precision"]=""
    obs_df["z_coordinate_method"]=""
    obs_df["bbox_min_longitude"]=""
    obs_df["bbox_max_longitude"]=""
    obs_df["bbox_min_latitude"]=""
    obs_df["bbox_max_latitude"]=""
    obs_df["spatial_representativeness"]=""
    obs_df["original_code_table"]=""
    obs_df["report_id"]=obs_df["observation_id"].str[:24]


    # add timestamp to obs_df and create report id
    obs_df["Timestamp2"] = obs_df["year"].map(str) + "-" +\
                           obs_df["month"].map(str)+ "-" +\
                           obs_df["day"].map(str) 
    obs_df["Seconds"] = "00"
    obs_df["offset"] = "+00"
    obs_df["date_time"] = obs_df["Timestamp2"].map(str)+ " " +\
                          obs_df["hour"].map(str) + ":" +\
                          obs_df["Minute"].map(str) + ":" +\
                          obs_df["Seconds"].map(str) 
    obs_df.date_time = obs_df.date_time + '+00'
    obs_df["dates"] = obs_df["date_time"].str[:-11] # NOTE - this is :-12 in the obs table code

    obs_df['primary_station_id_2'] = obs_df['primary_station_id'].astype(str) + '-' +\
                                     obs_df['source_id'].astype(str)
    obs_df["observation_value"] = pd.to_numeric(obs_df["observation_value"], errors='coerce')
    obs_df = obs_df.astype(str) 
    obs_df['source_id'] = obs_df['source_id'].astype(str).apply(lambda x: x.replace('.0', ''))

    # add in location information to cdm obs
    obs_df = d_utils.add_data_policy(obs_df, record_id_df)

    obs_df["observation_value"] = pd.to_numeric(obs_df["observation_value"], errors='coerce')
    obs_df = obs_df.fillna("null")
    obs_df = obs_df.replace({"null":""})

    # set up master obs_df to extract each variable
    obs_df["latitude"] = pd.to_numeric(obs_df["latitude"], errors='coerce')
    obs_df["longitude"] = pd.to_numeric(obs_df["longitude"], errors='coerce')
    obs_df["latitude"] = obs_df["latitude"].round(3)
    obs_df["longitude"] = obs_df["longitude"].round(3)

    # add observation id to dataframe
    obs_df['observation_id'] = obs_df['primary_station_id'].astype(str) + '-' +\
                               obs_df['record_number'].astype(str) + '-' +\
                               obs_df['dates'].astype(str)
    obs_df['observation_id'] = obs_df['observation_id'].str.replace(r' ', '-')
    obs_df["observation_id"] = obs_df["observation_id"] + obs_df['observed_variable'] + '-' +\
                               obs_df['value_significance']

    # create report_id fom observation_id
    obs_df['report_id'] = obs_df['primary_station_id'].astype(str) + '-' +\
                          obs_df['record_number'].astype(str) + '-' +\
                          obs_df['dates'].astype(str)
    obs_df['report_id'] = obs_df['report_id'].str.strip()

    # reorder obs_df columns
    obs_df = obs_df[["observation_id","report_id","data_policy_licence","date_time",
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

    # save one file to relevant directory
    try:
        obs_outname = os.path.join(utils.DAILY_UPDATE_CDM_OBS_OUTDIR, f"cdm_observations_{out_filename}.psv.gz")
        obs_df.to_csv(obs_outname, index=False, sep="|", compression="infer")

    except IOError:
        # something wrong with file paths, despite checking
        print(f"Cannot save datafile: {obs_outname}")
    except RuntimeError:
        print("Runtime error")
        # TODO add logging for these errors

    # --------------------------------------------------
    # CDM Header table
    # make header from completed observations table

    col_list = ["observation_id", "report_id", "longitude", "latitude", "source_id","date_time"]

    obs_df["report_id"] = obs_df["report_id"].str.strip()
    hdf = pd.DataFrame() 
    hdf['extract_record'] = obs_df['report_id'].str[:-11]
    hdf['station_record_number'] = hdf['extract_record'].str[12:]
    hdf['primary_station_id'] = hdf['extract_record'].str[:11]                                           
    hdf["report_id"] = obs_df["report_id"]
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
    hdf["processing_codes"] = ""
    hdf["longitude"] = obs_df["longitude"]
    hdf["latitude"] = obs_df["latitude"]
    hdf["source_id"] = obs_df["source_id"]
    hdf['record_timestamp'] = pd.to_datetime('now').strftime("%Y-%m-%d %H:%M:%S")
    hdf.record_timestamp = hdf.record_timestamp + '+00'
    hdf["history"] = ""
    hdf["processing_level"] = "0"
    hdf["report_timestamp"] = obs_df["date_time"]
    hdf['primary_station_id_3'] = hdf['primary_station_id'].astype(str) + '-' +\
                                  hdf['source_id'].astype(str) + '-' +\
                                  hdf['station_record_number'].astype(str)
    hdf["duplicates_report"] = hdf["report_id"]

    # add in required information from external .csv file specific for header tables 
    hdf = hdf.astype(str)
    hdf = record_id_df.merge(hdf, on=['primary_station_id_3'])

    # tidy up metadata
    hdf['height_of_station_above_sea_level'] = hdf['height_of_station_above_sea_level'].astype(str).apply(lambda x: x.replace('.0',''))

    hdf = hdf.rename(columns={"latitude_x":"latitude",})
    hdf = hdf.rename(columns={"longitude_x":"longitude",})
    hdf["latitude"] = pd.to_numeric(hdf["latitude"], errors='coerce')
    hdf["longitude"] = pd.to_numeric(hdf["longitude"], errors='coerce')
    hdf["latitude"] = hdf["latitude"].round(3)
    hdf["longitude"] = hdf["longitude"].round(3)

    hdf = hdf.drop_duplicates(subset=['duplicates_report'])

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

    hdf['region'] = hdf['region'].astype(str).apply(lambda x: x.replace('.0', ''))
    hdf['sub_region'] = hdf['sub_region'].astype(str).apply(lambda x: x.replace('.0', ''))

    # save file to relevant directory 
    try:
        header_outname = os.path.join(utils.DAILY_UPDATE_CDM_HEADER_OUTDIR, f"cdm_header_{out_filename}.psv.gz")
        hdf.to_csv(header_outname, index=False, sep="|", compression="infer")
    except IOError:
        # something wrong with file paths, despite checking
        print(f"Cannot save datafile: {header_outname}")
    except RuntimeError:
        print("Runtime error")
        # TODO add logging for these errors

    # delete_update_file_and_dir(os.path.join(utils.DAILY_UPDATE_OUTDIR, last_file_dir))

    return


#***************************************
if __name__ == "__main__":

    import argparse

    # set up keyword arguments
    parser = argparse.ArgumentParser()
    parser.add_argument('--diagnostics', dest='diagnostics', action='store_true', default=False,
                        help='Extra output')


    args = parser.parse_args()
    main(diagnostics=args.diagnostics)
