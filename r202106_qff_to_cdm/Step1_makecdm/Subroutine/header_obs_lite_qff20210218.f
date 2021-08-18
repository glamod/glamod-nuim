c      Subroutine to make make CDM tables.
c      AJ_Kettle, 11Dec2019
c      09Dec2019: modified title of cdm files
c      11Jun2020: changed report type denotation
c      11Jun2020: used source_id & record number from data lines
c      12Jun2020: slave character width denotation for s_vec* from data file 
c      21Oct2020: added extra column with source id to cdm-lite
c      20Nov2020: added tables for qc & line counts

       SUBROUTINE header_obs_lite_qff20210218(
     +   s_date_st,s_time_st,s_zone_st,

     +   s_directory_output_header,s_directory_output_observation, 
     +   s_directory_output_lite,s_directory_output_receipt,
     +   s_directory_output_qc,s_directory_output_receipt_linecount,
     +   s_stnname_isolated,
     +   l_rgh,l_lines,
     +   s_vec_station_id,s_vec_station_name,
     +   s_vec_year,s_vec_month,s_vec_day,
     +     s_vec_hour,s_vec_minute,
     +     s_vec_latitude,s_vec_longitude,s_vec_elevation,
     +   s_vec_airt_c,s_vec_dewp_c,s_vec_stnp_hpa,s_vec_slpr_hpa,
     +     s_vec_wdir_deg,s_vec_wspd_ms,
     +   s_vec_airt_origprec_empir_c,s_vec_dewp_origprec_empir_c,
     +     s_vec_stnp_origprec_empir_hpa,s_vec_slpr_origprec_empir_hpa,
     +     s_vec_wdir_origprec_empir_deg,s_vec_wspd_origprec_empir_ms,
     +   f_vec_airt_c,f_vec_dewp_c,f_vec_stnp_hpa,f_vec_slpr_hpa,
     +     f_vec_wdir_deg,f_vec_wspd_ms,
     +   s_vec_airt_k,s_vec_dewp_k,s_vec_stnp_pa,s_vec_slpr_pa,
     +   s_vec_airt_convprec_empir_k,s_vec_dewp_convprec_empir_k,
     +     s_vec_stnp_convprec_empir_pa,s_vec_slpr_convprec_empir_pa,
     +   f_vec_airt_k,f_vec_dewp_k,f_vec_stnp_pa,f_vec_slpr_pa,
     +   s_vec_airt_source_id,s_vec_dewp_source_id,s_vec_stnp_source_id,
     +   s_vec_slpr_source_id,s_vec_wdir_source_id,s_vec_wspd_source_id,
     +   s_vec_airt_recordnum,s_vec_dewp_recordnum,s_vec_stnp_recordnum,
     +   s_vec_slpr_recordnum,s_vec_wdir_recordnum,s_vec_wspd_recordnum,
     +   s_vec_airt_cdmqc,s_vec_dewp_cdmqc,s_vec_stnp_cdmqc,
     +   s_vec_slpr_cdmqc,s_vec_wdir_cdmqc,s_vec_wspd_cdmqc,
     +    s_vec_airt_cdmqcmethod,s_vec_dewp_cdmqcmethod,
     +    s_vec_stnp_cdmqcmethod,s_vec_slpr_cdmqcmethod,
     +    s_vec_wdir_cdmqcmethod,s_vec_wspd_cdmqcmethod,
     +   l_varselect,s_code_observation,s_code_unit,
     +     s_code_value_significance,s_code_unit_original,
     +     s_code_conversion_method,s_code_conversion_flag,
     +     s_predef_hgt_obs_above_sfc,
     +   ilen,l_cc_rgh,l_collect_cnt,
     +     s_collect_primary_id,s_collect_record_number,
     +     s_collect_secondary_id,s_collect_station_name,
     +     s_collect_longitude,s_collect_latitude,
     +     s_collect_height_station_above_sea_level,
     +     s_collect_data_policy_licence,s_collect_source_id,
     +     s_collect_region,s_collect_operating_territory,
     +     s_collect_station_type,s_collect_platform_type,
     +     s_collect_platform_sub_type,
     +     s_collect_primary_station_id_scheme,
     +     s_collect_location_accuracy,s_collect_location_method,
     +     s_collect_location_quality,s_collect_station_crs,
     +     s_collect_height_station_above_local_ground,
     +     s_collect_height_station_above_sea_level_acc,
     +     s_collect_sea_level_datum,
     +   l_scoutput_numfield,s_scoutput_vec_header,s_collect_datalines)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into subroutine

      CHARACTER(LEN=8)    :: s_date_st
      CHARACTER(LEN=10)   :: s_time_st
      CHARACTER(LEN=5)    :: s_zone_st

      CHARACTER(LEN=300)  :: s_directory_output_header
      CHARACTER(LEN=300)  :: s_directory_output_observation
      CHARACTER(LEN=300)  :: s_directory_output_lite
      CHARACTER(LEN=300)  :: s_directory_output_receipt
      CHARACTER(LEN=300)  :: s_directory_output_qc
      CHARACTER(LEN=300)  :: s_directory_output_receipt_linecount

      CHARACTER(LEN=300)  :: s_stnname_isolated

      INTEGER             :: l_rgh
      INTEGER             :: l_lines

      CHARACTER(LEN=*)    :: s_vec_station_id(l_rgh)          !16
      CHARACTER(LEN=*)    :: s_vec_station_name(l_rgh)        !64
      CHARACTER(LEN=*)    :: s_vec_year(l_rgh)                !4
      CHARACTER(LEN=*)    :: s_vec_month(l_rgh)               !2
      CHARACTER(LEN=*)    :: s_vec_day(l_rgh)                 !2
      CHARACTER(LEN=*)    :: s_vec_hour(l_rgh)                !2
      CHARACTER(LEN=*)    :: s_vec_minute(l_rgh)              !2
      CHARACTER(LEN=*)    :: s_vec_latitude(l_rgh)            !32 16
      CHARACTER(LEN=*)    :: s_vec_longitude(l_rgh)           !32 16
      CHARACTER(LEN=*)    :: s_vec_elevation(l_rgh)           !32 16
c*****
c     Original variables string and float
      CHARACTER(LEN=*)    :: s_vec_airt_c(l_rgh)              !32
      CHARACTER(LEN=*)    :: s_vec_dewp_c(l_rgh)              !32
      CHARACTER(LEN=*)    :: s_vec_stnp_hpa(l_rgh)            !32
      CHARACTER(LEN=*)    :: s_vec_slpr_hpa(l_rgh)            !32
      CHARACTER(LEN=*)    :: s_vec_wdir_deg(l_rgh)            !32
      CHARACTER(LEN=*)    :: s_vec_wspd_ms(l_rgh)             !32

      REAL                :: f_vec_airt_c(l_rgh)
      REAL                :: f_vec_dewp_c(l_rgh)
      REAL                :: f_vec_stnp_hpa(l_rgh)
      REAL                :: f_vec_slpr_hpa(l_rgh)
      REAL                :: f_vec_wdir_deg(l_rgh)
      REAL                :: f_vec_wspd_ms(l_rgh)
c*****
c     Emipirical precision of original variables
      CHARACTER(LEN=*)    :: s_vec_airt_origprec_empir_c(l_rgh)   !32
      CHARACTER(LEN=*)    :: s_vec_dewp_origprec_empir_c(l_rgh)   !32
      CHARACTER(LEN=*)    :: s_vec_stnp_origprec_empir_hpa(l_rgh) !32
      CHARACTER(LEN=*)    :: s_vec_slpr_origprec_empir_hpa(l_rgh) !32
      CHARACTER(LEN=*)    :: s_vec_wdir_origprec_empir_deg(l_rgh) !32
      CHARACTER(LEN=*)    :: s_vec_wspd_origprec_empir_ms(l_rgh)  !32 
c*****
c     Converted variables string and float
      CHARACTER(LEN=*)    :: s_vec_airt_k(l_rgh)              !32
      CHARACTER(LEN=*)    :: s_vec_dewp_k(l_rgh)              !32
      CHARACTER(LEN=*)    :: s_vec_stnp_pa(l_rgh)             !32
      CHARACTER(LEN=*)    :: s_vec_slpr_pa(l_rgh)             !32

      REAL                :: f_vec_airt_k(l_rgh)
      REAL                :: f_vec_dewp_k(l_rgh)
      REAL                :: f_vec_stnp_pa(l_rgh)
      REAL                :: f_vec_slpr_pa(l_rgh)
c*****
c     Converted precision
      CHARACTER(LEN=*)    :: s_vec_airt_convprec_empir_k(l_rgh)  !32 
      CHARACTER(LEN=*)    :: s_vec_dewp_convprec_empir_k(l_rgh)  !32
      CHARACTER(LEN=*)    :: s_vec_stnp_convprec_empir_pa(l_rgh) !32
      CHARACTER(LEN=*)    :: s_vec_slpr_convprec_empir_pa(l_rgh) !32
c*****
c     Source_id colume
      CHARACTER(LEN=*)    :: s_vec_airt_source_id(l_rgh)         !4
      CHARACTER(LEN=*)    :: s_vec_dewp_source_id(l_rgh)         !4
      CHARACTER(LEN=*)    :: s_vec_stnp_source_id(l_rgh)         !4
      CHARACTER(LEN=*)    :: s_vec_slpr_source_id(l_rgh)         !4
      CHARACTER(LEN=*)    :: s_vec_wdir_source_id(l_rgh)         !4
      CHARACTER(LEN=*)    :: s_vec_wspd_source_id(l_rgh)         !4
c*****
c     Record number from stnconfig file matching
      CHARACTER(LEN=*)    :: s_vec_airt_recordnum(l_rgh)         !2
      CHARACTER(LEN=*)    :: s_vec_dewp_recordnum(l_rgh)         !2
      CHARACTER(LEN=*)    :: s_vec_stnp_recordnum(l_rgh)         !2
      CHARACTER(LEN=*)    :: s_vec_slpr_recordnum(l_rgh)         !2
      CHARACTER(LEN=*)    :: s_vec_wdir_recordnum(l_rgh)         !2
      CHARACTER(LEN=*)    :: s_vec_wspd_recordnum(l_rgh)         !2
c*****
c     CDM qc flag
      CHARACTER(LEN=*)    :: s_vec_airt_cdmqc(l_rgh)             !1
      CHARACTER(LEN=*)    :: s_vec_dewp_cdmqc(l_rgh)             !1
      CHARACTER(LEN=*)    :: s_vec_stnp_cdmqc(l_rgh)             !1
      CHARACTER(LEN=*)    :: s_vec_slpr_cdmqc(l_rgh)             !1
      CHARACTER(LEN=*)    :: s_vec_wdir_cdmqc(l_rgh)             !1
      CHARACTER(LEN=*)    :: s_vec_wspd_cdmqc(l_rgh)             !1

      CHARACTER(LEN=*)    :: s_vec_airt_cdmqcmethod(l_rgh)       !2
      CHARACTER(LEN=*)    :: s_vec_dewp_cdmqcmethod(l_rgh)       !2
      CHARACTER(LEN=*)    :: s_vec_stnp_cdmqcmethod(l_rgh)       !2
      CHARACTER(LEN=*)    :: s_vec_slpr_cdmqcmethod(l_rgh)       !2
      CHARACTER(LEN=*)    :: s_vec_wdir_cdmqcmethod(l_rgh)       !2
      CHARACTER(LEN=*)    :: s_vec_wspd_cdmqcmethod(l_rgh)       !2
c*****
c     Codes
      INTEGER             :: l_varselect
      CHARACTER(LEN=3)    :: s_code_observation(l_varselect)
      CHARACTER(LEN=3)    :: s_code_unit(l_varselect)
      CHARACTER(LEN=3)    :: s_code_value_significance(l_varselect)
      CHARACTER(LEN=3)    :: s_code_unit_original(l_varselect)
      CHARACTER(LEN=3)    :: s_code_conversion_method(l_varselect)
      CHARACTER(LEN=3)    :: s_code_conversion_flag(l_varselect)
      CHARACTER(LEN=10)   :: s_predef_numerical_precision(l_varselect)
      CHARACTER(LEN=10)   :: s_predef_hgt_obs_above_sfc(l_varselect)
c*****
c     short lists of stnconfig info
      INTEGER             :: ilen
      INTEGER             :: l_cc_rgh
      INTEGER             :: l_collect_cnt

      CHARACTER(LEN=ilen) :: s_collect_primary_id(l_cc_rgh)
      CHARACTER(LEN=ilen) :: s_collect_record_number(l_cc_rgh)
      CHARACTER(LEN=ilen) :: s_collect_secondary_id(l_cc_rgh)
      CHARACTER(LEN=ilen) :: s_collect_station_name(l_cc_rgh)
      CHARACTER(LEN=ilen) :: s_collect_longitude(l_cc_rgh)
      CHARACTER(LEN=ilen) :: s_collect_latitude(l_cc_rgh)
      CHARACTER(LEN=ilen) :: 
     +     s_collect_height_station_above_sea_level(l_cc_rgh)
      CHARACTER(LEN=ilen) :: s_collect_data_policy_licence(l_cc_rgh)
      CHARACTER(LEN=ilen) :: s_collect_source_id(l_cc_rgh)

c     Variables originally from stnconfig-write
      CHARACTER(LEN=ilen) :: s_collect_region(l_cc_rgh)
      CHARACTER(LEN=ilen) :: s_collect_operating_territory(l_cc_rgh)
      CHARACTER(LEN=ilen) :: s_collect_station_type(l_cc_rgh)
      CHARACTER(LEN=ilen) :: s_collect_platform_type(l_cc_rgh)
      CHARACTER(LEN=ilen) :: s_collect_platform_sub_type(l_cc_rgh)
      CHARACTER(LEN=ilen)::s_collect_primary_station_id_scheme(l_cc_rgh)
      CHARACTER(LEN=ilen) :: s_collect_location_accuracy(l_cc_rgh)
      CHARACTER(LEN=ilen) :: s_collect_location_method(l_cc_rgh)
      CHARACTER(LEN=ilen) :: s_collect_location_quality(l_cc_rgh)
      CHARACTER(LEN=ilen) :: s_collect_station_crs(l_cc_rgh)
      CHARACTER(LEN=ilen) ::
     +    s_collect_height_station_above_local_ground(l_cc_rgh)
      CHARACTER(LEN=ilen) ::
     +    s_collect_height_station_above_sea_level_acc(l_cc_rgh)
      CHARACTER(LEN=ilen) :: s_collect_sea_level_datum(l_cc_rgh)

      INTEGER             :: l_scoutput_numfield
      CHARACTER(LEN=ilen) :: s_scoutput_vec_header(50) 
      CHARACTER(LEN=ilen) :: s_collect_datalines(l_cc_rgh,50)
c*****
c     Variables used in subroutine

      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: i1
      INTEGER             :: io

      INTEGER             :: i_flag

      CHARACTER(LEN=300)  :: s_pathandname
c*****
c     preliminary variables
      CHARACTER(LEN=12)   :: s_primary_id
      CHARACTER(LEN=4)    :: s_record_year
      CHARACTER(LEN=2)    :: s_record_month
      CHARACTER(LEN=2)    :: s_record_day
      CHARACTER(LEN=2)    :: s_record_hour
      CHARACTER(LEN=2)    :: s_record_minute
      CHARACTER(LEN=2)    :: s_record_second
      CHARACTER(LEN=3)    :: s_record_zone
c*****
      INTEGER             :: l_channel
c*****
c     header info
      INTEGER             :: l_col_header
      CHARACTER(LEN=50)   :: s_header_titlevec(100)       !changed from 22 to 100
      CHARACTER(LEN=1000) :: s_header_title_assemble_pre
      CHARACTER(LEN=1000) :: s_header_title_assemble
      INTEGER             :: i_len_header_title           !info to size header string
      CHARACTER(LEN=4)    :: s_len_header_title

c     Observation info
      INTEGER             :: l_col_obs
      CHARACTER(LEN=50)   :: s_obs_titlevec(100)
      CHARACTER(LEN=1000) :: s_obs_title_assemble_pre
      CHARACTER(LEN=1000) :: s_obs_title_assemble
      INTEGER             :: i_len_obs_title
      CHARACTER(LEN=4)    :: s_len_obs_title

c     Lite info
      INTEGER             :: l_col_lite
      CHARACTER(LEN=50)   :: s_lite_titlevec(100)
      CHARACTER(LEN=1000) :: s_lite_title_assemble_pre
      CHARACTER(LEN=1000) :: s_lite_title_assemble
      INTEGER             :: i_len_lite_title
      CHARACTER(LEN=4)    :: s_len_lite_title

c     QC info
      INTEGER             :: l_col_qcmethod
      CHARACTER(LEN=50)   :: s_qcmethod_titlevec(100)
      CHARACTER(LEN=1000) :: s_qcmethod_title_assemble_pre
      CHARACTER(LEN=1000) :: s_qcmethod_title_assemble
      INTEGER             :: i_len_qcmethod_title
      CHARACTER(LEN=4)    :: s_len_qcmethod_title
c*****
      CHARACTER(LEN=300)  :: s_pathandname_header
      CHARACTER(LEN=300)  :: s_pathandname_obs
      CHARACTER(LEN=300)  :: s_pathandname_lite
      CHARACTER(LEN=300)  :: s_pathandname_receipt
      CHARACTER(LEN=300)  :: s_pathandname_qc

      CHARACTER(LEN=300)  :: s_filename_header
      CHARACTER(LEN=300)  :: s_filename_observation
      CHARACTER(LEN=300)  :: s_filename_lite
      CHARACTER(LEN=300)  :: s_filename_receipt
      CHARACTER(LEN=300)  :: s_filename_qc
c*****
      CHARACTER(LEN=10)   :: s_fmt,s_fmt1
      CHARACTER(LEN=10)   :: s_fmt_header_title 
      CHARACTER(LEN=10)   :: s_fmt_obs_title
      CHARACTER(LEN=10)   :: s_fmt_lite_title
      CHARACTER(LEN=10)   :: s_fmt_qcmethod_title
c*****
c     Information for receipt file (Note up to 100 report numbers)
      CHARACTER(LEN=50)   :: s_obs_date_time_st
      CHARACTER(LEN=50)   :: s_obs_date_time_en
      CHARACTER(LEN=50)   :: s_record_date_time_st_byreport(l_cc_rgh)
      CHARACTER(LEN=50)   :: s_record_date_time_en_byreport(l_cc_rgh)
      INTEGER             :: i_record_hist_channel(l_cc_rgh,l_varselect)
      INTEGER             :: i_record_hist_integrate(l_cc_rgh)

      INTEGER             :: i_vec_cnt_channelexported(l_varselect)
c*****
c     Counters for lines in obs,header,lite files
      INTEGER             :: n_lines_obs
      INTEGER             :: n_lines_header
      INTEGER             :: n_lines_lite
      INTEGER             :: n_lines_qcmethod
c*****
      CHARACTER(LEN=10)   :: s_date_reconstruct_yyyy_mm_dd
      CHARACTER(LEN=8)    :: s_time_reconstruct_hh_mm_ss
      CHARACTER(LEN=3)    :: s_time_offset

      CHARACTER(LEN=4)    :: s_corr_year
      CHARACTER(LEN=2)    :: s_corr_month
      CHARACTER(LEN=2)    :: s_corr_day
      CHARACTER(LEN=2)    :: s_corr_hour
      CHARACTER(LEN=2)    :: s_corr_minute

      CHARACTER(LEN=4)    :: s_year
      CHARACTER(LEN=2)    :: s_month
      CHARACTER(LEN=2)    :: s_day
      CHARACTER(LEN=2)    :: s_hour
      CHARACTER(LEN=2)    :: s_minute
c*****
      CHARACTER(LEN=2)    :: s_avec_recordnumber(l_varselect)
      CHARACTER(LEN=3)    :: s_avec_sourceid(l_varselect)
      CHARACTER(LEN=32)   :: s_avec_submitdata(l_varselect) !10
      CHARACTER(LEN=32)   :: s_avec_origdata(l_varselect)   !10
      CHARACTER(LEN=32)   :: s_avec_precision(l_varselect)  !10
      CHARACTER(LEN=32)   :: s_avec_origprec(l_varselect)   !10
      CHARACTER(LEN=1)    :: s_avec_qc(l_varselect)
      CHARACTER(LEN=2)    :: s_avec_qcmethod(l_varselect)

      INTEGER             :: l_distinct_recnum
      CHARACTER(LEN=2)    :: s_dvec_recordnumber(l_varselect)
c*****
      INTEGER             :: i_count_elements
c*****
c     Single record number element for data
      CHARACTER(LEN=50)   :: s_single_primary_id
      CHARACTER(LEN=50)   :: s_single_record_number
      CHARACTER(LEN=50)   :: s_single_secondary_id
      CHARACTER(LEN=50)   :: s_single_station_name
      CHARACTER(LEN=50)   :: s_single_longitude
      CHARACTER(LEN=50)   :: s_single_latitude
      CHARACTER(LEN=50)   :: s_single_height_station_above_sea_level
      CHARACTER(LEN=50)   :: s_single_data_policy_licence
      CHARACTER(LEN=50)   :: s_single_source_id
      CHARACTER(LEN=50)   :: s_single_region
      CHARACTER(LEN=50)   :: s_single_operating_territory
      CHARACTER(LEN=50)   :: s_single_station_type
      CHARACTER(LEN=50)   :: s_single_platform_type
      CHARACTER(LEN=50)   :: s_single_platform_sub_type
      CHARACTER(LEN=50)   :: s_single_primary_station_id_scheme
      CHARACTER(LEN=50)   :: s_single_location_accuracy
      CHARACTER(LEN=50)   :: s_single_location_method
      CHARACTER(LEN=50)   :: s_single_location_quality
      CHARACTER(LEN=50)   :: s_single_station_crs
      CHARACTER(LEN=50)   :: s_single_height_station_above_local_ground
      CHARACTER(LEN=50)   :: s_single_height_station_above_sea_level_acc
      CHARACTER(LEN=50)   :: s_single_sea_level_datum
c*****
c     Archive variables by record number & variable channel number
      CHARACTER(LEN=10)::s_arch_date_st_yyyy_mm_dd(l_cc_rgh,l_varselect)
      CHARACTER(LEN=10)::s_arch_date_en_yyyy_mm_dd(l_cc_rgh,l_varselect)
      INTEGER             :: i_arch_cnt(l_cc_rgh,l_varselect)

      DOUBLE PRECISION    :: d_obs_jtime

      DOUBLE PRECISION    :: d_arch2_jtime_min(l_cc_rgh,l_varselect)
      DOUBLE PRECISION    :: d_arch2_jtime_max(l_cc_rgh,l_varselect)
      CHARACTER(10)::s_arch2_date_st_yyyy_mm_dd(l_cc_rgh,l_varselect)
      CHARACTER(10)::s_arch2_date_en_yyyy_mm_dd(l_cc_rgh,l_varselect)
c*****
c     Individual data fields for observation
      CHARACTER(LEN=50)   :: s_obs_observation_id                  !1
      CHARACTER(LEN=50)   :: s_obs_report_id                       !2
      CHARACTER(LEN=50)   :: s_obs_data_policy_licence             !3
      CHARACTER(LEN=50)   :: s_obs_date_time                       !4
      CHARACTER(LEN=50)   :: s_obs_date_time_meaning               !5
      CHARACTER(LEN=50)   :: s_obs_observation_duration            !6
      CHARACTER(LEN=50)   :: s_obs_longitude                       !7
      CHARACTER(LEN=50)   :: s_obs_latitude                        !8
      CHARACTER(LEN=50)   :: s_obs_crs                             !9
      CHARACTER(LEN=50)   :: s_obs_z_coordinate                    !10
      CHARACTER(LEN=50)   :: s_obs_z_coordinate_type               !11
      CHARACTER(LEN=50):: s_obs_observation_height_above_station_surface !12 
      CHARACTER(LEN=50)   :: s_obs_observed_variable               !13
      CHARACTER(LEN=50)   :: s_obs_secondary_variable              !14
      CHARACTER(LEN=50)   :: s_obs_observation_value               !15
      CHARACTER(LEN=50)   :: s_obs_value_significance              !16
      CHARACTER(LEN=50)   :: s_obs_secondary_value                 !17
      CHARACTER(LEN=50)   :: s_obs_units                           !18
      CHARACTER(LEN=50)   :: s_obs_code_table                      !19
      CHARACTER(LEN=50)   :: s_obs_conversion_flag                 !20
      CHARACTER(LEN=50)   :: s_obs_location_method                 !21
      CHARACTER(LEN=50)   :: s_obs_location_precision              !22
      CHARACTER(LEN=50)   :: s_obs_coordinate_method               !23
      CHARACTER(LEN=50)   :: s_obs_bbox_min_longitude              !24
      CHARACTER(LEN=50)   :: s_obs_bbox_max_longitude              !25
      CHARACTER(LEN=50)   :: s_obs_bbox_min_latitude               !26
      CHARACTER(LEN=50)   :: s_obs_bbox_max_latitude               !27
      CHARACTER(LEN=50)   :: s_obs_spatial_representativeness      !28
      CHARACTER(LEN=50)   :: s_obs_quality_flag                    !29
      CHARACTER(LEN=50)   :: s_obs_numerical_precision             !30
      CHARACTER(LEN=50)   :: s_obs_sensor_id                       !31
      CHARACTER(LEN=50)   :: s_obs_sensor_automation_status        !32
      CHARACTER(LEN=50)   :: s_obs_exposure_of_sensor              !33
      CHARACTER(LEN=50)   :: s_obs_original_precision              !34
      CHARACTER(LEN=50)   :: s_obs_original_units                  !35
      CHARACTER(LEN=50)   :: s_obs_original_code_table             !36
      CHARACTER(LEN=50)   :: s_obs_original_value                  !37
      CHARACTER(LEN=50)   :: s_obs_conversion_method               !38
      CHARACTER(LEN=50)   :: s_obs_processing_code                 !39
      CHARACTER(LEN=50)   :: s_obs_processing_level                !40
      CHARACTER(LEN=50)   :: s_obs_adjustment_id                   !41
      CHARACTER(LEN=50)   :: s_obs_traceability                    !42
      CHARACTER(LEN=50)   :: s_obs_advanced_qc                     !43
      CHARACTER(LEN=50)   :: s_obs_advanced_uncertainty            !44
      CHARACTER(LEN=50)   :: s_obs_advanced_homogenisation         !45
      CHARACTER(LEN=50)   :: s_obs_advanced_assimilation_feedback  !46
      CHARACTER(LEN=50)   :: s_obs_source_id                       !47 !46
c*****
c     Individual data fields for qc
      CHARACTER(LEN=50)   :: s_qcmethod_observation_id             !1
      CHARACTER(LEN=50)   :: s_qcmethod_report_id                  !2
      CHARACTER(LEN=50)   :: s_qcmethod_qc_method                  !3
      CHARACTER(LEN=50)   :: s_qcmethod_quality_flag               !4
c*****
c     Variables assembling header & observation data lines
      CHARACTER(LEN=1000) :: s_header_linedata_assemble_pre
      CHARACTER(LEN=1000) :: s_header_linedata_assemble 
      CHARACTER(LEN=50)   :: s_header_linedata_vec(100)      !changed to 100 from 22
      CHARACTER(LEN=1000) :: s_obs_linedata_assemble_pre
      CHARACTER(LEN=1000) :: s_obs_linedata_assemble 
      CHARACTER(LEN=50)   :: s_obs_linedata_vec(100)         !changed to 100 from 22
      CHARACTER(LEN=1000) :: s_lite_linedata_assemble_pre
      CHARACTER(LEN=1000) :: s_lite_linedata_assemble 
      CHARACTER(LEN=50)   :: s_lite_linedata_vec(100)         !changed to 100 from 22
      CHARACTER(LEN=1000) :: s_qcmethod_linedata_assemble_pre
      CHARACTER(LEN=1000) :: s_qcmethod_linedata_assemble 
      CHARACTER(LEN=50)   :: s_qcmethod_linedata_vec(100)

      INTEGER             :: i_linedata_len
      CHARACTER(LEN=4)    :: s_linedata_len 
c*****
c     Individual fields for lite
      CHARACTER(LEN=50)   :: s_lite_observation_id                 !1  s_obs_obseration_id
      CHARACTER(LEN=50)   :: s_lite_report_type                    !2  s_header_report_id
      CHARACTER(LEN=50)   :: s_lite_date_time                      !3  s_obs_date_time
      CHARACTER(LEN=50)   :: s_lite_date_time_meaning              !4  s_obs_date_time_meaning
      CHARACTER(LEN=50)   :: s_lite_latitude                       !5  s_obs_latitude
      CHARACTER(LEN=50)   :: s_lite_longitude                      !6  s_obs_longitude 
      CHARACTER(LEN=50)::s_lite_observation_height_above_station_surface !7  s_obs_observation_height_above_station_surface
      CHARACTER(LEN=50)   :: s_lite_observed_variable              !8  s_obs_observed_variable
      CHARACTER(LEN=50)   :: s_lite_units                          !9  s_obs_units
      CHARACTER(LEN=50)   :: s_lite_observation_value              !10 s_obs_observation_value
      CHARACTER(LEN=50)   :: s_lite_value_significance             !11 s_obs_value_significance 
      CHARACTER(LEN=50)   :: s_lite_observation_duration           !12 s_obs_observation_duration
      CHARACTER(LEN=50)   :: s_lite_platform_type                  !13 s_header_platform_type 
      CHARACTER(LEN=50)   :: s_lite_station_type                   !14 s_header_station_type
      CHARACTER(LEN=50)   :: s_lite_primary_station_id             !15 s_header_primary_station_id
      CHARACTER(LEN=50)   :: s_lite_station_name                   !16 s_header_station_name
      CHARACTER(LEN=50)   :: s_lite_quality_flag                   !17 s_obs_quality_flag
      CHARACTER(LEN=50)   :: s_lite_data_policy_licence            !18 s_obs_data_policy_licence
      CHARACTER(LEN=50)   :: s_lite_source_id                      !19 s_obs_source_id
c*****
c     Individual data fields for header                        
      CHARACTER(LEN=50)   :: s_header_report_id                    !1  !1
      CHARACTER(LEN=50)   :: s_header_region                       !2
      CHARACTER(LEN=50)   :: s_header_sub_region                   !3
      CHARACTER(LEN=50)   :: s_header_application_area             !4  !2
      CHARACTER(LEN=50)   :: s_header_observing_programme          !5  !3
      CHARACTER(LEN=50)   :: s_header_report_type                  !6  !4
      CHARACTER(LEN=50)   :: s_header_station_name                 !7
      CHARACTER(LEN=50)   :: s_header_station_type                 !8
      CHARACTER(LEN=50)   :: s_header_platform_type                !9
      CHARACTER(LEN=50)   :: s_header_platform_sub_type            !10
      CHARACTER(LEN=50)   :: s_header_primary_station_id           !11 !5
      CHARACTER(LEN=50)   :: s_header_station_record_number        !12 !6
      CHARACTER(LEN=50)   :: s_header_primary_station_id_scheme    !13
      CHARACTER(LEN=50)   :: s_header_longitude                    !14
      CHARACTER(LEN=50)   :: s_header_latitude                     !15
      CHARACTER(LEN=50)   :: s_header_location_accuracy            !16
      CHARACTER(LEN=50)   :: s_header_location_method              !17
      CHARACTER(LEN=50)   :: s_header_location_quality             !18
      CHARACTER(LEN=50)   :: s_header_crs                          !19
      CHARACTER(LEN=50)   :: s_header_station_speed                !20
      CHARACTER(LEN=50)   :: s_header_station_course               !21
      CHARACTER(LEN=50)   :: s_header_station_heading              !22
      CHARACTER(LEN=50)   :: 
     +  s_header_height_of_station_above_local_ground              !23
      CHARACTER(LEN=50)   :: s_header_height_of_station_above_sea_level  !24
      CHARACTER(LEN=50)   :: 
     +  s_header_height_of_station_above_sea_level_accuracy        !25
      CHARACTER(LEN=50)   :: s_header_sea_level_datum              !26
      CHARACTER(LEN=50)   :: s_header_report_meaning_of_timestamp  !27 !7
      CHARACTER(LEN=50)   :: s_header_report_timestamp             !28 !8
      CHARACTER(LEN=50)   :: s_header_report_duration              !29 !9
      CHARACTER(LEN=50)   :: s_header_report_time_accuracy         !30 !10
      CHARACTER(LEN=50)   :: s_header_report_time_quality          !31 !11
      CHARACTER(LEN=50)   :: s_header_report_time_reference        !32 !12
      CHARACTER(LEN=50)   :: s_header_profile_id                   !33 !13
      CHARACTER(LEN=50)   :: s_header_events_at_station            !34 !14
      CHARACTER(LEN=50)   :: s_header_report_quality               !35 !15
      CHARACTER(LEN=50)   :: s_header_duplicate_status             !36 !16
      CHARACTER(LEN=50)   :: s_header_duplicates                   !37 !17
      CHARACTER(LEN=50)   :: s_header_record_timestamp             !38 !18
      CHARACTER(LEN=50)   :: s_header_history                      !39 !19
      CHARACTER(LEN=50)   :: s_header_processing_level             !40 !20
      CHARACTER(LEN=50)   :: s_header_processing_codes             !41 !21
      CHARACTER(LEN=50)   :: s_header_source_id                    !42 !22
      CHARACTER(LEN=50)   :: s_header_source_record_id             !43
c*****
      CHARACTER(LEN=300)  :: s_command

c************************************************************************
c      print*,'just entered header_obs_lite_qff20200609'

c      print*,'s_directory_output_qc=',TRIM(s_directory_output_qc)
c      print*,'s_directory_output_receipt_linecount=',
c     +  TRIM(s_directory_output_receipt_linecount)

c      print*,'l_rgh,l_lines=',l_rgh,l_lines

c      print*,'s_stnname_isolated=',TRIM(s_stnname_isolated)

c      print*,'s_vec_station_id=',
c     +  ('='//TRIM(s_vec_station_id(i))//'=',i=1,10)
c      print*,'s_vec_station_name=',
c     +  ('='//TRIM(s_vec_station_name(i))//'=',i=1,10)

c      print*,'s_vec_wdir_deg=',
c     +  ('|'//TRIM(s_vec_wdir_deg(k)),k=1,10)
c      print*,'s_vec_wdir_origprec_empir_deg=',
c     +  ('|'//TRIM(s_vec_wdir_origprec_empir_deg(k)),k=1,10)

c      print*,'s_vec_wspd_ms=',
c     +  ('|'//TRIM(s_vec_wspd_ms(k)),k=1,10)
c      print*,'s_vec_wspd_origprec_empir_ms=',
c     +  ('|'//TRIM(s_vec_wspd_origprec_empir_ms(k)),k=1,10)

c      STOP 'header_obs_lite_qff20201120'

      i_flag=0     !initialize problem flag to good
c************************************************************************
c************************************************************************
c     Preprocessing

      s_primary_id=TRIM(s_stnname_isolated)  !11 digit code 

      s_record_year    =s_date_st(1:4)
      s_record_month   =s_date_st(5:6)
      s_record_day     =s_date_st(7:8)

      s_record_hour    =s_time_st(1:2)
      s_record_minute  =s_time_st(3:4)
      s_record_second  =s_time_st(5:6)

      s_record_zone    =s_zone_st(1:3)

c      print*,'s_primary_id=',TRIM(s_primary_id)
c      print*,'s_record_year=',s_record_year
c      print*,'s_record_month=',s_record_month
c      print*,'s_record_day=',s_record_day
c      print*,'s_record_hour=',s_record_hour
c      print*,'s_record_minute=',s_record_minute
c      print*,'s_record_second=',s_record_second
c      print*,'s_record_zone=',s_record_zone

c      print*,'finished preprocessing'
c************************************************************************
c      Verify codes

c      NOTE: variable order: airt,dewp,stnp,slpr,wdir,wspd

       l_channel=l_varselect

c       print*,'s_code_observation',(s_code_observation(i),i=1,l_channel)
c       print*,'s_code_unit',       (s_code_unit(i),i=1,l_channel)
c       print*,'s_code_value_significance',
c     +  (s_code_value_significance(i),i=1,l_channel)
c       print*,'s_code_unit_original',
c     +  (s_code_unit_original(i),i=1,l_channel)
c       print*,'s_code_conversion_method',
c     +  (s_code_unit_original(i),i=1,l_channel)
c************************************************************************
c************************************************************************
      l_col_header=43     !changed to 43 from 22
      s_header_titlevec(1) ='report_id'
      s_header_titlevec(2) ='region'
      s_header_titlevec(3) ='sub_region'
      s_header_titlevec(4) ='application_area'     !changed to 4 from 2
      s_header_titlevec(5) ='observing_programme'  !changed to 5 from 3
      s_header_titlevec(6) ='report_type'          !changed to 6 from 4
      s_header_titlevec(7) ='station_name'
      s_header_titlevec(8) ='station_type'
      s_header_titlevec(9) ='platform_type'
      s_header_titlevec(10)='platform_subtype'
      s_header_titlevec(11)='primary_station_id'            !changed to 11 from 5
      s_header_titlevec(12) ='station_record_number'        !changed to 12 from 6
      s_header_titlevec(13) ='primary_station_id_scheme'
      s_header_titlevec(14) ='longitude'
      s_header_titlevec(15) ='latitude'
      s_header_titlevec(16) ='location_accuracy'
      s_header_titlevec(17) ='location_method'
      s_header_titlevec(18) ='location_quality'
      s_header_titlevec(19) ='crs'
      s_header_titlevec(20) ='station_speed'
      s_header_titlevec(21) ='station_course'
      s_header_titlevec(22) ='station_heading'
      s_header_titlevec(23) ='height_of_station_above_local_ground'
      s_header_titlevec(24) ='height_of_station_above_sea_level'
      s_header_titlevec(25) =
     +  'height_of_station_above_sea_level_accuracy'
      s_header_titlevec(26) ='sea_level_datum'
      s_header_titlevec(27) ='report_meaning_of_timestamp'  !changed to 27 from 7
      s_header_titlevec(28) ='report_timestamp'             !changed to 28 from 8
      s_header_titlevec(29) ='report_duration'              !changed to 29 from 9
      s_header_titlevec(30) ='report_time_accuracy'         !changed to 30 from 10
      s_header_titlevec(31) ='report_time_quality'          !changed to 31 from 11
      s_header_titlevec(32) ='report_time_reference'        !changed to 32 from 12
      s_header_titlevec(33) ='profile_id'                   !changed to 33 from 13
      s_header_titlevec(34) ='events_at_station'
      s_header_titlevec(35) ='report_quality'
      s_header_titlevec(36) ='duplicate_status'
      s_header_titlevec(37) ='duplicates'
      s_header_titlevec(38) ='record_timestamp'
      s_header_titlevec(39) ='history'
      s_header_titlevec(40) ='processing_level'
      s_header_titlevec(41) ='processing_codes'
      s_header_titlevec(42) ='source_id'
      s_header_titlevec(43) ='source_record_id'

      s_header_title_assemble_pre=''
      DO i=1,l_col_header
       s_header_title_assemble_pre=TRIM(s_header_title_assemble_pre)//
     +   TRIM(s_header_titlevec(i))//'|'
      ENDDO 

      i_len_header_title=LEN_TRIM(s_header_title_assemble_pre)
      WRITE(s_len_header_title,'(i4)') i_len_header_title

c     Take assembled header without last pipe
      s_header_title_assemble=
     +  s_header_title_assemble_pre(1:i_len_header_title-1)

c      print*,'s_header_title_assemble='//
c     +  TRIM(s_header_title_assemble)//'='
c      print*,'i_len_header_title=',i_len_header_title

      IF (i_len_header_title.GE.1000) THEN 
       print*,'i_len_header_title=',i_len_header_title
       STOP 'write_header_obs_table; i_len_title>limit'
      ENDIF
c*****
c     OBSERVATION

c     19Jun2019: changed from 46 to 47 because of error in template
c     28Sep2019: correction from 47 to 46 columns from new template 21Aug2019
      l_col_obs=47 !46 !22 !changed to 46 from 22

      s_obs_titlevec(1) ='observation_id'
      s_obs_titlevec(2) ='report_id'
      s_obs_titlevec(3) ='data_policy_licence'
      s_obs_titlevec(4) ='date_time'
      s_obs_titlevec(5) ='date_time_meaning'
      s_obs_titlevec(6) ='observation_duration'
      s_obs_titlevec(7) ='longitude'
      s_obs_titlevec(8) ='latitude'
      s_obs_titlevec(9) ='crs'                            !new parameter
      s_obs_titlevec(10)='z_coordinate'                   !new parameter
      s_obs_titlevec(11)='z_coordinate_type'              !new parameter
      s_obs_titlevec(12) ='observation_height_above_station_surface'  !changed to 12 from 9
      s_obs_titlevec(13)='observed_variable'              !changed to 13 from 10
      s_obs_titlevec(14)='secondary variable'             !new parameter
      s_obs_titlevec(15)='observation_value'              !changed to 15 from 11
      s_obs_titlevec(16)='value_significance'             !changed to 16 from 12
      s_obs_titlevec(17)='secondary_value'                !changed to 17 from 13
      s_obs_titlevec(18)='units'                          !changed to 18 from 14
      s_obs_titlevec(19)='code_table'                     !new parameter
      s_obs_titlevec(20)='conversion_flag'                !changed to 20 from 15
      s_obs_titlevec(21)='location_method'                !new parameter
      s_obs_titlevec(22)='location_precision'             !new parameter
      s_obs_titlevec(23)='z_coordinate_method'            !new parameter
      s_obs_titlevec(24)='bbox_min_longitude'             !new parameter
      s_obs_titlevec(25)='bbox_max_longitude'             !new parameter
      s_obs_titlevec(26)='bbox_min_latitude'              !new parameter
      s_obs_titlevec(27)='bbox_max_latitude'              !new parameter
      s_obs_titlevec(28)='spatial_representativeness'     !new parameter
      s_obs_titlevec(29)='quality_flag'                   !changed to 29 from 16
      s_obs_titlevec(30)='numerical_precision'            !changed to 30 from 17
      s_obs_titlevec(31)='sensor_id'                      !new parameter
      s_obs_titlevec(32)='sensor_automation_status'       !new parameter
      s_obs_titlevec(33)='exposure_of_sensor'             !new parameter
      s_obs_titlevec(34)='original_precision'             !changed to 35 from 18
      s_obs_titlevec(35)='original_units'                 !changed to 36 from 19
      s_obs_titlevec(36)='original_code_table'            !new parameter
      s_obs_titlevec(37)='original_value'                 !changed to 38 from 20
      s_obs_titlevec(38)='conversion_method'              !changes to 39 from 21
      s_obs_titlevec(39)='processing_code'                !new parameter
      s_obs_titlevec(40)='processing_level'               !new parameter
      s_obs_titlevec(41)='adjustment_id'                  !new parameter
      s_obs_titlevec(42)='traceability'                   !new parameter
      s_obs_titlevec(43)='advanced_qc'                    !new parameter
      s_obs_titlevec(44)='advanced_uncertainty'           !new parameter
      s_obs_titlevec(45)='advanced_homogenisation'        !new parameter
      s_obs_titlevec(46)='advanced_assimilation_feedback' !new parameter
      s_obs_titlevec(47)='source_id'                      !changed to 47 from 46

      s_obs_title_assemble_pre=''
      DO i=1,l_col_obs
       s_obs_title_assemble_pre=TRIM(s_obs_title_assemble_pre)//
     +   TRIM(s_obs_titlevec(i))//'|'
      ENDDO 

      i_len_obs_title=LEN_TRIM(s_obs_title_assemble_pre)
      WRITE(s_len_obs_title,'(i4)') i_len_obs_title

c     Take assembled obs without last pipe
      s_obs_title_assemble=
     +  s_obs_title_assemble_pre(1:i_len_obs_title-1)

c      print*,'s_obs_title_assemble='//
c     +  TRIM(s_obs_title_assemble)//'='
c      print*,'i_len_obs_title=',i_len_obs_title

      IF (i_len_obs_title.GE.1000) THEN 
       STOP 'write_header_obs_table; i_len_obs_title>limit'
      ENDIF
c*****
c     LITE

      l_col_lite=19 !18 changed from 18 to 19 21Oct2020

      s_lite_titlevec(1) ='observation_id'
      s_lite_titlevec(2) ='report_type'
      s_lite_titlevec(3) ='date_time'
      s_lite_titlevec(4) ='date_time_meaning'
      s_lite_titlevec(5) ='latitude'
      s_lite_titlevec(6) ='longitude'
      s_lite_titlevec(7) ='observation_height_above_station_surface'
      s_lite_titlevec(8) ='observed_variable'
      s_lite_titlevec(9) ='units'
      s_lite_titlevec(10)='observation_value'
      s_lite_titlevec(11)='value_significance'
      s_lite_titlevec(12)='observation_duration'
      s_lite_titlevec(13)='platform_type'
      s_lite_titlevec(14)='station_type'
      s_lite_titlevec(15)='primary_station_id'
      s_lite_titlevec(16)='station_name'
      s_lite_titlevec(17)='quality_flag'
      s_lite_titlevec(18)='data_policy_licence'
      s_lite_titlevec(19)='source_id'

      s_lite_title_assemble_pre=''
      DO i=1,l_col_lite
       s_lite_title_assemble_pre=TRIM(s_lite_title_assemble_pre)//
     +   TRIM(s_lite_titlevec(i))//'|'
      ENDDO 

      i_len_lite_title=LEN_TRIM(s_lite_title_assemble_pre)
      WRITE(s_len_lite_title,'(i4)') i_len_lite_title

c     Take assembled obs without last pipe
      s_lite_title_assemble=
     +  s_lite_title_assemble_pre(1:i_len_lite_title-1)

      IF (i_len_lite_title.GE.1000) THEN 
       STOP 'make_header_observation_lite; i_len_obs_title>limit'
      ENDIF
c*****
c     QC 

      l_col_qcmethod=4

      s_qcmethod_titlevec(1) ='report_id'
      s_qcmethod_titlevec(2) ='observation_id'
      s_qcmethod_titlevec(3) ='qc_method'
      s_qcmethod_titlevec(4) ='quality_flag'

      s_qcmethod_title_assemble_pre=''
      DO i=1,l_col_qcmethod
       s_qcmethod_title_assemble_pre=
     +   TRIM(s_qcmethod_title_assemble_pre)//
     +   TRIM(s_qcmethod_titlevec(i))//'|'
      ENDDO 

      i_len_qcmethod_title=LEN_TRIM(s_qcmethod_title_assemble_pre)
      WRITE(s_len_qcmethod_title,'(i4)') i_len_qcmethod_title

c     Take assembled obs without last pipe
      s_qcmethod_title_assemble=
     +  s_qcmethod_title_assemble_pre(1:i_len_qcmethod_title-1)

      IF (i_len_qcmethod_title.GE.1000) THEN 
       STOP 'header_obs_lite_qff20201120; i_len_qcmethod_title>limit'
      ENDIF

c      print*,'s_header_title_assemble=',TRIM(s_header_title_assemble)
c      print*,'i_len_header_title=',i_len_header_title
c      print*,'s_obs_title_assemble=',TRIM(s_obs_title_assemble)
c      print*,'i_len_obs_title=',i_len_obs_title
c      print*,'s_lite_title_assemble=',TRIM(s_lite_title_assemble)
c      print*,'i_len_lite_title=',i_len_lite_title
c      print*,'s_qc_title_assemble=',TRIM(s_qc_title_assemble)
c      print*,'i_len_qc_title=',i_len_qc_title

c      STOP 'header_obs_lite_qff20201120.f'
c************************************************************************
c************************************************************************
c     Define file names and full output path
c     13Jun2019: modified to write filename without file number
      s_filename_header=
     +  'header_table_r202106_'//TRIM(s_stnname_isolated)//
     +  '.psv'
      s_filename_observation=
     +  'observation_table_r202106_'//TRIM(s_stnname_isolated)//
     +  '.psv'
      s_filename_lite=
     +  'CDM_lite_r202106_'//TRIM(s_stnname_isolated)//
     +  '.psv'
      s_filename_qc=
     +  'qc_definition_r202106_'//TRIM(s_stnname_isolated)//
     +  '.psv'

c      s_filename_header=
c     +  'header_table_SecondR_'//TRIM(s_stnname_isolated)//
c     +  '.psv'
c      s_filename_observation=
c     +  'observation_table_SecondR_'//TRIM(s_stnname_isolated)//
c     +  '.psv'
c      s_filename_lite=
c     +  'CDM_lite_SecondRelease_'//TRIM(s_stnname_isolated)//
c     +  '.psv'

      s_pathandname_header=
     +   TRIM(s_directory_output_header)//
     +   TRIM(s_filename_header)
      s_pathandname_obs=
     +   TRIM(s_directory_output_observation)//
     +   TRIM(s_filename_observation)
      s_pathandname_lite=
     +   TRIM(s_directory_output_lite)//
     +   TRIM(s_filename_lite)
      s_pathandname_qc=
     +   TRIM(s_directory_output_qc)//
     +   TRIM(s_filename_qc)
c************************************************************************
c     INITIALIZATIONS

c     Initialize channel export counters
      DO i=1,l_channel
       i_vec_cnt_channelexported(i)=0
      ENDDO

c     Initialize values for the start/end times
      s_obs_date_time_st='-999'
      s_obs_date_time_en='-999'

c     Initialize values for the different report types
      DO i=1,l_cc_rgh          !cycle through report numbers
c       s_record_date_time_st_byreport(i)='-999'
c       s_record_date_time_en_byreport(i)='-999'
       DO j=1,l_varselect
        i_record_hist_channel(i,j)=0
 
c       Initialize the archival variables
        s_arch_date_st_yyyy_mm_dd(i,j) =''
        s_arch_date_en_yyyy_mm_dd(i,j) =''

        i_arch_cnt(i,j)                =0

        s_arch2_date_st_yyyy_mm_dd(i,j)=''
        s_arch2_date_en_yyyy_mm_dd(i,j)=''
        d_arch2_jtime_min(i,j)=10.0**7
        d_arch2_jtime_max(i,j)=-10.0**7
       ENDDO
      ENDDO

c      print*,'just before opening output files'
c************************************************************************
c     Open header file for output
      OPEN(UNIT=2,
     +   FILE=TRIM(s_pathandname_header),
     +   FORM='formatted',
     +   STATUS='REPLACE',ACTION='WRITE')

c     Open observation file for output
      OPEN(UNIT=3,
     +   FILE=TRIM(s_pathandname_obs),
     +   FORM='formatted',
     +   STATUS='REPLACE',ACTION='WRITE')

c     Open lite file for output
      OPEN(UNIT=4,
     +   FILE=TRIM(s_pathandname_lite),
     +   FORM='formatted',
     +   STATUS='REPLACE',ACTION='WRITE')

c     Open qc file for output
      OPEN(UNIT=5,
     +   FILE=TRIM(s_pathandname_qc),
     +   FORM='formatted',
     +   STATUS='REPLACE',ACTION='WRITE')

c************************************************************************
      s_fmt_header_title='a'//TRIM(ADJUSTL(s_len_header_title)) !s_fmt1
      WRITE(2,'('//s_fmt_header_title//')') 
     +   ADJUSTL(s_header_title_assemble)   !good

      s_fmt_obs_title='a'//TRIM(ADJUSTL(s_len_obs_title))       !s_fmt1
      WRITE(3,'('//s_fmt_obs_title//')') 
     +   ADJUSTL(s_obs_title_assemble)   !good

      s_fmt_lite_title='a'//TRIM(ADJUSTL(s_len_lite_title))       !s_fmt1
      WRITE(4,'('//s_fmt_lite_title//')') 
     +   ADJUSTL(s_lite_title_assemble)   !good

      s_fmt_qcmethod_title='a'//TRIM(ADJUSTL(s_len_qcmethod_title))       !s_fmt1
      WRITE(5,'('//s_fmt_qcmethod_title//')') 
     +   ADJUSTL(s_qcmethod_title_assemble)   !good
c************************************************************************
c     Cycle through time steps

      n_lines_obs   =0
      n_lines_header=0
      n_lines_lite  =0
      n_lines_qcmethod =0
c************************************************************************
c************************************************************************
      DO i=1,l_lines      !cycles through all lines of one station
c************************************************************************
c************************************************************************
c******
c      Master Preliminary variables that apply to header & observation
c       s_date_single=s_vec_date_yyyy_mm(i)   !use time stamp for data line
c       s_year  =s_date_single(1:4)
c       s_month =s_date_single(6:7)
c       s_day   ='01'

c       s_date_reconstruct_yyyy_mm_dd=
c     +    TRIM(s_year)//'-'//TRIM(s_month)//'-'//TRIM(s_day)
c       s_time_reconstruct_hh_mm_ss='00:00:00'
c       s_time_reconstruct_short='00:00'
c       s_time_offset     ='+00'

c      Find reconstructed dates & times
       CALL reconstruct_date_time(
     +  s_vec_year(i),s_vec_month(i),s_vec_day(i),
     +  s_vec_hour(i),s_vec_minute(i),
     +  s_date_reconstruct_yyyy_mm_dd,s_time_reconstruct_hh_mm_ss,
     +  s_corr_year,s_corr_month,s_corr_day,s_corr_hour,s_corr_minute)

       s_year  =s_corr_year
       s_month =s_corr_month
       s_day   =s_corr_day
       s_hour  =s_corr_hour
       s_minute=s_corr_minute

c       s_date_reconstruct_yyyy_mm_dd=
c     +   TRIM(s_vec_year(i))//'-'//
c     +   TRIM(s_vec_month(i))//'-'//
c     +   TRIM(s_vec_day(i))
c       s_time_reconstruct_hh_mm_ss=
c     +   s_vec_hour(i)//':'//s_vec_minute(i)//':00'

       s_time_offset     ='+00'

c       print*,'s_vec_year=', TRIM(s_vec_year(i))
c       print*,'s_vec_month=',TRIM(s_vec_month(i))
c       print*,'s_vec_day=',  TRIM(s_vec_day(i))
c       print*,'s_vec_hour=', TRIM(s_vec_hour(i))
c       print*,'s_vec_minute=',TRIM(s_vec_minute(i))

c       print*,'s_date_reconstruct_yyyy_mm_dd=',
c     +   TRIM(s_date_reconstruct_yyyy_mm_dd)
c       print*,'s_time_reconstruct_hh_mm_ss=',
c     +   TRIM(s_time_reconstruct_hh_mm_ss)

c******
c      print*,'just before assemble_vector_qff'
c      print*,'s_vec_wdir_deg=',
c     +  ('|'//TRIM(s_vec_wdir_deg(k)),k=1,10)
c      print*,'s_vec_wdir_origprec_empir_deg=',
c     +  ('|'//TRIM(s_vec_wdir_origprec_empir_deg(k)),k=1,10)

c      print*,'s_vec_wspd_ms=',
c     +  ('|'//TRIM(s_vec_wspd_ms(k)),k=1,10)
c      print*,'s_vec_wspd_origprec_empir_ms=',
c     +  ('|'//TRIM(s_vec_wspd_origprec_empir_ms(k)),k=1,10)
c******
c      Call subroutine to find which record numbers populated
c      print*,'just before find_vector_recordnumber'
       CALL assemble_vector_qff(l_channel,
     +   s_vec_airt_recordnum(i),s_vec_dewp_recordnum(i),
     +   s_vec_stnp_recordnum(i),s_vec_slpr_recordnum(i),
     +   s_vec_wdir_recordnum(i),s_vec_wspd_recordnum(i),
     +   s_avec_recordnumber)

c       print*,'a_vec_recordnu',(s_avec_recordnumber(j),j=1,l_channel)

c      Assemble vector sourceid
       CALL assemble_vector_qff(l_channel,
     +   s_vec_airt_source_id(i),s_vec_dewp_source_id(i),
     +   s_vec_stnp_source_id(i),s_vec_slpr_source_id(i),
     +   s_vec_wdir_source_id(i),s_vec_wspd_source_id(i),
     +   s_avec_sourceid)

c      Assemble vector presented data
       CALL assemble_vector_qff(l_channel,
     +   s_vec_airt_k(i),s_vec_dewp_k(i),
     +   s_vec_stnp_pa(i),s_vec_slpr_pa(i),
     +   s_vec_wdir_deg(i),s_vec_wspd_ms(i),
     +   s_avec_submitdata)

c      Assemble vector original data
       CALL assemble_vector_qff(l_channel,
     +   s_vec_airt_c(i),s_vec_dewp_c(i),
     +   s_vec_stnp_hpa(i),s_vec_slpr_hpa(i),
     +   s_vec_wdir_deg(i),s_vec_wspd_ms(i),
     +   s_avec_origdata)

c      Assemble vector qc flag
       CALL assemble_vector_qff(l_channel,
     +   s_vec_airt_cdmqc(i),s_vec_dewp_cdmqc(i),
     +   s_vec_stnp_cdmqc(i),s_vec_slpr_cdmqc(i),
     +   s_vec_wdir_cdmqc(i),s_vec_wspd_cdmqc(i),
     +   s_avec_qc)

c      Assemble vector qc method flag
       CALL assemble_vector_qff(l_channel,
     +   s_vec_airt_cdmqcmethod(i),s_vec_dewp_cdmqcmethod(i),
     +   s_vec_stnp_cdmqcmethod(i),s_vec_slpr_cdmqcmethod(i),
     +   s_vec_wdir_cdmqcmethod(i),s_vec_wspd_cdmqcmethod(i),
     +   s_avec_qcmethod)

c      Assemble vector precision of presented variable based on histogram analysis
       CALL assemble_vector_qff(l_channel,
     +s_vec_airt_convprec_empir_k(i),s_vec_dewp_convprec_empir_k(i),
     +s_vec_stnp_convprec_empir_pa(i),s_vec_slpr_convprec_empir_pa(i),
     +s_vec_wdir_origprec_empir_deg(i),s_vec_wspd_origprec_empir_ms(i),
     +s_avec_precision)

c      Assemble vector original data precision based on histogram analysis
       CALL assemble_vector_qff(l_channel,
     +s_vec_airt_origprec_empir_c(i),s_vec_dewp_origprec_empir_c(i),
     +s_vec_stnp_origprec_empir_hpa(i),s_vec_slpr_origprec_empir_hpa(i),
     +s_vec_wdir_origprec_empir_deg(i),s_vec_wspd_origprec_empir_ms(i),
     +s_avec_origprec)

c       print*,'s_avec_qc=',
c     +  ('='//TRIM(s_avec_qc(ii))//'=',ii=1,l_channel)
c       print*,'s_avec_qcmethod=',
c     +  ('='//TRIM(s_avec_qcmethod(ii))//'=',ii=1,l_channel)
c       STOP 'header_obs_lite_qff20201120'

c      print*,'s_avec_submitdata=',
c     +  ('='//TRIM(s_avec_submitdata(i1)),i1=1,6)
c      print*,'fragments='//
c     +  TRIM(s_vec_airt_k(i))//'='//TRIM(s_vec_dewp_k(i))//'='//
c     +  TRIM(s_vec_stnp_pa(i))//'='//TRIM(s_vec_slpr_pa(i))//'='//
c     +  TRIM(s_vec_wdir_deg(i))//'='//TRIM(s_vec_wspd_ms(i))//'='

c      print*,'s_avec_precision=',
c     +  ('='//TRIM(s_avec_precision(i1)),i1=1,6)
c      print*,'fragments='//
c     +  TRIM(s_vec_airt_convprec_empir_k(i))//'='//
c     +  TRIM(s_vec_dewp_convprec_empir_k(i))//'='//
c     +  TRIM(s_vec_stnp_convprec_empir_pa(i))//'='//
c     +  TRIM(s_vec_slpr_convprec_empir_pa(i))//'='//
c     +  TRIM(s_vec_wdir_origprec_empir_deg(i))//'='//
c     +  TRIM(s_vec_wspd_origprec_empir_ms(i))//'='

c      print*,'s_avec_origdata=',
c     +  ('='//TRIM(s_avec_origdata(i1)),i1=1,6)
c      print*,'fragments='//
c     +  TRIM(s_vec_airt_c(i))//'='//TRIM(s_vec_dewp_c(i))//'='//
c     +  TRIM(s_vec_stnp_hpa(i))//'='//TRIM(s_vec_slpr_hpa(i))//'='//
c     +  TRIM(s_vec_wdir_deg(i))//'='//TRIM(s_vec_wspd_ms(i))//'='

c      print*,'s_avec_origprec=',
c     +  ('='//TRIM(s_avec_origprec(i1)),i1=1,6)
c      print*,'fragments='//
c     +  TRIM(s_vec_airt_origprec_empir_c(i))//'='//
c     +  TRIM(s_vec_dewp_origprec_empir_c(i))//'='//
c     +  TRIM(s_vec_stnp_origprec_empir_hpa(i))//'='//
c     +  TRIM(s_vec_slpr_origprec_empir_hpa(i))//'='//
c     +  TRIM(s_vec_wdir_origprec_empir_deg(i))//'='//
c     +  TRIM(s_vec_wspd_origprec_empir_ms(i))//'='

c******
c      print*,'just after assemble_vector_qff'
c      print*,'s_vec_wdir_deg=',
c     +  ('|'//TRIM(s_vec_wdir_deg(k)),k=1,10)
c      print*,'s_vec_wdir_origprec_empir_deg=',
c     +  ('|'//TRIM(s_vec_wdir_origprec_empir_deg(k)),k=1,10)

c      print*,'s_vec_wspd_ms=',
c     +  ('|'//TRIM(s_vec_wspd_ms(k)),k=1,10)
c      print*,'s_vec_wspd_origprec_empir_ms=',
c     +  ('|'//TRIM(s_vec_wspd_origprec_empir_ms(k)),k=1,10)
c******
c      STOP 'header_obs_lite_qff'

c      Find number of elements in line vector (should be at least 1 data in line)
       CALL count_elements_vector_qff(l_channel,s_avec_origdata,
     +   i_count_elements)

c      EXIT LOOP if no data present
       IF (i_count_elements.EQ.0) THEN 
        print*,'not no gsom data in time step'
        print*,'this condition should not be met in qff file'

        GOTO 52
        STOP 'make_header_observation2'
       ENDIF
c*************************************************************************
c*************************************************************************
c      OBSERVATION: Define elements for observation line
       DO j=1,l_channel       !cycle through all variables in dataline

c       Act only if data variable not blank
        IF (LEN_TRIM(s_avec_origdata(j)).GT.0) THEN 
c*****
c       Get single variables by cycling through record number list
        DO k=1,l_collect_cnt       !cycle through stnconfig record numbers
c        Match variable record number to stnconfig record number
         IF (TRIM(s_avec_recordnumber(j)).EQ.
     +       TRIM(s_collect_record_number(k))) THEN 
          s_single_primary_id   =TRIM(s_collect_primary_id(k))
          s_single_record_number=TRIM(s_collect_record_number(k))
          s_single_secondary_id =TRIM(s_collect_secondary_id(k))
          s_single_station_name =TRIM(s_collect_station_name(k))
          s_single_longitude    =TRIM(s_collect_longitude(k))
          s_single_latitude     =TRIM(s_collect_latitude(k))
          s_single_height_station_above_sea_level=
     +         TRIM(s_collect_height_station_above_sea_level(k))
          s_single_data_policy_licence=
     +         TRIM(s_collect_data_policy_licence(k))
          s_single_source_id    =TRIM(s_collect_source_id(k))
          s_single_region       =TRIM(s_collect_region(k))
          s_single_operating_territory=
     +         TRIM(s_collect_operating_territory(k))
          s_single_station_type =TRIM(s_collect_station_type(k))

          s_single_platform_type=TRIM(s_collect_platform_type(k))
          s_single_platform_sub_type =
     +         TRIM(s_collect_platform_sub_type(k))
          s_single_primary_station_id_scheme=
     +         TRIM(s_collect_primary_station_id_scheme(k))

          s_single_location_accuracy=
     +         TRIM(s_collect_location_accuracy(k))
          s_single_location_method=
     +         TRIM(s_collect_location_method(k))
          s_single_location_quality=
     +         TRIM(s_collect_location_quality(k))
          s_single_station_crs  =TRIM(s_collect_station_crs(k))
          s_single_height_station_above_local_ground=
     +         TRIM(s_collect_height_station_above_local_ground(k))
          s_single_height_station_above_sea_level_acc=
     +         TRIM(s_collect_height_station_above_sea_level_acc(k))
          s_single_sea_level_datum=
     +         TRIM(s_collect_sea_level_datum(k))

          kk=k    !save identified index

          GOTO 61
         ENDIF
        ENDDO     !close k

c       If here then stnconfig information not found for observation
        print*,'emergency stop, recordnumber info not found for obs'

        print*,'presented record number',j,
     +    '='//TRIM(s_avec_recordnumber(j))//'='
        print*,'l_collect_cnt=',l_collect_cnt
        print*,'s_collect_record_number=',
     +    ('='//TRIM(s_collect_record_number(k))//'=',k=1,l_collect_cnt)

c       If here need to close all files & exit
        i_flag=1    !set problem flag

c       BAD RECORD NUMBER FOR ONE CHANNEL; goto next channel element
c        GOTO 71

        STOP 'header_obs_lite_qff20200609; observation sequence'
 
 61     CONTINUE
c*****
c       METHOD1
c       Main archival for stnconfig file
c       Update only if not previously set
        IF (s_arch_date_st_yyyy_mm_dd(kk,j).EQ.'') THEN 
         s_arch_date_st_yyyy_mm_dd(kk,j)=s_date_reconstruct_yyyy_mm_dd
        ENDIF
c       Update on each time step
        s_arch_date_en_yyyy_mm_dd(kk,j)=s_date_reconstruct_yyyy_mm_dd
        i_arch_cnt(kk,j)=i_arch_cnt(kk,j)+1

c       METHOD2
c       Convert date-time to jtime
        CALL get_jtime_from_datetime20210218(
     +     s_date_reconstruct_yyyy_mm_dd,s_time_reconstruct_hh_mm_ss,
     +     d_obs_jtime)

        CALL find_minmax_datetime20210218(
     +     s_date_reconstruct_yyyy_mm_dd,d_obs_jtime,
     +     d_arch2_jtime_min(kk,j),
     +     d_arch2_jtime_max(kk,j),
     +     s_arch2_date_st_yyyy_mm_dd(kk,j),
     +     s_arch2_date_en_yyyy_mm_dd(kk,j))

c*****
c       1. observation_id
c       11Jun2020: note recordnumber change here
        jj=1
        s_obs_observation_id=
     +     TRIM(s_primary_id)//'-'//
     +     TRIM(ADJUSTL(s_avec_recordnumber(j)))//'-'//
     +     TRIM(s_year)//'-'//
     +     TRIM(s_month)//'-'//
     +     TRIM(s_day)//'-'//
     +     TRIM(s_hour)//':'//
     +     TRIM(s_minute)//'-'//
     +     TRIM(s_code_observation(j))//'-'//
     +     TRIM(s_code_value_significance(j))
        s_obs_linedata_vec(jj)=TRIM(s_obs_observation_id)
c******
c       2. report_id - note this uses observation record number
c          this column corresponds to column 1 in header file
        jj=2
        s_obs_report_id=TRIM(s_primary_id)//'-'//
     +     TRIM(ADJUSTL(s_avec_recordnumber(j)))//'-'//
     +     TRIM(s_year)//'-'//
     +     TRIM(s_month)//'-'//
     +     TRIM(s_day)//'-'//
     +     TRIM(s_hour)//':'//
     +     TRIM(s_minute)
        s_obs_linedata_vec(jj)=s_obs_report_id
c******
c       3. data_policy_licence 
        jj=3
        s_obs_data_policy_licence=TRIM(s_single_data_policy_licence)
        s_obs_linedata_vec(jj)=s_obs_data_policy_licence
c******
c       4. date_time
        jj=4
        s_obs_date_time=
     +    s_date_reconstruct_yyyy_mm_dd//' '//
     +    s_time_reconstruct_hh_mm_ss//s_time_offset
        s_obs_linedata_vec(jj)=s_obs_date_time
c******
c       5. date-time_meaning
        jj=5
        s_obs_date_time_meaning='1'     !enter 1 for synop (beginning date time)
        s_obs_linedata_vec(jj)=s_obs_date_time_meaning
c******
c       6. observation_duration
        jj=6
        s_obs_observation_duration='0'   !0=instantaneous, 13=daily, 14=monthly
        s_obs_linedata_vec(jj)=s_obs_observation_duration
c******
c       7. longitude
        jj=7
        s_obs_longitude=TRIM(s_single_longitude)
        s_obs_linedata_vec(jj)=s_obs_longitude
c******
c       8. latitude
        jj=8
        s_obs_latitude=TRIM(s_single_latitude)
        s_obs_linedata_vec(jj)=s_obs_latitude
c******
c       9. crs
        jj=9
        s_obs_crs='NULL'
        s_obs_linedata_vec(jj)=s_obs_crs
c******
c       10.z_coordinate
        jj=10
        s_obs_z_coordinate='NULL'
        s_obs_linedata_vec(jj)=s_obs_z_coordinate
c******
c       11.z_coordinate_type
        jj=11
        s_obs_z_coordinate_type='NULL'
        s_obs_linedata_vec(jj)=s_obs_z_coordinate_type
c******
c       12.observation_height_above_station_surface
        jj=12
        s_obs_observation_height_above_station_surface=
     +    s_predef_hgt_obs_above_sfc(j) 
        s_obs_linedata_vec(jj)=
     +    s_obs_observation_height_above_station_surface
c******
c       13.observed_variable
        jj=13
        s_obs_observed_variable=s_code_observation(j)
        s_obs_linedata_vec(jj)=s_obs_observed_variable
c******
c       14.secondary_variable
        jj=14
        s_obs_secondary_variable='NULL'
        s_obs_linedata_vec(jj)=s_obs_secondary_variable
c******
c       15.observation_value
        jj=15
        s_obs_observation_value=
     +     TRIM(ADJUSTL(s_avec_submitdata(j)))
        s_obs_linedata_vec(jj)=s_obs_observation_value
c******
c       16.value_significance
        jj=16
        s_obs_value_significance=s_code_value_significance(j)
        s_obs_linedata_vec(jj)=s_obs_value_significance
c******
c       17.secondary_value
        jj=17
        s_obs_secondary_value=''
        s_obs_linedata_vec(jj)=s_obs_secondary_value
c******
c       18.units
        jj=18
        s_obs_units=s_code_unit(j)
        s_obs_linedata_vec(jj)=s_obs_units
c******
c       19.code table
        jj=19
        s_obs_code_table     ='NULL'
        s_obs_linedata_vec(jj)=s_obs_code_table
c******
c       20.conversion_flag
        jj=20
        s_obs_conversion_flag=s_code_conversion_flag(j)
        s_obs_linedata_vec(jj)=s_obs_conversion_flag
c******
c       21.location_flag
        jj=21
        s_obs_location_method='NULL'
        s_obs_linedata_vec(jj)=s_obs_location_method
c******
c       22.location_precision
        jj=22
        s_obs_location_precision='NULL'
        s_obs_linedata_vec(jj)=s_obs_location_precision
c******
c       23.coordinate_method
        jj=23
        s_obs_coordinate_method='NULL'
        s_obs_linedata_vec(jj)=s_obs_coordinate_method
c******
c       24.bbox_min_longitude
        jj=24
        s_obs_bbox_min_longitude='NULL'
        s_obs_linedata_vec(jj)=s_obs_bbox_min_longitude
c******
c       25.bbox_max_longitude
        jj=25
        s_obs_bbox_max_longitude='NULL'
        s_obs_linedata_vec(jj)=s_obs_bbox_max_longitude
c******
c       26.bbox_min_latitude
        jj=26
        s_obs_bbox_min_latitude='NULL'
        s_obs_linedata_vec(jj)=s_obs_bbox_min_latitude
c******
c       27.bbox_max_latitude
        jj=27
        s_obs_bbox_max_latitude='NULL'
        s_obs_linedata_vec(jj)=s_obs_bbox_max_latitude
c******
c       28.spatial_representativeness
        jj=28
        s_obs_spatial_representativeness='NULL'
        s_obs_linedata_vec(jj)=s_obs_spatial_representativeness
c******
c       29.quality_flag
        jj=29
        s_obs_quality_flag=TRIM(ADJUSTL(s_avec_qc(j)))
        s_obs_linedata_vec(jj)=s_obs_quality_flag
c******
c       30.numerical_precision (problem here)
        jj=30
        s_obs_numerical_precision=TRIM(ADJUSTL(s_avec_precision(j)))
        s_obs_linedata_vec(jj)=s_obs_numerical_precision
c******
c       31.sensor_id
        jj=31
        s_obs_sensor_id='NULL'
        s_obs_linedata_vec(jj)=s_obs_sensor_id
c******
c       32.sensor_automation_status
        jj=32
        s_obs_sensor_automation_status='NULL'
        s_obs_linedata_vec(jj)=s_obs_sensor_automation_status
c******
c       33.exposure_of_sensor
        jj=33
        s_obs_exposure_of_sensor='NULL'
        s_obs_linedata_vec(jj)=s_obs_exposure_of_sensor
c******
c       34.original_precision
        jj=34
        s_obs_original_precision=TRIM(ADJUSTL(s_avec_origprec(j)))
        s_obs_linedata_vec(jj)=s_obs_original_precision
c******
c       35.original_units
        jj=35
        s_obs_original_units=TRIM(ADJUSTL(s_code_unit_original(j)))
        s_obs_linedata_vec(jj)=s_obs_original_units
c******
c       36.original_code_table 
        jj=36
        s_obs_original_code_table='NULL'
        s_obs_linedata_vec(jj)=s_obs_original_code_table
c******
c       37.original_value
        jj=37
        s_obs_original_value=TRIM(ADJUSTL(s_avec_origdata(j)))
        s_obs_linedata_vec(jj)=s_obs_original_value
c******
c       38.conversion_method
        jj=38
        s_obs_conversion_method=s_code_conversion_method(j)
        s_obs_linedata_vec(jj)=s_obs_conversion_method
c******
c       39.processing_code
        jj=39
        s_obs_processing_code='NULL'
        s_obs_linedata_vec(jj)=s_obs_processing_code
c******
c       40.processing_level
        jj=40
        s_obs_processing_level='0'
        s_obs_linedata_vec(jj)=s_obs_processing_level
c******
c       41.adjustment_id
        jj=41
        s_obs_adjustment_id='NULL'
        s_obs_linedata_vec(jj)=s_obs_adjustment_id
c******
c       42.traceability
        jj=42
        s_obs_traceability='NULL'
        s_obs_linedata_vec(jj)=s_obs_traceability
c******
c       43.advanced_qc
        jj=43
        s_obs_advanced_qc='NULL'
        s_obs_linedata_vec(jj)=s_obs_advanced_qc
c******
c       44.advanced_uncertainty
        jj=44
        s_obs_advanced_uncertainty='NULL'
        s_obs_linedata_vec(jj)=s_obs_advanced_uncertainty
c******
c       45.advanced_homogenisation
        jj=45
        s_obs_advanced_homogenisation='NULL'
        s_obs_linedata_vec(jj)=s_obs_advanced_homogenisation
c******
c       46.advanced_assimilation_feedback
        jj=46
        s_obs_advanced_assimilation_feedback='NULL' 
        s_obs_linedata_vec(jj)=s_obs_advanced_assimilation_feedback
c******
c       47.source_id 
c       note change 11Jun2020
        jj=47
        s_obs_source_id=TRIM(ADJUSTL(s_avec_sourceid(j)))  !s_single_source_id 
        s_obs_linedata_vec(jj)=s_obs_source_id
c******
c******
c       String all fields together
        s_obs_linedata_assemble_pre=''
        DO jj=1,l_col_obs
         s_obs_linedata_assemble_pre =
     +     TRIM( s_obs_linedata_assemble_pre)//
     +     TRIM(s_obs_linedata_vec(jj))//'|'
        ENDDO 

        i_linedata_len=LEN_TRIM(s_obs_linedata_assemble_pre)

c       Clip off final pipe
        s_obs_linedata_assemble=
     +    s_obs_linedata_assemble_pre(1:i_linedata_len-1)

        i_linedata_len=LEN_TRIM(s_obs_linedata_assemble)
c       Convert integer to string for format statement
        WRITE(s_linedata_len,'(i4)') i_linedata_len

        IF (i_linedata_len.GE.1000) THEN
         print*,'i_linedata_len=',i_linedata_len 
         STOP 'make_header_observation2; i_obs_linedata_len>limit'
        ENDIF
c******
c       WRITE LINE; data presence already vetted

         s_fmt1='a'//TRIM(ADJUSTL(s_linedata_len))
         WRITE(3,'('//s_fmt1//')') 
     +   ADJUSTL(s_obs_linedata_assemble)   !good

c         print*,'i_linedata_len=',i_linedata_len
c         print*,'s_obs_linedata_assemble',TRIM(s_obs_linedata_assemble)

c        INCREMENT LINE COUNTER HERE (number lines in observation file)
         n_lines_obs=n_lines_obs+1
c******
c******
c        Output lines to screen

         GOTO 23

         CALL sample_screenprint_obs(
     +  s_obs_observation_id,s_obs_report_id,s_obs_data_policy_licence,
     +  s_obs_date_time,s_obs_date_time_meaning,
     +    s_obs_observation_duration,
     +  s_obs_longitude,s_obs_latitude,s_obs_crs,
     +  s_obs_z_coordinate,s_obs_z_coordinate_type,
     +    s_obs_observation_height_above_station_surface, 
     +  s_obs_observed_variable,s_obs_secondary_variable,
     +    s_obs_observation_value,
     +  s_obs_value_significance,s_obs_secondary_value,s_obs_units,
     +  s_obs_code_table,s_obs_conversion_flag,s_obs_location_method,
     +  s_obs_location_precision,s_obs_coordinate_method,
     +  s_obs_bbox_min_longitude,s_obs_bbox_max_longitude,
     +  s_obs_bbox_min_latitude,s_obs_bbox_max_latitude,
     +  s_obs_spatial_representativeness,s_obs_quality_flag,
     +  s_obs_numerical_precision,s_obs_sensor_id,
     +  s_obs_sensor_automation_status,s_obs_exposure_of_sensor,
     +  s_obs_original_precision,s_obs_original_units,
     +  s_obs_original_code_table,s_obs_original_value,
     +  s_obs_conversion_method,s_obs_processing_code,
     +  s_obs_processing_level,s_obs_adjustment_id,
     +  s_obs_traceability,s_obs_advanced_qc,
     +  s_obs_advanced_uncertainty,s_obs_advanced_homogenisation,
     +  s_obs_advanced_assimilation_feedback,
     +  s_obs_source_id,
     +  s_obs_linedata_assemble)

c      CALL SLEEP(1)

        STOP 'header_obs_lite_qff20201120; just after obs'

 23     CONTINUE
c******
        ENDIF                 !condition that variable not empty

 71     CONTINUE              !entry point; bad recordnumber of 1 channel

       ENDDO                  !close index j cycling through channels
c*************************************************************************
c*************************************************************************
c      QCMETHOD procedure

       DO j=1,l_channel       !cycle through all variables in dataline

c       Act only if data variable not blank (observation table condition)
        IF (LEN_TRIM(s_avec_origdata(j)).GT.0) THEN 

c       Act only if qcmethod variable not blank
        IF (LEN_TRIM(s_avec_qcmethod(j)).GT.0) THEN 
c*****
c       Get single variables by cycling through record number list
        DO k=1,l_collect_cnt       !cycle through stnconfig record numbers
         IF (TRIM(s_avec_recordnumber(j)).EQ.
     +       TRIM(s_collect_record_number(k))) THEN 
          s_single_primary_id   =TRIM(s_collect_primary_id(k))
          s_single_record_number=TRIM(s_collect_record_number(k))
          s_single_secondary_id =TRIM(s_collect_secondary_id(k))
          s_single_station_name =TRIM(s_collect_station_name(k))
          s_single_longitude    =TRIM(s_collect_longitude(k))
          s_single_latitude     =TRIM(s_collect_latitude(k))
          s_single_height_station_above_sea_level=
     +         TRIM(s_collect_height_station_above_sea_level(k))
          s_single_data_policy_licence=
     +         TRIM(s_collect_data_policy_licence(k))
          s_single_source_id    =TRIM(s_collect_source_id(k))
          s_single_region       =TRIM(s_collect_region(k))
          s_single_operating_territory=
     +         TRIM(s_collect_operating_territory(k))
          s_single_station_type =TRIM(s_collect_station_type(k))

          s_single_platform_type=TRIM(s_collect_platform_type(k))
          s_single_platform_sub_type =
     +         TRIM(s_collect_platform_sub_type(k))
          s_single_primary_station_id_scheme=
     +         TRIM(s_collect_primary_station_id_scheme(k))

          s_single_location_accuracy=
     +         TRIM(s_collect_location_accuracy(k))
          s_single_location_method=
     +         TRIM(s_collect_location_method(k))
          s_single_location_quality=
     +         TRIM(s_collect_location_quality(k))
          s_single_station_crs  =TRIM(s_collect_station_crs(k))
          s_single_height_station_above_local_ground=
     +         TRIM(s_collect_height_station_above_local_ground(k))
          s_single_height_station_above_sea_level_acc=
     +         TRIM(s_collect_height_station_above_sea_level_acc(k))
          s_single_sea_level_datum=
     +         TRIM(s_collect_sea_level_datum(k))

          kk=k    !save identified index

          GOTO 161
         ENDIF
        ENDDO     !close k

c       If here then stnconfig information not found for observation
        print*,'emergency stop,recordnumber info not found qcmethod'

        print*,'presented record number',j,
     +    '='//TRIM(s_avec_recordnumber(j))//'='
        print*,'l_collect_cnt=',l_collect_cnt
        print*,'s_collect_record_number=',
     +    ('='//TRIM(s_collect_record_number(k))//'=',k=1,l_collect_cnt)

c       If here need to close all files & exit
        i_flag=1    !set problem flag

        STOP 'header_obs_lite_qff20201120; qcmethod sequence'
 
 161    CONTINUE
c*****
cc       Main archival for stnconfig file
cc       Update only if not previously set
c        IF (s_arch_date_st_yyyy_mm_dd(kk,j).EQ.'') THEN 
c         s_arch_date_st_yyyy_mm_dd(kk,j)=s_date_reconstruct_yyyy_mm_dd
c        ENDIF
cc       Update on each time step
c        s_arch_date_en_yyyy_mm_dd(kk,j)=s_date_reconstruct_yyyy_mm_dd
c        i_arch_cnt(kk,j)=i_arch_cnt(kk,j)+1
c*****
c*****
c       1. observation_id
c       11Jun2020: note recordnumber change here
        jj=1
        s_qcmethod_observation_id=
     +     TRIM(s_primary_id)//'-'//
     +     TRIM(ADJUSTL(s_avec_recordnumber(j)))//'-'//
     +     TRIM(s_year)//'-'//
     +     TRIM(s_month)//'-'//
     +     TRIM(s_day)//'-'//
     +     TRIM(s_hour)//':'//
     +     TRIM(s_minute)//'-'//
     +     TRIM(s_code_observation(j))//'-'//
     +     TRIM(s_code_value_significance(j))
        s_qcmethod_linedata_vec(jj)=TRIM(s_qcmethod_observation_id)
c******
c       2. report_id - note this uses observation record number
c          this column corresponds to column 1 in header file
        jj=2
        s_qcmethod_report_id=TRIM(s_primary_id)//'-'//
     +     TRIM(ADJUSTL(s_avec_recordnumber(j)))//'-'//
     +     TRIM(s_year)//'-'//
     +     TRIM(s_month)//'-'//
     +     TRIM(s_day)//'-'//
     +     TRIM(s_hour)//':'//
     +     TRIM(s_minute)
        s_qcmethod_linedata_vec(jj)=s_qcmethod_report_id
c******
c       3. qcmethod
        jj=3
        s_qcmethod_qc_method=TRIM(ADJUSTL(s_avec_qcmethod(j)))
        s_qcmethod_linedata_vec(jj)=s_qcmethod_qc_method
c******
c       4.quality_flag
        jj=4
        s_qcmethod_quality_flag=TRIM(ADJUSTL(s_avec_qc(j)))
        s_qcmethod_linedata_vec(jj)=s_qcmethod_quality_flag
c******
c******
c       String all fields together
        s_qcmethod_linedata_assemble_pre=''
        DO jj=1,l_col_qcmethod
         s_qcmethod_linedata_assemble_pre =
     +     TRIM(s_qcmethod_linedata_assemble_pre)//
     +     TRIM(s_qcmethod_linedata_vec(jj))//'|'
        ENDDO 

        i_linedata_len=LEN_TRIM(s_qcmethod_linedata_assemble_pre)

c       Clip off final pipe
        s_qcmethod_linedata_assemble=
     +    s_qcmethod_linedata_assemble_pre(1:i_linedata_len-1)

        i_linedata_len=LEN_TRIM(s_qcmethod_linedata_assemble)
c       Convert integer to string for format statement
        WRITE(s_linedata_len,'(i4)') i_linedata_len

        IF (i_linedata_len.GE.1000) THEN
         print*,'i_linedata_len=',i_linedata_len 
         STOP 
     +    'header_obs_lite_qff20201120; i_qcmethod_linedata_len>limit'
        ENDIF
c******
c       WRITE LINE; data presence already vetted

         s_fmt1='a'//TRIM(ADJUSTL(s_linedata_len))
         WRITE(5,'('//s_fmt1//')') 
     +   ADJUSTL(s_qcmethod_linedata_assemble)   !good

c         print*,'i_linedata_len=',i_linedata_len
c         print*,'s_obs_linedata_assemble',TRIM(s_obs_linedata_assemble)

c        INCREMENT LINE COUNTER HERE (number lines in observation file)
         n_lines_qcmethod=n_lines_qcmethod+1
c******
         GOTO 123

         CALL sample_screenprint_qcmethod(
     +     s_qcmethod_observation_id,s_qcmethod_report_id,
     +     s_qcmethod_qc_method,s_qcmethod_quality_flag)

         STOP 'header_obs_lite_qff20210218; just after qcmethod'

 123     CONTINUE
c******
        ENDIF                 !condition that qcmethod variable not empty
        ENDIF                 !condition that value length greater than zero

       ENDDO                  !close index j cycling through channels
c*************************************************************************
c*************************************************************************
c      LITE procedure

c      Define elements for observation line
       DO j=1,l_channel       !cycle through all variables in dataline

c       Act only if data variable not blank
        IF (LEN_TRIM(s_avec_origdata(j)).GT.0) THEN 
c*****
c       Get single variables by cycling through record number list
        DO k=1,l_collect_cnt       !cycle through stnconfig record numbers
         IF (TRIM(s_avec_recordnumber(j)).EQ.
     +       TRIM(s_collect_record_number(k))) THEN 
          s_single_primary_id   =TRIM(s_collect_primary_id(k))
          s_single_record_number=TRIM(s_collect_record_number(k))
          s_single_secondary_id =TRIM(s_collect_secondary_id(k))
          s_single_station_name =TRIM(s_collect_station_name(k))
          s_single_longitude    =TRIM(s_collect_longitude(k))
          s_single_latitude     =TRIM(s_collect_latitude(k))
          s_single_height_station_above_sea_level=
     +         TRIM(s_collect_height_station_above_sea_level(k))
          s_single_data_policy_licence=
     +         TRIM(s_collect_data_policy_licence(k))
          s_single_source_id    =TRIM(s_collect_source_id(k))
          s_single_region       =TRIM(s_collect_region(k))
          s_single_operating_territory=
     +         TRIM(s_collect_operating_territory(k))
          s_single_station_type =TRIM(s_collect_station_type(k))

          s_single_platform_type=TRIM(s_collect_platform_type(k))
          s_single_platform_sub_type =
     +         TRIM(s_collect_platform_sub_type(k))
          s_single_primary_station_id_scheme=
     +         TRIM(s_collect_primary_station_id_scheme(k))

          s_single_location_accuracy=
     +         TRIM(s_collect_location_accuracy(k))
          s_single_location_method=
     +         TRIM(s_collect_location_method(k))
          s_single_location_quality=
     +         TRIM(s_collect_location_quality(k))
          s_single_station_crs  =TRIM(s_collect_station_crs(k))
          s_single_height_station_above_local_ground=
     +         TRIM(s_collect_height_station_above_local_ground(k))
          s_single_height_station_above_sea_level_acc=
     +         TRIM(s_collect_height_station_above_sea_level_acc(k))
          s_single_sea_level_datum=
     +         TRIM(s_collect_sea_level_datum(k))

          kk=k    !save identified index

          GOTO 63
         ENDIF
        ENDDO     !close k, cycling through stnconfig info

c       If here then stnconfig information not found for observation
        print*,'emergency stop, recordnumber info not found for lite'

c       BAD RECORD NUMBER FOR ONE CHANNEL; goto next channel element
        STOP 'header_obs_lite_qff; lite sequence'

        GOTO 72
 
 63     CONTINUE
c*****
c       1. observation_id (observation table column 1)
        jj=1
c       11Jun2020: note change in record number here
        s_lite_observation_id=
     +     TRIM(s_primary_id)//'-'//
     +     TRIM(ADJUSTL(s_avec_recordnumber(j)))//'-'//
     +     TRIM(s_year)//'-'//
     +     TRIM(s_month)//'-'//
     +     TRIM(s_day)//'-'//
     +     TRIM(s_hour)//':'//
     +     TRIM(s_minute)//'-'//
     +     TRIM(s_code_observation(j))//'-'//
     +     TRIM(s_code_value_significance(j))
c        s_lite_observation_id=
c     +     TRIM(s_primary_id)//'-'//
c     +     TRIM(ADJUSTL(s_single_record_number))//'-'//
c     +     TRIM(s_year)//'-'//
c     +     TRIM(s_month)//'-'//
c     +     TRIM(s_day)//'-'//
c     +     TRIM(s_hour)//':'//
c     +     TRIM(s_minute)//'-'//
c     +     TRIM(s_code_observation(j))//'-'//
c     +     TRIM(s_code_value_significance(j))
        s_lite_linedata_vec(jj)=TRIM(s_lite_observation_id)
c******
c       2. report_type (header table column 6)
        jj=2
        IF (s_single_source_id.NE.'223') THEN
         s_lite_report_type='0'
        ENDIF
        IF (s_single_source_id.EQ.'223') THEN
         s_lite_report_type='4'
        ENDIF
c        s_lite_report_type=''
        s_lite_linedata_vec(jj)=TRIM(s_lite_report_type)
c******
c       3. date_time (observation table column 4)
        jj=3
        s_lite_date_time=
     +    s_date_reconstruct_yyyy_mm_dd//' '//
     +    s_time_reconstruct_hh_mm_ss//s_time_offset
        s_lite_linedata_vec(jj)=s_lite_date_time
c******
c       4. date_time_meaning (observation table column 5)
        jj=4
        s_lite_date_time_meaning='1'     !1 for synop; enter 1 for monthly
        s_lite_linedata_vec(jj)=s_lite_date_time_meaning
c******
c       5. latitude (observation table column 8)
        jj=5
        s_lite_latitude=TRIM(s_single_latitude)
        s_lite_linedata_vec(jj)=s_lite_latitude
c******
c       6. longitude (observation table column 7)
        jj=6
        s_lite_longitude=TRIM(s_single_longitude)
        s_lite_linedata_vec(jj)=s_lite_longitude
c******
c       7. observation_height_above_station_surface (observation table col 12)
        jj=7
        s_lite_observation_height_above_station_surface=
     +    s_predef_hgt_obs_above_sfc(j) 
        s_lite_linedata_vec(jj)=
     +    s_lite_observation_height_above_station_surface
c******
c       8. observed_variable (observation table col 13)
        jj=8
        s_lite_observed_variable=s_code_observation(j)
        s_lite_linedata_vec(jj)=s_lite_observed_variable
c******
c       9. units (observation table col 18)
        jj=9
        s_lite_units=s_code_unit(j)
        s_lite_linedata_vec(jj)=s_lite_units
c******
c       10.observation_value (observation table col 15)
        jj=10
        s_lite_observation_value=
     +     TRIM(ADJUSTL(s_avec_submitdata(j)))
        s_lite_linedata_vec(jj)=s_lite_observation_value
c******
c       11.value_significance (observation table column 16)
        jj=11
        s_lite_value_significance=s_code_value_significance(j)
        s_lite_linedata_vec(jj)=s_lite_value_significance
c******
c       12.observation_duration (observation table column 6)
        jj=12
        s_lite_observation_duration='0'   !0=instantaneous, 13=daily, 14=monthly
        s_lite_linedata_vec(jj)=s_lite_observation_duration
c******
c       13. platform_type (header table column 9)
        jj=13
        s_lite_platform_type=TRIM(s_single_platform_type)
        s_lite_linedata_vec(jj)=TRIM(s_lite_platform_type)
c******
c       14. station_type (header table column 8))
        jj=14
        s_lite_station_type=TRIM(s_single_station_type)
        s_lite_linedata_vec(jj)=TRIM(s_lite_station_type)
c******
c       15. primary_station_id (header table column 11)
        jj=15
        s_lite_primary_station_id=s_primary_id
        s_lite_linedata_vec(jj)=TRIM(s_lite_primary_station_id)
c******
c       16. station_name (header table column 7)
        jj=16
        s_lite_station_name=TRIM(s_single_station_name)
        s_lite_linedata_vec(jj)=TRIM(s_lite_station_name)
c******
c       17. quality_flag (observation table column 29)
        jj=17
        s_lite_quality_flag=TRIM(ADJUSTL(s_avec_qc(j)))
        s_lite_linedata_vec(jj)=s_lite_quality_flag
c******
c       18. data_policy_licence (observation table column 3)
        jj=18
        s_lite_data_policy_licence=TRIM(s_single_data_policy_licence)
        s_lite_linedata_vec(jj)=s_lite_data_policy_licence
c******
c       19. source_id (observation table column 46)
        jj=19
        s_lite_source_id=TRIM(ADJUSTL(s_avec_sourceid(j)))
        s_lite_linedata_vec(jj)=s_lite_source_id
c******
c******
c       String all fields together
        s_lite_linedata_assemble_pre=''
        DO jj=1,l_col_lite             !cycle through columns in lite file
         s_lite_linedata_assemble_pre =
     +     TRIM( s_lite_linedata_assemble_pre)//
     +     TRIM(s_lite_linedata_vec(jj))//'|'
        ENDDO 

        i_linedata_len=LEN_TRIM(s_lite_linedata_assemble_pre)

c       Clip off final pipe
        s_lite_linedata_assemble=
     +    s_lite_linedata_assemble_pre(1:i_linedata_len-1)

        i_linedata_len=LEN_TRIM(s_lite_linedata_assemble)
c       Convert integer to string for format statement
        WRITE(s_linedata_len,'(i4)') i_linedata_len

        IF (i_linedata_len.GE.1000) THEN
         print*,'i_linedata_len=',i_linedata_len 
         STOP 'header_obs_lite_qff; i_obs_linedata_len>limit'
        ENDIF
c******
c       WRITE LINE; data presence already vetted

         s_fmt1='a'//TRIM(ADJUSTL(s_linedata_len))
         WRITE(4,'('//s_fmt1//')') 
     +   ADJUSTL(s_lite_linedata_assemble)   !good

c         print*,'i_linedata_len=',i_linedata_len
c         print*,'s_obs_linedata_assemble',TRIM(s_obs_linedata_assemble)

c        INCREMENT LINE COUNTER HERE (number lines in observation file)
         n_lines_lite=n_lines_lite+1

c******
c******
        GOTO 26

c       Print info to screen 
        CALL sample_screenprint_lite(
     +  s_lite_observation_id,s_lite_report_type,
     +  s_lite_date_time,s_lite_date_time_meaning,
     +  s_lite_latitude,s_lite_longitude, 
     +  s_lite_observation_height_above_station_surface,
     +  s_lite_observed_variable,s_lite_units,
     +  s_lite_observation_value,s_lite_value_significance, 
     +  s_lite_observation_duration,s_lite_platform_type, 
     +  s_lite_station_type,s_lite_primary_station_id,
     +  s_lite_station_name,s_lite_quality_flag,
     +  s_lite_data_policy_licence,s_lite_source_id, 
     +  s_lite_linedata_assemble)

        STOP 'header_obs_lite_qff20201120'

 26     CONTINUE
c******
c******
        ENDIF         !condition that variable variable not empty

 72     CONTINUE      !entry point for bad record number test

       ENDDO          !close index j cycling through channels
c*************************************************************************
c*************************************************************************
c      HEADER PROCEDURE

c      Find distinct record number - this will not be more than 6 variables
c      From set of 6 record numbers, subroutine finds distinct ones.
c      Bad record numbers are filtered here.
       CALL find_distinct_recnum_qff(
     +   l_channel,s_avec_recordnumber,
     +   l_distinct_recnum,s_dvec_recordnumber)

c       print*,'l_distinct_recnum=',l_distinct_recnum
c       print*,'s_dvec_recordnumber=',
c     +   (s_dvec_recordnumber(j),j=1,l_distinct_recnum)

c      Assemble information for each header line
c      cycle through distinct record numbers from from 1 up to 6
       DO j=1,l_distinct_recnum    

c       Segment to find single values from stnconfig
        DO k=1,l_collect_cnt       !cycle through stnconfig record numbers
         IF (TRIM(s_dvec_recordnumber(j)).EQ.
     +       TRIM(s_collect_record_number(k))) THEN 
          s_single_primary_id   =TRIM(s_collect_primary_id(k))
          s_single_record_number=TRIM(s_collect_record_number(k))
          s_single_secondary_id =TRIM(s_collect_secondary_id(k))
          s_single_station_name =TRIM(s_collect_station_name(k))
          s_single_longitude    =TRIM(s_collect_longitude(k))
          s_single_latitude     =TRIM(s_collect_latitude(k))
          s_single_height_station_above_sea_level=
     +         TRIM(s_collect_height_station_above_sea_level(k))
          s_single_data_policy_licence=
     +         TRIM(s_collect_data_policy_licence(k))
          s_single_source_id    =TRIM(s_collect_source_id(k))
          s_single_region       =TRIM(s_collect_region(k))
          s_single_operating_territory=
     +         TRIM(s_collect_operating_territory(k))
          s_single_station_type =TRIM(s_collect_station_type(k))

          s_single_platform_type=TRIM(s_collect_platform_type(k))
          s_single_platform_sub_type =
     +         TRIM(s_collect_platform_sub_type(k))
          s_single_primary_station_id_scheme=
     +         TRIM(s_collect_primary_station_id_scheme(k))

          s_single_location_accuracy=
     +         TRIM(s_collect_location_accuracy(k))
          s_single_location_method=
     +         TRIM(s_collect_location_method(k))
          s_single_location_quality=
     +         TRIM(s_collect_location_quality(k))
          s_single_station_crs  =TRIM(s_collect_station_crs(k))
          s_single_height_station_above_local_ground=
     +         TRIM(s_collect_height_station_above_local_ground(k))
          s_single_height_station_above_sea_level_acc=
     +         TRIM(s_collect_height_station_above_sea_level_acc(k))
          s_single_sea_level_datum=
     +         TRIM(s_collect_sea_level_datum(k))

          GOTO 60
         ENDIF
        ENDDO    !close k-index

c       If there then record number not found
        print*,'emergency stop, record number not found'

c       BAD RECORD NUMBER FOR ONE RECORD NUMBER CYCLER; goto next recordnumber
        STOP 'header_obs_lite_qff; header sequence'
c        GOTO 73

 60     CONTINUE
c******
c******
c      MAIN LIST VARIABLES
c******
c      1. report_id
       jj=1
       s_header_report_id=
     +     TRIM(s_primary_id)//'-'//
     +     TRIM(ADJUSTL(s_single_record_number))//'-'//
     +     TRIM(s_year)//'-'//
     +     TRIM(s_month)//'-'//
     +     TRIM(s_day)//'-'//
     +     TRIM(s_hour)//':'//
     +     TRIM(s_minute)
       s_header_linedata_vec(jj)=TRIM(s_header_report_id)
c******
c      2. region
       jj=2
       s_header_region=ADJUSTL(s_single_region)
       s_header_linedata_vec(jj)=TRIM(s_header_region)
c******
c      3. subregion
       jj=3
       s_header_sub_region=ADJUSTL(s_single_operating_territory)
       s_header_linedata_vec(jj)=TRIM(s_header_sub_region)
c*****
c      4. application_area
       jj=4
       s_header_application_area=''
       s_header_linedata_vec(jj)=TRIM(s_header_application_area)
c*****
c      5. observing_programme
       jj=5
       s_header_observing_programme=''
       s_header_linedata_vec(jj)=TRIM(s_header_observing_programme)
c******
c      6. report_type
       jj=6
       IF (s_single_source_id.NE.'223') THEN
        s_header_report_type='0'
       ENDIF
       IF (s_single_source_id.EQ.'223') THEN
        s_header_report_type='4'
       ENDIF
       s_header_linedata_vec(jj)=TRIM(s_header_report_type)
c*****
c      7. station_name
       jj=7
       s_header_station_name=TRIM(s_single_station_name)
       s_header_linedata_vec(jj)=TRIM(s_header_station_name)
c*****
c      8. station_type
       jj=8
       s_header_station_type=TRIM(s_single_station_type)
       s_header_linedata_vec(jj)=TRIM(s_header_station_type)
c******
c      9. platform_type
       jj=9
       s_header_platform_type=TRIM(s_single_platform_type)
       s_header_linedata_vec(jj)=TRIM(s_header_platform_type)
c*****
c      10.platform_sub_type
       jj=10
       s_header_platform_sub_type=TRIM(s_single_platform_sub_type)
       s_header_linedata_vec(jj)=TRIM(s_header_platform_sub_type)
c*****
c      11.primary_station_id
       jj=11
       s_header_primary_station_id=s_primary_id
       s_header_linedata_vec(jj)=TRIM(s_header_primary_station_id)
c*****
c      12.station_record_number
       jj=12
       s_header_station_record_number=s_single_record_number
       s_header_linedata_vec(jj)=s_header_station_record_number
c*****
c      13.primary_station_id_scheme
       jj=13
       s_header_primary_station_id_scheme=
     +    s_single_primary_station_id_scheme 
       s_header_linedata_vec(jj)=s_header_primary_station_id_scheme
c*****
c      14.longitude
       jj=14
       s_header_longitude=s_single_longitude
       s_header_linedata_vec(jj)=s_header_longitude
c*****
c      15.latitude
       jj=15
       s_header_latitude=s_single_latitude
       s_header_linedata_vec(jj)=s_header_latitude
c*****
c      16.location_accuracy
       jj=16
       s_header_location_accuracy=s_single_location_accuracy
       s_header_linedata_vec(jj)=s_header_location_accuracy
c*****
c      17.location_method
       jj=17
       s_header_location_method=s_single_location_method
       s_header_linedata_vec(jj)=s_header_location_method
c*****
c      18.location_quality
       jj=18
       s_header_location_quality=s_single_location_quality
       s_header_linedata_vec(jj)=s_header_location_quality
c*****
c      19.crs
       jj=19
       s_header_crs=s_single_station_crs
       s_header_linedata_vec(jj)=s_header_crs
c*****
c      20.station_speed
       jj=20
       s_header_station_speed='NULL'
       s_header_linedata_vec(jj)=s_header_station_speed
c*****
c      21.station_course
       jj=21
       s_header_station_course='NULL'
       s_header_linedata_vec(jj)=s_header_station_course
c*****
c      22.station_heading
       jj=22
       s_header_station_heading='NULL'
       s_header_linedata_vec(jj)=s_header_station_heading
c*****
c      23.height_of_station_above_local_ground
       jj=23
       s_header_height_of_station_above_local_ground=
     +   s_single_height_station_above_local_ground
       s_header_linedata_vec(jj)=
     +   s_header_height_of_station_above_local_ground
c*****
c      24.height_of_station_above_sea_level
       jj=24
       s_header_height_of_station_above_sea_level=
     +   s_single_height_station_above_sea_level
       s_header_linedata_vec(jj)=
     +   s_header_height_of_station_above_sea_level
c*****
c      25.height_of_station_above_sea_level_accuracy
       jj=25
       s_header_height_of_station_above_sea_level_accuracy=
     +   s_single_height_station_above_sea_level_acc
       s_header_linedata_vec(jj)=
     +   s_header_height_of_station_above_sea_level_accuracy
c*****
c      26.sea_level_datum
       jj=26
       s_header_sea_level_datum=s_single_sea_level_datum
       s_header_linedata_vec(jj)=s_header_sea_level_datum
c*****
c      27.report_meaning_of_timestamp (daily=monthly=1; synop=2)
       jj=27
       s_header_report_meaning_of_timestamp='2'  !1=beginning, 2=end, 3=middle
       s_header_linedata_vec(jj)=s_header_report_meaning_of_timestamp
c*****
c      28.report_timestamp
       jj=28
       s_header_report_timestamp=
     +   s_date_reconstruct_yyyy_mm_dd//' '//
     +   s_time_reconstruct_hh_mm_ss//s_time_offset
       s_header_linedata_vec(jj)=s_header_report_timestamp
c*****
c      29.report_duration
       jj=29
       s_header_report_duration='0'   !hardwire code 0 for instantaneous
       s_header_linedata_vec(jj)=s_header_report_duration
c*****
c      30.report_time_accuracy
       jj=30
       s_header_report_time_accuracy=''
       s_header_linedata_vec(jj)=s_header_report_time_accuracy
c*****
c      31.report_time_quality
       jj=31
       s_header_report_time_quality=''
       s_header_linedata_vec(jj)=s_header_report_time_quality
c*****
c      32.report_time_reference
       jj=32
       s_header_report_time_reference='0'   !0 is unknown
       s_header_linedata_vec(jj)=s_header_report_time_reference
c*****
c      33.profile_id
       jj=33
       s_header_profile_id=''
       s_header_linedata_vec(jj)=s_header_profile_id
c*****
c      34.events_at_station
       jj=34
       s_header_events_at_station=''
       s_header_linedata_vec(jj)=s_header_events_at_station
c*****
c      35.report_quality
       jj=35
       s_header_report_quality=''
       s_header_linedata_vec(jj)=s_header_report_quality
c*****
c      36.duplicate_status
       jj=36
       s_header_duplicate_status='4'    !4 means unchecked
       s_header_linedata_vec(jj)=s_header_duplicate_status
c*****
c      37.duplicates
       jj=37
       s_header_duplicates=''
       s_header_linedata_vec(jj)=s_header_duplicates
c*****
c      38.record_timestamp
       jj=38
       s_header_record_timestamp=
     +   s_record_year//'-'//s_record_month//'-'//s_record_day//' '//
     +   s_record_hour//':'//s_record_minute//':'//s_record_second//
     +   s_record_zone
       s_header_linedata_vec(jj)=TRIM(s_header_record_timestamp)
c*****
c      39.history
       jj=39
       s_header_history=''
       s_header_linedata_vec(jj)=s_header_history
c*****
c      40.processing_level
       jj=40
       s_header_processing_level='0'
       s_header_linedata_vec(jj)=s_header_processing_level
c*****
c      41.processing_codes
       jj=41
       s_header_processing_codes=''
       s_header_linedata_vec(jj)=s_header_processing_codes
c*****
c      42.source_id
       jj=42
       s_header_source_id=s_single_source_id
       s_header_linedata_vec(jj)=s_header_source_id
c*****
c      43.source_record_id
       jj=43
       s_header_source_record_id='NULL'
       s_header_linedata_vec(jj)=s_header_source_record_id
c*****
c*****
c      String all fields together
       s_header_linedata_assemble_pre=''
       DO k=1,l_col_header
        s_header_linedata_assemble_pre=
     +    TRIM( s_header_linedata_assemble_pre)//
     +    TRIM(s_header_linedata_vec(k))//'|'
       ENDDO 

c      Convert integer to string for line length
       i_linedata_len=LEN_TRIM(s_header_linedata_assemble_pre)
       WRITE(s_linedata_len,'(i4)') i_linedata_len

c      Clip final pipe
       s_header_linedata_assemble=
     +   s_header_linedata_assemble_pre(1:i_linedata_len-1)

c       print*,'i_linedata_len=',i_linedata_len,'='//s_linedata_len//'='
       IF (i_linedata_len.GE.1000) THEN 
        STOP 'write_header_obs_table; i_linedata_len>limit'
       ENDIF
c******
c     Output header data line
      s_fmt1='a'//TRIM(ADJUSTL(s_linedata_len))
      WRITE(2,'('//s_fmt1//')') 
     +   ADJUSTL(s_header_linedata_assemble)   !good

c      WRITE(2,'('//s_fmt_header_title//')') 
c     +   ADJUSTL(s_header_title_assemble)   !good

c      print*,'s_fmt1=',s_fmt1 

c     INCREMENT LINE COUNTER HERE (number lines in observation file)
       n_lines_header=n_lines_header+1

c       STOP 'test i_linedata_len'
c*****
c*****
      GOTO 25

c       Print info to screen 
       CALL sample_screenprint_header(
     +  s_header_report_id,s_header_region,
     +  s_header_sub_region,s_header_application_area,
     +  s_header_observing_programme,s_header_report_type,
     +  s_header_station_name,s_header_station_type,
     +  s_header_platform_type,s_header_platform_sub_type,
     +  s_header_primary_station_id,s_header_station_record_number,
     +  s_header_primary_station_id_scheme,s_header_longitude,
     +  s_header_latitude,s_header_location_accuracy,
     +  s_header_location_method,s_header_location_quality,
     +  s_header_crs,s_header_station_speed,
     +  s_header_station_course,s_header_station_heading,
     +  s_header_height_of_station_above_local_ground,
     +  s_header_height_of_station_above_sea_level,
     +  s_header_height_of_station_above_sea_level_accuracy,
     +  s_header_sea_level_datum,s_header_report_meaning_of_timestamp,
     +  s_header_report_timestamp,s_header_report_duration,
     +  s_header_report_time_accuracy,s_header_report_time_quality,
     +  s_header_report_time_reference,s_header_profile_id,
     +  s_header_events_at_station,s_header_report_quality,
     +  s_header_duplicate_status,s_header_duplicates,
     +  s_header_record_timestamp,s_header_history,
     +  s_header_processing_level,s_header_processing_codes,
     +  s_header_source_id,s_header_source_record_id,
     +  s_header_linedata_assemble)

      STOP 'header_obs_lite_qff20201120'

 25   CONTINUE

c*****

c       STOP 'header_obs_lite_qff'
c******
c******


c*****
 73    CONTINUE   !entry point for bad record number
c*****
       ENDDO   !close j cycling through distinct report numbers
c*****
 52    CONTINUE   !exit point on discovery that line has no data
c*****
c*****
c************************************************************************
c************************************************************************
      ENDDO    !close i cycling through data lines
c************************************************************************
c************************************************************************
 91   CONTINUE

      CLOSE(UNIT=2)
      CLOSE(UNIT=3)
      CLOSE(UNIT=4)
      CLOSE(UNIT=5)
c***********************************************************************
c      GOTO 53

c     zip finished files

      s_command='gzip -f '//TRIM(s_pathandname_header)
      print*,'s_command=',TRIM(s_command) 
      CALL SYSTEM(s_command,io)

c      print*,'cleared gzip header'

      s_command='gzip -f '//TRIM(s_pathandname_obs)
      print*,'s_command=',TRIM(s_command) 
      CALL SYSTEM(s_command,io)

c      print*,'cleared gzip obs'

      s_command='gzip -f '//TRIM(s_pathandname_lite)
      print*,'s_command=',TRIM(s_command) 
      CALL SYSTEM(s_command,io)

c      print*,'cleared gzip lite'

 53   CONTINUE
c***********************************************************************
      print*,'n_lines_obs=',   n_lines_obs
      print*,'n_lines_header=',n_lines_header
      print*,'n_lines_lite=',  n_lines_lite
      print*,'n_lines_qcmethod=',n_lines_qcmethod

c      print*,'date_st=',(s_arch_date_st_yyyy_mm_dd(1,j),j=1,l_varselect)
c      print*,'date_en=',(s_arch_date_en_yyyy_mm_dd(1,j),j=1,l_varselect)

c      print*,'date2st',(s_arch2_date_st_yyyy_mm_dd(1,j),j=1,l_varselect)
c      print*,'date2en',(s_arch2_date_en_yyyy_mm_dd(1,j),j=1,l_varselect)

c     New stnconfig file
      CALL make_new_stnconfig_qff(s_directory_output_receipt,
     + s_stnname_isolated,
     + l_varselect,s_code_observation,
     + l_cc_rgh,l_collect_cnt,l_scoutput_numfield,ilen,
     + s_scoutput_vec_header,s_collect_datalines,
     + i_arch_cnt,s_arch2_date_st_yyyy_mm_dd,s_arch2_date_en_yyyy_mm_dd)

c     Receipt file with line counts
      CALL make_receiptfile_linecount(
     +  s_directory_output_receipt_linecount,s_stnname_isolated,
     +  n_lines_obs,n_lines_header,n_lines_lite,n_lines_qcmethod)

      print*,'just leaving header_obs_lite_qff20200609'

c      STOP 'header_obs_lite_qff'

      RETURN
      END
