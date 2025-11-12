c     Subroutine to print qcmethod info
c     AJ_Kettle, 22Nov2020

      SUBROUTINE sample_screenprint_qcmethod(
     +   s_qcmethod_observation_id,s_qcmethod_report_id,
     +   s_qcmethod_qc_method,s_qcmethod_quality_flag)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into program
      CHARACTER(LEN=50)   :: s_qcmethod_observation_id
      CHARACTER(LEN=50)   :: s_qcmethod_report_id
      CHARACTER(LEN=50)   :: s_qcmethod_qc_method
      CHARACTER(LEN=50)   :: s_qcmethod_quality_flag

c*****
c     Variables used in subroutine

      INTEGER             :: i,j,k
c************************************************************************

         print*,'1.s_qcmethod_observation_id='//
     +     TRIM(s_qcmethod_observation_id)//'='
         print*,'2.s_qcmethod_report_id='//
     +     TRIM(s_qcmethod_report_id)//'='
         print*,'3.s_qcmethod_qc_method='//
     +     TRIM(s_qcmethod_qc_method)//'='
         print*,'4.s_qcmethod_quality_flag='//
     +     TRIM(s_qcmethod_quality_flag)//'='

      RETURN
      END
