c     Subroutine to process re_ncdc_ob_time
c     AJ_KETTLE, Feb09/2018
c     subroutine modified for wind extractor
c     14Mar2020: adapted for USAF update

      SUBROUTINE time_processor(
     +  l_rgh_datalines,l_data,s_vec_ncdc_ob_time,
     +  d_vec_jtime,s_vec_date_dd_mm_yyyy,s_vec_time_hh_mm_ss)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into subroutine

      INTEGER             :: l_rgh_datalines
      INTEGER             :: l_data

      CHARACTER(LEN=14)   :: s_vec_ncdc_ob_time(l_rgh_datalines)
      DOUBLE PRECISION    :: d_vec_jtime(l_rgh_datalines)

      CHARACTER(LEN=10)   :: s_vec_date_dd_mm_yyyy(l_rgh_datalines) 
      CHARACTER(LEN=8)    :: s_vec_time_hh_mm_ss(l_rgh_datalines)
c*****
c     Variables used within subroutine
      INTEGER             :: i,j,k,ii,jj,kk

      CHARACTER(LEN=14)   :: s_ncdc_ob_time_single
      CHARACTER(LEN=10)   :: s_date 
      CHARACTER(LEN=8)    :: s_time
      DOUBLE PRECISION    :: d_jday

      DOUBLE PRECISION    :: d_jday_test1,d_jday_test2

      INTEGER             :: i_day_min
c************************************************************************
c      print*,'just inside time processor'
c      print*,'ll_rec=',ll_rec

      DO i=1,l_data
       s_ncdc_ob_time_single=s_vec_ncdc_ob_time(i)
       CALL std_datetime_fmt(s_ncdc_ob_time_single,s_date,s_time)

       s_vec_date_dd_mm_yyyy(i)=s_date 
       s_vec_time_hh_mm_ss(i)  =s_time

c      Find julian time
       call str_to_jtime_pvwave(d_jday,
     +  s_vec_date_dd_mm_yyyy(i),s_vec_time_hh_mm_ss(i),2,-1)

       d_vec_jtime(i)=d_jday
      ENDDO
c************************************************************************
      GOTO 10

c     Test field
      CALL str_to_jtime_pvwave(d_jday_test1,
     +  '15/09/1752','00:00:00',2,-1)

      CALL str_to_jtime_pvwave(d_jday_test2,
     +  '15/04/1992','08:00:00',2,-1)

 10   CONTINUE

c      print*,'tester=',d_jday_test1,d_jday_test2

c     Test each of the fields
c      CALL find_minmax_datetime(l_rgh3,ll_rec,s_rec_date,s_rec_time)
c************************************************************************
c      print*,'just leaving time processor'

c      STOP 'time_processor'

      RETURN
      END
