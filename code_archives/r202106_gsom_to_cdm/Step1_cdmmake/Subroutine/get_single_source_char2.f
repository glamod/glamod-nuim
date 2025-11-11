c     Subroutine to get letter for all months in single station
c     Special subroutine for attribute info from tavg & awnd
c     AJ_Kettle, 30Sep2019

      SUBROUTINE get_single_source_char2(s_var,l_rgh_lines,l_lines,
     +   s_vec_tavg_attrib,s_vec_tavg_sourcelett)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into subroutine

      CHARACTER(LEN=4)    :: s_var
      INTEGER             :: l_rgh_lines
      INTEGER             :: l_lines

      CHARACTER(LEN=10)   :: s_vec_tavg_attrib(l_rgh_lines)
      CHARACTER(LEN=1)    :: s_vec_tavg_sourcelett(l_rgh_lines)
c******
c     Variables used in subroutine

      INTEGER              :: i,j,k,ii,jj,kk

      CHARACTER(LEN=10)   :: s_single
      INTEGER             :: i_len
      INTEGER             :: i_comma_cnt
      INTEGER             :: i_comma_pos(5)
      INTEGER             :: i_qc_delsource
c************************************************************************
c      print*,'just entered get_single_source_char2'

c     Cycle through lines
      DO i=1,l_lines

c      Initialize output
       s_vec_tavg_sourcelett(i)=''

       s_single=TRIM(s_vec_tavg_attrib(i))

       i_len=LEN_TRIM(s_vec_tavg_attrib(i))

c      Cycle through line to find locations of commas
       i_comma_cnt=0
       DO j=1,i_len
        IF (s_single(j:j).EQ.',') THEN 
         i_comma_cnt=i_comma_cnt+1
         i_comma_pos(i_comma_cnt)=j
        ENDIF
       ENDDO

c      Exit analysis if no comma
       IF (i_comma_cnt.EQ.0) THEN 
        GOTO 10
       ENDIF

       IF (i_comma_cnt.LT.1) THEN
        print*,'emergency stop, commas=',i_comma_cnt
        print*,'s_var=',s_var
        print*,'i,l_lines',i,l_lines
        print*,'i_len=',i_len
        print*,'s_single=',s_single
        print*,'s_vec_tavg_attrib=',(s_vec_tavg_attrib(j),j=1,l_lines)

        STOP 'get_single_source_char2'
       ENDIF

c      Source letter should be after single comma
       s_vec_tavg_sourcelett(i)=
     +   s_single(i_comma_pos(1)+1:i_len)
c       s_vec_tavg_sourcelett(i)=
c     +   s_single(i_comma_pos(1)+1:i_comma_pos(1)+1)

c       print*,'i...',i,(i_comma_pos(j),j=1,3)

c       i_qc_delsource=i_comma_pos(3)-i_comma_pos(2)

c       s_vec_tavg_sourcelett(i)=''         !initialize as blank
cc      If 2 commas together, then place good flag
c       IF (i_qc_delchar.EQ.1) THEN
c        s_vec_tavg_sourcelett(i)='0'        !place good condition
c       ENDIF

 10    CONTINUE
      ENDDO

c      print*,'l_lines=',l_lines
c      print*,'attrib=',(s_vec_tavg_attrib(i),i=1,l_lines)
c      print*,'source_lett=',(s_vec_tavg_sourcelett(i),i=1,l_lines)

c      print*,'just leaving get_single_source_char2'
c      STOP 'get_single_source_char2'

      RETURN
      END
