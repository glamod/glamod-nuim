c     Subroutine to export lines to cumulative file
c     AJ_Kettle, 10Jan2020
c     27Apr2020: used for first release
c     09Feb2021: used assembled qc table

      SUBROUTINE export_assemble20210209(s_date_st,s_time_st,s_zone_st,
     +   s_pathandname_out,
     +   l_rgh,l_lines,s_vec_lines)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into subroutine

      CHARACTER(LEN=8)    :: s_date_st
      CHARACTER(LEN=10)   :: s_time_st
      CHARACTER(LEN=5)    :: s_zone_st

      CHARACTER(LEN=300)  :: s_pathandname_out
      INTEGER             :: l_rgh
      INTEGER             :: l_lines
      CHARACTER(LEN=1000) :: s_vec_lines(l_rgh) 
c*****
c     Variables used in subroutine
      INTEGER             :: i,j,k,ii,jj,kk

      CHARACTER(LEN=3)    :: s_filestatus1
      LOGICAL             :: there

      CHARACTER(LEN=1000) :: s_line_single
      INTEGER             :: i_len
      CHARACTER(LEN=4)    :: s_len

      CHARACTER(LEN=4)    :: s_fmt_data
c************************************************************************
c      print*,'just entered export_lines_cumfile'

      INQUIRE(FILE=TRIM(s_pathandname_out),
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
     +   FILE=TRIM(s_pathandname_out),
     +   FORM='formatted',
     +   STATUS='REPLACE',ACTION='WRITE')

         WRITE(2,FMT=1002) 'New assembled qc table file             '
         WRITE(2,FMT=1002) '                                        '
         WRITE(2,FMT=1006) 'AJ_Kettle',s_date_st,s_time_st
         WRITE(2,FMT=1002) '                                        '
         WRITE(2,FMT=1002) 'subroutine: export_assemble20210209.f   '
         WRITE(2,FMT=1002) '                                        '
 1002    FORMAT(a40)
 1006    FORMAT(t1,a9,t11,a8,t20,a10)

c      (Note: changed to 2 because first line badly formatted)
       DO i=2,l_lines
        s_line_single=s_vec_lines(i) 

        i_len=LEN_TRIM(s_line_single)
        WRITE(s_len,'(i4)') i_len

c        print*,'i_len=',i_len

        IF (i_len.GE.1000) THEN
         print*,'emergency stop, line too long; i_len=',i_len
         STOP 'export_lines_cumfile'
        ENDIF
        
c       Output data line
        s_fmt_data='a'//TRIM(ADJUSTL(s_len)) 
        WRITE(2,'('//s_fmt_data//')') 
     +     ADJUSTL(s_line_single)   !good

       ENDDO

       CLOSE(UNIT=2)

      ENDIF
c*****
c     Case of old file
      IF (s_filestatus1.EQ.'OLD') THEN 
       OPEN(UNIT=2,
     +   FILE=TRIM(s_pathandname_out),
     +   FORM='formatted',
     +   STATUS='OLD',ACTION='WRITE',ACCESS='APPEND')

c      do not print header in first line
       DO i=2,l_lines
        s_line_single=s_vec_lines(i) 

        i_len=LEN_TRIM(s_line_single)
        WRITE(s_len,'(i4)') i_len

c        print*,'i_len=',i_len

        IF (i_len.GE.1000) THEN
         print*,'emergency stop, line too long; i_len=',i_len
         STOP 'export_lines_cumfile'
        ENDIF
        
c       Output data line
        s_fmt_data='a'//TRIM(ADJUSTL(s_len)) 
        WRITE(2,'('//s_fmt_data//')') 
     +     ADJUSTL(s_line_single)   !good

       ENDDO

       CLOSE(UNIT=2)
      ENDIF
c*****
c      print*,'just leaving export_lines_cumfile'

c      STOP 'export_lines_cumfile'

      RETURN
      END
