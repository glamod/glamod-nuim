c     Subroutine to get sfc_obs & metadata files
c     AJ_Kettle, 16Jan2020

      SUBROUTINE get_sfcobs_metadata_files(s_directory_untarpack,
     +   s_file_sfcobs,s_file_metadata,
     +   s_file_sfcobs_no_ext,s_file_metadata_no_ext)

      IMPLICIT NONE
c************************************************************************
c     Declare variables 

      CHARACTER(LEN=300)  :: s_directory_untarpack
      CHARACTER(LEN=300)  :: s_file_sfcobs
      CHARACTER(LEN=300)  :: s_file_metadata

      CHARACTER(LEN=300)  :: s_file_sfcobs_no_ext
      CHARACTER(LEN=300)  :: s_file_metadata_no_ext
c*****
c     Variables used in subroutine

      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: io
      CHARACTER(LEN=300)  :: s_command

      CHARACTER(LEN=300)  :: s_pathandname

      CHARACTER(LEN=300)  :: s_filelist(11)
      CHARACTER(LEN=300)  :: s_linget
      INTEGER             :: l_len
c************************************************************************
c      print*,'just entered get_sfcobs_metadata_files'

c      s_pathandname=TRIM(s_directory_untarpack)//'zlist.dat'
      s_pathandname='zlist.dat'

c     Read in 11 files from tarball

      ii=0

      OPEN(UNIT=2,FILE=TRIM(s_pathandname),
     +  FORM='formatted',STATUS='OLD',ACTION='READ')     

      DO 

c      Read data line
       READ(2,1002,IOSTAT=io) s_linget
1002   FORMAT(a300)
       IF (io .GT. 0) THEN
        WRITE(*,*) 'Check input. Something went wrong'
        GOTO 100
       ELSE IF (io .LT. 0) THEN 
c        WRITE(*,*) 'end of file reached'
        GOTO 100
       ELSE

        ii=ii+1
        s_filelist(ii)=s_linget

       ENDIF
      ENDDO                !end of line-counting loop

100   CONTINUE

      CLOSE(UNIT=2)
c*****
c      print*,'s_filelist=',(TRIM(s_filelist(i)),i=1,11)

c      STOP 'get_sfcobs_metadata_files'

c     Get names of target files
      s_file_sfcobs=''
      s_file_metadata=''
      DO i=1,11
       s_linget=s_filelist(i)

       l_len=LEN_TRIM(s_linget)

       DO j=1,l_len
        IF (s_linget(j:j+6).EQ.'.csv.gz') THEN
         IF (s_linget(j-7:j-1).EQ.'sfc_obs') THEN 
          s_file_sfcobs=TRIM(s_linget)
          s_file_sfcobs_no_ext=TRIM(s_linget(1:j-1))
         ENDIF
         IF (s_linget(j-8:j-1).EQ.'METADATA') THEN 
          s_file_metadata=TRIM(s_linget)
          s_file_metadata_no_ext=TRIM(s_linget(1:j-1))
         ENDIF

c         STOP 'get_sfcobs_metadata_files; condition met'
 
c        exit character processor
         GOTO 10

        ENDIF
       ENDDO
 10    CONTINUE
      ENDDO

c      print*,'s_file_sfcobs=',TRIM(s_file_sfcobs)
c      print*,'s_file_metadata=',TRIM(s_file_metadata)

c      print*,'just leaving get_sfcobs_metadata_files'

c      STOP 'get_sfcobs_metadata_files'

      RETURN
      END
