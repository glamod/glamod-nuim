c     Subroutine to assemble vector of original precision
c     AJ_Kettle, 10Jan2019

      SUBROUTINE assemble_vec_original_precision2(l_channel,
     +  s_prec_empir_prcp_mm,s_prec_empir_tmin_c,
     +  s_prec_empir_tmax_c,s_prec_empir_tavg_c,
     +  s_prec_empir_snwd_mm,s_prec_empir_snow_mm,
     +  s_prec_empir_awnd_ms,s_prec_empir_awdr_deg,
     +  s_prec_empir_wesd_mm,
     +  s_vec_original_prec)

      IMPLICIT NONE
c************************************************************************
c     Declare variables passed into program

      INTEGER             :: l_channel

      CHARACTER(LEN=*)    :: s_prec_empir_prcp_mm
      CHARACTER(LEN=*)    :: s_prec_empir_tmin_c
      CHARACTER(LEN=*)    :: s_prec_empir_tmax_c
      CHARACTER(LEN=*)    :: s_prec_empir_tavg_c
      CHARACTER(LEN=*)    :: s_prec_empir_snwd_mm
      CHARACTER(LEN=*)    :: s_prec_empir_snow_mm
      CHARACTER(LEN=*)    :: s_prec_empir_awnd_ms
      CHARACTER(LEN=*)    :: s_prec_empir_awdr_deg
      CHARACTER(LEN=*)    :: s_prec_empir_wesd_mm

      CHARACTER(LEN=*)    :: s_vec_original_prec(l_channel)
c*****
c     Variables used within program
 
      INTEGER             :: i,j,k,ii,jj,kk
c************************************************************************
c      print *,'just entered assemble_vec_original_precision'

c      print*,'l_channel=',l_channel

c      print*,'prcp',LEN_TRIM(s_prec_empir_prcp_mm)
c      print*,'tmin',LEN_TRIM(s_prec_empir_tmin_c)
c      print*,'tmax',LEN_TRIM(s_prec_empir_tmax_c)
c      print*,'tavg',LEN_TRIM(s_prec_empir_tavg_c)
c      print*,'snwd',LEN_TRIM(s_prec_empir_snwd_mm)
c      print*,'snow',LEN_TRIM(s_prec_empir_snow_mm)
c      print*,'awnd',LEN_TRIM(s_prec_empir_awnd_ms)
c      print*,'awdr',LEN_TRIM(s_prec_empir_awdr_deg)
c      print*,'wesd',LEN_TRIM(s_prec_empir_wesd_mm)

      s_vec_original_prec(1)=TRIM(s_prec_empir_prcp_mm)
      s_vec_original_prec(2)=TRIM(s_prec_empir_tmin_c)
      s_vec_original_prec(3)=TRIM(s_prec_empir_tmax_c)
      s_vec_original_prec(4)=TRIM(s_prec_empir_tavg_c)
      s_vec_original_prec(5)=TRIM(s_prec_empir_snwd_mm)
      s_vec_original_prec(6)=TRIM(s_prec_empir_snow_mm)
      s_vec_original_prec(7)=TRIM(s_prec_empir_awnd_ms)
      s_vec_original_prec(8)=TRIM(s_prec_empir_awdr_deg)
      s_vec_original_prec(9)=TRIM(s_prec_empir_wesd_mm)

c      print*,'s_vec_original_prec=',
c     +  ('='//TRIM(s_vec_original_prec(i))//'=',i=1,l_channel)

c      print *,'just leaving assemble_vec_original_precision'

c      STOP 'assemble_vec_original_precision'

      RETURN
      END
