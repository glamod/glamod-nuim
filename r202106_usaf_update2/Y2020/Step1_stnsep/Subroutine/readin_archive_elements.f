c     Subroutine to readin archive elements
c     AJ_Kettle, 29Jan2020

      SUBROUTINE readin_archive_elements(l_filelist,s_vec_filelist,
     +  i_vec_index,i_vec_flagst,i_vec_flagen)

      IMPLICIT NONE
c************************************************************************
c     Declare variables 
      INTEGER             :: l_filelist
      CHARACTER(LEN=300)  :: s_vec_filelist(2000)

      INTEGER             :: i_vec_index(2000)
      INTEGER             :: i_vec_flagst(2000)
      INTEGER             :: i_vec_flagen(2000)
c*****
c     Variables used in subroutine

      INTEGER             :: i,j,k,ii,jj,kk

      CHARACTER(LEN=300)  :: s_file_single

      INTEGER             :: i_single_index
      INTEGER             :: i_single_flagst
      INTEGER             :: i_single_flagen
c************************************************************************
c      print*,'just entered readin_archive_elements'

      DO i=1,l_filelist
       s_file_single=s_vec_filelist(i)

c       print*,'i=',i,TRIM(s_file_single)

c      Get elements single file
       CALL get_elements_single_file(s_file_single,
     +   i_single_index,i_single_flagst,i_single_flagen)

c       print*,'back inside readin_archive_elements'
c       print*,'i_single_flagst=',i_single_flagst
c       print*,'i_single_flagen=',i_single_flagen

       i_vec_index(i)  =i_single_index
       i_vec_flagst(i) =i_single_flagst
       i_vec_flagen(i) =i_single_flagen

      ENDDO

c      print*,'i_vec_index=',(i_vec_index(i),i=1,l_filelist)
c      print*,'i_vec_flagst=',(i_vec_flagst(i),i=1,l_filelist)
c      print*,'i_vec_flagen=',(i_vec_flagen(i),i=1,l_filelist)

c      print*,'just leaving readin_archive_elements'

c      STOP 'readin_archive_elements'

      RETURN
      END
