The Merge File Format (MFF) C3S311a Lot 2 read me document version.02
produced by Simon Noone, simon.noone@mu.ie



1st row contains column headers for each field.
This is a multi varibale file created by the mingle/merge process.


Station_ID = Merged Station Identifier
Station_name = station name
Year = Year (GMT) of the observation record
Month =	Month (GMT) of the observation record
Day = Day (GMT) of the observation record
Hour = Hour (GMT) of the observation record
Minute = Minute (GMT) of the observation record
Latitude = Latitude coordinate of a geophysical observation (-90.00 to 90.00)
Longitude = The longitude coordinate of a geophysical observation (-180.00 – 180.00)
Elevation = The elevation of a geophysical observation in meters relative to Mean Sea Level
temperature=  observed variable
temperature_source_ID = source identifier for each observation
temperature_station_ID = station _id of mingled station for temperature observation
dew_point_temperature = observed variable
dew_point_temperature_source_ID = source identifier for each observation
dew_point_temperature_station_ID= station _id of mingled station for dew_point_temperature observation
station_level_pressure =observed variable
station_level_pressure_source_ID = source identifier for each observation
station_level_pressure_station_ID = station _id of mingled station for station_level_pressure observation
sea_level_pressure = observed variable
sea_level_pressure_source_ID = source identifier for each observation
sea_level_pressure_station_ID = station _id of mingled station for sea_level_pressure observation
wind_direction= observed variable
wind_direction_source_ID = source identifier for each observation
wind_direction_station_ID = station _id of mingled station for wind_direction observation
wind_speed= observed variable = station _id of mingled station for wind_speed
wind_speed_source_ID = source identifier for each observation 
wind_speed_station_ID = station _id of mingled station for wind_speed observation 

Units (all variables should be in the following units for the IFF):

temperature =  (degrees C)
dew_point_temperature = (degrees C)
wind_direction =  (degrees)
wind speed = (meters per second)
sea level pressure = (hPa hectopascals)
station_level_pressure = (hPa hectopascals)



Saving and file naming convention:

Save as a pipe [|] separated file ext = [.psv] Multiple variables per file. 
Name the MFF using the Merged station ID 

Save the files in Level1/Land/ directory on the JASMIN workspace in the relevant Level1b timescale sub-directory.
 e.g /gws/nopw/j04/c3s311a_lot2/data/Level1/Land/level1b_sub_daily_data/ date veruions e.g v20200601


