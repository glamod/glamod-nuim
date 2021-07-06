c     Subroutine to get information from station configuration list
c     AJ_Kettle, 09Sep2019

      SUBROUTINE info_from_stnconfig(s_stnname_single,
     +   l_scinput,l_scinput_rgh,
     +   s_scinput_primary_id,
     +   s_scinput_record_number,s_scinput_policy_license,
     +   s_scinput_source_id,
     +   s_record_number_single,s_source_id_single,
     +   s_data_policy_licence_single)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into subroutine
      CHARACTER(LEN=12)   :: s_stnname_single

      INTEGER             :: l_scinput_rgh
      INTEGER             :: l_scinput
      CHARACTER(LEN=20)   :: s_scinput_primary_id(l_scinput_rgh)
      CHARACTER(LEN=2)    :: s_scinput_record_number(l_scinput_rgh)
      CHARACTER(LEN=1)    :: s_scinput_policy_license(l_scinput_rgh)
      CHARACTER(LEN=3)    :: s_scinput_source_id(l_scinput_rgh)

      CHARACTER(LEN=2)    :: s_record_number_single
      CHARACTER(LEN=1)    :: s_data_policy_licence_single 
      CHARACTER(LEN=3)    :: s_source_id_single
c*****
c     Variables used in subroutine

      INTEGER             :: i,j,k,ii,jj,kk
c************************************************************************
c      print*,'just entered info_from_stnconfig'

c      Get get information from station configuration file
       DO j=1,l_scinput
        IF (TRIM(s_stnname_single).EQ.
     +      TRIM(s_scinput_primary_id(j))) THEN
         s_record_number_single      =TRIM(s_scinput_record_number(j)) 
         s_source_id_single          =TRIM(s_scinput_source_id(j))
         s_data_policy_licence_single=TRIM(s_scinput_policy_license(j))

cd         print*,'s_record_number_single='//
cd     +       TRIM(s_record_number_single)//'='
cd         print*,'s_source_id_single='//TRIM(s_source_id_single)//'='

         GOTO 120
        ENDIF
       ENDDO

       STOP 'get_gsom_datafile; s_source_id_single not found'

 120   CONTINUE

c      print*,'s_record_number_single=',TRIM(s_record_number_single)
c      print*,'s_data_policy_licence_single=',
c     +  TRIM(s_data_policy_licence_single) 
c      print*,'s_source_id_single=',TRIM(s_source_id_single)

c      print*,'just leaving info_from_stnconfig'

      RETURN
      END
