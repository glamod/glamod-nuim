c     Subroutine to make receipt file with line count
c     AJ_Kettle, 23Nov2020

      SUBROUTINE make_receiptfile_linecount20210207(
     +  s_directory_output_receipt_linecount,s_stnname_isolated,
     +  n_lines_obs,n_lines_header,n_lines_lite,n_lines_qcmethod)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into subroutine

      CHARACTER(LEN=*)    :: s_directory_output_receipt_linecount
      CHARACTER(LEN=*)    :: s_stnname_isolated

c     Counters for lines in obs,header,lite files
      INTEGER             :: n_lines_obs
      INTEGER             :: n_lines_header
      INTEGER             :: n_lines_lite
      INTEGER             :: n_lines_qcmethod
c*****
c     Variables used in subroutine

      INTEGER             :: i,j,k,ii,jj,kk

      CHARACTER(LEN=16)   :: s_lines_obs
      CHARACTER(LEN=16)   :: s_lines_header
      CHARACTER(LEN=16)   :: s_lines_lite
      CHARACTER(LEN=16)   :: s_lines_qcmethod

      CHARACTER(LEN=300)  :: s_line_data 
      CHARACTER(LEN=300)  :: s_line_title 

      INTEGER             :: i_len_title
      CHARACTER(LEN=4)    :: s_len_title
     
      INTEGER             :: i_len_data
      CHARACTER(LEN=4)    :: s_len_data

      CHARACTER(LEN=8)    :: s_fmt

      CHARACTER(LEN=300)  :: s_pathandname 
c************************************************************************
c      print*,'just entered make_receiptfile_linecount'

c      print*,'s_stnname_single=',TRIM(s_stnname_isolated)
c      print*,'n_lines_obs...',
c     +  n_lines_obs,n_lines_header,n_lines_lite,n_lines_qcmethod

      WRITE(s_lines_obs,'(i10)') n_lines_obs
      WRITE(s_lines_header,'(i10)') n_lines_header
      WRITE(s_lines_lite,'(i10)') n_lines_lite
      WRITE(s_lines_qcmethod,'(i10)') n_lines_qcmethod

c      print*,'s_lines_obs=',s_lines_obs
c      print*,'s_lines_header=',s_lines_header
c      print*,'s_lines_lite=',s_lines_lite
c      print*,'s_lines_qcmethod=',s_lines_qcmethod

      s_line_title='stnname|obs|header|lite|qcmethod'

      s_line_data=
     +  TRIM((s_stnname_isolated))//'|'//
     +  TRIM(ADJUSTL(s_lines_obs))//'|'//
     +  TRIM(ADJUSTL(s_lines_header))//'|'//
     +  TRIM(ADJUSTL(s_lines_lite))//'|'//
     +  TRIM(ADJUSTL(s_lines_qcmethod))

c      print*,'s_line_data=',TRIM(s_line_data)
c*****
      i_len_title=LEN_TRIM(s_line_title)
      WRITE(s_len_title,'(i4)') i_len_title

      i_len_data=LEN_TRIM(s_line_data)
      WRITE(s_len_data,'(i4)') i_len_data
c*****
      s_pathandname=
     +  TRIM(s_directory_output_receipt_linecount)//
     +  TRIM(s_stnname_isolated)

c      print*,'s_pathandname', TRIM(s_pathandname)

      OPEN(UNIT=2,
     +   FILE=TRIM(s_pathandname),
     +   FORM='formatted',
     +   STATUS='REPLACE',ACTION='WRITE')

      s_fmt='a'//TRIM(ADJUSTL(s_len_title)) 
      WRITE(2,'('//s_fmt//')') ADJUSTL(s_line_title)
      s_fmt='a'//TRIM(ADJUSTL(s_len_data)) 
      WRITE(2,'('//s_fmt//')') ADJUSTL(s_line_data)

      CLOSE(UNIT=2)
c*****
c      print*,'just leaving make_receiptfile_linecount'

      RETURN
      END
