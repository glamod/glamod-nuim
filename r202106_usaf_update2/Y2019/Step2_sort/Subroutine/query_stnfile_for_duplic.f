c     Subroutine to query station for duplicate source input from crash
c     AJ_Kettle, 11Apr2021

      SUBROUTINE query_stnfile_for_duplic(
     +   s_directory_files,s_filename,
     +   l_usaffiles_rgh,l_rgh_char,l_rgh_datalines,
     +   i_linpre_flag)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into subroutine
      CHARACTER(LEN=300)  :: s_directory_files
      CHARACTER(LEN=30)   :: s_filename

      INTEGER             :: l_usaffiles_rgh
      INTEGER             :: l_rgh_char
      INTEGER             :: l_rgh_datalines

      INTEGER             :: i_linpre_flag(l_rgh_datalines)
c*****
c     Variables used in subroutine
      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: io
      INTEGER             :: jj1,jj2

      CHARACTER(l_rgh_char):: s_header

      CHARACTER(LEN=300)  :: s_pathandname
      CHARACTER(l_rgh_char):: s_linget

      CHARACTER(LEN=25)   :: s_linusaf(l_usaffiles_rgh)
      CHARACTER(LEN=5)    :: s_usaf_index(l_usaffiles_rgh)   !up to 1250 indices possible
      CHARACTER(LEN=6)    :: s_usaf_nlines(l_usaffiles_rgh)

      INTEGER             :: i_usaf_lineposi(l_usaffiles_rgh)
      INTEGER             :: i_usaf_lineposi_st(l_usaffiles_rgh)
      INTEGER             :: i_usaf_lineposi_en(l_usaffiles_rgh)

      CHARACTER(LEN=5)    :: s_usaf_index_uniq(l_usaffiles_rgh)
      INTEGER             :: i_usaf_cnt_uniq(l_usaffiles_rgh)
      INTEGER             :: i_usaf_mat_st(l_usaffiles_rgh,10)
      INTEGER             :: i_usaf_mat_en(l_usaffiles_rgh,10)

      INTEGER             :: l_lines
      INTEGER             :: l_list_orig
      INTEGER             :: l_uniq
c************************************************************************
c      print*,'just query_stnfile_for_duplic'

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

c       PROCEDURE 1: USAF file marker
        IF (s_linget(1:4).EQ.'USAF') THEN 
         jj1=jj1+1

         IF (jj1.GT.l_usaffiles_rgh) THEN 
          print*,'crash program; jj1>l_usaffiles_rgh',jj1
          STOP 'get_lines_single_file'
         ENDIF

         s_linusaf(jj1)    =s_linget(1:25)
         s_usaf_index(jj1) =s_linget(13:17)  !modified for Try1c
         s_usaf_nlines(jj1)=s_linget(19:25)  !modified for Try1c

         i_usaf_lineposi(jj1)   =jj
c        Specify start of current group
         i_usaf_lineposi_st(jj1)=jj+1
c        Specify end of last group
         IF (jj1.GT.1) THEN
          i_usaf_lineposi_en(jj1-1)=jj-1
         ENDIF

        ENDIF              !end condition USAF finder

       ENDIF
      ENDDO
 100  CONTINUE
      CLOSE(UNIT=5)

c     Specify end of last group
      i_usaf_lineposi_en(jj1)=jj   !end of last group is last line

c      print*,'jj,jj1=',jj,jj1

      l_lines=jj
      l_list_orig=jj1

c      print*,'s_usaf_index=',(s_usaf_index(i),i=1,jj1)
c      print*,'i_usaf_lineposi=',(i_usaf_lineposi(i),i=1,jj1)

c      print*,'just leaving query_stnfile_for_duplic'

c      DO i=1,l_list_orig
c       print*,'i=',i,i_usaf_lineposi(i),
c     +   i_usaf_lineposi_st(i),i_usaf_lineposi_en(i)
c      ENDDO

c      STOP 'query_stnfile_for_duplic'
c*****
c*****
c     Find list of unique input stations

c     Initialize counter
      DO i=1,l_usaffiles_rgh
       i_usaf_cnt_uniq(i)=0
      ENDDO

      jj2=0
      jj2=jj2+1
      s_usaf_index_uniq(jj2)=s_usaf_index(1)      
      i_usaf_cnt_uniq(jj2)=i_usaf_cnt_uniq(jj2)+1
      i_usaf_mat_st(jj2,i_usaf_cnt_uniq(jj2))=i_usaf_lineposi_st(1)
      i_usaf_mat_en(jj2,i_usaf_cnt_uniq(jj2))=i_usaf_lineposi_en(1)

c     Cycle through original stations
      DO i=2,l_list_orig

c      Cycle through unique stations
       DO j=1,jj2 
        IF (TRIM(s_usaf_index(i)).EQ.TRIM(s_usaf_index_uniq(j))) 
     +    THEN
         i_usaf_cnt_uniq(j)=i_usaf_cnt_uniq(j)+1

c        Stop program if crash record is too long
         IF (i_usaf_cnt_uniq(j).GT.10) THEN
          print*,'crash record too long to be archived'
          STOP 'query_stnfile_for_duplic'
         ENDIF

         i_usaf_mat_st(j,i_usaf_cnt_uniq(j))=i_usaf_lineposi_st(i)
         i_usaf_mat_en(j,i_usaf_cnt_uniq(j))=i_usaf_lineposi_en(i)
         GOTO 12
        ENDIF
       ENDDO

c      If there then must augment list
       jj2=jj2+1

       s_usaf_index_uniq(jj2)=s_usaf_index(i)      
       i_usaf_cnt_uniq(jj2)=i_usaf_cnt_uniq(jj2)+1
       i_usaf_mat_st(jj2,i_usaf_cnt_uniq(jj2))=i_usaf_lineposi_st(i)
       i_usaf_mat_en(jj2,i_usaf_cnt_uniq(jj2))=i_usaf_lineposi_en(i)

 12    CONTINUE
      ENDDO

      l_uniq=jj2

c      print*,'l_list_orig,l_uniq=',l_list_orig,l_uniq
c      print*,'i_usaf_cnt_uniq=',(i_usaf_cnt_uniq(i),i=1,l_uniq)
c      DO i=1,l_uniq
c       print*,'s_usaf_index_uniq...',
c     +   i,s_usaf_index_uniq(i),i_usaf_cnt_uniq(i)

c       IF (i_usaf_cnt_uniq(i).GT.1) THEN 
c        DO j=1,i_usaf_cnt_uniq(i)
c         print*,'i,i,st,en',i,j,i_usaf_mat_st(i,j),i_usaf_mat_en(i,j)
c        ENDDO
c       ENDIF
c      ENDDO
c*****
c     Construct flag vector

c     Initialize flag vector to bad
      DO i=1,l_lines
       i_linpre_flag(i)=1
      ENDDO

c     Cycle through the uniq indices
      DO i=1,l_uniq
       ii=i_usaf_cnt_uniq(i)  !specify good index, last of duplicates

c      this flags data lines as good
       DO j=i_usaf_mat_st(i,ii),i_usaf_mat_en(i,ii)
        i_linpre_flag(j)=0
       ENDDO

c      this flags the header line as good
       i_linpre_flag(i_usaf_mat_st(i,ii)-1)=0

      ENDDO

c      DO i=1,l_lines
c       print*,'i...',i,i_linpre_flag(i)
c      ENDDO
c*****
c      STOP 'query_stnfile_for_duplic'

      RETURN
      END
