c     Subroutine to convert USAF date/time the
c     AJ_KETTLE, Feb7/2018
c     22Jan2020: modified for USAF update files

      SUBROUTINE std_datetime_fmt2(s_ncdc_ob_time_single,s_date,s_time)

      IMPLICIT NONE
c************************************************************************
      INTEGER             :: i,j,k,ii,jj,kk

      CHARACTER(LEN=14)   :: s_ncdc_ob_time_single
      CHARACTER(LEN=10)   :: s_date 
      CHARACTER(LEN=10)   :: s_time

      CHARACTER(LEN=4)    :: s_year
      CHARACTER(LEN=2)    :: s_month
      CHARACTER(LEN=2)    :: s_day
      CHARACTER(LEN=2)    :: s_hour
      CHARACTER(LEN=2)    :: s_minute
      CHARACTER(LEN=2)    :: s_second
c************************************************************************
c      print*,'just inside std_datetime_fmt'

c      print*,'s_ncdc_ob_time_single=',s_ncdc_ob_time_single

      s_day   =s_ncdc_ob_time_single(1:2)
      s_month =s_ncdc_ob_time_single(3:4)
      s_year  =s_ncdc_ob_time_single(5:8)

      s_hour  =s_ncdc_ob_time_single(9:10)
      s_minute=s_ncdc_ob_time_single(11:12)
      s_second=s_ncdc_ob_time_single(13:14)

      s_date=s_day//'/'//s_month//'/'//s_year
      s_time=s_hour//':'//s_minute//':'//s_second

c      print*,'s_date=',s_date
c      print*,'s_time=',s_time

c      CALL SLEEP(1)      
c************************************************************************
c      print*,'just leaving std_datetime_fmt'

      RETURN
      END