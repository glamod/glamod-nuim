c     Subroutine to find CDM qc code
c     AJ_Kettle, 11Dec2019

      SUBROUTINE find_cdm_qc_code(l_rgh,l_lines,
     +    s_vec_airt_qc_flag,s_vec_dewp_qc_flag,
     +    s_vec_stnp_qc_flag,s_vec_slpr_qc_flag,
     +    s_vec_wdir_qc_flag,s_vec_wspd_qc_flag,

     +    s_vec_airt_cdmqc,s_vec_dewp_cdmqc,
     +    s_vec_stnp_cdmqc,s_vec_slpr_cdmqc,
     +    s_vec_wdir_cdmqc,s_vec_wspd_cdmqc)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into subroutine

      INTEGER             :: l_rgh
      INTEGER             :: l_lines

      CHARACTER(LEN=8)    :: s_vec_airt_qc_flag(l_rgh)
      CHARACTER(LEN=8)    :: s_vec_dewp_qc_flag(l_rgh)
      CHARACTER(LEN=8)    :: s_vec_stnp_qc_flag(l_rgh)
      CHARACTER(LEN=8)    :: s_vec_slpr_qc_flag(l_rgh)
      CHARACTER(LEN=8)    :: s_vec_wdir_qc_flag(l_rgh)
      CHARACTER(LEN=8)    :: s_vec_wspd_qc_flag(l_rgh)

c     CDM qc flag
      CHARACTER(LEN=1)    :: s_vec_airt_cdmqc(l_rgh)
      CHARACTER(LEN=1)    :: s_vec_dewp_cdmqc(l_rgh)
      CHARACTER(LEN=1)    :: s_vec_stnp_cdmqc(l_rgh)
      CHARACTER(LEN=1)    :: s_vec_slpr_cdmqc(l_rgh)
      CHARACTER(LEN=1)    :: s_vec_wdir_cdmqc(l_rgh)
      CHARACTER(LEN=1)    :: s_vec_wspd_cdmqc(l_rgh)
c*****
c     Variables used within subroutine

      INTEGER             :: i,j,k,ii,jj,kk

      INTEGER             :: i_cnt_fail_airt
      INTEGER             :: i_cnt_fail_dewp
      INTEGER             :: i_cnt_fail_stnp
      INTEGER             :: i_cnt_fail_slpr
      INTEGER             :: i_cnt_fail_wdir
      INTEGER             :: i_cnt_fail_wspd

c************************************************************************
c      print*,'just entering find_cdm_qc_code'

      i_cnt_fail_airt=0
      i_cnt_fail_dewp=0
      i_cnt_fail_stnp=0
      i_cnt_fail_slpr=0
      i_cnt_fail_wdir=0
      i_cnt_fail_wspd=0

      DO i=1,l_lines

c      Initialize flags to missing
       s_vec_airt_cdmqc(i)='3'
       s_vec_dewp_cdmqc(i)='3'
       s_vec_stnp_cdmqc(i)='3'
       s_vec_slpr_cdmqc(i)='3'
       s_vec_wdir_cdmqc(i)='3'
       s_vec_wspd_cdmqc(i)='3'

c      AIRT
       IF (LEN_TRIM(s_vec_airt_qc_flag(i)).EQ.0) THEN
        s_vec_airt_cdmqc(i)='0'   !if no flag then pass=0
       ENDIF
       IF (LEN_TRIM(s_vec_airt_qc_flag(i)).GT.0) THEN
        s_vec_airt_cdmqc(i)='1'   !if any flag then fail=1
        i_cnt_fail_airt=i_cnt_fail_airt+1
       ENDIF

c      DEWP
       IF (LEN_TRIM(s_vec_dewp_qc_flag(i)).EQ.0) THEN
        s_vec_dewp_cdmqc(i)='0'   !if no flag then pass=0
       ENDIF
       IF (LEN_TRIM(s_vec_dewp_qc_flag(i)).GT.0) THEN
        s_vec_dewp_cdmqc(i)='1'   !if any flag then fail=1
        i_cnt_fail_dewp=i_cnt_fail_dewp+1
       ENDIF

c      STNP
       IF (LEN_TRIM(s_vec_stnp_qc_flag(i)).EQ.0) THEN
        s_vec_stnp_cdmqc(i)='0'   !if no flag then pass=0
       ENDIF
       IF (LEN_TRIM(s_vec_stnp_qc_flag(i)).GT.0) THEN
        s_vec_stnp_cdmqc(i)='1'   !if any flag then fail=1
        i_cnt_fail_stnp=i_cnt_fail_stnp+1
       ENDIF

c      SLPR
       IF (LEN_TRIM(s_vec_slpr_qc_flag(i)).EQ.0) THEN
        s_vec_slpr_cdmqc(i)='0'   !if no flag then pass=0
       ENDIF
       IF (LEN_TRIM(s_vec_slpr_qc_flag(i)).GT.0) THEN
        s_vec_slpr_cdmqc(i)='1'   !if any flag then fail=1
        i_cnt_fail_slpr=i_cnt_fail_slpr+1
       ENDIF

c      WDIR
       IF (LEN_TRIM(s_vec_wdir_qc_flag(i)).EQ.0) THEN
        s_vec_wdir_cdmqc(i)='0'   !if no flag then pass=0
       ENDIF
       IF (LEN_TRIM(s_vec_wdir_qc_flag(i)).GT.0) THEN
        s_vec_wdir_cdmqc(i)='1'   !if any flag then fail=1
        i_cnt_fail_wdir=i_cnt_fail_wdir+1
       ENDIF

c      WSPD
       IF (LEN_TRIM(s_vec_wspd_qc_flag(i)).EQ.0) THEN
        s_vec_wspd_cdmqc(i)='0'   !if no flag then pass=0
       ENDIF
       IF (LEN_TRIM(s_vec_wspd_qc_flag(i)).GT.0) THEN
        s_vec_wspd_cdmqc(i)='1'   !if any flag then fail=1
        i_cnt_fail_wspd=i_cnt_fail_wspd+1
       ENDIF

      ENDDO

c      print*,'i_cnt_fail_airt',i_cnt_fail_airt
c      print*,'i_cnt_fail_dewp',i_cnt_fail_dewp
c      print*,'i_cnt_fail_stnp',i_cnt_fail_stnp
c      print*,'i_cnt_fail_slpr',i_cnt_fail_slpr
c      print*,'i_cnt_fail_wdir',i_cnt_fail_wdir
c      print*,'i_cnt_fail_wspd',i_cnt_fail_wspd

c      print*,'just leaving find_cdm_qc_code'

c      STOP 'find_cdm_qc_code'

      RETURN
      END
