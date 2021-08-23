c     Subroutine to output last index
c     AJ_Kettle, 18Mar2019

      SUBROUTINE export_last_index(s_directory_outfile_lastfile,
     +  s_filename,s_networktype,s_platformid,i_index)

      IMPLICIT NONE
c************************************************************************
c     Declare variables 

      CHARACTER(LEN=*)    :: s_directory_outfile_lastfile
      CHARACTER(LEN=*)    :: s_filename

      CHARACTER(LEN=*)    :: s_networktype
      CHARACTER(LEN=*)    :: s_platformid

      INTEGER             :: i_index
c*****
c     Variables used in subroutine

      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: io

      INTEGER             :: i_len
      INTEGER             :: i_underscore
      INTEGER             :: i_period

      LOGICAL             :: there
      CHARACTER(LEN=300)  :: s_command

      CHARACTER(LEN=300)  :: s_pathandname
c************************************************************************
c      print *,'just entered export_last_index'

c      print*,'s_directory_outfile_lastfile',
c     +  TRIM(s_directory_outfile_lastfile)
c      print*,'s_filename',TRIM(s_filename)
c      print*,'s_shortname_wmo',TRIM(s_shortname_wmo)

c     Separate network & platform
c      i_len=LEN_TRIM(s_shortname_wmo)
c      DO i=1,i_len
c       IF (s_shortname_wmo(i:i).EQ.'_') THEN
c        i_underscore=i
c       ENDIF
c       IF (s_shortname_wmo(i:i).EQ.'.') THEN
c        i_period=i
c       ENDIF
c      ENDDO

c      s_network =s_shortname_wmo(1:i_underscore-1) 
c      s_platform=s_shortname_wmo(i_underscore+1:i_period-1)
c******
      s_pathandname=TRIM(s_directory_outfile_lastfile)//TRIM(s_filename)

c     Inquire if file exists
      INQUIRE(FILE=s_pathandname,EXIST=there)

c     Erase old index archive file
      IF (there) THEN
c      UNIX
       s_command='rm '//TRIM(s_pathandname)
c      MSDOS
c      s_command='del /Q '//TRIM(s_directory_out3)//'lastfile.dat'
c       print*,'s_command',TRIM(s_command)
       CALL SYSTEM(s_command,io)
      ENDIF

      OPEN(UNIT=2,FILE=TRIM(s_pathandname),
     +  FORM='formatted',STATUS='NEW',ACTION='WRITE')      

       WRITE(2,1000,IOSTAT=io) 
     +  ADJUSTL(TRIM(s_networktype)//'_'//TRIM(s_platformid))  !s_subdirectory 
       WRITE(2,1002,IOSTAT=io) i_index
c       WRITE(2,1004,IOSTAT=io) ' ' 
 1000  FORMAT(t1,a14)
 1002  FORMAT(t1,i7)
 1004  FORMAT(t1,a14)

      CLOSE(UNIT=2)

c      print *,'just leaving export_last_index'

c      print*,'s_network=',TRIM(s_network)
c      print*,'s_platform=',TRIM(s_platform)

c      STOP 'export_last_index'

      RETURN
      END
