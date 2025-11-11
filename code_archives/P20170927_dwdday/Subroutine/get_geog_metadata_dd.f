c     Subroutine to read geographic location metadata
c     AJ_Kettle, Sep11/2017

      SUBROUTINE get_geog_metadata_dd(s_pathandname,
     +   l_geog,
     +   s_geog_stnid,s_geog_hgt_m,s_geog_lat_deg,s_geog_lon_deg,
     +   s_geog_stdate,s_geog_endate,
     +   s_geog_stnname,i_geog_stnname_len)

      IMPLICIT NONE
c************************************************************************
c     Declare variables

      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: io

      CHARACTER(LEN=200)  :: s_pathandname

      INTEGER             :: i_cnt,i_pos(20)

      CHARACTER(LEN=300)  :: s_linget1
      CHARACTER(LEN=300)  :: s_lindat1(20)
      INTEGER             :: l_geog_full,l_geog
      CHARACTER(LEN=8)    :: s_geog_stnid(20)
      CHARACTER(LEN=8)    :: s_geog_hgt_m(20)
      CHARACTER(LEN=8)    :: s_geog_lat_deg(20),s_geog_lon_deg(20)
      CHARACTER(LEN=8)    :: s_geog_stdate(20),s_geog_endate(20)
      CHARACTER(LEN=50)   :: s_geog_stnname(20)
      INTEGER             :: i_geog_stnname_len(20)
      INTEGER             :: i_geog_semicolon_cnt(20)
c************************************************************************
      OPEN(UNIT=1,FILE=s_pathandname,FORM='formatted',
     +  STATUS='OLD',ACTION='READ') 

c     Read lines of data
      ii=1
      DO 
       READ(1,1000,IOSTAT=io) s_linget1
1000   FORMAT(a300)
   
       IF (io .GT. 0) THEN
        WRITE(*,*) 'Check input. Something went wrong'
        GOTO 100
       ELSE IF (io .LT. 0) THEN 
c        WRITE(*,*) 'end of file reached'
        GOTO 100
       ELSE
        s_lindat1(ii)=TRIM(ADJUSTL(s_linget1))

        ii=ii+1
       ENDIF

      ENDDO
100   CONTINUE

      CLOSE(UNIT=1)

      l_geog_full=ii-1
      l_geog=l_geog_full-1

c      print*,'l_geog=',l_geog

      IF (l_geog.GE.20) THEN 
       print*,'geog range exceeded, l_geog=',i,l_geog
       CALL SLEEP(5)
      ENDIF
c*****
c     Extract fields
      DO j=2,l_geog_full
       s_linget1=s_lindat1(j)

c      Find location of semicolons
       i_cnt=1
       DO i=1,300      !search 300 spaces
        IF (s_linget1(i:i).EQ.';') THEN
         i_pos(i_cnt)=i
         i_cnt=i_cnt+1
        ENDIF
       ENDDO

c       print*,'s_linget1=',s_linget1

       s_geog_stnid(j-1)  =s_linget1(1:i_pos(1)-1)
       s_geog_hgt_m(j-1)  =s_linget1(i_pos(1)+1:i_pos(2)-1)
       s_geog_lat_deg(j-1)=s_linget1(i_pos(2)+1:i_pos(3)-1)
       s_geog_lon_deg(j-1)=s_linget1(i_pos(3)+1:i_pos(4)-1)
       s_geog_stdate(j-1) =s_linget1(i_pos(4)+1:i_pos(5)-1)
       s_geog_endate(j-1) =s_linget1(i_pos(5)+1:i_pos(6)-1)
       s_geog_stnname(j-1)= 
     +   TRIM(ADJUSTL( s_linget1(i_pos(6)+1:i_pos(6)+50) ))
       i_geog_stnname_len(j-1)=LEN_TRIM(s_geog_stnname(j-1))

       i_geog_semicolon_cnt(j-1)=i_cnt-1

c       s_geog_hgt_m(j-1)  =s_linget(4:11)  !semicolon at 12
c       s_geog_lat_deg(j-1)=s_linget(13:20) !semicolon at 21 
c       s_geog_lon_deg(j-1)=s_linget(22:29) !semicolon at 30
c       s_geog_stdate(j-1) =s_linget(31:38) !semicolon at 39
c       s_geog_endate(j-1) =s_linget(40:47) !semicolon at 48
c       s_geog_stnname(j-1)=TRIM(ADJUSTL(s_linget(49:99)))
c       i_geog_stnname_len(j-1)=LEN_TRIM(s_geog_stnname(j-1))

c       print*,'j',j
c       print*,'s_geog_hgt_m='//s_geog_hgt_m(j-1)
c       print*,'s_geog_lat_deg='//s_geog_lat_deg(j-1)
c       print*,'s_geog_lon_deg='//s_geog_lon_deg(j-1)
c       print*,'s_geog_stdate='//s_geog_stdate(j-1)
c       print*,'s_geog_endate='//s_geog_endate(j-1)
c       print*,'s_geog_stnname='//s_geog_stnname(j-1)
      ENDDO


c      print*,'write out list'
c      print*,'l_geog=',l_geog
c      print*,'i_geog_semicolon_cnt=',
c     +  (i_geog_semicolon_cnt(j),j=1,l_geog)
c      print*,'s_geog_stdate=',
c     +  (s_geog_stdate(j),j=1,l_geog)
c      print*,'s_geog_endate=',
c     +  (s_geog_endate(j),j=1,l_geog)

c************************************************************************
c      print*,'just leaving get_geog_meta_dd.f'
   
      RETURN
      END
