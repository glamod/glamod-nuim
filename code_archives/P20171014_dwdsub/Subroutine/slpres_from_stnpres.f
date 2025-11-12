c     Subroutine to convert from stnpres to sealevel pressure
c     AJ_Kettle, Nov07/2017

      SUBROUTINE slpres_from_stnpres(f_p_hpa,f_e_hpa,f_hght_m,f_airt_c,
     +   f_slpres_hpa)

      IMPLICIT NONE
c************************************************************************
      INTEGER             :: i,j,k,ii,jj,kk

c     Inputs
      REAL                :: f_p_hpa
      REAL                :: f_e_hpa
      REAL                :: f_hght_m
      REAL                :: f_airt_c

c     Output
      REAL                :: f_slpres_hpa

c     INTERNAL CONSTANTS
      REAL                :: f_grav_ms2
      REAL                :: f_gasconstant_jkgk
      REAL                :: f_airt_k
      REAL                :: f_alapse_km
      REAL                :: f_ccoef_khpa
c************************************************************************
      f_grav_ms2          =9.80665
      f_gasconstant_jkgk  =287.05
      f_airt_k            =273.15+f_airt_c
      f_alapse_km         =0.0065
      f_ccoef_khpa        =0.12

      f_slpres_hpa=f_p_hpa*
     +  EXP( 
     +       (f_grav_ms2*f_hght_m/f_gasconstant_jkgk)/
     +       (f_airt_k+f_alapse_km*f_hght_m/2.0+f_e_hpa*f_ccoef_khpa)
     +     )
 
      
c************************************************************************
      RETURN
      END