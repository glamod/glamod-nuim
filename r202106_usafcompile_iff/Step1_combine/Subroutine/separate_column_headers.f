c     Subroutine to get vector column headers
c     AJ_Kettle, 05May2021

      SUBROUTINE separate_column_headers(l_rgh_char,s_header1,
     +  l_header1,s_vec_header1)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into subroutine

      INTEGER             :: l_rgh_char
      CHARACTER(l_rgh_char):: s_header1
      INTEGER             :: l_header1
      CHARACTER(LEN=50)   :: s_vec_header1(200)
c*****
c     Variables used within subroutine

      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: io

      INTEGER             :: i_len
      INTEGER             :: l_comma_cnt
      INTEGER             :: i_comma_pos(200)
      INTEGER             :: i_pos1,i_pos2
      INTEGER             :: i_lenrec(200)
c************************************************************************
c      print*,'just inside separate_column_headers'

      i_len=LEN_TRIM(s_header1)

c      print*,'i_len=',i_len

      l_comma_cnt=0
      DO i=1,i_len
       IF (s_header1(i:i).EQ.',') THEN
        l_comma_cnt=l_comma_cnt+1
        i_comma_pos(l_comma_cnt)=i
       ENDIF
      ENDDO

      l_header1=l_comma_cnt+1

      DO i=1,l_header1
       IF (i.EQ.1) THEN
        i_pos1=1
        i_pos2=i_comma_pos(1)-1
        s_vec_header1(i)=s_header1(i_pos1:i_pos2)
        i_lenrec(i)=LEN_TRIM(s_vec_header1(i))
        GOTO 10
       ENDIF
       IF (i.EQ.l_header1) THEN
        i_pos1=i_comma_pos(l_header1-1)+1
        i_pos2=i_len

c        print*,'i_pos1,i_pos2...',i_pos1,i_pos2
 
        s_vec_header1(i)=s_header1(i_pos1:i_pos2)
        i_lenrec(i)=LEN_TRIM(s_vec_header1(i))
        GOTO 10
       ENDIF

       i_pos1=i_comma_pos(i-1)+1
       i_pos2=i_comma_pos(i)-1
       s_vec_header1(i)=s_header1(i_pos1:i_pos2)
       i_lenrec(i)=LEN_TRIM(s_vec_header1(i))

 10    CONTINUE
      ENDDO      

c      print*,'l_comma_cnt=',l_comma_cnt
c      print*,'i_comma_pos=',(i_comma_pos(i),i=1,l_comma_cnt)

c      DO i=1,l_header1
c       print*,'i...',i,i_lenrec(i),TRIM(s_vec_header1(i))
c      ENDDO

c      print*,'just leaving separate_column_headers'

      RETURN
      END
