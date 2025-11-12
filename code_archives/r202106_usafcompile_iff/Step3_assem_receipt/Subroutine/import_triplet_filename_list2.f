c     Subroutine to import file lists
c     AJ_Kettle, 10Jul2019
c     26Mar2020: adapted for USAF update

      SUBROUTINE import_triplet_filename_list2(
     +  s_directory_outfile_iff_netplatdistinct,
     +  l_stn_rgh,l_stn,s_filelist)

      IMPLICIT NONE
c************************************************************************
c     Declare variables 

      CHARACTER(LEN=300)  :: s_directory_outfile_iff_netplatdistinct

      INTEGER             :: l_stn_rgh
      INTEGER             :: l_stn
      CHARACTER(LEN=*)    :: s_filelist(l_stn_rgh)
c*****
c     Variables used in subroutine
      INTEGER             :: i,j,k,ii,jj,kk

      INTEGER             :: io
      CHARACTER(LEN=300)  :: s_command

      CHARACTER(LEN=300)  :: s_filename
c************************************************************************
      print*,'just entered import_triplet_filename_list2'
c*****
c     Create file with filenames

c     Files subdirectory
c      s_command=
c     +'ls '//
c     + TRIM(s_directory_outfile_iff_netplatdistinct)//
c     + '*.dat > filelist.dat'

      s_command=
     +'(cd '//
     + TRIM(s_directory_outfile_iff_netplatdistinct)//
     + ' && ls) > filelist.dat'
      print*,'s_command=',TRIM(s_command)
      CALL SYSTEM(s_command,io)
c*****
c     Read in triplet lists

      s_filename='filelist.dat'
      CALL read_in_triplet_list2(s_filename,
     +  l_stn_rgh,l_stn,s_filelist)
c*****
c     Erase file listing

      s_command='rm filelist.dat'
      CALL SYSTEM(s_command,io)
c*****
      print*,'just leaving import_triplet_filename_list2'
c*****
      RETURN
      END
