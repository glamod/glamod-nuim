c     Subroutine to get precision of vector
c     AJ_Kettle, 13Dec2018

      SUBROUTINE precision_single_vector1a(l_timestamp_rgh,l_timestamp,
     +  s_tmin_datavalue,
     +  i_prec_empir)

      IMPLICIT NONE
c************************************************************************
c     Declare variables passed into program

      INTEGER             :: l_timestamp_rgh
      INTEGER             :: l_timestamp
      CHARACTER(LEN=5)    :: s_tmin_datavalue(l_timestamp_rgh)

      INTEGER             :: i_prec_empir
c*****
c     Variables used in subroutine      
      INTEGER             :: i,j,k,ii,jj,kk

      INTEGER             :: i_len
      CHARACTER(LEN=5)    :: s_singlevalue
      CHARACTER(LEN=1)    :: s_singlechar

      INTEGER             :: l_extract
      CHARACTER(LEN=1)    :: s_singlechar_0(20)
      CHARACTER(LEN=1)    :: s_singlechar_1(20) 
      CHARACTER(LEN=1)    :: s_singlechar_2(20)  

      INTEGER             :: l_pattern
      CHARACTER(LEN=1)    :: s_pattern(11)
      INTEGER             :: i_hist0(11)
      INTEGER             :: i_hist1(11)
      INTEGER             :: i_hist2(11)

      INTEGER             :: i_occ0,i_occ1,i_occ2

      INTEGER             :: i_threshold
      INTEGER             :: l_iiuse
c************************************************************************
      l_extract=30

      ii=0

      DO i=1,l_timestamp 
       s_singlevalue=TRIM(s_tmin_datavalue(i))
       i_len=LEN_TRIM(s_singlevalue)

       IF (i_len.GT.0.AND.i_len.GE.3) THEN
        
        ii=ii+1

        s_singlechar_0(ii)=s_singlevalue(i_len:i_len)
        s_singlechar_1(ii)=s_singlevalue(i_len-1:i_len-1)
        s_singlechar_2(ii)=s_singlevalue(i_len-2:i_len-2)
     
c        print*,'i_len...',i,ii,i_len,TRIM(s_singlevalue)
c        print*,'s_singlechar'//'='//s_singlechar_0(ii)//'='//
c     +    s_singlechar_1(ii)//'='//s_singlechar_2(ii)//'='

c       Exit loop if l_extract numbers found
        IF (ii.EQ.l_extract) THEN 
         GOTO 10

c         STOP 'test_precision_variables; ii=10'
        ENDIF

       ENDIF
      ENDDO

 10   CONTINUE

      l_iiuse=ii
c*****
c     Exit analysis if threshold number not reached
      i_threshold=10
      IF (l_iiuse.LT.i_threshold) THEN 
       GOTO 20
      ENDIF
c*****
c     Test vector for number of distinct values
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
            
c     Initialize historgram with null values
      DO i=1,l_pattern
       i_hist0(i)=0
       i_hist1(i)=0
       i_hist2(i)=0
      ENDDO

      DO i=1,l_iiuse    !cycle through archived numbers
       DO j=1,l_pattern   !cycle through histogram identifiers
        IF (s_singlechar_0(i).EQ.s_pattern(j)) THEN 
         i_hist0(j)=i_hist0(j)+1
        ENDIF
        IF (s_singlechar_1(i).EQ.s_pattern(j)) THEN 
         i_hist1(j)=i_hist1(j)+1
        ENDIF
        IF (s_singlechar_2(i).EQ.s_pattern(j)) THEN 
         i_hist2(j)=i_hist2(j)+1
        ENDIF
       ENDDO
      ENDDO

c     Count number of different positions occupied
      i_occ0=0
      i_occ1=0
      i_occ2=0
      DO i=1,l_pattern
       IF (i_hist0(i).GT.0) THEN 
        i_occ0=i_occ0+1
       ENDIF
       IF (i_hist1(i).GT.0) THEN 
        i_occ1=i_occ1+1
       ENDIF
       IF (i_hist2(i).GT.0) THEN 
        i_occ2=i_occ2+1
       ENDIF
      ENDDO

c      print*,'i_hist0=',(i_hist0(i),i=1,l_pattern)
c      print*,'i_hist1=',(i_hist1(i),i=1,l_pattern)
c      print*,'i_hist2=',(i_hist2(i),i=1,l_pattern)
c      print*,'i_occ0...',i_occ0,i_occ1,i_occ2

c     Find empirical precision
c     Condition for identifying last place
      i_prec_empir=-999
      IF (i_occ0.GT.1) THEN
       i_prec_empir=0
       GOTO 20
      ENDIF
      IF (i_occ0.LE.1) THEN
       IF (i_occ1.GT.1) THEN
        i_prec_empir=1
        GOTO 20
       ENDIF
       IF (i_occ1.LE.1) THEN
        IF (i_occ2.GT.1) THEN
         i_prec_empir=2
         GOTO 20
        ENDIF
       ENDIF
      ENDIF

c     If here then error in procedure
c      STOP 'test_precision_variables; error in i_prec_empir'

 20   CONTINUE

c      print*,'i_prec_empir',i_prec_empir

      RETURN
      END


