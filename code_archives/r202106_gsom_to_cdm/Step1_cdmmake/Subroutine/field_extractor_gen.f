c     Subroutine to extract fields from single line
c     AJ_Kettle, 06Nov2018

      SUBROUTINE field_extractor_gen(s_header,l_field_rgh,l_width_rgh,
     +  s_vec_header,
     +  l_field) 

      IMPLICIT NONE
c************************************************************************
c     Variables passed into subroutine

      INTEGER             :: l_field_rgh
      INTEGER             :: l_width_rgh
      CHARACTER(LEN=*)    :: s_header
      CHARACTER(LEN=l_width_rgh) :: s_vec_header(l_field_rgh)
      INTEGER             :: l_field
c***********************************************************************
c     Variables used within program

c      INTEGER,PARAMETER   :: l_linewidth=2000
c      CHARACTER(LEN=l_linewidth) :: s_onefield    !to contain char of 1 column
      CHARACTER(LEN=l_width_rgh) :: s_onefield
      INTEGER             :: i_len
      INTEGER             :: i_comma
      INTEGER             :: i_comma_pos(l_field_rgh)
      CHARACTER(LEN=1)    :: s_single

      INTEGER             :: i_fieldwidth

      INTEGER             :: i,j,k,ii,jj,kk
c************************************************************************
c      print*,'just inside field_extractor_gen'
c      print*,'s_header=',TRIM(s_header)

      i_len=LEN_TRIM(s_header)

c      print*,'i_len=',i_len

c      IF (i_len.GE.l_linewidth) THEN 
c       STOP 'field_extractor_gen; input line length too long'
c      ENDIF

c     Find commas
      i_comma=0
      DO j=1,i_len   !cycle through all characters in header line
       s_single=s_header(j:j)
       IF (s_single.EQ.',') THEN
        i_comma=i_comma+1
        i_comma_pos(i_comma)=j

        IF (i_comma.GT.l_field_rgh) THEN
         print*,'i_comma,l_field_rgh=',i_comma,l_field_rgh
         STOP 'i_comma too many, field_extractor_gen'
        ENDIF

       ENDIF
      ENDDO

c     Test field length
      DO j=1,i_comma-1
       i_fieldwidth=i_comma_pos(j+1)-i_comma_pos(j)

       IF (i_fieldwidth.GT.l_width_rgh) THEN
        print*,'i_fieldwidth,l_width_rgh=',i_fieldwidth,l_width_rgh
        STOP 'fieldwidth too great, i_field_extractor_gen'
       ENDIF
      ENDDO

c     Extract fields
      DO j=1,i_comma-1
       s_onefield=s_header(i_comma_pos(j)+1:i_comma_pos(j+1)-1)
       s_vec_header(j+1)=s_onefield
      ENDDO
c     initial field
      s_onefield=s_header(1:i_comma_pos(1)-1)
      s_vec_header(1)=s_onefield
c     end field
      s_onefield=s_header(i_comma_pos(i_comma)+1:i_len)
      s_vec_header(i_comma+1)=s_onefield

      l_field=i_comma+1

c      DO i=1,l_field
c       print*,i,TRIM(s_vec_header(i))
c      ENDDO

c      print*,'s_header=',TRIM(s_header)
c      print*,'i_len,l_field=',i_len,l_field

c      print*,'just leaving field_extractor_gen'

      RETURN
      END
