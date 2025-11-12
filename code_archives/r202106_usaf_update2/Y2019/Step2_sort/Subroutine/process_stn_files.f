c     Subroutine to process station files
c     AJ_Kettle, 19Feb20120

      SUBROUTINE process_stn_files(s_date_st,s_time_st,
     +  s_directory_files,s_directory_file_outputsort,
     +  s_directory_file_summary, 
     +  l_files_rgh,l_files,s_vec_filenames)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into subroutine

      CHARACTER(LEN=8)    :: s_date_st
      CHARACTER(LEN=10)   :: s_time_st

      CHARACTER(LEN=300)  :: s_directory_files
      CHARACTER(LEN=300)  :: s_directory_file_outputsort
      CHARACTER(LEN=300)  :: s_directory_file_summary

      INTEGER             :: l_files_rgh
      INTEGER             :: l_files
      CHARACTER(LEN=30)   :: s_vec_filenames(l_files_rgh)
c*****
c     Variables used in subroutine
      INTEGER             :: i,j,k,ii,jj,kk

      INTEGER, PARAMETER  :: l_usaffiles_rgh=5000   !about 1200 source files
      INTEGER,PARAMETER   :: l_rgh_char=4000
      INTEGER,PARAMETER   :: l_rgh_datalines=500000 !1000000

      CHARACTER(LEN=30)   :: s_filename

      CHARACTER(l_rgh_char):: s_header

      INTEGER             :: l_datalines
      CHARACTER(LEN=l_rgh_char) :: s_linsto_unsort(l_rgh_datalines)
      CHARACTER(LEN=l_rgh_char) :: s_linsto_sort(l_rgh_datalines)
c      DOUBLE PRECISION    :: d_julday_sort(l_rgh_datalines)

      INTEGER             :: i_linpre_flag_0good1bad(l_rgh_datalines)

      CHARACTER(LEN=14)   :: s_ncdc_ob_time_st
      CHARACTER(LEN=14)   :: s_ncdc_ob_time_en

      INTEGER             :: i_linelength_min_unsort
      INTEGER             :: i_linelength_max_unsort
      INTEGER             :: i_commacount_min_unsort
      INTEGER             :: i_commacount_max_unsort

      INTEGER             :: i_linelength_min_sort
      INTEGER             :: i_linelength_max_sort
      INTEGER             :: i_commacount_min_sort
      INTEGER             :: i_commacount_max_sort

      INTEGER             :: l_cnt_usaffiles
      INTEGER             :: i_usaf_index(l_usaffiles_rgh)
      INTEGER             :: i_usaf_nlines(l_usaffiles_rgh)

c************************************************************************
      print*,'just entered process_stn_files'

      print*,'l_files_rgh=',l_files_rgh
      print*,'l_files=',l_files

      DO i=1,l_files

       print*,'i=',i,s_vec_filenames(i)

c      Get lines single file
       s_filename=s_vec_filenames(i)

c      Query file for duplicate source files from crashes
c      i_linpre_flag: flags good & bad/crashed
       CALL query_stnfile_for_duplic(
     +   s_directory_files,s_filename,
     +   l_usaffiles_rgh,l_rgh_char,l_rgh_datalines,
     +   i_linpre_flag_0good1bad)

c      Get lines single file
c      NOTE: l_datalines,s_linsto_unsort: continuous unsorted data lines
c            with crash trials removed
c      NOTE: s_header is single line with header col titles
c      NOTE: l_cnt_usaffiles,i_usaf_index,i_usaf_nlines: admin info
c            of the source USAF files where data lines came from,
c            including the crash trials
       CALL get_lines_single_file20210412(
     +   s_directory_files,s_filename,
     +   l_usaffiles_rgh,l_rgh_char,l_rgh_datalines,
     +   i_linpre_flag_0good1bad,

     +   l_datalines,s_linsto_unsort,
     +   s_header,
     +   l_cnt_usaffiles,i_usaf_index,i_usaf_nlines)

c      Sort line list
       CALL sort_line_list(l_rgh_char,l_rgh_datalines,
     +   l_datalines,s_linsto_unsort,

     +   s_linsto_sort,
     +   s_ncdc_ob_time_st,s_ncdc_ob_time_en,
     +   i_linelength_min_unsort,i_linelength_max_unsort,
     +   i_commacount_min_unsort,i_commacount_max_unsort,
     +   i_linelength_min_sort,i_linelength_max_sort,
     +   i_commacount_min_sort,i_commacount_max_sort)

c      Export sorted datalines
       CALL export_sorted_list(s_directory_file_outputsort,
     +   s_filename,
     +   l_usaffiles_rgh,l_cnt_usaffiles,i_usaf_index,i_usaf_nlines,
     +   l_rgh_char,l_rgh_datalines,l_datalines,s_linsto_sort,
     +   s_header)

c       STOP 'process_stn_files'

c      Output summary list
       CALL export_level2_summaryline(s_date_st,s_time_st,
     +   s_directory_file_summary,s_filename,
     +   l_datalines,
     +   s_ncdc_ob_time_st,s_ncdc_ob_time_en,
     +   i_linelength_min_unsort,i_linelength_max_unsort,
     +   i_commacount_min_unsort,i_commacount_max_unsort,
     +   i_linelength_min_sort,i_linelength_max_sort,
     +   i_commacount_min_sort,i_commacount_max_sort)

c       STOP 'process_stn_files'

      ENDDO

      print*,'just leaving process_stn_files'

      RETURN
      END
