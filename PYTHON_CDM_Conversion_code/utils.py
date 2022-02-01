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
SUBDAILY_QC_OUT_DIR = config.get("Paths", "subdaily_qc_outdir")
SUBDAILY_CDMLITE_OUT_DIR = config.get("Paths", "subdaily_cdmlite_outdir")

# Files
SUBDAILY_CDMLITE_FILE_ROOT = config.get("Filenames", "subdaily_cdmlite_file")
SUBDAILY_QC_FILE_ROOT = config.get("Filenames", "subdaily_qc_file")

# Station records
STATION_RECORD_ENTRIES = config.get("Records", "station_records")
