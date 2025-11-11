c     Subroutine to get qc_key
c     AJ_Kettle, 17Nov2020

      SUBROUTINE get_qckey(s_directory_qckey,s_filename_qckey,
     +  l_qckey,
     +  s_qckey_sourceflag,s_qckey_c3sflag,s_qckey_timescale)

      IMPLICIT NONE
c************************************************************************
c     Declare variables 

      CHARACTER(LEN=300)  :: s_directory_qckey
      CHARACTER(LEN=300)  :: s_filename_qckey

      INTEGER             :: l_qckey
      CHARACTER(LEN=*)    :: s_qckey_sourceflag(100)
      CHARACTER(LEN=*)    :: s_qckey_c3sflag(100)
      CHARACTER(LEN=*)    :: s_qckey_timescale(100) 
c*****
c     Variables used in subroutine

      INTEGER             :: i,j,k,ii,jj,kk

      CHARACTER(LEN=300)  :: s_command
      INTEGER             :: io

      CHARACTER(LEN=300)  :: s_pathandname

      CHARACTER(LEN=300)  :: s_linget
      CHARACTER(LEN=300)  :: s_linsto(100)

      INTEGER             :: i_st,i_en
c************************************************************************
c      print*,'just entered get_qckey'

c*****
c     Input list of names into vector

      s_pathandname=TRIM(s_directory_qckey)//TRIM(s_filename_qckey)

c      print*,'s_pathandname=',TRIM(s_pathandname)

      OPEN(UNIT=2,FILE=TRIM(s_pathandname),
     +  FORM='formatted',STATUS='OLD',ACTION='READ')

      ii=0

      DO
       READ(2,1000,IOSTAT=io) s_linget
 1000  FORMAT(a300)

c       print*,'s_linget=',TRIM(s_linget)
c       print*,'len',LEN_TRIM(s_linget)
      
       IF (io .GT. 0) THEN
        print*, 'Check input. Something went wrong'
        GOTO 100
       ELSE IF (io .LT. 0) THEN
        print*, 'end of file reached'
        GOTO 100
       ELSE

        ii=ii+1

        s_linsto(ii)=s_linget

        IF (s_linget(1:2).EQ.'s-') THEN
         i_st=ii+1
        ENDIF
        IF (s_linget(1:2).EQ.'e-') THEN
         i_en=ii-1
        ENDIF
        
       ENDIF
      ENDDO
 100  CONTINUE

      CLOSE(UNIT=2)
c*****
c     Extract fields from lines

      ii=0

      DO i=i_st,i_en
       ii=ii+1

       s_linget=s_linsto(i)

       s_qckey_sourceflag(ii)=s_linget(1:2)
       s_qckey_c3sflag(ii)   =s_linget(6:7)
       s_qckey_timescale(ii) =s_linget(11:23)
      ENDDO

      l_qckey=ii

c      print*,'l_qckey=',l_qckey

c      print*,'s_qckey_sourceflag=',(s_qckey_sourceflag(i),i=1,l_qckey)
c      print*,'s_qckey_c3sflag=',(s_qckey_c3sflag(i),i=1,l_qckey)
c      print*,'s_qckey_timescale=',(s_qckey_timescale(i),i=1,l_qckey)
c*****
c      print*,'just leaving get_qckey'

      RETURN
      END
