c     Subroutine to input lines from single file
c     AJ_Kettle, 20Feb2020
c     12Apr2021: includes flag idintifying crash trials

      SUBROUTINE get_lines_single_file20210412(
     +   s_directory_files,s_filename,
     +   l_usaffiles_rgh,l_rgh_char,l_rgh_datalines,
     +   i_linpre_flag_0good1bad,

     +   l_lines,s_linsto2,
     +   s_header,
     +   l_cnt_usaffiles,i_usaf_index,i_usaf_nlines)

c************************************************************************
c     Variables passed into subroutine
      CHARACTER(LEN=300)  :: s_directory_files
      CHARACTER(LEN=30)   :: s_filename

      INTEGER             :: l_usaffiles_rgh
      INTEGER             :: l_rgh_char
      INTEGER             :: l_rgh_datalines

      INTEGER             :: l_lines
      CHARACTER(LEN=l_rgh_char) :: s_linsto2(l_rgh_datalines)
      CHARACTER(l_rgh_char):: s_header

      INTEGER             :: i_linpre_flag_0good1bad(l_rgh_datalines)
c*****
c     Variables used in subroutine
      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: io

      INTEGER             :: jj1,jj2
      INTEGER             :: i_strlen
      INTEGER             :: i_maxstrlen

      CHARACTER(LEN=300)  :: s_pathandname
      CHARACTER(l_rgh_char):: s_linget

c      CHARACTER(LEN=l_rgh_char) :: s_linmast(l_rgh_datalines)

      CHARACTER(LEN=25)   :: s_linusaf(l_usaffiles_rgh)
      CHARACTER(LEN=5)    :: s_usaf_index(l_usaffiles_rgh)   !up to 1250 indices possible
      CHARACTER(LEN=6)    :: s_usaf_nlines(l_usaffiles_rgh)

      INTEGER             :: l_cnt_usaffiles
      INTEGER             :: i_usaf_index(l_usaffiles_rgh)   !up to 1250 indices possible
      INTEGER             :: i_usaf_nlines(l_usaffiles_rgh)
c************************************************************************
c      print*,'just entered get_lines_single_file20210412'

      s_pathandname=TRIM(s_directory_files)//TRIM(s_filename)

c      print*,'s_pathandname=',TRIM(s_pathandname)

      OPEN(UNIT=5,FILE=TRIM(s_pathandname),
     +  FORM='formatted',STATUS='OLD',ACTION='READ')

c     Sequence to read in lines from raw file

c     Read header from first line
      READ(5,1002,IOSTAT=io) s_header   
 1002 FORMAT(a4000)

      jj=0
      jj1=0
      jj2=0
      i_maxstrlen=0

      DO 
       READ(5,1002,IOSTAT=io) s_linget   

       IF (io .GT. 0) THEN
        WRITE(*,*) 'Check input. Something went wrong'
        GOTO 100
       ELSE IF (io .LT. 0) THEN
c        WRITE(*,*) 'end of file reached'
        GOTO 100
       ELSE

c       general line incrementer
        jj=jj+1

c       Crash program if number lines exceeds array size
        IF (jj.GE.l_rgh_datalines) THEN 
         print*,'crashed program jj>l_rgh_datalines'
         STOP 'get_single_list_data2'
        ENDIF

c       PROCEDURE 0: Store all files regardless of type
c        s_linmast(jj)=s_linget

c       PROCEDURE 1: USAF file marker
        IF (s_linget(1:4).EQ.'USAF') THEN 
        IF (i_linpre_flag_0good1bad(jj).EQ.0) THEN
         jj1=jj1+1

         IF (jj1.GT.l_usaffiles_rgh) THEN 
          print*,'crash program; jj1>l_usaffiles_rgh',jj1
          STOP 'get_lines_single_file'
         ENDIF

         s_linusaf(jj1)    =s_linget(1:25)
         s_usaf_index(jj1) =s_linget(13:17)  !modified for Try1c
         s_usaf_nlines(jj1)=s_linget(19:25)  !modified for Try1c

c         IF (jj1.GT.1) THEN 
c          i_index_en(jj1-1)   =jj-1
c         ENDIF
c         i_index_st(jj1)   =jj+1

c         print*,'jj1=',jj1
c         print*,'s_linget=',TRIM(s_linget)    
c         print*,'s_linusaf=',    TRIM(s_linusaf(jj1))
c         print*,'s_usaf_index='//TRIM(s_usaf_index(jj1))//'='
c         print*,'s_usaf_nlines='//TRIM(s_usaf_nlines(jj1))//'='

c        Convert to integers; PROBLEM HERE
         READ(s_usaf_index(jj1),*) i_usaf_index(jj1)
         READ(s_usaf_nlines(jj1),*) i_usaf_nlines(jj1)

c         print*,'jj1..',s_usaf_index(jj1),s_usaf_nlines(jj1)
c         print*,'ii..',i_usaf_index(jj1),i_usaf_nlines(jj1)
c         CALL SLEEP(1)
        ENDIF
        ENDIF              !end condition USAF finder

c       PROCEDURE 2: to archive data line
        IF (.NOT.(s_linget(1:4).EQ.'USAF')) THEN 
        IF (i_linpre_flag_0good1bad(jj).EQ.0) THEN
         jj2=jj2+1

         s_linsto2(jj2)=s_linget

         i_strlen=LEN_TRIM(s_linget)
         i_maxstrlen=MAX(i_maxstrlen,i_strlen)
        ENDIF
        ENDIF

       ENDIF
      ENDDO
 100  CONTINUE
      CLOSE(UNIT=5)

      l_lines=jj2

      l_cnt_usaffiles=jj1

c      print*,'number file switches, jj1=',jj1
c      print*,'number of lines, jj2=',jj2
c      print*,'i_maxstrlen=',i_maxstrlen

c      print*,'jj1=',jj1
c      print*,'s_usaf_index=',(s_usaf_index(i),i=1,jj1)

c      print*,'just leaving get_lines_single_file20210412'

c      STOP 'get_lines_single_file20210412'

      RETURN
      END
