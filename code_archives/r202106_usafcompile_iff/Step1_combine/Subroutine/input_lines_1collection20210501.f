c     Subroutine to import lines of station in 1 collection
c     AJ_Kettle, 26Apr2021

      SUBROUTINE input_lines_1collection20210501(s_directory_dataroot,
     +    s_single_stn,
     +    l_rgh_char,l_rgh_datalines,

     +    l_lines,s_linsto2,
     +    s_header)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into subroutine

      CHARACTER(LEN=300)  :: s_directory_dataroot
      CHARACTER(LEN=32)   :: s_single_stn

      INTEGER             :: l_rgh_char
      INTEGER             :: l_rgh_datalines

      INTEGER             :: l_lines
      CHARACTER(l_rgh_char):: s_linsto2(l_rgh_datalines)
      CHARACTER(l_rgh_char):: s_header
c*****
c     Variables used in subroutine
      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: io

      CHARACTER(LEN=300)  :: s_pathandname
      CHARACTER(l_rgh_char):: s_linget

      INTEGER             :: l_datalines_declare

      INTEGER             :: i_flag_header
      INTEGER             :: i_data

      INTEGER             :: ii_total
c************************************************************************
c      print*,'just entered input_lines_1collection'

      s_pathandname=
     + TRIM(s_directory_dataroot)//TRIM(s_single_stn)

c      print*,'s_pathandname='//TRIM(s_pathandname)//'='

      OPEN(UNIT=5,FILE=TRIM(s_pathandname),
     +  FORM='formatted',STATUS='OLD',ACTION='READ')

cc     Read 2 header lines
c      READ(5,1002,IOSTAT=io) s_linget   
c      READ(5,1002,IOSTAT=io) s_linget   

cc     Read data line count line
c      READ(UNIT=5,FMT=1004) l_datalines_declare
c 1004 FORMAT(t21,i7)

c     Get data lines
c      ii_total=0
      i_flag_header=0
      i_data=0

      DO 
       READ(5,1002,IOSTAT=io) s_linget   
 1002  FORMAT(a4000)

       IF (io .GT. 0) THEN
        WRITE(*,*) 'Check input. Something went wrong'
        GOTO 100
       ELSE IF (io .LT. 0) THEN
c        WRITE(*,*) 'end of file reached'
        GOTO 100
       ELSE

c       Condition for getting data
        IF (i_flag_header.EQ.1) THEN 
         i_data=i_data+1

c        Crash program if lines too big for storages
         IF (i_data.GE.l_rgh_datalines) THEN 
          print*,'file data lines too large for storage'
          STOP 'input_lines_1collection20210501'
         ENDIF

         s_linsto2(i_data)=s_linget
        ENDIF

c       Condition for getting header
        IF (s_linget(1:8).EQ.'PLATFORM'.OR.
     +      s_linget(1:8).EQ.'platform') THEN 
         s_header=s_linget
         i_flag_header=1
        ENDIF

c        ii_total=ii_total+1

       ENDIF
      ENDDO
 100  CONTINUE
      CLOSE(UNIT=5)

c      print*,'l_datalines_declare=',l_datalines_declare,i_data

      l_lines=i_data

c      print*,'l_lines=',l_lines
c      STOP 'input_lines_1collection20210501'

      RETURN
      END
