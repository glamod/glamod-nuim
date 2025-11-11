c     Subroutine to get station metadata for single station
c     AJ_Kettle, 20Mar2019
c     16Mar2020: used for USAF update

      SUBROUTINE get_metadata_singlestn(s_networktype,s_platformid,
     +  l_rgh_metadata,l_metadata,
     +  s_metadata_platformid,s_metadata_networktype,
     +  s_metadata_name,s_metadata_st,s_metadata_co,
     +  s_metadata_lat,s_metadata_lon,s_metadata_elev,
     +  s_metadata_eq_cdmlandcode,

     +  s_metasingle_platformid,s_metasingle_networktype,
     +  s_metasingle_name,s_metasingle_st,s_metasingle_co,
     +  s_metasingle_lat,s_metasingle_lon,s_metasingle_elev,
     +  s_metasingle_cdmlandcode)

c************************************************************************
c     Declare variables 

      CHARACTER(LEN=30)   :: s_networktype
      CHARACTER(LEN=30)   :: s_platformid

      INTEGER             :: l_rgh_metadata
      INTEGER             :: l_metadata

      CHARACTER(LEN=30)   :: s_metadata_platformid(l_rgh_metadata)
      CHARACTER(LEN=30)   :: s_metadata_networktype(l_rgh_metadata)
      CHARACTER(LEN=100)  :: s_metadata_name(l_rgh_metadata)
      CHARACTER(LEN=15)   :: s_metadata_st(l_rgh_metadata)
      CHARACTER(LEN=15)   :: s_metadata_co(l_rgh_metadata)
      CHARACTER(LEN=15)   :: s_metadata_lat(l_rgh_metadata)
      CHARACTER(LEN=15)   :: s_metadata_lon(l_rgh_metadata)
      CHARACTER(LEN=15)   :: s_metadata_elev(l_rgh_metadata)

      CHARACTER(LEN=15)   :: s_metadata_eq_cdmlandcode(l_rgh_metadata)

      CHARACTER(LEN=30)   :: s_metasingle_platformid
      CHARACTER(LEN=30)   :: s_metasingle_networktype
      CHARACTER(LEN=100)  :: s_metasingle_name
      CHARACTER(LEN=15)   :: s_metasingle_st
      CHARACTER(LEN=15)   :: s_metasingle_co
      CHARACTER(LEN=15)   :: s_metasingle_lat
      CHARACTER(LEN=15)   :: s_metasingle_lon
      CHARACTER(LEN=15)   :: s_metasingle_elev

      CHARACTER(LEN=15)   :: s_metasingle_cdmlandcode
c*****
c     Variables used in subroutine

      INTEGER             :: i,j,k,ii,jj,kk
c************************************************************************
c      print*,'just entered get_metadata_singlestn'

      DO i=1,l_metadata 
       IF (TRIM(s_networktype).EQ.TRIM(s_metadata_networktype(i)).AND.
     +     TRIM(s_platformid) .EQ.TRIM(s_metadata_platformid(i))) THEN
c        print*,'station found,i',i

        s_metasingle_platformid =s_metadata_platformid(i)
        s_metasingle_networktype=s_metadata_networktype(i)
        s_metasingle_name       =s_metadata_name(i)
        s_metasingle_st         =s_metadata_st(i)
        s_metasingle_co         =s_metadata_co(i)
        s_metasingle_lat        =s_metadata_lat(i)
        s_metasingle_lon        =s_metadata_lon(i)
        s_metasingle_elev       =s_metadata_elev(i)

        s_metasingle_cdmlandcode=s_metadata_eq_cdmlandcode(i)

        GOTO 10

c        print*,'s_metasingle_platformid=', s_metasingle_platformid
c        print*,'s_metasingle_networktype=',s_metasingle_networktype
c        print*,'s_metasingle_name=',s_metasingle_name
c        print*,'s_metasingle_st=',s_metasingle_st
c        print*,'s_metasingle_co=',s_metasingle_co
c        print*,'s_metasingle_lat=',s_metasingle_lat
c        print*,'s_metasingle_lon=',s_metasingle_lon
c        print*,'s_metasingle_elev=',s_metasingle_elev
c        print*,'s_metasingle_s_metasingle_cdmlandcode=',
c          s_metasingle_s_metasingle_cdmlandcode

c        STOP 'get_metadata_singlestn'

       ENDIF
      ENDDO

c      print*,'meta data search failed'
c      print*,'l_metadata=',l_metadata
c      print*,'s_networktype=',TRIM(s_networktype)
c      print*,'s_platformid=', TRIM(s_platformid)

c      STOP 'get_metadata_singlestn'

 10   CONTINUE

c      print*,'s_metasingle_platformid=', s_metasingle_platformid
c      print*,'s_metasingle_networktype=',s_metasingle_networktype
c      print*,'s_metasingle_name=',s_metasingle_name
c      print*,'s_metasingle_st=',s_metasingle_st
c      print*,'s_metasingle_co=',s_metasingle_co
c      print*,'s_metasingle_lat=',s_metasingle_lat
c      print*,'s_metasingle_lon=',s_metasingle_lon
c      print*,'s_metasingle_elev=',s_metasingle_elev
c      print*,'s_metasingle_cdmlandcode=',s_metasingle_cdmlandcode

c      print*,'just leaving get_metadata_singlestn'
c      STOP 'get_metadata_singlestn'

      RETURN
      END
