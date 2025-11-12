c     Subroutine to get station configuration info for single station
c     AJ_Kettle, 13Mar2019
c     13Mar2020: modified for usaf update

      SUBROUTINE get_stnconfig_singlestn2(s_shortnamelist_single,
     +  l_scinput_rgh,l_scinput,
     +  s_scinput_primary_id,s_scinput_station_name,
     +  s_scinput_longitude,s_scinput_latitude,s_scinput_elevation_m,

     +  s_scsingle_primary_id,s_scsingle_station_name,
     +  s_scsingle_longitude,s_scsingle_latitude,s_scsingle_elevation_m,
     +  l_occur)

      IMPLICIT NONE
c************************************************************************
c     Declare variables 

      CHARACTER(LEN=*)    :: s_shortnamelist_single   !300

      INTEGER             :: l_scinput_rgh
      INTEGER             :: l_scinput
      CHARACTER(LEN=*)    :: s_scinput_primary_id(l_scinput_rgh)   !20
      CHARACTER(LEN=*)    :: s_scinput_station_name(l_scinput_rgh) !50
      CHARACTER(LEN=*)    :: s_scinput_longitude(l_scinput_rgh)    !10
      CHARACTER(LEN=*)    :: s_scinput_latitude(l_scinput_rgh)     !10
      CHARACTER(LEN=*)    :: s_scinput_elevation_m(l_scinput_rgh)  !10

      CHARACTER(LEN=*)    :: s_scsingle_primary_id                 !20
      CHARACTER(LEN=*)    :: s_scsingle_station_name               !50
      CHARACTER(LEN=*)    :: s_scsingle_longitude                  !10
      CHARACTER(LEN=*)    :: s_scsingle_latitude                   !10
      CHARACTER(LEN=*)    :: s_scsingle_elevation_m                !10
c*****
c     Variables used in subroutine

      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: io

      INTEGER             :: l_occur

c      CHARACTER(LEN=300)  :: s_name_single
c      INTEGER             :: i_len
c      CHARACTER(LEN=300)  :: s_name_isolate
c************************************************************************
c      print*,'just entered get_stnconfig_singlestn'

c     Isolate name
c      s_name_single=s_shortnamelist_single
c      i_len=LEN_TRIM(s_name_single)
c      s_name_isolate=s_name_single(1:i_len-4)

c     Initialize output variables
      ii=0
      s_scsingle_primary_id  ='XXX'
      s_scsingle_station_name='XXX'
      s_scsingle_longitude   ='XXX'
      s_scsingle_latitude    ='XXX'
      s_scsingle_elevation_m ='XXX'

c     Cycle through info list
      DO j=1,l_scinput
       IF (TRIM(s_shortnamelist_single).EQ.
     +     TRIM(s_scinput_primary_id(j))) THEN 
        s_scsingle_primary_id  =s_scinput_primary_id(j)
        s_scsingle_station_name=s_scinput_station_name(j)
        s_scsingle_longitude   =s_scinput_longitude(j)
        s_scsingle_latitude    =s_scinput_latitude(j)
        s_scsingle_elevation_m =s_scinput_elevation_m(j)

        ii=ii+1

c        GOTO 10
       ENDIF
      ENDDO
 10   CONTINUE

      l_occur=ii

c      IF (l_occur.GT.0) THEN 
c       print*,'test to see if any matches in stnconfig file'
c       STOP 'get_stnconfig_singlestn2'
c      ENDIF     

c      print*,'l_occur=',l_occur

c      print*,'just leaving get_stnconfig_singlestn'

c      STOP 'get_stnconfig_singlestn'

      RETURN
      END
