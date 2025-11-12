c     Subroutine to convert variables units from C to K & hPa to Pa
c     AJ_Kettle, 09Dec2019

      SUBROUTINE convert_units_qff(f_ndflag,
     +    l_rgh_lines,l_lines,
     +    f_vec_airt_c,f_vec_dewp_c,
     +    f_vec_stnp_hpa,f_vec_slpr_hpa,
     +    s_vec_airt_origprec_empir_c,s_vec_dewp_origprec_empir_c,
     +    s_vec_stnp_origprec_empir_hpa,s_vec_slpr_origprec_empir_hpa,

     +    f_vec_airt_k,f_vec_dewp_k,
     +    f_vec_stnp_pa,f_vec_slpr_pa,
     +    s_vec_airt_k,s_vec_dewp_k,
     +    s_vec_stnp_pa,s_vec_slpr_pa,
     +    s_vec_airt_convprec_empir_k,s_vec_dewp_convprec_empir_k,
     +    s_vec_stnp_convprec_empir_pa,s_vec_slpr_convprec_empir_pa)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into subroutine

      REAL                :: f_ndflag

      INTEGER             :: l_rgh_lines
      INTEGER             :: l_lines

      REAL                :: f_vec_airt_c(l_rgh_lines)
      REAL                :: f_vec_dewp_c(l_rgh_lines)
      REAL                :: f_vec_stnp_hpa(l_rgh_lines)
      REAL                :: f_vec_slpr_hpa(l_rgh_lines)

      CHARACTER(LEN=*)    :: s_vec_airt_origprec_empir_c(l_rgh_lines) 
      CHARACTER(LEN=*)    :: s_vec_dewp_origprec_empir_c(l_rgh_lines)
      CHARACTER(LEN=*)    :: s_vec_stnp_origprec_empir_hpa(l_rgh_lines)
      CHARACTER(LEN=*)    :: s_vec_slpr_origprec_empir_hpa(l_rgh_lines)
c*****
c     Unit conversions of variables
      REAL                :: f_vec_airt_k(l_rgh_lines)
      REAL                :: f_vec_dewp_k(l_rgh_lines)
      REAL                :: f_vec_stnp_pa(l_rgh_lines)
      REAL                :: f_vec_slpr_pa(l_rgh_lines)

      CHARACTER(LEN=*)    :: s_vec_airt_k(l_rgh_lines)
      CHARACTER(LEN=*)    :: s_vec_dewp_k(l_rgh_lines)
      CHARACTER(LEN=*)    :: s_vec_stnp_pa(l_rgh_lines)
      CHARACTER(LEN=*)    :: s_vec_slpr_pa(l_rgh_lines)

      CHARACTER(LEN=*)    :: s_vec_airt_convprec_empir_k(l_rgh_lines)
      CHARACTER(LEN=*)    :: s_vec_dewp_convprec_empir_k(l_rgh_lines)
      CHARACTER(LEN=*)    :: s_vec_stnp_convprec_empir_pa(l_rgh_lines)
      CHARACTER(LEN=*)    :: s_vec_slpr_convprec_empir_pa(l_rgh_lines)
c*****
c     Variables used within subroutine

      INTEGER             :: i,j,k,ii,jj,kk

      CHARACTER(LEN=32)   :: s_temp
c************************************************************************
c      print*,'just entered convert_units_qff'

c*****
      DO i=1,l_lines

c      Initialize variables
       f_vec_airt_k(i) =f_ndflag
       f_vec_dewp_k(i) =f_ndflag
       f_vec_stnp_pa(i)=f_ndflag
       f_vec_slpr_pa(i)=f_ndflag

       IF (f_vec_airt_c(i).NE.f_ndflag) THEN 
        f_vec_airt_k(i)=273.15+f_vec_airt_c(i)
       ENDIF
       IF (f_vec_dewp_c(i).NE.f_ndflag) THEN 
        f_vec_dewp_k(i)=273.15+f_vec_dewp_c(i)
       ENDIF
       IF (f_vec_stnp_hpa(i).NE.f_ndflag) THEN 
        f_vec_stnp_pa(i)=f_vec_stnp_hpa(i)*100.0
       ENDIF
       IF (f_vec_slpr_hpa(i).NE.f_ndflag) THEN 
        f_vec_slpr_pa(i)=f_vec_slpr_hpa(i)*100.0
       ENDIF
      ENDDO
c*****
c     Convert float to character; hardwire precision to 2 for 273.15
      DO i=1,l_lines

c      AIRT
       IF (f_vec_airt_c(i).NE.f_ndflag) THEN 
c        WRITE(s_vec_airt_k(i),'(f10.2)') f_vec_airt_k(i)
        WRITE(s_temp,'(f10.2)') f_vec_airt_k(i)
        s_vec_airt_k(i)=ADJUSTL(s_temp)
        s_vec_airt_convprec_empir_k(i)='0.01'
       ENDIF

c      DEWP
       IF (f_vec_dewp_c(i).NE.f_ndflag) THEN 
c        WRITE(s_vec_dewp_k(i),'(f10.2)') f_vec_dewp_k(i)
        WRITE(s_temp,'(f10.2)') f_vec_dewp_k(i)
        s_vec_dewp_k(i)=ADJUSTL(s_temp)
        s_vec_dewp_convprec_empir_k(i)='0.01'
       ENDIF

c      STNP
       IF (f_vec_stnp_hpa(i).NE.f_ndflag) THEN 
c        WRITE(s_vec_stnp_pa(i),'(i10)') NINT(f_vec_stnp_pa(i))
        WRITE(s_temp,'(i10)') NINT(f_vec_stnp_pa(i))
        s_vec_stnp_pa(i)=ADJUSTL(s_temp)

c       Assess converted precision
        CALL assess_convprec_pressure(
     +    s_vec_stnp_origprec_empir_hpa(i),
     +    s_vec_stnp_convprec_empir_pa(i))
       ENDIF

c      SLPR
       IF (f_vec_slpr_hpa(i).NE.f_ndflag) THEN 
c        WRITE(s_vec_slpr_pa(i),'(i10)') NINT(f_vec_slpr_pa(i))
        WRITE(s_temp,'(i10)') NINT(f_vec_slpr_pa(i))
        s_vec_slpr_pa(i)=ADJUSTL(s_temp)

c       Assess converted precision
        CALL assess_convprec_pressure(
     +    s_vec_slpr_origprec_empir_hpa(i),
     +    s_vec_slpr_convprec_empir_pa(i))
       ENDIF


cc      PRECISION 1
c       IF (s_vec_tmax_origprec(i).EQ.'1') THEN 
c        WRITE(s_vec_tmax_k(i),'(f10.1)') f_vec_tmax_k(i)
c        GOTO 10
c       ENDIF
cc      PRECISION 2
c       IF (s_vec_tmax_origprec(i).EQ.'2') THEN 
c        WRITE(s_vec_tmax_k(i),'(f10.2)') f_vec_tmax_k(i)
c        GOTO 10
c       ENDIF
cc      PRECISION 3
c       IF (s_vec_tmax_origprec(i).EQ.'3') THEN 
c        WRITE(s_vec_tmax_k(i),'(f10.3)') f_vec_tmax_k(i)
c        GOTO 10
c       ENDIF

      ENDDO
c*****

c      print*,'f_vec_airt_c=',(f_vec_airt_c(i),i=1,10)
c      print*,'s_vec_airt_k=',(TRIM(s_vec_airt_k(i)),i=1,10)
c      print*,'s_vec_airt_convprec_empir_k',
c     +  (TRIM(s_vec_airt_convprec_empir_k(i)),i=1,10)

c      print*,'f_vec_dewp_c=',(f_vec_dewp_c(i),i=1,10)
c      print*,'s_vec_dewp_k=',(s_vec_dewp_k(i),i=1,10)
c      print*,'s_vec_dewp_convprec_empir_k',
c     +  (TRIM(s_vec_dewp_convprec_empir_k(i)),i=1,10)

c      print*,'just leaving convert_units_qff'
c      STOP 'convert_units_qff'

      RETURN
      END
