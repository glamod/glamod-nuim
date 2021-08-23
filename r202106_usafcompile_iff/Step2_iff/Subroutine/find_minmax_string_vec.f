c     Subroutine to find min/max of string vectors
c     AJ_Kettle, 26Feb2019
c     14Mar2020: adapted for USAF update

      SUBROUTINE find_minmax_string_vec(
     +  l_rgh_datalines,l_data,
     +  s_vec_platformid,s_vec_networktype,
     +  s_vec_ncdc_ob_time,s_vec_reporttypecode,
     +  s_vec_latitude,s_vec_longitude,s_vec_platformheight,
     +  s_vec_windspeed_ms,
     +  s_vec_sealevelpressure_hpa,s_vec_stationpressure_hpa,

     +  i_minmax_strlen_platformid,i_minmax_strlen_networktype,
     +  i_minmax_strlen_ncdc_ob_time,i_minmax_strlen_reporttypecode,
     +  i_minmax_strlen_latitude,i_minmax_strlen_longitude,
     +  i_minmax_strlen_platformheight,i_minmax_strlen_windspeed,
     +  i_minmax_strlen_sealevelpressure,
     +  i_minmax_strlen_stationpressure)

      IMPLICIT NONE
c************************************************************************
c     Declare variables passed into program

      INTEGER             :: l_rgh_datalines
      INTEGER             :: l_data

      CHARACTER(LEN=*)    :: s_vec_platformid(l_rgh_datalines)
      CHARACTER(LEN=*)    :: s_vec_networktype(l_rgh_datalines)
      CHARACTER(LEN=*)    :: s_vec_ncdc_ob_time(l_rgh_datalines)
      CHARACTER(LEN=*)    :: s_vec_reporttypecode(l_rgh_datalines)
      CHARACTER(LEN=*)    :: s_vec_latitude(l_rgh_datalines)
      CHARACTER(LEN=*)    :: s_vec_longitude(l_rgh_datalines)
      CHARACTER(LEN=*)    :: s_vec_platformheight(l_rgh_datalines)
      CHARACTER(LEN=*)    :: s_vec_windspeed_ms(l_rgh_datalines)
      CHARACTER(LEN=*)    :: s_vec_sealevelpressure_hpa(l_rgh_datalines)
      CHARACTER(LEN=*)    :: s_vec_stationpressure_hpa(l_rgh_datalines)

      INTEGER             :: i_minmax_strlen_platformid(2)
      INTEGER             :: i_minmax_strlen_networktype(2)
      INTEGER             :: i_minmax_strlen_ncdc_ob_time(2)
      INTEGER             :: i_minmax_strlen_reporttypecode(2)
      INTEGER             :: i_minmax_strlen_latitude(2)
      INTEGER             :: i_minmax_strlen_longitude(2)
      INTEGER             :: i_minmax_strlen_platformheight(2)
      INTEGER             :: i_minmax_strlen_windspeed(2)
      INTEGER             :: i_minmax_strlen_sealevelpressure(2)
      INTEGER             :: i_minmax_strlen_stationpressure(2)
c*****
c     Variables used within program

      INTEGER             :: i,j,k,ii,jj,kk

c************************************************************************
c      print*,'just entered find_minmax_string_vec'

c      print*,'l_data=',l_data

c     Initialize min value
      i_minmax_strlen_platformid(1)       =+10000
      i_minmax_strlen_networktype(1)      =+10000
      i_minmax_strlen_ncdc_ob_time(1)     =+10000
      i_minmax_strlen_reporttypecode(1)   =+10000
      i_minmax_strlen_latitude(1)         =+10000
      i_minmax_strlen_longitude(1)        =+10000
      i_minmax_strlen_platformheight(1)   =+10000
      i_minmax_strlen_windspeed(1)        =+10000
      i_minmax_strlen_sealevelpressure(1) =+10000
      i_minmax_strlen_stationpressure(1)  =+10000

      i_minmax_strlen_platformid(2)       =-10000
      i_minmax_strlen_networktype(2)      =-10000
      i_minmax_strlen_ncdc_ob_time(2)     =-10000
      i_minmax_strlen_reporttypecode(2)   =-10000
      i_minmax_strlen_latitude(2)         =-10000
      i_minmax_strlen_longitude(2)        =-10000
      i_minmax_strlen_platformheight(2)   =-10000
      i_minmax_strlen_windspeed(2)        =-10000
      i_minmax_strlen_sealevelpressure(2) =-10000
      i_minmax_strlen_stationpressure(2)  =-10000

      DO i=1,l_data

c      Find min
       i_minmax_strlen_platformid(1)=
     +   MIN(i_minmax_strlen_platformid(1),
     +   LEN_TRIM(s_vec_platformid(i)))
       i_minmax_strlen_networktype(1)=
     +   MIN(i_minmax_strlen_networktype(1),
     +   LEN_TRIM(s_vec_networktype(i)))
       i_minmax_strlen_ncdc_ob_time(1)=
     +   MIN(i_minmax_strlen_ncdc_ob_time(1),
     +   LEN_TRIM(s_vec_ncdc_ob_time(i)))
       i_minmax_strlen_reporttypecode(1)=
     +   MIN(i_minmax_strlen_reporttypecode(1),
     +   LEN_TRIM(s_vec_reporttypecode(i)))
       i_minmax_strlen_latitude(1)=
     +   MIN(i_minmax_strlen_latitude(1),
     +   LEN_TRIM(s_vec_latitude(i)))
       i_minmax_strlen_longitude(1)=
     +   MIN(i_minmax_strlen_longitude(1),
     +   LEN_TRIM(s_vec_longitude(i)))
       i_minmax_strlen_platformheight(1)=
     +   MIN(i_minmax_strlen_platformheight(1),
     +   LEN_TRIM(s_vec_platformheight(i)))
       i_minmax_strlen_windspeed(1)=
     +   MIN(i_minmax_strlen_windspeed(1),
     +   LEN_TRIM(s_vec_windspeed_ms(i)))
       i_minmax_strlen_sealevelpressure(1)=
     +   MIN(i_minmax_strlen_sealevelpressure(1),
     +   LEN_TRIM(s_vec_sealevelpressure_hpa(i)))
       i_minmax_strlen_stationpressure(1)=
     +   MIN(i_minmax_strlen_stationpressure(1),
     +   LEN_TRIM(s_vec_stationpressure_hpa(i)))

c      Find max
       i_minmax_strlen_platformid(2)=
     +   MAX(i_minmax_strlen_platformid(2),
     +   LEN_TRIM(s_vec_platformid(i)))
       i_minmax_strlen_networktype(2)=
     +   MAX(i_minmax_strlen_networktype(2),
     +   LEN_TRIM(s_vec_networktype(i)))
       i_minmax_strlen_ncdc_ob_time(2)=
     +   MAX(i_minmax_strlen_ncdc_ob_time(2),
     +   LEN_TRIM(s_vec_ncdc_ob_time(i)))
       i_minmax_strlen_reporttypecode(2)=
     +   MAX(i_minmax_strlen_reporttypecode(2),
     +   LEN_TRIM(s_vec_reporttypecode(i)))
       i_minmax_strlen_latitude(2)=
     +   MAX(i_minmax_strlen_latitude(2),
     +   LEN_TRIM(s_vec_latitude(i)))
       i_minmax_strlen_longitude(2)=
     +   MAX(i_minmax_strlen_longitude(2),
     +   LEN_TRIM(s_vec_longitude(i)))
       i_minmax_strlen_platformheight(2)=
     +   MAX(i_minmax_strlen_platformheight(2),
     +   LEN_TRIM(s_vec_platformheight(i)))
       i_minmax_strlen_windspeed(2)=
     +   MAX(i_minmax_strlen_windspeed(2),
     +   LEN_TRIM(s_vec_windspeed_ms(i)))
       i_minmax_strlen_sealevelpressure(2)=
     +   MAX(i_minmax_strlen_sealevelpressure(2),
     +   LEN_TRIM(s_vec_sealevelpressure_hpa(i)))
       i_minmax_strlen_stationpressure(2)=
     +   MAX(i_minmax_strlen_stationpressure(2),
     +   LEN_TRIM(s_vec_stationpressure_hpa(i)))
      ENDDO

c      print*,'platformid=',(i_minmax_strlen_platformid(i),i=1,2)
c      print*,'networktype=',(i_minmax_strlen_networktype(i),i=1,2)
c      print*,'ncdc_ob_time=',(i_minmax_strlen_ncdc_ob_time(i),i=1,2)
c      print*,'reporttypecode',(i_minmax_strlen_reporttypecode(i),i=1,2)
c      print*,'latitude=',(i_minmax_strlen_latitude(i),i=1,2)
c      print*,'longitude=',(i_minmax_strlen_longitude(i),i=1,2)
c      print*,'platformheight=',(i_minmax_strlen_platformheight(i),i=1,2)
c      print*,'windspeed=',(i_minmax_strlen_windspeed(i),i=1,2)
c      print*,'sealevelpressure=',
c     +  (i_minmax_strlen_sealevelpressure(i),i=1,2)
c      print*,'stationpressure=',
c     +  (i_minmax_strlen_stationpressure(i),i=1,2)

c      print*,'just leaving find_minmax_string_vec'

c      STOP 'find_minmax_string_vec'

      RETURN
      END
