c     Subroutine to convert variables
c     AJ_Kettle, 26Feb2019
c     04Jul2019: modified to include all 6 variables
c     14Mar2020: modified for USAF update

      SUBROUTINE convert_variables2(f_ndflag,
     +  l_rgh_datalines,l_data,
     +  s_vec_latitude,s_vec_longitude,s_vec_platformheight,
     +  s_vec_winddirection_deg,s_vec_windspeed_ms,
     +  s_vec_airtemperature_c,s_vec_dewpointtemperature_c,
     +  s_vec_sealevelpressure_hpa,s_vec_stationpressure_hpa,

     +  f_vec_latitude,f_vec_longitude,f_vec_platformheight,
     +  f_vec_winddirection_deg,f_vec_windspeed_ms,
     +  f_vec_airtemperature_c,f_vec_dewpointtemperature_c,
     +  f_vec_sealevelpressure_hpa,f_vec_stationpressure_hpa)

c     +  s_vec_latitude,s_vec_longitude,s_vec_platformheight,
c     +  s_vec_windspeed_ms,
c     +  s_vec_sealevelpressure_hpa,s_vec_stationpressure_hpa,

c     +  f_vec_latitude,f_vec_longitude,f_vec_platformheight,
c     +  f_vec_windspeed_ms,
c     +  f_vec_sealevelpressure_hpa,f_vec_stationpressure_hpa)

      IMPLICIT NONE
c************************************************************************
c     Declare variables passed into program

      INTEGER             :: l_rgh_datalines
      INTEGER             :: l_data

      REAL                :: f_ndflag

      CHARACTER(LEN=*)    :: s_vec_latitude(l_rgh_datalines)
      CHARACTER(LEN=*)    :: s_vec_longitude(l_rgh_datalines)
      CHARACTER(LEN=*)    :: s_vec_platformheight(l_rgh_datalines)
      CHARACTER(LEN=*)    :: s_vec_winddirection_deg(l_rgh_datalines)
      CHARACTER(LEN=*)    :: s_vec_windspeed_ms(l_rgh_datalines)
      CHARACTER(LEN=*)    :: s_vec_airtemperature_c(l_rgh_datalines)
      CHARACTER(LEN=*)   :: s_vec_dewpointtemperature_c(l_rgh_datalines)
      CHARACTER(LEN=*)    :: s_vec_sealevelpressure_hpa(l_rgh_datalines)
      CHARACTER(LEN=*)    :: s_vec_stationpressure_hpa(l_rgh_datalines)

      REAL                :: f_vec_latitude(l_rgh_datalines)
      REAL                :: f_vec_longitude(l_rgh_datalines)
      REAL                :: f_vec_platformheight(l_rgh_datalines)
      REAL                :: f_vec_winddirection_deg(l_rgh_datalines)
      REAL                :: f_vec_windspeed_ms(l_rgh_datalines)
      REAL                :: f_vec_airtemperature_c(l_rgh_datalines)
      REAL               :: f_vec_dewpointtemperature_c(l_rgh_datalines)
      REAL                :: f_vec_sealevelpressure_hpa(l_rgh_datalines)
      REAL                :: f_vec_stationpressure_hpa(l_rgh_datalines)
c*****
c     Variables used within program

      INTEGER             :: i,j,k,ii,jj,kk

      INTEGER             :: i_len

      CHARACTER(LEN=100)  :: s_input
      REAL                :: f_output
      INTEGER             :: i_badflag
c************************************************************************
c      print*,'just inside convert_variables'

c     Do conversions
      DO i=1,l_data 
c*****
c      Initialize variables with ndflags
       f_vec_latitude(i)            =f_ndflag
       f_vec_longitude(i)           =f_ndflag
       f_vec_platformheight(i)      =f_ndflag
       f_vec_winddirection_deg(i)   =f_ndflag
       f_vec_windspeed_ms(i)        =f_ndflag
       f_vec_airtemperature_c(i)    =f_ndflag
       f_vec_dewpointtemperature_c(i)=f_ndflag
       f_vec_sealevelpressure_hpa(i)=f_ndflag
       f_vec_stationpressure_hpa(i) =f_ndflag    
c*****
c*****
c      Latitude
       s_input=s_vec_latitude(i)
       i_len=LEN_TRIM(s_input)
       IF (i_len.GT.0) THEN  
        CALL convert_single_string_to_float(s_input,f_ndflag,
     +    f_output,i_badflag)
         f_vec_latitude(i)=f_output
  
        IF (i_badflag.EQ.1) THEN
         print*,'bad latitude',s_input
         STOP 'convert_variables'
        ENDIF
       ENDIF
c*****
c      Longitude
       s_input=s_vec_longitude(i)
       i_len=LEN_TRIM(s_input)
       IF (i_len.GT.0) THEN  
        CALL convert_single_string_to_float(s_input,f_ndflag,
     +    f_output,i_badflag)
         f_vec_longitude(i)=f_output
  
        IF (i_badflag.EQ.1) THEN
         print*,'bad longitude',s_input
         STOP 'convert_variables'
        ENDIF
       ENDIF
c*****
c      Platformheight
       s_input=s_vec_platformheight(i)
       i_len=LEN_TRIM(s_input)
       IF (i_len.GT.0) THEN  
        CALL convert_single_string_to_float(s_input,f_ndflag,
     +    f_output,i_badflag)
         f_vec_platformheight(i)=f_output
  
        IF (i_badflag.EQ.1) THEN
         print*,'bad platformheight',s_input
         STOP 'convert_variables'
        ENDIF
       ENDIF
c*****
c      1. Winddirection
       s_input=s_vec_winddirection_deg(i)
       i_len=LEN_TRIM(s_input)
       IF (i_len.GT.0) THEN  
        CALL convert_single_string_to_float(s_input,f_ndflag,
     +   f_output,i_badflag)
         f_vec_winddirection_deg(i)=f_output
  
        IF (i_badflag.EQ.1) THEN
         print*,'bad winddirection',s_input
         STOP 'convert_variables'
        ENDIF
       ENDIF
c*****
c      2. Windspeed
       s_input=s_vec_windspeed_ms(i)
       i_len=LEN_TRIM(s_input)
       IF (i_len.GT.0) THEN  
        CALL convert_single_string_to_float(s_input,f_ndflag,
     +    f_output,i_badflag)
         f_vec_windspeed_ms(i)=f_output
  
        IF (i_badflag.EQ.1) THEN
         print*,'bad windspeed',s_input
         STOP 'convert_variables'
        ENDIF
       ENDIF
c*****
c      3. Airtemperature
       s_input=s_vec_airtemperature_c(i)
       i_len=LEN_TRIM(s_input)
       IF (i_len.GT.0) THEN  
        CALL convert_single_string_to_float(s_input,f_ndflag,
     +    f_output,i_badflag)
         f_vec_airtemperature_c(i)=f_output
  
        IF (i_badflag.EQ.1) THEN
         print*,'bad airtemperature',s_input
         STOP 'convert_variables'
        ENDIF
       ENDIF
c*****
c      4. Dewpointtemperature
       s_input=s_vec_dewpointtemperature_c(i)
       i_len=LEN_TRIM(s_input)
       IF (i_len.GT.0) THEN  
        CALL convert_single_string_to_float(s_input,f_ndflag,
     +    f_output,i_badflag)
         f_vec_dewpointtemperature_c(i)=f_output
  
        IF (i_badflag.EQ.1) THEN
         print*,'bad dewpointtemperature',s_input
         STOP 'convert_variables'
        ENDIF
       ENDIF
c*****
c      5. Sealevelpressure
       s_input=s_vec_sealevelpressure_hpa(i)
       i_len=LEN_TRIM(s_input)
       IF (i_len.GT.0) THEN  
        CALL convert_single_string_to_float(s_input,f_ndflag,
     +    f_output,i_badflag)
        f_vec_sealevelpressure_hpa(i)=f_output
  
        IF (i_badflag.EQ.1) THEN
         print*,'bad sealevelpressure',s_input
         STOP 'convert_variables'
        ENDIF
       ENDIF
c*****
c      6. Station pressure
       s_input=s_vec_stationpressure_hpa(i)
       i_len=LEN_TRIM(s_input)
       IF (i_len.GT.0) THEN  
        CALL convert_single_string_to_float(s_input,f_ndflag,
     +    f_output,i_badflag)
        f_vec_stationpressure_hpa(i)=f_output
  
        IF (i_badflag.EQ.1) THEN
         print*,'bad stationpressure',s_input
         STOP 'convert_variables'
        ENDIF
       ENDIF
c*****

      ENDDO

c      print*,'just leaving convert_variables'

c      STOP 'convert_variables'

      RETURN
      END
