c     Subroutine to get source id number code from letter code
c     AJ_Kettle, 10Dec2018

      SUBROUTINE get_source_id_single2(l_source_rgh,l_source,
     +  s_source_codeletter,s_source_codenumber,
     +  l_timestamp_rgh,l_timestamp,s_prcp_sflag, 
     +  s_prcp_sourceid)

      IMPLICIT NONE
c************************************************************************
c     Declare variables passed into program

      INTEGER             :: l_source_rgh
      INTEGER             :: l_source
      CHARACTER(LEN=1)    :: s_source_codeletter(l_source_rgh)
      CHARACTER(LEN=3)    :: s_source_codenumber(l_source_rgh)

      INTEGER             :: l_timestamp_rgh
      INTEGER             :: l_timestamp

      CHARACTER(LEN=1)    :: s_prcp_sflag(l_timestamp_rgh)

      CHARACTER(LEN=3)    :: s_prcp_sourceid(l_timestamp_rgh)
c*****
c     Variables used in subroutine

      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: i_len
c************************************************************************
c      print*,'just entered get_source_id_single2'

      DO i=1,l_timestamp

       s_prcp_sourceid(i)=''    !initialize source id to blank

       i_len=LEN_TRIM(s_prcp_sflag(i))

c      Act if source letter flag in place
       IF (i_len.GT.0) THEN

       DO j=1,l_source 
        IF (TRIM(s_prcp_sflag(i)).EQ.TRIM(s_source_codeletter(j))) THEN 
         s_prcp_sourceid(i)=s_source_codenumber(j)
         GOTO 10
        ENDIF
       ENDDO

c      If here then letter code not found
       print*,'emergency stop, letter code not found'
       print*,'s_prcp_sflag=',TRIM(s_prcp_sflag(i))
       STOP 'get_source_id_single'

 10    CONTINUE

       ENDIF
      ENDDO

c      print*,'s_prcp_sflag=',( TRIM(s_prcp_sflag(i)),i=1,10)
c      print*,'s_prcp_sourceid=',( TRIM(s_prcp_sourceid(i)),i=1,10)

c      print*,'just leaving get_source_id_single2'

      RETURN
      END
