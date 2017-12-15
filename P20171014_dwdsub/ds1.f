c     Program to process DWD subdaily files
c     AJ_Kettle, Oct17/2017

c************************************************************************
c     Summary program structure
    
c     getlist_comp_files               need zfilelist_pre1999.dat
c     getlist_comp_files               need zfilelist_post2000.dat
c     define_basis_stnset
c     get_info_stns                    need KL_Standardformate_Beschreibung_Stationen.txt
c     match_info_basis_set2
c     get_wigos_number_sd              need dwd_wmo_number.dat
c   start loop
c     get_data_2file
c     get_data_1file
c     convert_variables
c       dewp_from_vpres_stnpres
c       slpres_from_stnpres
c       convert_time_utc
c       convert_time_utc
c     find_time_interval
c     calc_basic_stats_sd1
c       dwd_subday_stat_pack
c     export_header_subdaily2
c     export_observation_subdaily2
c   end loop
c     export_tab_sn1_stndata
c     export_listsort_sd
c     export_basis_info
c     sift_sort_export_sd
c       sort_like_pwave
c************************************************************************

      IMPLICIT NONE
c2-------10--------20--------30--------40--------50--------60--------70--------80
c************************************************************************
c     Declare variables

      REAL                :: f_time_st,f_time_en,f_deltime_s
      CHARACTER(LEN=8)    :: s_date
      CHARACTER(LEN=10)   :: s_time
      CHARACTER(LEN=5)    :: s_zone
      INTEGER             :: i_values(8)

      INTEGER, PARAMETER  :: l_mstn =100
      INTEGER, PARAMETER  :: l_mlen1=300000
      INTEGER, PARAMETER  :: l_mlen2=30000
      INTEGER, PARAMETER  :: l_mlent=300000
      INTEGER             :: i_computer

      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: io

      INTEGER             :: i_ndflag
      REAL                :: f_ndflag
      DOUBLE PRECISION    :: d_ndflag
      CHARACTER(LEN=4)    :: s_ndflag 

      CHARACTER(LEN=300)  :: s_directory
      CHARACTER(LEN=300)  :: s_directory2
      CHARACTER(LEN=300)  :: s_directory_compress
      CHARACTER(LEN=300)  :: s_directory_uncompress
      CHARACTER(LEN=300)  :: s_directory_root

      CHARACTER(LEN=300)  :: s_filename_in
      CHARACTER(LEN=300)  :: s_pathandname
      CHARACTER(LEN=300)  :: s_directory_output
      CHARACTER(LEN=300)  :: s_command

      INTEGER             :: l_file_co
      CHARACTER(LEN=300)  :: s_files_co(100)
      CHARACTER(LEN=5)    :: s_stnnum_co(100)

      INTEGER             :: l_file_un
      CHARACTER(LEN=300)  :: s_files_un(100)
      CHARACTER(LEN=5)    :: s_stnnum_un(100)

      CHARACTER(LEN=5)    :: s_stnnum_basis(100)
      INTEGER             :: i_basisflag_un(100)
      INTEGER             :: i_basisflag_co(100)
      INTEGER             :: l_file_basis
      CHARACTER(LEN=300)  :: s_basis_files_co(100)
      CHARACTER(LEN=300)  :: s_basis_files_un(100)

      CHARACTER(LEN=5)    :: s_stnnum_basis_pre(100)
      INTEGER             :: i_basisflag_un_pre(100)
      INTEGER             :: i_basisflag_co_pre(100)
      INTEGER             :: l_file_basis_pre
      CHARACTER(LEN=300)  :: s_basis_files_co_pre(100)
      CHARACTER(LEN=300)  :: s_basis_files_un_pre(100)

      INTEGER             :: l_stnrecord
      CHARACTER(LEN=5)    :: s_stke(100),s_stid(100)
      CHARACTER(LEN=8)    :: s_stdate(100),s_endate(100)
      CHARACTER(LEN=9)    :: s_hght(100)
      CHARACTER(LEN=10)   :: s_lat(100),s_lon(100)
      CHARACTER(LEN=25)   :: s_stnname(100)
      CHARACTER(LEN=25)   :: s_bundesland(100)

      CHARACTER(LEN=5)    :: s_basis_stke(l_mstn)
      CHARACTER(LEN=5)    :: s_basis_stid(l_mstn)
      CHARACTER(LEN=8)    :: s_basis_stdate(l_mstn)
      CHARACTER(LEN=8)    :: s_basis_endate(l_mstn)
      CHARACTER(LEN=9)    :: s_basis_hght(l_mstn)
      CHARACTER(LEN=10)   :: s_basis_lat(l_mstn)
      CHARACTER(LEN=10)   :: s_basis_lon(l_mstn)
      CHARACTER(LEN=25)   :: s_basis_stnname(l_mstn)
      CHARACTER(LEN=25)   :: s_basis_bundesland(l_mstn)

      CHARACTER(LEN=17)   :: s_basis_wigos_full(l_mstn)

      INTEGER             :: l_file_use

      INTEGER             :: i_len
      CHARACTER(LEN=300)  :: s_filename
      CHARACTER(LEN=300)  :: s_filename1
      CHARACTER(LEN=300)  :: s_filename_actual
      CHARACTER(LEN=300)  :: s_basis_filename
      CHARACTER(LEN=5)    :: s_stnnum_use

c*****
c     COMPRESSED SECTION: Subdaily string
      INTEGER             :: l_f1_sd
      CHARACTER(LEN=4)    :: s1_sd_year(l_mlen1)
      CHARACTER(LEN=2)    :: s1_sd_month(l_mlen1) 
      CHARACTER(LEN=2)    :: s1_sd_day(l_mlen1) 
      CHARACTER(LEN=4)    :: s1_sd_time(l_mlen1)
      CHARACTER(LEN=3)    :: s1_sd_time_id(l_mlen1)
      REAL                :: f1_sd_pres_hpa(l_mlen1)
      REAL                :: f1_sd_airt_c(l_mlen1)
      REAL                :: f1_sd_wetb_c(l_mlen1)
      REAL                :: f1_sd_vprs_hpa(l_mlen1)
      REAL                :: f1_sd_relh_pc(l_mlen1)
      REAL                :: f1_sd_relhreg_pc(l_mlen1)
      REAL                :: f1_sd_wdir_code(l_mlen1)
      REAL                :: f1_sd_wspd_bft(l_mlen1)
      REAL                :: f1_sd_ccov_okta(l_mlen1)
      REAL                :: f1_sd_visi_code(l_mlen1)
      REAL                :: f1_sd_grdcnd_code(l_mlen1)
      REAL                :: f1_sd_ppt_mm(l_mlen1)

      CHARACTER(LEN=1)    :: s1_sd_pres_qc(l_mlen1)
      CHARACTER(LEN=1)    :: s1_sd_airt_qc(l_mlen1)
      CHARACTER(LEN=1)    :: s1_sd_wetb_qc(l_mlen1)
      CHARACTER(LEN=1)    :: s1_sd_vprs_qc(l_mlen1)
      CHARACTER(LEN=1)    :: s1_sd_relh_qc(l_mlen1)
      CHARACTER(LEN=1)    :: s1_sd_relhreg_qc(l_mlen1)
      CHARACTER(LEN=1)    :: s1_sd_wspdwdir_qc(l_mlen1)
      CHARACTER(LEN=1)    :: s1_sd_ccov_qc(l_mlen1)
      CHARACTER(LEN=1)    :: s1_sd_visi_qc(l_mlen1)
      CHARACTER(LEN=1)    :: s1_sd_grdcnd_qc(l_mlen1)
      CHARACTER(LEN=1)    :: s1_sd_ppt_qc(l_mlen1)

      CHARACTER(LEN=1)    :: s1_sd_wetb_ice(l_mlen1)

c     COMPRESSED SECTION: Daily string
      INTEGER             :: l_f1_day
      CHARACTER(LEN=4)    :: s1_year(l_mlen1)
      CHARACTER(LEN=2)    :: s1_month(l_mlen1)
      CHARACTER(LEN=2)    :: s1_day(l_mlen1)
      CHARACTER(LEN=4)    :: s1_timeday(l_mlen1)
      CHARACTER(LEN=3)    :: s1_timeday_id(l_mlen1)
      REAL                :: f1_pres_dayavg_hpa(l_mlen1)
      REAL                :: f1_airt_daymax_c(l_mlen1)
      REAL                :: f1_airt_daymin_c(l_mlen1)
      REAL                :: f1_airt_range_c(l_mlen1)
      REAL                :: f1_boden_daymin_c(l_mlen1)
      REAL                :: f1_airt_dayavg_c(l_mlen1)
      REAL                :: f1_vprs_dayavg_hpa(l_mlen1)
      REAL                :: f1_relh_dayavg_pc(l_mlen1)
      REAL                :: f1_wspd_dayavg_bft(l_mlen1)
      REAL                :: f1_ccov_dayavg_okta(l_mlen1)
      REAL                :: f1_sundur_daytot_h(l_mlen1)
      REAL                :: f1_ppt_daytot_mm(l_mlen1)
      REAL                :: f1_snowcover_cm(l_mlen1)
      REAL                :: f1_snow_daytot_cm(l_mlen1)
      REAL                :: f1_wspd_daymax_ms(l_mlen1)
      REAL                :: f1_snowmelted_cm(l_mlen1)
      REAL                :: f1_we_snowmelted_mm(l_mlen1)
      REAL                :: f1_we_snowcover_mm(l_mlen1)
c*****
c     UNCOMPRESSED SECTION: Subdaily string
      INTEGER             :: l_f2_sd
      CHARACTER(LEN=4)    :: s2_sd_year(l_mlen2)
      CHARACTER(LEN=2)    :: s2_sd_month(l_mlen2) 
      CHARACTER(LEN=2)    :: s2_sd_day(l_mlen2) 
      CHARACTER(LEN=4)    :: s2_sd_time(l_mlen2)
      CHARACTER(LEN=3)    :: s2_sd_time_id(l_mlen2)
      REAL                :: f2_sd_pres_hpa(l_mlen2)
      REAL                :: f2_sd_airt_c(l_mlen2)
      REAL                :: f2_sd_wetb_c(l_mlen2)
      REAL                :: f2_sd_vprs_hpa(l_mlen2)
      REAL                :: f2_sd_relh_pc(l_mlen2)
      REAL                :: f2_sd_relhreg_pc(l_mlen2)
      REAL                :: f2_sd_wdir_code(l_mlen2)
      REAL                :: f2_sd_wspd_bft(l_mlen2)
      REAL                :: f2_sd_ccov_okta(l_mlen2)
      REAL                :: f2_sd_visi_code(l_mlen2)
      REAL                :: f2_sd_grdcnd_code(l_mlen2)
      REAL                :: f2_sd_ppt_mm(l_mlen2)

      CHARACTER(LEN=1)    :: s2_sd_pres_qc(l_mlen2)
      CHARACTER(LEN=1)    :: s2_sd_airt_qc(l_mlen2)
      CHARACTER(LEN=1)    :: s2_sd_wetb_qc(l_mlen2)
      CHARACTER(LEN=1)    :: s2_sd_vprs_qc(l_mlen2)
      CHARACTER(LEN=1)    :: s2_sd_relh_qc(l_mlen2)
      CHARACTER(LEN=1)    :: s2_sd_relhreg_qc(l_mlen2)
      CHARACTER(LEN=1)    :: s2_sd_wspdwdir_qc(l_mlen2)
      CHARACTER(LEN=1)    :: s2_sd_ccov_qc(l_mlen2)
      CHARACTER(LEN=1)    :: s2_sd_visi_qc(l_mlen2)
      CHARACTER(LEN=1)    :: s2_sd_grdcnd_qc(l_mlen2)
      CHARACTER(LEN=1)    :: s2_sd_ppt_qc(l_mlen2)

      CHARACTER(LEN=1)    :: s2_sd_wetb_ice(l_mlen1)

c     UNCOMPRESSED SECTION: Daily string
      INTEGER             :: l_f2_day
      CHARACTER(LEN=4)    :: s2_year(l_mlen2)
      CHARACTER(LEN=2)    :: s2_month(l_mlen2)
      CHARACTER(LEN=2)    :: s2_day(l_mlen2)
      CHARACTER(LEN=4)    :: s2_timeday(l_mlen2)
      CHARACTER(LEN=3)    :: s2_timeday_id(l_mlen2)
      REAL                :: f2_pres_dayavg_hpa(l_mlen2)
      REAL                :: f2_airt_daymax_c(l_mlen2)
      REAL                :: f2_airt_daymin_c(l_mlen2)
      REAL                :: f2_airt_range_c(l_mlen2)
      REAL                :: f2_boden_daymin_c(l_mlen2)
      REAL                :: f2_airt_dayavg_c(l_mlen2)
      REAL                :: f2_vprs_dayavg_hpa(l_mlen2)
      REAL                :: f2_relh_dayavg_pc(l_mlen2)
      REAL                :: f2_wspd_dayavg_bft(l_mlen2)
      REAL                :: f2_ccov_dayavg_okta(l_mlen2)
      REAL                :: f2_sundur_daytot_h(l_mlen2)
      REAL                :: f2_ppt_daytot_mm(l_mlen2)
      REAL                :: f2_snowcover_cm(l_mlen2)
      REAL                :: f2_snow_daytot_cm(l_mlen2)
      REAL                :: f2_wspd_daymax_ms(l_mlen2)
      REAL                :: f2_snowmelted_cm(l_mlen2)
      REAL                :: f2_we_snowmelted_mm(l_mlen2)
      REAL                :: f2_we_snowcover_mm(l_mlen2)
c*****
c     TOTAL: Subdaily string
      INTEGER             :: j_sd
      CHARACTER(LEN=4)    :: st_sd_year(l_mlent)
      CHARACTER(LEN=2)    :: st_sd_month(l_mlent) 
      CHARACTER(LEN=2)    :: st_sd_day(l_mlent) 
      CHARACTER(LEN=4)    :: st_sd_time(l_mlent)
      CHARACTER(LEN=3)    :: st_sd_time_id(l_mlent)
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

      CHARACTER(LEN=1)    :: st_sd_pres_qc(l_mlent)
      CHARACTER(LEN=1)    :: st_sd_airt_qc(l_mlent)
      CHARACTER(LEN=1)    :: st_sd_wetb_qc(l_mlent)
      CHARACTER(LEN=1)    :: st_sd_vprs_qc(l_mlent)
      CHARACTER(LEN=1)    :: st_sd_relh_qc(l_mlent)
      CHARACTER(LEN=1)    :: st_sd_relhreg_qc(l_mlent)
      CHARACTER(LEN=1)    :: st_sd_wspdwdir_qc(l_mlent)
      CHARACTER(LEN=1)    :: st_sd_ccov_qc(l_mlent)
      CHARACTER(LEN=1)    :: st_sd_visi_qc(l_mlent)
      CHARACTER(LEN=1)    :: st_sd_grdcnd_qc(l_mlent)
      CHARACTER(LEN=1)    :: st_sd_ppt_qc(l_mlent)

      CHARACTER(LEN=1)    :: st_sd_wetb_ice(l_mlent)

c     converted variables
      REAL                :: ft_sd_airt_k(l_mlent)
      REAL                :: ft_sd_wetb_k(l_mlent)
      REAL                :: ft_sd_wdir_deg(l_mlent)
      REAL                :: ft_sd_wspd_ms(l_mlent)
      REAL                :: ft_sd_dewp_c(l_mlent)
      REAL                :: ft_sd_dewp_k(l_mlent)
      REAL                :: ft_sd_slpres_hpa(l_mlent)
      CHARACTER(LEN=4)    :: st_sd_timeutc(l_mlent)
      CHARACTER(LEN=8)    :: st_sd_timeutc_hh_mm_ss(l_mlent)
      CHARACTER(LEN=4)    :: st_timedayutc(l_mlent)
      CHARACTER(LEN=8)    :: st_timedayutc_hh_mm_ss(l_mlent)

c     time interval calculation
      REAL                :: f_duration_s(l_mlent)

c     TOTAL: Daily float
      INTEGER             :: j_day
      CHARACTER(LEN=4)    :: st_year(l_mlent)
      CHARACTER(LEN=2)    :: st_month(l_mlent)
      CHARACTER(LEN=2)    :: st_day(l_mlent)
      CHARACTER(LEN=4)    :: st_timeday(l_mlent)
      CHARACTER(LEN=3)    :: st_timeday_id(l_mlent)
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
c*****
c     STATS SUBDAY

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
c     STATS DAY

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
c*****
c     Archival - SUBDAY variables

      INTEGER             :: i_arch_j_sd(l_mstn)

      CHARACTER(LEN=4)    :: s_arch_sd_year_st(l_mstn) 
      CHARACTER(LEN=4)    :: s_arch_sd_year_en(l_mstn)  
      CHARACTER(LEN=2)    :: s_arch_sd_month_st(l_mstn) 
      CHARACTER(LEN=2)    :: s_arch_sd_month_en(l_mstn) 
      CHARACTER(LEN=2)    :: s_arch_sd_day_st(l_mstn) 
      CHARACTER(LEN=2)    :: s_arch_sd_day_en(l_mstn) 
      CHARACTER(LEN=4)    :: s_arch_sd_timeutc_st(l_mstn)
      CHARACTER(LEN=4)    :: s_arch_sd_timeutc_en(l_mstn)

      REAL                :: f_arch_sd_pres_min_hpa(l_mstn)
      REAL                :: f_arch_sd_pres_max_hpa(l_mstn)
      REAL                :: f_arch_sd_pres_avg_hpa(l_mstn)
      REAL                :: f_arch_sd_pres_ngood(l_mstn)
      REAL                :: f_arch_sd_pres_nbad(l_mstn)

      REAL                :: f_arch_sd_airt_min_c(l_mstn)
      REAL                :: f_arch_sd_airt_max_c(l_mstn)
      REAL                :: f_arch_sd_airt_avg_c(l_mstn)
      REAL                :: f_arch_sd_airt_ngood(l_mstn)
      REAL                :: f_arch_sd_airt_nbad(l_mstn)

      REAL                :: f_arch_sd_wetb_min_c(l_mstn)
      REAL                :: f_arch_sd_wetb_max_c(l_mstn)
      REAL                :: f_arch_sd_wetb_avg_c(l_mstn)
      REAL                :: f_arch_sd_wetb_ngood(l_mstn)
      REAL                :: f_arch_sd_wetb_nbad(l_mstn)

      REAL                :: f_arch_sd_vprs_min_hpa(l_mstn)
      REAL                :: f_arch_sd_vprs_max_hpa(l_mstn)
      REAL                :: f_arch_sd_vprs_avg_hpa(l_mstn)
      REAL                :: f_arch_sd_vprs_ngood(l_mstn)
      REAL                :: f_arch_sd_vprs_nbad(l_mstn)

      REAL                :: f_arch_sd_relh_min_pc(l_mstn)
      REAL                :: f_arch_sd_relh_max_pc(l_mstn)
      REAL                :: f_arch_sd_relh_avg_pc(l_mstn)
      REAL                :: f_arch_sd_relh_ngood(l_mstn)
      REAL                :: f_arch_sd_relh_nbad(l_mstn)

      REAL                :: f_arch_sd_relhreg_min_pc(l_mstn)
      REAL                :: f_arch_sd_relhreg_max_pc(l_mstn)
      REAL                :: f_arch_sd_relhreg_avg_pc(l_mstn)
      REAL                :: f_arch_sd_relhreg_ngood(l_mstn)
      REAL                :: f_arch_sd_relhreg_nbad(l_mstn)

      REAL                :: f_arch_sd_wdir_min_code(l_mstn)
      REAL                :: f_arch_sd_wdir_max_code(l_mstn)
      REAL                :: f_arch_sd_wdir_avg_code(l_mstn)
      REAL                :: f_arch_sd_wdir_ngood(l_mstn)
      REAL                :: f_arch_sd_wdir_nbad(l_mstn)

      REAL                :: f_arch_sd_wspd_min_bft(l_mstn)
      REAL                :: f_arch_sd_wspd_max_bft(l_mstn)
      REAL                :: f_arch_sd_wspd_avg_bft(l_mstn)
      REAL                :: f_arch_sd_wspd_ngood(l_mstn)
      REAL                :: f_arch_sd_wspd_nbad(l_mstn)

      REAL                :: f_arch_sd_ccov_min_okta(l_mstn)
      REAL                :: f_arch_sd_ccov_max_okta(l_mstn)
      REAL                :: f_arch_sd_ccov_avg_okta(l_mstn)
      REAL                :: f_arch_sd_ccov_ngood(l_mstn)
      REAL                :: f_arch_sd_ccov_nbad(l_mstn)

      REAL                :: f_arch_sd_visi_min_code(l_mstn)
      REAL                :: f_arch_sd_visi_max_code(l_mstn)
      REAL                :: f_arch_sd_visi_avg_code(l_mstn)
      REAL                :: f_arch_sd_visi_ngood(l_mstn)
      REAL                :: f_arch_sd_visi_nbad(l_mstn)

      REAL                :: f_arch_sd_grdcnd_min_code(l_mstn)
      REAL                :: f_arch_sd_grdcnd_max_code(l_mstn)
      REAL                :: f_arch_sd_grdcnd_avg_code(l_mstn)
      REAL                :: f_arch_sd_grdcnd_ngood(l_mstn)
      REAL                :: f_arch_sd_grdcnd_nbad(l_mstn)

      REAL                :: f_arch_sd_ppt_min_mm(l_mstn)
      REAL                :: f_arch_sd_ppt_max_mm(l_mstn)
      REAL                :: f_arch_sd_ppt_avg_mm(l_mstn)
      REAL                :: f_arch_sd_ppt_ngood(l_mstn)
      REAL                :: f_arch_sd_ppt_nbad(l_mstn)
c******
c     Archival - STATS DAY

      INTEGER             :: i_arch_j_day(l_mstn)

      REAL                :: f_arch_day_pres_min_hpa(l_mstn)
      REAL                :: f_arch_day_pres_max_hpa(l_mstn)
      REAL                :: f_arch_day_pres_avg_hpa(l_mstn)
      REAL                :: f_arch_day_pres_ngood(l_mstn)
      REAL                :: f_arch_day_pres_nbad(l_mstn)

      REAL                :: f_arch_day_airt_daymax_min_c(l_mstn)
      REAL                :: f_arch_day_airt_daymax_max_c(l_mstn)
      REAL                :: f_arch_day_airt_daymax_avg_c(l_mstn)
      REAL                :: f_arch_day_airt_daymax_ngood(l_mstn)
      REAL                :: f_arch_day_airt_daymax_nbad(l_mstn)

      REAL                :: f_arch_day_airt_daymin_min_c(l_mstn)
      REAL                :: f_arch_day_airt_daymin_max_c(l_mstn)
      REAL                :: f_arch_day_airt_daymin_avg_c(l_mstn)
      REAL                :: f_arch_day_airt_daymin_ngood(l_mstn)
      REAL                :: f_arch_day_airt_daymin_nbad(l_mstn)

      REAL                :: f_arch_day_airt_range_min_c(l_mstn)
      REAL                :: f_arch_day_airt_range_max_c(l_mstn)
      REAL                :: f_arch_day_airt_range_avg_c(l_mstn)
      REAL                :: f_arch_day_airt_range_ngood(l_mstn)
      REAL                :: f_arch_day_airt_range_nbad(l_mstn)

      REAL                :: f_arch_day_boden_daymin_min_c(l_mstn)
      REAL                :: f_arch_day_boden_daymin_max_c(l_mstn)
      REAL                :: f_arch_day_boden_daymin_avg_c(l_mstn)
      REAL                :: f_arch_day_boden_daymin_ngood(l_mstn)
      REAL                :: f_arch_day_boden_daymin_nbad(l_mstn)

      REAL                :: f_arch_day_airt_dayavg_min_c(l_mstn)
      REAL                :: f_arch_day_airt_dayavg_max_c(l_mstn)
      REAL                :: f_arch_day_airt_dayavg_avg_c(l_mstn)
      REAL                :: f_arch_day_airt_dayavg_ngood(l_mstn)
      REAL                :: f_arch_day_airt_dayavg_nbad(l_mstn)

      REAL                :: f_arch_day_vprs_dayavg_min_hpa(l_mstn)
      REAL                :: f_arch_day_vprs_dayavg_max_hpa(l_mstn)
      REAL                :: f_arch_day_vprs_dayavg_avg_hpa(l_mstn)
      REAL                :: f_arch_day_vprs_dayavg_ngood(l_mstn)
      REAL                :: f_arch_day_vprs_dayavg_nbad(l_mstn)

      REAL                :: f_arch_day_relh_dayavg_min_pc(l_mstn)
      REAL                :: f_arch_day_relh_dayavg_max_pc(l_mstn)
      REAL                :: f_arch_day_relh_dayavg_avg_pc(l_mstn)
      REAL                :: f_arch_day_relh_dayavg_ngood(l_mstn)
      REAL                :: f_arch_day_relh_dayavg_nbad(l_mstn)

      REAL                :: f_arch_day_wspd_dayavg_min_bft(l_mstn)
      REAL                :: f_arch_day_wspd_dayavg_max_bft(l_mstn)
      REAL                :: f_arch_day_wspd_dayavg_avg_bft(l_mstn)
      REAL                :: f_arch_day_wspd_dayavg_ngood(l_mstn)
      REAL                :: f_arch_day_wspd_dayavg_nbad(l_mstn)

      REAL                :: f_arch_day_ccov_dayavg_min_okta(l_mstn)
      REAL                :: f_arch_day_ccov_dayavg_max_okta(l_mstn)
      REAL                :: f_arch_day_ccov_dayavg_avg_okta(l_mstn)
      REAL                :: f_arch_day_ccov_dayavg_ngood(l_mstn)
      REAL                :: f_arch_day_ccov_dayavg_nbad(l_mstn)

      REAL                :: f_arch_day_sundur_daytot_min_h(l_mstn)
      REAL                :: f_arch_day_sundur_daytot_max_h(l_mstn)
      REAL                :: f_arch_day_sundur_daytot_avg_h(l_mstn)
      REAL                :: f_arch_day_sundur_daytot_ngood(l_mstn)
      REAL                :: f_arch_day_sundur_daytot_nbad(l_mstn)

      REAL                :: f_arch_day_ppt_daytot_min_mm(l_mstn)
      REAL                :: f_arch_day_ppt_daytot_max_mm(l_mstn)
      REAL                :: f_arch_day_ppt_daytot_avg_mm(l_mstn)
      REAL                :: f_arch_day_ppt_daytot_ngood(l_mstn)
      REAL                :: f_arch_day_ppt_daytot_nbad(l_mstn)

      REAL                :: f_arch_day_snowcover_min_cm(l_mstn)
      REAL                :: f_arch_day_snowcover_max_cm(l_mstn)
      REAL                :: f_arch_day_snowcover_avg_cm(l_mstn)
      REAL                :: f_arch_day_snowcover_ngood(l_mstn)
      REAL                :: f_arch_day_snowcover_nbad(l_mstn)

      REAL                :: f_arch_day_snow_daytot_min_cm(l_mstn)
      REAL                :: f_arch_day_snow_daytot_max_cm(l_mstn)
      REAL                :: f_arch_day_snow_daytot_avg_cm(l_mstn)
      REAL                :: f_arch_day_snow_daytot_ngood(l_mstn)
      REAL                :: f_arch_day_snow_daytot_nbad(l_mstn)

      REAL                :: f_arch_day_wspd_daymax_min_ms(l_mstn)
      REAL                :: f_arch_day_wspd_daymax_max_ms(l_mstn)
      REAL                :: f_arch_day_wspd_daymax_avg_ms(l_mstn)
      REAL                :: f_arch_day_wspd_daymax_ngood(l_mstn)
      REAL                :: f_arch_day_wspd_daymax_nbad(l_mstn)

      REAL                :: f_arch_day_snowmelted_min_cm(l_mstn)
      REAL                :: f_arch_day_snowmelted_max_cm(l_mstn)
      REAL                :: f_arch_day_snowmelted_avg_cm(l_mstn)
      REAL                :: f_arch_day_snowmelted_ngood(l_mstn)
      REAL                :: f_arch_day_snowmelted_nbad(l_mstn)

      REAL                :: f_arch_day_we_snowmelted_min_mm(l_mstn)
      REAL                :: f_arch_day_we_snowmelted_max_mm(l_mstn)
      REAL                :: f_arch_day_we_snowmelted_avg_mm(l_mstn)
      REAL                :: f_arch_day_we_snowmelted_ngood(l_mstn)
      REAL                :: f_arch_day_we_snowmelted_nbad(l_mstn)

      REAL                :: f_arch_day_we_snowcover_min_mm(l_mstn)
      REAL                :: f_arch_day_we_snowcover_max_mm(l_mstn)
      REAL                :: f_arch_day_we_snowcover_avg_mm(l_mstn)
      REAL                :: f_arch_day_we_snowcover_ngood(l_mstn)
      REAL                :: f_arch_day_we_snowcover_nbad(l_mstn)

      CHARACTER(LEN=5)    :: s_export_stid
      CHARACTER(LEN=25)   :: s_export_stnname
      CHARACTER(LEN=10)   :: s_export_lat
      CHARACTER(LEN=10)   :: s_export_lon
      CHARACTER(LEN=9)    :: s_export_hght

      REAL                :: f_hght_m
      REAL                :: f_lon_deg
      REAL                :: f_test
      CHARACTER(LEN=9)    :: s_test 
      CHARACTER(LEN=10)   :: s_test10
c************************************************************************
c     Find start time    
      CALL CPU_TIME(f_time_st)

c     Find date & time
      CALL DATE_AND_TIME(s_date,s_time,s_zone,i_values)
c************************************************************************
      i_ndflag=-999
      f_ndflag=-999.0
      d_ndflag=-999.0
      s_ndflag='-999'
c************************************************************************
c     Set flag for type of computer
      i_computer=1
c************************************************************************
c     Directories for source datasets
c     MSDOS option
      IF (i_computer.EQ.1) THEN
900   s_directory=
     +  'D:\DWD_datasets\1000084_DWD_Sub_daily\1000083_DWD_Sub_daily\'
      s_directory2=
     +  'D:/DWD_datasets/1000084_DWD_Sub_daily/1000083_DWD_Sub_daily/'
      ENDIF
c     Jasmin-unix option
      IF (i_computer.EQ.2) THEN
      ENDIF

c     Summary file output should be same DOS & UNIX
      s_directory_output  ='Data_middle/'   
c************************************************************************
c     Generate list of daily files for records 2000-present 
      s_command='dir /B '//TRIM(s_directory)//'kl*_akt.txt > '//
     +  'zfilelist_post2000.dat'
c      print*,'s_command=',s_command
      CALL SYSTEM(s_command,io)

c     Generate list of daily files for records up to 1999 
      s_command='dir /B '//TRIM(s_directory)//'kl*.gz > '//
     +  'zfilelist_pre1999.dat'
c      print*,'s_command=',s_command
      CALL SYSTEM(s_command,io)

c     Get list compressed files - pre1999
      s_pathandname='zfilelist_pre1999.dat'
      CALL getlist_comp_files(s_pathandname,
     +  l_file_co,s_files_co,s_stnnum_co)

c     Get list uncompressed files - post 2000 
      s_pathandname='zfilelist_post2000.dat'
      CALL getlist_comp_files(s_pathandname,
     +  l_file_un,s_files_un,s_stnnum_un)

      print*,'s_stnnum_un=',(s_stnnum_un(i),i=1,l_file_un)
      print*,'s_stnnum_co=',(s_stnnum_co(i),i=1,l_file_co)
      print*,'l_file_co,l_file_un=',l_file_co,l_file_un
c      CALL SLEEP(4)
c************************************************************************
c     Get list unique stations
      CALL define_basis_stnset(
     +  l_file_co,s_files_co,s_stnnum_co,
     +  l_file_un,s_files_un,s_stnnum_un,
     +  s_stnnum_basis_pre,i_basisflag_co_pre,i_basisflag_un_pre,
     +  l_file_basis_pre,s_basis_files_co_pre,s_basis_files_un_pre)
c************************************************************************
c     Read in basis information for stations
      s_basis_filename='KL_Standardformate_Beschreibung_Stationen.txt'
      s_pathandname=TRIM(s_directory)//TRIM(s_basis_filename)
      CALL get_info_stns(s_pathandname,l_stnrecord,
     +  s_stke,s_stid,s_stdate,s_endate,s_hght,s_lat,s_lon,s_stnname,
     +  s_bundesland)

c     Extract info for basis set; index all info geographical dataset
      CALL match_info_basis_set2(
     +  l_stnrecord,s_stke,s_stid,s_stdate,s_endate,
     +  s_hght,s_lat,s_lon,s_stnname,s_bundesland,
     +  l_file_basis_pre,s_stnnum_basis_pre, 
     +  i_basisflag_co_pre,i_basisflag_un_pre,
     +  s_basis_files_co_pre,s_basis_files_un_pre,

     +  l_file_basis,s_stnnum_basis, 
     +  i_basisflag_co,i_basisflag_un,
     +  s_basis_files_co,s_basis_files_un,

     +  s_basis_stke,s_basis_stid,s_basis_stdate,s_basis_endate,
     +  s_basis_hght,s_basis_lat,s_basis_lon,
     +  s_basis_stnname,s_basis_bundesland)

c     Compose full wigos number
      CALL get_wigos_number_sd(l_mstn,l_file_basis,s_basis_stke,
     +  s_basis_wigos_full)

      print*,'l_file_basis=',l_file_basis 
      print*,'s_basis_stke=',s_basis_stke(1),s_basis_stke(l_file_basis)
      print*,'s_basis_stid=',s_basis_stid(1),s_basis_stid(l_file_basis)
      print*,'s_basis_stdate=',s_basis_stdate(1)
      print*,'s_basis_endate=',s_basis_endate(1)
      print*,'s_basis_hght=',s_basis_hght(1)
      print*,'s_basis_lat=',s_basis_lat(1)
      print*,'s_basis_lon=',s_basis_lon(1)
      print*,'s_basis_stnname=',s_basis_stnname(1)
      print*,'s_basis_bundesland=',s_basis_bundesland(1)
c      CALL SLEEP(10)

c      print*,'s_stnnum_basis=',(s_stnnum_basis(i),i=1,1)
c      print*,'i_basisflag_co=',(i_basisflag_co(i),i=1,1)
c      print*,'i_basisflag_un=',(i_basisflag_un(i),i=1,1)
c      print*,'s_basis_files_co_pre=',
c     +   (TRIM(s_basis_files_co_pre(i)),i=1,l_file_basis_pre)
c      print*,'s_basis_files_un=',s_basis_files_un(1)
c      print*,'l_file_basis_pre=',l_file_basis_pre
c      DO i=1,l_file_basis_pre
c       print*,'i=',i,TRIM(s_basis_files_co_pre(i))
c      ENDDO
c      CALL SLEEP(4)
c************************************************************************
c************************************************************************
c       s_pathandname=TRIM(ADJUSTL(TRIM(s_directory2)//TRIM(s_filename)))
c       print*,'s_filename=',s_filename

c      print*,'l_stnrecord=',l_stnrecord
c      print*,'l_file_basis_pre=',l_file_basis_pre
c      print*,'l_file_basis=',    l_file_basis

c      DO i=1,l_file_basis
c       print*,'i=',i,TRIM(s_stke(i)),
c     +  TRIM(s_basis_files_co(i)),TRIM(s_basis_files_un(i))
cc       CALL SLEEP(1)
c      ENDDO
c      CALL SLEEP(4)
c************************************************************************
c     Print out names of files
      DO i=1,l_file_basis
       print*,'i=',i,TRIM(ADJUSTL(s_basis_files_co(i)))
      ENDDO
c      CALL SLEEP(10)
c************************************************************************
c     Process compressed files here

      l_file_use=l_file_basis  !3

      DO i=1,l_file_use       
c***********
c***********
c      Find altitude 
       s_test        =TRIM(s_basis_hght(i))
       READ(s_test,*) f_test
       f_hght_m      =f_test

c      Find longitude
       s_test10      =TRIM(s_basis_lon(i))
       READ(s_test10,*) f_test
       f_lon_deg     =f_test
c***********
c***********
c      Initialize counting variables for each station
       l_f1_sd =0
       l_f1_day=0
       l_f2_sd =0
       l_f2_day=0
c***********
c***********
c      Compressed pre-1999 files
       s_filename=TRIM(ADJUSTL(s_basis_files_co(i)))

c      SKIP CONDITION
       IF (TRIM(s_filename).EQ.'x') THEN
        print*,'no compressed file, skip',i
        GOTO 100        
       ENDIF

c      Copy compressed directory here
c       print*,'just before command line'
c       print*,'s_directory=',TRIM(s_directory)
       s_command='dir '//TRIM(s_directory)//TRIM(s_filename)
       CALL SYSTEM(s_command,io)
       s_command='copy '//TRIM(s_directory)//TRIM(s_filename)//
     +   ' HHere\'//TRIM(s_filename)
       CALL SYSTEM(s_command,io)

c       print*,'s_command=',TRIM(s_command)
c       print*,'s_filename=',TRIM(s_filename)
c       CALL SLEEP(10)

c      Unzip compressed directory here
       s_command=TRIM('gunzip -qq HHere/'//TRIM(s_filename))
       CALL SYSTEM(s_command,io)

c      Place subroutine to process file
       s_directory_compress='HHere/'
       s_filename=TRIM(ADJUSTL(s_basis_files_co(i)))
c      Need reference file without '.gz' extension
       i_len=LEN_TRIM(s_filename)
       s_filename_actual=s_filename(1:i_len-3)
c       print*,'s_directory=',s_directory
       print*,'s_filename_actual=',i,TRIM(s_filename_actual)
       CALL get_data_2file(s_directory_compress,s_filename_actual,
     +   l_mlen1,f_ndflag,

     +   l_f1_sd,
     +   s1_sd_year,s1_sd_month,s1_sd_day,s1_sd_time,s1_sd_time_id, 
     +   f1_sd_pres_hpa,f1_sd_airt_c,f1_sd_wetb_c,
     +   f1_sd_vprs_hpa,f1_sd_relh_pc,f1_sd_relhreg_pc,
     +   f1_sd_wdir_code,f1_sd_wspd_bft,f1_sd_ccov_okta,
     +   f1_sd_visi_code,f1_sd_grdcnd_code,f1_sd_ppt_mm,
     +   s1_sd_pres_qc,s1_sd_airt_qc,s1_sd_wetb_qc,
     +   s1_sd_vprs_qc,s1_sd_relh_qc,s1_sd_relhreg_qc,
     +   s1_sd_wspdwdir_qc,s1_sd_ccov_qc,s1_sd_visi_qc,
     +   s1_sd_grdcnd_qc,s1_sd_ppt_qc,
     +   s1_sd_wetb_ice,

     +   l_f1_day,
     +   s1_year,s1_month,s1_day,s1_timeday,s1_timeday_id,
     +   f1_pres_dayavg_hpa,f1_airt_daymax_c,f1_airt_daymin_c,
     +   f1_airt_range_c,f1_boden_daymin_c,f1_airt_dayavg_c,
     +   f1_vprs_dayavg_hpa,f1_relh_dayavg_pc,f1_wspd_dayavg_bft,
     +   f1_ccov_dayavg_okta,f1_sundur_daytot_h,f1_ppt_daytot_mm,
     +   f1_snowcover_cm,f1_snow_daytot_cm,f1_wspd_daymax_ms,
     +   f1_snowmelted_cm,f1_we_snowmelted_mm,f1_we_snowcover_mm)

c      print*,'l_f1_day=',l_f1_day
c      call sleep(1)

c      Delete files after analysis
       s_command=TRIM('del HHere\kl*')
c       print*,TRIM(s_command)
       CALL SYSTEM(s_command,io)

c       print*,'cleared compressed sequence'

100    CONTINUE
c***********
c***********
c      Uncompressed post-2000 files
       s_directory_uncompress=s_directory
       s_filename=TRIM(ADJUSTL(s_basis_files_un(i)))
c       s_stnnum_use=TRIM(ADJUSTL(s_stnnum_un(i)))

c      SKIP CONDITION
       IF (TRIM(s_filename).EQ.'x') THEN
        print*,'no uncompressed file, skip',i
        GOTO 102      
       ENDIF

c       print*,'s_directory_uncompress=',s_directory_uncompress
c       print*,'s_filename=', s_filename

c      Get data from file
       CALL get_data_1file(s_directory_uncompress,s_filename,
     +   l_mlen2,f_ndflag, 

     +   l_f2_sd,
     +   s2_sd_year,s2_sd_month,s2_sd_day,s2_sd_time,s2_sd_time_id, 
     +   f2_sd_pres_hpa,f2_sd_airt_c,f2_sd_wetb_c,
     +   f2_sd_vprs_hpa,f2_sd_relh_pc,f2_sd_relhreg_pc,
     +   f2_sd_wdir_code,f2_sd_wspd_bft,f2_sd_ccov_okta,
     +   f2_sd_visi_code,f2_sd_grdcnd_code,f2_sd_ppt_mm,
     +   s2_sd_pres_qc,s2_sd_airt_qc,s2_sd_wetb_qc,
     +   s2_sd_vprs_qc,s2_sd_relh_qc,s2_sd_relhreg_qc,
     +   s2_sd_wspdwdir_qc,s2_sd_ccov_qc,s2_sd_visi_qc,
     +   s2_sd_grdcnd_qc,s2_sd_ppt_qc,
     +   s2_sd_wetb_ice,

     +   l_f2_day,
     +   s2_year,s2_month,s2_day,s2_timeday,s2_timeday_id,
     +   f2_pres_dayavg_hpa,f2_airt_daymax_c,f2_airt_daymin_c,
     +   f2_airt_range_c,f2_boden_daymin_c,f2_airt_dayavg_c,
     +   f2_vprs_dayavg_hpa,f2_relh_dayavg_pc,f2_wspd_dayavg_bft,
     +   f2_ccov_dayavg_okta,f2_sundur_daytot_h,f2_ppt_daytot_mm,
     +   f2_snowcover_cm,f2_snow_daytot_cm,f2_wspd_daymax_ms,
     +   f2_snowmelted_cm,f2_we_snowmelted_mm,f2_we_snowcover_mm)

102    CONTINUE
c***********
c***********
c      Initialize total arrays
       DO j=1,l_mlent 
        ft_sd_pres_hpa(j)    =f_ndflag
        ft_sd_airt_c(j)      =f_ndflag
        ft_sd_wetb_c(j)      =f_ndflag
        ft_sd_vprs_hpa(j)    =f_ndflag
        ft_sd_relh_pc(j)     =f_ndflag
        ft_sd_relhreg_pc(j)  =f_ndflag
        ft_sd_wdir_code(j)   =f_ndflag
        ft_sd_wspd_bft(j)    =f_ndflag
        ft_sd_ccov_okta(j)   =f_ndflag
        ft_sd_visi_code(j)   =f_ndflag
        ft_sd_grdcnd_code(j) =f_ndflag
        ft_sd_ppt_mm(j)      =f_ndflag

        st_sd_pres_qc(j)     ='X'
        st_sd_airt_qc(j)     ='X'
        st_sd_wetb_qc(j)     ='X'
        st_sd_vprs_qc(j)     ='X'
        st_sd_relh_qc(j)     ='X'
        st_sd_relhreg_qc(j)  ='X'
        st_sd_wspdwdir_qc(j) ='X'
        st_sd_ccov_qc(j)     ='X'
        st_sd_visi_qc(j)     ='X'
        st_sd_grdcnd_qc(j)   ='X'
        st_sd_ppt_qc(j)      ='X'

        ft_pres_dayavg_hpa(j)  =f_ndflag
        ft_airt_daymax_c(j)    =f_ndflag
        ft_airt_daymin_c(j)    =f_ndflag
        ft_airt_range_c(j)     =f_ndflag
        ft_boden_daymin_c(j)   =f_ndflag
        ft_airt_dayavg_c(j)    =f_ndflag
        ft_vprs_dayavg_hpa(j)  =f_ndflag
        ft_relh_dayavg_pc(j)   =f_ndflag
        ft_wspd_dayavg_bft(j)  =f_ndflag
        ft_ccov_dayavg_okta(j) =f_ndflag
        ft_sundur_daytot_h(j)  =f_ndflag
        ft_ppt_daytot_mm(j)    =f_ndflag
        ft_snowcover_cm(j)     =f_ndflag
        ft_snow_daytot_cm(j)   =f_ndflag
        ft_wspd_daymax_ms(j)   =f_ndflag
        ft_snowmelted_cm(j)    =f_ndflag
        ft_we_snowmelted_mm(j) =f_ndflag
        ft_we_snowcover_mm(j)  =f_ndflag
       ENDDO
c***********
c***********
c      Combine 2 sections

c      COMPRESSED,SUBDAILY
       j_sd=1
       IF (l_f1_sd.GT.0) THEN
       DO j=1,l_f1_sd
        st_sd_year(j_sd)        =s1_sd_year(j)
        st_sd_month(j_sd)       =s1_sd_month(j) 
        st_sd_day(j_sd)         =s1_sd_day(j)
        st_sd_time(j_sd)        =s1_sd_time(j)
        st_sd_time_id(j_sd)     =s1_sd_time_id(j)
        ft_sd_pres_hpa(j_sd)    =f1_sd_pres_hpa(j)
        ft_sd_airt_c(j_sd)      =f1_sd_airt_c(j)
        ft_sd_wetb_c(j_sd)      =f1_sd_wetb_c(j)
        ft_sd_vprs_hpa(j_sd)    =f1_sd_vprs_hpa(j)
        ft_sd_relh_pc(j_sd)     =f1_sd_relh_pc(j)
        ft_sd_relhreg_pc(j_sd)  =f1_sd_relhreg_pc(j)
        ft_sd_wdir_code(j_sd)   =f1_sd_wdir_code(j)
        ft_sd_wspd_bft(j_sd)    =f1_sd_wspd_bft(j)
        ft_sd_ccov_okta(j_sd)   =f1_sd_ccov_okta(j)
        ft_sd_visi_code(j_sd)   =f1_sd_visi_code(j)
        ft_sd_grdcnd_code(j_sd) =f1_sd_grdcnd_code(j)
        ft_sd_ppt_mm(j_sd)      =f1_sd_ppt_mm(j)

        st_sd_pres_qc(j_sd)     =s1_sd_pres_qc(j)
        st_sd_airt_qc(j_sd)     =s1_sd_airt_qc(j)
        st_sd_wetb_qc(j_sd)     =s1_sd_wetb_qc(j)
        st_sd_vprs_qc(j_sd)     =s1_sd_vprs_qc(j)
        st_sd_relh_qc(j_sd)     =s1_sd_relh_qc(j)
        st_sd_relhreg_qc(j_sd)  =s1_sd_relhreg_qc(j)
        st_sd_wspdwdir_qc(j_sd) =s1_sd_wspdwdir_qc(j)
        st_sd_ccov_qc(j_sd)     =s1_sd_ccov_qc(j)
        st_sd_visi_qc(j_sd)     =s1_sd_visi_qc(j)
        st_sd_grdcnd_qc(j_sd)   =s1_sd_grdcnd_qc(j)
        st_sd_ppt_qc(j_sd)      =s1_sd_ppt_qc(j)

        st_sd_wetb_ice(j_sd)    =s1_sd_wetb_ice(j) 

        j_sd=j_sd+1
       ENDDO
       ENDIF
c      UNCOMPRESSED,SUBDAILY
       IF (l_f2_sd.GT.0) THEN
       DO j=1,l_f2_sd
        st_sd_year(j_sd)        =s2_sd_year(j)
        st_sd_month(j_sd)       =s2_sd_month(j) 
        st_sd_day(j_sd)         =s2_sd_day(j)
        st_sd_time(j_sd)        =s2_sd_time(j)
        st_sd_time_id(j_sd)     =s2_sd_time_id(j)
        ft_sd_pres_hpa(j_sd)    =f2_sd_pres_hpa(j)
        ft_sd_airt_c(j_sd)      =f2_sd_airt_c(j)
        ft_sd_wetb_c(j_sd)      =f2_sd_wetb_c(j)
        ft_sd_vprs_hpa(j_sd)    =f2_sd_vprs_hpa(j)
        ft_sd_relh_pc(j_sd)     =f2_sd_relh_pc(j)
        ft_sd_relhreg_pc(j_sd)  =f2_sd_relhreg_pc(j)
        ft_sd_wdir_code(j_sd)   =f2_sd_wdir_code(j)
        ft_sd_wspd_bft(j_sd)    =f2_sd_wspd_bft(j)
        ft_sd_ccov_okta(j_sd)   =f2_sd_ccov_okta(j)
        ft_sd_visi_code(j_sd)   =f2_sd_visi_code(j)
        ft_sd_grdcnd_code(j_sd) =f2_sd_grdcnd_code(j)
        ft_sd_ppt_mm(j_sd)      =f2_sd_ppt_mm(j)

        st_sd_pres_qc(j_sd)     =s2_sd_pres_qc(j)
        st_sd_airt_qc(j_sd)     =s2_sd_airt_qc(j)
        st_sd_wetb_qc(j_sd)     =s2_sd_wetb_qc(j)
        st_sd_vprs_qc(j_sd)     =s2_sd_vprs_qc(j)
        st_sd_relh_qc(j_sd)     =s2_sd_relh_qc(j)
        st_sd_relhreg_qc(j_sd)  =s2_sd_relhreg_qc(j)
        st_sd_wspdwdir_qc(j_sd) =s2_sd_wspdwdir_qc(j)
        st_sd_ccov_qc(j_sd)     =s2_sd_ccov_qc(j)
        st_sd_visi_qc(j_sd)     =s2_sd_visi_qc(j)
        st_sd_grdcnd_qc(j_sd)   =s2_sd_grdcnd_qc(j)
        st_sd_ppt_qc(j_sd)      =s2_sd_ppt_qc(j)

        st_sd_wetb_ice(j_sd)    =s2_sd_wetb_ice(j) 

        j_sd=j_sd+1

        IF (j_sd.GE.l_mlent) THEN 
         print*,'emergency stop, sd total exceeded'
         CALL SLEEP(5)
        ENDIF
       ENDDO
       ENDIF

       j_sd=j_sd-1

c      COMPRESSED, DAILY
       j_day=1
       IF (l_f1_day.GT.0) THEN
       DO j=1,l_f1_day
        st_year(j_day)             =s1_year(j) 
        st_month(j_day)            =s1_month(j)
        st_day(j_day)              =s1_day(j)
        st_timeday(j_day)          =s1_timeday(j)
        st_timeday_id(j_day)       =s1_timeday_id(j)
        ft_pres_dayavg_hpa(j_day)  =f1_pres_dayavg_hpa(j)
        ft_airt_daymax_c(j_day)    =f1_airt_daymax_c(j)
        ft_airt_daymin_c(j_day)    =f1_airt_daymin_c(j)
        ft_airt_range_c(j_day)     =f1_airt_range_c(j)
        ft_boden_daymin_c(j_day)   =f1_boden_daymin_c(j)
        ft_airt_dayavg_c(j_day)    =f1_airt_dayavg_c(j)
        ft_vprs_dayavg_hpa(j_day)  =f1_vprs_dayavg_hpa(j)
        ft_relh_dayavg_pc(j_day)   =f1_relh_dayavg_pc(j)
        ft_wspd_dayavg_bft(j_day)  =f1_wspd_dayavg_bft(j)
        ft_ccov_dayavg_okta(j_day) =f1_ccov_dayavg_okta(j)
        ft_sundur_daytot_h(j_day)  =f1_sundur_daytot_h(j)
        ft_ppt_daytot_mm(j_day)    =f1_ppt_daytot_mm(j)
        ft_snowcover_cm(j_day)     =f1_snowcover_cm(j)
        ft_snow_daytot_cm(j_day)   =f1_snow_daytot_cm(j)
        ft_wspd_daymax_ms(j_day)   =f1_wspd_daymax_ms(j)
        ft_snowmelted_cm(j_day)    =f1_snowmelted_cm(j)
        ft_we_snowmelted_mm(j_day) =f1_we_snowmelted_mm(j)
        ft_we_snowcover_mm(j_day)  =f1_we_snowcover_mm(j)

        j_day=j_day+1
       ENDDO
       ENDIF
c      UNCOMPRESSED DAILY
       IF (l_f2_day.GT.0) THEN
       DO j=1,l_f2_day
        st_year(j_day)             =s2_year(j) 
        st_month(j_day)            =s2_month(j)
        st_day(j_day)              =s2_day(j)
        st_timeday(j_day)          =s2_timeday(j)
        st_timeday_id(j_day)       =s2_timeday_id(j)
        ft_pres_dayavg_hpa(j_day)  =f2_pres_dayavg_hpa(j)
        ft_airt_daymax_c(j_day)    =f2_airt_daymax_c(j)
        ft_airt_daymin_c(j_day)    =f2_airt_daymin_c(j)
        ft_airt_range_c(j_day)     =f2_airt_range_c(j)
        ft_boden_daymin_c(j_day)   =f2_boden_daymin_c(j)
        ft_airt_dayavg_c(j_day)    =f2_airt_dayavg_c(j)
        ft_vprs_dayavg_hpa(j_day)  =f2_vprs_dayavg_hpa(j)
        ft_relh_dayavg_pc(j_day)   =f2_relh_dayavg_pc(j)
        ft_wspd_dayavg_bft(j_day)  =f2_wspd_dayavg_bft(j)
        ft_ccov_dayavg_okta(j_day) =f2_ccov_dayavg_okta(j)
        ft_sundur_daytot_h(j_day)  =f2_sundur_daytot_h(j)
        ft_ppt_daytot_mm(j_day)    =f2_ppt_daytot_mm(j)
        ft_snowcover_cm(j_day)     =f2_snowcover_cm(j)
        ft_snow_daytot_cm(j_day)   =f2_snow_daytot_cm(j)
        ft_wspd_daymax_ms(j_day)   =f2_wspd_daymax_ms(j)
        ft_snowmelted_cm(j_day)    =f2_snowmelted_cm(j)
        ft_we_snowmelted_mm(j_day) =f2_we_snowmelted_mm(j)
        ft_we_snowcover_mm(j_day)  =f2_we_snowcover_mm(j)

        j_day=j_day+1

        IF (j_day.GE.l_mlent) THEN 
         print*,'emergency stop, day total exceeded'
         CALL SLEEP(5)
        ENDIF
       ENDDO
       ENDIF

       j_day=j_day-1

       print*,'l_f1_sd,l_f1_day=',l_f1_sd,l_f1_day
       print*,'l_f2_sd,l_f2_day=',l_f2_sd,l_f2_day
       print*,'j_sd,j_day=',j_sd,j_day
c***********
c      Convert subdaily airt, wetb, wspd, wdir

       CALL convert_variables(l_mlent,j_sd,j_day,f_ndflag,
     +   ft_sd_airt_c,ft_sd_wetb_c,ft_sd_wdir_code,ft_sd_wspd_bft,
     +   ft_sd_pres_hpa,ft_sd_vprs_hpa,
     +   st_sd_wetb_ice,
     +   st_sd_time,st_sd_time_id,
     +   st_timeday,st_timeday_id,
     +   f_hght_m,f_lon_deg,

     +   ft_sd_airt_k,ft_sd_wetb_k,ft_sd_wdir_deg,ft_sd_wspd_ms,
     +   ft_sd_dewp_c,ft_sd_dewp_k,ft_sd_slpres_hpa,
     +   st_sd_timeutc,st_sd_timeutc_hh_mm_ss,
     +   st_timedayutc,st_timedayutc_hh_mm_ss)

c      Find duration of precipation intervals
       CALL find_time_interval(f_ndflag,l_mlent,j_sd,
     +   st_sd_year,st_sd_month,st_sd_day,st_sd_timeutc_hh_mm_ss,
     +   f_duration_s)

c      print*,'f_duration_s=',(f_duration_s(ii),ii=1,5) 

c       print*,'st_sd_timeutc',st_sd_timeutc(1),st_sd_timeutc(j_sd)
c       CALL SLEEP(5)
c***********
c      Find stats for assembled vectors
       CALL calc_basic_stats_sd1(l_mlent,j_sd,j_day,f_ndflag,
     +   ft_sd_pres_hpa,ft_sd_airt_c,ft_sd_wetb_c,
     +   ft_sd_vprs_hpa,ft_sd_relh_pc,ft_sd_relhreg_pc,
     +   ft_sd_wdir_code,ft_sd_wspd_bft,ft_sd_ccov_okta,
     +   ft_sd_visi_code,ft_sd_grdcnd_code,ft_sd_ppt_mm,

     +   ft_pres_dayavg_hpa,ft_airt_daymax_c,ft_airt_daymin_c,
     +   ft_airt_range_c,ft_boden_daymin_c,ft_airt_dayavg_c,
     +   ft_vprs_dayavg_hpa,ft_relh_dayavg_pc,ft_wspd_dayavg_bft,
     +   ft_ccov_dayavg_okta,ft_sundur_daytot_h,ft_ppt_daytot_mm,
     +   ft_snowcover_cm,ft_snow_daytot_cm,ft_wspd_daymax_ms,
     +   ft_snowmelted_cm,ft_we_snowmelted_mm,ft_we_snowcover_mm,

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

      print*,'ft_pres_dayavg_hpa=',(ft_pres_dayavg_hpa(ii),ii=1,10)
      print*,'pres day stat',
     +  ft_day_pres_min_hpa,ft_day_pres_max_hpa,
     +    ft_day_pres_avg_hpa,
     +    ft_day_pres_ngood,ft_day_pres_nbad
c***********
c     Archive stats for assembled variables

        i_arch_j_sd(i)               =j_sd

c       0 archive subdaily time
        s_arch_sd_year_st(i)         =st_sd_year(1)
        s_arch_sd_year_en(i)         =st_sd_year(j_sd)
        s_arch_sd_month_st(i)        =st_sd_month(1)
        s_arch_sd_month_en(i)        =st_sd_month(j_sd)
        s_arch_sd_day_st(i)          =st_sd_day(1)
        s_arch_sd_day_en(i)          =st_sd_day(j_sd)
        s_arch_sd_timeutc_st(i)      =st_sd_timeutc(1)
        s_arch_sd_timeutc_en(i)      =st_sd_timeutc(j_sd)

c        print*,'i,s_arch_sd_year_st=',i,s_arch_sd_year_st(i)
c        print*,'i,s_arch_sd_year_en=',i,s_arch_sd_year_en(i)
c        print*,'i,s_arch_sd_timeutc_st',s_arch_sd_timeutc_st(i)
c        print*,'i,s_arch_sd_timeutc_en',s_arch_sd_timeutc_en(i)
c        CALL SLEEP(5)

c       1
        f_arch_sd_pres_min_hpa(i)    =ft_sd_pres_min_hpa
        f_arch_sd_pres_max_hpa(i)    =ft_sd_pres_max_hpa
        f_arch_sd_pres_avg_hpa(i)    =ft_sd_pres_avg_hpa
        f_arch_sd_pres_ngood(i)      =ft_sd_pres_ngood
        f_arch_sd_pres_nbad(i)       =ft_sd_pres_nbad
c       2
        f_arch_sd_airt_min_c(i)      =ft_sd_airt_min_c
        f_arch_sd_airt_max_c(i)      =ft_sd_airt_max_c
        f_arch_sd_airt_avg_c(i)      =ft_sd_airt_avg_c
        f_arch_sd_airt_ngood(i)      =ft_sd_airt_ngood
        f_arch_sd_airt_nbad(i)       =ft_sd_airt_nbad
c       3
        f_arch_sd_wetb_min_c(i)      =ft_sd_wetb_min_c
        f_arch_sd_wetb_max_c(i)      =ft_sd_wetb_max_c
        f_arch_sd_wetb_avg_c(i)      =ft_sd_wetb_avg_c
        f_arch_sd_wetb_ngood(i)      =ft_sd_wetb_ngood
        f_arch_sd_wetb_nbad(i)       =ft_sd_wetb_nbad
c       4
        f_arch_sd_vprs_min_hpa(i)    =ft_sd_vprs_min_hpa
        f_arch_sd_vprs_max_hpa(i)    =ft_sd_vprs_max_hpa
        f_arch_sd_vprs_avg_hpa(i)    =ft_sd_vprs_avg_hpa
        f_arch_sd_vprs_ngood(i)      =ft_sd_vprs_ngood
        f_arch_sd_vprs_nbad(i)       =ft_sd_vprs_nbad
c       5
        f_arch_sd_relh_min_pc(i)     =ft_sd_relh_min_pc
        f_arch_sd_relh_max_pc(i)     =ft_sd_relh_max_pc
        f_arch_sd_relh_avg_pc(i)     =ft_sd_relh_avg_pc 
        f_arch_sd_relh_ngood(i)      =ft_sd_relh_ngood
        f_arch_sd_relh_nbad(i)       =ft_sd_relh_nbad
c       6
        f_arch_sd_relhreg_min_pc(i)  =ft_sd_relhreg_min_pc
        f_arch_sd_relhreg_max_pc(i)  =ft_sd_relhreg_max_pc
        f_arch_sd_relhreg_avg_pc(i)  =ft_sd_relhreg_avg_pc
        f_arch_sd_relhreg_ngood(i)   =ft_sd_relhreg_ngood
        f_arch_sd_relhreg_nbad(i)    =ft_sd_relhreg_nbad
c       7
        f_arch_sd_wdir_min_code(i)   =ft_sd_wdir_min_code
        f_arch_sd_wdir_max_code(i)   =ft_sd_wdir_max_code
        f_arch_sd_wdir_avg_code(i)   =ft_sd_wdir_avg_code 
        f_arch_sd_wdir_ngood(i)      =ft_sd_wdir_ngood 
        f_arch_sd_wdir_nbad(i)       =ft_sd_wdir_nbad
c       8
        f_arch_sd_wspd_min_bft(i)    =ft_sd_wspd_min_bft
        f_arch_sd_wspd_max_bft(i)    =ft_sd_wspd_max_bft
        f_arch_sd_wspd_avg_bft(i)    =ft_sd_wspd_avg_bft
        f_arch_sd_wspd_ngood(i)      =ft_sd_wspd_ngood
        f_arch_sd_wspd_nbad(i)       =ft_sd_wspd_nbad
c       9
        f_arch_sd_ccov_min_okta(i)   =ft_sd_ccov_min_okta
        f_arch_sd_ccov_max_okta(i)   =ft_sd_ccov_max_okta
        f_arch_sd_ccov_avg_okta(i)   =ft_sd_ccov_avg_okta
        f_arch_sd_ccov_ngood(i)      =ft_sd_ccov_ngood
        f_arch_sd_ccov_nbad(i)       =ft_sd_ccov_nbad
c       10
        f_arch_sd_visi_min_code(i)   =ft_sd_visi_min_code
        f_arch_sd_visi_max_code(i)   =ft_sd_visi_max_code
        f_arch_sd_visi_avg_code(i)   =ft_sd_visi_avg_code
        f_arch_sd_visi_ngood(i)      =ft_sd_visi_ngood
        f_arch_sd_visi_nbad(i)       =ft_sd_visi_nbad
c       11
        f_arch_sd_grdcnd_min_code(i) =ft_sd_grdcnd_min_code
        f_arch_sd_grdcnd_max_code(i) =ft_sd_grdcnd_max_code
        f_arch_sd_grdcnd_avg_code(i) =ft_sd_grdcnd_avg_code
        f_arch_sd_grdcnd_ngood(i)    =ft_sd_grdcnd_ngood
        f_arch_sd_grdcnd_nbad(i)     =ft_sd_grdcnd_nbad
c       12
        f_arch_sd_ppt_min_mm(i)      =ft_sd_ppt_min_mm
        f_arch_sd_ppt_max_mm(i)      =ft_sd_ppt_max_mm
        f_arch_sd_ppt_avg_mm(i)      =ft_sd_ppt_avg_mm
        f_arch_sd_ppt_ngood(i)       =ft_sd_ppt_ngood
        f_arch_sd_ppt_nbad(i)        =ft_sd_ppt_nbad
        
c***********
c     Archival - STATS DAY

        i_arch_j_day(i)                  =j_day

c       1
        f_arch_day_pres_min_hpa(i)       =ft_day_pres_min_hpa
        f_arch_day_pres_max_hpa(i)       =ft_day_pres_max_hpa
        f_arch_day_pres_avg_hpa(i)       =ft_day_pres_avg_hpa
        f_arch_day_pres_ngood(i)         =ft_day_pres_ngood
        f_arch_day_pres_nbad(i)          =ft_day_pres_nbad
c       2
        f_arch_day_airt_daymax_min_c(i)  =ft_day_airt_daymax_min_c
        f_arch_day_airt_daymax_max_c(i)  =ft_day_airt_daymax_max_c
        f_arch_day_airt_daymax_avg_c(i)  =ft_day_airt_daymax_avg_c
        f_arch_day_airt_daymax_ngood(i)  =ft_day_airt_daymax_ngood
        f_arch_day_airt_daymax_nbad(i)   =ft_day_airt_daymax_nbad
c       3
        f_arch_day_airt_daymin_min_c(i)  =ft_day_airt_daymin_min_c
        f_arch_day_airt_daymin_max_c(i)  =ft_day_airt_daymin_max_c
        f_arch_day_airt_daymin_avg_c(i)  =ft_day_airt_daymin_avg_c
        f_arch_day_airt_daymin_ngood(i)  =ft_day_airt_daymin_ngood
        f_arch_day_airt_daymin_nbad(i)   =ft_day_airt_daymin_nbad
c       4
        f_arch_day_airt_range_min_c(i)   =ft_day_airt_range_min_c
        f_arch_day_airt_range_max_c(i)   =ft_day_airt_range_max_c
        f_arch_day_airt_range_avg_c(i)   =ft_day_airt_range_avg_c
        f_arch_day_airt_range_ngood(i)   =ft_day_airt_range_ngood
        f_arch_day_airt_range_nbad(i)    =ft_day_airt_range_nbad
c       5
        f_arch_day_boden_daymin_min_c(i) =ft_day_boden_daymin_min_c
        f_arch_day_boden_daymin_max_c(i) =ft_day_boden_daymin_max_c
        f_arch_day_boden_daymin_avg_c(i) =ft_day_boden_daymin_avg_c
        f_arch_day_boden_daymin_ngood(i) =ft_day_boden_daymin_ngood
        f_arch_day_boden_daymin_nbad(i)  =ft_day_boden_daymin_nbad
c       6
        f_arch_day_airt_dayavg_min_c(i)  =ft_day_airt_dayavg_min_c
        f_arch_day_airt_dayavg_max_c(i)  =ft_day_airt_dayavg_max_c
        f_arch_day_airt_dayavg_avg_c(i)  =ft_day_airt_dayavg_avg_c
        f_arch_day_airt_dayavg_ngood(i)  =ft_day_airt_dayavg_ngood
        f_arch_day_airt_dayavg_nbad(i)   =ft_day_airt_dayavg_nbad
c       7
        f_arch_day_vprs_dayavg_min_hpa(i)=ft_day_vprs_dayavg_min_hpa
        f_arch_day_vprs_dayavg_max_hpa(i)=ft_day_vprs_dayavg_max_hpa
        f_arch_day_vprs_dayavg_avg_hpa(i)=ft_day_vprs_dayavg_avg_hpa
        f_arch_day_vprs_dayavg_ngood(i)  =ft_day_vprs_dayavg_ngood
        f_arch_day_vprs_dayavg_nbad(i)   =ft_day_vprs_dayavg_nbad
c       8
        f_arch_day_relh_dayavg_min_pc(i) =ft_day_relh_dayavg_min_pc
        f_arch_day_relh_dayavg_max_pc(i) =ft_day_relh_dayavg_max_pc
        f_arch_day_relh_dayavg_avg_pc(i) =ft_day_relh_dayavg_avg_pc
        f_arch_day_relh_dayavg_ngood(i)  =ft_day_relh_dayavg_ngood
        f_arch_day_relh_dayavg_nbad(i)   =ft_day_relh_dayavg_nbad
c       9
        f_arch_day_wspd_dayavg_min_bft(i)=ft_day_wspd_dayavg_min_bft
        f_arch_day_wspd_dayavg_max_bft(i)=ft_day_wspd_dayavg_max_bft
        f_arch_day_wspd_dayavg_avg_bft(i)=ft_day_wspd_dayavg_avg_bft
        f_arch_day_wspd_dayavg_ngood(i)  =ft_day_wspd_dayavg_ngood
        f_arch_day_wspd_dayavg_nbad(i)   =ft_day_wspd_dayavg_nbad
c       10  
        f_arch_day_ccov_dayavg_min_okta(i)=ft_day_ccov_dayavg_min_okta
        f_arch_day_ccov_dayavg_max_okta(i)=ft_day_ccov_dayavg_max_okta
        f_arch_day_ccov_dayavg_avg_okta(i)=ft_day_ccov_dayavg_avg_okta
        f_arch_day_ccov_dayavg_ngood(i)   =ft_day_ccov_dayavg_ngood
        f_arch_day_ccov_dayavg_nbad(i)    =ft_day_ccov_dayavg_nbad
c       11
        f_arch_day_sundur_daytot_min_h(i)=ft_day_sundur_daytot_min_h
        f_arch_day_sundur_daytot_max_h(i)=ft_day_sundur_daytot_max_h
        f_arch_day_sundur_daytot_avg_h(i)=ft_day_sundur_daytot_avg_h
        f_arch_day_sundur_daytot_ngood(i)=ft_day_sundur_daytot_ngood
        f_arch_day_sundur_daytot_nbad(i) =ft_day_sundur_daytot_nbad
c       12
        f_arch_day_ppt_daytot_min_mm(i)  =ft_day_ppt_daytot_min_mm
        f_arch_day_ppt_daytot_max_mm(i)  =ft_day_ppt_daytot_max_mm
        f_arch_day_ppt_daytot_avg_mm(i)  =ft_day_ppt_daytot_avg_mm
        f_arch_day_ppt_daytot_ngood(i)   =ft_day_ppt_daytot_ngood
        f_arch_day_ppt_daytot_nbad(i)    =ft_day_ppt_daytot_nbad
c       13
        f_arch_day_snowcover_min_cm(i)   =ft_day_snowcover_min_cm
        f_arch_day_snowcover_max_cm(i)   =ft_day_snowcover_max_cm
        f_arch_day_snowcover_avg_cm(i)   =ft_day_snowcover_avg_cm
        f_arch_day_snowcover_ngood(i)    =ft_day_snowcover_ngood
        f_arch_day_snowcover_nbad(i)     =ft_day_snowcover_nbad
c       14
        f_arch_day_snow_daytot_min_cm(i) =ft_day_snow_daytot_min_cm
        f_arch_day_snow_daytot_max_cm(i) =ft_day_snow_daytot_max_cm
        f_arch_day_snow_daytot_avg_cm(i) =ft_day_snow_daytot_avg_cm
        f_arch_day_snow_daytot_ngood(i)  =ft_day_snow_daytot_ngood
        f_arch_day_snow_daytot_nbad(i)   =ft_day_snow_daytot_nbad
c       15
        f_arch_day_wspd_daymax_min_ms(i) =ft_day_wspd_daymax_min_ms 
        f_arch_day_wspd_daymax_max_ms(i) =ft_day_wspd_daymax_max_ms
        f_arch_day_wspd_daymax_avg_ms(i) =ft_day_wspd_daymax_avg_ms
        f_arch_day_wspd_daymax_ngood(i)  =ft_day_wspd_daymax_ngood
        f_arch_day_wspd_daymax_nbad(i)   =ft_day_wspd_daymax_nbad
c       16
        f_arch_day_snowmelted_min_cm(i)  =ft_day_snowmelted_min_cm
        f_arch_day_snowmelted_max_cm(i)  =ft_day_snowmelted_max_cm
        f_arch_day_snowmelted_avg_cm(i)  =ft_day_snowmelted_avg_cm
        f_arch_day_snowmelted_ngood(i)   =ft_day_snowmelted_ngood
        f_arch_day_snowmelted_nbad(i)    =ft_day_snowmelted_nbad
c       17
        f_arch_day_we_snowmelted_min_mm(i)=ft_day_we_snowmelted_min_mm
        f_arch_day_we_snowmelted_max_mm(i)=ft_day_we_snowmelted_max_mm
        f_arch_day_we_snowmelted_avg_mm(i)=ft_day_we_snowmelted_avg_mm
        f_arch_day_we_snowmelted_ngood(i) =ft_day_we_snowmelted_ngood
        f_arch_day_we_snowmelted_nbad(i)  =ft_day_we_snowmelted_nbad
c       18
        f_arch_day_we_snowcover_min_mm(i)=ft_day_we_snowcover_min_mm
        f_arch_day_we_snowcover_max_mm(i)=ft_day_we_snowcover_max_mm
        f_arch_day_we_snowcover_avg_mm(i)=ft_day_we_snowcover_avg_mm
        f_arch_day_we_snowcover_ngood(i) =ft_day_we_snowcover_ngood
        f_arch_day_we_snowcover_nbad(i)  =ft_day_we_snowcover_nbad
c***********
c       USE THIS ONE

c       Create header file: no header lines if all data NULL
901     s_directory_root='D:\Export\DWD_subdaily_header\'    !'Production_sd_header/'
        CALL export_header_subdaily2(f_ndflag,s_directory_root,
     +    s_basis_wigos_full(i),j_sd,l_mlent,
     +    st_sd_year,st_sd_month,st_sd_day,st_sd_timeutc,
     +    st_sd_timeutc_hh_mm_ss,
     +    s_basis_stnname(i),
     +    s_basis_hght(i),s_basis_lat(i),s_basis_lon(i),

     +    ft_sd_ppt_mm,ft_sd_airt_k,ft_sd_slpres_hpa,ft_sd_wspd_ms,
     +    ft_sd_wdir_deg,ft_sd_relh_pc,ft_snow_daytot_cm, 
     +    f_duration_s)

c       Create observation file
902     s_directory_root='D:\Export\DWD_subdaily_observation\'   !'Production_sd_observation/'
        CALL export_observation_subdaily2(f_ndflag,s_directory_root,
     +    s_basis_wigos_full(i),j_sd,l_mlent,
     +    st_sd_year,st_sd_month,st_sd_day,st_sd_timeutc,
     +    st_sd_timeutc_hh_mm_ss,
     +    s_basis_stnname(i),
     +    s_basis_hght(i),s_basis_lat(i),s_basis_lon(i),

     +    ft_sd_ppt_mm,ft_sd_airt_k,ft_sd_slpres_hpa,ft_sd_wspd_ms,
     +    ft_sd_wdir_deg,ft_sd_relh_pc,ft_snow_daytot_cm, 
     +    ft_sd_airt_c,ft_sd_pres_hpa,ft_sd_wspd_bft,
     +    ft_sd_wdir_code,ft_sd_vprs_hpa,
     +    f_duration_s)

c*****
c       INITIAL WORKINGS

c       Create header file: 2 types of header line for same date
cc        s_directory_root='Production_sd_header/'
c        s_directory_root='D:\Export\DWD_subdaily_header\'
c        CALL export_header_subdaily1a(f_ndflag,s_directory_root,
c     +    s_basis_wigos_full(i),j_sd,l_mlent,
c     +    st_sd_year,st_sd_month,st_sd_day,st_sd_timeutc,
c     +    st_sd_timeutc_hh_mm_ss,
c     +    s_basis_stnname(i),
c     +    s_basis_hght(i),s_basis_lat(i),s_basis_lon(i),

c     +    f_duration_s)

c        CALL export_header_subdaily(s_directory_root,
c     +    s_basis_wigos_full(i),j_sd,l_mlent,
c     +    st_sd_year,st_sd_month,st_sd_day,st_sd_timeutc,
c     +    st_sd_timeutc_hh_mm_ss,
c     +    s_basis_stnname(i),
c     +    s_basis_hght(i),s_basis_lat(i),s_basis_lon(i))

c        CALL export_observation_subdaily(f_ndflag,s_directory_root,
c     +    s_basis_wigos_full(i),j_sd,l_mlent,
c     +    st_sd_year,st_sd_month,st_sd_day,st_sd_timeutc,
c     +    st_sd_timeutc_hh_mm_ss,
c     +    s_basis_stnname(i),
c     +    s_basis_hght(i),s_basis_lat(i),s_basis_lon(i),

c     +    ft_sd_ppt_mm,ft_sd_airt_k,ft_sd_slpres_hpa,ft_sd_wspd_ms,
c     +    ft_sd_wdir_deg,ft_sd_relh_pc,ft_snow_daytot_cm, 
c     +    ft_sd_airt_c,ft_sd_pres_hpa,ft_sd_wspd_bft,
c     +    ft_sd_wdir_code,ft_sd_vprs_hpa,
c     +    f_duration_s)

c***********
c       Create formatted data file for subdaily

        s_export_stid   =s_basis_stid(i)
        s_export_stnname=s_basis_stnname(i)
        s_export_lat    =s_basis_lat(i)
        s_export_lon    =s_basis_lon(i)
        s_export_hght   =s_basis_hght(i)

c        CALL export_format_data(s_directory_output,
c     +   f_ndflag,
c     +   s_export_stid,s_export_stnname,
c     +   s_export_lat,s_export_lon,s_export_hght,
c     +   l_mlent,j_sd,
c     +   st_sd_year,st_sd_month,st_sd_day,st_sd_time,st_sd_time_id,
c     +   ft_sd_airt_k,ft_sd_ppt_mm,
c     +   ft_sd_wspd_ms,ft_sd_wdir_deg,
c     +   ft_sd_pres_hpa,ft_sd_wetb_k)

c***********
      ENDDO        !close i
c************************************************************************
c     Export table sn1
      s_filename1='export_table_sn1_stnmetadata.dat'
      CALL export_tab_sn1_stndata(s_directory_output,s_filename1,
     +  s_date,
     +  l_mstn,l_file_basis, 
     +  s_basis_stke,s_basis_stid,s_basis_stdate,s_basis_endate,
     +  s_basis_hght,s_basis_lat,s_basis_lon,s_basis_stnname,
     +  i_arch_j_day,i_arch_j_sd,
     +  s_arch_sd_year_st,s_arch_sd_year_en,
     +  s_arch_sd_month_st,s_arch_sd_month_en,
     +  s_arch_sd_day_st,s_arch_sd_day_en,
     +  s_arch_sd_timeutc_st,s_arch_sd_timeutc_en,
     +  f_arch_sd_pres_ngood,f_arch_sd_airt_ngood,
     +  f_arch_sd_relh_ngood,f_arch_sd_wdir_ngood,
     +  f_arch_sd_wspd_ngood,f_arch_sd_ppt_ngood,
     +  f_arch_day_snowcover_ngood,f_arch_day_snow_daytot_ngood)

c    +  f_arch_sd_pres_ngood(i)         s1-58
c        f_arch_sd_airt_ngood            s2-85
c        f_arch_sd_relh_ngood            s5-38
c        f_arch_sd_wdir_ngood(i)         s7-106
c        f_arch_sd_wspd_ngood(i)         s8-107 
c        f_arch_sd_ppt_ngood(i)          s12-44
c        f_arch_day_snowcover_ngood(i)   d13-53
c        f_arch_day_snow_daytot_ngood(i) d14-55)


c     Export table of station info sorted on number of lines
      s_filename1='stats_summary_list_sd_sort.dat'
      CALL export_listsort_sd(s_directory_output,s_filename1,
     +  s_date,
     +  l_mstn,l_file_use,
     +  s_basis_stke,s_basis_stid,s_basis_stdate,s_basis_endate,
     +  s_basis_hght,s_basis_lat,s_basis_lon,
     +  i_arch_j_sd)  

c     Export table of daily stats for each station
      s_filename1='export_basis_info.txt'
      CALL export_basis_info(s_directory_output,s_filename1,
     +  s_date,l_file_basis,
     +  s_basis_stke,s_basis_stid,s_basis_stdate,s_basis_endate,
     +  s_basis_hght,s_basis_lat,s_basis_lon,
     +  s_basis_stnname,s_basis_bundesland)

c************************************************************************
c     SORTED SUBDAILY SUMMARIES

c     1.PRES
      s_filename1='statsort_subday_pres.txt'
      CALL sift_sort_export_sd(s_directory_output,s_filename1,
     +   s_date,
     +   l_mstn,l_file_use,
     +   f_arch_sd_pres_ngood,f_arch_sd_pres_nbad,
     +   f_arch_sd_pres_avg_hpa,
     +   f_arch_sd_pres_min_hpa,f_arch_sd_pres_max_hpa)

c     2.AIRT
      s_filename1='statsort_subday_airt.txt'
      CALL sift_sort_export_sd(s_directory_output,s_filename1,
     +   s_date,
     +   l_mstn,l_file_use,
     +   f_arch_sd_airt_ngood,f_arch_sd_airt_nbad,
     +   f_arch_sd_airt_avg_c,
     +   f_arch_sd_airt_min_c,f_arch_sd_airt_max_c)

c     3.WETB
      s_filename1='statsort_subday_wetb.txt'
      CALL sift_sort_export_sd(s_directory_output,s_filename1,
     +   s_date,
     +   l_mstn,l_file_use,
     +   f_arch_sd_wetb_ngood,f_arch_sd_wetb_nbad,
     +   f_arch_sd_wetb_avg_c,
     +   f_arch_sd_wetb_min_c,f_arch_sd_wetb_max_c)

c     4.VPRS
      s_filename1='statsort_subday_vprs.txt'
      CALL sift_sort_export_sd(s_directory_output,s_filename1,
     +   s_date,
     +   l_mstn,l_file_use,
     +   f_arch_sd_vprs_ngood,f_arch_sd_vprs_nbad,
     +   f_arch_sd_vprs_avg_hpa,
     +   f_arch_sd_vprs_min_hpa,f_arch_sd_vprs_max_hpa)

c     5.RELH
      s_filename1='statsort_subday_relh.txt'
      CALL sift_sort_export_sd(s_directory_output,s_filename1,
     +   s_date,
     +   l_mstn,l_file_use,
     +   f_arch_sd_relh_ngood,f_arch_sd_relh_nbad,
     +   f_arch_sd_relh_avg_pc,
     +   f_arch_sd_relh_min_pc,f_arch_sd_relh_max_pc)

c     8.WSPD
      s_filename1='statsort_subday_wspd.txt'
      CALL sift_sort_export_sd(s_directory_output,s_filename1,
     +   s_date,
     +   l_mstn,l_file_use,
     +   f_arch_sd_wspd_ngood,f_arch_sd_wspd_nbad,
     +   f_arch_sd_wspd_avg_bft,
     +   f_arch_sd_wspd_min_bft,f_arch_sd_wspd_max_bft)

c     9.CCOV
      s_filename1='statsort_subday_ccov.txt'
      CALL sift_sort_export_sd(s_directory_output,s_filename1,
     +   s_date,
     +   l_mstn,l_file_use,
     +   f_arch_sd_ccov_ngood,f_arch_sd_ccov_nbad,
     +   f_arch_sd_ccov_avg_okta,
     +   f_arch_sd_ccov_min_okta,f_arch_sd_ccov_max_okta)

c     12.PPT
      s_filename1='statsort_subday_ppt.txt'
      CALL sift_sort_export_sd(s_directory_output,s_filename1,
     +   s_date,
     +   l_mstn,l_file_use,
     +   f_arch_sd_ppt_ngood,f_arch_sd_ppt_nbad,
     +   f_arch_sd_ppt_avg_mm,
     +   f_arch_sd_ppt_min_mm,f_arch_sd_ppt_max_mm)

c************************************************************************
c     SORTED DAILY SUMMARIES

c     1. pres: Sift/sort/export single column data
      s_filename1='statsort_day_pres_dayavg.txt'
      CALL sift_sort_export_sd(s_directory_output,s_filename1,
     +   s_date,
     +   l_mstn,l_file_use, 
     +   f_arch_day_pres_ngood,f_arch_day_pres_nbad,
     +   f_arch_day_pres_avg_hpa,
     +   f_arch_day_pres_min_hpa,f_arch_day_pres_max_hpa)

c     6. airt_dayavg: Sift/sort/export single column data
      s_filename1='statsort_day_airt_dayavg.txt'
      CALL sift_sort_export_sd(s_directory_output,s_filename1,
     +   s_date,
     +   l_mstn,l_file_use, 
     +   f_arch_day_airt_daymax_ngood,f_arch_day_airt_daymax_nbad,
     +   f_arch_day_airt_dayavg_avg_c,
     +   f_arch_day_airt_dayavg_min_c,f_arch_day_airt_dayavg_max_c)

c     8. relh_dayavg: Sift/sort/export single column data
      s_filename1='statsort_day_relh_dayavg.txt'
      CALL sift_sort_export_sd(s_directory_output,s_filename1,
     +   s_date,
     +   l_mstn,l_file_use,
     +   f_arch_day_relh_dayavg_ngood,f_arch_day_relh_dayavg_nbad,
     +   f_arch_day_relh_dayavg_avg_pc,
     +   f_arch_day_relh_dayavg_min_pc,f_arch_day_relh_dayavg_max_pc)

c     9. wspd_dayavg: Sift/sort/export single column data
      s_filename1='statsort_day_wspd_dayavg.txt'
      CALL sift_sort_export_sd(s_directory_output,s_filename1,
     +   s_date,
     +   l_mstn,l_file_use,
     +   f_arch_day_wspd_dayavg_ngood,f_arch_day_wspd_dayavg_nbad,
     +   f_arch_day_wspd_dayavg_avg_bft,
     +   f_arch_day_wspd_dayavg_min_bft,f_arch_day_wspd_dayavg_max_bft)

c     12. ppt_daytot: Sift/sort/export single column data
      s_filename1='statsort_day_ppt_daytot.txt'
      CALL sift_sort_export_sd(s_directory_output,s_filename1,
     +   s_date,
     +   l_mstn,l_file_use,
     +   f_arch_day_ppt_daytot_ngood,f_arch_day_ppt_daytot_nbad,
     +   f_arch_day_ppt_daytot_avg_mm,
     +   f_arch_day_ppt_daytot_min_mm,f_arch_day_ppt_daytot_max_mm)

c     14. snow_daytot: Sift/sort/export single column data
      s_filename1='statsort_day_snow_daytot.txt'
      CALL sift_sort_export_sd(s_directory_output,s_filename1,
     +   s_date,
     +   l_mstn,l_file_use,
     +   f_arch_day_snow_daytot_ngood,f_arch_day_snow_daytot_nbad,
     +   f_arch_day_snow_daytot_avg_cm,
     +   f_arch_day_snow_daytot_min_cm,f_arch_day_snow_daytot_max_cm)

c     15. wspd_daymax: Sift/sort/export single column data
      s_filename1='statsort_day_wspd_daymax.txt'
      CALL sift_sort_export_sd(s_directory_output,s_filename1,
     +   s_date,
     +   l_mstn,l_file_use,
     +   f_arch_day_wspd_daymax_ngood,f_arch_day_wspd_daymax_nbad,
     +   f_arch_day_wspd_daymax_avg_ms,
     +   f_arch_day_wspd_daymax_min_ms,f_arch_day_wspd_daymax_max_ms)

c     17. we_snowmelted_daytot: Sift/sort/export single column data
      s_filename1='statsort_day_we_snowmelted_daytot.txt'
      CALL sift_sort_export_sd(s_directory_output,s_filename1,
     +  s_date,
     +  l_mstn,l_file_use,
     +  f_arch_day_we_snowmelted_ngood,f_arch_day_we_snowmelted_nbad,
     +  f_arch_day_we_snowmelted_avg_mm,
     +  f_arch_day_we_snowmelted_min_mm,f_arch_day_we_snowmelted_max_mm)
c************************************************************************


c************************************************************************
c     Find end time
      CALL CPU_TIME(f_time_en)

      f_deltime_s=f_time_en-f_time_st
      print*,'f_deltime_s,f_deltime_min=',f_deltime_s,f_deltime_s/60.0     
c************************************************************************
      END

c************************************************************************
c     Sorting subroutine

      SUBROUTINE sort_like_pwave(n,arr,brr)

      IMPLICIT NONE
c****
      INTEGER n
      REAL    arr(n)
      REAL    crr(n)
      INTEGER brr(n)
      INTEGER i,j
      REAL    a
      INTEGER b
c****
c     Copy original array
      DO i=1,n
       brr(i)=i         !simple ascending index
       crr(i)=arr(i)
      ENDDO 
c****
      DO j=2,n
       a=crr(j)
       b=brr(j)
       DO i=j-1,1,-1
        IF (crr(i).LE.a) GOTO 10
        crr(i+1)=crr(i)
        brr(i+1)=brr(i)
       ENDDO
       i=0
10     crr(i+1)=a
       brr(i+1)=b
      ENDDO
     
      RETURN
      END
c***********************************************************
c     Sorting subroutine

      SUBROUTINE sort_like_pwave_integer(n,arr,brr)

      IMPLICIT NONE
c****
      INTEGER n
      INTEGER arr(n)
      INTEGER crr(n)
      INTEGER brr(n)
      INTEGER i,j
      INTEGER a
      INTEGER b
c****
c     Copy original array
      DO i=1,n
       brr(i)=i         !simple ascending index
       crr(i)=arr(i)
      ENDDO 
c****
      DO j=2,n
       a=crr(j)
       b=brr(j)
       DO i=j-1,1,-1
        IF (crr(i).LE.a) GOTO 10
        crr(i+1)=crr(i)
        brr(i+1)=brr(i)
       ENDDO
       i=0
10     crr(i+1)=a
       brr(i+1)=b
      ENDDO
     
      RETURN
      END