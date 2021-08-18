c     Program to collect receipts together
c     AJ_Kettle, 27Apr2020
c     08Feb2021: used for release r202102
c     01Mar2021: adapted from monthly to subdaily

c     02Mar2021: complete run 20354 stns; c/c=0.10/29.7min

c     17Aug2021: complete run 23539 stns: c/c=0.050/2.03min

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
      print*,'start program slc20210817'
c************************************************************************
c     Find start time    
      CALL CPU_TIME(f_cputime_st)

c     Find date & time
      CALL DATE_AND_TIME(s_date_st,s_time_st,s_zone_st,i_values_st)
c************************************************************************
c     20210817: implemented
      s_directory_receipt=
     +  '/work/scratch-pw/akettle/P20210802_qff_cdm_21q2/'//
     +  'Step1_makecdm/Receipt_linecount/'
c     20210817: removed
c      s_directory_receipt=
c     +  '/work/scratch-pw/akettle/P20210208_qff_cdm_21q1qc/'//
c     +  'Step1_makecdm/Receipt_linecount/'

c     20210817: implemented
      s_directory_filelist=
     +  '/work/scratch-pw/akettle/P20210802_qff_cdm_21q2/'//
     +  'Step1_makecdm/'
c     20210817: removed
c      s_directory_filelist=
c     +  '/work/scratch-pw/akettle/P20210208_qff_cdm_21q1qc/'//
c     +  'Step1_makecdm/'

c     20210817: implemented
      s_directory_assemblereceipt=
     +  '/work/scratch-pw/akettle/P20210802_qff_cdm_21q2/'//
     +  'Step2c_assem_linecount/'
c     20210817: removed
c      s_directory_assemblereceipt=
c     +  '/work/scratch-pw/akettle/P20210208_qff_cdm_21q1qc/'//
c     +  'Step2c_assem_linecount/'

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

c      STOP 'mlc1'
c************************************************************************
c     Import filename list
      CALL import_filename_list(
     +  s_directory_filelist,s_filename,
     +  l_rgh_stn,l_stn,
     +  s_filelist_stations)

      print*,'l_stn=',l_stn
c************************************************************************
c     Remove temporary list
      s_command='rm '//TRIM(s_directory_filelist)//'z_list.txt'
      print*,'s_command=',TRIM(s_command) 
      CALL SYSTEM(s_command,io)

c      STOP 'mlc1'
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
      print*,'end program slc20210817'

      END
