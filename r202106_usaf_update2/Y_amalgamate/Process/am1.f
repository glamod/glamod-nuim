c     Program to amalgamate USAF files in second update
c     AJ_Kettle, 21Apr2021

c     size of source directories
c     2019: 54 750 032
c     2020: 45 882 528
c     2021:  6 624 176

c     22Apr2021: full stnlist for 2019-2021 15577 stn
c     27Apr2021: full run amalgamation files; c/c=16.4/117.0min
c     27Apr2021: full run amalgamation files; c/c=16.14/86.30min

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
      CHARACTER(LEN=300)  :: s_directory_dataroot1
      CHARACTER(LEN=300)  :: s_directory_dataroot2
      CHARACTER(LEN=300)  :: s_directory_dataroot3

      CHARACTER(LEN=300)  :: s_directory_assemstns
      CHARACTER(LEN=300)  :: s_directory_diagnostics

      CHARACTER(LEN=300)  :: s_subdirectory_sorted

      CHARACTER(LEN=300)  :: s_filelist
      CHARACTER(LEN=300)  :: s_file_liststn
      CHARACTER(LEN=300)  :: s_file_linecount

c*****
      INTEGER,PARAMETER   :: l_rgh_stn=20000
      INTEGER             :: l_stn2019
      INTEGER             :: l_stn2020
      INTEGER             :: l_stn2021
      CHARACTER(LEN=32)   :: s_vec_stnlist2019(l_rgh_stn)
      CHARACTER(LEN=32)   :: s_vec_stnlist2020(l_rgh_stn)
      CHARACTER(LEN=32)   :: s_vec_stnlist2021(l_rgh_stn)
c*****
      INTEGER             :: l_amal
      CHARACTER(LEN=32)   :: s_vec_stnlist_amal(l_rgh_stn)
      INTEGER             :: i_mat_stnlist_flag(l_rgh_stn,3)
c*****
      CHARACTER(LEN=300)  :: s_command
      INTEGER             :: io
c************************************************************************
      print*,'start am1'
c************************************************************************
c     Find start time    
      CALL CPU_TIME(f_time_st)

c     Find date & time
      CALL DATE_AND_TIME(s_date_st,s_time_st,s_zone_st,i_values_st)
c************************************************************************
c************************************************************************
c     Directory of files

c     Note root is in GWS for update1 & scratch-pw for update2
      s_directory_dataroot1=
     + '/work/scratch-pw/akettle/P20210325_usaf_update2/'//
     + 'Y2019/'
      s_directory_dataroot2=
     + '/work/scratch-pw/akettle/P20210325_usaf_update2/'//
     + 'Y2020/'
      s_directory_dataroot3=
     + '/work/scratch-pw/akettle/P20210325_usaf_update2/'//
     + 'Y2021/'

      s_directory_assemstns=
     + '/work/scratch-pw/akettle/P20210325_usaf_update2/Y_amal/'//
     + 'Data_5sorted/'
      s_directory_diagnostics=
     + '/work/scratch-pw/akettle/P20210325_usaf_update2/Y_amal/'//
     + 'Data_5diag/'

      s_subdirectory_sorted='Data_4sorted/'

      s_filelist='z_filelist.dat'
      s_file_liststn='list_stn_2019_2020_2021.dat'
      s_file_linecount='linecount_2019_2020_2021.dat'

c      s_file_diag_fullstn
c************************************************************************
c     Erase files output directory

      s_command=
     +  'rm '//TRIM(s_directory_assemstns)//'*'
      print*,'s_command=',TRIM(s_command) 
      CALL SYSTEM(s_command,io)

      s_command=
     +  'rm '//TRIM(s_directory_diagnostics)//'*'
      print*,'s_command=',TRIM(s_command) 
      CALL SYSTEM(s_command,io)

c      STOP 'am1'
c************************************************************************
c     2019 - Create datafile list
      s_command=
     +  '(cd '//TRIM(s_directory_dataroot1)//
     +  TRIM(s_subdirectory_sorted)//
     +  ' && ls) > '//
     +  TRIM(s_filelist)
c      print*,'s_command=',TRIM(s_command) 
      CALL SYSTEM(s_command,io)

c     Read in data file lists
      CALL readin_stnlist(s_filelist,
     +  l_rgh_stn,l_stn2019,s_vec_stnlist2019)

c     Remove data file lists
      s_command='rm '//TRIM(s_filelist)
c      print*,'s_command=',TRIM(s_command) 
      CALL SYSTEM(s_command,io)
c*****
c     2020 - Create datafile list
      s_command=
     +  '(cd '//TRIM(s_directory_dataroot2)//
     +  TRIM(s_subdirectory_sorted)//
     +  ' && ls) > '//
     +  TRIM(s_filelist)
c      print*,'s_command=',TRIM(s_command) 
      CALL SYSTEM(s_command,io)

c     Read in data file lists
      CALL readin_stnlist(s_filelist,
     +  l_rgh_stn,l_stn2020,s_vec_stnlist2020)

c     Remove data file lists
      s_command='rm '//TRIM(s_filelist)
c      print*,'s_command=',TRIM(s_command) 
      CALL SYSTEM(s_command,io)
c*****
c     2021 - Create datafile list
      s_command=
     +  '(cd '//TRIM(s_directory_dataroot3)//
     +  TRIM(s_subdirectory_sorted)//
     +  ' && ls) > '//
     +  TRIM(s_filelist)
c      print*,'s_command=',TRIM(s_command) 
      CALL SYSTEM(s_command,io)

c     Read in data file lists
      CALL readin_stnlist(s_filelist,
     +  l_rgh_stn,l_stn2021,s_vec_stnlist2021)

c     Remove data file lists
      s_command='rm '//TRIM(s_filelist)
c      print*,'s_command=',TRIM(s_command) 
      CALL SYSTEM(s_command,io)
c*****
c************************************************************************
c     Create diagnostics files
      CALL find_single_bigvector2(l_rgh_stn,
     +  l_stn2019,s_vec_stnlist2019,l_stn2020,s_vec_stnlist2020,
     +  l_stn2021,s_vec_stnlist2021,
     +  l_amal,
     +  s_vec_stnlist_amal,i_mat_stnlist_flag)
c************************************************************************
c     Export station diagnostics list
      CALL export_stnlist(s_date_st,s_time_st,
     +  s_directory_diagnostics,s_file_liststn, 
     +  l_rgh_stn,l_amal,
     +  s_vec_stnlist_amal,i_mat_stnlist_flag)
c************************************************************************
c     Create amalgamated set of data files

      CALL combine_3datasets(s_date_st,s_time_st,
     +  s_directory_dataroot1,
     +  s_directory_dataroot2,s_directory_dataroot3,
     +  s_subdirectory_sorted,
     +  s_directory_assemstns,s_directory_diagnostics,
     +  s_file_linecount,
     +  l_rgh_stn,l_amal,
     +  s_vec_stnlist_amal,i_mat_stnlist_flag)




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
      print*,'successfully finished am1'

      END
