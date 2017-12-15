c     Subroutine to create subdaily header file
c     AJ_Kettle, Dec5/2017
c     modified Dec8/2017 to include 2 types output duration

      SUBROUTINE export_header_subdaily1a(f_ndflag,s_directory_root,
     +  s_basis_wigos_full_single,j_sd,l_mlent,
     +  st_sd_year,st_sd_month,st_sd_day,st_sd_timeutc,
     +  st_sd_timeutc_hh_mm_ss,
     +  s_basis_stnname_single,
     +  s_basis_hght_single,s_basis_lat_single,s_basis_lon_single,

     +  f_duration_s)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into subroutine

      REAL                :: f_ndflag
      CHARACTER(LEN=300)  :: s_directory_root

      INTEGER             :: l_mlent
      INTEGER             :: l_file_basis
c      INTEGER             :: l_mstn
c      CHARACTER(LEN=5)    :: s_basis_stke(l_mstn)
c      CHARACTER(LEN=5)    :: s_basis_stid(l_mstn)
c      CHARACTER(LEN=17)   :: s_basis_wigos_full(l_mstn)
      CHARACTER(LEN=17)   :: s_basis_wigos_full_single
      INTEGER             :: j_sd
      CHARACTER(LEN=25)   :: s_basis_stnname_single
      CHARACTER(LEN=9)    :: s_basis_hght_single
      CHARACTER(LEN=10)   :: s_basis_lat_single
      CHARACTER(LEN=10)   :: s_basis_lon_single

      CHARACTER(LEN=4)    :: st_sd_year(l_mlent)
      CHARACTER(LEN=2)    :: st_sd_month(l_mlent) 
      CHARACTER(LEN=2)    :: st_sd_day(l_mlent) 
      CHARACTER(LEN=4)    :: st_sd_timeutc(l_mlent)
      CHARACTER(LEN=8)    :: st_sd_timeutc_hh_mm_ss(l_mlent)

      REAL                :: f_duration_s(l_mlent)

c     Variables used in subroutine
      CHARACTER(LEN=8)    :: s_date1
      CHARACTER(LEN=10)   :: s_time1
      CHARACTER(LEN=5)    :: s_zone1
      INTEGER             :: i_values1(8)

      CHARACTER(LEN=28)   :: s_title   !from 24 to 28 hcar with .txt extension

      CHARACTER(LEN=4)    :: s_year
      CHARACTER(LEN=2)    :: s_month
      CHARACTER(LEN=2)    :: s_day
      CHARACTER(LEN=8)    :: s_time_single
      CHARACTER(LEN=2)    :: s_hour
      CHARACTER(LEN=2)    :: s_minute
      CHARACTER(LEN=2)    :: s_second
      CHARACTER(LEN=3)    :: s_timezone

      CHARACTER(LEN=34)   :: s_report_id                 !1
      CHARACTER(LEN=3)    :: s_region                    !2
      CHARACTER(LEN=3)    :: s_subregion                 !3
      CHARACTER(LEN=30)   :: s_application_area          !4
      CHARACTER(LEN=30)   :: s_observing_program         !5
      CHARACTER(LEN=4)    :: s_report_type               !6
      CHARACTER(LEN=50)   :: s_station_name              !7
      CHARACTER(LEN=1)    :: s_station_type              !8
      CHARACTER(LEN=4)    :: s_platform_type             !9
      CHARACTER(LEN=4)    :: s_platform_subtype          !10 
      CHARACTER(LEN=17)   :: s_primary_stn_id            !11
      CHARACTER(LEN=1)    :: s_stn_record_number         !12
      CHARACTER(LEN=1)    :: s_primary_stn_id_scheme     !13
      CHARACTER(LEN=10)   :: s_longitude                 !14
      CHARACTER(LEN=10)   :: s_latitude                  !15
      CHARACTER(LEN=6)    :: s_location_accuracy         !16
      CHARACTER(LEN=4)    :: s_location_method           !17
      CHARACTER(LEN=1)    :: s_location_quality          !18
      CHARACTER(LEN=1)    :: s_crs                       !19
      CHARACTER(LEN=4)    :: s_station_speed             !20
      CHARACTER(LEN=4)    :: s_station_course            !21
      CHARACTER(LEN=4)    :: s_station_heading           !22
      CHARACTER(LEN=4)    :: s_hght_above_grd            !23
      CHARACTER(LEN=8)    :: s_hght_above_sea_level      !24
      CHARACTER(LEN=4)    :: s_hght_stn_accuracy         !25
      CHARACTER(LEN=4)    :: s_sea_level_datum           !26
      CHARACTER(LEN=1)    :: s_meaning_timestamp         !27
      CHARACTER(LEN=22)   :: s_report_timestamp          !28
      CHARACTER(LEN=8)    :: s_report_duration           !29
      CHARACTER(LEN=4)    :: s_report_time_accuracy      !30
      CHARACTER(LEN=4)    :: s_report_time_quality       !31
      CHARACTER(LEN=1)    :: s_report_time_ref           !32
      CHARACTER(LEN=4)    :: s_profile_id                !33
      CHARACTER(LEN=2)    :: s_events_at_station         !34
      CHARACTER(LEN=4)    :: s_report_quality            !35
      CHARACTER(LEN=1)    :: s_duplicate_status          !36
      CHARACTER(LEN=2)    :: s_duplicates                !37
      CHARACTER(LEN=24)   :: s_record_timestamp          !38
      CHARACTER(LEN=20)   :: s_history                   !39
      CHARACTER(LEN=1)    :: s_processing_level          !40
      CHARACTER(LEN=2)    :: s_processing_codes          !41
      CHARACTER(LEN=3)    :: s_source_id                 !42
      CHARACTER(LEN=4)    :: s_source_record_id          !43

      CHARACTER(LEN=400)  :: s_export_line
      CHARACTER(LEN=800)  :: s_export_header

      REAL                :: f_test
      INTEGER             :: i_test
      CHARACTER(LEN=8)    :: s_test8

      INTEGER             :: i,j,k,ii,jj,kk,io

      CHARACTER(LEN=300)  :: s_command
c************************************************************************
      print*,'just entered export_header_subdaily'
c      print*,'s_basis_wigos_full_single',s_basis_wigos_full_single

c      print*,'stime=',   (s_monrec_common_stime(j),j=1,4)
c      print*,'timezone=',(s_monrec_common_timezone(j),j=1,4)
c      CALL SLEEP(5)

c     Find date & time
      CALL DATE_AND_TIME(s_date1,s_time1,s_zone1,i_values1)

      print*,'s_date=',s_date1
      print*,'s_time=',s_time1
      print*,'s_zone=',s_zone1

      s_title=s_basis_wigos_full_single//'_header.txt'

c      print*,'s_title=',s_title

c     Open file for export
      OPEN(UNIT=1,
     +   FILE=TRIM(s_directory_root)//s_title,
     +   FORM='formatted',
     +   STATUS='NEW',ACTION='WRITE')

         s_export_header=
     + TRIM('report_id')//'|'//TRIM('region')//'|'//
     + TRIM('subregion')//'|'//TRIM('application_area')//'|'//
     + TRIM('observing_program')//'|'//TRIM('report_type')//'|'//
     + TRIM('station_name')//'|'//TRIM('station_type')//'|'//
     + TRIM('platform_type')//'|'//TRIM('platform_sub_type')//'|'//
     + TRIM('primary_station_id')//'|'//
     + TRIM('station_record_number')//'|'//
     + TRIM('primary_station_id_scheme')//'|'//TRIM('longitude')//'|'//
     + TRIM('latitude')//'|'//TRIM('location_accuracy')//'|'//
     + TRIM('location_method')//'|'//TRIM('location_quality')//'|'//
     + TRIM('crs')//'|'//TRIM('station_speed')//'|'//
     + TRIM('station_course')//'|'//TRIM('station_heading')//'|'//
     + TRIM('height_of_station_above_local_ground')//'|'//
     + TRIM('height_of_above_sea_level')//'|'//
     + TRIM('height_of_station_above_sea_level_accuracy')//'|'//
     + TRIM('sea_level_datum')//'|'//
     + TRIM('report_meaning_of_time_stamp')//'|'//
     + TRIM('report_timestamp')//'|'//
     + TRIM('report_duration')//'|'//TRIM('report_time_accuracy')//'|'//
     + TRIM('report_time_quality')//'|'//
     + TRIM('report_time_reference')//'|'//
     + TRIM('profile_id')//'|'//TRIM('events_at_station')//'|'//
     + TRIM('report_quality')//'|'//TRIM('duplicate_status')//'|'//
     + TRIM('duplicates')//'|'//TRIM('record_timestamp')//'|'//
     + TRIM('history')//'|'//TRIM('processing_level')//'|'//
     + TRIM('processing_codes')//'|'//TRIM('source_id')//'|'//
     + TRIM('source_record_id')

         WRITE(UNIT=1,FMT=3011) ADJUSTL(s_export_header)
3011     FORMAT(a800)

c     Line-stepper for output file
      DO j=1,10 !j_sd

       DO k=1,2      !k=1 for instaneous measurements; k=2 for ppt accumulations
c*******
c        1.  Make report_id (34 characters subdaily)

c         s_date_single=s_day_date(j)
         s_year =st_sd_year(j)
         s_month=st_sd_month(j)
         s_day  =st_sd_day(j)

         s_time_single=st_sd_timeutc_hh_mm_ss(j)  !st_sd_timeutc(j)
         s_hour  =s_time_single(1:2)
         s_minute=s_time_single(4:5)
         s_second=s_time_single(7:8)

         s_report_id=s_basis_wigos_full_single//'-'//
     +     s_year//'-'//s_month//'-'//s_day//' '//s_hour//':'//s_minute
c*******
c        2.  region
         s_region='6'               !Europe=6, Namer=4 [CDM Table 132]
c*******
c        3.  subregion
         s_subregion='56'           !Ireland=101, Germany=56 [CDM Table150]
c*******
c        4.  application_area       !CDM table 95
         s_application_area='{1,4,5,8,9,10,11,14,15,16}'  
c*******      
c        5.  observing_program      !CDM table 120
         s_observing_program='{5,10,48,49,50}'
c*******
c        6.  report_type            !CDM table with TBD
         s_report_type='NULL'    
c*******
c        7.  station_name
         s_station_name=s_basis_stnname_single
c*******
c        8.  station_type           !1 for land-based stations
         s_station_type='1'
c*******
c        9.  platform_type
         s_platform_type='NULL' 
c*******
c        10. platform subtype
         s_platform_subtype='NULL'
c*******
c        11. primary_station_id
         s_primary_stn_id=s_basis_wigos_full_single
c*******
c        12. station_record_number
         s_stn_record_number='1'
c*******
c        13. primary_station_id_scheme
         s_primary_stn_id_scheme='0'
c*******
c        14. longitude
         s_longitude =ADJUSTL(s_basis_lon_single)
c*******
c        15. latitude
         s_latitude  =ADJUSTL(s_basis_lat_single)
c*******
c        16. location_accuracy
         s_location_accuracy='0.0001'
c*******
c        17. location method
         s_location_method='NULL'
c*******
c        18. location quality              !CDM table 112
         s_location_quality='3'
c*******
c        19. crs                           !CDM table 101
         s_crs='0'
c*******
c        20. station_speed 
         s_station_speed='NULL' 
c*******
c        21. station_course
         s_station_course='NULL'
c*******
c        22. station_heading
         s_station_heading='NULL'
c*******
c        23. hght_stn_above_grd
         s_hght_above_grd='NULL'
c*******
c        24. hght_stn_above_sea_level
         s_hght_above_sea_level=ADJUSTL(s_basis_hght_single)
c*******
c        25. hght_stn_accuracy
         s_hght_stn_accuracy='NULL'
c*******
c        26. sea_level_datum
         s_sea_level_datum='NULL'
c*******
c        27. report_meaning_of_time_stamp
         s_meaning_timestamp='2'
c*******
c        28. report_timestamp (22characters)
         s_report_timestamp=s_year//'-'//s_month//'-'//s_day//' '//
     +     s_hour//':'//s_minute//':'//s_second//'+00'
c*******
c        29. report_duration

         IF (k.EQ.1) THEN
          s_report_duration='600'
         ENDIF

         IF (k.EQ.2) THEN
          IF (f_duration_s(j).EQ.f_ndflag) THEN
           s_report_duration='NULL'
          ENDIF
          IF (f_duration_s(j).NE.f_ndflag) THEN
c          Convert report duration from float to string
           i_test=NINT(f_duration_s(j))
           WRITE(s_test8,'(i8)') i_test
           s_report_duration=ADJUSTL(s_test8)
          ENDIF
         ENDIF
c*******
c        30. report_time_accuracy
         s_report_time_accuracy='NULL'
c*******
c        31. report_time_quality
         s_report_time_quality='NULL'
c*******
c        32. report_time_reference               !CDM table 152
         s_report_time_ref='0'
c*******
c        33. profile_id
         s_profile_id='NULL'
c*******
c        34. events_at_station
         s_events_at_station='{}'
c*******
c        35. report_quality 
         s_report_quality='NULL'
c*******
c        36. duplicate_status                     !CDM Table 104
         s_duplicate_status='4'
c*******
c        37. duplicates
         s_duplicates='{}'
c*******
c        38. record_timestamp (24 characters)
         s_record_timestamp=
     +    s_date1(1:4)//'-'//s_date1(5:6)//'-'//s_date1(7:8)//' '//
     +    s_time1(1:2)//':'//s_time1(3:4)//':'//s_time1(5:6)//
     +    s_zone1(1:5)
c*******
c        39. history
         s_history='initial data release'
c*******
c        40. processing_level                     !CDM Table 124
         s_processing_level='0'
c*******
c        41. processing_codes 
         s_processing_codes='{}'
c*******
c        42. source_id
         s_source_id='82'
c*******
c        43. source_record_id
         s_source_record_id='NULL'
c*******
c        Pipe separators
         s_export_line=
     + TRIM(s_report_id)//'|'//TRIM(s_region)//'|'//
     + TRIM(s_subregion)//'|'//TRIM(s_application_area)//'|'//
     + TRIM(s_observing_program)//'|'//TRIM(s_report_type)//'|'//
     + TRIM(s_station_name)//'|'//TRIM(s_station_type)//'|'//
     + TRIM(s_platform_type)//'|'//TRIM(s_platform_subtype)//'|'//
     + TRIM(s_primary_stn_id)//'|'//TRIM(s_stn_record_number)//'|'//
     + TRIM(s_primary_stn_id_scheme)//'|'//TRIM(s_longitude)//'|'//
     + TRIM(s_latitude)//'|'//TRIM(s_location_accuracy)//'|'//
     + TRIM(s_location_method)//'|'//TRIM(s_location_quality)//'|'//
     + TRIM(s_crs)//'|'//TRIM(s_station_speed)//'|'//
     + TRIM(s_station_course)//'|'//TRIM(s_station_heading)//'|'//
     + TRIM(s_hght_above_grd)//'|'//TRIM(s_hght_above_sea_level)//'|'//
     + TRIM(s_hght_stn_accuracy)//'|'//TRIM(s_sea_level_datum)//'|'//
     + TRIM(s_meaning_timestamp)//'|'//TRIM(s_report_timestamp)//'|'//
     + TRIM(s_report_duration)//'|'//TRIM(s_report_time_accuracy)//'|'//
     + TRIM(s_report_time_quality)//'|'//TRIM(s_report_time_ref)//'|'//
     + TRIM(s_profile_id)//'|'//TRIM(s_events_at_station)//'|'//
     + TRIM(s_report_quality)//'|'//TRIM(s_duplicate_status)//'|'//
     + TRIM(s_duplicates)//'|'//TRIM(s_record_timestamp)//'|'//
     + TRIM(s_history)//'|'//TRIM(s_processing_level)//'|'//
     + TRIM(s_processing_codes)//'|'//TRIM(s_source_id)//'|'//
     + TRIM(s_source_record_id)

         WRITE(UNIT=1,FMT=3009) ADJUSTL(s_export_line)
3009     FORMAT(a400)
c*******
      GOTO 11

         print*,'s_report_id='//'xx'//TRIM(s_report_id)//'xx'
         print*,'s_region='//'xx'//TRIM(s_region)//'xx'
         print*,'s_subregion='//'xx'//TRIM(s_subregion)//'xx'
         print*,'s_application_area='//'xx'//TRIM(s_application_area)//
     +     'xx'
         print*,'s_observing_program='//'xx'//TRIM(s_observing_program)
     +     //'xx'
         print*,'s_report_type='//'xx'//TRIM(s_report_type)//'xx'
         print*,'s_station_name='//'xx'//TRIM(s_station_name)//'xx'
         print*,'s_station_type='//'xx'//TRIM(s_station_type)//'xx'

         print*,'s_platform_type'//'xx'//TRIM(s_platform_type)//'xx'
         print*,'s_platform_subtype'//'xx'//TRIM(s_platform_subtype)
     +     //'xx'
         print*,'s_primary_stn_id'//'xx'//TRIM(s_primary_stn_id)//'xx'
         print*,'s_stn_record_number'//'xx'//TRIM(s_stn_record_number)
     +     //'xx'
         print*,'s_primary_stn_id_scheme'//'xx'//
     +     TRIM(s_primary_stn_id_scheme)//'xx'
         print*,'s_longitude'//'xx'//TRIM(s_longitude)//'xx'
         print*,'s_latitude'//'xx'//TRIM(s_latitude)//'xx'
         print*,'s_location_accuracy'//'xx'//TRIM(s_location_accuracy)
     +     //'xx'
         print*,'s_location_method'//'xx'//TRIM(s_location_method)//'xx'
         print*,'s_location_quality'//'xx'//TRIM(s_location_quality)
     +     //'xx'
         print*,'s_crs'//'xx'//TRIM(s_crs)//'xx'
         print*,'s_station_speed'//'xx'//TRIM(s_station_speed)//'xx'
         print*,'s_station_course'//'xx'//TRIM(s_station_course)//'xx'
         print*,'s_station_heading'//'xx'//TRIM(s_station_heading)//'xx'
         print*,'s_hght_above_grd'//'xx'//TRIM(s_hght_above_grd)//'xx'
         print*,'s_hght_above_sea_level'//'xx'//
     +     TRIM(s_hght_above_sea_level)//'xx'
         print*,'s_hght_stn_accuracy'//'xx'//TRIM(s_hght_stn_accuracy)
     +     //'xx'
         print*,'s_sea_level_datum'//'xx'//TRIM(s_sea_level_datum)//'xx'
         print*,'s_meaning_timestamp'//'xx'//TRIM(s_meaning_timestamp)
     +     //'xx'
         print*,'s_report_timestamp'//'xx'//TRIM(s_report_timestamp)
     +     //'xx'
         print*,'s_report_duration'//'xx'//TRIM(s_report_duration)
     +     //'xx'
         print*,'s_report_time_accuracy'//'xx'//
     +     TRIM(s_report_time_accuracy)//'xx'
         print*,'s_report_time_quality'//'xx'//
     +     TRIM(s_report_time_quality)//'xx'
         print*,'s_report_time_ref'//'xx'//TRIM(s_report_time_ref)
     +     //'xx'
         print*,'s_profile_id'//'xx'//TRIM(s_profile_id)//'xx'
         print*,'s_events_at_station'//'xx'//TRIM(s_events_at_station)
     +     //'xx'
         print*,'s_report_quality'//'xx'//TRIM(s_report_quality)//'xx'
         print*,'s_duplicate_status'//'xx'//TRIM(s_duplicate_status)
     +     //'xx'
         print*,'s_duplicates'//'xx'//TRIM(s_duplicates)//'xx'
         print*,'s_record_timestamp'//'xx'//TRIM(s_record_timestamp)
     +     //'xx'
         print*,'s_history'//'xx'//TRIM(s_history)//'xx'
         print*,'s_processing_level'//'xx'//TRIM(s_processing_level)
     +     //'xx'
         print*,'s_processing_codes'//'xx'//TRIM(s_processing_codes)
     +     //'xx'
         print*,'s_source_id'//'xx'//TRIM(s_source_id)//'xx'
         print*,'s_source_record_id'//'xx'//TRIM(s_source_record_id)
     +     //'xx'

11    CONTINUE
c*******
       ENDDO   !close index k
      ENDDO    !close index j

      CLOSE(UNIT=1) 

c     Compress data file
      s_command=TRIM('gzip -qq '//TRIM(s_directory_root)//TRIM(s_title))
      CALL SYSTEM(s_command,io)
c************************************************************************
c      print*,'just leaving export_header_subdaily'
c      CALL SLEEP(5)
       
      RETURN
      END