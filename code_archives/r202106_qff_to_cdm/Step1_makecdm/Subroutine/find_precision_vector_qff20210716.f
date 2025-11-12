c     Subroutine to find precision vector
c     AJ_Kettle, 13Nov2018
c     08Jan2019: modification of find_precision_vector2 /w reduced lines
c                NOTE 30 lines used in histogram method
c     01Dec2019: modified for qff analysis
c     16Jul2021: character lengths changed from 16 to 32

      SUBROUTINE find_precision_vector_qff20210716(l_rgh_lines,l_lines,
     +  s_vec_tmax,
     +  s_vec_tmax_origprec,s_vec_tmax_origprec_neglog,
     +  s_vec_tmax_origprec_empir)

      IMPLICIT NONE
c************************************************************************
c     Variables brought into program

      INTEGER             :: l_rgh_lines
      INTEGER             :: l_lines

      CHARACTER(LEN=*)    :: s_vec_tmax(l_rgh_lines)                 !32
      CHARACTER(LEN=*)    :: s_vec_tmax_origprec(l_rgh_lines)        !32
      CHARACTER(LEN=*)    :: s_vec_tmax_origprec_neglog(l_rgh_lines) !1
      CHARACTER(LEN=*)    :: s_vec_tmax_origprec_empir(l_rgh_lines)  !32
c*****
c     Variables used in program

      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: i_len
      INTEGER             :: i_lenprec
      CHARACTER(LEN=32)   :: s_single
      CHARACTER(LEN=32)   :: s_lenprec
      CHARACTER(LEN=1)    :: s_lenprec_neglog

      CHARACTER(LEN=1)    :: s_charlist_dec_right(l_rgh_lines,5)
      CHARACTER(LEN=1)    :: s_charlist_dec_left(l_rgh_lines,5)
      INTEGER             :: i_charlist_cnt_right(l_rgh_lines)
      INTEGER             :: i_charlist_cnt_left(l_rgh_lines)
      CHARACTER(LEN=1)    :: s_charlist_single(l_rgh_lines)
      CHARACTER(LEN=1)    :: s_singlechar
      INTEGER             :: i_good
      INTEGER             :: i_bad

      INTEGER             :: i_flag(l_rgh_lines)

      INTEGER             :: l_numelement
      CHARACTER(LEN=1)    :: s_listelement(12)  
      INTEGER             :: i_histelement(12)
      INTEGER             :: i_hist_right(5)
      INTEGER             :: i_hist_left(5)

      CHARACTER(LEN=32)   :: s_lenprec_vec_right(5)
      CHARACTER(LEN=32)   :: s_lenprec_vec_left(5)

      CHARACTER(LEN=32)   :: s_lenprec_empir

      INTEGER             :: i_case

      INTEGER             :: l_cnt
      INTEGER             :: l_cnt_limit
      INTEGER             :: l_lines_use

      INTEGER             :: i_topout_right,i_topout_left

c************************************************************************
c      print*,'just entered find_precision_vector_qff20210716',l_lines

c      print*,'l_lines=',l_lines
c      print*,'s_vec_tmax=',(s_vec_tmax(i),i=1,5)
c      DO i=1,l_lines
c       print*,'i=',i,s_vec_tmax(i)
c      ENDDO

c     Find histogram for n lines

c     Initialize decimal placement vectors
      DO i=1,l_lines
       DO j=1,5
        s_charlist_dec_right(i,j)='x'
        s_charlist_dec_left(i,j) ='x'
       ENDDO
      ENDDO

c     Cycle through all lines
      l_cnt=0
      l_cnt_limit=30
      l_lines_use=l_lines          !initialize variable
      DO i=1,l_lines

c      Initialize flags for each line
       i_topout_right=0
       i_topout_left=0

       s_single=TRIM(s_vec_tmax(i))
       i_len=LEN_TRIM(s_single)

c      Case where field blank
       IF (i_len.EQ.0) THEN
        s_lenprec=''

        i_flag(i)=0
       ENDIF

c      Case where number entered
       IF (i_len.GT.0) THEN

        i_flag(i)=1
        l_cnt=l_cnt+1

c       Exit loop if more than 30 elements found
        IF (l_cnt.GT.l_cnt_limit) THEN
         l_lines_use=i         !define reduced line index
         GOTO 61
        ENDIF

c       Cycle along characters to find period
        DO j=1,i_len

c        Case where period found
         IF (s_single(j:j).EQ.'.') THEN
          i_lenprec=i_len-j
          WRITE( s_lenprec_neglog,'(i1)') i_lenprec
c          print*,'len_prec=',i,TRIM(s_single),i_len-j

          IF (j.LE.1.OR.j.GE.32) THEN
           print*,'emergency stop; period in strange place'
           print*,'j=',j
           STOP 'find_precision_vector_qff20210716'
          ENDIF

c         Query characters right of decimal place
          jj=1
          DO k=j+1,i_len

c          Exit loop if storage index exceeded
           IF (jj.GT.5) THEN
            i_topout_right=1
            GOTO 22 

            print*,'emergency stop'
            print*,'storage s_charlist_dec_right exceeded'
            print*,'i,j+1,i_len=',i,j+1,i_len,jj
            print*,'s_single='//s_single//'='
            STOP 'find_precision_vector_qff20210716'
           ENDIF

           s_charlist_dec_right(i,jj)=s_single(k:k)
           jj=jj+1

          ENDDO

 22       CONTINUE

          i_charlist_cnt_right(i)=jj
c          print*,'i_charlist_cnt_right=',i_charlist_cnt_right(i),'elem',
c     +      (s_charlist_dec_right(i,k),k=1,jj)

c         Query characters left of decimal place
          jj=1
          DO k=j-1,1,-1

c          Exit loop if storage exceeded
           IF (jj.GT.5) THEN 

            i_topout_left=1
            GOTO 24 

            print*,'emergency stop'
            print*,'storage s_charlist_dec_left exceeded'
            print*,'i,j=',i,j,jj
            print*,'s_single='//s_single//'='
            STOP 'find_precision_vector_qff20210716'
           ENDIF

           s_charlist_dec_left(i,jj)=s_single(k:k)
           jj=jj+1

          ENDDO

 24       CONTINUE

          i_charlist_cnt_left(i)=jj
c          print*,'i_charlist_cnt_left=',i_charlist_cnt_left(i),'elem',
c     +      (s_charlist_dec_left(i,k),k=1,jj)

          i_case=1

c         exit loop after decimal place found
          GOTO 31

         ENDIF
        ENDDO   !close i_len index j

c       Case 2 where no decimal place found
        jj=1
        DO k=i_len,1,-1

         IF (jj.GT.5) THEN 
          print*,'emergency stop; no decimal case'
          print*,'storage s_charlist_dec_left exceeded'
          print*,'i,j=',i,j,jj
          print*,'s_single='//s_single//'='
          STOP 'find_precision_vector_qff20210716'
         ENDIF

         s_charlist_dec_left(i,jj)=s_single(k:k)
         jj=jj+1
        ENDDO
        i_charlist_cnt_left(i)=jj

        i_case=2

cc       positions to right of decimal place set to 0
c        DO k=1,5
c         s_charlist_dec_right(i,k)='x'    !fill rhs with x
c        ENDDO
c        i_charlist_cnt_right(i)=0

c        print*,'i_charlist_cnt_left=',i_charlist_cnt_left(i),'elem=',
c     +    (s_charlist_dec_left(i,k),k=1,jj)

 31     CONTINUE

       ENDIF
      ENDDO

 61   CONTINUE

c      print*,'Location A'
c      print*,'i_flag=',(i_flag(i),i=1,l_lines)

c     Find number of different characters in each position

c     RIGHT
      DO j=1,5
c       print*,'j=',j

       i_bad =0
       i_good=0
       i_hist_right(j)=0

       DO i=1,l_lines_use   !l_lines

c        print*,'i_loop',i,i_flag(i)

c       Condition that field must be nonzero length
        IF (i_flag(i).EQ.1) THEN

        s_singlechar=s_charlist_dec_right(i,j)

c        print*,'i,j=',i,j,i_good,s_charlist_dec_right(i,j)

c       Count number of good & bad elements
        IF (s_singlechar.EQ.'x') THEN 
         i_bad=i_bad+1
        ENDIF
        IF (s_singlechar.NE.'x') THEN 
         i_good=i_good+1
         s_charlist_single(i_good)=s_singlechar
        ENDIF
        
        ENDIF
       ENDDO

c       print*,'i_bad,i_good=',i_bad,i_good

c      Query vector if any good numbers
c      Find number distinct elements if i_good>0
       IF (i_good.GT.0) THEN 
        CALL find_number_elements(l_rgh_lines,i_good,
     +     s_charlist_single,
     +     l_numelement,s_listelement,i_histelement)

        i_hist_right(j)=l_numelement
       ENDIF       

c       print*,'j,i_hist_right',j,i_hist_right(j)
      ENDDO

c      print*,'Location B'

c     LEFT
      DO j=1,5
       i_bad =0
       i_good=0
       i_hist_left(j)=0

       DO i=1,l_lines_use    !l_lines
c       Condition that field must be nonzero length
        IF (i_flag(i).EQ.1) THEN

        s_singlechar=s_charlist_dec_left(i,j)

c       Count number of good & bad elements
        IF (s_singlechar.EQ.'x') THEN 
         i_bad=i_bad+1
        ENDIF
        IF (s_singlechar.NE.'x') THEN 
         i_good=i_good+1
         s_charlist_single(i_good)=s_singlechar
        ENDIF

        ENDIF
       ENDDO

c      Query vector if any good numbers
c      Find number distinct elements if i_good>0
       IF (i_good.GT.0) THEN 
        CALL find_number_elements(l_rgh_lines,i_good,
     +     s_charlist_single,
     +     l_numelement,s_listelement,i_histelement)

        i_hist_left(j)=l_numelement
       ENDIF       
      ENDDO   !close l_lines index i

c      print*,'Location C'
c*****
c     Find empirical precision vector
      s_lenprec_vec_left(1)  ='1'
      s_lenprec_vec_left(2)  ='10'
      s_lenprec_vec_left(3)  ='100'
      s_lenprec_vec_left(4)  ='1000'
      s_lenprec_vec_left(5)  ='10000'
      s_lenprec_vec_right(1) ='0.1'
      s_lenprec_vec_right(2) ='0.01'
      s_lenprec_vec_right(3) ='0.001'
      s_lenprec_vec_right(4) ='0.0001'
      s_lenprec_vec_right(5) ='0.00001'

c      print*,'i_hist_left=',(i_hist_left(i),i=1,5)
c      print*,'i_hist_right=',(i_hist_right(i),i=1,5)

c     Case1: decimal place
      s_lenprec_empir=''  !initialization
      IF (i_case.EQ.1) THEN 
      DO i=5,1,-1 
       IF (i_hist_left(i).GT.1) THEN 
        s_lenprec_empir=s_lenprec_vec_left(i)
       ENDIF
      ENDDO
      DO i=1,5 
       IF (i_hist_right(i).GT.1) THEN 
        s_lenprec_empir=s_lenprec_vec_right(i)
       ENDIF
      ENDDO
      ENDIF

c      print*,'s_lenprec_empir=',s_lenprec_empir

c      STOP 'find_precision_vector_qff20210716'

c     Case2: no decimal place
      IF (i_case.EQ.2) THEN 
      DO i=5,1,-1 
       IF (i_hist_left(i).GT.1) THEN 
        s_lenprec_empir=s_lenprec_vec_left(i)
       ENDIF
      ENDDO
      ENDIF

c      print*,'Location D'
c*****
c     place empirical precision in each line
      DO i=1,l_lines
       s_single=TRIM(s_vec_tmax(i))
       i_len=LEN_TRIM(s_single)

c      Case where field blank
       IF (i_len.EQ.0) THEN
        s_vec_tmax_origprec_empir(i)=''  !no precision estimate if field blank
       ENDIF
       IF (i_len.GT.0) THEN
        s_vec_tmax_origprec_empir(i)=s_lenprec_empir
       ENDIF

      ENDDO

c      print*,'Location E'

c      print*,'i_case=',i_case
c      print*,'i_hist_right=',(i_hist_right(i),i=1,5)
c      print*,'i_hist_left=', (i_hist_left(i),i=1,5)
c      print*,'s_lenprec_empir=',s_lenprec_empir

c      print*,'l_numelement=',l_numelement
c      print*,'s_listelement=',(s_listelement(i),i=1,l_numelement)
c      print*,'i_histelement=',(i_histelement(i),i=1,l_numelement)

c      STOP 'find_precision_vector2'
c************************************************************************
c************************************************************************
c     Original analysis based on number the decimal places
      DO i=1,l_lines
       s_single=TRIM(s_vec_tmax(i))
       i_len=LEN_TRIM(s_single)

c      Case where field blank
       IF (i_len.EQ.0) THEN
        s_lenprec=''
       ENDIF

c      Case where number entered
       IF (i_len.GT.0) THEN
c       Cycle along characters to find period
        DO j=1,i_len
         IF (s_single(j:j).EQ.'.') THEN
          i_lenprec=i_len-j
          WRITE( s_lenprec_neglog,'(i1)') i_lenprec
c          print*,'len_prec=',TRIM(s_single),i_len-j

c         Establish conditions for input precision
          IF (i_lenprec.EQ.1) THEN 
           s_lenprec='0.1'
           GOTO 10
          ENDIF
          IF (i_lenprec.EQ.2) THEN 
           s_lenprec='0.01'
           GOTO 10
          ENDIF
          IF (i_lenprec.EQ.3) THEN 
           s_lenprec='0.001'
           GOTO 10
          ENDIF
          IF (i_lenprec.EQ.4) THEN 
           s_lenprec='0.0001'
           GOTO 10
          ENDIF
          IF (i_lenprec.EQ.5) THEN 
           s_lenprec='0.00001'
           GOTO 10
          ENDIF
c         12Dec2019: extra condition added to handle exception
          IF (i_lenprec.GT.5) THEN 
           s_lenprec='0.00001'
           GOTO 10
          ENDIF

          IF (i_lenprec.GT.5) THEN 
           print*,'precision out of range'
           print*,'i_lenprec=',i_lenprec
           print*,'i_len=',i_len
           print*,'i,j=',i,j
           print*,'s_vec_tmax=',TRIM(s_vec_tmax(i))

           STOP 'find_precision_vector_qff'
          ENDIF

c          GOTO 10
         ENDIF
        ENDDO

c       If here then no decimal place found
        s_lenprec_neglog='0'  
        s_lenprec='1'    !if no decimal place found 
       ENDIF

 10    CONTINUE

       s_vec_tmax_origprec(i)=s_lenprec
       s_vec_tmax_origprec_neglog(i)=s_lenprec_neglog 
      ENDDO 

c      print*,'s_lenprec=',       s_lenprec
c      print*,'s_lenprec_neglog=',s_lenprec_neglog
c      print*,'s_lenprec_empir=', s_lenprec_empir

c      print*,'just leaving find_precision_vector_qff'

c      STOP 'find_precision_vector2'

      RETURN
      END
