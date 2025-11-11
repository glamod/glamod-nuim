c     Subroutine to get information from station configuration list
c     AJ_Kettle, 09Sep2019

      SUBROUTINE info_from_stnconfig_vector(s_stnname_single,
     +   l_scinput,l_scinput_rgh,
     +   s_scinput_primary_id,
     +   s_scinput_record_number,s_scinput_policy_license,
     +   s_scinput_source_id,
     +   l_scshort,
     +   s_scshort_record_number,s_scshort_source_id,
     +   s_scshort_policy_licence)

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

      INTEGER             :: l_scshort
      CHARACTER(LEN=2)    :: s_scshort_record_number(20)
      CHARACTER(LEN=1)    :: s_scshort_policy_licence(20) 
      CHARACTER(LEN=3)    :: s_scshort_source_id(20)
c*****
c     Variables used in subroutine

      INTEGER             :: i,j,k,ii,jj,kk
c************************************************************************
c      print*,'just entered info_from_stnconfig_vector'

c     Get get information from station configuration file
      ii=0
      DO j=1,l_scinput
        IF (TRIM(s_stnname_single).EQ.
     +      TRIM(s_scinput_primary_id(j))) THEN

         ii=ii+1

         IF (ii.GT.20) THEN 
          print*,'emergency stop; record_number too high'
          STOP 'info_from_stnconfig_vector'
         ENDIF

         s_scshort_record_number(ii) =TRIM(s_scinput_record_number(j)) 
         s_scshort_source_id(ii)     =TRIM(s_scinput_source_id(j))
         s_scshort_policy_licence(ii)=
     +                              TRIM(s_scinput_policy_license(j))

cd         print*,'s_record_number_single='//
cd     +       TRIM(s_record_number_single)//'='
cd         print*,'s_source_id_single='//TRIM(s_source_id_single)//'='

         GOTO 120
        ENDIF
      ENDDO

      STOP 'get_gsom_datafile; s_source_id_single not found'

 120  CONTINUE

      l_scshort=ii

c      print*,'l_scshort=',l_scshort
c      print*,'s_scvec_record_number=',
c     +  (TRIM(s_scshort_record_number(i)),i=1,l_scshort)
c      print*,'s_scvec_data_policy_licence=',
c     +  (TRIM(s_scshort_policy_licence(i)),i=1,l_scshort)
c      print*,'s_scvec_source_id=',
c     +  (TRIM(s_scshort_source_id(i)),i=1,l_scshort)

c     print*,'just leaving info_from_stnconfig_vector'

c      STOP 'info_from_stnconfig_vector'

      RETURN
      END
