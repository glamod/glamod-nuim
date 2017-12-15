c     Subroutine to input data from one file
c     AJ_Kettle, Oct17/2017

      SUBROUTINE get_data_2file(s_directory,s_filename,
     +  l_mlen,f_ndflag,

     +  l_line3, 
     +  s_sd_year,s_sd_month,s_sd_day,s_sd_time,s_sd_time_id, 
     +  f_sd_pres_hpa,f_sd_airt_c,f_sd_wetb_c,
     +  f_sd_vprs_hpa,f_sd_relh_pc,f_sd_relhreg_pc,
     +  f_sd_wdir_code,f_sd_wspd_bft,f_sd_ccov_okta,
     +  f_sd_visi_code,f_sd_grdcnd_code,f_sd_ppt_mm,
     +  s_sd_pres_qc,s_sd_airt_qc,s_sd_wetb_qc,
     +  s_sd_vprs_qc,s_sd_relh_qc,s_sd_relhreg_qc,
     +  s_sd_wspdwdir_qc,s_sd_ccov_qc,s_sd_visi_qc,
     +  s_sd_grdcnd_qc,s_sd_ppt_qc,
     +  s_sd_wetb_ice,

     +  l_line,
     +  s_year,s_month,s_day,s_timeday,s_timeday_id,
     +  f_pres_dayavg_hpa,f_airt_daymax_c,f_airt_daymin_c,
     +  f_airt_range_c,f_boden_daymin_c,f_airt_dayavg_c,
     +  f_vprs_dayavg_hpa,f_relh_dayavg_pc,f_wspd_dayavg_bft,
     +  f_ccov_dayavg_okta,f_sundur_daytot_h,f_ppt_daytot_mm,
     +  f_snowcover_cm,f_snow_daytot_cm,f_wspd_daymax_ms,
     +  f_snowmelted_cm,f_we_snowmelted_mm,f_we_snowcover_mm)

      IMPLICIT NONE
c************************************************************************
      INTEGER             :: l_mlen 
      REAL                :: f_ndflag

      CHARACTER(LEN=300)  :: s_directory
      CHARACTER(LEN=300)  :: s_filename

      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: io      
      CHARACTER(LEN=300)  :: s_linget
      CHARACTER(LEN=300)  :: s_linsto(l_mlen)
      INTEGER             :: i_modulo

      INTEGER             :: i_len1,i_maxlen1
      INTEGER             :: l_line
      INTEGER             :: l_ex

      CHARACTER(LEN=5)    :: s_ndflag_m9999
      CHARACTER(LEN=4)    :: s_ndflag_m999
      CHARACTER(LEN=3)    :: s_ndflag_m99
      CHARACTER(LEN=2)    :: s_ndflag_m9

      CHARACTER(LEN=2)    :: s_kennung(l_mlen)
      CHARACTER(LEN=5)    :: s_stnnumber(l_mlen)
      CHARACTER(LEN=4)    :: s_year(l_mlen)
      CHARACTER(LEN=2)    :: s_month(l_mlen)
      CHARACTER(LEN=2)    :: s_day(l_mlen)
      CHARACTER(LEN=5)    :: s_pres1(l_mlen)
      CHARACTER(LEN=5)    :: s_pres2(l_mlen)
      CHARACTER(LEN=5)    :: s_pres3(l_mlen)
      CHARACTER(LEN=1)    :: s_pres1_qc(l_mlen)
      CHARACTER(LEN=1)    :: s_pres2_qc(l_mlen)
      CHARACTER(LEN=1)    :: s_pres3_qc(l_mlen)
      CHARACTER(LEN=5)    :: s_pres_dayavg(l_mlen)
      CHARACTER(LEN=4)    :: s_airt_daymax(l_mlen)
      CHARACTER(LEN=4)    :: s_airt_daymin(l_mlen)
      CHARACTER(LEN=3)    :: s_airt_range(l_mlen)
      CHARACTER(LEN=4)    :: s_boden_daymin(l_mlen)
      CHARACTER(LEN=4)    :: s_airt1(l_mlen)
      CHARACTER(LEN=4)    :: s_airt2(l_mlen)
      CHARACTER(LEN=4)    :: s_airt3(l_mlen)
      CHARACTER(LEN=1)    :: s_airt1_qc(l_mlen)
      CHARACTER(LEN=1)    :: s_airt2_qc(l_mlen)
      CHARACTER(LEN=1)    :: s_airt3_qc(l_mlen)
      CHARACTER(LEN=4)    :: s_airt_dayavg(l_mlen)
      CHARACTER(LEN=4)    :: s_wetb1(l_mlen)
      CHARACTER(LEN=4)    :: s_wetb2(l_mlen)
      CHARACTER(LEN=4)    :: s_wetb3(l_mlen)
      CHARACTER(LEN=1)    :: s_wetb1_qc(l_mlen)
      CHARACTER(LEN=1)    :: s_wetb2_qc(l_mlen)
      CHARACTER(LEN=1)    :: s_wetb3_qc(l_mlen)
      CHARACTER(LEN=1)    :: s_wetb1_ice(l_mlen)
      CHARACTER(LEN=1)    :: s_wetb2_ice(l_mlen)
      CHARACTER(LEN=1)    :: s_wetb3_ice(l_mlen)
      CHARACTER(LEN=4)    :: s_vprs1(l_mlen)
      CHARACTER(LEN=4)    :: s_vprs2(l_mlen)
      CHARACTER(LEN=4)    :: s_vprs3(l_mlen)
      CHARACTER(LEN=1)    :: s_vprs1_qc(l_mlen)
      CHARACTER(LEN=1)    :: s_vprs2_qc(l_mlen)
      CHARACTER(LEN=1)    :: s_vprs3_qc(l_mlen)
      CHARACTER(LEN=4)    :: s_vprs_dayavg(l_mlen)
      CHARACTER(LEN=3)    :: s_relh1(l_mlen)
      CHARACTER(LEN=3)    :: s_relh2(l_mlen)
      CHARACTER(LEN=3)    :: s_relh3(l_mlen)
      CHARACTER(LEN=1)    :: s_relh1_qc(l_mlen)
      CHARACTER(LEN=1)    :: s_relh2_qc(l_mlen)
      CHARACTER(LEN=1)    :: s_relh3_qc(l_mlen)
      CHARACTER(LEN=3)    :: s_relh_dayavg(l_mlen)
      CHARACTER(LEN=3)    :: s_relhreg1(l_mlen)
      CHARACTER(LEN=3)    :: s_relhreg2(l_mlen)
      CHARACTER(LEN=3)    :: s_relhreg3(l_mlen)
      CHARACTER(LEN=1)    :: s_relhreg1_qc(l_mlen)
      CHARACTER(LEN=1)    :: s_relhreg2_qc(l_mlen)
      CHARACTER(LEN=1)    :: s_relhreg3_qc(l_mlen)
      CHARACTER(LEN=2)    :: s_wdir1(l_mlen)
      CHARACTER(LEN=2)    :: s_wspd1(l_mlen)
      CHARACTER(LEN=2)    :: s_wdir2(l_mlen)
      CHARACTER(LEN=2)    :: s_wspd2(l_mlen)
      CHARACTER(LEN=2)    :: s_wdir3(l_mlen)
      CHARACTER(LEN=2)    :: s_wspd3(l_mlen)
      CHARACTER(LEN=1)    :: s_wspdwdir1_qc(l_mlen)
      CHARACTER(LEN=1)    :: s_wspdwdir2_qc(l_mlen)
      CHARACTER(LEN=1)    :: s_wspdwdir3_qc(l_mlen)
      CHARACTER(LEN=3)    :: s_wspd_dayavg(l_mlen)
      CHARACTER(LEN=2)    :: s_ccov1(l_mlen)
      CHARACTER(LEN=2)    :: s_ccov2(l_mlen)
      CHARACTER(LEN=2)    :: s_ccov3(l_mlen)
      CHARACTER(LEN=1)    :: s_ccov1_qc(l_mlen)
      CHARACTER(LEN=1)    :: s_ccov2_qc(l_mlen)
      CHARACTER(LEN=1)    :: s_ccov3_qc(l_mlen)
      CHARACTER(LEN=3)    :: s_ccov_dayavg(l_mlen)
      CHARACTER(LEN=3)    :: s_sundur_daytot(l_mlen)
      CHARACTER(LEN=2)    :: s_visi1(l_mlen)
      CHARACTER(LEN=2)    :: s_visi2(l_mlen)
      CHARACTER(LEN=2)    :: s_visi3(l_mlen)
      CHARACTER(LEN=1)    :: s_visi1_qc(l_mlen)
      CHARACTER(LEN=1)    :: s_visi2_qc(l_mlen)
      CHARACTER(LEN=1)    :: s_visi3_qc(l_mlen)
      CHARACTER(LEN=2)    :: s_grdcnd1(l_mlen)
      CHARACTER(LEN=2)    :: s_grdcnd2(l_mlen)
      CHARACTER(LEN=2)    :: s_grdcnd3(l_mlen)
      CHARACTER(LEN=1)    :: s_grdcnd1_qc(l_mlen)
      CHARACTER(LEN=1)    :: s_grdcnd2_qc(l_mlen)
      CHARACTER(LEN=1)    :: s_grdcnd3_qc(l_mlen)
      CHARACTER(LEN=4)    :: s_ppt1(l_mlen)
      CHARACTER(LEN=4)    :: s_ppt2(l_mlen)
      CHARACTER(LEN=4)    :: s_ppt3(l_mlen)
      CHARACTER(LEN=1)    :: s_ppt1_qc(l_mlen)
      CHARACTER(LEN=1)    :: s_ppt2_qc(l_mlen)
      CHARACTER(LEN=1)    :: s_ppt3_qc(l_mlen)
      CHARACTER(LEN=4)    :: s_ppt_daytot(l_mlen)
      CHARACTER(LEN=3)    :: s_snowcover(l_mlen)
      CHARACTER(LEN=3)    :: s_snow_daytot(l_mlen)
      CHARACTER(LEN=3)    :: s_wspd_daymax(l_mlen)
      CHARACTER(LEN=4)    :: s_snowmelted(l_mlen)
      CHARACTER(LEN=5)    :: s_we_snowmelted(l_mlen)
      CHARACTER(LEN=5)    :: s_we_snowcover(l_mlen)

      CHARACTER(LEN=4)    :: s_year1(l_mlen)
      CHARACTER(LEN=4)    :: s_year2(l_mlen)
      CHARACTER(LEN=4)    :: s_year3(l_mlen)
      CHARACTER(LEN=2)    :: s_month1(l_mlen)
      CHARACTER(LEN=2)    :: s_month2(l_mlen)
      CHARACTER(LEN=2)    :: s_month3(l_mlen)
      CHARACTER(LEN=2)    :: s_day1(l_mlen)
      CHARACTER(LEN=2)    :: s_day2(l_mlen)
      CHARACTER(LEN=2)    :: s_day3(l_mlen)
      CHARACTER(LEN=4)    :: s_time1(l_mlen)
      CHARACTER(LEN=4)    :: s_time2(l_mlen)
      CHARACTER(LEN=4)    :: s_time3(l_mlen)
      CHARACTER(LEN=3)    :: s_time_id1(l_mlen)
      CHARACTER(LEN=3)    :: s_time_id2(l_mlen)
      CHARACTER(LEN=3)    :: s_time_id3(l_mlen)

      CHARACTER(LEN=4)    :: s_timeday(l_mlen)
      CHARACTER(LEN=3)    :: s_timeday_id(l_mlen)

      INTEGER             :: ii_kl,ii_kx,ii_kk,ii_kf,ii_kg

c     Variables to string data
      INTEGER             :: l_line3
      CHARACTER(LEN=4)    :: s_sd_year(l_mlen)
      CHARACTER(LEN=2)    :: s_sd_month(l_mlen) 
      CHARACTER(LEN=2)    :: s_sd_day(l_mlen) 
      CHARACTER(LEN=4)    :: s_sd_time(l_mlen)
      CHARACTER(LEN=3)    :: s_sd_time_id(l_mlen)
      CHARACTER(LEN=5)    :: s_sd_pres(l_mlen)
      CHARACTER(LEN=4)    :: s_sd_airt(l_mlen)
      CHARACTER(LEN=4)    :: s_sd_wetb(l_mlen)
      CHARACTER(LEN=4)    :: s_sd_vprs(l_mlen)
      CHARACTER(LEN=3)    :: s_sd_relh(l_mlen)
      CHARACTER(LEN=3)    :: s_sd_relhreg(l_mlen)
      CHARACTER(LEN=2)    :: s_sd_wdir(l_mlen)
      CHARACTER(LEN=2)    :: s_sd_wspd(l_mlen)
      CHARACTER(LEN=2)    :: s_sd_ccov(l_mlen)
      CHARACTER(LEN=2)    :: s_sd_visi(l_mlen)
      CHARACTER(LEN=2)    :: s_sd_grdcnd(l_mlen)
      CHARACTER(LEN=4)    :: s_sd_ppt(l_mlen)

      CHARACTER(LEN=1)    :: s_sd_pres_qc(l_mlen)
      CHARACTER(LEN=1)    :: s_sd_airt_qc(l_mlen)
      CHARACTER(LEN=1)    :: s_sd_wetb_qc(l_mlen)
      CHARACTER(LEN=1)    :: s_sd_vprs_qc(l_mlen)
      CHARACTER(LEN=1)    :: s_sd_relh_qc(l_mlen)
      CHARACTER(LEN=1)    :: s_sd_relhreg_qc(l_mlen)
      CHARACTER(LEN=1)    :: s_sd_wspdwdir_qc(l_mlen)
      CHARACTER(LEN=1)    :: s_sd_ccov_qc(l_mlen)
      CHARACTER(LEN=1)    :: s_sd_visi_qc(l_mlen)
      CHARACTER(LEN=1)    :: s_sd_grdcnd_qc(l_mlen)
      CHARACTER(LEN=1)    :: s_sd_ppt_qc(l_mlen)

      CHARACTER(LEN=1)    :: s_sd_wetb_ice(l_mlen)

      CHARACTER(LEN=5)    :: s_test
      REAL                :: f_test

      REAL                :: f_year(l_mlen)

c     Subdaily string
      REAL                :: f_sd_pres_hpa(l_mlen)
      REAL                :: f_sd_airt_c(l_mlen)
      REAL                :: f_sd_wetb_c(l_mlen)
      REAL                :: f_sd_vprs_hpa(l_mlen)
      REAL                :: f_sd_relh_pc(l_mlen)
      REAL                :: f_sd_relhreg_pc(l_mlen)
      REAL                :: f_sd_wdir_code(l_mlen)
      REAL                :: f_sd_wspd_bft(l_mlen)
      REAL                :: f_sd_ccov_okta(l_mlen)
      REAL                :: f_sd_visi_code(l_mlen)
      REAL                :: f_sd_grdcnd_code(l_mlen)
      REAL                :: f_sd_ppt_mm(l_mlen)

c     Daily string
      REAL                :: f_pres_dayavg_hpa(l_mlen)
      REAL                :: f_airt_daymax_c(l_mlen)
      REAL                :: f_airt_daymin_c(l_mlen)
      REAL                :: f_airt_range_c(l_mlen)
      REAL                :: f_boden_daymin_c(l_mlen)
      REAL                :: f_airt_dayavg_c(l_mlen)
      REAL                :: f_vprs_dayavg_hpa(l_mlen)
      REAL                :: f_relh_dayavg_pc(l_mlen)
      REAL                :: f_wspd_dayavg_bft(l_mlen)
      REAL                :: f_ccov_dayavg_okta(l_mlen)
      REAL                :: f_sundur_daytot_h(l_mlen)
      REAL                :: f_ppt_daytot_mm(l_mlen)
      REAL                :: f_snowcover_cm(l_mlen)
      REAL                :: f_snow_daytot_cm(l_mlen)
      REAL                :: f_wspd_daymax_ms(l_mlen)
      REAL                :: f_snowmelted_cm(l_mlen)
      REAL                :: f_we_snowmelted_mm(l_mlen)
      REAL                :: f_we_snowcover_mm(l_mlen)


c************************************************************************
      print*,'just inside get_data_2file'
c************************************************************************
      s_ndflag_m9999='-9999'
      s_ndflag_m999 ='-999'
      s_ndflag_m99  ='-99'
      s_ndflag_m9   ='-9'
c************************************************************************
c     Initialize line length for daily/subdaily sections
      l_line =-999
      l_line3=-999

c     Initialize maxlength variable
      i_maxlen1=0

      OPEN(UNIT=1,FILE=TRIM(s_directory)//TRIM(s_filename),
     +  FORM='formatted',
     +  STATUS='OLD',ACTION='READ') 

c     Read lines of data
      ii=1
      jj=1
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

c        print*,ii,MODULO(ii,2),s_linget        
c        CALL SLEEP(1) 

c        i_modulo=MODULO(ii,2)

c        IF (i_modulo.EQ.1) THEN 
         s_linsto(jj)=TRIM(ADJUSTL(s_linget))

         i_len1=LEN_TRIM(s_linget)
         i_maxlen1=MAX(i_maxlen1,i_len1)

c        print*,'ii...',ii,jj
c         CALL SLEEP(1)

         jj=jj+1

         IF (jj.GE.l_mlen) THEN 
          print*,'emergency stop get_data_2file, jj>l_mlen'
          CALL SLEEP(4)
         ENDIF

c        ENDIF

        ii=ii+1
       ENDIF

      ENDDO
100   CONTINUE

      CLOSE(UNIT=1)

      l_line=jj-2

c      print*,'ii,jj',ii,jj
c      print*,'l_line=',l_line,i_maxlen1
c      print*,'start lines'
c      print*,'s_linsto(1)=',s_linsto(1)
c      print*,'s_linsto(2)=',s_linsto(2)

c      print*,'end lines'
c      print*,'s_linsto(l_line-1)=',s_linsto(l_line-1)
c      print*,'s_linsto(l_line)=  ',s_linsto(l_line)
c      CALL SLEEP(4)
c************************************************************************
c     Get information from 1 line

      DO i=1,l_line 
       s_linget=s_linsto(i)

c       print*,'s_linget=',i,s_linget
c       call sleep(2)

       s_kennung(i)    =s_linget(1:2)
       s_stnnumber(i)  =s_linget(3:7)
       s_year(i)       =s_linget(8:11)
       s_month(i)      =s_linget(12:13)
       s_day(i)        =s_linget(14:15)
       s_pres1(i)      =s_linget(20:24)
       s_pres1_qc(i)   =s_linget(25:25)
       s_pres2(i)      =s_linget(26:30)
       s_pres2_qc(i)   =s_linget(31:31)
       s_pres3(i)      =s_linget(32:36)
       s_pres3_qc(i)   =s_linget(37:37)
       s_pres_dayavg(i)=s_linget(38:42)
       s_airt_daymax(i)=s_linget(44:47)
       s_airt_daymin(i)=s_linget(49:52)
       s_airt_range(i)  =s_linget(54:56)
       s_boden_daymin(i)=s_linget(58:61)
       s_airt1(i)       =s_linget(64:67)
       s_airt1_qc(i)    =s_linget(68:68)
       s_airt2(i)       =s_linget(69:72)
       s_airt2_qc(i)    =s_linget(73:73)
       s_airt3(i)       =s_linget(74:77)
       s_airt3_qc(i)    =s_linget(78:78)
       s_airt_dayavg(i) =s_linget(79:83)
       s_wetb1(i)       =s_linget(84:87)
       s_wetb1_ice(i)   =s_linget(88:88)
       s_wetb1_qc(i)    =s_linget(89:89)
       s_wetb2(i)       =s_linget(90:93)
       s_wetb2_ice(i)   =s_linget(94:94)
       s_wetb2_qc(i)    =s_linget(95:95)
       s_wetb3(i)       =s_linget(96:99)
       s_wetb3_ice(i)   =s_linget(100:100)
       s_wetb3_qc(i)    =s_linget(101:101)
       s_vprs1(i)       =s_linget(102:104)
       s_vprs1_qc(i)    =s_linget(105:105)
       s_vprs2(i)       =s_linget(106:108)
       s_vprs2_qc(i)    =s_linget(109:109)
       s_vprs3(i)       =s_linget(110:112)
       s_vprs3_qc(i)    =s_linget(113:113)
       s_vprs_dayavg(i) =s_linget(114:116)
       s_relh1(i)       =s_linget(118:120)
       s_relh1_qc(i)    =s_linget(121:121)
       s_relh2(i)       =s_linget(122:124)
       s_relh2_qc(i)    =s_linget(125:125)
       s_relh3(i)       =s_linget(126:128)
       s_relh3_qc(i)    =s_linget(129:129)
       s_relh_dayavg(i) =s_linget(130:132)
       s_relhreg1(i)    =s_linget(134:136)
       s_relhreg1_qc(i) =s_linget(137:137)
       s_relhreg2(i)    =s_linget(138:140)
       s_relhreg2_qc(i) =s_linget(141:141)
       s_relhreg3(i)    =s_linget(142:144)
       s_relhreg3_qc(i) =s_linget(145:145)
       s_wdir1(i)       =s_linget(146:147)
       s_wspd1(i)       =s_linget(148:149)
       s_wspdwdir1_qc(i)=s_linget(150:150)
       s_wdir2(i)       =s_linget(151:152)
       s_wspd2(i)       =s_linget(153:154)
       s_wspdwdir2_qc(i)=s_linget(155:155)
       s_wdir3(i)       =s_linget(156:157)
       s_wspd3(i)       =s_linget(158:159)
       s_wspdwdir3_qc(i)=s_linget(160:160)
       s_wspd_dayavg(i) =s_linget(161:163)
       s_ccov1(i)       =s_linget(165:166)
       s_ccov1_qc(i)    =s_linget(167:167)
       s_ccov2(i)       =s_linget(174:175)
       s_ccov2_qc(i)    =s_linget(176:176)
       s_ccov3(i)       =s_linget(183:184)
       s_ccov3_qc(i)    =s_linget(185:185)
       s_ccov_dayavg(i) =s_linget(192:194)
       s_sundur_daytot(i)  =s_linget(196:198)
       s_visi1(i)          =s_linget(201:202)
       s_visi1_qc(i)       =s_linget(203:203)
       s_visi2(i)          =s_linget(204:205)
       s_visi2_qc(i)       =s_linget(206:206)
       s_visi3(i)          =s_linget(207:208)
       s_visi3_qc(i)       =s_linget(209:209)
       s_grdcnd1(i)        =s_linget(210:211)
       s_grdcnd1_qc(i)     =s_linget(212:212)
       s_grdcnd2(i)        =s_linget(213:214)
       s_grdcnd2_qc(i)     =s_linget(215:215)
       s_grdcnd3(i)        =s_linget(216:217)
       s_grdcnd3_qc(i)     =s_linget(218:218)
       s_ppt1(i)           =s_linget(228:231)
       s_ppt1_qc(i)        =s_linget(233:233)
       s_ppt2(i)           =s_linget(234:237)
       s_ppt2_qc(i)        =s_linget(239:239)
       s_ppt3(i)           =s_linget(240:243)
       s_ppt3_qc(i)        =s_linget(245:245)
       s_ppt_daytot(i)     =s_linget(246:249)
       s_snowcover(i)      =s_linget(252:254)
       s_snow_daytot(i)    =s_linget(257:259)
       s_wspd_daymax(i)    =s_linget(262:264)
       s_snowmelted(i)     =s_linget(266:269)
       s_we_snowmelted(i)  =s_linget(271:275)
       s_we_snowcover(i)   =s_linget(277:281)

      ENDDO

      GOTO 10

      l_ex=1
      print*,'s_kennung',     (s_kennung(i),i=1,l_ex)
      print*,'s_stnnumber=',  (s_stnnumber(i),i=1,l_ex)
      print*,'s_year=',       (s_year(i),i=1,l_ex)
      print*,'s_month=',      (s_month(i),i=1,l_ex)
      print*,'s_day=',        (s_day(i),i=1,l_ex)
      print*,'s_pres1=',      (s_pres1(i),i=1,l_ex)
      print*,'s_pres2=',      (s_pres2(i),i=1,l_ex)
      print*,'s_pres3=',      (s_pres3(i),i=1,l_ex)
      print*,'s_pres_dayavg=',(s_pres_dayavg(i),i=1,l_ex)
      print*,'s_airt_daymax=',(s_airt_daymax(i),i=1,l_ex)
      print*,'s_airt_daymin=',(s_airt_daymin(i),i=1,l_ex)

      print*,'s_airt_range=',  (s_airt_range(i),i=1,l_ex) 
      print*,'s_boden_daymin=',(s_boden_daymin(i),i=1,l_ex)
      print*,'s_airt1=',       (s_airt1(i),i=1,l_ex) 
      print*,'s_airt2=',       (s_airt2(i),i=1,l_ex) 
      print*,'s_airt3=',       (s_airt3(i),i=1,l_ex) 
      print*,'s_airt_dayavg=', (s_airt_dayavg(i),i=1,l_ex) 
      print*,'s_wetb1=',       (s_wetb1(i),i=1,l_ex)  
      print*,'s_wetb2=',       (s_wetb2(i),i=1,l_ex) 
      print*,'s_wetb3=',       (s_wetb3(i),i=1,l_ex) 
      print*,'s_vprs1=',       (s_vprs1(i),i=1,l_ex) 
      print*,'s_vprs2=',       (s_vprs2(i),i=1,l_ex) 
      print*,'s_vprs3=',       (s_vprs3(i),i=1,l_ex)

      print*,'s_vprs_dayavg=', (s_vprs_dayavg(i),i=1,l_ex)
      print*,'s_relh1=',       (s_relh1(i),i=1,l_ex)      
      print*,'s_relh2=',       (s_relh2(i),i=1,l_ex)     
      print*,'s_relh3=',       (s_relh3(i),i=1,l_ex)       
      print*,'s_relh_dayavg=', (s_relh_dayavg(i),i=1,l_ex)
      print*,'s_relhreg1=',    (s_relhreg1(i),i=1,l_ex)      
      print*,'s_relhreg2=',    (s_relhreg2(i),i=1,l_ex)     
      print*,'s_relhreg3=',    (s_relhreg3(i),i=1,l_ex)       
      print*,'s_wdir1=',       (s_wdir1(i),i=1,l_ex)   
      print*,'s_wspd1=',       (s_wspd1(i),i=1,l_ex) 
      print*,'s_wdir2=',       (s_wdir2(i),i=1,l_ex) 
      print*,'s_wspd2=',       (s_wspd2(i),i=1,l_ex) 
      print*,'s_wdir3=',       (s_wdir3(i),i=1,l_ex) 
      print*,'s_wspd3=',       (s_wspd3(i),i=1,l_ex) 
      print*,'s_wspd_dayavg=', (s_wspd_dayavg(i),i=1,l_ex)
      print*,'s_ccov1=',       (s_ccov1(i),i=1,l_ex)
      print*,'s_ccov2=',       (s_ccov2(i),i=1,l_ex) 
      print*,'s_ccov3=',       (s_ccov3(i),i=1,l_ex) 
      print*,'s_ccov_dayavg=', (s_ccov_dayavg(i),i=1,l_ex)

      print*,'s_sundur_daytot=', (s_sundur_daytot(i),i=1,l_ex)  
      print*,'s_visi1=',         (s_visi1(i),i=1,l_ex)         
      print*,'s_visi2=',         (s_visi2(i),i=1,l_ex)         
      print*,'s_visi3=',         (s_visi3(i),i=1,l_ex)      
      print*,'s_grdcnd1=',       (s_grdcnd1(i),i=1,l_ex)     
      print*,'s_grdcnd2=',       (s_grdcnd2(i),i=1,l_ex)      
      print*,'s_grdcnd3=',       (s_grdcnd3(i),i=1,l_ex)       
      print*,'s_ppt1=',          (s_ppt1(i),i=1,l_ex)        
      print*,'s_ppt2=',          (s_ppt2(i),i=1,l_ex)         
      print*,'s_ppt3=',          (s_ppt3(i),i=1,l_ex)          
      print*,'s_ppt_daytot=',    (s_ppt_daytot(i),i=1,l_ex)  
      print*,'s_snowcover=',     (s_snowcover(i),i=1,l_ex)     
      print*,'s_snow_daytot=',   (s_snow_daytot(i),i=1,l_ex)     
      print*,'s_wspd_daymax=',   (s_wspd_daymax(i),i=1,l_ex)     
      print*,'s_snowmelted=',    (s_snowmelted(i),i=1,l_ex)      
      print*,'s_we_snowmelted=', (s_we_snowmelted(i),i=1,l_ex)    
      print*,'s_we_snowcover=',  (s_we_snowcover(i),i=1,l_ex)    

      print*,'QC flag check'
      print*,'s_pres1=',(s_pres1(i),i=1,5)
      print*,'s_pres2=',(s_pres2(i),i=1,5)
      print*,'s_pres3=',(s_pres3(i),i=1,5)
      print*,'s_pres1_qc=',(s_pres1_qc(i),i=1,5)
      print*,'s_pres2_qc=',(s_pres2_qc(i),i=1,5)
      print*,'s_pres3_qc=',(s_pres3_qc(i),i=1,5)

      print*,'s_airt1=',(s_airt1(i),i=1,5)
      print*,'s_airt2=',(s_airt2(i),i=1,5)
      print*,'s_airt3=',(s_airt3(i),i=1,5)
      print*,'s_airt1_qc=',(s_airt1_qc(i),i=1,5)
      print*,'s_airt2_qc=',(s_airt2_qc(i),i=1,5)
      print*,'s_airt3_qc=',(s_airt3_qc(i),i=1,5)

10    CONTINUE 

c      CALL SLEEP(10)
c************************************************************************
c     Convert year to float

      DO i=1,l_line 
       s_test         =TRIM(s_year(i))
        READ(s_test,*) f_test
        f_year(i)     =f_test/10.0
      ENDDO
c************************************************************************
c     Test kl/kx/kk
      ii_kl=0
      ii_kx=0
      ii_kk=0
      ii_kf=0
      ii_kg=0

      DO i=1,l_line                                   !KL: public set
       IF (TRIM(s_kennung(i)).EQ.'KL') THEN

        s_year1(i)   =s_year(i)
        s_year2(i)   =s_year(i)
        s_year3(i)   =s_year(i)
        s_month1(i)  =s_month(i)
        s_month2(i)  =s_month(i)
        s_month3(i)  =s_month(i)
        s_day1(i)    =s_day(i)
        s_day2(i)    =s_day(i)
        s_day3(i)    =s_day(i)

        IF (f_year(i).GT.1986) THEN 
         s_time1(i)   ='0730'
         s_time2(i)   ='1430'
         s_time3(i)   ='2130'
         s_time_id1(i)='MEZ'
         s_time_id2(i)='MEZ'
         s_time_id3(i)='MEZ'

         s_timeday(i) ='0730'
         s_timeday_id(i)='MEZ'
        ENDIF
        IF (f_year(i).LE.1986) THEN 
         s_time1(i)   ='0700'
         s_time2(i)   ='1400'
         s_time3(i)   ='2100'
         s_time_id1(i)='MOZ'
         s_time_id2(i)='MOZ'
         s_time_id3(i)='MOZ'

         s_timeday(i) ='0700'
         s_timeday_id(i)='MOZ'
        ENDIF
 
        ii_kl=ii_kl+1
        GOTO 20
       ENDIF
       IF (TRIM(s_kennung(i)).EQ.'KX') THEN               !KX: public set (format after Apr1 2001)

        s_year1(i)   =s_year(i)
        s_year2(i)   =s_year(i)
        s_year3(i)   =s_year(i)
        s_month1(i)  =s_month(i)
        s_month2(i)  =s_month(i)
        s_month3(i)  =s_month(i)
        s_day1(i)    =s_day(i)
        s_day2(i)    =s_day(i)
        s_day3(i)    =s_day(i)

        s_time1(i)   ='0600'
        s_time2(i)   ='1200'
        s_time3(i)   ='1800' 
        s_time_id1(i)='UTC'
        s_time_id2(i)='UTC'
        s_time_id3(i)='UTC'

        s_timeday(i) ='0600'
        s_timeday_id(i)='UTC'

        ii_kx=ii_kx+1
        GOTO 20
       ENDIF
c      special format for Projekt KLIDADIGI
       IF (TRIM(s_kennung(i)).EQ.'KK') THEN        !KK format: document sent by Walter

        s_year1(i)   =s_year(i)
        s_year2(i)   =s_year(i)
        s_year3(i)   =s_year(i)
        s_month1(i)  =s_month(i)
        s_month2(i)  =s_month(i)
        s_month3(i)  =s_month(i)
        s_day1(i)    =s_day(i)
        s_day2(i)    =s_day(i)
        s_day3(i)    =s_day(i)

        IF (f_year(i).GT.1986) THEN 
         s_time1(i)   ='0730'
         s_time2(i)   ='1430'
         s_time3(i)   ='2130'
         s_time_id1(i)='MEZ'
         s_time_id2(i)='MEZ'
         s_time_id3(i)='MEZ'

         s_timeday(i) ='0730'
         s_timeday_id(i)='MEZ'
        ENDIF
        IF (f_year(i).LE.1986) THEN 
         s_time1(i)   ='0700'
         s_time2(i)   ='1400'
         s_time3(i)   ='2100'
         s_time_id1(i)='MOZ'
         s_time_id2(i)='MOZ'
         s_time_id3(i)='MOZ'

         s_timeday(i) ='0700'
         s_timeday_id(i)='MOZ'
        ENDIF

        ii_kk=ii_kk+1
        GOTO 20
       ENDIF
       IF (TRIM(s_kennung(i)).EQ.'KF') THEN      !KF public data: eMD data 1949-1966

        s_year1(i)   =s_year(i)
        s_year2(i)   =s_year(i)
        s_year3(i)   =s_year(i)
        s_month1(i)  =s_month(i)
        s_month2(i)  =s_month(i)
        s_month3(i)  =s_month(i)
        s_day1(i)    =s_day(i)
        s_day2(i)    =s_day(i)
        s_day3(i)    =s_day(i)

        IF (f_year(i).GT.1961) THEN 
         s_time1(i)   ='0700'
         s_time2(i)   ='1400'
         s_time3(i)   ='2100'
         s_time_id1(i)='MEZ'
         s_time_id2(i)='MEZ'
         s_time_id3(i)='MEZ'

         s_timeday(i) ='0700'
         s_timeday_id(i)='MEZ'
        ENDIF
        IF (f_year(i).LE.1961) THEN 
         s_time1(i)   ='0700'
         s_time2(i)   ='1400'
         s_time3(i)   ='2100'
         s_time_id1(i)='MOZ'
         s_time_id2(i)='MOZ'
         s_time_id3(i)='MOZ'

         s_timeday(i) ='0700'
         s_timeday_id(i)='MOZ'
        ENDIF

        ii_kf=ii_kf+1
        GOTO 20
       ENDIF
       IF (TRIM(s_kennung(i)).EQ.'KG') THEN    !public site KG=eMD format 1967-1990

        s_year1(i)   =s_year(i)
        s_year2(i)   =s_year(i)
        s_year3(i)   =s_year(i)
        s_month1(i)  =s_month(i)
        s_month2(i)  =s_month(i)
        s_month3(i)  =s_month(i)
        s_day1(i)    =s_day(i)
        s_day2(i)    =s_day(i)
        s_day3(i)    =s_day(i)

        s_time1(i)   ='0600'
        s_time2(i)   ='1200'
        s_time3(i)   ='1800' 
        s_time_id1(i)='UTC'
        s_time_id2(i)='UTC'
        s_time_id3(i)='UTC'

        s_timeday(i) ='0600'
        s_timeday_id(i)='UTC'

        ii_kg=ii_kg+1
        GOTO 20
       ENDIF

       print*,'emergency stop',i,s_kennung(i)
       CALL SLEEP(1)

20     CONTINUE
      ENDDO

c      print*,'ii_kl=',ii_kl
c      print*,'ii_kx=',ii_kx
c      print*,'ii_kk=',ii_kk
c      print*,'ii_kf=',ii_kf
c      print*,'ii_kg=',ii_kg

c      print*,'k-sum,l_line=',ii_kl+ii_kx+ii_kk+ii_kf+ii_kg,l_line
c      CALL SLEEP(5)
c************************************************************************
c     String subdaily variables in row

      l_line3=3*l_line

      DO i=1,l_line 
       s_sd_year((i-1)*3+1)  =s_year1(i)
       s_sd_year((i-1)*3+2)  =s_year2(i)
       s_sd_year((i-1)*3+3)  =s_year3(i)

       s_sd_month((i-1)*3+1) =s_month1(i)
       s_sd_month((i-1)*3+2) =s_month2(i)
       s_sd_month((i-1)*3+3) =s_month3(i)

       s_sd_day((i-1)*3+1)   =s_day1(i)
       s_sd_day((i-1)*3+2)   =s_day2(i)
       s_sd_day((i-1)*3+3)   =s_day3(i)

       s_sd_time((i-1)*3+1)  =s_time1(i)
       s_sd_time((i-1)*3+2)  =s_time2(i)
       s_sd_time((i-1)*3+3)  =s_time3(i)

       s_sd_time_id((i-1)*3+1)=s_time_id1(i)
       s_sd_time_id((i-1)*3+2)=s_time_id2(i)
       s_sd_time_id((i-1)*3+3)=s_time_id3(i)
c******
c      DATA
       s_sd_pres((i-1)*3+1)  =s_pres1(i)
       s_sd_pres((i-1)*3+2)  =s_pres2(i)
       s_sd_pres((i-1)*3+3)  =s_pres3(i)

       s_sd_airt((i-1)*3+1)  =s_airt1(i)
       s_sd_airt((i-1)*3+2)  =s_airt2(i)
       s_sd_airt((i-1)*3+3)  =s_airt3(i)

       s_sd_wetb((i-1)*3+1)  =s_wetb1(i)
       s_sd_wetb((i-1)*3+2)  =s_wetb2(i)
       s_sd_wetb((i-1)*3+3)  =s_wetb3(i)

       s_sd_vprs((i-1)*3+1)  =s_vprs1(i)
       s_sd_vprs((i-1)*3+2)  =s_vprs2(i)
       s_sd_vprs((i-1)*3+3)  =s_vprs3(i)

       s_sd_relh((i-1)*3+1)  =s_relh1(i)
       s_sd_relh((i-1)*3+2)  =s_relh2(i)
       s_sd_relh((i-1)*3+3)  =s_relh3(i)

       s_sd_relhreg((i-1)*3+1)  =s_relhreg1(i)
       s_sd_relhreg((i-1)*3+2)  =s_relhreg2(i)
       s_sd_relhreg((i-1)*3+3)  =s_relhreg3(i)

       s_sd_wdir((i-1)*3+1)  =s_wdir1(i)
       s_sd_wdir((i-1)*3+2)  =s_wdir2(i)
       s_sd_wdir((i-1)*3+3)  =s_wdir3(i)

       s_sd_wspd((i-1)*3+1)  =s_wspd1(i)
       s_sd_wspd((i-1)*3+2)  =s_wspd2(i)
       s_sd_wspd((i-1)*3+3)  =s_wspd3(i)

       s_sd_ccov((i-1)*3+1)  =s_ccov1(i)
       s_sd_ccov((i-1)*3+2)  =s_ccov2(i)
       s_sd_ccov((i-1)*3+3)  =s_ccov3(i)

       s_sd_visi((i-1)*3+1)  =s_visi1(i)
       s_sd_visi((i-1)*3+2)  =s_visi2(i)
       s_sd_visi((i-1)*3+3)  =s_visi3(i)

       s_sd_grdcnd((i-1)*3+1)=s_grdcnd1(i)
       s_sd_grdcnd((i-1)*3+2)=s_grdcnd2(i)
       s_sd_grdcnd((i-1)*3+3)=s_grdcnd3(i)

       s_sd_ppt((i-1)*3+1)   =s_ppt1(i)
       s_sd_ppt((i-1)*3+2)   =s_ppt2(i)
       s_sd_ppt((i-1)*3+3)   =s_ppt3(i)
c******
c      QC
       s_sd_pres_qc((i-1)*3+1)  =s_pres1_qc(i)
       s_sd_pres_qc((i-1)*3+2)  =s_pres2_qc(i)
       s_sd_pres_qc((i-1)*3+3)  =s_pres3_qc(i)

       s_sd_airt_qc((i-1)*3+1)  =s_airt1_qc(i)
       s_sd_airt_qc((i-1)*3+2)  =s_airt2_qc(i)
       s_sd_airt_qc((i-1)*3+3)  =s_airt3_qc(i)

       s_sd_wetb_qc((i-1)*3+1)  =s_wetb1_qc(i)
       s_sd_wetb_qc((i-1)*3+2)  =s_wetb2_qc(i)
       s_sd_wetb_qc((i-1)*3+3)  =s_wetb3_qc(i)

       s_sd_vprs_qc((i-1)*3+1)  =s_vprs1_qc(i)
       s_sd_vprs_qc((i-1)*3+2)  =s_vprs2_qc(i)
       s_sd_vprs_qc((i-1)*3+3)  =s_vprs3_qc(i)

       s_sd_relh_qc((i-1)*3+1)  =s_relh1_qc(i)
       s_sd_relh_qc((i-1)*3+2)  =s_relh2_qc(i)
       s_sd_relh_qc((i-1)*3+3)  =s_relh3_qc(i)

       s_sd_relhreg_qc((i-1)*3+1)  =s_relhreg1_qc(i)
       s_sd_relhreg_qc((i-1)*3+2)  =s_relhreg2_qc(i)
       s_sd_relhreg_qc((i-1)*3+3)  =s_relhreg3_qc(i)

       s_sd_wspdwdir_qc((i-1)*3+1)  =s_wspdwdir1_qc(i)
       s_sd_wspdwdir_qc((i-1)*3+2)  =s_wspdwdir2_qc(i)
       s_sd_wspdwdir_qc((i-1)*3+3)  =s_wspdwdir3_qc(i)

       s_sd_ccov_qc((i-1)*3+1)  =s_ccov1_qc(i)
       s_sd_ccov_qc((i-1)*3+2)  =s_ccov2_qc(i)
       s_sd_ccov_qc((i-1)*3+3)  =s_ccov3_qc(i)

       s_sd_visi_qc((i-1)*3+1)  =s_visi1_qc(i)
       s_sd_visi_qc((i-1)*3+2)  =s_visi2_qc(i)
       s_sd_visi_qc((i-1)*3+3)  =s_visi3_qc(i)

       s_sd_grdcnd_qc((i-1)*3+1)=s_grdcnd1_qc(i)
       s_sd_grdcnd_qc((i-1)*3+2)=s_grdcnd2_qc(i)
       s_sd_grdcnd_qc((i-1)*3+3)=s_grdcnd3_qc(i)

       s_sd_ppt_qc((i-1)*3+1)   =s_ppt1_qc(i)
       s_sd_ppt_qc((i-1)*3+2)   =s_ppt2_qc(i)
       s_sd_ppt_qc((i-1)*3+3)   =s_ppt3_qc(i)
c******
c      Ice flag on wet bulb

       s_sd_wetb_ice((i-1)*3+1)  =s_wetb1_ice(i)
       s_sd_wetb_ice((i-1)*3+2)  =s_wetb2_ice(i)
       s_sd_wetb_ice((i-1)*3+3)  =s_wetb3_ice(i)
c******
      ENDDO 

c      print*,'l_line3=',l_line3
c      print*,'s_sd_pres=',(s_sd_pres(i),i=1,10) 
c      print*,'s_sd_pres=',(s_sd_pres(i),i=l_line3-10,l_line3) 
c************************************************************************
c     Initialize all floats with ndflags

      DO i=1,l_mlen 
       f_sd_pres_hpa(i)     =f_ndflag
       f_sd_airt_c(i)       =f_ndflag
       f_sd_wetb_c(i)       =f_ndflag
       f_sd_vprs_hpa(i)     =f_ndflag
       f_sd_relh_pc(i)      =f_ndflag
       f_sd_relhreg_pc(i)   =f_ndflag
       f_sd_wdir_code(i)    =f_ndflag
       f_sd_wspd_bft(i)     =f_ndflag
       f_sd_ccov_okta(i)    =f_ndflag
       f_sd_visi_code(i)    =f_ndflag
       f_sd_grdcnd_code(i)  =f_ndflag
       f_sd_ppt_mm(i)       =f_ndflag

       f_pres_dayavg_hpa(i) =f_ndflag
       f_airt_daymax_c(i)   =f_ndflag
       f_airt_daymin_c(i)   =f_ndflag
       f_airt_range_c(i)    =f_ndflag
       f_boden_daymin_c(i)  =f_ndflag
       f_airt_dayavg_c(i)   =f_ndflag
       f_vprs_dayavg_hpa(i) =f_ndflag
       f_relh_dayavg_pc(i)  =f_ndflag
       f_wspd_dayavg_bft(i) =f_ndflag
       f_ccov_dayavg_okta(i)=f_ndflag
       f_sundur_daytot_h(i) =f_ndflag
       f_ppt_daytot_mm(i)   =f_ndflag
       f_snowcover_cm(i)    =f_ndflag
       f_snow_daytot_cm(i)  =f_ndflag
       f_wspd_daymax_ms(i)  =f_ndflag
       f_snowmelted_cm(i)   =f_ndflag
       f_we_snowmelted_mm(i)=f_ndflag
       f_we_snowcover_mm(i) =f_ndflag
      ENDDO
c************************************************************************
c     Convert subdaily variables to float

      DO i=1,l_line3

c      PRES ndflag='-9999'
       s_test         =TRIM(s_sd_pres(i))
       IF (s_test.NE.s_ndflag_m9999) THEN
c        print*,'i pres=',i,'xxx'//s_test//'xxx'
        READ(s_test,*) f_test
        f_sd_pres_hpa(i)   =f_test/10.0
       ENDIF
c       IF (s_test.NE.s_ndflag_m9999) THEN
c        print*,'P ndflag found'
c        CALL SLEEP(5)
c       ENDIF

c      AIRT ndflag='-999'
       s_test         =TRIM(s_sd_airt(i))
       IF (s_test.NE.s_ndflag_m999) THEN
c       print*,'i airt=',i,'xxx'//s_test//'xxx'
        READ(s_test,*) f_test
        f_sd_airt_c(i)   =f_test/10.0
       ENDIF

c      WETB ndflag='-999'
       s_test         =TRIM(s_sd_wetb(i))
       IF (s_test.NE.s_ndflag_m999) THEN
c       print*,'i wetb=',i,'xxx'//s_test//'xxx'
        READ(s_test,*) f_test
        f_sd_wetb_c(i)   =f_test/10.0
       ENDIF

c      VPRS ndflag='-99'
       s_test         =TRIM(s_sd_vprs(i))
       IF (s_test.NE.s_ndflag_m99) THEN
c       print*,'i vprs=',i,'xxx'//s_test//'xxx'
        READ(s_test,*) f_test
        f_sd_vprs_hpa(i)   =f_test/10.0
       ENDIF   

c      RELH ndflag='-99'
       s_test         =TRIM(s_sd_relh(i))
       IF (s_test.NE.s_ndflag_m99) THEN
c       print*,'i relh=',i,'xxx'//s_test//'xxx'
        READ(s_test,*) f_test
        f_sd_relh_pc(i)   =f_test
       ENDIF

c      RELHREG ndflag='-99'      
       s_test         =TRIM(s_sd_relhreg(i))
       IF (s_test.NE.s_ndflag_m99) THEN
c       print*,'i relhreg=',i,'xxx'//s_test//'xxx'
        READ(s_test,*) f_test
        f_sd_relhreg_pc(i)=f_test
       ENDIF

c      WDIR ndflag='-9'
       s_test         =TRIM(s_sd_wdir(i))
       IF (s_test.NE.s_ndflag_m9) THEN
c       print*,'i wdir=',i,'xxx'//s_test//'xxx'
        READ(s_test,*) f_test
        f_sd_wdir_code(i)   =f_test
       ENDIF

c      WSPD ndflag='-9'
       s_test         =TRIM(s_sd_wspd(i))
       IF (s_test.NE.s_ndflag_m9) THEN
c       print*,'i wspd=',i,'xxx'//s_test//'xxx'
        READ(s_test,*) f_test
        f_sd_wspd_bft(i)   =f_test
       ENDIF

c      CCOV ndflag='-9'
       s_test         =TRIM(s_sd_ccov(i))
       IF (s_test.NE.s_ndflag_m9) THEN
        READ(s_test,*) f_test
        f_sd_ccov_okta(i)   =f_test
       ENDIF

c      VISI ndflag='-9'
       s_test         =TRIM(s_sd_visi(i))
       IF (s_test.NE.s_ndflag_m9) THEN
c       print*,'i visi=',i,'xxx'//s_test//'xxx'
        READ(s_test,*) f_test
        f_sd_visi_code(i)   =f_test
       ENDIF

c      GRDCND ndflag='-9'
       s_test         =TRIM(s_sd_grdcnd(i))
       IF (s_test.NE.s_ndflag_m9) THEN
c       print*,'i grdcnd=',i,'xxx'//s_test//'xxx'
        READ(s_test,*) f_test
        f_sd_grdcnd_code(i) =f_test
       ENDIF

c      PPT ndflag='-999'
       s_test         =TRIM(s_sd_ppt(i))
       IF (s_test.NE.s_ndflag_m999) THEN
c       print*,'i ppt=',i,'xxx'//s_test//'xxx'
        READ(s_test,*) f_test
        f_sd_ppt_mm(i)   =f_test/10.0
       ENDIF

      ENDDO

c      print*,'cleared subdaily float conversion'
c************************************************************************
c     Convert daily variables float

      DO i=1,l_line

c      PRES_DAYAVG ndflag=-9999
       s_test         =TRIM(ADJUSTL(s_pres_dayavg(i)))
       IF (s_test.NE.s_ndflag_m9999) THEN
        READ(s_test,*) f_test
        f_pres_dayavg_hpa(i)   =f_test/10.0       !convert to hpa

c        IF (f_pres_dayavg_hpa(i).LT.0.0) THEN 
c         print*,'emergency stop, get_data_2file, dayavg_pres'
c         print*,'f_pres_dayavg_hpa(i)',f_pres_dayavg_hpa(i)
c         print*,'s_pres_dayavg(i)',    s_pres_dayavg(i)
c         print*,'f_test=',             f_test
c         print*,'s_test=',             s_test
c         print*,'l_line=',             l_line
c         CALL SLEEP(5)
c        ENDIF
       ENDIF

c      AIRT_DAYMAX ndflag=-999
       s_test         =TRIM(s_airt_daymax(i))
       IF (s_test.NE.s_ndflag_m999) THEN
        READ(s_test,*) f_test
        f_airt_daymax_c(i)   =f_test/10.0
       ENDIF

c      AIRT_DAYMIN ndflag=-999
       s_test         =TRIM(s_airt_daymin(i))
       IF (s_test.NE.s_ndflag_m999) THEN
        READ(s_test,*) f_test
        f_airt_daymin_c(i)   =f_test/10.0
       ENDIF 

c      AIRT_RANGE ndflag=-99
       s_test         =TRIM(s_airt_range(i))
       IF (s_test.NE.s_ndflag_m99) THEN
        READ(s_test,*) f_test
        f_airt_range_c(i)   =f_test/10.0
       ENDIF

c      BODEN_DAYMIN ndflag=-999
       s_test         =TRIM(s_boden_daymin(i))
       IF (s_test.NE.s_ndflag_m999) THEN
        READ(s_test,*) f_test
        f_boden_daymin_c(i)   =f_test/10.0
       ENDIF

c      AIRT_DAYAVG ndflag=-999
       s_test         =TRIM(s_airt_dayavg(i))
       IF (s_test.NE.s_ndflag_m999) THEN
        READ(s_test,*) f_test
        f_airt_dayavg_c(i)   =f_test/10.0
       ENDIF

c      VPRS_DAYAVG ndflag=-99
       s_test         =TRIM(s_vprs_dayavg(i))
       IF (s_test.NE.s_ndflag_m99) THEN
        READ(s_test,*) f_test
        f_vprs_dayavg_hpa(i)   =f_test/10.0
       ENDIF

c      RELH_DAYAVG ndflag=-99
       s_test         =TRIM(s_relh_dayavg(i))
       IF (s_test.NE.s_ndflag_m99) THEN
        READ(s_test,*) f_test
        f_relh_dayavg_pc(i)   =f_test
       ENDIF

c      WSPD_DAYAVG ndflag=-99
       s_test         =TRIM(s_wspd_dayavg(i))
       IF (s_test.NE.s_ndflag_m99) THEN
        READ(s_test,*) f_test
        f_wspd_dayavg_bft(i)   =f_test/10.0
       ENDIF

c      CCOV_DAYAVG ndflag=-99
       s_test         =TRIM(s_ccov_dayavg(i))
       IF (s_test.NE.s_ndflag_m99) THEN
        READ(s_test,*) f_test
        f_ccov_dayavg_okta(i)   =f_test/10.0
       ENDIF

c      SUNDUR_DAYTOT ndflag=-99
       s_test         =TRIM(s_sundur_daytot(i))
       IF (s_test.NE.s_ndflag_m99) THEN
        READ(s_test,*) f_test
        f_sundur_daytot_h(i)   =f_test/10.0
       ENDIF

c      PPT_DAYTOT ndflag=-999
       s_test         =TRIM(s_ppt_daytot(i))
       IF (s_test.NE.s_ndflag_m999) THEN
        READ(s_test,*) f_test
        f_ppt_daytot_mm(i)   =f_test/10.0
       ENDIF

c      SNOWCOVER ndflag=-99
       s_test         =TRIM(s_snowcover(i))
       IF (s_test.NE.s_ndflag_m99) THEN
        READ(s_test,*) f_test
        f_snowcover_cm(i)   =f_test
       ENDIF

c      SNOW_DAYTOT ndflag=-99
       s_test         =TRIM(s_snow_daytot(i))
       IF (s_test.NE.s_ndflag_m99) THEN
        READ(s_test,*) f_test
        f_snow_daytot_cm(i)   =f_test
       ENDIF

c      WSPD_DAYMAX ndflag=-99
       s_test         =TRIM(s_wspd_daymax(i))
       IF (s_test.NE.s_ndflag_m99) THEN
        READ(s_test,*) f_test
        f_wspd_daymax_ms(i)   =f_test/10.0
       ENDIF

c      SNOWMELTED ndflag=-999
       s_test         =TRIM(s_snowmelted(i))
       IF (s_test.NE.s_ndflag_m999) THEN
        READ(s_test,*) f_test
        f_snowmelted_cm(i)   =f_test
       ENDIF

c      WE_SNOWMELTED ndflag=-9999
       s_test         =TRIM(s_we_snowmelted(i))
       IF (s_test.NE.s_ndflag_m9999) THEN
        READ(s_test,*) f_test
        f_we_snowmelted_mm(i)   =f_test/10.0
       ENDIF

c      WE_SNOWCOVER ndflag=-9999
       s_test         =TRIM(s_we_snowcover(i))
       IF (s_test.NE.s_ndflag_m9999) THEN
        READ(s_test,*) f_test
        f_we_snowcover_mm(i)   =f_test/10.0
       ENDIF

      ENDDO

c      print*,'cleared daily float conversion'
c************************************************************************
c************************************************************************
      print*,'cleared get_data_2file'

      RETURN
      END