c     Subroutine to get qc_vector
c     AJ_Kettle, 13Nov2018

      SUBROUTINE qc_checker20210204(
     +  l_rgh_lines,l_lines,s_vec_tmax_attrib,
     +  s_vec_tmax_qc,
     +  s_vec_tmax_qc_ncepcode)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into program

      INTEGER             :: l_rgh_lines
      INTEGER             :: l_lines

      CHARACTER(LEN=10)   :: s_vec_tmax_attrib(l_rgh_lines)
      CHARACTER(LEN=1)    :: s_vec_tmax_qc(l_rgh_lines)
      CHARACTER(LEN=1)    :: s_vec_tmax_qc_ncepcode(l_rgh_lines)
c*****
c     Variables used in program

      INTEGER             :: i,j,k,ii,jj,kk

      CHARACTER(LEN=10)   :: s_single
      CHARACTER(LEN=1)    :: s_ncepcode

      INTEGER             :: i_len
      INTEGER             :: i_comma_pos(5)
      INTEGER             :: i_comma_cnt
      INTEGER             :: i_qc_delchar
c************************************************************************
c     TMAX

c     Cycle through lines
      DO i=1,l_lines

c      Initialize output variable to blank fields
       s_vec_tmax_qc(i)=''
       s_vec_tmax_qc_ncepcode(i)='' 

       s_single=s_vec_tmax_attrib(i)

       i_len=LEN_TRIM(s_vec_tmax_attrib(i))

c      Only act if something in field
       IF (i_len.NE.0) THEN 

c       print*,'s_single='//s_single//'='
c       STOP 'qc_checker20210204'

c      Cycle through line to find locations of commas
       i_comma_cnt=1
       DO j=1,i_len
        IF (s_single(j:j).EQ.',') THEN 
         i_comma_pos(i_comma_cnt)=j
         i_comma_cnt=i_comma_cnt+1
        ENDIF
       ENDDO

c      Exit analysis if no commas found
       IF (i_comma_cnt.EQ.0) THEN 
        GOTO 10
       ENDIF

       i_qc_delchar=i_comma_pos(3)-i_comma_pos(2)

c      Condition for crashing program
       s_vec_tmax_qc(i)='1'         !initialize as fail
       IF (i_qc_delchar.EQ.0.OR.i_qc_delchar.GE.3) THEN
        print*,'emergency stop, bad ncepcode length'
        print*,'i_len=',i_len
        print*,'i_qc_delchar',i_qc_delchar
        print*,'s_single='//s_single//'='
        print*,'i_comma_pos=',(i_comma_pos(ii),ii=1,3)
        STOP 'qc_checker20210204'
       ENDIF
c      Condition getting ncepcode
       IF (i_qc_delchar.EQ.2) THEN
        s_vec_tmax_qc_ncepcode(i)=
     +    s_single(i_comma_pos(2)+1:i_comma_pos(2)+1)

c        print*,'test ncepcode='//s_vec_tmax_qc_ncepcode(i)//'='
c        STOP 'qc_checker20210204'
       ENDIF
c      If 2 commas together, then place good flag
       IF (i_qc_delchar.EQ.1) THEN
        s_vec_tmax_qc(i)='0'        !place good condition
        s_vec_tmax_qc_ncepcode(i)=''  !no code for good condition
       ENDIF

       ENDIF !close condition i_len.NE.0

 10    CONTINUE
      ENDDO
c*****
c************************************************************************
      RETURN
      END
