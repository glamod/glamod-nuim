c     Program to make IFF file from combined USAF files
c     AJ_Kettle, 10Mar2020

c     23May2021: test 1 stn;   c/c=0.15/0.15min
c     23May2021: test 10 stn;  c/c=0.24/0.38min
c     23May2021: test 100 stn; c/c=1.00/2.05min; 2 stns rejected
c     23May2021: test 1000stn; c/c=23.28/39.47min; 154 stns rejected
c     24May2021: run stopped on newsci6 at i=6610; 1207 stns rejected

c     24May2021: stns 1-3000 on newsci3; c/c=75.1/105.1min; 384 rejected
c     24May2021: stns 3001-4000 on newsci3; c/c=114.1/129.8min; 764 rejected
c     25May2021: stns to i=8000 finished; 1391 rejects
c     26May2021: stns 8001-12000 on newsci6; c/c=529.4/706.6min; 2346 rejects
c     26May2021: stns 12001-14000 on newsci6; c/c=162.9/266.2min; 2642 rejects
c     26May2021: newsci6; program stopped i=23971 because netplat>20char
c     27May2021: newsci6: last few files completed at 12:10; 6260 rejects

c     Transfer record
c     CMANS: temperature: 1353  files
c     ICAO:  temperature: 64139

c     Number of CMANS IFF files: 4535

c     01Jun2021: evening run to fix source_id for CMANS; failed
c     02Jun2021: run to fix CMANS; successful; c/c=48.82/75.98min


c2-------10--------20--------30--------40--------50--------60--------70--------80
      IMPLICIT NONE
c************************************************************************
c     Declare variables 

      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: io

      REAL                :: f_cputime_st,f_cputime_en

      REAL                :: f_deltime_cpu_s
      REAL                :: f_deltime_clock_s

      CHARACTER(LEN=8)    :: s_date_st
      CHARACTER(LEN=10)   :: s_time_st
      CHARACTER(LEN=5)    :: s_zone_st
      INTEGER             :: i_values_st(8)
      CHARACTER(LEN=8)    :: s_date_en
      CHARACTER(LEN=10)   :: s_time_en
      CHARACTER(LEN=5)    :: s_zone_en
      INTEGER             :: i_values_en(8)

      REAL                :: f_clock_st_s,f_clock_en_s
c*****
c     Directories & filenames
      CHARACTER(LEN=300)  :: s_dir_datainput
      CHARACTER(LEN=300)  :: s_dir_usaf_filelist
      CHARACTER(LEN=300)  :: s_dir_outfile_iff_fileaccept
      CHARACTER(LEN=300)  :: s_dir_outfile_iff_netplatdistinct
      CHARACTER(LEN=300)  :: s_dir_outfile_iff_netplatdistinct2

      CHARACTER(LEN=300)  :: s_dir_outfile_yearstats
      CHARACTER(LEN=300)  :: s_dir_outfile_yearstats_sift
      CHARACTER(LEN=300)  :: s_dir_outfile_lastfile

      CHARACTER(LEN=300)  :: s_filename_stnlist
      CHARACTER(LEN=300)  :: s_filename_stnconfig
      CHARACTER(LEN=300)  :: s_filename_stnconfig_new
      CHARACTER(LEN=300)  :: s_filename_metadata
      CHARACTER(LEN=300)  :: s_filename_metadata3
      CHARACTER(LEN=300)  :: s_filename_fipscode
      CHARACTER(LEN=300)  :: s_filename_countrycode
c*****
      REAL                :: f_ndflag
      DOUBLE PRECISION    :: d_ndflag
c*****
      INTEGER,PARAMETER   :: l_stnlist_rgh=30000
      INTEGER             :: l_stnlist
      CHARACTER(LEN=30)   :: s_vec_stnlist(l_stnlist_rgh) 
c*****
      INTEGER,PARAMETER   :: l_scinput_rgh=200000    !(151480 elements in file)
      INTEGER             :: l_scinput
      CHARACTER(LEN=20)   :: s_scinput_primary_id(l_scinput_rgh)
      CHARACTER(LEN=2)    :: s_scinput_record_number(l_scinput_rgh)
      CHARACTER(LEN=20)   :: s_scinput_secondary_id(l_scinput_rgh)
      CHARACTER(LEN=50)   :: s_scinput_station_name(l_scinput_rgh)
      CHARACTER(LEN=10)   :: s_scinput_longitude(l_scinput_rgh)
      CHARACTER(LEN=10)   :: s_scinput_latitude(l_scinput_rgh)
      CHARACTER(LEN=10)   :: s_scinput_elevation_m(l_scinput_rgh)
      CHARACTER(LEN=1)    :: s_scinput_policy_license(l_scinput_rgh)
      CHARACTER(LEN=3)    :: s_scinput_source_id(l_scinput_rgh)
c*****
c     Stnconfig information
      INTEGER,PARAMETER   :: l_scoutput_rgh=200000 !183839 lines in this file
      INTEGER             :: l_scoutput
      INTEGER             :: l_scoutput_numfield
      INTEGER,PARAMETER   :: ilen=60
       
      CHARACTER(LEN=ilen) :: s_scoutput_vec_header(50)               
      CHARACTER(LEN=ilen) :: s_scoutput_mat_fields(l_scoutput_rgh,50)

      CHARACTER(LEN=20)   :: s_scinput2_primary_id(l_scoutput_rgh)
      CHARACTER(LEN=2)    :: s_scinput2_record_number(l_scoutput_rgh)
      CHARACTER(LEN=20)   :: s_scinput2_secondary_id(l_scoutput_rgh)
      CHARACTER(LEN=50)   :: s_scinput2_station_name(l_scoutput_rgh)
      CHARACTER(LEN=10)   :: s_scinput2_longitude(l_scoutput_rgh)
      CHARACTER(LEN=10)   :: s_scinput2_latitude(l_scoutput_rgh)
      CHARACTER(LEN=10)   :: s_scinput2_elevation_m(l_scoutput_rgh)
      CHARACTER(LEN=1)    :: s_scinput2_policy_license(l_scoutput_rgh)
      CHARACTER(LEN=3)    :: s_scinput2_source_id(l_scoutput_rgh)
c*****
c     Metadata variables
      INTEGER,PARAMETER   :: l_rgh_metadata=200000
      INTEGER             :: l_metadata
      CHARACTER(LEN=30)   :: s_metadata_platformid(l_rgh_metadata)
      CHARACTER(LEN=30)   :: s_metadata_networktype(l_rgh_metadata)
      CHARACTER(LEN=100)  :: s_metadata_name(l_rgh_metadata)
      CHARACTER(LEN=15)   :: s_metadata_st(l_rgh_metadata)
      CHARACTER(LEN=15)   :: s_metadata_co(l_rgh_metadata)
      CHARACTER(LEN=15)   :: s_metadata_lat(l_rgh_metadata)
      CHARACTER(LEN=15)   :: s_metadata_lon(l_rgh_metadata)
      CHARACTER(LEN=15)   :: s_metadata_elev(l_rgh_metadata)
      CHARACTER(LEN=15)   :: s_metadata_s(l_rgh_metadata)
      CHARACTER(LEN=15)   :: s_metadata_ualat(l_rgh_metadata)
      CHARACTER(LEN=15)   :: s_metadata_ualon(l_rgh_metadata)
      CHARACTER(LEN=15)   :: s_metadata_uaelev(l_rgh_metadata)
      CHARACTER(LEN=15)   :: s_metadata_time_conv(l_rgh_metadata)

c     Metadata match files
      CHARACTER(LEN=15)   :: s_metadata_eq_cdmlandcode(l_rgh_metadata)

      CHARACTER(LEN=300)  :: s_command
c************************************************************************
      print*,'start program im1'
c************************************************************************
c     Find start time    
      CALL CPU_TIME(f_cputime_st)

c     Find date & time
      CALL DATE_AND_TIME(s_date_st,s_time_st,s_zone_st,i_values_st)
c************************************************************************
c     Declare directories & filenames

      s_dir_datainput='Data_input/'
      s_dir_usaf_filelist=
     +  '/work/scratch-pw/akettle/P20210429_usafcompile_iff/'//
     +  'Step1_combine/'
      s_dir_outfile_iff_fileaccept=
     +  '/work/scratch-pw/akettle/P20210429_usafcompile_iff/'//
     +  'Step2_iff/'
      s_dir_outfile_iff_netplatdistinct=
     +  '/work/scratch-pw/akettle/P20210429_usafcompile_iff/'//
     +  'Step2_iffinfo/'
      s_dir_outfile_iff_netplatdistinct2=
     +  '/work/scratch-pw/akettle/P20210429_usafcompile_iff/'//
     +  'Step2_iffinfo2/'

c      s_dir_outfile_yearstats     ='Data_output/Data_highwind/'
c      s_dir_outfile_yearstats_sift='Data_output/Data_highwind_sift/'
      s_dir_outfile_lastfile      ='Data_output/'

      s_filename_stnlist='z_filelist.dat'
c      s_filename_stnconfig='station_configuration_read.txt'
c      s_filename_stnconfig_new='station_configuration_ffr.csv'
      s_filename_metadata='usaf-swo-03_20161109_STNMETADATA.csv'
      s_filename_metadata3='usaf-swo-03_20200329_STNMETADATA.csv'

      s_filename_fipscode='fips_3lett_mcneill20181016.dat'
      s_filename_countrycode='modify_subregion.dat'
c************************************************************************
c     Remove finished files

      GOTO 10

c*****
c     Clear main output directories
      s_command=
     +  'rm '//TRIM(s_dir_outfile_iff_fileaccept)//'Accept/*'
      print*,'s_command=',TRIM(s_command) 
      CALL SYSTEM(s_command,io)

c      s_command=
c     +  'rm '//TRIM(s_dir_outfile_iff_netplatdistinct)//'Reject/*'
c      print*,'s_command=',TRIM(s_command) 
c      CALL SYSTEM(s_command,io)
c*****
c     Clear diagnostics group1
      s_command=
     +  'rm '//TRIM(s_dir_outfile_iff_netplatdistinct)//'Accept/*'
      print*,'s_command=',TRIM(s_command) 
      CALL SYSTEM(s_command,io)

      s_command=
     +  'rm '//TRIM(s_dir_outfile_iff_netplatdistinct)//'Reject/*'
      print*,'s_command=',TRIM(s_command) 
      CALL SYSTEM(s_command,io)

      s_command=
     +  'rm '//TRIM(s_dir_outfile_iff_netplatdistinct)//'Latlon0/*'
      print*,'s_command=',TRIM(s_command) 
      CALL SYSTEM(s_command,io)
c*****
c      Clear diagnostics group2
      s_command=
     +  'rm '//TRIM(s_dir_outfile_iff_netplatdistinct2)//'Accept/*'
      print*,'s_command=',TRIM(s_command) 
      CALL SYSTEM(s_command,io)

      s_command=
     +  'rm '//TRIM(s_dir_outfile_iff_netplatdistinct2)//'Reject/*'
      print*,'s_command=',TRIM(s_command) 
      CALL SYSTEM(s_command,io)

      s_command=
     +  'rm '//TRIM(s_dir_outfile_iff_netplatdistinct2)//'Latlon0/*'
      print*,'s_command=',TRIM(s_command) 
      CALL SYSTEM(s_command,io)
      print*,'just finished erasing output file release'
c*****
 10   CONTINUE

c      STOP 'iff1'
c************************************************************************
c     Declare constants
      f_ndflag=-999.0
      d_ndflag=-999.0
c************************************************************************
c     Read in station list: hardwired list from scratch-pw

      CALL readin_stnlist(s_dir_datainput,s_filename_stnlist,
     +  l_stnlist_rgh,l_stnlist,
     +  s_vec_stnlist)

c      STOP 'iff1'
c************************************************************************
c     Read in stnconfig-file
c     Get elements from input file (new file from SN March 2019)
c      CALL get_input_elements(s_dir_datainput,s_filename_stnconfig,
c     +  l_scinput_rgh,l_scinput,
c     +  s_scinput_primary_id,s_scinput_record_number,
c     +  s_scinput_secondary_id,s_scinput_station_name,
c     +  s_scinput_longitude,s_scinput_latitude,
c     +  s_scinput_elevation_m,s_scinput_policy_license,
c     +  s_scinput_source_id)

c     Get stnconfig info
c      CALL get_stnconfig_qff(s_dir_datainput,
c     +  s_filename_stnconfig_new,
c     +  l_scoutput_rgh,l_scoutput,ilen,
c     +  l_scoutput_numfield,s_scoutput_vec_header,
c     +  s_scoutput_mat_fields)

c     Clip new stnconfig file to get limited set of variables
c      CALL clip_out_new_stnconfig(l_scoutput_rgh,l_scoutput,ilen,
c     +  l_scoutput_numfield,s_scoutput_vec_header,
c     +  s_scoutput_mat_fields,
c     +  s_scinput2_primary_id,s_scinput2_record_number,
c     +  s_scinput2_secondary_id,s_scinput2_station_name,
c     +  s_scinput2_longitude,s_scinput2_latitude,
c     +  s_scinput2_elevation_m,s_scinput2_policy_license,
c     +  s_scinput2_source_id)

c************************************************************************
c     Import master METAdata file: use metadata with last update 
      CALL readin_metadata_info3(
     +  s_dir_datainput,s_filename_metadata3,
     +  l_rgh_metadata,l_metadata,
     +  s_metadata_platformid,s_metadata_networktype,
     +  s_metadata_name,s_metadata_st,s_metadata_co,
     +  s_metadata_lat,s_metadata_lon,s_metadata_elev,
     +  s_metadata_s,
     +  s_metadata_ualat,s_metadata_ualon,s_metadata_uaelev,
     +  s_metadata_time_conv)

c************************************************************************
c     Get 3number code from USAF FIPS code
      CALL get_cdmcountry_usaffips(s_dir_datainput,
     +  s_filename_fipscode,s_filename_countrycode, 
     +  l_rgh_metadata,l_metadata,s_metadata_co, 
     +  s_metadata_eq_cdmlandcode)

c      STOP 'iff1'
c************************************************************************
c     Process data files & make iff
      CALL process_files_prelim20210521(
     +  s_date_st,s_time_st,
     +  f_ndflag,d_ndflag,
     +  s_dir_usaf_filelist,
     +  s_dir_outfile_iff_fileaccept,
     +  s_dir_outfile_iff_netplatdistinct,
     +  s_dir_outfile_iff_netplatdistinct2,
     +  s_dir_outfile_yearstats,
     +  s_dir_outfile_yearstats_sift,
     +  s_dir_outfile_lastfile,
     +  l_stnlist_rgh,l_stnlist,s_vec_stnlist,
c     +  l_scinput_rgh,l_scinput,
c     +  s_scinput_primary_id,s_scinput_record_number,
c     +  s_scinput_secondary_id,s_scinput_station_name,
c     +  s_scinput_longitude,s_scinput_latitude,
c     +  s_scinput_elevation_m,s_scinput_policy_license,
c     +  s_scinput_source_id,
c     +  l_scoutput_rgh,l_scoutput,
c     +  s_scinput2_primary_id,s_scinput2_record_number,
c     +  s_scinput2_secondary_id,s_scinput2_station_name,
c     +  s_scinput2_longitude,s_scinput2_latitude,
c     +  s_scinput2_elevation_m,s_scinput2_policy_license,
c     +  s_scinput2_source_id,
     +  l_rgh_metadata,l_metadata,
     +  s_metadata_platformid,s_metadata_networktype,
     +  s_metadata_name,s_metadata_st,s_metadata_co,
     +  s_metadata_lat,s_metadata_lon,s_metadata_elev,
     +  s_metadata_eq_cdmlandcode)

c************************************************************************
c************************************************************************
c     Find end time
      CALL CPU_TIME(f_cputime_en)

c     Find date & time
      CALL DATE_AND_TIME(s_date_en,s_time_en,s_zone_en,i_values_en)
c************************************************************************
      print*,'i_values_st',(i_values_st(i),i=1,8)
      print*,'i_values_en',(i_values_en(i),i=1,8)

      f_clock_st_s=FLOAT(i_values_st(3))*24.0*60.0*60.0+
     +  FLOAT(i_values_st(5))*60.0*60.0+FLOAT(i_values_st(6))*60.0+
     +  FLOAT(i_values_st(7))
      f_clock_en_s=FLOAT(i_values_en(3))*24.0*60.0*60.0+
     +  FLOAT(i_values_en(5))*60.0*60.0+FLOAT(i_values_en(6))*60.0+
     +  FLOAT(i_values_en(7))

      print*,'f_clock_st_s,f_clock_en_s=',f_clock_st_s,f_clock_en_s

      f_deltime_clock_s=f_clock_en_s-f_clock_st_s
c************************************************************************
      f_deltime_cpu_s=f_cputime_en-f_cputime_st
      print*,'f_deltime_cpu_s,f_deltime_cpu_min=',
     +  f_deltime_cpu_s,f_deltime_cpu_s/60.0     
      print*,'f_deltime_clock_s,f_deltime_clock_min=',
     +  f_deltime_clock_s,f_deltime_clock_s/60.0    

      print*,'date/time st=',TRIM(s_date_st)//' '//TRIM(s_time_st)
      print*,'date/time en=',TRIM(s_date_en)//' '//TRIM(s_time_en)
c************************************************************************
      print*,'end program iff1'
c************************************************************************

      END
