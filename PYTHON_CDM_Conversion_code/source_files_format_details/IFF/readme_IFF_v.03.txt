The Intermediate File Format C3S311a Lot 2 read me document version.02
produced by Simon Noone, simon.noone@mu.ie

First row contains the column headers see below for explanation:

Source_ID = Source identifier which will be issued by C3S Lot2 
Station_ID = Station Identifier - record number based on staTion configurations. e.g - WMO10002-1
Station_name = station name
Alias_station_name = Alias station name (if more than one separate with a comma)
Year = Year (GMT) of the observation record
Month =	Month (GMT) of the observation record
Day = Day (GMT) of the observation record
Hour = Hour (GMT) of the observation record
Minute = Minute (GMT) of the observation record
Latitude = Latitude coordinate of a geophysical observation (-90.00 to 90.00)
Longitude = The longitude coordinate of a geophysical observation (-180.00 – 180.00)
Elevation = The elevation of a geophysical observation in meters relative to Mean Sea Level
Observed_value = The observed  value (see variable units below)
Source_QC_flag	= Quality Flags from source for observed value(see qc_look_up_table for definitions)
Original_observed_value = original observed  value (if available) 
Original_observed_value_units = original observed  value units 
Report_type_code = this code corresponds to the Geophysical Report e.g FM-12 FM-13 etc
Measurement_code_1 = Codes for additional source information about the observation (see measurement code table for definitions)
Measurement_code_2 = Codes for additional source information about the observation (see measurement code table for definitions)

Units (all variables should be in the following units for the IFF):

temperature =  (degrees C)
dew_point_temperature = (degrees C)
wind_direction =  (degrees)
wind speed = (meters per second)
sea level pressure = (hPa hectopascals)
station_level_pressure = (hPa hectopascals)



Saving and file naming convention:

Save as a pipe [|] separated file ext = [.psv] one single variable per file. 

Save the files in Level1/Land/ directory on the JASMIN workspace in the relevant Level1a timescale sub-directory, in the relevant variable specific sub-directory, 
in the relevant source sub-directory. e.g /gws/nopw/j04/c3s311a_lot2/data/Level1/Land/level1a_sub_daily_data/sea_level_pressure/245
 
Name the IFF using the station ID - record number (for multiple station configurations) combined with the variable name (exactly as defined below) combined with source ID using _ separators e.g IE9999-1_sea_level_pressure_245.psv

temperature 
dew_point_temperature
wind_direction 
wind_speed 
sea_level_pressure 
station_level_pressure 
