c     Subroutine string all triplet lines together
c     AJ_Kettle, 10Sep2019
c     28Mar2020: used for USAF update

      SUBROUTINE assemble_triplet_lines_stnconfig2(
     +   s_date_st,s_time_st,s_zone_st,
     +   s_directory_assemble,s_filename,
     +   l_cnt_rgh,l_cnt_triplet,
     +   s_networktype_single,s_platformid_single,
     +   s_vec_index,
     +   s_vec_latitude,s_vec_longitude,s_vec_height,
     +   s_metasingle_name,s_metasingle_cdmlandcode,
     +   s_vec_year_st,s_vec_year_en,s_vec_assemble_varcode)

      IMPLICIT NONE
c************************************************************************
c     Declare variables 

      CHARACTER(LEN=8)    :: s_date_st
      CHARACTER(LEN=10)   :: s_time_st
      CHARACTER(LEN=5)    :: s_zone_st

      CHARACTER(LEN=300)  :: s_directory_assemble
      CHARACTER(LEN=300)  :: s_filename

      INTEGER             :: l_cnt_rgh
      INTEGER             :: l_cnt_triplet

      CHARACTER(LEN=15)   :: s_networktype_single
      CHARACTER(LEN=15)   :: s_platformid_single

      CHARACTER(LEN=*)    :: s_vec_index(l_cnt_rgh)
      CHARACTER(LEN=*)    :: s_vec_latitude(l_cnt_rgh)
      CHARACTER(LEN=*)    :: s_vec_longitude(l_cnt_rgh)
      CHARACTER(LEN=*)    :: s_vec_height(l_cnt_rgh)

      CHARACTER(LEN=*)    :: s_metasingle_name
      CHARACTER(LEN=*)    :: s_metasingle_cdmlandcode

      CHARACTER(LEN=*)    :: s_vec_year_st(l_cnt_rgh)
      CHARACTER(LEN=*)    :: s_vec_year_en(l_cnt_rgh)
      CHARACTER(LEN=*)    :: s_vec_assemble_varcode(l_cnt_rgh)
c*****
c     Variables used in subroutine

      INTEGER             :: i,j,k,ii,jj,kk

      INTEGER             :: io
      CHARACTER(LEN=300)  :: s_pathandname
      LOGICAL             :: there
      CHARACTER(LEN=3)    :: s_filestatus1

      INTEGER             :: l_len_header_orig
      INTEGER             :: l_len_header
      CHARACTER(LEN=3)    :: s_len_header 
      INTEGER,PARAMETER   :: l_header_col=13
      CHARACTER(LEN=300)  :: s_line_header_orig
      CHARACTER(LEN=300)  :: s_line_header
      CHARACTER(LEN=50)   :: s_vec_header(l_header_col)

      CHARACTER(LEN=50)   :: s_primary_id            !1
      CHARACTER(LEN=50)   :: s_record_number         !2
      CHARACTER(LEN=50)   :: s_secondary_id          !3
      CHARACTER(LEN=50)   :: s_station_name          !4
      CHARACTER(LEN=50)   :: s_longitude             !5
      CHARACTER(LEN=50)   :: s_latitude              !6
      CHARACTER(LEN=50)   :: s_height                !7
      CHARACTER(LEN=50)   :: s_start_date            !8
      CHARACTER(LEN=50)   :: s_end_date              !9
      CHARACTER(LEN=50)   :: s_operating_territory   !10
      CHARACTER(LEN=50)   :: s_observed_variables    !11
      CHARACTER(LEN=50)   :: s_location_accuracy     !12
      CHARACTER(LEN=50)   :: s_source_id             !13

      CHARACTER(LEN=300)  :: s_line_data_orig
      CHARACTER(LEN=300)  :: s_line_data
      CHARACTER(LEN=50)   :: s_vec_data(l_header_col)

      INTEGER             :: l_len_data_orig
      INTEGER             :: l_len_data
      CHARACTER(LEN=3)    :: s_len_data 

      CHARACTER(LEN=4)    :: s_fmt_header
      CHARACTER(LEN=4)    :: s_fmt_data
c************************************************************************
c      print*,'just entered assemble_triplet_lines_stn'

c      print*,'s_vec_index=',(s_vec_index(i),i=1,l_cnt_triplet)
c      STOP 'assemble_triplet_lines_stnconfig'
c************************************************************************
c     Inquire if file exists
      s_pathandname=TRIM(s_directory_assemble)//TRIM(s_filename)

c      print*,'s_pathandname=',TRIM(s_pathandname)

      INQUIRE(FILE=TRIM(s_pathandname),
     +   EXIST=there)
      IF (there) THEN
        s_filestatus1='OLD'
      ENDIF
      IF (.NOT.(there)) THEN
        s_filestatus1='NEW'
      ENDIF    

c     Case of new file
      IF (s_filestatus1.EQ.'NEW') THEN 

       OPEN(UNIT=2,
     +   FILE=TRIM(s_pathandname),
     +   FORM='formatted',
     +   STATUS='REPLACE',ACTION='WRITE')

         WRITE(2,FMT=1002) 'Output triplet identifications          '
         WRITE(2,FMT=1002) '                                        '
         WRITE(2,FMT=1006) 'AJ_Kettle',s_date_st,s_time_st
         WRITE(2,FMT=1002) '                                        '
         WRITE(2,FMT=1002) 'subr: assemble_triplet_lines_stnconfig.f'
         WRITE(2,FMT=1002) '                                        '
 1002    FORMAT(a40)
 1006    FORMAT(t1,a9,t11,a8,t20,a10)
c******
c        Assign elements header line
         s_vec_header(1) ='primary_id'
         s_vec_header(2) ='record_number'
         s_vec_header(3) ='secondary_id'
         s_vec_header(4) ='station_name'
         s_vec_header(5) ='longitude'
         s_vec_header(6) ='latitude'
         s_vec_header(7) ='height_of_station_above_sea_level'
         s_vec_header(8) ='start_date'
         s_vec_header(9) ='end_date'
         s_vec_header(10)='operating_territory'
         s_vec_header(11)='observed_variables'
         s_vec_header(12)='location_accuracy'
         s_vec_header(13)='source_id'

c        Assemble header line
         s_line_header_orig=''
         DO i=1,l_header_col
          s_line_header_orig=
     +      TRIM(s_line_header_orig)//TRIM(s_vec_header(i))//'|'

c          print*,'i=',i,TRIM(s_vec_header(i))
c          print*,TRIM(s_line_header_orig)
         ENDDO

         l_len_header_orig=LEN_TRIM(s_line_header_orig)
         l_len_header=l_len_header_orig-1
         s_line_header=s_line_header_orig(1:l_len_header)
 
c        convert integer heade line length to string
         WRITE(s_len_header,'(i3)') l_len_header

c         print*,'l_header_col=',l_header_col
c         print*,'l_len_header=',l_len_header
c         print*,'s_len_header=',TRIM(s_len_header)
c         print*,'s_line_header_orig='//TRIM(s_line_header_orig)//'='
c         print*,'s_line_header='//TRIM(s_line_header)//'='
c         print*,'l_cnt_triplet=',l_cnt_triplet

c        Output header line
         s_fmt_header='a'//TRIM(ADJUSTL(s_len_header)) 
         WRITE(2,'('//s_fmt_header//')') 
     +     ADJUSTL(s_line_header)   !good
c******
c        Cycle through data
         DO i=1,l_cnt_triplet

c********
c         Assemble each of 13 parameters

c         1.primary_id
          s_primary_id=
     +      TRIM(s_networktype_single)//'-'//TRIM(s_platformid_single)
          s_vec_data(1)=TRIM(s_primary_id)
c***
c         2.record_number
c         convert integer heade line length to string
c          WRITE(s_record_number,'(i5)') i
          s_record_number=TRIM(s_vec_index(i))
          s_vec_data(2)=TRIM(s_record_number)
c***
c         3.secondary_id       
          s_secondary_id=''
          s_vec_data(3)=TRIM(s_secondary_id)
c***
c         4.station_name
          s_station_name=TRIM(s_metasingle_name)
          s_vec_data(4)=TRIM(s_station_name)
c***
c         5.longitude
          s_longitude=TRIM(s_vec_longitude(i))
          s_vec_data(5)=TRIM(s_longitude)
c***     
c         6.latitude
          s_latitude=TRIM(s_vec_latitude(i))
          s_vec_data(6)=TRIM(s_latitude)
c***  
c         7.height
          s_height=TRIM(s_vec_height(i))
          s_vec_data(7)=TRIM(s_height)
c***
c         8.start_date
          s_start_date=TRIM(s_vec_year_st(i))
          s_vec_data(8)=TRIM(s_start_date)
c***
c         9.end_date
          s_end_date=TRIM(s_vec_year_en(i))
          s_vec_data(9)=TRIM(s_end_date)
c***
c         10.operating territory
          s_operating_territory=TRIM(s_metasingle_cdmlandcode)
          s_vec_data(10)=TRIM(s_operating_territory)
c***
c         11.observed_variables
          s_observed_variables=TRIM(s_vec_assemble_varcode(i))
          s_vec_data(11)=TRIM(s_observed_variables)
c***
c         12.location accuracy
          s_location_accuracy='0.1'
          s_vec_data(12)=TRIM(s_location_accuracy)
c***
c         13.source_id
          IF ( TRIM(s_networktype_single).EQ.'WMO') THEN
           s_source_id='220'
          ENDIF
          IF ( TRIM(s_networktype_single).EQ.'AFWA') THEN
           s_source_id='221'
          ENDIF
          IF ( TRIM(s_networktype_single).EQ.'ICAO') THEN
           s_source_id='223'
          ENDIF
          s_vec_data(13)=TRIM(s_source_id)

c***
c          print*,'s_vec_data=',(TRIM(s_vec_data(j))//'|',j=1,13)
c***
c         Assemble data line
          s_line_data_orig=''
          DO j=1,l_header_col
           s_line_data_orig=
     +      TRIM(s_line_data_orig)//TRIM(s_vec_data(j))//'|'
          ENDDO

          l_len_data_orig=LEN_TRIM(s_line_data_orig)
          l_len_data=l_len_data_orig-1
          s_line_data=s_line_data_orig(1:l_len_data)

c         convert integer heade line length to string
          WRITE(s_len_data,'(i3)') l_len_data

          IF (l_len_data.GE.300) THEN 
           print*,'data line length over 300'
           STOP 'assemble_triplet_lines_stnconfig'
          ENDIF

c         Output data line
          s_fmt_data='a'//TRIM(ADJUSTL(s_len_data)) 
          WRITE(2,'('//s_fmt_data//')') 
     +     ADJUSTL(s_line_data)   !good

c          print*,'s_fmt_data='//s_fmt_data//'='
c********

         ENDDO   !close i
c******
       CLOSE(UNIT=2)
      ENDIF
c****
c****
c****
c     Case of old file
      IF (s_filestatus1.EQ.'OLD') THEN 
       OPEN(UNIT=2,
     +   FILE=TRIM(s_pathandname),
     +   FORM='formatted',
     +   STATUS='OLD',ACTION='WRITE',ACCESS='APPEND')
c******
c        Cycle through data
         DO i=1,l_cnt_triplet

c********
c         Assemble each of 13 parameters

c         1.primary_id
          s_primary_id=
     +      TRIM(s_networktype_single)//'-'//TRIM(s_platformid_single)
          s_vec_data(1)=TRIM(s_primary_id)
c***
c         2.record_number
c         convert integer heade line length to string
c          WRITE(s_record_number,'(i5)') i
          s_record_number=TRIM(s_vec_index(i))
          s_vec_data(2)=TRIM(s_record_number)
c***
c         3.secondary_id       
          s_secondary_id=''
          s_vec_data(3)=TRIM(s_secondary_id)
c***
c         4.station_name
          s_station_name=TRIM(s_metasingle_name)
          s_vec_data(4)=TRIM(s_station_name)
c***
c         5.longitude
          s_longitude=TRIM(s_vec_longitude(i))
          s_vec_data(5)=TRIM(s_longitude)
c***     
c         6.latitude
          s_latitude=TRIM(s_vec_latitude(i))
          s_vec_data(6)=TRIM(s_latitude)
c***  
c         7.height
          s_height=TRIM(s_vec_height(i))
          s_vec_data(7)=TRIM(s_height)
c***
c         8.start_date
          s_start_date=TRIM(s_vec_year_st(i))
          s_vec_data(8)=TRIM(s_start_date)
c***
c         9.end_date
          s_end_date=TRIM(s_vec_year_en(i))
          s_vec_data(9)=TRIM(s_end_date)
c***
c         10.operating territory
          s_operating_territory=TRIM(s_metasingle_cdmlandcode)
          s_vec_data(10)=TRIM(s_operating_territory)
c***
c         11.observed_variables
          s_observed_variables=TRIM(s_vec_assemble_varcode(i))
          s_vec_data(11)=TRIM(s_observed_variables)
c***
c         12.location accuracy
          s_location_accuracy='0.1'
          s_vec_data(12)=TRIM(s_location_accuracy)
c***
c         13.source_id
          IF ( TRIM(s_networktype_single).EQ.'WMO') THEN
           s_source_id='220'
          ENDIF
          IF ( TRIM(s_networktype_single).EQ.'AFWA') THEN
           s_source_id='221'
          ENDIF
          IF ( TRIM(s_networktype_single).EQ.'ICAO') THEN
           s_source_id='223'
          ENDIF
          s_vec_data(13)=TRIM(s_source_id)

c***
c          print*,'s_vec_data=',(TRIM(s_vec_data(j))//'|',j=1,13)
c***
c         Assemble data line
          s_line_data_orig=''
          DO j=1,l_header_col
           s_line_data_orig=
     +      TRIM(s_line_data_orig)//TRIM(s_vec_data(j))//'|'
          ENDDO

          l_len_data_orig=LEN_TRIM(s_line_data_orig)
          l_len_data=l_len_data_orig-1
          s_line_data=s_line_data_orig(1:l_len_data)

c         convert integer heade line length to string
          WRITE(s_len_data,'(i3)') l_len_data

          IF (l_len_data.GE.300) THEN 
           print*,'data line length over 300'
           STOP 'assemble_triplet_lines_stnconfig'
          ENDIF

c         Output data line
          s_fmt_data='a'//TRIM(ADJUSTL(s_len_data)) 
          WRITE(2,'('//s_fmt_data//')') 
     +     ADJUSTL(s_line_data)   !good

c          print*,'s_fmt_data='//s_fmt_data//'='
c********

         ENDDO   !close i
c******
       CLOSE(UNIT=2)

      ENDIF
c************************************************************************

c      print*,'just leaving assemble_triplet_lines_stn'

      RETURN
      END
