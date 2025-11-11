c     Subroutine to define qcmethod vector
c     AJ_Kettle, 16Dec2020

      SUBROUTINE get_qcmethod_vector20201216(f_ndflag,l_channel,
     +  s_prcp_cdmqc,s_tmin_cdmqc,
     +  s_tmax_cdmqc,s_tavg_cdmqc,
     +  s_snwd_cdmqc,s_snow_cdmqc,
     +  s_awnd_cdmqc,s_awdr_cdmqc,
     +  s_wesd_cdmqc,
     +  s_prcp_cdmqcmethod,s_tmin_cdmqcmethod,
     +  s_tmax_cdmqcmethod,s_tavg_cdmqcmethod,
     +  s_snwd_cdmqcmethod,s_snow_cdmqcmethod,
     +  s_awnd_cdmqcmethod,s_awdr_cdmqcmethod,
     +  s_wesd_cdmqcmethod,
     +  s_vec_qc_code_check,s_vec_qcmethod_code)

      IMPLICIT NONE
c************************************************************************
c     Declare variables passed into subroutine

      REAL                :: f_ndflag

      INTEGER             :: l_channel

      CHARACTER(LEN=1)    :: s_prcp_cdmqc
      CHARACTER(LEN=1)    :: s_tmin_cdmqc
      CHARACTER(LEN=1)    :: s_tmax_cdmqc
      CHARACTER(LEN=1)    :: s_tavg_cdmqc
      CHARACTER(LEN=1)    :: s_snwd_cdmqc
      CHARACTER(LEN=1)    :: s_snow_cdmqc
      CHARACTER(LEN=1)    :: s_awnd_cdmqc
      CHARACTER(LEN=1)    :: s_awdr_cdmqc
      CHARACTER(LEN=1)    :: s_wesd_cdmqc

      CHARACTER(LEN=2)    :: s_prcp_cdmqcmethod
      CHARACTER(LEN=2)    :: s_tmin_cdmqcmethod
      CHARACTER(LEN=2)    :: s_tmax_cdmqcmethod
      CHARACTER(LEN=2)    :: s_tavg_cdmqcmethod
      CHARACTER(LEN=2)    :: s_snwd_cdmqcmethod
      CHARACTER(LEN=2)    :: s_snow_cdmqcmethod
      CHARACTER(LEN=2)    :: s_awnd_cdmqcmethod
      CHARACTER(LEN=2)    :: s_awdr_cdmqcmethod
      CHARACTER(LEN=2)    :: s_wesd_cdmqcmethod

      CHARACTER(LEN=1)    :: s_vec_qc_code_check(l_channel)
      CHARACTER(LEN=2)    :: s_vec_qcmethod_code(l_channel)
c*****
c     Variables used in subroutine

      INTEGER             :: i,j,k,ii,jj,kk
c************************************************************************

      ii=1
      s_vec_qc_code_check(ii)=s_prcp_cdmqc
      s_vec_qcmethod_code(ii)=s_prcp_cdmqcmethod

      ii=2
      s_vec_qc_code_check(ii)=s_tmin_cdmqc
      s_vec_qcmethod_code(ii)=s_tmin_cdmqcmethod

      ii=3
      s_vec_qc_code_check(ii)=s_tmax_cdmqc
      s_vec_qcmethod_code(ii)=s_tmax_cdmqcmethod

      ii=4
      s_vec_qc_code_check(ii)=s_tavg_cdmqc
      s_vec_qcmethod_code(ii)=s_tavg_cdmqcmethod

      ii=5
      s_vec_qc_code_check(ii)=s_snwd_cdmqc
      s_vec_qcmethod_code(ii)=s_snwd_cdmqcmethod

      ii=6
      s_vec_qc_code_check(ii)=s_snow_cdmqc
      s_vec_qcmethod_code(ii)=s_snow_cdmqcmethod

      ii=7
      s_vec_qc_code_check(ii)=s_awnd_cdmqc
      s_vec_qcmethod_code(ii)=s_awnd_cdmqcmethod

      ii=8
      s_vec_qc_code_check(ii)=s_awdr_cdmqc
      s_vec_qcmethod_code(ii)=s_awdr_cdmqcmethod

      ii=9
      s_vec_qc_code_check(ii)=s_wesd_cdmqc
      s_vec_qcmethod_code(ii)=s_wesd_cdmqcmethod

c      print*,'s_vec_qc_code_che',(s_vec_qc_code_check(i),i=1,l_channel)
c      print*,'s_vec_qcmethod_co',(s_vec_qcmethod_code(i),i=1,l_channel)

c      STOP 'get_qcmethod_vector2020216'

      RETURN
      END
