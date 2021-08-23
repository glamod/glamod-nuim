c     Subroutine to read in last file index & platform type
c     AJ_Kettle, 
c     21Mar2020: used for USAF index

      SUBROUTINE readin_lastfile_index(s_directory_outfile_lastfile,
     +  s_last_netplat,i_lastindex,i_start)

      IMPLICIT NONE
c************************************************************************
c     Declare variables 

      CHARACTER(LEN=*)    :: s_directory_outfile_lastfile

      CHARACTER(LEN=*)    :: s_last_netplat
      INTEGER             :: i_lastindex
      INTEGER             :: i_start
c*****
c     Variables used in subroutine

      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: io

      CHARACTER(LEN=300)  :: s_pathandname
      LOGICAL             :: there
      CHARACTER(LEN=300)  :: s_command
c************************************************************************
c      print*,'just entered readin_lastfile_index'

      s_pathandname=TRIM(s_directory_outfile_lastfile)//'lastfile.dat'

c     Initialize last completed file info
      s_last_netplat='-999'
      i_lastindex   =-999

c     Inquire if file exists
      INQUIRE(FILE=s_pathandname,EXIST=there)

c     Read info if file exists
      IF (there) THEN
       OPEN(UNIT=2,FILE=TRIM(s_pathandname),
     +  FORM='formatted',STATUS='OLD',ACTION='READ')      

        READ(2,1000,IOSTAT=io) s_last_netplat 
        READ(2,1002,IOSTAT=io) i_lastindex
c        WRITE(2,1004,IOSTAT=io) ADJUSTL(s_shortname_wmo) 
 1000   FORMAT(t1,a20)
 1002   FORMAT(t1,i7)
c 1004   FORMAT(t1,a14)
       CLOSE(UNIT=2)

       i_start=i_lastindex+1
      ENDIF

c     Set defaults if no file exists
      IF (.NOT.there) THEN
c       s_last_networktype='WMO'
       i_start=1      !select 1 if no information file
      ENDIF

c      print*,'s_last_networktype=',s_last_networktype
c      print*,'i_start=',i_start

c      print*,'just leaving readin_lastfile_index'

c      STOP 'readin_lastfile_index'

      RETURN
      END
