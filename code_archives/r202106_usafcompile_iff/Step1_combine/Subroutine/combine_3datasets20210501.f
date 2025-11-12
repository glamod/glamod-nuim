c     Subroutine to combine 3 datasets
c     AJ_Kettle, 26Apr2021
c     01May2021: modified 

      SUBROUTINE combine_3datasets20210501(s_date_st,s_time_st,
     +  s_directory_usaf_main,s_directory_usaf_update1,
     +  s_directory_usaf_update2,
     +  s_directory_usaf_output_files,s_directory_usaf_output_diag,
     +  s_file_linecount,
     +  l_rgh_stn,l_amal,
     +  s_vec_stnlist_amal,i_mat_stnlist_flag)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into subroutine

      CHARACTER(LEN=8)    :: s_date_st
      CHARACTER(LEN=10)   :: s_time_st

      CHARACTER(LEN=300)  :: s_directory_usaf_main
      CHARACTER(LEN=300)  :: s_directory_usaf_update1
      CHARACTER(LEN=300)  :: s_directory_usaf_update2

      CHARACTER(LEN=300)  :: s_directory_usaf_output_files
      CHARACTER(LEN=300)  :: s_directory_usaf_output_diag

      CHARACTER(LEN=300)  :: s_file_linecount

      INTEGER             :: l_amal
      INTEGER             :: l_rgh_stn
      CHARACTER(LEN=32)   :: s_vec_stnlist_amal(l_rgh_stn)
      INTEGER             :: i_mat_stnlist_flag(l_rgh_stn,3)
c*****
c     Variables used in subroutine
      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: io

      CHARACTER(LEN=300)  :: s_directory_dataroot
      CHARACTER(LEN=32)   :: s_single_stn

      INTEGER,PARAMETER   :: l_rgh_char=4000
      INTEGER,PARAMETER   :: l_rgh_datalines=1200000 !1000000 !500000 !1000000

      INTEGER             :: l_lines
      CHARACTER(l_rgh_char):: s_linsto2(l_rgh_datalines)
      CHARACTER(l_rgh_char):: s_header

      INTEGER             :: l_vec_lines(3)
c************************************************************************
      print*,'just entered combine_3datasets'

c     Cycle through all stations
      DO i=1,l_amal !12001,l_amal !1,12000 !l_amal

       s_single_stn=s_vec_stnlist_amal(i)

c       print*,'i,s_single_stn=',i,TRIM(s_single_stn)

c       STOP 'combine_3datasets20210501'

c      Cycle through 3 channels
       DO j=1,3 

c       Initialize vector
        l_vec_lines(j)=0

        IF (j.EQ.1) THEN
         s_directory_dataroot=s_directory_usaf_main
        ENDIF 
        IF (j.EQ.2) THEN
         s_directory_dataroot=s_directory_usaf_update1
        ENDIF 
        IF (j.EQ.3) THEN
         s_directory_dataroot=s_directory_usaf_update2
        ENDIF 

c       Act if station present in collection
        IF (i_mat_stnlist_flag(i,j).EQ.1) THEN 

c        Input lines single file
         CALL input_lines_1collection20210501(
     +    s_directory_dataroot,
     +    s_single_stn,
     +    l_rgh_char,l_rgh_datalines,

     +    l_lines,s_linsto2,
     +    s_header)

c        Output line collection
         CALL output_lines_1collection20210506(
     +    s_directory_usaf_output_files,
     +    s_single_stn,
     +    l_rgh_char,l_rgh_datalines,
     +    l_lines,s_linsto2,
     +    s_header)

         l_vec_lines(j)=l_lines

c         print*,'j,l_lines=',j,l_lines

         IF (l_lines.GT.l_rgh_datalines) THEN 
          print*,'too many lines'
          STOP 'combine_3datasets20210501'
         ENDIF

        ENDIF
       ENDDO  !j-index

c      Output data line record
       CALL export_stnlist_linecount20210506(s_date_st,s_time_st,
     +  s_directory_usaf_output_diag,s_file_linecount,
     +  s_single_stn,l_vec_lines, 
     +  l_amal)

       print*,'i,i_mat_stnlist_flag=',i,TRIM(s_single_stn),
     +   (i_mat_stnlist_flag(i,j),j=1,3)
c       STOP 'combine_3datasets'
c       CALL SLEEP(1)

      ENDDO   !i-index

      print*,'just leaving combine_3datasets'

c      STOP 'combine_3datasets'

      RETURN
      END
