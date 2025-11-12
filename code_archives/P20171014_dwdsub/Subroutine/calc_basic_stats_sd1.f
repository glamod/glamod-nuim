c     Subroutine to calc basic stats for assembled vectors
c     AJ_Kettle, Oct26/2017

      SUBROUTINE calc_basic_stats_sd1(l_mlent,j_sd,j_day,f_ndflag,
     +  ft_sd_pres_hpa,ft_sd_airt_c,ft_sd_wetb_c,
     +  ft_sd_vprs_hpa,ft_sd_relh_pc,ft_sd_relhreg_pc,
     +  ft_sd_wdir_code,ft_sd_wspd_bft,ft_sd_ccov_okta,
     +  ft_sd_visi_code,ft_sd_grdcnd_code,ft_sd_ppt_mm,

     +  ft_pres_dayavg_hpa,ft_airt_daymax_c,ft_airt_daymin_c,
     +  ft_airt_range_c,ft_boden_daymin_c,ft_airt_dayavg_c,
     +  ft_vprs_dayavg_hpa,ft_relh_dayavg_pc,ft_wspd_dayavg_bft,
     +  ft_ccov_dayavg_okta,ft_sundur_daytot_h,ft_ppt_daytot_mm,
     +  ft_snowcover_cm,ft_snow_daytot_cm,ft_wspd_daymax_ms,
     +  ft_snowmelted_cm,ft_we_snowmelted_mm,ft_we_snowcover_mm,

     +  ft_sd_pres_min_hpa,ft_sd_pres_max_hpa,ft_sd_pres_avg_hpa,
     +    ft_sd_pres_ngood,ft_sd_pres_nbad,
     +  ft_sd_airt_min_c,ft_sd_airt_max_c,ft_sd_airt_avg_c, 
     +    ft_sd_airt_ngood,ft_sd_airt_nbad,
     +  ft_sd_wetb_min_c,ft_sd_wetb_max_c,ft_sd_wetb_avg_c,
     +    ft_sd_wetb_ngood,ft_sd_wetb_nbad,
     +  ft_sd_vprs_min_hpa,ft_sd_vprs_max_hpa,ft_sd_vprs_avg_hpa,
     +    ft_sd_vprs_ngood,ft_sd_vprs_nbad,
     +  ft_sd_relh_min_pc,ft_sd_relh_max_pc,ft_sd_relh_avg_pc,
     +    ft_sd_relh_ngood,ft_sd_relh_nbad,
     +  ft_sd_relhreg_min_pc,ft_sd_relhreg_max_pc,
     +    ft_sd_relhreg_avg_pc,
     +    ft_sd_relhreg_ngood,ft_sd_relhreg_nbad,
     +  ft_sd_wdir_min_code,ft_sd_wdir_max_code,ft_sd_wdir_avg_code,
     +    ft_sd_wdir_ngood,ft_sd_wdir_nbad,
     +  ft_sd_wspd_min_bft,ft_sd_wspd_max_bft,ft_sd_wspd_avg_bft,
     +    ft_sd_wspd_ngood,ft_sd_wspd_nbad,
     +  ft_sd_ccov_min_okta,ft_sd_ccov_max_okta,
     +    ft_sd_ccov_avg_okta,
     +    ft_sd_ccov_ngood,ft_sd_ccov_nbad,
     +  ft_sd_visi_min_code,ft_sd_visi_max_code,
     +    ft_sd_visi_avg_code,
     +    ft_sd_visi_ngood,ft_sd_visi_nbad,
     +  ft_sd_grdcnd_min_code,ft_sd_grdcnd_max_code,
     +    ft_sd_grdcnd_avg_code,
     +    ft_sd_grdcnd_ngood,ft_sd_grdcnd_nbad,
     +  ft_sd_ppt_min_mm,ft_sd_ppt_max_mm,ft_sd_ppt_avg_mm,
     +    ft_sd_ppt_ngood,ft_sd_ppt_nbad,

     +  ft_day_pres_min_hpa,ft_day_pres_max_hpa,
     +    ft_day_pres_avg_hpa,
     +    ft_day_pres_ngood,ft_day_pres_nbad,
     +  ft_day_airt_daymax_min_c,ft_day_airt_daymax_max_c,
     +    ft_day_airt_daymax_avg_c,
     +    ft_day_airt_daymax_ngood,ft_day_airt_daymax_nbad,
     +  ft_day_airt_daymin_min_c,ft_day_airt_daymin_max_c,
     +    ft_day_airt_daymin_avg_c,
     +    ft_day_airt_daymin_ngood,ft_day_airt_daymin_nbad,
     +  ft_day_airt_range_min_c,ft_day_airt_range_max_c,
     +    ft_day_airt_range_avg_c,
     +    ft_day_airt_range_ngood,ft_day_airt_range_nbad,
     +  ft_day_boden_daymin_min_c,ft_day_boden_daymin_max_c,
     +    ft_day_boden_daymin_avg_c,
     +    ft_day_boden_daymin_ngood,ft_day_boden_daymin_nbad,
     +  ft_day_airt_dayavg_min_c,ft_day_airt_dayavg_max_c,
     +    ft_day_airt_dayavg_avg_c,
     +    ft_day_airt_dayavg_ngood,ft_day_airt_dayavg_nbad,
     +  ft_day_vprs_dayavg_min_hpa,ft_day_vprs_dayavg_max_hpa,
     +    ft_day_vprs_dayavg_avg_hpa,
     +    ft_day_vprs_dayavg_ngood,ft_day_vprs_dayavg_nbad,
     +  ft_day_relh_dayavg_min_pc,ft_day_relh_dayavg_max_pc,
     +    ft_day_relh_dayavg_avg_pc,
     +    ft_day_relh_dayavg_ngood,ft_day_relh_dayavg_nbad,
     +  ft_day_wspd_dayavg_min_bft,ft_day_wspd_dayavg_max_bft,
     +    ft_day_wspd_dayavg_avg_bft,
     +    ft_day_wspd_dayavg_ngood,ft_day_wspd_dayavg_nbad,
     +  ft_day_ccov_dayavg_min_okta,ft_day_ccov_dayavg_max_okta,
     +    ft_day_ccov_dayavg_avg_okta,
     +    ft_day_ccov_dayavg_ngood,ft_day_ccov_dayavg_nbad,
     +  ft_day_sundur_daytot_min_h,ft_day_sundur_daytot_max_h,
     +    ft_day_sundur_daytot_avg_h,
     +    ft_day_sundur_daytot_ngood,ft_day_sundur_daytot_nbad,
     +  ft_day_ppt_daytot_min_mm,ft_day_ppt_daytot_max_mm,
     +    ft_day_ppt_daytot_avg_mm,
     +    ft_day_ppt_daytot_ngood,ft_day_ppt_daytot_nbad,
     +  ft_day_snowcover_min_cm,ft_day_snowcover_max_cm,
     +    ft_day_snowcover_avg_cm,
     +    ft_day_snowcover_ngood,ft_day_snowcover_nbad,
     +  ft_day_snow_daytot_min_cm,ft_day_snow_daytot_max_cm,
     +    ft_day_snow_daytot_avg_cm,
     +    ft_day_snow_daytot_ngood,ft_day_snow_daytot_nbad,
     +  ft_day_wspd_daymax_min_ms,ft_day_wspd_daymax_max_ms,
     +    ft_day_wspd_daymax_avg_ms,
     +    ft_day_wspd_daymax_ngood,ft_day_wspd_daymax_nbad,
     +  ft_day_snowmelted_min_cm,ft_day_snowmelted_max_cm,
     +    ft_day_snowmelted_avg_cm,
     +    ft_day_snowmelted_ngood,ft_day_snowmelted_nbad,
     +  ft_day_we_snowmelted_min_mm,ft_day_we_snowmelted_max_mm,
     +    ft_day_we_snowmelted_avg_mm,
     +    ft_day_we_snowmelted_ngood,ft_day_we_snowmelted_nbad,
     +  ft_day_we_snowcover_min_mm,ft_day_we_snowcover_max_mm,
     +    ft_day_we_snowcover_avg_mm,
     +    ft_day_we_snowcover_ngood,ft_day_we_snowcover_nbad)

      IMPLICIT NONE
c************************************************************************
      REAL                :: f_ndflag

      INTEGER             :: l_mlent
      INTEGER             :: j_sd
      REAL                :: ft_sd_pres_hpa(l_mlent)
      REAL                :: ft_sd_airt_c(l_mlent)
      REAL                :: ft_sd_wetb_c(l_mlent)
      REAL                :: ft_sd_vprs_hpa(l_mlent)
      REAL                :: ft_sd_relh_pc(l_mlent)
      REAL                :: ft_sd_relhreg_pc(l_mlent)
      REAL                :: ft_sd_wdir_code(l_mlent)
      REAL                :: ft_sd_wspd_bft(l_mlent)
      REAL                :: ft_sd_ccov_okta(l_mlent)
      REAL                :: ft_sd_visi_code(l_mlent)
      REAL                :: ft_sd_grdcnd_code(l_mlent)
      REAL                :: ft_sd_ppt_mm(l_mlent)

      INTEGER             :: j_day
      REAL                :: ft_pres_dayavg_hpa(l_mlent)
      REAL                :: ft_airt_daymax_c(l_mlent)
      REAL                :: ft_airt_daymin_c(l_mlent)
      REAL                :: ft_airt_range_c(l_mlent)
      REAL                :: ft_boden_daymin_c(l_mlent)
      REAL                :: ft_airt_dayavg_c(l_mlent)
      REAL                :: ft_vprs_dayavg_hpa(l_mlent)
      REAL                :: ft_relh_dayavg_pc(l_mlent)
      REAL                :: ft_wspd_dayavg_bft(l_mlent)
      REAL                :: ft_ccov_dayavg_okta(l_mlent)
      REAL                :: ft_sundur_daytot_h(l_mlent)
      REAL                :: ft_ppt_daytot_mm(l_mlent)
      REAL                :: ft_snowcover_cm(l_mlent)
      REAL                :: ft_snow_daytot_cm(l_mlent)
      REAL                :: ft_wspd_daymax_ms(l_mlent)
      REAL                :: ft_snowmelted_cm(l_mlent)
      REAL                :: ft_we_snowmelted_mm(l_mlent)
      REAL                :: ft_we_snowcover_mm(l_mlent)
c****
c     Output variables

      REAL                :: ft_sd_pres_min_hpa
      REAL                :: ft_sd_pres_max_hpa
      REAL                :: ft_sd_pres_avg_hpa
      REAL                :: ft_sd_pres_ngood
      REAL                :: ft_sd_pres_nbad

      REAL                :: ft_sd_airt_min_c
      REAL                :: ft_sd_airt_max_c
      REAL                :: ft_sd_airt_avg_c
      REAL                :: ft_sd_airt_ngood
      REAL                :: ft_sd_airt_nbad

      REAL                :: ft_sd_wetb_min_c
      REAL                :: ft_sd_wetb_max_c
      REAL                :: ft_sd_wetb_avg_c
      REAL                :: ft_sd_wetb_ngood
      REAL                :: ft_sd_wetb_nbad

      REAL                :: ft_sd_vprs_min_hpa
      REAL                :: ft_sd_vprs_max_hpa
      REAL                :: ft_sd_vprs_avg_hpa
      REAL                :: ft_sd_vprs_ngood
      REAL                :: ft_sd_vprs_nbad

      REAL                :: ft_sd_relh_min_pc
      REAL                :: ft_sd_relh_max_pc
      REAL                :: ft_sd_relh_avg_pc
      REAL                :: ft_sd_relh_ngood
      REAL                :: ft_sd_relh_nbad

      REAL                :: ft_sd_relhreg_min_pc
      REAL                :: ft_sd_relhreg_max_pc
      REAL                :: ft_sd_relhreg_avg_pc
      REAL                :: ft_sd_relhreg_ngood
      REAL                :: ft_sd_relhreg_nbad

      REAL                :: ft_sd_wdir_min_code
      REAL                :: ft_sd_wdir_max_code
      REAL                :: ft_sd_wdir_avg_code
      REAL                :: ft_sd_wdir_ngood
      REAL                :: ft_sd_wdir_nbad

      REAL                :: ft_sd_wspd_min_bft
      REAL                :: ft_sd_wspd_max_bft
      REAL                :: ft_sd_wspd_avg_bft
      REAL                :: ft_sd_wspd_ngood
      REAL                :: ft_sd_wspd_nbad

      REAL                :: ft_sd_ccov_min_okta
      REAL                :: ft_sd_ccov_max_okta
      REAL                :: ft_sd_ccov_avg_okta
      REAL                :: ft_sd_ccov_ngood
      REAL                :: ft_sd_ccov_nbad

      REAL                :: ft_sd_visi_min_code
      REAL                :: ft_sd_visi_max_code
      REAL                :: ft_sd_visi_avg_code
      REAL                :: ft_sd_visi_ngood
      REAL                :: ft_sd_visi_nbad

      REAL                :: ft_sd_grdcnd_min_code
      REAL                :: ft_sd_grdcnd_max_code
      REAL                :: ft_sd_grdcnd_avg_code
      REAL                :: ft_sd_grdcnd_ngood
      REAL                :: ft_sd_grdcnd_nbad

      REAL                :: ft_sd_ppt_min_mm
      REAL                :: ft_sd_ppt_max_mm
      REAL                :: ft_sd_ppt_avg_mm
      REAL                :: ft_sd_ppt_ngood
      REAL                :: ft_sd_ppt_nbad
c****
      REAL                :: ft_day_pres_min_hpa
      REAL                :: ft_day_pres_max_hpa
      REAL                :: ft_day_pres_avg_hpa
      REAL                :: ft_day_pres_ngood
      REAL                :: ft_day_pres_nbad

      REAL                :: ft_day_airt_daymax_min_c
      REAL                :: ft_day_airt_daymax_max_c
      REAL                :: ft_day_airt_daymax_avg_c
      REAL                :: ft_day_airt_daymax_ngood
      REAL                :: ft_day_airt_daymax_nbad

      REAL                :: ft_day_airt_daymin_min_c
      REAL                :: ft_day_airt_daymin_max_c
      REAL                :: ft_day_airt_daymin_avg_c
      REAL                :: ft_day_airt_daymin_ngood
      REAL                :: ft_day_airt_daymin_nbad

      REAL                :: ft_day_airt_range_min_c
      REAL                :: ft_day_airt_range_max_c
      REAL                :: ft_day_airt_range_avg_c
      REAL                :: ft_day_airt_range_ngood
      REAL                :: ft_day_airt_range_nbad

      REAL                :: ft_day_boden_daymin_min_c
      REAL                :: ft_day_boden_daymin_max_c
      REAL                :: ft_day_boden_daymin_avg_c
      REAL                :: ft_day_boden_daymin_ngood
      REAL                :: ft_day_boden_daymin_nbad

      REAL                :: ft_day_airt_dayavg_min_c
      REAL                :: ft_day_airt_dayavg_max_c
      REAL                :: ft_day_airt_dayavg_avg_c
      REAL                :: ft_day_airt_dayavg_ngood
      REAL                :: ft_day_airt_dayavg_nbad

      REAL                :: ft_day_vprs_dayavg_min_hpa
      REAL                :: ft_day_vprs_dayavg_max_hpa
      REAL                :: ft_day_vprs_dayavg_avg_hpa
      REAL                :: ft_day_vprs_dayavg_ngood
      REAL                :: ft_day_vprs_dayavg_nbad

      REAL                :: ft_day_relh_dayavg_min_pc
      REAL                :: ft_day_relh_dayavg_max_pc
      REAL                :: ft_day_relh_dayavg_avg_pc
      REAL                :: ft_day_relh_dayavg_ngood
      REAL                :: ft_day_relh_dayavg_nbad

      REAL                :: ft_day_wspd_dayavg_min_bft
      REAL                :: ft_day_wspd_dayavg_max_bft
      REAL                :: ft_day_wspd_dayavg_avg_bft
      REAL                :: ft_day_wspd_dayavg_ngood
      REAL                :: ft_day_wspd_dayavg_nbad

      REAL                :: ft_day_ccov_dayavg_min_okta
      REAL                :: ft_day_ccov_dayavg_max_okta
      REAL                :: ft_day_ccov_dayavg_avg_okta
      REAL                :: ft_day_ccov_dayavg_ngood
      REAL                :: ft_day_ccov_dayavg_nbad

      REAL                :: ft_day_sundur_daytot_min_h
      REAL                :: ft_day_sundur_daytot_max_h
      REAL                :: ft_day_sundur_daytot_avg_h
      REAL                :: ft_day_sundur_daytot_ngood
      REAL                :: ft_day_sundur_daytot_nbad

      REAL                :: ft_day_ppt_daytot_min_mm
      REAL                :: ft_day_ppt_daytot_max_mm
      REAL                :: ft_day_ppt_daytot_avg_mm
      REAL                :: ft_day_ppt_daytot_ngood
      REAL                :: ft_day_ppt_daytot_nbad

      REAL                :: ft_day_snowcover_min_cm
      REAL                :: ft_day_snowcover_max_cm
      REAL                :: ft_day_snowcover_avg_cm
      REAL                :: ft_day_snowcover_ngood
      REAL                :: ft_day_snowcover_nbad

      REAL                :: ft_day_snow_daytot_min_cm
      REAL                :: ft_day_snow_daytot_max_cm
      REAL                :: ft_day_snow_daytot_avg_cm
      REAL                :: ft_day_snow_daytot_ngood
      REAL                :: ft_day_snow_daytot_nbad

      REAL                :: ft_day_wspd_daymax_min_ms
      REAL                :: ft_day_wspd_daymax_max_ms
      REAL                :: ft_day_wspd_daymax_avg_ms
      REAL                :: ft_day_wspd_daymax_ngood
      REAL                :: ft_day_wspd_daymax_nbad

      REAL                :: ft_day_snowmelted_min_cm
      REAL                :: ft_day_snowmelted_max_cm
      REAL                :: ft_day_snowmelted_avg_cm
      REAL                :: ft_day_snowmelted_ngood
      REAL                :: ft_day_snowmelted_nbad

      REAL                :: ft_day_we_snowmelted_min_mm
      REAL                :: ft_day_we_snowmelted_max_mm
      REAL                :: ft_day_we_snowmelted_avg_mm
      REAL                :: ft_day_we_snowmelted_ngood
      REAL                :: ft_day_we_snowmelted_nbad

      REAL                :: ft_day_we_snowcover_min_mm
      REAL                :: ft_day_we_snowcover_max_mm
      REAL                :: ft_day_we_snowcover_avg_mm
      REAL                :: ft_day_we_snowcover_ngood
      REAL                :: ft_day_we_snowcover_nbad

c************************************************************************
      print*,'just inside calc_basic_stats_sd1'
c      print*,'l_mlent=',l_mlent

c     Find basic stats for single file
c     PRES
      CALL dwd_subday_stat_pack(l_mlent,j_sd,f_ndflag,
     +   ft_sd_pres_hpa,

     +   ft_sd_pres_min_hpa,ft_sd_pres_max_hpa,
     +   ft_sd_pres_avg_hpa,
     +   ft_sd_pres_ngood,ft_sd_pres_nbad)

c     AIRT
      CALL dwd_subday_stat_pack(l_mlent,j_sd,f_ndflag,
     +   ft_sd_airt_c,

     +   ft_sd_airt_min_c,ft_sd_airt_max_c,
     +   ft_sd_airt_avg_c,
     +   ft_sd_airt_ngood,ft_sd_airt_nbad)

c     WETB
      CALL dwd_subday_stat_pack(l_mlent,j_sd,f_ndflag,
     +   ft_sd_wetb_c,

     +   ft_sd_wetb_min_c,ft_sd_wetb_max_c,
     +   ft_sd_wetb_avg_c,
     +   ft_sd_wetb_ngood,ft_sd_wetb_nbad)

c     VPRS
      CALL dwd_subday_stat_pack(l_mlent,j_sd,f_ndflag,
     +   ft_sd_vprs_hpa,

     +   ft_sd_vprs_min_hpa,ft_sd_vprs_max_hpa,
     +   ft_sd_vprs_avg_hpa,
     +   ft_sd_vprs_ngood,ft_sd_vprs_nbad)

c     RELH
      CALL dwd_subday_stat_pack(l_mlent,j_sd,f_ndflag,
     +   ft_sd_relh_pc,

     +   ft_sd_relh_min_pc,ft_sd_relh_max_pc,
     +   ft_sd_relh_avg_pc,
     +   ft_sd_relh_ngood,ft_sd_relh_nbad)

c     RELHREG
      CALL dwd_subday_stat_pack(l_mlent,j_sd,f_ndflag,
     +   ft_sd_relhreg_pc,

     +   ft_sd_relhreg_min_pc,ft_sd_relhreg_max_pc,
     +   ft_sd_relhreg_avg_pc,
     +   ft_sd_relhreg_ngood,ft_sd_relhreg_nbad)

c     WDIR
      CALL dwd_subday_stat_pack(l_mlent,j_sd,f_ndflag,
     +   ft_sd_wdir_code,

     +   ft_sd_wdir_min_code,ft_sd_wdir_max_code,
     +   ft_sd_wdir_avg_code,
     +   ft_sd_wdir_ngood,ft_sd_wdir_nbad)

c     WSPD
      CALL dwd_subday_stat_pack(l_mlent,j_sd,f_ndflag,
     +   ft_sd_wspd_bft,

     +   ft_sd_wspd_min_bft,ft_sd_wspd_max_bft,
     +   ft_sd_wspd_avg_bft,
     +   ft_sd_wspd_ngood,ft_sd_wspd_nbad)

c     CCOV
      CALL dwd_subday_stat_pack(l_mlent,j_sd,f_ndflag,
     +   ft_sd_ccov_okta,

     +   ft_sd_ccov_min_okta,ft_sd_ccov_max_okta,
     +   ft_sd_ccov_avg_okta,
     +   ft_sd_ccov_ngood,ft_sd_ccov_nbad)

c     VISI
      CALL dwd_subday_stat_pack(l_mlent,j_sd,f_ndflag,
     +   ft_sd_visi_code,

     +   ft_sd_visi_min_code,ft_sd_visi_max_code,
     +   ft_sd_visi_avg_code,
     +   ft_sd_visi_ngood,ft_sd_visi_nbad)

c     GRDCND
      CALL dwd_subday_stat_pack(l_mlent,j_sd,f_ndflag,
     +   ft_sd_grdcnd_code,

     +   ft_sd_grdcnd_min_code,ft_sd_grdcnd_max_code,
     +   ft_sd_grdcnd_avg_code,
     +   ft_sd_grdcnd_ngood,ft_sd_grdcnd_nbad)

c     PPT
      CALL dwd_subday_stat_pack(l_mlent,j_sd,f_ndflag,
     +   ft_sd_ppt_mm,

     +   ft_sd_ppt_min_mm,ft_sd_ppt_max_mm,
     +   ft_sd_ppt_avg_mm,
     +   ft_sd_ppt_ngood,ft_sd_ppt_nbad)
c************************************************************************
c************************************************************************
c     Find basic stats for single file
c     PRES_DAYAVG
      CALL dwd_subday_stat_pack(l_mlent,j_day,f_ndflag,
     +   ft_pres_dayavg_hpa,

     +   ft_day_pres_min_hpa,ft_day_pres_max_hpa,
     +   ft_day_pres_avg_hpa,
     +   ft_day_pres_ngood,ft_day_pres_nbad)

c     AIRT_DAYMAX
      CALL dwd_subday_stat_pack(l_mlent,j_day,f_ndflag,
     +   ft_airt_daymax_c,

     +   ft_day_airt_daymax_min_c,ft_day_airt_daymax_max_c,
     +   ft_day_airt_daymax_avg_c,
     +   ft_day_airt_daymax_ngood,ft_day_airt_daymax_nbad)

c     AIRT_DAYMIN
      CALL dwd_subday_stat_pack(l_mlent,j_day,f_ndflag,
     +   ft_airt_daymin_c,

     +   ft_day_airt_daymin_min_c,ft_day_airt_daymin_max_c,
     +   ft_day_airt_daymin_avg_c,
     +   ft_day_airt_daymin_ngood,ft_day_airt_daymin_nbad)

c     AIRT_RANGE
      CALL dwd_subday_stat_pack(l_mlent,j_day,f_ndflag,
     +   ft_airt_range_c,

     +   ft_day_airt_range_min_c,ft_day_airt_daymin_max_c,
     +   ft_day_airt_range_avg_c,
     +   ft_day_airt_range_ngood,ft_day_airt_range_nbad)

c     BODEN_DAYMIN
      CALL dwd_subday_stat_pack(l_mlent,j_day,f_ndflag,
     +   ft_boden_daymin_c,

     +   ft_day_boden_daymin_min_c,ft_day_boden_daymin_max_c,
     +   ft_day_boden_daymin_avg_c,
     +   ft_day_boden_daymin_ngood,ft_day_boden_daymin_nbad)

c     AIRT_DAYAVG
      CALL dwd_subday_stat_pack(l_mlent,j_day,f_ndflag,
     +   ft_airt_dayavg_c,

     +   ft_day_airt_dayavg_min_c,ft_day_airt_dayavg_max_c,
     +   ft_day_airt_dayavg_avg_c,
     +   ft_day_airt_dayavg_ngood,ft_day_airt_dayavg_nbad)

c     VPRS_DAYAVG
      CALL dwd_subday_stat_pack(l_mlent,j_day,f_ndflag,
     +   ft_vprs_dayavg_hpa,

     +   ft_day_vprs_dayavg_min_hpa,ft_day_vprs_dayavg_max_hpa,
     +   ft_day_vprs_dayavg_avg_hpa,
     +   ft_day_vprs_dayavg_ngood,ft_day_vprs_dayavg_nbad)

c     RELH_DAYAVG
      CALL dwd_subday_stat_pack(l_mlent,j_day,f_ndflag,
     +   ft_relh_dayavg_pc,

     +   ft_day_relh_dayavg_min_pc,ft_day_relh_dayavg_max_pc,
     +   ft_day_relh_dayavg_avg_pc,
     +   ft_day_relh_dayavg_ngood,ft_day_relh_dayavg_nbad)

c     WSPD_DAYAVG
      CALL dwd_subday_stat_pack(l_mlent,j_day,f_ndflag,
     +   ft_wspd_dayavg_bft,

     +   ft_day_wspd_dayavg_min_bft,ft_day_wspd_dayavg_max_bft,
     +   ft_day_wspd_dayavg_avg_bft,
     +   ft_day_wspd_dayavg_ngood,ft_day_wspd_dayavg_nbad)

c     CCOV_DAYAVG
      CALL dwd_subday_stat_pack(l_mlent,j_day,f_ndflag,
     +   ft_ccov_dayavg_okta,

     +   ft_day_ccov_dayavg_min_okta,ft_day_ccov_dayavg_max_okta,
     +   ft_day_ccov_dayavg_avg_okta,
     +   ft_day_ccov_dayavg_ngood,ft_day_ccov_dayavg_nbad)

c     SUNDUR_DAYTOT
      CALL dwd_subday_stat_pack(l_mlent,j_day,f_ndflag,
     +   ft_sundur_daytot_h,

     +   ft_day_sundur_daytot_min_h,ft_day_sundur_daytot_max_h,
     +   ft_day_sundur_daytot_avg_h,
     +   ft_day_sundur_daytot_ngood,ft_day_sundur_daytot_nbad)

c     PPT_DAYTOT
      CALL dwd_subday_stat_pack(l_mlent,j_day,f_ndflag,
     +   ft_ppt_daytot_mm,

     +   ft_day_ppt_daytot_min_mm,ft_day_ppt_daytot_max_mm,
     +   ft_day_ppt_daytot_avg_mm,
     +   ft_day_ppt_daytot_ngood,ft_day_ppt_daytot_nbad)

c     SNOWCOVER
      CALL dwd_subday_stat_pack(l_mlent,j_day,f_ndflag,
     +   ft_snowcover_cm,

     +   ft_day_snowcover_min_cm,ft_day_snowcover_max_cm,
     +   ft_day_snowcover_avg_cm,
     +   ft_day_snowcover_ngood,ft_day_snowcover_nbad)

c     SNOW_DAYTOT
      CALL dwd_subday_stat_pack(l_mlent,j_day,f_ndflag,
     +   ft_snow_daytot_cm,

     +   ft_day_snow_daytot_min_cm,ft_day_snow_daytot_max_cm,
     +   ft_day_snow_daytot_avg_cm,
     +   ft_day_snow_daytot_ngood,ft_day_snow_daytot_nbad)

c     WSPD_DAYMAX
      CALL dwd_subday_stat_pack(l_mlent,j_day,f_ndflag,
     +   ft_wspd_daymax_ms,

     +   ft_day_wspd_daymax_min_ms,ft_day_wspd_daymax_max_ms,
     +   ft_day_wspd_daymax_avg_ms,
     +   ft_day_wspd_daymax_ngood,ft_day_wspd_daymax_nbad)

c     SNOWMELTED
      CALL dwd_subday_stat_pack(l_mlent,j_day,f_ndflag,
     +   ft_snowmelted_cm,

     +   ft_day_snowmelted_min_cm,ft_day_snowmelted_max_cm,
     +   ft_day_snowmelted_avg_cm,
     +   ft_day_snowmelted_ngood,ft_day_snowmelted_nbad)

c     WE_SNOWMELTED
      CALL dwd_subday_stat_pack(l_mlent,j_day,f_ndflag,
     +   ft_we_snowmelted_mm,

     +   ft_day_we_snowmelted_min_mm,ft_day_we_snowmelted_max_mm,
     +   ft_day_we_snowmelted_avg_mm,
     +   ft_day_we_snowmelted_ngood,ft_day_we_snowmelted_nbad)

c     WE_SNOWCOVER
      CALL dwd_subday_stat_pack(l_mlent,j_day,f_ndflag,
     +   ft_we_snowcover_mm,

     +   ft_day_we_snowcover_min_mm,ft_day_we_snowcover_max_mm,
     +   ft_day_we_snowcover_avg_mm,
     +   ft_day_we_snowcover_ngood,ft_day_we_snowcover_nbad)

c************************************************************************
      GOTO 18

c     Output stats
      print*,'ft_sd_pres_ngood=', ft_sd_pres_ngood
      print*,'ft_sd_pres_nbad=',  ft_sd_pres_nbad
      print*,'ft_sd_pres_min_hpa',ft_sd_pres_min_hpa
      print*,'ft_sd_pres_max_hpa',ft_sd_pres_max_hpa
      print*,'ft_sd_pres_avg_hpa',ft_sd_pres_avg_hpa

      print*,'ft_sd_airt_ngood=', ft_sd_airt_ngood
      print*,'ft_sd_airt_nbad=',  ft_sd_airt_nbad
      print*,'ft_sd_airt_min_c',  ft_sd_airt_min_c
      print*,'ft_sd_airt_max_c',  ft_sd_airt_max_c
      print*,'ft_sd_airt_avg_hpa',ft_sd_airt_avg_c

      print*,'ft_sd_wetb_ngood=', ft_sd_wetb_ngood
      print*,'ft_sd_wetb_nbad=',  ft_sd_wetb_nbad
      print*,'ft_sd_wetb_min_c',  ft_sd_wetb_min_c
      print*,'ft_sd_wetb_max_c',  ft_sd_wetb_max_c
      print*,'ft_sd_wetb_avg_c',  ft_sd_wetb_avg_c

      print*,'ft_sd_vprs_ngood=',   ft_sd_vprs_ngood
      print*,'ft_sd_vprs_nbad=',    ft_sd_vprs_nbad
      print*,'ft_sd_vprs_min_hpa',  ft_sd_vprs_min_hpa
      print*,'ft_sd_vprs_max_hpa',  ft_sd_vprs_max_hpa
      print*,'ft_sd_vprs_avg_hpa',  ft_sd_vprs_avg_hpa

      print*,'ft_sd_relh_ngood=',   ft_sd_relh_ngood
      print*,'ft_sd_relh_nbad=',    ft_sd_relh_nbad
      print*,'ft_sd_relh_min_pc',   ft_sd_relh_min_pc
      print*,'ft_sd_relh_max_pc',   ft_sd_relh_max_pc
      print*,'ft_sd_relh_avg_pc',   ft_sd_relh_avg_pc

      print*,'ft_sd_relhreg_ngood=',ft_sd_relhreg_ngood
      print*,'ft_sd_relhreg_nbad=', ft_sd_relhreg_nbad
      print*,'ft_sd_relhreg_min_pc',ft_sd_relhreg_min_pc
      print*,'ft_sd_relhreg_max_pc',ft_sd_relhreg_max_pc
      print*,'ft_sd_relhreg_avg_pc',ft_sd_relhreg_avg_pc

      print*,'ft_sd_wdir_ngood=',   ft_sd_wdir_ngood
      print*,'ft_sd_wdir_nbad=',    ft_sd_wdir_nbad
      print*,'ft_sd_wdir_min_code', ft_sd_wdir_min_code
      print*,'ft_sd_wdir_max_code', ft_sd_wdir_max_code
      print*,'ft_sd_wdir_avg_code', ft_sd_wdir_avg_code

      print*,'ft_sd_wspd_ngood=',   ft_sd_wspd_ngood
      print*,'ft_sd_wspd_nbad=',    ft_sd_wspd_nbad
      print*,'ft_sd_wspd_min_bft',  ft_sd_wspd_min_bft
      print*,'ft_sd_wspd_max_bft',  ft_sd_wspd_max_bft
      print*,'ft_sd_wspd_avg_bft',  ft_sd_wspd_avg_bft

      print*,'ft_sd_ccov_ngood=',   ft_sd_ccov_ngood
      print*,'ft_sd_ccov_nbad=',    ft_sd_ccov_nbad
      print*,'ft_sd_ccov_min_okta', ft_sd_ccov_min_okta
      print*,'ft_sd_ccov_max_okta', ft_sd_ccov_max_okta
      print*,'ft_sd_ccov_avg_okta', ft_sd_ccov_avg_okta

      print*,'ft_sd_visi_ngood=',   ft_sd_visi_ngood
      print*,'ft_sd_visi_nbad=',    ft_sd_visi_nbad
      print*,'ft_sd_visi_min_code', ft_sd_visi_min_code
      print*,'ft_sd_visi_max_code', ft_sd_visi_max_code
      print*,'ft_sd_visi_avg_code', ft_sd_visi_avg_code

      print*,'ft_sd_ppt_ngood=',    ft_sd_ppt_ngood
      print*,'ft_sd_ppt_nbad=',     ft_sd_ppt_nbad
      print*,'ft_sd_ppt_min_mm',    ft_sd_ppt_min_mm
      print*,'ft_sd_ppt_max_mm',    ft_sd_ppt_max_mm
      print*,'ft_sd_ppt_avg_mm',    ft_sd_ppt_avg_mm
c*****
      print*,'ft_day_pres_min_hpa=',     ft_day_pres_min_hpa
      print*,'ft_day_pres_max_hpa=',     ft_day_pres_max_hpa
      print*,'ft_day_pres_avg_hpa=',     ft_day_pres_avg_hpa
      print*,'ft_day_pres_ngood=',       ft_day_pres_ngood
      print*,'ft_day_pres_nbad=',        ft_day_pres_nbad

      print*,'ft_day_airt_daymax_min_c=',ft_day_airt_daymax_min_c
      print*,'ft_day_airt_daymax_max_c=',ft_day_airt_daymax_max_c
      print*,'ft_day_airt_daymax_avg_c=',ft_day_airt_daymax_avg_c
      print*,'ft_day_airt_daymax_ngood=',ft_day_airt_daymax_ngood
      print*,'ft_day_airt_daymax_nbad=', ft_day_airt_daymax_nbad

      print*,'ft_day_airt_daymin_min_c=',ft_day_airt_daymin_min_c
      print*,'ft_day_airt_daymin_max_c=',ft_day_airt_daymin_max_c
      print*,'ft_day_airt_daymin_avg_c=',ft_day_airt_daymin_avg_c
      print*,'ft_day_airt_daymin_ngood=',ft_day_airt_daymin_ngood
      print*,'ft_day_airt_daymin_nbad=', ft_day_airt_daymin_nbad

      print*,'ft_day_airt_range_min_c=', ft_day_airt_range_min_c
      print*,'ft_day_airt_range_max_c=', ft_day_airt_range_max_c
      print*,'ft_day_airt_range_avg_c=', ft_day_airt_range_avg_c
      print*,'ft_day_airt_range_ngood=', ft_day_airt_range_ngood
      print*,'ft_day_airt_range_nbad=',  ft_day_airt_range_nbad

      print*,'ft_day_boden_daymin_min_c=', ft_day_boden_daymin_min_c
      print*,'ft_day_boden_daymin_max_c=', ft_day_boden_daymin_max_c
      print*,'ft_day_boden_daymin_avg_c=', ft_day_boden_daymin_avg_c
      print*,'ft_day_boden_daymin_ngood=', ft_day_boden_daymin_ngood
      print*,'ft_day_boden_daymin_nbad=',  ft_day_boden_daymin_nbad

      print*,'ft_day_airt_dayavg_min_c=',  ft_day_airt_dayavg_min_c 
      print*,'ft_day_airt_dayavg_max_c=',  ft_day_airt_dayavg_max_c
      print*,'ft_day_airt_dayavg_avg_c=',  ft_day_airt_dayavg_avg_c
      print*,'ft_day_airt_dayavg_ngood=',  ft_day_airt_dayavg_ngood
      print*,'ft_day_airt_dayavg_nbad=',   ft_day_airt_dayavg_nbad

      print*,'ft_day_vprs_dayavg_min_hpa=',ft_day_vprs_dayavg_min_hpa
      print*,'ft_day_vprs_dayavg_max_hpa=',ft_day_vprs_dayavg_max_hpa 
      print*,'ft_day_vprs_dayavg_avg_hpa=',ft_day_vprs_dayavg_avg_hpa
      print*,'ft_day_vprs_dayavg_ngood=',  ft_day_vprs_dayavg_ngood
      print*,'ft_day_vprs_dayavg_nbad=',   ft_day_vprs_dayavg_nbad

      print*,'ft_day_relh_dayavg_min_pc=', ft_day_relh_dayavg_min_pc
      print*,'ft_day_relh_dayavg_max_pc=', ft_day_relh_dayavg_max_pc
      print*,'ft_day_relh_dayavg_avg_pc=', ft_day_relh_dayavg_avg_pc
      print*,'ft_day_relh_dayavg_ngood=',  ft_day_relh_dayavg_ngood
      print*,'ft_day_relh_dayavg_nbad=',   ft_day_relh_dayavg_nbad

      print*,'ft_day_wspd_dayavg_min_bft=',ft_day_wspd_dayavg_min_bft
      print*,'ft_day_wspd_dayavg_max_bft=',ft_day_wspd_dayavg_max_bft
      print*,'ft_day_wspd_dayavg_avg_bft=',ft_day_wspd_dayavg_avg_bft
      print*,'ft_day_wspd_dayavg_ngood=',  ft_day_wspd_dayavg_ngood
      print*,'ft_day_wspd_dayavg_nbad=',   ft_day_wspd_dayavg_nbad

      print*,'ft_day_ccov_dayavg_min_okta=',ft_day_ccov_dayavg_min_okta
      print*,'ft_day_ccov_dayavg_max_okta=',ft_day_ccov_dayavg_max_okta
      print*,'ft_day_ccov_dayavg_avg_okta=',ft_day_ccov_dayavg_avg_okta
      print*,'ft_day_ccov_dayavg_ngood=',   ft_day_ccov_dayavg_ngood
      print*,'ft_day_ccov_dayavg_nbad=',    ft_day_ccov_dayavg_nbad

      print*,'ft_day_sundur_daytot_min_h=', ft_day_sundur_daytot_min_h
      print*,'ft_day_sundur_daytot_max_h=', ft_day_sundur_daytot_max_h
      print*,'ft_day_sundur_daytot_avg_h=', ft_day_sundur_daytot_avg_h
      print*,'ft_day_sundur_daytot_ngood=', ft_day_sundur_daytot_ngood
      print*,'ft_day_sundur_daytot_nbad=',  ft_day_sundur_daytot_nbad

      print*,'ft_day_ppt_daytot_min_mm=',   ft_day_ppt_daytot_min_mm
      print*,'ft_day_ppt_daytot_max_mm=',   ft_day_ppt_daytot_max_mm
      print*,'ft_day_ppt_daytot_avg_mm=',   ft_day_ppt_daytot_avg_mm
      print*,'ft_day_ppt_daytot_ngood=',    ft_day_ppt_daytot_ngood
      print*,'ft_day_sundur_daytot_nbad=',  ft_day_sundur_daytot_nbad

      print*,'ft_day_snowcover_min_cm=',    ft_day_snowcover_min_cm
      print*,'ft_day_snowcover_max_cm=',    ft_day_snowcover_max_cm
      print*,'ft_day_snowcover_avg_cm=',    ft_day_snowcover_max_cm
      print*,'ft_day_snowcover_ngood=',     ft_day_snowcover_ngood
      print*,'ft_day_snowcover_nbad=',      ft_day_snowcover_nbad

      print*,'ft_day_snow_daytot_min_cm=',  ft_day_snow_daytot_min_cm
      print*,'ft_day_snow_daytot_max_cm=',  ft_day_snow_daytot_max_cm
      print*,'ft_day_snow_daytot_avg_cm=',  ft_day_snow_daytot_avg_cm
      print*,'ft_day_snow_daytot_ngood=',   ft_day_snow_daytot_ngood
      print*,'ft_day_snow_daytot_nbad=',    ft_day_snow_daytot_nbad

      print*,'ft_day_wspd_daymax_min_ms=',  ft_day_wspd_daymax_min_ms
      print*,'ft_day_wspd_daymax_max_ms=',  ft_day_wspd_daymax_max_ms
      print*,'ft_day_wspd_daymax_avg_ms=',  ft_day_wspd_daymax_avg_ms
      print*,'ft_day_wspd_daymax_ngood=',   ft_day_wspd_daymax_ngood
      print*,'ft_day_wspd_daymax_nbad=',    ft_day_wspd_daymax_nbad

      print*,'ft_day_snowmelted_min_cm=',   ft_day_snowmelted_min_cm
      print*,'ft_day_snowmelted_max_cm=',   ft_day_snowmelted_min_cm
      print*,'ft_day_snowmelted_avg_cm=',   ft_day_snowmelted_avg_cm
      print*,'ft_day_snowmelted_ngood=',    ft_day_snowmelted_ngood
      print*,'ft_day_snowmelted_nbad=',     ft_day_snowmelted_nbad

      print*,'ft_day_we_snowmelted_min_mm=',ft_day_we_snowmelted_min_mm
      print*,'ft_day_we_snowmelted_max_mm=',ft_day_we_snowmelted_max_mm
      print*,'ft_day_we_snowmelted_avg_mm=',ft_day_we_snowmelted_avg_mm
      print*,'ft_day_we_snowmelted_ngood=', ft_day_we_snowmelted_ngood
      print*,'ft_day_we_snowmelted_nbad=',  ft_day_we_snowmelted_nbad

      print*,'ft_day_we_snowcover_min_mm=', ft_day_we_snowcover_min_mm
      print*,'ft_day_we_snowcover_max_mm=', ft_day_we_snowcover_max_mm
      print*,'ft_day_we_snowcover_avg_mm=', ft_day_we_snowcover_avg_mm
      print*,'ft_day_we_snowcover_ngood=',  ft_day_we_snowcover_ngood
      print*,'ft_day_we_snowcover_nbad=',   ft_day_we_snowcover_nbad

      print*,'j_day=',j_day
      print*,'j_sd=',j_sd,j_sd/3.0

18    CONTINUE
c************************************************************************

      RETURN
      END