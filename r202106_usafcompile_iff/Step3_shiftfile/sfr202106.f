c     Program to transfer IFF file
c     AJ_Kettle, 23Mar2020
c     02Jun2021: used for r202106

c     02Jun2021: dew_point_temperature transfer finished 03Jun2021 0725 /cp
c     03Jun2021: sea_level_pressure: rsync --ignore-existing test
c                jasmin windows crash, sourceid=220, i=12049
c                completed in 2 segments c/c=2e-5/294.6min
c     03Jun2021: station_level_pressure: rsync --ignore-existing test
c                completed in 1 segment c/c=2e-5/232.0min
c     03Jun2021: wind _direction start 1 break evening with Jasmin crash
c                wind_direction fisnished 04Jun2021 1357; c/c=1.9e-5/321min
c     04Jun2021: wind_speed start 1 break late afternoon
c                2nd break evening 04Jun2021
c                24min to finish 05Jun2021
c     06Jun2021: temperature run finished c/c=2.8e-5/742min

c     06Jun2021: check shift
c                        AFWA-221    CMANS-222   ICAO-223    WMO-220
c                dewp    4869/4869   345/345     31896/31896 33690/33960
c                slp     4385/4385   950/950     22173/22173 29675/29675
c                stnp    2750/2750   115/115     14589/14589 26691/26691
c                airt    5024/5024   1008/1008   32243/32243 /35012
c                wdir    4963/4963   1007/1007   32257/32257 34453/34453
c                wspd    5031/5031   1110/1110   32402/32402 34730/34730

c     -07Jun2021: check file sizes
c                        AFWA-221    CMANS-222   ICAO-223    WMO-220
c                dewp    m-241082    m-17336     p-ICAOCYUT  m-162561
c                                                m-1545990
c                slp     m-203434    m-45525     m-1000192   m-1327841
c                stnp    m-136184    m-5809      m-710045    m-1294384
c                airt    m-198725    m-41060     m-1240453   m-1326032
c                wdir    m-210898    m-43975     m-1334807   m-1405712
c                wspd    m-194242    m-44281     m-1214922   m-1281031


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
      CHARACTER(LEN=300)  :: s_dir_root
      CHARACTER(LEN=300)  :: s_dir_source
      CHARACTER(LEN=300)  :: s_dir_full

      INTEGER,PARAMETER   :: l_variable=6
      INTEGER,PARAMETER   :: l_subdir=4
      CHARACTER(LEN=300)  :: s_subdir_var(l_variable)
      CHARACTER(LEN=300)  :: s_subdir_idnum(l_subdir)
      CHARACTER(LEN=300)  :: s_subdir_idnum_base(l_subdir)
c*****
      CHARACTER(LEN=1000) :: s_command
      CHARACTER(LEN=300)  :: s_fileref
      CHARACTER(LEN=300)  :: s_fileexclude

c************************************************************************
      print*,'start program sfr202106'
c************************************************************************
c     Find start time    
      CALL CPU_TIME(f_cputime_st)

c     Find date & time
      CALL DATE_AND_TIME(s_date_st,s_time_st,s_zone_st,i_values_st)
c************************************************************************
c     02Jun2021: implemented
      s_dir_root=
     +  '/gws/nopw/j04/c3s311a_lot2/data/level1/land/'//
     +  'level1a_sub_daily_data/'
      s_dir_source=
     +  '/work/scratch-pw/akettle/P20210429_usafcompile_iff/'//
     +  'Step2_iff/Accept/'

c     02Jun2021: removed
c      s_dir_root=
c     +  '/gws/nopw/j04/c3s311a_lot2/data/level1/land/'//
c     +  'level1a_sub_daily_data/'

      s_subdir_var(1)='dew_point_temperature'
      s_subdir_var(2)='sea_level_pressure'
      s_subdir_var(3)='station_level_pressure'
      s_subdir_var(4)='temperature'
      s_subdir_var(5)='wind_direction'
      s_subdir_var(6)='wind_speed'

      s_subdir_idnum(1)='220_a'
      s_subdir_idnum(2)='221_a'
      s_subdir_idnum(3)='223_a'
      s_subdir_idnum(4)='222'

      s_subdir_idnum_base(1)='220'
      s_subdir_idnum_base(2)='221'
      s_subdir_idnum_base(3)='223'
      s_subdir_idnum_base(4)='222'
c*****
      GOTO 10

c     Erase procedure
      ii=0
      DO i=1,l_variable
       DO j=1,l_subdir
        ii=ii+1 
        s_dir_full=
     +    TRIM(s_dir_root)//
     +    TRIM(s_subdir_var(i))//'/'//
     +    TRIM(s_subdir_idnum(j))//'/'

      s_command='rm '//TRIM(s_dir_full)//'*.*'
      print*,'s_command=',TRIM(s_command)
      CALL SYSTEM(s_command,io)

        print*,'i,j=',i,j,ii,TRIM(s_dir_full)
       ENDDO
      ENDDO

      print*,'cleared erase procedure'

 10   CONTINUE
c*****
c      GOTO 50
c 50   CONTINUE

c     Copy sequence
      ii=0
      DO i=4,4 !6,6 !5,5 !3,3 !2,2 !1,1 !l_variable
c      Case for all variables except temperature
       IF (i.NE.4) THEN 
       DO j=1,l_subdir  !cycle through network directories
        ii=ii+1 
        s_fileref=
     +    TRIM(s_dir_source)//'*'//
     +    TRIM(s_subdir_var(i))//'_'//
     +    TRIM(s_subdir_idnum_base(j))//'.psv'
        s_dir_full=
     +    TRIM(s_dir_root)//
     +    TRIM(s_subdir_var(i))//'/'//
     +    TRIM(s_subdir_idnum(j))//'/'

      s_command='rsync --ignore-existing '//
     +  TRIM(s_fileref)//' '//TRIM(s_dir_full)
c      s_command='cp -n '//TRIM(s_fileref)//' '//TRIM(s_dir_full(ii))
      print*,'s_command=',TRIM(s_command)
      CALL SYSTEM(s_command,io)

        print*,'i,j=',i,j,ii,TRIM(s_dir_full)
       ENDDO    !close j

       ENDIF
c******
c      Case for temperature only
       IF (i.EQ.4) THEN
       DO j=2,l_subdir  !cycle through network directories
        ii=ii+1 
        s_fileref=
     +    TRIM(s_dir_source)//'*'//
     +    TRIM(s_subdir_var(i))//'_'//
     +    TRIM(s_subdir_idnum_base(j))//'.psv'
        s_fileexclude=
     +    TRIM(s_dir_source)//'*'//
     +    TRIM(s_subdir_var(1))//'_'//
     +    TRIM(s_subdir_idnum_base(j))//'.psv'
        s_dir_full=
     +    TRIM(s_dir_root)//
     +    TRIM(s_subdir_var(i))//'/'//
     +    TRIM(s_subdir_idnum(j))//'/'

c     copy filelist into file
      s_command='find '//TRIM(s_dir_source)//
     +  ' -name '//
     +  '*'//
     +    TRIM(s_subdir_var(i))//'_'//
     +    TRIM(s_subdir_idnum_base(j))//'.psv'//
     +  ' > tmp_list.txt'
      print*,'s_command=',TRIM(s_command)
      CALL SYSTEM(s_command,io)

c     copy named files from list to GWS directory
      s_command='rsync --ignore-existing --files-from=tmp_list.txt / '//
     +  TRIM(s_dir_full)
      print*,'s_command=',TRIM(s_command)
c      STOP 'sfr202106'
      CALL SYSTEM(s_command,io)
c      STOP 'sfr202106'

c     remove list in advance of copying another network
      s_command='rm tmp_list.txt'
      print*,'s_command=',TRIM(s_command)
      CALL SYSTEM(s_command,io)

c      s_command='rsync --ignore-existing '//
c     +  TRIM(s_fileref)//' '//TRIM(s_dir_full)
c      print*,'s_command=',TRIM(s_command)
c      CALL SYSTEM(s_command,io)

c      s_command='cp -n '//TRIM(s_fileref)//' '//TRIM(s_dir_f

c      s_command='rsync --ignore-existing --exclude '//
c     +  TRIM(s_fileexclude)//' '//
c     +  TRIM(s_fileref)//' '//TRIM(s_dir_full(ii))
c      s_command='cp -n '//TRIM(s_fileref)//' '//TRIM(s_dir_full(ii))

c      s_command='rm '//
c     +  TRIM(s_dir_full(ii))//'*'//TRIM(s_subdir_var(1))//'*'
c      print*,'s_command=',TRIM(s_command)
cc      STOP 'sfr202106'
c     CALL SYSTEM(s_command,io)

        print*,'i,j=',i,j,ii,TRIM(s_dir_full)
       ENDDO  !close j
       ENDIF
c*****
      ENDDO   !close i


c      s_command='rm '//TRIM(s_dir_target)//'*.*'
c      print*,'s_command=',TRIM(s_command)
c      CALL SYSTEM(s_command,io)
c******
      GOTO 50

c     Case for temperature only
      i=4
      j=1

        s_fileref=
     +    TRIM(s_dir_source)//'*'//
     +    TRIM(s_subdir_var(i))//'_'//
     +    TRIM(s_subdir_idnum_base(j))//'.psv'
        s_fileexclude=
     +    TRIM(s_dir_source)//'*'//
     +    TRIM(s_subdir_var(1))//'_'//
     +    TRIM(s_subdir_idnum_base(j))//'.psv'
        s_dir_full=
     +    TRIM(s_dir_root)//
     +    TRIM(s_subdir_var(i))//'/'//
     +    TRIM(s_subdir_idnum(j))//'/'

      s_command='rsync --ignore-existing '//
     +  TRIM(s_fileref)//' '//TRIM(s_dir_full)
      print*,'s_command=',TRIM(s_command)
      STOP 'sfr202106'
      CALL SYSTEM(s_command,io)

c      s_command='cp -n '//TRIM(s_fileref)//' '//TRIM(s_dir_f

c      s_command='rsync --ignore-existing --exclude '//
c     +  TRIM(s_fileexclude)//' '//
c     +  TRIM(s_fileref)//' '//TRIM(s_dir_full(ii))
c      s_command='cp -n '//TRIM(s_fileref)//' '//TRIM(s_dir_full(ii))

c      s_command='rm '//
c     +  TRIM(s_dir_full(ii))//'*'//TRIM(s_subdir_var(1))//'*'
c      print*,'s_command=',TRIM(s_command)
cc      STOP 'sfr202106'
c     CALL SYSTEM(s_command,io)

        print*,'i,j=',i,j,ii,TRIM(s_dir_full)
 50     CONTINUE
c*****

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
      print*,'end program sf1'
c************************************************************************

      END
