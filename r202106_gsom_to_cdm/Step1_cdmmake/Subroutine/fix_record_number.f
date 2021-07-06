c     Subroutine to correct record number if information available 
c     AJ_Kettle, 26Nov2019

      SUBROUTINE fix_record_number(l_rgh_lines,l_lines, 
     +  i_vec_snow_qcmod_flag,i_cnt_recordnum,s_mat_recordnum,
     +  s_vec_snow_recordnum)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into subroutine

      INTEGER             :: l_rgh_lines
      INTEGER             :: l_lines
 
      INTEGER             :: i_vec_snow_qcmod_flag(l_rgh_lines)
      INTEGER             :: i_cnt_recordnum(l_rgh_lines)
      CHARACTER(*)        :: s_mat_recordnum(l_rgh_lines,6)      !len=2

      CHARACTER(*)        :: s_vec_snow_recordnum(l_rgh_lines)
c*****
c     Variables used in subroutine

      INTEGER             :: i,j,k,ii,jj,kk  

      INTEGER             :: i_qcmod_new
      CHARACTER(LEN=2)    :: s_recordnum_new
c************************************************************************
      DO i=1,l_lines
        IF (i_vec_snow_qcmod_flag(i).GT.0) THEN 

c        No solution possible
         IF (i_cnt_recordnum(i).EQ.0) THEN
          i_qcmod_new=2       !assign flag for no solution
          s_recordnum_new=''  !no record number possible
         ENDIF

c        Workaround solution
         IF (i_cnt_recordnum(i).GT.0) THEN
          i_qcmod_new=1       !assign flag for workaround solution
          s_recordnum_new=s_mat_recordnum(i,1)  !first record number
         ENDIF

         i_vec_snow_qcmod_flag(i)=i_qcmod_new
         s_vec_snow_recordnum(i) =s_recordnum_new

c         print*,'i_cnt_recordnum=',i_cnt_recordnum(i)
c         print*,'s_mat_recordnum=',
c     +      (s_mat_recordnum(i,ii),ii=1,i_cnt_recordnum(i))
c         print*,'s_mat_variableid=',
c     +      (s_mat_variableid(i,ii),ii=1,i_cnt_recordnum(i))
c         print*,'i_qcmod_new=',i_qcmod_new
c         print*,'s_recordnum_new=',s_recordnum_new

        ENDIF

      ENDDO

      RETURN
      END
