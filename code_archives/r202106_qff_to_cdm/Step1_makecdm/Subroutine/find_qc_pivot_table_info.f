c     Subroutine for qc pivot table info
c     AJ_Kettle, 20Nov2020

      SUBROUTINE find_qc_pivot_table_info(l_rgh,l_lines,
     +    s_vec_airt_qc_flag,s_vec_dewp_qc_flag,
     +    s_vec_stnp_qc_flag,s_vec_slpr_qc_flag,
     +    s_vec_wdir_qc_flag,s_vec_wspd_qc_flag,
     +    s_vec_airt_cdmqc,s_vec_dewp_cdmqc,
     +    s_vec_stnp_cdmqc,s_vec_slpr_cdmqc,
     +    s_vec_wdir_cdmqc,s_vec_wspd_cdmqc,
     +    s_qckey_timescale_spec,l_qckey,
     +    s_qckey_sourceflag,s_qckey_c3sflag,s_qckey_timescale,

     +    s_vec_airt_cdmqcpivot,s_vec_dewp_cdmqcpivot,
     +    s_vec_stnp_cdmqcpivot,s_vec_slpr_cdmqcpivot,
     +    s_vec_wdir_cdmqcpivot,s_vec_wspd_cdmqcpivot)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into subroutine

      INTEGER             :: l_rgh
      INTEGER             :: l_lines

c     qc flags from source
      CHARACTER(LEN=8)    :: s_vec_airt_qc_flag(l_rgh)
      CHARACTER(LEN=8)    :: s_vec_dewp_qc_flag(l_rgh)
      CHARACTER(LEN=8)    :: s_vec_stnp_qc_flag(l_rgh)
      CHARACTER(LEN=8)    :: s_vec_slpr_qc_flag(l_rgh)
      CHARACTER(LEN=8)    :: s_vec_wdir_qc_flag(l_rgh)
      CHARACTER(LEN=8)    :: s_vec_wspd_qc_flag(l_rgh)

c     CDM qc flag assigned in program
      CHARACTER(LEN=1)    :: s_vec_airt_cdmqc(l_rgh)
      CHARACTER(LEN=1)    :: s_vec_dewp_cdmqc(l_rgh)
      CHARACTER(LEN=1)    :: s_vec_stnp_cdmqc(l_rgh)
      CHARACTER(LEN=1)    :: s_vec_slpr_cdmqc(l_rgh)
      CHARACTER(LEN=1)    :: s_vec_wdir_cdmqc(l_rgh)
      CHARACTER(LEN=1)    :: s_vec_wspd_cdmqc(l_rgh)

      CHARACTER(LEN=2)    :: s_vec_airt_cdmqcpivot(l_rgh)
      CHARACTER(LEN=2)    :: s_vec_dewp_cdmqcpivot(l_rgh)
      CHARACTER(LEN=2)    :: s_vec_stnp_cdmqcpivot(l_rgh)
      CHARACTER(LEN=2)    :: s_vec_slpr_cdmqcpivot(l_rgh)
      CHARACTER(LEN=2)    :: s_vec_wdir_cdmqcpivot(l_rgh)
      CHARACTER(LEN=2)    :: s_vec_wspd_cdmqcpivot(l_rgh)

c     info new qc table
      CHARACTER(LEN=300)  :: s_qckey_timescale_spec
      INTEGER             :: l_qckey
      CHARACTER(LEN=2)    :: s_qckey_sourceflag(100)
      CHARACTER(LEN=2)    :: s_qckey_c3sflag(100)
      CHARACTER(LEN=300)  :: s_qckey_timescale(100)
c*****
c     Variables used in subroutine

      INTEGER             :: i,j,k,ii,jj,kk

      INTEGER             :: l_len,l_len_test
c************************************************************************
c      print*,'just entered find_qc_pivot_table_info'  

      CALL qc_c3s_singlevariable(l_rgh,l_lines,
     +  s_vec_airt_qc_flag,s_vec_airt_cdmqc,s_vec_airt_cdmqcpivot,
     +  s_qckey_timescale_spec,
     +  l_qckey,
     +  s_qckey_sourceflag,s_qckey_c3sflag,s_qckey_timescale)

      CALL qc_c3s_singlevariable(l_rgh,l_lines,
     +  s_vec_dewp_qc_flag,s_vec_dewp_cdmqc,s_vec_dewp_cdmqcpivot,
     +  s_qckey_timescale_spec,
     +  l_qckey,
     +  s_qckey_sourceflag,s_qckey_c3sflag,s_qckey_timescale)

      CALL qc_c3s_singlevariable(l_rgh,l_lines,
     +  s_vec_stnp_qc_flag,s_vec_stnp_cdmqc,s_vec_stnp_cdmqcpivot,
     +  s_qckey_timescale_spec,
     +  l_qckey,
     +  s_qckey_sourceflag,s_qckey_c3sflag,s_qckey_timescale)

      CALL qc_c3s_singlevariable(l_rgh,l_lines,
     +  s_vec_slpr_qc_flag,s_vec_slpr_cdmqc,s_vec_slpr_cdmqcpivot,
     +  s_qckey_timescale_spec,
     +  l_qckey,
     +  s_qckey_sourceflag,s_qckey_c3sflag,s_qckey_timescale)

      CALL qc_c3s_singlevariable(l_rgh,l_lines,
     +  s_vec_wdir_qc_flag,s_vec_wdir_cdmqc,s_vec_wdir_cdmqcpivot,
     +  s_qckey_timescale_spec,
     +  l_qckey,
     +  s_qckey_sourceflag,s_qckey_c3sflag,s_qckey_timescale)

      CALL qc_c3s_singlevariable(l_rgh,l_lines,
     +  s_vec_wspd_qc_flag,s_vec_wspd_cdmqc,s_vec_wspd_cdmqcpivot,
     +  s_qckey_timescale_spec,
     +  l_qckey,
     +  s_qckey_sourceflag,s_qckey_c3sflag,s_qckey_timescale)

c      print*,'just leaving find_qc_pivot_table_info'  

c      STOP 'find_qc_pivot_table_info'

      RETURN
      END
