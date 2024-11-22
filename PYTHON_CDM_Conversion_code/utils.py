# -*- coding: utf-8 -*-
"""
Utility routines for CDM conversion code
rjhd2, February 2022
snoone edited 17/02/2022
snoone edited 22/02/2022

"""
import os
import configparser
import glob


# -------------------------------------------------------------
# Read in configuration file and make available to all routines
CONFIG_FILE = "configuration.txt"

config = configparser.ConfigParser()
# more convoluted to ensure it pulls the config_file even if called from another dir
config.read(os.path.join(os.path.abspath(os.path.dirname( __file__ )), CONFIG_FILE))

# -----------------
# Subdaily/daily/monthly 
# Paths
SUBDAILY_QFF_IN_DIR = config.get("Paths", "subdaily_qff_indir")
SUBDAILY_HEAD_IN_DIR = config.get("Paths", "subdaily_cdmhead_indir")
DAILY_CSV_IN_DIR = config.get("Paths", "daily_csv_indir")
DAILY_HEAD_IN_DIR = config.get("Paths", "daily_cdmhead_csv_indir")
MONTHLY_CSV_IN_DIR = config.get("Paths", "monthly_csv_indir")
SUBDAILY_CDM_LITE_OUT_DIR = config.get("Paths", "subdaily_cdmlite_outdir")
SUBDAILY_CDM_CORE_OUT_DIR = config.get("Paths", "subdaily_cdmcore_outdir")
SUBDAILY_CDM_QC_OUT_DIR = config.get("Paths", "subdaily_cdmqc_outdir")
SUBDAILY_CDM_OBS_OUT_DIR = config.get("Paths", "subdaily_cdmobs_outdir")
SUBDAILY_CDM_HEAD_OUT_DIR = config.get("Paths", "subdaily_cdmhead_outdir")
DAILY_CDM_LITE_OUT_DIR = config.get("Paths", "daily_cdmlite_outdir")
DAILY_CDM_QC_OUT_DIR = config.get("Paths", "daily_cdmqc_outdir")
DAILY_CDM_OBS_OUT_DIR = config.get("Paths", "daily_cdmobs_outdir")
DAILY_CDM_HEAD_OUT_DIR = config.get("Paths", "daily_cdmhead_outdir")
MONTHLY_CDM_LITE_OUT_DIR = config.get("Paths", "monthly_cdmlite_outdir")
MONTHLY_CDM_QC_OUT_DIR = config.get("Paths", "monthly_cdmqc_outdir")
MONTHLY_CDM_OBS_OUT_DIR = config.get("Paths", "monthly_cdmobs_outdir")
MONTHLY_CDM_HEAD_OUT_DIR = config.get("Paths", "monthly_cdmhead_outdir")

# make directories if they do not exist
for path in (SUBDAILY_CDM_LITE_OUT_DIR,
             SUBDAILY_CDM_CORE_OUT_DIR,
             SUBDAILY_CDM_QC_OUT_DIR,
             SUBDAILY_CDM_OBS_OUT_DIR,
             SUBDAILY_CDM_HEAD_OUT_DIR,
             DAILY_CDM_LITE_OUT_DIR,
             DAILY_CDM_QC_OUT_DIR,
             DAILY_CDM_OBS_OUT_DIR,
             DAILY_CDM_HEAD_OUT_DIR,
             MONTHLY_CDM_LITE_OUT_DIR,
             MONTHLY_CDM_QC_OUT_DIR,
             MONTHLY_CDM_OBS_OUT_DIR,
             MONTHLY_CDM_HEAD_OUT_DIR,
             ):
    os.makedirs(path, exist_ok=True)


# Files
SUBDAILY_CDM_LITE_FILE_ROOT = config.get("Filenames", "subdaily_cdmlite_file")
SUBDAILY_CDM_CORE_FILE_ROOT = config.get("Filenames", "subdaily_cdmcore_file")
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
#  observations tables and one for the header table
SUBDAILY_STATION_RECORD_ENTRIES_OBS_LITE = config.get("Records", "subdaily_station_records_obs_lite")
SUBDAILY_STATION_RECORD_ENTRIES_OBS_CORE = config.get("Records", "subdaily_station_records_obs_core")
SUBDAILY_STATION_RECORD_ENTRIES_HEADER = config.get("Records", "subdaily_station_records_header")
DAILY_STATION_RECORD_ENTRIES_OBS_LITE = config.get("Records", "daily_station_records_obs_lite")
DAILY_STATION_RECORD_ENTRIES_HEADER = config.get("Records", "daily_station_records_header")
MONTHLY_STATION_RECORD_ENTRIES_OBS_LITE = config.get("Records", "monthly_station_records_obs_lite")
MONTHLY_STATION_RECORD_ENTRIES_HEADER = config.get("Records", "monthly_station_records_header")

# Daily updates from GHCND
DAILY_FTP_SERVER = config.get("DailyUpdates", "ftp")
DAILY_FTP_DIR = config.get("DailyUpdates", "ftpdir")
DAILY_UPDATE_OUTDIR = config.get("DailyUpdates", "daily_update_outdir")

DAILY_UPDATE_CDM_HEADER_OUTDIR = config.get("DailyUpdates", "daily_update_cdmhead_outdir")
DAILY_UPDATE_CDM_OBS_OUTDIR = config.get("DailyUpdates", "daily_update_cdmobs_outdir")
DAILY_UPDATE_CDM_QC_OUTDIR = config.get("DailyUpdates", "daily_update_cdmqc_outdir")
DAILY_UPDATE_CDM_LITE_OUTDIR = config.get("DailyUpdates", "daily_update_cdmlite_outdir")
# make directories if they do not exist
for path in (DAILY_UPDATE_OUTDIR,
             DAILY_UPDATE_CDM_HEADER_OUTDIR,
             DAILY_UPDATE_CDM_OBS_OUTDIR,
             DAILY_UPDATE_CDM_QC_OUTDIR,
             DAILY_UPDATE_CDM_LITE_OUTDIR,
             ):
    os.makedirs(path, exist_ok=True)

# Monthly updates from GHCND
MONTHLY_URL_HOST = config.get("MonthlyUpdates", "url")
MONTHLY_URL_DIR = config.get("MonthlyUpdates", "urldir")
MONTHLY_UPDATE_FILE = config.get("MonthlyUpdates", "monthly_file")
MONTHLY_UPDATE_OUTDIR = config.get("MonthlyUpdates", "monthly_update_outdir")
MONTHLY_UPDATE_EXTRACTDIR = config.get("MonthlyUpdates", "monthly_update_extractdir")
MONTHLY_UPDATE_TEMPDIR = config.get("MonthlyUpdates", "monthly_update_tempdir")
MONTHLY_UPDATE_STNDIR = config.get("MonthlyUpdates", "monthly_update_stndir")
MONTHLY_UPDATE_CDM_HEADER_OUTDIR = config.get("MonthlyUpdates", "monthly_update_cdmhead_outdir")
MONTHLY_UPDATE_CDM_OBS_OUTDIR = config.get("MonthlyUpdates", "monthly_update_cdmobs_outdir")
MONTHLY_UPDATE_CDM_QC_OUTDIR = config.get("MonthlyUpdates", "monthly_update_cdmqc_outdir")
MONTHLY_UPDATE_CDM_LITE_OUTDIR = config.get("MonthlyUpdates", "monthly_update_cdmlite_outdir")
# make directories if they do not exist
for path in (MONTHLY_UPDATE_OUTDIR,
             MONTHLY_UPDATE_EXTRACTDIR,
             MONTHLY_UPDATE_TEMPDIR,
             MONTHLY_UPDATE_STNDIR,
             MONTHLY_UPDATE_CDM_HEADER_OUTDIR,
             MONTHLY_UPDATE_CDM_OBS_OUTDIR,
             MONTHLY_UPDATE_CDM_QC_OUTDIR,
             MONTHLY_UPDATE_CDM_LITE_OUTDIR
         ):
    os.makedirs(path, exist_ok=True)



def get_station_list_to_process(indir, extension, station="", subset="", run_all=False, prepend=""):
    """
    Parameters
    ----------

    indir :  `str`
        Directory in which the input files are to be found

    extension : `str`
        Filename extension of the input files

    station : `str` 
        Single station ID to process

    subset : `str`
        Path to file containing subset of IDs to process

    run_all : `bool`
        Run all files in the directory defined in the config file

    prepend : `str`
        Text to insert before station ID for input filename
    """

    # Obtain list of station(s) to process (single/subset/all)
    if station != "":
        print(f"Single station run: {station}")
        all_filenames = [os.path.join(indir, f"{prepend}{station}{extension}")]
        
    elif subset != "":
        print(f"Subset of stations run defined in: {subset}")
        # Allows for parallelisation
        try:
            with open(subset, "r") as f:
                filenames = f.read().splitlines()
                #now add the path to the front
                all_filenames = []
                for infile in filenames:
                    all_filenames += [os.path.join(indir, f"{prepend}{infile}{extension}")]

            print(f"   N = {len(all_filenames)}")

        except IOError:
            print(f"Subset file {subset} cannot be found")
            all_filenames = []
        
        except OSError:
            print(f"Subset file {subset} cannot be found")
            all_filenames = []
        
    elif run_all:
        print(f"All stations run in {indir}")
        # no prepend necessary as working from directory listing
        all_filenames = [i for i in glob.glob(os.path.join(indir, f'*{extension}'))]
        print(f"   N = {len(all_filenames)}")

    return all_filenames
