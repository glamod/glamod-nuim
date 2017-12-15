c     Subroutine to get get full wigos number
c     AJ_Kettle, Dec5/2017

      SUBROUTINE get_wigos_number_sd(l_mstn,l_file_basis,s_basis_stke,
     +  s_basis_wigos_full)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into subroutine
      INTEGER             :: l_file_basis
      INTEGER             :: l_mstn
      CHARACTER(LEN=5)    :: s_basis_stke(l_mstn)
      CHARACTER(LEN=17)   :: s_basis_wigos_full(l_mstn)

      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: io

      CHARACTER(LEN=200)  :: s_filename

      CHARACTER(LEN=300)  :: s_linget
      CHARACTER(LEN=300)  :: s_linsto(100)

      INTEGER             :: l_wigosfile
      CHARACTER(LEN=5)    :: s_rgh_stke(100)
      CHARACTER(LEN=17)   :: s_rgh_wigos(100)
c************************************************************************
c      print*,'just entered get_wigos_number_sd'

      ii=1                      !counter for station lines
      jj=1

      s_filename='dwd_wmo_number.dat'
c      print*,'s_filename',TRIM(s_filename)

      OPEN(UNIT=1,FILE=s_filename,
     +  FORM='formatted',
     +  STATUS='OLD',ACTION='READ') 

      DO 
       READ(1,1000,IOSTAT=io) s_linget
1000   FORMAT(a300)
   
       IF (io .GT. 0) THEN
        WRITE(*,*) 'Check input. Something went wrong'
        GOTO 100
       ELSE IF (io .LT. 0) THEN 
        WRITE(*,*) 'end of file reached'
        GOTO 100
       ELSE
        IF (ii.GE.5) THEN
         s_linsto(jj)=s_linget
         jj=jj+1
        ENDIF
        ii=ii+1
       ENDIF
      ENDDO
100   CONTINUE

      CLOSE(unit=1)

      l_wigosfile=jj-1
c************************************************************************
c     Extract stke & wigos number from lines

      DO i=1,l_wigosfile
       s_linget          =s_linsto(i)  
       s_rgh_stke(i)     =s_linget(26:30)
       s_rgh_wigos(i)    =s_linget(32:48)
      ENDDO

c      print*,'s_rgh_stke(1)=',  s_rgh_stke(1)
c      print*,'s_rgh_stke(end)=',s_rgh_stke(l_wigosfile)
c      print*,'s_rgh_wigos(1)=',  s_rgh_wigos(1)
c      print*,'s_rgh_wigos(end)=',s_rgh_wigos(l_wigosfile)
c      print*,'l_file_basis=',   l_file_basis
c************************************************************************
c     Match stke numbers to get WIGOS number

      DO i=1,l_file_basis
       DO j=1,l_wigosfile
        IF (s_basis_stke(i).EQ.s_rgh_stke(j)) THEN 
         s_basis_wigos_full(i)=s_rgh_wigos(j)
         GOTO 15
        ENDIF
       ENDDO

       print*,'stop: problem get_wigos_number',i
       CALL SLEEP(5)

15     CONTINUE
      ENDDO

c************************************************************************
c      print*,'just leaving get_wigos_number_sd'
c      CALL SLEEP(5)

      RETURN
      END