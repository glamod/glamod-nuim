c     Subroutine to convert float to string
c     AJ_Kettle, 08Jan2019

      SUBROUTINE convert_integer_to_string2(f_ndflag,s_format,      
     +   l_timestamp_rgh,l_timestamp,f_prcp_datavalue_mm,
     +   s_prcp_datavalue_mm)    

      IMPLICIT NONE
c************************************************************************
      REAL                :: f_ndflag

      CHARACTER(LEN=*)    :: s_format

      INTEGER             :: l_timestamp_rgh
      INTEGER             :: l_timestamp

      REAL                :: f_prcp_datavalue_mm(l_timestamp_rgh)
      CHARACTER(LEN=*)    :: s_prcp_datavalue_mm(l_timestamp_rgh)
c*****
c     Variables used in program

      INTEGER             :: i,j,k,ii,jj,kk
      CHARACTER(LEN=10)   :: s_string

      INTEGER             :: i_len
c************************************************************************
c      print*,'just entered convert_integer_to_string'

      DO i=1,l_timestamp
       s_prcp_datavalue_mm(i)=''    !initialize string to blank
       IF (f_prcp_datavalue_mm(i).NE.f_ndflag) THEN 
        WRITE(s_string,s_format) NINT(f_prcp_datavalue_mm(i))
        s_prcp_datavalue_mm(i)=ADJUSTL(TRIM(ADJUSTL(s_string)))

        i_len=LEN_TRIM(ADJUSTL(s_string))  !LEN_TRIM(s_string)
        IF (i_len.GE.10) THEN 
         print*,'i_len=',i_len
         print*,'s_format=',TRIM(s_format)
         print*,'f_prcp_datavalue_mm=',f_prcp_datavalue_mm(i)
         print*,'nint value=',NINT(f_prcp_datavalue_mm(i))
         print*,'s_string=',TRIM(s_string)
         STOP 'convert_integer_to_string; string too long'
        ENDIF

       ENDIF
      ENDDO

c      print*,'just leaving convert_integer_to_string'

      RETURN
      END
