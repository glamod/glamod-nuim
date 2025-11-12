c     Subroutine to convert from stnpres to sealevel pressure
c     copied from earlier dwdsub analysis
c     AJ_Kettle, Nov29/2017

      SUBROUTINE slpres_from_stnpres_dwdday(
     +   f_p_hpa,f_e_hpa,f_hght_m,f_airt_c,
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

c      REAL                :: f_numer
c      REAL                :: f_denom1
c      REAL                :: f_denom2
c      REAL                :: f_denom3
c************************************************************************
      f_grav_ms2          =9.80665
      f_gasconstant_jkgk  =287.05
      f_airt_k            =273.15+f_airt_c
      f_alapse_km         =0.0065
      f_ccoef_khpa        =0.12

c      f_numer =f_grav_ms2*f_hght_m/f_gasconstant_jkgk
c      f_denom1=f_airt_k
c      f_denom2=f_alapse_km*f_hght_m/2.0
c      f_denom3=f_e_hpa*f_ccoef_khpa

      f_slpres_hpa=f_p_hpa*
     +  EXP( 
     +       (f_grav_ms2*f_hght_m/f_gasconstant_jkgk)/
     +       (f_airt_k+f_alapse_km*f_hght_m/2.0+f_e_hpa*f_ccoef_khpa)
     +     )

c      print*,'f_numer =',f_numer
c      print*,'f_denom1=',f_denom1
c      print*,'f_denom2=',f_denom2
c      print*,'f_denom3=',f_denom3
c      print*,'f_p_hpa=',f_p_hpa
c      call sleep(5)

c      print*,'just leaving slpres_from_stnpres_dwdday'
c************************************************************************
      RETURN
      END