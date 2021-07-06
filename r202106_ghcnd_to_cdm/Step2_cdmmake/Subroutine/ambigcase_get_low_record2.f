c     Subroutine to get record number in case of ambiguity
c     AJ_Kettle, 16Jan2019

      SUBROUTINE ambigcase_get_low_record2(s_variable_single,
     +  s_single_sourceid,
     +  l_collect_cnt,s_collect_source_id,s_collect_record_number,
     +  s_record_numberchosen, 
     +  i_flag_skip)

c************************************************************************
c     Declare variables passed into program

      CHARACTER(LEN=*)    :: s_variable_single           !len=4
      CHARACTER(LEN=*)    :: s_single_sourceid           !len=3
      INTEGER             :: l_collect_cnt
      CHARACTER(LEN=*)    :: s_collect_source_id(20)     !len=3
      CHARACTER(LEN=*)    :: s_collect_record_number(20) !len=3
      CHARACTER(LEN=*)    :: s_record_numberchosen       !len=3

      INTEGER             :: i_flag_skip
c*****
c     Variables used in subroutine

      INTEGER             :: i,j,k,ii,jj,kk
      CHARACTER(LEN=3)    :: s_sift_source_id(20)
      CHARACTER(LEN=3)    :: s_sift_record_number(20)
c************************************************************************
c      print*,'just entered ambigcase_get_low_record'

      ii=0
      i_flag_skip=0     !initialize skip flag

      DO i=1,l_collect_cnt
       IF (TRIM(s_single_sourceid).EQ.s_collect_source_id(i)) THEN 
        ii=ii+1
        s_sift_source_id(ii)    =s_collect_source_id(i)
        s_sift_record_number(ii)=s_collect_record_number(i)
       ENDIF
      ENDDO

      IF (ii.GT.0) THEN 
       s_record_numberchosen=s_sift_record_number(1)
      ENDIF
      IF (ii.EQ.0) THEN
       print*,'variable source_id not found in list'
       print*,'s_variable_single=',TRIM(s_variable_single)
       print*,'l_collect_cnt=',l_collect_cnt
       print*,'s_single_sourceid='//TRIM(s_single_sourceid)//'='
       print*,'s_collect_source_id=',
     +   ('='//TRIM(s_collect_source_id(i))//'=',i=1,l_collect_cnt)

c      Case of source_id 165
       IF (TRIM(s_single_sourceid).EQ.'165') THEN
        print*,'ambiguous case for source_id=165; skip activated'
        s_record_numberchosen=''  !set record number to blank 
        i_flag_skip=1       !flag to skip printing
c        STOP 'ambigcase_get_low_record; known source_id 165 problem'
       ENDIF

c      Case of source_id not 165
       IF (TRIM(s_single_sourceid).NE.'165') THEN
        print*,'s_single_sourceid=',s_single_sourceid
        i_flag_skip=1
c        STOP 'ambigcase_get_low_record; emergency stop; odd source_id'
        print*,'skip procedure'
       ENDIF

      ENDIF

c      print*,'ii=',ii
c      print*,'s_sift_source_id=',
c     +  ('='//TRIM(s_sift_source_id(i))//'=',i=1,ii)
c      print*,'s_sift_record_number=',
c     +  ('='//TRIM(s_sift_record_number(i))//'=',i=1,ii)
c      print*,'s_record_numberchosen=',TRIM(s_record_numberchosen)

c      print*,'just leaving ambigcase_get_low_record'

c      STOP 'ambigcase_get_low_record'

      RETURN
      END
