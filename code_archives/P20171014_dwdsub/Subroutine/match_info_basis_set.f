c     Subroutine to match info for basis set
c     AJ_Kettle, Oct19/2017

      SUBROUTINE match_info_basis_set(
     +  l_stnrecord,s_stke,s_stid,s_stdate,s_endate,
     +  s_hght,s_lat,s_lon,s_stnname,s_bundesland,
     +  l_file_basis,s_stnnum_basis,
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

      INTEGER             :: l_file_basis
      CHARACTER(LEN=5)    :: s_stnnum_basis(100)
      CHARACTER(LEN=5)    :: s_basis_stke(100),s_basis_stid(100)
      CHARACTER(LEN=8)    :: s_basis_stdate(100),s_basis_endate(100)
      CHARACTER(LEN=9)    :: s_basis_hght(100)
      CHARACTER(LEN=10)   :: s_basis_lat(100),s_basis_lon(100)
      CHARACTER(LEN=25)   :: s_basis_stnname(100)
      CHARACTER(LEN=25)   :: s_basis_bundesland(100)

      INTEGER             :: i,j,k,ii,jj,kk
c************************************************************************
      DO i=1,l_file_basis
       DO j=1,l_stnrecord
        IF (s_stnnum_basis(i).EQ.s_stke(j)) THEN
         s_basis_stke(i)      =s_stke(j)
         s_basis_stid(i)      =s_stid(j)
         s_basis_stdate(i)    =s_stdate(j)
         s_basis_endate(i)    =s_endate(j)
         s_basis_hght(i)      =s_hght(j)
         s_basis_lat(i)       =s_lat(j)
         s_basis_lon(i)       =s_lon(j)
         s_basis_stnname(i)   =s_stnname(j)
         s_basis_bundesland(i)=s_bundesland(j)
         GOTO 28
        ENDIF
       ENDDO

       print*,'bad file',s_stnnum_basis(i)

28     CONTINUE
      ENDDO

      RETURN
      END
