#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Aug 27 09:40:50 2020

@author: snoone
"""
# step 3 remove all unwanted files after processing
import os
import glob

# add parent directory to access daily conversion scripts
sys.path.append("../")
import utils

from gsom_update_step1_jasmin import EXTENSION

files = glob.glob(f"{utils.MONTHLY_UPDATE_EXTRACTDIR}*.{EXTENSION}")
for f in files:
    os.remove(f)

files = glob.glob(f"{utils.MONTHLY_UPDATE_TEMPDIR}*.{EXTENSION}")
for f in files:
    os.remove(f)

# be explicit on the tar.gz file that's been downloaded
files = glob.glob(f"{utils.MONTHLY_UPDATE_OUTDIR}{utils.MONTHLY_UPDATE_FILE}")
for f in files:
    os.remove(f)
