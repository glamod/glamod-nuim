c     Subroutine to get elements from stnconfig line
c     AJ_Kettle, 19May2019
c     11Mar2020: used for USAF update IFF make

      SUBROUTINE get_elements_stnconfig_line(s_header,
     +  l_numfield,s_vec_fields)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into program

      CHARACTER(LEN=1000) :: s_header
      CHARACTER(LEN=*)   :: s_vec_fields(50)

c*****
c     Variables used within subroutine

      INTEGER             :: i,j,k,ii,jj,kk

      INTEGER             :: i_len
      INTEGER             :: i_pos(100)
      INTEGER             :: i_lenfield(100)
      INTEGER             :: l_numfield
      INTEGER             :: i_maxlen
c************************************************************************
c      print*,'just entered get_elements_stnconfig_line'

      i_len=LEN_TRIM(s_header)

c      print*,'i_len=',i_len

      ii=0

      DO i=1,i_len 
       IF (s_header(i:i).EQ.'|') THEN 
        ii=ii+1
        i_pos(ii)=i
       ENDIF
      ENDDO

      l_numfield=ii+1

c      print*,'ii=',ii
c      print*,'i_pos=',(i_pos(i),i=1,ii)
c*****
c     Find vector of field lengths
      DO i=1,l_numfield

c      Line first
       IF (i.EQ.1) THEN
        i_lenfield(i)=i_pos(1)

        s_vec_fields(i)=s_header(1:i_pos(1)-1)
       ENDIF

c      Line last
       IF (i.EQ.l_numfield) THEN
        i_lenfield(l_numfield)=i_len-i_pos(l_numfield-1)

        s_vec_fields(l_numfield)=s_header(i_pos(l_numfield-1)+1:i_len)
       ENDIF

c      Lines middle
       IF (i.GT.1.AND.i.LT.l_numfield) THEN
        i_lenfield(i)=i_pos(i)-i_pos(i-1)

        s_vec_fields(i)=s_header(i_pos(i-1)+1:i_pos(i)-1)
       ENDIF
      ENDDO

c      print*,'s_vec_fields',(TRIM(s_vec_fields(i)),i=1,l_numfield)

c     Find maximum field length
      i_maxlen=0
      DO i=1,l_numfield
       i_maxlen=MAX(i_maxlen,i_lenfield(i))
      ENDDO

c      print*,'i_maxlen=',i_maxlen
c      print*,'i_lenfield=',(i_lenfield(i),i=1,i_maxlen)

      IF (i_maxlen.GT.100) THEN
       print*,'l_numfield=',l_numfield
       print*,'i_lenfield=',(i_lenfield(i),i=1,l_numfield)
       print*,'emergency stop, field >100'
       STOP 'get_elements_stnconfig_line'
      ENDIF
c*****
c      print*,'just leaving get_elements_stnconfig_line'

c      STOP 'get_elements_stnconfig_line'

c      CALL SLEEP(1)

      RETURN
      END
