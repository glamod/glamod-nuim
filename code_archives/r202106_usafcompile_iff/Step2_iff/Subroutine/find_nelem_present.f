c     Subroutine to count number of nonzeroe entries in fields
c     AJ_Kettle, 26Feb2019
c     14Mar2020: adapted for USAF update

      SUBROUTINE find_nelem_present(
     +  l_rgh_datalines,l_data,
     +  s_vec_platformid,s_vec_networktype,
     +  s_vec_ncdc_ob_time,s_vec_reporttypecode,
     +  s_vec_latitude,s_vec_longitude,s_vec_platformheight,
     +  s_vec_windspeed_ms,
     +  s_vec_sealevelpressure_hpa,s_vec_stationpressure_hpa,

     +  i_cnt_strlen_platformid,i_cnt_strlen_networktype,
     +  i_cnt_strlen_ncdc_ob_time,i_cnt_strlen_reporttypecode,
     +  i_cnt_strlen_latitude,i_cnt_strlen_longitude,
     +  i_cnt_strlen_platformheight,i_cnt_strlen_windspeed,
     +  i_cnt_strlen_sealevelpressure,i_cnt_strlen_stationpressure)

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

      INTEGER             :: i_cnt_strlen_platformid
      INTEGER             :: i_cnt_strlen_networktype
      INTEGER             :: i_cnt_strlen_ncdc_ob_time
      INTEGER             :: i_cnt_strlen_reporttypecode
      INTEGER             :: i_cnt_strlen_latitude
      INTEGER             :: i_cnt_strlen_longitude
      INTEGER             :: i_cnt_strlen_platformheight
      INTEGER             :: i_cnt_strlen_windspeed
      INTEGER             :: i_cnt_strlen_sealevelpressure
      INTEGER             :: i_cnt_strlen_stationpressure
c*****
c     Variables used within program

      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: i_len
c************************************************************************
c      print*,'just entered find_nelem_present'

c     Initialize to 0
      i_cnt_strlen_platformid      =0
      i_cnt_strlen_networktype     =0
      i_cnt_strlen_ncdc_ob_time    =0
      i_cnt_strlen_reporttypecode  =0
      i_cnt_strlen_latitude        =0
      i_cnt_strlen_longitude       =0
      i_cnt_strlen_platformheight  =0
      i_cnt_strlen_windspeed       =0
      i_cnt_strlen_sealevelpressure=0
      i_cnt_strlen_stationpressure =0

      DO i=1,l_data 

       i_len=LEN_TRIM(s_vec_platformid(i))
       IF (i_len.GT.0) THEN 
        i_cnt_strlen_platformid      =i_cnt_strlen_platformid+1
       ENDIF

       i_len=LEN_TRIM(s_vec_networktype(i))
       IF (i_len.GT.0) THEN 
        i_cnt_strlen_networktype     =i_cnt_strlen_networktype+1
       ENDIF

       i_len=LEN_TRIM(s_vec_ncdc_ob_time(i))
       IF (i_len.GT.0) THEN 
        i_cnt_strlen_ncdc_ob_time    =i_cnt_strlen_ncdc_ob_time+1
       ENDIF

       i_len=LEN_TRIM(s_vec_reporttypecode(i))
       IF (i_len.GT.0) THEN 
        i_cnt_strlen_reporttypecode  =i_cnt_strlen_reporttypecode+1
       ENDIF

       i_len=LEN_TRIM(s_vec_latitude(i))
       IF (i_len.GT.0) THEN 
        i_cnt_strlen_latitude        =i_cnt_strlen_latitude+1
       ENDIF

       i_len=LEN_TRIM(s_vec_longitude(i))
       IF (i_len.GT.0) THEN 
        i_cnt_strlen_longitude       =i_cnt_strlen_longitude+1
       ENDIF

       i_len=LEN_TRIM(s_vec_platformheight(i))
       IF (i_len.GT.0) THEN 
        i_cnt_strlen_platformheight  =i_cnt_strlen_platformheight+1
       ENDIF

       i_len=LEN_TRIM(s_vec_windspeed_ms(i))
       IF (i_len.GT.0) THEN 
        i_cnt_strlen_windspeed       =i_cnt_strlen_windspeed+1
       ENDIF

       i_len=LEN_TRIM(s_vec_sealevelpressure_hpa(i))
       IF (i_len.GT.0) THEN 
        i_cnt_strlen_sealevelpressure=i_cnt_strlen_sealevelpressure+1
       ENDIF

       i_len=LEN_TRIM(s_vec_stationpressure_hpa(i))
       IF (i_len.GT.0) THEN 
        i_cnt_strlen_stationpressure =i_cnt_strlen_stationpressure+1
       ENDIF

      ENDDO

c      print*,'just leaving find_nelem_present'

      RETURN
      END
