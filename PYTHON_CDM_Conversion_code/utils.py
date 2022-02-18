# -*- coding: utf-8 -*-
"""
Utility routines for CDM conversion code

rjhd2, February 2022
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
DAILY_HEAD_IN_DIR = config.get("Paths", "subdaily_head_indir")
SUBDAILY_QC_OUT_DIR = config.get("Paths", "subdaily_qc_outdir")
SUBDAILY_CDMLITE_OUT_DIR = config.get("Paths", "subdaily_cdmlite_outdir")
SUBDAILY_CDMOBS_OUT_DIR = config.get("Paths", "subdaily_cdmobs_outdir")
SUBDAILY_CDMHEAD_OUT_DIR = config.get("Paths", "subdaily_cdmhead_outdir")

# Files
SUBDAILY_CDMLITE_FILE_ROOT = config.get("Filenames", "subdaily_cdmlite_file")
SUBDAILY_QC_FILE_ROOT = config.get("Filenames", "subdaily_qc_file")
SUBDAILY_CDMOBS_FILE_ROOT = config.get("Filenames", "subdaily_cdmobs_file")
SUBDAILY_CDMHEAD_FILE_ROOT = config.get("Filenames", "subdaily_cdmhead_file")

# Station records (note there are two difgferent record needd one for obs and on
#header tables code
STATION_RECORD_ENTRIES = config.get("Records", "station_records")
STATION_RECORD_ENTRIES_H = config.get("Records", "station_records_H")
