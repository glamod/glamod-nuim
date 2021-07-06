c     Subroutine to get station configuration information
c     AJ_Kettle, 07May2019
c     10Jun2019: modified to get information from stnconfig_write file
c                use * to take string length info from calling program
c     28Nov2019: modified to account for column scramble in version4
c     13Apr2020: modified for 01May2020 release

      SUBROUTINE get_singles_stnconfig_v5(i_flag,s_stnname_single,
     +  l_scoutput_rgh,l_scoutput,l_scfield,l_scoutput_numfield,
     +  s_scoutput_vec_header,s_scoutput_mat_fields,

     +  l_collect_cnt,
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

     +  s_collect_datalines,

     +  l_collect_distinct,
     +  s_collect_flagambig)

      IMPLICIT NONE
c************************************************************************
c     Declare variables 
 
      INTEGER             :: i_flag
      CHARACTER(LEN=12)   :: s_stnname_single

      INTEGER             :: l_scoutput_rgh
      INTEGER             :: l_scoutput
      INTEGER             :: l_scfield
      INTEGER             :: l_scoutput_numfield
      CHARACTER(LEN=*)    :: s_scoutput_vec_header(50)                !50
      CHARACTER(LEN=*)    :: s_scoutput_mat_fields(l_scoutput_rgh,50) !50

      INTEGER             :: l_collect_cnt
c     Variables originally from stnconfig-read
      CHARACTER(LEN=*)    :: s_collect_primary_id(20)                !20
      CHARACTER(LEN=*)    :: s_collect_record_number(20)             !2
      CHARACTER(LEN=*)    :: s_collect_secondary_id(20)              !20
      CHARACTER(LEN=*)    :: s_collect_station_name(20)              !50
      CHARACTER(LEN=*)    :: s_collect_longitude(20)                 !10
      CHARACTER(LEN=*)    :: s_collect_latitude(20)                  !10
      CHARACTER(LEN=*)    ::s_collect_height_station_above_sea_level(20)   !10
      CHARACTER(LEN=*)    :: s_collect_data_policy_licence(20)            !1
      CHARACTER(LEN=*)    :: s_collect_source_id(20)                 !3

c     Variables originally from stnconfig-write
      CHARACTER(LEN=*)    :: s_collect_region(20)
      CHARACTER(LEN=*)    :: s_collect_operating_territory(20)
      CHARACTER(LEN=*)    :: s_collect_station_type(20)
      CHARACTER(LEN=*)    :: s_collect_platform_type(20)
      CHARACTER(LEN=*)    :: s_collect_platform_sub_type(20)
      CHARACTER(LEN=*)    :: s_collect_primary_station_id_scheme(20)
      CHARACTER(LEN=*)    :: s_collect_location_accuracy(20)
      CHARACTER(LEN=*)    :: s_collect_location_method(20)
      CHARACTER(LEN=*)    :: s_collect_location_quality(20)
      CHARACTER(LEN=*)    :: s_collect_station_crs(20)
      CHARACTER(LEN=*)::s_collect_height_station_above_local_ground(20)
      CHARACTER(LEN=*)::s_collect_height_station_above_sea_level_acc(20)
      CHARACTER(LEN=*)    :: s_collect_sea_level_datum(20)

      CHARACTER(LEN=*)    :: s_collect_datalines(20,50)

      INTEGER             :: l_collect_distinct
      CHARACTER(LEN=1)    :: s_collect_flagambig(20)
c*****
c     Variables used within program

      INTEGER             :: i,j,k,ii,jj,kk

c     original singles starting from read file
      CHARACTER(LEN=l_scfield) :: s_single_primary_id     !20
      CHARACTER(LEN=l_scfield) :: s_single_record_number  !2
      CHARACTER(LEN=l_scfield) :: s_single_secondary_id   !20
      CHARACTER(LEN=l_scfield) :: s_single_station_name   !50
      CHARACTER(LEN=l_scfield) :: s_single_longitude      !10
      CHARACTER(LEN=l_scfield) :: s_single_latitude       !10
      CHARACTER(LEN=l_scfield) ::s_single_height_station_above_sea_level    !10
      CHARACTER(LEN=l_scfield) :: s_single_data_policy_licence !1
      CHARACTER(LEN=l_scfield) :: s_single_source_id      !3

c     extended singles starting from write file
      CHARACTER(LEN=l_scfield) :: s_single_region
      CHARACTER(LEN=l_scfield) :: s_single_operating_territory
      CHARACTER(LEN=l_scfield) :: s_single_station_type
      CHARACTER(LEN=l_scfield) :: s_single_platform_type
      CHARACTER(LEN=l_scfield) :: s_single_platform_sub_type
      CHARACTER(LEN=l_scfield) :: s_single_primary_station_id_scheme
      CHARACTER(LEN=l_scfield) :: s_single_location_accuracy
      CHARACTER(LEN=l_scfield) :: s_single_location_method
      CHARACTER(LEN=l_scfield) :: s_single_location_quality
      CHARACTER(LEN=l_scfield) :: s_single_station_crs
      CHARACTER(LEN=l_scfield) :: 
     +  s_single_height_station_above_local_ground
      CHARACTER(LEN=l_scfield) :: 
     +  s_single_height_station_above_sea_level_accuracy
      CHARACTER(LEN=l_scfield) :: s_single_sea_level_datum

      CHARACTER(LEN=l_scfield) :: s_scoutput_vec_data(50) !single line stnconfig data

      CHARACTER(LEN=3)    :: s_distinct_source_id(20)
      INTEGER             :: i_distinct_cnt(20)
c*****
      INTEGER             :: i_primary_id
      INTEGER             :: i_record_number
      INTEGER             :: i_secondary_id
      INTEGER             :: i_station_name
      INTEGER             :: i_longitude
      INTEGER             :: i_latitude
      INTEGER             :: i_height_of_station_above_sea_level
      INTEGER             :: i_data_policy_licence
      INTEGER             :: i_source_id
      INTEGER             :: i_region
      INTEGER             :: i_operating_territory
      INTEGER             :: i_station_type
      INTEGER             :: i_platform_type
      INTEGER             :: i_platform_sub_type
      INTEGER             :: i_primary_station_id_scheme
      INTEGER             :: i_location_accuracy
      INTEGER             :: i_location_method
      INTEGER             :: i_location_quality
      INTEGER             :: i_station_crs
      INTEGER             :: i_height_of_station_above_local_ground
      INTEGER             ::i_height_of_station_above_sea_level_accuracy
      INTEGER             :: i_sea_level_datum
c******

c************************************************************************
c      print*,'just entered get_singles_stnconfig_v5'

      i_flag=0    !initialize bad flag to 0

c      DO i=1,l_scoutput_numfield
c       print*,'s_scoutput_vec_header=',i,TRIM(s_scoutput_vec_header(i))
c      ENDDO

c      print*,'l_scfield=',l_scfield
c      STOP 'get_singles_stnconfig_v5'

c     Write out column headers
      DO i=1,l_scoutput_numfield
c       print*,i,s_scoutput_vec_header(i)

       IF (TRIM(s_scoutput_vec_header(i)).EQ.'primary_id') THEN 
        i_primary_id=i
        GOTO 5
       ENDIF
       IF (TRIM(s_scoutput_vec_header(i)).EQ.'record_number') THEN
        i_record_number=i 
        GOTO 5
       ENDIF
       IF (TRIM(s_scoutput_vec_header(i)).EQ.'secondary_id') THEN 
        i_secondary_id=i
        GOTO 5
       ENDIF
       IF (TRIM(s_scoutput_vec_header(i)).EQ.'station_name') THEN 
        i_station_name=i
        GOTO 5
       ENDIF
       IF (TRIM(s_scoutput_vec_header(i)).EQ.'longitude') THEN 
        i_longitude=i
        GOTO 5
       ENDIF
       IF (TRIM(s_scoutput_vec_header(i)).EQ.'latitude') THEN 
        i_latitude=i
        GOTO 5
       ENDIF
       IF (TRIM(s_scoutput_vec_header(i)).EQ.
     +     'height_of_station_above_sea_level') THEN 
        i_height_of_station_above_sea_level=i
        GOTO 5
       ENDIF
       IF (TRIM(s_scoutput_vec_header(i)).EQ.'data_policy_licence') THEN 
        i_data_policy_licence=i
        GOTO 5
       ENDIF
       IF (TRIM(s_scoutput_vec_header(i)).EQ.'source_id') THEN 
        i_source_id=i
        GOTO 5
       ENDIF

       IF (TRIM(s_scoutput_vec_header(i)).EQ.'region') THEN
        i_region=i
        GOTO 5
       ENDIF
       IF (TRIM(s_scoutput_vec_header(i)).EQ.'operating_territory') THEN
        i_operating_territory=i
        GOTO 5
       ENDIF
       IF (TRIM(s_scoutput_vec_header(i)).EQ.'station_type') THEN
        i_station_type=i
        GOTO 5
       ENDIF
       IF (TRIM(s_scoutput_vec_header(i)).EQ.'platform_type') THEN
        i_platform_type=i
        GOTO 5
       ENDIF
       IF (TRIM(s_scoutput_vec_header(i)).EQ.'platform_sub_type') THEN
        i_platform_sub_type=i
        GOTO 5
       ENDIF
       IF (TRIM(s_scoutput_vec_header(i)).EQ.
     +   'primary_station_id_scheme') THEN
        i_primary_station_id_scheme=i
        GOTO 5
       ENDIF
       IF (TRIM(s_scoutput_vec_header(i)).EQ.'location_accuracy') THEN
        i_location_accuracy=i
        GOTO 5
       ENDIF
       IF (TRIM(s_scoutput_vec_header(i)).EQ.'location_method') THEN
        i_location_method=i
        GOTO 5
       ENDIF
       IF (TRIM(s_scoutput_vec_header(i)).EQ.'location_quality') THEN
        i_location_quality=i
        GOTO 5
       ENDIF
       IF (TRIM(s_scoutput_vec_header(i)).EQ.'station_crs') THEN
        i_station_crs=i
        GOTO 5
       ENDIF
       IF (TRIM(s_scoutput_vec_header(i)).EQ.
     +   'height_of_station_above_local_ground') THEN
        i_height_of_station_above_local_ground=i
        GOTO 5
       ENDIF
       IF (TRIM(s_scoutput_vec_header(i)).EQ.
     +   'height_of_station_above_sea_level_accuracy') THEN
        i_height_of_station_above_sea_level_accuracy=i
        GOTO 5
       ENDIF
       IF (TRIM(s_scoutput_vec_header(i)).EQ.'sea_level_datum') THEN
        i_sea_level_datum=i
        GOTO 5
       ENDIF

 5     CONTINUE

      ENDDO

c      print*,'i_primary_id=',i_primary_id
c      print*,'i_record_number=',i_record_number
c      print*,'i_secondary_id=',i_secondary_id
c      print*,'i_station_name=',i_station_name
c      print*,'i_longitude=',i_longitude
c      print*,'i_latitude=',i_latitude
c      print*,'i_height_of_station_above_sea_level',
c     +  i_height_of_station_above_sea_level
c      print*,'i_data_policy_licence=',i_data_policy_licence
c      print*,'i_source_id=',i_source_id

c      print*,'i_region=',i_region
c      print*,'i_operating_territory=',i_operating_territory
c      print*,'i_station_type=',i_station_type
c      print*,'i_platform_type=',i_platform_type
c      print*,'i_platform_sub_type=',i_platform_sub_type
c      print*,'i_primary_station_id_scheme=',i_primary_station_id_scheme
c      print*,'i_location_accuracy=',i_location_accuracy
c      print*,'i_location_method=',i_location_method
c      print*,'i_location_quality=',i_location_quality
c      print*,'i_station_crs=',i_station_crs
c      print*,'i_height_of_station_above_local_ground_level=',
c     +  i_height_of_station_above_local_ground
c      print*,'i_height_of_station_above_sea_level_accuracy=',
c     +  i_height_of_station_above_sea_level_accuracy
c      print*,'i_sea_level_datum=',i_sea_level_datum
c*****
c      print*,'s_scoutput_mat_fields=',
c     +  (TRIM(s_scoutput_mat_fields(i,1)),i=1,5)
c      print*,'l_scoutput=',l_scoutput
c      print*,'l_scoutput_numfield=',l_scoutput_numfield
c      print*,'s_stnname_single=',TRIM(s_stnname_single)

c      STOP 'get_singles_stnconfig_v5'

      ii=0       !counter for different record number
c     
      DO i=1,l_scoutput

c      Note there will be multiple records for same station name
       IF (TRIM(s_scoutput_mat_fields(i,1)).EQ.TRIM(s_stnname_single))
     +     THEN 

c       Extract all fields from line
        DO j=1,l_scoutput_numfield 
         s_scoutput_vec_data(j)=s_scoutput_mat_fields(i,j)
        ENDDO

c       extract variables by index along data line
        s_single_primary_id                    =
     +   s_scoutput_vec_data(i_primary_id)         !1 stays 1
        s_single_record_number                 =
     +   s_scoutput_vec_data(i_record_number)      !3 stays 3
        s_single_secondary_id                  =
     +   s_scoutput_vec_data(i_secondary_id)       !4 stays 4
        s_single_station_name                  =
     +   s_scoutput_vec_data(i_station_name)       !5 changes to 6
        s_single_longitude                     =
     +   s_scoutput_vec_data(i_longitude)          !6 changes to 10
        s_single_latitude                      =
     +   s_scoutput_vec_data(i_latitude)           !7 changes to 11
        s_single_height_station_above_sea_level=
     +   s_scoutput_vec_data(i_height_of_station_above_sea_level) !45 stays 45
        s_single_data_policy_licence           =
     +   s_scoutput_vec_data(i_data_policy_licence)!39 stays 39
        s_single_source_id                     =
     +   s_scoutput_vec_data(i_source_id)          !48 stays 48

c       Variables from stnconfig-write
        s_single_region                        =
     +   s_scoutput_vec_data(i_region)             !38 stays 38
        s_single_operating_territory           =
     +   s_scoutput_vec_data(i_operating_territory)!19 stays 19
        s_single_station_type                  =
     +   s_scoutput_vec_data(i_station_type)       !15 stays 15
        s_single_platform_type                 =
     +   s_scoutput_vec_data(i_platform_type)      !16 stays 16
        s_single_platform_sub_type             =
     +   s_scoutput_vec_data(i_platform_sub_type)  !17 stays 17
        s_single_primary_station_id_scheme     =
     +   s_scoutput_vec_data(i_primary_station_id_scheme) !2 becomes 40
        s_single_location_accuracy             =
     +   s_scoutput_vec_data(i_location_accuracy)  !41 stays 41
        s_single_location_method               =
     +   s_scoutput_vec_data(i_location_method)    !42 stays 42
        s_single_location_quality              =
     +   s_scoutput_vec_data(i_location_quality)   !43 stays 43
        s_single_station_crs                   =
     +   s_scoutput_vec_data(i_station_crs)        !11 changes to 9
        s_single_height_station_above_local_ground=
     + s_scoutput_vec_data(i_height_of_station_above_local_ground) !44 stays 44
        s_single_height_station_above_sea_level_accuracy=
     + s_scoutput_vec_data(i_height_of_station_above_sea_level_accuracy) !46 stays 46
        s_single_sea_level_datum               =
     +   s_scoutput_vec_data(i_sea_level_datum)

        ii=ii+1                   !increment counter for primary_id 

        IF (ii.GT.20) THEN 
         print*,'ii=',ii
         STOP 'get_singles_stnconfig_v5; collect number over limit'
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

c     set flag if station not found
      IF (ii.EQ.0) THEN 
       i_flag=1
      ENDIF

c      IF (l_collect_cnt.GT.0) THEN
c       print*,'station found' 
c       print*,'l_collect_cnt=',l_collect_cnt
c       STOP 'get_singles_stnconfig2'
c      ENDIF
c************************************************************************
c     Find the number distinct source_id in the list

c     Initialize variable
      DO i=1,20
       i_distinct_cnt(i)=0
      ENDDO

      IF (l_collect_cnt.EQ.1) THEN 
       l_collect_distinct=1
       s_distinct_source_id(1)=s_collect_source_id(1)
       i_distinct_cnt(1)=1
      ENDIF

      IF (l_collect_cnt.GT.1) THEN 

       l_collect_distinct=0
       l_collect_distinct=l_collect_distinct+1      
       s_distinct_source_id(1)=s_collect_source_id(1)
       i_distinct_cnt(1)=i_distinct_cnt(1)+1

       DO i=2,l_collect_cnt
        DO j=1,l_collect_distinct
         IF (TRIM(s_collect_source_id(i)).EQ.
     +       TRIM(s_distinct_source_id(j))) THEN 
          i_distinct_cnt(j)=i_distinct_cnt(j)+1
          GOTO 21
         ENDIF
        ENDDO

c       If here thin must augment counting variable
        l_collect_distinct=l_collect_distinct+1      
        s_distinct_source_id(l_collect_distinct)=s_collect_source_id(i)
        i_distinct_cnt(l_collect_distinct)=
     +     i_distinct_cnt(l_collect_distinct)+1
       ENDDO

 21    CONTINUE

      ENDIF
c************************************************************************
c     Flag source id that are ambiguous 
c     (ie. different reporttype with same source_id)

c     Conduct ambiguity procedure if element found in stnconfig file
      IF (l_collect_cnt.GT.0) THEN 

c     Initialize all source id to good
      DO i=1,20 
       s_collect_flagambig(i)='0'
      ENDDO

      IF (l_collect_cnt.NE.l_collect_distinct) THEN
c      Cycle through distinct source id
       DO i=1,l_collect_distinct
c       Act if count>1
        IF (i_distinct_cnt(i).GT.1) THEN 
         DO j=1,l_collect_cnt
          IF (TRIM(s_collect_source_id(j)).EQ.
     +        TRIM(s_distinct_source_id(i))) THEN 
           s_collect_flagambig(j)='1'
          ENDIF
         ENDDO
        ENDIF
       ENDDO
      ENDIF

      ENDIF

c      IF (l_collect_cnt.NE.l_collect_distinct) THEN

c      print*,'l_collect_cnt,l_collect_distinct=',
c     +  l_collect_cnt,l_collect_distinct
c      print*,'i_distinct_cnt',(i_distinct_cnt(i),i=1,l_collect_distinct)
c      print*,'distinct source_id=',
c     +  ('='//TRIM(s_distinct_source_id(j))//'=',j=1,l_collect_distinct)
c      print*,'s_collect_flagambig=',
c     +  (s_collect_flagambig(j),j=1,l_collect_cnt)
c      STOP 'get_singles_stnconfig2'

c      ENDIF
c************************************************************************
c      Test length of name
       DO i=1,l_collect_cnt
        IF (LEN_TRIM(s_collect_station_name(i)).GT.50) THEN
         print*,'emergency stop name length over 50 char'
         STOP 'get_singles_stnconfig_v5'
        ENDIF
       ENDDO
c************************************************************************
c      print*,'l_collect_cnt=',l_collect_cnt

c      print*,'s_collect_primary_id=',
c     +  (s_collect_primary_id(i),i=1,l_collect_cnt)
c      print*,'s_collect_record_number=',
c     +  ('='//TRIM(s_collect_record_number(i))//'=',i=1,l_collect_cnt)
c      print*,'s_collect_secondary_id=',
c     +  (s_collect_secondary_id(i),i=1,l_collect_cnt)
c      print*,'s_collect_station_name=',
c     +  (s_collect_station_name(i),i=1,l_collect_cnt)
c      print*,'s_collect_longitude=',
c     +  (s_collect_longitude(i),i=1,l_collect_cnt)
c      print*,'s_collect_latitude=',
c     +  (s_collect_latitude(i),i=1,l_collect_cnt)
c      print*,'s_collect_elevation_m=',
c     +  (s_collect_elevation_m(i),i=1,l_collect_cnt)
c      print*,'s_collect_policy_license=',
c     +  (s_collect_policy_license(i),i=1,l_collect_cnt)
c      print*,'s_collect_source_id=',
c     +  (s_collect_source_id(i),i=1,l_collect_cnt)

c************************************************************************
c      print*,'just leaving get_singles_stnconfig3'

c      STOP 'get_singles_stnconfig_v5'

      RETURN
      END
