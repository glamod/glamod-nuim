c     Subroutine to find record number for 1 variable
c     AJ_Kettle, 01Oct2019
c     13Nov2019: modified to get bad line number
c     25Nov2019: modified handle data source_id cases not in stnconfig
c     10Dec2019: modified for QFF conversion

      SUBROUTINE find_record_number_qff20200617b(
     +  s_directory_output_diagnostics,s_stnname_isolated,
     +  s_var_name,
     +  i_flag,i_flag_linenumber,
     +  l_rgh_lines,l_lines,s_vec_airt_c,s_vec_airt_sourcenum,
     +  l_cc_rgh,l_collect_cnt,
     +  s_collect_source_id,s_collect_record_number,
     +  s_vec_airt_recordnum,i_vec_airt_qcmod_flag)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into subroutine

      CHARACTER(LEN=*)    :: s_directory_output_diagnostics
      CHARACTER(LEN=*)    :: s_stnname_isolated

      CHARACTER(LEN=*)    :: s_var_name
      INTEGER             :: i_flag
      INTEGER             :: i_flag_linenumber

      INTEGER             :: l_rgh_lines
      INTEGER             :: l_lines
      CHARACTER(LEN=*)    :: s_vec_airt_c(l_rgh_lines)
      CHARACTER(LEN=*)    :: s_vec_airt_sourcenum(l_rgh_lines)
      CHARACTER(LEN=*)    :: s_vec_airt_recordnum(l_rgh_lines)
      INTEGER             :: i_vec_airt_qcmod_flag(l_rgh_lines)

      INTEGER             :: l_cc_rgh
      INTEGER             :: l_collect_cnt
      CHARACTER(LEN=*)    :: s_collect_source_id(l_cc_rgh)
      CHARACTER(LEN=*)    :: s_collect_record_number(l_cc_rgh)
c*****
c     Variables from used in subroutine

      INTEGER             :: i,j,k,ii,jj,kk

      CHARACTER(LEN=3)    :: s_single_char3_data
      CHARACTER(LEN=3)    :: s_single_char3_stnconfig

      INTEGER             :: i_single_data,i_single_stnconfig
c************************************************************************
c      print*,'just entered find_record_number_qff20200617b'

c      print*,'s_var_name=',s_var_name
c      print*,'l_rgh_lines=',l_rgh_lines
c      print*,'l_lines=',l_lines
c      print*,'l_cc_rgh=',l_cc_rgh
c      print*,'l_collect_cnt=',l_collect_cnt

c      DO i=1,5
c       print*,'i...',
c     +  TRIM(s_vec_airt_c(i))//'='//
c     +  TRIM(s_vec_airt_sourcenum(i))//'='//
c     +  TRIM(s_vec_airt_recordnum(i))//'='
c      ENDDO

      i_flag=0

      DO i=1,l_lines

c      Act only if variable variable present
       IF (LEN_TRIM(s_vec_airt_c(i)).NE.0) THEN

c      Cycle through allowable source numbers
       DO j=1,l_collect_cnt
c        print*,'i,j...',i,j,'='//TRIM(s_vec_airt_sourcenum(i))//'='//
c     +          TRIM(s_collect_source_id(j))//'='
  
        s_single_char3_data     =ADJUSTL(s_vec_airt_sourcenum(i))
        s_single_char3_stnconfig=ADJUSTL(s_collect_source_id(j))

c        WRITE(s_collect_source_id(j),'(i3)') i_single_data
c        WRITE(s_vec_airt_sourcenum(i),'(i3)') i_single_stnconfig

c        WRITE(s_single_char3_data,'(i3)') i_single_data
c        WRITE(s_single_char3_stnconfig,'(i3)') i_single_stnconfig

c        print*,'integers...',i_single_data,i_single_stnconfig

c        print*,'lentrim...',
c     +   LEN_TRIM(s_single_char3_data),
c     +   LEN_TRIM(s_single_char3_stnconfig)

c        print*,'singles..',
c     +    TRIM(s_single_char3_data(1:3))//'='//
c     +    TRIM(s_single_char3_stnconfig(1:3))
c        IF (s_single_char3_data(2:3).EQ.s_single_char3_stnconfig(1:2)) 
c     +    THEN
c         print*,'condamet'
c        ENDIF

        IF (ADJUSTL(s_vec_airt_sourcenum(i)).EQ.
     +      ADJUSTL(s_collect_source_id(j))) THEN
c         print*,'condition met' 
         s_vec_airt_recordnum(i)=TRIM(s_collect_record_number(j))
         GOTO 10
        ENDIF
       ENDDO

c      set failure flag here
       i_flag=1
       i_flag_linenumber=i

       i_vec_airt_qcmod_flag(i)=1  !set problem flag for further analysis

       print*,'problem; source id not found'
       print*,'s_var_name=',s_var_name
       print*,'varvalue=',TRIM(s_vec_airt_c(i))
       print*,'presented sourcenum='//TRIM(s_vec_airt_sourcenum(i))//'='
       print*,'l_collect_cnt=',l_collect_cnt
       print*,'s_collect_source_id',
     +   ('='//TRIM(s_collect_source_id(j))//'=',j=1,l_collect_cnt)
       print*,'s_collect_record_number',
     +  ('='//TRIM(s_collect_record_number(j))//'=',j=1,l_collect_cnt)

       print*,'s_directory_output_diagnostics=',
     +   TRIM(s_directory_output_diagnostics)
       print*,'s_stnname_isolated=',TRIM(s_stnname_isolated)

       CALL export_record_number_problem20201016(
     +  s_directory_output_diagnostics,s_stnname_isolated,
     +  s_var_name,s_vec_airt_c(i),s_vec_airt_sourcenum(i),
     +  l_cc_rgh,l_collect_cnt,
     +  s_collect_source_id,s_collect_record_number,
     +  i_flag_linenumber)

       print*,'i_flag=',i_flag
       print*,'i_flag_linenumber=',i_flag_linenumber,i

       print*,'emergency stop; source id not found'

c       STOP 'find_record_number_qff20200617b'

c      Exit analysis
       GOTO 20

 10    CONTINUE

       ENDIF
      ENDDO

 20   CONTINUE

c      print*,'exit i_flag=',i_flag

c      DO i=1,5
c       print*,'i...',
c     +  TRIM(s_vec_airt_c(i))//'='//
c     +  TRIM(s_vec_airt_sourcenum(i))//'='//
c     +  TRIM(s_vec_airt_recordnum(i))//'='
c      ENDDO

c      print*,'just leaving find_record_number_qff20200617b'

      RETURN
      END
