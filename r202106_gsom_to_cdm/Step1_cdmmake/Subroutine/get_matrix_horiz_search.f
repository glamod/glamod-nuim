c     Subroutine to get matrix for horizonal search
c     AJ_Kettle, 29Nov2019

      SUBROUTINE get_matrix_horiz_search(l_rgh_lines,l_lines,
     +  s_vec_tmax_c,s_vec_tmax_sourcelett,
     +  s_vec_tmin_c,s_vec_tmin_sourcelett,
     +  s_vec_tavg_c,s_vec_tavg_sourcelett,
     +  s_vec_prcp_mm,s_vec_prcp_sourcelett,
     +  s_vec_snow_mm,s_vec_snow_sourcelett,
     +  s_vec_awnd_ms,s_vec_awnd_sourcelett,
     +  i_cnt_sourcelett,
     +  s_mat_sourcelett,s_mat_variableid)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into subroutine

      INTEGER             :: l_rgh_lines
      INTEGER             :: l_lines

      CHARACTER(LEN=10)   :: s_vec_tmax_c(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_tmin_c(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_tavg_c(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_prcp_mm(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_snow_mm(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_awnd_ms(l_rgh_lines)

      CHARACTER(LEN=1)    :: s_vec_tmax_sourcelett(l_rgh_lines)
      CHARACTER(LEN=1)    :: s_vec_tmin_sourcelett(l_rgh_lines)
      CHARACTER(LEN=1)    :: s_vec_tavg_sourcelett(l_rgh_lines)
      CHARACTER(LEN=1)    :: s_vec_prcp_sourcelett(l_rgh_lines)
      CHARACTER(LEN=1)    :: s_vec_snow_sourcelett(l_rgh_lines)
      CHARACTER(LEN=1)    :: s_vec_awnd_sourcelett(l_rgh_lines)

      INTEGER             :: i_cnt_sourcelett(l_rgh_lines)
      CHARACTER(LEN=1)    :: s_mat_sourcelett(l_rgh_lines,6)
      CHARACTER(LEN=4)    :: s_mat_variableid(l_rgh_lines,6)
c*****
c     Variables used inside subroutine

      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: i_len_var
      INTEGER             :: i_len_let
c************************************************************************

      DO i=1,l_lines

       ii=0

c      TMAX
       i_len_var=LEN_TRIM(s_vec_tmax_c(i))
       i_len_let=LEN_TRIM(s_vec_tmax_sourcelett(i))
       IF (i_len_var.GT.0.AND.i_len_let.GT.0) THEN
        ii=ii+1
        s_mat_sourcelett(i,ii)=s_vec_tmax_sourcelett(i)
        s_mat_variableid(i,ii)='TMAX'
       ENDIF
c      TMIN
       i_len_var=LEN_TRIM(s_vec_tmin_c(i))
       i_len_let=LEN_TRIM(s_vec_tmin_sourcelett(i))
       IF (i_len_var.GT.0.AND.i_len_let.GT.0) THEN
        ii=ii+1
        s_mat_sourcelett(i,ii)=s_vec_tmin_sourcelett(i)
        s_mat_variableid(i,ii)='TMIN'
       ENDIF
c      TAVG
       i_len_var=LEN_TRIM(s_vec_tavg_c(i))
       i_len_let=LEN_TRIM(s_vec_tavg_sourcelett(i))
       IF (i_len_var.GT.0.AND.i_len_let.GT.0) THEN
        ii=ii+1
        s_mat_sourcelett(i,ii)=s_vec_tavg_sourcelett(i)
        s_mat_variableid(i,ii)='TAVG'
       ENDIF
c      PRCP
       i_len_var=LEN_TRIM(s_vec_prcp_mm(i))
       i_len_let=LEN_TRIM(s_vec_prcp_sourcelett(i))
       IF (i_len_var.GT.0.AND.i_len_let.GT.0) THEN
        ii=ii+1
        s_mat_sourcelett(i,ii)=s_vec_prcp_sourcelett(i)
        s_mat_variableid(i,ii)='PRCP'
       ENDIF
c      SNOW
       i_len_var=LEN_TRIM(s_vec_snow_mm(i))
       i_len_let=LEN_TRIM(s_vec_snow_sourcelett(i))
       IF (i_len_var.GT.0.AND.i_len_let.GT.0) THEN
        ii=ii+1
        s_mat_sourcelett(i,ii)=s_vec_snow_sourcelett(i)
        s_mat_variableid(i,ii)='SNOW'
       ENDIF
c      AWND
       i_len_var=LEN_TRIM(s_vec_awnd_ms(i))
       i_len_let=LEN_TRIM(s_vec_awnd_sourcelett(i))
       IF (i_len_var.GT.0.AND.i_len_let.GT.0) THEN
        ii=ii+1
        s_mat_sourcelett(i,ii)=s_vec_awnd_sourcelett(i)
        s_mat_variableid(i,ii)='AWND'
       ENDIF

       i_cnt_sourcelett(i)=ii

      ENDDO

      RETURN
      END
