c     Subroutine to resolve time stamp of measurements
c     AJ_Kettle, Dec3/2017

      SUBROUTINE find_timestamp(l_prod,s_day_date,f_last_lon_deg,
     +   s_dayavg_airt_stime,s_dayavg_airt_timezone,
     +   s_dayavg_pres_stime,s_dayavg_pres_timezone,
     +   s_dayavg_relh_stime,s_dayavg_relh_timezone,
     +   s_dayavg_wspd_stime,s_dayavg_wspd_timezone,
     +   s_daytot_ppt_stime,s_daytot_ppt_timezone,
     +   s_daytot_snoacc_stime,s_daytot_snoacc_timezone,

     +   s_dayavg_airtk_stime,s_dayavg_airtk_timezone,
     +   s_dayavg_slpres_stime,s_dayavg_slpres_timezone,

     +   s_daymax_airt_stime,s_daymax_airt_timezone,
     +   s_daymin_airt_stime,s_daymin_airt_timezone,

     +   s_dayavg_common_stime,s_dayavg_common_timezone,
     +   s_dayavg_common2_stime,s_dayavg_common2_timezone)

      IMPLICIT NONE
c************************************************************************
      INTEGER             :: i,j,k,ii,jj,kk

      INTEGER             :: l_prod
      CHARACTER(LEN=8)    :: s_day_date(100000)

      REAL                :: f_last_lon_deg

c     Create time-vector for measurement
      CHARACTER(LEN=8)    :: s_dayavg_airt_stime(100000)
      CHARACTER(LEN=5)    :: s_dayavg_airt_timezone(100000)
      CHARACTER(LEN=8)    :: s_dayavg_pres_stime(100000)
      CHARACTER(LEN=5)    :: s_dayavg_pres_timezone(100000)
      CHARACTER(LEN=8)    :: s_dayavg_relh_stime(100000)
      CHARACTER(LEN=5)    :: s_dayavg_relh_timezone(100000)
      CHARACTER(LEN=8)    :: s_dayavg_wspd_stime(100000)
      CHARACTER(LEN=5)    :: s_dayavg_wspd_timezone(100000)
      CHARACTER(LEN=8)    :: s_daytot_ppt_stime(100000)
      CHARACTER(LEN=5)    :: s_daytot_ppt_timezone(100000)
      CHARACTER(LEN=8)    :: s_daytot_snoacc_stime(100000)
      CHARACTER(LEN=5)    :: s_daytot_snoacc_timezone(100000)

      CHARACTER(LEN=8)    :: s_dayavg_airtk_stime(100000)
      CHARACTER(LEN=5)    :: s_dayavg_airtk_timezone(100000)
      CHARACTER(LEN=8)    :: s_dayavg_slpres_stime(100000)
      CHARACTER(LEN=5)    :: s_dayavg_slpres_timezone(100000)

      CHARACTER(LEN=8)    :: s_daymax_airt_stime(100000)
      CHARACTER(LEN=5)    :: s_daymax_airt_timezone(100000)
      CHARACTER(LEN=8)    :: s_daymin_airt_stime(100000)
      CHARACTER(LEN=5)    :: s_daymin_airt_timezone(100000)

      CHARACTER(LEN=8)    :: s_dayavg_common_stime(100000)
      CHARACTER(LEN=5)    :: s_dayavg_common_timezone(100000)

      CHARACTER(LEN=8)    :: s_dayavg_common2_stime(100000)
      CHARACTER(LEN=5)    :: s_dayavg_common2_timezone(100000)

c     Internal variables for program
      CHARACTER(LEN=8)    :: s_date_single
      CHARACTER(LEN=4)    :: s_year
      CHARACTER(LEN=4)    :: s_time_single
      CHARACTER(LEN=2)    :: s_month
      CHARACTER(LEN=2)    :: s_day
      CHARACTER(LEN=2)    :: s_hour
      CHARACTER(LEN=2)    :: s_minute

      REAL                :: f_year
      REAL                :: f_month
      REAL                :: f_day
      REAL                :: f_decihour_shift
      REAL                :: f_minute_remain 
      CHARACTER(LEN=2)    :: s_minute_remain 
      CHARACTER(LEN=2)    :: s_whole_hour
      REAL                :: f_hour
      REAL                :: f_minute
      REAL                :: f_deciday
      REAL                :: f_deciday_utc
      REAL                :: f_decihour
      REAL                :: f_decihour_utc

      INTEGER             :: i_wholehour_utc
      REAL                :: f_deciminute_utc
      INTEGER             :: i_wholeminute_utc
      REAL                :: f_decisecond_utc
      INTEGER             :: i_wholesecond_utc
      CHARACTER(LEN=2)    :: s_wholehour_utc
      CHARACTER(LEN=2)    :: s_wholeminute_utc
      CHARACTER(LEN=2)    :: s_wholesecond_utc
      INTEGER             :: i_hour_round
      INTEGER             :: i_minute_round
      REAL                :: f_minute_round

      CHARACTER(LEN=4)    :: s_test4
      CHARACTER(LEN=2)    :: s_test2
      REAL                :: f_test
      INTEGER             :: i_test
       
      CHARACTER(LEN=2)    :: s_hour_utc
c************************************************************************
c      print*,'just entered find_timestamp'
c************************************************************************
c     Find local solar time
      f_decihour_shift=24.0*f_last_lon_deg/360.0
      f_minute_remain=60.0*(f_decihour_shift-INT(f_decihour_shift))

      WRITE(s_test2,'(i2)') INT(f_decihour_shift)
      IF (f_decihour_shift.GE.10.0) THEN
       s_whole_hour=s_test2
      ENDIF
      IF (f_decihour_shift.LT.10.0) THEN
       s_whole_hour='0'//ADJUSTL(s_test2)
      ENDIF

      WRITE(s_test2,'(i2)') NINT(f_minute_remain)
      IF (NINT(f_minute_remain).GE.10) THEN
       s_minute_remain=s_test2
      ENDIF
      IF (NINT(f_minute_remain).LT.10) THEN
       s_minute_remain='0'//ADJUSTL(s_test2)
      ENDIF

c      print*,'f_decihour,f_minute_remain=',f_decihour,f_minute_remain
c      print*,'s_whole_hour,s_minute_remain',s_whole_hour,s_minute_remain

c      CALL SLEEP(5)
c************************************************************************
c************************************************************************
c     Convert given time to UTC

      DO i=1,l_prod
       s_date_single=s_day_date(i)
       s_year =s_date_single(1:4)
       s_month=s_date_single(5:6)
       s_day  =s_date_single(7:8)

c      Convert date to float
       s_test4       =TRIM(s_year)
       READ(s_test4,*) f_test
       f_year        =f_test

       s_test4       =TRIM(s_month)
       READ(s_test4,*) f_test
       f_month       =f_test

       s_test4       =TRIM(s_day)
       READ(s_test4,*) f_test
       f_day         =f_test
c******
c      Local solar time option
       IF (f_year.LT.1987.0) THEN
c        s_dayavg_airt_stime(i)='0700'
c        s_dayavg_airt_timezone(i)='+'//s_whole_hour//s_minute_remain

        s_time_single='0700'  !s_dayavg_airt_stime(i)
        s_hour  =s_time_single(1:2)
        s_minute=s_time_single(3:4)

        s_test2       =TRIM(s_hour)
        READ(s_test2,*) f_test
        f_hour        =f_test

        s_test2       =TRIM(s_minute)
        READ(s_test2,*) f_test
        f_minute      =f_test

        f_decihour=f_hour+f_minute/60.0
        f_decihour_utc=f_decihour-f_decihour_shift
        i_wholehour_utc=INT(f_decihour_utc)
        f_deciminute_utc=
     +    60.0*(f_decihour_utc-FLOAT(i_wholehour_utc))
        i_wholeminute_utc=INT(f_deciminute_utc)
        f_decisecond_utc=
     +    60.0*(f_deciminute_utc-FLOAT(i_wholeminute_utc))
        i_wholesecond_utc=INT(f_decisecond_utc)

        i_hour_round=i_wholehour_utc
        f_minute_round=10.0*FLOAT(NINT(f_deciminute_utc/10.0))
c       case where rounded minutes >60s
        IF (f_minute_round.GE.60.0) THEN 
         f_minute_round=f_minute_round-60.0
         i_hour_round=i_hour_round+1               
        ENDIF
        i_minute_round=INT(f_minute_round)

        i_test=i_hour_round
        WRITE(s_test2,'(i2)') i_test
        IF (i_test.GE.10) THEN 
         s_wholehour_utc=ADJUSTL(s_test2)
        ENDIF
        IF (i_test.LT.10) THEN 
         s_wholehour_utc='0'//ADJUSTL(s_test2)
        ENDIF

        i_test=i_minute_round
        WRITE(s_test2,'(i2)') i_test
        IF (i_test.GE.10) THEN 
         s_wholeminute_utc=ADJUSTL(s_test2)
        ENDIF
        IF (i_test.LT.10) THEN 
         s_wholeminute_utc='0'//ADJUSTL(s_test2)
        ENDIF

c        i_test=i_wholehour_utc
c        WRITE(s_test2,'(i2)') i_test
c        IF (i_test.GE.10) THEN 
c         s_wholehour_utc=ADJUSTL(s_test2)
c        ENDIF
c        IF (i_test.LT.10) THEN 
c         s_wholehour_utc='0'//ADJUSTL(s_test2)
c        ENDIF

c        i_test=i_wholeminute_utc
c        WRITE(s_test2,'(i2)') i_test
c        IF (i_test.GE.10) THEN 
c         s_wholeminute_utc=ADJUSTL(s_test2)
c        ENDIF
c        IF (i_test.LT.10) THEN 
c         s_wholeminute_utc='0'//ADJUSTL(s_test2)
c        ENDIF

c        i_test=i_wholesecond_utc
c        WRITE(s_test2,'(i2)') i_test
c        IF (i_test.GE.10) THEN 
c         s_wholesecond_utc=ADJUSTL(s_test2)
c        ENDIF
c        IF (i_test.LT.10) THEN 
c         s_wholesecond_utc='0'//ADJUSTL(s_test2)
c        ENDIF

c        s_dayavg_common_stime(i)   =
c     + s_wholehour_utc//':'//s_wholeminute_utc//':'//s_wholesecond_utc
        s_dayavg_common_stime(i)   =
     + s_wholehour_utc//':'//s_wholeminute_utc//':00'
        s_dayavg_common_timezone(i)='+0000'

C        print*,'lst option',i,s_dayavg_common_stime(i),
C     +    s_dayavg_common_timezone(i),i_wholeminute_utc
C        CALL SLEEP(1)

       ENDIF

c      Middle European time option
       IF (f_year.GE.1987.0) THEN
c        s_dayavg_airt_stime(i)='0730'
c        s_dayavg_airt_timezone(i)='+0100'

        s_time_single='0730'  !s_dayavg_airt_stime(i)
        s_hour  =s_time_single(1:2)
        s_minute=s_time_single(3:4)

        s_test2       =TRIM(s_hour)
        READ(s_test2,*) f_test
        f_hour        =f_test

        s_test2       =TRIM(s_minute)
        READ(s_test2,*) f_test
        f_minute      =f_test

        f_decihour=f_hour+f_minute/60.0
        f_decihour_utc=f_decihour-1.0      !shift 1h from MEZ to UTZ
        i_wholehour_utc=INT(f_decihour_utc)
        f_deciminute_utc=60.0*(f_decihour_utc-FLOAT(i_wholehour_utc))
        i_wholeminute_utc=INT(f_deciminute_utc)
        f_decisecond_utc=
     +    60.0*(f_deciminute_utc-FLOAT(i_wholeminute_utc))
        i_wholesecond_utc=INT(f_decisecond_utc)

        i_test=i_wholehour_utc
        WRITE(s_test2,'(i2)') i_test
        IF (i_test.GE.10) THEN 
         s_wholehour_utc=ADJUSTL(s_test2)
        ENDIF
        IF (i_test.LT.10) THEN 
         s_wholehour_utc='0'//ADJUSTL(s_test2)
        ENDIF

        i_test=i_wholeminute_utc
        WRITE(s_test2,'(i2)') i_test
        IF (i_test.GE.10) THEN 
         s_wholeminute_utc=ADJUSTL(s_test2)
        ENDIF
        IF (i_test.LT.10) THEN 
         s_wholeminute_utc='0'//ADJUSTL(s_test2)
        ENDIF

        i_test=i_wholesecond_utc
        WRITE(s_test2,'(i2)') i_test
        IF (i_test.GE.10) THEN 
         s_wholesecond_utc=ADJUSTL(s_test2)
        ENDIF
        IF (i_test.LT.10) THEN 
         s_wholesecond_utc='0'//ADJUSTL(s_test2)
        ENDIF

        s_dayavg_common_stime(i)   =
     + s_wholehour_utc//':'//s_wholeminute_utc//':'//s_wholesecond_utc
        s_dayavg_common_timezone(i)='+0000'     !hardwired to UTC

c        print*,'MEZ option',i,s_dayavg_common_stime(i),
c     +    s_dayavg_common_timezone(i)
c        CALL SLEEP(1)

       ENDIF
      ENDDO

c     Assign individual series common value
      DO i=1,l_prod
       s_dayavg_airt_stime(i)     =s_dayavg_common_stime(i)
       s_dayavg_airt_timezone(i)  =s_dayavg_common_timezone(i)
       s_dayavg_pres_stime(i)     =s_dayavg_common_stime(i)
       s_dayavg_pres_timezone(i)  =s_dayavg_common_timezone(i)
       s_dayavg_relh_stime(i)     =s_dayavg_common_stime(i)
       s_dayavg_relh_timezone(i)  =s_dayavg_common_timezone(i)
       s_dayavg_wspd_stime(i)     =s_dayavg_common_stime(i)
       s_dayavg_wspd_timezone(i)  =s_dayavg_common_timezone(i)
       s_daytot_ppt_stime(i)      =s_dayavg_common_stime(i)
       s_daytot_ppt_timezone(i)   =s_dayavg_common_timezone(i)
       s_daytot_snoacc_stime(i)   =s_dayavg_common_stime(i)
       s_daytot_snoacc_timezone(i)=s_dayavg_common_timezone(i)

       s_dayavg_airtk_stime(i)    =s_dayavg_common_stime(i)
       s_dayavg_airtk_timezone(i) =s_dayavg_common_timezone(i)
       s_dayavg_slpres_stime(i)   =s_dayavg_common_stime(i)
       s_dayavg_slpres_timezone(i)=s_dayavg_common_timezone(i)
      ENDDO
c************************************************************************
c************************************************************************
c     Find separate times for airt_max & airt_min

      DO i=1,l_prod
       s_date_single=s_day_date(i)
       s_year =s_date_single(1:4)
       s_month=s_date_single(5:6)
       s_day  =s_date_single(7:8)

c      Convert date to float
       s_test4       =TRIM(s_year)
       READ(s_test4,*) f_test
       f_year        =f_test

       s_test4       =TRIM(s_month)
       READ(s_test4,*) f_test
       f_month       =f_test

       s_test4       =TRIM(s_day)
       READ(s_test4,*) f_test
       f_day         =f_test
c******
c      Local solar time option

       IF (f_year.LT.1987.0) THEN

        s_time_single='2100'  !s_dayavg_airt_stime(i)
        s_hour  =s_time_single(1:2)
        s_minute=s_time_single(3:4)

        s_test2       =TRIM(s_hour)
        READ(s_test2,*) f_test
        f_hour        =f_test

        s_test2       =TRIM(s_minute)
        READ(s_test2,*) f_test
        f_minute      =f_test

        f_decihour=f_hour+f_minute/60.0
        f_decihour_utc=f_decihour-f_decihour_shift
        i_wholehour_utc=INT(f_decihour_utc)
        f_deciminute_utc=
     +    60.0*(f_decihour_utc-FLOAT(i_wholehour_utc))
        i_wholeminute_utc=INT(f_deciminute_utc)
        f_decisecond_utc=
     +    60.0*(f_deciminute_utc-FLOAT(i_wholeminute_utc))
        i_wholesecond_utc=INT(f_decisecond_utc)

        i_test=i_wholehour_utc
        WRITE(s_test2,'(i2)') i_test
        IF (i_test.GE.10) THEN 
         s_wholehour_utc=ADJUSTL(s_test2)
        ENDIF
        IF (i_test.LT.10) THEN 
         s_wholehour_utc='0'//ADJUSTL(s_test2)
        ENDIF

        i_test=i_wholeminute_utc
        WRITE(s_test2,'(i2)') i_test
        IF (i_test.GE.10) THEN 
         s_wholeminute_utc=ADJUSTL(s_test2)
        ENDIF
        IF (i_test.LT.10) THEN 
         s_wholeminute_utc='0'//ADJUSTL(s_test2)
        ENDIF

        i_test=i_wholesecond_utc
        WRITE(s_test2,'(i2)') i_test
        IF (i_test.GE.10) THEN 
         s_wholesecond_utc=ADJUSTL(s_test2)
        ENDIF
        IF (i_test.LT.10) THEN 
         s_wholesecond_utc='0'//ADJUSTL(s_test2)
        ENDIF

        s_dayavg_common2_stime(i)   =
     + s_wholehour_utc//':'//s_wholeminute_utc//':'//s_wholesecond_utc
        s_dayavg_common2_timezone(i)='+0000'

c        print*,'lst option',i,s_dayavg_common2_stime(i),
c     +    s_dayavg_common2_timezone(i)
c        CALL SLEEP(1)

       ENDIF

c      Middle European time option
       IF (f_year.GE.1987.0) THEN

        s_time_single='2130'  !s_dayavg_airt_stime(i)
        s_hour  =s_time_single(1:2)
        s_minute=s_time_single(3:4)

        s_test2       =TRIM(s_hour)
        READ(s_test2,*) f_test
        f_hour        =f_test

        s_test2       =TRIM(s_minute)
        READ(s_test2,*) f_test
        f_minute      =f_test

        f_decihour=f_hour+f_minute/60.0
        f_decihour_utc=f_decihour-1.0      !shift 1h from MEZ to UTZ
        i_wholehour_utc=INT(f_decihour_utc)
        f_deciminute_utc=60.0*(f_decihour_utc-FLOAT(i_wholehour_utc))
        i_wholeminute_utc=INT(f_deciminute_utc)
        f_decisecond_utc=
     +    60.0*(f_deciminute_utc-FLOAT(i_wholeminute_utc))
        i_wholesecond_utc=INT(f_decisecond_utc)

        i_test=i_wholehour_utc
        WRITE(s_test2,'(i2)') i_test
        IF (i_test.GE.10) THEN 
         s_wholehour_utc=ADJUSTL(s_test2)
        ENDIF
        IF (i_test.LT.10) THEN 
         s_wholehour_utc='0'//ADJUSTL(s_test2)
        ENDIF

        i_test=i_wholeminute_utc
        WRITE(s_test2,'(i2)') i_test
        IF (i_test.GE.10) THEN 
         s_wholeminute_utc=ADJUSTL(s_test2)
        ENDIF
        IF (i_test.LT.10) THEN 
         s_wholeminute_utc='0'//ADJUSTL(s_test2)
        ENDIF

        i_test=i_wholesecond_utc
        WRITE(s_test2,'(i2)') i_test
        IF (i_test.GE.10) THEN 
         s_wholesecond_utc=ADJUSTL(s_test2)
        ENDIF
        IF (i_test.LT.10) THEN 
         s_wholesecond_utc='0'//ADJUSTL(s_test2)
        ENDIF

        s_dayavg_common2_stime(i)   =
     + s_wholehour_utc//':'//s_wholeminute_utc//':'//s_wholesecond_utc
        s_dayavg_common2_timezone(i)='+0000'     !hardwired to UTC

c        print*,'MEZ option',i,s_dayavg_common2_stime(i),
c     +    s_dayavg_common2_timezone(i)
c        CALL SLEEP(1)

       ENDIF
      ENDDO

c     Assign values from common variables
      DO i=1,l_prod
       s_daymax_airt_stime(i)   =s_dayavg_common2_stime(i)
       s_daymax_airt_timezone(i)=s_dayavg_common2_timezone(i)
       s_daymin_airt_stime(i)   =s_dayavg_common2_stime(i)
       s_daymin_airt_timezone(i)=s_dayavg_common2_timezone(i)
      ENDDO
c************************************************************************
c      print*,'s_dayavg_airt_stime=',(s_dayavg_airt_stime(i),i=1,3)
c      print*,'s_dayavg_airt_timezone=',(s_dayavg_airt_timezone(i),i=1,3)

c      print*,'just leaving find_timestamp'

      RETURN
      END