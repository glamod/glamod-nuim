c     Subroutine to read in vector namelist
c     AJ_Kettle, 19Feb2020

      SUBROUTINE readin_namelist_all(
     +  s_directory_namelist,s_filelist_stns,
     +  l_files_rgh,l_files,s_vec_filenames)

      IMPLICIT NONE
c************************************************************************
c     Declare variables 

      CHARACTER(LEN=300)  :: s_directory_namelist
      CHARACTER(LEN=300)  :: s_filelist_stns

      INTEGER             :: l_files_rgh
      INTEGER             :: l_files
      CHARACTER(LEN=30)   :: s_vec_filenames(l_files_rgh)
c*****
c     Variables used in subroutine

      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: io

      CHARACTER(LEN=300)  :: s_pathandname

      CHARACTER(LEN=30)   :: s_linget 
c************************************************************************
      print*,'just inside readin_namelist_all'

      s_pathandname=TRIM(s_directory_namelist)//TRIM(s_filelist_stns)

      print*,'s_pathandname=',TRIM(s_pathandname)

      ii=0

      OPEN(UNIT=5,
     +  FILE=TRIM(s_pathandname),
     +  FORM='formatted',
     +  STATUS='OLD',ACTION='READ')

      DO 
       READ(5,1000,IOSTAT=io) s_linget   
 1000  FORMAT(a300)

       IF (io .GT. 0) THEN
        WRITE(*,*) 'Check input. Something went wrong'
        GOTO 100
       ELSE IF (io .LT. 0) THEN
        WRITE(*,*) 'end of file reached'
        GOTO 100
       ELSE

       ii=ii+1
       s_vec_filenames(ii)=s_linget

c       print*,ii,io,TRIM(s_linget)
c       CALL SLEEP(1)
       ENDIF
      ENDDO
 100  CONTINUE
      CLOSE(UNIT=5)
    
      l_files=ii
      print*,'l_files=',l_files
      print*,TRIM(s_vec_filenames(1))
      print*,TRIM(s_vec_filenames(l_files))
c************************************************************************

      print*,'just leaving readin_namelist_all'

      RETURN
      END
