c     Program to make header & observation files 
c     AJ_Kettle, 03Sep2019
c     22Oct2019: unexpected problem in i=159 with source letter not found
c     04Jun2020: completed full run in 2 parts with Jasmin-Lotus; about 28h; break at 24h
c     11Jun2020: changed report_type in cdm maker & eraase procedure
c     13Jun2020: last full run in 3.70h with lastfile record
c        i=    75294
c        ii=       0
c        T1:stnconf     0
c        T2:srclett     1
c        T3:newlett     0
c        T4:rcrdnum    69
c        T5:cdmmake   334
c        date/time= 20200613 223446.811
c        clock time=   3.6989 h

c     NEW RELEASE
c     03Feb2021: 83960 files in stations selection list; 114417 files source directory
c     03Feb2021: complete run through 1 file;   newsci6; c/c=0.016/0.033min
c     03Feb2021: complete run through 10 files; newsci6; c/c=0.035/0.233min
c     03Feb2021: note original columns: header:43, obs:46, lite:18
c     03Feb2021: run through 1000 files; newsci6; c/c=3.81/14.97min
c     04Feb2021: run through 5000 files; newsci6; c/c=14.6/90.0min
c     04Feb2021: tried full cycle to stop when qc flag indicated; newsci6; i=13298
c     05Feb2021: tried overnight full cycle; stopped by Jasmin resent 20000 stations
c     07Feb2021: run through 10 files; newsci6; c/c=0.035/0.90min
c     08Feb2021: run through 10 files; newsci6; c/c=0.040/0.27min
c     08Feb2021: run through first 16868 files on newsci6; no problem
c     08Feb2021: run through 50000-74000 files on newsci6; no problem
c     08Feb2021: run through 74500-83960 files on newsci6; c/c=24.5/145.5min
c     10Feb2021: run through 1-83960 files on newsci6; c/c=265.7/1386.2min

c     15Jun2021: run through 1-83960 files on newsci6; c/c=208.2/1270.4min

c     21Jun2021: copying errors
c     LITE; CDM_lite_r202102_USC00117470.psv.gz, CDM_lite_r202102_USC00311901.psv.gz
c     HEADER: no problems
c     OBSERVATION: no problems

c     Finished output files must go to:
c     /gws/nopw/j04/c3s311a_lot2/data/level2/land/r202005/cdm_lite/monthly
c     /gws/nopw/j04/c3s311a_lot2/data/level2/land/r202005/observations_tables/monthly
c     /gws/nopw/j04/c3s311a_lot2/data/level2/land/r202005/header_tables/monthly

c************************************************************************
c     Directory tree (06Jan2020)

c     readin_source_id          need: P20190816_noaa/GSOM/Data_ancillary/GHCNdSource_C3Ssource_IDS_20191101.psv
c     get_stnconfig_master      need: P20190816_noaa/GSOM/Data_stnconfig/station_configuration_first_ghcnd_v4.psv.csv
c      -get_elements_stnconfig_line
c     get_scinput_info
c     readin_subset             need: P20181030_ghcnd/Data_input/doc8_Super_GHCNd_subset.csv
c     process_gsom_files
c      -get_codes_gsom_processing2
c      -station_loop_process
c        -get_singles_stnconfig_v4
c        -export_test1          output: level0/land/monthly_data_processing/P20190819_gsomconvert/Data_output/Diagnostics/test1.dat
c        -get_gsom_datalines4   need: level0/land/monthly_data_processing/P20190819_gsomconvert/Data_source/*.*
c        -latlon_4decimal
c        -find_original_precision2
c          -find_precision_vector3
c            -find_number_elements
c        -get_qc_from_attrib
c          -qc_checker
c        -get_source_char_from_attrib3
c          -get_single_source_char
c          -get_single_source_char2
c          -get_matrix_horiz_search
c          -find_altern_letter
c        -export_test2          need: level0/land/monthly_data_processing/P20190819_gsomconvert/Data_output/Diagnostics/test2.dat
c        -source_number_from_character
c          -source_number_from_character_single
c        -record_number_from_source_number3
c          -find_record_number_single3
c          -get_mat_altern_sourcenum
c          -fix_record_number
c          -fix_datzilla
c        -export_test4          need: level0/land/monthly_data_processing/P20190819_gsomconvert/Data_output/Diagnostics/test4.dat
c        -modify_qc_code
c        -convert_variable2
c        -declare_converted_var_precision
c        -count_occurrence_variables
c        -make_header_observation_lite2   need: level0/land/monthly_data_processing/P20190819_gsomconvert/Data_output/Header/*.*
c                                         need: level0/land/monthly_data_processing/P20190819_gsomconvert/Data_output/Observation/*.*
c                                         need: level0/land/monthly_data_processing/P20190819_gsomconvert/Data_output/Lite/*.*
c          -assemble_vector_gsom
c          -count_elements_vector
c          -find_distinct_recnum_gsom
c        -make_new_stnconfig2
c          -get_strvector_distinct
c          -export_stnconfig_lines        need: level0/land/monthly_data_processing/P20190819_gsomconvert/Data_output/Receipt/*.*

c************************************************************************
c2-------10--------20--------30--------40--------50--------60--------70--------80
      IMPLICIT NONE
c************************************************************************
c     Declare variables 

      INTEGER             :: i,j,k,ii,jj,kk

      REAL                :: f_time_st,f_time_en

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
      CHARACTER(LEN=300)  :: s_directory_stnconfig
      CHARACTER(LEN=300)  :: s_directory_ancilldata
      CHARACTER(LEN=300)  :: s_directory_ancilldata2
      CHARACTER(LEN=300)  :: s_directory_gsom
      CHARACTER(LEN=300)  :: s_directory_qckey

      CHARACTER(LEN=300)  :: s_directory_output_header
      CHARACTER(LEN=300)  :: s_directory_output_observation
      CHARACTER(LEN=300)  :: s_directory_output_lite
      CHARACTER(LEN=300)  :: s_directory_output_receipt
      CHARACTER(LEN=300)  :: s_directory_output_lastfile
      CHARACTER(LEN=300)  :: s_directory_output_diagnostics
      CHARACTER(LEN=300)  :: s_directory_output_qc
      CHARACTER(LEN=300)  :: s_directory_output_receipt_linecount

c      CHARACTER(LEN=300)  :: s_filename_stnconfig_new
c      CHARACTER(LEN=300)  :: s_filename_stnconfig_write
c      CHARACTER(LEN=300)  :: s_filename_stnconfig_mod
      CHARACTER(LEN=300)  :: s_filename_stnconfig
      CHARACTER(LEN=300)  :: s_filename_ghcnd_subset
      CHARACTER(LEN=300)  :: s_filename_ghcnd_source
      CHARACTER(LEN=300)  :: s_filename_ghcnd_source2
      CHARACTER(LEN=300)  :: s_filename_qckey

      CHARACTER(LEN=300)  :: s_filename_test1
      CHARACTER(LEN=300)  :: s_filename_test2
      CHARACTER(LEN=300)  :: s_filename_test3
      CHARACTER(LEN=300)  :: s_filename_test4
      CHARACTER(LEN=300)  :: s_filename_test5
c*****
      REAL                :: f_ndflag

c     variable for GSOM/GHCND conversion
      INTEGER,PARAMETER   :: l_source_rgh=100
      INTEGER             :: l_source
      CHARACTER(LEN=500)  :: s_source_name(l_source_rgh)
      CHARACTER(LEN=1)    :: s_source_codeletter(l_source_rgh)
      CHARACTER(LEN=3)    :: s_source_codenumber(l_source_rgh)

c     Info for station config files (note ~155000 stns in revised stnconfig)
c      INTEGER,PARAMETER   :: l_scinput_rgh=160000
c      INTEGER             :: l_scinput
c      CHARACTER(LEN=20)   :: s_scinput_primary_id(l_scinput_rgh)
c      CHARACTER(LEN=2)    :: s_scinput_record_number(l_scinput_rgh)
c      CHARACTER(LEN=20)   :: s_scinput_secondary_id(l_scinput_rgh)
c      CHARACTER(LEN=50)   :: s_scinput_station_name(l_scinput_rgh)
c      CHARACTER(LEN=10)   :: s_scinput_longitude(l_scinput_rgh)
c      CHARACTER(LEN=10)   :: s_scinput_latitude(l_scinput_rgh)
c      CHARACTER(LEN=10)   :: s_scinput_elevation_m(l_scinput_rgh)
c      CHARACTER(LEN=1)    :: s_scinput_policy_license(l_scinput_rgh)
c      CHARACTER(LEN=3)    :: s_scinput_source_id(l_scinput_rgh)

      INTEGER,PARAMETER   :: l_scoutput_rgh=200000
      INTEGER             :: l_scoutput
      INTEGER,PARAMETER   :: l_scfield=60
      CHARACTER(LEN=1000) :: s_header
      INTEGER             :: l_scoutput_numfield       
      CHARACTER(LEN=l_scfield)::s_scoutput_vec_header(50)               
      CHARACTER(LEN=l_scfield)::s_scoutput_mat_fields(l_scoutput_rgh,50)

      INTEGER,PARAMETER   :: l_stations_rgh=130000
      CHARACTER(LEN=12)   :: s_stnname(l_stations_rgh)
      INTEGER             :: l_subset
c*****
c     09Dec2020: qc_key information
      CHARACTER(LEN=300)  :: s_qckey_timescale_spec
      INTEGER             :: l_qckey
      CHARACTER(LEN=2)    :: s_qckey_sourceflag(100)
      CHARACTER(LEN=2)    :: s_qckey_c3sflag(100)
      CHARACTER(LEN=300)  :: s_qckey_timescale(100) 
c*****
      CHARACTER(LEN=300)  :: s_command
      INTEGER             :: io
c************************************************************************
      print*,'start gm20210202'

c************************************************************************
c     Find start time    
      CALL CPU_TIME(f_time_st)

c     Find date & time
      CALL DATE_AND_TIME(s_date_st,s_time_st,s_zone_st,i_values_st)
c************************************************************************
c     Declare directories

c     Inputs
c     r202106
      s_directory_stnconfig =
     +  '/gws/nopw/j04/c3s311a_lot2/data/incoming/GSOM_r30062021/'//
     +  'configuration_files/'
      s_directory_ancilldata='Data_ancillary/'
c     +  '/gws/nopw/j04/c3s311a_lot2/data/incoming/GSOM_r30062021/'//
c     +  'configuration_files/'
      s_directory_gsom      =
     +  '/gws/nopw/j04/c3s311a_lot2/data/incoming/'//
     +  'GSOM_r30062021/csv_files/'
      s_directory_qckey     ='Data_qckey/'

cc     r202102
c      s_directory_stnconfig =
c     +  'Data_stnconfig/'
c      s_directory_ancilldata=
c     +  'Data_ancillary/'
c      s_directory_gsom      =
c     +  '/gws/nopw/j04/c3s311a_lot2/data/level0/land/'//
c     +  'monthly_data_processing/20210128_GSOM_full/'
c      s_directory_qckey     ='Data_qckey/'
c     02Feb2021: 
c      s_directory_gsom      =
c     +  '/work/scratch/akettle/P20200518_gsombig/Data_source/'
c*****
c     Outputs - release r202106
      s_directory_output_header=
     +  '/work/scratch-pw/akettle/P20210609_gsom_cdm_r202106/'//
     +  'Step1_cdmmake/Header/'
      s_directory_output_observation=
     +  '/work/scratch-pw/akettle/P20210609_gsom_cdm_r202106/'//
     +  'Step1_cdmmake/Observation/'
      s_directory_output_lite=
     +  '/work/scratch-pw/akettle/P20210609_gsom_cdm_r202106/'//
     +  'Step1_cdmmake/Lite/'
      s_directory_output_receipt=
     +  '/work/scratch-pw/akettle/P20210609_gsom_cdm_r202106/'//
     +  'Step1_cdmmake/Receipt/'
      s_directory_output_lastfile=
     +  '/work/scratch-pw/akettle/P20210609_gsom_cdm_r202106/'//
     +  'Step1_cdmmake/Lastfile/'
      s_directory_output_diagnostics=
     +  '/work/scratch-pw/akettle/P20210609_gsom_cdm_r202106/'//
     +  'Step1_cdmmake/Diagnostics/'
      s_directory_output_qc=
     +  '/work/scratch-pw/akettle/P20210609_gsom_cdm_r202106/'//
     +  'Step1_cdmmake/QC/'
      s_directory_output_receipt_linecount=
     +  '/work/scratch-pw/akettle/P20210609_gsom_cdm_r202106/'//
     +  'Step1_cdmmake/Receipt_linecount/'

cc     Outputs - release r202102
c      s_directory_output_header=
c     +  '/work/scratch-pw/akettle/P20210202_gsom_cdm_r202102/'//
c     +  'Step1_cdmmake/Header/'
c      s_directory_output_observation=
c     +  '/work/scratch-pw/akettle/P20210202_gsom_cdm_r202102/'//
c     +  'Step1_cdmmake/Observation/'
c      s_directory_output_lite=
c     +  '/work/scratch-pw/akettle/P20210202_gsom_cdm_r202102/'//
c     +  'Step1_cdmmake/Lite/'
c      s_directory_output_receipt=
c     +  '/work/scratch-pw/akettle/P20210202_gsom_cdm_r202102/'//
c     +  'Step1_cdmmake/Receipt/'
c      s_directory_output_lastfile=
c     +  '/work/scratch-pw/akettle/P20210202_gsom_cdm_r202102/'//
c     +  'Step1_cdmmake/Lastfile/'
c      s_directory_output_diagnostics=
c     +  '/work/scratch-pw/akettle/P20210202_gsom_cdm_r202102/'//
c     +  'Step1_cdmmake/Diagnostics/'
c      s_directory_output_qc=
c     +  '/work/scratch-pw/akettle/P20210202_gsom_cdm_r202102/'//
c     +  'Step1_cdmmake/QC/'
c      s_directory_output_receipt_linecount=
c     +  '/work/scratch-pw/akettle/P20210202_gsom_cdm_r202102/'//
c     +  'Step1_cdmmake/Receipt_linecount/'

ccc     Outputs - release r202005
cc      s_directory_output_header=
cc     +  '/work/scratch/akettle/P20200518_gsombig/Data_output/'//
cc     +  'Header/'
cc      s_directory_output_observation=
cc     +  '/work/scratch/akettle/P20200518_gsombig/Data_output/'//
cc     +  'Observation/'
cc      s_directory_output_lite=
cc     +  '/work/scratch/akettle/P20200518_gsombig/Data_output/'//
cc     +  'Lite/'
cc      s_directory_output_receipt=
cc     +  '/work/scratch/akettle/P20200518_gsombig/Data_output/'//
cc     +  'Receipt/'
cc      s_directory_output_lastfile=
cc     +  '/work/scratch/akettle/P20200518_gsombig/Data_output/'//
cc     +  'Lastfile/'
cc      s_directory_output_diagnostics=
cc     +  '/work/scratch/akettle/P20200518_gsombig/Data_output/'//
cc     +  'Diagnostics/'

c*****
c     Declare filenames

c     r202106
      s_filename_stnconfig=
     +  'daily_monthly_station_config_28_05_2021_1800.csv'
      s_filename_ghcnd_subset   =
     +  'daily_monthly_stationid_list_30_05_2021.csv'
cc     r202102
c      s_filename_stnconfig=
c     +  'preliminary_daily_monthly_station_config_11_01_2021.psv.csv'
cc     02Feb2021: stnconfig file removed 
cc      s_filename_stnconfig=
cc     +  'f20200409_preliminary_station_configuration_GHCND.psv.csv'
c      s_filename_ghcnd_subset   =
c     +  'daily_monthly_stationid_list_31_01_2021.csv'
c     02Feb2021: removed and replaced with new subset list
c      s_filename_ghcnd_subset   ='f20200406_station_list_GHCND.csv'

c     new source conversion list issued 01Nov2019
c     conversion between GHCNd letters and CDM 3-digit source id
      s_filename_ghcnd_source2 ='GHCNdSource_C3Ssource_IDS_20191101.psv'
cc     old source conversion list without 'm'
c      s_filename_ghcnd_source  ='doc4_GHCNdSource_C3Ssource_IDS.csv'
      s_filename_qckey='qckey.dat'

      s_filename_test1='test1.dat'
      s_filename_test2='test2.dat'
      s_filename_test3='test3.dat'
      s_filename_test4='test4.dat'
      s_filename_test5='test5.dat'
c************************************************************************
c     Define parameters
      s_qckey_timescale_spec='daily/monthly'   !subdaily or daily/monthly
c************************************************************************
c     Remove header, observation, lite, receipt files

      STOP 'gm20210609.f; just before erasing procedure'

      GOTO 14

      s_command='for f in '//
     +   TRIM(s_directory_output_header)//'*.*; do rm "$f"; done'
      print*,'s_command=',TRIM(s_command)
      CALL SYSTEM(s_command,io)

      s_command='for f in '//
     +   TRIM(s_directory_output_observation)//'*.*; do rm "$f"; done'
      print*,'s_command=',TRIM(s_command)
      CALL SYSTEM(s_command,io)

      s_command='for f in '//
     +   TRIM(s_directory_output_lite)//'*.*; do rm "$f"; done'
      print*,'s_command=',TRIM(s_command)
      CALL SYSTEM(s_command,io)

      s_command='for f in '//
     +   TRIM(s_directory_output_qc)//'*.*; do rm "$f"; done'
      print*,'s_command=',TRIM(s_command)
      CALL SYSTEM(s_command,io)

      s_command='for f in '//
     +   TRIM(s_directory_output_receipt)//'*.*; do rm "$f"; done'
      print*,'s_command=',TRIM(s_command)
      CALL SYSTEM(s_command,io)

c      s_command='for f in '//
c     +  TRIM(s_directory_output_receipt_linecount)//'*.*; 
c     +  do rm "$f"; done'
c      print*,'s_command=',TRIM(s_command)
c      CALL SYSTEM(s_command,io)

      s_command='rm '//TRIM(s_directory_output_receipt_linecount)//'*'
      print*,'s_command=',TRIM(s_command)
      CALL SYSTEM(s_command,io)

      s_command='for f in '//
     +   TRIM(s_directory_output_diagnostics)//'*.*; do rm "$f"; done'
      print*,'s_command=',TRIM(s_command)
      CALL SYSTEM(s_command,io)

c      s_command=
c     +  'rm '//TRIM(s_directory_output_header)//'*.*'
c      print*,'s_command=',TRIM(s_command) 
c      CALL SYSTEM(s_command,io)

c      s_command=
c     +  'rm '//TRIM(s_directory_output_observation)//'*.*'
c      print*,'s_command=',TRIM(s_command) 
c      CALL SYSTEM(s_command,io)

c      s_command=
c     +  'rm '//TRIM(s_directory_output_lite)//'*.*'
c      print*,'s_command=',TRIM(s_command) 
c      CALL SYSTEM(s_command,io)

c      s_command=
c     +  'rm '//TRIM(s_directory_output_receipt)//'*.*'
c      print*,'s_command=',TRIM(s_command) 
c      CALL SYSTEM(s_command,io)

c      s_command=
c     +  'rm '//TRIM(s_directory_output_diagnostics)//'*.*'
c      print*,'s_command=',TRIM(s_command) 
c      CALL SYSTEM(s_command,io)

 14   CONTINUE

      STOP 'gm20210609.f; just finished erasing procedure'
c************************************************************************
      f_ndflag=-999.0
c************************************************************************
c     Read in source codes for daily data
c     new version of source conversion: psv & without 'm'
      CALL readin_source_id2(
     +  s_directory_ancilldata,s_filename_ghcnd_source2,
     +  l_source_rgh,l_source,
     +  s_source_name,s_source_codeletter,s_source_codenumber)

      print*,'new, l_source=',l_source
      print*,'s_source_codeletter=',
     +  (s_source_codeletter(i),i=1,l_source)
      print*,'s_source_codenumber=',
     +  (s_source_codenumber(i),i=1,l_source)

c      STOP 'gm20210609'
c************************************************************************
c     20May2020: new stnconfig file with variable field width
      CALL get_stnconfig_ghcnd2(s_directory_stnconfig,
     +  s_filename_stnconfig,
     +  l_scoutput_rgh,l_scoutput,l_scfield,
     +  s_header,
     +  l_scoutput_numfield,s_scoutput_vec_header,
     +  s_scoutput_mat_fields)

      print*,'l_scoutput=',l_scoutput
      print*,'l_scoutput_numfield=',l_scoutput_numfield
      print*,'s_scoutput_vec_header=',
     +  (TRIM(s_scoutput_vec_header(i)),i=1,l_scoutput_numfield)

c      STOP 'gm20210609'
c************************************************************************
c     Read in ghcnd subset file
      CALL readin_subset(
     +  s_directory_stnconfig,s_filename_ghcnd_subset,
     +  l_stations_rgh,l_subset,s_stnname)

      print*,'l_subset=',l_subset
c      print*,'s_stnname=',s_stnname(19994)

c      STOP 'gm20210609'
c************************************************************************
c     Read in qff conversion key
      CALL get_qckey(s_directory_qckey,s_filename_qckey,
     +  l_qckey,
     +  s_qckey_sourceflag,s_qckey_c3sflag,s_qckey_timescale)

      print*,'l_qckey=',l_qckey

c      STOP 'gd20210609'
c************************************************************************
c     Get data from files
      CALL process_gsom_files20210204(
     +  s_date_st,s_time_st,s_zone_st,i_values_st,
     +  s_directory_gsom,
     +  s_directory_output_header,s_directory_output_observation,
     +  s_directory_output_lite,
     +  s_directory_output_receipt,s_directory_output_lastfile,
     +  s_directory_output_diagnostics,
     +  s_directory_output_qc,s_directory_output_receipt_linecount,
     +  s_filename_test1,s_filename_test2,s_filename_test3,
     +  s_filename_test4,s_filename_test5,
     +  l_stations_rgh,l_subset,s_stnname,
     +  f_ndflag,
     +  l_scoutput_rgh,l_scoutput,l_scfield,
     +  l_scoutput_numfield,s_scoutput_vec_header,
     +  s_scoutput_mat_fields,
     +  l_source_rgh,l_source,
     +  s_source_name,s_source_codeletter,s_source_codenumber,
     +  s_qckey_timescale_spec,l_qckey,
     +  s_qckey_sourceflag,s_qckey_c3sflag,s_qckey_timescale)

c************************************************************************
c     Find end time
      CALL CPU_TIME(f_time_en)

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
      f_deltime_cpu_s=f_time_en-f_time_st
      print*,'f_deltime_cpu_s,f_deltime_cpu_min=',
     +  f_deltime_cpu_s,f_deltime_cpu_s/60.0     
      print*,'f_deltime_clock_s,f_deltime_clock_min=',
     +  f_deltime_clock_s,f_deltime_clock_s/60.0    
c************************************************************************

      END
