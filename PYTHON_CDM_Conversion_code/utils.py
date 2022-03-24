# -*- coding: utf-8 -*-
"""
Utility routines for CDM conversion code
rjhd2, February 2022
snoone edited 17/02/2022
snoone edited 22/02/2022

"""
import os
import configparser


# -------------------------------------------------------------
# Read in configuration file and make available to all routines
CONFIG_FILE = "configuration.txt"

config = configparser.ConfigParser()
config.read(os.path.abspath(CONFIG_FILE))

# -----------------
# Subdaily/daily/monthly 
# Paths
SUBDAILY_QFF_IN_DIR = config.get("Paths", "subdaily_qff_indir")
SUBDAILY_HEAD_IN_DIR = config.get("Paths", "subdaily_cdmhead_indir")
SUBDAILY_QC_OUT_DIR = config.get("Paths", "subdaily_cdmqc_outdir")
DAILY_CSV_IN_DIR = config.get("Paths", "daily_csv_indir")
DAILY_HEAD_IN_DIR = config.get("Paths", "daily_cdmhead_csv_indir")
MONTHLY_CSV_IN_DIR = config.get("Paths", "monthly_csv_indir")
SUBDAILY_CDM_LITE_OUT_DIR = config.get("Paths", "subdaily_cdmlite_outdir")
SUBDAILY_CDM_OBS_OUT_DIR = config.get("Paths", "subdaily_cdmobs_outdir")
SUBDAILY_CDM_HEAD_OUT_DIR = config.get("Paths", "subdaily_cdmhead_outdir")
DAILY_CDM_LITE_OUT_DIR = config.get("Paths", "daily_cdmlite_outdir")
DAILY_QC_OUT_DIR = config.get("Paths", "daily_cdmqc_outdir")
DAILY_CDM_OBS_OUT_DIR = config.get("Paths", "daily_cdmobs_outdir")
MONTHLY_CDM_LITE_OUT_DIR = config.get("Paths", "monthly_cdmlite_outdir")
MONTHLY_CDM_OBS_OUT_DIR = config.get("Paths", "monthly_cdmobs_outdir")
MONTHLY_CDM_HEAD_OUT_DIR = config.get("Paths", "monthly_cdmhead_outdir")

# make directories if they do not exist
for path in (SUBDAILY_QC_OUT_DIR,
             SUBDAILY_CDM_LITE_OUT_DIR,
             SUBDAILY_CDM_OBS_OUT_DIR,
             SUBDAILY_CDM_HEAD_OUT_DIR,
             DAILY_CDM_LITE_OUT_DIR,
             DAILY_QC_OUT_DIR,
             DAILY_CDM_OBS_OUT_DIR,
             MONTHLY_CDM_LITE_OUT_DIR,
             MONTHLY_CDM_OBS_OUT_DIR,
             MONTHLY_CDM_HEAD_OUT_DIR,
             ):
    os.makedirs(path, exist_ok=True)


# Files
SUBDAILY_CDM_LITE_FILE_ROOT = config.get("Filenames", "subdaily_cdmlite_file")
SUBDAILY_QC_FILE_ROOT = config.get("Filenames", "subdaily_cdmqc_file")
SUBDAILY_CDM_OBS_FILE_ROOT = config.get("Filenames", "subdaily_cdmobs_file")
SUBDAILY_CDM_HEAD_FILE_ROOT = config.get("Filenames", "subdaily_cdmhead_file")
DAILY_CDM_LITE_FILE_ROOT = config.get("Filenames", "daily_cdmlite_file")
DAILY_QC_FILE_ROOT = config.get("Filenames", "daily_cdmqc_file")
DAILY_CDM_OBS_FILE_ROOT = config.get("Filenames", "daily_cdmobs_file")
DAILY_CDM_HEAD_FILE_ROOT= config.get("Filenames", "daily_cdmhead_file")
MONTHLY_CDM_LITE_FILE_ROOT = config.get("Filenames", "monthly_cdmlite_file")
MONTHLY_CDM_OBS_FILE_ROOT = config.get("Filenames", "monthly_cdmobs_file")
MONTHLY_CDM_HEAD_FILE_ROOT = config.get("Filenames", "monthly_cdmhead_file")
# Station records (note there are two different record_id .csv files needed one for
#observations tables and one for the header table
SUBDAILY_STATION_RECORD_ENTRIES_OBS_LITE = config.get("Records", "subdaily_station_records_obs_lite")
SUBDAILY_STATION_RECORD_ENTRIES_HEADER = config.get("Records", "subdaily_station_records_header")
DAILY_STATION_RECORD_ENTRIES_OBS_LITE = config.get("Records", "daily_station_records_obs_lite")
DAILY_STATION_RECORD_ENTRIES_HEADER = config.get("Records", "daily_station_records_header")
MONTHLY_STATION_RECORD_ENTRIES_OBS_LITE = config.get("Records", "monthly_station_records_obs_lite")
MONTHLY_STATION_RECORD_ENTRIES_HEADER = config.get("Records", "monthly_station_records_header")

