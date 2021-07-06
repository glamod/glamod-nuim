c     Subroutine to extract fields from single line
c     AJ_Kettle, 06Nov2018

      SUBROUTINE field_extractor_quot(s_header,
     +  l_field_rgh,l_width_rgh,s_vec_header,
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

      INTEGER,PARAMETER   :: l_linewidth=5000
      CHARACTER(LEN=l_linewidth) :: s_onefield
      INTEGER             :: i_len
      INTEGER             :: i_comma
      INTEGER             :: i_comma_pos(l_field_rgh)
      CHARACTER(LEN=1)    :: s_single

      INTEGER             :: i_quot
      INTEGER             :: i_quot_pos(l_field_rgh)
      INTEGER             :: i_quot2

      INTEGER             :: i_st,i_en

      INTEGER             :: i_fieldwidth

      INTEGER             :: i,j,k,ii,jj,kk

      CHARACTER(LEN=l_linewidth) :: s_header_template
c************************************************************************
      i_len=LEN_TRIM(s_header)

      IF (i_len.GE.l_linewidth) THEN 
       STOP 'input line length too long, field_extractor_gen'
      ENDIF
c*****
cc     Find commas
c      i_comma=0
c      DO j=1,i_len
c       s_single=s_header(j:j)
c       IF (s_single.EQ.',') THEN
c        i_comma=i_comma+1
c        i_comma_pos(i_comma)=j

c        IF (i_comma.GT.l_field_rgh) THEN
c         print*,'i_comma,l_field_rgh=',i_comma,l_field_rgh
c         STOP 'i_comma too many, field_extractor_quot'
c        ENDIF

c       ENDIF
c      ENDDO

c      print*,'i_comma=',i_comma
c*****
c     Find quotation marks
      i_quot=0
      DO j=1,i_len
       s_single=s_header(j:j)
       IF (s_single.EQ.'"') THEN
        i_quot=i_quot+1
        i_quot_pos(i_quot)=j

        IF (i_quot.GT.l_field_rgh) THEN
         print*,'i_quot,l_field_rgh=',i_quot,l_field_rgh
         STOP 'i_quot too many, field_extractor_quot'
        ENDIF

       ENDIF
      ENDDO

c      print*,'i_quot=',i_quot
c      print*,'i_quot_pos=',(i_quot_pos(i),i=1,10)
c      print*,'s_header=',TRIM(s_header)
c*****
c     Create template
      i_quot2=i_quot/2.0
      s_header_template=''

c      print*,'i_quot2=',i_quot2

      DO i=1,i_len
       s_single=s_header(i:i) 

       DO j=1,i_quot2   !cycle through quot indicators
c        DO k=i_quot_pos(2*(i-1)+1:2*(i-1)+2)
c         IF ()
c        ENDDO 
        i_st=i_quot_pos(2*(j-1)+1)
        i_en=i_quot_pos(2*(j-1)+2)

c        print*,'i...',i,j,i_st,i_en

c        call sleep(1)

        IF (i.GE.i_st.AND.i.LE.i_en) THEN 
         s_single='B'

c        Jump loop as soon as black identified
         GOTO 100
        ENDIF
       ENDDO

 100   CONTINUE

c      Increment s_header_template
       s_header_template=TRIM(s_header_template)//TRIM(s_single)

c       print*,'s_header=',TRIM(s_header(1:i))
c       print*,'s_header_template=',TRIM(s_header_template(1:i))
c       print*,'s_single=',TRIM(s_single)

      ENDDO

c      print*,'s_header=',TRIM(s_header)
c      print*,'s_header_template=',TRIM(s_header_template)

c      print*,'length s_header=',LEN_TRIM(s_header)
c      print*,'length s_header_template=',LEN_TRIM(s_header_template)
c*****
c     Find commas
      i_comma=0
      DO j=1,i_len
        s_single=s_header_template(j:j)
        IF (s_single.EQ.',') THEN
         i_comma=i_comma+1
         i_comma_pos(i_comma)=j

         IF (i_comma.GT.l_field_rgh) THEN
          print*,'i_comma,l_field_rgh=',i_comma,l_field_rgh
          STOP 'i_comma too many, field_extractor_quot'
         ENDIF

        ENDIF
      ENDDO

c      print*,'i_comma=',i_comma
c*****
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
       s_onefield=s_header(i_comma_pos(j)+2:i_comma_pos(j+1)-2)
       s_vec_header(j+1)=s_onefield
      ENDDO
c     initial field
      s_onefield=s_header(2:i_comma_pos(1)-2)
      s_vec_header(1)=s_onefield
c     end field
      s_onefield=s_header(i_comma_pos(i_comma)+2:i_len-1)
      s_vec_header(i_comma+1)=s_onefield

      l_field=i_comma+1

c      DO i=1,l_field
c        print*,i,TRIM(s_vec_header(i))
c      ENDDO

c      print*,'s_header=',TRIM(s_header)
c      print*,'i_len,l_field=',i_len,l_field

      RETURN
      END
