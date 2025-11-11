c     Subroutine to convert string vector to float vector
c     AJ_Kettle, 11Dec2018

      SUBROUTINE convert_variable_column2(f_ndflag,f_convertfactor,
     +   l_timestamp_rgh,l_timestamp,s_prcp_datavalue,

     +   f_prcp_datavalue)     

      IMPLICIT NONE
c************************************************************************
c     Declare variables passed into program

      REAL                :: f_ndflag
      REAL                :: f_convertfactor

      INTEGER             :: l_timestamp_rgh
      INTEGER             :: l_timestamp

      CHARACTER(LEN=5)    :: s_prcp_datavalue(l_timestamp_rgh)
      REAL                :: f_prcp_datavalue(l_timestamp_rgh)
c*****
c     Variables used inside program
      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: i_len

      REAL                :: f_prelim
c************************************************************************
c      print*,'just inside convert_variable_column'

      DO i=1,l_timestamp
       f_prcp_datavalue(i)=f_ndflag   !initial float to f_ndflag

       i_len=LEN_TRIM(s_prcp_datavalue(i))

c      Act if string length>0
       IF (i_len.GT.0) THEN
        READ(s_prcp_datavalue(i),*) f_prelim
        f_prcp_datavalue(i)=f_prelim*f_convertfactor
       ENDIF

c      read(string,*)b
      ENDDO

c      print*,'just leaving convert_variable_column'
c************************************************************************
      RETURN
      END
