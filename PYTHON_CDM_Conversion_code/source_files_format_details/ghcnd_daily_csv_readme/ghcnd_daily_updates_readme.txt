The superghcnd_diff_yyyymmdd1_to_yyyymmdd2.tar.gz files contain the changes to the superghcnd_full data between the two dates listed
in the file name (yyyymmdd1 and yyyymmdd2, where yyyy = year; mm=month; and dd=day of the two different days that are compared).

There are three files contained in each superghcnd_diff_yyyymmdd_to_yyyymmdd.tar.gz file:

update.csv:  contains changes to values or flags that were present on yyyymmdd1 
             (i.e., these values or flags have been altered between yyyymmdd1 and yyyymmdd2)
insert.csv:  contains values that were new on yyyymmdd2 (i.e., that were not yet available 
             on yyyymmdd1, but were newly available on yyyymmdd2)
delete.csv   contains values that were present on yyyymmdd1, but not on yyyymmdd2 
             (i.e., have been removed from the yyyymmdd1 version of the dataset as of yyyymmdd2)

The format of update.csv, insert.csv and delete.csv is the same comma delimited format as in the superghcnd_full and /by_year files 
(as indicated below):

ID = 11 character station identification code
YEAR/MONTH/DAY = 8 character date in YYYYMMDD format (e.g. 19860529 = May 29, 1986)
ELEMENT = 4 character indicator of element type 
DATA VALUE = 5 character data value for ELEMENT 
M-FLAG = 1 character Measurement Flag 
Q-FLAG = 1 character Quality Flag 
S-FLAG = 1 character Source Flag 
OBS-TIME = 4-character time of observation in hour-minute format (i.e. 0700 =7:00 am)

See section III of the GHCN-Daily readme.txt file (ftp://ftp.ncdc.noaa.gov/pub/data/ghcn/daily/readme.txt)
for an explanation of ELEMENT codes and their units as well as the M-FLAG, Q-FLAGS and S-FLAGS.

The OBS-TIME field is populated with the observation times contained in NOAA/NCEI's HOMR station history database.  