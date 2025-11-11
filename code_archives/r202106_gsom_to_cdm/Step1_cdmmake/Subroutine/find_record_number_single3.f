c     Subroutine to find record number for 1 variable
c     AJ_Kettle, 01Oct2019
c     13Nov2019: modified to get bad line number
c     25Nov2019: modified handle data source_id cases not in stnconfig

      SUBROUTINE find_record_number_single3(s_var_name,
     +  i_flag,i_flag_linenumber,
     +  l_rgh_lines,l_lines,s_vec_tmax_c,s_vec_tmax_sourcenum,
     +  l_scshort,s_scshort_source_id,s_scshort_record_number,
     +  s_vec_tmax_recordnum,i_vec_tmax_qcmod_flag)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into subroutine

      CHARACTER(LEN=4)    :: s_var_name
      INTEGER             :: i_flag
      INTEGER             :: i_flag_linenumber

      INTEGER             :: l_rgh_lines
      INTEGER             :: l_lines
      CHARACTER(LEN=10)   :: s_vec_tmax_c(l_lines)
      CHARACTER(LEN=3)    :: s_vec_tmax_sourcenum(l_lines)
      CHARACTER(LEN=2)    :: s_vec_tmax_recordnum(l_lines)
      INTEGER             :: i_vec_tmax_qcmod_flag(l_lines)

      INTEGER             :: l_scshort
c      CHARACTER(LEN=3)    :: s_scshort_source_id(20)
c      CHARACTER(LEN=2)    :: s_scshort_record_number(20)
      CHARACTER(LEN=*)    :: s_scshort_source_id(20)
      CHARACTER(LEN=*)    :: s_scshort_record_number(20)
c*****
c     Variables from used in subroutine

      INTEGER             :: i,j,k,ii,jj,kk
c************************************************************************
      i_flag=0

      DO i=1,l_lines

c      Act only if variable variable present
       IF (LEN_TRIM(s_vec_tmax_c(i)).NE.0) THEN

c      Cycle through allowable source numbers
       DO j=1,l_scshort
        IF (TRIM(s_vec_tmax_sourcenum(i)).EQ.
     +      TRIM(s_scshort_source_id(j))) THEN 
         s_vec_tmax_recordnum(i)=TRIM(s_scshort_record_number(j))
         GOTO 10
        ENDIF
       ENDDO

c      set failure flag here
       i_flag=1
       i_flag_linenumber=i

       i_vec_tmax_qcmod_flag(i)=1  !set problem flag for further analysis

c       print*,'problem; source id not found'
c       print*,'s_var_name=',s_var_name
c       print*,'varvalue=',TRIM(s_vec_tmax_c(i))
c       print*,'sourcenum=',TRIM(s_vec_tmax_sourcenum(i))
c       print*,'l_scshort=',l_scshort
c       print*,'s_scshort_source_id',
c     +   ('='//TRIM(s_scshort_source_id(j))//'=',j=1,l_scshort)
c       print*,'s_scshort_record_number',
c    +   ('='//TRIM(s_scshort_record_number(j))//'=',j=1,l_scshort)

c       print*,'emergency stop; source id not found'

c      Exit analysis
c       GOTO 20

c       STOP 'find_record_number_single3'

 10    CONTINUE

       ENDIF
      ENDDO

 20   CONTINUE

      RETURN
      END
