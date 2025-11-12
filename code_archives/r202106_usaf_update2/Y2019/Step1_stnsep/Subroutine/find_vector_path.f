c     Subroutine to find path for tar files
c     AJ_Kettle, 15Jan2020

      SUBROUTINE find_vector_path(l_rgh,l_lines,l_tar,
     +  s_linsto,i_vec_tarflag,
     +  s_linepath)

      IMPLICIT NONE
c************************************************************************
c     Declare variables passed into program

      INTEGER             :: l_rgh
      INTEGER             :: l_lines
      INTEGER             :: l_tar

      CHARACTER(LEN=300)  :: s_linsto(l_rgh)
      INTEGER             :: i_vec_tarflag(l_rgh)
 
      CHARACTER(LEN=300)  :: s_linepath(l_rgh)
c*****
c     Variables used inside subroutine

      INTEGER             :: i,j,k,ii,jj,kk
c************************************************************************
c      print*,'just inside find_vector_path'

      DO i=1,l_lines
       IF (i_vec_tarflag(i).EQ.1) THEN 

c       Search backwards for first case no_tar flag
        DO j=i,1,-1 
         IF (i_vec_tarflag(j).NE.1) THEN
          s_linepath(i)=TRIM(s_linsto(j))

c          print*,'s_linepath=',TRIM(s_linepath(i))

c         Exit loop
          GOTO 10
         ENDIF 
        ENDDO

       ENDIF

 10    CONTINUE

      ENDDO

c      print*,'just leaving find_vector_path'

      RETURN
      END
