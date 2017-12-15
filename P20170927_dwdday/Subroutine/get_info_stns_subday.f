c     Subroutine to get foundation info for stations
c     AJ_Kettle, Oct.19/2017

      SUBROUTINE get_info_stns_subday(s_pathandname,l_stnrecord,
     +  s_stke,s_stid,s_stdate,s_endate,s_hght,s_lat,s_lon,s_stnname,
     +  s_bundesland)

      IMPLICIT NONE
c************************************************************************
      CHARACTER(LEN=300)  :: s_pathandname

      INTEGER             :: l_stnrecord
      CHARACTER(LEN=5)    :: s_stke(100),s_stid(100)
      CHARACTER(LEN=8)    :: s_stdate(100),s_endate(100)
      CHARACTER(LEN=9)    :: s_hght(100)
      CHARACTER(LEN=10)   :: s_lat(100),s_lon(100)
      CHARACTER(LEN=25)   :: s_stnname(100),s_bundesland(100)

      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: io

      CHARACTER(LEN=300)  :: s_linget
      CHARACTER(LEN=300)  :: s_linsto(100)
      CHARACTER(LEN=2)    :: s_test2

      INTEGER             :: l_ex
c************************************************************************
      OPEN(UNIT=1,FILE=TRIM(s_pathandname),
     +  FORM='formatted',
     +  STATUS='OLD',ACTION='READ') 

      ii=1                      !counter for station lines

      DO 
       READ(1,1000,IOSTAT=io) s_linget
1000   FORMAT(a300)
   
       IF (io .GT. 0) THEN
        WRITE(*,*) 'Check input. Something went wrong'
        GOTO 100
       ELSE IF (io .LT. 0) THEN 
        WRITE(*,*) 'end of file reached'
        GOTO 100
       ELSE

        s_test2=s_linget(1:2)
        IF (s_test2.EQ.'10') THEN
         s_linsto(ii)=s_linget
         ii=ii+1
        ENDIF
       ENDIF
      ENDDO
100   CONTINUE
      CLOSE(unit=1)

      l_stnrecord=ii-1

c      print*,'l_stnrecord=',l_stnrecord
c************************************************************************
c     Extract columns from line

      DO i=1,l_stnrecord
       s_linget=s_linsto(i)

       s_stke(i)      =TRIM(s_linget(1:5))
       s_stid(i)      =TRIM(s_linget(7:11))
       s_stdate(i)    =TRIM(s_linget(13:20))
       s_endate(i)    =TRIM(s_linget(22:29))
       s_hght(i)      =TRIM(s_linget(31:39))
       s_lat(i)       =TRIM(s_linget(41:50))
       s_lon(i)       =TRIM(s_linget(52:61))
       s_stnname(i)   =TRIM(s_linget(63:87))
       s_bundesland(i)=TRIM(s_linget(89:113))
      ENDDO

      l_ex=1
c      print*,'s_stke=',  (s_stke(i),i=1,l_ex)
c      print*,'s_stid=',  (s_stid(i),i=1,l_ex)
c      print*,'s_stdate=',(s_stdate(i),i=1,l_ex)
c      print*,'s_endate=',(s_endate(i),i=1,l_ex)
c      print*,'s_hght=',  (s_hght(i),i=1,l_ex)
c      print*,'s_lat=',   (s_lat(i),i=1,l_ex)
c      print*,'s_lon=',   (s_lon(i),i=1,l_ex)
c      print*,'s_stnname=',   (s_stnname(i),i=1,l_ex)
c      print*,'s_bundesland=',(s_bundesland(i),i=1,l_ex)

c      DO i=1,l_stnrecord
c       print*,'i=',i,s_stke(i)
c      ENDDO
c************************************************************************
      RETURN
      END