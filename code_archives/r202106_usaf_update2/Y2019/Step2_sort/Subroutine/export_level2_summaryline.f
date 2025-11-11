c     Subroutine to export summary line for station
c     AJ_Kettle, 20Feb2019
c     26Feb2020: adapted for USAF_update file

      SUBROUTINE export_level2_summaryline(s_date_st,s_time_st,
     +   s_directory_file_summary,s_shortname_single,
     +   l_cnt_datalines,
     +   s_ncdc_ob_time_st,s_ncdc_ob_time_en,
     +   i_linelength_min_unsort,i_linelength_max_unsort,
     +   i_commacount_min_unsort,i_commacount_max_unsort,
     +   i_linelength_min_sort,i_linelength_max_sort,
     +   i_commacount_min_sort,i_commacount_max_sort)

      IMPLICIT NONE
c************************************************************************
c     Declare variables 

      CHARACTER(LEN=8)    :: s_date_st
      CHARACTER(LEN=10)   :: s_time_st

      CHARACTER(LEN=*)    :: s_directory_file_summary
      CHARACTER(LEN=*)    :: s_shortname_single

      INTEGER             :: l_cnt_datalines
      CHARACTER(LEN=14)   :: s_ncdc_ob_time_st
      CHARACTER(LEN=14)   :: s_ncdc_ob_time_en
      INTEGER             :: i_linelength_min_unsort
      INTEGER             :: i_linelength_max_unsort
      INTEGER             :: i_commacount_min_unsort
      INTEGER             :: i_commacount_max_unsort
      INTEGER             :: i_linelength_min_sort
      INTEGER             :: i_linelength_max_sort
      INTEGER             :: i_commacount_min_sort
      INTEGER             :: i_commacount_max_sort
c*****
c     Variables used in subroutine
 
      INTEGER             :: i,j,k,ii,jj,kk     

      INTEGER             :: i_len
      CHARACTER(LEN=30)   :: s_shortname_clip

      CHARACTER(LEN=300)  :: s_pathandname

      LOGICAL             :: there
      CHARACTER(LEN=3)    :: s_filestatus1
c************************************************************************
c      print*,'just entered export_level2_summaryline'
c*****
c      Find filename with extension clipped off
       i_len=LEN_TRIM(s_shortname_single)
       DO i=1,i_len
        IF (s_shortname_single(i:i).EQ.'.') THEN 
         s_shortname_clip=s_shortname_single(1:i-1)
        ENDIF
       ENDDO
c*****
c     Output statistics

      s_pathandname=TRIM(s_directory_file_summary)//
     +  'line_length_stats.dat'
c*****
c     Check if file exists
      INQUIRE(FILE=TRIM(s_pathandname),
     +   EXIST=there)
      IF (there) THEN
        s_filestatus1='OLD'
      ENDIF
      IF (.NOT.(there)) THEN
        s_filestatus1='NEW'
      ENDIF
c*****
c     open file for data export
      IF (s_filestatus1.EQ.'NEW') THEN

      OPEN(UNIT=5,
     +  FILE=TRIM(s_pathandname),
     +  FORM='formatted',
     +  STATUS='NEW',ACTION='WRITE')

      WRITE(UNIT=5,FMT=1000) 'Line length and comma count statistics'
      WRITE(UNIT=5,FMT=1000) '                                      '
      WRITE(5,FMT=1006) 'AJ_Kettle',s_date_st,s_time_st
 1006 FORMAT(t1,a9,t11,a8,t20,a10)
      WRITE(UNIT=5,FMT=1000) '                                      '

 1000 FORMAT(t1,a40)

      WRITE(UNIT=5,FMT=1002) 'Station name  ',
     +  'Date/time     ','Date/time     ','Number ',
     +  'MIN ','MAX ','MIN','MAX','MIN ','MAX ','MIN','MAX'
      WRITE(UNIT=5,FMT=1002) '              ',
     +  'Start         ','End           ','Lines  ',
     +  'Line','Line','com','com','Line','Line','com','com'
      WRITE(UNIT=5,FMT=1002) '              ',
     +  'ddmmyyyyhhmmss','ddmmyyyyhhmmss','Data   ',
     +  'Leng','Leng','cnt','cnt','Leng','Leng','cnt','cnt'
      WRITE(UNIT=5,FMT=1002) '              ',
     +  '              ','              ','       ',
     +  'Un- ','Un- ','Un-','Un-','sort','sort','srt','srt'
      WRITE(UNIT=5,FMT=1002) '              ',
     +  '              ','              ','       ',
     +  'sort','sort','srt','srt','    ','    ','   ','   '
      WRITE(UNIT=5,FMT=1002) '+------------+',
     +  '+------------+','+------------+','+-----+',
     +  '+--+','+--+','+-+','+-+','+--+','+--+','+-+','+-+'
 1002 FORMAT(t1,a14,t16,a14,t31,a14,t46,a7,t54,a4,t59,a4,t64,a3,t68,
     +  a3,t72,a4,t77,a4,t82,a3,t86,a3)

      WRITE(UNIT=5,FMT=1003) ADJUSTL(s_shortname_clip),
     +   s_ncdc_ob_time_st,s_ncdc_ob_time_en,
     +   l_cnt_datalines,
     +   i_linelength_min_unsort,i_linelength_max_unsort,
     +   i_commacount_min_unsort,i_commacount_max_unsort,
     +   i_linelength_min_sort,i_linelength_max_sort,
     +   i_commacount_min_sort,i_commacount_max_sort

 1003 FORMAT(t1,a14,t16,a14,t31,a14,t46,i7,t54,i4,t59,i4,t64,i3,t68,
     +  i3,t72,i4,t77,i4,t82,i3,t86,i3)

      CLOSE(UNIT=5)

      ENDIF

c     Append old file 
      IF (s_filestatus1.EQ.'OLD') THEN
       OPEN(UNIT=5,
     +  FILE=TRIM(s_pathandname),
     +  FORM='formatted',
     +  STATUS='OLD',ACTION='WRITE',ACCESS='APPEND')

        WRITE(UNIT=5,FMT=1003) ADJUSTL(s_shortname_clip),
     +   s_ncdc_ob_time_st,s_ncdc_ob_time_en,
     +   l_cnt_datalines,
     +   i_linelength_min_unsort,i_linelength_max_unsort,
     +   i_commacount_min_unsort,i_commacount_max_unsort,
     +   i_linelength_min_sort,i_linelength_max_sort,
     +   i_commacount_min_sort,i_commacount_max_sort

       CLOSE(UNIT=5)
      ENDIF

c      print*,'just leaving export_level2_summaryline'

c      STOP 'export_level2_summaryline'

      RETURN
      END
