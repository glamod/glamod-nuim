c     Subroutine to verify that stn name agrees with all elements of file       
c     AJ_Kettle, 04Dec2018

      SUBROUTINE verify_stn_id2(s_stnname_single,
     +   l_lines_rgh,l_lines,s_arch_id)

      IMPLICIT NONE
c************************************************************************
c     Declare variables passed into program

      CHARACTER(LEN=12)   :: s_stnname_single
      INTEGER             :: l_lines_rgh
      INTEGER             :: l_lines
      CHARACTER(LEN=12)   :: s_arch_id(l_lines_rgh)
c*****
c     Declare variables used in program

      INTEGER             :: i,j,k,ii,jj,kk
c************************************************************************
c      print*,'just inside verify_stn_id'

      DO i=1,l_lines
       IF ( TRIM(s_stnname_single).NE.TRIM(s_arch_id(i)) ) THEN 

        print*,'s_stnname_single',i,TRIM(s_stnname_single),
     +    TRIM(s_arch_id(i))

        STOP 'verify_stn_id; emergency stop'
       ENDIF
      ENDDO

c      print*,'just leaving verify_stn_id'

      RETURN
      END
