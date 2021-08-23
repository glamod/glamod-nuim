c     Program to separate second USAF update into station files
c     AJ_Kettle, 29Mar2021

c     15Apr2021: newsci6: 1/26 tar test file to yield 13277 stn files; c/c=0.37/5.43min
c     15Apr2021 13:48: newsci6 full run c/c 7.83/127.15min; 13894 stn files

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
      CHARACTER(LEN=300)  :: s_directory_filelist 
      CHARACTER(LEN=300)  :: s_directory_dataroot
c      CHARACTER(LEN=300)  :: s_directory_dataroot1
c      CHARACTER(LEN=300)  :: s_directory_dataroot2
c      CHARACTER(LEN=300)  :: s_directory_dataroot3

c     directories for intermediate and final steps
      CHARACTER(LEN=300)  :: s_directory_1tar
      CHARACTER(LEN=300)  :: s_directory_2untarpack
      CHARACTER(LEN=300)  :: s_directory_3unsort
      CHARACTER(LEN=300)  :: s_directory_3headerlist
      CHARACTER(LEN=300)  :: s_directory_3archive

      CHARACTER(LEN=300)  :: s_subdir
      CHARACTER(LEN=300)  :: s_name_filelist
c      CHARACTER(LEN=300)  :: s_name_filelist1
c      CHARACTER(LEN=300)  :: s_name_filelist2
c      CHARACTER(LEN=300)  :: s_name_filelist3
c*****
c     Standard ASCII characters
      INTEGER             :: l_ascii
      INTEGER             :: i_list_ascii(62)
      CHARACTER(LEN=1)    :: s_list_asciichar(62)
c*****
      INTEGER             :: l_tar
      CHARACTER(LEN=300)  :: s_vec_path(2000)
      CHARACTER(LEN=300)  :: s_vec_name(2000)

c      INTEGER             :: l_tar1
c      CHARACTER(LEN=300)  :: s_vec_path1(2000)
c      CHARACTER(LEN=300)  :: s_vec_name1(2000)

c      INTEGER             :: l_tar2
c      CHARACTER(LEN=300)  :: s_vec_path2(2000)
c      CHARACTER(LEN=300)  :: s_vec_name2(2000)

c      INTEGER             :: l_tar3
c      CHARACTER(LEN=300)  :: s_vec_path3(2000)
c      CHARACTER(LEN=300)  :: s_vec_name3(2000)
c*****
      CHARACTER(LEN=300)  :: s_command
      INTEGER             :: io

      CHARACTER(LEN=4)    :: s_year_select 
c************************************************************************
      print*,'start up21'
c************************************************************************
c     Find start time    
      CALL CPU_TIME(f_time_st)

c     Find date & time
      CALL DATE_AND_TIME(s_date_st,s_time_st,s_zone_st,i_values_st)
c************************************************************************
      s_year_select='2021'
c************************************************************************
c     Directory of files

      s_directory_filelist=
     +  '/home/users/akettle/Work/P20210325_usaf_update2/'//
     +  'Datafile_listing/'
c     Note root is in GWS for update1 & scratch-pw for update2
      s_directory_dataroot=
     + '/work/scratch-pw/akettle/P20210325_usaf_update2/Data_source/'//
     + TRIM(s_year_select)//'/'

      s_name_filelist='file'//TRIM(s_year_select)//'.dat'
c************************************************************************
      CALL get_directory_paths20210412(s_year_select,
     + s_directory_1tar,s_directory_2untarpack,
     + s_directory_3unsort,s_directory_3headerlist,s_directory_3archive)

c      STOP 'up20'
c************************************************************************
c      GOTO 41

c     Remove all output files

      s_command=
     +  'rm '//TRIM(s_directory_1tar)//'*'
      print*,'s_command=',TRIM(s_command) 
      CALL SYSTEM(s_command,io)

      s_command=
     +  'rm '//TRIM(s_directory_2untarpack)//'*'
      print*,'s_command=',TRIM(s_command) 
      CALL SYSTEM(s_command,io)

      s_command=
     +  'rm '//TRIM(s_directory_3unsort)//'*.csv'
      print*,'s_command=',TRIM(s_command) 
      CALL SYSTEM(s_command,io)

      s_command=
     +  'rm '//TRIM(s_directory_3headerlist)//'*'
      print*,'s_command=',TRIM(s_command) 
      CALL SYSTEM(s_command,io)

      s_command=
     +  'rm '//TRIM(s_directory_3archive)//'*'
      print*,'s_command=',TRIM(s_command) 
      CALL SYSTEM(s_command,io)

c      STOP 'just erased output directories; up21'

 41   CONTINUE
c************************************************************************
c     Get list of ASCII characters

      CALL get_ascii_list(l_ascii,i_list_ascii,s_list_asciichar)
c************************************************************************
c     Import file listing
      CALL import_file_listing20210401(
     +  s_directory_filelist,s_name_filelist,
     +  s_directory_dataroot,
     +  l_tar,
     +  s_vec_path,s_vec_name)



      print*,'l_tar=',l_tar
      print*,'s_vec_path=',(TRIM(s_vec_path(i)),i=1,1)
      print*,'s_vec_name=',(TRIM(s_vec_name(i)),i=1,1)

c      print*,'l_tar1,l_tar2...=',l_tar1,l_tar2,l_tar3
c      print*,'s_vec_path1=',(TRIM(s_vec_path1(i)),i=1,1)
c      print*,'s_vec_name1=',(TRIM(s_vec_name1(i)),i=1,1)
c      print*,'s_vec_path2=',(TRIM(s_vec_path2(i)),i=1,1)
c      print*,'s_vec_name2=',(TRIM(s_vec_name2(i)),i=1,1)
c      print*,'s_vec_path3=',(TRIM(s_vec_path3(i)),i=1,1)
c      print*,'s_vec_name3=',(TRIM(s_vec_name3(i)),i=1,1)

c      STOP 'up20'
c************************************************************************
c     Process data files
      CALL process_files(l_tar,s_vec_path,s_vec_name,
     +  s_directory_1tar,s_directory_2untarpack,
     +  s_directory_3headerlist,s_directory_3unsort,
     +  s_directory_3archive,
     +  l_ascii,i_list_ascii,s_list_asciichar)
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

      END
