c     Subroutine to extract stnconfig subset variables
c     AJ_Kettle, 04Dec2019

      SUBROUTINE get_singles_stnconfig_qff2(i_flag,s_stnname_single,
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

      INTEGER             :: i_flag            !flag if station not found in list
      CHARACTER(LEN=300)  :: s_stnname_single
c*****
c     Stnconfig information
      INTEGER             :: l_scoutput_rgh
      INTEGER             :: l_scoutput
      INTEGER             :: ilen
      INTEGER             :: l_scoutput_numfield
       
      CHARACTER(LEN=ilen) :: s_scoutput_vec_header(50)               
      CHARACTER(LEN=ilen) :: s_scoutput_mat_fields(l_scoutput_rgh,50)

      INTEGER             :: l_cc_rgh
      INTEGER             :: l_collect_cnt

c     Variables originally from stnconfig-read
      CHARACTER(LEN=*) :: s_collect_primary_id(l_cc_rgh)
      CHARACTER(LEN=ilen) :: s_collect_record_number(l_cc_rgh)
      CHARACTER(LEN=ilen) :: s_collect_secondary_id(l_cc_rgh)
      CHARACTER(LEN=ilen) :: s_collect_station_name(l_cc_rgh)
      CHARACTER(LEN=ilen) :: s_collect_longitude(l_cc_rgh)
      CHARACTER(LEN=ilen) :: s_collect_latitude(l_cc_rgh)
      CHARACTER(LEN=ilen) ::
     +   s_collect_height_station_above_sea_level(l_cc_rgh)
      CHARACTER(LEN=ilen) :: s_collect_data_policy_licence(l_cc_rgh)
      CHARACTER(LEN=ilen) :: s_collect_source_id(l_cc_rgh)

c     Variables originally from stnconfig-write
      CHARACTER(LEN=ilen) :: s_collect_region(l_cc_rgh)
      CHARACTER(LEN=ilen) :: s_collect_operating_territory(l_cc_rgh)
      CHARACTER(LEN=ilen) :: s_collect_station_type(l_cc_rgh)
      CHARACTER(LEN=ilen) :: s_collect_platform_type(l_cc_rgh)
      CHARACTER(LEN=ilen) :: s_collect_platform_sub_type(l_cc_rgh)
      CHARACTER(LEN=ilen) :: 
     +   s_collect_primary_station_id_scheme(l_cc_rgh)
      CHARACTER(LEN=ilen) :: s_collect_location_accuracy(l_cc_rgh)
      CHARACTER(LEN=ilen) :: s_collect_location_method(l_cc_rgh)
      CHARACTER(LEN=ilen) :: s_collect_location_quality(l_cc_rgh)
      CHARACTER(LEN=ilen) :: s_collect_station_crs(l_cc_rgh)
      CHARACTER(LEN=ilen) :: 
     +   s_collect_height_station_above_local_ground(l_cc_rgh)
      CHARACTER(LEN=ilen) ::
     +   s_collect_height_station_above_sea_level_acc(l_cc_rgh)
      CHARACTER(LEN=ilen) :: s_collect_sea_level_datum(l_cc_rgh)

      CHARACTER(LEN=ilen) :: s_collect_datalines(l_cc_rgh,50)

      INTEGER             :: l_collect_distinct
      CHARACTER(LEN=1)    :: s_collect_flagambig(l_cc_rgh)
c*****
c*****
c     Variables used in subroutine

      INTEGER             :: i,j,k,ii,jj,kk
c*****
c     22 headers important for CDM files
      INTEGER             :: l_ext_header
      CHARACTER(LEN=ilen) :: s_ext_header(22)
      INTEGER             :: i_ext(22)
c*****
      CHARACTER(LEN=ilen) :: s_scoutput_vec_data(50) !single line stnconfig data
c*****
c     original singles starting from read file
      CHARACTER(LEN=ilen) :: s_single_primary_id     !20
      CHARACTER(LEN=ilen) :: s_single_record_number  !2
      CHARACTER(LEN=ilen) :: s_single_secondary_id   !20
      CHARACTER(LEN=ilen) :: s_single_station_name   !50
      CHARACTER(LEN=ilen) :: s_single_longitude      !10
      CHARACTER(LEN=ilen) :: s_single_latitude       !10
      CHARACTER(LEN=ilen) :: s_single_height_station_above_sea_level    !10
      CHARACTER(LEN=ilen) :: s_single_data_policy_licence !1
      CHARACTER(LEN=ilen) :: s_single_source_id      !3

c     extended singles starting from write file
      CHARACTER(LEN=ilen) :: s_single_region
      CHARACTER(LEN=ilen) :: s_single_operating_territory
      CHARACTER(LEN=ilen) :: s_single_station_type
      CHARACTER(LEN=ilen) :: s_single_platform_type
      CHARACTER(LEN=ilen) :: s_single_platform_sub_type
      CHARACTER(LEN=ilen) :: s_single_primary_station_id_scheme
      CHARACTER(LEN=ilen) :: s_single_location_accuracy
      CHARACTER(LEN=ilen) :: s_single_location_method
      CHARACTER(LEN=ilen) :: s_single_location_quality
      CHARACTER(LEN=ilen) :: s_single_station_crs
      CHARACTER(LEN=ilen) :: 
     +  s_single_height_station_above_local_ground
      CHARACTER(LEN=ilen) :: 
     +  s_single_height_station_above_sea_level_accuracy
      CHARACTER(LEN=ilen) :: s_single_sea_level_datum

c************************************************************************
c      print*,'just entered get_singles_stnconfig_qff2'

c      print*,'l_scoutput_numfield=',l_scoutput_numfield
c      print*,'ilen=',ilen
c*****
c     Automatic process to ind columns of extractor variables

      l_ext_header   =22
      s_ext_header(1)= 'primary_id'
      s_ext_header(2)= 'record_number'
      s_ext_header(3)= 'secondary_id'
      s_ext_header(4)= 'station_name'
      s_ext_header(5)= 'longitude'
      s_ext_header(6)= 'latitude'
      s_ext_header(7)= 'height_of_station_above_sea_level'
      s_ext_header(8)= 'data_policy_licence'
      s_ext_header(9)= 'source_id'
      s_ext_header(10)='region'
      s_ext_header(11)='operating_territory'
      s_ext_header(12)='station_type'
      s_ext_header(13)='platform_type'
      s_ext_header(14)='platform_sub_type'
      s_ext_header(15)='primary_id_scheme'
      s_ext_header(16)='location_accuracy'
      s_ext_header(17)='location_method'
      s_ext_header(18)='location_quality'
      s_ext_header(19)='station_crs'
      s_ext_header(20)='height_of_station_above_local_ground'
      s_ext_header(21)='height_of_station_above_sea_level_accuracy'
      s_ext_header(22)='sea_level_datum'

c      DO i=1,l_scoutput_numfield
c       print*,'i=',i,TRIM(s_scoutput_vec_header(i))
c      ENDDO
c      DO j=1,l_ext_header
c       print*,'j=',j,TRIM(s_ext_header(j))
c      ENDDO

      DO j=1,l_ext_header
       DO i=1,l_scoutput_numfield
       IF (TRIM(s_scoutput_vec_header(i)).EQ.TRIM(s_ext_header(j))) THEN 
         i_ext(j)=i
         GOTO 81
       ENDIF
       ENDDO

c      if here then problem matching title
       print*,'j',j,'='//TRIM(s_ext_header(j))//'='
       STOP 'get_singles_stnconfig_qff2; problem match'

 81    CONTINUE
      ENDDO

c      DO i=1,l_ext_header
c       print*,'i_ext=',i,i_ext(i)
c      ENDDO
c*****
c*****
c*****
c      print*,'s_scoutput_mat_fields=',
c     +  (TRIM(s_scoutput_mat_fields(i,1)),i=1,5)
c      print*,'l_scoutput=',l_scoutput
c      print*,'l_scoutput_numfield=',l_scoutput_numfield
c      print*,'s_stnname_single=',TRIM(s_stnname_single)

      i_flag=0   !initialize problem flag to 0/good

      ii=0       !counter for different record number
c     
      DO i=1,l_scoutput

c      Note there will be multiple records for same station name
       IF (TRIM(s_scoutput_mat_fields(i,1)).EQ.TRIM(s_stnname_single))
     +     THEN 

        print*,'i test',i,
     +    TRIM(s_scoutput_mat_fields(i,1))//'='//
     +    TRIM(s_scoutput_mat_fields(i,2))//'='//
     +    TRIM(s_scoutput_mat_fields(i,4))//'='//
     +    TRIM(s_scoutput_mat_fields(i,45))//'='//
     +    TRIM(s_scoutput_mat_fields(i,49))//'='

c       Extract all fields from line
        DO j=1,l_scoutput_numfield 
         s_scoutput_vec_data(j)=s_scoutput_mat_fields(i,j)
        ENDDO

c       extract variables by index along data lie
        s_single_primary_id              =s_scoutput_vec_data(i_ext(1)) !(1)
        s_single_record_number           =s_scoutput_vec_data(i_ext(2)) !(3)
        s_single_secondary_id            =s_scoutput_vec_data(i_ext(3)) !(4)
        s_single_station_name            =s_scoutput_vec_data(i_ext(4)) !(5)  !v2=6
        s_single_longitude               =s_scoutput_vec_data(i_ext(5)) !(6)  !v2=10
        s_single_latitude                =s_scoutput_vec_data(i_ext(6)) !(7)  !v2=11
        s_single_height_station_above_sea_level
     +                                   =s_scoutput_vec_data(i_ext(7)) !(45)
        s_single_data_policy_licence     =s_scoutput_vec_data(i_ext(8)) !(39)
        s_single_source_id               =s_scoutput_vec_data(i_ext(9)) !(48)

c       Variables from stnconfig-write
        s_single_region                  =s_scoutput_vec_data(i_ext(10)) !(38)
        s_single_operating_territory     =s_scoutput_vec_data(i_ext(11)) !(19)
        s_single_station_type            =s_scoutput_vec_data(i_ext(12)) !(15)
        s_single_platform_type           =s_scoutput_vec_data(i_ext(13)) !(16)
        s_single_platform_sub_type       =s_scoutput_vec_data(i_ext(14)) !(17)
        s_single_primary_station_id_scheme
     +                                   =s_scoutput_vec_data(i_ext(15)) !(2)
        s_single_location_accuracy       =s_scoutput_vec_data(i_ext(16)) !(41)
        s_single_location_method         =s_scoutput_vec_data(i_ext(17)) !(42)
        s_single_location_quality        =s_scoutput_vec_data(i_ext(18)) !(43)
        s_single_station_crs             =s_scoutput_vec_data(i_ext(19)) !(11) !v2=9
        s_single_height_station_above_local_ground
     +                                   =s_scoutput_vec_data(i_ext(20)) !(44)
        s_single_height_station_above_sea_level_accuracy
     +                                   =s_scoutput_vec_data(i_ext(21)) !(46)
        s_single_sea_level_datum         =s_scoutput_vec_data(i_ext(22)) !(47)

        ii=ii+1                   !increment counter for primary_id 

        IF (ii.GE.l_cc_rgh) THEN 
         print*,'ii collecting variable over limit',ii,l_cc_rgh
         STOP 'get_singles_stnconfig_qff'
        ENDIF

c       Collect variables together
c       from stnconfig_read
        s_collect_primary_id(ii)    =s_single_primary_id
        s_collect_record_number(ii) =s_single_record_number
        s_collect_secondary_id(ii)  =s_single_secondary_id
        s_collect_station_name(ii)  =s_single_station_name
        s_collect_longitude(ii)     =s_single_longitude
        s_collect_latitude(ii)      =s_single_latitude
        s_collect_height_station_above_sea_level(ii)   
     +                      =s_single_height_station_above_sea_level
        s_collect_data_policy_licence(ii)=s_single_data_policy_licence
        s_collect_source_id(ii)     =s_single_source_id

c       from stnconfig_write
        s_collect_region(ii)        =s_single_region
        s_collect_operating_territory(ii)=s_single_operating_territory
        s_collect_station_type(ii)  =s_single_station_type
        s_collect_platform_type(ii) =s_single_platform_type
        s_collect_platform_sub_type(ii)=s_single_platform_sub_type
        s_collect_primary_station_id_scheme(ii)
     +                              =s_single_primary_station_id_scheme
        s_collect_location_accuracy(ii)=s_single_location_accuracy
        s_collect_location_method(ii)=s_single_location_method
        s_collect_location_quality(ii)=s_single_location_quality
        s_collect_station_crs(ii)   =s_single_station_crs
        s_collect_height_station_above_local_ground(ii)
     +         =s_single_height_station_above_local_ground
        s_collect_height_station_above_sea_level_acc(ii)
     +         =s_single_height_station_above_sea_level_accuracy
        s_collect_sea_level_datum   =s_single_sea_level_datum

c       Archive subset of station configuration lines
        DO j=1,l_scoutput_numfield 
         s_collect_datalines(ii,j)=s_scoutput_vec_data(j)
        ENDDO

       ENDIF
      ENDDO

      l_collect_cnt=ii  !value can be >1 if there are a number of reporttypes

c     Crash condition; no match for station
      IF (l_collect_cnt.EQ.0) THEN
       i_flag=1      !flag name in file list as bad

       print*,'stnname not found in stnconfig list'
       print*,'s_stnname_single=',TRIM(s_stnname_single)
c       STOP 'get_singles_stnconfig_qff'

       GOTO 10
      ENDIF

c      IF (l_collect_cnt.GT.0) THEN
c       print*,'station found' 
c       print*,'l_collect_cnt=',l_collect_cnt
c       STOP 'get_singles_stnconfig2'
c      ENDIF
c************************************************************************

      DO i=1,l_collect_cnt
       print*,'i=',i,
     +   TRIM(s_collect_primary_id(i))//'='//
     +   TRIM(s_collect_record_number(i))//'='//
     +   TRIM(s_collect_height_station_above_sea_level_acc(i))//'='//
     +   TRIM(s_collect_sea_level_datum(i))//'='//
     +   TRIM(s_collect_source_id(i))//'='
      ENDDO     
c************************************************************************
 10   CONTINUE

      print*,'l_collect_cnt=',l_collect_cnt

c      print*,'lon=',(s_collect_longitude(i),i=1,l_collect_cnt)
c      print*,'lat=',(s_collect_latitude(i),i=1,l_collect_cnt)

c      print*,'just leaving get_singles_stnconfig_qff2'

      STOP 'get_singles_stnconfig_qff2'      

      RETURN
      END
