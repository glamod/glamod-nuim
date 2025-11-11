c     Subroutine to get alternative letters
c     AJ_Kettle, 29Nov2019

      SUBROUTINE find_altern_letter(i,l_lines,l_rgh_lines,
     +   i_cnt_sourcelett,s_mat_sourcelett,
     +   s_vec_tmax_sourcelett,i_vec_tmax_test2_flag,
     +   i_flag_cat2,i_cnt_cat2_allcase)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into subroutine

      INTEGER             :: i
      INTEGER             :: l_lines
      INTEGER             :: l_rgh_lines

      INTEGER             :: i_cnt_sourcelett(l_rgh_lines)
      CHARACTER(LEN=1)    :: s_mat_sourcelett(l_rgh_lines,6)

      CHARACTER(LEN=1)    :: s_vec_tmax_sourcelett(l_rgh_lines)
      INTEGER             :: i_vec_tmax_test2_flag(l_rgh_lines)

      INTEGER             :: i_flag_cat2
      INTEGER             :: i_cnt_cat2_allcase
c*****
c     Variables used in subroutine

      INTEGER             :: ii,jj,kk

      INTEGER             :: i_len
c************************************************************************

c*****
c     Horizontal test

c     no other source letters
      IF (i_cnt_sourcelett(i).EQ.0) THEN
       i_vec_tmax_test2_flag(i)=2  !set bad flag because no alternatives 

c         i_flag_cat2=1

c      go to vertical test
       GOTO 10
      ENDIF
c     1+ other source letter
      IF (i_cnt_sourcelett(i).GE.1) THEN
       i_vec_tmax_test2_flag(i)=1  !set good flag because one alternative 
       s_vec_tmax_sourcelett(i)=s_mat_sourcelett(i,1)

c      Exit analysis
       GOTO 20
      ENDIF

 10   CONTINUE

c*****
c     Vertical test - using previous index
      IF (i.GT.1) THEN 
       i_len=LEN_TRIM(s_vec_tmax_sourcelett(i-1))
       IF (i_len.GE.1) THEN
        i_vec_tmax_test2_flag(i)=1  !set good flag because one alternative 
        s_vec_tmax_sourcelett(i)=s_vec_tmax_sourcelett(i-1)
c       Exit analysis
        GOTO 20
       ENDIF
      ENDIF

c     Vertical test - using following index
      IF (i.LT.l_lines) THEN 
       i_len=LEN_TRIM(s_vec_tmax_sourcelett(i+1))
       IF (i_len.GE.1) THEN
        i_vec_tmax_test2_flag(i)=1  !set good flag because one alternative 
        s_vec_tmax_sourcelett(i)=s_vec_tmax_sourcelett(i+1)
c       Exit analysis
        GOTO 20
       ENDIF
      ENDIF

c      IF (i.GT.1) THEN 
c       IF (i_cnt_sourcelett(i-1).GE.1) THEN
c        i_vec_tmax_test2_flag(i)=1  !set good flag because one alternative 
c        s_vec_tmax_sourcelett(i)=s_mat_sourcelett(i-1,1)
cc       Exit analysis
c        GOTO 20
c       ENDIF
c      ENDIF

cc     Vertical test - using following index
c      IF (i.LT.l_lines) THEN 
c       IF (i_cnt_sourcelett(i-1).GE.1) THEN
c        i_vec_tmax_test2_flag(i)=1  !set good flag because one alternative 
c        s_vec_tmax_sourcelett(i)=s_mat_sourcelett(i-1,1)
cc       Exit analysis
c        GOTO 20
c       ENDIF
c      ENDIF
******
c     If here for any reason then set category 2 flag
      i_flag_cat2=1
      i_cnt_cat2_allcase=i_cnt_cat2_allcase+1
c*****
 20   CONTINUE

      RETURN
      END
