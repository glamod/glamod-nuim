c     Subroutine to match info for basis set
c     AJ_Kettle, Oct19/2017

      SUBROUTINE match_info_basis_set2(
     +  l_stnrecord,s_stke,s_stid,s_stdate,s_endate,
     +  s_hght,s_lat,s_lon,s_stnname,s_bundesland,
     +  l_file_basis_pre,s_stnnum_basis_pre,
     +  i_basisflag_co_pre,i_basisflag_un_pre,
     +  s_basis_files_co_pre,s_basis_files_un_pre,

     +  l_file_basis,s_stnnum_basis, 
     +  i_basisflag_co,i_basisflag_un,
     +  s_basis_files_co,s_basis_files_un,

     +  s_basis_stke,s_basis_stid,s_basis_stdate,s_basis_endate,
     +  s_basis_hght,s_basis_lat,s_basis_lon,
     +  s_basis_stnname,s_basis_bundesland)

      IMPLICIT NONE
c************************************************************************
      INTEGER             :: l_stnrecord
      CHARACTER(LEN=5)    :: s_stke(100),s_stid(100)
      CHARACTER(LEN=8)    :: s_stdate(100),s_endate(100)
      CHARACTER(LEN=9)    :: s_hght(100)
      CHARACTER(LEN=10)   :: s_lat(100),s_lon(100)
      CHARACTER(LEN=25)   :: s_stnname(100)
      CHARACTER(LEN=25)   :: s_bundesland(100)

      INTEGER             :: l_file_basis_pre
      CHARACTER(LEN=5)    :: s_stnnum_basis_pre(100)
      INTEGER             :: i_basisflag_un_pre(100)
      INTEGER             :: i_basisflag_co_pre(100)
      CHARACTER(LEN=300)  :: s_basis_files_co_pre(100)
      CHARACTER(LEN=300)  :: s_basis_files_un_pre(100)

c     new basis dataset
      INTEGER             :: l_file_basis
      CHARACTER(LEN=5)    :: s_stnnum_basis(100)
      INTEGER             :: i_basisflag_un(100)
      INTEGER             :: i_basisflag_co(100)
      CHARACTER(LEN=300)  :: s_basis_files_co(100)
      CHARACTER(LEN=300)  :: s_basis_files_un(100)

      CHARACTER(LEN=5)    :: s_basis_stke(100),s_basis_stid(100)
      CHARACTER(LEN=8)    :: s_basis_stdate(100),s_basis_endate(100)
      CHARACTER(LEN=9)    :: s_basis_hght(100)
      CHARACTER(LEN=10)   :: s_basis_lat(100),s_basis_lon(100)
      CHARACTER(LEN=25)   :: s_basis_stnname(100)
      CHARACTER(LEN=25)   :: s_basis_bundesland(100)

      INTEGER             :: i,j,k,ii,jj,kk
c************************************************************************
c     Station record list defines basis set
      l_file_basis=l_stnrecord
      DO j=1,l_stnrecord

       s_basis_stke(j)      =s_stke(j)
       s_basis_stid(j)      =s_stid(j)
       s_basis_stdate(j)    =s_stdate(j)
       s_basis_endate(j)    =s_endate(j)
       s_basis_hght(j)      =s_hght(j)
       s_basis_lat(j)       =s_lat(j)
       s_basis_lon(j)       =s_lon(j)
       s_basis_stnname(j)   =s_stnname(j)
       s_basis_bundesland(j)=s_bundesland(j)

       DO i=1,l_file_basis_pre
        IF (s_stnnum_basis_pre(i).EQ.s_stke(j)) THEN

         s_stnnum_basis(j)  =s_stnnum_basis_pre(i)
         i_basisflag_un(j)  =i_basisflag_un_pre(i)
         i_basisflag_co(j)  =i_basisflag_co_pre(i)
         s_basis_files_co(j)=s_basis_files_co_pre(i)
         s_basis_files_un(j)=s_basis_files_un_pre(i)

         GOTO 28
        ENDIF
       ENDDO

       print*,'emergency stop, match_info_basis_set2.f'
       CALL SLEEP(5)
c       print*,'bad file',s_stnnum_basis(i)

28     CONTINUE
      ENDDO

c      print*,'l_file_basis,l_stnrecord=',l_file_basis,l_stnrecord
c      print*,'s_stnnum_basis=',(s_stnnum_basis(i),i=1,l_file_basis)
c************************************************************************
      RETURN
      END
