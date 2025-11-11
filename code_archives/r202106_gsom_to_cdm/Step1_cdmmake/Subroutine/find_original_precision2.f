c     Subroutine to find original precision
c     AJ_Kettle, 13Nov2018

      SUBROUTINE find_original_precision2(l_rgh_lines,l_lines,
     +  s_vec_tmax,s_vec_tmin,s_vec_tavg,
     +  s_vec_prcp,s_vec_snow,s_vec_awnd,
     +  s_vec_tmax_origprec,s_vec_tmin_origprec,
     +  s_vec_tavg_origprec,s_vec_prcp_origprec,
     +  s_vec_snow_origprec,s_vec_awnd_origprec,
     +  s_vec_tmax_origprec_neglog,s_vec_tmin_origprec_neglog,
     +  s_vec_tavg_origprec_neglog,s_vec_prcp_origprec_neglog,
     +  s_vec_snow_origprec_neglog,s_vec_awnd_origprec_neglog,
     +  s_vec_tmax_origprec_empir,s_vec_tmin_origprec_empir,
     +  s_vec_tavg_origprec_empir,s_vec_prcp_origprec_empir,
     +  s_vec_snow_origprec_empir,s_vec_awnd_origprec_empir)

      IMPLICIT NONE
c************************************************************************
c     Variables brought into program
      INTEGER             :: l_rgh_lines
      INTEGER             :: l_lines
      INTEGER             :: i_field_present(6)

      CHARACTER(LEN=10)   :: s_vec_tmax(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_tmin(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_tavg(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_prcp(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_snow(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_awnd(l_rgh_lines)

      CHARACTER(LEN=10)   :: s_vec_tmax_origprec(l_rgh_lines) 
      CHARACTER(LEN=10)   :: s_vec_tmin_origprec(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_tavg_origprec(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_prcp_origprec(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_snow_origprec(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_awnd_origprec(l_rgh_lines) 

      CHARACTER(LEN=10)   :: s_vec_tmax_origprec_empir(l_rgh_lines) 
      CHARACTER(LEN=10)   :: s_vec_tmin_origprec_empir(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_tavg_origprec_empir(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_prcp_origprec_empir(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_snow_origprec_empir(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_awnd_origprec_empir(l_rgh_lines) 

      CHARACTER(LEN=1)    :: s_vec_tmax_origprec_neglog(l_rgh_lines) 
      CHARACTER(LEN=1)    :: s_vec_tmin_origprec_neglog(l_rgh_lines)
      CHARACTER(LEN=1)    :: s_vec_tavg_origprec_neglog(l_rgh_lines)
      CHARACTER(LEN=1)    :: s_vec_prcp_origprec_neglog(l_rgh_lines)
      CHARACTER(LEN=1)    :: s_vec_snow_origprec_neglog(l_rgh_lines)
      CHARACTER(LEN=1)    :: s_vec_awnd_origprec_neglog(l_rgh_lines) 
c*****
      INTEGER             :: i,j,k,ii,jj,kk
c************************************************************************
c      print*,'just entered find_original_precision2'

c      GOTO 25

c     Call subroutine to find original precision
c      CALL find_precision_vector2(l_rgh_lines,l_lines,
c     +  s_vec_tmax,
c     +  s_vec_tmax_origprec,s_vec_tmax_origprec_neglog,
c     +  s_vec_tmax_origprec_empir)
      CALL find_precision_vector3(l_rgh_lines,l_lines,
     +  s_vec_tmax,
     +  s_vec_tmax_origprec,s_vec_tmax_origprec_neglog,
     +  s_vec_tmax_origprec_empir)

c      print*,'cleared tmax'

c     Call subroutine to find original precision
c      CALL find_precision_vector2(l_rgh_lines,l_lines,
c     +  s_vec_tmin,
c     +  s_vec_tmin_origprec,s_vec_tmin_origprec_neglog,
c     +  s_vec_tmin_origprec_empir)
      CALL find_precision_vector3(l_rgh_lines,l_lines,
     +  s_vec_tmin,
     +  s_vec_tmin_origprec,s_vec_tmin_origprec_neglog,
     +  s_vec_tmin_origprec_empir)

c      print*,'cleared tmin'

c     Call subroutine to find original precision
c      CALL find_precision_vector2(l_rgh_lines,l_lines,
c     +  s_vec_tavg,
c     +  s_vec_tavg_origprec,s_vec_tavg_origprec_neglog,
c     +  s_vec_tavg_origprec_empir)
      CALL find_precision_vector3(l_rgh_lines,l_lines,
     +  s_vec_tavg,
     +  s_vec_tavg_origprec,s_vec_tavg_origprec_neglog,
     +  s_vec_tavg_origprec_empir)

c      print*,'cleared tavg'

c     Call subroutine to find original precision
c      CALL find_precision_vector2(l_rgh_lines,l_lines,
c     +  s_vec_prcp,
c     +  s_vec_prcp_origprec,s_vec_prcp_origprec_neglog,
c     +  s_vec_prcp_origprec_empir)
      CALL find_precision_vector3(l_rgh_lines,l_lines,
     +  s_vec_prcp,
     +  s_vec_prcp_origprec,s_vec_prcp_origprec_neglog,
     +  s_vec_prcp_origprec_empir)

c      print*,'cleared prcp'

c 25   CONTINUE

c     Call subroutine to find original precision
c      CALL find_precision_vector2(l_rgh_lines,l_lines,
c     +  s_vec_snow,
c     +  s_vec_snow_origprec,s_vec_snow_origprec_neglog,
c     +  s_vec_snow_origprec_empir)
      CALL find_precision_vector3(l_rgh_lines,l_lines,
     +  s_vec_snow,
     +  s_vec_snow_origprec,s_vec_snow_origprec_neglog,
     +  s_vec_snow_origprec_empir)

c      print*,'cleared snow'

c      GOTO 26

c     Call subroutine to find original precision
c      CALL find_precision_vector2(l_rgh_lines,l_lines,
c     +  s_vec_awnd,
c     +  s_vec_awnd_origprec,s_vec_awnd_origprec_neglog,
c     +  s_vec_awnd_origprec_empir)
      CALL find_precision_vector3(l_rgh_lines,l_lines,
     +  s_vec_awnd,
     +  s_vec_awnd_origprec,s_vec_awnd_origprec_neglog,
     +  s_vec_awnd_origprec_empir)

c      print*,'cleared awnd'

c 26   CONTINUE
c*****
      GOTO 15

      print*,'s_vec_tmax=',(s_vec_tmax(i),i=1,l_lines)
      print*,'s_vec_tmax_origprec=',(s_vec_tmax_origprec(i),i=1,l_lines)
c      print*,'s_vec_tmax_origprec_neglog=',
c     +  (s_vec_tmax_origprec_neglog(i),i=1,l_lines)
      print*,'s_vec_tmax_origprec_empir=',
     +  (s_vec_tmax_origprec_empir(i),i=1,l_lines)

      print*,'s_vec_tmin=',(s_vec_tmin(i),i=1,l_lines)
      print*,'s_vec_tmin_origprec=',(s_vec_tmin_origprec(i),i=1,l_lines)
c      print*,'s_vec_tmin_origprec_neglog=',
c     +  (s_vec_tmin_origprec_neglog(i),i=1,l_lines)
      print*,'s_vec_tmin_origprec_empir=',
     +  (s_vec_tmin_origprec_empir(i),i=1,l_lines)

      print*,'s_vec_tavg=',(s_vec_tavg(i),i=1,l_lines)
      print*,'s_vec_tavg_origprec=',(s_vec_tavg_origprec(i),i=1,l_lines)
c      print*,'s_vec_tavg_origprec_neglog=',
c     +   (s_vec_tavg_origprec_neglog(i),i=1,l_lines)
      print*,'s_vec_tavg_origprec_empir=',
     +   (s_vec_tavg_origprec_empir(i),i=1,l_lines)

      print*,'s_vec_prcp=',(s_vec_prcp(i),i=1,l_lines)
      print*,'s_vec_prcp_origprec=',(s_vec_prcp_origprec(i),i=1,l_lines)
c      print*,'s_vec_prcp_origprec_neglog=',
c     +   (s_vec_prcp_origprec_neglog(i),i=1,l_lines)
      print*,'s_vec_prcp_origprec_empir=',
     +   (s_vec_prcp_origprec_empir(i),i=1,l_lines)

      print*,'s_vec_snow=',(s_vec_snow(i),i=1,l_lines)
      print*,'s_vec_snow_origprec=',(s_vec_snow_origprec(i),i=1,l_lines)
c      print*,'s_vec_snow_origprec_neglog=',
c     +   (s_vec_snow_origprec_neglog(i),i=1,l_lines)
      print*,'s_vec_snow_origprec_empir=',
     +   (s_vec_snow_origprec_empir(i),i=1,l_lines)

      print*,'s_vec_awnd=',(s_vec_awnd(i),i=1,l_lines)
      print*,'s_vec_awnd_origprec=',(s_vec_awnd_origprec(i),i=1,l_lines)
c      print*,'s_vec_awnd_origprec_neglog=',
c     +   (s_vec_awnd_origprec_neglog(i),i=1,l_lines)
      print*,'s_vec_awnd_origprec_empir=',
     +   (s_vec_awnd_origprec_empir(i),i=1,l_lines)

 15   CONTINUE
c************************************************************************
c      print*,'just leaving find_original_precision2'

c      STOP 'find_original_precision2'

      RETURN
      END
