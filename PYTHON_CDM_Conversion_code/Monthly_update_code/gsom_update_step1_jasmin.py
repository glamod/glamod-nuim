#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Jul 17 14:22:41 2019

@author: snoone
"""
# step 1 extracts the archive files to .cvs separted files(delete, insert, update)  current directory


import os
import sys
import glob
import pandas as pd
import calendar
import requests
import tarfile
import datetime

# add parent directory to access daily conversion scripts
sys.path.append("../")
import utils

EXTENSION = "csv"
VAR_LIST = ['STATION', 'DATE',"LATITUDE","LONGITUDE","ELEVATION",
              "NAME","PRCP", "PRCP_ATTRIBUTES","TAVG",
              "TAVG_ATTRIBUTES","TMAX","TMAX_ATTRIBUTES",
              "TMIN","TMIN_ATTRIBUTES","SNOW","SNOW_ATTRIBUTES",
              "AWND","AWND_ATTRIBUTES"]

def download_update_file():
    """
    Pull down the latest diff file from the host
    """

    # download the update tar.gz diff file from GHCND ftp site
    url = f"{utils.MONTHLY_URL_HOST}{utils.MONTHLY_URL_DIR}{utils.MONTHLY_UPDATE_FILE}"
    
    assert url == "https://www.ncei.noaa.gov//data/global-summary-of-the-month/archive/gsom-latest.tar.gz"

    r = requests.get(url, allow_redirects=True)
    open(f"{utils.MONTHLY_UPDATE_OUTDIR}{utils.MONTHLY_UPDATE_FILE}", 'wb').write(r.content)

    return # download_update_file


def extract_files():
    """
    Extract the csv from the tar file to a directory for processing.
    """

    # untar the most recent file
    tf = tarfile.open(f"{utils.MONTHLY_UPDATE_OUTDIR}{utils.MONTHLY_UPDATE_FILE}")
    tf.extractall(f"{utils.MONTHLY_UPDATE_EXTRACTDIR}")
    # change directory path to extract directory where .csv file located

    return

def add_months(sourcedate, months):
    """
    Function to add or subtract months

    Parameters
    ----------

    sourcedate : `datetime`

    months : `int`
    """
    month = sourcedate.month - 1 + months
    year = sourcedate.year + month // 12
    month = month % 12 + 1
    day = min(sourcedate.day, calendar.monthrange(year,month)[1])
    return datetime.date(year, month, day)


def get_previous_month_data():
    """
    Strip out required variables and extract previous months data 
    """

    # first disaggregate the station files by variables required and date range
    currentdate = datetime.date.today()

    # produce current date less one month
    now = pd.to_datetime(str(currentdate), format='%Y-%m')
    date = add_months(now, -1)

    # strip out day and use for selection of previous months data from station files
    date = [date.strftime("%Y-%m")]
    print(date[0])

    # find all files
    all_files = [i for i in glob.glob(f"{utils.MONTHLY_UPDATE_EXTRACTDIR}*.{EXTENSION}")]

    # read each filename, and only retain variables and dates needed
    for infile in all_files:
        df = pd.read_csv(infile, sep=",")   
        df = df.loc[:, df.columns.isin(VAR_LIST)]
        df = df.loc[df["DATE"].isin(date)]

        filename = infile.split("/")[-1]
        outname = f"{utils.MONTHLY_UPDATE_TEMPDIR}{filename}"

        df.to_csv(outname, index=False, sep=",")

    return

def concatenate_files():
    """
    Concatenate the relevant files together
    """

    # produce current date less one month
    now = pd.to_datetime(str(datetime.date.today()), format='%Y-%m')
    date = add_months(now, -1)

    # strip out day and use for selection of previous months data from station files
    date = [date.strftime("%Y-%m")]
    print(date[0])
    date2= str(date).strip('[]')
    date2 =str(date2).strip("''")
    
    # concatenate all files to remove files with no data and combine to gsom_diff 
    #  i.e., one file for all stations

    # import all csv files in current dir
    all_filenames = [i for i in glob.glob(f"{utils.MONTHLY_UPDATE_TEMPDIR}*.{EXTENSION}")]

    # combine all files in the list
    df = pd.concat([pd.read_csv(f, delimiter=',') for f in all_filenames])

    # reorder headers
    df = df[VAR_LIST]

    df.to_csv(f"{utils.MONTHLY_UPDATE_STNDIR}gsom_diff_{date2}.csv", index=False)

    return

def main(diagnostics=False):
    """
    Run processing of DAILY diff files for updates

    Parameters
    ----------

    diagnostics : `bool` 
        Turn on extra output (currently unused)
    """
    print("Downloading tar.gz file")
    download_update_file()
    print("...done")

    print("Extracting tar file")
    extract_files()
    print("...done")

    print("Extracting previous month")
    get_previous_month_data()
    print("...done")

    print("Concatenating files")
    concatenate_files()
    print("...done")

    print("Finished step 1 of monthly update")

    return

#***************************************
if __name__ == "__main__":

    import argparse

    # set up keyword arguments
    parser = argparse.ArgumentParser()
    parser.add_argument('--diagnostics', dest='diagnostics', action='store_true', default=False,
                        help='Extra output')


    args = parser.parse_args()
    main(diagnostics=args.diagnostics)
