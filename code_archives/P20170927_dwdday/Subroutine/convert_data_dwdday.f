c     Subroutine to convert data 
c     AJ_Kettle, Nov28/2017

      SUBROUTINE convert_data_dwdday(f_ndflag,l_prod,f_dayavg_airt_c,
     +   f_dayavg_pres_mb,f_dayavg_vapprs_mb,f_last_hgt_m,
     +   f_daymax_airt_c,f_daymin_airt_c,

     +   f_dayavg_airt_k,f_dayavg_slpres_hpa,
     +   f_daymax_airt_k,f_daymin_airt_k)

      IMPLICIT NONE
c************************************************************************
      REAL                :: f_ndflag
      INTEGER             :: l_prod
      REAL                :: f_dayavg_airt_c(100000)
      REAL                :: f_dayavg_pres_mb(100000)
      REAL                :: f_dayavg_vapprs_mb(100000)
      REAL                :: f_last_hgt_m
      REAL                :: f_daymax_airt_c(100000)
      REAL                :: f_daymin_airt_c(100000)

c     Exported variables
      REAL                :: f_dayavg_airt_k(100000)
      REAL                :: f_dayavg_slpres_hpa(100000)
      REAL                :: f_daymax_airt_k(100000)
      REAL                :: f_daymin_airt_k(100000)

      REAL                :: f_p_hpa
      REAL                :: f_e_hpa
      REAL                :: f_airt_c
      REAL                :: f_slpres_hpa

      INTEGER             :: i,j,k,ii,jj,kk
c************************************************************************
c     Convert air temperature, airt_max & airt_min
      DO i=1,l_prod
c      initialize vector
       f_dayavg_airt_k(i)=f_ndflag
       f_daymax_airt_k(i)=f_ndflag
       f_daymin_airt_k(i)=f_ndflag

       IF (f_dayavg_airt_c(i).NE.f_ndflag) THEN
        f_dayavg_airt_k(i)=273.15+f_dayavg_airt_c(i)
       ENDIF
       IF (f_daymax_airt_c(i).NE.f_ndflag) THEN
        f_daymax_airt_k(i)=273.15+f_daymax_airt_c(i)
       ENDIF
       IF (f_daymin_airt_c(i).NE.f_ndflag) THEN
        f_daymin_airt_k(i)=273.15+f_daymin_airt_c(i)
       ENDIF
      ENDDO
c************************************************************************
c     Convert from station pressure to sealevel pressure
      DO i=1,l_prod
       f_dayavg_slpres_hpa(i)=f_ndflag

       f_p_hpa =f_dayavg_pres_mb(i)
       f_e_hpa =f_dayavg_vapprs_mb(i)
       f_airt_c=f_dayavg_airt_c(i)

       IF (f_p_hpa.EQ.f_ndflag.OR.f_e_hpa.EQ.f_ndflag.OR.
     +     f_airt_c.EQ.f_ndflag) THEN
        GOTO 12
       ENDIF

c       If here then all flag checks good
        CALL slpres_from_stnpres_dwdday(
     +   f_p_hpa,f_e_hpa,f_last_hgt_m,f_airt_c,
     +   f_slpres_hpa)
        f_dayavg_slpres_hpa(i)=f_slpres_hpa

c        print*,'f_dayavg_pres_mb=',f_dayavg_pres_mb(i)
c        print*,'f_dayavg_vapprs_mb=',f_dayavg_vapprs_mb(i)
c        print*,'f_dayavg_airt_c=',f_dayavg_airt_c(i)
c        print*,'f_last_hgt_m=',f_last_hgt_m
c        print*,'f_dayavg_slpres_hpa=',f_dayavg_slpres_hpa(i)
c        print*,'pres orig,sl,ratio',f_dayavg_pres_mb(i),
c     +    f_dayavg_slpres_hpa(i),
c     +    f_dayavg_slpres_hpa(i)/f_dayavg_pres_mb(i)
c        call sleep(1)

12     CONTINUE
      ENDDO

c      print*,'f_ndflag=',f_ndflag
c      print*,'f_dayavg_pres_mb(i)=',  (f_dayavg_pres_mb(i),i=1,5)
c      print*,'f_dayavg_vapprs_mb(i)=',(f_dayavg_vapprs_mb(i),i=1,5)
c      print*,'f_dayavg_airt_c(i)=',   (f_dayavg_airt_c(i),i=1,5)
c      print*,'f_dayavg_slpres_mb(i)=',(f_dayavg_slpres_mb(i),i=1,5)
c      CALL SLEEP(5)
c************************************************************************
      RETURN
      END