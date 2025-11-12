c     Subroutine to convert variable string to float
c     AJ_Kettle, 01Dec2019

      SUBROUTINE convert_var_string_to_float(i_flag,
     +   s_stnname_isolated,
     +   f_ndflag,l_rgh,l_lines,
     +   s_vec_airt_c,s_vec_dewp_c,
     +   s_vec_stnp_hpa,s_vec_slpr_hpa,
     +   s_vec_wdir_deg,s_vec_wspd_ms,

     +   f_vec_airt_c,f_vec_dewp_c,
     +   f_vec_stnp_hpa,f_vec_slpr_hpa,
     +   f_vec_wdir_deg,f_vec_wspd_ms)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into subroutine

      INTEGER             :: i_flag

      CHARACTER(LEN=*)    :: s_stnname_isolated

      REAL                :: f_ndflag

      INTEGER             :: l_rgh
      INTEGER             :: l_lines
      INTEGER,PARAMETER   :: l_clen=32

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
c*****
c     Variables used within subroutine

      INTEGER             :: i,j,k,ii,jj,kk

      INTEGER             :: i_airt_numgood,i_airt_numbad
      INTEGER             :: i_dewp_numgood,i_dewp_numbad
      INTEGER             :: i_stnp_numgood,i_stnp_numbad
      INTEGER             :: i_slpr_numgood,i_slpr_numbad
      INTEGER             :: i_wdir_numgood,i_wdir_numbad
      INTEGER             :: i_wspd_numgood,i_wspd_numbad

c************************************************************************
c      print*,'just entered convert_var_string_to_float'

      i_flag=0

c     AIRT
      CALL string_convert_float_qff(f_ndflag,l_rgh,l_lines,l_clen,
     +  s_vec_airt_c,
     +  f_vec_airt_c,
     +  i_airt_numgood,i_airt_numbad)

c     DEWP
      CALL string_convert_float_qff(f_ndflag,l_rgh,l_lines,l_clen,
     +  s_vec_dewp_c,
     +  f_vec_dewp_c,
     +  i_dewp_numgood,i_dewp_numbad)

c     STNP
      CALL string_convert_float_qff(f_ndflag,l_rgh,l_lines,l_clen,
     +  s_vec_stnp_hpa,
     +  f_vec_stnp_hpa,
     +  i_stnp_numgood,i_stnp_numbad)

c     SLPR
      CALL string_convert_float_qff(f_ndflag,l_rgh,l_lines,l_clen,
     +  s_vec_slpr_hpa,
     +  f_vec_slpr_hpa,
     +  i_slpr_numgood,i_slpr_numbad)

c     WDIR
      CALL string_convert_float_qff(f_ndflag,l_rgh,l_lines,l_clen,
     +  s_vec_wdir_deg,
     +  f_vec_wdir_deg,
     +  i_wdir_numgood,i_wdir_numbad)

c     WSPD
      CALL string_convert_float_qff(f_ndflag,l_rgh,l_lines,l_clen,
     +  s_vec_wspd_ms,
     +  f_vec_wspd_ms,
     +  i_wspd_numgood,i_wspd_numbad)

c     Condition for flagging station
      IF (i_airt_numbad.GT.0.OR.i_dewp_numbad.GT.0.OR.
     +    i_stnp_numbad.GT.0.OR.i_slpr_numbad.GT.0.OR.
     +    i_wdir_numbad.GT.0.OR.i_wspd_numbad.GT.0) THEN
       i_flag=1

       print*,'emergency stop; bad float conversion'
       print*,'s_stnname_isolated=',TRIM(s_stnname_isolated)
       print*,'i_airt_numbad=',i_airt_numbad
       print*,'i_dewp_numbad=',i_dewp_numbad
       print*,'i_stnp_numbad=',i_stnp_numbad
       print*,'i_slpr_numbad=',i_slpr_numbad
       print*,'i_wdir_numbad=',i_wdir_numbad
       print*,'i_wspd_numbad=',i_wspd_numbad

       STOP 'convert_var_string_to_float'
      ENDIF

      GOTO 10

      print*,'s_airt=',(TRIM(s_vec_airt_c(i)),i=1,10)
      print*,'f_airt=',(f_vec_airt_c(i),i=1,10)
      print*,'n good/bad=',i_airt_numgood,i_airt_numbad

      print*,'s_dewp=',(TRIM(s_vec_dewp_c(i)),i=1,10)
      print*,'dewp=',(f_vec_dewp_c(i),i=1,10)
      print*,'n good/bad=',i_dewp_numgood,i_dewp_numbad

      print*,'s_stnp=',(TRIM(s_vec_stnp_hpa(i)),i=1,10)
      print*,'stnp=',(f_vec_stnp_hpa(i),i=1,10)
      print*,'n good/bad=',i_stnp_numgood,i_stnp_numbad

      print*,'s_slpr=',(TRIM(s_vec_slpr_hpa(i)),i=1,10)
      print*,'slpr=',(f_vec_slpr_hpa(i),i=1,10)
      print*,'n good/bad=',i_slpr_numgood,i_slpr_numbad

      print*,'s_wdir=',(TRIM(s_vec_wdir_deg(i)),i=1,10)
      print*,'wdir=',(f_vec_wdir_deg(i),i=1,10)
      print*,'n good/bad=',i_wdir_numgood,i_wdir_numbad

      print*,'s_wspd=',(TRIM(s_vec_wspd_ms(i)),i=1,10)
      print*,'wspd=',(f_vec_wspd_ms(i),i=1,10)
      print*,'n good/bad=',i_wspd_numgood,i_wspd_numbad

      STOP 'convert_var_string_to_float'

 10   CONTINUE

c      print*,'just leaving convert_var_string_to_float'

c      STOP 'convert_var_string_to_float'

      RETURN
      END
