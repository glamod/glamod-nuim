c     Subroutine to read in iff list
c     AJ_Kettle,10Jul2019
c     26Mar2020: adapted for USAF update
c     01Jun2021: used for reading in IFF list

      SUBROUTINE read_in_iff_list(s_filename,
     +  l_iff_rgh,l_iff,s_vec_iff_filename)

      IMPLICIT NONE
c************************************************************************
c     Declare variables 

      CHARACTER(LEN=300)  :: s_filename

      INTEGER             :: l_iff_rgh
      INTEGER             :: l_iff
      CHARACTER(LEN=*)    :: s_vec_iff_filename(l_iff_rgh)
c*****
      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: io

      CHARACTER(LEN=300)  :: s_pathandname
      CHARACTER(LEN=300)  :: s_linget

      INTEGER             :: i_len
c************************************************************************
      print*,'just entered read_in_iff_list'

      s_pathandname=TRIM(s_filename)

      print*,'s_pathandname=',TRIM(s_pathandname)

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

        i_len=LEN_TRIM(s_linget)
        IF (i_len.GT.64) THEN
         print*,'emergency stop, filename too long'
         STOP 'read_in_iff_list.f'
        ENDIF

        ii=ii+1
        s_vec_iff_filename(ii)=s_linget

       ENDIF
      ENDDO                !end of line-counting loop

100   CONTINUE

      CLOSE(UNIT=2)

      l_iff=ii

      print*,'l_iff=',l_iff
      print*,'s_vec_iff_filename=',TRIM(s_vec_iff_filename(1))
      print*,'s_vec_iff_filename=',TRIM(s_vec_iff_filename(l_iff))

      print*,'just leaving read_in_iff_list'

      RETURN
      END
