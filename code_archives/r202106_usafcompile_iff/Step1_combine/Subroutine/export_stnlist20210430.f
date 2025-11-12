c     Subroutine to export list of stations
c     AJ_Kettle, 22Apr2021

      SUBROUTINE export_stnlist20210430(s_date_st,s_time_st,
     +  s_directory_diagnostics,s_file_liststn, 
     +  l_rgh_stn,l_amal,
     +  s_vec_stnlist_amal,i_mat_stnlist_flag)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into subroutine

      CHARACTER(LEN=8)    :: s_date_st
      CHARACTER(LEN=10)   :: s_time_st

      CHARACTER(LEN=300)  :: s_directory_diagnostics
      CHARACTER(LEN=300)  :: s_file_liststn

      INTEGER             :: l_rgh_stn
      INTEGER             :: l_amal
      CHARACTER(LEN=32)   :: s_vec_stnlist_amal(l_rgh_stn)
      INTEGER             :: i_mat_stnlist_flag(l_rgh_stn,3)
c*****
c     Variables used within subroutine

      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: io

      CHARACTER(LEN=300)  :: s_pathandname

      CHARACTER(LEN=32)   :: s_vec_stnlist_stripname(l_rgh_stn)
      CHARACTER(LEN=32)   :: s_single
      INTEGER             :: i_len
      INTEGER             :: i_len_max
c************************************************************************
      print*,'just inside export_stnlist20210430'

      print*,'l_amal=',l_amal
c      STOP 'export_stnlist20210430'

c*****
c     Strip extension from names
      i_len_max=0
      DO i=1,l_amal
       s_single=(s_vec_stnlist_amal(i))
       i_len=LEN_TRIM(s_single)
       s_vec_stnlist_stripname(i)=s_single(1:i_len-4)

c       print*,'i...',i,i_len

       i_len_max=MAX(i_len,i_len_max)

       IF (i_len.GE.32) THEN
        print*,'emergency stop, stnname too long'
        STOP 'export_stnlist20210430' 
       ENDIF

c       CALL SLEEP(1)
      ENDDO

      print*,'i_len_max=',i_len_max
c      print*,'s_vec_stnlist_amal=', 
c     +  (TRIM(s_vec_stnlist_amal(i)),i=1,2),
c     +  TRIM(s_vec_stnlist_amal(l_amal))
c      print*,'s_vec_stnlist_stripname=',
c     +  (TRIM(s_vec_stnlist_stripname(i)),i=1,2),
c     +  TRIM(s_vec_stnlist_stripname(l_amal))
c*****
      s_pathandname=TRIM(s_directory_diagnostics)//TRIM(s_file_liststn) 

      print*,'s_pathandname=',TRIM(s_pathandname)

      OPEN(UNIT=2,FILE=s_pathandname,
     +  FORM='formatted',STATUS='REPLACE',ACTION='WRITE')   

      WRITE(2,1000) 'Station listing with collection source  '
      WRITE(2,1000) '                                        '
      WRITE(2,1002) s_date_st,s_time_st
      WRITE(2,1000) '                                        '
      WRITE(2,1000) 'subdirectory: export_stnlist20210430.f  '
      WRITE(2,1000) '                                        '
      WRITE(2,1003) 'N_stns= ',l_amal
      WRITE(2,1000) '                                        '

 1000 FORMAT(t1,a40)
 1002 FORMAT(t1,a8,t10,a6)
 1003 FORMAT(t1,a8,t10,i6)

c      s_vec_stnlist_amal(l_rgh_stn)
c      INTEGER             :: i_mat_stnlist_flag(l_rgh_stn,3)

      WRITE(2,1004) 'Station Netplat ','Main','Upd1','Upd2'
      WRITE(2,1004) '+--------------+','+--+','+--+','+--+'
 1004 FORMAT(t1,a16,t18,a4,t23,a4,t28,a4)
 1006 FORMAT(t1,a16,t18,i4,t23,i4,t28,i4)

      DO i=1,l_amal
       WRITE(2,1006) ADJUSTL(s_vec_stnlist_stripname(i)),
     +  i_mat_stnlist_flag(i,1),
     +  i_mat_stnlist_flag(i,2),
     +  i_mat_stnlist_flag(i,3)
      ENDDO

      CLOSE(UNIT=2)

      print*,'just leaving export_stnlist20210430'

c      STOP 'export_stnlist20210430'

      RETURN
      END
