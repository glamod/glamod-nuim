c     Subroutine to calculate statistical package
c     AJ_Kettle, Sept26/2017

      SUBROUTINE dwd_day_stat_package(l_prod,f_ndflag,f_dayavg_airt_c,
     + f_dayavg_airt_min_c,f_dayavg_airt_max_c,f_dayavg_airt_avg_c,
     + f_dayavg_airt_ngood,f_dayavg_airt_nbad)

      IMPLICIT NONE
c************************************************************************
      INTEGER             :: l_prod
      REAL                :: f_ndflag
      REAL                :: f_dayavg_airt_c(100000)
      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: i_good

      REAL                :: f_dayavg_airt_ngood,f_dayavg_airt_nbad
      REAL                :: f_dayavg_airt_min_c
      REAL                :: f_dayavg_airt_max_c
      REAL                :: f_dayavg_airt_avg_c
c************************************************************************
c     dayavg_airt

c      print*,'l_prod=',l_prod
c      print*,'f_dayavg_airt_c=',(f_dayavg_airt_c(i),i=1,10)

      i_good   =0
      f_dayavg_airt_ngood=0.0
      f_dayavg_airt_nbad =0.0
      f_dayavg_airt_min_c=10000.0  !-f_ndflag
      f_dayavg_airt_max_c=-10000.0 !f_ndflag
      f_dayavg_airt_avg_c=0.0

      DO i=1,l_prod 
       IF (f_dayavg_airt_c(i).NE.f_ndflag) THEN

        f_dayavg_airt_min_c=MIN(f_dayavg_airt_min_c,f_dayavg_airt_c(i))
        f_dayavg_airt_max_c=MAX(f_dayavg_airt_max_c,f_dayavg_airt_c(i))
        f_dayavg_airt_avg_c=f_dayavg_airt_avg_c+f_dayavg_airt_c(i)

        f_dayavg_airt_ngood=f_dayavg_airt_ngood+1.0     
        i_good=i_good+1
       ENDIF
       IF (.NOT.(f_dayavg_airt_c(i).NE.f_ndflag)) THEN
        f_dayavg_airt_nbad=f_dayavg_airt_nbad+1.0
       ENDIF     
      ENDDO

      IF (f_dayavg_airt_ngood.GE.1.0) THEN 
       f_dayavg_airt_avg_c=f_dayavg_airt_avg_c/f_dayavg_airt_ngood
      ENDIF
      IF (.NOT.(f_dayavg_airt_ngood.GE.1.0)) THEN 
       f_dayavg_airt_avg_c=-99.0 !f_ndflag
       f_dayavg_airt_min_c=-99.0 !f_ndflag
       f_dayavg_airt_max_c=-99.0 !f_ndflag
      ENDIF

c      print*,'f_dayavg_airt_ngood=',f_dayavg_airt_ngood
c      print*,'f_dayavg_airt_nbad=',f_dayavg_airt_nbad
c      print*,'f_dayavg_airt_min_c',f_dayavg_airt_min_c
c      print*,'f_dayavg_airt_max_c',f_dayavg_airt_max_c
c      print*,'f_dayavg_airt_avg_c',f_dayavg_airt_avg_c

      RETURN
      END