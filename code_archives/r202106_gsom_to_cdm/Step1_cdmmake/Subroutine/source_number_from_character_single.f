c     Subroutine to get source letter for single variable
c     AJ_Kettle, 30Sep2019

      SUBROUTINE source_number_from_character_single(i_flag,s_varname,
     +  l_rgh_lines,l_lines,s_vec_tmax_sourcelett,
     +  s_vec_tmax_attrib,s_vec_tmax_c,
     +  l_source_rgh,l_source,s_source_codeletter,s_source_codenumber,

     +  s_vec_tmax_sourcenum)

      IMPLICIT NONE
c************************************************************************
c     variable for GSOM/GHCND conversion

      INTEGER             :: i_flag

      CHARACTER(LEN=4)    :: s_varname

c     Get GHCND source letter
      INTEGER             :: l_rgh_lines
      INTEGER             :: l_lines
      CHARACTER(LEN=1)    :: s_vec_tmax_sourcelett(l_rgh_lines)

      CHARACTER(LEN=10)   :: s_vec_tmax_attrib(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_tmax_c(l_rgh_lines)

      INTEGER             :: l_source_rgh
      INTEGER             :: l_source
      CHARACTER(LEN=1)    :: s_source_codeletter(l_source_rgh)
      CHARACTER(LEN=3)    :: s_source_codenumber(l_source_rgh)

      CHARACTER(LEN=3)    :: s_vec_tmax_sourcenum(l_rgh_lines)
c*****
c     Variables used within subroutine

      INTEGER             :: i,j,k,ii,jj,kk
c************************************************************************
      DO i=1,l_lines

c      Initialize variable to blank
       s_vec_tmax_sourcenum(i)=''

       IF (LEN_TRIM(s_vec_tmax_sourcelett(i)).GT.0) THEN
        DO j=1,l_source
         IF (TRIM(s_vec_tmax_sourcelett(i)).EQ.
     +       TRIM(s_source_codeletter(j))) THEN
          s_vec_tmax_sourcenum(i)=s_source_codenumber(j)

          GOTO 10

         ENDIF
        ENDDO

c       set flag to exit processing
        i_flag=1

        print*,'emergency stop; sourcelett not found'
        print*,'s_varname=',s_varname
        print*,'s_vec_..._sourcelett(i)',
     +    '='//s_vec_tmax_sourcelett(i)//'='
        print*,'length of sourcelett string',
     +    LEN_TRIM(s_vec_tmax_sourcelett(i))
        print*,'attribute=',TRIM(s_vec_tmax_attrib(i))
        print*,'variable value=',s_vec_tmax_c(i)
        print*,'data line of station file i=',i
        print*,'total data lines in station file i=',l_lines
        print*,'vec, inex=-2,-1,0,1,2',
     +    ('='//s_vec_tmax_sourcelett(ii)//'=',ii=i-2,i+2)
        print*,'s_source_codeletter, NCEI number-letter codea=',
     +     ('='//s_source_codeletter(j)//'=',j=1,l_source)
c        STOP 'source_number_from_character_single'
        GOTO 20

 10     CONTINUE
       ENDIF
      ENDDO

 20   CONTINUE    !exit point for bad source letter

      RETURN
      END
