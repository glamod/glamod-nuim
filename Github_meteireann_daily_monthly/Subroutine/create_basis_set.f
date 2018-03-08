c     Subroutine to create basis metadata set
c     AJ_Kettle, Dec21/2017

      SUBROUTINE create_basis_set(l_nfile,l_nfile_use,s_filelist,
     +  l_meta,
     +  s_meta_namelist,s_meta_fileid,s_meta_alt_m,
     +  s_meta_lat,s_meta_lon,s_meta_wigos,
     +  s_basis_nameshort,s_basis_namelist,s_basis_fileid,
     +  s_basis_alt_m,s_basis_lat,s_basis_lon,s_basis_wigos)

      IMPLICIT NONE
c************************************************************************
c     Declare variables

      INTEGER             :: l_nfile
      INTEGER             :: l_nfile_use
      CHARACTER(LEN=300)  :: s_filelist(l_nfile)

      INTEGER             :: l_meta
      CHARACTER(LEN=30)   :: s_meta_namelist(l_nfile)
      CHARACTER(LEN=4)    :: s_meta_fileid(l_nfile)
      CHARACTER(LEN=4)    :: s_meta_alt_m(l_nfile)
      CHARACTER(LEN=7)    :: s_meta_lat(l_nfile)
      CHARACTER(LEN=7)    :: s_meta_lon(l_nfile)
      CHARACTER(LEN=17)   :: s_meta_wigos(l_nfile)

      CHARACTER(LEN=30)   :: s_basis_nameshort(l_nfile)
      CHARACTER(LEN=30)   :: s_basis_namelist(l_nfile)
      CHARACTER(LEN=4)    :: s_basis_fileid(l_nfile)
      CHARACTER(LEN=4)    :: s_basis_alt_m(l_nfile)
      CHARACTER(LEN=7)    :: s_basis_lat(l_nfile)
      CHARACTER(LEN=7)    :: s_basis_lon(l_nfile)
      CHARACTER(LEN=17)   :: s_basis_wigos(l_nfile)

      INTEGER             :: i,j,k,ii,jj,kk

      INTEGER             :: l_len_filelist(l_nfile)
      INTEGER             :: l_len_meta_namelist(l_nfile)
      CHARACTER(LEN=30)   :: s_filelist_root(l_nfile)
      CHARACTER(LEN=30)   :: s_meta_namelist_root(l_nfile)

      CHARACTER(LEN=30)   :: s_singlename

      INTEGER             :: i_good
c************************************************************************
      print*,'just inside create_basis_set'

      print*,'s_filelist=',(TRIM(s_filelist(i)),i=1,2)
      print*,'s_meta_namelist=',(TRIM(s_meta_namelist(i)),i=1,2)
      print*,'l_nfile_use=',l_nfile_use
      print*,'l_meta',l_meta

c     Find lengths of name strings
      DO i=1,l_meta
       l_len_meta_namelist(i)=LEN_TRIM(s_meta_namelist(i))
       s_singlename=TRIM(s_meta_namelist(i))
       s_meta_namelist_root(i)=s_singlename(3:l_len_meta_namelist(i))
      ENDDO

      DO i=1,l_nfile_use
       l_len_filelist(i)=LEN_TRIM(s_filelist(i))
       s_singlename=TRIM(s_filelist(i))
       s_filelist_root(i)=s_singlename(3:l_len_filelist(i))
      ENDDO

      print*,'l_len_meta_namelist=',(l_len_meta_namelist(i),i=1,5)
      print*,'l_len_filelist=',(l_len_filelist(i),i=1,5)

c      DO i=1,l_meta
cc       print*,'i=',i,TRIM(s_filelist(i)),TRIM(s_meta_namelist(i))
c       print*,'i=',i,TRIM(s_filelist_root(i)),
c     +   TRIM(s_meta_namelist_root(i))
c      ENDDO
c************************************************************************
c     Match lists to get metadata

      i_good=0

      DO i=1,l_nfile_use
       DO j=1,l_meta
        IF 
     + (TRIM(s_filelist_root(i)).EQ.TRIM(s_meta_namelist_root(j))) THEN
         s_basis_nameshort(i)=s_filelist_root(i)
         s_basis_namelist(i) =s_filelist(i)
         s_basis_fileid(i)   =s_meta_fileid(j)
         s_basis_alt_m(i)    =s_meta_alt_m(j)
         s_basis_lat(i)      =s_meta_lat(j)
         s_basis_lon(i)      =s_meta_lon(j)
         s_basis_wigos(i)    =s_meta_wigos(j)

         i_good=i_good+1
         
         GOTO 31
        ENDIF
       ENDDO

       print*,'emergency stop, no match',TRIM(s_filelist(i))
       CALL SLEEP(2)

31     CONTINUE

      ENDDO   

      print*,'i_good=',i_good
 
      print*,'s_basis_wigos=',(s_basis_wigos(i),i=1,2)
      print*,'s_basis_nameshort=',(TRIM(s_basis_nameshort(i)),i=1,2)
c************************************************************************
      print*,'just leaving create_basis_set'

      RETURN
      END