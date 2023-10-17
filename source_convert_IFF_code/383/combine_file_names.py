# -*- coding: utf-8 -*-
"""
Created on Wed Jul 17 14:22:41 2019

@author: snoone
"""
import os
import glob
import pandas as pd
import csv
OUTDIR = "C:/Users/snoone/Dropbox/OLD_BELGIAN_AFRICAN_DARE_INVENTORY/Kevin_folder_african_inv/checked_forms_clidar_2022/ANDAPA_Form_3/ANDAPA_Form_3/B/issues/files"
os.chdir("C:/Users/snoone/Dropbox/OLD_BELGIAN_AFRICAN_DARE_INVENTORY/Kevin_folder_african_inv/checked_forms_clidar_2022/ANDAPA_Form_3/ANDAPA_Form_3/B/issues/files")

extension = 'csv'
all_filenames = [i for i in glob.glob('*.{}'.format(extension))]
#combine all files in the list
df = pd.concat([pd.read_csv(f,delimiter=',') for f in all_filenames])
#dewpointtemp df['Observed_value']= round(df['Observed_value'],1)
df.to_csv("files_andapa_form2_comb.csv",index=False)

