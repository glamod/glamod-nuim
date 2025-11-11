c     Subroutine to calculate basic stats for day files
c     AJ_Kettle, Sept29/2017

      SUBROUTINE calc_basic_stats_dd(f_ndflag,l_prod,
     +   f_dayavg_airt_c,f_dayavg_vapprs_mb,f_dayavg_ccov_okta,
     +   f_dayavg_pres_mb,f_dayavg_relh_pc,f_dayavg_wspd_ms,
     +   f_daymax_airt_c,f_daymin_airt_c,f_daymin_minbod_c,
     +   f_daymax_gust_ms,f_daytot_ppt_mm,f_daytot_sundur_h,
     +   f_daytot_snoacc_cm,

     +   f_dayavg_airt_k,f_dayavg_slpres_hpa,

     +   f_dayavg_airt_ngood,f_dayavg_airt_nbad,
     +   f_dayavg_airt_min_c,f_dayavg_airt_max_c,
     +   f_dayavg_airt_avg_c, 
     +   f_dayavg_vapprs_ngood,f_dayavg_vapprs_nbad,
     +   f_dayavg_vapprs_min_mb,f_dayavg_vapprs_max_mb,
     +   f_dayavg_vapprs_avg_mb, 
     +   f_dayavg_ccov_ngood,f_dayavg_ccov_nbad,
     +   f_dayavg_ccov_min_okta,f_dayavg_ccov_max_okta,
     +   f_dayavg_ccov_avg_okta, 
     +   f_dayavg_pres_ngood,f_dayavg_pres_nbad,
     +   f_dayavg_pres_min_mb,f_dayavg_pres_max_mb,
     +   f_dayavg_pres_avg_mb, 
     +   f_dayavg_relh_ngood,f_dayavg_relh_nbad, 
     +   f_dayavg_relh_min_pc,f_dayavg_relh_max_pc,
     +   f_dayavg_relh_avg_pc, 
     +   f_dayavg_wspd_ngood,f_dayavg_wspd_nbad,
     +   f_dayavg_wspd_min_ms,f_dayavg_wspd_max_ms,
     +   f_dayavg_wspd_avg_ms,
     +   f_daymax_airt_ngood,f_daymax_airt_nbad,
     +   f_daymax_airt_min_c,f_daymax_airt_max_c,
     +   f_daymax_airt_avg_c, 
     +   f_daymin_airt_ngood,f_daymin_airt_nbad,
     +   f_daymin_airt_min_c,f_daymin_airt_max_c,
     +   f_daymin_airt_avg_c, 
     +   f_daymin_minbod_ngood,f_daymin_minbod_nbad,
     +   f_daymin_minbod_min_c,f_daymin_minbod_max_c,
     +   f_daymin_minbod_avg_c, 
     +   f_daymax_gust_ngood,f_daymax_gust_nbad,
     +   f_daymax_gust_min_ms,f_daymax_gust_max_ms,
     +   f_daymax_gust_avg_ms, 
     +   f_daytot_ppt_ngood,f_daytot_ppt_nbad,
     +   f_daytot_ppt_min_mm,f_daytot_ppt_max_mm,
     +   f_daytot_ppt_avg_mm, 
     +   f_daytot_sundur_ngood,f_daytot_sundur_nbad,
     +   f_daytot_sundur_min_h,f_daytot_sundur_max_h,
     +   f_daytot_sundur_avg_h,
     +   f_daytot_snoacc_ngood,f_daytot_snoacc_nbad,
     +   f_daytot_snoacc_min_cm,f_daytot_snoacc_max_cm,
     +   f_daytot_snoacc_avg_cm,

     +   f_dayavg_airtk_ngood,f_dayavg_airtk_nbad,
     +   f_dayavg_airtk_min_k,f_dayavg_airtk_max_k,
     +   f_dayavg_airtk_avg_k, 
     +   f_dayavg_slpres_ngood,f_dayavg_slpres_nbad,
     +   f_dayavg_slpres_min_hpa,f_dayavg_slpres_max_hpa,
     +   f_dayavg_slpres_avg_hpa)

      IMPLICIT NONE
c************************************************************************
      INTEGER             :: l_prod
      REAL                :: f_ndflag

      REAL                :: f_dayavg_airt_c(100000)
      REAL                :: f_dayavg_vapprs_mb(100000)
      REAL                :: f_dayavg_ccov_okta(100000)
      REAL                :: f_dayavg_pres_mb(100000)
      REAL                :: f_dayavg_relh_pc(100000)
      REAL                :: f_dayavg_wspd_ms(100000)
      REAL                :: f_daymax_airt_c(100000)
      REAL                :: f_daymin_airt_c(100000)
      REAL                :: f_daymin_minbod_c(100000)
      REAL                :: f_daymax_gust_ms(100000)
      REAL                :: f_daytot_ppt_mm(100000)
      REAL                :: f_daytot_sundur_h(100000)
      REAL                :: f_daytot_snoacc_cm(100000) 
c****
      REAL                :: f_dayavg_airt_k(100000)
      REAL                :: f_dayavg_slpres_hpa(100000)
c****
      REAL                :: f_dayavg_airt_ngood,f_dayavg_airt_nbad
      REAL                :: f_dayavg_airt_min_c
      REAL                :: f_dayavg_airt_max_c
      REAL                :: f_dayavg_airt_avg_c 

      REAL                :: f_dayavg_vapprs_ngood,f_dayavg_vapprs_nbad
      REAL                :: f_dayavg_vapprs_min_mb
      REAL                :: f_dayavg_vapprs_max_mb
      REAL                :: f_dayavg_vapprs_avg_mb 

      REAL                :: f_dayavg_ccov_ngood,f_dayavg_ccov_nbad
      REAL                :: f_dayavg_ccov_min_okta
      REAL                :: f_dayavg_ccov_max_okta
      REAL                :: f_dayavg_ccov_avg_okta 

      REAL                :: f_dayavg_pres_ngood,f_dayavg_pres_nbad
      REAL                :: f_dayavg_pres_min_mb
      REAL                :: f_dayavg_pres_max_mb
      REAL                :: f_dayavg_pres_avg_mb 

      REAL                :: f_dayavg_relh_ngood,f_dayavg_relh_nbad
      REAL                :: f_dayavg_relh_min_pc
      REAL                :: f_dayavg_relh_max_pc
      REAL                :: f_dayavg_relh_avg_pc 

      REAL                :: f_dayavg_wspd_ngood,f_dayavg_wspd_nbad
      REAL                :: f_dayavg_wspd_min_ms
      REAL                :: f_dayavg_wspd_max_ms
      REAL                :: f_dayavg_wspd_avg_ms 

      REAL                :: f_daymax_airt_ngood,f_daymax_airt_nbad
      REAL                :: f_daymax_airt_min_c
      REAL                :: f_daymax_airt_max_c
      REAL                :: f_daymax_airt_avg_c 

      REAL                :: f_daymin_airt_ngood,f_daymin_airt_nbad
      REAL                :: f_daymin_airt_min_c
      REAL                :: f_daymin_airt_max_c
      REAL                :: f_daymin_airt_avg_c 

      REAL                :: f_daymin_minbod_ngood,f_daymin_minbod_nbad
      REAL                :: f_daymin_minbod_min_c
      REAL                :: f_daymin_minbod_max_c
      REAL                :: f_daymin_minbod_avg_c 

      REAL                :: f_daymax_gust_ngood,f_daymax_gust_nbad
      REAL                :: f_daymax_gust_min_ms
      REAL                :: f_daymax_gust_max_ms
      REAL                :: f_daymax_gust_avg_ms 

      REAL                :: f_daytot_ppt_ngood,f_daytot_ppt_nbad
      REAL                :: f_daytot_ppt_min_mm
      REAL                :: f_daytot_ppt_max_mm
      REAL                :: f_daytot_ppt_avg_mm 

      REAL                :: f_daytot_sundur_ngood,f_daytot_sundur_nbad
      REAL                :: f_daytot_sundur_min_h
      REAL                :: f_daytot_sundur_max_h
      REAL                :: f_daytot_sundur_avg_h 

      REAL                :: f_daytot_snoacc_ngood,f_daytot_snoacc_nbad
      REAL                :: f_daytot_snoacc_min_cm
      REAL                :: f_daytot_snoacc_max_cm
      REAL                :: f_daytot_snoacc_avg_cm
c****
      REAL                :: f_dayavg_airtk_ngood
      REAL                :: f_dayavg_airtk_nbad
      REAL                :: f_dayavg_airtk_min_k
      REAL                :: f_dayavg_airtk_max_k
      REAL                :: f_dayavg_airtk_avg_k 

      REAL                :: f_dayavg_slpres_ngood
      REAL                :: f_dayavg_slpres_nbad
      REAL                :: f_dayavg_slpres_min_hpa
      REAL                :: f_dayavg_slpres_max_hpa
      REAL                :: f_dayavg_slpres_avg_hpa

      INTEGER             :: i,j,k,ii,jj,kk
c************************************************************************
c      print*,'just inside calc_basic_stats_dd'
c      print*,'f_dayavg_airt_c=',(f_dayavg_airt_c(i),i=1,5)
c      print*,'f_dayavg_airt_k=',(f_dayavg_airt_k(i),i=1,5)

c      print*,'f_dayavg_pres_mb=',(f_dayavg_pres_mb(i),i=1,5)
c      print*,'f_dayavg_slpres_hpa=',(f_dayavg_slpres_hpa(i),i=1,5)

c     Find stats dayavg_airt
      CALL dwd_day_stat_package(l_prod,f_ndflag,f_dayavg_airt_c,
     + f_dayavg_airt_min_c,f_dayavg_airt_max_c,f_dayavg_airt_avg_c,
     + f_dayavg_airt_ngood,f_dayavg_airt_nbad)

c      print*,'dayavg_airt stat',
c     +   f_dayavg_airt_min_c,f_dayavg_airt_max_c,f_dayavg_airt_avg_c
c      print*,'airt cnt',f_dayavg_airt_ngood,f_dayavg_airt_nbad
c************************************************************************
c     Find stats dayavg_vapprs_mb
      CALL dwd_day_stat_package(l_prod,f_ndflag,f_dayavg_vapprs_mb,
     + f_dayavg_vapprs_min_mb,f_dayavg_vapprs_max_mb,
     +   f_dayavg_vapprs_avg_mb,
     + f_dayavg_vapprs_ngood,f_dayavg_vapprs_nbad)

c      print*,'dayavg_vapprs stat',
c     +   f_dayavg_vapprs_min_mb,f_dayavg_vapprs_max_mb,
c     +       f_dayavg_vapprs_avg_mb
c      print*,'vapprs cnt',f_dayavg_vapprs_ngood,f_dayavg_vapprs_nbad
c************************************************************************
c     Find stats dayavg_ccov
      CALL dwd_day_stat_package(l_prod,f_ndflag,f_dayavg_ccov_okta,
     + f_dayavg_ccov_min_okta,f_dayavg_ccov_max_okta,
     +   f_dayavg_ccov_avg_okta,
     + f_dayavg_ccov_ngood,f_dayavg_ccov_nbad)

c      print*,'dayavg_ccov stat',
c     +   f_dayavg_ccov_min_okta,f_dayavg_ccov_max_okta,
c     +   f_dayavg_ccov_avg_okta
c      print*,'ccov cnt',f_dayavg_ccov_ngood,f_dayavg_ccov_nbad
c************************************************************************
c     Find stats dayavg_pres
      CALL dwd_day_stat_package(l_prod,f_ndflag,f_dayavg_pres_mb,
     + f_dayavg_pres_min_mb,f_dayavg_pres_max_mb,f_dayavg_pres_avg_mb,
     + f_dayavg_pres_ngood,f_dayavg_pres_nbad)

c      print*,'dayavg_pres stat',
c     +   f_dayavg_pres_min_mb,f_dayavg_pres_max_mb,f_dayavg_pres_avg_mb
c      print*,'pres cnt',f_dayavg_pres_ngood,f_dayavg_pres_nbad
c************************************************************************
c     Find stats dayavg_relh
      CALL dwd_day_stat_package(l_prod,f_ndflag,f_dayavg_relh_pc,
     + f_dayavg_relh_min_pc,f_dayavg_relh_max_pc,f_dayavg_relh_avg_pc,
     + f_dayavg_relh_ngood,f_dayavg_relh_nbad)

c      print*,'dayavg_relh stat',
c     +   f_dayavg_relh_min_pc,f_dayavg_relh_max_pc,f_dayavg_relh_avg_pc
c      print*,'relh cnt',f_dayavg_relh_ngood,f_dayavg_relh_nbad
c************************************************************************
c     Find stats dayavg_wspd
      CALL dwd_day_stat_package(l_prod,f_ndflag,f_dayavg_wspd_ms,
     + f_dayavg_wspd_min_ms,f_dayavg_wspd_max_ms,f_dayavg_wspd_avg_ms,
     + f_dayavg_wspd_ngood,f_dayavg_wspd_nbad)

c      print*,'dayavg_wspd stat',
c     +   f_dayavg_wspd_min_ms,f_dayavg_wspd_max_ms,f_dayavg_wspd_avg_ms
c      print*,'wspd cnt',f_dayavg_wspd_ngood,f_dayavg_wspd_nbad
c************************************************************************
c     Find stats daymax_airt
      CALL dwd_day_stat_package(l_prod,f_ndflag,f_daymax_airt_c,
     + f_daymax_airt_min_c,f_daymax_airt_max_c,f_daymax_airt_avg_c,
     + f_daymax_airt_ngood,f_daymax_airt_nbad)

c      print*,'daymax_airt stat',
c     +   f_daymax_airt_min_c,f_daymax_airt_max_c,f_daymax_airt_avg_c
c      print*,'airt cnt',f_daymax_airt_ngood,f_daymax_airt_nbad
c************************************************************************
c     Find stats daymin_airt
      CALL dwd_day_stat_package(l_prod,f_ndflag,f_daymin_airt_c,
     + f_daymin_airt_min_c,f_daymin_airt_max_c,f_daymin_airt_avg_c,
     + f_daymin_airt_ngood,f_daymin_airt_nbad)

c      print*,'daymin_airt stat',
c     +   f_daymin_airt_min_c,f_daymin_airt_max_c,f_daymin_airt_avg_c
c      print*,'airt cnt',f_daymin_airt_ngood,f_daymin_airt_nbad
c************************************************************************
c     Find stats daymin_airt
      CALL dwd_day_stat_package(l_prod,f_ndflag,f_daymin_minbod_c,
     + f_daymin_minbod_min_c,f_daymin_minbod_max_c,
     +   f_daymin_minbod_avg_c,
     + f_daymin_minbod_ngood,f_daymin_minbod_nbad)

c      print*,'daymin_minbod stat',
c     +   f_daymin_minbod_min_c,f_daymin_minbod_max_c, 
c     +   f_daymin_minbod_avg_c
c      print*,'minbod cnt',f_daymin_minbod_ngood,f_daymin_minbod_nbad
c************************************************************************
c     Find stats dayavg_gust
      CALL dwd_day_stat_package(l_prod,f_ndflag,f_daymax_gust_ms,
     + f_daymax_gust_min_ms,f_daymax_gust_max_ms,f_daymax_gust_avg_ms,
     + f_daymax_gust_ngood,f_daymax_gust_nbad)

c      print*,'daymax_gust stat',
c     +   f_daymax_gust_min_ms,f_daymax_gust_max_ms,f_daymax_gust_avg_ms
c      print*,'gust cnt',f_daymax_gust_ngood,f_daymax_gust_nbad
c************************************************************************
c     Find stats daytot_ppt
      CALL dwd_day_stat_package(l_prod,f_ndflag,f_daytot_ppt_mm,
     + f_daytot_ppt_min_mm,f_daytot_ppt_max_mm,f_daytot_ppt_avg_mm,
     + f_daytot_ppt_ngood,f_daytot_ppt_nbad)

c      print*,'daytot_ppt stat',
c     +   f_daytot_ppt_min_mm,f_daytot_ppt_max_mm,f_daytot_ppt_avg_mm
c      print*,'ppt cnt',f_daytot_ppt_ngood,f_daytot_ppt_nbad
c************************************************************************
c     Find stats daytot_sundur
      CALL dwd_day_stat_package(l_prod,f_ndflag,f_daytot_sundur_h,
     + f_daytot_sundur_min_h,f_daytot_sundur_max_h,
     + f_daytot_sundur_avg_h,
     + f_daytot_sundur_ngood,f_daytot_sundur_nbad)

c      print*,'daytot_sundur stat',
c     +   f_daytot_sundur_min_h,f_daytot_sundur_max_h, 
c     +   f_daytot_sundur_avg_h
c      print*,'ppt cnt',f_daytot_sundur_ngood,f_daytot_sundur_nbad
c************************************************************************
c     Find stats daytot_snoacc
      CALL dwd_day_stat_package(l_prod,f_ndflag,f_daytot_snoacc_cm,
     + f_daytot_snoacc_min_cm,f_daytot_snoacc_max_cm,
     + f_daytot_snoacc_avg_cm,
     + f_daytot_snoacc_ngood,f_daytot_snoacc_nbad)

c      print*,'daytot_snoacc stat',
c     +   f_daytot_snoacc_min_cm,f_daytot_snoacc_max_cm, 
c     +   f_daytot_snoacc_avg_cm
c      print*,'snoacc cnt',f_daytot_snoacc_ngood,f_daytot_snoacc_nbad
c************************************************************************
c************************************************************************
c     Find stats dayavg_airt
      CALL dwd_day_stat_package(l_prod,f_ndflag,f_dayavg_airt_k,
     + f_dayavg_airtk_min_k,f_dayavg_airtk_max_k,f_dayavg_airtk_avg_k,
     + f_dayavg_airtk_ngood,f_dayavg_airtk_nbad)

c     Find stats dayavg_pres
      CALL dwd_day_stat_package(l_prod,f_ndflag,f_dayavg_slpres_hpa,
     + f_dayavg_slpres_min_hpa,f_dayavg_slpres_max_hpa,
     + f_dayavg_slpres_avg_hpa,
     + f_dayavg_slpres_ngood,f_dayavg_slpres_nbad)

c      print*,'f_dayavg_airt_ngood=', f_dayavg_airt_ngood
c      print*,'f_dayavg_airtk_ngood=',f_dayavg_airtk_ngood
c      print*,'f_dayavg_pres_ngood=', f_dayavg_pres_ngood
c      print*,'f_dayavg_slpres_ngood=',f_dayavg_slpres_ngood
c      print*,'just leaving calc_basic_stats_dd'

      RETURN
      END