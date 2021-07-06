c     Subroutine to find variable indices
c     AJ_Kettle, 06Nov2018

      SUBROUTINE find_variable_index_single(l_width_rgh,l_field_rgh,
     +  l_field,s_vec_header,
     +  s_string_find,
     +  i_index_single)

c************************************************************************
c     Variables passed into program

      INTEGER             :: l_field
      INTEGER             :: l_field_rgh
      CHARACTER(LEN=l_width_rgh) :: s_vec_header(l_field_rgh)

      CHARACTER(LEN=*)    :: s_string_find
      INTEGER             :: i_index_single
c*****
      INTEGER             :: i,j,k,ii,jj,kk

      INTEGER             :: i_cnt
c************************************************************************
c      print*,'just entered find_variable_indices'

c      print*,'s_varselect=',(TRIM(s_varselect(i)),i=1,l_varselect)

c      print*,'l_field=',l_field
c      print*,'s_vec_header=',(TRIM(s_vec_header(i)),i=1,l_field)

c     Initialize counter variable
      i_cnt=0
      i_index_single=-999    !ndflag is -999

c     Conduct search
      DO i=1,l_field 
        IF (TRIM(s_vec_header(i)).EQ.'"'//TRIM(s_string_find)//'"') THEN
         i_cnt=i_cnt+1
         i_index_single=i
        ENDIF
      ENDDO

c     Check if counter duplicated
      IF (i_cnt.GT.1) THEN 
        print*,'i_vec_cnt=',i_cnt
        STOP 'i_vec_cnt>1; find_variable_index_single'
      ENDIF

c      print*,'i_cnt=',i_cnt
c      print*,'i_index_single=',i_index_single

c      print*,'just leaving find variable_index_single'

      RETURN
      END
