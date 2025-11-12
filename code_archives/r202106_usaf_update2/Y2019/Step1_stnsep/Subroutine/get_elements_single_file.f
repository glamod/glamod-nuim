c     Subroutine to import elements from single file
c     AJ_Kettle, 29Jan2020

      SUBROUTINE get_elements_single_file(s_file_single,
     +   i_single_index,i_single_flagst,i_single_flagen)

      IMPLICIT NONE
c************************************************************************
c     Declare variables 

      CHARACTER(LEN=300)  :: s_file_single
      INTEGER             :: i_single_index
      INTEGER             :: i_single_flagst
      INTEGER             :: i_single_flagen
c*****
c     Variables used in subroutine

      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: io

      CHARACTER(LEN=300)  :: s_linget
      CHARACTER(LEN=300)  :: s_linsto(7)
      INTEGER             :: l_lines

      INTEGER             :: i_get
c************************************************************************
c      print*,'just entered get_elments_single_file'
c*****
c     Initialize archival vector
      DO i=1,7
       s_linsto(i)=''
      ENDDO
c*****
      ii=0   !initialize counter

      OPEN(UNIT=1,FILE=TRIM(s_file_single),FORM='formatted',
     +  STATUS='OLD',ACTION='READ')      

      DO                         !start loop for all lines in file

c      Read data line
       READ(1,1002,IOSTAT=io) s_linget
1002   FORMAT(a300)           !changed from 3400 to 4000

       IF (io .GT. 0) THEN
        WRITE(*,*) 'Check input. Something went wrong'
        GOTO 100
       ELSE IF (io .LT. 0) THEN 
c        WRITE(*,*) 'end of file reached'
        GOTO 100
       ELSE

c       Line counter
        ii=ii+1
        s_linsto(ii)=s_linget

        IF (ii.GT.7) THEN 
         print*,'emergency stop; too many lines',ii
         STOP 'get_elements_single_file'
        ENDIF

       ENDIF      !main reading condition

      ENDDO

 100  CONTINUE

      CLOSE(UNIT=1)
c*****
      l_lines=ii

c     Find index
      s_linget=TRIM(s_linsto(1))
c      READ(s_linget,*) i_single_index
      READ(s_linget,*) i_get
      i_single_index=i_get

c     Initialize flags to null values
      i_single_flagst=0
      i_single_flagen=0

      IF (TRIM(s_linsto(2)).EQ.'st') THEN
       i_single_flagst=1
      ENDIF
      IF (TRIM(s_linsto(3)).EQ.'en') THEN
       i_single_flagen=1
      ENDIF

c      print*,'l_lines=',l_lines
c      print*,'s_linsto(1)=',TRIM(s_linsto(1))   
c      print*,'s_linsto(2)=',TRIM(s_linsto(2))   
c      print*,'s_linsto(3)=',TRIM(s_linsto(3))

c      print*,'i_get=',i_get
c      print*,'i_single_index=',i_single_index
c      print*,'i_single_flagst=',i_single_flagst
c      print*,'i_single_flagen=',i_single_flagen

c      print*,'just leaving get_elements_single_file'

      RETURN
      END
