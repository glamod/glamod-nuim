c     Subroutine to find time interval between successive measurements
c     AJ_Kettle, Dec6/2017

      SUBROUTINE find_time_interval(f_ndflag,l_mlent,j_sd,
     +  st_sd_year,st_sd_month,st_sd_day,st_sd_timeutc_hh_mm_ss,
     +  f_deltime_s)

      IMPLICIT NONE
c************************************************************************
      REAL                :: f_ndflag

      INTEGER             :: l_mlent
      INTEGER             :: j_sd

      CHARACTER(LEN=4)    :: st_sd_year(l_mlent)
      CHARACTER(LEN=2)    :: st_sd_month(l_mlent) 
      CHARACTER(LEN=2)    :: st_sd_day(l_mlent) 
      CHARACTER(LEN=8)    :: st_sd_timeutc_hh_mm_ss(l_mlent)

      DOUBLE PRECISION    :: d_jday,d_jday_vec(l_mlent)

      INTEGER             :: i,j,k,ii,jj,kk

      CHARACTER(LEN=4)    :: s_year
      CHARACTER(LEN=2)    :: s_month
      CHARACTER(LEN=2)    :: s_day
      CHARACTER(LEN=2)    :: s_hour
      CHARACTER(LEN=2)    :: s_minute
      CHARACTER(LEN=2)    :: s_second
      CHARACTER(LEN=8)    :: s_time_single

      REAL                :: f_year
      REAL                :: f_month
      REAL                :: f_day
      REAL                :: f_hour
      REAL                :: f_minute
      REAL                :: f_second

      REAL                :: f_test

      REAL                :: f_deltime_s(l_mlent)
      REAL                :: f_min_deltime_s
      REAL                :: f_max_deltime_s
c************************************************************************
c      print*,'just entered find_time_interval'

c     Find julian time for each record
      DO i=1,j_sd

       s_year        =st_sd_year(i)
       s_month       =st_sd_month(i) 
       s_day         =st_sd_day(i) 
 
       s_time_single =st_sd_timeutc_hh_mm_ss(i)
       s_hour        =s_time_single(1:2)
       s_minute      =s_time_single(4:5)
       s_second      =s_time_single(7:8)

c      Convert to floats
       READ(s_year,*) f_test
       f_year      =f_test
       READ(s_month,*) f_test
       f_month     =f_test
       READ(s_day,*) f_test
       f_day       =f_test
       READ(s_hour,*) f_test
       f_hour      =f_test
       READ(s_minute,*) f_test
       f_minute    =f_test
       READ(s_second,*) f_test
       f_second    =f_test

       d_jday=DBLE( 367.0*f_year-
     +   INT(7.0*(f_year+INT((f_month+9.0)/12.0))/4.0)-
     +   INT(3.0*(INT((f_year+INT((f_month-9.0)/7.0))/100.0)+1.0)/4.0)+
     +   INT(275.0*f_month/9.0)+f_day ) +
     +   DBLE(100000.0)+
     +   DBLE(f_hour/24.0)+DBLE(f_minute/(24.0*60.0))+
     +   DBLE(f_second/(24.0*3600.0))

       d_jday_vec(i)=d_jday

c       print*,'d_jday=',d_jday       
c       print*,'year=',  s_year,f_year
c       print*,'month=', s_month,f_month
c       print*,'day=',   s_day,f_day
c       print*,'hour=',  s_hour,f_hour
c       print*,'minute=',s_minute,f_minute
c       print*,'second=',s_second,f_second
c       CALL SLEEP(1)

      ENDDO

c     Find time interval
c      print*,'just before time interval calculator'
      ii=0
      jj=0
c     Initialize deltime variable
      DO i=1,j_sd
       f_deltime_s(i)=f_ndflag
      ENDDO
      DO i=1,j_sd-1
       f_deltime_s(i+1)=(d_jday_vec(i+1)-d_jday_vec(i))*3600.0*24.0

c      Place ndflag if deltime>0.5days
       IF (f_deltime_s(i+1).GT.0.5*3600.0*24.0) THEN 
        f_deltime_s(i+1)=f_ndflag
        ii=ii+1
       ENDIF
       IF (.NOT.(f_deltime_s(i+1).GT.0.5*3600.0*24.0)) THEN 
        jj=jj+1
       ENDIF

c       print*,'f_deltime_s(i+1)=',i,f_deltime_s(i+1)
c       CALL SLEEP(1)
      ENDDO

c      print*,'f_deltime_s=',(f_deltime_s(i),i=1,5)
c      print*,'number ndflag deltime,j_sd=',ii,j_sd
c      print*,'number good deltime,  j_sd=',jj,j_sd

c     Find min & max of time interval
      f_min_deltime_s=50000.0
      f_max_deltime_s=0.0
      DO i=2,j_sd
       f_min_deltime_s=MIN(f_min_deltime_s,f_deltime_s(i))
       f_max_deltime_s=MAX(f_max_deltime_s,f_deltime_s(i))
      ENDDO

c      print*,'f_min_deltime_s=',f_min_deltime_s
c      print*,'f_max_deltime_s=',f_max_deltime_s

c      print*,'f_min_deltime_d=',f_min_deltime_s/(24.0*3600.0)
c      print*,'f_max_deltime_d=',f_max_deltime_s/(24.0*3600.0)
c************************************************************************
c      print*,'just leaving find_time_interval'
c      CALL SLEEP(5)

      RETURN
      END