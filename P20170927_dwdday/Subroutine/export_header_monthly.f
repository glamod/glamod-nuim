c     Subroutine to create monthly header file
c     AJ_Kettle, Dec2/2017

      SUBROUTINE export_header_monthly(s_directory_root,
     +   s_stnnum_single,
     +   l_sd_stnrecord,s_sd_stke,s_sd_stid,s_sd_wigos_full,
     +   l_monrec_common,
     +   s_monrec_common_month,s_monrec_common_year,
     +   f_monrec_common_nseconds,
     +   s_monrec_common_stime,s_monrec_common_timezone5,
     +   s_last_hgt_m,s_last_lat_deg,s_last_lon_deg,s_last_stnname)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into subroutine
      CHARACTER(LEN=200)  :: s_directory_root

      CHARACTER(LEN=5)    :: s_stnnum_single

      INTEGER             :: l_sd_stnrecord
      CHARACTER(LEN=5)    :: s_sd_stke(100)
      CHARACTER(LEN=5)    :: s_sd_stid(100)
      CHARACTER(LEN=17)   :: s_sd_wigos_full(100)

      INTEGER             :: l_monrec_common
      CHARACTER(LEN=2)    :: s_monrec_common_month(5000)
      CHARACTER(LEN=4)    :: s_monrec_common_year(5000)
      REAL                :: f_monrec_common_nseconds(5000)
      CHARACTER(LEN=8)    :: s_monrec_common_stime(5000)
      CHARACTER(LEN=5)    :: s_monrec_common_timezone5(5000)

      CHARACTER(LEN=8)    :: s_last_hgt_m
      CHARACTER(LEN=8)    :: s_last_lat_deg
      CHARACTER(LEN=8)    :: s_last_lon_deg
      CHARACTER(LEN=50)   :: s_last_stnname

c     Variables used in subroutine
      CHARACTER(LEN=8)    :: s_date1
      CHARACTER(LEN=10)   :: s_time1
      CHARACTER(LEN=5)    :: s_zone1
      INTEGER             :: i_values1(8)

      CHARACTER(LEN=28)   :: s_title            !changed from 24 to 28 for .txt extension
c      CHARACTER(LEN=8)    :: s_date_single
      CHARACTER(LEN=4)    :: s_year
      CHARACTER(LEN=2)    :: s_month
      CHARACTER(LEN=2)    :: s_day
      CHARACTER(LEN=8)    :: s_time_single
      CHARACTER(LEN=2)    :: s_hour
      CHARACTER(LEN=2)    :: s_minute
      CHARACTER(LEN=2)    :: s_second
      CHARACTER(LEN=5)    :: s_timezone5

      CHARACTER(LEN=32)   :: s_report_id                 !1
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
      CHARACTER(LEN=24)   :: s_record_timestamp          !38
      CHARACTER(LEN=20)   :: s_history                   !39
      CHARACTER(LEN=1)    :: s_processing_level          !40
      CHARACTER(LEN=2)    :: s_processing_codes          !41
      CHARACTER(LEN=3)    :: s_source_id                 !42
      CHARACTER(LEN=50)   :: s_source_record_id          !43 changed from 4 to 50

      CHARACTER(LEN=400)  :: s_export_line
      CHARACTER(LEN=800)  :: s_export_header

      REAL                :: f_test
      INTEGER             :: i_test
      CHARACTER(LEN=8)    :: s_test8

      INTEGER             :: i,j,k,ii,jj,kk,io

      CHARACTER(LEN=300)  :: s_command
c************************************************************************
      print*,'just entered export_header_monthly'

c      print*,'stime=',   (s_monrec_common_stime(j),j=1,4)
c      print*,'timezone=',(s_monrec_common_timezone(j),j=1,4)
c      CALL SLEEP(5)

c     Find date & time
      CALL DATE_AND_TIME(s_date1,s_time1,s_zone1,i_values1)

      print*,'s_date=',s_date1
      print*,'s_time=',s_time1
      print*,'s_zone=',s_zone1

      print*,'l_sd_stnrecord=',l_sd_stnrecord
      print*,'s_stnnum_single=',s_stnnum_single
c      print*,'s_sd_stid=',(s_sd_stid(i),i=1,5)
c      print*,'s_sd_wigos_full=',(s_sd_wigos_full(i),i=1,5)

c     Test to see if match with subday list
      DO i=1,l_sd_stnrecord
       IF (s_sd_stid(i).EQ.s_stnnum_single) THEN

        print*,'match identified'

        s_title=s_sd_wigos_full(i)//'_header.txt'

        print*,'s_directory_root=',TRIM(s_directory_root)
        print*,'s_title=',s_title

c       Open file for export
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

c         s_export_header=
c     + TRIM('report_id')//'|'//TRIM('region')//'|'//
c     + TRIM('subregion')//'|'//TRIM('application_area')//'|'//
c     + TRIM('observing_program')//'|'//TRIM('report_type')//'|'//
c     + TRIM('station_name')//'|'//TRIM('station_type')//'|'//
c     + TRIM('platform_type')//'|'//TRIM('platform_subtype')//'|'//
c     + TRIM('primary_stn_id')//'|'//TRIM('stn_record_number')//'|'//
c     + TRIM('primary_stn_id_scheme')//'|'//TRIM('longitude')//'|'//
c     + TRIM('latitude')//'|'//TRIM('location_accuracy')//'|'//
c     + TRIM('location_method')//'|'//TRIM('location_quality')//'|'//
c     + TRIM('crs')//'|'//TRIM('station_speed')//'|'//
c     + TRIM('station_course')//'|'//TRIM('station_heading')//'|'//
c     + TRIM('hght_above_grd')//'|'//TRIM('hght_above_sea_level')//'|'//
c     + TRIM('hght_stn_accuracy')//'|'//TRIM('sea_level_datum')//'|'//
c     + TRIM('meaning_timestamp')//'|'//TRIM('report_timestamp')//'|'//
c     + TRIM('report_duration')//'|'//TRIM('report_time_accuracy')//'|'//
c     + TRIM('report_time_quality')//'|'//TRIM('report_time_ref')//'|'//
c     + TRIM('profile_id')//'|'//TRIM('events_at_station')//'|'//
c     + TRIM('report_quality')//'|'//TRIM('duplicate_status')//'|'//
c     + TRIM('duplicates')//'|'//TRIM('record_timestamp')//'|'//
c     + TRIM('history')//'|'//TRIM('processing_level')//'|'//
c     + TRIM('processing_codes')//'|'//TRIM('source_id')//'|'//
c     + TRIM('source_record_id')

c         s_export_header=
c     + TRIM('report_id')//';'//TRIM('region')//';'//
c     + TRIM('subregion')//';'//TRIM('application_area')//';'//
c     + TRIM('observing_program')//';'//TRIM('report_type')//';'//
c     + TRIM('station_name')//';'//TRIM('station_type')//';'//
c     + TRIM('platform_type')//';'//TRIM('platform_subtype')//';'//
c     + TRIM('primary_stn_id')//';'//TRIM('stn_record_number')//';'//
c     + TRIM('primary_stn_id_scheme')//';'//TRIM('longitude')//';'//
c     + TRIM('latitude')//';'//TRIM('location_accuracy')//';'//
c     + TRIM('location_method')//';'//TRIM('location_quality')//';'//
c     + TRIM('crs')//';'//TRIM('station_speed')//';'//
c     + TRIM('station_course')//';'//TRIM('station_heading')//';'//
c     + TRIM('hght_above_grd')//';'//TRIM('hght_above_sea_level')//';'//
c     + TRIM('hght_stn_accuracy')//';'//TRIM('sea_level_datum')//';'//
c     + TRIM('meaning_timestamp')//';'//TRIM('report_timestamp')//';'//
c     + TRIM('report_duration')//';'//TRIM('report_time_accuracy')//';'//
c     + TRIM('report_time_quality')//';'//TRIM('report_time_ref')//';'//
c     + TRIM('profile_id')//';'//TRIM('events_at_station')//';'//
c     + TRIM('report_quality')//';'//TRIM('duplicate_status')//';'//
c     + TRIM('duplicates')//';'//TRIM('record_timestamp')//';'//
c     + TRIM('history')//';'//TRIM('processing_level')//';'//
c     + TRIM('processing_codes')//';'//TRIM('source_id')//';'//
c     + TRIM('source_record_id')

         WRITE(UNIT=1,FMT=3011) ADJUSTL(s_export_header)
3011     FORMAT(a800)

c       Line-stepper for output file
        DO j=1,l_monrec_common
c*******
c        1.  Make report_id
c         s_date_single=s_day_date(j)
         s_year =s_monrec_common_year(j)
         s_month=s_monrec_common_month(j)
         s_day  ='01'                      !hardwire date for month

         s_time_single=s_monrec_common_stime(j)
         s_hour  =s_time_single(1:2)
         s_minute=s_time_single(4:5)
         s_second=s_time_single(7:8)

         s_timezone5=s_monrec_common_timezone5(j)

         s_report_id=s_sd_wigos_full(i)//'-'//
     +     s_year//'-'//s_month
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
         s_station_name=s_last_stnname
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
         s_primary_stn_id=s_sd_wigos_full(i)
c*******
c        12. station_record_number
         s_stn_record_number='1'
c*******
c        13. primary_station_id_scheme
         s_primary_stn_id_scheme='0'
c*******
c        14. longitude
         s_longitude =ADJUSTL(s_last_lon_deg)
c*******
c        15. latitude
         s_latitude  =ADJUSTL(s_last_lat_deg)
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
         s_hght_above_sea_level=ADJUSTL(s_last_hgt_m)
c*******
c        25. hght_stn_accuracy
         s_hght_stn_accuracy='NULL'
c*******
c        26. sea_level_datum
         s_sea_level_datum='NULL'
c*******
c        27. report_meaning_of_time_stamp
         s_meaning_timestamp='1'
c*******
c        28. report_timestamp (11+11=22)
         s_report_timestamp=s_year//'-'//s_month//'-'//s_day//' '//
     +     s_hour//':'//s_minute//':'//s_second//
     +     s_timezone5(1:3)
c*******
c        29. report_duration

c        Convert report duration from float to string
         i_test=NINT(f_monrec_common_nseconds(j))
         WRITE(s_test8,'(i8)') i_test
         s_report_duration=ADJUSTL(s_test8)
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
c        38. record_timestamp  (11+13=24)
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
c         s_source_record_id='NULL'

         s_source_record_id=
     +    TRIM(s_source_id)//'-'//
     +    TRIM(s_sd_wigos_full(i))//'-'//
     +    TRIM(s_report_timestamp)
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

c     Semi-colon separators
c         s_export_line=
c     + TRIM(s_report_id)//';'//TRIM(s_region)//';'//
c     + TRIM(s_subregion)//';'//TRIM(s_application_area)//';'//
c     + TRIM(s_observing_program)//';'//TRIM(s_report_type)//';'//
c     + TRIM(s_station_name)//';'//TRIM(s_station_type)//';'//
c     + TRIM(s_platform_type)//';'//TRIM(s_platform_subtype)//';'//
c     + TRIM(s_primary_stn_id)//';'//TRIM(s_stn_record_number)//';'//
c     + TRIM(s_primary_stn_id_scheme)//';'//TRIM(s_longitude)//';'//
c     + TRIM(s_latitude)//';'//TRIM(s_location_accuracy)//';'//
c     + TRIM(s_location_method)//';'//TRIM(s_location_quality)//';'//
c     + TRIM(s_crs)//';'//TRIM(s_station_speed)//';'//
c     + TRIM(s_station_course)//';'//TRIM(s_station_heading)//';'//
c     + TRIM(s_hght_above_grd)//';'//TRIM(s_hght_above_sea_level)//';'//
c     + TRIM(s_hght_stn_accuracy)//';'//TRIM(s_sea_level_datum)//';'//
c     + TRIM(s_meaning_timestamp)//';'//TRIM(s_report_timestamp)//';'//
c     + TRIM(s_report_duration)//';'//TRIM(s_report_time_accuracy)//';'//
c     + TRIM(s_report_time_quality)//';'//TRIM(s_report_time_ref)//';'//
c     + TRIM(s_profile_id)//';'//TRIM(s_events_at_station)//';'//
c     + TRIM(s_report_quality)//';'//TRIM(s_duplicate_status)//';'//
c     + TRIM(s_duplicates)//';'//TRIM(s_record_timestamp)//';'//
c     + TRIM(s_history)//';'//TRIM(s_processing_level)//';'//
c     + TRIM(s_processing_codes)//';'//TRIM(s_source_id)//';'//
c     + TRIM(s_source_record_id)

         WRITE(UNIT=1,FMT=3009) ADJUSTL(s_export_line)
3009     FORMAT(a400)
c*******
c        Screen output results
c         print*,'s_report_timestampxx'//TRIM(s_report_timestamp)//'xx'
c         print*,'s_record_timestampxx'//TRIM(s_record_timestamp)//'xx'

c         print*,'s_time_single='//s_time_single//'xx'
c         print*,'s_hour=',s_hour  
c         print*,'s_minute=',s_minute
c         print*,'s_monrec_common_stime',s_monrec_common_stime(i)
c         print*,'s_monrec_common_timezone5',s_monrec_common_timezone5(i)

c         CALL SLEEP(2)
c*******
        ENDDO                !close index j

        CLOSE(UNIT=1) 

c*******
c     Compress data file; placed immediately after file close
      s_command=TRIM('gzip -qq '//TRIM(s_directory_root)//TRIM(s_title))
      CALL SYSTEM(s_command,io)
c*******
cc        CALL SLEEP(5)
        GOTO 10
       ENDIF
      ENDDO                  !close index i

10    CONTINUE
c************************************************************************

c************************************************************************
      print*,'just leaving export_header_monthly'
   
      RETURN
      END