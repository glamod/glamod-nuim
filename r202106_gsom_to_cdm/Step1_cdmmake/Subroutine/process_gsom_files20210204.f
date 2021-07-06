c     Subroutine to output header/observation for GSOM
c     AJ_Kettle, 06Sep2019
c     20May2020: removed scinput variables; variable width scoutput

      SUBROUTINE process_gsom_files20210204(
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
c     variable for GSOM/GHCND conversion
      INTEGER             :: l_source_rgh
      INTEGER             :: l_source
      CHARACTER(LEN=500)  :: s_source_name(l_source_rgh)
      CHARACTER(LEN=1)    :: s_source_codeletter(l_source_rgh)
      CHARACTER(LEN=3)    :: s_source_codenumber(l_source_rgh)
c*****
c     Variables used in subroutine

      INTEGER             :: i,j,k,ii,jj,kk      

      INTEGER,PARAMETER   :: l_varselect=6
      CHARACTER(LEN=4)    :: s_varselect(l_varselect)
      CHARACTER(LEN=3)    :: s_code_observation(l_varselect)
      CHARACTER(LEN=3)    :: s_code_unit(l_varselect)
      CHARACTER(LEN=3)    :: s_code_value_significance(l_varselect)
      CHARACTER(LEN=3)    :: s_code_unit_original(l_varselect)
      CHARACTER(LEN=3)    :: s_code_conversion_method(l_varselect)
      CHARACTER(LEN=3)    :: s_code_conversion_flag(l_varselect)
      CHARACTER(LEN=10)   :: s_predef_numerical_precision(l_varselect)
      CHARACTER(LEN=10)   :: s_predef_hgt_obs_above_sfc(l_varselect)

c     09Dec2020: qc_key information
      CHARACTER(LEN=300)  :: s_qckey_timescale_spec
      INTEGER             :: l_qckey
      CHARACTER(LEN=2)    :: s_qckey_sourceflag(100)
      CHARACTER(LEN=2)    :: s_qckey_c3sflag(100)
      CHARACTER(LEN=300)  :: s_qckey_timescale(100) 

c************************************************************************
      print*,'just entered process_gsom_files20200520'

c      DO i=1,l_scoutput_numfield
c       print*,'s_scoutput_vec_header=',i,TRIM(s_scoutput_vec_header(i))
c      ENDDO
c      STOP 'process_gsom_files20200520'

c     Get codes for variables to be processed
      CALL get_codes_gsom_processing20200527(l_varselect,
     +   s_varselect,s_code_observation,s_code_unit,
     +   s_code_value_significance,s_code_unit_original,
     +   s_code_conversion_method,s_code_conversion_flag,
     +   s_predef_numerical_precision,s_predef_hgt_obs_above_sfc)

c     Start station loop here
      CALL station_loop_process20210204(
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

      print*,'just leaving process_gsom_files20200520'

      RETURN
      END
