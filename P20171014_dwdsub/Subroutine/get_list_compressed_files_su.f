c     Subroutine to get list of compressed files
c     AJ_Kettle, Oct17/2017

      SUBROUTINE get_list_compressed_files_su(s_pathandname,
     +  l_zipfile_co,s_zipfiles_co,s_stnnum_co)

      IMPLICIT NONE
c************************************************************************
      CHARACTER(LEN=300)  :: s_pathandname

      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: io      
      CHARACTER(LEN=300)  :: s_linget2

      INTEGER             :: l_zipfile_co
      CHARACTER(LEN=300)  :: s_zipfiles_co(100)
      CHARACTER(LEN=5)    :: s_stnnum_co(100)
c************************************************************************



c************************************************************************
      RETURN
      END