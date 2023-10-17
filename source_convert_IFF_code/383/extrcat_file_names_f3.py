     
 
import os   
import glob
import pandas as pd
import csv

OUTDIR = "C:/Users/snoone/Dropbox/OLD_BELGIAN_AFRICAN_DARE_INVENTORY/Kevin_folder_african_inv/checked_forms_clidar_2022/Macenta_Form_3/Macenta_Form_3/"
os.chdir("C:/Users/snoone/Dropbox/OLD_BELGIAN_AFRICAN_DARE_INVENTORY/Kevin_folder_african_inv/checked_forms_clidar_2022/Macenta_Form_3/Macenta_Form_3/B")
extension = 'xlsx'
all_filenames = [i for i in glob.glob('*.{}'.format(extension))]

    
for filename in all_filenames:

      df1=pd.read_excel(filename,nrows=0)
      df1 = df1.T.reset_index().T.reset_index(drop=True)
      df1.columns =  ["1", "Station_name", "2", "3","4","Month","5","Year","9","File","11","12","13","14","15"]
      df1=df1.drop(columns =["1", "2", "3","4","5","9","11","12","13","14","15"])
      df1 = df1.astype(str)
      y=df1.iloc[0]["Year"]
      m=df1.iloc[0]["Month"]
      date=(y+"_"+m)
      
      outname = os.path.join(OUTDIR,date)
    #with open(filename, "w") as outfile:
      df1.to_csv(outname+".csv", index=False, sep=",")