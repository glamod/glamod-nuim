c     Subroutine to get the CDM country code from the USAF FIPS code
c     AJ_Kettle, 23Aug2019
c     21Mar2020: used for USAF update

      SUBROUTINE get_cdmcountry_usaffips(s_directory_countrycode,
     +  s_fipscode_file,s_countrycode_file, 
     +  l_rgh_metadata,l_metadata,s_metadata_co, 
     +  s_metadata_eq_cdmlandcode)

      IMPLICIT NONE
c************************************************************************
c     Declare variables 

      CHARACTER(LEN=*)    :: s_directory_countrycode  !300

      CHARACTER(LEN=*)    :: s_fipscode_file          !300
      CHARACTER(LEN=*)    :: s_countrycode_file       !300

      INTEGER             :: l_rgh_metadata
      INTEGER             :: l_metadata
      CHARACTER(LEN=*)    :: s_metadata_co(l_rgh_metadata)             !15
      CHARACTER(LEN=*)    :: s_metadata_eq_cdmlandcode(l_rgh_metadata) !15
c*****
c     Variables used within subroutine

      INTEGER             :: i,j,k,ii,jj,kk

      INTEGER,PARAMETER   :: l_rgh_fips=300
      INTEGER             :: l_fips
      CHARACTER(LEN=2)    :: s_convertfips_2lett(l_rgh_fips)
      CHARACTER(LEN=3)    :: s_convertfips_3lett(l_rgh_fips)

      INTEGER,PARAMETER   :: l_rgh_subregion=300
      INTEGER             :: l_subregion
      CHARACTER(LEN=3)    :: s_subregion_indexnumber(l_rgh_subregion)
      CHARACTER(LEN=2)    :: s_subregion_countrycode2(l_rgh_subregion)
      CHARACTER(LEN=3)    :: s_subregion_countrycode3(l_rgh_subregion)
      CHARACTER(LEN=80)   :: s_subregion_countryname(l_rgh_subregion)

      CHARACTER(LEN=15)   :: s_metadata_fips3lett(l_rgh_metadata)
c************************************************************************
      print*,'just inside get_cdmcountry_usaffips'

c     Import conversion from 2letter USAF/FIPS to 3-letter code
      CALL readin_fips_3lett_conversion2(l_rgh_fips,
     +  s_directory_countrycode,s_fipscode_file,
     +  l_fips,s_convertfips_2lett,s_convertfips_3lett)

c     Import country code conversion table - Dave Berry CDM table
      CALL readin_countrycode2(l_rgh_subregion,
     +  s_directory_countrycode,s_countrycode_file,
     +  l_subregion,s_subregion_indexnumber,
     +  s_subregion_countrycode2,s_subregion_countrycode3,
     +  s_subregion_countryname)

c     Initialize variable
      DO i=1,l_rgh_metadata
       s_metadata_eq_cdmlandcode(i)=''
      ENDDO

c     Find match 1
      ii=0
      DO i=1,l_metadata  !cycle through metadata
       DO j=1,l_fips     !cycle through FIPS codes
        IF (TRIM(s_metadata_co(i)).EQ.TRIM(s_convertfips_2lett(j))) THEN 
         s_metadata_fips3lett(i)=TRIM(s_convertfips_3lett(j))
         ii=ii+1
        ENDIF
       ENDDO
      ENDDO
      print*,'convert1; l_metadata,ii=',l_metadata,ii

c     Find match 2 - from 3lett FIPS to CDM code
      ii=0
      DO i=1,l_metadata  !cycle through metadata
       DO j=1,l_subregion
        IF (TRIM(s_metadata_fips3lett(i)).EQ.
     +      TRIM(s_subregion_countrycode3(j))) THEN 
         s_metadata_eq_cdmlandcode(i)=TRIM(s_subregion_indexnumber(j))
         ii=ii+1
        ENDIF
       ENDDO
      ENDDO
      print*,'convert2; l_metadata,ii=',l_metadata,ii 

      print*,'just leaving get_cdcountry_usaffips'

      RETURN
      END
