c     Subroutine to get elements from line
c     AJ_Kettle, 01Mar2018
c     11Mar2020: modified for USAF update 

      SUBROUTINE get_elements_from_line(s_linget,
     +    s_primary_id,s_record_number,s_secondary_id,s_station_name,
     +    s_longitude,s_latitude,s_elevation_m,
     +    s_policy_license,s_source_id)

      IMPLICIT NONE
c************************************************************************
      CHARACTER(LEN=300)  :: s_linget

      CHARACTER(LEN=20)   :: s_primary_id
      CHARACTER(LEN=2)    :: s_record_number
      CHARACTER(LEN=20)   :: s_secondary_id
      CHARACTER(LEN=50)   :: s_station_name
      CHARACTER(LEN=10)   :: s_longitude
      CHARACTER(LEN=10)   :: s_latitude
      CHARACTER(LEN=10)   :: s_elevation_m
      CHARACTER(LEN=1)    :: s_policy_license
      CHARACTER(LEN=3)    :: s_source_id
c*****
c     Variables used within subroutine

      INTEGER             :: i,j,k,ii,jj,kk

      INTEGER             :: i_len
      CHARACTER(LEN=1)    :: s_single
      INTEGER             :: i_pos
      INTEGER             :: i_posloc(20)
      INTEGER             :: i_vec_len(20)
c************************************************************************
c      print*,'just inside get_elements_from_line'

      i_len=LEN_TRIM(s_linget)
      i_pos=0

      DO i=1,i_len
       s_single=s_linget(i:i)
       IF (s_single.EQ.'|') THEN 
        i_pos=i_pos+1
        i_posloc(i_pos)=i
       ENDIF
      ENDDO

c     Find lengths; number of fields one more than dividers
      i_vec_len(1)=i_posloc(1)-1
      i_vec_len(2)=i_posloc(2)-i_posloc(1)-1
      i_vec_len(3)=i_posloc(3)-i_posloc(2)-1
      i_vec_len(4)=i_posloc(4)-i_posloc(3)-1
      i_vec_len(5)=i_posloc(5)-i_posloc(4)-1
      i_vec_len(6)=i_posloc(6)-i_posloc(5)-1
      i_vec_len(7)=i_posloc(7)-i_posloc(6)-1
      i_vec_len(8)=i_posloc(8)-i_posloc(7)-1
      i_vec_len(9)=i_len      -i_posloc(8)

c      print*,'i_vec_len=',(i_vec_len(i),i=1,i_pos+1)
c*****
c     Test lengths of fields
      IF (i_vec_len(1).GT.20.OR.
     +    i_vec_len(2).GT.2 .OR.
     +    i_vec_len(3).GT.20.OR.
     +    i_vec_len(4).GT.50.OR.
     +    i_vec_len(5).GT.10.OR.
     +    i_vec_len(6).GT.10.OR.
     +    i_vec_len(7).GT.10.OR.
     +    i_vec_len(8).GT.1 .OR.
     +    i_vec_len(9).GT.3) THEN
       print*,'emergency stop; field overlength'
       STOP 'get_elements_from_line'
      ENDIF
c*****
      s_primary_id    =s_linget(1:i_posloc(1)-1)
      s_record_number =s_linget(i_posloc(1)+1:i_posloc(2)-1)
      s_secondary_id  =s_linget(i_posloc(2)+1:i_posloc(3)-1)
      s_station_name  =s_linget(i_posloc(3)+1:i_posloc(4)-1)
      s_longitude     =s_linget(i_posloc(4)+1:i_posloc(5)-1)
      s_latitude      =s_linget(i_posloc(5)+1:i_posloc(6)-1)
      s_elevation_m   =s_linget(i_posloc(6)+1:i_posloc(7)-1)
      s_policy_license=s_linget(i_posloc(7)+1:i_posloc(8)-1)
      s_source_id     =s_linget(i_posloc(8)+1:i_len)

c      print*,'i_pos=',i_pos
c      print*,'i_posloc=',(i_posloc(i),i=1,i_pos)

c      print*,'just leaving get_elements_from_line'

c      STOP 'get_elements_from_line'

      RETURN
      END
