c     Subroutine to extract first fields from line
c     AJ_Kettle, 17Jan2020
      
      SUBROUTINE extract_netplat_info(s_linget,i_len,
     +   l_ascii,i_list_ascii,s_list_asciichar,
     +   s_platformid_single,s_networktype_single,
     +   s_reporttype_single,s_ncdc_ob_time_single)

      IMPLICIT NONE
c************************************************************************
c     Declare variables 

      CHARACTER(LEN=*)    :: s_linget
      INTEGER             :: i_len

      INTEGER             :: l_ascii
      INTEGER             :: i_list_ascii(62)
      CHARACTER(LEN=1)    :: s_list_asciichar(62)

      CHARACTER(LEN=*)    :: s_platformid_single
      CHARACTER(LEN=*)    :: s_networktype_single
      CHARACTER(LEN=*)    :: s_reporttype_single
      CHARACTER(LEN=*)    :: s_ncdc_ob_time_single
******
c     Variables used in subroutine

      INTEGER             :: i,j,k,ii,jj,kk

      INTEGER             :: i_comma_cnt
      INTEGER             :: i_comma_pos(200)
      INTEGER             :: i_field_cnt
      INTEGER             :: i_cnt_comma_max
      INTEGER             :: i_cnt_comma_min
      INTEGER             :: i_lenfield(200)

c     Variables to rebuild platformid & networktype
c      INTEGER             :: i_cntbadchar_ref1,i_idbadascii_ref1
      CHARACTER(LEN=20)   :: s_platformid_test
      CHARACTER(LEN=20)   :: s_platformid_rebuild
      INTEGER             :: i_cntbadchar_platformid1
      INTEGER             :: i_idbadascii_platformid1
      CHARACTER(LEN=20)   :: s_networktype_test
      CHARACTER(LEN=20)   :: s_networktype_rebuild
      INTEGER             :: i_cntbadchar_networktype1
      INTEGER             :: i_idbadascii_networktype1
      CHARACTER(LEN=20)   :: s_reporttype_test
      CHARACTER(LEN=20)   :: s_reporttype_rebuild
      INTEGER             :: i_cntbadchar_reporttype1
      INTEGER             :: i_idbadascii_reporttype1

      CHARACTER(LEN=14)   :: s_ncdc_ob_time_test  
c************************************************************************
c      print*,'just inside extract_netplat_info'

c      Sequence to find commas
       i_comma_cnt=1
       DO j=1,i_len   
        IF (s_linget(j:j) .EQ. ',') THEN
         i_comma_pos(i_comma_cnt)=j
         i_comma_cnt=i_comma_cnt+1         
        ENDIF
       ENDDO
       i_comma_cnt=i_comma_cnt-1
       i_field_cnt=i_comma_cnt+1

       i_cnt_comma_max=MAX(i_cnt_comma_max,i_comma_cnt)
       i_cnt_comma_min=MIN(i_cnt_comma_min,i_comma_cnt)

c      Assess if field empty
       i_lenfield(1)=i_comma_pos(1)-1
       DO j=1,i_comma_cnt-1
        i_lenfield(j+1)=i_comma_pos(j+1)-i_comma_pos(j)-1
       ENDDO
       i_lenfield(i_comma_cnt+1)=LEN_TRIM(ADJUSTL(s_linget
     +(i_comma_pos(i_comma_cnt)+1:i_comma_pos(i_comma_cnt)+20) ))

c      Find binary length field
c       DO j=1,i_field_cnt
c        IF (i_lenfield(j).EQ.0) THEN
c         i_lenfield_binary(j)=0
c        ENDIF
c        IF (i_lenfield(j).GT.0) THEN
c         i_lenfield_binary(j)=1
c        ENDIF
c       ENDDO

c      Extract fields for platformid & networktype
       s_platformid_test=TRIM(ADJUSTL(s_linget(1:i_comma_pos(1)-1)))
       s_networktype_test=
     +  TRIM(ADJUSTL(s_linget(i_comma_pos(1)+1:i_comma_pos(2)-1)))
       s_ncdc_ob_time_test=
     +  TRIM(ADJUSTL(s_linget(i_comma_pos(2)+1:i_comma_pos(3)-1)))
       s_reporttype_test=
     +  TRIM(ADJUSTL(s_linget(i_comma_pos(3)+1:i_comma_pos(4)-1)))

c      Rebuild platformid & networktype
       CALL test_component_char(s_platformid_test,
     +    l_ascii,i_list_ascii,s_list_asciichar,
     +    s_platformid_rebuild,
     +    i_cntbadchar_platformid1,i_idbadascii_platformid1)
       CALL test_component_char(s_networktype_test,
     +    l_ascii,i_list_ascii,s_list_asciichar,
     +    s_networktype_rebuild,
     +    i_cntbadchar_networktype1,i_idbadascii_networktype1)
c***
       s_platformid_single  =ADJUSTL(s_platformid_rebuild)
       s_networktype_single =ADJUSTL(s_networktype_rebuild)

       s_ncdc_ob_time_single=ADJUSTL(s_ncdc_ob_time_test)
       s_reporttype_single  =ADJUSTL(s_reporttype_test)
c***
c      print*,'just leaving extract_nettplat_info'

c      STOP 'extract_netplat_info'

      RETURN
      END
