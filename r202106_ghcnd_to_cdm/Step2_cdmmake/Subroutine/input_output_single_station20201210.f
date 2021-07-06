c     Subroutine to get vectors of data
c     AJ_Kettle, 08May2019

c     Subroutines called from this subroutine
c     -get_lines_1file2
c       -get_fields_from_ghcnd_line2
c     -find_len_fields2
c     -verify_stn_id2
c     -find_hist_param_elements2
c     -find_distinct_timesteps2
c     -get_sourceid_numcode2
c     -get_record_number2
c       -search_stringfragment2
c       -ambigcase_get_low_record2
c     -total_counts_record_number2
c     -convert_string_to_float_ghcnd3
c       -convert_float_to_string2
c       -convert_integer_to_string2
c     -test_precision_variables2
c       -precision_single_vector1a
c       -precision_single_vector2a
c       -precision_interpreter_tenths2
c       -precision_interpreter_whole2
c     -header_obs_table2a
c       -sort_vec_obs_ancillary_ghcnd2
c       -find_vector_recordnumber2
c       -assemble_vec_original_precision2

      SUBROUTINE input_output_single_station20201210(f_ndflag,
     +    s_date_st,s_time_st,s_zone_st,
     +    s_directory_ghcnd_input,
     +    s_directory_output_header,s_directory_output_observation,
     +    s_directory_output_lite,
     +    s_directory_output_receipt,
     +    s_directory_output_qc,s_directory_output_receipt_linecount,
     +    s_filename,s_stnname_single,
     +    l_source_rgh,l_source,
     +    s_source_name,s_source_codeletter,s_source_codenumber,
     +    l_collect_cnt,

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

     +    l_collect_distinct,
     +    s_collect_flagambig,

     +    s_filestatus1,i_flag_skip,
     +  s_qckey_timescale_spec,l_qckey,
     +  s_qckey_sourceflag,s_qckey_c3sflag,s_qckey_timescale)

      IMPLICIT NONE
c************************************************************************
c     Declare variables 

      REAL                :: f_ndflag

      CHARACTER(LEN=8)    :: s_date_st
      CHARACTER(LEN=10)   :: s_time_st
      CHARACTER(LEN=5)    :: s_zone_st

      CHARACTER(LEN=*)    :: s_directory_ghcnd_input
      CHARACTER(LEN=*)    :: s_directory_output_header
      CHARACTER(LEN=*)    :: s_directory_output_observation
      CHARACTER(LEN=*)    :: s_directory_output_lite
      CHARACTER(LEN=*)    :: s_directory_output_receipt
      CHARACTER(LEN=*)    :: s_directory_output_qc
      CHARACTER(LEN=*)    :: s_directory_output_receipt_linecount

      CHARACTER(LEN=300)  :: s_filename
      CHARACTER(LEN=12)   :: s_stnname_single

      INTEGER             :: l_source_rgh
      INTEGER             :: l_source
      CHARACTER(LEN=500)  :: s_source_name(l_source_rgh)
      CHARACTER(LEN=1)    :: s_source_codeletter(l_source_rgh)
      CHARACTER(LEN=3)    :: s_source_codenumber(l_source_rgh)

      INTEGER             :: l_collect_cnt

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

      INTEGER             :: l_collect_distinct
      CHARACTER(LEN=1)    :: s_collect_flagambig(20)

      CHARACTER(LEN=3)    :: s_filestatus1
c*****
      CHARACTER(LEN=300)  :: s_qckey_timescale_spec
      INTEGER             :: l_qckey
      CHARACTER(LEN=2)    :: s_qckey_sourceflag(100)
      CHARACTER(LEN=2)    :: s_qckey_c3sflag(100)
      CHARACTER(LEN=300)  :: s_qckey_timescale(100) 
c*****
c*****
c     Declare variables used in subroutine

      INTEGER             :: i,j,k,ii,jj,kk

      CHARACTER(LEN=4)    :: s_param_select(9)

      CHARACTER(LEN=300)  :: s_pathandname
      LOGICAL             :: there

      INTEGER, PARAMETER  :: l_lines_rgh=1000000
      INTEGER             :: l_lines

      CHARACTER(LEN=12)   :: s_archpre_id(l_lines_rgh)
      CHARACTER(LEN=8)    :: s_archpre_date_yyyymmdd(l_lines_rgh)
      CHARACTER(LEN=4)    :: s_archpre_element(l_lines_rgh)
      CHARACTER(LEN=5)    :: s_archpre_datavalue(l_lines_rgh)
      CHARACTER(LEN=1)    :: s_archpre_mflag(l_lines_rgh)
      CHARACTER(LEN=1)    :: s_archpre_qflag(l_lines_rgh)
      CHARACTER(LEN=1)    :: s_archpre_sflag(l_lines_rgh)
      CHARACTER(LEN=4)    :: s_archpre_obstime(l_lines_rgh)

      CHARACTER(LEN=12)   :: s_arch_id(l_lines_rgh)
      CHARACTER(LEN=8)    :: s_arch_date_yyyymmdd(l_lines_rgh)
      CHARACTER(LEN=4)    :: s_arch_element(l_lines_rgh)
      CHARACTER(LEN=5)    :: s_arch_datavalue(l_lines_rgh)
      CHARACTER(LEN=1)    :: s_arch_mflag(l_lines_rgh)
      CHARACTER(LEN=1)    :: s_arch_qflag(l_lines_rgh)
      CHARACTER(LEN=1)    :: s_arch_sflag(l_lines_rgh)
      CHARACTER(LEN=4)    :: s_arch_obstime(l_lines_rgh)

c     11May2021: changed for release 202106 from 100000 to 400000
      INTEGER, PARAMETER  :: l_timestamp_rgh=100000 !100000
      INTEGER             :: l_timestamp

      CHARACTER(LEN=8)    :: s_distinct_date_yyyymmdd(l_timestamp_rgh)

      CHARACTER(LEN=5)    :: s_prcp_datavalue(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_prcp_mflag(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_prcp_qflag(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_prcp_sflag(l_timestamp_rgh)
      CHARACTER(LEN=4)    :: s_prcp_obstime(l_timestamp_rgh)

      CHARACTER(LEN=5)    :: s_tmin_datavalue(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_tmin_mflag(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_tmin_qflag(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_tmin_sflag(l_timestamp_rgh)
      CHARACTER(LEN=4)    :: s_tmin_obstime(l_timestamp_rgh)

      CHARACTER(LEN=5)    :: s_tmax_datavalue(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_tmax_mflag(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_tmax_qflag(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_tmax_sflag(l_timestamp_rgh)
      CHARACTER(LEN=4)    :: s_tmax_obstime(l_timestamp_rgh)

      CHARACTER(LEN=5)    :: s_tavg_datavalue(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_tavg_mflag(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_tavg_qflag(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_tavg_sflag(l_timestamp_rgh)
      CHARACTER(LEN=4)    :: s_tavg_obstime(l_timestamp_rgh)

      CHARACTER(LEN=5)    :: s_snwd_datavalue(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_snwd_mflag(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_snwd_qflag(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_snwd_sflag(l_timestamp_rgh)
      CHARACTER(LEN=4)    :: s_snwd_obstime(l_timestamp_rgh)

      CHARACTER(LEN=5)    :: s_snow_datavalue(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_snow_mflag(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_snow_qflag(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_snow_sflag(l_timestamp_rgh)
      CHARACTER(LEN=4)    :: s_snow_obstime(l_timestamp_rgh)

      CHARACTER(LEN=5)    :: s_awnd_datavalue(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_awnd_mflag(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_awnd_qflag(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_awnd_sflag(l_timestamp_rgh)
      CHARACTER(LEN=4)    :: s_awnd_obstime(l_timestamp_rgh)

      CHARACTER(LEN=5)    :: s_awdr_datavalue(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_awdr_mflag(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_awdr_qflag(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_awdr_sflag(l_timestamp_rgh)
      CHARACTER(LEN=4)    :: s_awdr_obstime(l_timestamp_rgh)

      CHARACTER(LEN=5)    :: s_wesd_datavalue(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_wesd_mflag(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_wesd_qflag(l_timestamp_rgh)
      CHARACTER(LEN=1)    :: s_wesd_sflag(l_timestamp_rgh)
      CHARACTER(LEN=4)    :: s_wesd_obstime(l_timestamp_rgh)
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
      CHARACTER(LEN=3)    :: s_prcp_sourceid(l_timestamp_rgh)
      CHARACTER(LEN=3)    :: s_tmin_sourceid(l_timestamp_rgh)
      CHARACTER(LEN=3)    :: s_tmax_sourceid(l_timestamp_rgh)
      CHARACTER(LEN=3)    :: s_tavg_sourceid(l_timestamp_rgh)
      CHARACTER(LEN=3)    :: s_snwd_sourceid(l_timestamp_rgh)
      CHARACTER(LEN=3)    :: s_snow_sourceid(l_timestamp_rgh)
      CHARACTER(LEN=3)    :: s_awnd_sourceid(l_timestamp_rgh)
      CHARACTER(LEN=3)    :: s_awdr_sourceid(l_timestamp_rgh)
      CHARACTER(LEN=3)    :: s_wesd_sourceid(l_timestamp_rgh)

      INTEGER             :: i_flag_skip
      CHARACTER(LEN=2)    :: s_prcp_recordnumber(l_timestamp_rgh)
      CHARACTER(LEN=2)    :: s_tmin_recordnumber(l_timestamp_rgh)
      CHARACTER(LEN=2)    :: s_tmax_recordnumber(l_timestamp_rgh)
      CHARACTER(LEN=2)    :: s_tavg_recordnumber(l_timestamp_rgh)
      CHARACTER(LEN=2)    :: s_snwd_recordnumber(l_timestamp_rgh)
      CHARACTER(LEN=2)    :: s_snow_recordnumber(l_timestamp_rgh)
      CHARACTER(LEN=2)    :: s_awnd_recordnumber(l_timestamp_rgh)
      CHARACTER(LEN=2)    :: s_awdr_recordnumber(l_timestamp_rgh)
      CHARACTER(LEN=2)    :: s_wesd_recordnumber(l_timestamp_rgh)

      INTEGER             :: i_collect_cnt_valid_prcp(20)
      INTEGER             :: i_collect_cnt_valid_tmin(20)
      INTEGER             :: i_collect_cnt_valid_tmax(20)
      INTEGER             :: i_collect_cnt_valid_tavg(20)
      INTEGER             :: i_collect_cnt_valid_snwd(20)
      INTEGER             :: i_collect_cnt_valid_snow(20)
      INTEGER             :: i_collect_cnt_valid_awnd(20)
      INTEGER             :: i_collect_cnt_valid_awdr(20)
      INTEGER             :: i_collect_cnt_valid_wesd(20)

      INTEGER             :: i_collect_cnt_valid_tot(20)
      INTEGER             :: i_collect_cnt_grandtot

      REAL                :: f_prcp_datavalue_mm(l_timestamp_rgh)
      REAL                :: f_tmin_datavalue_c(l_timestamp_rgh)
      REAL                :: f_tmax_datavalue_c(l_timestamp_rgh)
      REAL                :: f_tavg_datavalue_c(l_timestamp_rgh)
      REAL                :: f_snwd_datavalue_mm(l_timestamp_rgh)
      REAL                :: f_snow_datavalue_mm(l_timestamp_rgh)
      REAL                :: f_awnd_datavalue_ms(l_timestamp_rgh)
      REAL                :: f_awdr_datavalue_deg(l_timestamp_rgh)
      REAL                :: f_wesd_datavalue_mm(l_timestamp_rgh)

      CHARACTER(LEN=10)   :: s_prcp_datavalue_mm(l_timestamp_rgh)
      CHARACTER(LEN=10)   :: s_tmin_datavalue_c(l_timestamp_rgh)
      CHARACTER(LEN=10)   :: s_tmax_datavalue_c(l_timestamp_rgh)
      CHARACTER(LEN=10)   :: s_tavg_datavalue_c(l_timestamp_rgh)
      CHARACTER(LEN=10)   :: s_snwd_datavalue_mm(l_timestamp_rgh)
      CHARACTER(LEN=10)   :: s_snow_datavalue_mm(l_timestamp_rgh)
      CHARACTER(LEN=10)   :: s_awnd_datavalue_ms(l_timestamp_rgh)
      CHARACTER(LEN=10)   :: s_awdr_datavalue_deg(l_timestamp_rgh)
      CHARACTER(LEN=10)   :: s_wesd_datavalue_mm(l_timestamp_rgh)

      CHARACTER(LEN=10)   :: s_prec_empir_prcp_mm
      CHARACTER(LEN=10)   :: s_prec_empir_tmin_c
      CHARACTER(LEN=10)   :: s_prec_empir_tmax_c
      CHARACTER(LEN=10)   :: s_prec_empir_tavg_c
      CHARACTER(LEN=10)   :: s_prec_empir_snwd_mm
      CHARACTER(LEN=10)   :: s_prec_empir_snow_mm
      CHARACTER(LEN=10)   :: s_prec_empir_awnd_ms
      CHARACTER(LEN=10)   :: s_prec_empir_awdr_deg
      CHARACTER(LEN=10)   :: s_prec_empir_wesd_mm
c************************************************************************
c      print*,'just entered input_output_single_station20201210'

c      STOP 'just entered input_output_single_station20201210'

c      print*,'l_qckey=',l_qckey
c      print*,'s_qckey_sourceflag=',
c     +  (TRIM(s_qckey_sourceflag(i)),i=1,l_qckey)
c      print*,'s_qckey_c3sflag=',
c     +  (TRIM(s_qckey_c3sflag(i)),i=1,l_qckey)
c      print*,'s_qckey_timescale=',
c     +  (TRIM(s_qckey_timescale(i)),i=1,l_qckey) 

c      STOP 'input_output_single_station20201210'
c************************************************************************
c     Define parameters for output

      s_param_select(1)='PRCP'
      s_param_select(2)='TMIN'
      s_param_select(3)='TMAX'
      s_param_select(4)='TAVG'
      s_param_select(5)='SNWD'
      s_param_select(6)='SNOW'
      s_param_select(7)='AWND'
      s_param_select(8)='AWDR'
      s_param_select(9)='WESD'

c************************************************************************
      s_pathandname=TRIM(s_directory_ghcnd_input)//TRIM(s_filename)

c      print*,'s_pathandname=',TRIM(s_pathandname)

      INQUIRE(FILE=TRIM(s_pathandname),
     +   EXIST=there)
      IF (there) THEN
         s_filestatus1='YES'
      ENDIF
      IF (.NOT.(there)) THEN
         s_filestatus1='NO '
      ENDIF

c      print*,'there=',there     
c      print*,'s_filestatus1=',s_filestatus1

c     STOP 'get_daily_data_vectors2'

c     Case of good file
      IF (s_filestatus1.EQ.'YES') THEN 

c      Get all lines in file
       CALL get_lines_1file2(s_pathandname,l_lines_rgh,l_lines,
     +  s_archpre_id,s_archpre_date_yyyymmdd,
     +  s_archpre_element,s_archpre_datavalue,
     +  s_archpre_mflag,s_archpre_qflag,s_archpre_sflag,
     +  s_archpre_obstime)

c      Sort sequence here
       CALL time_sort_process(l_lines_rgh,l_lines,
     +  s_archpre_id,s_archpre_date_yyyymmdd,
     +  s_archpre_element,s_archpre_datavalue,
     +  s_archpre_mflag,s_archpre_qflag,s_archpre_sflag,
     +  s_archpre_obstime,

     +  s_arch_id,s_arch_date_yyyymmdd,
     +  s_arch_element,s_arch_datavalue,
     +  s_arch_mflag,s_arch_qflag,s_arch_sflag,
     +  s_arch_obstime)

c       print*,'s_arch_element=',(TRIM(s_arch_element(i)),i=1,10)
c       print*,'s_arch_datavalue=',(TRIM(s_arch_datavalue(i)),i=1,10)
c       print*,'s_arch_qflag=',(TRIM(s_arch_qflag(i)),i=1,10)

c       STOP 'input_output_single_station20201210'

c      Check valid entries in each field
       CALL find_len_fields2(l_lines_rgh,l_lines,
     +  s_arch_id,s_arch_date_yyyymmdd,s_arch_element,s_arch_datavalue,
     +  s_arch_mflag,s_arch_qflag,s_arch_sflag,s_arch_obstime)

c      Verify that stn name agrees with all elements of file       
       CALL verify_stn_id2(s_stnname_single,
     +   l_lines_rgh,l_lines,s_arch_id)

c      Find histogram parameter elements
       CALL find_hist_param_elements2(l_lines_rgh,l_lines,
     +   s_arch_element,s_param_select)

c      Find number of distinct time stamps
       CALL find_distinct_timesteps2(l_lines_rgh,l_lines,
     +  s_arch_id,s_arch_date_yyyymmdd,s_arch_element,s_arch_datavalue,
     +  s_arch_mflag,s_arch_qflag,s_arch_sflag,s_arch_obstime,
     +  s_param_select,

     +  l_timestamp_rgh,l_timestamp,s_distinct_date_yyyymmdd,
     +  s_prcp_datavalue,s_prcp_mflag,s_prcp_qflag,s_prcp_sflag, 
     +    s_prcp_obstime,
     +  s_tmin_datavalue,s_tmin_mflag,s_tmin_qflag,s_tmin_sflag,
     +    s_tmin_obstime,
     +  s_tmax_datavalue,s_tmax_mflag,s_tmax_qflag,s_tmax_sflag,
     +    s_tmax_obstime,
     +  s_tavg_datavalue,s_tavg_mflag,s_tavg_qflag,s_tavg_sflag,
     +    s_tavg_obstime,
     +  s_snwd_datavalue,s_snwd_mflag,s_snwd_qflag,s_snwd_sflag,
     +    s_snwd_obstime,
     +  s_snow_datavalue,s_snow_mflag,s_snow_qflag,s_snow_sflag,
     +    s_snow_obstime,
     +  s_awnd_datavalue,s_awnd_mflag,s_awnd_qflag,s_awnd_sflag,
     +    s_awnd_obstime,
     +  s_awdr_datavalue,s_awdr_mflag,s_awdr_qflag,s_awdr_sflag,
     +    s_awdr_obstime,
     +  s_wesd_datavalue,s_wesd_mflag,s_wesd_qflag,s_wesd_sflag,
     +    s_wesd_obstime)
c*****
c      Place qc converter here
       CALL qc_converter(s_qckey_timescale_spec,l_qckey,
     +    s_qckey_sourceflag,s_qckey_c3sflag,s_qckey_timescale,
     +    l_timestamp_rgh,l_timestamp,
     +    s_prcp_qflag,
     +    s_tmin_qflag,s_tmax_qflag,s_tavg_qflag,
     +    s_snwd_qflag,s_snow_qflag, 
     +    s_awnd_qflag,s_awdr_qflag,s_wesd_qflag,
 
     +    s_prcp_cdmqc,s_tmin_cdmqc,s_tmax_cdmqc,
     +    s_tavg_cdmqc,s_snwd_cdmqc,s_snow_cdmqc,
     +    s_awnd_cdmqc,s_awdr_cdmqc,s_wesd_cdmqc,
     +    s_prcp_cdmqcmethod,s_tmin_cdmqcmethod,s_tmax_cdmqcmethod,
     +    s_tavg_cdmqcmethod,s_snwd_cdmqcmethod,s_snow_cdmqcmethod,
     +    s_awnd_cdmqcmethod,s_awdr_cdmqcmethod,s_wesd_cdmqcmethod)

c*****
c      Call subroutine to get source_id number code
c      this matches GHCND letter code with NUIM number code
       CALL get_sourceid_numcode2(l_timestamp_rgh,l_timestamp,
     +    s_prcp_sflag,s_tmin_sflag,s_tmax_sflag,
     +    s_tavg_sflag,s_snwd_sflag,s_snow_sflag,
     +    s_awnd_sflag,s_awdr_sflag,s_wesd_sflag,
     +    l_source_rgh,l_source,
     +    s_source_codeletter,s_source_codenumber,

     +    s_prcp_sourceid,s_tmin_sourceid,s_tmax_sourceid,
     +    s_tavg_sourceid,s_snwd_sourceid,s_snow_sourceid,
     +    s_awnd_sourceid,s_awdr_sourceid,s_wesd_sourceid)

c      Call subroutine to get record number
c      PROBLEM HERE
       i_flag_skip=0    !initialize to good flag
       CALL get_record_number2(l_timestamp_rgh,l_timestamp,
     +    s_prcp_sourceid,s_tmin_sourceid,s_tmax_sourceid,
     +    s_tavg_sourceid,s_snwd_sourceid,s_snow_sourceid,
     +    s_awnd_sourceid,s_awdr_sourceid,s_wesd_sourceid,
     +    l_collect_cnt,l_collect_distinct,s_collect_record_number,
     +    s_collect_source_id,s_collect_secondary_id,
     +    s_collect_flagambig, 

     +    s_prcp_recordnumber,s_tmin_recordnumber,s_tmax_recordnumber,
     +    s_tavg_recordnumber,s_snwd_recordnumber,s_snow_recordnumber,
     +    s_awnd_recordnumber,s_awdr_recordnumber,s_wesd_recordnumber,
     +    i_flag_skip)

c      exit analysis if station not found
       IF (i_flag_skip.EQ.1) THEN 
c        STOP 'input_output_single_station'
        GOTO 100
       ENDIF

c      See what record numbers represented
       CALL total_counts_recordnumber2(l_timestamp_rgh,l_timestamp,
     +    s_prcp_recordnumber,s_tmin_recordnumber,s_tmax_recordnumber,
     +    s_tavg_recordnumber,s_snwd_recordnumber,s_snow_recordnumber,
     +    s_awnd_recordnumber,s_awdr_recordnumber,s_wesd_recordnumber,
     +    l_collect_cnt,s_collect_record_number,

     +    i_collect_cnt_valid_prcp,i_collect_cnt_valid_tmin,
     +    i_collect_cnt_valid_tmax,i_collect_cnt_valid_tavg,
     +    i_collect_cnt_valid_snwd,i_collect_cnt_valid_snow,
     +    i_collect_cnt_valid_awnd,i_collect_cnt_valid_awdr,
     +    i_collect_cnt_valid_wesd,i_collect_cnt_valid_tot,
     +    i_collect_cnt_grandtot)

c      Call subroutine to convert string to float (13May2019)
       CALL convert_string_to_float_ghcnd3(f_ndflag,
     +    l_timestamp_rgh,l_timestamp,
     +    s_prcp_datavalue,s_tmin_datavalue,s_tmax_datavalue,
     +    s_tavg_datavalue,s_snwd_datavalue,s_snow_datavalue,
     +    s_awnd_datavalue,s_awdr_datavalue,s_wesd_datavalue,

     +    f_prcp_datavalue_mm,f_tmin_datavalue_c,f_tmax_datavalue_c,
     +    f_tavg_datavalue_c,f_snwd_datavalue_mm,f_snow_datavalue_mm,
     +    f_awnd_datavalue_ms,f_awdr_datavalue_deg,f_wesd_datavalue_mm,
     +    s_prcp_datavalue_mm,s_tmin_datavalue_c,s_tmax_datavalue_c,
     +    s_tavg_datavalue_c,s_snwd_datavalue_mm,s_snow_datavalue_mm,
     +    s_awnd_datavalue_ms,s_awdr_datavalue_deg,s_wesd_datavalue_mm)

c      Test precision of data set
       CALL test_precision_variables2(l_timestamp_rgh,l_timestamp,
     +  s_prcp_datavalue,s_tmin_datavalue,s_tmax_datavalue,
     +  s_tavg_datavalue,s_snwd_datavalue,s_snow_datavalue,
     +  s_awnd_datavalue,s_awdr_datavalue,s_wesd_datavalue,

     +  s_prec_empir_prcp_mm,s_prec_empir_tmin_c,s_prec_empir_tmax_c,
     +  s_prec_empir_tavg_c,s_prec_empir_snwd_mm,s_prec_empir_snow_mm,
     +  s_prec_empir_awnd_ms,s_prec_empir_awdr_deg,s_prec_empir_wesd_mm)

c      Call subroutine to do CDM conversion

c      Act if i_skip_flag is good
c       IF (i_flag_skip.EQ.0) THEN

c       print*,'just before header_obs_lite_table20201215'
c       STOP 'input_output_single_station20201210'

c      Act if at least 1 record number in set
       IF (i_collect_cnt_grandtot.GT.0) THEN

       CALL header_obs_lite_table20201215(f_ndflag,
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

       ENDIF
      ENDIF      !close s_filestatus tester

 100  CONTINUE

      print*,'just leaving input_output_single_station20201012'

c      STOP 'get_daily_data_vectors2'

      RETURN
      END
