c     Program to make listing of the USAF files in main & update; combine ds
c     AJ_Kettle, 30Apr2021

c     Size of source stations files AFWA-ICAO-WMO-CMANS:
c             N_stns Filesize
c     ----------------------------------
c     main    22721  730,286,648 (on GWS)
c     update1 15966   36,546,095 (on GWS)
c     update2 15128    9,885,418 (on GWS; 102,322,624 on scratch-pw)

c     2021/05/06: test 10 stns;    c/c=0.06/0.10min
c     2021/05/06: test 100 stns;   c/c=0.06/0.42min
c     2021/05/06: test 1000 stns;  c/c=2.13/6.98min
c     2021/05/07: stns 1-12000; c/c=189.6/408.5min
c     2021/05/08: 12001-20679; premature stop by Jasmin reset
c     2021/05/09: complete station run 24000+ stns c/c=253.6/541.2min

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
      CHARACTER(LEN=300)  :: s_directory_usaf_main
      CHARACTER(LEN=300)  :: s_directory_usaf_update1
      CHARACTER(LEN=300)  :: s_directory_usaf_update2

      CHARACTER(LEN=300)  :: s_directory_usaf_output_files
      CHARACTER(LEN=300)  :: s_directory_usaf_output_diag

      CHARACTER(LEN=300)  :: s_filelist
      CHARACTER(LEN=300)  :: s_file_liststn
      CHARACTER(LEN=300)  :: s_file_linecount
      CHARACTER(LEN=300)  :: s_file_headercompare

c*****
      INTEGER,PARAMETER   :: l_rgh_stn=30000
      INTEGER             :: l_stn_ma
      INTEGER             :: l_stn_u1
      INTEGER             :: l_stn_u2
      CHARACTER(LEN=32)   :: s_vec_stnlist_ma(l_rgh_stn)
      CHARACTER(LEN=32)   :: s_vec_stnlist_u1(l_rgh_stn)
      CHARACTER(LEN=32)   :: s_vec_stnlist_u2(l_rgh_stn)
c*****
      INTEGER             :: l_amal
      CHARACTER(LEN=32)   :: s_vec_stnlist_amal(l_rgh_stn)
      INTEGER             :: i_mat_stnlist_flag(l_rgh_stn,3)
c*****
c*****
      CHARACTER(LEN=300)  :: s_command 
c************************************************************************
      print*,'start program cu2'
c************************************************************************
c     Find start time    
      CALL CPU_TIME(f_cputime_st)

c     Find date & time
      CALL DATE_AND_TIME(s_date_st,s_time_st,s_zone_st,i_values_st)
c************************************************************************
      s_directory_usaf_main=
     + '/gws/nopw/j04/c3s311a_lot2/data/level0/land/'//
     + 'sub_daily_data_processing/P20190207_endtoend/'//
     + 'zscratch_ajk3/L2_stnfiles_sort/'
c     + '/gws/nopw/j04/c3s311a_lot2/data/level0/land/'//
c     + 'sub_daily_data_processing/P20200227_usafcompile/'//
c     + 'Step1_stncombine/'
      s_directory_usaf_update1=
     + '/gws/nopw/j04/c3s311a_lot2/data/level0/land/'//
     + 'sub_daily_data_processing/P20200114_usafupdate/Data_4sorted/'
      s_directory_usaf_update2=
     + '/gws/nopw/j04/c3s311a_lot2/data/level0/land/'//
     + 'sub_daily_data_processing/P20210325_usaf_update2/'//
     + 'Y_amal/Data_5sorted/'

      s_directory_usaf_output_files=
     + '/work/scratch-pw/akettle/P20210429_usafcompile_iff/'//
     + 'Step1_combine/' 
      s_directory_usaf_output_diag=
     + '/work/scratch-pw/akettle/P20210429_usafcompile_iff/'//
     + 'Step1_diag/'

      s_filelist='z_filelist.dat'
      s_file_liststn='list_stn_ma_u1_u2.dat'
      s_file_linecount='linecount_ma_u1_u2.dat'
      s_file_headercompare='header_compare.dat'
c************************************************************************
c     Erase output directory files

c      GOTO 15

c     Remove data file lists
      s_command='rm '//TRIM(s_directory_usaf_output_files)//'*'
      print*,'s_command=',TRIM(s_command) 
      CALL SYSTEM(s_command,io)

c     Remove data file lists
      s_command='rm '//TRIM(s_directory_usaf_output_diag)//'*'
      print*,'s_command=',TRIM(s_command) 
      CALL SYSTEM(s_command,io)

 15   CONTINUE

c      STOP 'cu2.f'
c************************************************************************
c     MAIN - Create datafile list
      s_command=
     +  '(cd '//TRIM(s_directory_usaf_main)//
     +  ' && ls) > '//TRIM(s_filelist)
      print*,'s_command=',TRIM(s_command) 
      CALL SYSTEM(s_command,io)

c     Read in data file lists
      CALL readin_stnlist20210429(s_filelist,
     +  l_rgh_stn,l_stn_ma,s_vec_stnlist_ma)

c     Remove data file lists
      s_command='rm '//TRIM(s_filelist)
      print*,'s_command=',TRIM(s_command) 
      CALL SYSTEM(s_command,io)
c*****
c     UPDATE1 - Create datafile list
      s_command=
     +  '(cd '//TRIM(s_directory_usaf_update1)//
     +  ' && ls) > '//TRIM(s_filelist)
      print*,'s_command=',TRIM(s_command) 
      CALL SYSTEM(s_command,io)

c     Read in data file lists
      CALL readin_stnlist20210429(s_filelist,
     +  l_rgh_stn,l_stn_u1,s_vec_stnlist_u1)

c     Remove data file lists
      s_command='rm '//TRIM(s_filelist)
      print*,'s_command=',TRIM(s_command) 
      CALL SYSTEM(s_command,io)
c*****
c     UPDATE2 - Create datafile list
      s_command=
     +  '(cd '//TRIM(s_directory_usaf_update2)//
     +  ' && ls) > '//TRIM(s_filelist)
      print*,'s_command=',TRIM(s_command) 
      CALL SYSTEM(s_command,io)

c     Read in data file lists
      CALL readin_stnlist20210429(s_filelist,
     +  l_rgh_stn,l_stn_u2,s_vec_stnlist_u2)

c     Remove data file lists
      s_command='rm '//TRIM(s_filelist)
      print*,'s_command=',TRIM(s_command) 
      CALL SYSTEM(s_command,io)
c*****
c************************************************************************
c     Create diagnostics files
      CALL find_single_bigvector20210430(l_rgh_stn,
     +  l_stn_ma,s_vec_stnlist_ma,l_stn_u1,s_vec_stnlist_u1,
     +  l_stn_u2,s_vec_stnlist_u2,
     +  l_amal,
     +  s_vec_stnlist_amal,i_mat_stnlist_flag)
c************************************************************************
c     Export station diagnostics list
      CALL export_stnlist20210430(s_date_st,s_time_st,
     +  s_directory_usaf_output_diag,s_file_liststn, 
     +  l_rgh_stn,l_amal,
     +  s_vec_stnlist_amal,i_mat_stnlist_flag)
c************************************************************************
c     Create comparison header list from 3 groups
      CALL export_compare_header(s_date_st,s_time_st,
     +  s_directory_usaf_main,s_directory_usaf_update1,
     +  s_directory_usaf_update2,
     +  s_directory_usaf_output_diag,s_file_headercompare,
     +  l_rgh_stn,
     +  l_stn_ma,s_vec_stnlist_ma,l_stn_u1,s_vec_stnlist_u1,
     +  l_stn_u2,s_vec_stnlist_u2)
c************************************************************************
c     Create amalgamated set of data files
      CALL combine_3datasets20210501(s_date_st,s_time_st,
     +  s_directory_usaf_main,s_directory_usaf_update1,
     +  s_directory_usaf_update2,
     +  s_directory_usaf_output_files,s_directory_usaf_output_diag,
     +  s_file_linecount,
     +  l_rgh_stn,l_amal,
     +  s_vec_stnlist_amal,i_mat_stnlist_flag)



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
      print*,'end program cu2'
c************************************************************************

      END





