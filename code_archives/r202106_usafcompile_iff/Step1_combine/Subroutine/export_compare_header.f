c     Subroutine to export comparison of header
c     AJ_Kettle, 04May2021

      SUBROUTINE export_compare_header(s_date_st,s_time_st,
     +  s_directory_usaf_main,s_directory_usaf_update1,
     +  s_directory_usaf_update2,
     +  s_directory_usaf_output_diag,s_file_headercompare,
     +  l_rgh_stn,
     +  l_stn_ma,s_vec_stnlist_ma,l_stn_u1,s_vec_stnlist_u1,
     +  l_stn_u2,s_vec_stnlist_u2)

      IMPLICIT NONE
c************************************************************************
c     Declare variables 

      CHARACTER(LEN=8)    :: s_date_st
      CHARACTER(LEN=10)   :: s_time_st

      CHARACTER(LEN=300)  :: s_directory_usaf_main
      CHARACTER(LEN=300)  :: s_directory_usaf_update1
      CHARACTER(LEN=300)  :: s_directory_usaf_update2

      CHARACTER(LEN=300)  :: s_directory_usaf_output_diag
      CHARACTER(LEN=300)  :: s_file_headercompare

      INTEGER             :: l_rgh_stn
      INTEGER             :: l_stn_ma
      INTEGER             :: l_stn_u1
      INTEGER             :: l_stn_u2
      CHARACTER(LEN=32)   :: s_vec_stnlist_ma(l_rgh_stn)
      CHARACTER(LEN=32)   :: s_vec_stnlist_u1(l_rgh_stn)
      CHARACTER(LEN=32)   :: s_vec_stnlist_u2(l_rgh_stn)
c*****
c     Variables used in subroutine

      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: io

      INTEGER,PARAMETER   :: l_rgh_char=4000
      CHARACTER(l_rgh_char):: s_header1,s_header2,s_header3

      INTEGER             :: l_header1,l_header2,l_header3
      CHARACTER(LEN=50)   :: s_vec_header1(200)
      CHARACTER(LEN=50)   :: s_vec_header2(200)
      CHARACTER(LEN=50)   :: s_vec_header3(200)

c************************************************************************

c     Get header 1 file
      CALL get_header_line_single_file(s_directory_usaf_main,
     +  s_vec_stnlist_ma(1),l_rgh_char,
     +  s_header1)
c     Get header 1 file
      CALL get_header_line_single_file(s_directory_usaf_update1,
     +  s_vec_stnlist_u1(1),l_rgh_char,
     +  s_header2)
c     Get header 1 file
      CALL get_header_line_single_file(s_directory_usaf_update2,
     +  s_vec_stnlist_u2(1),l_rgh_char,
     +  s_header3)
c*****
c     Separate out column headers
      CALL separate_column_headers(l_rgh_char,s_header1,
     +  l_header1,s_vec_header1)
      CALL separate_column_headers(l_rgh_char,s_header2,
     +  l_header2,s_vec_header2)
      CALL separate_column_headers(l_rgh_char,s_header3,
     +  l_header3,s_vec_header3)

      print*,'l_header1...',l_header1,l_header2,l_header3

c      DO i=1,l_header1
c       print*,'i...',i,
c     +  s_vec_header1(i),s_vec_header2(i),s_vec_header3(i)
c      ENDDO
c*****
c     Export list column headers
      CALL export_header_columns(s_date_st,s_time_st,
     +   s_directory_usaf_output_diag,s_file_headercompare, 
     +   l_header1,s_vec_header1,
     +   l_header2,s_vec_header2,l_header3,s_vec_header3)
c*****
c      STOP 'export_compare_header'

      RETURN
      END
