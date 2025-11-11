c     Subroutine to get networktype & platformid for single station
c     AJ_Kettle, 20Mar2019
c     12Mar2020: used for USAF update without modification

      SUBROUTINE get_netplat(s_shortnamelist_singlename,
     +  s_networktype,s_platformid)

c************************************************************************
c     Declare variables 

      CHARACTER(LEN=*)    :: s_shortnamelist_singlename

      CHARACTER(LEN=*)    :: s_networktype
      CHARACTER(LEN=*)    :: s_platformid

      INTEGER             :: i_len
      INTEGER             :: i_underscore
      INTEGER             :: i_period
c************************************************************************
c      print*,'just entered get_netplat'

c     Separate network & platform
      i_len=LEN_TRIM(s_shortnamelist_singlename)
      DO i=1,i_len
       IF (s_shortnamelist_singlename(i:i).EQ.'_') THEN
        i_underscore=i
       ENDIF
       IF (s_shortnamelist_singlename(i:i).EQ.'.') THEN
        i_period=i
       ENDIF
      ENDDO

      s_networktype =
     +  s_shortnamelist_singlename(1:i_underscore-1) 
      s_platformid  =
     +  s_shortnamelist_singlename(i_underscore+1:i_period-1)

c      print*,'i_len=',i_len
c      print*,'s_shortnamelist_singlename=',
c     +   TRIM(s_shortnamelist_singlename)
c      print*,'s_networktype=',TRIM(s_networktype)
c      print*,'s_platformid=',TRIM(s_platformid)

c      print*,'just leaving get_netplat'

c      STOP 'get_netplat'

      RETURN
      END
