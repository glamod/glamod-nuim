c     Subroutine read in file lines & append them in new file
c     AJ_Kettle, 09Jan2020
c     27Apr2020: used for 01May2020 release

      SUBROUTINE get_lines_append_stnconfig(
     +  s_date_st,s_time_st,s_zone_st,
     +  s_directory_receipt,s_directory_assemblereceipt,
     +  l_rgh_stn,l_stn,
     +  s_filelist_stations,
     +  s_filename_out)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into subroutine
      CHARACTER(LEN=8)    :: s_date_st
      CHARACTER(LEN=10)   :: s_time_st
      CHARACTER(LEN=5)    :: s_zone_st

      CHARACTER(LEN=300)  :: s_directory_receipt
      CHARACTER(LEN=300)  :: s_directory_assemblereceipt

      INTEGER             :: l_rgh_stn
      INTEGER             :: l_stn
      CHARACTER(LEN=300)  :: s_filelist_stations(l_rgh_stn)

      CHARACTER(LEN=300)  :: s_filename_out
c*****
c     Variables used in subroutine
      INTEGER             :: i,j,k,ii,jj,kk

      INTEGER, PARAMETER  :: l_rgh=100000
      INTEGER             :: l_lines
      CHARACTER(LEN=1000) :: s_vec_lines(l_rgh) 

      CHARACTER(LEN=300)  :: s_file_single
      CHARACTER(LEN=300)  :: s_pathandname
      CHARACTER(LEN=300)  :: s_pathandname_out
c************************************************************************
      print*,'just entered get_lines_append_stnconfig'

      DO i=1,l_stn 

       s_file_single=s_filelist_stations(i)
       s_pathandname=TRIM(s_directory_receipt)//TRIM(s_file_single)

       s_pathandname_out=
     +   TRIM(s_directory_assemblereceipt)//TRIM(s_filename_out)

       print*,'s_file_single=',i,TRIM(s_file_single)
c       print*,'s_pathandname=',i,TRIM(s_pathandname)

c      Get lines from single file
       CALL get_lines_single_qcfile(s_pathandname,
     +   l_rgh,l_lines,s_vec_lines)

c       print*,'l_lines=',l_lines
c       DO j=1,l_lines 
c        print*,'j=',j,TRIM(s_vec_lines(j))
c       ENDDO

c      Export lines to cumulative file
c      Condition for export that file must have more than just header
       IF (l_lines.GT.1) THEN 
        CALL export_assemble20210209(s_date_st,s_time_st,s_zone_st,
     +   s_pathandname_out,
     +   l_rgh,l_lines,s_vec_lines)
       ENDIF

c       CALL SLEEP(1)

      ENDDO

      print*,'just leaving get_lines_append_stnconfig'

      RETURN
      END
