c     Subroutine for QC check on single variable
c     AJ_Kettle, 10Jan2018

      SUBROUTINE qc_single_variable2(l_channel,s_vec_qc_code,i_index,
     +  l_badflag,s_badflag, 
     +  s_prcp_qflag)

      IMPLICIT NONE
c************************************************************************
c     Declare variables passed into program

      INTEGER             :: l_channel
      CHARACTER(LEN=*)    :: s_vec_qc_code(l_channel)
      INTEGER             :: i_index
      INTEGER             :: l_badflag 
      CHARACTER(LEN=*)    :: s_badflag(14)   !LEN=1
      CHARACTER(LEN=*)    :: s_prcp_qflag    !LEN=1
c*****
c     Variables used in program
      INTEGER             :: i,j,k,ii,jj,kk
c************************************************************************
c     Blank field is good qc
      IF (TRIM(s_prcp_qflag).EQ.'') THEN
       s_vec_qc_code(i_index)='0'
       GOTO 10
      ENDIF
      DO i=1,l_badflag
       IF (TRIM(s_prcp_qflag).EQ.s_badflag(i)) THEN
        s_vec_qc_code(i_index)='1'
        GOTO 10
       ENDIF
      ENDDO
c     If here then error in qc_checker
      print*,'s_prcp_qflag='//TRIM(s_prcp_qflag)//'='
      STOP 'get_quality_flag_vector; strange qcflag'

 10   CONTINUE

      RETURN
      END
