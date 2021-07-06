c     Subroutine to resolve qc info
c     AJ_Kettle, 14Dec2020
c     01Feb2021: slave designations for variables passed into subroutine
c     05Feb2021: used for GSOM coversion

      SUBROUTINE resolve_qc_single_param20210205(
     +  s_qckey_timescale_spec,l_qckey,
     +  s_qckey_sourceflag,s_qckey_c3sflag,s_qckey_timescale,
     +  l_rgh_lines,l_lines,
     +   s_vec_tmax_qc,s_vec_tmax_qc_ncepcode,

     +   s_vec_tmax_qc_cdmqcmethod,
     +  i_cnt_qc)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into subroutine

      CHARACTER(LEN=300)  :: s_qckey_timescale_spec
      INTEGER             :: l_qckey
      CHARACTER(LEN=*)    :: s_qckey_sourceflag(100)             !2
      CHARACTER(LEN=*)    :: s_qckey_c3sflag(100)                !2
      CHARACTER(LEN=300)  :: s_qckey_timescale(100) 

      INTEGER             :: l_rgh_lines
      INTEGER             :: l_lines

      CHARACTER(LEN=*)    :: s_vec_tmax_qc(l_rgh_lines)             !1
      CHARACTER(LEN=*)    :: s_vec_tmax_qc_ncepcode(l_rgh_lines)    !1
      CHARACTER(LEN=*)    :: s_vec_tmax_qc_cdmqcmethod(l_rgh_lines) !2

      INTEGER             :: i_cnt_qc
c******
c     Variables used in subroutine
      INTEGER             :: i,j,k,ii,jj,kk

      INTEGER             :: ilen
c************************************************************************
      ii=0

      DO i=1,l_lines

c      Initialize
       s_vec_tmax_qc_cdmqcmethod(i)=''

       ilen=LEN_TRIM(s_vec_tmax_qc_ncepcode(i))

c      act if ncepcode not empty
       IF (ilen.GT.0) THEN

        DO j=1,l_qckey
c        Match time scales
         IF (TRIM(s_qckey_timescale(j)).EQ.TRIM(s_qckey_timescale_spec))
     +     THEN
c        comparing 1 & 2 element string
         IF (TRIM(s_vec_tmax_qc_ncepcode(i)).EQ.
     +       TRIM(s_qckey_sourceflag(j))) THEN
c          print*,'match found, s_vec_tmax_qc_ncepcode=',
c     +      s_vec_tmax_qc_ncepcode(i)
c          STOP 'resolve_qc_single_param20210205'

          ii=ii+1
          s_vec_tmax_qc_cdmqcmethod(i)=TRIM(ADJUSTL(s_qckey_c3sflag(j)))   !both length 2

c          print*,'match found, s_vec_tmax_qc_ncepcode=',
c     +      s_vec_tmax_qc_ncepcode(i),s_vec_tmax_qc_cdmqcmethod(i)
c          STOP 'resolve_qc_single_param20210205'

          GOTO 10
         ENDIF
         ENDIF
        ENDDO

        print*,'problem: qc flag info not found',
     +    '='//TRIM(s_vec_tmax_qc_ncepcode(i))//'='

        print*,'qckey info'
        DO j=1,l_qckey
         print*,'j=',j,'='//TRIM(s_qckey_sourceflag(j))//'='
        ENDDO

        STOP 'resolve_qc_single_param20210205'

 10     CONTINUE
       ENDIF

      ENDDO

      i_cnt_qc=ii

c      print*,'ii=',ii,l_timestamp

      RETURN
      END
