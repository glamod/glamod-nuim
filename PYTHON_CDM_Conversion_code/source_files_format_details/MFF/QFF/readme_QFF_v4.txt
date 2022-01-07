The Quality Controlled File Format (QFF) C3S311a Lot 2 read me document version.03
produced by Simon Noone, simon.noone@mu.ie


1st row contains column headers for each field.
This is a multi variable file created by the mingle/merge/qc process.


Station_ID = Merged Station primary Identifier
Station_name = station name
Year = Year (GMT) of the observation record
Month =	Month (GMT) of the observation record
Day = Day (GMT) of the observation record
Hour = Hour (GMT) of the observation record
Minute = Minute (GMT) of the observation record
Latitude = Latitude coordinate of a geophysical observation (-90.00 to 90.00)
Longitude = The longitude coordinate of a geophysical observation (-180.00 – 180.00)
Elevation = The elevation of a geophysical observation in meters relative to Mean Sea Level
temperature
temperature_source_ID= Source identifier for each observation
temperature_station_ID = station _id of mingled station for temperature observation
temperature_QC_flag= Quality control flag for temperature. denoted by an alpha_numeric relating to whether observed value passed, failed a specific test. 
dew_point_temperature
dew_point_temperature_source_ID= Source identifier for each observation
dew_point_temperature_station_ID= station _id of mingled station for dew_point_temperature observation
dew_point_temperature_QC_flag= Quality control flag for dew_point_temperature denoted by an alpha_numeric relating to whether observed value passed, failed a specific test. 
station_level_pressure
station_level_pressure_source_ID= Source identifier for each observation
station_level_pressure_station_ID = station _id of mingled station for station_level_pressure observation 
station_level_pressure_QC_flag= Quality control flag for station_level_pressure denoted by an alpha_numeric relating to whether observed value passed, failed a specific test.
sea_level_pressure
sea_level_pressure_source_ID= Source identifier for each observation
sea_level_pressure_station_ID = station _id of mingled station for sea_level_pressure observation
sea_level_pressure_QC_flag= Quality control flag for sea_level_pressure denoted by an alpha_numeric relating to whether observed value passed, failed a specific test.
wind_direction
wind_direction_source_ID= Source identifier for each observation
wind_direction_station_ID = station _id of mingled station for wind_direction observation
wind_direction_QC_flag= Quality control flag for wind_direction denoted by an alpha_numeric relating to whether observed value passed, failed a specific test. 
wind_speed
wind_speed_source_ID= Source identifier for each observation
wind_speed_station_ID = station _id of mingled station for wind_speed observation 
wind_speed_QC_flag= Quality control flag for wind_speed denoted by an alpha_numeric relating to whether observed value passed, failed a specific test.



Units (all variables should be in the following units for the IFF):

temperature =  (degrees C)
dew_point_temperature = (degrees C)
wind_direction =  (degrees)
wind speed = (meters per second)
sea level pressure = (hPa hectopascals)
station_level_pressure = (hPa hectopascals)



Saving and file naming convention:

Save as a pipe [|] separated file ext = [.psv] Multiple variables per file. 
Name the QFF using the Merged station ID 

Save the files in Level1/Land/ directory on the JASMIN workspace in the relevant Level1c timescale sub-directory.
 e.g /gws/nopw/j04/c3s311a_lot2/data/Level1/Land/level1c_sub_daily_data/


