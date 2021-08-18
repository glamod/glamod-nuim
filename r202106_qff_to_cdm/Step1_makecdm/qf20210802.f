c     Master program to sort out qff files
c     AJ_Kettle, 15Mar2019
c     05Jun2020: used for second release
c     19Oct2020: runtime c/c=4.33/5.42; 10 element Oct test on sci3; err=0/0/0/0
c     19Oct2020: runtime c/c=4.28/5.70; 10 element Oct test on sci6; err=0/0/0/0
c     19Oct2020: runtime c/c=15.8/22.9; 100 element Oct test on sci3; err=0/0/0/0
c     21Oct2020: runtime c/c=4.42/6.10; 10 element Oct test on sci3; err=0/0/0/0
c     24Oct2020: runtime c/c=15.8/19.1; 100 element Oct test on sci3; err=0/0/0/0
c     25Oct2020: runtime c/c=205.5/287.8; 1500 element Oct test on sci3; err=0/0/0/0
c     25Oct2020: runtime c/c=223.3/275.5; 1501-3000 on sci3; err=0/0/0/0
c     25Oct2020: runtime c/c=284.6/370.5; 3001-5000 on sci3; err=1/0/0/0
c     25Oct2020: runtime c/c=238.1/308.8; 5001-6000 on sci3; err=1/0/0/0
c     26Oct2020: emergency stop i=7457, ICM00011177, record_number_from source_number_qff20200617
c     26Oct2020: runtime c/c=28.2/66.0min; 7457-8000 on sci3; err=0/0/1/0
c     26Oct2020: xwindows logged off at i=8746 sci3
c     27Oct2020: xwindows logged off at i=8849 sci3
c     27Oct2020: runtime c/c 35.9/56.7min; i=8849-9000 sci3
c     27Oct2020: (sci3) failure at 10513 becauses over 1 000 000 lines in file
c     28Oct2020: (sci3) failure at 10517 becauses over 1 000 000 lines in file
c     28Oct2020: (sci3) restarted trial with 1 200 000 lines
c     28Oct2020: (sci3) runtime c/c=176.2/239.0min; 10517-11000
c     28Oct2020: (sci3) runtime c/c=174.8/212.0min; finished to x-12000
c     28Oct2020: (sci3) runtime c/c=146.7/189.1min; finished to x-13000
c     29Oct2020: (sci3) runtime c/c=157.7/201.0min; finished to x-14000
c     29Oct2020: (sci3) runtime c/c=140.3/179.0min; finished to x-15000; err=0/0/1/0
c     29Oct2020: (sci3) runtime c/c=276.9/340.9min; finished to x-16000; err=0/0/1/0
c     30Oct2020: (sci3) program stopped at i=17436 terminal reset midnight; err=0/0/1/0
c     31Oct2020: (sci3) runtime c/c=521.0/633.4min; i=17437-18000;  err=0/0/0/0
c     31Oct2020: (sci3) program stopped at i=18325 terminal reset midnight; err=0/0/0/0
c     01Nov2020: (sci3) runtime c/c=649.8/785.9min: i=18325-19000; err=0/0/0/0
c     02Nov2020: (sci3) runtime c/c=249.8/313.9min: i=19000-20000; err=0/0/3/0
c     02Nov2020: (sci3) program stopped at i=20336 segmentation fault(single_stn_name); err=0/0/1/0 (end of list only 20335 files)
c     24Nov2020: (newsci6) runtime c/c=150.2/201.9min: i=1-1000; err=0/0/0/0
c     24Nov2020: (newsci6) program stopped by admin logoff  i=1394
c     24Nov2020: (newsci6) runtime c/c=96.7/122.8min: i=1395-2000; err=0/0/0/0
c     24Nov2020: (newsci6) runtime c/c=96.7/122.8min: i=1395-2000; err=0/0/0/0
c     30Nov2020: (newsci6) runtime c/c=428.6/566.6min: i=14000-16000; err=0/0/2/0
c     01Dec2020: (newsci6) runtime c/c=352.4/?????min: i=16001-17000; err=0/0/1/0
c     03Dec2020: (newsci6) runtime c/c=277.1/345.0min: i=19001-20335; err=0/0/4/0

c     17Feb2021: newsci6: new set of qff files from Robert Dunne 20606 files available
c     17Feb2021: newsci6: SN wish list with 22634 files
c     18Feb2021: newsci6: 10stn test, c/c=4.8/7.2min
c     19Feb2021: newsci6: 10stn test, c/c=5.2/6.1min
c     19Feb2021: newsci6: 200stn run, c/c=32.9/42.0min
c     19Feb2021: newsci6: problem at i=727 with segfault finder; ASI0000YBNA is empty
c     19Feb2021: newsci6: last 263 stns completed c/c=63.2/76.6min
c     19Feb2021: newsci6: stns 1001-2000, c/c=143.1/172.6min
c     20Feb2021: newsci6: stns 2001-3000, c/c=123.1/151.1min
c     20Feb2021: newsci6: stns 3001-4000, c/c=186.7/226.5min
c     20Feb2021: newsci6: stns 4001-5000, c/c=132.7/161.8min
c     20Feb2021: newsci6: problem with i=5462
c     20Feb2021: newsci6: run stopped at i=6575 with midnight reset
c     21Feb2021: newsci6: finished to 7000, c/c=185.8/216.9min 
c     21Feb2021: newsci6: 7001-8000, c/c=197.9/237.0min 
c     21Feb2021: newsci6: 8001-9000, c/c=92.9/114.7min 
c     21Feb2021: newsci6: 9001-10000, c/c=382.1/445.3min 
c     22Feb2021: newsci6: 10001-11000, c/c=235.7/284.4min 
c     22Feb2021: newsci6: 12001-13000, c/c=203.7/249.8min 
c     23Feb2021: newsci6: 13001-14000, c/c=175.1/215.2min 
c     23Feb2021: newsci6: 14001-15000, c/c=131.2/184.8min 
c     23Feb2021: newsci6: 15001-16000, c/c=129.2/160.4min 
c     24Feb2021: newsci6: 17001-18000, c/c=250.0/302.1min 
c     24Feb2021: newsci6: 18001-19000, c/c=392.5/471.3min 
c     25Feb2021: newsci6: ~19450-20000, c/c=530.6/675.5min 
c     26Feb2021: newsci6: 20400-21000, c/c=5398.1/662.7min 
c     26Feb2021: newsci6: 21000-22000, c/c=133.3/163.7min 
c     26Feb2021: newsci6: 22000-22633, c/c=42.1/54.2min 

c     13Jul2021: newsci6: 00001-00010, c/c=5.86/7.42min; test run
c     14Jul2021: newsci6: 00001-00010, c/c=5.83/7.03min; test run
c     14Jul2021: newsci6: 00001-00200, c/c=39.51/50.10min; test run; 199 files

c     16Jul2021: newsci6: 00586 problem station; precision determination
c     17Jul2021: newsci6: 00001-00585, c/c=69.18/88.15min; completed no problems
c     17Jul2021: newsci6: 00600 problem station; precision determination
c     17Jul2021: newsci6: 00606 problem station; precision determination
c     17Jul2021: subroutine fixed; 00586 station successfully run
c     17Jul2021: subroutine fixed; 00600 station successfully run
c     17Jul2021: subroutine fixed; 00606 station successfully run
c     17Jul2021: newsci6: 00606-02000, c/c=56.76/79.85min;
c     18Jul2021: newsci6: 02001-03000, c/c=107.5/228.9min
c     19Jul2021: newsci6: 03001-04000, c/c=117.1/144.5min
c     19Jul2021: newsci6: 04001-05000, c/c=107.3/127.6min
c     19Jul2021: newsci6: 05001-06000, c/c=136.8/165.9min
c     19Jul2021: newsci6: 06001-07000, c/c=153.0/183.4min
c     19Jul2021: newsci6: premature run termination at 7076; jasmin logout
c     20Jul2021: newsci6: 07001-08000, c/c=228.1/270.4min
c     21Jul2021: newsci6: 08001-09000, c/c=339.4/391.5min
c     21Jul2021: newsci6: 09001-09243, jasmin auto logout at i=9243, 1.67h
c     21Jul2021: newsci6: 09243-09500, c/c=24.7/31.1min 
c     24Jul2021: newsci6: 09501-10000, c/c=35.4/44.5min 
c     25Jul2021: newsci6: 10001-14000, emergency stop i=12713; lines>1200000
c     25Jul2021: newsci6: autologout Jasmin i=12863
c     25Jul2021: newsci6: 12864-14000, c/c=288.6/337.4min 
c     26Jul2021: newsci6: 14001-16000, c/c=395.4/485.4min 
c     26Jul2021: newsci6: autologout Jasmin i=16325
c     27Jul2021: newsci6: 16326-18000, c/c=431.5/512.9min 
c     27Jul2021: newsci6: autologout Jasmin i=18784 (4.54h)
c     27Jul2021: newsci6: autologout Jasmin i=19231 (4.28h)
c     27Jul2021: newsci6: 19232-20000, c/c=213.2/263.6min 
c     28Jul2021: newsci6: autologout Jasmin i=21276 (18.57h)
c     28Jul2021: newsci6: autologout Jasmin i=21734 (9.24h)
c     29Jul2021: newsci6: autologout Jasmin i=22112 (8.60h)
c     03Aug2021: newsci6: test 00001-00010, c/c=0.26/0.33min; 9/10 files not found
c     03Aug2021: newsci6: test 00001-00100, c/c=0.30/0.45min; 95/100 files not found
c     03Aug2021: newsci6: test 00001-01000, c/c=2.00/2.97min; 973/1000 files not found
c     03Aug2021: newsci6: test 00001-00010, c/c=1.20/1.42min; 2/10 files not found
c     03Aug2021: newsci6: test 00001-01000, c/c=-/3.13h; 995/1000 files found
c     06Aug2021: newsci6: run 0????-03789, c/c=-/4.09h; Jasmin crash 1353; 106 files not found
c     07Aug2021: newsci6: run 03790-05000, c/c=256.7/332.9min (5.55h); 156 not there
c     07Aug2021: newsci6: run 03790-05000, c/c=256.7/332.9min (5.55h); 156 not there
c     07Aug2021: newsci6: run 05001-06000, c/c=185.8/259.9min
c     07Aug2021: newsci6: run 06001-06612, c/c=-/2.39h; Jasmin crash
c     07Aug2021: newsci6: run 06613-07000, c/c=167.0/230.4min
c     07Aug2021: newsci6: run 07001-08000, c/c=159.7/249.7min
c     08Aug2021: newsci6: run 08001-09000, c/c=153.7/236.5min
c     08Aug2021: newsci6: run 09001-09429, c/c=-/2.98h; Jasmin crash
c     09Aug2021: newsci6: run 09430-11000, c/c=589.2/768.0min
c     09Aug2021: newsci6: run 11001-12000, c/c=101.0/143.0min
c     09Aug2021: newsci6: run 12001-12428, c/c=-/2.75h; Jasmin crash 13:53
c     09Aug2021: newsci6: run 12429-12670, c/c=-/3.23h; Jasmin crash 19:29
c     09Aug2021: newsci3: run 12671-12716, c/c=-/1.28h; Jasmin crash 20:58
c     09Aug2021: newsci6: run 11001-12000, c/c=101.0/143.0min
c     10Aug2021: newsci6: run 12001-14000, c/c=326.0/400.5min
c     11Aug2021: newsci6: run 14500-18000, c/c=-/15.78h; normal completion
c     11Aug2021: newsci6: run 18000-18675, c/c=-/3.11h; Jasmin crash 09:16
c     14Aug2021: newsci6: run 18676-25032, c/c=3187.9/3831.4; normal completion to end, no fail tests

c     problem encountered
c      -source id with '.0'
c      -qff latitude file with 18 sigfigs: 24.4330000000000

c     qff source_list
c     /gws/nopw/j04/c3s311a_lot2/data/level1/land/level1c_sub_daily_data/v20200528/

c     Directory tree
c     qf1
c     -get_stnconfig_qff            need: Data_stnconfig/Prelim_sub_daily_station_config_ffr_v1.psv.csv
c     -get_list_qff_files           need: level0/sub_daily_data/dunn_test_files/*.*
c                                   output: Data_middle/z_qff_filelist.dat
c     -process_qff_files
c      -get_codes_processing_qff
c      -readin_lastfile_number_qff  need: level0/land_sub_daily_data_processing/d20191119_qff_to_cdm/Output/Lastfile/lastfile.dat
c      -test_qff_file_in_stnconfig
c       -isolate_single_name
c       -get_singles_stnconfig_qff2
c      -isolate_single_name
c      -get_singles_stnconfig_qff2
c      -process_single_qff_file     need: level1/land/level1c_sub_daily_data/dunn_test_files/*.*
c       -extract_fields_from_line
c      -find_original_precision_qff
c       -find_precision_vector_qff
c        -find_number_elements
c      -convert_var_string_to_float
c       -string_convert_float_qff
c      -convert_units_qff
c      -record_number_from_source_number_qff
c       -find_record_number_qff
c      -find_cdm_qc_code
c      -header_obs_lite_qff         output: level0/land/sub_daily_data_processing/d20191119_qff_to_cdm/Output/Header/*.*
c                                   output: level0/land/sub_daily_data_processing/d20191119_qff_to_cdm/Output/Observation/*.*
c                                   output: level0/land/sub_daily_data_processing/d20191119_qff_to_cdm/Output/Lite/*.*
c       -find_reconstruct_data_time
c       -assemble_vector_qff
c       -count_elements_vector_qff
c       -sample_screenprint_obs
c       -sample_screenprint_lite
c       -find_distinct_recnum_qff
c       -sample_screenprint_header
c       -make_new_stnconfig_qff
c        -get_strvector_distinct
c        -export_stnconfig_lines    output: level0/land/sub_daily_data_processing/d20191119_qff_to_cdm/Output/Receipt/*.*
c      -export_last_index_qff

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

      REAL                :: f_ndflag
      DOUBLE PRECISION    :: d_ndflag

      CHARACTER(LEN=300)  :: s_command
      INTEGER             :: io
c*****
      CHARACTER(LEN=300)  :: s_directory_output_header
      CHARACTER(LEN=300)  :: s_directory_output_observation
      CHARACTER(LEN=300)  :: s_directory_output_lite
      CHARACTER(LEN=300)  :: s_directory_output_receipt
      CHARACTER(LEN=300)  :: s_directory_output_lastfile
      CHARACTER(LEN=300)  :: s_directory_output_diagnostics
      CHARACTER(LEN=300)  :: s_directory_output_diagnostics_segfault
      CHARACTER(LEN=300)  :: s_directory_output_diagnostics_notthere
      CHARACTER(LEN=300)  :: s_directory_output_qc
      CHARACTER(LEN=300)  :: s_directory_output_receipt_linecount

      CHARACTER(LEN=300)  :: s_directory_file_source
      CHARACTER(LEN=300)  :: s_directory_data_middle
      CHARACTER(LEN=300)  :: s_directory_stnconfig
      CHARACTER(LEN=300)  :: s_directory_temp
      CHARACTER(LEN=300)  :: s_directory_qckey
      CHARACTER(LEN=300)  :: s_directory_ancillary

      CHARACTER(LEN=300)  :: s_qff_filelist
      CHARACTER(LEN=300)  :: s_filename_stnconfig
      CHARACTER(LEN=300)  :: s_filename_qckey
      CHARACTER(LEN=300)  :: s_filename_wishlist
c*****
      INTEGER,PARAMETER   :: l_rgh_files=100000
      INTEGER             :: l_files
      CHARACTER(LEN=300)  :: s_vec_files(l_rgh_files)
c*****
c     Stnconfig information
      INTEGER,PARAMETER   :: l_scoutput_rgh=160000 !100000 !70000 !160000
      INTEGER             :: l_scoutput
      INTEGER             :: l_scoutput_numfield
      INTEGER,PARAMETER   :: ilen=100 !100       !character width of field
       
      CHARACTER(LEN=ilen) :: s_scoutput_vec_header(50)               
c      CHARACTER(LEN=ilen) :: s_scoutput_mat_fields(l_scoutput_rgh,50)
      CHARACTER(LEN=1000) :: s_scoutput_stnconfig_lines(l_scoutput_rgh)
      CHARACTER(LEN=1000) :: s_scoutput_header
      CHARACTER(LEN=16)   :: s_scoutput_searchname(l_scoutput_rgh)

      CHARACTER(LEN=300)  :: s_qckey_timescale_spec
      INTEGER             :: l_qckey
      CHARACTER(LEN=2)    :: s_qckey_sourceflag(100)
      CHARACTER(LEN=2)    :: s_qckey_c3sflag(100)
      CHARACTER(LEN=300)  :: s_qckey_timescale(100) 
c************************************************************************
      print*,'start program qf20210215'
c************************************************************************
c     Find start time    
      CALL CPU_TIME(f_time_st)

c     Find date & time
      CALL DATE_AND_TIME(s_date_st,s_time_st,s_zone_st,i_values_st)
c************************************************************************
      f_ndflag=-999.0
      d_ndflag=-999.0

      s_qckey_timescale_spec='subdaily'   !subdaily or daily/monthly
c************************************************************************
c     Declare directories (20336 files in source directory)

c     Implemented 02Aug2021
      s_directory_file_source=
     +  '/gws/nopw/j04/c3s311a_lot2/data/level1/land/'//
     +  'level1c_sub_daily_data/v20210728/'
cc     removed 08Aug2021; Implemented 13/07/2021
c      s_directory_file_source=
c     +  '/gws/nopw/j04/c3s311a_lot2/data/level1/land/'//
c     +  'level1c_sub_daily_data/v20210615/'
cc     removed 13/07/2021 Declare directories (20336 files in source directory)
c      s_directory_file_source=
c     +  '/gws/nopw/j04/c3s311a_lot2/data/level1/land/'//
c     +  'level1c_sub_daily_data/v20201218/'
c      s_directory_file_source=
c     +  '/gws/nopw/j04/c3s311a_lot2/data/level1/land/'//
c     +  'level1c_sub_daily_data/v20200901/'

c     implemented 13Jul2021: This is the new directory for stnconfig & wishlist
      s_directory_stnconfig  =
     +  'Data_stnconfig/'
cc     removed 02Aug2021: implemented 13Jul2021: This is the new directory for stnconfig & wishlist
c      s_directory_stnconfig  =
c     +  '/gws/nopw/j04/c3s311a_lot2/data/incoming/'//
c     +  'sub_daily_configuration_29_06_21/'
cc     removed 13Jul2021; Must change directory for r21q2
c      s_directory_stnconfig  ='Data_stnconfig/'

      s_directory_data_middle='Data_middle/'    !to store file listing
      s_directory_temp       ='Data_temp/'      !segmentation fault tester
      s_directory_qckey      ='Data_qckey/'
      s_directory_ancillary  ='Data_ancillary/'

c     Implemented 02Aug2021; Outputs
      s_directory_output_header=
     +  '/work/scratch-pw/akettle/P20210802_qff_cdm_21q2/'//
     +  'Step1_makecdm/Header/'
      s_directory_output_observation=
     +  '/work/scratch-pw/akettle/P20210802_qff_cdm_21q2/'//
     +  'Step1_makecdm/Observation/'
      s_directory_output_lite=
     +  '/work/scratch-pw/akettle/P20210802_qff_cdm_21q2/'//
     +  'Step1_makecdm/Lite/'
      s_directory_output_receipt=
     +  '/work/scratch-pw/akettle/P20210802_qff_cdm_21q2/'//
     +  'Step1_makecdm/Receipt/'
      s_directory_output_lastfile=
     +  '/work/scratch-pw/akettle/P20210802_qff_cdm_21q2/'//
     +  'Step1_makecdm/Lastfile/'
      s_directory_output_diagnostics=
     +  '/work/scratch-pw/akettle/P20210802_qff_cdm_21q2/'//
     +  'Step1_makecdm/Diagnostics/'
      s_directory_output_diagnostics_segfault=
     +  '/work/scratch-pw/akettle/P20210802_qff_cdm_21q2/'//
     +  'Step1_makecdm/Diagnostics_segfault/'
      s_directory_output_diagnostics_notthere=
     +  '/work/scratch-pw/akettle/P20210802_qff_cdm_21q2/'//
     +  'Step1_makecdm/Diagnostics_notthere/'
      s_directory_output_qc=
     +  '/work/scratch-pw/akettle/P20210802_qff_cdm_21q2/'//
     +  'Step1_makecdm/QC/'
      s_directory_output_receipt_linecount=
     +  '/work/scratch-pw/akettle/P20210802_qff_cdm_21q2/'//
     +  'Step1_makecdm/Receipt_linecount/'

cc     removed 02Aug2021: Outputs
c      s_directory_output_header=
c     +  '/work/scratch-pw/akettle/P20210625_qff_cdm_21q2/'//
c     +  'Step1_makecdm/Header/'
c      s_directory_output_observation=
c     +  '/work/scratch-pw/akettle/P20210625_qff_cdm_21q2/'//
c     +  'Step1_makecdm/Observation/'
c      s_directory_output_lite=
c     +  '/work/scratch-pw/akettle/P20210625_qff_cdm_21q2/'//
c     +  'Step1_makecdm/Lite/'
c      s_directory_output_receipt=
c     +  '/work/scratch-pw/akettle/P20210625_qff_cdm_21q2/'//
c     +  'Step1_makecdm/Receipt/'
c      s_directory_output_lastfile=
c     +  '/work/scratch-pw/akettle/P20210625_qff_cdm_21q2/'//
c     +  'Step1_makecdm/Lastfile/'
c      s_directory_output_diagnostics=
c     +  '/work/scratch-pw/akettle/P20210625_qff_cdm_21q2/'//
c     +  'Step1_makecdm/Diagnostics/'
c      s_directory_output_diagnostics_segfault=
c     +  '/work/scratch-pw/akettle/P20210625_qff_cdm_21q2/'//
c     +  'Step1_makecdm/Diagnostics_segfault/'
c      s_directory_output_diagnostics_notthere=
c     +  '/work/scratch-pw/akettle/P20210625_qff_cdm_21q2/'//
c     +  'Step1_makecdm/Diagnostics_notthere/'
c      s_directory_output_qc=
c     +  '/work/scratch-pw/akettle/P20210625_qff_cdm_21q2/'//
c     +  'Step1_makecdm/QC/'
c      s_directory_output_receipt_linecount=
c     +  '/work/scratch-pw/akettle/P20210625_qff_cdm_21q2/'//
c     +  'Step1_makecdm/Receipt_linecount/'

c     This is full listing of qff files in directory
      s_qff_filelist='z_qff_filelist.dat'
      s_filename_qckey='qckey.dat'

c     implemented 13Jul2021
      s_filename_stnconfig=
     +  'prelim_sub_daily_station_configuration_29_07_2021_18.00.csv'
cc    removed 02Aug2021; implemented 13Jul2021
c      s_filename_stnconfig=
c     +  'sbdy_station_configuration_prelim_28_06_21.csv'
c     removed 13Jul2021
c     07Oct2020: new stnconfig file declared
c     15Feb2021: updated with new stnconfig file
c      s_filename_stnconfig=
c     +  'station_configuration_sbdy_prelim_19_01_2021.psv.csv'
cc     +  'station_configuration_sbdy_prelim_19_01_2021.psv.psv'
cc     +  'station_configuration_sbdy_prelim_19_01_2021.psv.csv'
cc     +  'sub_daily_configurationfile_30_09_2020.csv'

c     This is listing of subset of files by SN
c     implemented 03Aug2021
      s_filename_wishlist='sub_daily_station_list_03_08_21_10.00.csv'
cc     removed 03Aug2021; implemented 02Aug2021
c      s_filename_wishlist='sub_daily_station_list_29_07_21_18.00.csv'
cc     removed 02Aug2021; implemented 13Jul2021
c      s_filename_wishlist='sbdy_station_list_29_06_21.csv'
cc     removed 13Jul2021
c      s_filename_wishlist='sub_daily_stationid_list_31_01_2021.csv'
c************************************************************************
c     Remove header, observation, lite, receipt files

      GOTO 14

      s_command=
     +  'rm '//TRIM(s_directory_output_header)//'*'
      print*,'s_command=',TRIM(s_command) 
      CALL SYSTEM(s_command,io)

      s_command=
     +  'rm '//TRIM(s_directory_output_observation)//'*'
      print*,'s_command=',TRIM(s_command) 
      CALL SYSTEM(s_command,io)

      s_command=
     +  'rm '//TRIM(s_directory_output_lite)//'*'
      print*,'s_command=',TRIM(s_command) 
      CALL SYSTEM(s_command,io)

      s_command=
     +  'rm '//TRIM(s_directory_output_receipt)//'*'
      print*,'s_command=',TRIM(s_command) 
      CALL SYSTEM(s_command,io)

      s_command=
     +  'rm '//TRIM(s_directory_output_diagnostics)//'*'
      print*,'s_command=',TRIM(s_command) 
      CALL SYSTEM(s_command,io)

      s_command=
     +  'rm '//TRIM(s_directory_output_diagnostics_segfault)//'*'
      print*,'s_command=',TRIM(s_command) 
      CALL SYSTEM(s_command,io)

      s_command=
     +  'rm '//TRIM(s_directory_output_diagnostics_notthere)//'*'
      print*,'s_command=',TRIM(s_command) 
      CALL SYSTEM(s_command,io)

      s_command=
     +  'rm '//TRIM(s_directory_output_lastfile)//'*'
      print*,'s_command=',TRIM(s_command) 
      CALL SYSTEM(s_command,io)

      s_command=
     +  'rm '//TRIM(s_directory_output_qc)//'*'
      print*,'s_command=',TRIM(s_command) 
      CALL SYSTEM(s_command,io)

      s_command=
     +  'rm '//TRIM(s_directory_output_receipt_linecount)//'*'
      print*,'s_command=',TRIM(s_command) 
      CALL SYSTEM(s_command,io)

 14   CONTINUE

c     Clean Directory_temp
c      s_command=
c     +  'rm '//TRIM(s_directory_temp)//'*.*'
c      print*,'s_command=',TRIM(s_command) 
c      CALL SYSTEM(s_command,io)

c      STOP 'qf20210802.f; just finished erasing procedure'
c************************************************************************
c     Get stnconfig info
      print*,'s_filename_stnconfig=',TRIM(s_filename_stnconfig)

      CALL get_stnconfig_qff20210714(s_directory_stnconfig,
     +  s_filename_stnconfig,
     +  l_scoutput_rgh,l_scoutput,ilen,
     +  l_scoutput_numfield,s_scoutput_vec_header,
     +  s_scoutput_stnconfig_lines,
     +  s_scoutput_header,s_scoutput_searchname)

c      STOP 'qf20210625.f; just cleared get_stnconfig_qff'
c************************************************************************
c     Sequence to make listing of all qff files in input directory

      GOTO 16

c     Make list of files in RD QFF directory
      s_command=
     +  'ls '//TRIM(s_directory_file_source)//'*.qff > '//
     +  TRIM(s_directory_data_middle)//
     +  TRIM(s_qff_filelist)
      print*,'s_command=',TRIM(s_command)
      CALL SYSTEM(s_command,io)

56    CONTINUE

      CALL get_list_qff_files(
     +  s_directory_data_middle,s_qff_filelist,
     +  l_rgh_files,l_files,s_vec_files)

      print*,'l_files=',l_files

c     Remove intermediate files
      s_command=
     +  'rm '//TRIM(s_directory_data_middle)//TRIM(s_qff_filelist)
      print*,'s_command=',TRIM(s_command)
      CALL SYSTEM(s_command,io)

c      STOP 'qf20210625 just after erase sequence'

 16   CONTINUE
c************************************************************************
c     Get wish list sent by SN

c     implemented 13Jul2021
      CALL get_list_qff_files20210217(s_directory_file_source,
     +  s_directory_stnconfig,s_filename_wishlist,
     +  l_rgh_files,l_files,s_vec_files)
c     removed 13Jul2021
c      CALL get_list_qff_files20210217(s_directory_file_source,
c     +  s_directory_ancillary,s_filename_wishlist,
c     +  l_rgh_files,l_files,s_vec_files)

c      print*,'l_files=',l_files
c      print*,'s_vec_files=',(TRIM(s_vec_files(i))//'=',i=1,10)

c      STOP 'qf20210625.f; just cleared get_list_qff_files20210217'
c************************************************************************
c     Read in qff conversion key

      CALL get_qckey(s_directory_qckey,s_filename_qckey,
     +  l_qckey,
     +  s_qckey_sourceflag,s_qckey_c3sflag,s_qckey_timescale)

c      STOP 'qf20210802; just after get_qckey'
c************************************************************************
c     Process qff files

      CALL process_qff_files20210724(
     +  s_date_st,s_time_st,s_zone_st,i_values_st,
     +  s_directory_output_header,s_directory_output_observation,
     +  s_directory_output_lite,s_directory_output_receipt,
     +  s_directory_output_lastfile,s_directory_output_diagnostics,
     +  s_directory_output_diagnostics_segfault,
     +  s_directory_output_diagnostics_notthere,
     +  s_directory_output_qc,s_directory_output_receipt_linecount,
     +  s_directory_file_source,
     +  s_directory_temp,
     +  l_rgh_files,l_files,s_vec_files,
     +  f_ndflag,
     +  l_scoutput_rgh,l_scoutput,ilen,
     +  s_scoutput_stnconfig_lines,
     +  s_scoutput_header,s_scoutput_searchname,
     +  s_qckey_timescale_spec,l_qckey,
     +  s_qckey_sourceflag,s_qckey_c3sflag,s_qckey_timescale)

c      print*,'l_scoutput_rgh,l_scoutput',l_scoutput_rgh,l_scoutput
c      STOP 'qf1'

c************************************************************************



c************************************************************************
      print*,'end program qf1'
c************************************************************************
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

      print*,'s_date_en=',s_date_en
      print*,'s_time_en=',s_time_en    
c************************************************************************

      END
