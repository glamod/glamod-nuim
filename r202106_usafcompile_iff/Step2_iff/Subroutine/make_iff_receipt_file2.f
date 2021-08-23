c     Subroutine to make iff receipt file
c     AJ_Kettle, 30Aug2019
c     17Mar2020: used for USAF update

      SUBROUTINE make_iff_receipt_file2(s_date_st,s_time_st,
     +  i_0good_1bad_2zero,
     +  s_directory_outfile_iff_netplatdistinct,
     +  s_networktype,s_platformid,
     +  s_metasingle_platformid,s_metasingle_networktype,
     +  s_metasingle_name,s_metasingle_cdmlandcode,
     +  s_metasingle_lat,s_metasingle_lon,s_metasingle_elev,
     +  l_rgh_datalines,l_data,
     +  i_triplediff_cnt,i_triplediff_numobs,
     +  f_triplediff_lat,f_triplediff_lon,f_triplediff_plathght,
     +  i_triplet_datacnt_good_wdir,i_triplet_datacnt_good_wspd,
     +  i_triplet_datacnt_good_airt,i_triplet_datacnt_good_dewp,
     +  i_triplet_datacnt_good_slp,i_triplet_datacnt_good_stnp,
     +  s_year_st_g6,s_year_en_g6,
     +  s_assemble_varcode)

      IMPLICIT NONE
c************************************************************************
c     Declare variables 

      CHARACTER(LEN=8)    :: s_date_st
      CHARACTER(LEN=10)   :: s_time_st

      INTEGER             :: i_0good_1bad_2zero

      CHARACTER(LEN=300)  :: s_directory_outfile_iff_netplatdistinct

      CHARACTER(LEN=30)   :: s_networktype
      CHARACTER(LEN=30)   :: s_platformid

      CHARACTER(LEN=30)   :: s_metasingle_platformid
      CHARACTER(LEN=30)   :: s_metasingle_networktype
      CHARACTER(LEN=100)  :: s_metasingle_name
      CHARACTER(LEN=15)   :: s_metasingle_cdmlandcode
      CHARACTER(LEN=15)   :: s_metasingle_lat
      CHARACTER(LEN=15)   :: s_metasingle_lon
      CHARACTER(LEN=15)   :: s_metasingle_elev

      INTEGER             :: l_rgh_datalines
      INTEGER             :: l_data

      INTEGER             :: i_triplediff_cnt
      INTEGER             :: i_triplediff_numobs(l_rgh_datalines)
      REAL                :: f_triplediff_lat(l_rgh_datalines)
      REAL                :: f_triplediff_lon(l_rgh_datalines)
      REAL                :: f_triplediff_plathght(l_rgh_datalines)

      INTEGER             ::i_triplet_datacnt_good_wdir(l_rgh_datalines)
      INTEGER             ::i_triplet_datacnt_good_wspd(l_rgh_datalines)
      INTEGER             ::i_triplet_datacnt_good_airt(l_rgh_datalines)
      INTEGER             ::i_triplet_datacnt_good_dewp(l_rgh_datalines)
      INTEGER             ::i_triplet_datacnt_good_slp(l_rgh_datalines)
      INTEGER             ::i_triplet_datacnt_good_stnp(l_rgh_datalines)

      CHARACTER(LEN=4)    :: s_year_st_g6(l_rgh_datalines)
      CHARACTER(LEN=4)    :: s_year_en_g6(l_rgh_datalines)
      CHARACTER(LEN=30)   :: s_assemble_varcode(l_rgh_datalines)  
c*****
c     Variables used inside program

      INTEGER             :: i,j,k,ii,jj,kk

      CHARACTER(LEN=300)  :: s_pathandname
c************************************************************************
c      print*,'just entered make_iff_receipt_file'

c      print*,'Latitude:      ',TRIM(s_metasingle_lat)
c      print*,'Longitude:     ',TRIM(s_metasingle_lon)
c      print*,'Elevation:     ',TRIM(s_metasingle_elev)
c      STOP 'make_iff_receipt_file'

      IF (i_0good_1bad_2zero.EQ.0) THEN 
       s_pathandname=TRIM(s_directory_outfile_iff_netplatdistinct)//
     +  'Accept/'//
     +  TRIM(s_networktype)//'_'//TRIM(s_platformid)//'.dat'
      ENDIF
      IF (i_0good_1bad_2zero.EQ.1) THEN 
       s_pathandname=TRIM(s_directory_outfile_iff_netplatdistinct)//
     +  'Reject/'//
     +  TRIM(s_networktype)//'_'//TRIM(s_platformid)//'.dat'
      ENDIF
      IF (i_0good_1bad_2zero.EQ.2) THEN 
       s_pathandname=TRIM(s_directory_outfile_iff_netplatdistinct)//
     +  'Latlon0/'//
     +  TRIM(s_networktype)//'_'//TRIM(s_platformid)//'.dat'
      ENDIF

c      print*,'s_pathandname=',TRIM(s_pathandname)
c*****
c     Open header file for output
      OPEN(UNIT=2,
     +   FILE=TRIM(s_pathandname),
     +   FORM='formatted',
     +   STATUS='REPLACE',ACTION='WRITE')

      WRITE(2,FMT=1002) 'Station summary station configuration   '
      WRITE(2,FMT=1002) '                                        '
 1002 FORMAT(a40)

      WRITE(2,FMT=1003) 'AJ_Kettle',s_date_st,s_time_st
 1003 FORMAT(t1,a9,t11,a8,t20,a10)

      WRITE(2,FMT=1002) '                                        '

      WRITE(2,1000) 'Network_type:  ',TRIM(s_networktype)
      WRITE(2,1000) 'Platform_id:   ',TRIM(s_platformid)
 1000 FORMAT(t1,a15,t17,a10)
 1001 FORMAT(t1,a15,t17,a50)

      WRITE(2,FMT=1002) '                                        '

      WRITE(2,FMT=1002) 'Metadata identifiers                    '
      WRITE(2,1000) 'Network_type:  ',TRIM(s_metasingle_networktype)
      WRITE(2,1000) 'Platform_id:   ',TRIM(s_metasingle_platformid)
      WRITE(2,1000) 'Country code:  ',TRIM(s_metasingle_cdmlandcode)
      WRITE(2,1001) 'Name:          ',TRIM(s_metasingle_name)
      WRITE(2,1000) 'Latitude:      ',TRIM(s_metasingle_lat)
      WRITE(2,1000) 'Longitude:     ',TRIM(s_metasingle_lon)
      WRITE(2,1000) 'Elevation:     ',TRIM(s_metasingle_elev)

      WRITE(2,FMT=1002) '                                        '

      WRITE(2,1004) 'Number lines:  ',l_data
      WRITE(2,1004) 'Number triplet:',i_triplediff_cnt
 1004 FORMAT(t1,a15,t17,i7)

      WRITE(2,1002) '               '

      WRITE(2,1006) 'NN',
     +  'Latitude ','Longitude','Height   ',
     +  'wdir   ','wspd   ','airt   ','dewp   ','slp    ','stnp   ',
     +  'Strt','End ','Variables           '
      WRITE(2,1006) '++','+-------+','+-------+','+-------+',
     +  '+-----+','+-----+','+-----+','+-----+','+-----+','+-----+',
     +  '+--+','+--+','+-----------------------+'
 1006 FORMAT(t1,a2,t4,a9,t14,a9,t24,a9,t34,
     +  a7,t42,a7,t50,a7,t58,a7,t66,a7,t74,a7,t82,
     +  a4,t87,a4,t92,a25)

      DO i=1,i_triplediff_cnt
       WRITE(2,1008) i,
     + f_triplediff_lat(i),f_triplediff_lon(i),f_triplediff_plathght(i),
     + i_triplet_datacnt_good_wdir(i),i_triplet_datacnt_good_wspd(i),
     + i_triplet_datacnt_good_airt(i),i_triplet_datacnt_good_dewp(i),
     + i_triplet_datacnt_good_slp(i), i_triplet_datacnt_good_stnp(i),
     + s_year_st_g6(i),
     + s_year_en_g6(i),
     + s_assemble_varcode(i) 

 1008  FORMAT(t1,i2,t4,f9.4,t14,f9.4,t24,f9.4,t34,
     +  i7,t42,i7,t50,i7,t58,i7,t66,i7,t74,i7,t82,
     +  a4,t87,a4,t92,a25)
      ENDDO

      CLOSE(UNIT=2)

c      print*,'just leaving make_iff_receipt_file'

      RETURN
      END
