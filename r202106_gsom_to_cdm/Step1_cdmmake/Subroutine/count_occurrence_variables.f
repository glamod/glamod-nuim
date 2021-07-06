c     Subroutine to count all data lines
c     AJ_Kettle, 30Sep2019

      SUBROUTINE count_occurrence_variables(l_rgh_lines,l_lines,
     +    s_vec_tmax_c,s_vec_tmin_c,s_vec_tavg_c,
     +    s_vec_prcp_mm,s_vec_snow_mm,s_vec_awnd_ms,

     +    i_count_alldatalines)

      IMPLICIT NONE
c************************************************************************
      INTEGER             :: l_rgh_lines
      INTEGER             :: l_lines

      CHARACTER(LEN=10)   :: s_vec_tmax_c(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_tmin_c(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_tavg_c(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_prcp_mm(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_snow_mm(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_awnd_ms(l_rgh_lines)

      INTEGER             :: i_count_alldatalines
c*****
c     Variables used within subroutine

      INTEGER             :: i,j,k,ii,jj,kk
c************************************************************************
      ii=0

      DO i=1,l_lines
       IF (LEN_TRIM(s_vec_tmax_c(i)).GT.0) THEN 
        ii=ii+1
       ENDIF
       IF (LEN_TRIM(s_vec_tmin_c(i)).GT.0) THEN 
        ii=ii+1
       ENDIF
       IF (LEN_TRIM(s_vec_tavg_c(i)).GT.0) THEN 
        ii=ii+1
       ENDIF
       IF (LEN_TRIM(s_vec_prcp_mm(i)).GT.0) THEN 
        ii=ii+1
       ENDIF
       IF (LEN_TRIM(s_vec_snow_mm(i)).GT.0) THEN 
        ii=ii+1
       ENDIF
       IF (LEN_TRIM(s_vec_awnd_ms(i)).GT.0) THEN 
        ii=ii+1
       ENDIF
      ENDDO

      i_count_alldatalines=ii

c      print*,'i_count_alldatalines=',i_count_alldatalines

c      STOP 'count_occurrence_variables'

      RETURN
      END
