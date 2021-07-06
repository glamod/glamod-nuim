c     Program to process GHCND files into CDM format
c     AJ_Kettle, 24Oct2019
c     09Dec2020: modified for new run with QC tables
c     22Dec2020: test to find first qc irregularity i=8, AFM00040938
c     30Jan2021: used for release 2021q1 - 117836 separated stns
c     10May2021: modified for end of June2021 release
c     11May2021: problem with distinct timestep counter for GQW00041415
c     13May2021: source files had to be sorted in time
c     13May2021: discovered corrupted file: USC00335585.csv.gz

c*****
c     31Jan2021: test with 100 stations; c/c=3.42/6.47
c     01Feb2021: new stn subset list implemented with 83960 stns listed
c     01Feb2021: test with 10 stns on newsci6; c/c=0.30/1.37min

c     02Feb2021: test with 10 stns on newsci6; c/c=0.31/0.68min; QC fixed
c     02Feb2021: test with stns 1-100 on newsci6; c/c=2.68/7.63min; QC fixed
c     02Feb2021: test with stns 1-200 on newsci6; c/c=7.22/16.75min
c     02Feb2021: test with stns 1-100 on newsci8; c/c=3.82/7.30min
c     02Feb2021: test with stns 101-100 on newsci8; c/c=6.65/10.47min
c     02Feb2021: run with stns 00001-02000 on newsci8; c/c=103.2/215.0min
c     02Feb2021: run with stns 02001-10000 on newsci8; c/c=265.6/572.0min; fin 03Feb21 02:43
c     02Feb2021: run with stns 10001-14000 on newsci8; c/c=251.8/457.6min; fin 03Feb21 19:18
c     03Feb2021: run with stns 14001-25000 on newsci8; c/c=545.8/1027.8min; fin 04Feb21 12:30
c     04Feb2021: run with stns 25001-38000 on newsci8; c/c=60.5/219.9min;   fin 04Feb21 17:31
c     04Feb2021: run with stns 38001-50000 on newsci8; c/c=54.5/216.9min;   fin 04Feb21 21:24
c     04Feb2021: run with stns 50001-54000 on newsci8; c/c=17.3/76.0min;    fin 05Feb21 12:13
c     04Feb2021: run with stns 60001-63704 on newsci8; terminated by Jasmin reset
c     05Feb2021: run with stns 63705-

c     09Mar2021: new set of 118489 daily station files from NCEI, wishlist=83960stns; stnconfig=130592
c     09Mar2021: test 1-100stns: c/c=2.8/5.8min; 1 failed stn
c     09Mar2021: test 1-1000stns: c/c=39.3/72.8min; 1 failed stn
c     09Mar2021: run  1001-2000stns: c/c=36.3/63.0min; 1 failed stn
c     09Mar2021: run  2001-3000stns: c/c=24.8/48.4min
c     10Mar2021: run  3001-5000stns: c/c=44.9/84.25min
c     10Mar2021: run  5001-6000stns: c/c=22.5/40.43min
c     10Mar2021: unexp termin i=6307
c     10Mar2021: run  8001-10000stns: newsci6; c/c=56.2/93.7min
c     10Mar2021: run  10001-14000stns: newsci6; c/c=179.1/268.2min
c     10Mar2021: run  14001-15000stns: newsci6; c/c=43.3/67.3min
c     10Mar2021: run  15001-16000stns: newsci6; c/c=26.0/48.5min
c     11Mar2021: run  21500-24000stns: newsci6; c/c=139.8/231.4min
c     11Mar2021: run  24001-25000stns: newsci6; c/c=17,1/34.1min
c     11Mar2021: run  25001-26000stns: newsci6; c/c=3.7/16.3min
c     11Mar2021: run  26001-27000stns: newsci6; c/c=3.1/15.7min
c     11Mar2021: run  27001-32000stns: newsci6; c/c=17.9/64.5min
c     11Mar2021: run  32001-36000stns: newsci6; c/c=13.5/47.4min
c     11Mar2021: run  36001-40000stns: newsci6; c/c=13.0/48.9min
c     11Mar2021: run  40001-44000stns: newsci6; c/c=13.4/54.3min
c     11Mar2021: run  44001-52000stns: newsci6; c/c=27.2/117.4min
c     11Mar2021: run  52001-54000stns: newsci6; c/c=6.4/27.3min
c     11Mar2021: run  54001-56000stns: newsci6; c/c=7.0/33.3min
c     12Mar2021: run  66101-67000stns: newsci6; c/c=34.6/48.3min
c     12Mar2021: run  67001-68000stns: newsci8; c/c=55.7/73.6min
c     12Mar2021: run  68001-69000stns: newsci3; c/c=35.4/49.8min
c     12Mar2021: run  69001-74000stns: newsci3; c/c=210.9/295.5min
c     12Mar2021: run  74001-75000stns: newsci3; c/c=38.3/54.1min
c     12Mar2021: run  75001-76000stns: newsci3; c/c=41.0/56.8min
c     12Mar2021: run  76001-84000stns: newsci6; c/c=222.0/349.9min
c*****
c     13May2021: run  1stn test; newsci6; c/c=0.147/0.183min
c     13May2021: run  10 stn test; newsci6; c/c=0.35/0.47min
c     14May2021: run  100 stn test: newsci3; c/c=2.93/3.87min; 1 bad station
c     14May2021: run  1000 stn main run: newsci3; c/c=41.51/57.58min; 1 bad stn total
c     14May2021: run  1001-2000 stn main run: newsci3; c/c=38.9/51.4min; 1 bad stn total
c     14May2021: run  2001-3000 stn main run: newsci3; c/c=26.3/37.1min; 1 bad stn total
c     15May2021: run  3001-5000 stn main run: newsci3; c/c=47.36/91.37min
c     15May2021: run  5001-8000 stn main run: newsci3; c/c=73.74/113.98min
c     15May2021: jasmin reset at i=9685
c     15May2021: run  8001-16000 stn main run: newsci3; c/c=268.5/357.2min
c     16May2021: run  16001-24000 stn main run: newsci3; c/c=330.0/449.6min
c     16May2021: jasmin reset at i=24760
c     16May2021: run  24001-32000 stn main run: newsci3; c/c=23.1/50.5min
c     16May2021: run  32001-40000 stn main run: newsci3; c/c=27.8/61.1min
c     16May2021: run  40001-48000 stn main run: newsci3; c/c=28.4/62.2min
c     17May2021: run  48001-56000 stn main run: newsci3; c/c=26.9/52.7min
c     17May2021: run  56001-62000 stn main run: newsci3; c/c=293.5/405.9min
c     18May2021: run  62001-72000 stn main run: newsci3: c/c=448.6/612.6min
c     19May2021: run  80001-83960 stn main run: newsci3: c/c=47.6/81.3min; 21 files failed

c     28May2021: N_obs=83457, N_header=83457, N_lite=83457
c     28May2021: verified identical file size CDM lite, header
c     28May2021: 2 problem files in copying over cdm-obs:
c                [akettle@sci3.jasmin.ac.uk ~]$ diff ~/dir1.txt ~/dir2.txt
c                5546c5546
c                < ./observation_table_r202010_CA003072783.psv.gz 135806
c                ---
c                > ./observation_table_r202010_CA003072783.psv.gz 0
c                81383c81383
c                < ./observation_table_r202010_USS0021C38S.psv.gz 811758
c                ---
c                > ./observation_table_r202010_USS0021C38S.psv.gz 0
c     28May2021: verified identical file size CDM obs

c2-------10--------20--------30--------40--------50--------60--------70--------80
      IMPLICIT NONE
c************************************************************************
c     Declare variables 

      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: io

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

c     Input directories
      CHARACTER(LEN=300)  :: s_directory_ghcnd_input
      CHARACTER(LEN=300)  :: s_directory_ancilldata
      CHARACTER(LEN=300)  :: s_directory_stnconfig
      CHARACTER(LEN=300)  :: s_directory_stnselect
      CHARACTER(LEN=300)  :: s_directory_qckey

c     Output directories
      CHARACTER(LEN=300)  :: s_directory_output_lastfile
      CHARACTER(LEN=300)  :: s_directory_output_runtime
      CHARACTER(LEN=300)  :: s_directory_output_header
      CHARACTER(LEN=300)  :: s_directory_output_observation
      CHARACTER(LEN=300)  :: s_directory_output_lite
      CHARACTER(LEN=300)  :: s_directory_output_receipt
      CHARACTER(LEN=300)  :: s_directory_output_errorfile
      CHARACTER(LEN=300)  :: s_directory_output_qc
      CHARACTER(LEN=300)  :: s_directory_output_receipt_linecount

      CHARACTER(LEN=300)  :: s_filename_ghcnd_subset
c      CHARACTER(LEN=300)  :: s_filename_stnconfig_old
      CHARACTER(LEN=300)  :: s_filename_stnconfig_new
c      CHARACTER(LEN=300)  :: s_filename_ghcnd_source
      CHARACTER(LEN=300)  :: s_filename_ghcnd_source2
      CHARACTER(LEN=300)  :: s_filename_qckey
c*****
      REAL                :: f_ndflag
c*****
      INTEGER             :: i_start
c*****
      INTEGER,PARAMETER   :: l_source_rgh=100
      INTEGER             :: l_source
      CHARACTER(LEN=500)  :: s_source_name(l_source_rgh)
      CHARACTER(LEN=1)    :: s_source_codeletter(l_source_rgh)
      CHARACTER(LEN=3)    :: s_source_codenumber(l_source_rgh)
c*****

      INTEGER,PARAMETER   :: l_scoutput_rgh=200000
      INTEGER             :: l_scoutput
      INTEGER,PARAMETER   :: l_scfield=60
      CHARACTER(LEN=1000) :: s_header
      INTEGER             :: l_scoutput_numfield
      CHARACTER(LEN=l_scfield)::s_scoutput_vec_header(50)
      CHARACTER(LEN=l_scfield)::s_scoutput_mat_fields(l_scoutput_rgh,50)

c     Check on stnconfig files
      CHARACTER(LEN=l_scfield)::s_scoutput_vec_header2(50)
c*****
c     Station subset information
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
c************************************************************************
      print*,'start program gd20210130'
c************************************************************************
c     Find start time    
      CALL CPU_TIME(f_time_st)

c     Find date & time
      CALL DATE_AND_TIME(s_date_st,s_time_st,s_zone_st,i_values_st)
c************************************************************************
c************************************************************************
c     Declare directories

c     Input directories - station files from separated big file
c     Source directory for Jun2021 release
c     Note: the files had been copied and uncompressed from:
c     /gws/nopw/j04/c3s311a_lot2/data/incoming/GHCND_r30062021/ghcnd_stations
      s_directory_ghcnd_input=
     +  '/work/scratch-pw/akettle/P20210510_ghcnd21q2/Source_dir/'
c     09Mar2021: new input directory with NCEI station files
c      s_directory_ghcnd_input=
c     +  '/gws/nopw/j04/c3s311a_lot2/data/incoming/GHCND_3rd_release/'//
c     +  'stn-files/'
c      s_directory_ghcnd_input=
c     +  '/work/scratch-pw/akettle/P20210112_ghcnd21q1/Step3_link/'
c      s_directory_ghcnd_input=
c     +  '/work/scratch-pw/akettle/P20201207_ghcnd20q4'//
c     +  '/Data_inputs_stns20201212/'

c     Note different set of source directories for release 202106
      s_directory_ancilldata='Data_ancillary/'
      s_directory_stnconfig =
     + '/gws/nopw/j04/c3s311a_lot2/data/incoming/GHCND_r30062021/'//
     + 'configuration_files/'
c       'Data_stnconfig/'
      s_directory_stnselect =
     +  '/gws/nopw/j04/c3s311a_lot2/data/incoming/GHCND_r30062021/'//
     +  'configuration_files/'
      s_directory_qckey     ='Data_qckey/'

c     Output directories
      s_directory_output_lastfile=
     + '/work/scratch-pw/akettle/P20210510_ghcnd21q2/'//
     + 'Step1_cdmmake/Lastnumber/'
      s_directory_output_runtime=
     + '/work/scratch-pw/akettle/P20210510_ghcnd21q2/'//
     + 'Step1_cdmmake/Runtime_save/'
      s_directory_output_header=
     + '/work/scratch-pw/akettle/P20210510_ghcnd21q2/'//
     + 'Step1_cdmmake/CDM_header/'
      s_directory_output_observation=
     + '/work/scratch-pw/akettle/P20210510_ghcnd21q2/'//
     + 'Step1_cdmmake/CDM_observation/'
      s_directory_output_lite=
     + '/work/scratch-pw/akettle/P20210510_ghcnd21q2/'//
     + 'Step1_cdmmake/CDM_lite/'
      s_directory_output_receipt=
     + '/work/scratch-pw/akettle/P20210510_ghcnd21q2/'//
     + 'Step1_cdmmake/Receipt/'
      s_directory_output_errorfile=
     + '/work/scratch-pw/akettle/P20210510_ghcnd21q2/'//
     + 'Step1_cdmmake/Errorfile/'
      s_directory_output_qc=
     + '/work/scratch-pw/akettle/P20210510_ghcnd21q2/'//
     + 'Step1_cdmmake/QC/'
      s_directory_output_receipt_linecount=
     + '/work/scratch-pw/akettle/P20210510_ghcnd21q2/'//
     + 'Step1_cdmmake/Receipt_linecount/'

c****
c     List input filenames
      s_filename_ghcnd_subset =
     +  'daily_monthly_stationid_list_30_05_2021.csv'
c     this was subset file used for r202102
c      s_filename_ghcnd_subset =
c     +  'daily_monthly_stationid_list_31_01_2021.csv'
c     01Feb2021: replaced with new subset file
c      s_filename_ghcnd_subset ='f20200406_station_list_GHCND.csv'

c     new stnconfig file used for r202106
      s_filename_stnconfig_new=
     +  'daily_monthly_station_config_30_05_2021.csv'
c     this was stnconfig file used for r202102; new stnconfig file 09Mar2021
c      s_filename_stnconfig_new=
c     +  'daily_monthly_station_config_18_02_2021.csv'
c      s_filename_stnconfig_new=
c     +  'preliminary_daily_monthly_station_config_11_01_2021.psv.csv'
c     +  'f20200409_preliminary_station_configuration_GHCND.psv.csv'

      s_filename_ghcnd_source2 ='GHCNdSource_C3Ssource_IDS_20191101.psv'
      s_filename_qckey='qckey.dat'
c************************************************************************
c     Define parameters
      f_ndflag=-999.0

      s_qckey_timescale_spec='daily/monthly'   !subdaily or daily/monthly
c************************************************************************
c     Read in last file number
      CALL readin_lastfile_number(s_directory_output_lastfile,
     +  i_start)

      print*,'i_start=',i_start

c      STOP 'gd20210510'
c************************************************************************
c     Erase files if i_start=1
c      i_start=1                      !define i_start=1 to erase all files
      print*,'i_start=',i_start
      IF (i_start.EQ.1) THEN 
       print*,'erase condition met'

       CALL erase_files_seq20201210(i_start,
     +  s_directory_output_header,s_directory_output_observation,
     +  s_directory_output_lite,
     +  s_directory_output_lastfile,s_directory_output_receipt,
     +  s_directory_output_errorfile,
     +  s_directory_output_qc,s_directory_output_receipt_linecount)
      ENDIF

c      STOP 'gd20210510; just after big erase'
c************************************************************************
c     Read in source codes for daily data: key to convert NCEI letter to CDM nr
c     new version of source conversion: psv & without 'm'
      CALL readin_source_id2(
     +  s_directory_ancilldata,s_filename_ghcnd_source2,
     +  l_source_rgh,l_source,
     +  s_source_name,s_source_codeletter,s_source_codenumber)
c************************************************************************
c     Get stnconfig file
      CALL get_stnconfig_ghcnd2( s_directory_stnconfig,
     +  s_filename_stnconfig_new,
     +  l_scoutput_rgh,l_scoutput,l_scfield,
     +  s_header,
     +  l_scoutput_numfield,s_scoutput_vec_header,
     +  s_scoutput_mat_fields)

      print*,'l_scoutput=',l_scoutput
c************************************************************************
c     Import station files
      CALL readin_subset(
     +  s_directory_stnselect,s_filename_ghcnd_subset,
     +  l_stations_rgh,l_subset,s_stnname)

      print*,'s_stnname st,en='//
     +  TRIM(s_stnname(1))//'='//TRIM(s_stnname(l_subset))//'='
      print*,'l_subset=',l_subset
c************************************************************************
c     Read in qff conversion key
      CALL get_qckey(s_directory_qckey,s_filename_qckey,
     +  l_qckey,
     +  s_qckey_sourceflag,s_qckey_c3sflag,s_qckey_timescale)

      print*,'l_qckey=',l_qckey

c      STOP 'gd20210510'
c************************************************************************
c     Process all daily files
      CALL main_cycler20201210(f_ndflag,
     +  s_date_st,s_time_st,s_zone_st,i_values_st,
     +  s_directory_ghcnd_input,
     +  s_directory_output_lastfile,s_directory_output_receipt,
     +  s_directory_output_errorfile,
     +  s_directory_output_header,s_directory_output_observation,
     +  s_directory_output_lite,
     +  s_directory_output_qc,s_directory_output_receipt_linecount,
     +  l_source_rgh,l_source,
     +  s_source_name,s_source_codeletter,s_source_codenumber,
     +  l_stations_rgh,l_subset,s_stnname,
     +  l_scoutput_rgh,l_scoutput,l_scfield,
     +  l_scoutput_numfield,s_scoutput_vec_header,
     +  s_scoutput_mat_fields,
     +  s_qckey_timescale_spec,l_qckey,
     +  s_qckey_sourceflag,s_qckey_c3sflag,s_qckey_timescale)
c************************************************************************
c************************************************************************



c************************************************************************
c************************************************************************
c     Find end time
      CALL CPU_TIME(f_time_en)

c     Find date & time
      CALL DATE_AND_TIME(s_date_en,s_time_en,s_zone_en,i_values_en)
c************************************************************************
      print*,'s_date_en=',TRIM(s_date_en)
      print*,'s_time_en=',TRIM(s_time_en)
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
c************************************************************************
      print*,'start program gd20210130'

      END
