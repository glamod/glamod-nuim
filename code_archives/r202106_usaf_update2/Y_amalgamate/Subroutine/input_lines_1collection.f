c     Subroutine to import lines of station in 1 collection
c     AJ_Kettle, 26Apr2021

      SUBROUTINE input_lines_1collection(s_directory_dataroot,
     +    s_subdirectory_sorted,
     +    s_single_stn,
     +    l_rgh_char,l_rgh_datalines,

     +    l_lines,s_linsto2,
     +    s_header)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into subroutine

      CHARACTER(LEN=300)  :: s_directory_dataroot
      CHARACTER(LEN=300)  :: s_subdirectory_sorted
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
c************************************************************************
c      print*,'just entered input_lines_1collection'

      s_pathandname=
     + TRIM(s_directory_dataroot)//TRIM(s_subdirectory_sorted)//
     + TRIM(s_single_stn)

c      print*,'s_pathandname=',TRIM(s_pathandname)

      OPEN(UNIT=5,FILE=TRIM(s_pathandname),
     +  FORM='formatted',STATUS='OLD',ACTION='READ')

c     Read 2 header lines
      READ(5,1002,IOSTAT=io) s_linget   
      READ(5,1002,IOSTAT=io) s_linget   
 1002 FORMAT(a4000)

c     Read data line count line
      READ(UNIT=5,FMT=1004) l_datalines_declare
 1004 FORMAT(t21,i7)

c     Get data lines
      i_flag_header=0
      i_data=0
      DO 
       READ(5,1002,IOSTAT=io) s_linget   

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
         s_linsto2(i_data)=s_linget
        ENDIF

c       Condition for getting header
        IF (s_linget(1:8).EQ.'PLATFORM') THEN 
         s_header=s_linget
         i_flag_header=1
        ENDIF

       ENDIF
      ENDDO
 100  CONTINUE
      CLOSE(UNIT=5)

c      print*,'l_datalines_declare=',l_datalines_declare,i_data

      l_lines=i_data

c      STOP 'input_lines_1collection'

      RETURN
      END
