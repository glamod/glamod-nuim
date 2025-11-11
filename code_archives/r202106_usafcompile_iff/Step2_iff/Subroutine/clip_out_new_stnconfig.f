c     Subroutine to Clip new stnconfig file to get limited set of variables
c     11Mar2020: clip out stnconfig info

      SUBROUTINE clip_out_new_stnconfig(l_scoutput_rgh,l_scoutput,ilen,
     +  l_scoutput_numfield,s_scoutput_vec_header,
     +  s_scoutput_mat_fields,
     +  s_scinput2_primary_id,s_scinput2_record_number,
     +  s_scinput2_secondary_id,s_scinput2_station_name,
     +  s_scinput2_longitude,s_scinput2_latitude,
     +  s_scinput2_elevation_m,s_scinput2_policy_licence,
     +  s_scinput2_source_id)

      IMPLICIT NONE
c************************************************************************
c     Declare variables passed into subroutine

      INTEGER             :: l_scoutput_rgh
      INTEGER             :: l_scoutput
      INTEGER             :: l_scoutput_numfield
      INTEGER             :: ilen
       
      CHARACTER(LEN=ilen) :: s_scoutput_vec_header(50)               
      CHARACTER(LEN=ilen) :: s_scoutput_mat_fields(l_scoutput_rgh,50)

      CHARACTER(LEN=*)    :: s_scinput2_primary_id(l_scoutput_rgh)    !20
      CHARACTER(LEN=*)    :: s_scinput2_record_number(l_scoutput_rgh) !2
      CHARACTER(LEN=*)    :: s_scinput2_secondary_id(l_scoutput_rgh)  !20
      CHARACTER(LEN=*)    :: s_scinput2_station_name(l_scoutput_rgh)  !50
      CHARACTER(LEN=*)    :: s_scinput2_longitude(l_scoutput_rgh)     !10
      CHARACTER(LEN=*)    :: s_scinput2_latitude(l_scoutput_rgh)      !10
      CHARACTER(LEN=*)    :: s_scinput2_elevation_m(l_scoutput_rgh)   !10
      CHARACTER(LEN=*)    :: s_scinput2_policy_licence(l_scoutput_rgh)!1
      CHARACTER(LEN=*)    :: s_scinput2_source_id(l_scoutput_rgh)     !3
c*****
c     Declare variables used in subroutine
      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: io

      INTEGER             :: i_flag_primary_id
      INTEGER             :: i_flag_record_number
      INTEGER             :: i_flag_secondary_id
      INTEGER             :: i_flag_station_name
      INTEGER             :: i_flag_longitude
      INTEGER             :: i_flag_latitude
      INTEGER             :: i_flag_elevation
      INTEGER             :: i_flag_policy_licence
      INTEGER             :: i_flag_source_id

      INTEGER             :: i_len_test

      CHARACTER(LEN=20)   :: s_single

      INTEGER             :: l_afwa,l_icao,l_wmo
c************************************************************************
      print*,'just inside clip_out_new_stnconfig'

      print*,'l_scoutput_numfield=',l_scoutput_numfield
      print*,'s_scoutput_vec_header=',
     +  (TRIM(s_scoutput_vec_header(i)),i=1,l_scoutput_numfield)

      i_flag_primary_id=0
      i_flag_record_number=0
      i_flag_secondary_id=0
      i_flag_station_name=0
      i_flag_longitude=0
      i_flag_latitude=0
      i_flag_elevation=0
      i_flag_policy_licence=0
      i_flag_source_id=0

      DO j=1,l_scoutput_numfield

c      PRIMARY_ID
       IF (TRIM(s_scoutput_vec_header(j)).EQ.'primary_id') THEN
c        print*,'j,primary_id',j
c        print*,(TRIM(s_scoutput_mat_fields(i,j)),i=1,5)
        i_flag_primary_id=1
        DO i=1,l_scoutput
         s_scinput2_primary_id(i)=TRIM(s_scoutput_mat_fields(i,j))
        ENDDO
       ENDIF

c      RECORD_NUMBER
       IF (TRIM(s_scoutput_vec_header(j)).EQ.'record_number') THEN
        i_flag_record_number=1
        DO i=1,l_scoutput
         s_scinput2_record_number(i)=TRIM(s_scoutput_mat_fields(i,j))
        ENDDO
       ENDIF

c      SECONDARY_ID
       IF (TRIM(s_scoutput_vec_header(j)).EQ.'secondary_id') THEN
        i_flag_secondary_id=1
        DO i=1,l_scoutput
         s_scinput2_secondary_id(i)=TRIM(s_scoutput_mat_fields(i,j))
        ENDDO
       ENDIF

c      STATION_NAME
       IF (TRIM(s_scoutput_vec_header(j)).EQ.'station_name') THEN
        i_flag_station_name=1
        DO i=1,l_scoutput
         s_scinput2_station_name(i)=TRIM(s_scoutput_mat_fields(i,j))
        ENDDO
       ENDIF

c      LONGITUDE
       IF (TRIM(s_scoutput_vec_header(j)).EQ.'longitude') THEN
        i_flag_longitude=1
        DO i=1,l_scoutput

         i_len_test=LEN_TRIM(s_scoutput_mat_fields(i,j))
         IF (i_len_test.GE.10) THEN 
          print*,'longitude length test failed',i_len_test
          STOP 'clip_out_new_stnconfig'
         ENDIF

         s_scinput2_longitude(i)=TRIM(s_scoutput_mat_fields(i,j))
        ENDDO
       ENDIF

c      LATITUDE
       IF (TRIM(s_scoutput_vec_header(j)).EQ.'latitude') THEN
        i_flag_latitude=1
        DO i=1,l_scoutput

         i_len_test=LEN_TRIM(s_scoutput_mat_fields(i,j))
         IF (i_len_test.GE.10) THEN 
          print*,'latitude length test failed',i_len_test
          STOP 'clip_out_new_stnconfig'
         ENDIF

         s_scinput2_latitude(i)=TRIM(s_scoutput_mat_fields(i,j))
        ENDDO
       ENDIF

c      ELEVATION
       IF (TRIM(s_scoutput_vec_header(j)).EQ.
     +     'height_of_station_above_sea_level') THEN
        i_flag_elevation=1
        DO i=1,l_scoutput
         s_scinput2_elevation_m(i)=TRIM(s_scoutput_mat_fields(i,j))
        ENDDO
       ENDIF

c      POLICY_LICENCE
       IF (TRIM(s_scoutput_vec_header(j)).EQ.'data_policy_licence') THEN
        i_flag_policy_licence=1
        DO i=1,l_scoutput
c         print*,'policy licience=',i,TRIM(s_scoutput_mat_fields(i,j))
         s_scinput2_policy_licence(i)=TRIM(s_scoutput_mat_fields(i,j))

c         CALL SLEEP(1)
        ENDDO
       ENDIF

c      SOURCE_ID
       IF (TRIM(s_scoutput_vec_header(j)).EQ.'source_id') THEN
        i_flag_source_id=1
        DO i=1,l_scoutput
         s_scinput2_source_id(i)=TRIM(s_scoutput_mat_fields(i,j))
        ENDDO
       ENDIF

      ENDDO

c     Count number of networktypes in list
      l_afwa=0
      l_icao=0
      l_wmo=0
      DO i=1,l_scoutput
       s_single=TRIM(s_scinput2_primary_id(i))
       IF (s_single(1:4).EQ.'AFWA') THEN 
        l_afwa=l_afwa+1
       ENDIF
       IF (s_single(1:4).EQ.'ICAO') THEN 
        l_icao=l_icao+1
       ENDIF
       IF (s_single(1:3).EQ.'WMO') THEN 
        l_wmo=l_wmo+1
       ENDIF
      ENDDO

      print*,'l_afwa,l_icao,l_wmo=',l_afwa,l_icao,l_wmo

      print*,'s_scinput2_primary_id=',i_flag_primary_id,
     +  (TRIM(s_scinput2_primary_id(i))//'=',i=1,5)
      print*,'s_scinput2_record_number=',i_flag_record_number,
     +  (TRIM(s_scinput2_record_number(i))//'=',i=1,5)
      print*,'s_scinput2_secondary_id=',i_flag_secondary_id,
     +  (TRIM(s_scinput2_secondary_id(i))//'=',i=1,5)
      print*,'s_scinput2_station_name=',i_flag_station_name,
     +  (TRIM(s_scinput2_station_name(i))//'=',i=1,5)
      print*,'s_scinput2_latitude=',i_flag_latitude,
     +  (TRIM(s_scinput2_latitude(i))//'=',i=1,5)

      print*,'s_scinput2_elevation_m=',i_flag_elevation,
     +  (TRIM(s_scinput2_elevation_m(i))//'=',i=1,5)
      print*,'s_scinput2_policy_licence=',i_flag_policy_licence,
     +  (TRIM(s_scinput2_policy_licence(i))//'=',i=1,5)
      print*,'s_scinput2_source_id=',i_flag_source_id,
     +  (TRIM(s_scinput2_source_id(i))//'=',i=1,5)

c      print*,'just leaving clip_out_new_stnconfig'
c      STOP 'clip_out_new_stnconfig'

      RETURN
      END
