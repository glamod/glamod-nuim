c     Subroutine to convert float to string - single element 
c     AJ_Kettle, 12Jan2019

      SUBROUTINE convert_float_to_string_single2(f_ndflag,s_format,      
     +   f_tmin_datavalue_k,
     +   s_tmin_datavalue_k)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into subroutine

      REAL                :: f_ndflag
      CHARACTER(LEN=*)    :: s_format

      REAL                :: f_tmin_datavalue_k
      CHARACTER(LEN=*)    :: s_tmin_datavalue_k
c*****
c     Variables used in program
      CHARACTER(LEN=10)   :: s_string
      INTEGER             :: i_len
c************************************************************************
      s_tmin_datavalue_k=''    !initialize string to blank
      IF (f_tmin_datavalue_k.NE.f_ndflag) THEN 
        WRITE(s_string,s_format) f_tmin_datavalue_k
        s_tmin_datavalue_k=ADJUSTL(TRIM(s_string))

        i_len=LEN_TRIM(ADJUSTL(s_string))
        IF (i_len.GE.10) THEN 
         print*,'i_len=',i_len
         print*,'s_string=',TRIM(s_string)
         STOP 'convert_float_to_string_single; string too long'
        ENDIF
      ENDIF

      RETURN
      END
