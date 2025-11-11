c     Subroutine to find variable indices
c     AJ_Kettle, 06Nov2018

      SUBROUTINE find_variable_indices(l_width_rgh,l_field_rgh,
     +  l_field,s_vec_header,
     +  l_varselect,s_varselect,
     +  i_index_locate)

c************************************************************************
c     Variables passed into program

      INTEGER             :: l_field
      INTEGER             :: l_field_rgh
      CHARACTER(LEN=l_width_rgh) :: s_vec_header(l_field_rgh)

      CHARACTER(LEN=4)    :: s_varselect(6)
      INTEGER             :: l_varselect
      INTEGER             :: i_index_locate(6)
c*****
      INTEGER             :: i,j,k,ii,jj,kk

      INTEGER             :: i_vec_cnt(6)
c************************************************************************
c      print*,'just entered find_variable_indices'

c      print*,'s_varselect=',(TRIM(s_varselect(i)),i=1,l_varselect)

c      print*,'l_field=',l_field
c      print*,'s_vec_header=',(TRIM(s_vec_header(i)),i=1,l_field)

c     Initialize counter variable
      DO i=1,l_varselect
       i_vec_cnt(i)=0
       i_index_locate(i)=-999    !ndflag is -999
      ENDDO

c     Conduct search
      DO i=1,l_field 
       DO j=1,l_varselect
c        print*,'"'//TRIM(s_varselect(j))//'"'
        IF (TRIM(s_vec_header(i)).EQ.'"'//TRIM(s_varselect(j))//'"') 
     +    THEN
         i_vec_cnt(j)=i_vec_cnt(j)+1
         i_index_locate(j)=i
        ENDIF
       ENDDO
      ENDDO

c     Check if counter duplicated
      DO i=1,l_varselect
       IF (i_vec_cnt(i).GT.1) THEN 
        print*,'i_vec_cnt=',(i_vec_cnt(j),j=1,6)
        STOP 'i_vec_cnt>1; find_variable_indices'
       ENDIF
      ENDDO

c      print*,'i_vec_cnt=',(i_vec_cnt(i),i=1,6)
c      print*,'i_index_locate=',(i_index_locate(i),i=1,6)

c      print*,'just leaving find variable_indices'

      RETURN
      END
