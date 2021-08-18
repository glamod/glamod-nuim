c     Subroutine find qff files not in stnconfig
c     AJ_Kettle, 17Dec2019

      SUBROUTINE test_qff_file_in_stnconfig(l_rgh_files,l_files,
     +  s_vec_files,
     +  l_scoutput_rgh,l_scoutput,l_scoutput_numfield,ilen,
     +  s_scoutput_vec_header,s_scoutput_mat_fields,

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

     +  s_collect_datalines)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into subroutine
      INTEGER             :: l_rgh_files
      INTEGER             :: l_files
      CHARACTER(LEN=300)  :: s_vec_files(l_rgh_files)

c     Stnconfig information
      INTEGER             :: l_scoutput_rgh
      INTEGER             :: l_scoutput
      INTEGER             :: l_scoutput_numfield
      INTEGER             :: ilen
       
      CHARACTER(LEN=ilen) :: s_scoutput_vec_header(50)               
      CHARACTER(LEN=ilen) :: s_scoutput_mat_fields(l_scoutput_rgh,50)
c*****
c     Variables originally from stnconfig-read
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

c     Archives up to 50 column & 20 lines from stnconfig-write file
      CHARACTER(LEN=ilen) :: s_collect_datalines(l_cc_rgh,50)
c*****
c     Variables used in subroutine
      INTEGER             :: i,j,k,ii,jj,kk

      INTEGER             :: i_bad_test1_nostnlist
      CHARACTER(LEN=300)  :: s_file_single
      CHARACTER(LEN=300)  :: s_stnname_isolated
      INTEGER             :: i_flag
c************************************************************************
      print*,'just entered test_qff_file_in_stnconfig'

      i_bad_test1_nostnlist=0
      DO i=1,l_files

       s_file_single=s_vec_files(i)

c       print*,'i...',i,TRIM(s_file_single)
c       STOP 'process_qff_files2'

c      Isolate single name from full path
       CALL isolate_single_name(s_file_single,s_stnname_isolated)

c*****
c      Get info from stn_config file
       CALL get_singles_stnconfig_qff2(i_flag,s_stnname_isolated,
     +  l_scoutput_rgh,l_scoutput,l_scoutput_numfield,ilen,
     +  s_scoutput_vec_header,s_scoutput_mat_fields,

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

     +  s_collect_datalines)

       IF (i_flag.EQ.1) THEN 
        i_bad_test1_nostnlist=i_bad_test1_nostnlist+1

        print*,'badlist,i...',i,i_bad_test1_nostnlist,
     +    TRIM(s_stnname_isolated)
       ENDIF

      ENDDO

c      STOP 'process_qff_files2'

      print*,'just leaving test_qff_file_in_stnconfig'

      RETURN
      END
