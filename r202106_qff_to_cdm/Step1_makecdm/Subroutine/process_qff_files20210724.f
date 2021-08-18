c     Subroutine to process qff files
c     AJ_Kettle, 19Nov2019
c     20200607: modified width source_id field from 4 to 8
c     20200609: modified width source_id field from 16 to 32
c     20210216: modified to handle different qff format
c     20210724: export list of stations not found from wish list

      SUBROUTINE process_qff_files20210724(
     +  s_date_st,s_time_st,s_zone_st,i_values_st,
     +  s_directory_output_header,s_directory_output_observation,
     +  s_directory_output_lite,s_directory_output_receipt,
     +  s_directory_output_lastfile,s_directory_output_diagnostics,
     +  s_directory_output_diagnostics_segfault,
     +  s_directory_output_diagnostics_notthere,
     +  s_directory_output_qc,s_directory_output_receipt_linecount,
     +  s_directory_file_source,
     +  s_directory_temp,
     +  l_rgh_files,l_files,s_vec_files,
     +  f_ndflag,
     +  l_scoutput_rgh,l_scoutput,ilen,
     +  s_scoutput_stnconfig_lines,
     +  s_scoutput_header,s_scoutput_searchname,
     +  s_qckey_timescale_spec,l_qckey,
     +  s_qckey_sourceflag,s_qckey_c3sflag,s_qckey_timescale)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into subroutine

      CHARACTER(LEN=8)    :: s_date_st
      CHARACTER(LEN=10)   :: s_time_st
      CHARACTER(LEN=5)    :: s_zone_st
      INTEGER             :: i_values_st(8)

      CHARACTER(LEN=300)  :: s_directory_output_header
      CHARACTER(LEN=300)  :: s_directory_output_observation
      CHARACTER(LEN=300)  :: s_directory_output_lite
      CHARACTER(LEN=300)  :: s_directory_output_receipt
      CHARACTER(LEN=300)  :: s_directory_output_lastfile
      CHARACTER(LEN=300)  :: s_directory_output_diagnostics
      CHARACTER(LEN=300)  :: s_directory_output_diagnostics_segfault
      CHARACTER(LEN=300)  :: s_directory_output_diagnostics_notthere
      CHARACTER(LEN=300)  :: s_directory_output_qc
      CHARACTER(LEN=300)  :: s_directory_output_receipt_linecount

      CHARACTER(LEN=300)  :: s_directory_file_source

      CHARACTER(LEN=300)  :: s_directory_temp

      INTEGER             :: l_rgh_files
      INTEGER             :: l_files
      CHARACTER(LEN=300)  :: s_vec_files(l_rgh_files)

      REAL                :: f_ndflag

c     info new qc table
      CHARACTER(LEN=300)  :: s_qckey_timescale_spec
      INTEGER             :: l_qckey
      CHARACTER(LEN=2)    :: s_qckey_sourceflag(100)
      CHARACTER(LEN=2)    :: s_qckey_c3sflag(100)
      CHARACTER(LEN=300)  :: s_qckey_timescale(100)
c*****
c     Stnconfig information
      INTEGER             :: l_scoutput_rgh
      INTEGER             :: l_scoutput
c      INTEGER             :: l_scoutput_numfield
      INTEGER             :: ilen
       
      CHARACTER(LEN=*)    :: s_scoutput_header
      CHARACTER(LEN=*)    :: s_scoutput_stnconfig_lines(l_scoutput_rgh)
      CHARACTER(LEN=*)    :: s_scoutput_searchname(l_scoutput_rgh)   !16
c*****
c     Variables originally from stnconfig-read
      INTEGER,PARAMETER   :: l_cc_rgh=100     !record nrs expected for stn
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

c     Archives up to 50 column & 20 lines from stnconfig-write file
      CHARACTER(LEN=ilen) :: s_collect_datalines(l_cc_rgh,50)
      CHARACTER(LEN=ilen) :: s_collect_vec_header(50)
      INTEGER             :: l_collect_numfield


      INTEGER             :: l_collect_distinct
      CHARACTER(LEN=1)    :: s_collect_flagambig(l_cc_rgh)
c*****
c*****
c*****
c     Variables used in subroutine

      INTEGER             :: i,j,k,ii,jj,kk
      CHARACTER(LEN=300)  :: s_file_single
      CHARACTER(LEN=300)  :: s_stnname_isolated
      CHARACTER(LEN=300)  :: s_stnlook

c     28Oct2020: trial failed with 2 000 000 line allocation
      INTEGER,PARAMETER   :: l_rgh=1300000 !1200000 !1000000
      INTEGER             :: l_lines

      INTEGER             :: i_start

c     master variable declarations here
      CHARACTER(LEN=16)   :: s_vec_station_id(l_rgh)
      CHARACTER(LEN=64)   :: s_vec_station_name(l_rgh)
      CHARACTER(LEN=4)    :: s_vec_year(l_rgh)
      CHARACTER(LEN=2)    :: s_vec_month(l_rgh)
      CHARACTER(LEN=2)    :: s_vec_day(l_rgh)
      CHARACTER(LEN=2)    :: s_vec_hour(l_rgh)
      CHARACTER(LEN=2)    :: s_vec_minute(l_rgh)
      CHARACTER(LEN=32)   :: s_vec_latitude(l_rgh)
      CHARACTER(LEN=32)   :: s_vec_longitude(l_rgh)
      CHARACTER(LEN=32)   :: s_vec_elevation(l_rgh)
      CHARACTER(LEN=32)   :: s_vec_airt_c(l_rgh)
      CHARACTER(LEN=8)    :: s_vec_airt_source_id(l_rgh)
      CHARACTER(LEN=8)    :: s_vec_airt_qc_flag(l_rgh)
      CHARACTER(LEN=32)   :: s_vec_dewp_c(l_rgh)
      CHARACTER(LEN=8)    :: s_vec_dewp_source_id(l_rgh)
      CHARACTER(LEN=8)    :: s_vec_dewp_qc_flag(l_rgh)
      CHARACTER(LEN=32)   :: s_vec_stnp_hpa(l_rgh)
      CHARACTER(LEN=8)    :: s_vec_stnp_source_id(l_rgh)
      CHARACTER(LEN=8)    :: s_vec_stnp_qc_flag(l_rgh)
      CHARACTER(LEN=32)   :: s_vec_slpr_hpa(l_rgh)
      CHARACTER(LEN=8)    :: s_vec_slpr_source_id(l_rgh)
      CHARACTER(LEN=8)    :: s_vec_slpr_qc_flag(l_rgh)
      CHARACTER(LEN=32)   :: s_vec_wdir_deg(l_rgh)
      CHARACTER(LEN=8)    :: s_vec_wdir_source_id(l_rgh)
      CHARACTER(LEN=8)    :: s_vec_wdir_qc_flag(l_rgh)
      CHARACTER(LEN=32)   :: s_vec_wspd_ms(l_rgh)
      CHARACTER(LEN=8)    :: s_vec_wspd_source_id(l_rgh)
      CHARACTER(LEN=8)    :: s_vec_wspd_qc_flag(l_rgh)
c*****
c     Variables to assess original precision
      CHARACTER(LEN=32)   :: s_vec_airt_origprec_c(l_rgh) 
      CHARACTER(LEN=32)   :: s_vec_dewp_origprec_c(l_rgh)
      CHARACTER(LEN=32)   :: s_vec_stnp_origprec_hpa(l_rgh)
      CHARACTER(LEN=32)   :: s_vec_slpr_origprec_hpa(l_rgh)
      CHARACTER(LEN=32)   :: s_vec_wdir_origprec_deg(l_rgh)
      CHARACTER(LEN=32)   :: s_vec_wspd_origprec_ms(l_rgh) 

      CHARACTER(LEN=32)   :: s_vec_airt_origprec_empir_c(l_rgh) 
      CHARACTER(LEN=32)   :: s_vec_dewp_origprec_empir_c(l_rgh)
      CHARACTER(LEN=32)   :: s_vec_stnp_origprec_empir_hpa(l_rgh)
      CHARACTER(LEN=32)   :: s_vec_slpr_origprec_empir_hpa(l_rgh)
      CHARACTER(LEN=32)   :: s_vec_wdir_origprec_empir_deg(l_rgh)
      CHARACTER(LEN=32)   :: s_vec_wspd_origprec_empir_ms(l_rgh) 

      CHARACTER(LEN=1)    :: s_vec_airt_origprec_neglog(l_rgh) 
      CHARACTER(LEN=1)    :: s_vec_dewp_origprec_neglog(l_rgh)
      CHARACTER(LEN=1)    :: s_vec_stnp_origprec_neglog(l_rgh)
      CHARACTER(LEN=1)    :: s_vec_slpr_origprec_neglog(l_rgh)
      CHARACTER(LEN=1)    :: s_vec_wdir_origprec_neglog(l_rgh)
      CHARACTER(LEN=1)    :: s_vec_wspd_origprec_neglog(l_rgh) 
c*****
c     Float conversions of all variables
      REAL                :: f_vec_airt_c(l_rgh)
      REAL                :: f_vec_dewp_c(l_rgh)
      REAL                :: f_vec_stnp_hpa(l_rgh)
      REAL                :: f_vec_slpr_hpa(l_rgh)
      REAL                :: f_vec_wdir_deg(l_rgh)
      REAL                :: f_vec_wspd_ms(l_rgh)
c*****
c     Unit conversions of variables
      REAL                :: f_vec_airt_k(l_rgh)
      REAL                :: f_vec_dewp_k(l_rgh)
      REAL                :: f_vec_stnp_pa(l_rgh)
      REAL                :: f_vec_slpr_pa(l_rgh)

      CHARACTER(LEN=32)   :: s_vec_airt_k(l_rgh)
      CHARACTER(LEN=32)   :: s_vec_dewp_k(l_rgh)
      CHARACTER(LEN=32)   :: s_vec_stnp_pa(l_rgh)
      CHARACTER(LEN=32)   :: s_vec_slpr_pa(l_rgh)

      CHARACTER(LEN=32)   :: s_vec_airt_convprec_empir_k(l_rgh) 
      CHARACTER(LEN=32)   :: s_vec_dewp_convprec_empir_k(l_rgh)
      CHARACTER(LEN=32)   :: s_vec_stnp_convprec_empir_pa(l_rgh)
      CHARACTER(LEN=32)   :: s_vec_slpr_convprec_empir_pa(l_rgh)
c*****
c     Record number from stnconfig file matching
      CHARACTER(LEN=2)    :: s_vec_airt_recordnum(l_rgh)
      CHARACTER(LEN=2)    :: s_vec_dewp_recordnum(l_rgh)
      CHARACTER(LEN=2)    :: s_vec_stnp_recordnum(l_rgh)
      CHARACTER(LEN=2)    :: s_vec_slpr_recordnum(l_rgh)
      CHARACTER(LEN=2)    :: s_vec_wdir_recordnum(l_rgh)
      CHARACTER(LEN=2)    :: s_vec_wspd_recordnum(l_rgh)
c*****
c     CDM qc flag
      CHARACTER(LEN=1)    :: s_vec_airt_cdmqc(l_rgh)
      CHARACTER(LEN=1)    :: s_vec_dewp_cdmqc(l_rgh)
      CHARACTER(LEN=1)    :: s_vec_stnp_cdmqc(l_rgh)
      CHARACTER(LEN=1)    :: s_vec_slpr_cdmqc(l_rgh)
      CHARACTER(LEN=1)    :: s_vec_wdir_cdmqc(l_rgh)
      CHARACTER(LEN=1)    :: s_vec_wspd_cdmqc(l_rgh)

      CHARACTER(LEN=2)    :: s_vec_airt_cdmqcmethod(l_rgh)
      CHARACTER(LEN=2)    :: s_vec_dewp_cdmqcmethod(l_rgh)
      CHARACTER(LEN=2)    :: s_vec_stnp_cdmqcmethod(l_rgh)
      CHARACTER(LEN=2)    :: s_vec_slpr_cdmqcmethod(l_rgh)
      CHARACTER(LEN=2)    :: s_vec_wdir_cdmqcmethod(l_rgh)
      CHARACTER(LEN=2)    :: s_vec_wspd_cdmqcmethod(l_rgh)
c*****
      INTEGER             :: i_flag

      INTEGER             :: i_bad_test1_nostnlist
      INTEGER             :: i_bad_test2_floatconvert
      INTEGER             :: i_bad_test3_sourceid_prob
      INTEGER             :: i_bad_test4_segfault
c*****
c     Hardwired codes for CDM writing
      INTEGER,PARAMETER   :: l_varselect=6
      CHARACTER(LEN=3)    :: s_code_observation(l_varselect)
      CHARACTER(LEN=3)    :: s_code_unit(l_varselect)
      CHARACTER(LEN=3)    :: s_code_value_significance(l_varselect)
      CHARACTER(LEN=3)    :: s_code_unit_original(l_varselect)
      CHARACTER(LEN=3)    :: s_code_conversion_method(l_varselect)
      CHARACTER(LEN=3)    :: s_code_conversion_flag(l_varselect)
      CHARACTER(LEN=10)   :: s_predef_numerical_precision(l_varselect)
      CHARACTER(LEN=10)   :: s_predef_hgt_obs_above_sfc(l_varselect)

      INTEGER             :: i_flag_segfault

      LOGICAL             :: there
c************************************************************************
      print*,'just entering process_qff_files20210216'

      print*,'l_files=',l_files

c      STOP 'near start process_qff_files2'
c*****
c     Get codes for variables to be processed
      CALL get_codes_processing_qff(l_varselect,
     +   s_code_observation,s_code_unit,
     +   s_code_value_significance,s_code_unit_original,
     +   s_code_conversion_method,s_code_conversion_flag,
     +   s_predef_numerical_precision,s_predef_hgt_obs_above_sfc)
c*****
c     Check last return & erase all files if index absent or 1

c     Read in last file number
      CALL readin_lastfile_number_qff(s_directory_output_lastfile,
     +  i_start)

      print*,'i_start=',i_start

c      STOP 'process_qff_files20210216'
c************************************************************************
c     Call test to find qff files not in stnconfig

c      GOTO 54

c      CALL test_qff_file_in_stnconfig(l_rgh_files,l_files,
c     +  s_vec_files,
c     +  l_scoutput_rgh,l_scoutput,l_scoutput_numfield,ilen,
c     +  s_scoutput_vec_header,s_scoutput_mat_fields,

c     +  l_cc_rgh,l_collect_cnt,
c     +  s_collect_primary_id,s_collect_record_number,
c     +  s_collect_secondary_id,s_collect_station_name,
c     +  s_collect_longitude,s_collect_latitude,
c     +  s_collect_height_station_above_sea_level,
c     +  s_collect_data_policy_licence,s_collect_source_id,

c     +  s_collect_region,s_collect_operating_territory,
c     +  s_collect_station_type,s_collect_platform_type,
c     +  s_collect_platform_sub_type,s_collect_primary_station_id_scheme,
c     +  s_collect_location_accuracy,s_collect_location_method,
c     +  s_collect_location_quality,s_collect_station_crs,
c     +  s_collect_height_station_above_local_ground,
c     +  s_collect_height_station_above_sea_level_acc,
c     +  s_collect_sea_level_datum,

c     +  s_collect_datalines)

c      STOP 'process_qff_files2; just after test_qff_file_in_stnconfig'

c 54   CONTINUE
c************************************************************************
      GOTO 55

c     Find index selected stations
c      s_stnlook='ASM00094108'
      s_stnlook='AMM00037897'

      DO i=1,l_files
       s_file_single=s_vec_files(i)

c       print*,'i...',i,TRIM(s_file_single)
c       STOP 'process_qff_files2'

c      Isolate single name from full path
       CALL isolate_single_name(s_file_single,s_stnname_isolated)

       IF (i.EQ.1) THEN 
        print*,'first file:',TRIM(s_stnname_isolated)
       ENDIF

       IF (TRIM(s_stnname_isolated).EQ.TRIM(s_stnlook)) THEN 
        print*,'i,s_stnlook=',i,TRIM(s_stnlook)
c        STOP 'process_qff_files2'
       ENDIF
      ENDDO

c      STOP 'file not found'

 55   CONTINUE
c************************************************************************
c      STOP 'process_gff_files2'

c     Cycle through station
      ii=0
      i_bad_test1_nostnlist=0
      i_bad_test2_floatconvert=0
      i_bad_test3_sourceid_prob=0
      i_bad_test4_segfault=0

      DO i=i_start,l_files !19000 !18000 !15000 !14000 !11000 !10000 !9000 !8000 !7000 !6000 !5000 !1000 !l_files !20000 !18000 !16000 !14000 !10001 !9500 !9000 !2001,3000
c 607,2000 !606,606 !600,600 !586,586 !601,2000 !586,586 !1,585 !1,1000 !i_start,l_files 

       s_file_single=s_vec_files(i)

       print*,'i...',i,TRIM(s_file_single)

c       STOP 'process_qff_files2; A'

c      Isolate single name from full path
       CALL isolate_single_name(s_file_single,s_stnname_isolated)

       print*,'s_stnname_isolated=',TRIM(s_stnname_isolated)

c       STOP 'process_qff_files2; B'
c*****
c     Test if wishlist file in Robert Dunn directory
c     Inquire if file exists
      INQUIRE(FILE=TRIM(s_file_single),
     +  EXIST=there)

c     Skip analysis if file does not exist
      IF (.NOT.there) THEN 

        CALL export_file_name(
     +    s_directory_output_diagnostics_notthere,s_stnname_isolated)

       GOTO 51
      ENDIF
c*****
c     Test if file is good
      i_flag_segfault=0
      CALL test_file_segfault(s_file_single,s_stnname_isolated,
     +   s_directory_output_diagnostics_segfault,
     +   s_directory_temp,
     +   i_flag_segfault)

c      print*,'process_qff_files20210216; cleared test_file_segfault'

c      Exit analysis & go to next station if flag set
       IF (i_flag_segfault.EQ.1) THEN
        i_bad_test4_segfault=i_bad_test4_segfault+1
        GOTO 51
       ENDIF
c*****
c      New method to get stnconfig information
c      print*,'l_scoutput=',l_scoutput
c      print*,'s_scoutput_searchname=',
c     +  (s_scoutput_searchname(j)//'=',j=1,5)

       CALL get_singles_stnconfig_qff20201012(
     +  i_flag,s_stnname_isolated,
     +  l_scoutput_rgh,l_scoutput,ilen,
     +  s_scoutput_stnconfig_lines,
     +  s_scoutput_header,s_scoutput_searchname,

     +  l_cc_rgh,l_collect_cnt,
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

     +  s_collect_datalines,s_collect_vec_header,l_collect_numfield)

c      Skip to next station if stconfig entry found
       IF (i_flag.EQ.1) THEN 
        i_bad_test1_nostnlist=i_bad_test1_nostnlist+1  
        GOTO 51
       ENDIF

c       print*,'l_collect_cnt=',l_collect_cnt
c       STOP 'process_qff_files20210216; C'
c*****
c      Process single qff file
       CALL process_single_qff_file20210216(s_file_single,
     +  l_rgh,l_lines, 
     +  s_vec_station_id,s_vec_station_name,
     +  s_vec_year,s_vec_month,s_vec_day,
     +  s_vec_hour,s_vec_minute,
     +  s_vec_latitude,s_vec_longitude,s_vec_elevation,
     +  s_vec_airt_c,s_vec_airt_source_id,s_vec_airt_qc_flag,
     +  s_vec_dewp_c,s_vec_dewp_source_id,s_vec_dewp_qc_flag,
     +  s_vec_stnp_hpa,s_vec_stnp_source_id,s_vec_stnp_qc_flag,
     +  s_vec_slpr_hpa,s_vec_slpr_source_id,s_vec_slpr_qc_flag,  
     +  s_vec_wdir_deg,s_vec_wdir_source_id,s_vec_wdir_qc_flag,
     +  s_vec_wspd_ms,s_vec_wspd_source_id,s_vec_wspd_qc_flag)

c       print*,'cleared process_single_qff_file20210216',l_lines
c*****
c      Find precision
       CALL find_original_precision_qff(l_rgh,l_lines,
     +   s_vec_airt_c,s_vec_dewp_c,
     +   s_vec_stnp_hpa,s_vec_slpr_hpa,
     +   s_vec_wdir_deg,s_vec_wspd_ms,

     +   s_vec_airt_origprec_c,s_vec_dewp_origprec_c,
     +   s_vec_stnp_origprec_hpa,s_vec_slpr_origprec_hpa,
     +   s_vec_wdir_origprec_deg,s_vec_wspd_origprec_ms,
     +   s_vec_airt_origprec_neglog,s_vec_dewp_origprec_neglog,
     +   s_vec_stnp_origprec_neglog,s_vec_slpr_origprec_neglog,
     +   s_vec_wdir_origprec_neglog,s_vec_wspd_origprec_neglog,
     +   s_vec_airt_origprec_empir_c,s_vec_dewp_origprec_empir_c,
     +   s_vec_stnp_origprec_empir_hpa,s_vec_slpr_origprec_empir_hpa,
     +   s_vec_wdir_origprec_empir_deg,s_vec_wspd_origprec_empir_ms)

c       print*,'cleared find_original_precision_qff'
c*****
c      Convert variable string to float
       CALL convert_var_string_to_float(i_flag,
     +   s_stnname_isolated,
     +   f_ndflag,l_rgh,l_lines,
     +   s_vec_airt_c,s_vec_dewp_c,
     +   s_vec_stnp_hpa,s_vec_slpr_hpa,
     +   s_vec_wdir_deg,s_vec_wspd_ms,

     +   f_vec_airt_c,f_vec_dewp_c,
     +   f_vec_stnp_hpa,f_vec_slpr_hpa,
     +   f_vec_wdir_deg,f_vec_wspd_ms)

c       print*,'cleared convert_var_string_to_float'

       IF (i_flag.EQ.1) THEN 
        i_bad_test2_floatconvert=i_bad_test2_floatconvert+1
       ENDIF
c*****
c      Convert variables units from C to K & hPa to Pa
       CALL convert_units_qff(f_ndflag,
     +    l_rgh,l_lines,
     +    f_vec_airt_c,f_vec_dewp_c,
     +    f_vec_stnp_hpa,f_vec_slpr_hpa,
     +    s_vec_airt_origprec_empir_c,s_vec_dewp_origprec_empir_c,
     +    s_vec_stnp_origprec_empir_hpa,s_vec_slpr_origprec_empir_hpa,

     +    f_vec_airt_k,f_vec_dewp_k,
     +    f_vec_stnp_pa,f_vec_slpr_pa,
     +    s_vec_airt_k,s_vec_dewp_k,
     +    s_vec_stnp_pa,s_vec_slpr_pa,
     +    s_vec_airt_convprec_empir_k,s_vec_dewp_convprec_empir_k,
     +    s_vec_stnp_convprec_empir_pa,s_vec_slpr_convprec_empir_pa)

c       print*,'cleared convert_units_qff'
c*****
c      Find record number from source number
c       print*,'just before record_number_from_source_number_qff20200617'
c       print*,'s_directory_output_diagnostics',
c     +   TRIM(s_directory_output_diagnostics)
c       print*,'s_stnname_isolated',TRIM(s_stnname_isolated)
       i_flag=0
       CALL record_number_from_source_number_qff20200617b(
     +    s_directory_output_diagnostics,s_stnname_isolated,
     +    i_flag,
     +    l_cc_rgh,l_collect_cnt,
     +    s_collect_record_number,s_collect_source_id,
     +    l_rgh,l_lines,
     +    s_vec_airt_c,s_vec_dewp_c,
     +    s_vec_stnp_hpa,s_vec_slpr_hpa,
     +    s_vec_wdir_deg,s_vec_wspd_ms,
     +    f_vec_airt_c,f_vec_dewp_c,
     +    f_vec_stnp_hpa,f_vec_slpr_hpa,
     +    f_vec_wdir_deg,f_vec_wspd_ms,
     +    s_vec_airt_source_id,s_vec_dewp_source_id,
     +    s_vec_stnp_source_id,s_vec_slpr_source_id,
     +    s_vec_wdir_source_id,s_vec_wspd_source_id,

     +    s_vec_airt_recordnum,s_vec_dewp_recordnum,
     +    s_vec_stnp_recordnum,s_vec_slpr_recordnum,
     +    s_vec_wdir_recordnum,s_vec_wspd_recordnum)

c       print*,'cleared record_number_from_source_number'

c       print*,'i_flag=',i_flag
c       print*,'l_collect_cnt=',l_collect_cnt
c       print*,'s_collect_record_number=',
c     +   ('='//TRIM(s_collect_record_number(j))//'=',j=1,l_collect_cnt)
c       print*,'s_collect_source_id=',
c     +   ('='//TRIM(s_collect_source_id(j))//'=',j=1,l_collect_cnt)

c       STOP 'process_qff_files20201009'

c      Exit analysis & go to next station if flag set
       IF (i_flag.EQ.1) THEN
        i_bad_test3_sourceid_prob=i_bad_test3_sourceid_prob+1
        GOTO 51
       ENDIF
c*****
c      Find CDM QC codes
       CALL find_cdm_qc_code(l_rgh,l_lines,
     +    s_vec_airt_qc_flag,s_vec_dewp_qc_flag,
     +    s_vec_stnp_qc_flag,s_vec_slpr_qc_flag,
     +    s_vec_wdir_qc_flag,s_vec_wspd_qc_flag,

     +    s_vec_airt_cdmqc,s_vec_dewp_cdmqc,
     +    s_vec_stnp_cdmqc,s_vec_slpr_cdmqc,
     +    s_vec_wdir_cdmqc,s_vec_wspd_cdmqc)

c       print*,'cleared find_cdm_qc_code'
c*****
c     Place qc converter here
      CALL find_qc_pivot_table_info(l_rgh,l_lines,
     +    s_vec_airt_qc_flag,s_vec_dewp_qc_flag,
     +    s_vec_stnp_qc_flag,s_vec_slpr_qc_flag,
     +    s_vec_wdir_qc_flag,s_vec_wspd_qc_flag,
     +    s_vec_airt_cdmqc,s_vec_dewp_cdmqc,
     +    s_vec_stnp_cdmqc,s_vec_slpr_cdmqc,
     +    s_vec_wdir_cdmqc,s_vec_wspd_cdmqc,
     +    s_qckey_timescale_spec,l_qckey,
     +    s_qckey_sourceflag,s_qckey_c3sflag,s_qckey_timescale,

     +    s_vec_airt_cdmqcmethod,s_vec_dewp_cdmqcmethod,
     +    s_vec_stnp_cdmqcmethod,s_vec_slpr_cdmqcmethod,
     +    s_vec_wdir_cdmqcmethod,s_vec_wspd_cdmqcmethod)

c*****
c      print*,'s_vec_wdir_deg=',
c     +  ('|'//TRIM(s_vec_wdir_deg(k)),k=1,10)
c      print*,'s_vec_wdir_origprec_deg=',
c     +  ('|'//TRIM(s_vec_wdir_origprec_deg(k)),k=1,10)
c      print*,'s_vec_wdir_origprec_empir_deg=',
c     +  ('|'//TRIM(s_vec_wdir_origprec_empir_deg(k)),k=1,10)
c      print*,'s_vec_wdir_origprec_neglog=',
c     +  ('|'//TRIM(s_vec_wdir_origprec_neglog(k)),k=1,10)

c      print*,'s_vec_wspd_ms=',
c     +  ('|'//TRIM(s_vec_wspd_ms(k)),k=1,10)
c      print*,'s_vec_wspd_origprec_ms=',
c     +  ('|'//TRIM(s_vec_wspd_origprec_ms(k)),k=1,10)
c      print*,'s_vec_wspd_origprec_empir_ms=',
c     +  ('|'//TRIM(s_vec_wspd_origprec_empir_ms(k)),k=1,10)
c      print*,'s_vec_wspd_origprec_neglog=',
c     +  ('|'//TRIM(s_vec_wspd_origprec_neglog(k)),k=1,10)

c       STOP 'process_qff_files20200607'
c*****
c      CDM tables here

       CALL header_obs_lite_qff20210218(
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
     +   l_collect_numfield,s_collect_vec_header,s_collect_datalines)

        ii=ii+1

 51    CONTINUE       !entrance point one of bad flag tests

c       Export index of finished file
        CALL export_last_index_qff20200612(
     +   s_directory_output_lastfile,i,ii,
     +   i_values_st)
c*****
       print*,'INTERIM FLAG TALLY'
       print*,'i_bad_test1_nostnlist=',i_bad_test1_nostnlist
       print*,'i_bad_test2_floatconvert=',i_bad_test2_floatconvert
       print*,'i_bad_test3_sourceid_prob=',i_bad_test3_sourceid_prob
       print*,'i_bad_test4_segfault=',    i_bad_test4_segfault

      ENDDO

      print*,'just leaving process_qff_files'

      RETURN
      END
