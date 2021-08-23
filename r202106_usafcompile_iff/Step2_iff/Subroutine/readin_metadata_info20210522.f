c     Subroutine to get info on metadata
c     AJ_Kettle, June17/2018
c     19Mar2019: moved to Step3_stn_readin
c     15Mar2015: small modification for USAF update file

      SUBROUTINE readin_metadata_info3(
     +  s_directory_metadata,s_metadata_file,
     +  l_rgh_metadata,l_metadata,
     +  s_metadata_platformid,s_metadata_networktype,
     +  s_metadata_name,s_metadata_st,s_metadata_co,
     +  s_metadata_lat,s_metadata_lon,s_metadata_elev,
     +  s_metadata_s,
     +  s_metadata_ualat,s_metadata_ualon,s_metadata_uaelev,
     +  s_metadata_time_conv)

      IMPLICIT NONE
c************************************************************************
c     Declare variables 

      INTEGER             :: i,j,k,ii,jj,kk

      INTEGER             :: l_rgh_metadata

      CHARACTER(LEN=300)  :: s_directory_metadata
      CHARACTER(LEN=300)  :: s_metadata_file

      CHARACTER(LEN=30)   :: s_frag_platformid    !20
      CHARACTER(LEN=30)   :: s_frag_networktype   !20
      CHARACTER(LEN=100)  :: s_frag_name          !100
      CHARACTER(LEN=15)   :: s_frag_st            !20
      CHARACTER(LEN=15)   :: s_frag_co            !20
      CHARACTER(LEN=15)   :: s_frag_lat           !20
      CHARACTER(LEN=15)   :: s_frag_lon           !20
      CHARACTER(LEN=15)   :: s_frag_elev          !20
      CHARACTER(LEN=15)   :: s_frag_s             !20
      CHARACTER(LEN=15)   :: s_frag_ualat         !20
      CHARACTER(LEN=15)   :: s_frag_ualon         !20
      CHARACTER(LEN=15)   :: s_frag_uaelev        !20
      CHARACTER(LEN=15)   :: s_frag_time_conv     !20

      INTEGER             :: i_len_platformid
      INTEGER             :: i_len_networktype
      INTEGER             :: i_len_name
      INTEGER             :: i_len_st
      INTEGER             :: i_len_co
      INTEGER             :: i_len_lat
      INTEGER             :: i_len_lon
      INTEGER             :: i_len_elev
      INTEGER             :: i_len_s
      INTEGER             :: i_len_ualat
      INTEGER             :: i_len_ualon
      INTEGER             :: i_len_uaelev
      INTEGER             :: i_len_time_conv

      INTEGER             :: i_lenmax_platformid
      INTEGER             :: i_lenmax_networktype
      INTEGER             :: i_lenmax_name
      INTEGER             :: i_lenmax_st
      INTEGER             :: i_lenmax_co
      INTEGER             :: i_lenmax_lat
      INTEGER             :: i_lenmax_lon
      INTEGER             :: i_lenmax_elev
      INTEGER             :: i_lenmax_s
      INTEGER             :: i_lenmax_ualat
      INTEGER             :: i_lenmax_ualon
      INTEGER             :: i_lenmax_uaelev
      INTEGER             :: i_lenmax_time_conv

      INTEGER             :: i_lenmin_platformid
      INTEGER             :: i_lenmin_networktype
      INTEGER             :: i_lenmin_name
      INTEGER             :: i_lenmin_st
      INTEGER             :: i_lenmin_co
      INTEGER             :: i_lenmin_lat
      INTEGER             :: i_lenmin_lon
      INTEGER             :: i_lenmin_elev
      INTEGER             :: i_lenmin_s
      INTEGER             :: i_lenmin_ualat
      INTEGER             :: i_lenmin_ualon
      INTEGER             :: i_lenmin_uaelev
      INTEGER             :: i_lenmin_time_conv

      INTEGER             :: i_lendiff_platformid
      INTEGER             :: i_lendiff_networktype
      INTEGER             :: i_lendiff_name
      INTEGER             :: i_lendiff_st
      INTEGER             :: i_lendiff_co
      INTEGER             :: i_lendiff_lat
      INTEGER             :: i_lendiff_lon
      INTEGER             :: i_lendiff_elev
      INTEGER             :: i_lendiff_s
      INTEGER             :: i_lendiff_ualat
      INTEGER             :: i_lendiff_ualon
      INTEGER             :: i_lendiff_uaelev
      INTEGER             :: i_lendiff_time_conv

      CHARACTER(LEN=*)    :: s_metadata_platformid(l_rgh_metadata)   !30
      CHARACTER(LEN=*)    :: s_metadata_networktype(l_rgh_metadata)  !30
      CHARACTER(LEN=*)    :: s_metadata_name(l_rgh_metadata)         !100
      CHARACTER(LEN=*)    :: s_metadata_st(l_rgh_metadata)           !15
      CHARACTER(LEN=*)    :: s_metadata_co(l_rgh_metadata)           !15
      CHARACTER(LEN=*)    :: s_metadata_lat(l_rgh_metadata)          !15
      CHARACTER(LEN=*)    :: s_metadata_lon(l_rgh_metadata)          !15
      CHARACTER(LEN=*)    :: s_metadata_elev(l_rgh_metadata)         !15
      CHARACTER(LEN=*)    :: s_metadata_s(l_rgh_metadata)            !15
      CHARACTER(LEN=*)    :: s_metadata_ualat(l_rgh_metadata)        !15
      CHARACTER(LEN=*)    :: s_metadata_ualon(l_rgh_metadata)        !15
      CHARACTER(LEN=*)    :: s_metadata_uaelev(l_rgh_metadata)       !15
      CHARACTER(LEN=*)    :: s_metadata_time_conv(l_rgh_metadata)    !15

      INTEGER             :: i_metadata_linelength(l_rgh_metadata)
      INTEGER             :: i_metadata_commacnt(l_rgh_metadata)

      INTEGER             :: i_max_linelength
      INTEGER             :: i_max_commacnt

      CHARACTER(LEN=300)  :: s_pathandname
      INTEGER             :: l_metadata
      INTEGER             :: l_metadatap2

      CHARACTER(LEN=200)  :: s_linget
      CHARACTER(LEN=200)  :: s_linsto(l_rgh_metadata) 

      INTEGER             :: io
      INTEGER             :: i_comma_cnt
      INTEGER             :: i_comma_pos(20)
      INTEGER             :: i_len
c************************************************************************
c      print*,'just inside readin_metadata_info'
c      print*,'number of metadata lines registered 180423'

      s_pathandname=TRIM(s_directory_metadata)//TRIM(s_metadata_file)
c      print*,'s_pathandname=',TRIM(s_pathandname)

c     Read in lines
      ii=0

      OPEN(UNIT=1,FILE=TRIM(s_pathandname),FORM='formatted',
     +  STATUS='OLD',ACTION='READ')      

      DO 

c      Read data line
       READ(1,1002,IOSTAT=io) s_linget
1002   FORMAT(a200)
       IF (io .GT. 0) THEN
        WRITE(*,*) 'Check input. Something went wrong'
        GOTO 100
       ELSE IF (io .LT. 0) THEN 
c        WRITE(*,*) 'end of file reached'
        GOTO 100
       ELSE

        ii=ii+1

        IF (ii.GT.l_rgh_metadata) THEN
         print*,'emergency stop array storage exceeded'
         STOP 'readin_metadata_info20210522'
        ENDIF

        s_linsto(ii)=s_linget

       ENDIF
      ENDDO                !end of line-counting loop

100   CONTINUE

      CLOSE(UNIT=1)

      l_metadatap2=ii
      l_metadata  =l_metadatap2-2

c      print*,'l_metadata=',l_metadata
c      CALL SLEEP(5)
c************************************************************************
c     Extract fields

c     initialize variables
      i_max_linelength=0
      i_max_commacnt  =0

c     Initialize max length of strings
      i_lenmax_platformid =0
      i_lenmax_networktype=0
      i_lenmax_name       =0
      i_lenmax_st         =0
      i_lenmax_co         =0
      i_lenmax_lat        =0
      i_lenmax_lon        =0
      i_lenmax_elev       =0
      i_lenmax_s          =0
      i_lenmax_ualat      =0
      i_lenmax_ualon      =0
      i_lenmax_uaelev     =0
      i_lenmax_time_conv  =0

c     Initialize min length of strings
      i_lenmin_platformid =1000
      i_lenmin_networktype=1000
      i_lenmin_name       =1000
      i_lenmin_st         =1000
      i_lenmin_co         =1000
      i_lenmin_lat        =1000
      i_lenmin_lon        =1000
      i_lenmin_elev       =1000
      i_lenmin_s          =1000
      i_lenmin_ualat      =1000
      i_lenmin_ualon      =1000
      i_lenmin_uaelev     =1000
      i_lenmin_time_conv  =1000

      DO i=3,l_metadatap2   !do not include 1st line
       s_linget=s_linsto(i)

c      Find length of string
       i_len=LEN_TRIM(s_linget) 

c      Sequence to find commas
       i_comma_cnt=0
       DO j=1,i_len   
        IF (s_linget(j:j) .EQ. ',') THEN
         i_comma_cnt=i_comma_cnt+1   
         i_comma_pos(i_comma_cnt)=j
        ENDIF
       ENDDO

       i_metadata_linelength(i-1)=i_len
       i_metadata_commacnt(i-1)  =i_comma_cnt
c******
c      Find lengths of strings

       i_lendiff_platformid =(i_comma_pos(1)-1)-1
       i_lendiff_networktype=(i_comma_pos(2)-1)-(i_comma_pos(1)+1)
       i_lendiff_name       =(i_comma_pos(3)-1)-(i_comma_pos(2)+1)
       i_lendiff_st         =(i_comma_pos(4)-1)-(i_comma_pos(3)+1)
       i_lendiff_co         =(i_comma_pos(5)-1)-(i_comma_pos(4)+1)
       i_lendiff_lat        =(i_comma_pos(6)-1)-(i_comma_pos(5)+1)
       i_lendiff_lon        =(i_comma_pos(7)-1)-(i_comma_pos(6)+1)
       i_lendiff_elev       =(i_comma_pos(8)-1)-(i_comma_pos(7)+1)
       i_lendiff_s          =(i_comma_pos(9)-1)-(i_comma_pos(8)+1)
       i_lendiff_ualat      =(i_comma_pos(10)-1)-(i_comma_pos(9)+1)
       i_lendiff_ualon      =(i_comma_pos(11)-1)-(i_comma_pos(10)+1)
       i_lendiff_uaelev     =(i_comma_pos(12)-1)-(i_comma_pos(11)+1)
       i_lendiff_time_conv  =(i_comma_pos(12)+6)-(i_comma_pos(12)+1)
c******
c       print*,s_linget(1:i_comma_pos(1)-1),

c       print*,'i=',i
c       print*,'s_linget=',TRIM(s_linget)
c       print*,'i_comma_cnt=',i_comma_cnt
c       print*,'i_comma_pos=',(i_comma_pos(j),j=1,i_comma_cnt)

c       print*,'diffs=',
c     +  i_lendiff_platformid,i_lendiff_networktype,
c     +  i_lendiff_name,      i_lendiff_st,
c     +  i_lendiff_co,        i_lendiff_lat,
c     +  i_lendiff_lon,       i_lendiff_elev,
c     +  i_lendiff_s,         i_lendiff_ualat,
c     +  i_lendiff_ualon,     i_lendiff_uaelev,
c     +  i_lendiff_time_conv

       s_frag_platformid=s_linget(1:i_comma_pos(1)-1)
       s_frag_networktype=
     +   s_linget(i_comma_pos(1)+1:i_comma_pos(2)-1)
       s_frag_name       =
     +   s_linget(i_comma_pos(2)+1:i_comma_pos(3)-1)
       s_frag_st         =
     +   s_linget(i_comma_pos(3)+1:i_comma_pos(4)-1)
       s_frag_co         =
     +   s_linget(i_comma_pos(4)+1:i_comma_pos(5)-1)
       s_frag_lat        =
     +   s_linget(i_comma_pos(5)+1:i_comma_pos(6)-1)
       s_frag_lon        =
     +   s_linget(i_comma_pos(6)+1:i_comma_pos(7)-1)
       s_frag_elev       =
     +   s_linget(i_comma_pos(7)+1:i_comma_pos(8)-1)
       s_frag_s          =
     +   s_linget(i_comma_pos(8)+1:i_comma_pos(9)-1)
       s_frag_ualat      =
     +   s_linget(i_comma_pos(9)+1:i_comma_pos(10)-1)
       s_frag_ualon      =
     +   s_linget(i_comma_pos(10)+1:i_comma_pos(11)-1)
       s_frag_uaelev     =
     +   s_linget(i_comma_pos(11)+1:i_comma_pos(12)-1)
       s_frag_time_conv  =
     +   s_linget(i_comma_pos(12)+1:i_comma_pos(12)+6)

c      Find length of strings
       i_len_platformid =LEN_TRIM(s_frag_platformid)
       i_len_networktype=LEN_TRIM(s_frag_networktype)
       i_len_name       =LEN_TRIM(s_frag_name)
       i_len_st         =LEN_TRIM(s_frag_st)
       i_len_co         =LEN_TRIM(s_frag_co)
       i_len_lat        =LEN_TRIM(s_frag_lat)
       i_len_lon        =LEN_TRIM(s_frag_lon)
       i_len_elev       =LEN_TRIM(s_frag_elev)
       i_len_s          =LEN_TRIM(s_frag_s)
       i_len_ualat      =LEN_TRIM(s_frag_ualat)
       i_len_ualon      =LEN_TRIM(s_frag_ualon)
       i_len_uaelev     =LEN_TRIM(s_frag_uaelev)
       i_len_time_conv  =LEN_TRIM(s_frag_time_conv)

c      Find max length of strings
       i_lenmax_platformid =MAX(i_len_platformid,i_lenmax_platformid)
       i_lenmax_networktype=MAX(i_len_networktype,i_lenmax_networktype)
       i_lenmax_name       =MAX(i_len_name,i_lenmax_name)
       i_lenmax_st         =MAX(i_len_st,i_lenmax_st)
       i_lenmax_co         =MAX(i_len_co,i_lenmax_co)
       i_lenmax_lat        =MAX(i_len_lat,i_lenmax_lat)
       i_lenmax_lon        =MAX(i_len_lon,i_lenmax_lon)
       i_lenmax_elev       =MAX(i_len_elev,i_lenmax_elev)
       i_lenmax_s          =MAX(i_len_s,i_lenmax_s)
       i_lenmax_ualat      =MAX(i_len_ualat,i_lenmax_ualat)
       i_lenmax_ualon      =MAX(i_len_ualon,i_lenmax_ualon)
       i_lenmax_uaelev     =MAX(i_len_uaelev,i_lenmax_uaelev)
       i_lenmax_time_conv  =MAX(i_len_time_conv,i_lenmax_time_conv)

c      Find min length of strings
       i_lenmin_platformid =MIN(i_len_platformid,i_lenmin_platformid)
       i_lenmin_networktype=MIN(i_len_networktype,i_lenmin_networktype)
       i_lenmin_name       =MIN(i_len_name,i_lenmin_name)
       i_lenmin_st         =MIN(i_len_st,i_lenmin_st)
       i_lenmin_co         =MIN(i_len_co,i_lenmin_co)
       i_lenmin_lat        =MIN(i_len_lat,i_lenmin_lat)
       i_lenmin_lon        =MIN(i_len_lon,i_lenmin_lon)
       i_lenmin_elev       =MIN(i_len_elev,i_lenmin_elev)
       i_lenmin_s          =MIN(i_len_s,i_lenmin_s)
       i_lenmin_ualat      =MIN(i_len_ualat,i_lenmin_ualat)
       i_lenmin_ualon      =MIN(i_len_ualon,i_lenmin_ualon)
       i_lenmin_uaelev     =MIN(i_len_uaelev,i_lenmin_uaelev)
       i_lenmin_time_conv  =MIN(i_len_time_conv,i_lenmin_time_conv)

       s_metadata_platformid(i-2) =s_frag_platformid
       s_metadata_networktype(i-2)=s_frag_networktype
       s_metadata_name(i-2)       =s_frag_name
       s_metadata_st(i-2)         =s_frag_st
       s_metadata_co(i-2)         =s_frag_co
       s_metadata_lat(i-2)        =s_frag_lat
       s_metadata_lon(i-2)        =s_frag_lon
       s_metadata_elev(i-2)       =s_frag_elev
       s_metadata_s(i-2)          =s_frag_s
       s_metadata_ualat(i-2)      =s_frag_ualat
       s_metadata_ualon(i-2)      =s_frag_ualon
       s_metadata_uaelev(i-2)     =s_frag_uaelev
       s_metadata_time_conv(i-2)  =s_frag_time_conv

c      Extract fields
c       BAD 
c       s_metadata_platformid(i-1) =
c     +   TRIM(s_linget(1:i_comma_pos(1)-1))
c       print*,'cleared A',TRIM(s_metadata_platformid(i-1))
c       BAD
c       s_metadata_networktype(i-1)=
c     +   (s_linget(i_comma_pos(1)+1:i_comma_pos(2)-1))
c       print*,'cleared B',TRIM(s_metadata_networktype(i-1))
c       GOOD
c       s_metadata_name(i-1)       =
c     +   TRIM(s_linget(i_comma_pos(2)+1:i_comma_pos(3)-1))
c       print*,'cleared C',TRIM(s_metadata_name(i-1))
c      BAD
c       s_metadata_st(i-1)         =
c     +   TRIM(s_linget(i_comma_pos(3)+1:i_comma_pos(4)-1))
c       print*,'cleared D',TRIM(s_metadata_st(i-1))
c       print*,'ss'//TRIM(s_linget(i_comma_pos(4)+1:i_comma_pos(5)-1))//
c     +   'ss'
c       BAD
c       s_metadata_co(i-1)         =
c     +   s_linget(i_comma_pos(4)+1:i_comma_pos(5)-1)
c       print*,'cleared E'
c      BAD
c       s_metadata_lat(i-1)        =
c     +   s_linget(i_comma_pos(5)+1:i_comma_pos(6)-1)
c       print*,'cleared F'
c       s_metadata_lon(i-1)        =
c     +   s_linget(i_comma_pos(6)+1:i_comma_pos(7)-1)
c       print*,'cleared G'
c       s_metadata_elev(i-1)       =
c     +   s_linget(i_comma_pos(7)+1:i_comma_pos(8)-1)
c       print*,'cleared H'
c       s_metadata_s(i-1)          =
c     +   s_linget(i_comma_pos(8)+1:i_comma_pos(9)-1)
c       s_metadata_ualat(i-1)      =
c     +   s_linget(i_comma_pos(9)+1:i_comma_pos(10)-1)
c       s_metadata_ualon(i-1)      =
c     +   s_linget(i_comma_pos(10)+1:i_comma_pos(11)-1)
c       s_metadata_uaelev(i-1)     =
c     +   s_linget(i_comma_pos(11)+1:i_comma_pos(12)-1)
c      s_metadata_time_conv(i-1)  =
c     +   s_linget(i_comma_pos(12)+1:i_comma_pos(12)+6)
c******
       i_max_linelength=MAX(i_max_linelength,i_metadata_linelength(i))
       i_max_commacnt  =MAX(i_max_commacnt,i_metadata_commacnt(i))

      ENDDO

      print*,'i_metadata_linelength=',(i_metadata_linelength(i),i=1,5)
      print*,'i_metadata_commacnt=',(i_metadata_commacnt(i),i=1,5)
      print*,'i_max_linelength=',i_max_linelength
      print*,'i_max_commacnt',i_max_commacnt

      print*,'s_metadata_platformid=',
     +  (TRIM(s_metadata_platformid(i)),i=1,5)
      print*,'s_metadata_networktype=',
     +  (TRIM(s_metadata_networktype(i)),i=1,5)
      print*,'s_metadata_name=',(TRIM(s_metadata_name(i)),i=1,5)
      print*,'s_metadata_st=',(TRIM(s_metadata_st(i)),i=1,5)
      print*,'s_metadata_co=',(TRIM(s_metadata_co(i)),i=1,5)
      print*,'s_metadata_lat=',(TRIM(s_metadata_lat(i)),i=1,5)
      print*,'s_metadata_lon=',(TRIM(s_metadata_lon(i)),i=1,5)
      print*,'s_metadata_elev=',(TRIM(s_metadata_elev(i)),i=1,5)
      print*,'s_metadata_s=',(TRIM(s_metadata_s(i)),i=1,5)
      print*,'s_metadata_ualat=',(TRIM(s_metadata_ualat(i)),i=1,5)
      print*,'s_metadata_ualon=',(TRIM(s_metadata_ualon(i)),i=1,5)
      print*,'s_metadata_uaelev=',(TRIM(s_metadata_uaelev(i)),i=1,5)
      print*,'s_metadata_time_conv=',
     +  (TRIM(s_metadata_time_conv(i)),i=1,5)

      print*,'i_.._platformid=',i_lenmin_platformid,i_lenmax_platformid
      print*,'i_.._networktype=',
     + i_lenmin_networktype,i_lenmax_networktype
      print*,'i_.._name=',      i_lenmin_name,i_lenmax_name
      print*,'i_.._st=',        i_lenmin_st,i_lenmax_st
      print*,'i_.._co=',        i_lenmin_co,i_lenmax_co
      print*,'i_.._lat=',       i_lenmin_lat,i_lenmax_lat
      print*,'i_.._lon=',       i_lenmin_lon,i_lenmax_lon
      print*,'i_.._elev=',      i_lenmin_elev,i_lenmax_elev
      print*,'i_.._s=',         i_lenmin_s,i_lenmax_s
      print*,'i_.._ualat=',     i_lenmin_ualat,i_lenmax_ualat
      print*,'i_.._ualon=',     i_lenmin_ualon,i_lenmax_ualon
      print*,'i_.._uaelev=',    i_lenmin_uaelev,i_lenmax_uaelev
      print*,'i_.._time_conv=', i_lenmin_time_conv,i_lenmax_time_conv

      print*,'l_metadata,l_metadatap2=',l_metadata,l_metadatap2
c************************************************************************
c************************************************************************
      print*,'just leaving readin_metadata_info20210522'
c      STOP 'readin_metadata_info2'

      RETURN
      END
