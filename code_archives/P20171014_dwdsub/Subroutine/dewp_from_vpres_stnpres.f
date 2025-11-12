c     Subroutine to find dew point from vapor pressure
c     AJ_Kettle, Nov7/2017

c     from wmo_8_en-2012.pdf

      SUBROUTINE dewp_from_vpres_stnpres(f_ew_hpa,f_p_hpa,
     +   f_dewp_c)

      IMPLICIT NONE
c************************************************************************
      REAL                :: f_dewp_c     

      REAL                :: f_ew_hpa
      REAL                :: f_p_hpa 

      REAL                :: f_p_coef
c************************************************************************
c     Find pressure coefficient
      f_p_coef=1.0016+3.15*10.0**(-6.0)*f_p_hpa-0.074/f_p_hpa

      f_dewp_c=(243.12*ALOG(f_ew_hpa/(6.112*f_p_coef)))/
     +   (17.62-ALOG(f_ew_hpa/(6.112*f_p_coef)))

c      f_dewp_c=(243.12*ALOG(f_ew_pa/611.2))/(17.62-ALOG(f_ew_pa/611.2))
c************************************************************************
      RETURN
      END