c     Subroutine to import file lists
c     AJ_Kettle, 10Jul2019
c     26Mar2020: adapted for USAF update

      SUBROUTINE import_iff_filenames(s_dir_iff_source,
     +  l_iff_rgh,l_iff,s_vec_iff_filename,
     +  s_vec_iff_networktype,s_vec_iff_platformid)

      IMPLICIT NONE
c************************************************************************
c     Declare variables 

      CHARACTER(*)        :: s_dir_iff_source

      INTEGER             :: l_iff_rgh
      INTEGER             :: l_iff
      CHARACTER(*)        :: s_vec_iff_filename(l_iff_rgh)
      CHARACTER(*)        :: s_vec_iff_networktype(l_iff_rgh)
      CHARACTER(*)        :: s_vec_iff_platformid(l_iff_rgh)
c*****
c     Variables used in subroutine
      INTEGER             :: i,j,k,ii,jj,kk

      INTEGER             :: io
      CHARACTER(LEN=300)  :: s_command

      CHARACTER(LEN=300)  :: s_filename
c************************************************************************
      print*,'just inside import_iff_filenames'

      s_command=
     +'(cd '//TRIM(s_dir_iff_source)//' && ls) > filelist.dat'
      print*,'s_command=',TRIM(s_command)
      CALL SYSTEM(s_command,io)
c*****
c     Read in iff filename list
      s_filename='filelist.dat'
      CALL read_in_iff_list(s_filename,
     +  l_iff_rgh,l_iff,s_vec_iff_filename)
c*****
c     Erase file listing
      s_command='rm filelist.dat'
      CALL SYSTEM(s_command,io)
c*****
      print*,'just leaving import_iff_filenames'

      RETURN
      END
