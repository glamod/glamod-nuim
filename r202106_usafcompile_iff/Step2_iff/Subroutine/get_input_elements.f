c     Subroutine to get input elements
c     AJ_Kettle, 01Mar2019
c     11Mar2019: modified USAF update

      SUBROUTINE get_input_elements(s_directory_input,s_filename,
     +  l_scinput_rgh,l_scinput,
     +  s_scinput_primary_id,s_scinput_record_number,
     +  s_scinput_secondary_id,s_scinput_station_name,
     +  s_scinput_longitude,s_scinput_latitude,
     +  s_scinput_elevation_m,s_scinput_policy_license,
     +  s_scinput_source_id)

      IMPLICIT NONE
c************************************************************************
c     Variables passed in from outside

      CHARACTER(LEN=300)  :: s_directory_input
      CHARACTER(LEN=300)  :: s_filename

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
      INTEGER             :: io

      CHARACTER(LEN=300)  :: s_pathandname
      CHARACTER(LEN=300)  :: s_linget
      CHARACTER(LEN=300)  :: s_header

      CHARACTER(LEN=20)   :: s_primary_id
      CHARACTER(LEN=2)    :: s_record_number
      CHARACTER(LEN=20)   :: s_secondary_id
      CHARACTER(LEN=50)   :: s_station_name
      CHARACTER(LEN=10)   :: s_longitude
      CHARACTER(LEN=10)   :: s_latitude
      CHARACTER(LEN=10)   :: s_elevation_m
      CHARACTER(LEN=1)    :: s_policy_license
      CHARACTER(LEN=3)    :: s_source_id

c************************************************************************
c      print*,'just entered get_input_elements'

      s_pathandname=TRIM(s_directory_input)//TRIM(s_filename)

      ii=0
      jj=0

      OPEN(UNIT=5,
     +  FILE=TRIM(s_pathandname),
     +  FORM='formatted',
     +  STATUS='OLD',ACTION='READ')

      READ(5,1000,IOSTAT=io) s_header

      DO 
       READ(5,1000,IOSTAT=io) s_linget   
 1000  FORMAT(a300)

       IF (io .GT. 0) THEN
        WRITE(*,*) 'Check input. Something went wrong'
        GOTO 100
       ELSE IF (io .LT. 0) THEN
        WRITE(*,*) 'end of file reached'
        GOTO 100
       ELSE
        ii=ii+1

c       Get elements from line
        CALL get_elements_from_line(s_linget,
     +    s_primary_id,s_record_number,s_secondary_id,s_station_name,
     +    s_longitude,s_latitude,s_elevation_m,
     +    s_policy_license,s_source_id)

c       Archive strings
c        IF (s_primary_id(1:4).EQ.'WMO_'.OR.
c     +      s_primary_id(1:5).EQ.'ICAO_'.OR.
c     +      s_primary_id(1:5).EQ.'AFWA_'.OR.
c     +      s_primary_id(1:6).EQ.'CMANS_') THEN 
c        print*,'s_primary_id=',s_primary_id

         s_scinput_primary_id(ii)    =s_primary_id
         s_scinput_record_number(ii) =s_record_number
         s_scinput_secondary_id(ii)  =s_secondary_id
         s_scinput_station_name(ii)  =s_station_name
         s_scinput_longitude(ii)     =s_longitude
         s_scinput_latitude(ii)      =s_latitude
         s_scinput_elevation_m(ii)   =s_elevation_m
         s_scinput_policy_license(ii)=s_policy_license
         s_scinput_source_id(ii)     =s_source_id
c         jj=jj+1
c        ENDIF

cc       print*,ii,io,TRIM(s_linget)
cc       CALL SLEEP(1)
       ENDIF
      ENDDO
 100  CONTINUE
      CLOSE(UNIT=5)

c      l_stnconfig_in=ii

      l_scinput=ii

      print*,'s_scinput_primary_id',
     +  (TRIM(s_scinput_primary_id(i)),i=1,5)
      print*,'s_scinput_record_number',
     +  (TRIM(s_scinput_record_number(i)),i=1,5)
      print*,'s_scinput_secondary_id',
     +  (TRIM(s_scinput_secondary_id(i)),i=1,5)
      print*,'s_scinput_station_name',
     +  (TRIM(s_scinput_station_name(i)),i=1,5)
      print*,'s_scinput_longitude',
     +  (TRIM(s_scinput_longitude(i)),i=1,5)
      print*,'s_scinput_latitude',
     +  (TRIM(s_scinput_latitude(i)),i=1,5)
      print*,'s_scinput_elevation_m',
     +  (TRIM(s_scinput_elevation_m(i)),i=1,5)
      print*,'s_scinput_policy_license',
     +  (TRIM(s_scinput_policy_license(i)),i=1,5)
      print*,'s_scinput_source_id',
     +  (TRIM(s_scinput_source_id(i)),i=1,5)

c      print*,'l_stnconfig_in=',l_stnconfig_in
      print*,'l_scinput..=',l_scinput_rgh,l_scinput
c************************************************************************
c************************************************************************
c      print*,'just leaving get_input_elements'
c      STOP 'get_input_elements'

      RETURN
      END
