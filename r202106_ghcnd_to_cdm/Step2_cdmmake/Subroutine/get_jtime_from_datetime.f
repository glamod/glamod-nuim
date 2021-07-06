c     Subroutine convert date time string to jtime
c     AJ_Kettle, 11Feb2021

      SUBROUTINE get_jtime_from_datetime(s_obs_date_time,
     +     d_obs_jtime)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into subroutine

      CHARACTER(*)        :: s_obs_date_time                  

      DOUBLE PRECISION    :: d_obs_jtime

c*****
c     Variables used within subroutine

      INTEGER             :: i,j,k,ii,jj,kk

      CHARACTER(LEN=4)    :: s_year
      CHARACTER(LEN=2)    :: s_month
      CHARACTER(LEN=2)    :: s_day
      CHARACTER(LEN=2)    :: s_hour
      CHARACTER(LEN=2)    :: s_minute
      CHARACTER(LEN=2)    :: s_second

      CHARACTER(LEN=10)   :: s_date_new 
      CHARACTER(LEN=8)    :: s_time_new
c************************************************************************

      s_year    =s_obs_date_time(1:4)
      s_month   =s_obs_date_time(6:7)
      s_day     =s_obs_date_time(9:10)
      s_hour    =s_obs_date_time(12:13)
      s_minute  =s_obs_date_time(15:16)
      s_second  =s_obs_date_time(18:19)

      s_date_new=s_day//'/'//s_month//'/'//s_year
      s_time_new=s_hour//'/'//s_minute//'/'//s_second

      CALL str_to_dt_pvwave3(d_obs_jtime,
     +  s_date_new,s_time_new,2,-1)

c      print*,'s_date_new=',s_date_new
c      print*,'s_time_new=',s_time_new
c      print*,'d_obs_jtime=',d_obs_jtime

      RETURN
      END
