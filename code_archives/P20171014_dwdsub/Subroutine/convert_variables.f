c     Subroutine to convert selected variables for output
c     AJ Kettle, Nov.1/2017

      SUBROUTINE convert_variables(l_mlent,j_sd,j_day,f_ndflag,
     +  ft_sd_airt_c,ft_sd_wetb_c,ft_sd_wdir_code,ft_sd_wspd_bft,
     +  ft_sd_pres_hpa,ft_sd_vprs_hpa,
     +  st_sd_wetb_ice,
     +  st_sd_time,st_sd_time_id,
     +  st_timeday,st_timeday_id,
     +  f_hght_m,f_lon_deg,

     +  ft_sd_airt_k,ft_sd_wetb_k,ft_sd_wdir_deg,ft_sd_wspd_ms,
     +  ft_sd_dewp_c,ft_sd_dewp_k,ft_sd_slpres_hpa,
     +  st_sd_timeutc,st_sd_timeutc_hh_mm_ss,
     +  st_timedayutc,st_timedayutc_hh_mm_ss)

      IMPLICIT NONE
c************************************************************************
      INTEGER             :: i,j,k,ii,jj,kk

      INTEGER             :: l_mlent
      INTEGER             :: j_sd
      INTEGER             :: j_day
      REAL                :: f_ndflag

c     Input variables 
      REAL                :: ft_sd_airt_c(l_mlent)
      REAL                :: ft_sd_wetb_c(l_mlent)
      REAL                :: ft_sd_wdir_code(l_mlent)
      REAL                :: ft_sd_wspd_bft(l_mlent)
      REAL                :: ft_sd_pres_hpa(l_mlent)
      REAL                :: ft_sd_vprs_hpa(l_mlent)
      CHARACTER(LEN=1)    :: st_sd_wetb_ice(l_mlent)
      REAL                :: f_hght_m
      REAL                :: f_lon_deg
      CHARACTER(LEN=4)    :: st_sd_time(l_mlent)
      CHARACTER(LEN=3)    :: st_sd_time_id(l_mlent)
      CHARACTER(LEN=4)    :: st_timeday(l_mlent)
      CHARACTER(LEN=3)    :: st_timeday_id(l_mlent)

c     Output variables
      REAL                :: ft_sd_airt_k(l_mlent)
      REAL                :: ft_sd_wetb_k(l_mlent)
      REAL                :: ft_sd_wdir_deg(l_mlent)
      REAL                :: ft_sd_wspd_ms(l_mlent)
      REAL                :: ft_sd_dewp_c(l_mlent)
      REAL                :: ft_sd_dewp_k(l_mlent)
      REAL                :: ft_sd_slpres_hpa(l_mlent)
      CHARACTER(LEN=4)    :: st_sd_timeutc(l_mlent)
      CHARACTER(LEN=8)    :: st_sd_timeutc_hh_mm_ss(l_mlent)
      CHARACTER(LEN=4)    :: st_timedayutc(l_mlent)
      CHARACTER(LEN=8)    :: st_timedayutc_hh_mm_ss(l_mlent)

c     Conversion table
      REAL                :: f_wdir_orig(34)
      REAL                :: f_wdir_conv(34)

c     Intermediate variables for calculation of dew point
      REAL                :: f_ew_hpa
      REAL                :: f_p_hpa
      REAL                :: f_dewp_c
      INTEGER             :: ii_iceflag
      CHARACTER(LEN=1)    :: s_wetb_iceflag

c     Intermediate variables for calculation sea level pressure
      REAL                :: f_e_hpa
      REAL                :: f_slpres_hpa
      REAL                :: f_airt_c


c************************************************************************
      print*,'just inside convert_variables.f'

c     Define 18 character wdir code

      f_wdir_orig(1)=-999.0    !no wind observation
      f_wdir_orig(2)=0.0       !no wind
      f_wdir_orig(3)=1.0       !
      f_wdir_orig(4)=2.0       !NNE
      f_wdir_orig(5)=3.0       !
      f_wdir_orig(6)=4.0       !NE
      f_wdir_orig(7)=5.0       !
      f_wdir_orig(8)=6.0       !ENE
      f_wdir_orig(9)=7.0       !
      f_wdir_orig(10)=8.0      !E
      f_wdir_orig(11)=9.0      !
      f_wdir_orig(12)=10.0     !ESE
      f_wdir_orig(13)=11.0     !
      f_wdir_orig(14)=12.0     !SE
      f_wdir_orig(15)=13.0     !
      f_wdir_orig(16)=14.0     !SSE
      f_wdir_orig(17)=15.0     !
      f_wdir_orig(18)=16.0     !S
      f_wdir_orig(19)=17.0     !
      f_wdir_orig(20)=18.0     !SSW
      f_wdir_orig(21)=19.0     !
      f_wdir_orig(22)=20.0     !SW
      f_wdir_orig(23)=21.0     !
      f_wdir_orig(24)=22.0     !WSW
      f_wdir_orig(25)=23.0     !
      f_wdir_orig(26)=24.0     !W
      f_wdir_orig(27)=25.0     !
      f_wdir_orig(28)=26.0     !WNW
      f_wdir_orig(29)=27.0     !
      f_wdir_orig(30)=28.0     !NW
      f_wdir_orig(31)=29.0     !
      f_wdir_orig(32)=30.0     !NNW
      f_wdir_orig(33)=31.0     !
      f_wdir_orig(34)=32.0     !N

      f_wdir_conv(1)=-999.0      !no wind observation
      f_wdir_conv(2)=0.0         !no wind
      f_wdir_conv(3)=11.25      
      f_wdir_conv(4)=22.5      
      f_wdir_conv(5)=33.75     
      f_wdir_conv(6)=45.0     
      f_wdir_conv(7)=56.25    
      f_wdir_conv(8)=67.5    
      f_wdir_conv(9)=78.75    
      f_wdir_conv(10)=90.0   
      f_wdir_conv(11)=101.25   
      f_wdir_conv(12)=112.5   
      f_wdir_conv(13)=123.75   
      f_wdir_conv(14)=135.0  
      f_wdir_conv(15)=146.25  
      f_wdir_conv(16)=157.5   
      f_wdir_conv(17)=168.75
      f_wdir_conv(18)=180.0
      f_wdir_conv(19)=191.25  
      f_wdir_conv(20)=202.5
      f_wdir_conv(21)=213.75 
      f_wdir_conv(22)=225.0  
      f_wdir_conv(23)=236.25 
      f_wdir_conv(24)=247.50
      f_wdir_conv(25)=258.75
      f_wdir_conv(26)=270.0
      f_wdir_conv(27)=281.25
      f_wdir_conv(28)=292.5
      f_wdir_conv(29)=303.75
      f_wdir_conv(30)=315.0
      f_wdir_conv(31)=326.25
      f_wdir_conv(32)=337.5
      f_wdir_conv(33)=348.75     
      f_wdir_conv(34)=0.0     

c      f_wdir_orig(1)=-999.0     !no wind observation
c      f_wdir_orig(2)=0.0      !no wind
c      f_wdir_orig(3)=2.0      !NNE
c      f_wdir_orig(4)=4.0      !NE
c      f_wdir_orig(5)=6.0      !ENE
c      f_wdir_orig(6)=8.0      !E
c      f_wdir_orig(7)=10.0      !ESE
c      f_wdir_orig(8)=12.0      !SE
c      f_wdir_orig(9)=14.0      !SSE
c      f_wdir_orig(10)=16.0     !S
c      f_wdir_orig(11)=18.0     !SSW
c      f_wdir_orig(12)=20.0     !SW
c      f_wdir_orig(13)=22.0     !WSW
c      f_wdir_orig(14)=24.0     !W
c      f_wdir_orig(15)=26.0     !WNW
c      f_wdir_orig(16)=28.0     !NW
c      f_wdir_orig(17)=30.0     !NNW
c      f_wdir_orig(18)=32.0     !N

c      f_wdir_conv(1)=-999.0      !no wind observation
c      f_wdir_conv(2)=0.0       !no wind
c      f_wdir_conv(3)=22.5      !NNE
c      f_wdir_conv(4)=45.0      !NE
c      f_wdir_conv(5)=67.5      !ENE
c      f_wdir_conv(6)=90.0      !E
c      f_wdir_conv(7)=112.5     !ESE
c      f_wdir_conv(8)=130.0     !SE
c      f_wdir_conv(9)=157.5     !SSE
c      f_wdir_conv(10)=180.0    !S
c      f_wdir_conv(11)=202.5    !SSW
c      f_wdir_conv(12)=225.0    !SW
c      f_wdir_conv(13)=247.5    !WSW
c      f_wdir_conv(14)=270.0    !W
c      f_wdir_conv(15)=292.5    !WNW
c      f_wdir_conv(16)=315.0    !NW
c      f_wdir_conv(17)=337.5    !NNW
c      f_wdir_conv(18)=0.0      !N

c************************************************************************
c     Initialize converted variables with ndflags

      DO i=1,l_mlent
       ft_sd_airt_k(i)  =f_ndflag
       ft_sd_wetb_k(i)  =f_ndflag
       ft_sd_wdir_deg(i)=f_ndflag
       ft_sd_wspd_ms(i) =f_ndflag
      ENDDO
c************************************************************************
c     Convert wspd

      DO i=1,j_sd
       DO j=1,34 
        IF (ft_sd_wdir_code(i).EQ.f_wdir_orig(j)) THEN 
         ft_sd_wdir_deg(i)=f_wdir_conv(j)
         GOTO 10
        ENDIF
       ENDDO

       print*,'emergency stop, convert variables'
       print*,'ft_sd_wdir_code(i)=',ft_sd_wdir_code(i)
       CALL SLEEP(5)

10     CONTINUE
      ENDDO
c************************************************************************
c     Convert airt & wetb
      DO i=1,j_sd
       IF (ft_sd_airt_c(i).NE.f_ndflag) THEN
        ft_sd_airt_k(i)  =273.15+ft_sd_airt_c(i)
       ENDIF
       IF (ft_sd_wetb_c(i).NE.f_ndflag) THEN
        ft_sd_wetb_k(i)  =273.15+ft_sd_wetb_c(i)
       ENDIF
      ENDDO
c************************************************************************
c     Convert wspd
      DO i=1,j_sd
       IF (ft_sd_wspd_bft(i).NE.f_ndflag) THEN 
        ft_sd_wspd_ms(i)=0.836*ft_sd_wspd_bft(i)**(3.0/2.0)
       ENDIF
      ENDDO
c************************************************************************
c     Find dewpoint from stnpres & vpres
      ii_iceflag=0

      DO i=1,j_sd
       IF (ft_sd_vprs_hpa(i).NE.f_ndflag.AND.
     +     ft_sd_pres_hpa(i).NE.f_ndflag) THEN 
        f_ew_hpa=ft_sd_vprs_hpa(i)
        f_p_hpa =ft_sd_pres_hpa(i)
        s_wetb_iceflag=st_sd_wetb_ice(i)
c        CALL dewp_from_vpres_stnpres(f_ew_hpa,f_p_hpa,
c     +    f_dewp_c)
        CALL dewfrostp_from_vpres_spres(f_ew_hpa,f_p_hpa,
     +    s_wetb_iceflag, 
     +    f_dewp_c)
     
        ft_sd_dewp_c(i)=f_dewp_c
        ft_sd_dewp_k(i)=273.15+f_dewp_c

c        IF (st_sd_wetb_ice(i).EQ.'E') THEN 
c         ii_iceflag=ii_iceflag+1
cc         print*,'wetb_iceflag=',st_sd_wetb_ice(i)
cc         CALL SLEEP(1)
c        ENDIF

c        print*,'dewp,wetb,airt=',
c     +    ft_sd_dewp_c(i),ft_sd_wetb_c(i),ft_sd_airt_c(i)
c        CALL SLEEP(2)

       ENDIF
      ENDDO

c      print*,'ii_iceflag,j_sd=',ii_iceflag,j_sd
c************************************************************************
c     Convert station pressure to sea level pressure

      DO i=1,j_sd
       ft_sd_slpres_hpa(i)=f_ndflag

       f_p_hpa=ft_sd_pres_hpa(i)
       f_e_hpa=ft_sd_vprs_hpa(i)
       f_airt_c=ft_sd_airt_c(i)

       IF (f_p_hpa.EQ.f_ndflag.OR.f_e_hpa.EQ.f_ndflag.OR.
     +     f_airt_c.EQ.f_ndflag) THEN
        GOTO 12
       ENDIF

       CALL slpres_from_stnpres(f_p_hpa,f_e_hpa,f_hght_m,f_airt_c,
     +   f_slpres_hpa)
       ft_sd_slpres_hpa(i)=f_slpres_hpa            !added Nov29/2017
12     CONTINUE
      ENDDO
c************************************************************************
c     Convert all times to UTC - subdaily
      CALL convert_time_utc(l_mlent,j_sd,f_lon_deg,
     +   st_sd_time,st_sd_time_id,
     +   st_sd_timeutc,st_sd_timeutc_hh_mm_ss)

c     Convert all times to UTC - daily
      print*,'just before daily timestamp convert'
      CALL convert_time_utc(l_mlent,j_day,f_lon_deg,
     +   st_timeday,st_timeday_id,
     +   st_timedayutc,st_timedayutc_hh_mm_ss)

c************************************************************************
      RETURN
      END
