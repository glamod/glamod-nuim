c     Subroutine to output lines 1 collection
c     AJ_Kettle, 26Apr2021

      SUBROUTINE output_lines_1collection(s_directory_assemstns,
     +    s_single_stn,
     +    l_rgh_char,l_rgh_datalines,
     +    l_lines,s_linsto2,
     +    s_header)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into subroutine

      CHARACTER(LEN=300)  :: s_directory_assemstns
      CHARACTER(LEN=32)   :: s_single_stn

      INTEGER             :: l_rgh_char
      INTEGER             :: l_rgh_datalines

      INTEGER             :: l_lines
      CHARACTER(l_rgh_char):: s_linsto2(l_rgh_datalines)
      CHARACTER(l_rgh_char):: s_header

c*****
c     Variables used in subroutine
      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: io

      CHARACTER(LEN=300)  :: s_pathandname

      LOGICAL             :: there
      CHARACTER(LEN=3)    :: s_filestatus1

      INTEGER             :: i_len
      CHARACTER(LEN=4)    :: s_len

      CHARACTER(l_rgh_char):: s_linsto_single
c************************************************************************
c      print*,'just entering output_lines_1_collection'
 
c      print*,'l_lines=',l_lines

      s_pathandname=TRIM(s_directory_assemstns)//TRIM(s_single_stn)

c      print*,'s_pathandname=',TRIM(s_pathandname)

c      STOP 'output_lines_1collection'

c     Find if file already exists
      INQUIRE(FILE=TRIM(s_pathandname),
     +  EXIST=there)

      IF (there) THEN
       s_filestatus1='OLD'
      ENDIF
      IF (.NOT.(there)) THEN
       s_filestatus1='NEW'
      ENDIF
c*****
c     Place header line here for new file
      IF (s_filestatus1.EQ.'NEW') THEN 

       OPEN(UNIT=5,
     +  FILE=TRIM(s_pathandname),
     +  FORM='formatted',
     +  STATUS='REPLACE',ACTION='WRITE')

       i_len=LEN_TRIM(s_header)
       WRITE(s_len,'(i4)') i_len   !convert string length integer-to-string
       WRITE(5,'(a'//TRIM(s_len)//')') ADJUSTL(s_header)

       CLOSE(UNIT=5)
      ENDIF
c*****
c     Export data lines here

      OPEN(UNIT=5,
     +  FILE=TRIM(s_pathandname),
     +  FORM='formatted',
     +  STATUS='OLD',ACTION='WRITE',ACCESS='APPEND')

      DO i=1,l_lines
c       Create custom format
        s_linsto_single=s_linsto2(i) 
        i_len=LEN_TRIM(s_linsto_single)

        WRITE(s_len,'(i4)') i_len   !convert string length integer-to-string

c        print*,'s_linsto_single='//TRIM(s_linsto_single)//'='
c        print*,'i_len=',i_len
c        print*,'s_len=',TRIM(s_len)

        WRITE(5,'(a'//TRIM(s_len)//')') ADJUSTL(s_linsto2(i))
      ENDDO

      CLOSE(UNIT=5)
c*****
c      print*,'just leaving output_lines_1collection'

c      STOP 'output_lines_1collection'

      RETURN
      END
