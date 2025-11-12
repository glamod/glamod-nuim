c     Convert date-time string to jtime
c     AJ_Kettle, 18Feb2021

      SUBROUTINE get_jtime_from_datetime20210218(
     +     s_date_reconstruct_yyyy_mm_dd,s_time_reconstruct_hh_mm_ss,
     +     d_obs_jtime)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into subroutine

      CHARACTER(*)        :: s_date_reconstruct_yyyy_mm_dd
      CHARACTER(*)        :: s_time_reconstruct_hh_mm_ss               

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

c      print*,'date=',s_date_reconstruct_yyyy_mm_dd
c      print*,'time=',s_time_reconstruct_hh_mm_ss   

      s_year    =s_date_reconstruct_yyyy_mm_dd(1:4)
      s_month   =s_date_reconstruct_yyyy_mm_dd(6:7)
      s_day     =s_date_reconstruct_yyyy_mm_dd(9:10)
      s_hour    =s_time_reconstruct_hh_mm_ss(1:2)
      s_minute  =s_time_reconstruct_hh_mm_ss(4:5)
      s_second  =s_time_reconstruct_hh_mm_ss(7:8)

      s_date_new=s_day//'/'//s_month//'/'//s_year
      s_time_new=s_hour//'/'//s_minute//'/'//s_second

      CALL str_to_dt_pvwave3(d_obs_jtime,
     +  s_date_new,s_time_new,2,-1)

c      print*,'d_obs_jtime=',d_obs_jtime
c      print*,'s_date_new',s_date_new
c      print*,'s_time_new',s_time_new

c      STOP 'get_jtime_from_datetime20210218'

      RETURN
      END
