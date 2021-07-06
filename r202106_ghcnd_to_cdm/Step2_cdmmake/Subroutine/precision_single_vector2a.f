c     Subroutine to get precision of vector
c     AJ_Kettle, 13Dec2018

c     Subroutines called
c      -find_hist_dailyprecision2

      SUBROUTINE precision_single_vector2a(l_timestamp_rgh,l_timestamp,
     +  s_tmin_datavalue,
     +  i_prec_empir)

      IMPLICIT NONE
c************************************************************************
c     Declare variables passed into program

      INTEGER             :: l_timestamp_rgh
      INTEGER             :: l_timestamp
      CHARACTER(LEN=*)    :: s_tmin_datavalue(l_timestamp_rgh)  !LEN=5

      INTEGER             :: i_prec_empir
c*****
c     Variables used in subroutine      

      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: l_extract
      INTEGER             :: ii_use

      INTEGER             :: i_len
      CHARACTER(LEN=5)    :: s_singlevalue

      CHARACTER(LEN=1)    :: s_matrix_char(100,5) 
      CHARACTER(LEN=1)    :: s_singlechar_vec(100)
      INTEGER             :: i_len_arch(100)

      INTEGER             :: l_char

      INTEGER             :: l_pattern
      CHARACTER(LEN=1)    :: s_pattern(11)
      INTEGER             :: i_hist_single(11)
      INTEGER             :: i_populated
      INTEGER             :: i_vec_populated(5)
c************************************************************************
c      print*,'just entered precision_single_vector2'

c      print*,'s_tmin_datavalue=',(s_tmin_datavalue(i),i=1,100)

c     initialize main output to ndflag
      i_prec_empir=-999  !initialize index to -999

      l_extract=100 !30  !select 100 points for analysis

c     Initialize matrix with null-strings
      DO i=1,100
       DO j=1,5 
        s_matrix_char(i,j)='x'
       ENDDO
      ENDDO

c      print*,'1.s_matrix_char=',(s_matrix_char(1,j),j=1,5)
c      print*,'2.s_matrix_char=',(s_matrix_char(2,j),j=1,5)
c      print*,'3.s_matrix_char=',(s_matrix_char(3,j),j=1,5)
c      print*,'4.s_matrix_char=',(s_matrix_char(4,j),j=1,5)
c      print*,'5.s_matrix_char=',(s_matrix_char(5,j),j=1,5)

      ii=0

      DO i=1,l_timestamp 
       s_singlevalue=TRIM(s_tmin_datavalue(i))
       i_len=LEN_TRIM(s_singlevalue)
 
c      Condition for valid number of any length
       IF (i_len.GT.0) THEN
        ii=ii+1
        jj=0
        DO j=i_len,1,-1
         jj=jj+1
         s_matrix_char(ii,jj)=s_singlevalue(j:j)
         i_len_arch(ii)      =i_len
c         IF (jj.GT.5) THEN
c          STOP 'precision_single_vector2; jj too big for s_matrix_char' 
c         ENDIF
        ENDDO

c       Condition to exit loop when 30 element threshold reached
        IF (ii.GE.l_extract) THEN 
         GOTO 10
        ENDIF
       ENDIF
      ENDDO

 10   CONTINUE

      ii_use=ii

c     Exit loop if no numbers found
      IF (ii_use.EQ.0) THEN
       GOTO 100
      ENDIF

c      print*,'ii_use=',ii_use
c      print*,'1.s_tmin_datavalue=',s_tmin_datavalue(1)
c      print*,'1.s_matrix_char=',(s_matrix_char(1,j),j=1,5)
c      print*,'1.i_len_arch=',i_len_arch(1)
c      print*,'2.s_tmin_datavalue=',s_tmin_datavalue(2)
c      print*,'2.s_matrix_char=',(s_matrix_char(2,j),j=1,5)
c      print*,'2.i_len_arch=',i_len_arch(2)
c      print*,'3.s_tmin_datavalue=',s_tmin_datavalue(3)
c      print*,'3.s_matrix_char=',(s_matrix_char(3,j),j=1,5)
c      print*,'3.i_len_arch=',i_len_arch(3)
c      print*,'4.s_tmin_datavalue=',s_tmin_datavalue(4)
c      print*,'4.s_matrix_char=',(s_matrix_char(4,j),j=1,5)
c      print*,'4.i_len_arch=',i_len_arch(4)
c      print*,'5.s_tmin_datavalue=',s_tmin_datavalue(5)
c      print*,'5.s_matrix_char=',(s_matrix_char(5,j),j=1,5)
c      print*,'5.i_len_arch=',i_len_arch(5)
c*****
c     Define standard historgram elements

      l_pattern=11
      s_pattern(1)='0'
      s_pattern(2)='1'
      s_pattern(3)='2'
      s_pattern(4)='3'
      s_pattern(5)='4'
      s_pattern(6)='5'
      s_pattern(7)='6'
      s_pattern(8)='7'
      s_pattern(9)='8'
      s_pattern(10)='9'
      s_pattern(11)='-'
c*****
c     Define lines of data

c     initialize single character line
      DO i=1,100
       s_singlechar_vec(i)=''
      ENDDO

      DO i=1,5
       i_vec_populated(i)=0
      ENDDO

      DO j=1,5 
       ii=0
       DO i=1,ii_use     !cycle through data lines
        IF (s_matrix_char(i,j).NE.'x') THEN   
         ii=ii+1
         s_singlechar_vec(ii)=s_matrix_char(i,j)
        ENDIF
       ENDDO

       l_char=ii    !range of values 0-100

c      Process for histogram 

c      Initialize histogram
c       DO i=1,l_pattern       
c        i_hist_single(i)=0
c       ENDDO

       CALL find_hist_dailyprecision2(l_pattern,s_pattern,
     +   l_char,s_singlechar_vec,
     +   i_hist_single,i_populated)

       i_vec_populated(j)=i_populated

c       print*,'j,l_char',j,l_char
c       print*,'s_singlechar_vec=',(s_singlechar_vec(i),i=1,l_char)
c       print*,'i_populated'

      ENDDO
c*****
c     Find index of significant position
      i_prec_empir=-999  !initialize index to -999
      DO i=1,5
       IF (i_vec_populated(i).GT.1) THEN
        i_prec_empir=i-1

c       terminate search program
        GOTO 20
       ENDIF 
      ENDDO 

c     If there then problem. Look for highest precision
      DO i=5,1,-1
c      Find index of highest populated location
       IF (i_vec_populated(i).GT.0) THEN
        i_prec_empir=i-1
        GOTO 20
       ENDIF
      ENDDO

 20   CONTINUE
c*****
 100  CONTINUE      !come here if no valid data
c*****
c      print*,'l_char=',l_char
c      print*,'s_singlechar_vec=',(s_singlechar_vec(i),i=1,l_char)
c      print*,'i_vec_populated=',(i_vec_populated(i),i=1,5)
c      print*,'i_prec_empir=',i_prec_empir
c*****
c      print*,'just leaving precision_single_vector2'

c      STOP 'precision_single_vector2'

      RETURN
      END
