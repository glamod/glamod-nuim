c     Subroutine to find distinct elements in vector
c     AJ_Kettle, 02Jul2019

      SUBROUTINE get_strvector_distinct(l_channel,l_vec,
     +   s_vec_obscode_fulllist,
     +   l_distinct,s_vec_obscode_distinct)

      IMPLICIT NONE
c************************************************************************
c     Declare variables passed into program
    
      INTEGER             :: l_channel

      INTEGER             :: l_vec
      CHARACTER(LEN=*)    :: s_vec_obscode_fulllist(l_channel)

      INTEGER             :: l_distinct
      CHARACTER(LEN=*)    :: s_vec_obscode_distinct(l_channel)
c*****
c     Variables used in subroutine
 
      INTEGER             :: i,j,k,ii,jj,kk

      CHARACTER(LEN=3)    :: s_distinct(l_channel)
      INTEGER             :: i_vec_cnt(l_channel)
c************************************************************************
c      print*,'just inside get_strvector_distinct'

c      print*,'l_channel=',l_channel
c      print*,'l_vec=',l_vec
c      print*,'s_vec_obscode_fulllist',
c     +   ('='//TRIM(s_vec_obscode_fulllist(i))//'=',i=1,l_vec)

c     Initialize count variable
      DO i=1,l_channel
       i_vec_cnt(i)=0
      ENDDO

      ii=0
      ii=ii+1
      s_vec_obscode_distinct(ii)=s_vec_obscode_fulllist(1)
      i_vec_cnt(ii)=i_vec_cnt(ii)+1

      DO i=2,l_vec
       DO j=1,ii 
        IF (TRIM(s_vec_obscode_fulllist(i)).EQ.
     +      TRIM(s_vec_obscode_distinct(j))) THEN 
         i_vec_cnt(j)=i_vec_cnt(j)+1

         GOTO 10
        ENDIF
       ENDDO

c      If here, the must augment distinct list
       ii=ii+1
       s_vec_obscode_distinct(ii)=s_vec_obscode_fulllist(i)
       i_vec_cnt(ii)=i_vec_cnt(ii)+1

 10    CONTINUE

      ENDDO

      l_distinct=ii

c      print*,'l_distinct=',l_distinct
c      print*,'i_vec_cnt=',(i_vec_cnt(i),i=1,l_distinct)
c      print*,'s_vec_obscode_distinct',
c     +  ('='//TRIM(s_vec_obscode_distinct(i))//'=',i=1,l_distinct)

c      print*,'just leaving get_strvector_distinct'

      RETURN
      END
