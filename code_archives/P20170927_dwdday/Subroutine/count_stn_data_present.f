c     Subroutine to count number of stations where any records present for variable
c     AJ_Kettle, Oct03/2017

      SUBROUTINE count_stn_data_present(l_zipfile,
     +  i_arch_dayavg_airt_ngood,i_arch_dayavg_vapprs_ngood,
     +  i_arch_dayavg_ccov_ngood,i_arch_dayavg_pres_ngood,
     +  i_arch_dayavg_relh_ngood,i_arch_dayavg_wspd_ngood,
     +  i_arch_daymax_airt_ngood,i_arch_daymin_airt_ngood,
     +  i_arch_daymin_minbod_ngood,i_arch_daymax_gust_ngood,
     +  i_arch_daytot_ppt_ngood,i_arch_daytot_sundur_ngood,
     +  i_arch_daytot_snoacc_ngood,
     +  i_cnt_dayavg_airt,i_cnt_dayavg_vapprs,i_cnt_dayavg_ccov,
     +  i_cnt_dayavg_pres,i_cnt_dayavg_relh,i_cnt_dayavg_wspd,
     +  i_cnt_daymax_airt,i_cnt_daymin_airt,i_cnt_daymin_minbod,
     +  i_cnt_daymax_gust,i_cnt_daytot_ppt,i_cnt_daytot_sundur,
     +  i_cnt_daytot_snoacc)

      IMPLICIT NONE
c************************************************************************
      INTEGER             :: l_zipfile

      INTEGER             :: i_arch_dayavg_airt_ngood(1100)
      INTEGER             :: i_arch_dayavg_vapprs_ngood(1100)
      INTEGER             :: i_arch_dayavg_ccov_ngood(1100)
      INTEGER             :: i_arch_dayavg_pres_ngood(1100)
      INTEGER             :: i_arch_dayavg_relh_ngood(1100)
      INTEGER             :: i_arch_dayavg_wspd_ngood(1100)
      INTEGER             :: i_arch_daymax_airt_ngood(1100)
      INTEGER             :: i_arch_daymin_airt_ngood(1100)
      INTEGER             :: i_arch_daymin_minbod_ngood(1100)
      INTEGER             :: i_arch_daymax_gust_ngood(1100)
      INTEGER             :: i_arch_daytot_ppt_ngood(1100)
      INTEGER             :: i_arch_daytot_sundur_ngood(1100)
      INTEGER             :: i_arch_daytot_snoacc_ngood(1100)

      INTEGER             :: i_cnt_dayavg_airt
      INTEGER             :: i_cnt_dayavg_vapprs
      INTEGER             :: i_cnt_dayavg_ccov
      INTEGER             :: i_cnt_dayavg_pres
      INTEGER             :: i_cnt_dayavg_relh
      INTEGER             :: i_cnt_dayavg_wspd
      INTEGER             :: i_cnt_daymax_airt
      INTEGER             :: i_cnt_daymin_airt
      INTEGER             :: i_cnt_daymin_minbod
      INTEGER             :: i_cnt_daymax_gust
      INTEGER             :: i_cnt_daytot_ppt
      INTEGER             :: i_cnt_daytot_sundur
      INTEGER             :: i_cnt_daytot_snoacc

      INTEGER             :: i,j,k
c************************************************************************
      print*,'just entered count_stn_data_present'
c************************************************************************
c     Initialize variables
      i_cnt_dayavg_airt    =0
      i_cnt_dayavg_vapprs  =0
      i_cnt_dayavg_ccov    =0
      i_cnt_dayavg_pres    =0
      i_cnt_dayavg_relh    =0
      i_cnt_dayavg_wspd    =0
      i_cnt_daymax_airt    =0
      i_cnt_daymin_airt    =0
      i_cnt_daymin_minbod  =0
      i_cnt_daymax_gust    =0
      i_cnt_daytot_ppt     =0
      i_cnt_daytot_sundur  =0
      i_cnt_daytot_snoacc  =0

      DO i=1,l_zipfile
c       print*,'i=',i

       IF (i_arch_dayavg_airt_ngood(i).GT.0) THEN 
        i_cnt_dayavg_airt    =i_cnt_dayavg_airt+1
       ENDIF
       IF (i_arch_dayavg_vapprs_ngood(i).GT.0) THEN 
        i_cnt_dayavg_vapprs  =i_cnt_dayavg_vapprs+1
       ENDIF
       IF (i_arch_dayavg_ccov_ngood(i).GT.0) THEN 
        i_cnt_dayavg_ccov    =i_cnt_dayavg_ccov+1
       ENDIF
       IF (i_arch_dayavg_pres_ngood(i).GT.0) THEN 
        i_cnt_dayavg_pres    =i_cnt_dayavg_pres+1
       ENDIF
       IF (i_arch_dayavg_relh_ngood(i).GT.0) THEN 
        i_cnt_dayavg_relh    =i_cnt_dayavg_relh+1
       ENDIF
       IF (i_arch_dayavg_wspd_ngood(i).GT.0) THEN 
        i_cnt_dayavg_wspd    =i_cnt_dayavg_wspd+1
       ENDIF
       IF (i_arch_dayavg_pres_ngood(i).GT.0) THEN 
        i_cnt_dayavg_pres    =i_cnt_dayavg_pres+1
       ENDIF
       IF (i_arch_daymax_airt_ngood(i).GT.0) THEN 
        i_cnt_daymax_airt    =i_cnt_daymax_airt+1
       ENDIF
       IF (i_arch_daymin_airt_ngood(i).GT.0) THEN 
        i_cnt_daymin_airt    =i_cnt_daymin_airt+1
       ENDIF
       IF (i_arch_daymin_minbod_ngood(i).GT.0) THEN 
        i_cnt_daymin_minbod  =i_cnt_daymin_minbod+1
       ENDIF
       IF (i_arch_daymax_gust_ngood(i).GT.0) THEN 
        i_cnt_daymax_gust    =i_cnt_daymax_gust+1
       ENDIF
       IF (i_arch_daytot_ppt_ngood(i).GT.0) THEN 
        i_cnt_daytot_ppt     =i_cnt_daytot_ppt+1
       ENDIF
       IF (i_arch_daytot_sundur_ngood(i).GT.0) THEN 
        i_cnt_daytot_sundur  =i_cnt_daytot_sundur+1
       ENDIF
       IF (i_arch_daytot_snoacc_ngood(i).GT.0) THEN 
        i_cnt_daytot_snoacc  =i_cnt_daytot_snoacc+1
       ENDIF
      ENDDO

c      print*,'i_cnt_dayavg_airt=',  i_cnt_dayavg_airt
c      print*,'i_cnt_dayavg_vapprs=',i_cnt_dayavg_vapprs
c      print*,'i_cnt_dayavg_ccov=',  i_cnt_dayavg_ccov
c      print*,'i_cnt_dayavg_pres=',  i_cnt_dayavg_pres
c      print*,'i_cnt_dayavg_relh=',  i_cnt_dayavg_relh
c      print*,'i_cnt_dayavg_wspd=',  i_cnt_dayavg_wspd
c      print*,'i_cnt_daymax_airt=',  i_cnt_daymax_airt
c      print*,'i_cnt_daymin_airt=',  i_cnt_daymin_airt
c      print*,'i_cnt_daymin_minbod=',i_cnt_daymin_minbod
c      print*,'i_cnt_daymax_gust=',  i_cnt_daymax_gust
c      print*,'i_cnt_daytot_ppt=',   i_cnt_daytot_ppt
c      print*,'i_cnt_daytot_sundur=',i_cnt_daytot_sundur
c      print*,'i_cnt_daytot_snoacc=',i_cnt_daytot_snoacc

      RETURN
      END