c     Subroutine to write single iff files
c     AJ_Kettle, 30Jun2019
c     06Aug2019: modified s_input index from 2 to 5
c     06Aug2019: modified OPEN command to replace files
c     18Mar2020: used for USAF update

      SUBROUTINE iff_write_file(i_input,i_0good_1bad_2zero,
     +   s_directory_outfile_iff_use,s_networktype,s_platformid,
     +   s_paramname,s_paramunit,
     +   s_metasingle_name,
     +   l_c1,l_c2,l_rgh_datalines,l_data,
     +   s_vec_platformid,s_vec_networktype,
     +   s_vec_ncdc_ob_time,s_vec_reporttypecode,
     +   s_vec_latitude,s_vec_longitude,s_vec_platformheight,
     +   s_vec_windspeed_ms,s_vec_windspeed_qc,
     +   s_vec_date_dd_mm_yyyy,s_vec_time_hh_mm_ss,
     +   i_vec_triplet_index,
     +   i_triplediff_cnt,
     +   s_st_date_dd_mm_yyyy,s_st_time_hh_mm_ss,
     +   s_en_date_dd_mm_yyyy,s_en_time_hh_mm_ss)

      IMPLICIT NONE
c************************************************************************
      INTEGER             :: i_input
      INTEGER             :: i_0good_1bad_2zero

      CHARACTER(LEN=300)  :: s_directory_outfile_iff_use

      CHARACTER(LEN=300)  :: s_fileuse
      CHARACTER(LEN=30)   :: s_networktype
      CHARACTER(LEN=30)   :: s_platformid

      CHARACTER(LEN=50)   :: s_paramname
      CHARACTER(LEN=50)   :: s_paramunit

      CHARACTER(LEN=100)  :: s_metasingle_name

      INTEGER             :: l_c1,l_c2
      INTEGER             :: l_rgh_datalines
      INTEGER             :: l_data

      CHARACTER(LEN=15)   :: s_vec_platformid(l_rgh_datalines)
      CHARACTER(LEN=15)   :: s_vec_networktype(l_rgh_datalines)
      CHARACTER(LEN=14)   :: s_vec_ncdc_ob_time(l_rgh_datalines)
      CHARACTER(LEN=6)    :: s_vec_reporttypecode(l_rgh_datalines)
      CHARACTER(LEN=15)   :: s_vec_latitude(l_rgh_datalines)
      CHARACTER(LEN=15)   :: s_vec_longitude(l_rgh_datalines)
      CHARACTER(LEN=15)   :: s_vec_platformheight(l_rgh_datalines)

      CHARACTER(LEN=l_c1) :: s_vec_windspeed_ms(l_rgh_datalines)
      CHARACTER(LEN=l_c2) :: s_vec_windspeed_qc(l_rgh_datalines)

      CHARACTER(LEN=10)   :: s_vec_date_dd_mm_yyyy(l_rgh_datalines) 
      CHARACTER(LEN=8)    :: s_vec_time_hh_mm_ss(l_rgh_datalines)

      INTEGER             :: i_vec_triplet_index(l_rgh_datalines)
      INTEGER             :: i_triplediff_cnt
      CHARACTER(LEN=10)   :: s_st_date_dd_mm_yyyy 
      CHARACTER(LEN=8)    :: s_st_time_hh_mm_ss
      CHARACTER(LEN=10)   :: s_en_date_dd_mm_yyyy 
      CHARACTER(LEN=8)    :: s_en_time_hh_mm_ss
c*****
c     Variables used within subroutine

      INTEGER             :: i,j,k,ii,jj,kk

      CHARACTER(LEN=300)  :: s_pathandname 

      CHARACTER(LEN=50)   :: s_vec_header(19)
      CHARACTER(LEN=1000) :: s_header_assemble_pre
      CHARACTER(LEN=1000) :: s_header_assemble

      CHARACTER(LEN=100)  :: s_vec_dataline(19)
      CHARACTER(LEN=1000) :: s_dataline_assemble_pre
      CHARACTER(LEN=1000) :: s_dataline_assemble

      INTEGER             :: i_len

      CHARACTER(LEN=5)    :: s_input
c      CHARACTER(LEN=2)    :: s_input

      CHARACTER(LEN=100)  :: s_source_id_assess

      INTEGER             :: i_len_header
      CHARACTER(LEN=3)    :: s_len_header
      INTEGER             :: i_len_dataline
      CHARACTER(LEN=3)    :: s_len_dataline

      CHARACTER(LEN=4)    :: s_fmt_header
      CHARACTER(LEN=4)    :: s_fmt_dataline

      CHARACTER(LEN=50)   :: s_filename

      CHARACTER(LEN=10)   :: s_single_date_dd_mm_yyyy 
      CHARACTER(LEN=8)    :: s_single_time_hh_mm_ss

      CHARACTER(LEN=4)    :: s_single_year
      CHARACTER(LEN=2)    :: s_single_month
      CHARACTER(LEN=2)    :: s_single_day
      CHARACTER(LEN=2)    :: s_single_hour
      CHARACTER(LEN=2)    :: s_single_minute

      CHARACTER(LEN=100)  :: s_source_id                              !1
      CHARACTER(LEN=100)  :: s_station_id                             !2
      CHARACTER(LEN=100)  :: s_station_name                           !3
      CHARACTER(LEN=100)  :: s_alias_station_name                     !4
      CHARACTER(LEN=100)  :: s_year                                   !5
      CHARACTER(LEN=100)  :: s_month                                  !6
      CHARACTER(LEN=100)  :: s_day                                    !7
      CHARACTER(LEN=100)  :: s_hour                                   !8
      CHARACTER(LEN=100)  :: s_minute                                 !9
      CHARACTER(LEN=100)  :: s_latitude                               !10
      CHARACTER(LEN=100)  :: s_longitude                              !11
      CHARACTER(LEN=100)  :: s_elevation                              !12
      CHARACTER(LEN=100)  :: s_observed_value                         !13
      CHARACTER(LEN=100)  :: s_source_qc_flag                         !14
      CHARACTER(LEN=100)  :: s_original_observed                      !15
      CHARACTER(LEN=100)  :: s_original_observed_units                !16
      CHARACTER(LEN=100)  :: s_report_type_code                       !17
      CHARACTER(LEN=100)  :: s_gravity_corrected_by_source            !18
      CHARACTER(LEN=100)  :: s_homogenization_corrected_by_source     !19

      INTEGER             :: i_timesignal
c************************************************************************
c      print*,'just entered iff_write_file'

c      print*,'i_0good_1bad=',i_0good_1bad

c      print*,'s_directory_outfile_iff_use=',
c     +  TRIM(s_directory_outfile_iff_use)
c      print*,'s_paramname=',TRIM(s_paramname)
c      print*,'s_paramunit=',TRIM(s_paramunit)
c      print*,'s_networktype,s_platformid=',
c     +  TRIM(s_networktype),TRIM(s_platformid)
c*****
c*****
c     Convert triplet index to character
c      WRITE(s_input,'(i2)') i_input
      WRITE(s_input,'(i5)') i_input

c      print*,'i_input,s_input=',i_input,s_input

c     Assessment of source_id to use
      IF (TRIM(s_networktype).EQ.'WMO') THEN 
       s_source_id_assess      ='220'                         !1
      ENDIF
      IF (TRIM(s_networktype).EQ.'AFWA') THEN 
       s_source_id_assess      ='221'                         !1
      ENDIF
      IF (TRIM(s_networktype).EQ.'ICAO') THEN 
       s_source_id_assess      ='223'                         !1
      ENDIF
      IF (TRIM(s_networktype).EQ.'CMANS') THEN 
       s_source_id_assess      ='222'                         !1
      ENDIF

c     Construct filename
c      s_filename=TRIM(s_networktype)//'_'//TRIM(s_platformid)//'_'//
c     +  TRIM(ADJUSTL(s_input))//'_'//TRIM(s_paramname)//'.dat'
      s_filename=TRIM(s_networktype)//TRIM(s_platformid)//'-'//
     +  TRIM(ADJUSTL(s_input))//'_'//TRIM(s_paramname)//'_'//
     +  TRIM(s_source_id_assess)//'.psv'

c      print*,'s_filename=',TRIM(s_filename)
c      STOP 'iff_write_file'

c     accept condition
      IF (i_0good_1bad_2zero.EQ.0) THEN 
       s_pathandname=TRIM(s_directory_outfile_iff_use)//
     +  'Accept/'//
     +  TRIM(s_filename)
      ENDIF
c     reject condition
      IF (i_0good_1bad_2zero.EQ.1) THEN 
       s_pathandname=TRIM(s_directory_outfile_iff_use)//
     +  'Reject/'//
     +  TRIM(s_filename)

       GOTO 90
      ENDIF
c     Latlon0 condition
      IF (i_0good_1bad_2zero.EQ.2) THEN 
       s_pathandname=TRIM(s_directory_outfile_iff_use)//
     +  'Latlon0/'//
     +  TRIM(s_filename)

       GOTO 90
      ENDIF

c      print*,'s_pathandname=',TRIM(s_pathandname)

c*****
c     Open header file for output
      OPEN(UNIT=2,
     +   FILE=TRIM(s_pathandname),
     +   FORM='formatted',
     +   STATUS='REPLACE',ACTION='WRITE')

c      OPEN(UNIT=2,
c     +   FILE=TRIM(s_pathandname),
c     +   FORM='formatted',
c     +   STATUS='NEW',ACTION='WRITE')
c************************************************************************
c     Write out header

      s_vec_header(1)='Source_id'
      s_vec_header(2)='Station_id'
      s_vec_header(3)='Station_name'
      s_vec_header(4)='Alias_station_name'
      s_vec_header(5)='Year'
      s_vec_header(6)='Month'
      s_vec_header(7)='Day'
      s_vec_header(8)='Hour'
      s_vec_header(9)='Minute'
      s_vec_header(10)='Latitude'
      s_vec_header(11)='Longitude'
      s_vec_header(12)='Elevation'
      s_vec_header(13)='Observed_value'
      s_vec_header(14)='Source_QC_flag'
      s_vec_header(15)='Original_observed'
      s_vec_header(16)='Original_observed_units'
      s_vec_header(17)='Report_type_code'
      s_vec_header(18)='Gravity_corrected_by_source'
      s_vec_header(19)='Homogenization_corrected_by_source'

      s_header_assemble_pre=''
      DO i=1,19 
       s_header_assemble_pre=
     +   TRIM(s_header_assemble_pre)//TRIM(s_vec_header(i))//'|'
      ENDDO

      i_len=LEN_TRIM(s_header_assemble_pre)
      s_header_assemble=s_header_assemble_pre(1:i_len-1)

c      print*,'i_len=',i_len
c      print*,'s_header_assemble=',TRIM(s_header_assemble)

c     convert string length to character to format output string
      i_len_header=LEN_TRIM(s_header_assemble)
      WRITE(s_len_header,'(i3)') i_len_header

c     write header to file
      s_fmt_header='a'//TRIM(ADJUSTL(s_len_header))       !s_fmt1
      WRITE(2,'('//s_fmt_header//')') 
     +   ADJUSTL(s_header_assemble)   !good
c************************************************************************
      i_timesignal=0

      DO i=1,l_data

c      key condition for export: variable must have length>0
       IF (LEN_TRIM(s_vec_windspeed_ms(i)).GT.0) THEN

       IF (i_input.EQ.i_vec_triplet_index(i)) THEN 
c*****
c       Archive start & end dates
        IF (i_timesignal.EQ.0) THEN
         s_st_date_dd_mm_yyyy =s_vec_date_dd_mm_yyyy(i)
         s_st_time_hh_mm_ss   =s_vec_time_hh_mm_ss(i)
         i_timesignal=0
        ENDIF
        s_en_date_dd_mm_yyyy =s_vec_date_dd_mm_yyyy(i)
        s_en_time_hh_mm_ss   =s_vec_time_hh_mm_ss(i)
c*****
c       Extract date/time elements
        s_single_date_dd_mm_yyyy=s_vec_date_dd_mm_yyyy(i)
        s_single_time_hh_mm_ss  =s_vec_time_hh_mm_ss(i)

        s_single_year   =s_single_date_dd_mm_yyyy(7:10)
        s_single_month  =s_single_date_dd_mm_yyyy(4:5)
        s_single_day    =s_single_date_dd_mm_yyyy(1:2)
        s_single_hour   =s_single_time_hh_mm_ss(1:2)
        s_single_minute =s_single_time_hh_mm_ss(4:5)

c        print*,'s_year',s_year
c        print*,'s_month',s_month
c        print*,'s_day',s_day
c        print*,'s_hour',s_hour
c        print*,'s_minute',s_minute
c*****
c       Collect data line elements

        s_source_id       =s_source_id_assess            !1
        s_station_id      =TRIM(s_networktype)//TRIM(s_platformid)//
     +    '-'//TRIM(ADJUSTL(s_input)) !2
        s_station_name    =TRIM(s_metasingle_name)       !3
        s_alias_station_name=''                          !4
        s_year            =s_single_year                 !5
        s_month           =s_single_month                !6
        s_day             =s_single_day                  !7
        s_hour            =s_single_hour                 !8
        s_minute          =s_single_minute               !9
        s_latitude        =s_vec_latitude(i)             !10
        s_longitude       =s_vec_longitude(i)            !11
        s_elevation       =s_vec_platformheight(i)       !12
        s_observed_value  =s_vec_windspeed_ms(i)         !13

c       Map USAF qc onto IFF qc
c       map 0(notchecked) onto 3(unknown)
c       map 1(good)       onto 0(passed)
c       map 2(suspect)    onto 1(failed)
c       map 3(erroneous)  onto 1(failed)
c       map 4(calculated) onto 3(unknown)
c       map 5(removed)    onto 3(unknown)
c       map blank         onto 9(missing)
        IF (TRIM(s_vec_windspeed_qc(i)).EQ.'0') THEN   
         s_source_qc_flag  ='3'                          !14
        ENDIF
        IF (TRIM(s_vec_windspeed_qc(i)).EQ.'1') THEN 
         s_source_qc_flag  ='0'                          !14
        ENDIF
        IF (TRIM(s_vec_windspeed_qc(i)).EQ.'2') THEN
         s_source_qc_flag  ='1'                          !14
        ENDIF
        IF (TRIM(s_vec_windspeed_qc(i)).EQ.'3') THEN
         s_source_qc_flag  ='1'                          !14
        ENDIF
        IF (TRIM(s_vec_windspeed_qc(i)).EQ.'4') THEN
         s_source_qc_flag  ='3'                          !14
        ENDIF
        IF (TRIM(s_vec_windspeed_qc(i)).EQ.'5') THEN
         s_source_qc_flag  ='3'                          !14
        ENDIF
        IF (TRIM(s_vec_windspeed_qc(i)).EQ.'') THEN 
         s_source_qc_flag  ='9'                          !14
        ENDIF

        s_original_observed=s_vec_windspeed_ms(i)        !15
        s_original_observed_units=s_paramunit            !16
        s_report_type_code=s_vec_reporttypecode(i)       !17
        s_gravity_corrected_by_source=''                 !18
        s_homogenization_corrected_by_source=''          !19
c*****
c       Assign data line vector elements

        s_vec_dataline(1) =s_source_id
        s_vec_dataline(2) =s_station_id
        s_vec_dataline(3) =s_station_name
        s_vec_dataline(4) =s_alias_station_name
        s_vec_dataline(5) =s_year
        s_vec_dataline(6) =s_month
        s_vec_dataline(7) =s_day
        s_vec_dataline(8) =s_hour
        s_vec_dataline(9) =s_minute
        s_vec_dataline(10)=s_latitude
        s_vec_dataline(11)=s_longitude
        s_vec_dataline(12)=s_elevation
        s_vec_dataline(13)=s_observed_value
        s_vec_dataline(14)=s_source_qc_flag
        s_vec_dataline(15)=s_original_observed
        s_vec_dataline(16)=s_original_observed_units
        s_vec_dataline(17)=s_report_type_code
        s_vec_dataline(18)=s_gravity_corrected_by_source
        s_vec_dataline(19)=s_homogenization_corrected_by_source
        
c        DO j=1,19
c         print*,j,'='//TRIM(s_vec_dataline(j))//'='
c        ENDDO

c       Create long dataline string
        s_dataline_assemble_pre=''
        DO j=1,19
         s_dataline_assemble_pre=
     +    TRIM(s_dataline_assemble_pre)//TRIM(s_vec_dataline(j))//'|'
        ENDDO

        i_len=LEN_TRIM(s_dataline_assemble_pre)
        s_dataline_assemble=s_dataline_assemble_pre(1:i_len-1)

c        print*,'i_len=',i_len
c        print*,'s_dataline_assemble=',TRIM(s_dataline_assemble)

c       convert string length to character to format output string
        i_len_dataline=LEN_TRIM(s_dataline_assemble)
        WRITE(s_len_dataline,'(i3)') i_len_dataline

c        print*,'s_dataline_assemble=',
c     +    TRIM(s_dataline_assemble(1:i_len_dataline)) 

c       write header to file
        s_fmt_dataline='a'//TRIM(ADJUSTL(s_len_dataline))       !s_fmt1
        WRITE(2,'(t1,'//TRIM(s_fmt_dataline)//')') 
     +   ADJUSTL(s_dataline_assemble)   !good

c        print*,'s_fmt_dataline=',s_fmt_dataline

c        DO j=1,i_len_dataline
c         print*,'j..',j,s_dataline_assemble(j:j)
c        ENDDO
c*****
c        STOP 'iff_write_file'
c*****
       ENDIF
       ENDIF
      ENDDO
c*****
      CLOSE(UNIT=2)

 90   CONTINUE

c      print*,'just leaving iff_write_file'
c      STOP 'iff_write_file'

      RETURN
      END
