# -*- coding: utf-8 -*-
"""
Utility routines for CDM conversion code
rjhd2, February 2022
snoone edited 17/02/2022
"""
import os
import configparser


# -------------------------------------------------------------
# Read in configuration file and make available to all routines
CONFIG_FILE = "configuration.txt"

config = configparser.ConfigParser()
config.read(os.path.abspath(CONFIG_FILE))

# -----------------
# Subdaily CDM Lite
# Paths
SUBDAILY_QFF_IN_DIR = config.get("Paths", "subdaily_qff_indir")
SUBDAILY_HEAD_IN_DIR = config.get("Paths", "subdaily_head_indir")
SUBDAILY_QC_OUT_DIR = config.get("Paths", "subdaily_qc_outdir")
SUBDAILY_CDM_LITE_OUT_DIR = config.get("Paths", "subdaily_cdmlite_outdir")
SUBDAILY_CDM_OBS_OUT_DIR = config.get("Paths", "subdaily_cdmobs_outdir")
SUBDAILY_CDM_HEAD_OUT_DIR = config.get("Paths", "subdaily_cdmhead_outdir")
# Files
SUBDAILY_CDM_LITE_FILE_ROOT = config.get("Filenames", "subdaily_cdmlite_file")
SUBDAILY_QC_FILE_ROOT = config.get("Filenames", "subdaily_qc_file")
SUBDAILY_CDM_OBS_FILE_ROOT = config.get("Filenames", "subdaily_cdmobs_file")
SUBDAILY_CDM_HEAD_FILE_ROOT = config.get("Filenames", "subdaily_cdmhead_file")
# Station records (note there are two different record_id .csv files needed one for
# observations tables and one for the header table
STATION_RECORD_ENTRIES_OBS_LITE = config.get("Records", "station_records_obs_lite")
STATION_RECORD_ENTRIES_HEADER = config.get("Records", "station_records_header")
