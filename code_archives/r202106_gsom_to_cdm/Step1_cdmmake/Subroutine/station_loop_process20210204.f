c     Subroutine to do station loop for input & output
c     AJ_Kettle, 06Sep2019
c     23May2020: changed width of s_vec_lat/lon/elev from 12 to 20

      SUBROUTINE station_loop_process20210204(
     +  s_date_st,s_time_st,s_zone_st,i_values_st,
     +  s_directory_gsom,
     +  s_directory_output_header,s_directory_output_observation,
     +  s_directory_output_lite,
     +  s_directory_output_receipt,s_directory_output_lastfile,
     +  s_directory_output_diagnostics,
     +  s_directory_output_qc,s_directory_output_receipt_linecount,
     +  s_filename_test1,s_filename_test2,s_filename_test3,
     +  s_filename_test4,s_filename_test5,
     +  l_stations_rgh,l_subset,s_stnname,
     +  f_ndflag,
     +  l_scoutput_rgh,l_scoutput,l_scfield,
     +  l_scoutput_numfield,s_scoutput_vec_header,
     +  s_scoutput_mat_fields,
     +  l_varselect,
     +  s_varselect,s_code_observation,s_code_unit,
     +  s_code_value_significance,s_code_unit_original,
     +  s_code_conversion_method,s_code_conversion_flag,
     +  s_predef_numerical_precision,s_predef_hgt_obs_above_sfc,
     +  l_source_rgh,l_source,
     +  s_source_name,s_source_codeletter,s_source_codenumber,
     +  s_qckey_timescale_spec,l_qckey,
     +  s_qckey_sourceflag,s_qckey_c3sflag,s_qckey_timescale)

      IMPLICIT NONE
c************************************************************************
      CHARACTER(LEN=8)    :: s_date_st
      CHARACTER(LEN=10)   :: s_time_st
      CHARACTER(LEN=5)    :: s_zone_st
      INTEGER             :: i_values_st(8)

      CHARACTER(LEN=300)  :: s_directory_gsom

      CHARACTER(LEN=300)  :: s_directory_output_header
      CHARACTER(LEN=300)  :: s_directory_output_observation
      CHARACTER(LEN=300)  :: s_directory_output_lite
      CHARACTER(LEN=300)  :: s_directory_output_receipt
      CHARACTER(LEN=300)  :: s_directory_output_lastfile
      CHARACTER(LEN=300)  :: s_directory_output_diagnostics
      CHARACTER(LEN=300)  :: s_directory_output_qc
      CHARACTER(LEN=300)  :: s_directory_output_receipt_linecount

      CHARACTER(LEN=300)  :: s_filename_test1
      CHARACTER(LEN=300)  :: s_filename_test2
      CHARACTER(LEN=300)  :: s_filename_test3
      CHARACTER(LEN=300)  :: s_filename_test4
      CHARACTER(LEN=300)  :: s_filename_test5

      INTEGER             :: l_stations_rgh
      CHARACTER(LEN=12)   :: s_stnname(l_stations_rgh)
      INTEGER             :: l_subset

      REAL                :: f_ndflag
c*****

c     Stnconfig_output files
      INTEGER             :: l_scoutput_rgh
      INTEGER             :: l_scoutput
      INTEGER             :: l_scfield
      INTEGER             :: l_scoutput_numfield       
      CHARACTER(LEN=*)    :: s_scoutput_vec_header(50)               
      CHARACTER(LEN=*)    :: s_scoutput_mat_fields(l_scoutput_rgh,50)
c*****
      INTEGER             :: l_varselect
      CHARACTER(LEN=4)    :: s_varselect(l_varselect)
      CHARACTER(LEN=3)    :: s_code_observation(l_varselect)
      CHARACTER(LEN=3)    :: s_code_unit(l_varselect)
      CHARACTER(LEN=3)    :: s_code_value_significance(l_varselect)
      CHARACTER(LEN=3)    :: s_code_unit_original(l_varselect)
      CHARACTER(LEN=3)    :: s_code_conversion_method(l_varselect)
      CHARACTER(LEN=3)    :: s_code_conversion_flag(l_varselect)
      CHARACTER(LEN=10)   :: s_predef_numerical_precision(l_varselect)
      CHARACTER(LEN=10)   :: s_predef_hgt_obs_above_sfc(l_varselect)
c*****
c     variable for GSOM/GHCND conversion
      INTEGER             :: l_source_rgh
      INTEGER             :: l_source
      CHARACTER(LEN=500)  :: s_source_name(l_source_rgh)
      CHARACTER(LEN=1)    :: s_source_codeletter(l_source_rgh)
      CHARACTER(LEN=3)    :: s_source_codenumber(l_source_rgh)

c     09Dec2020: qc_key information
      CHARACTER(LEN=300)  :: s_qckey_timescale_spec
      INTEGER             :: l_qckey
      CHARACTER(LEN=2)    :: s_qckey_sourceflag(100)
      CHARACTER(LEN=2)    :: s_qckey_c3sflag(100)
      CHARACTER(LEN=300)  :: s_qckey_timescale(100) 
c*****
c*****
c     Variables used within subroutine

      INTEGER             :: i,j,k,ii,jj,kk

      INTEGER             :: i_bad,i_good
      INTEGER             :: i_bad_recordnumber
      INTEGER             :: i_bad_recordnumber_cat4thresh
      INTEGER             :: i_bad_sourceletter
      INTEGER             :: i_bad_sourceletter_cat2thresh
      INTEGER             :: i_bad_newletter
      INTEGER             :: i_bad_stnconlisting
      INTEGER             :: i_bad_cdmmaker

      CHARACTER(LEN=12)   :: s_stnname_single
      CHARACTER(LEN=300)  :: s_pathandname

      CHARACTER(LEN=2)    :: s_record_number_single
      CHARACTER(LEN=1)    :: s_data_policy_licence_single 
      CHARACTER(LEN=3)    :: s_source_id_single

      INTEGER             :: l_scshort
      CHARACTER(LEN=2)    :: s_scshort_record_number(20)
      CHARACTER(LEN=1)    :: s_scshort_data_policy_licence(20)
      CHARACTER(LEN=3)    :: s_scshort_source_id(20)

c     Parameters to readin data lines
      INTEGER,PARAMETER   :: l_rgh_lines=10000    !number data lines for 1 stn

      CHARACTER(LEN=8)    :: s_vec_date(l_rgh_lines)
      INTEGER, PARAMETER  :: l_rgh_lle=20
      CHARACTER(LEN=l_rgh_lle)::s_vec_lat(l_rgh_lines)   !changed from 12 to 20
      CHARACTER(LEN=l_rgh_lle)::s_vec_lon(l_rgh_lines)   !changed from 12 to 20
      CHARACTER(LEN=l_rgh_lle)::s_vec_elev(l_rgh_lines)  !changed from 12 to 20

      CHARACTER(LEN=12)   :: s_vec_lat_4dec(l_rgh_lines)
      CHARACTER(LEN=12)   :: s_vec_lon_4dec(l_rgh_lines)

      REAL                :: f_vec_lat_deg(l_rgh_lines)
      REAL                :: f_vec_lon_deg(l_rgh_lines)
      REAL                :: f_vec_elev_m(l_rgh_lines)

      REAL                :: f_vec_tmax_c(l_rgh_lines)
      REAL                :: f_vec_tmin_c(l_rgh_lines)
      REAL                :: f_vec_tavg_c(l_rgh_lines)
      REAL                :: f_vec_prcp_mm(l_rgh_lines)
      REAL                :: f_vec_snow_mm(l_rgh_lines)
      REAL                :: f_vec_awnd_ms(l_rgh_lines)

      CHARACTER(LEN=10)   :: s_vec_tmax_c(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_tmin_c(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_tavg_c(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_prcp_mm(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_snow_mm(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_awnd_ms(l_rgh_lines)

      CHARACTER(LEN=10)   :: s_vec_tmax_attrib(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_tmin_attrib(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_tavg_attrib(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_prcp_attrib(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_snow_attrib(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_awnd_attrib(l_rgh_lines)

c*****
c     Variables to assess original precision
      CHARACTER(LEN=10)   :: s_vec_tmax_origprec_c(l_rgh_lines) 
      CHARACTER(LEN=10)   :: s_vec_tmin_origprec_c(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_tavg_origprec_c(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_prcp_origprec_mm(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_snow_origprec_mm(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_awnd_origprec_ms(l_rgh_lines) 

      CHARACTER(LEN=10)   :: s_vec_tmax_origprec_empir_c(l_rgh_lines) 
      CHARACTER(LEN=10)   :: s_vec_tmin_origprec_empir_c(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_tavg_origprec_empir_c(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_prcp_origprec_empir_mm(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_snow_origprec_empir_mm(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_awnd_origprec_empir_ms(l_rgh_lines) 

      CHARACTER(LEN=1)    :: s_vec_tmax_origprec_neglog(l_rgh_lines) 
      CHARACTER(LEN=1)    :: s_vec_tmin_origprec_neglog(l_rgh_lines)
      CHARACTER(LEN=1)    :: s_vec_tavg_origprec_neglog(l_rgh_lines)
      CHARACTER(LEN=1)    :: s_vec_prcp_origprec_neglog(l_rgh_lines)
      CHARACTER(LEN=1)    :: s_vec_snow_origprec_neglog(l_rgh_lines)
      CHARACTER(LEN=1)    :: s_vec_awnd_origprec_neglog(l_rgh_lines) 
c*****
c     Variables to assess qc
      CHARACTER(LEN=1)    :: s_vec_tmax_qc(l_rgh_lines)
      CHARACTER(LEN=1)    :: s_vec_tmin_qc(l_rgh_lines)
      CHARACTER(LEN=1)    :: s_vec_tavg_qc(l_rgh_lines)
      CHARACTER(LEN=1)    :: s_vec_prcp_qc(l_rgh_lines)
      CHARACTER(LEN=1)    :: s_vec_snow_qc(l_rgh_lines)
      CHARACTER(LEN=1)    :: s_vec_awnd_qc(l_rgh_lines)

      CHARACTER(LEN=1)    :: s_vec_tmax_qc_ncepcode(l_rgh_lines)
      CHARACTER(LEN=1)    :: s_vec_tmin_qc_ncepcode(l_rgh_lines)
      CHARACTER(LEN=1)    :: s_vec_tavg_qc_ncepcode(l_rgh_lines)
      CHARACTER(LEN=1)    :: s_vec_prcp_qc_ncepcode(l_rgh_lines)
      CHARACTER(LEN=1)    :: s_vec_snow_qc_ncepcode(l_rgh_lines)
      CHARACTER(LEN=1)    :: s_vec_awnd_qc_ncepcode(l_rgh_lines)

      CHARACTER(LEN=2)    :: s_vec_tmax_qc_cdmqcmethod(l_rgh_lines)
      CHARACTER(LEN=2)    :: s_vec_tmin_qc_cdmqcmethod(l_rgh_lines)
      CHARACTER(LEN=2)    :: s_vec_tavg_qc_cdmqcmethod(l_rgh_lines)
      CHARACTER(LEN=2)    :: s_vec_prcp_qc_cdmqcmethod(l_rgh_lines)
      CHARACTER(LEN=2)    :: s_vec_snow_qc_cdmqcmethod(l_rgh_lines)
      CHARACTER(LEN=2)    :: s_vec_awnd_qc_cdmqcmethod(l_rgh_lines)
c*****
c     Get GHCND source letter
      CHARACTER(LEN=1)    :: s_vec_tmax_sourcelett(l_rgh_lines)
      CHARACTER(LEN=1)    :: s_vec_tmin_sourcelett(l_rgh_lines)
      CHARACTER(LEN=1)    :: s_vec_tavg_sourcelett(l_rgh_lines)
      CHARACTER(LEN=1)    :: s_vec_prcp_sourcelett(l_rgh_lines)
      CHARACTER(LEN=1)    :: s_vec_snow_sourcelett(l_rgh_lines)
      CHARACTER(LEN=1)    :: s_vec_awnd_sourcelett(l_rgh_lines)

      INTEGER             :: i_vec_tmax_test2_flag(l_rgh_lines)
      INTEGER             :: i_vec_tmin_test2_flag(l_rgh_lines)
      INTEGER             :: i_vec_tavg_test2_flag(l_rgh_lines)
      INTEGER             :: i_vec_prcp_test2_flag(l_rgh_lines)
      INTEGER             :: i_vec_snow_test2_flag(l_rgh_lines)
      INTEGER             :: i_vec_awnd_test2_flag(l_rgh_lines)

      CHARACTER(LEN=3)    :: s_vec_tmax_sourcenum(l_rgh_lines)
      CHARACTER(LEN=3)    :: s_vec_tmin_sourcenum(l_rgh_lines)
      CHARACTER(LEN=3)    :: s_vec_tavg_sourcenum(l_rgh_lines)
      CHARACTER(LEN=3)    :: s_vec_prcp_sourcenum(l_rgh_lines)
      CHARACTER(LEN=3)    :: s_vec_snow_sourcenum(l_rgh_lines)
      CHARACTER(LEN=3)    :: s_vec_awnd_sourcenum(l_rgh_lines)

      CHARACTER(LEN=2)    :: s_vec_tmax_recordnum(l_rgh_lines)
      CHARACTER(LEN=2)    :: s_vec_tmin_recordnum(l_rgh_lines)
      CHARACTER(LEN=2)    :: s_vec_tavg_recordnum(l_rgh_lines)
      CHARACTER(LEN=2)    :: s_vec_prcp_recordnum(l_rgh_lines)
      CHARACTER(LEN=2)    :: s_vec_snow_recordnum(l_rgh_lines)
      CHARACTER(LEN=2)    :: s_vec_awnd_recordnum(l_rgh_lines)

      INTEGER             :: i_vec_tmax_qcmod_flag(l_rgh_lines)
      INTEGER             :: i_vec_tmin_qcmod_flag(l_rgh_lines)
      INTEGER             :: i_vec_tavg_qcmod_flag(l_rgh_lines)
      INTEGER             :: i_vec_prcp_qcmod_flag(l_rgh_lines)
      INTEGER             :: i_vec_snow_qcmod_flag(l_rgh_lines)
      INTEGER             :: i_vec_awnd_qcmod_flag(l_rgh_lines)

c*****
c     Variables for conversion of temperature variables
      REAL                :: f_vec_tmax_k(l_rgh_lines)
      REAL                :: f_vec_tmin_k(l_rgh_lines)
      REAL                :: f_vec_tavg_k(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_tmax_k(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_tmin_k(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_tavg_k(l_rgh_lines)

      CHARACTER(LEN=10)   :: s_vec_tmax_convprec_k(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_tmin_convprec_k(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_tavg_convprec_k(l_rgh_lines)
c*****
c     Variables originally from stnconfig-read
      INTEGER             :: l_collect_cnt

      CHARACTER(LEN=l_scfield) :: s_collect_primary_id(20)     !20
      CHARACTER(LEN=l_scfield) :: s_collect_record_number(20)  !2
      CHARACTER(LEN=l_scfield) :: s_collect_secondary_id(20)   !20
      CHARACTER(LEN=l_scfield) :: s_collect_station_name(20)   !50
      CHARACTER(LEN=l_scfield) :: s_collect_longitude(20)      !10
      CHARACTER(LEN=l_scfield) :: s_collect_latitude(20)       !10
      CHARACTER(LEN=l_scfield):: 
     +  s_collect_height_station_above_sea_level(20) !10
      CHARACTER(LEN=l_scfield) :: s_collect_data_policy_licence(20) !1
      CHARACTER(LEN=l_scfield) :: s_collect_source_id(20)      !3

c     Variables originally from stnconfig-write
      CHARACTER(LEN=l_scfield) :: s_collect_region(20)
      CHARACTER(LEN=l_scfield) :: s_collect_operating_territory(20)
      CHARACTER(LEN=l_scfield) :: s_collect_station_type(20)
      CHARACTER(LEN=l_scfield) :: s_collect_platform_type(20)
      CHARACTER(LEN=l_scfield) :: s_collect_platform_sub_type(20)
      CHARACTER(LEN=l_scfield) ::s_collect_primary_station_id_scheme(20)
      CHARACTER(LEN=l_scfield) :: s_collect_location_accuracy(20)
      CHARACTER(LEN=l_scfield) :: s_collect_location_method(20)
      CHARACTER(LEN=l_scfield) :: s_collect_location_quality(20)
      CHARACTER(LEN=l_scfield) :: s_collect_station_crs(20)
      CHARACTER(LEN=l_scfield) ::
     +    s_collect_height_station_above_local_ground(20)
      CHARACTER(LEN=l_scfield) ::
     +    s_collect_height_station_above_sea_level_acc(20)
      CHARACTER(LEN=l_scfield) :: s_collect_sea_level_datum(20)

c     Archives up to 50 column & 20 lines from stnconfig-write file
      CHARACTER(LEN=l_scfield) :: s_collect_datalines(20,50)

      INTEGER             :: l_collect_distinct
      CHARACTER(LEN=1)    :: s_collect_flagambig(20)
c*****
      INTEGER             :: l_lines
      INTEGER             :: i_linelength_max
      INTEGER             :: i_linelength_min
      INTEGER             :: l_field
      INTEGER             :: i_len_header

      LOGICAL             :: there
      CHARACTER(LEN=3)    :: s_filestatus1

      INTEGER             :: i_count_alldatalines

c*****
c     Archive variables by record number & variable channel number
      CHARACTER(LEN=10)   :: s_arch_date_st_yyyy_mm_dd(20,l_varselect)
      CHARACTER(LEN=10)   :: s_arch_date_en_yyyy_mm_dd(20,l_varselect)
      INTEGER             :: i_arch_cnt(20,l_varselect)

      INTEGER             :: i_flag
      INTEGER             :: i_flag_cat2
      INTEGER             :: i_flag_cat4
      INTEGER             :: i_cnt_cat2_allcase
      INTEGER             :: i_cnt_cat4_allcase
      INTEGER             :: i_flag_linenumber
      CHARACTER(LEN=4)    :: s_flag_varname

      INTEGER             :: i_start

c************************************************************************
      print*,'just entered station_loop_process20200520'

c      DO i=1,l_scoutput_numfield
c       print*,'s_scoutput_vec_header=',i,TRIM(s_scoutput_vec_header(i))
c      ENDDO
c      STOP 'process_gsom_files20200520'

c************************************************************************
c     Read in last file number
      CALL readin_lastfile_number20200603(
     +  s_directory_output_lastfile,
     +  i_start)

c      print*,'i_start=',i_start,l_subset
c************************************************************************
c      STOP 'station_loop_process20200520'

      ii=0

      i_bad =0
      i_good=0
      i_bad_recordnumber =0
      i_bad_recordnumber_cat4thresh=0
      i_bad_sourceletter =0
      i_bad_sourceletter_cat2thresh=0
      i_bad_newletter    =0
      i_bad_stnconlisting=0
      i_bad_cdmmaker     =0

c     case 2 example i=160
c     case 4 example i=179

      DO i=1,l_subset !13298,13298 !l_subset !1,l_subset !10167,30000  !1good, 7good; rest of 10 bad

       print*,'start loop',i,TRIM(s_stnname(i)),l_subset

       s_stnname_single=TRIM(s_stnname(i))

       s_pathandname=
     +  TRIM(s_directory_gsom)//TRIM(s_stnname_single)//'.csv'

       print*,'s_pathandname=',TRIM(s_pathandname)
c************************************************************************
c       print*,'aa'

c      Get info from stn_config file
       i_flag=0   !initialize bad flag to 0
       CALL get_singles_stnconfig_v5(i_flag,s_stnname_single,
     +  l_scoutput_rgh,l_scoutput,l_scfield,l_scoutput_numfield,
     +  s_scoutput_vec_header,s_scoutput_mat_fields,

     +  l_collect_cnt,
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

     +  s_collect_datalines,

     +  l_collect_distinct,
     +  s_collect_flagambig)

c       TEST1: already covered by SN
c       If no stnconfig file, then station skipped completely
        IF (i_flag.EQ.1) THEN 
         print*,'no stnconfig_listing condition'

         i_bad_stnconlisting=i_bad_stnconlisting+1

c        Export list of station not in selection list
         CALL export_test1(s_date_st,s_time_st,s_zone_st,
     +    i_bad_stnconlisting,
     +    s_directory_output_diagnostics,s_filename_test1,
     +    i,s_stnname_single)

c         STOP 'station_loop_process'

         GOTO 51
        ENDIF

c       print*,'l_collect_cnt=',l_collect_cnt
c       STOP 'station_loop_process20200520'

c************************************************************************
c      See if file exists
       INQUIRE(FILE=TRIM(s_pathandname),
     +   EXIST=there)
       IF (there) THEN
         s_filestatus1='YES'
       ENDIF
       IF (.NOT.(there)) THEN
         s_filestatus1='NO '

c         print*,'station not found'
c         print*,'='//TRIM(s_pathandname)//'='
c         STOP 'station_loop_process20200520'
       ENDIF

c       print*,'s_filestatus1=',s_filestatus1
c       STOP 'station_loop_process20200520'
c************************************************************************
c      Case of absent file
       IF (s_filestatus1.EQ.'NO ') THEN
        i_bad=i_bad+1
       ENDIF

c      Case of good file
       IF (s_filestatus1.EQ.'YES') THEN 

        i_good=i_good+1

c       Get datalines from source file
        CALL get_gsom_datalines20200523(s_pathandname,
     +    l_varselect,s_varselect,
     +    f_ndflag, 
     +    l_rgh_lines,

     +    l_lines,
     +    l_rgh_lle,
     +    s_vec_date,s_vec_lat,s_vec_lon,s_vec_elev,
     +    f_vec_lat_deg,f_vec_lon_deg,f_vec_elev_m,
     +    f_vec_tmax_c,f_vec_tmin_c,f_vec_tavg_c,
     +    f_vec_prcp_mm,f_vec_snow_mm,f_vec_awnd_ms,
     +    s_vec_tmax_c,s_vec_tmin_c,s_vec_tavg_c,
     +    s_vec_prcp_mm,s_vec_snow_mm,s_vec_awnd_ms,
     +    s_vec_tmax_attrib,s_vec_tmin_attrib,s_vec_tavg_attrib,
     +    s_vec_prcp_attrib,s_vec_snow_attrib,s_vec_awnd_attrib,
     +    i_len_header,
     +    i_linelength_max,i_linelength_min,l_field)

c       Make 4 decimal place strings for lat-lon
        CALL latlon_4decimal20200523(l_rgh_lines,l_lines,
     +    s_vec_lat,s_vec_lon,f_vec_lat_deg,f_vec_lon_deg,

     +    s_vec_lat_4dec,s_vec_lon_4dec)

c       Find original precision from histogram analysis of original strings
c       NOTE: origprec: 1st procedure based on count of decimal places in number
c             origprec_empir 2nd procedure based on histogram analysis 
c             of decimal position
        CALL find_original_precision2(l_rgh_lines,l_lines,
     +    s_vec_tmax_c,s_vec_tmin_c,s_vec_tavg_c,
     +    s_vec_prcp_mm,s_vec_snow_mm,s_vec_awnd_ms,
     +    s_vec_tmax_origprec_c,s_vec_tmin_origprec_c,
     +    s_vec_tavg_origprec_c,s_vec_prcp_origprec_mm,
     +    s_vec_snow_origprec_mm,s_vec_awnd_origprec_ms,
     +    s_vec_tmax_origprec_neglog,s_vec_tmin_origprec_neglog,
     +    s_vec_tavg_origprec_neglog,s_vec_prcp_origprec_neglog,
     +    s_vec_snow_origprec_neglog,s_vec_awnd_origprec_neglog,
     +    s_vec_tmax_origprec_empir_c,s_vec_tmin_origprec_empir_c,
     +    s_vec_tavg_origprec_empir_c,s_vec_prcp_origprec_empir_mm,
     +    s_vec_snow_origprec_empir_mm,s_vec_awnd_origprec_empir_ms)

c       Get QC flag from attributes       
        CALL get_qc_from_attrib20210204(l_rgh_lines,l_lines,
     +    s_vec_tmax_attrib,s_vec_tmin_attrib,s_vec_tavg_attrib,
     +    s_vec_prcp_attrib,s_vec_snow_attrib,s_vec_awnd_attrib,
     +    s_vec_tmax_qc,s_vec_tmin_qc,s_vec_tavg_qc,
     +    s_vec_prcp_qc,s_vec_snow_qc,s_vec_awnd_qc,
     +    s_vec_tmax_qc_ncepcode,s_vec_tmin_qc_ncepcode,
     +    s_vec_tavg_qc_ncepcode,s_vec_prcp_qc_ncepcode,
     +    s_vec_snow_qc_ncepcode,s_vec_awnd_qc_ncepcode)

c      Set qcmethod from ncep code here
       CALL set_qcmethod_code(s_qckey_timescale_spec,l_qckey,
     +    s_qckey_sourceflag,s_qckey_c3sflag,s_qckey_timescale,
     +    l_rgh_lines,l_lines,
     +    s_vec_tmax_qc,s_vec_tmin_qc,s_vec_tavg_qc,
     +    s_vec_prcp_qc,s_vec_snow_qc,s_vec_awnd_qc,
     +    s_vec_tmax_qc_ncepcode,s_vec_tmin_qc_ncepcode,
     +    s_vec_tavg_qc_ncepcode,s_vec_prcp_qc_ncepcode,
     +    s_vec_snow_qc_ncepcode,s_vec_awnd_qc_ncepcode,

     +    s_vec_tmax_qc_cdmqcmethod,s_vec_tmin_qc_cdmqcmethod,
     +    s_vec_tavg_qc_cdmqcmethod,s_vec_prcp_qc_cdmqcmethod,
     +    s_vec_snow_qc_cdmqcmethod,s_vec_awnd_qc_cdmqcmethod)

c       Get source character from attribution string
        CALL get_source_char_from_attrib3(
     +    i_flag,i_flag_cat2,i_cnt_cat2_allcase,
     +    i_flag_linenumber,s_flag_varname,
     +    l_rgh_lines,l_lines,
     +    s_vec_tmax_c,s_vec_tmin_c,s_vec_tavg_c,
     +    s_vec_prcp_mm,s_vec_snow_mm,s_vec_awnd_ms,
     +    s_vec_tmax_attrib,s_vec_tmin_attrib,
     +    s_vec_tavg_attrib,s_vec_prcp_attrib,
     +    s_vec_snow_attrib,s_vec_awnd_attrib,
     +    s_vec_tmax_sourcelett,s_vec_tmin_sourcelett,
     +    s_vec_tavg_sourcelett,s_vec_prcp_sourcelett,
     +    s_vec_snow_sourcelett,s_vec_awnd_sourcelett,
     +    i_vec_tmax_test2_flag,i_vec_tmin_test2_flag,
     +    i_vec_tavg_test2_flag,i_vec_prcp_test2_flag,
     +    i_vec_snow_test2_flag,i_vec_awnd_test2_flag)

c        print*,'bad letter test i_flag=',i_flag

c       TEST2a - condition to abandon station test
        IF (i_cnt_cat2_allcase.GT.10) THEN
         i_bad_sourceletter_cat2thresh=i_bad_sourceletter_cat2thresh+1
        ENDIF

c       TEST2 - NO SOURCE LETTER PRESENT
c       ABANDON STATION if category 2 flag found (no alternatives found) 
        IF (i_flag_cat2.EQ.1) THEN 
c        IF (i_flag.EQ.1) THEN 
         print*,'bad_letter condition, TEST2 failed'

         i_bad_sourceletter=i_bad_sourceletter+1 

         CALL export_test2(s_date_st,s_time_st,s_zone_st,
     +    i_bad_sourceletter,
     +    s_directory_output_diagnostics,s_filename_test2,
     +    i,s_stnname_single,
     +    i_flag_linenumber,s_flag_varname,
     +    l_rgh_lines,l_lines,
     +    s_vec_date,
     +    s_vec_tmax_c,s_vec_tmin_c,s_vec_tavg_c,
     +    s_vec_prcp_mm,s_vec_snow_mm,s_vec_awnd_ms,
     +    s_vec_tmax_attrib,s_vec_tmin_attrib,
     +    s_vec_tavg_attrib,s_vec_prcp_attrib,
     +    s_vec_snow_attrib,s_vec_awnd_attrib,
     +    s_vec_tmax_sourcelett,s_vec_tmin_sourcelett,
     +    s_vec_tavg_sourcelett,s_vec_prcp_sourcelett,
     +    s_vec_snow_sourcelett,s_vec_awnd_sourcelett)

c         STOP 'station_loop_process; test2'

c         GOTO 51    !skip entire record in category 2 situation
        ENDIF

c       Get number from source character
        CALL source_number_from_character(i_flag,
     +    l_source_rgh,l_source,
     +    s_source_name,s_source_codeletter,s_source_codenumber,
     +    l_rgh_lines,l_lines,
     +    s_vec_tmax_sourcelett,s_vec_tmin_sourcelett,
     +    s_vec_tavg_sourcelett,s_vec_prcp_sourcelett,
     +    s_vec_snow_sourcelett,s_vec_awnd_sourcelett,
     +    s_vec_tmax_sourcenum,s_vec_tmin_sourcenum,
     +    s_vec_tavg_sourcenum,s_vec_prcp_sourcenum,
     +    s_vec_snow_sourcenum,s_vec_awnd_sourcenum, 
     +    s_vec_tmax_attrib,s_vec_tmin_attrib,
     +    s_vec_tavg_attrib,s_vec_prcp_attrib,
     +    s_vec_snow_attrib,s_vec_awnd_attrib,
     +    s_vec_tmax_c,s_vec_tmin_c,s_vec_tavg_c,
     +    s_vec_prcp_mm,s_vec_snow_mm,s_vec_awnd_ms)

c       TEST3 - this should be good now
        IF (i_flag.EQ.1) THEN 
         print*,'unrecog_letter condition, test3 failed'

         i_bad_newletter=i_bad_newletter+1 

         STOP 'station_loop_process'

         GOTO 51
        ENDIF

c       Get record_number from source_number
c      print*,'l_collect_cnt=',l_collect_cnt
c      print*,'s_collect_source_id',
c     +   ('='//TRIM(s_collect_source_id(j))//'=',j=1,l_collect_cnt)
c      print*,'s_collect_record_number',
c     +   ('='//TRIM(s_collect_record_number(j))//'=',j=1,l_collect_cnt)
c      STOP 'station_loop_process'

        CALL record_number_from_source_number3(
     +    i_flag,i_flag_cat4,i_cnt_cat4_allcase,
     +    i_flag_linenumber,s_flag_varname,
     +    l_collect_cnt,
     +    s_collect_record_number,s_collect_source_id,
     +    s_collect_data_policy_licence,
     +    l_rgh_lines,l_lines,
     +    s_vec_tmax_c,s_vec_tmin_c,s_vec_tavg_c,
     +    s_vec_prcp_mm,s_vec_snow_mm,s_vec_awnd_ms,
     +    s_vec_tmax_sourcenum,s_vec_tmin_sourcenum,
     +    s_vec_tavg_sourcenum,s_vec_prcp_sourcenum,
     +    s_vec_snow_sourcenum,s_vec_awnd_sourcenum,

     +    s_vec_tmax_recordnum,s_vec_tmin_recordnum,
     +    s_vec_tavg_recordnum,s_vec_prcp_recordnum,
     +    s_vec_snow_recordnum,s_vec_awnd_recordnum,
     +    i_vec_tmax_qcmod_flag,i_vec_tmin_qcmod_flag,
     +    i_vec_tavg_qcmod_flag,i_vec_prcp_qcmod_flag,
     +    i_vec_snow_qcmod_flag,i_vec_awnd_qcmod_flag)

c        STOP 'station_loop_process'

c       TEST4a - condition to abandon station test
        IF (i_cnt_cat4_allcase.GT.10) THEN
         i_bad_recordnumber_cat4thresh=i_bad_recordnumber_cat4thresh+1
        ENDIF

c       TEST4: Emergency exit of station
        IF (i_flag_cat4.EQ.1) THEN
c        IF (i_flag.EQ.1) THEN

         i_bad_recordnumber=i_bad_recordnumber+1 

          print*,'TEST4 condition failed'
c         print*,'s_stnname_single=',s_stnname_single

         CALL export_test4(s_date_st,s_time_st,s_zone_st,
     +    i_bad_recordnumber,
     +    s_directory_output_diagnostics,s_filename_test4,
     +    i,s_stnname_single,
     +    i_flag_linenumber,s_flag_varname,
     +    l_collect_cnt,
     +    s_collect_record_number,s_collect_source_id,
     +    l_rgh_lines,l_lines,
     +    s_vec_date,
     +    s_vec_tmax_c,s_vec_tmin_c,s_vec_tavg_c,
     +    s_vec_prcp_mm,s_vec_snow_mm,s_vec_awnd_ms,
     +    s_vec_tmax_attrib,s_vec_tmin_attrib,
     +    s_vec_tavg_attrib,s_vec_prcp_attrib,
     +    s_vec_snow_attrib,s_vec_awnd_attrib,
     +    s_vec_tmax_sourcelett,s_vec_tmin_sourcelett,
     +    s_vec_tavg_sourcelett,s_vec_prcp_sourcelett,
     +    s_vec_snow_sourcelett,s_vec_awnd_sourcelett,
     +    s_vec_tmax_sourcenum,s_vec_tmin_sourcenum,
     +    s_vec_tavg_sourcenum,s_vec_prcp_sourcenum,
     +    s_vec_snow_sourcenum,s_vec_awnd_sourcenum)

c         STOP 'station_loop_process; crash program at test4'

c         GOTO 51
        ENDIF

c       Modify qc on the basis of the qcmod_flag
c       05Feb2021: removed subroutine because value set to unacceptable 4
c        CALL modify_qc_code(l_rgh_lines,l_lines,
c     +    s_vec_tmax_qc,s_vec_tmin_qc,s_vec_tavg_qc,
c     +    s_vec_prcp_qc,s_vec_snow_qc,s_vec_awnd_qc,
c     +    i_vec_tmax_qcmod_flag,i_vec_tmin_qcmod_flag,
c     +    i_vec_tavg_qcmod_flag,i_vec_prcp_qcmod_flag,
c     +    i_vec_snow_qcmod_flag,i_vec_awnd_qcmod_flag)

c       Convert variables from C to K
        CALL convert_variables2(f_ndflag,
     +    l_rgh_lines,l_lines,
     +    f_vec_tmax_c,f_vec_tmin_c,f_vec_tavg_c,
     +    s_vec_tmax_origprec_neglog,s_vec_tmin_origprec_neglog,
     +    s_vec_tavg_origprec_neglog,

     +    f_vec_tmax_k,f_vec_tmin_k,f_vec_tavg_k,
     +    s_vec_tmax_k,s_vec_tmin_k,s_vec_tavg_k)

c       Declare converted precision; declared based on 273.15
        CALL declare_converted_var_precision(l_rgh_lines,l_lines,
     +    s_vec_tmax_convprec_k,s_vec_tmin_convprec_k,
     +    s_vec_tavg_convprec_k)

c       Count occurrences of any variables
        CALL count_occurrence_variables(l_rgh_lines,l_lines,
     +    s_vec_tmax_c,s_vec_tmin_c,s_vec_tavg_c,
     +    s_vec_prcp_mm,s_vec_snow_mm,s_vec_awnd_ms,

     +    i_count_alldatalines)

c       Make header & observation & get recept info
c        print*,'l_collect_cnt=',l_collect_cnt
c        STOP 'station_loop_process'
        CALL make_header_observation_lite20210203(i_flag,f_ndflag,
     +    s_date_st,s_time_st,s_zone_st,
     +    s_directory_output_header,s_directory_output_observation,
     +    s_directory_output_lite,s_directory_output_qc,
     +    s_directory_output_receipt_linecount, 
     +    s_stnname(i),
     +    l_rgh_lines,l_lines,
     +    s_vec_date,s_vec_lat_4dec,s_vec_lon_4dec,s_vec_elev,
     +    f_vec_lat_deg,f_vec_lon_deg,f_vec_elev_m,
     +    s_vec_tmax_c,s_vec_tmin_c,s_vec_tavg_c,
     +    s_vec_prcp_mm,s_vec_snow_mm,s_vec_awnd_ms,
     +    s_vec_tmax_k,s_vec_tmin_k,s_vec_tavg_k,
     +    f_vec_tmax_c,f_vec_tmin_c,f_vec_tavg_c,
     +    f_vec_prcp_mm,f_vec_snow_mm,f_vec_awnd_ms,
     +    f_vec_tmax_k,f_vec_tmin_k,f_vec_tavg_k,

     +    s_vec_tmax_qc,s_vec_tmin_qc,s_vec_tavg_qc,
     +    s_vec_prcp_qc,s_vec_snow_qc,s_vec_awnd_qc,
     +    s_vec_tmax_qc_cdmqcmethod,s_vec_tmin_qc_cdmqcmethod,
     +    s_vec_tavg_qc_cdmqcmethod,s_vec_prcp_qc_cdmqcmethod,
     +    s_vec_snow_qc_cdmqcmethod,s_vec_awnd_qc_cdmqcmethod,
     +    s_vec_tmax_origprec_c,s_vec_tmin_origprec_c,
     +    s_vec_tavg_origprec_c,s_vec_prcp_origprec_mm,
     +    s_vec_snow_origprec_mm,s_vec_awnd_origprec_ms,
     +    s_vec_tmax_origprec_empir_c,s_vec_tmin_origprec_empir_c,
     +    s_vec_tavg_origprec_empir_c,s_vec_prcp_origprec_empir_mm,
     +    s_vec_snow_origprec_empir_mm,s_vec_awnd_origprec_empir_ms,
     +    s_vec_tmax_convprec_k,s_vec_tmin_convprec_k,
     +    s_vec_tavg_convprec_k,

     +    s_vec_tmax_sourcenum,s_vec_tmin_sourcenum,
     +    s_vec_tavg_sourcenum,s_vec_prcp_sourcenum,
     +    s_vec_snow_sourcenum,s_vec_awnd_sourcenum,
     +    s_vec_tmax_recordnum,s_vec_tmin_recordnum,
     +    s_vec_tavg_recordnum,s_vec_prcp_recordnum,
     +    s_vec_snow_recordnum,s_vec_awnd_recordnum,

     +    l_varselect,
     +    s_code_observation,s_code_unit,
     +    s_code_value_significance,s_code_unit_original,
     +    s_code_conversion_method,s_code_conversion_flag,
     +    s_predef_numerical_precision,s_predef_hgt_obs_above_sfc,
   
     +  l_collect_cnt,l_collect_distinct,l_scfield,
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

     +  i_arch_cnt,s_arch_date_st_yyyy_mm_dd,s_arch_date_en_yyyy_mm_dd)

c     +    i_vec_tmax_qcmod_flag,i_vec_tmin_qcmod_flag,
c     +    i_vec_tavg_qcmod_flag,i_vec_prcp_qcmod_flag,
c     +    i_vec_snow_qcmod_flag,i_vec_awnd_qcmod_flag,

c       TEST5: Emergency exit of station
        IF (i_flag.EQ.1) THEN

         print*,'test5 condition failed (bad recordnr in CDM maker)'

         i_bad_cdmmaker=i_bad_cdmmaker+1

c         STOP 'station_loop_process'
 
c         GOTO 51
        ENDIF


c      DO ii=1,l_scoutput_numfield
c       print*,'s_scoutput_vec_header=',
c     +   ii,TRIM(s_scoutput_vec_header(ii))
c      ENDDO
c      STOP 'station_loop_process20200520'

c      New stnconfig file
       CALL make_new_stnconfig2(s_directory_output_receipt,
     +  s_stnname(i),
     +  l_varselect,s_code_observation,
     +  l_collect_cnt,l_scoutput_numfield,l_scfield,
     +  s_scoutput_vec_header,s_collect_datalines,
     +  i_arch_cnt,s_arch_date_st_yyyy_mm_dd,s_arch_date_en_yyyy_mm_dd)



       ENDIF

 51    CONTINUE

c      Export index of finished file
       CALL export_last_index20200603(
     +   s_directory_output_lastfile,i,ii,
     +   i_values_st,
     +   i_bad_stnconlisting,i_bad_sourceletter,i_bad_newletter,
     +   i_bad_recordnumber,i_bad_cdmmaker)

       print*,'INTERIM TALLY'
       print*,'i_bad_recordnumber(t4)=', i_bad_recordnumber
       print*,'i_bad_recordnumber_cat4thresh(t4a)=', 
     +    i_bad_recordnumber_cat4thresh
       print*,'i_bad_sourceletter(t2)=', i_bad_sourceletter
       print*,'i_bad_sourceletter_cat2thresh(t2a)=',
     +    i_bad_sourceletter_cat2thresh
       print*,'i_bad_newletter(t3)=',    i_bad_newletter
       print*,'i_bad_stnconlisting(t1)=',i_bad_stnconlisting
       print*,'i_bad_cdmmaker(t5)=',     i_bad_cdmmaker

      ENDDO    !close i main station loop

      print*,'FINAL TALLY'
      print*,'i_bad_recordnumber(t4)=', i_bad_recordnumber
       print*,'i_bad_recordnumber_cat4thresh(t4a)=', 
     +    i_bad_recordnumber_cat4thresh
      print*,'i_bad_sourceletter(t2)=', i_bad_sourceletter
       print*,'i_bad_sourceletter_cat2thresh(t2a)=',
     +    i_bad_sourceletter_cat2thresh
      print*,'i_bad_newletter(t3)=',    i_bad_newletter
      print*,'i_bad_stnconlisting(t1)=',i_bad_stnconlisting
      print*,'i_bad_cdmmaker(t5)=',     i_bad_cdmmaker

      print*,'just leaving station_loop_process'
c      STOP 'station_loop_process'

      RETURN
      END
