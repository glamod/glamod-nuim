c     Subroutine to export single file name
c     AJ_Kettle, 24Jul2021

      SUBROUTINE export_file_name(
     +    s_directory_output_diagnostics_notthere,s_stnname_isolated)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into subroutine

      CHARACTER(LEN=*)    :: s_directory_output_diagnostics_notthere
      CHARACTER(LEN=*)    :: s_stnname_isolated
c*****
c     Variables used in subroutine

      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: io

      INTEGER             :: i_len
      CHARACTER(LEN=2)    :: s_len 
      CHARACTER(LEN=3)    :: s_fmt 

c************************************************************************
c      print*,'just inside export_file_name'

c      print*,'s_stnname_isolated=',TRIM(s_stnname_isolated)
c      print*,'dir=',TRIM(s_directory_output_diagnostics_notthere)

      i_len=LEN_TRIM(s_stnname_isolated)
      WRITE(s_len,'(i2)') i_len

c      print*,'s_stnname_isolated=',i_len,s_stnname_isolated

      OPEN(UNIT=2,
     +  FILE=TRIM(s_directory_output_diagnostics_notthere)//
     +       TRIM(s_stnname_isolated),
     +  FORM='formatted',STATUS='REPLACE',ACTION='WRITE')    

      s_fmt='a'//TRIM(ADJUSTL(s_len))
      WRITE(2,'('//s_fmt//')') 
     +   ADJUSTL(s_stnname_isolated)   !good

      CLOSE(unit=2)

c      print*,'just leaving export_file_name'
c      STOP 'export_file_name'

      RETURN
      END
