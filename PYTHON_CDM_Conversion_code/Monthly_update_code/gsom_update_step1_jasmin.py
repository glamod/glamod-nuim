#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Jul 17 14:22:41 2019

@author: snoone



"""

import os
import glob
import pandas as pd
import datetime
import calendar
import requests

#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Jul 17 14:22:41 2019

@author: snoone



"""
# downlaod the udpate tar.gz diff ile from GHCND ftp site


# need to change directory path
# download the gsom latest file form the ncei archive 
os.chdir ("/gws/nopw/j04/c3s311a_lot2/data/incoming/monthly_gsom_update")
url ="https://www.ncei.noaa.gov/data/global-summary-of-the-month/archive/gsom-latest.tar.gz"
r = requests.get(url, allow_redirects=True)
open('gsom-latest.tar.gz', 'wb').write(r.content)

names = ("/pub/data/ghcn/daily/superghcnd/*.tar.gz")

latest_time = None
latest_name = None


# step 1 extracts the archive files to .cvs separted files(delete,inset,update)in current directory
########################################################################
# need to change directory path
import os
os.chdir("/gws/nopw/j04/c3s311a_lot2/data/incoming/monthly_gsom_update") 
# extract the csv from teh tar file to a dircetory for processing.
import tarfile
# untar the most recent file
tf = tarfile.open("gsom-latest.tar.gz")
tf.extractall("/gws/nopw/j04/c3s311a_lot2/data/incoming/monthly_gsom_update/out")
# change directory path to extract directory where .csv file located


# strip out requirted variables and extrtact previous months data 

# first disagregate the station files by variables required and date range
OUTDIR = "/gws/nopw/j04/c3s311a_lot2/data/incoming/monthly_gsom_update/out2"
os.chdir("/gws/nopw/j04/c3s311a_lot2/data/incoming/monthly_gsom_update/out")
extension = 'csv'



# function to add and subtract dyas or months
from datetime import date
def add_months(sourcedate, months):
    month = sourcedate.month - 1 + months
    year = sourcedate.year + month // 12
    month = month % 12 + 1
    day = min(sourcedate.day, calendar.monthrange(year,month)[1])
    return datetime.date(year, month, day)
currentdate = datetime.date.today()

# produce current date less one month
now = pd.to_datetime(str(date.today()), format='%Y-%m')
date= add_months(now,-1)
#  strip out day and use for slection of previous months data from station files
date = date.strftime("%Y-%m")
print (date)
date=[date] 
all_filenames = [i for i in glob.glob('*.{}'.format(extension))]


for filename in all_filenames:
    df= pd.read_csv(filename,sep=",")   
    list= ['STATION', 'DATE',"LATITUDE","LONGITUDE","ELEVATION",
                                          "NAME","PRCP", "PRCP_ATTRIBUTES","TAVG",
                                          "TAVG_ATTRIBUTES","TMAX","TMAX_ATTRIBUTES",
                                          "TMIN","TMIN_ATTRIBUTES","SNOW","SNOW_ATTRIBUTES","AWND","AWND_ATTRIBUTES"]
    


    df = df.loc[:, df.columns.isin(list)]
    df=df.loc[df["DATE"] .isin(date)]

   
    outname = os.path.join(OUTDIR, filename)
   
    df.to_csv(outname, index=False, sep=",")
    
    

date2= str(date).strip('[]')
date2 =str(date2).strip("''")

# concatenate all fils to remove files with  no data an dcombine to gsomm_diff 
#  one file for all stations
import glob
import pandas as pd

import os

# import all psv files in current dir
os.chdir("/gws/nopw/j04/c3s311a_lot2/data/incoming/monthly_gsom_update/out2/")
extension = 'csv'
all_filenames = [i for i in glob.glob('*.{}'.format(extension))]
#  combine all files in the list
df = pd.concat([pd.read_csv(f,delimiter=',') for f in all_filenames])
# reorder headers
df=df[['STATION', 'DATE',"LATITUDE","LONGITUDE","ELEVATION",
                                          "NAME","PRCP", "PRCP_ATTRIBUTES","TAVG",
                                          "TAVG_ATTRIBUTES","TMAX","TMAX_ATTRIBUTES",
                                          "TMIN","TMIN_ATTRIBUTES","SNOW","SNOW_ATTRIBUTES",
                                          "AWND","AWND_ATTRIBUTES"]]
os.chdir("/gws/nopw/j04/c3s311a_lot2/data/incoming/monthly_gsom_update/stns")
df.to_csv("gsom_diff_"+ date2 + ".csv",index=False)

