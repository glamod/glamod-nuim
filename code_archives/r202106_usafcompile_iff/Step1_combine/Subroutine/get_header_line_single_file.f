c     Subroutine to get header of 1 file
c     AJ_Kettle, 05May2021

      SUBROUTINE get_header_line_single_file(s_directory_dataroot,
     +  s_single_stn,l_rgh_char,
     +  s_header)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into subroutine

      CHARACTER(LEN=300)  :: s_directory_dataroot
      CHARACTER(LEN=32)   :: s_single_stn

      INTEGER             :: l_rgh_char
      CHARACTER(l_rgh_char):: s_header
c*****
c     Variables used in subroutine
      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: io

      CHARACTER(LEN=300)  :: s_pathandname
      CHARACTER(l_rgh_char):: s_linget

c************************************************************************

      print*,'get_header_line_single_file'

      s_pathandname=
     + TRIM(s_directory_dataroot)//TRIM(s_single_stn)

      print*,'s_pathandname='//TRIM(s_pathandname)//'='

      OPEN(UNIT=5,FILE=TRIM(s_pathandname),
     +  FORM='formatted',STATUS='OLD',ACTION='READ')

      DO 
       READ(5,1002,IOSTAT=io) s_linget   
 1002  FORMAT(a4000)

       IF (io .GT. 0) THEN
        WRITE(*,*) 'Check input. Something went wrong'
        GOTO 100
       ELSE IF (io .LT. 0) THEN
c        WRITE(*,*) 'end of file reached'
        GOTO 100
       ELSE

c       Condition for getting header
        IF (s_linget(1:8).EQ.'PLATFORM'.OR.
     +      s_linget(1:8).EQ.'platform') THEN 
         s_header=s_linget
         GOTO 100
        ENDIF

       ENDIF
      ENDDO
 100  CONTINUE
      CLOSE(UNIT=5)

c      print*,'s_header='//TRIM(s_header)//'='

c      STOP 'get_header_line_single_file'

      RETURN
      END
