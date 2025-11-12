c     Call subroutine to do CDM conversion
c     AJ_Kettle, 10Dec2018
c     29May2019: new procedure for new format table
c     01Nov2019: modified to include lite
c     18Apr2019: updated tables for 01May2020
c     23Apr2019: modified file creation to replace any existing file
c     15Dec2020: modified file to include qcmethod flags

c*****
c     Subroutines called
c     header_obs_lite_table
c     -sort_vec_obs_ancillary_ghcd2
c     -find_vector_recordnumber2
c     -assemble_vec_original_precision2
c     -get_numerical_precision2
c     -get_quality_flag_vector2
c      -qc_single_variable2
c     -get_observationvalue_vector2
c      -convert_float_to_string_single2
c     -get_hght_obs_above_sfc
c     -get_strvector_distinct
c     -export_stnconfig_lines
c*****

      SUBROUTINE header_obs_lite_table20201215(f_ndflag,
     +  s_directory_output_header,s_directory_output_observation,
     +  s_directory_output_lite,
     +  s_directory_output_receipt,
     +  s_directory_output_qc,s_directory_output_receipt_linecount,
     +  s_stnname_single,
     +  s_date_st,s_time_st,s_zone_st,
     +  l_timestamp_rgh,l_timestamp,
     +  s_distinct_date_yyyymmdd,
     +  l_collect_cnt,l_collect_distinct,

     +  s_collect_primary_id,s_collect_record_number,
     +  s_collect_secondary_id,s_collect_station_name,
     +  s_collect_longitude,s_collect_latitude,
     +  s_collect_height_station_above_sea_level,
     +  s_collect_data_policy_licence,s_collect_source_id,

     +  s_collect_region,s_collect_operating_territory,
     +  s_collect_station_type,s_collect_platform_type,
     +  s_collect_platform_sub_type,s_collect_primary_station_id_scheme,
     +  s_collect_location_accuracy,s_collect_location_method,
     +  s_collect_location_quality,s_collect_station_crs,
     +  s_collect_height_station_above_local_ground,
     +  s_collect_height_station_above_sea_level_acc,
     +  s_collect_sea_level_datum,

     +  s_collect_datalines,s_scoutput_vec_header,l_scoutput_numfield,

     +  f_prcp_datavalue_mm,f_tmin_datavalue_c,f_tmax_datavalue_c,
     +  f_tavg_datavalue_c,f_snwd_datavalue_mm,f_snow_datavalue_mm,
     +  f_awnd_datavalue_ms,f_awdr_datavalue_deg,f_wesd_datavalue_mm,
     +  s_prcp_datavalue_mm,s_tmin_datavalue_c,s_tmax_datavalue_c,
     +  s_tavg_datavalue_c,s_snwd_datavalue_mm,s_snow_datavalue_mm,
     +  s_awnd_datavalue_ms,s_awdr_datavalue_deg,s_wesd_datavalue_mm,
     +  s_prcp_datavalue,s_tmin_datavalue,s_tmax_datavalue,
     +  s_tavg_datavalue,s_snwd_datavalue,s_snow_datavalue,
     +  s_awnd_datavalue,s_awdr_datavalue,s_wesd_datavalue,
     +  s_prcp_sflag,s_tmin_sflag,s_tmax_sflag,
     +  s_tavg_sflag,s_snwd_sflag,s_snow_sflag,
     +  s_awnd_sflag,s_awdr_sflag,s_wesd_sflag,
     +  s_prcp_qflag,s_tmin_qflag,s_tmax_qflag,
     +  s_tavg_qflag,s_snwd_qflag,s_snow_qflag,
     +  s_awnd_qflag,s_awdr_qflag,s_wesd_qflag,
     +  s_prcp_sourceid,s_tmin_sourceid,s_tmax_sourceid,
     +  s_tavg_sourceid,s_snwd_sourceid,s_snow_sourceid,
     +  s_awnd_sourceid,s_awdr_sourceid,s_wesd_sourceid,
     +  s_prcp_recordnumber,s_tmin_recordnumber,s_tmax_recordnumber,
     +  s_tavg_recordnumber,s_snwd_recordnumber,s_snow_recordnumber,
     +  s_awnd_recordnumber,s_awdr_recordnumber,s_wesd_recordnumber,
     +  s_prec_empir_prcp_mm,s_prec_empir_tmin_c,s_prec_empir_tmax_c,
     +  s_prec_empir_tavg_c,s_prec_empir_snwd_mm,s_prec_empir_snow_mm,
     +  s_prec_empir_awnd_ms,s_prec_empir_awdr_deg,s_prec_empir_wesd_mm,

     +    s_prcp_cdmqc,s_tmin_cdmqc,s_tmax_cdmqc,
     +    s_tavg_cdmqc,s_snwd_cdmqc,s_snow_cdmqc,
     +    s_awnd_cdmqc,s_awdr_cdmqc,s_wesd_cdmqc,
     +    s_prcp_cdmqcmethod,s_tmin_cdmqcmethod,s_tmax_cdmqcmethod,
     +    s_tavg_cdmqcmethod,s_snwd_cdmqcmethod,s_snow_cdmqcmethod,
     +    s_awnd_cdmqcmethod,s_awdr_cdmqcmethod,s_wesd_cdmqcmethod)

      IMPLICIT NONE
c************************************************************************
c     Declare variables passed into subroutine

      REAL                :: f_ndflag

      CHARACTER(LEN=300)  :: s_directory_output_header
      CHARACTER(LEN=300)  :: s_directory_output_observation
      CHARACTER(LEN=300)  :: s_directory_output_lite
      CHARACTER(LEN=300)  :: s_directory_output_receipt
      CHARACTER(LEN=300)  :: s_directory_output_qc
      CHARACTER(LEN=300)  :: s_directory_output_receipt_linecount

      CHARACTER(LEN=12)   :: s_stnname_single

      CHARACTER(LEN=8)    :: s_date_st
      CHARACTER(LEN=10)   :: s_time_st
      CHARACTER(LEN=5)    :: s_zone_st

      INTEGER             :: l_timestamp_rgh
      INTEGER             :: l_timestamp

      CHARACTER(LEN=8)    :: s_distinct_date_yyyymmdd(l_timestamp_rgh)

      INTEGER             :: l_collect_cnt
      INTEGER             :: l_collect_distinct

c      CHARACTER(LEN=*)    :: s_collect_station_id(20)          !12
c      CHARACTER(LEN=*)    :: s_collect_record_number(20)       !2
c      CHARACTER(LEN=*)    :: s_collect_latitude(20)            !10
c      CHARACTER(LEN=*)    :: s_collect_longitude(20)           !10
c      CHARACTER(LEN=*)    :: s_collect_data_policy_licence(20) !3
c      CHARACTER(LEN=*)    :: s_collect_source_id(20)           !3

c     2019/06/10: modified to get lengths from outside
      CHARACTER(LEN=*)    :: s_collect_primary_id(20)
      CHARACTER(LEN=*)    :: s_collect_record_number(20)
      CHARACTER(LEN=*)    :: s_collect_secondary_id(20)
      CHARACTER(LEN=*)    :: s_collect_station_name(20)
      CHARACTER(LEN=*)    :: s_collect_longitude(20)
      CHARACTER(LEN=*)    :: s_collect_latitude(20)
      CHARACTER(LEN=*)   :: s_collect_height_station_above_sea_level(20)
      CHARACTER(LEN=*)    :: s_collect_data_policy_licence(20)
      CHARACTER(LEN=*)    :: s_collect_source_id(20)

c     Variables originally from stnconfig-write
      CHARACTER(LEN=*)    :: s_collect_region(20)
      CHARACTER(LEN=*)    :: s_collect_operating_territory(20)
      CHARACTER(LEN=*)    :: s_collect_station_type(20)
      CHARACTER(LEN=*)    :: s_collect_platform_type(20)
      CHARACTER(LEN=*)    :: s_collect_platform_sub_type(20)
      CHARACTER(LEN=*)    :: s_collect_primary_station_id_scheme(20)
      CHARACTER(LEN=*)    :: s_collect_location_accuracy(20)
      CHARACTER(LEN=*)    :: s_collect_location_method(20)
      CHARACTER(LEN=*)    :: s_collect_location_quality(20)
      CHARACTER(LEN=*)    :: s_collect_station_crs(20)
      CHARACTER(LEN=*)    ::
     +    s_collect_height_station_above_local_ground(20)
      CHARACTER(LEN=*)    ::
     +    s_collect_height_station_above_sea_level_acc(20)
      CHARACTER(LEN=*)    :: s_collect_sea_level_datum(20)

c     Matrix archive to rebuild station_config
      CHARACTER(LEN=*)    :: s_collect_datalines(20,50)
      CHARACTER(LEN=*)    :: s_scoutput_vec_header(50) !50
      INTEGER             :: l_scoutput_numfield

      REAL                :: f_prcp_datavalue_mm(l_timestamp_rgh)
      REAL                :: f_tmin_datavalue_c(l_timestamp_rgh)
      REAL                :: f_tmax_datavalue_c(l_timestamp_rgh)
      REAL                :: f_tavg_datavalue_c(l_timestamp_rgh)
      REAL                :: f_snwd_datavalue_mm(l_timestamp_rgh)
      REAL                :: f_snow_datavalue_mm(l_timestamp_rgh)
      REAL                :: f_awnd_datavalue_ms(l_timestamp_rgh)
      REAL                :: f_awdr_datavalue_deg(l_timestamp_rgh)
      REAL                :: f_wesd_datavalue_mm(l_timestamp_rgh)

      CHARACTER(LEN=*)    :: s_prcp_datavalue_mm(l_timestamp_rgh)  !len=10
      CHARACTER(LEN=*)    :: s_tmin_datavalue_c(l_timestamp_rgh)
      CHARACTER(LEN=*)    :: s_tmax_datavalue_c(l_timestamp_rgh)
      CHARACTER(LEN=*)    :: s_tavg_datavalue_c(l_timestamp_rgh)
      CHARACTER(LEN=*)    :: s_snwd_datavalue_mm(l_timestamp_rgh)
      CHARACTER(LEN=*)    :: s_snow_datavalue_mm(l_timestamp_rgh)
      CHARACTER(LEN=*)    :: s_awnd_datavalue_ms(l_timestamp_rgh)
      CHARACTER(LEN=*)    :: s_awdr_datavalue_deg(l_timestamp_rgh)
      CHARACTER(LEN=*)    :: s_wesd_datavalue_mm(l_timestamp_rgh)

      CHARACTER(LEN=*)    :: s_prcp_datavalue(l_timestamp_rgh)     !len=5
      CHARACTER(LEN=*)    :: s_tmin_datavalue(l_timestamp_rgh)
      CHARACTER(LEN=*)    :: s_tmax_datavalue(l_timestamp_rgh)
      CHARACTER(LEN=*)    :: s_tavg_datavalue(l_timestamp_rgh)
      CHARACTER(LEN=*)    :: s_snwd_datavalue(l_timestamp_rgh)
      CHARACTER(LEN=*)    :: s_snow_datavalue(l_timestamp_rgh)
      CHARACTER(LEN=*)    :: s_awnd_datavalue(l_timestamp_rgh)
      CHARACTER(LEN=*)    :: s_awdr_datavalue(l_timestamp_rgh)
      CHARACTER(LEN=*)    :: s_wesd_datavalue(l_timestamp_rgh)

      CHARACTER(LEN=*)    :: s_prcp_sflag(l_timestamp_rgh)         !len=1
      CHARACTER(LEN=*)    :: s_tmin_sflag(l_timestamp_rgh)
      CHARACTER(LEN=*)    :: s_tmax_sflag(l_timestamp_rgh)
      CHARACTER(LEN=*)    :: s_tavg_sflag(l_timestamp_rgh)
      CHARACTER(LEN=*)    :: s_snwd_sflag(l_timestamp_rgh)
      CHARACTER(LEN=*)    :: s_snow_sflag(l_timestamp_rgh)
      CHARACTER(LEN=*)    :: s_awnd_sflag(l_timestamp_rgh)
      CHARACTER(LEN=*)    :: s_awdr_sflag(l_timestamp_rgh)
      CHARACTER(LEN=*)    :: s_wesd_sflag(l_timestamp_rgh)

      CHARACTER(LEN=1)    :: s_prcp_qflag(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_tmin_qflag(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_tmax_qflag(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_tavg_qflag(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_snwd_qflag(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_snow_qflag(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_awnd_qflag(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_awdr_qflag(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_wesd_qflag(l_timestamp_rgh)

      CHARACTER(LEN=3)    :: s_prcp_sourceid(l_timestamp_rgh)
      CHARACTER(LEN=3)    :: s_tmin_sourceid(l_timestamp_rgh)
      CHARACTER(LEN=3)    :: s_tmax_sourceid(l_timestamp_rgh)
      CHARACTER(LEN=3)    :: s_tavg_sourceid(l_timestamp_rgh)
      CHARACTER(LEN=3)    :: s_snwd_sourceid(l_timestamp_rgh)
      CHARACTER(LEN=3)    :: s_snow_sourceid(l_timestamp_rgh)
      CHARACTER(LEN=3)    :: s_awnd_sourceid(l_timestamp_rgh)
      CHARACTER(LEN=3)    :: s_awdr_sourceid(l_timestamp_rgh)
      CHARACTER(LEN=3)    :: s_wesd_sourceid(l_timestamp_rgh)

      CHARACTER(LEN=*)    :: s_prcp_recordnumber(l_timestamp_rgh) !len=3
      CHARACTER(LEN=*)    :: s_tmin_recordnumber(l_timestamp_rgh)
      CHARACTER(LEN=*)    :: s_tmax_recordnumber(l_timestamp_rgh)
      CHARACTER(LEN=*)    :: s_tavg_recordnumber(l_timestamp_rgh)
      CHARACTER(LEN=*)    :: s_snwd_recordnumber(l_timestamp_rgh)
      CHARACTER(LEN=*)    :: s_snow_recordnumber(l_timestamp_rgh)
      CHARACTER(LEN=*)    :: s_awnd_recordnumber(l_timestamp_rgh)
      CHARACTER(LEN=*)    :: s_awdr_recordnumber(l_timestamp_rgh)
      CHARACTER(LEN=*)    :: s_wesd_recordnumber(l_timestamp_rgh)

      CHARACTER(LEN=*)    :: s_prec_empir_prcp_mm                 !len=10
      CHARACTER(LEN=*)    :: s_prec_empir_tmin_c
      CHARACTER(LEN=*)    :: s_prec_empir_tmax_c
      CHARACTER(LEN=*)    :: s_prec_empir_tavg_c
      CHARACTER(LEN=*)    :: s_prec_empir_snwd_mm
      CHARACTER(LEN=*)    :: s_prec_empir_snow_mm
      CHARACTER(LEN=*)    :: s_prec_empir_awnd_ms
      CHARACTER(LEN=*)    :: s_prec_empir_awdr_deg
      CHARACTER(LEN=*)    :: s_prec_empir_wesd_mm

c*****
c     CDM qc method
c     11Dec2020: extra variables included for qc pivot table

      CHARACTER(LEN=1)    :: s_prcp_cdmqc(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_tmin_cdmqc(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_tmax_cdmqc(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_tavg_cdmqc(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_snwd_cdmqc(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_snow_cdmqc(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_awnd_cdmqc(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_awdr_cdmqc(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_wesd_cdmqc(l_timestamp_rgh)

      CHARACTER(LEN=2)    :: s_prcp_cdmqcmethod(l_timestamp_rgh)
      CHARACTER(LEN=2)    :: s_tmin_cdmqcmethod(l_timestamp_rgh)
      CHARACTER(LEN=2)    :: s_tmax_cdmqcmethod(l_timestamp_rgh)
      CHARACTER(LEN=2)    :: s_tavg_cdmqcmethod(l_timestamp_rgh)
      CHARACTER(LEN=2)    :: s_snwd_cdmqcmethod(l_timestamp_rgh)
      CHARACTER(LEN=2)    :: s_snow_cdmqcmethod(l_timestamp_rgh)
      CHARACTER(LEN=2)    :: s_awnd_cdmqcmethod(l_timestamp_rgh)
      CHARACTER(LEN=2)    :: s_awdr_cdmqcmethod(l_timestamp_rgh)
      CHARACTER(LEN=2)    :: s_wesd_cdmqcmethod(l_timestamp_rgh)
c*****
c*****
c     Variables used within program

      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: i1

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
c     9 different kinds of variables; 9 channels
      INTEGER, PARAMETER  :: l_channel=9
      CHARACTER(LEN=3)    :: s_code_observation(l_channel)
      CHARACTER(LEN=3)    :: s_code_unit(l_channel)
      CHARACTER(LEN=3)    :: s_value_significance(l_channel)
      CHARACTER(LEN=3)    :: s_code_unit_original(l_channel)
      CHARACTER(LEN=3)    :: s_code_conversion_method(l_channel)
      CHARACTER(LEN=3)    :: s_code_conversion_flag(l_channel)
      CHARACTER(LEN=3)    :: s_code_observation_duration(l_channel)
      CHARACTER(LEN=10)   :: s_vec_original_value(l_channel)
      CHARACTER(LEN=10)   :: s_vec_observation_value(l_channel)
      CHARACTER(LEN=1)    :: s_vec_qc_code(l_channel)
      CHARACTER(LEN=1)    :: s_vec_qc_code_check(l_channel)
      CHARACTER(LEN=2)    :: s_vec_qcmethod_code(l_channel)
      CHARACTER(LEN=10)   :: s_vec_original_prec(l_channel)
      CHARACTER(LEN=10)   :: s_vec_numerical_precision(l_channel)
      REAL                :: f_vec_original_value(l_channel)
      CHARACTER(LEN=2)    :: s_vec_recordnumber(l_channel)    !changed from 3 to 2
      CHARACTER(LEN=10)   :: s_vec_hgt_obs_above_sfc(l_channel)

      INTEGER             :: i_vec_cnt_channelexported(l_channel)

c     header info
      INTEGER             :: l_col_header
      CHARACTER(LEN=50)   :: s_header_titlevec(100)       !changed from 22 to 100
      CHARACTER(LEN=1000) :: s_header_title_assemble_pre
      CHARACTER(LEN=1000) :: s_header_title_assemble
      INTEGER             :: i_len_header_title
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

c     qcmethod info
      INTEGER             :: l_col_qcmethod
      CHARACTER(LEN=50)   :: s_qcmethod_titlevec(100)
      CHARACTER(LEN=1000) :: s_qcmethod_title_assemble_pre
      CHARACTER(LEN=1000) :: s_qcmethod_title_assemble
      INTEGER             :: i_len_qcmethod_title
      CHARACTER(LEN=4)    :: s_len_qcmethod_title

c*****
      INTEGER             :: i_filenumber
      CHARACTER(LEN=3)    :: s_filenumber

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

      CHARACTER(LEN=10)   :: s_fmt,s_fmt1
      CHARACTER(LEN=10)   :: s_fmt_header_title    !format string for title output
      CHARACTER(LEN=10)   :: s_fmt_obs_title
      CHARACTER(LEN=10)   :: s_fmt_lite_title
      CHARACTER(LEN=10)   :: s_fmt_qcmethod_title
c*****
c     Archive of first & last dates of station file
      CHARACTER(LEN=50)   :: s_obs_date_time_st
      CHARACTER(LEN=50)   :: s_obs_date_time_en
      DOUBLE PRECISION    :: d_obs_jtime
      DOUBLE PRECISION    :: d_obs_jtime_min
      DOUBLE PRECISION    :: d_obs_jtime_max

c     Archive of first & last dates of station file by the record list
      CHARACTER(LEN=50)   :: s_record_date_time_st_byreport(20)
      CHARACTER(LEN=50)   :: s_record_date_time_en_byreport(20)
      INTEGER             :: i_record_hist_channel(20,9)
      INTEGER             :: i_record_hist_integrate(20)

      DOUBLE PRECISION    :: d_record_jtime_min_byreport(20)
      DOUBLE PRECISION    :: d_record_jtime_max_byreport(20)

c*****
      INTEGER             :: n_lines_obs
      INTEGER             :: n_lines_header
      INTEGER             :: n_lines_lite
      INTEGER             :: n_lines_qcmethod

      INTEGER             :: i_collect_populated_recnum(20)
      INTEGER             :: i_collect2d_populated_recnum(20,9)

c     Preliminary variables
      CHARACTER(LEN=10)   :: s_date_single
      CHARACTER(LEN=4)    :: s_year
      CHARACTER(LEN=2)    :: s_month
      CHARACTER(LEN=2)    :: s_day

      CHARACTER(LEN=10)   :: s_date_reconstruct
      CHARACTER(LEN=8)    :: s_time_reconstruct
      CHARACTER(LEN=5)    :: s_time_reconstruct_short
      CHARACTER(LEN=3)    :: s_time_offset

c      CHARACTER(LEN=2)    :: s_single_record_number     !changed from 3 to 2
c      CHARACTER(LEN=3)    :: s_single_source_id
c      CHARACTER(LEN=3)    :: s_single_policylicence
c      CHARACTER(LEN=10)   :: s_single_latitude
c      CHARACTER(LEN=10)   :: s_single_longitude

      CHARACTER(LEN=50)   :: s_single_primary_id
      CHARACTER(LEN=50)   :: s_single_record_number
      CHARACTER(LEN=50)   :: s_single_secondary_id
      CHARACTER(LEN=50)   :: s_single_station_name
      CHARACTER(LEN=50)   :: s_single_longitude
      CHARACTER(LEN=50)   :: s_single_latitude
      CHARACTER(LEN=50)   :: s_single_height_station_above_sea_level
      CHARACTER(LEN=50)   :: s_single_data_policy_licence
      CHARACTER(LEN=50)   :: s_single_source_id

      CHARACTER(LEN=1000) :: s_single_region
      CHARACTER(LEN=1000) :: s_single_operating_territory
      CHARACTER(LEN=1000) :: s_single_station_type
      CHARACTER(LEN=1000) :: s_single_platform_type
      CHARACTER(LEN=1000) :: s_single_platform_sub_type
      CHARACTER(LEN=1000) :: s_single_primary_station_id_scheme
      CHARACTER(LEN=1000) :: s_single_location_accuracy
      CHARACTER(LEN=1000) :: s_single_location_method
      CHARACTER(LEN=1000) :: s_single_location_quality
      CHARACTER(LEN=1000) :: s_single_station_crs
      CHARACTER(LEN=1000) :: s_single_height_station_above_local_ground
      CHARACTER(LEN=1000) :: s_single_height_station_above_sea_level_acc
      CHARACTER(LEN=1000) :: s_single_sea_level_datum

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
      CHARACTER(LEN=50)   :: s_header_height_of_station_above_sea_level  !24 (from stnconfig)
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

c     Individual data fields for observation 
c     NOTE: new column at 46 for 01May2020 release
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
      CHARACTER(LEN=50)   :: s_obs_advanced_assimilation_feedback  !46  new for 01May release
      CHARACTER(LEN=50)   :: s_obs_source_id                       !47  from stnconfig file
c*****
c     Individual data fields for qc
      CHARACTER(LEN=50)   :: s_qcmethod_observation_id             !1
      CHARACTER(LEN=50)   :: s_qcmethod_report_id                  !2
      CHARACTER(LEN=50)   :: s_qcmethod_qc_method                  !3
      CHARACTER(LEN=50)   :: s_qcmethod_quality_flag               !4
c*****
c     Individual fields for lite
c     NOTE: 19 columns; 1 column extra from previous release
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

c     info for new stnconfig lines
      CHARACTER(LEN=50)   :: s_collect_datalines_new(20,50)

      CHARACTER(LEN=50)   :: s_single_date_time_byreport

      CHARACTER(LEN=4)    :: s_year_st,s_year_en
      CHARACTER(LEN=30)   :: s_collect_obscode_pre
      CHARACTER(LEN=30)   :: s_collect_obscode
      INTEGER             :: i_len

      CHARACTER(LEN=4)    :: s_vec_year_st(20)
      CHARACTER(LEN=4)    :: s_vec_year_en(20)
      CHARACTER(LEN=30)   :: s_vec_collect_obscode(20)

      CHARACTER(LEN=3)    :: s_vec_obscode_fulllist(l_channel)
      INTEGER             :: l_distinct
      CHARACTER(LEN=3)    :: s_vec_obscode_distinct(l_channel)

      CHARACTER(LEN=50)   :: s_collect_datalines_output(20,50)

      CHARACTER(LEN=300)  :: s_command
      INTEGER             :: io

      CHARACTER(LEN=2)    :: s_qc_single

c************************************************************************
      print*,'just entered header_obs_table_lite20201215'

c      print*,'s_directory_output_header=', 
c     +  TRIM(s_directory_output_header)
c      print*,'s_directory_output_observation',
c     +  TRIM(s_directory_output_observation)
c      print*,'s_directory_output_lite', 
c     +  TRIM(s_directory_output_lite)

c      print*,'l_collect_cnt=',l_collect_cnt
c      print*,'s_collect_operating_territory=',
c     +  ('|'//s_collect_operating_territory(i)//'=',i=1,l_collect_cnt)

c      STOP 'header_obs_table_lite20201215'
c************************************************************************
c     Preprocessing

      s_primary_id=TRIM(s_stnname_single)      !netplat
c      s_stnname_single=TRIM(s_fileuse_clip) !already passed into subroutine

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
c     Call subroutine to organize: 
c      s_code_observation, s_code_unit, s_value_significance, 
c      s_code_unit_original, s_conversion_method, s_conversion_flag
c      s_code_observation_duration
      CALL sort_vec_obs_ancillary_ghcnd2(l_channel,
     +  s_code_observation,s_code_unit,s_value_significance,
     +  s_code_unit_original,s_code_conversion_method,
     +  s_code_conversion_flag,s_code_observation_duration)

c      print*,'l_channel=',l_channel
c      print*,'s_code_observation_duration',
c     +  (s_code_observation_duration(i),i=1,l_channel)
c************************************************************************
c     Column headers - header

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
      s_header_titlevec(34) ='events_at_station'            !changed to 34 from 14
      s_header_titlevec(35) ='report_quality'               !changed to 35 from 15
      s_header_titlevec(36) ='duplicate_status'             !changed to 36 from 16
      s_header_titlevec(37) ='duplicates'                   !changed to 37 from 17
      s_header_titlevec(38) ='record_timestamp'             !changed to 38 from 18
      s_header_titlevec(39) ='history'                      !changed to 39 from 19
      s_header_titlevec(40) ='processing_level'             !changed to 40 from 20
      s_header_titlevec(41) ='processing_codes'             !changed to 41 from 21
      s_header_titlevec(42) ='source_id'                    !changed to 42 from 22
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
       STOP 'header_obs_lite_table2; i_len_title>limit'
      ENDIF
c*****
c     OBSERVATION

c     19Jun2019: changed from 46 to 47 because of error in template
c     01Nov2019: changed from 47 to 46; error in template corrected
c     18Apr2019: changed from 46 to 47 for 01May2020 release
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
      s_obs_titlevec(12)='observation_height_above_station_surface'  !changed to 12 from 9
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
      s_obs_titlevec(46)='advanced_assimilation_feedback' !new parameter 18Apr2020
      s_obs_titlevec(47)='source_id'                      !changed to 47 from 46; changed to 46 from 22

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
       STOP 'header_obs_lite_table2; i_len_obs_title>limit'
      ENDIF

c      print*,'s_header_title_assemble=',TRIM(s_header_title_assemble)
c      print*,'i_len_header_title=',i_len_header_title
c      print*,'s_obs_title_assemble=',TRIM(s_obs_title_assemble)
c      print*,'i_len_obs_title=',i_len_obs_title
c*****
c     LITE

c     23Dec2020: changes from 18 to 19
      l_col_lite=19 !18

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
       STOP 'header_obs_lite_table2; i_len_obs_title>limit'
      ENDIF
c*****
c     QCMETHOD

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
       STOP 'header_obs_lite_table20201215; i_len_qcmethod_title>limit'
      ENDIF

c      print*,'s_header_title_assemble=',TRIM(s_header_title_assemble)
c      print*,'i_len_header_title=',i_len_header_title
c      print*,'s_obs_title_assemble=',TRIM(s_obs_title_assemble)
c      print*,'i_len_obs_title=',i_len_obs_title
c      print*,'s_lite_title_assemble=',TRIM(s_lite_title_assemble)
c      print*,'i_len_lite_title=',i_len_lite_title

c************************************************************************
c     Define first file number (indices for the files of 50000 lines length)
      i_filenumber=1
      WRITE(s_filenumber,'(i3)') i_filenumber
c      s_filenumber='1'

c      print*,'i_filenumber=',i_filenumber
c      print*,'s_filenumber='//TRIM(ADJUSTL(s_filenumber))//'='  
c      STOP 'write_header_obs_table; i_filenumber'
c*****
c     Define file names and full output path
c     13Jun2019: modified to write filename without file number
      s_filename_header=
     +  'header_table_r202010_'//TRIM(s_stnname_single)//
     +  '.psv'
      s_filename_observation=
     +  'observation_table_r202010_'//TRIM(s_stnname_single)//
     +  '.psv'
      s_filename_lite=
     +  'CDM_lite_r202010_'//TRIM(s_stnname_single)//
     +  '.psv'
      s_filename_qc=
     +  'qc_definition_r202010_'//TRIM(s_stnname_single)//
     +  '.psv'

c      s_filename_header=
c     +  'header_table_BETA_'//TRIM(s_stnname_single)//
c     +  '_'//TRIM(ADJUSTL(s_filenumber))//'.psv'
c      s_filename_observation=
c     +  'observation_table_BETA_'//TRIM(s_stnname_single)//
c     +  '_'//TRIM(ADJUSTL(s_filenumber))//'.psv'

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

c      print*,'s_filename_header=',TRIM(s_filename_header)
c      print*,'s_filename_observation=',TRIM(s_filename_observation)

c      print*,'s_pathandname_header=',TRIM(s_pathandname_header)
c      print*,'s_pathandname_obs=',   TRIM(s_pathandname_obs)
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
      DO i=1,20
       s_record_date_time_st_byreport(i)='-999'
       s_record_date_time_en_byreport(i)='-999'
       DO j=1,l_channel
        i_record_hist_channel(i,j)=0
       ENDDO
      ENDDO
c************************************************************************
c      GOTO 10

      print*,'s_pathandname_header=',TRIM(s_pathandname_header)
      print*,'s_pathandname_obs=',   TRIM(s_pathandname_obs)
      print*,'s_pathandname_lite=',  TRIM(s_pathandname_lite)

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
c     Write header title
      s_fmt_header_title='a'//TRIM(ADJUSTL(s_len_header_title)) !s_fmt1
      WRITE(2,'('//s_fmt_header_title//')') 
     +   ADJUSTL(s_header_title_assemble)   !good

c     Write observation title
      s_fmt_obs_title='a'//TRIM(ADJUSTL(s_len_obs_title))       !s_fmt1
      WRITE(3,'('//s_fmt_obs_title//')') 
     +   ADJUSTL(s_obs_title_assemble)   !good

c     Write lite title
      s_fmt_lite_title='a'//TRIM(ADJUSTL(s_len_lite_title))       !s_fmt1
      WRITE(4,'('//s_fmt_lite_title//')') 
     +   ADJUSTL(s_lite_title_assemble)   !good

c     Write qc title
      s_fmt_qcmethod_title='a'//TRIM(ADJUSTL(s_len_qcmethod_title))       !s_fmt1
      WRITE(5,'('//s_fmt_qcmethod_title//')') 
     +   ADJUSTL(s_qcmethod_title_assemble)   !good
c************************************************************************
c     Initialization

      n_lines_obs     =0
      n_lines_header  =0
      n_lines_lite    =0
      n_lines_qcmethod=0

      d_obs_jtime_min=10.0**7
      d_obs_jtime_max=-10.0**7

      DO i=1,20
       d_record_jtime_min_byreport(i)=10.0**7
       d_record_jtime_max_byreport(i)=-10.0**7
      ENDDO
c************************************************************************
c     Cycle through time steps
      DO i=1,l_timestamp      !cycles through all lines of one station

c     Call subroutine to find which record numbers populated
c      print*,'just before find_vector_recordnumber'
      CALL find_vector_recordnumber2(l_collect_cnt,l_channel,
     +   s_collect_record_number,
     +   s_prcp_recordnumber(i),s_tmin_recordnumber(i),
     +   s_tmax_recordnumber(i),s_tavg_recordnumber(i),
     +   s_snwd_recordnumber(i),s_snow_recordnumber(i),
     +   s_awnd_recordnumber(i),s_awdr_recordnumber(i),
     +   s_wesd_recordnumber(i),
     +   i_collect_populated_recnum,s_vec_recordnumber)

c     Cycle through all known record numbers for the station
c     NOTE: information gets exported if it matches the record number
      DO i1=1,l_collect_cnt

c     Act if there are valid record numbers
c     Open condition for populated record number counter
c     Act only if record present within short collection
      IF (i_collect_populated_recnum(i1).GT.0) THEN 

c***** 
c       Preliminary variables
        s_date_single=s_distinct_date_yyyymmdd(i)
c        s_time_single=s_rec_time_hh_mm_ss(i)
        s_year  =s_date_single(1:4)
        s_month =s_date_single(5:6)
        s_day   =s_date_single(7:8)
c        s_hour  =s_time_single(1:2)
c        s_minute=s_time_single(4:5)
c        s_second=s_time_single(7:8)

        s_date_reconstruct=
     +    TRIM(s_year)//'-'//TRIM(s_month)//'-'//TRIM(s_day)
c        s_time_reconstruct=
c     +    TRIM(s_hour)//':'//TRIM(s_minute)//':'//TRIM(s_second)
c        s_time_reconstruct_short=
c     +    TRIM(s_hour)//':'//TRIM(s_minute)
        s_time_reconstruct='00:00:00'
        s_time_reconstruct_short='00:00'
        s_time_offset     ='+00'

        s_single_primary_id          =s_collect_primary_id(i1)
        s_single_record_number       =s_collect_record_number(i1)
        s_single_secondary_id        =s_collect_secondary_id(i1)
        s_single_station_name        =s_collect_station_name(i1)
        s_single_longitude           =s_collect_longitude(i1)
        s_single_latitude            =s_collect_latitude(i1)
        s_single_height_station_above_sea_level=
     +     s_collect_height_station_above_sea_level(i1)
        s_single_data_policy_licence =s_collect_data_policy_licence(i1)
        s_single_source_id           =s_collect_source_id(i1)

        s_single_region              =s_collect_region(i1)
        s_single_operating_territory =s_collect_operating_territory(i1)
        s_single_station_type        =s_collect_station_type(i1)
        s_single_platform_type       =s_collect_platform_type(i1)
        s_single_platform_sub_type   =s_collect_platform_sub_type(i1)
        s_single_primary_station_id_scheme=
     +     s_collect_primary_station_id_scheme(i1)
        s_single_location_accuracy   =s_collect_location_accuracy(i1)
        s_single_location_method     =s_collect_location_method(i1)
        s_single_location_quality    =s_collect_location_quality(i1)
        s_single_station_crs         =s_collect_station_crs(i1)
        s_single_height_station_above_local_ground=
     +     s_collect_height_station_above_local_ground(i1)
        s_single_height_station_above_sea_level_acc=
     +     s_collect_height_station_above_sea_level_acc(i1)
        s_single_sea_level_datum     =s_collect_sea_level_datum(i1)
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
     +     TRIM(s_day)
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
c*****
c      6. report_type
       jj=6
       s_header_report_type='3'    !0=subdaily except ICAO, 3=daily, 2=monthly, 4=ICAO subdaily
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
c*****
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
c      26.sea_leel_datum
       jj=26
       s_header_sea_level_datum=s_single_sea_level_datum
       s_header_linedata_vec(jj)=s_header_sea_level_datum
c*****
c      27.report_meaning_of_timestamp
       jj=27
       s_header_report_meaning_of_timestamp='1'
       s_header_linedata_vec(jj)=s_header_report_meaning_of_timestamp
c*****
c      28.report_timestamp
       jj=28
       s_header_report_timestamp=
     +   s_date_reconstruct//' '//s_time_reconstruct//s_time_offset
       s_header_linedata_vec(jj)=s_header_report_timestamp
c*****
c      29.report_duration
       jj=29
       s_header_report_duration='13'   !hardwire code 13 for 1day
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
       s_header_report_time_reference='0'
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
       s_header_duplicate_status='4'
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
c******
c      String all fields together
       s_header_linedata_assemble_pre=''
       DO j=1,l_col_header
        s_header_linedata_assemble_pre=
     +    TRIM( s_header_linedata_assemble_pre)//
     +    TRIM(s_header_linedata_vec(j))//'|'
       ENDDO 

       i_linedata_len=LEN_TRIM(s_header_linedata_assemble_pre)
       WRITE(s_linedata_len,'(i4)') i_linedata_len

c      Clip final pipe
       s_header_linedata_assemble=
     +   s_header_linedata_assemble_pre(1:i_linedata_len-1)

c       print*,'i_linedata_len=',i_linedata_len,'='//s_linedata_len//'='
       IF (i_linedata_len.GE.1000) THEN 
        STOP 'write_header_obs_table; i_linedata_len>limite'
       ENDIF
c******
c     Output header data line
      s_fmt='"(a'//TRIM(ADJUSTL(s_linedata_len))//')"'
      s_fmt1='a'//TRIM(ADJUSTL(s_linedata_len))
      WRITE(2,'('//s_fmt1//')') 
     +   ADJUSTL(s_header_linedata_assemble)   !good

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

 25   CONTINUE

c      CALL SLEEP(1)
c*****
c*****
c*****
c*****
c     Assemble vector for numerical precision
      CALL assemble_vec_original_precision2(l_channel,
     +  s_prec_empir_prcp_mm,s_prec_empir_tmin_c,
     +  s_prec_empir_tmax_c,s_prec_empir_tavg_c,
     +  s_prec_empir_snwd_mm,s_prec_empir_snow_mm,
     +  s_prec_empir_awnd_ms,s_prec_empir_awdr_deg,
     +  s_prec_empir_wesd_mm,
     +  s_vec_original_prec)

c     Assemble vector for numerical precision
      CALL assemble_vec_original_precision2(l_channel,
     +  s_prec_empir_prcp_mm,s_prec_empir_tmin_c,
     +  s_prec_empir_tmax_c,s_prec_empir_tavg_c,
     +  s_prec_empir_snwd_mm,s_prec_empir_snow_mm,
     +  s_prec_empir_awnd_ms,s_prec_empir_awdr_deg,
     +  s_prec_empir_wesd_mm,
     +  s_vec_original_prec)

c     Get numerical precision
      CALL get_numerical_precision2(l_channel,
     +   s_vec_original_prec,s_vec_numerical_precision)

c     Define quality flag
      CALL get_quality_flag_vector2(f_ndflag,l_channel,
     +  f_prcp_datavalue_mm(i),f_tmin_datavalue_c(i),
     +  f_tmax_datavalue_c(i),f_tavg_datavalue_c(i),
     +  f_snwd_datavalue_mm(i),f_snow_datavalue_mm(i),
     +  f_awnd_datavalue_ms(i),f_awdr_datavalue_deg(i),
     +  f_wesd_datavalue_mm(i),
     +  s_prcp_qflag(i),s_tmin_qflag(i),
     +  s_tmax_qflag(i),s_tavg_qflag(i),
     +  s_snwd_qflag(i),s_snow_qflag(i),
     +  s_awnd_qflag(i),s_awdr_qflag(i),
     +  s_wesd_qflag(i),
     +  s_vec_qc_code)

c     Define qcmethod vector
      CALL get_qcmethod_vector20201216(f_ndflag,l_channel,
     +  s_prcp_cdmqc(i),s_tmin_cdmqc(i),
     +  s_tmax_cdmqc(i),s_tavg_cdmqc(i),
     +  s_snwd_cdmqc(i),s_snow_cdmqc(i),
     +  s_awnd_cdmqc(i),s_awdr_cdmqc(i),
     +  s_wesd_cdmqc(i),
     +  s_prcp_cdmqcmethod(i),s_tmin_cdmqcmethod(i),
     +  s_tmax_cdmqcmethod(i),s_tavg_cdmqcmethod(i),
     +  s_snwd_cdmqcmethod(i),s_snow_cdmqcmethod(i),
     +  s_awnd_cdmqcmethod(i),s_awdr_cdmqcmethod(i),
     +  s_wesd_cdmqcmethod(i),
     +  s_vec_qc_code_check,s_vec_qcmethod_code)

c     Check new and old the qc flags
c      CALL qc_check_oldnew(l_channel,s_vec_qc_code,s_vec_qc_code_check)
c      print*,'qc_code',(s_vec_qc_code(ii),ii=1,l_channel)
c      print*,'qc_code_check',(s_vec_qc_code_check(ii),ii=1,l_channel)
c      STOP 'header_obs_lite_table20201215'

c     Define output variables
      CALL get_observationvalue_vector2(f_ndflag,l_channel,
     +  f_prcp_datavalue_mm(i),f_tmin_datavalue_c(i),
     +  f_tmax_datavalue_c(i),f_tavg_datavalue_c(i),
     +  f_snwd_datavalue_mm(i),f_snow_datavalue_mm(i),
     +  f_awnd_datavalue_ms(i),f_awdr_datavalue_deg(i),
     +  f_wesd_datavalue_mm(i),
     +  s_prcp_datavalue_mm(i),s_tmin_datavalue_c(i),
     +  s_tmax_datavalue_c(i),s_tavg_datavalue_c(i),
     +  s_snwd_datavalue_mm(i),s_snow_datavalue_mm(i),
     +  s_awnd_datavalue_ms(i),s_awdr_datavalue_deg(i),
     +  s_wesd_datavalue_mm(i),
     +  f_vec_original_value,s_vec_original_value,
     +  s_vec_observation_value)

c     Define height obs above surface
      CALL get_hght_obs_above_sfc(l_channel,
     +  s_vec_hgt_obs_above_sfc)

c*************************************************************************
c      OBSERVATION
c      Cycle through variables

       DO j=1,l_channel    !cycle through 9 possible variables

c      Act only if variable record number matches the one in the i1 index 
       IF (TRIM(s_vec_recordnumber(j)).EQ.TRIM(s_single_record_number))
     +   THEN 
c*************************************************************************
c      Main list variables

c******
c       1. observation_id
        jj=1
        s_obs_observation_id=
     +     TRIM(s_primary_id)//'-'//
     +     TRIM(ADJUSTL(s_single_record_number))//'-'//
     +     TRIM(s_year)//'-'//
     +     TRIM(s_month)//'-'//
     +     TRIM(s_day)//'-'//
     +     TRIM(s_code_observation(j))//'-'//
     +     TRIM(s_value_significance(j))
        s_obs_linedata_vec(jj)=TRIM(s_obs_observation_id)
c******
c       2. report_id
        jj=2
        s_obs_report_id=s_header_report_id
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
     +   s_date_reconstruct//' '//s_time_reconstruct//s_time_offset
        s_obs_linedata_vec(jj)=s_obs_date_time
c******
c       5. date-time_meaning
        jj=5
        s_obs_date_time_meaning='1'     !enter 1 for daily
        s_obs_linedata_vec(jj)=s_obs_date_time_meaning
c******
c       6. observation_duration
        jj=6
        s_obs_observation_duration=s_code_observation_duration(j)
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
     +    s_vec_hgt_obs_above_sfc(j) 
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
     +     TRIM(ADJUSTL(s_vec_observation_value(j)))
        s_obs_linedata_vec(jj)=s_obs_observation_value
c******
c       16.value_significance
        jj=16
        s_obs_value_significance=s_value_significance(j)
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
        s_obs_conversion_flag=ADJUSTL(s_code_conversion_flag(j))
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
        s_obs_linedata_vec(jj)=TRIM(s_obs_coordinate_method)
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
c       0=passed, 1=failed, 2=not checked, 3=missing
        jj=29
        s_obs_quality_flag=TRIM(ADJUSTL(s_vec_qc_code(j)))
        s_obs_linedata_vec(jj)=s_obs_quality_flag
c******
c       30.numerical_precision
        jj=30
        s_obs_numerical_precision=
     +     TRIM(ADJUSTL(s_vec_numerical_precision(j)))
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
        s_obs_original_precision=s_vec_original_prec(j)
        IF (TRIM(s_code_conversion_method(j)).EQ.'') THEN 
         s_obs_original_precision=''

c         print*,'condition met: no export original values'
c         STOP 'write_header_obs_table3.f'
        ENDIF
        s_obs_linedata_vec(jj)=s_obs_original_precision
c******
c       35.original_units
        jj=35
        s_obs_original_units=s_code_unit_original(j)          !length 50,3
        IF (TRIM(s_code_conversion_method(j)).EQ.'') THEN
         s_obs_original_units=''
        ENDIF
        s_obs_linedata_vec(jj)=s_obs_original_units
c******
c       36.original_code_table 
        jj=36
        s_obs_original_code_table='NULL'
        s_obs_linedata_vec(jj)=s_obs_original_code_table
c******
c       37.original_value
        jj=37
        s_obs_original_value=s_vec_original_value(j)
        IF (TRIM(s_code_conversion_method(j)).EQ.'') THEN
         s_obs_original_value=''
        ENDIF
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
c       18Apr2020: column changed from 46 to 47
        jj=47
        s_obs_source_id=s_single_source_id 
        s_obs_linedata_vec(jj)=s_obs_source_id
c******
c******
c       String all fields together
        s_obs_linedata_assemble_pre=''
        DO jj=1,l_col_obs
         s_obs_linedata_assemble_pre =
     +     TRIM( s_obs_linedata_assemble_pre)//
     +     TRIM(s_obs_linedata_vec(jj))//'|'

c        print*,'jj',jj,TRIM(s_obs_linedata_assemble_pre)
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
         STOP 'header_obs_lite_table; i_obs_linedata_len>limit'
        ENDIF

c        print*,'s_obs_linedata_assemble=',TRIM(s_obs_linedata_assemble)

c        STOP 'header_obs_lite_table; output observation table line'
c******
c******
c        GOTO 38

c       WRITE LINE ONLY IF NDFLAG GOOD

c       Print data 
c       act only if data good
        IF (f_vec_original_value(j).NE.f_ndflag) THEN 

c         WRITE(3,FMT=1000) ADJUSTL(s_obs_linedata_assemble)

         s_fmt1='a'//TRIM(ADJUSTL(s_linedata_len))
         WRITE(3,'('//s_fmt1//')') 
     +   ADJUSTL(s_obs_linedata_assemble)   !good

c         print*,'i_linedata_len=',i_linedata_len
c         print*,'s_obs_linedata_assemble',TRIM(s_obs_linedata_assemble)

c        INCREMENT LINE COUNTER HERE (number lines in observation file)
         n_lines_obs=n_lines_obs+1

c*****
c        VARIABLES FOR RECEIPT FILE
c        Count variables actually exported
         i_vec_cnt_channelexported(j)=i_vec_cnt_channelexported(j)+1

c        Convert date-time to jtime
         CALL get_jtime_from_datetime(s_obs_date_time,
     +     d_obs_jtime)

c        Test/modify minmax
         CALL find_minmax_datetime(s_obs_date_time,d_obs_jtime,
     +     d_obs_jtime_min,d_obs_jtime_max,
     +     s_obs_date_time_st,s_obs_date_time_en)

c         print*,s_obs_date_time,d_obs_jtime,
c     +     d_obs_jtime_min,d_obs_jtime_max,
c     +     s_obs_date_time_st,s_obs_date_time_en
c         print*,'s_obs_date_time='//TRIM(s_obs_date_time)//'='
c         STOP 'header_obs_lite_table20201215'


cc        Establish condition for first date-time
c         IF (s_obs_date_time_st.EQ.'-999') THEN 
c          s_obs_date_time_st=s_obs_date_time
c         ENDIF
c         s_obs_date_time_en=s_obs_date_time

c        VARIABLES FOR STNCONFIG LINES
         DO k=1,l_collect_cnt        !cycle through record numbers
          IF (TRIM(s_vec_recordnumber(j)).EQ.
     +        TRIM(s_collect_record_number(k))) THEN 

c          Augment histogram by variable & record number
           i_record_hist_channel(k,j)=i_record_hist_channel(k,j)+1

c          Archive st/en date/time by record number
c        Test/modify minmax
         CALL find_minmax_datetime(s_obs_date_time,d_obs_jtime,
     +     d_record_jtime_min_byreport(k),
     +     d_record_jtime_max_byreport(k),
     +     s_record_date_time_st_byreport(k),
     +     s_record_date_time_en_byreport(k))

c           IF (s_record_date_time_st_byreport(k).EQ.'-999') THEN 
c            s_record_date_time_st_byreport(k)=s_obs_date_time
c           ENDIF
c           s_record_date_time_en_byreport(k)=s_obs_date_time

          ENDIF
         ENDDO
c*****
        ENDIF

 38     CONTINUE
c******
c******
c       Output lines to screen

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

c        ENDIF

 23     CONTINUE
c*****
       ENDIF   !CLOSE condition to match variable record numbers with i1 index
       ENDDO   !CLOSE j-index OBSERVATION (all variables for given station)
c*****
c*************************************************************************
c      QCMETHOD
c      Cycle through variables

       DO j=1,l_channel    !cycle through 9 possible variables

c       Check on qc flag
        IF (s_vec_qc_code(j).NE.s_vec_qc_code_check(j)) THEN
         print*,'problem with qc flags'
         STOP 'header_obs_lite_table20201215'
        ENDIF

c      Act only if variable record number matches the one in the i1 index 
        IF (TRIM(s_vec_recordnumber(j)).EQ.TRIM(s_single_record_number))
     +   THEN 

cc      Act only if s_vec_qc_code is something other than 0
c        IF (TRIM(s_vec_qc_code(j)).NE.'0') THEN 

c      Act only if qcmethod variable not blank
        IF (LEN_TRIM(s_vec_qcmethod_code(j)).GT.0) THEN 

c        print*,'qc_code='//TRIM(s_vec_qc_code(j))//'='
c        print*,'qcmethod='//TRIM(s_vec_qcmethod_code(j))//'='
c        print*,'len qcmet',LEN_TRIM(ADJUSTL(s_vec_qcmethod_code(j)))

        s_qc_single=TRIM(s_vec_qcmethod_code(j))

c        print*,'s_qc_single='//s_qc_single//'=',
c     +    LEN_TRIM(s_qc_single)
c        IF (TRIM(s_qc_single).EQ.'') THEN
c         print*,'null string recognized'
c        ENDIF

c       print*,'qcmethod conditions met'
c       STOP 'header_obs_lite_table20201215'

c*************************************************************************
c      Main list variables

c******
c******
c       1. observation_id
c       11Jun2020: note recordnumber change here
        jj=1
        s_qcmethod_observation_id=
     +     TRIM(s_primary_id)//'-'//
     +     TRIM(ADJUSTL(s_single_record_number))//'-'//
     +     TRIM(s_year)//'-'//
     +     TRIM(s_month)//'-'//
     +     TRIM(s_day)//'-'//
     +     TRIM(s_code_observation(j))//'-'//
     +     TRIM(s_value_significance(j))
        s_qcmethod_linedata_vec(jj)=TRIM(s_qcmethod_observation_id)
c******
c       2. report_id - note this uses observation record number
c          this column corresponds to column 1 in header file
        jj=2
        s_qcmethod_report_id=s_header_report_id
        s_qcmethod_linedata_vec(jj)=s_qcmethod_report_id
c******
c       3. qcmethod
        jj=3
        s_qcmethod_qc_method=TRIM(ADJUSTL(s_vec_qcmethod_code(j)))
        s_qcmethod_linedata_vec(jj)=s_qcmethod_qc_method
c******
c       4.quality_flag - translated code used in observation table
c       0=passed, 1=failed, 2=not checked, 3=missing
        jj=4
        s_qcmethod_quality_flag=TRIM(ADJUSTL(s_vec_qc_code(j)))
        s_qcmethod_linedata_vec(jj)=s_qcmethod_quality_flag
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

        STOP 'header_obs_lite_qff20201120; just after qcmethod'

 123     CONTINUE
c******
       ENDIF   !CLOSE condition for s_vec_qcmethod_code to be nonzero
       ENDIF   !CLOSE condition to match variable record numbers with i1 index
       ENDDO   !CLOSE j-index OBSERVATION (all variables for given station)
c*****

c*************************************************************************
c*************************************************************************
c*****
c*****
c      LITE
c      Cycle through variables

       DO j=1,l_channel    !cycle through 9 possible variables

c      Act onlyif variable record number matches the one in the i1 index 
       IF (TRIM(s_vec_recordnumber(j)).EQ.TRIM(s_single_record_number))
     +   THEN 
c*************************************************************************
c      Main list variables
c******
c       1. observation_id (observation table column 1)
        jj=1
        s_lite_observation_id=
     +     TRIM(s_primary_id)//'-'//
     +     TRIM(ADJUSTL(s_single_record_number))//'-'//
     +     TRIM(s_year)//'-'//
     +     TRIM(s_month)//'-'//
     +     TRIM(s_day)//'-'//
     +     TRIM(s_code_observation(j))//'-'//
     +     TRIM(s_value_significance(j))
c     +     TRIM(s_primary_id)//'-'//
c     +     TRIM(ADJUSTL(s_single_record_number))//'-'//
c     +     TRIM(s_year)//'-'//
c     +     TRIM(s_month)//'-'//
c     +     TRIM(s_code_observation(j))//'-'//
c     +     TRIM(s_code_value_significance(j))
        s_lite_linedata_vec(jj)=TRIM(s_lite_observation_id)
c******
c       2. report_type (header table column 6)
        jj=2
        s_lite_report_type=s_header_report_type
        s_lite_linedata_vec(jj)=TRIM(s_lite_report_type)
c******
c       3. date_time (observation table column 4)
        jj=3
        s_lite_date_time=
     +   s_date_reconstruct//' '//s_time_reconstruct//s_time_offset
c     +    s_date_reconstruct_yyyy_mm_dd//' '//
c     +    s_time_reconstruct_hh_mm_ss//s_time_offset
        s_lite_linedata_vec(jj)=s_lite_date_time
c******
c       4. date_time_meaning (observation table column 5)
        jj=4
        s_lite_date_time_meaning='1'     !enter 1 for daily 
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
     +     s_vec_hgt_obs_above_sfc(j)
c     +    s_predef_hgt_obs_above_sfc(j) 
        s_lite_linedata_vec(jj)=
     +    s_lite_observation_height_above_station_surface
c******
c       8. observed_variable (observation table col 13)
        jj=8
        s_lite_observed_variable=s_code_observation(j) !s_code_observation(j)
        s_lite_linedata_vec(jj)=s_lite_observed_variable
c******
c       9. units (observation table col 18)
        jj=9
        s_lite_units=s_code_unit(j)                     !s_code_unit(j)
        s_lite_linedata_vec(jj)=s_lite_units
c******
c       10.observation_value (observation table col 15)
        jj=10
        s_lite_observation_value=
     +     TRIM(ADJUSTL(s_vec_observation_value(j)))
c     +     TRIM(ADJUSTL(s_avec_submitdata(j)))
        s_lite_linedata_vec(jj)=s_lite_observation_value
c******
c       11.value_significance (observation table column 16)
        jj=11
        s_lite_value_significance=s_value_significance(j)  !s_code_value_significance(j)
        s_lite_linedata_vec(jj)=s_lite_value_significance
c******
c       12.observation_duration (observation table column 6)
        jj=12
        s_lite_observation_duration='13'   !13=daily, 14=monthly
        s_lite_linedata_vec(jj)=s_lite_observation_duration
c******
c       13. platform_type (header table column 9)
        jj=13
        s_lite_platform_type=TRIM(s_single_platform_type)  !TRIM(s_single_platform_type)
        s_lite_linedata_vec(jj)=TRIM(s_lite_platform_type)
c******
c       14. station_type (header table column 8))
        jj=14
        s_lite_station_type=TRIM(s_single_station_type)    !TRIM(s_single_station_type)
        s_lite_linedata_vec(jj)=TRIM(s_lite_station_type)
c******
c       15. primary_station_id (header table column 11)
        jj=15
        s_lite_primary_station_id=TRIM(s_primary_id)       !s_primary_id
        s_lite_linedata_vec(jj)=TRIM(s_lite_primary_station_id)
c******
c       16. station_name (header table column 7)
        jj=16
        s_lite_station_name=TRIM(s_single_station_name)    !TRIM(s_single_station_name)
        s_lite_linedata_vec(jj)=TRIM(s_lite_station_name)
c******
c       17. quality_flag (observation table column 29)
        jj=17
        s_lite_quality_flag=TRIM(ADJUSTL(s_vec_qc_code(j))) !TRIM(ADJUSTL(s_avec_qc(j)))
        s_lite_linedata_vec(jj)=s_lite_quality_flag
c******
c       18. data_policy_licence (observation table column 3)
        jj=18
        s_lite_data_policy_licence=TRIM(s_single_data_policy_licence) !TRIM(s_single_data_policy_licence)
        s_lite_linedata_vec(jj)=s_lite_data_policy_licence
c******
c       19. source_id (observation table column 3)
c       23Dec2020: added new column
        jj=19
        s_lite_source_id=s_single_source_id 
        s_lite_linedata_vec(jj)=s_lite_source_id
c******
c******
c       String all fields together
        s_lite_linedata_assemble_pre=''
        DO jj=1,l_col_lite
         s_lite_linedata_assemble_pre =
     +     TRIM(s_lite_linedata_assemble_pre)//
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
         STOP 'header_obs_lite_table; i_lite_linedata_len>limit'
        ENDIF

c        STOP 'header_obs_lite_table; output observation table line'
c******
c******
c        GOTO 39

c       WRITE LINE ONLY IF NDFLAG GOOD

c       Print data 
c       act only if data good
        IF (f_vec_original_value(j).NE.f_ndflag) THEN 

         s_fmt1='a'//TRIM(ADJUSTL(s_linedata_len))
         WRITE(4,'('//s_fmt1//')') 
     +   ADJUSTL(s_lite_linedata_assemble)   !good

c         print*,'i_linedata_len=',i_linedata_len
c         print*,'s_lite_linedata_assemble',TRIM(s_lite_linedata_assemble)

c        INCREMENT LINE COUNTER HERE (number lines in observation file)
         n_lines_lite=n_lines_lite+1
c*****
        ENDIF      !close condition of filled data space

 39     CONTINUE
c******
c******
        GOTO 26

c       Print info to screen 
        CALL sample_screenprint_lite(
     +   s_lite_observation_id,s_lite_report_type,
     +   s_lite_date_time,s_lite_date_time_meaning,
     +   s_lite_latitude,s_lite_longitude, 
     +   s_lite_observation_height_above_station_surface,
     +   s_lite_observed_variable,s_lite_units,
     +   s_lite_observation_value,s_lite_value_significance, 
     +   s_lite_observation_duration,s_lite_platform_type, 
     +   s_lite_station_type,s_lite_primary_station_id,
     +   s_lite_station_name,s_lite_quality_flag,
     +   s_lite_data_policy_licence,s_lite_source_id, 
     +   s_lite_linedata_assemble)

 26     CONTINUE
c*****

       ENDIF   !CLOSE condition to match variable record numbers with i1 index
       ENDDO   !CLOSE j-index LITE (all variables for given station)
c*****
c*****
c*****
      ENDIF    !close condition for populated record number counter

      ENDDO    !close i1-index for record number
c*****
c*****
      ENDDO    !close i-index for timestamp
c************************************************************************
 91   CONTINUE

      CLOSE(UNIT=2)
      CLOSE(UNIT=3)
      CLOSE(UNIT=4)
      CLOSE(UNIT=5)
c************************************************************************
c     gzip the files

c      GOTO 90

      s_command='gzip '//TRIM(s_pathandname_header)
c      print*,'s_command=',TRIM(s_command) 
      CALL SYSTEM(s_command,io)

c      print*,'cleared gzip header'

      s_command='gzip '//TRIM(s_pathandname_obs)
c      print*,'s_command=',TRIM(s_command) 
      CALL SYSTEM(s_command,io)

c      print*,'cleared gzip obs'

      s_command='gzip '//TRIM(s_pathandname_lite)
c      print*,'s_command=',TRIM(s_command) 
      CALL SYSTEM(s_command,io)

c      print*,'cleared gzip lite'

 90   CONTINUE

c      STOP 'header_obs_lite_table'
c************************************************************************
c         print*,'start/end=',
c     +     d_obs_jtime_min,d_obs_jtime_max,
c     +     s_obs_date_time_st,s_obs_date_time_en

c      print*,'i,ii_good,ii_bad=',
c     +  i,ii_good,ii_bad

c      print*,'s_obs_date_time_st=',TRIM(s_obs_date_time_st)
c      print*,'s_obs_date_time_en=',TRIM(s_obs_date_time_en)

c      print*,'l_collect_cnt=',l_collect_cnt
c      print*,'l_channel=',l_channel

c      DO i=1,l_collect_cnt 
c       print*,'i=',i
c       print*,'s_record_date_time_st_byreport=',
c     +   TRIM(s_record_date_time_st_byreport(i))
c       print*,'s_record_date_time_en_byreport=',
c     +   TRIM(s_record_date_time_en_byreport(i))
c       print*,'i_record_hist_channel=',
c     +   (i_record_hist_channel(i,j),j=1,l_channel)
c      ENDDO

c       STOP 'header_obs_lite_table20201215'
c************************************************************************
c************************************************************************
c     Modify stnconfig lines with new data

c      print*,'l_scoutput_numfield=',l_scoutput_numfield

      DO i=1,20
       DO j=1,50  
        s_collect_datalines_new(i,j)=s_collect_datalines(i,j)
       ENDDO
      ENDDO

      DO i=1,l_collect_cnt   !cycle through record numbers
       s_single_date_time_byreport=s_record_date_time_st_byreport(i)
       s_year_st=s_single_date_time_byreport(1:4)

       s_single_date_time_byreport=s_record_date_time_en_byreport(i)
       s_year_en=s_single_date_time_byreport(1:4)

c      Find total number of observations for record number
       i_record_hist_integrate(i)=0
       DO j=1,l_channel
        IF (i_record_hist_channel(i,j).GT.0) THEN
         i_record_hist_integrate(i)=i_record_hist_integrate(i)+
     +     i_record_hist_channel(i,j) 
        ENDIF
       ENDDO

c      Make string for observation code
       ii=0
       DO j=1,l_channel
        IF (i_record_hist_channel(i,j).GT.0) THEN
         ii=ii+1
         s_vec_obscode_fulllist(ii)=TRIM(s_code_observation(j))
        ENDIF
       ENDDO

c      Get vector of distinct observation codes
       CALL get_strvector_distinct(l_channel,ii,
     +   s_vec_obscode_fulllist,
     +   l_distinct,s_vec_obscode_distinct)

c      Assemble string with variables listed
       s_collect_obscode_pre=''
       DO j=1,l_distinct
        s_collect_obscode_pre=TRIM(s_collect_obscode_pre)//
     +      TRIM(s_vec_obscode_distinct(j))//','
       ENDDO

       i_len=LEN_TRIM(s_collect_obscode_pre)
       s_collect_obscode=s_collect_obscode_pre(1:i_len-1)

c      Archive info
       s_vec_year_st(i)        =s_year_st
       s_vec_year_en(i)        =s_year_en
       s_vec_collect_obscode(i)=s_collect_obscode

c       print*,'i,s_year_st,s_year_en=',
c     +   i,s_year_st//'='//s_year_en//'='//TRIM(s_collect_obscode)
c       print*,'ii=',ii
c       print*,'s_vec_obscode_fullli',(s_vec_obscode_fulllist(j),j=1,ii)
c       print*,'s_collect_obscode=',TRIM(s_collect_obscode)
      ENDDO

c      print*,'s_directory_output_receipt=',
c     +  TRIM(s_directory_output_receipt)
c      print*,'s_scoutput_vec_header=',
c     +  (TRIM(s_scoutput_vec_header(i)),i=1,l_scoutput_numfield)
c      print*,'col_1=',(s_collect_datalines(i,1),i=1,l_collect_cnt)
c      print*,'col_3=',(s_collect_datalines(i,3),i=1,l_collect_cnt)
c      print*,'col_13=',(s_collect_datalines(i,13),i=1,l_collect_cnt)
c      print*,'col_14=',(s_collect_datalines(i,14),i=1,l_collect_cnt)
c      print*,'col_29=',(s_collect_datalines(i,29),i=1,l_collect_cnt)

c      print*,'i_record_hist_integrate=',
c     +  (i_record_hist_integrate(i),i=1,l_collect_cnt)
c      print*,'s_vec_year_st',(TRIM(s_vec_year_st(i)),i=1,l_collect_cnt)
c      print*,'s_vec_year_en',(TRIM(s_vec_year_en(i)),i=1,l_collect_cnt)
c      print*,'s_vec_collect_obscode',
c     +  (TRIM(s_vec_collect_obscode(i)),i=1,l_collect_cnt)

c     Create copy of datalines
      DO i=1,20              !cycle through record numbers
       DO j=1,50             !cycle through parameter columns
        s_collect_datalines_output(i,j)=s_collect_datalines(i,j)
       ENDDO
      ENDDO

c     Assign values to col 13,14,29
      DO i=1,l_collect_cnt   !cycle through record numbers
       IF (i_record_hist_integrate(i).GT.0) THEN 
        s_collect_datalines_output(i,13)=TRIM(s_vec_year_st(i))
        s_collect_datalines_output(i,14)=TRIM(s_vec_year_en(i))
        s_collect_datalines_output(i,29)=TRIM(s_vec_collect_obscode(i))
       ENDIF
      ENDDO

c     c13: start date
c     c14: end date
c     c29: observed variables
c************************************************************************
c     Export receipt file with new stnconfig lines

      CALL export_stnconfig_lines(s_directory_output_receipt,
     +  s_stnname_single,
     +  l_collect_cnt,l_scoutput_numfield,
     +  i_record_hist_integrate,
     +  s_collect_datalines_output,
     +  s_scoutput_vec_header)
c************************************************************************
c     Receipt file with line counts
      CALL make_receiptfile_linecount20201222(
     +  s_directory_output_receipt_linecount,s_stnname_single,
     +  n_lines_obs,n_lines_header,n_lines_lite,n_lines_qcmethod)
c************************************************************************
      print*,'just leaving header_obs_table20201215'

c      STOP 'header_obs_table_lite20201215'

      RETURN
      END
