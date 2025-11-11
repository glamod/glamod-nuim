c     Subroutine to write lite outputs to screen
c     AJ_Kettle, 21Dec2020
c     03Feb2021: field width changed to slave designation

      SUBROUTINE sample_screenprint_lite(
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

      IMPLICIT NONE
c************************************************************************
c     Individual fields for lite
c     NOTE: 19 columns; 1 column extra from previous release
      CHARACTER(LEN=*)   :: s_lite_observation_id                 !1  s_obs_obseration_id
      CHARACTER(LEN=*)   :: s_lite_report_type                    !2  s_header_report_id
      CHARACTER(LEN=*)   :: s_lite_date_time                      !3  s_obs_date_time
      CHARACTER(LEN=*)   :: s_lite_date_time_meaning              !4  s_obs_date_time_meaning
      CHARACTER(LEN=*)   :: s_lite_latitude                       !5  s_obs_latitude
      CHARACTER(LEN=*)   :: s_lite_longitude                      !6  s_obs_longitude 
      CHARACTER(LEN=*)::s_lite_observation_height_above_station_surface !7  s_obs_observation_height_above_station_surface
      CHARACTER(LEN=*)   :: s_lite_observed_variable              !8  s_obs_observed_variable
      CHARACTER(LEN=*)   :: s_lite_units                          !9  s_obs_units
      CHARACTER(LEN=*)   :: s_lite_observation_value              !10 s_obs_observation_value
      CHARACTER(LEN=*)   :: s_lite_value_significance             !11 s_obs_value_significance 
      CHARACTER(LEN=*)   :: s_lite_observation_duration           !12 s_obs_observation_duration
      CHARACTER(LEN=*)   :: s_lite_platform_type                  !13 s_header_platform_type 
      CHARACTER(LEN=*)   :: s_lite_station_type                   !14 s_header_station_type
      CHARACTER(LEN=*)   :: s_lite_primary_station_id             !15 s_header_primary_station_id
      CHARACTER(LEN=*)   :: s_lite_station_name                   !16 s_header_station_name
      CHARACTER(LEN=*)   :: s_lite_quality_flag                   !17 s_obs_quality_flag
      CHARACTER(LEN=*)   :: s_lite_data_policy_licence            !18 s_obs_data_policy_licence
      CHARACTER(LEN=*)   :: s_lite_source_id                      !19 source id

      CHARACTER(LEN=1000) :: s_lite_linedata_assemble 
c************************************************************************
c     Declare variables passed into subroutine

c       Print info to screen
c        IF (f_vec_original_value(j).NE.f_ndflag) THEN 
         print*,'1.s_lite_observation_id='//
     +     TRIM(s_lite_observation_id)//'='
         print*,'2.s_lite_report_type='//
     +     TRIM(s_lite_report_type)//'='
         print*,'3.s_lite_date_time='//
     +     TRIM(s_lite_date_time)//'='
         print*,'4.s_lite_date_time_meaning='//
     +     TRIM(s_lite_date_time_meaning)//'='
         print*,'5.s_lite_latitude='//
     +     TRIM(s_lite_latitude)//'='
         print*,'6.s_lite_longitude='//
     +     TRIM(s_lite_longitude)//'='
         print*,'7.s_lite_height_above_surface='//
     +     TRIM(s_lite_observation_height_above_station_surface)//'='
         print*,'8.s_lite_observed_variable='//
     +     TRIM(s_lite_observed_variable)//'='
         print*,'9.s_lite_units='//
     +     TRIM(s_lite_units)//'='
         print*,'10.s_lite_observation_value='//
     +     TRIM(s_lite_observation_value)//'='
         print*,'11.s_lite_value_significance='//
     +     TRIM(s_lite_value_significance)//'='
         print*,'12.s_lite_observation_duration='//
     +     TRIM(s_lite_observation_duration)//'='
         print*,'13.s_lite_platform_type='//
     +     TRIM(s_lite_platform_type)//'='
         print*,'14.s_lite_station_type='//
     +     TRIM(s_lite_station_type)//'='
         print*,'15.s_lite_primary_station_id='//
     +     TRIM(s_lite_primary_station_id)//'='
         print*,'16.s_lite_station_name='//
     +     TRIM(s_lite_station_name)//'='
         print*,'17.s_lite_quality_flag='//
     +     TRIM(s_lite_quality_flag)//'='
         print*,'18.s_lite_data_policy_licence='//
     +     TRIM(s_lite_data_policy_licence)//'='
         print*,'19.s_lite_source_id='//
     +     TRIM(s_lite_source_id)//'='

         print*,'s_lite_linedata_assemble=',
     +    TRIM(s_lite_linedata_assemble)

c        ENDIF

        STOP 'sample_screenprint_lite'

      RETURN
      END
