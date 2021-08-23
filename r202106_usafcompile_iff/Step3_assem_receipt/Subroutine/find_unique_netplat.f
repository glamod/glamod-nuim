c     Subroutine to find unique netplat
c     AJ_Kettle, 02Jun2021

      SUBROUTINE find_unique_netplat(
     +  l_iff_rgh,l_iff,s_vec_iff_filename,
     +  l_stn_rgh,l_iffuniq,s_vec_iffuniq_netplat)

      IMPLICIT NONE
c************************************************************************
c     Declare variables 
      INTEGER             :: l_iff_rgh
      INTEGER             :: l_iff
      CHARACTER(*)        :: s_vec_iff_filename(l_iff_rgh)

      INTEGER             :: l_stn_rgh
      INTEGER             :: l_iffuniq
      CHARACTER(32)       :: s_vec_iffuniq_netplat(l_stn_rgh)
c*****
c     Variables used in subroutine
      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: io

      INTEGER             :: i_len
      INTEGER             :: i_pos

      CHARACTER(64)       :: s_single
      CHARACTER(32)       :: s_vec_xnetplat(l_iff_rgh)
c************************************************************************
      print*,'just entered find_unique_netplat'

      print*,'s_vec_iff_filename=',TRIM(s_vec_iff_filename(1))
      print*,'l_iff=',l_iff

      DO i=1,l_iff
       i_len=LEN_TRIM(s_vec_iff_filename(i))
       s_single=TRIM(s_vec_iff_filename(i))

c      Find location of dash
       DO j=1,i_len
        IF (s_single(j:j).EQ.'-') THEN 
         i_pos=j
         s_vec_xnetplat(i)=s_single(1:i_pos-1)
c         print*,'extracted:',s_vec_xnetplat(i)
c         STOP 'find_unique_netplat'
c         CALL SLEEP(1)
         GOTO 10
        ENDIF
       ENDDO
 10    CONTINUE
      ENDDO
c*****
c     Find unique netplat
      ii=0
      DO i=1,l_iff-1
       IF (s_vec_xnetplat(i).NE.s_vec_xnetplat(i+1)) THEN
        ii=ii+1
        s_vec_iffuniq_netplat(ii)=s_vec_xnetplat(i)
       ENDIF
      ENDDO
c     final element
      ii=ii+1
      s_vec_iffuniq_netplat(ii)=s_vec_xnetplat(l_iff)

      l_iffuniq=ii
      print*,'l_iffuniq=',l_iffuniq
c*****
c      print*,'i_len=',i_len


      print*,'just leaving find_unique_netplat'

      RETURN
      END
