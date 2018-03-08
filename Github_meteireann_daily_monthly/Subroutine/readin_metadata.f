c     Subroutine to read in metadata
c     AJ_Kettle, Dec19/2017

      SUBROUTINE readin_metadata(s_filename,l_nfile,
     +  l_meta,
     +  s_meta_namelist,s_meta_fileid,s_meta_alt_m,
     +  s_meta_lat,s_meta_lon,s_meta_wigos)

      IMPLICIT NONE
c************************************************************************
c     Declare variables

      CHARACTER(LEN=300)  :: s_filename

      INTEGER             :: l_nfile
      CHARACTER(LEN=30)   :: s_meta_namelist(l_nfile)
      CHARACTER(LEN=4)    :: s_meta_fileid(l_nfile)
      CHARACTER(LEN=4)    :: s_meta_alt_m(l_nfile)
      CHARACTER(LEN=7)    :: s_meta_lat(l_nfile)
      CHARACTER(LEN=7)    :: s_meta_lon(l_nfile)
      CHARACTER(LEN=17)   :: s_meta_wigos(l_nfile)

      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: io

      CHARACTER(LEN=300)  :: s_linget1
      CHARACTER(LEN=300)  :: s_linsto(l_nfile)
      INTEGER             :: l_meta
c************************************************************************
      print*,'just entered readin_metadata'
      print*,'l_nfile=',l_nfile

      OPEN(UNIT=1,FILE=s_filename,FORM='formatted',
     +  STATUS='OLD',ACTION='READ') 

c     Read in 13-line header
      DO i=1,13
       READ(1,1000,IOSTAT=io) s_linget1
1000   FORMAT(a300)
      ENDDO

c     Read lines of data
      ii=1
      DO 
       READ(1,1000,IOSTAT=io) s_linget1
   
       IF (io .GT. 0) THEN
        WRITE(*,*) 'Check input. Something went wrong'
        GOTO 100
       ELSE IF (io .LT. 0) THEN 
        WRITE(*,*) 'end of file reached'
        GOTO 100
       ELSE
        s_linsto(ii)=s_linget1
        ii=ii+1
       ENDIF

      ENDDO
100   CONTINUE

      CLOSE(UNIT=1)

      l_meta=ii-1

      print*,'l_meta=',l_meta
c************************************************************************
c     Extract data from lines

      DO i=1,l_meta
       s_linget1=s_linsto(i)

       s_meta_namelist(i)=s_linget1(1:22)
       s_meta_fileid(i)  =s_linget1(24:27)
       s_meta_alt_m(i)   =s_linget1(29:32)
       s_meta_lat(i)     =s_linget1(34:40)
       s_meta_lon(i)     =s_linget1(41:47)
       s_meta_wigos(i)   =s_linget1(63:79)
 
      ENDDO

c      print*,'s_meta_namelist',(s_meta_namelist(i),i=1,5)
c      print*,'s_meta_fileid',(s_meta_fileid(i),i=1,5)
c      print*,'s_meta_alt_m',(s_meta_alt_m(i),i=1,5)
c      print*,'s_meta_lat',(s_meta_lat(i),i=1,5)
c      print*,'s_meta_lon',(s_meta_lon(i),i=1,5)
c      print*,'s_meta_wigos',(s_meta_wigos(i),i=1,5)
c************************************************************************
c      print*,'just leaving readin_metadata'

      RETURN
      END