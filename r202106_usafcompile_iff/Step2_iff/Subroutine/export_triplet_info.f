c     Subroutine to export triplet information
c     AJ_Kettle, 05Jul2019
c     06Aug2019: modified index of i_triple_datacnt_good from 20 to l_rgh_datalines
c     19Mar2019: used for USAF update

      SUBROUTINE export_triplet_info(i_0good_1bad_2zero,
     +   l_rgh_datalines,l_data,
     +   s_directory_outfile_iff_netplatdistinct,
     +   s_networktype,s_platformid, 
     +   i_triplediff_cnt,i_triplediff_numobs,
     +   f_triplediff_lat,f_triplediff_lon,f_triplediff_plathght,
     +   i_triple_datacnt_good_wdir,i_triple_datacnt_good_wspd,
     +   i_triple_datacnt_good_airt,i_triple_datacnt_good_dewp,
     +   i_triple_datacnt_good_slp,i_triple_datacnt_good_stnp)

      IMPLICIT NONE
c************************************************************************
c     Declare variables 

      INTEGER             :: i_0good_1bad_2zero

      INTEGER             :: l_rgh_datalines
      INTEGER             :: l_data

      CHARACTER(LEN=300)  :: s_directory_outfile_iff_netplatdistinct
      CHARACTER(LEN=30)   :: s_networktype
      CHARACTER(LEN=30)   :: s_platformid
      INTEGER             :: i_triplediff_cnt
      INTEGER             :: i_triplediff_numobs(l_rgh_datalines)
      REAL                :: f_triplediff_lat(l_rgh_datalines)
      REAL                :: f_triplediff_lon(l_rgh_datalines)
      REAL                :: f_triplediff_plathght(l_rgh_datalines)

      INTEGER             :: i_triple_datacnt_good_wdir(l_rgh_datalines)
      INTEGER             :: i_triple_datacnt_good_wspd(l_rgh_datalines)
      INTEGER             :: i_triple_datacnt_good_airt(l_rgh_datalines)
      INTEGER             :: i_triple_datacnt_good_dewp(l_rgh_datalines)
      INTEGER             :: i_triple_datacnt_good_slp(l_rgh_datalines)
      INTEGER             :: i_triple_datacnt_good_stnp(l_rgh_datalines)

c      INTEGER             :: i_triple_datacnt_good_wdir(20)
c      INTEGER             :: i_triple_datacnt_good_wspd(20)
c      INTEGER             :: i_triple_datacnt_good_airt(20)
c      INTEGER             :: i_triple_datacnt_good_dewp(20)
c      INTEGER             :: i_triple_datacnt_good_slp(20)
c      INTEGER             :: i_triple_datacnt_good_stnp(20)
c*****
c     Variables used in subroutine

      INTEGER             :: i,j,k,ii,jj,kk
      CHARACTER(LEN=300)  :: s_pathandname

c************************************************************************
      print*,'just inside export_triplet_info'

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

      print*,'s_pathandname=',TRIM(s_pathandname)
c*****
c     Open header file for output
      OPEN(UNIT=2,
     +   FILE=TRIM(s_pathandname),
     +   FORM='formatted',
     +   STATUS='REPLACE',ACTION='WRITE')

      WRITE(2,1000) 'Network_type:  ',TRIM(s_networktype)
      WRITE(2,1000) 'Platform_id:   ',TRIM(s_platformid)
 1000 FORMAT(t1,a15,t17,a10)

      WRITE(2,1002) '               '
 1002 FORMAT(t1,a15)

      WRITE(2,1004) 'Number lines:  ',l_data
      WRITE(2,1004) 'Number triplet:',i_triplediff_cnt
 1004 FORMAT(t1,a15,t17,i7)

      WRITE(2,1002) '               '

      WRITE(2,1006) 'NN',
     +  'Latitude ','Longitude','Height   ',
     +  'wdir   ','wspd   ','airt   ','dewp   ','slp    ','stnp   '
      WRITE(2,1006) '++','+-------+','+-------+','+-------+',
     +  '+-----+','+-----+','+-----+','+-----+','+-----+','+-----+'
 1006 FORMAT(t1,a2,t4,a9,t14,a9,t24,a9,t34,
     +  a7,t42,a7,t50,a7,t58,a7,t66,a7,t74,a7)

      DO i=1,i_triplediff_cnt
       WRITE(2,1008) i,
     + f_triplediff_lat(i),f_triplediff_lon(i),f_triplediff_plathght(i),
     + i_triple_datacnt_good_wdir(i),i_triple_datacnt_good_wspd(i),
     + i_triple_datacnt_good_airt(i),i_triple_datacnt_good_dewp(i),
     + i_triple_datacnt_good_slp(i), i_triple_datacnt_good_stnp(i)
 1008  FORMAT(t1,i2,t4,f9.5,t14,f9.5,t24,f9.4,t34,
     +  i7,t42,i7,t50,i7,t58,i7,t66,i7,t74,i7)
      ENDDO

      CLOSE(UNIT=2)
c*****
      print*,'just leaving export_triplet_info'

c      STOP 'export_triplet_info'

      RETURN
      END
