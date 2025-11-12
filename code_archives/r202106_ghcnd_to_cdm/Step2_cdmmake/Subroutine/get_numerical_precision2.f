c     Subroutine get numerical precision from original precision
c     AJ_Kettle, 15Jan2019

      SUBROUTINE get_numerical_precision2(l_channel,
     +   s_vec_original_prec,s_vec_numerical_precision)

      IMPLICIT NONE
c************************************************************************
c     Declare variables passed into program

      INTEGER             :: l_channel
      CHARACTER(LEN=*)    :: s_vec_original_prec(l_channel)
      CHARACTER(LEN=*)    :: s_vec_numerical_precision(l_channel)
c*****
c     Variables used in subroutine
      INTEGER             :: i,j,k,ii,jj,kk
c************************************************************************
c       print*,'just entered get_numerical_precision'

c     Initialize with null values
      DO i=1,l_channel
       s_vec_numerical_precision(i)=''
      ENDDO

      s_vec_numerical_precision(1)=TRIM(s_vec_original_prec(1))
      s_vec_numerical_precision(2)='0.01'   !C to K conversion
      s_vec_numerical_precision(3)='0.01'   !C to K conversion
      s_vec_numerical_precision(4)='0.01'   !C to K conversion

c*****
      IF (TRIM(s_vec_original_prec(5)).EQ.'1') THEN 
       s_vec_numerical_precision(5)='0.1'    !mm to cm conversion
       GOTO 10
      ENDIF
      IF (TRIM(s_vec_original_prec(5)).EQ.'10') THEN 
       s_vec_numerical_precision(5)='1'    !mm to cm conversion
       GOTO 10
      ENDIF
      IF (TRIM(s_vec_original_prec(5)).EQ.'100') THEN 
       s_vec_numerical_precision(5)='10'    !mm to cm conversion
       GOTO 10
      ENDIF
      IF (TRIM(s_vec_original_prec(5)).EQ.'1000') THEN 
       s_vec_numerical_precision(5)='100'   !mm to cm conversion
       GOTO 10
      ENDIF
      IF (TRIM(s_vec_original_prec(5)).EQ.'10000') THEN 
       s_vec_numerical_precision(5)='1000'    !mm to cm conversion
       GOTO 10
      ENDIF

c      print*,'precision for snow depth not found',s_vec_original_prec(6)
c      STOP 'get_numerical_precision'

 10   CONTINUE
c*****
      s_vec_numerical_precision(6)=TRIM(s_vec_original_prec(6))
      s_vec_numerical_precision(7)=TRIM(s_vec_original_prec(7))
      s_vec_numerical_precision(8)=TRIM(s_vec_original_prec(8))

c      print*,'just leaving get_numerical_precision'

      RETURN
      END
