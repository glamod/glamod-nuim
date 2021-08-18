c     Subroutine to find number of elements
c     AJ_Kettle, 04Jan2019
c     01Dec2019: modified for qff analysis

      SUBROUTINE find_number_elements(l_rgh_lines,i_good,
     +  s_charlist_single,
     +  l_numelement,s_listelement,i_histelement)

      IMPLICIT NONE
c************************************************************************
c     Variables brought into program

      INTEGER             :: l_rgh_lines
      INTEGER             :: i_good
      CHARACTER(LEN=*)    :: s_charlist_single(l_rgh_lines)

      INTEGER             :: l_numelement
      CHARACTER(LEN=*)    :: s_listelement(12)  
      INTEGER             :: i_histelement(12)
c*****
c     Variables used in program

      INTEGER             :: i,j,k,ii,jj,kk
    
c************************************************************************
c      print*,'just inside find_number_elements'

c      print*,'i_good=',i_good
c      DO i=1,i_good
c       print*,'i,s_charlist_single=',i,s_charlist_single(i)
c      ENDDO

c     Initialize histogram
      DO i=1,12
       i_histelement(i)=0
      ENDDO

      l_numelement=0
      l_numelement=l_numelement+1
      s_listelement(l_numelement)=s_charlist_single(1)
      i_histelement(l_numelement)=i_histelement(l_numelement)+1

c     Cycle through elements of original vector
      DO i=2,i_good 

       DO j=1,l_numelement
        IF (TRIM(s_charlist_single(i)).EQ.TRIM(s_listelement(j))) THEN 
         i_histelement(j)=i_histelement(j)+1

         GOTO 10
        ENDIF
       ENDDO

c      If here then must augment s_listelement
       l_numelement=l_numelement+1

       IF (l_numelement.GT.12) THEN 
        print*,'l_numelement=',l_numelement
        STOP 'find_number_elements; l_numelement>12'
       ENDIF

       s_listelement(l_numelement)=s_charlist_single(i)
       i_histelement(l_numelement)=i_histelement(l_numelement)+1

 10    CONTINUE

      ENDDO

c      print*,'just leaving find_number_elements'

      RETURN
      END
