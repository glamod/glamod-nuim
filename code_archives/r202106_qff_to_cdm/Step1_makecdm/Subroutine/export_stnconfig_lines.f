c     Subroutine to export receipt files
c     AJ_Kettle, 08Aug2019
c     21Oct2019: tranferred to GSOM

      SUBROUTINE export_stnconfig_lines(s_directory_output_receipt,
     +  s_stnname_single,
     +  l_cc_rgh,l_collect_cnt,l_scoutput_numfield,
     +  i_record_hist_integrate,
     +  s_collect_datalines_output,
     +  s_scoutput_vec_header)

      IMPLICIT NONE
c************************************************************************
c     Declare variables passed into subroutine

      CHARACTER(LEN=300)  :: s_directory_output_receipt

      CHARACTER(LEN=*)    :: s_stnname_single

      INTEGER             :: l_cc_rgh
      INTEGER             :: l_collect_cnt
      INTEGER             :: l_scoutput_numfield

      INTEGER             :: i_record_hist_integrate(l_cc_rgh)
      CHARACTER(LEN=*)    :: s_collect_datalines_output(l_cc_rgh,50)
      CHARACTER(LEN=*)    :: s_scoutput_vec_header(50)
c*****
c     Variables used within subroutine

      INTEGER             :: i,j,k,ii,jj,kk

      CHARACTER(LEN=300)  :: s_pathandname_receipt

      CHARACTER(LEN=1000) :: s_receipt_header_assemble_pre
      CHARACTER(LEN=1000) :: s_receipt_data_assemble_pre
      CHARACTER(LEN=1000) :: s_receipt_header_assemble
      CHARACTER(LEN=1000) :: s_receipt_data_assemble

      INTEGER             :: i_len
      CHARACTER(LEN=4)    :: s_len

      CHARACTER(LEN=10)   :: s_fmt
c************************************************************************
c      print*,'just inside export_stnconfig_lines'

c      print*,'l_scoutput_numfield=',l_scoutput_numfield

c      print*,'s_scoutput_vec_header=',
c     +  (TRIM(s_scoutput_vec_header(i)),i=1,l_scoutput_numfield)

      s_pathandname_receipt=TRIM(s_directory_output_receipt)//
     +  TRIM(s_stnname_single)//'.dat'

c      print*,'s_pathandname_receipt=',TRIM(s_pathandname_receipt)

      OPEN(UNIT=2,
     +   FILE=TRIM(s_pathandname_receipt),
     +   FORM='formatted',
     +   STATUS='REPLACE',ACTION='WRITE')

c     Assemble header line
      s_receipt_header_assemble_pre=''
      DO i=1,l_scoutput_numfield
       s_receipt_header_assemble_pre=
     +   TRIM(s_receipt_header_assemble_pre)//
     +   TRIM(s_scoutput_vec_header(i))//'|'
      ENDDO

      i_len=LEN_TRIM(s_receipt_header_assemble_pre)
      WRITE(s_len,'(i4)') i_len

c     Take assembled obs without last pipe
      s_receipt_header_assemble=
     +  s_receipt_header_assemble_pre(1:i_len-1)

c      print*,'s_receipt_header_assemble='//
c     +  TRIM(s_receipt_header_assemble)
c      print*,'i_len,s_len=',i_len,s_len

      s_fmt='a'//TRIM(ADJUSTL(s_len)) 
      WRITE(2,'('//s_fmt//')') ADJUSTL(s_receipt_header_assemble_pre)   !good

c      STOP 'export_stnconfig_lines'

      DO i=1,l_collect_cnt
       print*,'i_record_hist_integrate=',i,i_record_hist_integrate(i)
 
c      Output line only measurements present
       IF (i_record_hist_integrate(i).GT.0) THEN 

c       Assemble data line
        s_receipt_data_assemble_pre=''
        DO j=1,l_scoutput_numfield
         s_receipt_data_assemble_pre=TRIM(s_receipt_data_assemble_pre)//
     +     TRIM(s_collect_datalines_output(i,j))//'|'
        ENDDO

        i_len=LEN_TRIM(s_receipt_data_assemble_pre)
        WRITE(s_len,'(i4)') i_len

c       Take assembled obs without last pipe
        s_receipt_data_assemble=
     +    s_receipt_data_assemble_pre(1:i_len-1)

c      print*,'s_receipt_data_assemble='//
c     +  TRIM(s_receipt_data_assemble)
c      print*,'i_len,s_len=',i_len,s_len
c      print*,'l_scoutput_numfield'

        s_fmt='a'//TRIM(ADJUSTL(s_len)) 
        WRITE(2,'('//s_fmt//')') ADJUSTL(s_receipt_data_assemble_pre)   !good

       ENDIF

c       IF (i_record_hist_integrate(i).EQ.0) THEN 
c        print*,'record number not used'
c        STOP
c       ENDIF

      ENDDO

      CLOSE(UNIT=2)

c      print*,'just leaving export_stnconfig_lines'

      RETURN
      END
