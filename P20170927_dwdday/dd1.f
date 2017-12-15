c     Program to process DWD daily data
c     AJ_Kettle, Sept27/2017
c     Oct13/2017 program modified following improvements on UNIX/Jasmin

c     Dec11,2017: Aachen daily/monthly header (356kb/13kb) & observation (2882kb/80kb) files

c************************************************************************
c     Subroutine structure

c     [system script: output compressed file listing to 'zfilelist.dat']

c     get_list_compressed_files_dd.f       need: zfilelist.dat
c     get_info_stns_subday.f               need: KL_standardformate_Beschreibung_stationen.txt
c     get_wigos_number.f                   need: dwd_wmo_number.dat

c   loop starts here

c     [system script: unzip one compressed data directory to temporary directory /HHere]

c     get_geog_metadata_dd                 need: variable station files
c     get_day_data_historical1             need: variable station files
c     convert_data_dwdday 
c       slpres_from-stnpres_dwdday
c     find_timestamp
c     common_month_variables
c       calc_monthly_values2
c     calc_basic_stats_dd
c       dwd_day_stat_package
c     calc_basic_stats_mon
c       dwd_mon_stat_package

c     [system script: delete station files from temporary directory /HHere]

c     export_header_production
c     export_observation_production
c     export_header_monthly
c     export_observation_monthly

c   loop ends here

c     export_tab_sn3a_stndata
c     export_tab_sn2a_stndata
c     cnt_stn_data_present
c     export_mon_datafile
c     make_hist_lprod_dd
c     export_hist_recordlength_dd
c     export_summary_listsort_dd
c     sift_sort_export
c     export_cnts_stn
c     export_datafile1
c     export_datafile2
c     export_datafile3
c     export_datafile4

c************************************************************************

c2-------10--------20--------30--------40--------50--------60--------70--------80
      IMPLICIT NONE
c************************************************************************
c     Declare variables

      REAL                :: f_time_st,f_time_en,f_deltime_s
      CHARACTER(LEN=8)    :: s_date
      CHARACTER(LEN=10)   :: s_time
      CHARACTER(LEN=5)    :: s_zone
      INTEGER             :: i_values(8)

      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: io

      INTEGER             :: i_computer

      INTEGER             :: i_ndflag
      REAL                :: f_ndflag
      DOUBLE PRECISION    :: d_ndflag
      CHARACTER(LEN=4)    :: s_ndflag 

      CHARACTER(LEN=200)  :: s_directory
      CHARACTER(LEN=200)  :: s_filename_in
      CHARACTER(LEN=200)  :: s_pathandname
      CHARACTER(LEN=300)  :: s_pathandname_subday
      CHARACTER(LEN=200)  :: s_directory_output

      CHARACTER(LEN=200)  :: s_filename1

      INTEGER             :: l_zipfile
      CHARACTER(LEN=300)  :: s_zipfiles(1100)
      CHARACTER(LEN=5)    :: s_stnnum(1100)
      CHARACTER(LEN=8)    :: s_stdate(1100),s_endate(1100)

      INTEGER             :: l_zip_use

      CHARACTER(LEN=5)    :: s_stnnum_use

      CHARACTER(LEN=200)  :: s_pathandname_export
      CHARACTER(LEN=200)  :: s_pathandname_export_metadata
      CHARACTER(LEN=200)  :: s_pathandname_export_readme

      CHARACTER(LEN=300)  :: s_linget
      CHARACTER(LEN=300)  :: s_command

      INTEGER             :: l_geog
      CHARACTER(LEN=8)    :: s_geog_stnid(20)
      CHARACTER(LEN=8)    :: s_geog_hgt_m(20)
      CHARACTER(LEN=8)    :: s_geog_lat_deg(20),s_geog_lon_deg(20)
      CHARACTER(LEN=8)    :: s_geog_stdate(20),s_geog_endate(20)
      CHARACTER(LEN=50)   :: s_geog_stnname(20)
      INTEGER             :: i_geog_stnname_len(20)

      CHARACTER(LEN=8)    :: s_last_hgt_m
      CHARACTER(LEN=8)    :: s_last_lat_deg
      CHARACTER(LEN=8)    :: s_last_lon_deg
      CHARACTER(LEN=50)   :: s_last_stnname
      REAL                :: f_last_hgt_m
      REAL                :: f_last_lon_deg

      CHARACTER(LEN=8)    :: s_test
      REAL                :: f_test

c     Information from subdaily subset
      INTEGER             :: l_sd_stnrecord
      CHARACTER(LEN=5)    :: s_sd_stke(100)
      CHARACTER(LEN=5)    :: s_sd_stid(100)
      CHARACTER(LEN=8)    :: s_sd_stdate(100)
      CHARACTER(LEN=8)    :: s_sd_endate(100)
      CHARACTER(LEN=9)    :: s_sd_hght(100)
      CHARACTER(LEN=10)   :: s_sd_lat(100)
      CHARACTER(LEN=10)   :: s_sd_lon(100)
      CHARACTER(LEN=25)   :: s_sd_stnname(100)
      CHARACTER(LEN=25)   :: s_sd_bundesland(100)

      CHARACTER(LEN=17)   :: s_sd_wigos_full(100)

      INTEGER             :: l_prod
      INTEGER             :: l_prod_fulluse
      CHARACTER(LEN=8)    :: s_day_date(100000)
      CHARACTER(LEN=10)   :: s_daytot_pptflg(100000)

c     Primary variables
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

c     Create time-vector for measurement
      CHARACTER(LEN=8)    :: s_dayavg_airt_stime(100000)
      CHARACTER(LEN=5)    :: s_dayavg_airt_timezone(100000)
      CHARACTER(LEN=8)    :: s_dayavg_pres_stime(100000)
      CHARACTER(LEN=5)    :: s_dayavg_pres_timezone(100000)
      CHARACTER(LEN=8)    :: s_dayavg_relh_stime(100000)
      CHARACTER(LEN=5)    :: s_dayavg_relh_timezone(100000)
      CHARACTER(LEN=8)    :: s_dayavg_wspd_stime(100000)
      CHARACTER(LEN=5)    :: s_dayavg_wspd_timezone(100000)
      CHARACTER(LEN=8)    :: s_daytot_ppt_stime(100000)
      CHARACTER(LEN=5)    :: s_daytot_ppt_timezone(100000)
      CHARACTER(LEN=8)    :: s_daytot_snoacc_stime(100000)
      CHARACTER(LEN=5)    :: s_daytot_snoacc_timezone(100000)

c     Derived variables
      REAL                :: f_dayavg_airt_k(100000)
      REAL                :: f_dayavg_slpres_hpa(100000)
      REAL                :: f_daymax_airt_k(100000)
      REAL                :: f_daymin_airt_k(100000)

c     Time stamp information
      CHARACTER(LEN=8)    :: s_dayavg_airtk_stime(100000)
      CHARACTER(LEN=5)    :: s_dayavg_airtk_timezone(100000)
      CHARACTER(LEN=8)    :: s_dayavg_slpres_stime(100000)
      CHARACTER(LEN=5)    :: s_dayavg_slpres_timezone(100000)

      CHARACTER(LEN=8)    :: s_daymax_airt_stime(100000)
      CHARACTER(LEN=5)    :: s_daymax_airt_timezone(100000)
      CHARACTER(LEN=8)    :: s_daymin_airt_stime(100000)
      CHARACTER(LEN=5)    :: s_daymin_airt_timezone(100000)

      CHARACTER(LEN=8)    :: s_dayavg_common_stime(100000)
      CHARACTER(LEN=5)    :: s_dayavg_common_timezone(100000)
      CHARACTER(LEN=8)    :: s_dayavg_common2_stime(100000)
      CHARACTER(LEN=5)    :: s_dayavg_common2_timezone(100000)

      INTEGER             :: i_cnt_stamp_reverse
      INTEGER             :: i_vec_stamp_reverse(100)

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
c****
c****
      INTEGER             :: i_arch_lprod(1100)
      CHARACTER(LEN=5)    :: s_arch_geog_stnid(1100)
      CHARACTER(LEN=8)    :: s_arch_geog_hgt_m(1100)
      CHARACTER(LEN=8)    :: s_arch_geog_lat_deg(1100)
      CHARACTER(LEN=8)    :: s_arch_geog_lon_deg(1100)
      CHARACTER(LEN=8)    :: s_arch_geog_stdate(1100)
      CHARACTER(LEN=8)    :: s_arch_geog_endate(1100)
      CHARACTER(LEN=8)    :: s_arch_dayrec_stdate(1100)
      CHARACTER(LEN=8)    :: s_arch_dayrec_endate(1100)

      INTEGER             :: i_arch_dayavg_airt_ngood(1100)
      REAL                :: f_arch_dayavg_airt_ngood(1100)
      REAL                :: f_arch_dayavg_airt_nbad(1100)
      REAL                :: f_arch_dayavg_airt_min_c(1100)
      REAL                :: f_arch_dayavg_airt_max_c(1100)
      REAL                :: f_arch_dayavg_airt_avg_c(1100)

      INTEGER             :: i_arch_dayavg_vapprs_ngood(1100)
      REAL                :: f_arch_dayavg_vapprs_ngood(1100)
      REAL                :: f_arch_dayavg_vapprs_nbad(1100)
      REAL                :: f_arch_dayavg_vapprs_min_mb(1100)
      REAL                :: f_arch_dayavg_vapprs_max_mb(1100)
      REAL                :: f_arch_dayavg_vapprs_avg_mb(1100)

      INTEGER             :: i_arch_dayavg_ccov_ngood(1100)
      REAL                :: f_arch_dayavg_ccov_ngood(1100)
      REAL                :: f_arch_dayavg_ccov_nbad(1100)
      REAL                :: f_arch_dayavg_ccov_min_okta(1100)
      REAL                :: f_arch_dayavg_ccov_max_okta(1100)
      REAL                :: f_arch_dayavg_ccov_avg_okta(1100)

      INTEGER             :: i_arch_dayavg_pres_ngood(1100)
      REAL                :: f_arch_dayavg_pres_ngood(1100)
      REAL                :: f_arch_dayavg_pres_nbad(1100)
      REAL                :: f_arch_dayavg_pres_min_mb(1100)
      REAL                :: f_arch_dayavg_pres_max_mb(1100)
      REAL                :: f_arch_dayavg_pres_avg_mb(1100) 

      INTEGER             :: i_arch_dayavg_relh_ngood(1100)
      REAL                :: f_arch_dayavg_relh_ngood(1100)
      REAL                :: f_arch_dayavg_relh_nbad(1100)
      REAL                :: f_arch_dayavg_relh_min_pc(1100)
      REAL                :: f_arch_dayavg_relh_max_pc(1100)
      REAL                :: f_arch_dayavg_relh_avg_pc(1100) 

      INTEGER             :: i_arch_dayavg_wspd_ngood(1100)
      REAL                :: f_arch_dayavg_wspd_ngood(1100)
      REAL                :: f_arch_dayavg_wspd_nbad(1100)
      REAL                :: f_arch_dayavg_wspd_min_ms(1100)
      REAL                :: f_arch_dayavg_wspd_max_ms(1100)
      REAL                :: f_arch_dayavg_wspd_avg_ms(1100) 

      INTEGER             :: i_arch_daymax_airt_ngood(1100)
      REAL                :: f_arch_daymax_airt_ngood(1100)
      REAL                :: f_arch_daymax_airt_nbad(1100)
      REAL                :: f_arch_daymax_airt_min_c(1100)
      REAL                :: f_arch_daymax_airt_max_c(1100)
      REAL                :: f_arch_daymax_airt_avg_c(1100)

      INTEGER             :: i_arch_daymin_airt_ngood(1100)
      REAL                :: f_arch_daymin_airt_ngood(1100)
      REAL                :: f_arch_daymin_airt_nbad(1100)
      REAL                :: f_arch_daymin_airt_min_c(1100)
      REAL                :: f_arch_daymin_airt_max_c(1100)
      REAL                :: f_arch_daymin_airt_avg_c(1100)
 
      INTEGER             :: i_arch_daymin_minbod_ngood(1100)
      REAL                :: f_arch_daymin_minbod_ngood(1100)
      REAL                :: f_arch_daymin_minbod_nbad(1100)
      REAL                :: f_arch_daymin_minbod_min_c(1100)
      REAL                :: f_arch_daymin_minbod_max_c(1100)
      REAL                :: f_arch_daymin_minbod_avg_c(1100)
 
      INTEGER             :: i_arch_daymax_gust_ngood(1100)
      REAL                :: f_arch_daymax_gust_ngood(1100)
      REAL                :: f_arch_daymax_gust_nbad(1100)
      REAL                :: f_arch_daymax_gust_min_ms(1100)
      REAL                :: f_arch_daymax_gust_max_ms(1100)
      REAL                :: f_arch_daymax_gust_avg_ms(1100)
 
      INTEGER             :: i_arch_daytot_ppt_ngood(1100)
      REAL                :: f_arch_daytot_ppt_ngood(1100)
      REAL                :: f_arch_daytot_ppt_nbad(1100)
      REAL                :: f_arch_daytot_ppt_min_mm(1100)
      REAL                :: f_arch_daytot_ppt_max_mm(1100)
      REAL                :: f_arch_daytot_ppt_avg_mm(1100)
 
      INTEGER             :: i_arch_daytot_sundur_ngood(1100)
      REAL                :: f_arch_daytot_sundur_ngood(1100)
      REAL                :: f_arch_daytot_sundur_nbad(1100)
      REAL                :: f_arch_daytot_sundur_min_h(1100)
      REAL                :: f_arch_daytot_sundur_max_h(1100)
      REAL                :: f_arch_daytot_sundur_avg_h(1100)

      INTEGER             :: i_arch_daytot_snoacc_ngood(1100)
      REAL                :: f_arch_daytot_snoacc_ngood(1100)
      REAL                :: f_arch_daytot_snoacc_nbad(1100)
      REAL                :: f_arch_daytot_snoacc_min_cm(1100)
      REAL                :: f_arch_daytot_snoacc_max_cm(1100)
      REAL                :: f_arch_daytot_snoacc_avg_cm(1100)
c*****
      INTEGER             :: i_arch_dayavg_airtk_ngood(1100)
      REAL                :: f_arch_dayavg_airtk_ngood(1100)
      REAL                :: f_arch_dayavg_airtk_nbad(1100)
      REAL                :: f_arch_dayavg_airtk_min_k(1100)
      REAL                :: f_arch_dayavg_airtk_max_k(1100)
      REAL                :: f_arch_dayavg_airtk_avg_k(1100)

      INTEGER             :: i_arch_dayavg_slpres_ngood(1100)
      REAL                :: f_arch_dayavg_slpres_ngood(1100)
      REAL                :: f_arch_dayavg_slpres_nbad(1100)
      REAL                :: f_arch_dayavg_slpres_min_hpa(1100)
      REAL                :: f_arch_dayavg_slpres_max_hpa(1100)
      REAL                :: f_arch_dayavg_slpres_avg_hpa(1100) 
c*****
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

      INTEGER             :: l_hist_dd
      INTEGER             :: i_xhist_dd(20),i_yhist_dd(20)
      CHARACTER(LEN=20)   :: s_xhist_dd_label(20)

c     Declare month variables
      INTEGER             :: l_monrec_common
      CHARACTER(LEN=2)    :: s_monrec_common_month(5000)
      CHARACTER(LEN=4)    :: s_monrec_common_year(5000)
      REAL                :: f_monrec_common_nseconds(5000)
      CHARACTER(LEN=8)    :: s_monrec_common_stime(5000)
      CHARACTER(LEN=5)    :: s_monrec_common_timezone5(5000)

      REAL                :: f_monrec_airt_k(5000)
      INTEGER             :: i_monrec_airt_flag(5000)
      REAL                :: f_monrec_wspd_ms(5000)
      INTEGER             :: i_monrec_wspd_flag(5000)
      REAL                :: f_monrec_slpres_hpa(5000)
      INTEGER             :: i_monrec_slpres_flag(5000)
      REAL                :: f_monrec_ppt_mm(5000)
      INTEGER             :: i_monrec_ppt_flag(5000)

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

c     Archive stats from month series
      INTEGER             :: i_arch_lmonrec_common(1100)
      CHARACTER(LEN=2)    :: s_arch_mon_commonmon_st(1100)
      CHARACTER(LEN=2)    :: s_arch_mon_commonmon_en(1100)
      CHARACTER(LEN=4)    :: s_arch_mon_commonyear_st(1100)
      CHARACTER(LEN=4)    :: s_arch_mon_commonyear_en(1100)

      REAL                :: f_arch_mon_airt_ngood(1100)
      REAL                :: f_arch_mon_airt_nbad(1100)
      REAL                :: f_arch_mon_airt_min_k(1100)
      REAL                :: f_arch_mon_airt_max_k(1100)
      REAL                :: f_arch_mon_airt_avg_k(1100)

      REAL                :: f_arch_mon_wspd_ngood(1100)
      REAL                :: f_arch_mon_wspd_nbad(1100)
      REAL                :: f_arch_mon_wspd_min_ms(1100)
      REAL                :: f_arch_mon_wspd_max_ms(1100)
      REAL                :: f_arch_mon_wspd_avg_ms(1100)

      REAL                :: f_arch_mon_slpres_ngood(1100)
      REAL                :: f_arch_mon_slpres_nbad(1100)
      REAL                :: f_arch_mon_slpres_min_hpa(1100)
      REAL                :: f_arch_mon_slpres_max_hpa(1100)
      REAL                :: f_arch_mon_slpres_avg_hpa(1100)

      REAL                :: f_arch_mon_ppt_ngood(1100)
      REAL                :: f_arch_mon_ppt_nbad(1100)
      REAL                :: f_arch_mon_ppt_min_mm(1100)
      REAL                :: f_arch_mon_ppt_max_mm(1100)
      REAL                :: f_arch_mon_ppt_avg_mm(1100)

      CHARACTER(LEN=200)  :: s_directory_root
c************************************************************************
      print*,'start program'

      i_computer=1

      IF (i_computer.EQ.1) THEN
       print*,'fortran program configured for MSDOS'
      ENDIF
      IF (i_computer.EQ.2) THEN
       print*,'fortran program configured for Jasmin-unix'
      ENDIF
c      CALL SLEEP(2)
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
c     Directories for source datasets
c     MSDOS option
      IF (i_computer.EQ.1) THEN
900    s_directory='D:\DWD_datasets\1000082_DWD_Daily\1000082_DWD_Daily\'
     +  //'Daily_data_Kl_Historical\'
      ENDIF
c     Jasmin-unix option
      IF (i_computer.EQ.2) THEN
      s_directory='D:\DWD_datasets\1000082_DWD_Daily\1000082_DWD_Daily\'
     +  //'Daily_data_Kl_Historical\'
      ENDIF

c     2017/10/13: commented out after UNIX experience
c      s_filename_in='filelist.dat'
c      s_pathandname=TRIM(s_directory)//TRIM(s_filename_in)

c     Summary file output should be same DOS & UNIX
      s_directory_output  ='Data_middle/'   !changed 20171013 for UNIX consistency

c     Generate list of daily files 
c     2017/10/13: changed after UNIX experience 
      s_command=TRIM('dir /B D:\DWD_datasets\1000082_DWD_Daily\'//
     +  '1000082_DWD_Daily\Daily_data_Kl_Historical\ta*.zip > '//
     +  'zfilelist.dat' )
      CALL SYSTEM(s_command,io)
      s_pathandname='zfilelist.dat'
c      print*,'io=',io
c      CALL SLEEP(5)

c      s_command=
c     +   TRIM('dir /B '//s_directory//'tages*.* > filelist.dat')
cc       print *,'s_command=',s_command

cc     Unzip file into current directory
c      CALL EXECUTE_COMMAND_LINE(s_command,WAIT=.TRUE.,EXITSTAT=io)
c      print*,'io=',io
c************************************************************************
c     List of compressed files
      CALL get_list_compressed_files_dd(s_pathandname,
     +  l_zipfile,s_zipfiles,s_stnnum,s_stdate,s_endate)

      print*,'l_zipfile=',l_zipfile
c************************************************************************
c     Get information for the subdaily stations
      s_pathandname_subday=
     +  'KL_Standardformate_Beschreibung_Stationen.txt'
      CALL get_info_stns_subday(s_pathandname_subday,l_sd_stnrecord,
     +  s_sd_stke,s_sd_stid,s_sd_stdate,s_sd_endate,s_sd_hght,
     +  s_sd_lat,s_sd_lon,s_sd_stnname,s_sd_bundesland)

      print *,'l_sd_stnrecord=',l_sd_stnrecord

c     Get full WIGOS number

      CALL get_wigos_number(l_sd_stnrecord,s_sd_stke,
     +  s_sd_wigos_full)

c     See if all subday stid found in daily stnnume
      DO i=1,l_sd_stnrecord
       DO j=1,l_zipfile
        IF (s_sd_stid(i).EQ.s_stnnum(j)) THEN
c         print*,'i,match',i
c         CALL SLEEP(1)
         GOTO 63
        ENDIF 
       ENDDO

       print*,'problem,i=',i,s_sd_stid(i)
       CALL SLEEP(5)

63     CONTINUE
      ENDDO

c      CALL SLEEP(5)
c************************************************************************
c     Cycle through files

      i_cnt_stamp_reverse=0    !initialize counter

      l_zip_use=l_zipfile

      DO i=1,l_zip_use     !l_zipfile-320,l_zipfile-200

       s_linget=TRIM(ADJUSTL(s_zipfiles(i)))

       s_stnnum_use=TRIM(ADJUSTL(s_stnnum(i)))

c       s_pathandname_export='D:\Export\DWD_month\dwd_'//
c     +   s_stnnum_use//'_mon_data.dat'
c       s_pathandname_export_metadata='D:\Export\DWD_month\dwd_'//
c     +   s_stnnum_use//'_mon_metadata.dat'
c       s_pathandname_export_readme='D:\Export\DWD_month\dwd_'//
c     +   s_stnnum_use//'_mon_readme.dat'

c      Need s_directory in DOS; not in UNIX because full path specified
       s_command=
     +   TRIM('unzip -qq '//TRIM(s_directory)//TRIM(s_linget)//
     +   ' -d HHere')

c       print *,'s_command=',s_command
       print *,'i,s_linget =',i,TRIM(s_linget)

c      Unzip file into current directory
c      DOS command
       IF (i_computer.EQ.1) THEN
c        CALL EXECUTE_COMMAND_LINE(s_command,WAIT=.TRUE.,EXITSTAT=io)
        CALL SYSTEM(s_command,io)    !changed to UNIX convention 2017/10/13
       ENDIF
c      UNIX command
       IF (i_computer.EQ.2) THEN
        CALL SYSTEM(s_command,io)
       ENDIF 

c       print*,'io=',io
c       call sleep(5)
c*****
c      Get geographical information (should be same for DOS & UNIX)

c      20171013: complicate construction changed after UNIX experience
c       s_pathandname='HHere\'//
c     +  'Stationsmetadaten_klima_stationen_'//s_stnnum(i)//
c     +  '_'//s_stdate(i)//'_'//s_endate(i)//'.txt'
c       s_pathandname='HHere\'//
c     +  'Stationsmetadaten_klima_stationen_'//s_stnnum(i)//
c     +  '_'//s_stdate(i)//'_'//'*.txt'
c       s_pathandname='HHere\Metadaten_Geographie_'//s_stnnum(i)//'.txt'
c      print*,s_pathandname

c      Sequence to get actual name of the station metadata file
c      20171013: must use backslashes for DOS & forwardslashes for UNIX
       s_command=
     +  'dir /B HHere\Stationsmetadaten_klima_sta* > filestat.dat'
       CALL SYSTEM(s_command,io)
       OPEN (UNIT=1,FILE='filestat.dat',FORM='formatted',
     +   STATUS='OLD',ACTION='READ')
       READ(UNIT=1,FMT=1000,IOSTAT=io) s_linget
1000   FORMAT(a300)
       s_pathandname='HHere/'//TRIM(ADJUSTL(s_linget))
c       print*,'s_pathandname=',s_pathandname

       CALL get_geog_metadata_dd(s_pathandname,
     +   l_geog,
     +   s_geog_stnid,s_geog_hgt_m,s_geog_lat_deg,s_geog_lon_deg,
     +   s_geog_stdate,s_geog_endate,
     +   s_geog_stnname,i_geog_stnname_len)

c      print*,'l_geog=',l_geog
c      print*,s_geog_lat_deg(l_geog),s_geog_lon_deg(l_geog)

c     Archive geog information 
      s_last_hgt_m  =s_geog_hgt_m(l_geog)
      s_last_lat_deg=s_geog_lat_deg(l_geog)
      s_last_lon_deg=s_geog_lon_deg(l_geog)
      s_last_stnname=s_geog_stnname(l_geog)

c     Convert height to float
      s_test        =TRIM(s_last_hgt_m)
      READ(s_test,*) f_test
      f_last_hgt_m  =f_test

c     Convert longitude to float
      s_test        =TRIM(s_last_lon_deg)
      READ(s_test,*) f_test
      f_last_lon_deg=f_test

c      print*,'l_geog=',l_geog
c      print*,'s_geog_stdate',s_geog_stdate(l_geog)
c      print*,'s_geog_endate',s_geog_endate(l_geog)
c*****
c      20171009: old sequence changed following experience with UNIX 
cc     Get historical day data
c      s_pathandname='HHere\produkt_klima_Tageswerte_'//
c     +   s_stdate(i)//'_'//s_endate(i)//'_'//s_stnnum(i)//'.txt'

c      Sequence to get actual name of the station metadata file
c      20171013: must use backslashes for DOS & forwardslashes for UNIX
       s_command=
     +  'dir /B HHere\produkt_klima* > fileprod.dat'
       CALL SYSTEM(s_command,io)
       OPEN (UNIT=1,FILE='fileprod.dat',FORM='formatted',
     +   STATUS='OLD',ACTION='READ')
       READ(UNIT=1,FMT=1010,IOSTAT=io) s_linget
1010   FORMAT(a300)
       s_pathandname='HHere/'//TRIM(ADJUSTL(s_linget))
c       print*,'s_pathandname=',s_pathandname

       CALL get_day_data_historical1(s_pathandname,f_ndflag,
     +   l_prod,l_prod_fulluse,
     +   s_day_date,s_daytot_pptflg,
     +   f_dayavg_airt_c,f_dayavg_vapprs_mb,f_dayavg_ccov_okta,
     +   f_dayavg_pres_mb,f_dayavg_relh_pc,f_dayavg_wspd_ms,
     +   f_daymax_airt_c,f_daymin_airt_c,f_daymin_minbod_c,
     +   f_daymax_gust_ms,f_daytot_ppt_mm,f_daytot_sundur_h,
     +   f_daytot_snoacc_cm)

c      Conversions: airt_c to airt_k; pressure to sl pressure
       CALL convert_data_dwdday(f_ndflag,l_prod,f_dayavg_airt_c,
     +   f_dayavg_pres_mb,f_dayavg_vapprs_mb,f_last_hgt_m,
     +   f_daymax_airt_c,f_daymin_airt_c,

     +   f_dayavg_airt_k,f_dayavg_slpres_hpa,
     +   f_daymax_airt_k,f_daymin_airt_k)

c      Resolve time stamp of measurements
       CALL find_timestamp(l_prod,s_day_date,f_last_lon_deg, 
     +   s_dayavg_airt_stime,s_dayavg_airt_timezone,
     +   s_dayavg_pres_stime,s_dayavg_pres_timezone,
     +   s_dayavg_relh_stime,s_dayavg_relh_timezone,
     +   s_dayavg_wspd_stime,s_dayavg_wspd_timezone,
     +   s_daytot_ppt_stime,s_daytot_ppt_timezone,
     +   s_daytot_snoacc_stime,s_daytot_snoacc_timezone,

     +   s_dayavg_airtk_stime,s_dayavg_airtk_timezone,
     +   s_dayavg_slpres_stime,s_dayavg_slpres_timezone,

     +   s_daymax_airt_stime,s_daymax_airt_timezone,
     +   s_daymin_airt_stime,s_daymin_airt_timezone,

     +   s_dayavg_common_stime,s_dayavg_common_timezone,
     +   s_dayavg_common2_stime,s_dayavg_common2_timezone)
c*****
c      Count reversed year-stamps
c       print*,'l_prod...',l_prod,l_prod_fulluse
       IF (l_prod.NE.l_prod_fulluse) THEN
        i_cnt_stamp_reverse=i_cnt_stamp_reverse+1
        i_vec_stamp_reverse(i_cnt_stamp_reverse)=i
       ENDIF
c*****
c*****
c      MONTH CALCULATIONS
c      Identify complete months data in record
c      ICARUS chosen monthly variables
c      air temperature, precipitation, windspeed, sealevel pressure
       CALL identify_complete_months(l_prod,s_day_date)

       CALL common_month_variables(f_ndflag,i_ndflag,l_prod,
     +  s_day_date,
     +  f_dayavg_airt_k,f_daytot_ppt_mm,
     +  f_dayavg_wspd_ms,f_dayavg_slpres_hpa,
     +  s_dayavg_airtk_stime,s_dayavg_airtk_timezone,
     +  s_daytot_ppt_stime,s_daytot_ppt_timezone,
     +  s_dayavg_wspd_stime,s_dayavg_wspd_timezone,
     +  s_dayavg_slpres_stime,s_dayavg_slpres_timezone,

     +  l_monrec_common,s_monrec_common_month,s_monrec_common_year,
     +  f_monrec_common_nseconds,
     +  s_monrec_common_stime,s_monrec_common_timezone5,
     +  f_monrec_airt_k,i_monrec_airt_flag,
     +  f_monrec_wspd_ms,i_monrec_wspd_flag,
     +  f_monrec_slpres_hpa,i_monrec_slpres_flag,
     +  f_monrec_ppt_mm,i_monrec_ppt_flag)

c     +  l_monrec_airt,
c     +  s_monrec_airt_month,s_monrec_airt_year,
c     +  f_monrec_airt_k,i_monrec_airt_flag,
c     +  l_monrec_wspd,
c     +  s_monrec_wspd_month,s_monrec_wspd_year,
c     +  f_monrec_wspd_ms,i_monrec_wspd_flag,
c     +  l_monrec_slpres,
c     +  s_monrec_slpres_month,s_monrec_slpres_year,
c     +  f_monrec_slpres_hpa,i_monrec_slpres_flag,
c     +  l_monrec_ppt,
c     +  s_monrec_ppt_month,s_monrec_ppt_year,
c     +  f_monrec_ppt_mm,i_monrec_ppt_flag)
c*****
c*****
c     Find statistical quantities
      CALL calc_basic_stats_dd(f_ndflag,l_prod,
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

c      print*,'dayavg_air...',
c     +   f_dayavg_airt_ngood,f_dayavg_airt_nbad,
c     +   f_dayavg_airt_min_c,f_dayavg_airt_max_c,
c     +   f_dayavg_airt_avg_c

c      print*,'f_dayavg_airt_ngood=', f_dayavg_airt_ngood
c      print*,'f_dayavg_airtk_ngood=',f_dayavg_airtk_ngood
c      print*,'f_dayavg_pres_ngood=', f_dayavg_pres_ngood
c      print*,'f_dayavg_slpres_ngood=',f_dayavg_slpres_ngood
c      CALL SLEEP(10)

c     Find basic stats for month values
      CALL calc_basic_stats_mon(f_ndflag,l_monrec_common,
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
c*****
c*****
c     Archive stats
      i_arch_lprod(i)                =l_prod

      s_arch_geog_stnid(i)           =s_stnnum(i)
      s_arch_geog_hgt_m(i)           =s_last_hgt_m
      s_arch_geog_lat_deg(i)         =s_last_lat_deg
      s_arch_geog_lon_deg(i)         =s_last_lon_deg
      s_arch_geog_stdate(i)          =s_stdate(i)
      s_arch_geog_endate(i)          =s_endate(i)
      s_arch_dayrec_stdate(i)        =s_day_date(1)
      s_arch_dayrec_endate(i)        =s_day_date(l_prod)

      i_arch_dayavg_airt_ngood(i)    =INT(f_dayavg_airt_ngood)
      f_arch_dayavg_airt_ngood(i)    =f_dayavg_airt_ngood
      f_arch_dayavg_airt_nbad(i)     =f_dayavg_airt_nbad
      f_arch_dayavg_airt_min_c(i)    =f_dayavg_airt_min_c
      f_arch_dayavg_airt_max_c(i)    =f_dayavg_airt_max_c
      f_arch_dayavg_airt_avg_c(i)    =f_dayavg_airt_avg_c

      i_arch_dayavg_vapprs_ngood(i)  =INT(f_dayavg_vapprs_ngood)
      f_arch_dayavg_vapprs_ngood(i)  =f_dayavg_vapprs_ngood
      f_arch_dayavg_vapprs_nbad(i)   =f_dayavg_vapprs_nbad
      f_arch_dayavg_vapprs_min_mb(i) =f_dayavg_vapprs_min_mb
      f_arch_dayavg_vapprs_max_mb(i) =f_dayavg_vapprs_max_mb
      f_arch_dayavg_vapprs_avg_mb(i) =f_dayavg_vapprs_avg_mb

      i_arch_dayavg_ccov_ngood(i)    =INT(f_dayavg_ccov_ngood)
      f_arch_dayavg_ccov_ngood(i)    =f_dayavg_ccov_ngood
      f_arch_dayavg_ccov_nbad(i)     =f_dayavg_ccov_nbad
      f_arch_dayavg_ccov_min_okta(i) =f_dayavg_ccov_min_okta
      f_arch_dayavg_ccov_max_okta(i) =f_dayavg_ccov_max_okta
      f_arch_dayavg_ccov_avg_okta(i) =f_dayavg_ccov_avg_okta

      i_arch_dayavg_pres_ngood(i)    =INT(f_dayavg_pres_ngood)
      f_arch_dayavg_pres_ngood(i)    =f_dayavg_pres_ngood
      f_arch_dayavg_pres_nbad(i)     =f_dayavg_pres_nbad
      f_arch_dayavg_pres_min_mb(i)   =f_dayavg_pres_min_mb
      f_arch_dayavg_pres_max_mb(i)   =f_dayavg_pres_max_mb
      f_arch_dayavg_pres_avg_mb(i)   =f_dayavg_pres_avg_mb
c
      i_arch_dayavg_relh_ngood(i)    =INT(f_dayavg_relh_ngood)
      f_arch_dayavg_relh_ngood(i)    =f_dayavg_relh_ngood
      f_arch_dayavg_relh_nbad(i)     =f_dayavg_relh_nbad
      f_arch_dayavg_relh_min_pc(i)   =f_dayavg_relh_min_pc
      f_arch_dayavg_relh_max_pc(i)   =f_dayavg_relh_max_pc
      f_arch_dayavg_relh_avg_pc(i)   =f_dayavg_relh_avg_pc

      i_arch_dayavg_wspd_ngood(i)    =INT(f_dayavg_wspd_ngood)
      f_arch_dayavg_wspd_ngood(i)    =f_dayavg_wspd_ngood
      f_arch_dayavg_wspd_nbad(i)     =f_dayavg_wspd_nbad
      f_arch_dayavg_wspd_min_ms(i)   =f_dayavg_wspd_min_ms
      f_arch_dayavg_wspd_max_ms(i)   =f_dayavg_wspd_max_ms
      f_arch_dayavg_wspd_avg_ms(i)   =f_dayavg_wspd_avg_ms

      i_arch_daymax_airt_ngood(i)    =INT(f_daymax_airt_ngood)
      f_arch_daymax_airt_ngood(i)    =f_daymax_airt_ngood
      f_arch_daymax_airt_nbad(i)     =f_daymax_airt_nbad
      f_arch_daymax_airt_min_c(i)    =f_daymax_airt_min_c
      f_arch_daymax_airt_max_c(i)    =f_daymax_airt_max_c
      f_arch_daymax_airt_avg_c(i)    =f_daymax_airt_avg_c

      i_arch_daymin_airt_ngood(i)    =INT(f_daymin_airt_ngood)
      f_arch_daymin_airt_ngood(i)    =f_daymin_airt_ngood
      f_arch_daymin_airt_nbad(i)     =f_daymin_airt_nbad
      f_arch_daymin_airt_min_c(i)    =f_daymin_airt_min_c
      f_arch_daymin_airt_max_c(i)    =f_daymin_airt_max_c
      f_arch_daymin_airt_avg_c(i)    =f_daymin_airt_avg_c
c 
      i_arch_daymin_minbod_ngood(i)  =INT(f_daymin_minbod_ngood)
      f_arch_daymin_minbod_ngood(i)  =f_daymin_minbod_ngood
      f_arch_daymin_minbod_nbad(i)   =f_daymin_minbod_nbad
      f_arch_daymin_minbod_min_c(i)  =f_daymin_minbod_min_c
      f_arch_daymin_minbod_max_c(i)  =f_daymin_minbod_max_c
      f_arch_daymin_minbod_avg_c(i)  =f_daymin_minbod_avg_c
 
      i_arch_daymax_gust_ngood(i)    =INT(f_daymax_gust_ngood)
      f_arch_daymax_gust_ngood(i)    =f_daymax_gust_ngood
      f_arch_daymax_gust_nbad(i)     =f_daymax_gust_nbad
      f_arch_daymax_gust_min_ms(i)   =f_daymax_gust_min_ms
      f_arch_daymax_gust_max_ms(i)   =f_daymax_gust_max_ms
      f_arch_daymax_gust_avg_ms(i)   =f_daymax_gust_avg_ms
 
      i_arch_daytot_ppt_ngood(i)     =INT(f_daytot_ppt_ngood)
      f_arch_daytot_ppt_ngood(i)     =f_daytot_ppt_ngood
      f_arch_daytot_ppt_nbad(i)      =f_daytot_ppt_nbad
      f_arch_daytot_ppt_min_mm(i)    =f_daytot_ppt_min_mm
      f_arch_daytot_ppt_max_mm(i)    =f_daytot_ppt_max_mm
      f_arch_daytot_ppt_avg_mm(i)    =f_daytot_ppt_avg_mm
 
      i_arch_daytot_sundur_ngood(i)  =INT(f_daytot_sundur_ngood)
      f_arch_daytot_sundur_ngood(i)  =f_daytot_sundur_ngood
      f_arch_daytot_sundur_nbad(i)   =f_daytot_sundur_nbad
      f_arch_daytot_sundur_min_h(i)  =f_daytot_sundur_min_h
      f_arch_daytot_sundur_max_h(i)  =f_daytot_sundur_max_h
      f_arch_daytot_sundur_avg_h(i)  =f_daytot_sundur_avg_h
c
      i_arch_daytot_snoacc_ngood(i)  =INT(f_daytot_snoacc_ngood)
      f_arch_daytot_snoacc_ngood(i)  =f_daytot_snoacc_ngood
      f_arch_daytot_snoacc_nbad(i)   =f_daytot_snoacc_nbad
      f_arch_daytot_snoacc_min_cm(i) =f_daytot_snoacc_min_cm
      f_arch_daytot_snoacc_max_cm(i) =f_daytot_snoacc_max_cm
      f_arch_daytot_snoacc_avg_cm(i) =f_daytot_snoacc_avg_cm
c*****
      i_arch_dayavg_airtk_ngood(i)   =INT(f_dayavg_airtk_ngood)
      f_arch_dayavg_airtk_ngood(i)   =f_dayavg_airtk_ngood
      f_arch_dayavg_airtk_nbad(i)    =f_dayavg_airtk_nbad
      f_arch_dayavg_airtk_min_k(i)   =f_dayavg_airtk_min_k
      f_arch_dayavg_airtk_max_k(i)   =f_dayavg_airtk_max_k
      f_arch_dayavg_airtk_avg_k(i)   =f_dayavg_airtk_avg_k

      i_arch_dayavg_slpres_ngood(i)  =INT(f_dayavg_slpres_ngood)
      f_arch_dayavg_slpres_ngood(i)  =f_dayavg_slpres_ngood
      f_arch_dayavg_slpres_nbad(i)   =f_dayavg_slpres_nbad
      f_arch_dayavg_slpres_min_hpa(i)=f_dayavg_slpres_min_hpa
      f_arch_dayavg_slpres_max_hpa(i)=f_dayavg_slpres_max_hpa
      f_arch_dayavg_slpres_avg_hpa(i)=f_dayavg_slpres_avg_hpa
c*****
c*****
c     Archive monthly values
      i_arch_lmonrec_common(i)   =l_monrec_common
      s_arch_mon_commonmon_st(i) =s_monrec_common_month(1)
      s_arch_mon_commonmon_en(i) =s_monrec_common_month(l_monrec_common)
      s_arch_mon_commonyear_st(i)=s_monrec_common_year(1)
      s_arch_mon_commonyear_en(i)=s_monrec_common_year(l_monrec_common)

      f_arch_mon_airt_ngood(i)       =f_monavg_airt_ngood
      f_arch_mon_airt_nbad(i)        =f_monavg_airt_nbad
      f_arch_mon_airt_min_k(i)       =f_monavg_airt_min_k
      f_arch_mon_airt_max_k(i)       =f_monavg_airt_max_k
      f_arch_mon_airt_avg_k(i)       =f_monavg_airt_avg_k

      f_arch_mon_wspd_ngood(i)       =f_monavg_wspd_ngood
      f_arch_mon_wspd_nbad(i)        =f_monavg_wspd_nbad     
      f_arch_mon_wspd_min_ms(i)      =f_monavg_wspd_min_ms
      f_arch_mon_wspd_max_ms(i)      =f_monavg_wspd_max_ms
      f_arch_mon_wspd_avg_ms(i)      =f_monavg_wspd_avg_ms

      f_arch_mon_slpres_ngood(i)     =f_monavg_slpres_ngood
      f_arch_mon_slpres_nbad(i)      =f_monavg_slpres_nbad
      f_arch_mon_slpres_min_hpa(i)   =f_monavg_slpres_min_hpa
      f_arch_mon_slpres_max_hpa(i)   =f_monavg_slpres_max_hpa
      f_arch_mon_slpres_avg_hpa(i)   =f_monavg_slpres_avg_hpa

      f_arch_mon_ppt_ngood(i)        =f_monavg_ppt_ngood
      f_arch_mon_ppt_nbad(i)         =f_monavg_ppt_nbad
      f_arch_mon_ppt_min_mm(i)       =f_monavg_ppt_min_mm
      f_arch_mon_ppt_max_mm(i)       =f_monavg_ppt_max_mm
      f_arch_mon_ppt_avg_mm(i)       =f_monavg_ppt_avg_mm

c*****
c      Remove unzipped directory
       s_command='rm -R HHere'
c       print*,'s_command=',s_command
c       CALL EXECUTE_COMMAND_LINE(s_command,WAIT=.TRUE.,EXITSTAT=io) 
c      DOS command
       IF (i_computer.EQ.1) THEN
        CALL EXECUTE_COMMAND_LINE(s_command,WAIT=.TRUE.,EXITSTAT=io)
       ENDIF
c      UNIX command
       IF (i_computer.EQ.2) THEN
        CALL SYSTEM(s_command,io)
       ENDIF 
c*****
c      DAILY

c       GOTO 61

c      Export header production file if match with subdaily files
901    s_directory_root='D:\Export\DWD_daily_header\'    !'Production_day_header/'
       CALL export_header_production(f_ndflag,s_directory_root,
     +   s_stnnum(i),
     +   l_sd_stnrecord,s_sd_stke,s_sd_stid,s_sd_wigos_full,
     +   l_prod,
     +   s_day_date,
     +   s_last_hgt_m,s_last_lat_deg,s_last_lon_deg,s_last_stnname,
     +   s_dayavg_common_stime,s_dayavg_common_timezone,
     +   f_daytot_ppt_mm,f_dayavg_airt_k,f_daytot_snoacc_cm,
     +   f_dayavg_slpres_hpa,f_dayavg_wspd_ms,f_dayavg_relh_pc)

c      Export observation production file if match with subdaily files
902    s_directory_root='D:\Export\DWD_daily_observation\'  !'Production_day_observation/'
       CALL export_observation_production(s_directory_root,
     +   f_ndflag,s_stnnum(i),
     +   l_sd_stnrecord,s_sd_stke,s_sd_stid,s_sd_wigos_full,
     +   l_prod,
     +   s_day_date,
     +   f_daytot_ppt_mm,f_dayavg_airt_k,f_daytot_snoacc_cm,
     +   f_dayavg_slpres_hpa,f_dayavg_wspd_ms,f_dayavg_relh_pc,
     +   f_dayavg_airt_c,f_dayavg_pres_mb,
     +   s_last_hgt_m,s_last_lat_deg,s_last_lon_deg,s_last_stnname,
     +   s_dayavg_common_stime,s_dayavg_common_timezone)

61    CONTINUE
c*****
c      NOT_USED
c      Export header production file if match with subdaily files - 2 time stamps
c       s_directory_root='Production_day_header8/'
c       CALL export_header_production8(s_directory_root,
c     +   s_stnnum(i),
c     +   l_sd_stnrecord,s_sd_stke,s_sd_stid,s_sd_wigos_full,
c     +   l_prod,
c     +   s_day_date,
c     +   s_last_hgt_m,s_last_lat_deg,s_last_lon_deg,s_last_stnname,
c     +   s_dayavg_common_stime,s_dayavg_common_timezone,
c     +   s_dayavg_common2_stime,s_dayavg_common2_timezone)

c      Export observation production file if match with subdaily files - 8 variables
c       s_directory_root='Production_day_observation8/'
c       CALL export_observation_production8(s_directory_root,
c     +   f_ndflag,s_stnnum(i),
c     +   l_sd_stnrecord,s_sd_stke,s_sd_stid,s_sd_wigos_full,
c     +   l_prod,
c     +   s_day_date,
c     +   f_daytot_ppt_mm,f_dayavg_airt_k,f_daytot_snoacc_cm,
c     +   f_dayavg_slpres_hpa,f_dayavg_wspd_ms,f_dayavg_relh_pc,
c     +   f_dayavg_airt_c,f_dayavg_pres_mb,
c     +   f_daymax_airt_k,f_daymin_airt_k,
c     +   f_daymax_airt_c,f_daymin_airt_c,
c     +   s_last_hgt_m,s_last_lat_deg,s_last_lon_deg,s_last_stnname,
c     +   s_dayavg_common_stime,s_dayavg_common_timezone,
c     +   s_dayavg_common2_stime,s_dayavg_common2_timezone)
c*****
c*****
c      MONTHLY

c      Export month header file - with Friday corrections
903    s_directory_root='D:\Export\DWD_monthly_header\'
c       s_directory_root='Production_month_header/'
       CALL export_header_monthly(s_directory_root,
     +   s_stnnum(i),
     +   l_sd_stnrecord,s_sd_stke,s_sd_stid,s_sd_wigos_full,
     +   l_monrec_common,
     +   s_monrec_common_month,s_monrec_common_year,
     +   f_monrec_common_nseconds,
     +   s_monrec_common_stime,s_monrec_common_timezone5,
     +   s_last_hgt_m,s_last_lat_deg,s_last_lon_deg,s_last_stnname)
c*****
c      Export month observation file
904    s_directory_root='D:\Export\DWD_monthly_observation\'   !'Production_month_observation/'
       CALL export_observation_monthly(s_directory_root,
     +   f_ndflag,s_stnnum(i),
     +   l_sd_stnrecord,s_sd_stke,s_sd_stid,s_sd_wigos_full,
     +   l_monrec_common,
     +   s_monrec_common_month,s_monrec_common_year,
     +   f_monrec_common_nseconds,
     +   s_monrec_common_stime,s_monrec_common_timezone5,
     +   s_last_hgt_m,s_last_lat_deg,s_last_lon_deg,s_last_stnname,
     +   f_monrec_airt_k,f_monrec_wspd_ms,
     +   f_monrec_slpres_hpa,f_monrec_ppt_mm)

c     +   f_arch_mon_airt_avg_k,f_arch_mon_wspd_avg_ms,
c     +   f_arch_mon_slpres_avg_hpa,f_arch_mon_ppt_avg_mm)

c*****
      ENDDO      !close i

      print*,'just out of i-loop'
c************************************************************************
      print*,'number reverse yearstamp=',i_cnt_stamp_reverse
      print*,'id rev',(i_vec_stamp_reverse(i),i=1,i_cnt_stamp_reverse)
c************************************************************************
c     Export station metadata DWD monthly datasets
      s_filename1='export_table_sn3a_stnmetadata_month.dat'
      CALL export_tab_sn3a_stndata(s_directory_output,s_filename1,
     +  s_date,
     +  l_sd_stnrecord,s_sd_stke,s_sd_stid,
     +  l_zip_use,s_stnnum,
     +  s_arch_mon_commonyear_st,s_arch_mon_commonmon_st, 
     +  s_arch_mon_commonyear_en,s_arch_mon_commonmon_en, 
     +  s_arch_geog_hgt_m,s_arch_geog_lat_deg,s_arch_geog_lon_deg,
     +  i_arch_lmonrec_common,
     +  f_arch_mon_airt_ngood,f_arch_mon_wspd_ngood, 
     +  f_arch_mon_slpres_ngood,f_arch_mon_ppt_ngood)

c     Export station metadata DWD daily datasets
      s_filename1='export_table_sn2a_stnmetadata_day.dat'
      CALL export_tab_sn2a_stndata(s_directory_output,s_filename1,
     +  s_date,
     +  l_sd_stnrecord,s_sd_stke,s_sd_stid,
     +  l_zip_use,s_stnnum,
     +  i_arch_lprod,s_arch_dayrec_stdate,s_arch_dayrec_endate,
     +  s_arch_geog_hgt_m,s_arch_geog_lat_deg,s_arch_geog_lon_deg,
     +  i_arch_dayavg_relh_ngood,i_arch_daytot_ppt_ngood, 
     +  i_arch_daytot_snoacc_ngood,i_arch_dayavg_slpres_ngood,
     +  i_arch_dayavg_airtk_ngood,i_arch_dayavg_wspd_ngood,
     +  i_arch_dayavg_pres_ngood,i_arch_dayavg_airt_ngood)

c     Count number of stns where any records present for variable
      CALL count_stn_data_present(l_zipfile,
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

c      print*,'cleared count_stn_data_present'
c************************************************************************
c     Output archive of monthly stats

      CALL export_mon_datafile(s_directory_output,s_date,
     +  l_zip_use,
     +  s_arch_geog_stnid,
     +  s_arch_geog_hgt_m,s_arch_geog_lat_deg,s_arch_geog_lon_deg,
     +  i_arch_lmonrec_common,
     +  s_arch_mon_commonmon_st,s_arch_mon_commonmon_en,
     +  s_arch_mon_commonyear_st,s_arch_mon_commonyear_en,
     +  f_arch_mon_airt_ngood,f_arch_mon_airt_nbad,
     +  f_arch_mon_airt_min_k,f_arch_mon_airt_max_k,
     +  f_arch_mon_airt_avg_k,
     +  f_arch_mon_wspd_ngood,f_arch_mon_wspd_nbad,     
     +  f_arch_mon_wspd_min_ms,f_arch_mon_wspd_max_ms,
     +  f_arch_mon_wspd_avg_ms,
     +  f_arch_mon_slpres_ngood,f_arch_mon_slpres_nbad,
     +  f_arch_mon_slpres_min_hpa,f_arch_mon_slpres_max_hpa,
     +  f_arch_mon_slpres_avg_hpa,
     +  f_arch_mon_ppt_ngood,f_arch_mon_ppt_nbad, 
     +  f_arch_mon_ppt_min_mm,f_arch_mon_ppt_max_mm,
     +  f_arch_mon_ppt_avg_mm)

c************************************************************************
c     Histogram of l_prod

      CALL make_hist_lprod_dd(l_zip_use,i_arch_lprod,
     +  l_hist_dd,i_xhist_dd,i_yhist_dd,s_xhist_dd_label)
c************************************************************************
c     Output histogram results
      CALL export_hist_recordlength_dd(s_date,
     +  s_directory_output,
     +  l_hist_dd,i_xhist_dd,i_yhist_dd,s_xhist_dd_label)

c     Export summary file with info sorted by number of lines
      CALL export_summary_listsort_dd(s_directory_output,s_date,
     +  l_zip_use,s_stnnum,
     +  s_arch_dayrec_stdate,s_arch_dayrec_endate,
     +  s_arch_geog_hgt_m,s_arch_geog_lat_deg,s_arch_geog_lon_deg,
     +  i_arch_lprod)
c************************************************************************
c     1.  Sift/sort/export single column data
      s_filename1='statsort_day_dayavg_airt.txt'
      CALL sift_sort_export(s_directory_output,s_filename1,
     +   s_date,
     +   l_zipfile,i_arch_dayavg_airt_ngood,
     +   f_arch_dayavg_airt_avg_c,
     +   f_arch_dayavg_airt_min_c,f_arch_dayavg_airt_max_c)

c     2.  Sift/sort/export single column data
      s_filename1='statsort_day_dayavg_vapprs.txt'
      CALL sift_sort_export(s_directory_output,s_filename1,
     +   s_date,
     +   l_zipfile,i_arch_dayavg_vapprs_ngood,
     +   f_arch_dayavg_vapprs_avg_mb,
     +   f_arch_dayavg_vapprs_min_mb,f_arch_dayavg_vapprs_max_mb)

c     3.  Sift/sort/export single column data
      s_filename1='statsort_day_dayavg_ccov.txt'
      CALL sift_sort_export(s_directory_output,s_filename1,
     +   s_date,
     +   l_zipfile,i_arch_dayavg_ccov_ngood,
     +   f_arch_dayavg_ccov_avg_okta,
     +   f_arch_dayavg_ccov_min_okta,f_arch_dayavg_ccov_max_okta)

c     4.  Sift/sort/export single column data
      s_filename1='statsort_day_dayavg_pres.txt'
      CALL sift_sort_export(s_directory_output,s_filename1,
     +   s_date,
     +   l_zipfile,i_arch_dayavg_pres_ngood,
     +   f_arch_dayavg_pres_avg_mb,
     +   f_arch_dayavg_pres_min_mb,f_arch_dayavg_pres_max_mb)

c     5.  Sift/sort/export single column data
      s_filename1='statsort_day_dayavg_relh.txt'
      CALL sift_sort_export(s_directory_output,s_filename1,
     +   s_date,
     +   l_zipfile,i_arch_dayavg_relh_ngood,
     +   f_arch_dayavg_relh_avg_pc,
     +   f_arch_dayavg_relh_min_pc,f_arch_dayavg_relh_max_pc)

c     6.  Sift/sort/export single column data
      s_filename1='statsort_day_dayavg_wspd.txt'
      CALL sift_sort_export(s_directory_output,s_filename1,
     +   s_date,
     +   l_zipfile,i_arch_dayavg_wspd_ngood,
     +   f_arch_dayavg_wspd_avg_ms,
     +   f_arch_dayavg_wspd_min_ms,f_arch_dayavg_wspd_max_ms)

c     7.  Sift/sort/export single column data
      s_filename1='statsort_day_daymax_airt.txt'
      CALL sift_sort_export(s_directory_output,s_filename1,
     +   s_date,
     +   l_zipfile,i_arch_daymax_airt_ngood,
     +   f_arch_daymax_airt_avg_c,
     +   f_arch_daymax_airt_min_c,f_arch_daymax_airt_max_c)

c     8.  Sift/sort/export single column data
      s_filename1='statsort_day_daymin_airt.txt'
      CALL sift_sort_export(s_directory_output,s_filename1,
     +   s_date,
     +   l_zipfile,i_arch_daymin_airt_ngood,
     +   f_arch_daymin_airt_avg_c,
     +   f_arch_daymin_airt_min_c,f_arch_daymin_airt_max_c)

c     9.  Sift/sort/export single column data
      s_filename1='statsort_day_daymin_minbod.txt'
      CALL sift_sort_export(s_directory_output,s_filename1,
     +   s_date,
     +   l_zipfile,i_arch_daymin_minbod_ngood,
     +   f_arch_daymin_minbod_avg_c,
     +   f_arch_daymin_minbod_min_c,f_arch_daymin_minbod_max_c)

c     10. Sift/sort/export single column data
      s_filename1='statsort_day_daymax_gust.txt'
      CALL sift_sort_export(s_directory_output,s_filename1,
     +   s_date,
     +   l_zipfile,i_arch_daymax_gust_ngood,
     +   f_arch_daymax_gust_avg_ms,
     +   f_arch_daymax_gust_min_ms,f_arch_daymax_gust_max_ms)

c     11. Sift/sort/export single column data
      s_filename1='statsort_day_daytot_ppt.txt'
      CALL sift_sort_export(s_directory_output,s_filename1,
     +   s_date,
     +   l_zipfile,i_arch_daytot_ppt_ngood,
     +   f_arch_daytot_ppt_avg_mm,
     +   f_arch_daytot_ppt_min_mm,f_arch_daytot_ppt_max_mm)

c     12. Sift/sort/export single column data
      s_filename1='statsort_day_daytot_sundur.txt'
      CALL sift_sort_export(s_directory_output,s_filename1,
     +   s_date,
     +   l_zipfile,i_arch_daytot_sundur_ngood,
     +   f_arch_daytot_sundur_avg_h,
     +   f_arch_daytot_sundur_min_h,f_arch_daytot_sundur_max_h)

c     13. Sift/sort/export single column data
      s_filename1='statsort_day_daytot_snoacc.txt'
      CALL sift_sort_export(s_directory_output,s_filename1,
     +   s_date,
     +   l_zipfile,i_arch_daytot_snoacc_ngood,
     +   f_arch_daytot_snoacc_avg_cm,
     +   f_arch_daytot_snoacc_min_cm,f_arch_daytot_snoacc_max_cm)

c************************************************************************
c     Output table of counts where variable present
      CALL export_cnts_stn(s_directory_output,s_date,l_zipfile,
     +  i_cnt_dayavg_airt,i_cnt_dayavg_vapprs,i_cnt_dayavg_ccov,
     +  i_cnt_dayavg_pres,i_cnt_dayavg_relh,i_cnt_dayavg_wspd,
     +  i_cnt_daymax_airt,i_cnt_daymin_airt,i_cnt_daymin_minbod,
     +  i_cnt_daymax_gust,i_cnt_daytot_ppt,i_cnt_daytot_sundur,
     +  i_cnt_daytot_snoacc)
c*****
c     Output file of stats
      CALL export_datafile1(s_directory_output,s_date,l_zipfile,
     +  s_arch_geog_stnid,
     +  s_arch_geog_hgt_m,s_arch_geog_lat_deg,s_arch_geog_lon_deg,
     +  s_arch_geog_stdate,s_arch_geog_endate,i_arch_lprod,
     +  i_arch_dayavg_airt_ngood,f_arch_dayavg_airt_min_c,
     +  f_arch_dayavg_airt_max_c,f_arch_dayavg_airt_avg_c,
     +  i_arch_dayavg_vapprs_ngood,f_arch_dayavg_vapprs_min_mb,
     +  f_arch_dayavg_vapprs_max_mb,f_arch_dayavg_vapprs_avg_mb,
     +  i_arch_dayavg_ccov_ngood,f_arch_dayavg_ccov_min_okta,
     +  f_arch_dayavg_ccov_max_okta,f_arch_dayavg_ccov_avg_okta,
     +  i_arch_dayavg_pres_ngood,f_arch_dayavg_pres_min_mb,
     +  f_arch_dayavg_pres_max_mb,f_arch_dayavg_pres_avg_mb)
c*****
c     Output variables relh/wspd/airtmax/airtmin
      CALL export_datafile2(s_directory_output,s_date,l_zipfile,
     +  s_arch_geog_stnid,
     +  s_arch_geog_hgt_m,s_arch_geog_lat_deg,s_arch_geog_lon_deg,
     +  s_arch_geog_stdate,s_arch_geog_endate,i_arch_lprod,
     +  i_arch_dayavg_relh_ngood,f_arch_dayavg_relh_min_pc,
     +  f_arch_dayavg_relh_max_pc,f_arch_dayavg_relh_avg_pc,
     +  i_arch_dayavg_wspd_ngood,f_arch_dayavg_wspd_min_ms,
     +  f_arch_dayavg_wspd_max_ms,f_arch_dayavg_wspd_avg_ms,
     +  i_arch_daymax_airt_ngood,f_arch_daymax_airt_min_c,
     +  f_arch_daymax_airt_max_c,f_arch_daymax_airt_avg_c,
     +  i_arch_daymin_airt_ngood,f_arch_daymin_airt_min_c,
     +  f_arch_daymin_airt_max_c,f_arch_daymin_airt_avg_c)
c*****
c     Output variables minbod/gust/ppt/sundur
      CALL export_datafile3(s_directory_output,s_date,l_zipfile,
     +  s_arch_geog_stnid,
     +  s_arch_geog_hgt_m,s_arch_geog_lat_deg,s_arch_geog_lon_deg,
     +  s_arch_geog_stdate,s_arch_geog_endate,i_arch_lprod,
     +  i_arch_daymin_minbod_ngood,f_arch_daymin_minbod_min_c,
     +  f_arch_daymin_minbod_max_c,f_arch_daymin_minbod_avg_c,
     +  i_arch_daymax_gust_ngood,f_arch_daymax_gust_min_ms,
     +  f_arch_daymax_gust_max_ms,f_arch_daymax_gust_avg_ms,
     +  i_arch_daytot_ppt_ngood,f_arch_daytot_ppt_min_mm,
     +  f_arch_daytot_ppt_max_mm,f_arch_daytot_ppt_avg_mm,
     +  i_arch_daytot_sundur_ngood,f_arch_daytot_sundur_min_h,
     +  f_arch_daytot_sundur_max_h,f_arch_daytot_sundur_avg_h)
c*****
c     Output variables snoacc
      CALL export_datafile4(s_directory_output,s_date,l_zipfile,
     +  s_arch_geog_stnid,
     +  s_arch_geog_hgt_m,s_arch_geog_lat_deg,s_arch_geog_lon_deg,
     +  s_arch_geog_stdate,s_arch_geog_endate,i_arch_lprod,
     +  i_arch_daytot_snoacc_ngood,f_arch_daytot_snoacc_min_cm,
     +  f_arch_daytot_snoacc_max_cm,f_arch_daytot_snoacc_avg_cm)

c************************************************************************
c************************************************************************
c     Find end time
      CALL CPU_TIME(f_time_en)

      f_deltime_s=f_time_en-f_time_st
      print*,'f_deltime_s,f_deltime_min=',f_deltime_s,f_deltime_s/60.0     
c************************************************************************
      END
c*********************************
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



