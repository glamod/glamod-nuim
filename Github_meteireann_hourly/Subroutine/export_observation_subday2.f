c     Subroutine to make CDM header file
c     AJ_Kettle, Dec25/2017
c     Jan14/2018: modified to remove original measurements

      SUBROUTINE export_observation_subday2(f_ndflag,s_directory_root,
     +  l_datalines,
     +  s1_basis_nameshort,s1_basis_namelist,s1_basis_fileid,
     +  s1_basis_alt_m,s1_basis_lat,s1_basis_lon,s1_basis_wigos,
     +  l_mlent,
     +  s_vec_date,s_vec_time,
     +  f_vec_airt_k,f_vec_rain_mm,f_vec_wspd_ms,f_vec_slpr_hpa,
     +  f_vec_relh_pc,
     +  f_vec_airt_c,f_vec_wspd_kt)

      IMPLICIT NONE
c************************************************************************
c     Declare variables

      CHARACTER(LEN=200)  :: s_directory_root

      REAL                :: f_ndflag
      INTEGER             :: l_datalines

      CHARACTER(LEN=30)   :: s1_basis_nameshort
      CHARACTER(LEN=30)   :: s1_basis_namelist
      CHARACTER(LEN=4)    :: s1_basis_fileid
      CHARACTER(LEN=4)    :: s1_basis_alt_m
      CHARACTER(LEN=7)    :: s1_basis_lat
      CHARACTER(LEN=7)    :: s1_basis_lon
      CHARACTER(LEN=17)   :: s1_basis_wigos

      INTEGER             :: l_mlent
      CHARACTER(LEN=10)   :: s_vec_date(l_mlent)
      CHARACTER(LEN=8)    :: s_vec_time(l_mlent)
      REAL                :: f_vec_airt_k(l_mlent)
      REAL                :: f_vec_rain_mm(l_mlent)
      REAL                :: f_vec_wspd_ms(l_mlent)
      REAL                :: f_vec_slpr_hpa(l_mlent)
      REAL                :: f_vec_relh_pc(l_mlent)
      REAL                :: f_vec_airt_c(l_mlent)
      REAL                :: f_vec_wspd_kt(l_mlent)

      CHARACTER(LEN=8)    :: s_date1
      CHARACTER(LEN=10)   :: s_time1
      CHARACTER(LEN=5)    :: s_zone1
      INTEGER             :: i_values1(8)

      CHARACTER(LEN=3)    :: s_code(5)
      CHARACTER(LEN=2)    :: s_value_signif_code(5)
      CHARACTER(LEN=3)    :: s_source_id
      CHARACTER(LEN=33)   :: s_title       !changed from 29 to 33 for .txt extension

      CHARACTER(LEN=400)  :: s_export_line
      CHARACTER(LEN=900)  :: s_export_header

      CHARACTER(LEN=10)   :: s_date_single
      CHARACTER(LEN=4)    :: s_year
      CHARACTER(LEN=2)    :: s_month
      CHARACTER(LEN=2)    :: s_day
      CHARACTER(LEN=8)    :: s_time_single
      CHARACTER(LEN=2)    :: s_hour
      CHARACTER(LEN=2)    :: s_minute 
      CHARACTER(LEN=2)    :: s_second 
      CHARACTER(LEN=5)    :: s_timezone5

      REAL                :: f_test
      INTEGER             :: i_test
      CHARACTER(LEN=8)    :: s_test8

      CHARACTER(LEN=50)   :: s_observation_id           !1   changed from 6 to 50
      CHARACTER(LEN=35)   :: s_report_id                !2
      CHARACTER(LEN=1)    :: s_data_policy_lic          !3
      CHARACTER(LEN=22)   :: s_date_time                !4
      CHARACTER(LEN=35)   :: s_date_time_meaning        !5
      CHARACTER(LEN=8)    :: s_obs_duration             !6
      CHARACTER(LEN=8)    :: s_longitude                !7
      CHARACTER(LEN=8)    :: s_latitude                 !8
      CHARACTER(LEN=1)    :: s_crs                      !9
      CHARACTER(LEN=4)    :: s_z_coordinate             !10
      CHARACTER(LEN=4)    :: s_z_coordinate_type        !11
      CHARACTER(LEN=4)    :: s_obs_hght_above_sfc       !12
      CHARACTER(LEN=3)    :: s_obs_variable             !13
      CHARACTER(LEN=4)    :: s_secondary_var            !14
      CHARACTER(LEN=8)    :: s_observation_value        !15
      CHARACTER(LEN=2)    :: s_value_significance       !16
      CHARACTER(LEN=4)    :: s_secondary_value          !17
      CHARACTER(LEN=3)    :: s_units                    !18
      CHARACTER(LEN=4)    :: s_code_table               !19
      CHARACTER(LEN=1)    :: s_conversion_flag          !20
      CHARACTER(LEN=4)    :: s_location_method          !21
      CHARACTER(LEN=6)    :: s_location_precision       !22
      CHARACTER(LEN=4)    :: s_zcoord_method            !23
      CHARACTER(LEN=4)    :: s_bbox_min_long            !24
      CHARACTER(LEN=4)    :: s_bbox_max_long            !25
      CHARACTER(LEN=4)    :: s_bbox_min_lat             !26
      CHARACTER(LEN=4)    :: s_bbox_max_lat             !27
      CHARACTER(LEN=1)    :: s_spatial_represent        !28
      CHARACTER(LEN=1)    :: s_quality_flag             !29
      CHARACTER(LEN=4)    :: s_qc_passed                !30
      CHARACTER(LEN=4)    :: s_qc_failed                !31
      CHARACTER(LEN=1)    :: s_numer_precision          !32
      CHARACTER(LEN=4)    :: s_std_uncertainty          !33
      CHARACTER(LEN=4)    :: s_method_uncertainty       !34
      CHARACTER(LEN=4)    :: s_sensor_id                !35
      CHARACTER(LEN=4)    :: s_sensor_automation        !36
      CHARACTER(LEN=4)    :: s_exposure_sensor          !37
      CHARACTER(LEN=4)    :: s_orig_precision           !38
      CHARACTER(LEN=3)    :: s_orig_units               !39
      CHARACTER(LEN=8)    :: s_original_value           !40
      CHARACTER(LEN=4)    :: s_conversion_method        !41
      CHARACTER(LEN=2)    :: s_processing_code          !42
      CHARACTER(LEN=4)    :: s_processing_level         !43
      CHARACTER(LEN=4)    :: s_adjustment_id            !44
      CHARACTER(LEN=4)    :: s_traceability             !45
      CHARACTER(LEN=1)    :: s_advanced_qc              !46
      CHARACTER(LEN=1)    :: s_adv_uncertainty          !47
      CHARACTER(LEN=1)    :: s_adv_homogen              !48
      CHARACTER(LEN=39)   :: s_multiple_source          !49

      INTEGER             :: i,j,k,ii,jj,kk,io

      INTEGER             :: i_reject
      INTEGER             :: i_retain
      INTEGER             :: i_keep

      CHARACTER(LEN=300)  :: s_command
c************************************************************************
      print*,'just entered export_observation_subday'

c     Find date & time
      CALL DATE_AND_TIME(s_date1,s_time1,s_zone1,i_values1)
c*****
c     Declare variable codes
      s_code(1) ='44'    !ppt      f_vec_rain_mm(l_mlent)
      s_code(2) ='85'    !dryb     f_vec_airt_k(l_mlent)
      s_code(3) ='58'    !mslp     f_vec_slpr_hpa(l_mlent)
      s_code(4) ='107'   !wspd     f_vec_wspd_ms(l_mlent)
      s_code(5) ='38'    !relhum   f_vec_relh_pc(l_mlent)

      s_value_signif_code(1)='13'
      s_value_signif_code(2)='12'
      s_value_signif_code(3)='12'
      s_value_signif_code(4)='12'
      s_value_signif_code(5)='12'
c*****
c     Declare source_id
      s_source_id='158'
c*****
      s_title=s1_basis_wigos//'_observation.txt'

c       Open file for export
        OPEN(UNIT=1,
     +   FILE=TRIM(s_directory_root)//s_title,
     +   FORM='formatted',
     +   STATUS='NEW',ACTION='WRITE')
c*****
c        Output header here - full length titles
         s_export_header=
     + TRIM('observation_id')//'|'//TRIM('report_id')//'|'//
     + TRIM('data_policy_licence')//'|'//TRIM('date_time')//'|'//
     + TRIM('date_time_meaning')//'|'//
     + TRIM('observation_duration')//'|'//
     + TRIM('longitude')//'|'//TRIM('latitude')//'|'//
     + TRIM('crs')//'|'//TRIM('z_coordinate')//'|'//
     + TRIM('z_coordinate_type')//'|'//
     + TRIM('observation_height_above_station_surface')//'|'//
     + TRIM('observed_variable')//'|'//TRIM('secondary_variable')//'|'//
     + TRIM('observation_value')//'|'//TRIM('value_significance')//'|'//
     + TRIM('secondary_value')//'|'//TRIM('units')//'|'//
     + TRIM('code_table')//'|'//TRIM('conversion_flag')//'|'//
     + TRIM('location_method')//'|'//TRIM('location_precision')//'|'//
     + TRIM('z_coordinate_method')//'|'//
     + TRIM('bbox_min_longitude')//'|'//
     + TRIM('bbox_max_longitude')//'|'//
     + TRIM('bbox_min_latitude')//'|'//
     + TRIM('bbox_max_latitude')//'|'//
     + TRIM('spatial_represent')//'|'//
     + TRIM('quality_flag')//'|'//TRIM('qc_passed')//'|'//
     + TRIM('qc_failed')//'|'//TRIM('numerical_precision')//'|'//
     + TRIM('standard_uncertainty')//'|'//
     + TRIM('method_of estimating_standard_uncertainty')//'|'//
     + TRIM('sensor_id')//'|'//TRIM('sensor_automation_status')//'|'//
     + TRIM('exposure_of_sensor')//'|'//
     + TRIM('original_precision')//'|'//
     + TRIM('original_units')//'|'//TRIM('original_value')//'|'//
     + TRIM('conversion_method')//'|'//TRIM('processing_code')//'|'//
     + TRIM('processing_level')//'|'//TRIM('adjustment_id')//'|'//
     + TRIM('traceability')//'|'//TRIM('advanced_qc')//'|'//
     + TRIM('advanced_uncertainty')//'|'//
     + TRIM('advanced_homogenisation')//'|'//
     + TRIM('source_id')
c*****
c         Write line with header titles
          WRITE(UNIT=1,FMT=3007) ADJUSTL(s_export_header)
3007      FORMAT(a900)
c*****
c       Line-stepper for output file
        DO j=1,l_datalines
c        Observation-stepper
         DO k=1,5
c*******
          s_date_single=s_vec_date(j)
          s_year =s_date_single(7:10)
          s_month=s_date_single(4:5)
          s_day  =s_date_single(1:2)

          s_time_single=s_vec_time(j)
          s_hour  =s_time_single(1:2)
          s_minute=s_time_single(4:5)
          s_second=s_time_single(7:8)

          s_timezone5='+0000'
c*******
c         1.  Observation_id

           s_observation_id=s1_basis_wigos//'-'//
     +      s_year//'-'//s_month//'-'//s_day//'-'//
     +      s_hour//':'//s_minute//'-'//
     +      TRIM(s_code(k))//'-'//TRIM(s_value_signif_code(k))
c*******
c         2.  report_id

          s_report_id=s1_basis_wigos//'-'//
     +      s_year//'-'//s_month//'-'//s_day//'-'//s_hour//':'//s_minute
c*******
c         3.  s_data_policy_lic                             !CDM table 102
          s_data_policy_lic='0'
c*******
c         4.  s_date_time
          s_date_time=s_year//'-'//s_month//'-'//s_day//' '//
     +      s_vec_time(j)//s_timezone5(1:3)
c*******
c         5.  s_date_time_meaning
          s_date_time_meaning='2'
c*******
c         6.  observation duration

          IF (k.EQ.1) THEN
           s_obs_duration='3600'
          ENDIF
          IF (.NOT.(k.EQ.1)) THEN
           s_obs_duration='600'
          ENDIF
c*******
c         7. longitude
          s_longitude =ADJUSTL(s1_basis_lon)
c*******
c         8. latitude
          s_latitude  =ADJUSTL(s1_basis_lat)
c*******
c         9. crs                           !CDM table 101
          s_crs='0'
c*******
c         10.s_z_coordinate
          s_z_coordinate     ='NULL'
c*******
c         11.s_z_coordinate_type
          s_z_coordinate_type='NULL'
c*******
c         12.s_obs_hght_stn_sfc
          s_obs_hght_above_sfc ='NULL'
c*******
c         13.s_obs_variable
          s_obs_variable=s_code(k)
c*******
c         14.s_secondary_var
          s_secondary_var='NULL'
c*******
c         15.s_observation_value 

          IF (k.EQ.1) THEN
           f_test=f_vec_rain_mm(j)
           IF (f_test.EQ.f_ndflag) THEN 
            s_observation_value='NULL'
           ENDIF
           IF (f_test.NE.f_ndflag) THEN 
            WRITE(s_test8,'(f8.2)') f_test
            s_observation_value=ADJUSTL(s_test8)
           ENDIF
          ENDIF
          IF (k.EQ.2) THEN
           f_test=f_vec_airt_k(j)
           IF (f_test.EQ.f_ndflag) THEN 
            s_observation_value='NULL'
           ENDIF
           IF (f_test.NE.f_ndflag) THEN 
            WRITE(s_test8,'(f8.2)') f_test
            s_observation_value=ADJUSTL(s_test8)
           ENDIF
          ENDIF
          IF (k.EQ.3) THEN
           f_test=f_vec_slpr_hpa(j)
           IF (f_test.EQ.f_ndflag) THEN 
            s_observation_value='NULL'
           ENDIF
           IF (f_test.NE.f_ndflag) THEN 
            WRITE(s_test8,'(f8.3)') f_test
            s_observation_value=ADJUSTL(s_test8)
           ENDIF
          ENDIF
          IF (k.EQ.4) THEN
           f_test=f_vec_wspd_ms(j)
           IF (f_test.EQ.f_ndflag) THEN 
            s_observation_value='NULL'
           ENDIF
           IF (f_test.NE.f_ndflag) THEN 
            WRITE(s_test8,'(f8.2)') f_test
            s_observation_value=ADJUSTL(s_test8)
           ENDIF
          ENDIF
          IF (k.EQ.5) THEN
           f_test=f_vec_relh_pc(j)
           IF (f_test.EQ.f_ndflag) THEN 
            s_observation_value='NULL'
           ENDIF
           IF (f_test.NE.f_ndflag) THEN 
            WRITE(s_test8,'(f8.2)') f_test
            s_observation_value=ADJUSTL(s_test8)
           ENDIF
          ENDIF
c*******
c         16.s_value_significance                !CDM Table 116

          s_value_significance=s_value_signif_code(k)
c*******
c         17.s_secondary_value
          s_secondary_value='NULL'
c*******
c         18.s_units
          IF (k.EQ.1) THEN  
           s_units='710'   !ppt_mm
          ENDIF
          IF (k.EQ.2) THEN
           s_units='005'   !airt_k
          ENDIF
          IF (k.EQ.3) THEN
           s_units='530'   !mslp hpa
          ENDIF
          IF (k.EQ.4) THEN
           s_units='731'   !wspd m/s
          ENDIF
          IF (k.EQ.5) THEN
           s_units='300'   !relhum
          ENDIF
c*******
c         19.s_code_table
          s_code_table='NULL'
c*******
c         20.s_conversion_flag          !CDM table 99
          IF (k.EQ.1) THEN  
           s_conversion_flag='2'     !ppt_mm
          ENDIF
          IF (k.EQ.2) THEN
           s_conversion_flag='0'     !airt_k
          ENDIF
          IF (k.EQ.3) THEN
           s_conversion_flag='2'     !mslp
          ENDIF
          IF (k.EQ.4) THEN
           s_conversion_flag='0'     !wspd
          ENDIF
          IF (k.EQ.5) THEN
           s_conversion_flag='1'     !relhum
          ENDIF
c*******
c         21.s_location_method
          s_location_method='NULL'
c*******
c         22.s_location_precision
          s_location_precision='0.01'
c*******
c         23.s_zcoord_method
          s_zcoord_method='NULL'
c*******
c         24.s_bbox_min_long
          s_bbox_min_long='NULL'
c*******
c         25.s_bbox_max_long
          s_bbox_max_long='NULL'
c*******
c         26.s_bbox_min_lat
          s_bbox_min_lat='NULL'
c*******
c         27.s_bbox_max_lat
          s_bbox_max_lat='NULL'
c*******
c         28.s_spatial_represent
          s_spatial_represent='0'
c*******
c         29.s_quality_flag               !CDM Table 131
          s_quality_flag='4'
c*******
c         30.s_qc_passed
          s_qc_passed='NULL'
c*******
c         31.s_qc_failed
          s_qc_failed='NULL'
c*******
c         32.s_numer_precision (number of decimal places)
          IF (k.EQ.1) THEN  
           s_numer_precision='1'     !ppt_mm
          ENDIF
          IF (k.EQ.2) THEN
           s_numer_precision='2'     !airt_k
          ENDIF
          IF (k.EQ.3) THEN
           s_numer_precision='3'     !mslp_hpa
          ENDIF
          IF (k.EQ.4) THEN
           s_numer_precision='0'     !wspd_m/s
          ENDIF
          IF (k.EQ.5) THEN
           s_numer_precision='0'     !relhum_pc
          ENDIF
c*******
c         33.s_std_uncertainty
          s_std_uncertainty='NULL'
c*******
c         34.s_method_uncertainty
          s_method_uncertainty='NULL'
c*******
c         35.s_sensor_id
          s_sensor_id='NULL'
c*******
c         36.s_sensor_automation
          s_sensor_automation='NULL'
c*******
c         37.s_exposure_sensor
          s_exposure_sensor='NULL'
c*******
c         38.s_orig_precision
          IF (k.EQ.1) THEN  
           s_orig_precision='1'     !ppt_mm
          ENDIF
          IF (k.EQ.2) THEN
           s_orig_precision='2'     !airt_c
          ENDIF
          IF (k.EQ.3) THEN
           s_orig_precision='3'     !mslp_hpa
          ENDIF
          IF (k.EQ.4) THEN
           s_orig_precision='0'     !wspd_ms
          ENDIF
          IF (k.EQ.5) THEN
           s_orig_precision='0'     !relhum_pc
          ENDIF
c*******
c         39.s_orig_units
          IF (k.EQ.1) THEN  
           s_orig_units='710'   !ppt_mm
          ENDIF
          IF (k.EQ.2) THEN
           s_orig_units='060'   !airt_c
          ENDIF
          IF (k.EQ.3) THEN
           s_orig_units='530'   !mslp_hpa
          ENDIF
          IF (k.EQ.4) THEN
           s_orig_units='201'   !wspd_kt
          ENDIF
          IF (k.EQ.5) THEN
           s_orig_units='300'   !relhum_pc
          ENDIF
c*******
c         40.s_original_value
          IF (k.EQ.1) THEN
           IF (s_conversion_flag.EQ.'2') THEN
            s_original_value=''
           ENDIF
           IF (s_conversion_flag.NE.'2') THEN 
            f_test=f_vec_rain_mm(j)               !ppt_mm
            IF (f_test.EQ.f_ndflag) THEN 
             s_original_value='NULL'
            ENDIF
            IF (f_test.NE.f_ndflag) THEN
             WRITE(s_test8,'(f8.2)') f_test
             s_original_value=ADJUSTL(s_test8)
            ENDIF
           ENDIF
          ENDIF

          IF (k.EQ.2) THEN
           IF (s_conversion_flag.EQ.'2') THEN
            s_original_value=''
           ENDIF
           IF (s_conversion_flag.NE.'2') THEN 
            f_test=f_vec_airt_c(j)                !airt_c
            IF (f_test.EQ.f_ndflag) THEN 
             s_original_value='NULL'
            ENDIF
            IF (f_test.NE.f_ndflag) THEN
             WRITE(s_test8,'(f8.2)') f_test
             s_original_value=ADJUSTL(s_test8)
            ENDIF
           ENDIF
          ENDIF

          IF (k.EQ.3) THEN                       !mslp_hpa
           IF (s_conversion_flag.EQ.'2') THEN
            s_original_value=''
           ENDIF
           IF (s_conversion_flag.NE.'2') THEN 
            f_test=f_vec_slpr_hpa(j)
            IF (f_test.EQ.f_ndflag) THEN 
             s_original_value='NULL'
            ENDIF
            IF (f_test.NE.f_ndflag) THEN
             WRITE(s_test8,'(f8.3)') f_test
             s_original_value=ADJUSTL(s_test8)
            ENDIF
           ENDIF
          ENDIF

          IF (k.EQ.4) THEN
           IF (s_conversion_flag.EQ.'2') THEN
            s_original_value=''
           ENDIF
           IF (s_conversion_flag.NE.'2') THEN 
            f_test=f_vec_wspd_kt(j)                !wspd_kt
            IF (f_test.EQ.f_ndflag) THEN 
             s_original_value='NULL'
            ENDIF
            IF (f_test.NE.f_ndflag) THEN
             WRITE(s_test8,'(f8.2)') f_test
             s_original_value=ADJUSTL(s_test8)
            ENDIF
           ENDIF
          ENDIF

          IF (k.EQ.5) THEN                        !relhum_pc
           IF (s_conversion_flag.EQ.'2') THEN
            s_original_value=''
           ENDIF
           IF (s_conversion_flag.NE.'2') THEN 
            f_test=f_vec_relh_pc(j)
            IF (f_test.EQ.f_ndflag) THEN 
             s_original_value='NULL'
            ENDIF
            IF (f_test.NE.f_ndflag) THEN
             WRITE(s_test8,'(f8.2)') f_test
             s_original_value=ADJUSTL(s_test8)
            ENDIF
           ENDIF
          ENDIF
c*******
c         41.s_conversion_method 

          IF (k.EQ.1) THEN
           s_conversion_method='NULL'      !ppt 
          ENDIF
          IF (k.EQ.2) THEN    
           s_conversion_method='1'         !airt 
          ENDIF
          IF (k.EQ.3) THEN
           s_conversion_method='NULL'      !mslp
          ENDIF
          IF (k.EQ.2) THEN    
           s_conversion_method='5'         !wspd code 107; method 5
          ENDIF
          IF (k.EQ.3) THEN
           s_conversion_method='NULL'      !relh 
          ENDIF
c*******
c         42.s_processing_code
          s_processing_code='{}'
c*******
c         43.s_processing_level
          s_processing_level='NULL'
c*******
c         44.s_adjustment_id
          s_adjustment_id='NULL'
c*******
c         45.s_traceability
          s_traceability='NULL'
c*******
c         46.s_advanced_qc
          s_advanced_qc='0'
c*******
c         47.s_advanced_uncertainty 
          s_adv_uncertainty='0' 
c*******
c         48.s_advanced_homogen
          s_adv_homogen='0'
c*******
c         49.s_multiple_source

          s_multiple_source=TRIM(s_source_id)//'-'//TRIM(s_date_time)
c          s_multiple_source=TRIM(s_source_id)//'-'//TRIM(s_report_id)
c*******
c*******
c      s_code(1) ='44'    !ppt      f_vec_rain_mm(l_mlent)
c      s_code(2) ='85'    !dryb     f_vec_airt_k(l_mlent)
c      s_code(3) ='58'    !mslp     f_vec_slpr_hpa(l_mlent)
c      s_code(4) ='107'   !wspd     f_vec_wspd_ms(l_mlent)
c      s_code(5) ='38'    !relhum   f_vec_relh_pc(l_mlent)
c*******
c         Criteria for retain/reject lines
          i_keep=0
          IF (s_observation_value.EQ.'NULL') THEN
           i_reject=i_reject+1
          ENDIF  
          IF (.NOT.(s_observation_value.EQ.'NULL')) THEN
           i_retain=i_retain+1
           i_keep=1
          ENDIF      
c*******
      IF (i_keep.EQ.1) THEN 
         s_export_line=
     + TRIM(s_observation_id)//'|'//TRIM(s_report_id)//'|'//
     + TRIM(s_data_policy_lic)//'|'//TRIM(s_date_time)//'|'//
     + TRIM(s_date_time_meaning)//'|'//TRIM(s_obs_duration)//'|'//
     + TRIM(s_longitude)//'|'//TRIM(s_latitude)//'|'//
     + TRIM(s_crs)//'|'//TRIM(s_z_coordinate)//'|'//
     + TRIM(s_z_coordinate_type)//'|'//TRIM(s_obs_hght_above_sfc)//'|'//
     + TRIM(s_obs_variable)//'|'//TRIM(s_secondary_var)//'|'//
     + TRIM(s_observation_value)//'|'//TRIM(s_value_significance)//'|'//
     + TRIM(s_secondary_value)//'|'//TRIM(s_units)//'|'//
     + TRIM(s_code_table)//'|'//TRIM(s_conversion_flag)//'|'//
     + TRIM(s_location_method)//'|'//TRIM(s_location_precision)//'|'//
     + TRIM(s_zcoord_method)//'|'//TRIM(s_bbox_min_long)//'|'//
     + TRIM(s_bbox_max_long)//'|'//TRIM(s_bbox_min_lat)//'|'//
     + TRIM(s_bbox_max_lat)//'|'//TRIM(s_spatial_represent)//'|'//
     + TRIM(s_quality_flag)//'|'//TRIM(s_qc_passed)//'|'//
     + TRIM(s_qc_failed)//'|'//TRIM(s_numer_precision)//'|'//
     + TRIM(s_std_uncertainty)//'|'//TRIM(s_method_uncertainty)//'|'//
     + TRIM(s_sensor_id)//'|'//TRIM(s_sensor_automation)//'|'//
     + TRIM(s_exposure_sensor)//'|'//TRIM(s_orig_precision)//'|'//
     + TRIM(s_orig_units)//'|'//TRIM(s_original_value)//'|'//
     + TRIM(s_conversion_method)//'|'//TRIM(s_processing_code)//'|'//
     + TRIM(s_processing_level)//'|'//TRIM(s_adjustment_id)//'|'//
     + TRIM(s_traceability)//'|'//TRIM(s_advanced_qc)//'|'//
     + TRIM(s_adv_uncertainty)//'|'//TRIM(s_adv_homogen)//'|'//
     + TRIM(s_multiple_source)

c         Write line with 1 observation
          WRITE(UNIT=1,FMT=3009) ADJUSTL(s_export_line)
3009      FORMAT(a400)

      ENDIF
c*******
      GOTO 111

          print*,'s_observation_id='//TRIM(s_observation_id)//'xx'
          print*,'s_report_id='//TRIM(s_report_id)//'xx'
          print*,'s_data_policy_lic='//TRIM(s_data_policy_lic)//'xx'
          print*,'s_date_time='//TRIM(s_date_time)//'xx'

          print*,'s_date_time_meaning='//TRIM(s_date_time_meaning)//'xx'
          print*,'s_obs_duration='//TRIM(s_obs_duration)//'xx'
          print*,'s_longitude='//TRIM(s_longitude)//'xx'
          print*,'s_latitude='//TRIM(s_latitude)//'xx'

          print*,'s_crs='//TRIM(s_crs)//'xx'
          print*,'s_z_coordinate='//TRIM(s_z_coordinate)//'xx'
          print*,'s_z_coordinate_type='//TRIM(s_z_coordinate_type)//'xx'
          print*,'s_obs_hght_above_sfc='//
     +      TRIM(s_obs_hght_above_sfc)//'xx'

          print*,'s_obs_variable='//TRIM(s_obs_variable)//'xx'
          print*,'s_secondary_var='//TRIM(s_secondary_var)//'xx'
          print*,'s_observation_value='//TRIM(s_observation_value)//'xx'
          print*,'s_value_significance='//
     +      TRIM(s_value_significance)//'xx'

          print*,'s_secondary_value='//TRIM(s_secondary_value)//'xx'
          print*,'s_units='//TRIM(s_units)//'xx'
          print*,'s_code_table='//TRIM(s_code_table)//'xx'
          print*,'s_conversion_flag='//TRIM(s_conversion_flag)//'xx'

          print*,'s_location_method='//TRIM(s_location_method)//'xx'
          print*,'s_location_precision='//
     +      TRIM(s_location_precision)//'xx'
          print*,'s_zcoord_method='//TRIM(s_zcoord_method)//'xx'
          print*,'s_bbox_min_long='//TRIM(s_bbox_min_long)//'xx'

          print*,'s_bbox_max_long='//TRIM(s_bbox_max_long)//'xx'
          print*,'s_bbox_min_lat='//TRIM(s_bbox_min_lat)//'xx'
          print*,'s_bbox_max_lat='//TRIM(s_bbox_max_lat)//'xx'
          print*,'s_spatial_represent='//TRIM(s_spatial_represent)//'xx'

          print*,'s_quality_flag='//TRIM(s_quality_flag)//'xx'
          print*,'s_qc_passed='//TRIM(s_qc_passed)//'xx'
          print*,'s_qc_failed='//TRIM(s_qc_failed)//'xx'
          print*,'s_numer_precision='//TRIM(s_numer_precision)//'xx'

          print*,'s_std_uncertainty='//TRIM(s_std_uncertainty)//'xx'
          print*,'s_method_uncertainty='//
     +      TRIM(s_method_uncertainty)//'xx'
          print*,'s_sensor_id='//TRIM(s_sensor_id)//'xx'
          print*,'s_sensor_automation='//TRIM(s_sensor_automation)//'xx'

          print*,'s_exposure_sensor='//TRIM(s_exposure_sensor)//'xx'
          print*,'s_orig_precision='//TRIM(s_orig_precision)//'xx'
          print*,'s_orig_units='//TRIM(s_orig_units)//'xx'
          print*,'s_original_value='//TRIM(s_original_value)//'xx'

          print*,'s_conversion_method='//TRIM(s_conversion_method)//'xx'
          print*,'s_processing_code='//TRIM(s_processing_code)//'xx'
          print*,'s_processing_level='//TRIM(s_processing_level)//'xx'
          print*,'s_adjustment_id='//TRIM(s_adjustment_id)//'xx'

          print*,'s_traceability='//TRIM(s_traceability)//'xx'
          print*,'s_advanced_qc='//TRIM(s_advanced_qc)//'xx'
          print*,'s_adv_uncertainty='//TRIM(s_adv_uncertainty)//'xx'
          print*,'s_adv_homogen='//TRIM(s_adv_homogen)//'xx'
          print*,'s_multiple_source='//TRIM(s_multiple_source)//'xx'

c          CALL SLEEP(2)
111    CONTINUE
c*******
         ENDDO  !close k
        ENDDO   !close j

        CLOSE(UNIT=1)

c     Compress data file; placed immediately after file close
      s_command=TRIM('gzip -qq '//TRIM(s_directory_root)//TRIM(s_title))
      CALL SYSTEM(s_command,io)
c*******
c************************************************************************
      print*,'just leaving export_observation_subday'

      RETURN
      END


