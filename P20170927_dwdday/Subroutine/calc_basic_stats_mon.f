c     Subroutine to find basic stats for month values
c     AJ_Kettle, Nov30/2017

      SUBROUTINE calc_basic_stats_mon(f_ndflag,l_monrec_common,
     +  f_monrec_airt_k,f_monrec_wspd_ms,
     +  f_monrec_slpres_hpa,f_monrec_ppt_mm,

     +  f_monavg_airt_ngood,f_monavg_airt_nbad,
     +  f_monavg_airt_min_k,f_monavg_airt_max_k, 
     +  f_monavg_airt_avg_k, 
     +  f_monavg_wspd_ngood,f_monavg_wspd_nbad,
     +  f_monavg_wspd_min_ms,f_monavg_wspd_max_ms,
     +  f_monavg_wspd_avg_ms,
     +  f_monavg_slpres_ngood,f_monavg_slpres_nbad,
     +  f_monavg_slpres_min_hpa,f_monavg_slpres_max_hpa,
     +  f_monavg_slpres_avg_hpa,
     +  f_monavg_ppt_ngood,f_monavg_ppt_nbad,
     +  f_monavg_ppt_min_mm,f_monavg_ppt_max_mm,
     +  f_monavg_ppt_avg_mm)

      IMPLICIT NONE
c************************************************************************
      REAL                :: f_ndflag
      INTEGER             :: l_monrec_common

      REAL                :: f_monrec_airt_k(5000)
      REAL                :: f_monrec_wspd_ms(5000)
      REAL                :: f_monrec_slpres_hpa(5000)
      REAL                :: f_monrec_ppt_mm(5000)

      REAL                :: f_monavg_airt_ngood
      REAL                :: f_monavg_airt_nbad
      REAL                :: f_monavg_airt_min_k
      REAL                :: f_monavg_airt_max_k
      REAL                :: f_monavg_airt_avg_k 

      REAL                :: f_monavg_wspd_ngood
      REAL                :: f_monavg_wspd_nbad
      REAL                :: f_monavg_wspd_min_ms
      REAL                :: f_monavg_wspd_max_ms
      REAL                :: f_monavg_wspd_avg_ms

      REAL                :: f_monavg_slpres_ngood
      REAL                :: f_monavg_slpres_nbad
      REAL                :: f_monavg_slpres_min_hpa
      REAL                :: f_monavg_slpres_max_hpa
      REAL                :: f_monavg_slpres_avg_hpa

      REAL                :: f_monavg_ppt_ngood
      REAL                :: f_monavg_ppt_nbad
      REAL                :: f_monavg_ppt_min_mm
      REAL                :: f_monavg_ppt_max_mm
      REAL                :: f_monavg_ppt_avg_mm

      INTEGER             :: ii,jj,kk,i,j,k
c************************************************************************
c     Find stats dayavg_airt
      CALL dwd_mon_stat_package(l_monrec_common,f_ndflag,
     + f_monrec_airt_k,
     + f_monavg_airt_min_k,f_monavg_airt_max_k,
     + f_monavg_airt_avg_k,
     + f_monavg_airt_ngood,f_monavg_airt_nbad)

c     Find stats dayavg_wspd
      CALL dwd_mon_stat_package(l_monrec_common,f_ndflag,
     + f_monrec_wspd_ms,
     + f_monavg_wspd_min_ms,f_monavg_wspd_max_ms,
     + f_monavg_wspd_avg_ms,
     + f_monavg_wspd_ngood,f_monavg_wspd_nbad)

c     Find stats dayavg_slpres
      CALL dwd_mon_stat_package(l_monrec_common,f_ndflag,
     + f_monrec_slpres_hpa,
     + f_monavg_slpres_min_hpa,f_monavg_slpres_max_hpa,
     + f_monavg_slpres_avg_hpa,
     + f_monavg_slpres_ngood,f_monavg_slpres_nbad)

c     Find stats dayavg_ppt
      CALL dwd_mon_stat_package(l_monrec_common,f_ndflag,
     + f_monrec_ppt_mm,
     + f_monavg_ppt_min_mm,f_monavg_ppt_max_mm,
     + f_monavg_ppt_avg_mm,
     + f_monavg_ppt_ngood,f_monavg_ppt_nbad)
c************************************************************************
c      print*,'airt_k=',f_monavg_airt_min_k,f_monavg_airt_max_k,
c     + f_monavg_airt_avg_k,
c     + f_monavg_airt_ngood,f_monavg_airt_nbad
c      print*,'wspd_ms=',f_monavg_wspd_min_ms,f_monavg_wspd_max_ms,
c     + f_monavg_wspd_avg_ms,
c     + f_monavg_wspd_ngood,f_monavg_wspd_nbad
c      print*,'slpres_hpa=',
c     + f_monavg_slpres_min_hpa,f_monavg_slpres_max_hpa,
c     + f_monavg_slpres_avg_hpa,
c     + f_monavg_slpres_ngood,f_monavg_slpres_nbad
c      print*,'ppt_mm=',f_monavg_ppt_min_mm,f_monavg_ppt_max_mm,
c     + f_monavg_ppt_avg_mm,
c     + f_monavg_ppt_ngood,f_monavg_ppt_nbad

      RETURN
      END