c     Subroutine to find histogram
c     AJ_Kettle, 11Jan2019

      SUBROUTINE find_hist_dailyprecision2(l_pattern,s_pattern,
     +   l_char,s_singlechar_vec,
     +   i_hist_single,i_populated)

      IMPLICIT NONE
c************************************************************************
c     Declare variables passed into program

      INTEGER             :: l_pattern
      CHARACTER(LEN=1)    :: s_pattern(11)
      INTEGER             :: l_char
      CHARACTER(LEN=1)    :: s_singlechar_vec(50)

      INTEGER             :: i_hist_single(11)
      INTEGER             :: i_populated
c*****
c     Variables used in subroutine      

      INTEGER             :: i,j,k,ii,jj,kk
c************************************************************************
c     Initialize histogram
      DO i=1,l_pattern
       i_hist_single(i)=0
      ENDDO

      i_populated=0     !initialize i_populated variable

      IF (l_char.GT.0) THEN
       DO j=1,l_char
        DO i=1,l_pattern
         IF (TRIM(s_singlechar_vec(j)).EQ.TRIM(s_pattern(i))) THEN 
          i_hist_single(i)=i_hist_single(i)+1
          GOTO 10
         ENDIF
        ENDDO

c       If here then problem
        print*,'Character not found='//s_singlechar_vec(j)//'='
        STOP 'find_hist_dailyprecision'

 10     CONTINUE
       ENDDO

c      Count number occupied elements in histogram
       ii=0
       DO i=1,l_pattern
        IF (i_hist_single(i).GE.1) THEN 
         ii=ii+1
        ENDIF
       ENDDO
       i_populated=ii

c       print*,'i_hist_single=',(i_hist_single(i),i=1,l_pattern)
c       print*,'i_populated=',i_populated

      ENDIF
c*****

      RETURN
      END
