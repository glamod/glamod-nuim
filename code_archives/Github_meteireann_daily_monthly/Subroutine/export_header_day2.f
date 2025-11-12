c     Subroutine to export header table for Meteireanne daily
c     AJ_Kettle, Dec19/2017
c     Jan12/2018: modified to change timezone from 5char to 3char

      SUBROUTINE export_header_day2(f_ndflag,s_directory_root, 
     +  l_datalines, 
     +  s1_basis_nameshort,s1_basis_namelist,s1_basis_fileid,
     +  s1_basis_alt_m,s1_basis_lat,s1_basis_lon,s1_basis_wigos,
     +  l_mlent,
     +  s_vec_date,s_vec_time,f_vec_rain_mm,f_vec_maxdy_k,f_vec_mindy_k)

      IMPLICIT NONE
c************************************************************************
c     Declare variables

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
      REAL                :: f_vec_rain_mm(l_mlent)
      REAL                :: f_vec_maxdy_k(l_mlent)
      REAL                :: f_vec_mindy_k(l_mlent)

      INTEGER             :: i,j,k,ii,jj,kk,io

      REAL                :: f_ndflag

      CHARACTER(LEN=200)  :: s_directory_root

      CHARACTER(LEN=10)   :: s_date1
      CHARACTER(LEN=10)   :: s_time1
      CHARACTER(LEN=5)    :: s_zone1
      INTEGER             :: i_values1(8)

      CHARACTER(LEN=400)  :: s_export_line
      CHARACTER(LEN=800)  :: s_export_header

      CHARACTER(LEN=10)    :: s_date_single
      CHARACTER(LEN=4)    :: s_year
      CHARACTER(LEN=2)    :: s_month
      CHARACTER(LEN=2)    :: s_day
      CHARACTER(LEN=10)    :: s_time_single
      CHARACTER(LEN=2)    :: s_hour
      CHARACTER(LEN=2)    :: s_minute 
      CHARACTER(LEN=5)    :: s_timezone5

      CHARACTER(LEN=35)   :: s_report_id                 !1
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
      CHARACTER(LEN=8)    :: s_longitude                 !14
      CHARACTER(LEN=8)    :: s_latitude                  !15
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
      CHARACTER(LEN=24)   :: s_record_timestamp          !38   changed from 26 to 24
      CHARACTER(LEN=20)   :: s_history                   !39
      CHARACTER(LEN=1)    :: s_processing_level          !40
      CHARACTER(LEN=2)    :: s_processing_codes          !41
      CHARACTER(LEN=3)    :: s_source_id                 !42
      CHARACTER(LEN=50)   :: s_source_record_id          !43   changed from 4 to 50

      CHARACTER(LEN=28)   :: s_title  
      INTEGER             :: i_reject
      INTEGER             :: i_retain
      INTEGER             :: i_keep

      CHARACTER(LEN=300)  :: s_command
c************************************************************************
      print*,'just inside export_header_day'
 
c     Find date & time
      CALL DATE_AND_TIME(s_date1,s_time1,s_zone1,i_values1)

      print*,'s_date=',s_date1
      print*,'s_time=',s_time1
      print*,'s_zone=',s_zone1

      s_title=s1_basis_wigos//'_header.txt'
      print*,'s_title=',s_title
c       
c     Open file for export
      OPEN(UNIT=1,
     +   FILE=TRIM(s_directory_root)//s_title,
     +   FORM='formatted',
     +   STATUS='NEW',ACTION='WRITE')

c       Enter header here - full length titles
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

c       Initialize counters
        i_reject=0
        i_retain=0

c       Line-stepper for output file
        DO j=1,l_datalines
c*******
c*******
c        1.  Make report_id
         s_date_single=s_vec_date(j)
         s_year =s_date_single(1:4)
         s_month=s_date_single(6:7)
         s_day  =s_date_single(9:10)

         s_timezone5='+0000'

         s_time_single=s_vec_time(j)
         s_hour  =s_time_single(1:2)
         s_minute=s_time_single(4:5)

         s_report_id=s1_basis_wigos//'-'//
     +     s_year//'-'//s_month//'-'//s_day
c*******
c        2.  region
         s_region='6'               !Europe=6, Namer=4 [CDM Table 132]
c*******
c        3.  subregion
         s_subregion='101'           !Ireland=101, Germany=56 [CDM Table150]
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
         s_station_name=TRIM(s1_basis_nameshort)
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
         s_primary_stn_id=s1_basis_wigos
c*******
c        12. station_record_number
         s_stn_record_number='1'
c*******
c        13. primary_station_id_scheme
         s_primary_stn_id_scheme='0'
c*******
c        14. longitude
         s_longitude =ADJUSTL(s1_basis_lon)
c*******
c        15. latitude
         s_latitude  =ADJUSTL(s1_basis_lat)
c*******
c        16. location_accuracy
         s_location_accuracy='0.01'
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
         s_hght_above_sea_level=ADJUSTL(s1_basis_alt_m)
c*******
c        25. hght_stn_accuracy
         s_hght_stn_accuracy='NULL'
c*******
c        26. sea_level_datum
         s_sea_level_datum='NULL'
c*******
c        27. report_meaning_of_time_stamp (1=beginning, 2=end; 3=middle)
         s_meaning_timestamp='1'
c*******
c        28. report_timestamp
         s_report_timestamp=s_year//'-'//s_month//'-'//s_day//' '//
     +     s_vec_time(j)//s_timezone5(1:3)
c*******
c        29. report_duration
         s_report_duration='86400'
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
c        38. record_timestamp
         s_record_timestamp=
     +    s_date1(1:4)//'-'//s_date1(5:6)//'-'//s_date1(7:8)//' '//
     +    s_time1(1:2)//':'//s_time1(3:4)//':'//s_time1(5:6)//
     +    s_zone1(1:3)

c     +    s_zone1(1:5)
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
         s_source_id='158'
c*******
c        43. source_record_id

         s_source_record_id=
     +    TRIM(s_source_id)//'-'//
     +    TRIM(s1_basis_wigos)//'-'//
     +    TRIM(s_report_timestamp)
c*******
         i_keep=0
         IF (f_vec_rain_mm(j).EQ.f_ndflag.AND.
     +       f_vec_maxdy_k(j).EQ.f_ndflag.AND.
     +       f_vec_mindy_k(j).EQ.f_ndflag) THEN
           i_reject=i_reject+1
         ENDIF         
         IF (.NOT.(f_vec_rain_mm(j).EQ.f_ndflag.AND.
     +       f_vec_maxdy_k(j).EQ.f_ndflag.AND.
     +       f_vec_mindy_k(j).EQ.f_ndflag)) THEN
           i_retain=i_retain+1
           i_keep=1
         ENDIF        
c*******
         IF (i_keep.EQ.1) THEN
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

        ENDIF

c*******
      GOTO 111

         print*,'s_report_id='//TRIM(s_report_id)//'xx'
         print*,'s_region='//TRIM(s_region)//'xx'
         print*,'s_subregion='//TRIM(s_subregion)//'xx'
         print*,'s_application_area='//TRIM(s_application_area)//'xx'

         print*,'s_observing_program='//TRIM(s_observing_program)//'xx'
         print*,'s_report_type'//TRIM(s_report_type)//'xx'
         print*,'s_station_name'//TRIM(s_station_name)//'xx'
         print*,'s_station_type'//TRIM(s_station_type)//'xx'

         print*,'s_platform_type'//TRIM(s_platform_type)//'xx'
         print*,'s_platform_subtype'//TRIM(s_platform_subtype)//'xx'
         print*,'s_primary_stn_id'//TRIM(s_primary_stn_id)//'xx'
         print*,'s_stn_record_number'//TRIM(s_stn_record_number)//'xx'

         print*,'s_primary_stn_id_scheme'//
     +        TRIM(s_primary_stn_id_scheme)//'xx'
         print*,'s_longitude'//TRIM(s_longitude)//'xx'
         print*,'s_latitude'//TRIM(s_latitude)//'xx'
         print*,'s_location_accuracy'//TRIM(s_location_accuracy)//'xx'

         print*,'s_location_method'//TRIM(s_location_method)//'xx'
         print*,'s_location_quality'//TRIM(s_location_quality)//'xx'
         print*,'s_crs'//TRIM(s_crs)//'xx'
         print*,'s_station_speed'//TRIM(s_station_speed)//'xx'

         print*,'s_station_course'//TRIM(s_station_course)//'xx'
         print*,'s_station_heading'//TRIM(s_station_heading)//'xx'
         print*,'s_hght_above_grd'//TRIM(s_hght_above_grd)//'xx'
         print*,'s_hght_above_sea_level'//
     +       TRIM(s_hght_above_sea_level)//'xx'

         print*,'s_hght_stn_accuracy'//TRIM(s_hght_stn_accuracy)//'xx'
         print*,'s_sea_level_datum'//TRIM(s_sea_level_datum)//'xx'
         print*,'s_meaning_timestamp'//TRIM(s_meaning_timestamp)//'xx'
         print*,'s_report_timestamp'//TRIM(s_report_timestamp)//'xx'

         print*,'s_report_duration'//TRIM(s_report_duration)//'xx'
         print*,'s_report_time_accuracy'//
     +        TRIM(s_report_time_accuracy)//'xx'
         print*,'s_report_time_quality'//
     +        TRIM(s_report_time_quality)//'xx'
         print*,'s_report_time_ref'//TRIM(s_report_time_ref)//'xx'

         print*,'s_profile_id'//TRIM(s_profile_id)//'xx'
         print*,'s_events_at_station'//TRIM(s_events_at_station)//'xx'
         print*,'s_report_quality'//TRIM(s_report_quality)//'xx'
         print*,'s_duplicate_status'//TRIM(s_duplicate_status)//'xx'

         print*,'s_duplicates'//TRIM(s_duplicates)//'xx'
         print*,'s_record_timestamp'//TRIM(s_record_timestamp)//'xx'
         print*,'s_history'//TRIM(s_history)//'xx'
         print*,'s_processing_level'//TRIM(s_processing_level)//'xx'

         print*,'s_processing_codes'//TRIM(s_processing_codes)//'xx'
         print*,'s_source_id'//TRIM(s_source_id)//'xx'
         print*,'s_source_record_id'//TRIM(s_source_record_id)//'xx'

c         CALL SLEEP(2)
111     CONTINUE
c*******
        ENDDO

      CLOSE(UNIT=1)

c     Compress data file; placed immediately after file close
      s_command=TRIM('gzip -qq '//TRIM(s_directory_root)//TRIM(s_title))
      CALL SYSTEM(s_command,io)
c*******

      print*,'i_reject,i_retain=',i_reject,i_retain
c************************************************************************
      print*,'just leaving export_header_day'

      RETURN
      END