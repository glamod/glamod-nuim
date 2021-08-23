c     Subroutine to process data files
c     AJ_Kettle, 15Jan2020

      SUBROUTINE process_files(l_tar,s_vec_path,s_vec_name,
     +  s_directory_1tar,s_directory_2untarpack,
     +  s_directory_3headerlist,s_directory_3unsort,
     +  s_directory_3archive,
     +  l_ascii,i_list_ascii,s_list_asciichar)

      IMPLICIT NONE
c************************************************************************
c     Declare variables 

      INTEGER             :: l_tar
      CHARACTER(LEN=300)  :: s_vec_path(2000)
      CHARACTER(LEN=300)  :: s_vec_name(2000)
      CHARACTER(LEN=300)  :: s_directory_1tar
      CHARACTER(LEN=300)  :: s_directory_2untarpack
      CHARACTER(LEN=300)  :: s_directory_3headerlist
      CHARACTER(LEN=300)  :: s_directory_3unsort
      CHARACTER(LEN=300)  :: s_directory_3archive
c*****
c     Standard ASCII characters
      INTEGER             :: l_ascii
      INTEGER             :: i_list_ascii(62)
      CHARACTER(LEN=1)    :: s_list_asciichar(62)
c*****
c     Variables used in subroutine

      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: io
c*****
      REAL                :: f_loop_time_st,f_loop_time_en

      CHARACTER(LEN=8)    :: s_loop_date_st
      CHARACTER(LEN=10)   :: s_loop_time_st
      CHARACTER(LEN=5)    :: s_loop_zone_st
      INTEGER             :: i_loop_values_st(8)
      CHARACTER(LEN=8)    :: s_loop_date_en
      CHARACTER(LEN=10)   :: s_loop_time_en
      CHARACTER(LEN=5)    :: s_loop_zone_en
      INTEGER             :: i_loop_values_en(8)
c*****
      INTEGER             :: i_index
      CHARACTER(LEN=300)  :: s_command
      CHARACTER(LEN=300)  :: s_new

      CHARACTER(LEN=300)  :: s_file_sfcobs
      CHARACTER(LEN=300)  :: s_file_metadata

      CHARACTER(LEN=300)  :: s_file_sfcobs_no_ext
      CHARACTER(LEN=300)  :: s_file_metadata_no_ext

      INTEGER             :: i_start

      CHARACTER(LEN=300)  :: s_single_path
      CHARACTER(LEN=300)  :: s_single_name

c      INTEGER,PARAMETER   :: l_distinctstns_rgh=200000
c      INTEGER             :: i_distinctstns
c      CHARACTER(LEN=20)   :: s_vec_distinctstns(l_distinctstns_rgh) 
c************************************************************************
      print*,'just entered process_files'

      print*,'l_tar=',l_tar

      print*,'s_directory_1tar=',TRIM(s_directory_1tar)
      print*,'s_directory_2untarpack=',TRIM(s_directory_2untarpack)
      print*,'s_directory_3unsort=',TRIM(s_directory_3unsort)
      print*,'s_directory_3archive=',TRIM(s_directory_3archive)

c      STOP 'process_files'

c      i_distinctstns=0

c     Get archive information
      CALL get_archive_decide_start(s_directory_3archive,i_start)

      print*,'i_start,l_tar=',i_start,l_tar
c      CALL SLEEP(10)
c      STOP 'process_files'

      DO i=i_start,l_tar !i_start,500 !1,l_tar
c****
c      Find loop time
       CALL CPU_TIME(f_loop_time_st)

c      Find loop date & time
       CALL DATE_AND_TIME(s_loop_date_st,s_loop_time_st,s_loop_zone_st,
     +   i_loop_values_st)
c****
       i_index=i

c      Create archive file
       CALL create_archive_file(s_directory_3archive,i_index)

       print*,'i=',i,TRIM(s_vec_name(i))

c       STOP 'process_files'

c       GOTO 100

c      remove temp file from 1tar directory
       s_command=
     +  'rm '//TRIM(s_directory_1tar)//'usaf*.*'
       print*,'s_command=',TRIM(s_command) 
       CALL SYSTEM(s_command,io)

c      clear untarpack directory file: 2untarpack
       s_command=
     +  'rm '//TRIM(s_directory_2untarpack)//'usaf*.*'
       print*,'s_command=',TRIM(s_command) 
       CALL SYSTEM(s_command,io)

c       s_command=
c     +  'cp '//TRIM(s_vec_path(i))//TRIM(s_vec_name(i))//' '//
c     +  TRIM(s_directory_1tar)//TRIM(s_vec_name(i))

c      copy tar file from source to temp directory
c      new command used with brackets
c       s_command=
c     +  'cp '''//TRIM(s_vec_path(i))//TRIM(s_vec_name(i))//''' '''//
c     +  TRIM(s_directory_1tar)//TRIM(s_vec_name(i))//''''
c      old command will not work brackets
c       s_command=
c     +  'cp '//TRIM(s_vec_path(i))//TRIM(s_vec_name(i))//' '//
c     +  TRIM(s_directory_1tar)//TRIM(s_vec_name(i))

       print*,'s_vec_path=',TRIM(s_vec_path(i))
       print*,'s_vec_name=',TRIM(s_vec_name(i))
       print*,'both...',
     + 'cp '//TRIM(s_vec_path(i))//TRIM(s_vec_name(i))//' '//
     +  TRIM(s_directory_1tar)//TRIM(s_vec_name(i))

c       s_single_path=TRIM(s_vec_path(i))
c       s_single_name=TRIM(s_vec_name(i))
c       s_command='cp '//
c     +  TRIM(s_single_path)//
c     +  TRIM(s_single_name)//' '//
c     +  TRIM(s_directory_1tar)//TRIM(s_single_name)
c       print*,'s_command new=',TRIM(s_command) 

       s_command=
     + 'cp '//TRIM(s_vec_path(i))//TRIM(s_vec_name(i))//' '//
     +  TRIM(s_directory_1tar)//TRIM(s_vec_name(i))

       print*,'s_command=',TRIM(s_command) 
       CALL SYSTEM(s_command,io)

c      Untar file to different directory
c      new command
       s_command=
     +  'tar '//
     +    '-C '//TRIM(s_directory_2untarpack)//' '//
     +    '-xvf '//TRIM(s_directory_1tar)//'*.tar'
c      old command
c       s_command=
c     +  'tar '//
c     +    '-C '//TRIM(s_directory_2untarpack)//' '//
c     +    '-xvf '//TRIM(s_directory_1tar)//TRIM(s_vec_name(i))
       print*,'s_command=',TRIM(s_command) 
       CALL SYSTEM(s_command,io)

c       STOP 'process_files'

c      Get listing of unpacked files
       s_command=
     +  'ls '//TRIM(s_directory_2untarpack)//'*.gz > zlist.dat'
       print*,'s_command=',TRIM(s_command) 
       CALL SYSTEM(s_command,io)

c       STOP 'process_files'

c      Get sfc_obs & metadata files
       CALL get_sfcobs_metadata_files(s_directory_2untarpack,
     +   s_file_sfcobs,s_file_metadata,
     +   s_file_sfcobs_no_ext,s_file_metadata_no_ext)

c       print*,'s_file_sfcobs=',TRIM(s_file_sfcobs)
c       print*,'s_file_metadata=',TRIM(s_file_metadata)
c       print*,'s_file_sfcobs=',TRIM(s_file_sfcobs_no_ext)
c       print*,'s_file_metadata=',TRIM(s_file_metadata_no_ext)

c       STOP 'process_files'

c      Uncompress two target files
       s_command='gunzip '//TRIM(s_file_sfcobs)
       print*,'s_command=',TRIM(s_command) 
       CALL SYSTEM(s_command,io)

       s_command='gunzip '//TRIM(s_file_metadata)
       print*,'s_command=',TRIM(s_command) 
       CALL SYSTEM(s_command,io)

c       STOP 'process_files'

c      Separate out 1 USAF file
       CALL separate_one_usaf_file1(i_index,
     +   s_file_sfcobs_no_ext,
     +   s_directory_3headerlist,s_directory_3unsort,
     +   l_ascii,i_list_ascii,s_list_asciichar)

 100   CONTINUE
c****
c      Find loop time
       CALL CPU_TIME(f_loop_time_en)

c      Find loop date & time
       CALL DATE_AND_TIME(s_loop_date_en,s_loop_time_en,s_loop_zone_en,
     +   i_loop_values_en)
c****
c      Update archive file
       CALL update_archive_file2(s_directory_3archive,i_index,
     +   f_loop_time_st,f_loop_time_en,
     +   s_loop_date_st,s_loop_time_st,i_loop_values_st,
     +   s_loop_date_en,s_loop_time_en,i_loop_values_en)

      ENDDO

      print*,'l_tar=',l_tar

      print*,'just leaving process_files'

      RETURN
      END
