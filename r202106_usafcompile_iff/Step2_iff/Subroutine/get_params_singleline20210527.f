c     Subroutine to get params from single file
c     AJ_Kettle, 30Mar2019; modified for truncated commacount
c     14Mar2020: used for USAF update

      SUBROUTINE get_params_singleline20210527(
     +  l_rgh_char,s_linget,
     +  i_commacnt,i_comma_pos,
     +  l_c1,l_c2,
     +  s_platformid,s_networktype,s_ncdc_ob_time,
     +  s_reporttypecode,s_latitude,s_longitude,s_platformheight,
     +  s_winddirection_deg,s_winddirection_qc,
     +  s_windspeed_ms,s_windspeed_qc,
     +  s_airtemperature_c,s_airtemperature_qc,
     +  s_dewpointtemperature_c,s_dewpointtemperature_qc,
     +  s_sealevelpressure_hpa,s_sealevelpressure_qc,
     +  s_stationpressure_hpa,s_stationpressure_qc)

      IMPLICIT NONE
c************************************************************************
c     Declare variables passed into program

      INTEGER             :: l_rgh_char
      CHARACTER(l_rgh_char)::s_linget
      INTEGER             :: i_commacnt
      INTEGER             :: i_comma_pos(200)

      INTEGER             :: l_c1
      INTEGER             :: l_c2

      CHARACTER(LEN=*)    :: s_platformid           !20
      CHARACTER(LEN=*)    :: s_networktype          !20  
      CHARACTER(LEN=*)    :: s_ncdc_ob_time         !14
      CHARACTER(LEN=*)    :: s_reporttypecode       !6
      CHARACTER(LEN=*)    :: s_latitude             !15
      CHARACTER(LEN=*)    :: s_longitude            !15
      CHARACTER(LEN=*)    :: s_platformheight       !15
      CHARACTER(LEN=l_c1) :: s_winddirection_deg    !10
      CHARACTER(LEN=l_c2) :: s_winddirection_qc     !10
      CHARACTER(LEN=l_c1) :: s_windspeed_ms         !10
      CHARACTER(LEN=l_c2) :: s_windspeed_qc         !10
      CHARACTER(LEN=l_c1) :: s_cloudceiling_m       !10
      CHARACTER(LEN=l_c2) :: s_cloudceiling_qc      !10
      CHARACTER(LEN=l_c1) :: s_visibility_m         !10
      CHARACTER(LEN=l_c2) :: s_visibility_qc        !10
      CHARACTER(LEN=l_c1) :: s_airtemperature_c     !10
      CHARACTER(LEN=l_c2) :: s_airtemperature_qc    !10
      CHARACTER(LEN=l_c1) :: s_dewpointtemperature_c  !10
      CHARACTER(LEN=l_c2) :: s_dewpointtemperature_qc !10
      CHARACTER(LEN=l_c1) :: s_sealevelpressure_hpa !10
      CHARACTER(LEN=l_c2) :: s_sealevelpressure_qc  !10

      CHARACTER(LEN=l_c1) :: s_observationperiodpp1_h
      CHARACTER(LEN=l_c2) :: s_observationperiodpp1_qc 
      CHARACTER(LEN=l_c1) :: s_precipamount1_mm
      CHARACTER(LEN=l_c2) :: s_precipamount1_qc   
      CHARACTER(LEN=l_c1) :: s_precipcondition1_dless  
      CHARACTER(LEN=l_c2) :: s_precipcondition1_qc
      CHARACTER(LEN=l_c1) :: s_observationperiodpp2_h
      CHARACTER(LEN=l_c2) :: s_observationperiodpp2_qc 
      CHARACTER(LEN=l_c1) :: s_precipamount2_mm
      CHARACTER(LEN=l_c2) :: s_precipamount2_qc   
      CHARACTER(LEN=l_c1) :: s_precipcondition2_dless  
      CHARACTER(LEN=l_c2) :: s_precipcondition2_qc
      CHARACTER(LEN=l_c1) :: s_observationperiodpp3_h
      CHARACTER(LEN=l_c2) :: s_observationperiodpp3_qc 
      CHARACTER(LEN=l_c1) :: s_precipamount3_mm
      CHARACTER(LEN=l_c2) :: s_precipamount3_qc   
      CHARACTER(LEN=l_c1) :: s_precipcondition3_dless  
      CHARACTER(LEN=l_c2) :: s_precipcondition3_qc
      CHARACTER(LEN=l_c1) :: s_observationperiodpp4_h
      CHARACTER(LEN=l_c2) :: s_observationperiodpp4_qc 
      CHARACTER(LEN=l_c1) :: s_precipamount4_mm
      CHARACTER(LEN=l_c2) :: s_precipamount4_qc   
      CHARACTER(LEN=l_c1) :: s_precipcondition4_dless  
      CHARACTER(LEN=l_c2) :: s_precipcondition4_qc

      CHARACTER(LEN=l_c1) :: s_precipamountsd_cm           !73
      CHARACTER(LEN=l_c2) :: s_precipamountsd_qc           !74
      CHARACTER(LEN=l_c1) :: s_depthwtrequiv_mm            !77
      CHARACTER(LEN=l_c2) :: s_depthwtrequiv_qc            !78

      CHARACTER(LEN=l_c1) :: s_precipamountsf1_cm
      CHARACTER(LEN=l_c2) :: s_precipamountsf1_qc   
      CHARACTER(LEN=l_c1) :: s_precipconditionsf1_dless  
      CHARACTER(LEN=l_c2) :: s_precipconditionsf1_qc
      CHARACTER(LEN=l_c1) :: s_observationperiodsf1_h
      CHARACTER(LEN=l_c2) :: s_observationperiodsf1_qc 
      CHARACTER(LEN=l_c1) :: s_precipamountsf2_cm
      CHARACTER(LEN=l_c2) :: s_precipamountsf2_qc   
      CHARACTER(LEN=l_c1) :: s_precipconditionsf2_dless  
      CHARACTER(LEN=l_c2) :: s_precipconditionsf2_qc
      CHARACTER(LEN=l_c1) :: s_observationperiodsf2_h
      CHARACTER(LEN=l_c2) :: s_observationperiodsf2_qc 
      CHARACTER(LEN=l_c1) :: s_precipamountsf3_cm
      CHARACTER(LEN=l_c2) :: s_precipamountsf3_qc   
      CHARACTER(LEN=l_c1) :: s_precipconditionsf3_dless  
      CHARACTER(LEN=l_c2) :: s_precipconditionsf3_qc
      CHARACTER(LEN=l_c1) :: s_observationperiodsf3_h
      CHARACTER(LEN=l_c2) :: s_observationperiodsf3_qc 
      CHARACTER(LEN=l_c1) :: s_precipamountsf4_cm
      CHARACTER(LEN=l_c2) :: s_precipamountsf4_qc   
      CHARACTER(LEN=l_c1) :: s_precipconditionsf4_dless  
      CHARACTER(LEN=l_c2) :: s_precipconditionsf4_qc
      CHARACTER(LEN=l_c1) :: s_observationperiodsf4_h
      CHARACTER(LEN=l_c2) :: s_observationperiodsf4_qc 

      CHARACTER(LEN=l_c1) :: s_stationpressure_hpa  !10
      CHARACTER(LEN=l_c2) :: s_stationpressure_qc   !10
c****
      INTEGER             :: i_lentest_platformid
      INTEGER             :: i_lentest_networktype
      INTEGER             :: i_lentest_ncdc_ob_time
      INTEGER             :: i_lentest_reporttypecode
      INTEGER             :: i_lentest_latitude
      INTEGER             :: i_lentest_longitude
      INTEGER             :: i_lentest_platformheight
      INTEGER             :: i_lentest_winddirection
      INTEGER             :: i_lentest_winddirection_qc
      INTEGER             :: i_lentest_windspeed
      INTEGER             :: i_lentest_windspeed_qc
      INTEGER             :: i_lentest_cloudceiling
      INTEGER             :: i_lentest_cloudceiling_qc
      INTEGER             :: i_lentest_visibility
      INTEGER             :: i_lentest_visibility_qc
      INTEGER             :: i_lentest_airtemperature
      INTEGER             :: i_lentest_airtemperature_qc
      INTEGER             :: i_lentest_dewpointtemperature
      INTEGER             :: i_lentest_dewpointtemperature_qc
      INTEGER             :: i_lentest_sealevelpressure
      INTEGER             :: i_lentest_sealevelpressure_qc

      INTEGER             :: i_lentest_observationperiodpp1
      INTEGER             :: i_lentest_observationperiodpp1_qc 
      INTEGER             :: i_lentest_precipamount1
      INTEGER             :: i_lentest_precipamount1_qc   
      INTEGER             :: i_lentest_precipcondition1  
      INTEGER             :: i_lentest_precipcondition1_qc
      INTEGER             :: i_lentest_observationperiodpp2
      INTEGER             :: i_lentest_observationperiodpp2_qc 
      INTEGER             :: i_lentest_precipamount2
      INTEGER             :: i_lentest_precipamount2_qc   
      INTEGER             :: i_lentest_precipcondition2  
      INTEGER             :: i_lentest_precipcondition2_qc
      INTEGER             :: i_lentest_observationperiodpp3
      INTEGER             :: i_lentest_observationperiodpp3_qc 
      INTEGER             :: i_lentest_precipamount3
      INTEGER             :: i_lentest_precipamount3_qc   
      INTEGER             :: i_lentest_precipcondition3  
      INTEGER             :: i_lentest_precipcondition3_qc
      INTEGER             :: i_lentest_observationperiodpp4
      INTEGER             :: i_lentest_observationperiodpp4_qc 
      INTEGER             :: i_lentest_precipamount4
      INTEGER             :: i_lentest_precipamount4_qc   
      INTEGER             :: i_lentest_precipcondition4  
      INTEGER             :: i_lentest_precipcondition4_qc

      INTEGER             :: i_lentest_precipamountsd
      INTEGER             :: i_lentest_precipamountsd_qc
      INTEGER             :: i_lentest_depthwtrequiv
      INTEGER             :: i_lentest_depthwtrequiv_qc

      INTEGER             :: i_lentest_precipamountsf1
      INTEGER             :: i_lentest_precipamountsf1_qc   
      INTEGER             :: i_lentest_precipconditionsf1  
      INTEGER             :: i_lentest_precipconditionsf1_qc
      INTEGER             :: i_lentest_observationperiodsf1
      INTEGER             :: i_lentest_observationperiodsf1_qc 
      INTEGER             :: i_lentest_precipamountsf2
      INTEGER             :: i_lentest_precipamountsf2_qc   
      INTEGER             :: i_lentest_precipconditionsf2  
      INTEGER             :: i_lentest_precipconditionsf2_qc
      INTEGER             :: i_lentest_observationperiodsf2
      INTEGER             :: i_lentest_observationperiodsf2_qc 
      INTEGER             :: i_lentest_precipamountsf3
      INTEGER             :: i_lentest_precipamountsf3_qc   
      INTEGER             :: i_lentest_precipconditionsf3  
      INTEGER             :: i_lentest_precipconditionsf3_qc
      INTEGER             :: i_lentest_observationperiodsf3
      INTEGER             :: i_lentest_observationperiodsf3_qc 
      INTEGER             :: i_lentest_precipamountsf4
      INTEGER             :: i_lentest_precipamountsf4_qc   
      INTEGER             :: i_lentest_precipconditionsf4  
      INTEGER             :: i_lentest_precipconditionsf4_qc
      INTEGER             :: i_lentest_observationperiodsf4
      INTEGER             :: i_lentest_observationperiodsf4_qc 

      INTEGER             :: i_lentest_stationpressure
      INTEGER             :: i_lentest_stationpressure_qc

c      INTEGER             :: i_test10
c************************************************************************
c      Get string fields from line (usaf_sfc_admin.pdf)
c      Legen document 103 pages: most variables on p17

c      Key                                Uni Page Values
c      14:  wind direction value          deg p163 1-360
c      15:  wind directionQC                  p163 0,1,2,3,4,5 (0=no checked,1=good)
c      16:  windcondition
c      17:  windconditionQC
c      18:  windspeed                     m/s p164 0-90 
c      19:  windspeed QC                      p164 0,1,2,3,4,5
c      20:  startdirection                    p164 1-360
c      21:  enddirection                      p164 1-360
c      22:  gustspeed                     m/s p164 1-110
c      23:  gustspeed QC                      p164 0,1,2,3,4,5
c      24:  windmeasurementmode               p165 0,1,2,3,4,5,6,7,8
c      25:  cloudceiling                  m   p165 no entry
c      26:  cloudceiling QC                   p165 0,1,2,3,4,5
c      (27:  ceiling determination)           p165 A,B,C,E,M,R,W,P
c      (28:  ceiling determination QC)        p165 0,1,2,3,4,5
c      (29:  cloudcavok)                      p166 Y,N
c      (30:  cloudcavok QC)                   p166 0,1,2,3,4,5
c      31:  visibility                    m   p166 0-160000
c      32:  visibility QC                     p166 0,1,2,3,4,5
c      33:  visibilitytype                m   p166 A,L,M,N,P,S,V
c      34:  visibilitytype QC                 p167 0,1,2,3,4,5
c      35:  airtemperature                c   p167 -93.2 to +61.8
c      36:  airtemperatureQC                  p167 0,1,2,3,4,5
c      37:  dewpointtemperature           c   p167 -110.0 to +63.0
c      38:  dewpointtemperatureQC             p167 0,1,2,3,4,5
c      39:  sealevelpressure              Pa  p168 450.0 to 1100.0
c      40:  sealevelpressureQC                p168 0,1,2,3,4,5

c      KEY CONDITION: 1=meas impossible/inaccurate; 2=trace, 3=measurable, 0=none, 9=missing
c      41:  observationperiodpp1          h   p168 0-99
c      42:  observationperiodpp1QC            p168 0,1,2,3,4,5
c      43:  precipamount1                 mm  p168 0.0 to 9992.0   (liquid precipitation)
c      44:  precipamount1QC                   p168 0,1,2,3,4,5
c      45:  precipcondition1                  p168 1,2,3,0,9
c      46:  precipcondition1QC                p169 0,1,2,3,4,5
c      47:  observationperiodpp2          h   p169 0-99
c      48:  observationperiodpp2QC            p169 0,1,2,3,4,5
c      49:  precipamount2                 mm  p169 0.0 to 9992.0   (liquid precipitation)
c      50:  precipamount2QC                   p169 0,1,2,3,4,5
c      51:  precipcondition2                  p170 1,2,3,0,9
c      52:  precipcondition2QC                p170 0,1,2,3,4,5
c      53:  observationperiodpp3          h   p170 0-99
c      54:  observationperiodpp3QC            p170 0,1,2,3,4,5
c      55:  precipamount3                 mm  p171 0.0 to 9992.0   (liquid precipitation)
c      56:  precipamount3QC                   p171 0,1,2,3,4,5
c      57:  precipcondition3                  p171 1,2,3,0,9
c      58:  precipcondition3QC                p171 0,1,2,3,4,5
c      59:  observationperiodpp4          h   p171 0-99
c      60:  observationperiodpp4QC            p171 0,1,2,3,4,5
c      61:  precipamount4                 mm  p172 0.0 to 9992.0   (liquid precipitation)
c      62:  precipamount4QC                   p172 0,1,2,3,4,5
c      63:  precipcondition4                  p172 1,2,3,0,9
c      64:  precipcondition4QC                p172 0,1,2,3,4,5

c      65:  preciphistdur                     p172 0,1,2,3
c      66:  preciphistdurQC                   p173 0,1,2,3,4,5
c      67:  preciphistchar                    p173 C,I
c      68:  preciphistcharQC                  p172 0,1,2,3,4,5
c      69:  precipdisc                        p173 0,1,2,3,4,5
c      70:  precipdiscQC                      p173 0,1,2,3,4,5
c      73:  precipamountsd                cm  p174 0-1200(dm?)
c      74:  precipamountsdQC                  p174 0,1,2,3,4,5
c      75:  precipconditionsd                 p174 0-1200(dm?)
c      76:  precipconditionsdQC               p175 0,1,2,3,4,5
c      77:  depthwtrequiv                 mm  p175 0-12000
c      78:  depthwtrequivQC                   p175 0,1,2,3,4,5
c      79:  depthwtrequivcon                  p175 0-12000
c      80:  depthwtrequivconQC                p175 0,1,2,3,4,5
c      81:  hailsize                      cm  p175 0-200

c      82:  precipamountsf1               cm  p176 0-500(dm?)
c      83:  precipamountsf1QC                 p176 0,1,2,3,4,5
c      84:  precipconditionsf1                p176 0,1,2,3,4
c      85:  precipconditionsf1QC              p176 0,1,2,3,4,5
c      86:  observationperiodsf1          h   p176 0-72
c      87:  observationperiodsf1QC            p176 0,1,2,3,4,5

c      88:  precipamountsf2               cm  p177 0-500(dm?)
c      89:  precipamountsf2QC                 p177 0,1,2,3,4,5
c      90:  precipconditionsf2                p177 0,1,2,3,4
c      91:  precipconditionsf2QC              p177 0,1,2,3,4,5
c      92:  observationperiodsf2          h   p177 0-72
c      93:  observationperiodsf2QC            p178 0,1,2,3,4,5

c      94:  precipamountsf3               cm  p178 0-500(dm?)
c      95:  precipamountsf3QC                 p178 0,1,2,3,4,5
c      96:  precipconditionsf3                p178 0,1,2,3,4
c      97:  precipconditionsf3QC              p178 0,1,2,3,4,5
c      98:  observationperiodsf3          h   p179 0-72
c      99:  observationperiodsf3QC            p179 0,1,2,3,4,5

c      100: precipamountsf4               cm  p179 0-500(dm?)
c      101: precipamountsf4QC                 p179 0,1,2,3,4,5
c      102: precipconditionsf4                p179 0,1,2,3,4
c      103: precipconditionsf4QC              p179 0,1,2,3,4,5
c      104: observationperiodsf4          h   p180 0-72
c      105: observationperiodsf4QC            p180 0,1,2,3,4,5
c...
c      142: cloudcover                      p221 00,01,02,03,04,05...10,/
c      143: cloudcoverQC                    p221 0,1,2,3,4,5
c      144: cloudcoverlo                    p221 00,01,02,03,04,05...10,/
c      145: cloudcoverloQC                  p221 0,1,2,3,4,5
c      146: cloudbaseheight                 p222 0-21000
c      147: cloudbaseheightQC               p222 0,1,2,3,4,5
c...
c      154: sunshine                        p224 0-6000
c      155: surfacecode                     p225 27 codes from 00 - 26
c      156: surfacecodeQC                   p225 0,1,2,3,4,5
c      157: soiltemperature                 p226 -110 to +150
c      158: soiltemperatureQC               p226 0,1,2,3,4,5
c      159: soildepth                       p226 00 to 96
c      160: observationperiodsoilt          p226 0 to 480
c      161: observationperiodsoiltQC        p226 0,1,2,3,4,5
c      162: altimetersetting                p227 863.5 to 1090.4
c      163: altimetersettingQC              p227 0,1,2,3,4,5
c      164: stationpressure                 p227 450.0 to 1100.0
c      165: stationpressureQC               p227 0,1,2,3,4,5
c...
c      168: pressure3hourchg                p228 -50 to +50
c      169: pressure3hourchgQC              p228 0,1,2,3,4,5
c      170: pressure24hourchg               p228 abs value between 0 and 80
c      171: pressure24hourchgQC             p228 0,1,2,3,4,5
c...  
c      177: seasurfacetemp                  p230 -5 to +45
c      178: seasurfacetempQC                p230 0,1,2,3,4,5
c************************************************************************
c      print*,'just entered get_params_single_line2'

c************************************************************************
c     Initialize variables with null flags
      s_platformid           ='-999'
      s_networktype          ='-999' 
      s_ncdc_ob_time         ='-999'
      s_reporttypecode       ='-999'
      s_latitude             ='-999'
      s_longitude            ='-999'
      s_platformheight       ='-999'
      s_winddirection_deg    ='-999'
      s_windspeed_ms         ='-999'
      s_cloudceiling_m       ='-999'
      s_visibility_m         ='-999'
      s_airtemperature_c     ='-999'
      s_dewpointtemperature_c='-999'
      s_sealevelpressure_hpa ='-999'
      s_stationpressure_hpa  ='-999'

c     Platformid
      IF (i_commacnt.GE.1) THEN
       i_lentest_platformid      =i_comma_pos(1)-1
       IF (i_lentest_platformid.GT.20) THEN
        print*,'i_lentest_platformid over limit: 20',
     +    i_lentest_platformid
        print*,'s_linget=',TRIM(s_linget)
        STOP 'get_params_single_line'
       ENDIF
       s_platformid        =s_linget(1:i_comma_pos(1)-1)

c       print*,'s_platformid=',TRIM(s_platformid)
c       STOP 'get_params_singleline20210527'
      ENDIF

c     Networktype
      IF (i_commacnt.GE.2) THEN
       i_lentest_networktype     =i_comma_pos(2)-i_comma_pos(1)-1
       IF (i_lentest_networktype.GT.20) THEN
        print*,'i_lentest_networktype over limit: 20', 
     +    i_lentest_networktype
        print*,'s_linget=',TRIM(s_linget)
        STOP 'get_params_single_line'
       ENDIF
       s_networktype       =s_linget(i_comma_pos(1)+1:i_comma_pos(2)-1)
      ENDIF

c     NCDC_ob_time
      IF (i_commacnt.GE.3) THEN
       i_lentest_ncdc_ob_time    =i_comma_pos(3)-i_comma_pos(2)-1
       IF (i_lentest_ncdc_ob_time.GT.14) THEN
        print*,'s_linget=',s_linget(i_comma_pos(2):i_comma_pos(3))
        print*,'i_lentest_ncdc_ob_time over limit: 14'
        print*,'s_linget=',TRIM(s_linget)
        STOP 'get_params_single_line'
       ENDIF
       s_ncdc_ob_time      =s_linget(i_comma_pos(2)+1:i_comma_pos(3)-1)
      ENDIF

c     Reporttypecode
      IF (i_commacnt.GE.4) THEN
       i_lentest_reporttypecode  =i_comma_pos(4)-i_comma_pos(3)-1
       IF (i_lentest_reporttypecode.GT.6) THEN
        print*,'i_lentest_reporttypecode over limit: 6'
        print*,'s_linget=',TRIM(s_linget)
        STOP 'get_params_single_line'
       ENDIF
       s_reporttypecode    =s_linget(i_comma_pos(3)+1:i_comma_pos(4)-1)
      ENDIF

c     Latitude
      IF (i_commacnt.GE.5) THEN
       i_lentest_latitude        =i_comma_pos(5)-i_comma_pos(4)-1
       IF (i_lentest_latitude.GT.15) THEN
        print*,'s_linget=',s_linget(i_comma_pos(4):i_comma_pos(5))
        print*,'i_lentest_latitude over limit: 15'
        print*,'s_linget=',TRIM(s_linget)
        STOP 'get_params_single_line'
       ENDIF
       s_latitude          =s_linget(i_comma_pos(4)+1:i_comma_pos(5)-1)
      ENDIF

c     Longitude
      IF (i_commacnt.GE.6) THEN
       i_lentest_longitude       =i_comma_pos(6)-i_comma_pos(5)-1
       IF (i_lentest_longitude.GT.15) THEN
        print*,'s_linget=',s_linget(i_comma_pos(5):i_comma_pos(6))
        print*,'i_lentest_longitude over limit: 15'
        print*,'s_linget=',TRIM(s_linget)
        STOP 'get_params_single_line'
       ENDIF
       s_longitude         =s_linget(i_comma_pos(5)+1:i_comma_pos(6)-1)
      ENDIF

c     Platformheight
      IF (i_commacnt.GE.11) THEN
       i_lentest_platformheight  =i_comma_pos(11)-i_comma_pos(10)-1
       IF (i_lentest_platformheight.GT.15) THEN
        print*,'i_lentest_platformheight over limit: 15'
        print*,'s_linget=',TRIM(s_linget)
        STOP 'get_params_single_line'
       ENDIF
       s_platformheight   =s_linget(i_comma_pos(10)+1:i_comma_pos(11)-1)
      ENDIF
c****
c     Winddirection - value
      IF (i_commacnt.GE.14) THEN
       i_lentest_winddirection=i_comma_pos(14)-i_comma_pos(13)-1
       IF (i_lentest_winddirection.GT.l_c1) THEN
        print*,'i_lentest_winddirection over limit:',l_c1
        STOP 'get_params_single_line'
       ENDIF
       s_winddirection_deg=s_linget(i_comma_pos(13)+1:i_comma_pos(14)-1)
      ENDIF

c     Winddirection - QC
      IF (i_commacnt.GE.15) THEN
       i_lentest_winddirection_qc=i_comma_pos(15)-i_comma_pos(14)-1
       IF (i_lentest_winddirection_qc.GT.l_c2) THEN
        print*,'i_lentest_winddirection over limit:',l_c2
        STOP 'get_params_single_line'
       ENDIF
       s_winddirection_qc=s_linget(i_comma_pos(14)+1:i_comma_pos(15)-1)
      ENDIF
c****
c     Windspeed - value
      IF (i_commacnt.GE.18) THEN
       i_lentest_windspeed       =i_comma_pos(18)-i_comma_pos(17)-1
       IF (i_lentest_windspeed.GT.l_c1) THEN
        print*,'i_lentest_windspeed over limit:',l_c1
        STOP 'get_params_single_line'
       ENDIF
       s_windspeed_ms     =s_linget(i_comma_pos(17)+1:i_comma_pos(18)-1)
      ENDIF

c     Windspeed - QC
      IF (i_commacnt.GE.19) THEN
       i_lentest_windspeed_qc       =i_comma_pos(19)-i_comma_pos(18)-1
       IF (i_lentest_windspeed_qc.GT.l_c2) THEN
        print*,'i_lentest_windspeed_qc over limit:',l_c2
        STOP 'get_params_single_line'
       ENDIF
       s_windspeed_qc     =s_linget(i_comma_pos(18)+1:i_comma_pos(19)-1)
      ENDIF
c****
      GOTO 50

c     Cloudceiling - value
      IF (i_commacnt.GE.25) THEN
       i_lentest_cloudceiling=i_comma_pos(25)-i_comma_pos(24)-1
       IF (i_lentest_cloudceiling.GT.l_c1) THEN
        print*,'i_lentest_cloudceiling over limit:',l_c1
        STOP 'get_params_single_line'
       ENDIF
       s_cloudceiling_m=s_linget(i_comma_pos(24)+1:i_comma_pos(25)-1)
      ENDIF

c     Cloudceiling - QC
      IF (i_commacnt.GE.26) THEN
       i_lentest_cloudceiling_qc=i_comma_pos(26)-i_comma_pos(25)-1
       IF (i_lentest_cloudceiling_qc.GT.l_c2) THEN
        print*,'i_lentest_cloudceiling_qc over limit:',l_c2
        STOP 'get_params_single_line'
       ENDIF
       s_cloudceiling_qc=s_linget(i_comma_pos(25)+1:i_comma_pos(26)-1)
      ENDIF
c****
c     Visibility - value
      IF (i_commacnt.GE.31) THEN
       i_lentest_visibility=i_comma_pos(31)-i_comma_pos(30)-1
       IF (i_lentest_visibility.GT.l_c1) THEN
        print*,'i_lentest_visibility over limit:',l_c1
        STOP 'get_params_single_line'
       ENDIF
       s_visibility_m=s_linget(i_comma_pos(30)+1:i_comma_pos(31)-1)
      ENDIF

c     Visibility - QC
      IF (i_commacnt.GE.32) THEN
       i_lentest_visibility_qc=i_comma_pos(32)-i_comma_pos(31)-1
       IF (i_lentest_visibility_qc.GT.l_c2) THEN
        print*,'i_lentest_visibility_qc over limit:',l_c2
        STOP 'get_params_single_line'
       ENDIF
       s_visibility_qc=s_linget(i_comma_pos(31)+1:i_comma_pos(32)-1)
      ENDIF

 50   CONTINUE
c****
c     (35) Airtemperature - value (34-35)
      IF (i_commacnt.GE.35) THEN
       i_lentest_airtemperature=i_comma_pos(35)-i_comma_pos(34)-1
       IF (i_lentest_airtemperature.GT.l_c1) THEN
        print*,'i_lentest_airtemperature over limit:',l_c1
        STOP 'get_params_single_line'
       ENDIF
       s_airtemperature_c=s_linget(i_comma_pos(34)+1:i_comma_pos(35)-1)
      ENDIF

c     (36) Airtemperature - QC (35-36)
      IF (i_commacnt.GE.36) THEN
       i_lentest_airtemperature_qc=i_comma_pos(36)-i_comma_pos(35)-1
       IF (i_lentest_airtemperature_qc.GT.l_c2) THEN
        print*,'i_lentest_airtemperature_qc over limit:',l_c2
        STOP 'get_params_single_line'
       ENDIF
       s_airtemperature_qc=s_linget(i_comma_pos(35)+1:i_comma_pos(36)-1)
      ENDIF
c****
c     (37) Dewpointtemperature - value (36-37)
      IF (i_commacnt.GE.37) THEN
       i_lentest_dewpointtemperature=i_comma_pos(37)-i_comma_pos(36)-1
       IF (i_lentest_dewpointtemperature.GT.l_c1) THEN
        print*,'i_lentest_dewpointtemperature over limit:',l_c1
        STOP 'get_params_single_line'
       ENDIF
       s_dewpointtemperature_c=
     +   s_linget(i_comma_pos(36)+1:i_comma_pos(37)-1)
      ENDIF

c     (38) Dewpointtemperature - QC (37-38)
      IF (i_commacnt.GE.38) THEN
       i_lentest_dewpointtemperature_qc=
     +   i_comma_pos(38)-i_comma_pos(37)-1
       IF (i_lentest_dewpointtemperature_qc.GT.l_c2) THEN
        print*,'i_lentest_dewpointtemperature_qc over limit:',l_c2
        STOP 'get_params_single_line'
       ENDIF
       s_dewpointtemperature_qc=
     +   s_linget(i_comma_pos(37)+1:i_comma_pos(38)-1)
      ENDIF
c****
c     (39) Sealevelpressure - value (38-39)
      IF (i_commacnt.GE.39) THEN
       i_lentest_sealevelpressure=i_comma_pos(39)-i_comma_pos(38)-1
       IF (i_lentest_sealevelpressure.GT.l_c1) THEN
        print*,'i_lentest_sealevelpressure over limit:',l_c1
        STOP 'get_params_single_line'
       ENDIF
       s_sealevelpressure_hpa=
     +  s_linget(i_comma_pos(38)+1:i_comma_pos(39)-1)
      ENDIF

c     (40) Sealevelpressure - qc (39-40)
      IF (i_commacnt.GE.40) THEN
       i_lentest_sealevelpressure_qc=i_comma_pos(40)-i_comma_pos(39)-1
       IF (i_lentest_sealevelpressure_qc.GT.l_c2) THEN
        print*,'i_lentest_sealevelpressure_qc over limit:',l_c2
        STOP 'get_params_single_line'
       ENDIF
       s_sealevelpressure_qc=
     +  s_linget(i_comma_pos(39)+1:i_comma_pos(40)-1)
      ENDIF
c****
c****
      GOTO 52

c     (41) Observationperiodpp1 - value (40-41)
      IF (i_commacnt.GE.41) THEN
       i_lentest_observationperiodpp1=
     +     i_comma_pos(41)-i_comma_pos(40)-1
       IF (i_lentest_observationperiodpp1.GT.l_c1) THEN
        print*,'i_lentest_observationperiodpp1 over limit:',l_c1
        STOP 'get_params_single_line2'
       ENDIF
       s_observationperiodpp1_h=
     +  s_linget(i_comma_pos(40)+1:i_comma_pos(41)-1)
      ENDIF

c     (42) Observationperiodpp1 - qc (41-42)
      IF (i_commacnt.GE.42) THEN
       i_lentest_observationperiodpp1_qc=
     +     i_comma_pos(42)-i_comma_pos(41)-1
       IF (i_lentest_observationperiodpp1_qc.GT.l_c2) THEN
        print*,'i_lentest_observationperiodpp1_qc over limit:',l_c2
        STOP 'get_params_single_line2'
       ENDIF
       s_observationperiodpp1_qc=
     +  s_linget(i_comma_pos(41)+1:i_comma_pos(42)-1)
      ENDIF
c****
c     (43) Precipamount1 - value (42-43)
      IF (i_commacnt.GE.43) THEN
       i_lentest_precipamount1=
     +     i_comma_pos(43)-i_comma_pos(42)-1
       IF (i_lentest_precipamount1.GT.l_c1) THEN
        print*,'i_lentest_precipamount1 over limit:',l_c1
        STOP 'get_params_single_line2'
       ENDIF
       s_precipamount1_mm=
     +  s_linget(i_comma_pos(42)+1:i_comma_pos(43)-1)
      ENDIF

c     (44) Precipamount1 - qc (43-44)
      IF (i_commacnt.GE.44) THEN
       i_lentest_precipamount1_qc=
     +     i_comma_pos(44)-i_comma_pos(43)-1
       IF (i_lentest_precipamount1_qc.GT.l_c2) THEN
        print*,'i_lentest_precipamount1_qc over limit:',l_c2
        STOP 'get_params_single_line2'
       ENDIF
       s_precipamount1_qc=
     +  s_linget(i_comma_pos(43)+1:i_comma_pos(44)-1)
      ENDIF
c****
c     (45) Precipcondition1 - value (44-45)
      IF (i_commacnt.GE.45) THEN
       i_lentest_precipcondition1=
     +     i_comma_pos(45)-i_comma_pos(44)-1
       IF (i_lentest_precipcondition1.GT.l_c1) THEN
        print*,'i_lentest_precipcondition1 over limit:',l_c1
        STOP 'get_params_single_line2'
       ENDIF
       s_precipcondition1_dless=
     +  s_linget(i_comma_pos(44)+1:i_comma_pos(45)-1)
      ENDIF

c     (46) Precipcondition1 - qc (45-46)
      IF (i_commacnt.GE.46) THEN
       i_lentest_precipcondition1_qc=
     +     i_comma_pos(46)-i_comma_pos(45)-1
       IF (i_lentest_precipcondition1_qc.GT.l_c2) THEN
        print*,'i_lentest_precipcondition1_qc over limit:',l_c2
        STOP 'get_params_single_line2'
       ENDIF
       s_precipcondition1_qc=
     +  s_linget(i_comma_pos(45)+1:i_comma_pos(46)-1)
      ENDIF
c****
c****
c     (47) Observationperiodpp2 - value (46-47)
      IF (i_commacnt.GE.47) THEN
       i_lentest_observationperiodpp2=
     +     i_comma_pos(47)-i_comma_pos(46)-1
       IF (i_lentest_observationperiodpp2.GT.l_c1) THEN
        print*,'i_lentest_observationperiodpp2 over limit:',l_c1
        STOP 'get_params_single_line2'
       ENDIF
       s_observationperiodpp2_h=
     +  s_linget(i_comma_pos(46)+1:i_comma_pos(47)-1)
      ENDIF

c     (48) Observationperiodpp2 - qc (47-48)
      IF (i_commacnt.GE.48) THEN
       i_lentest_observationperiodpp2_qc=
     +     i_comma_pos(48)-i_comma_pos(47)-1
       IF (i_lentest_observationperiodpp2_qc.GT.l_c2) THEN
        print*,'i_lentest_observationperiodpp2_qc over limit:',l_c2
        STOP 'get_params_single_line2'
       ENDIF
       s_observationperiodpp2_qc=
     +  s_linget(i_comma_pos(47)+1:i_comma_pos(48)-1)
      ENDIF
c****
c     (49) Precipamount2 - value (48-49)
      IF (i_commacnt.GE.49) THEN
       i_lentest_precipamount2=
     +     i_comma_pos(49)-i_comma_pos(48)-1
       IF (i_lentest_precipamount2.GT.l_c1) THEN
        print*,'i_lentest_precipamount2 over limit:',l_c1
        STOP 'get_params_single_line2'
       ENDIF
       s_precipamount2_mm=
     +  s_linget(i_comma_pos(48)+1:i_comma_pos(49)-1)
      ENDIF

c     (50) Precipamount2 - qc (49-50)
      IF (i_commacnt.GE.50) THEN
       i_lentest_precipamount2_qc=
     +     i_comma_pos(50)-i_comma_pos(49)-1
       IF (i_lentest_precipamount2_qc.GT.l_c2) THEN
        print*,'i_lentest_precipamount2_qc over limit:',l_c2
        STOP 'get_params_single_line2'
       ENDIF
       s_precipamount2_qc=
     +  s_linget(i_comma_pos(49)+1:i_comma_pos(50)-1)
      ENDIF
c****
c     (51) Precipcondition2 - value (50-51)
      IF (i_commacnt.GE.51) THEN
       i_lentest_precipcondition2=
     +     i_comma_pos(51)-i_comma_pos(50)-1
       IF (i_lentest_precipcondition2.GT.l_c1) THEN
        print*,'i_lentest_precipcondition2 over limit:',l_c1
        STOP 'get_params_single_line2'
       ENDIF
       s_precipcondition2_dless=
     +  s_linget(i_comma_pos(50)+1:i_comma_pos(51)-1)
      ENDIF

c     (52) Precipcondition2 - qc (51-52)
      IF (i_commacnt.GE.52) THEN
       i_lentest_precipcondition2_qc=
     +     i_comma_pos(52)-i_comma_pos(51)-1
       IF (i_lentest_precipcondition2_qc.GT.l_c2) THEN
        print*,'i_lentest_precipcondition2_qc over limit:',l_c2
        STOP 'get_params_single_line2'
       ENDIF
       s_precipcondition2_qc=
     +  s_linget(i_comma_pos(51)+1:i_comma_pos(52)-1)
      ENDIF
c****
c****
c     (53) Observationperiodpp3 - value (52-53)
      IF (i_commacnt.GE.53) THEN
       i_lentest_observationperiodpp3=
     +     i_comma_pos(53)-i_comma_pos(52)-1
       IF (i_lentest_observationperiodpp3.GT.l_c1) THEN
        print*,'i_lentest_observationperiodpp3 over limit:',l_c1
        STOP 'get_params_single_line3'
       ENDIF
       s_observationperiodpp3_h=
     +  s_linget(i_comma_pos(52)+1:i_comma_pos(53)-1)
      ENDIF

c     (54) Observationperiodpp3 - qc (53-54)
      IF (i_commacnt.GE.54) THEN
       i_lentest_observationperiodpp3_qc=
     +     i_comma_pos(54)-i_comma_pos(53)-1
       IF (i_lentest_observationperiodpp3_qc.GT.l_c2) THEN
        print*,'i_lentest_observationperiodpp3_qc over limit:',l_c2
        STOP 'get_params_single_line2'
       ENDIF
       s_observationperiodpp3_qc=
     +  s_linget(i_comma_pos(53)+1:i_comma_pos(54)-1)
      ENDIF
c****
c     (55) Precipamount3 - value (54-55)
      IF (i_commacnt.GE.55) THEN
       i_lentest_precipamount3=
     +     i_comma_pos(55)-i_comma_pos(54)-1
       IF (i_lentest_precipamount3.GT.l_c1) THEN
        print*,'i_lentest_precipamount3 over limit:',l_c1
        STOP 'get_params_single_line2'
       ENDIF
       s_precipamount3_mm=
     +  s_linget(i_comma_pos(54)+1:i_comma_pos(55)-1)
      ENDIF

c     (56) Precipamount3 - qc (55-56)
      IF (i_commacnt.GE.56) THEN
       i_lentest_precipamount3_qc=
     +     i_comma_pos(56)-i_comma_pos(55)-1
       IF (i_lentest_precipamount3_qc.GT.l_c2) THEN
        print*,'i_lentest_precipamount3_qc over limit:',l_c2
        STOP 'get_params_single_line2'
       ENDIF
       s_precipamount3_qc=
     +  s_linget(i_comma_pos(55)+1:i_comma_pos(56)-1)
      ENDIF
c****
c     (57) Precipcondition3 - value (56-57)
      IF (i_commacnt.GE.57) THEN
       i_lentest_precipcondition3=
     +     i_comma_pos(57)-i_comma_pos(56)-1
       IF (i_lentest_precipcondition3.GT.l_c1) THEN
        print*,'i_lentest_precipcondition3 over limit:',l_c1
        STOP 'get_params_single_line2'
       ENDIF
       s_precipcondition3_dless=
     +  s_linget(i_comma_pos(56)+1:i_comma_pos(57)-1)
      ENDIF

c     (58) Precipcondition3 - qc (57-58)
      IF (i_commacnt.GE.58) THEN
       i_lentest_precipcondition3_qc=
     +     i_comma_pos(58)-i_comma_pos(57)-1
       IF (i_lentest_precipcondition3_qc.GT.l_c2) THEN
        print*,'i_lentest_precipcondition3_qc over limit:',l_c2
        STOP 'get_params_single_line2'
       ENDIF
       s_precipcondition3_qc=
     +  s_linget(i_comma_pos(57)+1:i_comma_pos(58)-1)
      ENDIF
c****
c****
c     (59) Observationperiodpp4 - value (58-59)
      IF (i_commacnt.GE.59) THEN
       i_lentest_observationperiodpp4=
     +     i_comma_pos(59)-i_comma_pos(58)-1
       IF (i_lentest_observationperiodpp4.GT.l_c1) THEN
        print*,'i_lentest_observationperiodpp4 over limit:',l_c1
        STOP 'get_params_single_line2'
       ENDIF
       s_observationperiodpp4_h=
     +  s_linget(i_comma_pos(58)+1:i_comma_pos(59)-1)
      ENDIF

c     (60) Observationperiodpp4 - qc (59-60)
      IF (i_commacnt.GE.60) THEN
       i_lentest_observationperiodpp4_qc=
     +     i_comma_pos(60)-i_comma_pos(59)-1
       IF (i_lentest_observationperiodpp4_qc.GT.l_c2) THEN
        print*,'i_lentest_observationperiodpp4_qc over limit:',l_c2
        STOP 'get_params_single_line2'
       ENDIF
       s_observationperiodpp4_qc=
     +  s_linget(i_comma_pos(59)+1:i_comma_pos(60)-1)
      ENDIF
c****
c     (61) Precipamount4 - value (60-61)
      IF (i_commacnt.GE.61) THEN
       i_lentest_precipamount4=
     +     i_comma_pos(61)-i_comma_pos(60)-1
       IF (i_lentest_precipamount4.GT.l_c1) THEN
        print*,'i_lentest_precipamount4 over limit:',l_c1
        STOP 'get_params_single_line2'
       ENDIF
       s_precipamount4_mm=
     +  s_linget(i_comma_pos(60)+1:i_comma_pos(61)-1)
      ENDIF

c     (62) Precipamount4 - qc (61-62)
      IF (i_commacnt.GE.62) THEN
       i_lentest_precipamount4_qc=
     +     i_comma_pos(62)-i_comma_pos(61)-1
       IF (i_lentest_precipamount4_qc.GT.l_c2) THEN
        print*,'i_lentest_precipamount4_qc over limit:',l_c2
        STOP 'get_params_single_line2'
       ENDIF
       s_precipamount4_qc=
     +  s_linget(i_comma_pos(61)+1:i_comma_pos(62)-1)
      ENDIF
c****
c     (63) Precipcondition4 - value (62-63)
      IF (i_commacnt.GE.63) THEN
       i_lentest_precipcondition4=
     +     i_comma_pos(63)-i_comma_pos(62)-1
       IF (i_lentest_precipcondition4.GT.l_c1) THEN
        print*,'i_lentest_precipcondition4 over limit:',l_c1
        STOP 'get_params_single_line2'
       ENDIF
       s_precipcondition4_dless=
     +  s_linget(i_comma_pos(62)+1:i_comma_pos(63)-1)
      ENDIF

c     (64) Precipcondition4 - qc (63-64)
      IF (i_commacnt.GE.64) THEN
       i_lentest_precipcondition4_qc=
     +     i_comma_pos(64)-i_comma_pos(63)-1
       IF (i_lentest_precipcondition4_qc.GT.l_c2) THEN
        print*,'i_lentest_precipcondition4_qc over limit:',l_c2
        STOP 'get_params_single_line2'
       ENDIF
       s_precipcondition4_qc=
     +  s_linget(i_comma_pos(63)+1:i_comma_pos(64)-1)
      ENDIF
c****
c****
c     (73) Precipamountsd - value (72-73)
      IF (i_commacnt.GE.73) THEN
       i_lentest_precipamountsd=
     +     i_comma_pos(73)-i_comma_pos(72)-1
       IF (i_lentest_precipamountsd.GT.l_c1) THEN
        print*,'i_lentest_precipamountsd over limit:',l_c1
        STOP 'get_params_single_line2'
       ENDIF
       s_precipamountsd_cm=
     +  s_linget(i_comma_pos(72)+1:i_comma_pos(73)-1)
      ENDIF

c     (74) Precipamountsd - qc (73-74)
      IF (i_commacnt.GE.74) THEN
       i_lentest_precipamountsd_qc=
     +     i_comma_pos(74)-i_comma_pos(73)-1
       IF (i_lentest_precipamountsd_qc.GT.l_c2) THEN
        print*,'i_lentest_precipamountsd_qc over limit:',l_c2
        STOP 'get_params_single_line2'
       ENDIF
       s_precipamountsd_qc=
     +  s_linget(i_comma_pos(73)+1:i_comma_pos(74)-1)
      ENDIF
c****
c     (77) depthwtrequiv - value (76-77)
      IF (i_commacnt.GE.77) THEN
       i_lentest_depthwtrequiv=
     +     i_comma_pos(77)-i_comma_pos(76)-1
       IF (i_lentest_depthwtrequiv.GT.l_c1) THEN
        print*,'i_lentest_depthwtrequiv over limit:',l_c1
        STOP 'get_params_single_line2'
       ENDIF
       s_depthwtrequiv_mm=
     +  s_linget(i_comma_pos(76)+1:i_comma_pos(77)-1)
      ENDIF

c     (78) depthwtrequiv - qc (77-78)
      IF (i_commacnt.GE.78) THEN
       i_lentest_depthwtrequiv_qc=
     +     i_comma_pos(78)-i_comma_pos(77)-1
       IF (i_lentest_depthwtrequiv_qc.GT.l_c2) THEN
        print*,'i_lentest_depthwtrequiv_qc over limit:',l_c2
        STOP 'get_params_single_line2'
       ENDIF
       s_depthwtrequiv_qc=
     +  s_linget(i_comma_pos(77)+1:i_comma_pos(78)-1)
      ENDIF
c****
c****

c     82-83-84-85-86-87
c     (82) Precipamountsf1 - value (81-82)
      IF (i_commacnt.GE.82) THEN
       i_lentest_precipamountsf1=
     +     i_comma_pos(82)-i_comma_pos(81)-1
       IF (i_lentest_precipamountsf1.GT.l_c1) THEN
        print*,'i_lentest_precipamountsf1 over limit:',l_c1
        STOP 'get_params_single_line2'
       ENDIF
       s_precipamountsf1_cm=
     +  s_linget(i_comma_pos(42)+1:i_comma_pos(43)-1)
      ENDIF

c     (83) Precipamountsf1 - qc (82-83)
      IF (i_commacnt.GE.83) THEN
       i_lentest_precipamountsf1_qc=
     +     i_comma_pos(83)-i_comma_pos(82)-1
       IF (i_lentest_precipamountsf1_qc.GT.l_c2) THEN
        print*,'i_lentest_precipamountsf1_qc over limit:',l_c2
        STOP 'get_params_single_line2'
       ENDIF
       s_precipamountsf1_qc=
     +  s_linget(i_comma_pos(82)+1:i_comma_pos(83)-1)
      ENDIF
c****
c     (84) Precipconditionsf1 - value (83-84)
      IF (i_commacnt.GE.84) THEN
       i_lentest_precipconditionsf1=
     +     i_comma_pos(84)-i_comma_pos(83)-1
       IF (i_lentest_precipconditionsf1.GT.l_c1) THEN
        print*,'i_lentest_precipconditionsf1 over limit:',l_c1
        STOP 'get_params_single_line2'
       ENDIF
       s_precipconditionsf1_dless=
     +  s_linget(i_comma_pos(83)+1:i_comma_pos(84)-1)
      ENDIF

c     (85) Precipconditionsf1 - qc (84-85)
      IF (i_commacnt.GE.85) THEN
       i_lentest_precipconditionsf1_qc=
     +     i_comma_pos(85)-i_comma_pos(84)-1
       IF (i_lentest_precipconditionsf1_qc.GT.l_c2) THEN
        print*,'i_lentest_precipconditionsf1_qc over limit:',l_c2
        STOP 'get_params_single_line2'
       ENDIF
       s_precipconditionsf1_qc=
     +  s_linget(i_comma_pos(84)+1:i_comma_pos(85)-1)
      ENDIF
c****
c     (86) Observationperiodsf1 - value (85-86)
      IF (i_commacnt.GE.86) THEN
       i_lentest_observationperiodsf1=
     +     i_comma_pos(86)-i_comma_pos(85)-1
       IF (i_lentest_observationperiodsf1.GT.l_c1) THEN
        print*,'i_lentest_observationperiodsf1 over limit:',l_c1
        STOP 'get_params_single_line2'
       ENDIF
       s_observationperiodsf1_h=
     +  s_linget(i_comma_pos(85)+1:i_comma_pos(86)-1)
      ENDIF

c     (87) Observationperiodsf1 - qc (86-87)
      IF (i_commacnt.GE.87) THEN
       i_lentest_observationperiodsf1_qc=
     +     i_comma_pos(87)-i_comma_pos(86)-1
       IF (i_lentest_observationperiodsf1_qc.GT.l_c2) THEN
        print*,'i_lentest_observationperiodsf1_qc over limit:',l_c2
        STOP 'get_params_single_line2'
       ENDIF
       s_observationperiodsf1_qc=
     +  s_linget(i_comma_pos(86)+1:i_comma_pos(87)-1)
      ENDIF
c****
c****

c     88-89-90-91-92-93
c     (88) Precipamountsf2 - value (87-88)
      IF (i_commacnt.GE.88) THEN
       i_lentest_precipamountsf2=
     +     i_comma_pos(88)-i_comma_pos(87)-1
       IF (i_lentest_precipamountsf2.GT.l_c1) THEN
        print*,'i_lentest_precipamountsf2 over limit:',l_c1
        STOP 'get_params_single_line2'
       ENDIF
       s_precipamountsf2_cm=
     +  s_linget(i_comma_pos(87)+1:i_comma_pos(88)-1)
      ENDIF

c     (89) Precipamountsf2 - qc (88-89)
      IF (i_commacnt.GE.89) THEN
       i_lentest_precipamountsf2_qc=
     +     i_comma_pos(89)-i_comma_pos(88)-1
       IF (i_lentest_precipamountsf2_qc.GT.l_c2) THEN
        print*,'i_lentest_precipamountsf2_qc over limit:',l_c2
        STOP 'get_params_single_line2'
       ENDIF
       s_precipamountsf2_qc=
     +  s_linget(i_comma_pos(88)+1:i_comma_pos(89)-1)
      ENDIF
c****
c     (90) Precipconditionsf2 - value (89-90)
      IF (i_commacnt.GE.90) THEN
       i_lentest_precipconditionsf2=
     +     i_comma_pos(90)-i_comma_pos(89)-1
       IF (i_lentest_precipconditionsf2.GT.l_c1) THEN
        print*,'i_lentest_precipconditionsf2 over limit:',l_c1
        STOP 'get_params_single_line2'
       ENDIF
       s_precipconditionsf2_dless=
     +  s_linget(i_comma_pos(89)+1:i_comma_pos(90)-1)
      ENDIF

c     (91) Precipconditionsf2 - qc (90-91)
      IF (i_commacnt.GE.91) THEN
       i_lentest_precipconditionsf2_qc=
     +     i_comma_pos(91)-i_comma_pos(90)-1
       IF (i_lentest_precipconditionsf2_qc.GT.l_c2) THEN
        print*,'i_lentest_precipconditionsf2_qc over limit:',l_c2
        STOP 'get_params_single_line2'
       ENDIF
       s_precipconditionsf2_qc=
     +  s_linget(i_comma_pos(90)+1:i_comma_pos(91)-1)
      ENDIF
c****
c     (92) Observationperiodsf2 - value (91-92)
      IF (i_commacnt.GE.92) THEN
       i_lentest_observationperiodsf2=
     +     i_comma_pos(92)-i_comma_pos(91)-1
       IF (i_lentest_observationperiodsf2.GT.l_c1) THEN
        print*,'i_lentest_observationperiodsf2 over limit:',l_c1
        STOP 'get_params_single_line2'
       ENDIF
       s_observationperiodsf2_h=
     +  s_linget(i_comma_pos(91)+1:i_comma_pos(92)-1)
      ENDIF

c     (93) Observationperiodsf2 - qc (92-93)
      IF (i_commacnt.GE.93) THEN
       i_lentest_observationperiodsf2_qc=
     +     i_comma_pos(93)-i_comma_pos(92)-1
       IF (i_lentest_observationperiodsf2_qc.GT.l_c2) THEN
        print*,'i_lentest_observationperiodsf2_qc over limit:',l_c2
        STOP 'get_params_single_line2'
       ENDIF
       s_observationperiodsf2_qc=
     +  s_linget(i_comma_pos(92)+1:i_comma_pos(93)-1)
      ENDIF
c****
c****

c     94-95-96-97-98-99
c     (94) Precipamountsf3 - value (93-94)
      IF (i_commacnt.GE.94) THEN
       i_lentest_precipamountsf3=
     +     i_comma_pos(94)-i_comma_pos(93)-1
       IF (i_lentest_precipamountsf3.GT.l_c1) THEN
        print*,'i_lentest_precipamountsf3 over limit:',l_c1
        STOP 'get_params_single_line2'
       ENDIF
       s_precipamountsf3_cm=
     +  s_linget(i_comma_pos(93)+1:i_comma_pos(94)-1)
      ENDIF

c     (95) Precipamountsf3 - qc (94-95)
      IF (i_commacnt.GE.95) THEN
       i_lentest_precipamountsf3_qc=
     +     i_comma_pos(95)-i_comma_pos(94)-1
       IF (i_lentest_precipamountsf3_qc.GT.l_c2) THEN
        print*,'i_lentest_precipamountsf3_qc over limit:',l_c2
        STOP 'get_params_single_line2'
       ENDIF
       s_precipamountsf3_qc=
     +  s_linget(i_comma_pos(94)+1:i_comma_pos(95)-1)
      ENDIF
c****
c     (96) Precipconditionsf3 - value (95-96)
      IF (i_commacnt.GE.96) THEN
       i_lentest_precipconditionsf3=
     +     i_comma_pos(96)-i_comma_pos(95)-1
       IF (i_lentest_precipconditionsf3.GT.l_c1) THEN
        print*,'i_lentest_precipconditionsf3 over limit:',l_c1
        STOP 'get_params_single_line2'
       ENDIF
       s_precipconditionsf3_dless=
     +  s_linget(i_comma_pos(95)+1:i_comma_pos(96)-1)
      ENDIF

c     (97) Precipconditionsf3 - qc (96-97)
      IF (i_commacnt.GE.97) THEN
       i_lentest_precipconditionsf3_qc=
     +     i_comma_pos(97)-i_comma_pos(96)-1
       IF (i_lentest_precipconditionsf3_qc.GT.l_c2) THEN
        print*,'i_lentest_precipconditionsf3_qc over limit:',l_c2
        STOP 'get_params_single_line2'
       ENDIF
       s_precipconditionsf3_qc=
     +  s_linget(i_comma_pos(96)+1:i_comma_pos(97)-1)
      ENDIF
c****
c     (98) Observationperiodsf3 - value (97-98)
      IF (i_commacnt.GE.98) THEN
       i_lentest_observationperiodsf3=
     +     i_comma_pos(98)-i_comma_pos(97)-1
       IF (i_lentest_observationperiodsf3.GT.l_c1) THEN
        print*,'i_lentest_observationperiodsf3 over limit:',l_c1
        STOP 'get_params_single_line2'
       ENDIF
       s_observationperiodsf3_h=
     +  s_linget(i_comma_pos(97)+1:i_comma_pos(98)-1)
      ENDIF

c     (99) Observationperiodsf3 - qc (98-99)
      IF (i_commacnt.GE.99) THEN
       i_lentest_observationperiodsf3_qc=
     +     i_comma_pos(99)-i_comma_pos(98)-1
       IF (i_lentest_observationperiodsf3_qc.GT.l_c2) THEN
        print*,'i_lentest_observationperiodsf3_qc over limit:',l_c2
        STOP 'get_params_single_line2'
       ENDIF
       s_observationperiodsf3_qc=
     +  s_linget(i_comma_pos(98)+1:i_comma_pos(99)-1)
      ENDIF
c****
c****

c     100-101-102-103-104-105
c     (100) Precipamountsf4 - value (99-100)
      IF (i_commacnt.GE.100) THEN
       i_lentest_precipamountsf4=
     +     i_comma_pos(100)-i_comma_pos(99)-1
       IF (i_lentest_precipamountsf4.GT.l_c1) THEN
        print*,'i_lentest_precipamountsf4 over limit:',l_c1
        STOP 'get_params_single_line2'
       ENDIF
       s_precipamountsf4_cm=
     +  s_linget(i_comma_pos(99)+1:i_comma_pos(100)-1)
      ENDIF

c     (101) Precipamountsf4 - qc (100-101)
      IF (i_commacnt.GE.101) THEN
       i_lentest_precipamountsf4_qc=
     +     i_comma_pos(101)-i_comma_pos(100)-1
       IF (i_lentest_precipamountsf4_qc.GT.l_c2) THEN
        print*,'i_lentest_precipamountsf4_qc over limit:',l_c2
        STOP 'get_params_single_line2'
       ENDIF
       s_precipamountsf4_qc=
     +  s_linget(i_comma_pos(100)+1:i_comma_pos(101)-1)
      ENDIF
c****
c     (102) Precipconditionsf4 - value (101-102)
      IF (i_commacnt.GE.102) THEN
       i_lentest_precipconditionsf4=
     +     i_comma_pos(102)-i_comma_pos(101)-1
       IF (i_lentest_precipconditionsf4.GT.l_c1) THEN
        print*,'i_lentest_precipconditionsf4 over limit:',l_c1
        STOP 'get_params_single_line2'
       ENDIF
       s_precipconditionsf4_dless=
     +  s_linget(i_comma_pos(101)+1:i_comma_pos(102)-1)
      ENDIF

c     (103) Precipconditionsf4 - qc (102-103)
      IF (i_commacnt.GE.103) THEN
       i_lentest_precipconditionsf4_qc=
     +     i_comma_pos(103)-i_comma_pos(102)-1
       IF (i_lentest_precipconditionsf4_qc.GT.l_c2) THEN
        print*,'i_lentest_precipconditionsf4_qc over limit:',l_c2
        STOP 'get_params_single_line2'
       ENDIF
       s_precipconditionsf4_qc=
     +  s_linget(i_comma_pos(102)+1:i_comma_pos(103)-1)
      ENDIF
c****
c     (104) Observationperiodsf4 - value (103-104)
      IF (i_commacnt.GE.104) THEN
       i_lentest_observationperiodsf4=
     +     i_comma_pos(104)-i_comma_pos(103)-1
       IF (i_lentest_observationperiodsf4.GT.l_c1) THEN
        print*,'i_lentest_observationperiodsf4 over limit:',l_c1
        STOP 'get_params_single_line2'
       ENDIF
       s_observationperiodsf4_h=
     +  s_linget(i_comma_pos(103)+1:i_comma_pos(104)-1)
      ENDIF

c     (105) Observationperiodsf4 - qc (104-105)
      IF (i_commacnt.GE.105) THEN
       i_lentest_observationperiodsf4_qc=
     +     i_comma_pos(105)-i_comma_pos(104)-1
       IF (i_lentest_observationperiodsf4_qc.GT.l_c2) THEN
        print*,'i_lentest_observationperiodsf4_qc over limit:',l_c2
        STOP 'get_params_single_line2'
       ENDIF
       s_observationperiodsf4_qc=
     +  s_linget(i_comma_pos(104)+1:i_comma_pos(105)-1)
      ENDIF

 52   CONTINUE
c****
c****
c     (164) Stationpressure value (163-164)
      IF (i_commacnt.GE.164) THEN
       i_lentest_stationpressure =i_comma_pos(164)-i_comma_pos(163)-1
       IF (i_lentest_stationpressure.GT.l_c1) THEN
        print*,'i_lentest_stationpressure over limit:',l_c1
        STOP 'get_params_single_line2'
       ENDIF
       s_stationpressure_hpa=
     +  s_linget(i_comma_pos(163)+1:i_comma_pos(164)-1)
      ENDIF

c     (165) Stationpressure qc (164-165)
      IF (i_commacnt.GE.165) THEN
       i_lentest_stationpressure_qc =i_comma_pos(165)-i_comma_pos(164)-1
       IF (i_lentest_stationpressure_qc.GT.l_c2) THEN
        print*,'i_lentest_stationpressure_qc over limit:',l_c2
        STOP 'get_params_single_line2'
       ENDIF
       s_stationpressure_qc=
     +  s_linget(i_comma_pos(164)+1:i_comma_pos(165)-1)
      ENDIF
c*****
c*****
c      print*,'s_platformid=',          TRIM(s_platformid)
c      print*,'s_networktype=',         TRIM(s_networktype)
c      print*,'s_ncdc_ob_time=',        TRIM(s_ncdc_ob_time)
c      print*,'s_reporttypecode=',      TRIM(s_reporttypecode)
c      print*,'s_latitude=',            TRIM(s_latitude)
c      print*,'s_longitude=',           TRIM(s_longitude)
c      print*,'s_platformheight=',      TRIM(s_platformheight)
c      print*,'s_windspeed_ms=',        TRIM(s_windspeed_ms)
c      print*,'s_sealevelpressure_hpa=',TRIM(s_sealevelpressure_hpa)
c      print*,'s_stationpressure_hpa=', TRIM(s_stationpressure_hpa)
c*****
c      print*,'just leaving get_params_single_line2'

c      STOP 'get_params_single_line'

      RETURN
      END
