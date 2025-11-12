c     Subroutine to assess converted precision
c     AJ_Kettle, 10Dec2019

      SUBROUTINE assess_convprec_pressure(
     +    s_vec_stnp_origprec_empir_hpa_single,
     +    s_vec_stnp_convprec_empir_pa_single)

      IMPLICIT NONE
c************************************************************************
      CHARACTER(LEN=*)    :: s_vec_stnp_origprec_empir_hpa_single
      CHARACTER(LEN=*)    :: s_vec_stnp_convprec_empir_pa_single
c************************************************************************

      IF (LEN_TRIM(s_vec_stnp_origprec_empir_hpa_single).EQ.0) THEN 
       print*,'emergency stop, no value input precision'
c       STOP 'assess_convprec_pressure'

       GOTO 10
      ENDIF

      IF (TRIM(s_vec_stnp_origprec_empir_hpa_single).EQ.'100') THEN
       s_vec_stnp_convprec_empir_pa_single='10000'
       GOTO 10
      ENDIF
      IF (TRIM(s_vec_stnp_origprec_empir_hpa_single).EQ.'10') THEN
       s_vec_stnp_convprec_empir_pa_single='1000'
       GOTO 10
      ENDIF
      IF (TRIM(s_vec_stnp_origprec_empir_hpa_single).EQ.'1') THEN
       s_vec_stnp_convprec_empir_pa_single='100'
       GOTO 10
      ENDIF
      IF (TRIM(s_vec_stnp_origprec_empir_hpa_single).EQ.'0.1') THEN
       s_vec_stnp_convprec_empir_pa_single='10'
       GOTO 10
      ENDIF
      IF (TRIM(s_vec_stnp_origprec_empir_hpa_single).EQ.'0.01') THEN
       s_vec_stnp_convprec_empir_pa_single='1'
       GOTO 10
      ENDIF
      IF (TRIM(s_vec_stnp_origprec_empir_hpa_single).EQ.'0.001') THEN
       s_vec_stnp_convprec_empir_pa_single='0.1'
       GOTO 10
      ENDIF

      print*,'emergency stop; converted precision failed'
      print*,'s_vec_stnp_origprec_empir_hpa_single='//
     +  s_vec_stnp_origprec_empir_hpa_single//'='
      STOP 'assess_convprec_pressure'

 10   CONTINUE

      RETURN
      END
