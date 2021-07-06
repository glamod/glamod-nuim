c     Subroutine to convert string values to float
c     AJ_Kettle, 13May2019

c     Subroutines called:
c      -convert_variable_column2
c      -convert_float_to_string2
c      -convert_integer_to_string2

      SUBROUTINE convert_string_to_float_ghcnd3(f_ndflag,
     +    l_timestamp_rgh,l_timestamp,
     +    s_prcp_datavalue,s_tmin_datavalue,s_tmax_datavalue,
     +    s_tavg_datavalue,s_snwd_datavalue,s_snow_datavalue,
     +    s_awnd_datavalue,s_awdr_datavalue,s_wesd_datavalue,

     +    f_prcp_datavalue_mm,f_tmin_datavalue_c,f_tmax_datavalue_c,
     +    f_tavg_datavalue_c,f_snwd_datavalue_mm,f_snow_datavalue_mm,
     +    f_awnd_datavalue_ms,f_awdr_datavalue_deg,f_wesd_datavalue_mm,
     +    s_prcp_datavalue_mm,s_tmin_datavalue_c,s_tmax_datavalue_c,
     +    s_tavg_datavalue_c,s_snwd_datavalue_mm,s_snow_datavalue_mm,
     +    s_awnd_datavalue_ms,s_awdr_datavalue_deg,s_wesd_datavalue_mm)

      IMPLICIT NONE
c************************************************************************
c     Declare variables passed into program

      REAL                :: f_ndflag

      INTEGER             :: l_timestamp_rgh
      INTEGER             :: l_timestamp

      CHARACTER(LEN=*)    :: s_prcp_datavalue(l_timestamp_rgh)  !len=5
      CHARACTER(LEN=*)    :: s_tmin_datavalue(l_timestamp_rgh)
      CHARACTER(LEN=*)    :: s_tmax_datavalue(l_timestamp_rgh)
      CHARACTER(LEN=*)    :: s_tavg_datavalue(l_timestamp_rgh)
      CHARACTER(LEN=*)    :: s_snwd_datavalue(l_timestamp_rgh)
      CHARACTER(LEN=*)    :: s_snow_datavalue(l_timestamp_rgh)
      CHARACTER(LEN=*)    :: s_awnd_datavalue(l_timestamp_rgh)
      CHARACTER(LEN=*)    :: s_awdr_datavalue(l_timestamp_rgh)
      CHARACTER(LEN=*)    :: s_wesd_datavalue(l_timestamp_rgh)

      REAL                :: f_prcp_datavalue_mm(l_timestamp_rgh)
      REAL                :: f_tmin_datavalue_c(l_timestamp_rgh)
      REAL                :: f_tmax_datavalue_c(l_timestamp_rgh)
      REAL                :: f_tavg_datavalue_c(l_timestamp_rgh)
      REAL                :: f_snwd_datavalue_mm(l_timestamp_rgh)
      REAL                :: f_snow_datavalue_mm(l_timestamp_rgh)
      REAL                :: f_awnd_datavalue_ms(l_timestamp_rgh)
      REAL                :: f_awdr_datavalue_deg(l_timestamp_rgh)
      REAL                :: f_wesd_datavalue_mm(l_timestamp_rgh)

      CHARACTER(LEN=*)   :: s_prcp_datavalue_mm(l_timestamp_rgh)
      CHARACTER(LEN=*)   :: s_tmin_datavalue_c(l_timestamp_rgh)
      CHARACTER(LEN=*)   :: s_tmax_datavalue_c(l_timestamp_rgh)
      CHARACTER(LEN=*)   :: s_tavg_datavalue_c(l_timestamp_rgh)
      CHARACTER(LEN=*)   :: s_snwd_datavalue_mm(l_timestamp_rgh)
      CHARACTER(LEN=*)   :: s_snow_datavalue_mm(l_timestamp_rgh)
      CHARACTER(LEN=*)   :: s_awnd_datavalue_ms(l_timestamp_rgh)
      CHARACTER(LEN=*)   :: s_awdr_datavalue_deg(l_timestamp_rgh)
      CHARACTER(LEN=*)   :: s_wesd_datavalue_mm(l_timestamp_rgh)
c*****
c     Variables used inside program
      INTEGER             :: i,j,k,ii,jj,kk

      INTEGER             :: i_len
      REAL                :: f_convertfactor

      CHARACTER(LEN=10)   :: s_format
c************************************************************************
c      print*,'just inside convert_string_to_float_ghcnd2'

c     Conversion notes
c     prcp: tenths of mm
c     tmin: tenths of degrees
c     tmax: tenths of degrees
c     tavg: tenths of degrees
c     snwd: mm
c     snow: mm
c     awnd: tenths of m/s
c     awdr: degrees
c     wesd: tenths of mm

c      read(string,*)b

c     1.convert prcp: tenths of mm
      f_convertfactor=1.0/10.0
      CALL convert_variable_column2(f_ndflag,f_convertfactor,
     +   l_timestamp_rgh,l_timestamp,s_prcp_datavalue,
     +   f_prcp_datavalue_mm)     

c     2.convert tmin: tenths of degrees
      f_convertfactor=1.0/10.0
      CALL convert_variable_column2(f_ndflag,f_convertfactor,
     +   l_timestamp_rgh,l_timestamp,s_tmin_datavalue,
     +   f_tmin_datavalue_c)     

c     3.convert tmax: tenths of degrees
      f_convertfactor=1.0/10.0
      CALL convert_variable_column2(f_ndflag,f_convertfactor,
     +   l_timestamp_rgh,l_timestamp,s_tmax_datavalue,
     +   f_tmax_datavalue_c)     

c     4.convert tavg: tenths of degrees
      f_convertfactor=1.0/10.0
      CALL convert_variable_column2(f_ndflag,f_convertfactor,
     +   l_timestamp_rgh,l_timestamp,s_tavg_datavalue,
     +   f_tavg_datavalue_c)     

c     5.convert snwd: mm
      f_convertfactor=1.0
      CALL convert_variable_column2(f_ndflag,f_convertfactor,
     +   l_timestamp_rgh,l_timestamp,s_snwd_datavalue,
     +   f_snwd_datavalue_mm)     

c     6.convert snow: mm
      f_convertfactor=1.0
      CALL convert_variable_column2(f_ndflag,f_convertfactor,
     +   l_timestamp_rgh,l_timestamp,s_snow_datavalue,
     +   f_snow_datavalue_mm)     

c     7.convert awnd: tenths of m/s
      f_convertfactor=1.0/10.0
      CALL convert_variable_column2(f_ndflag,f_convertfactor,
     +   l_timestamp_rgh,l_timestamp,s_awnd_datavalue,
     +   f_awnd_datavalue_ms)     

c     8.convert awdr: degrees
      f_convertfactor=1.0
      CALL convert_variable_column2(f_ndflag,f_convertfactor,
     +   l_timestamp_rgh,l_timestamp,s_awdr_datavalue,
     +   f_awdr_datavalue_deg)     

c     9.convert wesd: tenths of mm
      f_convertfactor=1.0/10.0
      CALL convert_variable_column2(f_ndflag,f_convertfactor,
     +   l_timestamp_rgh,l_timestamp,s_wesd_datavalue,
     +   f_wesd_datavalue_mm)     
c*****
c*****
c     Convert float to string
      s_format='(f10.1)'
      CALL convert_float_to_string2(f_ndflag,s_format,      
     +   l_timestamp_rgh,l_timestamp,f_prcp_datavalue_mm,
     +   s_prcp_datavalue_mm)
 
      s_format='(f10.1)'
      CALL convert_float_to_string2(f_ndflag,s_format,      
     +   l_timestamp_rgh,l_timestamp,f_tmin_datavalue_c,
     +   s_tmin_datavalue_c)
 
      s_format='(f10.1)'
      CALL convert_float_to_string2(f_ndflag,s_format,      
     +   l_timestamp_rgh,l_timestamp,f_tmax_datavalue_c,
     +   s_tmax_datavalue_c)
 
      s_format='(f10.1)'
      CALL convert_float_to_string2(f_ndflag,s_format,      
     +   l_timestamp_rgh,l_timestamp,f_tavg_datavalue_c,
     +   s_tavg_datavalue_c)
 
      s_format='(i10)'
      CALL convert_integer_to_string2(f_ndflag,s_format,      
     +   l_timestamp_rgh,l_timestamp,f_snwd_datavalue_mm,
     +   s_snwd_datavalue_mm)
 
      s_format='(i10)'
      CALL convert_integer_to_string2(f_ndflag,s_format,      
     +   l_timestamp_rgh,l_timestamp,f_snow_datavalue_mm,
     +   s_snow_datavalue_mm)

      s_format='(f10.1)'
      CALL convert_float_to_string2(f_ndflag,s_format,      
     +   l_timestamp_rgh,l_timestamp,f_awnd_datavalue_ms,
     +   s_awnd_datavalue_ms)

      s_format='(i10)'
      CALL convert_integer_to_string2(f_ndflag,s_format,      
     +   l_timestamp_rgh,l_timestamp,f_awdr_datavalue_deg,
     +   s_awdr_datavalue_deg)

      s_format='(f10.1)'
      CALL convert_float_to_string2(f_ndflag,s_format,      
     +   l_timestamp_rgh,l_timestamp,f_wesd_datavalue_mm,
     +   s_wesd_datavalue_mm)
c*****
      GOTO 25

      print*,'f_prcp_datavalue_mm',(f_prcp_datavalue_mm(i),i=1,10)
      print*,'s_prcp_datavalue_mm',(TRIM(s_prcp_datavalue_mm(i)),i=1,10)
      print*,'s_prcp_datavalue',   (TRIM(s_prcp_datavalue(i)),i=1,10)

      print*,'f_tmin_datavalue_c',(f_tmin_datavalue_c(i),i=1,10)
      print*,'s_tmin_datavalue_c',(TRIM(s_tmin_datavalue_c(i)),i=1,10)
      print*,'s_tmin_datavalue',  (TRIM(s_tmin_datavalue(i)),i=1,10)

      print*,'f_tmax_datavalue_c',(f_tmax_datavalue_c(i),i=1,10)
      print*,'s_tmax_datavalue_c',(TRIM(s_tmax_datavalue_c(i)),i=1,10)
      print*,'s_tmax_datavalue',  (TRIM(s_tmax_datavalue(i)),i=1,10)

      print*,'f_tavg_datavalue_c',(f_tavg_datavalue_c(i),i=1,10)
      print*,'s_tavg_datavalue_c',(TRIM(s_tavg_datavalue_c(i)),i=1,10)
      print*,'s_tavg_datavalue',  (TRIM(s_tavg_datavalue(i)),i=1,10)

      print*,'f_snwd_datavalue_mm',(f_snwd_datavalue_mm(i),i=1,10)
      print*,'s_snwd_datavalue_mm',(TRIM(s_snwd_datavalue_mm(i)),i=1,10)
      print*,'s_snwd_datavalue',   (TRIM(s_snwd_datavalue(i)),i=1,10)

      print*,'f_snow_datavalue_mm',(f_snow_datavalue_mm(i),i=1,10)
      print*,'s_snow_datavalue_mm',(TRIM(s_snow_datavalue_mm(i)),i=1,10)
      print*,'s_snow_datavalue',   (TRIM(s_snow_datavalue(i)),i=1,10)

      print*,'f_awnd_datavalue_ms',(f_awnd_datavalue_ms(i),i=1,10)
      print*,'s_awnd_datavalue_ms',(TRIM(s_awnd_datavalue_ms(i)),i=1,10)
      print*,'s_awnd_datavalue',   (TRIM(s_awnd_datavalue(i)),i=1,10)

      print*,'f_awdr_datavalue_deg',(f_awdr_datavalue_deg(i),i=1,10)
      print*,'s_awdr_datavalue_deg',(s_awdr_datavalue_deg(i),i=1,10)
      print*,'s_awdr_datavalue',    (s_awdr_datavalue(i),i=1,10)

      print*,'f_wesd_datavalue_mm',(f_wesd_datavalue_mm(i),i=1,10)
      print*,'s_wesd_datavalue_mm',(s_wesd_datavalue_mm(i),i=1,10)
      print*,'s_wesd_datavalue',   (s_wesd_datavalue(i),i=1,10)

 25   CONTINUE
c*****
      GOTO 10

c     Test single variables
      DO i=1,l_timestamp 
       IF (f_prcp_datavalue_mm(i).NE.f_ndflag) THEN
        IF (f_prcp_datavalue_mm(i).LT.0.0) THEN
         print*,'i=',i,'='//TRIM(s_prcp_datavalue(i))//'=',
     +       f_prcp_datavalue_mm(i)
         STOP 'convert_string_to_float_ghcnd; prcp negative'
        ENDIF
       ENDIF

       IF (f_tmin_datavalue_c(i).NE.f_ndflag) THEN
        IF (f_tmin_datavalue_c(i).LT.-70.0.OR.
     +      f_tmin_datavalue_c(i).GT.+80.0) THEN
         print*,'i=',i,'='//TRIM(s_tmin_datavalue(i))//'=',
     +       f_tmin_datavalue_c(i)
         print*,'variable_listing:'
         print*,'prcp=', s_prcp_datavalue(i)
         print*,'tmin=', s_tmin_datavalue(i)
         print*,'tmax=', s_tmax_datavalue(i)
         print*,'tavg=', s_tavg_datavalue(i)
         print*,'snwd=', s_snwd_datavalue(i)
         print*,'snow=', s_snow_datavalue(i)
         print*,'awnd=', s_awnd_datavalue(i)
         print*,'awdr=', s_awdr_datavalue(i)
         print*,'wesd=', s_wesd_datavalue(i)
         STOP 'convert_string_to_float_ghcnd; tmin out of range'
        ENDIF
       ENDIF

       IF (f_tmax_datavalue_c(i).NE.f_ndflag) THEN
        IF (f_tmax_datavalue_c(i).LT.-70.0.OR.
     +      f_tmax_datavalue_c(i).GT.+80.0) THEN
         print*,'i=',i,'='//TRIM(s_tmax_datavalue(i))//'=',
     +       f_tmax_datavalue_c(i)
         STOP 'convert_string_to_float_ghcnd; tmax out of range'
        ENDIF
       ENDIF

       IF (f_tavg_datavalue_c(i).NE.f_ndflag) THEN
        IF (f_tavg_datavalue_c(i).LT.-70.0.OR.
     +      f_tavg_datavalue_c(i).GT.+80.0) THEN
         print*,'i=',i,'='//TRIM(s_tavg_datavalue(i))//'=',
     +       f_tavg_datavalue_c(i)
         STOP 'convert_string_to_float_ghcnd; tavg out of range'
        ENDIF
       ENDIF

       IF (f_snwd_datavalue_mm(i).NE.f_ndflag) THEN
        IF (f_snwd_datavalue_mm(i).LT.0.0) THEN
         print*,'i=',i,'='//TRIM(s_snwd_datavalue(i))//'=',
     +       f_snwd_datavalue_mm(i)
         STOP 'convert_string_to_float_ghcnd; snwd negative'
        ENDIF
       ENDIF

      ENDDO

 10   CONTINUE

c      print*,'just leaving convert_string_to_float_ghcnd'
c      STOP 'convert_string_to_float2'

      RETURN
      END
