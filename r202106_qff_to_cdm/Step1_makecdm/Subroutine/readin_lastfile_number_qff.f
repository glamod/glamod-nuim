c     Subroutine to read in last file number
c     AJ_Kettle, 16Mar2019
c     16Dec2019: moved from daily to qff analysis

      SUBROUTINE readin_lastfile_number_qff(s_directory_lastfile,
     +  i_start)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into program

      CHARACTER(LEN=300)  :: s_directory_lastfile
      INTEGER             :: i_start
c*****
c     Variables used within subroutine
 
      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: io
      LOGICAL             :: there
      INTEGER             :: i_last_index
c************************************************************************
c      print*,'just entered readin_lastfile_number'

c      print*,'s_directory_lastfile',TRIM(s_directory_lastfile)
c      print*,'i_start=',i_start

c      i_start_index=0     !initial to 0

c     Inquire if file exists
      INQUIRE(FILE=TRIM(s_directory_lastfile)//'lastfile.dat',
     +  EXIST=there)

c     assign starting index if file does not exist
      IF (.NOT.there) THEN
       i_start=1
      ENDIF

c     get starting index if file exists
      IF (there) THEN
       OPEN(UNIT=1,FILE=TRIM(s_directory_lastfile)//'lastfile.dat',
     +  FORM='formatted',STATUS='OLD',ACTION='READ')      

c      Read header
       READ(1,1000,IOSTAT=io) i_last_index
 1000  FORMAT(t3,i10)

c       print*,'i_last_index=',i_last_index

       i_start=i_last_index+1    

       CLOSE(UNIT=1)
      ENDIF

c      print*,'i_start=',i_start

c      print*,'just leaving reading_lastfile_number'
c      STOP 'readin_lastfile_number'

      RETURN
      END
