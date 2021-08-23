c     Subroutine to create archive file
c     AJ_Kettle, 28Oct2020

      SUBROUTINE create_archive_file(s_directory_3archive,i_index)

      IMPLICIT NONE
c************************************************************************
c     Declare variables 

      CHARACTER(LEN=300)  :: s_directory_3archive
      INTEGER             :: i_index

c*****
c     Variables used in subroutine

      INTEGER             :: i,j,k,ii,jj,kk
      CHARACTER(LEN=4)    :: s_index 
      CHARACTER(LEN=12)   :: s_filename_base
      CHARACTER(LEN=12)   :: s_filename_full

      CHARACTER(LEN=3)    :: s_filestatus1
      LOGICAL             :: there
      CHARACTER(LEN=300)  :: s_pathandname

c************************************************************************
c      print*,'just entered create_archive_file'

      WRITE(s_index,'(i4)') i_index

c      print*,'i_index=',i_index
c      print*,'s_index=',TRIM(s_index)

c     Compose full name
      IF (i_index.GE.0.AND.i_index.LT.10) THEN
       s_filename_base='000'//ADJUSTL(s_index)
      ENDIF
      IF (i_index.GE.10.AND.i_index.LT.100) THEN
       s_filename_base='00'//ADJUSTL(s_index)
      ENDIF
      IF (i_index.GE.100.AND.i_index.LT.1000) THEN
       s_filename_base='0'//ADJUSTL(s_index)
      ENDIF
      IF (i_index.GE.1000.AND.i_index.LT.10000) THEN
       s_filename_base=ADJUSTL(s_index)
      ENDIF

      s_filename_full='f'//TRIM(s_filename_base)//'.dat'

c      print*,'s_filename_base=',TRIM(s_filename_base)
c      print*,'s_filename_full=',TRIM(s_filename_full)
c*****
      s_pathandname=TRIM(s_directory_3archive)//TRIM(s_filename_full)

      INQUIRE(FILE=TRIM(s_pathandname),
     +  EXIST=there)

      IF (there) THEN
       s_filestatus1='OLD'
      ENDIF
      IF (.NOT.(there)) THEN
       s_filestatus1='NEW'
      ENDIF

c      print*,'s_filestatus1=',s_filestatus1
c*****
c     Create file with start flag
      OPEN(UNIT=2,FILE=TRIM(s_pathandname),
     +  FORM='formatted',STATUS='REPLACE',ACTION='WRITE')
      WRITE(2,1002) i_index
 1002 FORMAT(t1,i4)
      WRITE(2,1000) 'st'
 1000 FORMAT(t1,a2)
      CLOSE(UNIT=2)
c*****
c      print*,'just leaving create_archive_file'

c      STOP 'create_archive_file'

      RETURN
      END
