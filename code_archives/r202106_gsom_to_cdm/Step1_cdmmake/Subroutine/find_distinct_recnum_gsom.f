c     Subroutine to find distinct record numbers
c     AJ_Kettle, 02Oct2019

      SUBROUTINE find_distinct_recnum_gsom(
     +   l_channel,s_avec_recordnumber,
     +   l_distinct_recnum,s_dvec_recordnumber)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into program

      INTEGER             :: l_channel
      INTEGER             :: l_distinct_recnum

      CHARACTER(LEN=*)    :: s_avec_recordnumber(l_channel)
      CHARACTER(LEN=*)    :: s_dvec_recordnumber(l_channel)
c*****
c     Variables used in subroutine

      INTEGER             :: i,j,k,ii,jj,kk 

c     intermendiate info on valid recnums
      INTEGER             :: l_validvec
      CHARACTER(LEN=2)    :: s_validvec_recnum(l_channel)

      INTEGER             :: i_dvec_count(l_channel)
c************************************************************************
c      print*,'just entered find_distinct_recnum_gsom'
c*****
c     Initialize
      l_distinct_recnum=0
      DO i=1,l_channel
       s_dvec_recordnumber(i)=''
       i_dvec_count(i)       =0
      ENDDO
c*****
      ii=0

      DO i=1,l_channel
       IF (LEN_TRIM(s_avec_recordnumber(i)).GT.0) THEN 
        ii=ii+1
        s_validvec_recnum(ii)=s_avec_recordnumber(i)
       ENDIF
      ENDDO

      l_validvec=ii
c*****
c     Case of no valid numbers
      IF (l_validvec.EQ.0) THEN
       GOTO 10
      ENDIF

c      print*,'l_validvec=',l_validvec
c      print*,'s_validvec_recnum=',(s_validvec_recnum(i),i=1,l_validvec)
c*****
c     Case of single record_num

      IF (l_validvec.EQ.1) THEN
       l_distinct_recnum     =1
       s_dvec_recordnumber(1)=s_validvec_recnum(1)
       i_dvec_count(1)       =1
       GOTO 10
      ENDIF
c*****
c     For greater numbers find distinct record number

      l_distinct_recnum=0
      l_distinct_recnum=l_distinct_recnum+1
      s_dvec_recordnumber(l_distinct_recnum)=s_validvec_recnum(1)
      i_dvec_count(l_distinct_recnum)=i_dvec_count(l_distinct_recnum)+1    

      DO i=2,l_validvec
       DO j=1,l_distinct_recnum
        IF (TRIM(s_validvec_recnum(i)).EQ.TRIM(s_dvec_recordnumber(j))) 
     +     THEN 
         i_dvec_count(j)=i_dvec_count(j)+1       
         GOTO 20
        ENDIF
       ENDDO       

c      If here then must augment 
       l_distinct_recnum=l_distinct_recnum+1
       s_dvec_recordnumber(l_distinct_recnum)=s_validvec_recnum(1)
       i_dvec_count(l_distinct_recnum)=i_dvec_count(l_distinct_recnum)+1  

 20    CONTINUE
      ENDDO

c      print*,'l_distinct_recnum=',l_distinct_recnum
c      print*,'s_dvec_recordnumber=',
c     +   (s_dvec_recordnumber(i),i=1,l_distinct_recnum)
c      print*,'i_dvec_count=',
c     +   (i_dvec_count(i),i=1,l_distinct_recnum)

c*****
 10   CONTINUE

c      print*,'just leaving find_distinct_recnum_gsom'

c      STOP 'find_distinct_recnum_gsom'

      RETURN
      END
