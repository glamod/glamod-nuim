c     Subroutine to isolate single name from full path
c     AJ_Kettle, 03Dec2019

      SUBROUTINE isolate_single_name(s_file_single,s_stnname_isolated)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into subroutine

      CHARACTER(LEN=300)  :: s_file_single
      CHARACTER(LEN=300)  :: s_stnname_isolated
c*****
c     Variables used in subroutine

      INTEGER             :: i,j,k,ii,jj,kk

      INTEGER             :: i_len
      INTEGER             :: i_cnt
      INTEGER             :: i_pos_slash
      INTEGER             :: i_pos_period
c************************************************************************
c      print*,'just entered isolate_single_name'

      i_len=LEN_TRIM(s_file_single)

c      print*,'i_len=',i_len

      i_cnt=0
      DO j=1,i_len
       IF (s_file_single(j:j).EQ.'/') THEN
        i_pos_slash=j
        i_cnt=i_cnt+1
       ENDIF
       IF (s_file_single(j:j).EQ.'.') THEN
        i_pos_period=j
       ENDIF
      ENDDO

      s_stnname_isolated=s_file_single(i_pos_slash+1:i_pos_period-1)

c      print*,'i_cnt=',i_cnt
c      print*,'i_pos_slash,i_pos_period=',i_pos_slash,i_pos_period
c      print*,'s_stnname_isolated=','|'//TRIM(s_stnname_isolated)//'|'

c      print*,'just leaving isolate_single_name'

c      STOP 'isolate_single_name'

      RETURN
      END
