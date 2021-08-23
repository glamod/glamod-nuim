c     Program to clip source file numbers & process unsorted USAF station files 
c     AJ_Kettle, 19Feb2020
c     11Apr2021: modified for update 2019-2020-2021

c     16Apr2021: 14587 stn full run on sci6; c/c=29.44/115.30min

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
c*****
      CHARACTER(LEN=300)  :: s_directory_namelist
      CHARACTER(LEN=300)  :: s_directory_files
      CHARACTER(LEN=300)  :: s_directory_file_outputsort
      CHARACTER(LEN=300)  :: s_directory_file_summary

      CHARACTER(LEN=300)  :: s_filelist_stns
c*****

      INTEGER, PARAMETER  :: l_files_rgh=20000
      INTEGER             :: l_files
      CHARACTER(LEN=30)   :: s_vec_filenames(l_files_rgh)

      CHARACTER(LEN=300)  :: s_command

      CHARACTER(LEN=4)    :: s_year_select
c************************************************************************
      print*,'start program cs20'
c************************************************************************
c     Find start time    
      CALL CPU_TIME(f_time_st)

c     Find date & time
      CALL DATE_AND_TIME(s_date_st,s_time_st,s_zone_st,i_values_st)
c************************************************************************
      s_year_select='2020'
c************************************************************************
c     Declare directories

      s_directory_namelist='Source_data/'

c     Inputs
      s_directory_files   =
     +  '/work/scratch-pw/akettle/P20210325_usaf_update2/'//
     +  'Y'//TRIM(s_year_select)//'/'//
     +  'Data_3unsorted/'

c     Outputs
      s_directory_file_outputsort=
     +  '/work/scratch-pw/akettle/P20210325_usaf_update2/'//
     +  'Y'//TRIM(s_year_select)//'/'//
     +  'Data_4sorted/'
      s_directory_file_summary=
     +  '/work/scratch-pw/akettle/P20210325_usaf_update2/'//
     +  'Y'//TRIM(s_year_select)//'/'//
     +  'Data_4diag/'

c      s_directory_files   =
c     +'/work/scratch/akettle/P20200114_usafupdate/Try1c/Data_3unsorted/'
c      s_directory_file_outputsort=
c     +'/work/scratch/akettle/P20200114_usafupdate/Try1c/Data_4sorted/'
c      s_directory_file_summary=
c     +'/work/scratch/akettle/P20200114_usafupdate/Try1c/Data_4diag/'

      s_filelist_stns='z_filelist.dat'
c************************************************************************
c     Remove output files
      s_command=
     +  'rm '//TRIM(s_directory_file_outputsort)//'*.csv'
      print*,'s_command=',TRIM(s_command) 
      CALL SYSTEM(s_command,io)

      s_command=
     +  'rm '//TRIM(s_directory_file_summary)//'*'
      print*,'s_command=',TRIM(s_command) 
      CALL SYSTEM(s_command,io)
c************************************************************************
c     Make list of stations to process

      s_command='(cd '//TRIM(s_directory_files)//' && ls) > '//
     +  TRIM(s_directory_namelist)//TRIM(s_filelist_stns)
      print*,'s_command=',TRIM(s_command) 
      CALL SYSTEM(s_command,io)

c      STOP 'cs20'
c************************************************************************
c     Read in name list
      CALL readin_namelist_all(
     +  s_directory_namelist,s_filelist_stns,
     +  l_files_rgh,l_files,s_vec_filenames)

c      STOP 'cs20'
c************************************************************************
c     Process all stations in sequence
      CALL process_stn_files(s_date_st,s_time_st,
     +  s_directory_files,s_directory_file_outputsort,
     +  s_directory_file_summary,
     +  l_files_rgh,l_files,s_vec_filenames)

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

      print*,'s_date_en,s_time_en=',s_date_en,' ',s_time_en
c************************************************************************
      print*,'end program cs2'
c************************************************************************
      END
