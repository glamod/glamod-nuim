
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Jan 16 15:57:57 2020

@author: snoone
"""
  ###FTP transfer of most up to date diff file for the GHCND from NOAA/NCEI 
    #####
import ftplib
import os 

os.chdir(r"/gws/nopw/j04/c3s311a_lot2/data/level0/land/daily_data_processing/superghcnd_daily_updates") 
#Open ftp connection works OK and get the last update tar.gz file (diff)
ftp = ftplib.FTP('ftp.ncdc.noaa.gov')
ftp.login(user='anonymous', passwd = 'anonymous')
names = ftp.nlst("/pub/data/ghcn/daily/superghcnd/*.tar.gz")
#names ='*tar.gz'
latest_time = None
latest_name = None

for name in names:
    time = ftp.voidcmd("MDTM " + name)
    if (latest_time is None) or (time > latest_time):
        latest_name = name
        latest_time = time


##split the string to remove the path and get the file name
split=latest_name.split("/")

latest_file=split[6]
print(latest_file)

last_file = open('last_file.txt', 'r').read()
##compare todays file name with yesterdays if same quit else continue
if latest_file == last_file:
    ftp.quit()
    print ("not updated")
else:
    print("updated")
    import ftplib
    path = '/pub/data/ghcn/daily/superghcnd/'
    filename = (latest_file)
    ftp = ftplib.FTP("ftp.ncdc.noaa.gov") 
    ftp.login("anonymous", "anonymous") 
    ftp.cwd(path)
    ftp.retrbinary("RETR " + filename, open(filename, 'wb').write)
    with open("last_file.txt", "w") as output:
        output.write(str(filename))
        ftp.quit()