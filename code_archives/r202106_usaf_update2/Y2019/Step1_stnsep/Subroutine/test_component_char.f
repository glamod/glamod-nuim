c     Subroutine to rebuild string with good characters
c     AJ_Kettle, Feb24/2018
c     13FEB2019: subroutine used in new processing of USAF dataset
c     17Jan2020: update USAF files

      SUBROUTINE test_component_char(s_ref1_pre,
     +    l_ascii,i_list_ascii,s_list_asciichar,
     +    s_ref1,i_cntbadchar_ref1,i_idbadascii_ref1)

      IMPLICIT NONE
c************************************************************************
      CHARACTER(LEN=20)   :: s_ref1_pre
      CHARACTER(LEN=20)   :: s_ref1
      INTEGER             :: l_ascii
      INTEGER             :: i_list_ascii(62)
      CHARACTER(LEN=1)    :: s_list_asciichar(62)
      INTEGER             :: i_cntbadchar_ref1
      INTEGER             :: i_idbadascii_ref1

      INTEGER             :: i,j,k,ii,jj,kk

      CHARACTER(LEN=1)    :: s_singlechar
      INTEGER             :: i_len
      INTEGER             :: i_ascii_get
c************************************************************************
c      print*,'just inside test_component_char2'

      i_len=LEN_TRIM(s_ref1_pre)

c      print*,'s_ref1_pre'//TRIM(s_ref1_pre)//'x'
c      print*,'i_len=',i_len

c     Initialize counters
      i_cntbadchar_ref1=0
      i_idbadascii_ref1=-9

      s_ref1=''            !initialize character string

      DO i=1,i_len 
       s_singlechar=s_ref1_pre(i:i)
       i_ascii_get=ICHAR(s_singlechar)
      
c       print*,'s_singlechar=',i,s_singlechar

c      test single characters against good list
       DO j=1,l_ascii
        IF (s_singlechar.EQ.s_list_asciichar(j)) THEN 
c        Good character section: rebuild name & exit inside loop
         s_ref1=TRIM(s_ref1)//s_singlechar
         GOTO 10
        ENDIF
       ENDDO

c      Bad character section
       i_cntbadchar_ref1=i_cntbadchar_ref1+1
       i_idbadascii_ref1=i_ascii_get

10     CONTINUE

      ENDDO

c      print*,'rebuilt name'
c      print*,'s_ref1'//TRIM(s_ref1)//'x'
c      print*,'i_cntbadchar_ref1',i_cntbadchar_ref1
c************************************************************************
c      print*,'just leaving test_component_char2'

      RETURN
      END
