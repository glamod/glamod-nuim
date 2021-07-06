c     Subroutine to get observationvalue
c     AJ_Kettle, 12Jan2019
c     17Jan2019: modified for conversion of snow from mm to cm

c     Subroutines called
c      -convert_float_to_string_single2

      SUBROUTINE get_observationvalue_vector2(f_ndflag,l_channel,
     +  f_prcp_datavalue_mm,f_tmin_datavalue_c,
     +  f_tmax_datavalue_c,f_tavg_datavalue_c,
     +  f_snwd_datavalue_mm,f_snow_datavalue_mm,
     +  f_awnd_datavalue_ms,f_awdr_datavalue_deg,
     +  f_wesd_datavalue_mm,
     +  s_prcp_datavalue_mm,s_tmin_datavalue_c,
     +  s_tmax_datavalue_c,s_tavg_datavalue_c,
     +  s_snwd_datavalue_mm,s_snow_datavalue_mm,
     +  s_awnd_datavalue_ms,s_awdr_datavalue_deg,
     +  s_wesd_datavalue_mm,
     +  f_vec_original_value,s_vec_original_value,
     +  s_vec_observation_value)

      IMPLICIT NONE
c************************************************************************
c     Declare variables passed into program

      REAL                :: f_ndflag
      INTEGER             :: l_channel

      REAL                :: f_prcp_datavalue_mm
      REAL                :: f_tmin_datavalue_c
      REAL                :: f_tmax_datavalue_c
      REAL                :: f_tavg_datavalue_c
      REAL                :: f_snwd_datavalue_mm
      REAL                :: f_snow_datavalue_mm
      REAL                :: f_awnd_datavalue_ms
      REAL                :: f_awdr_datavalue_deg
      REAL                :: f_wesd_datavalue_mm

      CHARACTER(LEN=*)    :: s_prcp_datavalue_mm  !len=10 from main program
      CHARACTER(LEN=*)    :: s_tmin_datavalue_c
      CHARACTER(LEN=*)    :: s_tmax_datavalue_c
      CHARACTER(LEN=*)    :: s_tavg_datavalue_c
      CHARACTER(LEN=*)    :: s_snwd_datavalue_mm
      CHARACTER(LEN=*)    :: s_snow_datavalue_mm
      CHARACTER(LEN=*)    :: s_awnd_datavalue_ms
      CHARACTER(LEN=*)    :: s_awdr_datavalue_deg
      CHARACTER(LEN=*)    :: s_wesd_datavalue_mm

      REAL                :: f_vec_original_value(l_channel)
      CHARACTER(LEN=*)    :: s_vec_original_value(l_channel)      !length 10
      CHARACTER(LEN=*)    :: s_vec_observation_value(l_channel)   !length 10
c*****
c     Variables used within program
 
      INTEGER             :: i,j,k,ii,jj,kk

      REAL                :: f_tmin_datavalue_k
      REAL                :: f_tmax_datavalue_k
      REAL                :: f_tavg_datavalue_k
      REAL                :: f_snwd_datavalue_cm

      CHARACTER(LEN=10)   :: s_tmin_datavalue_k
      CHARACTER(LEN=10)   :: s_tmax_datavalue_k
      CHARACTER(LEN=10)   :: s_tavg_datavalue_k
      CHARACTER(LEN=10)   :: s_snwd_datavalue_cm

      CHARACTER(LEN=10)   :: s_format

c      REAL                :: f_originaldata(l_channel)
c      CHARACTER(LEN=10)   :: s_originaldata(l_channel)
c************************************************************************
c      print *,'just entered get_observationvalue_vector'

c     Initialize variables
      f_tmin_datavalue_k =f_ndflag
      f_tmax_datavalue_k =f_ndflag
      f_tavg_datavalue_k =f_ndflag
      f_snwd_datavalue_cm=f_ndflag

      s_tmin_datavalue_k =''
      s_tmax_datavalue_k =''
      s_tavg_datavalue_k =''
      s_snwd_datavalue_cm=''

c     TMIN
      IF (f_tmin_datavalue_c.NE.f_ndflag) THEN
       f_tmin_datavalue_k=273.15+f_tmin_datavalue_c

       s_format='(f10.2)'
       CALL convert_float_to_string_single2(f_ndflag,s_format,      
     +   f_tmin_datavalue_k,
     +   s_tmin_datavalue_k)
      ENDIF
c     TMAX
      IF (f_tmax_datavalue_c.NE.f_ndflag) THEN
       f_tmax_datavalue_k=273.15+f_tmax_datavalue_c

       s_format='(f10.2)'
       CALL convert_float_to_string_single2(f_ndflag,s_format,      
     +   f_tmax_datavalue_k,
     +   s_tmax_datavalue_k)
      ENDIF
c     TAVG
      IF (f_tavg_datavalue_c.NE.f_ndflag) THEN
       f_tavg_datavalue_k=273.15+f_tavg_datavalue_c

       s_format='(f10.2)'
       CALL convert_float_to_string_single2(f_ndflag,s_format,      
     +   f_tavg_datavalue_k,
     +   s_tavg_datavalue_k)
      ENDIF

c     SNWD
      IF (f_snwd_datavalue_mm.NE.f_ndflag) THEN
       f_snwd_datavalue_cm=f_snwd_datavalue_mm/10.0

       s_format='(f10.1)'
       CALL convert_float_to_string_single2(f_ndflag,s_format,      
     +   f_snwd_datavalue_cm,
     +   s_snwd_datavalue_cm)
      ENDIF

c************************************************************************
c************************************************************************
c     Initialize observation vector
      DO i=1,l_channel
       s_vec_original_value(i)   =''
       s_vec_observation_value(i)=''
      ENDDO

      f_vec_original_value(1)=f_prcp_datavalue_mm
      f_vec_original_value(2)=f_tmin_datavalue_c
      f_vec_original_value(3)=f_tmax_datavalue_c
      f_vec_original_value(4)=f_tavg_datavalue_c
      f_vec_original_value(5)=f_snwd_datavalue_mm
      f_vec_original_value(6)=f_snow_datavalue_mm
      f_vec_original_value(7)=f_awnd_datavalue_ms
      f_vec_original_value(8)=f_awdr_datavalue_deg
      f_vec_original_value(9)=f_wesd_datavalue_mm

      IF (f_prcp_datavalue_mm.NE.f_ndflag) THEN              !no conversion
       s_vec_original_value(1)   =TRIM(s_prcp_datavalue_mm) 
       s_vec_observation_value(1)=TRIM(s_prcp_datavalue_mm)
      ENDIF
      IF (f_tmin_datavalue_k.NE.f_ndflag) THEN               !conversion
       s_vec_original_value(2)   =TRIM(s_tmin_datavalue_c)
       s_vec_observation_value(2)=TRIM(s_tmin_datavalue_k)
      ENDIF
      IF (f_tmax_datavalue_k.NE.f_ndflag) THEN               !conversion
       s_vec_original_value(3)   =TRIM(s_tmax_datavalue_c)
       s_vec_observation_value(3)=TRIM(s_tmax_datavalue_k)
      ENDIF
      IF (f_tavg_datavalue_k.NE.f_ndflag) THEN               !conversion
       s_vec_original_value(4)   =TRIM(s_tavg_datavalue_c)
       s_vec_observation_value(4)=TRIM(s_tavg_datavalue_k)
      ENDIF
      IF (f_snwd_datavalue_mm.NE.f_ndflag) THEN              !conversion
       s_vec_original_value(5)   =TRIM(s_snwd_datavalue_mm)
       s_vec_observation_value(5)=TRIM(s_snwd_datavalue_cm)
      ENDIF
      IF (f_snow_datavalue_mm.NE.f_ndflag) THEN              !no conversion
       s_vec_original_value(6)   =TRIM(s_snow_datavalue_mm)
       s_vec_observation_value(6)=TRIM(s_snow_datavalue_mm)
      ENDIF
      IF (f_awnd_datavalue_ms.NE.f_ndflag) THEN              !no conversion
       s_vec_original_value(7)   =TRIM(s_awnd_datavalue_ms)
       s_vec_observation_value(7)=TRIM(s_awnd_datavalue_ms)
      ENDIF
      IF (f_awdr_datavalue_deg.NE.f_ndflag) THEN             !no conversion
       s_vec_original_value(8)   =TRIM(s_awdr_datavalue_deg)
       s_vec_observation_value(8)=TRIM(s_awdr_datavalue_deg)
      ENDIF
      IF (f_wesd_datavalue_mm.NE.f_ndflag) THEN              !no conversion
       s_vec_original_value(9)   =TRIM(s_wesd_datavalue_mm)
       s_vec_observation_value(9)=TRIM(s_wesd_datavalue_mm)
      ENDIF

c      print*,'s_vec_observation_value=',
c     +  (s_vec_observation_value(i),i=1,l_channel)

c      DO i=1,l_channel
c       print*,'i=',i,
c     +   s_vec_original_value(i),s_vec_observation_value(i),
c     +   f_vec_original_value(i)
c      ENDDO
c************************************************************************
c      print *,'just leaving get_observationvalue_vector'

c      STOP 'get_observationvalue_vector'

      RETURN
      END
