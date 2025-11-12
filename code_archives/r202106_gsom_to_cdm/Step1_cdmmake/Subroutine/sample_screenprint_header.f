c     Subroutine to export data to screen
c     AJ_Kettle, 16Dec2020
c     03Feb2021: changed to slave designation for char width

      SUBROUTINE sample_screenprint_header(
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

      IMPLICIT NONE
c************************************************************************
c     Declare variables passed into subroutine

c     Individual data fields for header                        
      CHARACTER(LEN=*)   :: s_header_report_id                    !1  !1
      CHARACTER(LEN=*)   :: s_header_region                       !2
      CHARACTER(LEN=*)   :: s_header_sub_region                   !3
      CHARACTER(LEN=*)   :: s_header_application_area             !4  !2
      CHARACTER(LEN=*)   :: s_header_observing_programme          !5  !3
      CHARACTER(LEN=*)   :: s_header_report_type                  !6  !4
      CHARACTER(LEN=*)   :: s_header_station_name                 !7
      CHARACTER(LEN=*)   :: s_header_station_type                 !8
      CHARACTER(LEN=*)   :: s_header_platform_type                !9
      CHARACTER(LEN=*)   :: s_header_platform_sub_type            !10
      CHARACTER(LEN=*)   :: s_header_primary_station_id           !11 !5
      CHARACTER(LEN=*)   :: s_header_station_record_number        !12 !6
      CHARACTER(LEN=*)   :: s_header_primary_station_id_scheme    !13
      CHARACTER(LEN=*)   :: s_header_longitude                    !14
      CHARACTER(LEN=*)   :: s_header_latitude                     !15
      CHARACTER(LEN=*)   :: s_header_location_accuracy            !16
      CHARACTER(LEN=*)   :: s_header_location_method              !17
      CHARACTER(LEN=*)   :: s_header_location_quality             !18
      CHARACTER(LEN=*)   :: s_header_crs                          !19
      CHARACTER(LEN=*)   :: s_header_station_speed                !20
      CHARACTER(LEN=*)   :: s_header_station_course               !21
      CHARACTER(LEN=*)   :: s_header_station_heading              !22
      CHARACTER(LEN=*)   :: 
     +  s_header_height_of_station_above_local_ground              !23
      CHARACTER(LEN=*)   :: s_header_height_of_station_above_sea_level  !24 (from stnconfig)
      CHARACTER(LEN=*)   :: 
     +  s_header_height_of_station_above_sea_level_accuracy        !25
      CHARACTER(LEN=*)   :: s_header_sea_level_datum              !26
      CHARACTER(LEN=*)   :: s_header_report_meaning_of_timestamp  !27 !7
      CHARACTER(LEN=*)   :: s_header_report_timestamp             !28 !8
      CHARACTER(LEN=*)   :: s_header_report_duration              !29 !9
      CHARACTER(LEN=*)   :: s_header_report_time_accuracy         !30 !10
      CHARACTER(LEN=*)   :: s_header_report_time_quality          !31 !11
      CHARACTER(LEN=*)   :: s_header_report_time_reference        !32 !12
      CHARACTER(LEN=*)   :: s_header_profile_id                   !33 !13
      CHARACTER(LEN=*)   :: s_header_events_at_station            !34 !14
      CHARACTER(LEN=*)   :: s_header_report_quality               !35 !15
      CHARACTER(LEN=*)   :: s_header_duplicate_status             !36 !16
      CHARACTER(LEN=*)   :: s_header_duplicates                   !37 !17
      CHARACTER(LEN=*)   :: s_header_record_timestamp             !38 !18
      CHARACTER(LEN=*)   :: s_header_history                      !39 !19
      CHARACTER(LEN=*)   :: s_header_processing_level             !40 !20
      CHARACTER(LEN=*)   :: s_header_processing_codes             !41 !21
      CHARACTER(LEN=*)   :: s_header_source_id                    !42 !22
      CHARACTER(LEN=*)   :: s_header_source_record_id             !43

      CHARACTER(LEN=1000) :: s_header_linedata_assemble 
c*****
c     Variables used in subroutine

      INTEGER             :: i,j,k,ii,jj,kk
c************************************************************************

      print*,'1.s_header_report_id='//
     +  TRIM(s_header_report_id)//'='
      print*,'2.s_header_region='//
     +  TRIM(s_header_region)//'='
      print*,'3.s_header_sub_region='//
     +  TRIM(s_header_sub_region)//'='
      print*,'4.s_header_application_area='//
     +  TRIM(s_header_application_area)//'='
      print*,'5.s_header_observing_programme='//
     +  TRIM(s_header_observing_programme)//'='
      print*,'6.s_header_report_type='//
     +  TRIM(s_header_report_type)//'='
      print*,'7.s_header_station_name='//
     +  TRIM(s_header_station_name)//'='
      print*,'8.s_header_station_type='//
     +  TRIM(s_header_station_type)//'='
      print*,'9.s_header_platform_type='//
     +  TRIM(s_header_platform_type)//'='
      print*,'10.s_header_platform_sub_type='//
     +  TRIM(s_header_platform_sub_type)//'='
      print*,'11.s_header_primary_station_id='//
     +  TRIM(s_header_primary_station_id)//'='
      print*,'12.s_header_station_record_number='//
     +  TRIM(s_header_station_record_number)//'='
      print*,'13.s_header_primary_station_id_scheme='//
     +  TRIM(s_header_primary_station_id_scheme)//'='
      print*,'14.s_header_longitude='//
     +  TRIM(s_header_longitude)//'='
      print*,'15.s_header_latitude='//
     +  TRIM(s_header_latitude)//'='
      print*,'16.s_header_location_accuracy='//
     +  TRIM(s_header_location_accuracy)//'='
      print*,'17.s_header_location_method='//
     +  TRIM(s_header_location_method)//'='
      print*,'18.s_header_location_quality='//
     +  TRIM(s_header_location_quality)//'='
      print*,'19.s_header_crs='//
     +  TRIM(s_header_crs)//'='
      print*,'20.s_header_station_speed='//
     +  TRIM(s_header_station_speed)//'='
      print*,'21.s_header_station_course='//
     +  TRIM(s_header_station_course)//'='
      print*,'22.s_header_station_heading='//
     +  TRIM(s_header_station_heading)//'='
      print*,'23.s_header_height_of_station_above_local_ground='//
     +  TRIM(s_header_height_of_station_above_local_ground)//'='
      print*,'24.s_header_height_of_station_above_sea_level='//
     +  TRIM(s_header_height_of_station_above_sea_level)//'='
      print*,'25.s_header_height_of_station_above_sea_level_accuracy='//
     +  TRIM(s_header_height_of_station_above_sea_level_accuracy)//'='
      print*,'26.s_header_sea_level_datum='//
     +  TRIM(s_header_sea_level_datum)//'='
      print*,'27.s_header_report_meaning_of_timestamp='//
     +  TRIM(s_header_report_meaning_of_timestamp)//'='
      print*,'28.s_header_report_timestamp='//
     +  TRIM(s_header_report_timestamp)//'='
      print*,'29.s_header_report_duration='//
     +  TRIM(s_header_report_duration)//'='
      print*,'30.s_header_report_time_accuracy='//
     +  TRIM(s_header_report_time_accuracy)//'='
      print*,'31.s_header_report_time_quality='//
     +  TRIM(s_header_report_time_quality)//'='
      print*,'32.s_header_report_time_reference='//
     +  TRIM(s_header_report_time_reference)//'='
      print*,'33.s_header_profile_id='//
     +  TRIM(s_header_profile_id)//'='
      print*,'34.s_header_events_at_station='//
     +  TRIM(s_header_events_at_station)//'='
      print*,'35.s_header_report_quality='//
     +  TRIM(s_header_report_quality)//'='
      print*,'36.s_header_duplicate_status='//
     +  TRIM(s_header_duplicate_status)//'='
      print*,'37.s_header_duplicates='//
     +  TRIM(s_header_duplicates)//'='
      print*,'38.s_header_record_timestamp='//
     +  TRIM(s_header_record_timestamp)//'='
      print*,'39.s_header_history='//
     +  TRIM(s_header_history)//'='
      print*,'40.s_header_processing_level='//
     +  TRIM(s_header_processing_level)//'='
      print*,'41.s_header_processing_codes='//
     +  TRIM(s_header_processing_codes)//'='
      print*,'42.s_header_source_id='//
     +  TRIM(s_header_source_id)//'='
      print*,'43.s_header_source_record_id='//
     +  TRIM(s_header_source_record_id)//'='

      print*,'s_header_linedata_assemble=',
     +  TRIM(s_header_linedata_assemble)
      STOP 'header_obs_lite_table20201215'

      RETURN
      END
