c     Subroutine to export error station
c     AJ_Kettle, 20Apr2020

      SUBROUTINE export_errorfile(
     +    s_directory_output_errorfile,s_filename,s_stnname_single)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into subroutine

      CHARACTER(LEN=300)  :: s_directory_output_errorfile
      CHARACTER(LEN=300)  :: s_filename
      CHARACTER(LEN=12)   :: s_stnname_single
c*****
c     Variables used in subroutine

      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: io

      CHARACTER(LEN=300)  :: s_pathandname
      LOGICAL             :: there

      CHARACTER(LEN=3)    :: s_filestatus1
c************************************************************************
c      print*,'just entered export_errorfile'

      s_pathandname=
     +  TRIM(s_directory_output_errorfile)//TRIM(s_filename)

      INQUIRE(FILE=TRIM(s_pathandname),
     +   EXIST=there)
      IF (there) THEN
        s_filestatus1='OLD'
      ENDIF
      IF (.NOT.(there)) THEN
        s_filestatus1='NEW'
      ENDIF
c*****
      IF (s_filestatus1.EQ.'NEW') THEN 
      OPEN(UNIT=2,
     +   FILE=TRIM(s_pathandname),
     +   FORM='formatted',
     +   STATUS='NEW',ACTION='WRITE')

      WRITE(2,FMT=1002) 'List bad stations                       '
      WRITE(2,FMT=1002) '                                        '
 1002 FORMAT(a40)
      ENDIF

      WRITE(2,FMT=1004) s_stnname_single 
 1004 FORMAT(a12)
      CLOSE(unit=2)

c     Case of old file
      IF (s_filestatus1.EQ.'OLD') THEN 

       OPEN(UNIT=2,
     +   FILE=TRIM(s_pathandname),
     +   FORM='formatted',
     +   STATUS='OLD',ACTION='WRITE',ACCESS='APPEND')
       WRITE(2,FMT=1004) s_stnname_single 
       CLOSE(unit=2)
      ENDIF
c*****
c      print*,'just leaving export_errorfile'

c      STOP 'export_errorfile'

      RETURN
      END
