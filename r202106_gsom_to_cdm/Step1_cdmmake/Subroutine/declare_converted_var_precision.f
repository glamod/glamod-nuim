c     Declare converted precision; declared based on 273.15
c     AJ_Kettle, 10Oct2019

      SUBROUTINE declare_converted_var_precision(l_rgh_lines,l_lines,
     +  s_vec_tmax_convprec_k,s_vec_tmin_convprec_k,
     +  s_vec_tavg_convprec_k)

      IMPLICIT NONE
c************************************************************************
      INTEGER             :: l_rgh_lines
      INTEGER             :: l_lines

      CHARACTER(LEN=10)   :: s_vec_tmax_convprec_k(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_tmin_convprec_k(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_tavg_convprec_k(l_rgh_lines)
c*****
c     Variables used in subroutine

      INTEGER             :: i,j,k,ii,jj,kk
c************************************************************************

      DO i=1,l_lines
       s_vec_tmax_convprec_k(i)='0.05'
       s_vec_tmin_convprec_k(i)='0.05'
       s_vec_tavg_convprec_k(i)='0.05'
      ENDDO

      RETURN
      END
