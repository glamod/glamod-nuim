c     Subroutine to read in source codes for daily data
c     AJ_Kettle, 06Dec2018
c     01Nov2019: modified for new conversion file with extra NCEI 'm'; psv also
c     11Nov2019: used in GHCND sequence
c     11May2020: used for 01May2020 release

      SUBROUTINE readin_source_id2(
     +  s_directory_ancilldata,s_filename_ghcnd_source,
     +  l_source_rgh,l_source,
     +  s_source_name,s_source_codeletter,s_source_codenumber)

      IMPLICIT NONE
c************************************************************************
c     Declare variables 

      CHARACTER(LEN=300)  :: s_directory_ancilldata
      CHARACTER(LEN=300)  :: s_filename_ghcnd_source

      INTEGER             :: l_source_rgh
      INTEGER             :: l_source
      CHARACTER(LEN=500)  :: s_source_name(l_source_rgh)
      CHARACTER(LEN=1)    :: s_source_codeletter(l_source_rgh)
      CHARACTER(LEN=3)    :: s_source_codenumber(l_source_rgh)
c*****
c     Variables used in program

      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: io

      CHARACTER(LEN=300)  :: s_pathandname

      CHARACTER(LEN=500)  :: s_linget
      CHARACTER(LEN=500)  :: s_linsto(l_source_rgh)

      INTEGER             :: i_len
      INTEGER             :: i_lenmin,i_lenmax

      INTEGER             :: i_commacnt
      INTEGER             :: i_commapos(2)

      CHARACTER(LEN=500)  :: s_single_name
      CHARACTER(LEN=1)    :: s_single_codeletter
      CHARACTER(LEN=3)    :: s_single_codenumber
c************************************************************************
      print*,'just entered readin_source_id2'

      s_pathandname=
     +  TRIM(s_directory_ancilldata)//TRIM(s_filename_ghcnd_source)

      OPEN(UNIT=1,FILE=TRIM(s_pathandname),FORM='formatted',
     +  STATUS='OLD',ACTION='READ')

c     Read in header
      READ(1,1002,IOSTAT=io) s_linget
      READ(1,1002,IOSTAT=io) s_linget    !this is condition for blank line
1002  FORMAT(a500)

c     Initialize maximum counter
      ii     =0
      i_lenmin=300
      i_lenmax=0

      DO 
       READ(1,1002,IOSTAT=io) s_linget
       IF (io .GT. 0) THEN
        WRITE(*,*) 'Check input. Something went wrong'
        GOTO 100
       ELSE IF (io .LT. 0) THEN 
c        WRITE(*,*) 'end of file reached'
        GOTO 100
       ELSE
        ii=ii+1

        s_linsto(ii)=s_linget

        i_lenmin=MIN(i_lenmin,LEN_TRIM(s_linget))
        i_lenmax=MAX(i_lenmax,LEN_TRIM(s_linget))
 
       ENDIF
      ENDDO
100   CONTINUE

      CLOSE(UNIT=1)

      l_source=ii

c      print*,'l_source=',l_source
c      print*,'i_lenmin,i_lenmax=',i_lenmin,i_lenmax
c************************************************************************
c     Find locations of commas

      DO i=1,l_source
       s_linget=s_linsto(i)

       i_len=LEN_TRIM(s_linget)

c      Count from end of line to beginning
       i_commacnt=0
       DO j=i_len,1,-1
        IF (s_linget(j:j).EQ.'|') THEN
         i_commacnt=i_commacnt+1
         i_commapos(i_commacnt)=j

c        Condition for loop exit
         IF (i_commacnt.EQ.2) THEN
          s_single_name      =s_linget(1:i_commapos(2)-1)
          s_single_codeletter=s_linget(i_commapos(2)+1:i_commapos(1)-1)
          s_single_codenumber=s_linget(i_commapos(1)+1:i_len)

c          print*,'i...',i,s_single_codeletter,s_single_codenumber
          GOTO 20
         ENDIF

        ENDIF
       ENDDO

 20    CONTINUE

       s_source_name(i)      =s_single_name
       s_source_codeletter(i)=s_single_codeletter
       s_source_codenumber(i)=s_single_codenumber

      ENDDO
c************************************************************************
      print*,'just leaving readin_source_id2'

c      STOP 'readin_source_id'

      RETURN
      END
