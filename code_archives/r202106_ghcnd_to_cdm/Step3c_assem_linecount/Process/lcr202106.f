c     Program to collect receipts together
c     AJ_Kettle, 27Apr2020
c     08Feb2021: used for release r202102

c     08Feb2021: runtime c/c=0.26/43.77min
c     10Feb2021: complete run 83937 stns; c/c=0.28/34.42min
c     14Mar2021: complete run 83889 stns; c/c=0.18/7.62min
c     27May2021: complete run 83847 stns: c/c=0.17/15.75min

c2-------10--------20--------30--------40--------50--------60--------70--------80
      IMPLICIT NONE
c************************************************************************
c     Declare variables 

      INTEGER             :: i,j,k,ii,jj,kk

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
      CHARACTER(LEN=300)  :: s_directory_filelist
      CHARACTER(LEN=300)  :: s_directory_receipt
      CHARACTER(LEN=300)  :: s_directory_assemblereceipt

      CHARACTER(LEN=300)  :: s_filename
      CHARACTER(LEN=300)  :: s_filename_out

      CHARACTER(LEN=300)  :: s_pathandname_out
c*****
      INTEGER,PARAMETER   :: l_rgh_stn=125000
      INTEGER             :: l_stn
      CHARACTER(LEN=300)  :: s_filelist_stations(l_rgh_stn)
c*****
      CHARACTER(LEN=300)  :: s_command
      INTEGER             :: io
c************************************************************************
      print*,'start program lcr202106'
c************************************************************************
c     Find start time    
      CALL CPU_TIME(f_cputime_st)

c     Find date & time
      CALL DATE_AND_TIME(s_date_st,s_time_st,s_zone_st,i_values_st)
c************************************************************************
      s_directory_filelist=
     +  '/work/scratch-pw/akettle/P20210510_ghcnd21q2/'//
     +  'Step1_cdmmake/'

      s_directory_receipt=
     +  '/work/scratch-pw/akettle/P20210510_ghcnd21q2/'//
     +  'Step1_cdmmake/'//
     +  'Receipt_linecount/'

      s_directory_assemblereceipt=
     +  '/work/scratch-pw/akettle/P20210510_ghcnd21q2/'//
     +  'Step2c_assem_linecount/'

      s_filename='z_list.txt'
      s_filename_out='assembled_linecount.dat'
c************************************************************************
c************************************************************************
c     Erase old assembled file
      s_pathandname_out=
     +   TRIM(s_directory_assemblereceipt)//TRIM(s_filename_out)

      s_command='rm '//TRIM(s_pathandname_out)
      print*,'s_command=',TRIM(s_command) 
      CALL SYSTEM(s_command,io)
c************************************************************************
c     Make new master file list
      s_command='(cd '//TRIM(s_directory_receipt)//' && ls *)'//
     +  ' > '//TRIM(s_directory_filelist)//'z_list.txt'
      print*,'s_command=',TRIM(s_command) 
      CALL SYSTEM(s_command,io)

c     Import filename list
      CALL import_filename_list(
     +  s_directory_filelist,s_filename,
     +  l_rgh_stn,l_stn,
     +  s_filelist_stations)

c     Remove temporary list
      s_command='rm '//TRIM(s_directory_filelist)//'z_list.txt'
      print*,'s_command=',TRIM(s_command) 
      CALL SYSTEM(s_command,io)

c      STOP 'lcr202106'
c************************************************************************
c     Routine read in file lines & append them in new file
      CALL get_lines_append_stnconfig(
     +  s_date_st,s_time_st,s_zone_st,
     +  s_directory_receipt,s_directory_assemblereceipt,
     +  l_rgh_stn,l_stn,
     +  s_filelist_stations,
     +  s_filename_out)
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

      print*,'date/time st=',TRIM(s_date_st),TRIM(s_time_st)
      print*,'date/time en=',TRIM(s_date_en),TRIM(s_time_en)
c************************************************************************
      print*,'end program lcr202106'

      END
