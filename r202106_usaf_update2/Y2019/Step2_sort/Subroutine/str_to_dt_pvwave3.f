c     Subroutine to convert date to jultime
c     AJ_Kettle, Aug22/2017
c     22Feb2020: applied to USAF update files

      SUBROUTINE str_to_dt_pvwave3(d_jday,
     +  s_date,s_time,i_datefmt,i_timefmt)

      IMPLICIT NONE
c********************************************
      DOUBLE PRECISION    :: d_jday
      DOUBLE PRECISION    :: d_jday_pre
      DOUBLE PRECISION    :: d_jday_ref

      CHARACTER(LEN=10)   :: s_date
      CHARACTER(LEN=8)    :: s_time
      INTEGER             :: i_datefmt,i_timefmt

      CHARACTER(LEN=4)    :: s_year
      CHARACTER(LEN=2)    :: s_mon
      CHARACTER(LEN=2)    :: s_day
      CHARACTER(LEN=2)    :: s_hour
      CHARACTER(LEN=2)    :: s_min
      CHARACTER(LEN=2)    :: s_sec

      REAL                :: f_year,f_mon,f_day
      REAL                :: f_hour,f_min,f_sec

      REAL                :: f_year_ref,f_mon_ref,f_day_ref
      REAL                :: f_hour_ref,f_min_ref,f_sec_ref
c********************************************
c      print*,'s_date=',TRIM(s_date)//'x'//s_time

c     Get different date elements
      IF (i_datefmt.EQ.1) THEN    !US format
       s_mon =s_date(1:2)
       s_day =s_date(4:5)
       s_year=s_date(7:10)
       GOTO 2
      ENDIF
      IF (i_datefmt.EQ.2) THEN    !European format
       s_day =s_date(1:2)
       s_mon =s_date(4:5)
       s_year=s_date(7:10)
       GOTO 2
      ENDIF
      print*,'unrecognized date flag'
2     CONTINUE

      IF (i_timefmt.EQ.-1) THEN  
       s_hour=s_time(1:2)
       s_min =s_time(4:5)
       s_sec =s_time(7:8)
       GOTO 4
      ENDIF
      print*,'unrecognized time flag'
      STOP 'str_to_dt_pvwave3'
4     CONTINUE

      READ(s_day,*)  f_day
      READ(s_mon,*)  f_mon
      READ(s_year,*) f_year
      READ(s_hour,*) f_hour
      READ(s_min,*)  f_min
      READ(s_sec,*)  f_sec

      d_jday_pre=DBLE( 367.0*f_year-
     +   INT(7.0*(f_year+INT((f_mon+9.0)/12.0))/4.0)-
     +   INT(3.0*(INT((f_year+INT((f_mon-9.0)/7.0))/100.0)+1.0)/4.0)+
     +   INT(275.0*f_mon/9.0)+f_day ) +
     +   DBLE(100000.0)+
     +   DBLE(f_hour/24.0)+DBLE(f_min/(24.0*60.0))+
     +   DBLE(f_sec/(24.0*3600.0))
c*********************************************
c     Find reference

      f_day_ref =14.0
      f_mon_ref =9.0
      f_year_ref=1752.0
      f_hour_ref=0.0
      f_min_ref =0.0
      f_sec_ref =0.0

      d_jday_ref=DBLE( 367.0*f_year_ref-
     +   INT(7.0*(f_year_ref+INT((f_mon_ref+9.0)/12.0))/4.0)-
     +   INT(3.0*(INT((f_year_ref+
     +     INT((f_mon_ref-9.0)/7.0))/100.0)+1.0)/4.0)+
     +   INT(275.0*f_mon_ref/9.0)+f_day_ref ) +
     +   DBLE(100000.0)+
     +   DBLE(f_hour_ref/24.0)+DBLE(f_min_ref/(24.0*60.0))+
     +   DBLE(f_sec_ref/(24.0*3600.0))
c*********************************************
      d_jday=d_jday_pre-d_jday_ref

c      print*,'d_jday...',d_jday_pre,d_jday_ref,d_jday
c      CALL SLEEP(1)
c*********************************************
      RETURN
      END
