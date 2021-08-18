c     Subroutine to get lines from single receipt file
c     AJ_Kettle, 09Jan2020

      SUBROUTINE get_lines_single_qcfile(s_pathandname,
     +   l_rgh,l_lines,s_vec_lines)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into subroutine

      CHARACTER(LEN=300)  :: s_pathandname
      INTEGER             :: l_rgh
      INTEGER             :: l_lines
      CHARACTER(LEN=1000) :: s_vec_lines(l_rgh) 

c*****
c     Variables used in subroutine
      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: io

      CHARACTER(LEN=1000) :: s_single_line
c************************************************************************
c      print*,'just entered get_lines_single_qcfile'
c      print*,'l_rgh=',l_rgh
c      STOP 'get_lines_single_qcfile'

c      print*,'s_pathandname=',TRIM(s_pathandname)

      ii=0

      OPEN(UNIT=2,FILE=TRIM(s_pathandname),
     +  FORM='formatted',STATUS='OLD',ACTION='READ')     

      DO 

c      Read data line
       READ(2,1002,IOSTAT=io) s_single_line
1002   FORMAT(a1000)
       IF (io .GT. 0) THEN
        WRITE(*,*) 'Check input. Something went wrong'
        GOTO 100
       ELSE IF (io .LT. 0) THEN 
c        WRITE(*,*) 'end of file reached'
        GOTO 100
       ELSE

        ii=ii+1

c       Crash program if too many lines
        IF (ii.GT.l_rgh) THEN 
         print*,'emergency stop, too many lines for array,ii=',ii
         STOP 'get_lines_single_qcfile'
        ENDIF

        s_vec_lines(ii)=s_single_line

       ENDIF
      ENDDO                !end of line-counting loop

100   CONTINUE

      CLOSE(UNIT=2)

      l_lines=ii

c      print*,'l_lines=',l_lines
c      DO i=1,l_lines
c       print*,i,TRIM(s_vec_lines(i))
c      ENDDO

c      print*,'just leaving get_lines_single_receiptfile'  

c      STOP 'get_lines_single_receiptfile'

      RETURN
      END
