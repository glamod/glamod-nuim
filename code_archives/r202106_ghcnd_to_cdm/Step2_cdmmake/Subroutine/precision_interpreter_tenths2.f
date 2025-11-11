c     Subroutine to make output precision
c     AJ_Kettle, 13Dec2018

      SUBROUTINE precision_interpreter_tenths2(i_prec_empir_prcp,
     +  s_prec_empir_prcp_mm)

      IMPLICIT NONE
c************************************************************************
c     Declare variables passed into program

      INTEGER             :: i_prec_empir_prcp   !tenths
      CHARACTER(LEN=10)   :: s_prec_empir_prcp_mm
c************************************************************************
      s_prec_empir_prcp_mm=''
      IF (i_prec_empir_prcp.EQ.-999) THEN 
       s_prec_empir_prcp_mm=''
       GOTO 10
      ENDIF
      IF (i_prec_empir_prcp.EQ.0) THEN 
       s_prec_empir_prcp_mm='0.1'
       GOTO 10
      ENDIF
      IF (i_prec_empir_prcp.EQ.1) THEN 
       s_prec_empir_prcp_mm='1'
       GOTO 10
      ENDIF
      IF (i_prec_empir_prcp.EQ.2) THEN 
       s_prec_empir_prcp_mm='10'
       GOTO 10
      ENDIF
      IF (i_prec_empir_prcp.EQ.3) THEN 
       s_prec_empir_prcp_mm='100'
       GOTO 10
      ENDIF
      IF (i_prec_empir_prcp.EQ.4) THEN 
       s_prec_empir_prcp_mm='1000'
       GOTO 10
      ENDIF

      print*,'not found i_prec_empir_prcp=',i_prec_empir_prcp
      STOP 'precision_interpreter_tenths; emergency stop'

 10   CONTINUE

      RETURN
      END
