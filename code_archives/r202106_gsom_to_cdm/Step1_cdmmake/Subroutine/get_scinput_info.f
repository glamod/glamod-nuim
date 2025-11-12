c     Subroutine to get scinput fields
c     AJ_Kettle, 31Oct2019

      SUBROUTINE get_scinput_info(
     +  l_scoutput_rgh,l_scoutput,s_scoutput_mat_fields,
     +  l_scinput_rgh,l_scinput,
     +  s_scinput_primary_id,s_scinput_record_number,
     +  s_scinput_secondary_id,s_scinput_station_name,
     +  s_scinput_longitude,s_scinput_latitude,
     +  s_scinput_elevation_m,s_scinput_policy_license,
     +  s_scinput_source_id)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into subroutine

      INTEGER             :: l_scoutput_rgh
      INTEGER             :: l_scoutput
      INTEGER             :: l_scoutput_numfield       
      CHARACTER(LEN=50)   :: s_scoutput_vec_header(50)               
      CHARACTER(LEN=50)   :: s_scoutput_mat_fields(l_scoutput_rgh,50)

      INTEGER             :: l_scinput_rgh
      INTEGER             :: l_scinput
      CHARACTER(LEN=20)   :: s_scinput_primary_id(l_scinput_rgh)
      CHARACTER(LEN=2)    :: s_scinput_record_number(l_scinput_rgh)
      CHARACTER(LEN=20)   :: s_scinput_secondary_id(l_scinput_rgh)
      CHARACTER(LEN=50)   :: s_scinput_station_name(l_scinput_rgh)
      CHARACTER(LEN=10)   :: s_scinput_longitude(l_scinput_rgh)
      CHARACTER(LEN=10)   :: s_scinput_latitude(l_scinput_rgh)
      CHARACTER(LEN=10)   :: s_scinput_elevation_m(l_scinput_rgh)
      CHARACTER(LEN=1)    :: s_scinput_policy_license(l_scinput_rgh)
      CHARACTER(LEN=3)    :: s_scinput_source_id(l_scinput_rgh)
c*****
c     Variables used in subroutine
      INTEGER             :: i,j,k,ii,jj,kk

c************************************************************************
      print*,'l_scoutput_numfield=',l_scoutput_numfield
      DO i=1,l_scoutput_numfield
       print*,i,TRIM(s_scoutput_vec_header(i))
      ENDDO

c      STOP 'get_scinput_info'

c     Get fields
      DO i=1,l_scoutput
       s_scinput_primary_id(i)    =TRIM(s_scoutput_mat_fields(i,1))
       s_scinput_record_number(i) =TRIM(s_scoutput_mat_fields(i,3))
       s_scinput_secondary_id(i)  =TRIM(s_scoutput_mat_fields(i,4))
       s_scinput_station_name(i)  =TRIM(s_scoutput_mat_fields(i,6))
       s_scinput_longitude(i)     =TRIM(s_scoutput_mat_fields(i,10))
       s_scinput_latitude(i)      =TRIM(s_scoutput_mat_fields(i,11))
       s_scinput_elevation_m(i)   =TRIM(s_scoutput_mat_fields(i,45))
       s_scinput_policy_license(i)=TRIM(s_scoutput_mat_fields(i,39))
       s_scinput_source_id(i)     =TRIM(s_scoutput_mat_fields(i,48))
      ENDDO

      l_scinput=l_scoutput

c      print*,'primary_id=',  (TRIM(s_scinput_primary_id(i)),i=1,10)
c      print*,'record_number',(TRIM(s_scinput_record_number(i)),i=1,10)
c      print*,'secondary_id', (TRIM(s_scinput_secondary_id(i)),i=1,10)
c      print*,'station_name', 
c     +  (TRIM(s_scinput_station_name(i))//'=',i=1,10)
c      print*,'longitude',    (TRIM(s_scinput_longitude(i)),i=1,10)
c      print*,'latitude',     (TRIM(s_scinput_latitude(i)),i=1,10)
c      print*,'elevation_m',  (TRIM(s_scinput_elevation_m(i)),i=1,10)
c      print*,'policy license',(TRIM(s_scinput_policy_license(i)),i=1,10)
c      print*,'source_id',    (TRIM(s_scinput_source_id(i)),i=1,10)

      RETURN
      END
