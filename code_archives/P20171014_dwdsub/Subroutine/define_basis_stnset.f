c     Subroutine to get list of unique stations
c     AJ_Kettle, Oct19/2017

      SUBROUTINE define_basis_stnset(
     +  l_file_co,s_files_co,s_stnnum_co,
     +  l_file_un,s_files_un,s_stnnum_un,
     +  s_stnnum_basis,i_basisflag_co,i_basisflag_un,
     +  l_file_basis,s_basis_files_co,s_basis_files_un)

      IMPLICIT NONE
c************************************************************************
      INTEGER             :: l_file_co
      CHARACTER(LEN=300)  :: s_files_co(100)
      CHARACTER(LEN=5)    :: s_stnnum_co(100)

      INTEGER             :: l_file_un
      CHARACTER(LEN=300)  :: s_files_un(100)
      CHARACTER(LEN=5)    :: s_stnnum_un(100)

      CHARACTER(LEN=5)    :: s_stnnum_basis(100)
      INTEGER             :: i_basisflag_un(100),i_basisflag_co(100)
      INTEGER             :: l_file_basis
      CHARACTER(LEN=300)  :: s_basis_files_co(100)
      CHARACTER(LEN=300)  :: s_basis_files_un(100)
 
      INTEGER             :: i,j,k,ii,jj,kk
c************************************************************************
      print*,'define_basis_stnset'

c     Initialize flag vectors
      DO i=1,100
       i_basisflag_un(i)  =0
       i_basisflag_co(i)  =0
       s_basis_files_co(i)='x'
       s_basis_files_un(i)='x'
      ENDDO

c     Define basis stations from uncompressed series
      DO i=1,l_file_un      
       s_stnnum_basis(i)   =s_stnnum_un(i)
       s_basis_files_un(i) =s_files_un(i)
       i_basisflag_un(i)   =1 
      ENDDO
      l_file_basis=l_file_un

c     Compare compressed stnnum with basis dataset
      ii=0                     !counter for odd situations
      DO j=1,l_file_co 
       DO i=1,l_file_basis 
        IF (s_stnnum_co(j).EQ.s_stnnum_basis(i)) THEN 
         s_basis_files_co(i)=s_files_co(j)
         i_basisflag_co(i)  =1
         GOTO 25
        ENDIF
       ENDDO

c      If here then new element for basis set
       l_file_basis=l_file_basis+1
       s_stnnum_basis(l_file_basis)  =s_stnnum_co(j)
       s_basis_files_co(l_file_basis)=s_files_co(j)
       i_basisflag_co(l_file_basis)  =1 
       ii=ii+1
 
25     CONTINUE
      ENDDO

c     Output list distinct stations
c      DO i=1,l_file_basis
c       print*,'i',i,s_stnnum_basis(i), 
c     +   i_basisflag_co(i),i_basisflag_un(i), 
c     +   TRIM(s_basis_files_co(i)),TRIM(s_basis_files_un(i))
c      ENDDO
c      CALL SLEEP(4)

c      print*,'ii odd=',ii
c      print*,'l_file_basis=',l_file_basis

      print*,'just leaving define_basis_stnset.f'

      RETURN
      END
