#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Jul 20 14:13:01 2020

@author: snoone
"""
import tarfile
import os 
SOURCE_DIR = "/gws/nopw/j04/c3s311a_lot2/data/level0/land/daily_data_processing/superghcnd_daily_updates"
OUTPUT_DIR = "/gws/nopw/j04/c3s311a_lot2/data/level0/land/daily_data_processing/superghcnd_daily_updates"
last_file = open(os.path.join(SOURCE_DIR, 'last_file.txt'), 'r').read()
dir_name = last_file.split(".")[0]
dir_path = os.path.join(OUTPUT_DIR, dir_name)


    # use last_file to untar the most recent file
tar_gz = os.path.join(SOURCE_DIR, last_file)
    #tar_gz = os.path.join(OUTPUT_DIR, dir_name)
print(f'[INFO] Untarring: {tar_gz} --> {last_file}')

tf = tarfile.open(tar_gz)
tf.extractall("/gws/nopw/j04/c3s311a_lot2/data/level0/land/daily_data_processing/superghcnd_daily_updates")