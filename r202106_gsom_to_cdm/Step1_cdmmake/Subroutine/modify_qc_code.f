c     Subroutine to modify qc on the basis of the qcmod_flag
c     AJ_Kettle, 02Dec2019

      SUBROUTINE modify_qc_code(l_rgh_lines,l_lines,
     +    s_vec_tmax_qc,s_vec_tmin_qc,s_vec_tavg_qc,
     +    s_vec_prcp_qc,s_vec_snow_qc,s_vec_awnd_qc,
     +    i_vec_tmax_qcmod_flag,i_vec_tmin_qcmod_flag,
     +    i_vec_tavg_qcmod_flag,i_vec_prcp_qcmod_flag,
     +    i_vec_snow_qcmod_flag,i_vec_awnd_qcmod_flag)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into subroutine

      INTEGER             :: l_rgh_lines
      INTEGER             :: l_lines

      CHARACTER(LEN=1)    :: s_vec_tmax_qc(l_rgh_lines)
      CHARACTER(LEN=1)    :: s_vec_tmin_qc(l_rgh_lines)
      CHARACTER(LEN=1)    :: s_vec_tavg_qc(l_rgh_lines)
      CHARACTER(LEN=1)    :: s_vec_prcp_qc(l_rgh_lines)
      CHARACTER(LEN=1)    :: s_vec_snow_qc(l_rgh_lines)
      CHARACTER(LEN=1)    :: s_vec_awnd_qc(l_rgh_lines)

      INTEGER             :: i_vec_tmax_qcmod_flag(l_rgh_lines)
      INTEGER             :: i_vec_tmin_qcmod_flag(l_rgh_lines)
      INTEGER             :: i_vec_tavg_qcmod_flag(l_rgh_lines)
      INTEGER             :: i_vec_prcp_qcmod_flag(l_rgh_lines)
      INTEGER             :: i_vec_snow_qcmod_flag(l_rgh_lines)
      INTEGER             :: i_vec_awnd_qcmod_flag(l_rgh_lines)
c*****
c     Variables used in subroutine

      INTEGER             :: i,j,k,ii,jj,kk
c************************************************************************

      DO i=1,l_lines
       IF (i_vec_tmax_qcmod_flag(i).EQ.1) THEN
        s_vec_tmax_qc(i)='4'
       ENDIF
       IF (i_vec_tmin_qcmod_flag(i).EQ.1) THEN
        s_vec_tmin_qc(i)='4'
       ENDIF
       IF (i_vec_tavg_qcmod_flag(i).EQ.1) THEN
        s_vec_tavg_qc(i)='4'
       ENDIF
       IF (i_vec_prcp_qcmod_flag(i).EQ.1) THEN
        s_vec_prcp_qc(i)='4'
       ENDIF
       IF (i_vec_snow_qcmod_flag(i).EQ.1) THEN
        s_vec_snow_qc(i)='4'
       ENDIF
       IF (i_vec_awnd_qcmod_flag(i).EQ.1) THEN
        s_vec_awnd_qc(i)='4'
       ENDIF

      ENDDO

      RETURN
      END
