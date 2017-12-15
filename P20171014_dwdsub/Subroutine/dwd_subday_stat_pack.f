c     Subroutine to calculate statistical package
c     AJ_Kettle, Oct26/2017

      SUBROUTINE dwd_subday_stat_pack(l_mlent,j_sd,f_ndflag,
     +  ft_sd_pres_hpa,

     +  ft_sd_pres_min_hpa,ft_sd_pres_max_hpa,
     +  ft_sd_pres_avg_hpa,
     +  ft_sd_pres_ngood,ft_sd_pres_nbad)

      IMPLICIT NONE
c************************************************************************
      INTEGER             :: l_mlent
      INTEGER             :: j_sd
      REAL                :: f_ndflag
      REAL                :: ft_sd_pres_hpa(l_mlent)
      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: i_good

      REAL                :: ft_sd_pres_ngood
      REAL                :: ft_sd_pres_nbad
      REAL                :: ft_sd_pres_min_hpa
      REAL                :: ft_sd_pres_max_hpa
      REAL                :: ft_sd_pres_tot_hpa
      REAL                :: ft_sd_pres_avg_hpa
c************************************************************************
c      print*,'l_mlent,j_sd=',l_mlent,j_sd
c      print*,'ft_sd_pres_hpa=',(ft_sd_pres_hpa(i),i=1,10)

      i_good   =0
      ft_sd_pres_ngood   =0.0
      ft_sd_pres_nbad    =0.0
      ft_sd_pres_min_hpa =-f_ndflag
      ft_sd_pres_max_hpa =f_ndflag
      ft_sd_pres_tot_hpa =0.0

      DO i=1,j_sd 
       IF (ft_sd_pres_hpa(i).NE.f_ndflag) THEN

        ft_sd_pres_min_hpa=MIN(ft_sd_pres_min_hpa,ft_sd_pres_hpa(i))
        ft_sd_pres_max_hpa=MAX(ft_sd_pres_max_hpa,ft_sd_pres_hpa(i))
        ft_sd_pres_tot_hpa=ft_sd_pres_tot_hpa+ft_sd_pres_hpa(i)

        ft_sd_pres_ngood=ft_sd_pres_ngood+1.0     
        i_good=i_good+1
       ENDIF
       IF (.NOT.(ft_sd_pres_hpa(i).NE.f_ndflag)) THEN
        ft_sd_pres_nbad=ft_sd_pres_nbad+1.0
       ENDIF     
      ENDDO

      IF (ft_sd_pres_ngood.GE.1.0) THEN 
       ft_sd_pres_avg_hpa=ft_sd_pres_tot_hpa/ft_sd_pres_ngood
      ENDIF
      IF (.NOT.(ft_sd_pres_ngood.GE.1.0)) THEN 
       ft_sd_pres_avg_hpa=f_ndflag
       ft_sd_pres_min_hpa=f_ndflag
       ft_sd_pres_max_hpa=f_ndflag
      ENDIF

c      print*,'ft_sd_pres_ngood=', ft_sd_pres_ngood
c      print*,'ft_sd_pres_nbad=',  ft_sd_pres_nbad
c      print*,'ft_sd_pres_min_hpa',ft_sd_pres_min_hpa
c      print*,'ft_sd_pres_max_hpa',ft_sd_pres_max_hpa
c      print*,'ft_sd_pres_avg_hpa',ft_sd_pres_avg_hpa

      RETURN
      END