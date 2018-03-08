c     Subroutine to read geographic location metadata
c     AJ_Kettle, Nov15/2017

      SUBROUTINE get_data2(s_pathandname,l_mlent,
     +  s_ndflag,i_ndflag,f_ndflag,
     +  l_datalines,s_vec_stnnum,
     +  s_vec_date,s_vec_time,
     +  f_vec_airt_c,f_vec_rain_mm,f_vec_wspd_kt,f_vec_slpr_hpa,
     +  f_vec_sunshine_h,f_vec_relh_pc,f_vec_cldcov_okta)

      IMPLICIT NONE
c************************************************************************
c     Declare variables

      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: io

      INTEGER             :: l_mlent
      CHARACTER(LEN=300)  :: s_pathandname
      CHARACTER(LEN=4)    :: s_ndflag
      INTEGER             :: i_ndflag
      REAL                :: f_ndflag

      CHARACTER(LEN=300)  :: s_linget1
      CHARACTER(LEN=300)  :: s_vec_line(l_mlent)
      INTEGER             :: l_lines

      INTEGER             :: i_linelen
      INTEGER             :: i_commacnt
      INTEGER             :: i_commapos(30)
      INTEGER             :: i_fieldcnt
      INTEGER             :: i_eof
      CHARACTER(LEN=20)   :: s_contentfull(30)

      CHARACTER(LEN=8)    :: s_vec_stnnum(l_mlent)          !1
      CHARACTER(LEN=20)   :: s_vec_datefull(l_mlent)        !2
      CHARACTER(LEN=11)   :: s_vec_airt_c(l_mlent)          !3
      CHARACTER(LEN=11)   :: s_vec_rain_mm(l_mlent)         !4
      CHARACTER(LEN=8)    :: s_vec_wspd_kt(l_mlent)         !5
      CHARACTER(LEN=11)   :: s_vec_slpr_hpa(l_mlent)        !6
      CHARACTER(LEN=11)   :: s_vec_sunshine_h(l_mlent)      !7
      CHARACTER(LEN=8)    :: s_vec_relh_pc(l_mlent)         !8
      CHARACTER(LEN=8)    :: s_vec_cldcov_okta(l_mlent)     !9
      INTEGER             :: l_datalines

      INTEGER             :: i_emptyflag_stnnum
      INTEGER             :: i_emptyflag_datefull
      INTEGER             :: i_emptyflag_airt
      INTEGER             :: i_emptyflag_rain
      INTEGER             :: i_emptyflag_wspd
      INTEGER             :: i_emptyflag_slpr
      INTEGER             :: i_emptyflag_sunshine
      INTEGER             :: i_emptyflag_relh
      INTEGER             :: i_emptyflag_cldcov

      INTEGER             :: i_len_stnnum(l_mlent)
      INTEGER             :: i_len_datefull(l_mlent)
      INTEGER             :: i_len_airt(l_mlent)
      INTEGER             :: i_len_rain(l_mlent)
      INTEGER             :: i_len_wspd(l_mlent)
      INTEGER             :: i_len_slpr(l_mlent)
      INTEGER             :: i_len_sunshine(l_mlent)
      INTEGER             :: i_len_relh(l_mlent)
      INTEGER             :: i_len_cldcov(l_mlent)

      REAL                :: f_vec_airt_c(l_mlent)          !3
      REAL                :: f_vec_rain_mm(l_mlent)         !4
      REAL                :: f_vec_wspd_kt(l_mlent)         !5
      REAL                :: f_vec_slpr_hpa(l_mlent)        !6
      REAL                :: f_vec_sunshine_h(l_mlent)      !7
      REAL                :: f_vec_relh_pc(l_mlent)         !8
      REAL                :: f_vec_cldcov_okta(l_mlent)     !9

      CHARACTER(LEN=2)    :: s_test2
      CHARACTER(LEN=8)    :: s_test8
      CHARACTER(LEN=11)   :: s_test11
      INTEGER             :: i_test
      REAL                :: f_test

c     Resolve date/time stamp
      CHARACTER(LEN=2)    :: s_day
      CHARACTER(LEN=3)    :: s_monthword
      CHARACTER(LEN=2)    :: s_monthnum
      CHARACTER(LEN=4)    :: s_year
      CHARACTER(LEN=2)    :: s_hour
      CHARACTER(LEN=2)    :: s_minute
      CHARACTER(LEN=2)    :: s_second
      CHARACTER(LEN=3)    :: s_template_monword(12)
      CHARACTER(LEN=2)    :: s_template_monnum(12)

      CHARACTER(LEN=10)   :: s_vec_date(l_mlent)
      CHARACTER(LEN=8)    :: s_vec_time(l_mlent)
c************************************************************************
      print*,'just entered get_data2'

c     Initialize i_lineflag to 1
c      i_datepos(1)=0
c      i_datepos(2)=0
c      i_datecnt=0

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
        s_vec_line(ii)=TRIM(ADJUSTL(s_linget1))

        IF (s_linget1(1:1).EQ.'(') THEN
         i_eof=ii-2
        ENDIF

c        IF (i_lineflag.EQ.1) THEN 
c         IF (ii_accum.GT.0) THEN 
c        IF (TRIM(ADJUSTL(s_linget1(3:3))).EQ.'/') THEN 
c        IF (ii.GT.18) THEN 
c         s_vec_line(ii_accum)=TRIM(s_linget1)
c         ii_accum=ii_accum+1
c        ENDIF

        ii=ii+1
       ENDIF

      ENDDO
100   CONTINUE

      CLOSE(UNIT=1)

      l_lines=ii-1
c      l_datalines=ii_accum-1
c      print*,'l_lines=',l_lines
cc      print*,'i_datecnt=',i_datecnt
cc      print*,'i_datepos=',i_datepos(1),i_datepos(2)
c      print*,'line12=',TRIM(s_vec_line(12))
c      print*,'line13=',TRIM(s_vec_line(13))
c      print*,'line end=',TRIM(s_vec_line(i_eof))
c************************************************************************
c     Extract fields from lines
      ii=0

      DO i=13,i_eof

       s_linget1=s_vec_line(i)
       i_linelen=LEN_TRIM(s_linget1)

c       print*,'s_linget1=',TRIM(s_linget1)
c       print*,'i_linelen=',i_linelen
c       call sleep(1)

       i_commacnt=0
       DO j=1,i_linelen
        IF (s_linget1(j:j).EQ.'|') THEN 
         i_commacnt=i_commacnt+1
         i_commapos(i_commacnt)=j
        ENDIF
       ENDDO 
       i_fieldcnt=i_commacnt+1
       
c       print*,'i_fieldcnt=',i_linelen,i_fieldcnt,i_commacnt
c       CALL SLEEP(1)

c      Extract full content
       DO j=1,i_commacnt
        s_contentfull(j)=s_linget1(i_commapos(j)+1:i_commapos(j+1)-1)
       ENDDO

c       print*,'s_contentfull=',(s_contentfull(j),j=1,i_commacnt)    
c       CALL SLEEP(1)

       ii=ii+1
       s_vec_stnnum(ii)     =s_contentfull(1)
       s_vec_datefull(ii)   =s_contentfull(2)
       s_vec_airt_c(ii)     =s_contentfull(3)
       s_vec_rain_mm(ii)    =s_contentfull(4)
       s_vec_wspd_kt(ii)    =s_contentfull(5)
       s_vec_slpr_hpa(ii)   =s_contentfull(6)
       s_vec_sunshine_h(ii) =s_contentfull(7)
       s_vec_relh_pc(ii)    =s_contentfull(8)
       s_vec_cldcov_okta(ii)=s_contentfull(9)

      ENDDO

      l_datalines=ii
      print*,'l_datalines=',ii
c************************************************************************
c     Flag empty fields

      i_emptyflag_stnnum   =0
      i_emptyflag_datefull =0
      i_emptyflag_airt     =0
      i_emptyflag_rain     =0
      i_emptyflag_wspd     =0
      i_emptyflag_slpr     =0
      i_emptyflag_sunshine =0
      i_emptyflag_relh     =0
      i_emptyflag_cldcov   =0

      DO i=1,l_datalines
       i_len_stnnum(i)  =LEN_TRIM(s_vec_stnnum(i)) 
       i_len_datefull(i)=LEN_TRIM(s_vec_datefull(i)) 
       i_len_airt(i)    =LEN_TRIM(s_vec_airt_c(i)) 
       i_len_rain(i)    =LEN_TRIM(s_vec_rain_mm(i)) 
       i_len_wspd(i)    =LEN_TRIM(s_vec_wspd_kt(i)) 
       i_len_slpr(i)    =LEN_TRIM(s_vec_slpr_hpa(i)) 
       i_len_sunshine(i)=LEN_TRIM(s_vec_sunshine_h(i)) 
       i_len_relh(i)    =LEN_TRIM(s_vec_relh_pc(i)) 
       i_len_cldcov(i)  =LEN_TRIM(s_vec_cldcov_okta(i)) 

c      Flag fields with missing data
       IF (i_len_stnnum(i).EQ.0) THEN 
        s_vec_stnnum(i)=s_ndflag
        i_emptyflag_stnnum=i_emptyflag_stnnum+1
       ENDIF
       IF (i_len_datefull(i).EQ.0) THEN 
        s_vec_datefull(i)=s_ndflag
        i_emptyflag_datefull=i_emptyflag_datefull+1
       ENDIF
       IF (i_len_airt(i).EQ.0) THEN 
        s_vec_airt_c(i)=s_ndflag
        i_emptyflag_airt=i_emptyflag_airt+1
       ENDIF
       IF (i_len_rain(i).EQ.0) THEN 
        s_vec_rain_mm(i)=s_ndflag
        i_emptyflag_rain=i_emptyflag_rain+1
       ENDIF
       IF (i_len_wspd(i).EQ.0) THEN 
        s_vec_wspd_kt(i)=s_ndflag
        i_emptyflag_wspd=i_emptyflag_wspd+1
       ENDIF
       IF (i_len_slpr(i).EQ.0) THEN 
        s_vec_slpr_hpa(i)=s_ndflag
        i_emptyflag_slpr=i_emptyflag_slpr+1
       ENDIF
       IF (i_len_sunshine(i).EQ.0) THEN 
        s_vec_sunshine_h(i)=s_ndflag
        i_emptyflag_sunshine=i_emptyflag_sunshine+1
       ENDIF
       IF (i_len_relh(i).EQ.0) THEN 
        s_vec_relh_pc(i)=s_ndflag
        i_emptyflag_relh=i_emptyflag_relh+1
       ENDIF
       IF (i_len_cldcov(i).EQ.0) THEN 
        s_vec_cldcov_okta(i)=s_ndflag
        i_emptyflag_cldcov=i_emptyflag_cldcov+1
       ENDIF
      ENDDO

c      print*,'i_emptyflag_stnnum=',  i_emptyflag_stnnum
c      print*,'i_emptyflag_datefull=',i_emptyflag_datefull
c      print*,'i_emptyflag_airt=',    i_emptyflag_airt
c      print*,'i_emptyflag_rain=',    i_emptyflag_rain
c      print*,'i_emptyflag_wspd=',    i_emptyflag_wspd
c      print*,'i_emptyflag_slpr=',    i_emptyflag_slpr
c      print*,'i_emptyflag_sunshine=',i_emptyflag_sunshine
c      print*,'i_emptyflag_relh=',    i_emptyflag_relh
c      print*,'i_emptyflag_cldcov=',  i_emptyflag_cldcov
c************************************************************************
c     COnvert from string to real
      DO i=1,l_datalines
       s_test11=s_vec_airt_c(i)
       READ(s_test11,*) f_test
       f_vec_airt_c(i)=f_test

       s_test11=s_vec_rain_mm(i)
       READ(s_test11,*) f_test
       f_vec_rain_mm(i)=f_test

       s_test8=s_vec_wspd_kt(i)
       READ(s_test8,*) f_test
       f_vec_wspd_kt(i)=f_test

       s_test11=s_vec_slpr_hpa(i)
       READ(s_test11,*) f_test
       f_vec_slpr_hpa(i)=f_test

       s_test11=s_vec_sunshine_h(i)
       READ(s_test11,*) f_test
       f_vec_sunshine_h(i)=f_test

       s_test8=s_vec_relh_pc(i)
       READ(s_test8,*) f_test
       f_vec_relh_pc(i)=f_test

       s_test8=s_vec_cldcov_okta(i)
       READ(s_test8,*) f_test
       f_vec_cldcov_okta(i)=f_test
      ENDDO
c************************************************************************
c     Declare template to translate monthword to month numbers
      s_template_monword(1)='jan'
      s_template_monword(2)='feb'
      s_template_monword(3)='mar'
      s_template_monword(4)='apr'
      s_template_monword(5)='may'
      s_template_monword(6)='jun'
      s_template_monword(7)='jul'
      s_template_monword(8)='aug'
      s_template_monword(9)='sep'
      s_template_monword(10)='oct'
      s_template_monword(11)='nov'
      s_template_monword(12)='dec'

      s_template_monnum(1)='01'
      s_template_monnum(2)='02'
      s_template_monnum(3)='03'
      s_template_monnum(4)='04'
      s_template_monnum(5)='05'
      s_template_monnum(6)='06'
      s_template_monnum(7)='07'
      s_template_monnum(8)='08'
      s_template_monnum(9)='09'
      s_template_monnum(10)='10'
      s_template_monnum(11)='11'
      s_template_monnum(12)='12'
c************************************************************************
c     Separate date string into date/time components

      DO i=1,l_datalines
       s_linget1=s_vec_datefull(i)

       s_day      =s_linget1(1:2)
       s_monthword=s_linget1(4:6)
       s_year     =s_linget1(8:11)
       s_hour     =s_linget1(13:14)
       s_minute   =s_linget1(16:17)
       s_second   =s_linget1(19:20)

       DO j=1,12 
        IF (s_monthword.EQ.s_template_monword(j)) THEN
         s_monthnum=s_template_monnum(j)
        ENDIF
       ENDDO

       s_vec_date(i)=s_day//'/'//s_monthnum//'/'//s_year
       s_vec_time(i)=s_hour//':'//s_minute//':'//s_second

c       print*,'s_day=',s_day
c       print*,'s_monthword=',s_monthword
c       print*,'s_year=',s_year
c       print*,'s_hour=',s_hour
c       print*,'s_minute=',s_minute
c       print*,'s_vec_date=',s_vec_date(i)
c       print*,'s_vec_time=',s_vec_time(i)
c       CALL SLEEP(1)

      ENDDO
c************************************************************************
c************************************************************************
      print*,'just leaving get_data2'

      RETURN
      END