c     Subroutine to count occupied vector elements
c     AJ_Kettle, 10Oct2019

      SUBROUTINE count_elements_vector(l_channel,s_avec_origdata,
     +   i_count_elements)

      IMPLICIT NONE
c************************************************************************
      INTEGER             :: l_channel
      CHARACTER(LEN=*)    :: s_avec_origdata(l_channel)
      INTEGER             :: i_count_elements
c*****
      INTEGER             :: i,j,k,ii,jj,kk
c************************************************************************

      ii=0

      DO i=1,l_channel
       IF (LEN_TRIM(s_avec_origdata(i)).GT.0) THEN 
        ii=ii+1
       ENDIF
      ENDDO

      i_count_elements=ii

c      print*,'i_count_elements=',i_count_elements

c      STOP 'count_elements_vector'

      RETURN
      END
