c     Program to make IFF file from combined USAF files using seq/para program
c     AJ_Kettle, 23Mar2020
c     29Mar2020: modified to assemble receipts from sequential run

c     08Jun2021: full run c/c=0.70/7.57min:
c     20Aug2021: NOTE: CMANS source_id not included in output file

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
      CHARACTER(LEN=300)  :: s_dir_iff_source
      CHARACTER(LEN=300)  :: s_dir_outfile_iff_netplatdistinct
      CHARACTER(LEN=300)  :: s_dir_assemble
c*****
c     List of completed IFF files
      INTEGER,PARAMETER   :: l_iff_rgh=500000
      INTEGER             :: l_iff
      CHARACTER(64)       :: s_vec_iff_filename(l_iff_rgh)
      CHARACTER(32)       :: s_vec_iff_networktype(l_iff_rgh)
      CHARACTER(32)       :: s_vec_iff_platformid(l_iff_rgh)
c*****
      INTEGER, PARAMETER  :: l_stn_rgh=30000
      INTEGER             :: l_stn
      CHARACTER(LEN=300)  :: s_filelist(l_stn_rgh)

      INTEGER             :: l_iffuniq
      CHARACTER(32)       :: s_vec_iffuniq_netplat(l_stn_rgh)
c*****
      CHARACTER(LEN=300)  :: s_command
c************************************************************************
      print*,'start program ip3_post'
c************************************************************************
c     Find start time    
      CALL CPU_TIME(f_cputime_st)

c     Find date & time
      CALL DATE_AND_TIME(s_date_st,s_time_st,s_zone_st,i_values_st)
c************************************************************************
c     Declare directories
      s_dir_iff_source=
     +  '/work/scratch-pw/akettle/P20210429_usafcompile_iff/'//
     +  'Step2_iff/Accept/'

      s_dir_outfile_iff_netplatdistinct=
     +  '/work/scratch-pw/akettle/P20210429_usafcompile_iff/'//
     +  'Step2_iffinfo/Accept/'
      s_dir_assemble=
     +  '/work/scratch-pw/akettle/P20210429_usafcompile_iff/'//
     +  'Step3_iff_assemble/'
c************************************************************************
c     Clear existing assembled file
      s_command='rm '//TRIM(s_dir_assemble)//'*.*'
      print*,'s_command=',TRIM(s_command)
      CALL SYSTEM(s_command,io)

c      STOP 'iff_assem_r202106'
c************************************************************************
c     Get list of station station receipt (there will be null data stns)
      CALL import_triplet_filename_list2(
     +  s_dir_outfile_iff_netplatdistinct,
     +  l_stn_rgh,l_stn,s_filelist)

c     Import IFF filename list
      CALL import_iff_filenames(s_dir_iff_source,
     +  l_iff_rgh,l_iff,s_vec_iff_filename,
     +  s_vec_iff_networktype,s_vec_iff_platformid)

      print*,'l_stn_rgh...',l_stn_rgh,l_stn,TRIM(s_filelist(1))
      print*,'l_iff=',l_iff,TRIM(s_vec_iff_filename(1))

c     Find unique netplat
      CALL find_unique_netplat(
     +  l_iff_rgh,l_iff,s_vec_iff_filename,
     +  l_stn_rgh,l_iffuniq,s_vec_iffuniq_netplat)

c      STOP 'iff_assem_r202106'

c     Routine read in file lines & append them in new file
      CALL get_lines_append_stnconfig_new(
     +  s_date_st,s_time_st,s_zone_st,
     +  s_dir_outfile_iff_netplatdistinct,
     +  s_dir_assemble,
     +  l_stn_rgh,
     +  l_stn,s_filelist,
     +  l_iffuniq,s_vec_iffuniq_netplat)

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
      print*,'end program ip3_post'
c************************************************************************

      END
