c     Subroutine for sample screen print of observation file
c     AJ_Kettle, 15Dec2019

      SUBROUTINE sample_screenprint_obs(
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

      IMPLICIT NONE
c************************************************************************
c     Variables passed into program
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
      CHARACTER(LEN=50)   :: s_obs_source_id                       !47

      CHARACTER(LEN=1000) :: s_obs_linedata_assemble 
c************************************************************************

c       Print info to screen 
         print*,'1.s_obs_observation_id='//
     +     TRIM(s_obs_observation_id)//'='
         print*,'2.s_obs_report_id='//
     +     TRIM(s_obs_report_id)//'='
         print*,'3.s_obs_data_policy_licence='//
     +     TRIM(s_obs_data_policy_licence)//'='
         print*,'4.s_obs_date_time='//
     +     TRIM(s_obs_date_time)//'='
         print*,'5.s_obs_date_time_meaning='//
     +     TRIM(s_obs_date_time_meaning)//'='
         print*,'6.s_obs_observation_duration='//
     +     TRIM(s_obs_observation_duration)//'='
         print*,'7.s_obs_longitude='//
     +     TRIM(s_obs_longitude)//'='
         print*,'8.s_obs_latitude='//
     +     TRIM(s_obs_latitude)//'='
         print*,'9.s_obs_crs='//
     +     TRIM(s_obs_crs)//'='
         print*,'10.s_obs_z_coordinate='//
     +     TRIM(s_obs_z_coordinate)//'='
         print*,'11.s_obs_z_coordinate_type='//
     +     TRIM(s_obs_z_coordinate_type)//'='
         print*,'12.s_obs_observation_height_above_station_surface='//
     +     TRIM(s_obs_observation_height_above_station_surface)//'='
         print*,'13.s_obs_observed_variable='//
     +     TRIM(s_obs_observed_variable)//'='
         print*,'14.s_obs_secondary_variable='//
     +     TRIM(s_obs_secondary_variable)//'='
         print*,'15.s_obs_observation_value='//
     +     TRIM(s_obs_observation_value)//'='
         print*,'16.s_obs_value_significance='//
     +     TRIM(s_obs_value_significance)//'='
         print*,'17.s_obs_secondary_value='//
     +     TRIM(s_obs_secondary_value)//'='
         print*,'18.s_obs_units='//
     +     TRIM(s_obs_units)//'='
         print*,'19.s_obs_code_table='//
     +     TRIM(s_obs_code_table)//'='
         print*,'20.s_obs_conversion_flag='//
     +     TRIM(s_obs_conversion_flag)//'='
         print*,'21.s_obs_location_method='//
     +     TRIM(s_obs_location_method)//'='
         print*,'22.s_obs_location_precision='//
     +     TRIM(s_obs_location_precision)//'='
         print*,'23.s_obs_coordinate_method='//
     +     TRIM(s_obs_coordinate_method)//'='
         print*,'24.s_obs_bbox_min_longitude='//
     +     TRIM(s_obs_bbox_min_longitude)//'='
         print*,'25.s_obs_bbox_max_longitude='//
     +     TRIM(s_obs_bbox_max_longitude)//'='
         print*,'26.s_obs_bbox_min_latitude='//
     +     TRIM(s_obs_bbox_min_latitude)//'='
         print*,'27.s_obs_bbox_max_latitude='//
     +     TRIM(s_obs_bbox_max_latitude)//'='
         print*,'28.s_obs_spatial_representativeness='//
     +     TRIM(s_obs_spatial_representativeness)//'='
         print*,'29.s_obs_quality_flag='//
     +     TRIM(s_obs_quality_flag)//'='
         print*,'30.s_obs_numerical_precision='//
     +     TRIM(s_obs_numerical_precision)//'='
         print*,'31.s_obs_sensor_id='//
     +     TRIM(s_obs_sensor_id)//'='
         print*,'32.s_obs_sensor_automation_status='//
     +     TRIM(s_obs_sensor_automation_status)//'='
         print*,'33.s_obs_exposure_of_sensor='//
     +     TRIM(s_obs_exposure_of_sensor)//'='
         print*,'34.s_obs_original_precision='//
     +     TRIM(s_obs_original_precision)//'='
         print*,'35.s_obs_original_units='//
     +     TRIM(s_obs_original_units)//'='
         print*,'36.s_obs_original_code_table='//
     +     TRIM(s_obs_original_code_table)//'='
         print*,'37.s_obs_original_value='//
     +     TRIM(s_obs_original_value)//'='
         print*,'38.s_obs_conversion_method='//
     +     TRIM(s_obs_conversion_method)//'='
         print*,'39.s_obs_processing_code='//
     +     TRIM(s_obs_processing_code)//'='
         print*,'40.s_obs_processing_level='//
     +     TRIM(s_obs_processing_level)//'='
         print*,'41.s_obs_adjustment_id='//
     +     TRIM(s_obs_adjustment_id)//'='
         print*,'42.s_obs_traceability='//
     +     TRIM(s_obs_traceability)//'='
         print*,'43.s_obs_advanced_qc='//
     +     TRIM(s_obs_advanced_qc)//'='
         print*,'44.s_obs_advanced_uncertainty='//
     +     TRIM(s_obs_advanced_uncertainty)//'='
         print*,'45.s_obs_advanced_homogenisation='//
     +     TRIM(s_obs_advanced_homogenisation)//'='
         print*,'46.s_obs_advanced_assimilation_feedback='//
     +     TRIM(s_obs_advanced_assimilation_feedback)//'='
         print*,'47.s_obs_source_id='//
     +     TRIM(s_obs_source_id)//'='

        print*,'s_obs_linedata_assemble=',TRIM(s_obs_linedata_assemble)

      RETURN
      END
