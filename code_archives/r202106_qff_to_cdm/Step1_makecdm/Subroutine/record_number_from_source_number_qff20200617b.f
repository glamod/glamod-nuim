c     Subroutine to get record number from source number
c     AJ_Kettle, 10Dec2019

      SUBROUTINE record_number_from_source_number_qff20200617b(
     +    s_directory_output_diagnostics,s_stnname_isolated,
     +    i_flag,
     +    l_cc_rgh,l_collect_cnt,
     +    s_collect_record_number,s_collect_source_id,
     +    l_rgh,l_lines,
     +    s_vec_airt_c,s_vec_dewp_c,
     +    s_vec_stnp_hpa,s_vec_slpr_hpa,
     +    s_vec_wdir_deg,s_vec_wspd_ms,
     +    f_vec_airt_c,f_vec_dewp_c,
     +    f_vec_stnp_hpa,f_vec_slpr_hpa,
     +    f_vec_wdir_deg,f_vec_wspd_ms,
     +    s_vec_airt_source_id,s_vec_dewp_source_id,
     +    s_vec_stnp_source_id,s_vec_slpr_source_id,
     +    s_vec_wdir_source_id,s_vec_wspd_source_id,

     +    s_vec_airt_recordnum,s_vec_dewp_recordnum,
     +    s_vec_stnp_recordnum,s_vec_slpr_recordnum,
     +    s_vec_wdir_recordnum,s_vec_wspd_recordnum)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into subroutine

      CHARACTER(LEN=*)    :: s_directory_output_diagnostics
      CHARACTER(LEN=*)    :: s_stnname_isolated

      INTEGER             :: i_flag

      INTEGER             :: l_cc_rgh      !record nrs expected for stn
      INTEGER             :: l_collect_cnt
      CHARACTER(LEN=*)    :: s_collect_record_number(l_cc_rgh)
      CHARACTER(LEN=*)    :: s_collect_source_id(l_cc_rgh)

      INTEGER             :: l_rgh
      INTEGER             :: l_lines

      CHARACTER(LEN=*)    :: s_vec_airt_c(l_rgh)
      CHARACTER(LEN=*)    :: s_vec_dewp_c(l_rgh)
      CHARACTER(LEN=*)    :: s_vec_stnp_hpa(l_rgh)
      CHARACTER(LEN=*)    :: s_vec_slpr_hpa(l_rgh)
      CHARACTER(LEN=*)    :: s_vec_wdir_deg(l_rgh)
      CHARACTER(LEN=*)    :: s_vec_wspd_ms(l_rgh)

      REAL                :: f_vec_airt_c(l_rgh)
      REAL                :: f_vec_dewp_c(l_rgh)
      REAL                :: f_vec_stnp_hpa(l_rgh)
      REAL                :: f_vec_slpr_hpa(l_rgh)
      REAL                :: f_vec_wdir_deg(l_rgh)
      REAL                :: f_vec_wspd_ms(l_rgh)

      CHARACTER(LEN=*)    :: s_vec_airt_source_id(l_rgh)
      CHARACTER(LEN=*)    :: s_vec_dewp_source_id(l_rgh)
      CHARACTER(LEN=*)    :: s_vec_stnp_source_id(l_rgh)
      CHARACTER(LEN=*)    :: s_vec_slpr_source_id(l_rgh)
      CHARACTER(LEN=*)    :: s_vec_wdir_source_id(l_rgh)
      CHARACTER(LEN=*)    :: s_vec_wspd_source_id(l_rgh)

      CHARACTER(LEN=*)    :: s_vec_airt_recordnum(l_rgh)
      CHARACTER(LEN=*)    :: s_vec_dewp_recordnum(l_rgh)
      CHARACTER(LEN=*)    :: s_vec_stnp_recordnum(l_rgh)
      CHARACTER(LEN=*)    :: s_vec_slpr_recordnum(l_rgh)
      CHARACTER(LEN=*)    :: s_vec_wdir_recordnum(l_rgh)
      CHARACTER(LEN=*)    :: s_vec_wspd_recordnum(l_rgh)
c*****
c     Variables used in subroutine

      INTEGER             :: i,j,k,ii,jj,kk

      INTEGER             :: i_vec_airt_qcmod_flag(l_rgh)
      INTEGER             :: i_vec_dewp_qcmod_flag(l_rgh)
      INTEGER             :: i_vec_stnp_qcmod_flag(l_rgh)
      INTEGER             :: i_vec_slpr_qcmod_flag(l_rgh)
      INTEGER             :: i_vec_wdir_qcmod_flag(l_rgh)
      INTEGER             :: i_vec_wspd_qcmod_flag(l_rgh)

      CHARACTER(LEN=4)    :: s_var_name

      INTEGER             :: i_flag_linenumber

      INTEGER             :: i_flag_airt
      INTEGER             :: i_flag_dewp
      INTEGER             :: i_flag_stnp
      INTEGER             :: i_flag_slpr
      INTEGER             :: i_flag_wdir
      INTEGER             :: i_flag_wspd

c************************************************************************
c      print*,'just in record_number_from_source_number_qff20200617b'

c      print*,'s_directory_output_diagnostics=',
c     +  s_directory_output_diagnostics
c      print*,'s_stnname_isolated=',s_stnname_isolated

c      print*,'l_rgh=',l_rgh
c      print*,'l_lines=',l_lines
c      print*,'l_cc_rgh=',l_cc_rgh
c      print*,'l_collect_cnt=',l_collect_cnt

c      DO i=1,l_collect_cnt
c       print*,'i=',i,s_collect_record_number(i),s_collect_source_id(i)
c      ENDDO

c      print*,'check wspd info'
c      DO i=1,5
c       print*,'i...',
c     +  TRIM(s_vec_wspd_ms(i))//'='//
c     +  TRIM(s_vec_wspd_source_id(i))//'='
c      ENDDO

c      STOP 'record_number_from_source_number_qff20200617b'
c*****
      i_flag=0     !initialization

      i_flag_airt=0
      i_flag_dewp=0
      i_flag_stnp=0
      i_flag_slpr=0
      i_flag_wdir=0
      i_flag_wspd=0
c*****
c     Initialize variables
      DO i=1,l_rgh

c      Initialize record number to blank
       s_vec_airt_recordnum(i)=''
       s_vec_dewp_recordnum(i)=''
       s_vec_stnp_recordnum(i)=''
       s_vec_slpr_recordnum(i)=''
       s_vec_wdir_recordnum(i)=''
       s_vec_wspd_recordnum(i)=''

c      Initialize qcmod flags to good
       i_vec_airt_qcmod_flag(i)=0
       i_vec_dewp_qcmod_flag(i)=0
       i_vec_stnp_qcmod_flag(i)=0
       i_vec_slpr_qcmod_flag(i)=0
       i_vec_wdir_qcmod_flag(i)=0
       i_vec_wspd_qcmod_flag(i)=0
      ENDDO
c*****

c     AIRT analysis
      s_var_name='AIRT'
      CALL find_record_number_qff20200617b(
     +  s_directory_output_diagnostics,s_stnname_isolated,
     +  s_var_name,
     +  i_flag_airt,i_flag_linenumber,
     +  l_rgh,l_lines,s_vec_airt_c,s_vec_airt_source_id,
     +  l_cc_rgh,l_collect_cnt,
     +  s_collect_source_id,s_collect_record_number,
     +  s_vec_airt_recordnum,i_vec_airt_qcmod_flag)

c      print*,'entrance flag=',i_flag_airt

c     DEWP analysis
      s_var_name='DEWP'
      CALL find_record_number_qff20200617b(
     +  s_directory_output_diagnostics,s_stnname_isolated,
     +  s_var_name,
     +  i_flag_dewp,i_flag_linenumber,
     +  l_rgh,l_lines,s_vec_dewp_c,s_vec_dewp_source_id,
     +  l_cc_rgh,l_collect_cnt,
     +  s_collect_source_id,s_collect_record_number,
     +  s_vec_dewp_recordnum,i_vec_dewp_qcmod_flag)

c      print*,'entrance flag=',i_flag_dewp

c     STNP analysis
      s_var_name='STNP'
      CALL find_record_number_qff20200617b(
     +  s_directory_output_diagnostics,s_stnname_isolated,
     +  s_var_name,
     +  i_flag_stnp,i_flag_linenumber,
     +  l_rgh,l_lines,s_vec_stnp_hpa,s_vec_stnp_source_id,
     +  l_cc_rgh,l_collect_cnt,
     +  s_collect_source_id,s_collect_record_number,
     +  s_vec_stnp_recordnum,i_vec_stnp_qcmod_flag)

c      print*,'entrance flag=',i_flag_stnp

c     SLPR analysis
      s_var_name='SLPR'
      CALL find_record_number_qff20200617b(
     +  s_directory_output_diagnostics,s_stnname_isolated,
     +  s_var_name,
     +  i_flag_slpr,i_flag_linenumber,
     +  l_rgh,l_lines,s_vec_slpr_hpa,s_vec_slpr_source_id,
     +  l_cc_rgh,l_collect_cnt,
     +  s_collect_source_id,s_collect_record_number,
     +  s_vec_slpr_recordnum,i_vec_slpr_qcmod_flag)

c      print*,'entrance flag=',i_flag_slpr

c     WDIR analysis
      s_var_name='WDIR'
      CALL find_record_number_qff20200617b(
     +  s_directory_output_diagnostics,s_stnname_isolated,
     +  s_var_name,
     +  i_flag_wdir,i_flag_linenumber,
     +  l_rgh,l_lines,s_vec_wdir_deg,s_vec_wdir_source_id,
     +  l_cc_rgh,l_collect_cnt,
     +  s_collect_source_id,s_collect_record_number,
     +  s_vec_wdir_recordnum,i_vec_wdir_qcmod_flag)

c      print*,'entrance flag=',i_flag_wdir

c     WSPD analysis
      s_var_name='WSPD'
      CALL find_record_number_qff20200617b(
     +  s_directory_output_diagnostics,s_stnname_isolated,
     +  s_var_name,
     +  i_flag_wspd,i_flag_linenumber,
     +  l_rgh,l_lines,s_vec_wspd_ms,s_vec_wspd_source_id,
     +  l_cc_rgh,l_collect_cnt,
     +  s_collect_source_id,s_collect_record_number,
     +  s_vec_wspd_recordnum,i_vec_wspd_qcmod_flag)

c      print*,'entrance flag=',i_flag_wspd

c 10   CONTINUE
c*****
c      print*,'flags=',i_flag_airt,i_flag_dewp,i_flag_stnp,
c     +  i_flag_slpr,i_flag_wdir,i_flag_wspd

c      IF (i_flag_airt.EQ.1) THEN 
c       print*,'flag_airt'
c      ENDIF
c      IF (i_flag_dewp.EQ.1) THEN
c       print*,'flag_dewp'
c      ENDIF
c      IF (i_flag_stnp.EQ.1) THEN 
c       print*,'flag_stnp'
c      ENDIF
c      IF (i_flag_slpr.EQ.1) THEN
c       print*,'flag_slpr'
c      ENDIF
c      IF (i_flag_wdir.EQ.1) THEN
c       print*,'flag_wdir'
c      ENDIF
c      IF (i_flag_wspd.EQ.1) THEN
c       print*,'flag_wspd'
c      ENDIF

c     Set skip flag if any parameter flag set
      IF (i_flag_airt.EQ.1.OR.i_flag_dewp.EQ.1.OR.
     +    i_flag_stnp.EQ.1.OR.i_flag_slpr.EQ.1.OR.
     +    i_flag_wdir.EQ.1.OR.i_flag_wspd.EQ.1) THEN

       print*,'skip flag condition met'
       print*,'record_number_from_source_number_qff20200617b.f' 
       print*,'common manifold position'
       print*,'i_flag_airt...',
     +   i_flag_airt,i_flag_dewp,i_flag_stnp,i_flag_slpr,
     +   i_flag_wdir,i_flag_wspd

c      DO i=1,5
c       print*,'i...',
c     +  TRIM(s_vec_wspd_ms(i))//'='//
c     +  TRIM(s_vec_wspd_source_id(i))//'='
c      ENDDO

c       STOP 'record_number_from source_number_qff20200617'

       i_flag=1
      ENDIF
c*****
c      print*,'component flags=',i_flag_airt,i_flag_dewp,
c     +  i_flag_stnp,i_flag_slpr,i_flag_wdir,i_flag_wspd 
c      print*,'i_flag=',i_flag

c      print*,'just leaving record_number_from source_number_qff'

c      STOP 'record_number_from source_number_qff20200617'

      RETURN
      END
