c     Subroutine to resolve qc for singlel variable
c     AJ_Kettle, 20Nov2020

      SUBROUTINE qc_c3s_singlevariable(l_rgh,l_lines,
     +  s_vec_airt_qc_flag,s_vec_airt_cdmqc,s_vec_airt_cdmqcpivot,
     +  s_qckey_timescale_spec,
     +  l_qckey,
     +  s_qckey_sourceflag,s_qckey_c3sflag,s_qckey_timescale)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into subroutine

      INTEGER             :: l_rgh
      INTEGER             :: l_lines

      CHARACTER(LEN=8)    :: s_vec_airt_qc_flag(l_rgh)
      CHARACTER(LEN=1)    :: s_vec_airt_cdmqc(l_rgh)
      CHARACTER(LEN=2)    :: s_vec_airt_cdmqcpivot(l_rgh)

      CHARACTER(LEN=300)  :: s_qckey_timescale_spec
      INTEGER             :: l_qckey
      CHARACTER(LEN=2)    :: s_qckey_sourceflag(100)
      CHARACTER(LEN=2)    :: s_qckey_c3sflag(100)
      CHARACTER(LEN=300)  :: s_qckey_timescale(100)
c*****
c     Variables used in subroutine

      INTEGER             :: i,j,k,ii,jj,kk

      INTEGER             :: l_len,l_len_test
c************************************************************************

      ii=0

      DO i=1,l_lines
       l_len=LEN_TRIM(s_vec_airt_qc_flag(i))

       l_len_test=LEN_TRIM(s_vec_airt_cdmqc(i))

c      test against previous qc assessment
c       IF (l_len.NE.l_len_test) THEN 
c        print*,'emergency stop, mismatched qc flags'
c        print*,'i...',i,l_len,l_len_test
c        STOP 'find_qc_pivot_table_info'
c       ENDIF

c      Initialize pivot table info to blank
       s_vec_airt_cdmqcpivot(i)=''

       IF (l_len.GT.0) THEN 

        DO j=1,l_qckey
c        Match qc flag 
         IF (TRIM(s_vec_airt_qc_flag(i)).EQ.TRIM(s_qckey_sourceflag(j))) 
     +     THEN
c        Match timescale
         IF (TRIM(s_qckey_timescale(j)).EQ.TRIM(s_qckey_timescale_spec)) 
     +     THEN
          s_vec_airt_cdmqcpivot(i)=TRIM(s_qckey_c3sflag(j))

         ENDIF
         ENDIF
        ENDDO

        ii=ii+1

c        print*,'s_vec_airt_qc_flag=',i,s_vec_airt_qc_flag(i),
c     +    '='//s_vec_airt_cdmqcpivot(i)//'='
       ENDIF

      ENDDO

c      print*,'ii=',ii

      RETURN
      END
