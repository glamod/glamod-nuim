c     Subroutine to get quality flag vector
c     AJ_Kettle, 09Jan2019

      SUBROUTINE get_quality_flag_vector2(f_ndflag,l_channel,
     +  f_prcp_datavalue_mm,f_tmin_datavalue_c,
     +  f_tmax_datavalue_c,f_tavg_datavalue_c,
     +  f_snwd_datavalue_mm,f_snow_datavalue_mm,
     +  f_awnd_datavalue_ms,f_awdr_datavalue_deg,
     +  f_wesd_datavalue_mm,
     +  s_prcp_qflag,s_tmin_qflag,
     +  s_tmax_qflag,s_tavg_qflag,
     +  s_snwd_qflag,s_snow_qflag,
     +  s_awnd_qflag,s_awdr_qflag,
     +  s_wesd_qflag,
     +  s_vec_qc_code)

      IMPLICIT NONE
c************************************************************************
c     Declare variables passed into program

      REAL                :: f_ndflag
      INTEGER             :: l_channel

      REAL                :: f_prcp_datavalue_mm
      REAL                :: f_tmin_datavalue_c
      REAL                :: f_tmax_datavalue_c
      REAL                :: f_tavg_datavalue_c
      REAL                :: f_snwd_datavalue_mm
      REAL                :: f_snow_datavalue_mm
      REAL                :: f_awnd_datavalue_ms
      REAL                :: f_awdr_datavalue_deg
      REAL                :: f_wesd_datavalue_mm

      CHARACTER(LEN=*)    :: s_prcp_qflag
      CHARACTER(LEN=*)    :: s_tmin_qflag
      CHARACTER(LEN=*)    :: s_tmax_qflag
      CHARACTER(LEN=*)    :: s_tavg_qflag
      CHARACTER(LEN=*)    :: s_snwd_qflag
      CHARACTER(LEN=*)    :: s_snow_qflag
      CHARACTER(LEN=*)    :: s_awnd_qflag
      CHARACTER(LEN=*)    :: s_awdr_qflag
      CHARACTER(LEN=*)    :: s_wesd_qflag

      CHARACTER(LEN=*)    :: s_vec_qc_code(l_channel)
c*****
c     Variables used within program

      INTEGER             :: i,j,k,ii,jj,kk
      CHARACTER(LEN=1)    :: s_badflag(14)
      INTEGER             :: l_badflag 

      INTEGER             :: i_index

      CHARACTER(LEN=1)    :: s_single_qflag
c************************************************************************
c      print*,'just entered get_quality_flag_vector'

c      print*,'f_ndflag=',f_ndflag
c      print*,'l_channel=',l_channel
c************************************************************************
c     Define list of bad flags
      s_badflag(1) ='D'
      s_badflag(2) ='G' 
      s_badflag(3) ='I'
      s_badflag(4) ='K' 
      s_badflag(5) ='L'
      s_badflag(6) ='M' 
      s_badflag(7) ='N'
      s_badflag(8) ='O' 
      s_badflag(9) ='R'
      s_badflag(10)='S' 
      s_badflag(11)='T'
      s_badflag(12)='W'
      s_badflag(13)='X'
      s_badflag(14)='Z'  

      l_badflag=14
c************************************************************************
c     Initialize the QC variable to missing=3
      DO i=1,l_channel
       s_vec_qc_code(i)='3'
      ENDDO

c     Call subroutine to determine 1 qc_vector element
      i_index=1
      s_single_qflag=s_prcp_qflag
      CALL qc_single_variable2(l_channel,s_vec_qc_code,i_index,
     +  l_badflag,s_badflag, 
     +  s_single_qflag)

      i_index=2
      s_single_qflag=s_tmin_qflag
      CALL qc_single_variable2(l_channel,s_vec_qc_code,i_index,
     +  l_badflag,s_badflag, 
     +  s_single_qflag)

      i_index=3
      s_single_qflag=s_tmax_qflag
      CALL qc_single_variable2(l_channel,s_vec_qc_code,i_index,
     +  l_badflag,s_badflag, 
     +  s_single_qflag)

      i_index=4
      s_single_qflag=s_tavg_qflag
      CALL qc_single_variable2(l_channel,s_vec_qc_code,i_index,
     +  l_badflag,s_badflag, 
     +  s_single_qflag)

      i_index=5
      s_single_qflag=s_snwd_qflag
      CALL qc_single_variable2(l_channel,s_vec_qc_code,i_index,
     +  l_badflag,s_badflag, 
     +  s_single_qflag)

      i_index=6
      s_single_qflag=s_snow_qflag
      CALL qc_single_variable2(l_channel,s_vec_qc_code,i_index,
     +  l_badflag,s_badflag, 
     +  s_single_qflag)

      i_index=7
      s_single_qflag=s_awnd_qflag
      CALL qc_single_variable2(l_channel,s_vec_qc_code,i_index,
     +  l_badflag,s_badflag, 
     +  s_single_qflag)

      i_index=8
      s_single_qflag=s_awdr_qflag
      CALL qc_single_variable2(l_channel,s_vec_qc_code,i_index,
     +  l_badflag,s_badflag, 
     +  s_single_qflag)

      i_index=9
      s_single_qflag=s_wesd_qflag
      CALL qc_single_variable2(l_channel,s_vec_qc_code,i_index,
     +  l_badflag,s_badflag, 
     +  s_single_qflag)

c      print*,'s_vec_qc_code=',(s_vec_qc_code(i),i=1,l_channel)
c      print*,'just leaving get_quality_flag_vector'

      RETURN
      END
