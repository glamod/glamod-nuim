c     Subroutine to read in station list
c     AJ_Kettle, 10Mar2020

      SUBROUTINE readin_stnlist(s_dir_stnlist,s_filename_stnlist,
     +  l_stnlist_rgh,l_stnlist,
     +  s_vec_stnlist)

      IMPLICIT NONE
c************************************************************************
c     Declare variables passed into program

      CHARACTER(LEN=300)  :: s_dir_stnlist

      CHARACTER(LEN=300)  :: s_filename_stnlist

      INTEGER             :: l_stnlist_rgh
      INTEGER             :: l_stnlist
      CHARACTER(LEN=30)   :: s_vec_stnlist(l_stnlist_rgh) 
c*****
c     Variables used in subroutine

      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: io

      CHARACTER(LEN=300)  :: s_pathandname 
      CHARACTER(LEN=30)   :: s_linget

      INTEGER             :: i_len
c************************************************************************

      s_pathandname=TRIM(s_dir_stnlist)//TRIM(s_filename_stnlist)

      ii=0

      OPEN(UNIT=5,
     +  FILE=TRIM(s_pathandname),
     +  FORM='formatted',
     +  STATUS='OLD',ACTION='READ')

      DO 
       READ(5,1000,IOSTAT=io) s_linget   
 1000  FORMAT(a30)

       IF (io .GT. 0) THEN
        WRITE(*,*) 'Check input. Something went wrong'
        GOTO 100
       ELSE IF (io .LT. 0) THEN
        WRITE(*,*) 'end of file reached'
        GOTO 100
       ELSE

       ii=ii+1

       i_len=LEN_TRIM(s_linget)
       IF (i_len.GE.30) THEN 
        print*,'emergency stop; stnname too long'
        STOP 'readin_stnlist'
       ENDIF

       s_vec_stnlist(ii)=s_linget

c       print*,ii,io,TRIM(s_linget)
c       CALL SLEEP(1)
       ENDIF
      ENDDO
 100  CONTINUE
      CLOSE(UNIT=5)
    
      l_stnlist=ii

      print*,'l_stnlist=',l_stnlist

      RETURN
      END
