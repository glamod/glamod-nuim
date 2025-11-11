c     Subroutine to find string fragment in larger string
c     AJ_Kettle, 18Dec2018

      SUBROUTINE search_stringfragment2(
     +  s_keystring,s_single_secondary_id,i_result)

      IMPLICIT NONE
c************************************************************************
c     Declare variables passed into program

      CHARACTER(LEN=*)    :: s_keystring
      CHARACTER(LEN=*)    :: s_single_secondary_id
      INTEGER             :: i_result
c*****
c     Variables used in subroutine

      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: i_len
c************************************************************************
c      print*,'just entered search_stringfragment'
 
      i_len=LEN_TRIM(s_single_secondary_id)

      DO i=1,i_len-2
       IF (TRIM(s_keystring).EQ.s_single_secondary_id(i:i+1)) THEN
        i_result=1
       ENDIF 
      ENDDO

c      print*,'s_keystring',TRIM(s_keystring)
c      print*,'s_single_secondary_id=',TRIM(s_single_secondary_id)
c      print*,'i_result=',i_result  

c      print*,'just leaving search_stringfragment'

c      STOP 'search_stringfragment'

      RETURN
      END
