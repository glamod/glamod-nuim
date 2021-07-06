c     Subroutine to find histogram parameter elements
c     AJ_Kettle, 06Dec2018

      SUBROUTINE find_hist_param_elements2(l_lines_rgh,l_lines,
     +   s_arch_element,s_param_select)

      IMPLICIT NONE
c************************************************************************
      INTEGER             :: l_lines_rgh
      INTEGER             :: l_lines
      CHARACTER(LEN=4)    :: s_arch_element(l_lines_rgh)
      CHARACTER(LEN=4)    :: s_param_select(9)
c*****
c     Variables used in subroutine

      INTEGER             :: i,j,k,ii,jj,kk
 
      INTEGER             :: i_hist(9)
c************************************************************************
c      print*,'just entering find_hist_param_elements'

c     Initialize vector
      DO j=1,9
       i_hist(j)=0
      ENDDO

      DO i=1,l_lines
       DO j=1,9 
        IF (s_arch_element(i).EQ.s_param_select(j)) THEN
         i_hist(j)=i_hist(j)+1
         GOTO 10
        ENDIF
       ENDDO
 10    CONTINUE
      ENDDO

c      print*,'i_hist=',(i_hist(j),j=1,9)

c      print*,'just leaving find_hist_param_elements'

c      STOP 'find_hist_param_elements'

      RETURN
      END
