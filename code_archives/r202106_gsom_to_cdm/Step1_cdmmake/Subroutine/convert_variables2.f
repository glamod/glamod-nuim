c     Subroutine to convert variables
c     AJ_Kettle, 11Nov2018

      SUBROUTINE convert_variables2(f_ndflag,
     +    l_rgh_lines,l_lines,
     +    f_vec_tmax_c,f_vec_tmin_c,f_vec_tavg_c,
     +    s_vec_tmax_origprec,s_vec_tmin_origprec,s_vec_tavg_origprec,

     +    f_vec_tmax_k,f_vec_tmin_k,f_vec_tavg_k,
     +    s_vec_tmax_k,s_vec_tmin_k,s_vec_tavg_k)

c (f_ndflag,
c     +    l_rgh_lines,l_lines,
c     +    f_vec_tmax_c,f_vec_tmin_c,f_vec_tavg_c,
c     +    f_vec_tmax_k,f_vec_tmin_k,f_vec_tavg_k)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into program

      REAL                :: f_ndflag

      INTEGER             :: l_rgh_lines
      INTEGER             :: l_lines

      REAL                :: f_vec_tmax_c(l_rgh_lines)
      REAL                :: f_vec_tmin_c(l_rgh_lines)
      REAL                :: f_vec_tavg_c(l_rgh_lines)

      CHARACTER(LEN=1)    :: s_vec_tmax_origprec(l_rgh_lines) 
      CHARACTER(LEN=1)    :: s_vec_tmin_origprec(l_rgh_lines)
      CHARACTER(LEN=1)    :: s_vec_tavg_origprec(l_rgh_lines)

      REAL                :: f_vec_tmax_k(l_rgh_lines)
      REAL                :: f_vec_tmin_k(l_rgh_lines)
      REAL                :: f_vec_tavg_k(l_rgh_lines)

      CHARACTER(LEN=10)   :: s_vec_tmax_k(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_tmin_k(l_rgh_lines)
      CHARACTER(LEN=10)   :: s_vec_tavg_k(l_rgh_lines)
c*****
c     Variables used in program

      INTEGER             :: i,j,k,ii,jj,kk
c************************************************************************
c      print*,'just entered convert_variables'

c      print*,'f_ndflag=',f_ndflag

c      print*,'l_rgh_lines,l_lines=',l_rgh_lines,l_lines

c      print*,'f_vec_tmax_c=',(f_vec_tmax_c(i),i=1,6)
c      print*,'f_vec_tmin_c=',(f_vec_tmin_c(i),i=1,6)
c      print*,'f_vec_tavg_c=',(f_vec_tavg_c(i),i=1,6)

      DO i=1,l_lines

c      Initialize variables
       f_vec_tmax_k(i)=f_ndflag
       f_vec_tmin_k(i)=f_ndflag
       f_vec_tavg_k(i)=f_ndflag

       IF (f_vec_tmax_c(i).NE.f_ndflag) THEN 
        f_vec_tmax_k(i)=273.15+f_vec_tmax_c(i)
       ENDIF
       IF (f_vec_tmin_c(i).NE.f_ndflag) THEN 
        f_vec_tmin_k(i)=273.15+f_vec_tmin_c(i)
       ENDIF
       IF (f_vec_tavg_c(i).NE.f_ndflag) THEN 
        f_vec_tavg_k(i)=273.15+f_vec_tavg_c(i)
       ENDIF
      ENDDO
c************************************************************************
c     Convert float to character; hardwire precision to 2 for 273.15
      DO i=1,l_lines
       IF (f_vec_tmax_c(i).NE.f_ndflag) THEN 
        WRITE(s_vec_tmax_k(i),'(f10.2)') f_vec_tmax_k(i)
       ENDIF
       IF (f_vec_tmin_c(i).NE.f_ndflag) THEN 
        WRITE(s_vec_tmin_k(i),'(f10.2)') f_vec_tmin_k(i)
       ENDIF
       IF (f_vec_tavg_c(i).NE.f_ndflag) THEN 
        WRITE(s_vec_tavg_k(i),'(f10.2)') f_vec_tavg_k(i)
       ENDIF
      ENDDO
c************************************************************************
      GOTO 50

c     Convert float to character
      DO i=1,l_lines
       IF (f_vec_tmax_c(i).NE.f_ndflag) THEN 

c      PRECISION 1
       IF (s_vec_tmax_origprec(i).EQ.'1') THEN 
        WRITE(s_vec_tmax_k(i),'(f10.1)') f_vec_tmax_k(i)
        GOTO 10
       ENDIF
c      PRECISION 2
       IF (s_vec_tmax_origprec(i).EQ.'2') THEN 
        WRITE(s_vec_tmax_k(i),'(f10.2)') f_vec_tmax_k(i)
        GOTO 10
       ENDIF
c      PRECISION 3
       IF (s_vec_tmax_origprec(i).EQ.'3') THEN 
        WRITE(s_vec_tmax_k(i),'(f10.3)') f_vec_tmax_k(i)
        GOTO 10
       ENDIF

       print*,'TMAX series'
       print*,'i...',i,f_vec_tmax_c(i),f_vec_tmax_k(i)
       print*,'s_vec_tmax_origprec=',TRIM(s_vec_tmax_origprec(i))

       STOP 'convert_variables2; origprec not found'
 10    CONTINUE

       ENDIF
      ENDDO

      DO i=1,l_lines
       IF (f_vec_tmin_c(i).NE.f_ndflag) THEN 

       IF (s_vec_tmin_origprec(i).EQ.'1') THEN 
        WRITE(s_vec_tmin_k(i),'(f10.1)') f_vec_tmin_k(i)
        GOTO 20
       ENDIF
       IF (s_vec_tmin_origprec(i).EQ.'2') THEN 
        WRITE(s_vec_tmin_k(i),'(f10.2)') f_vec_tmin_k(i)
        GOTO 20
       ENDIF
       IF (s_vec_tmin_origprec(i).EQ.'3') THEN 
        WRITE(s_vec_tmin_k(i),'(f10.3)') f_vec_tmin_k(i)
        GOTO 20
       ENDIF

       print*,'TMIN series'
       print*,'i...',i,f_vec_tmin_c(i),f_vec_tmin_k(i)
       print*,'s_vec_tmin_origprec=',TRIM(s_vec_tmin_origprec(i))

       STOP 'convert_variables2; origprec not found'
 20    CONTINUE
      
       ENDIF
      ENDDO

      DO i=1,l_lines
       IF (f_vec_tavg_c(i).NE.f_ndflag) THEN 

       IF (s_vec_tavg_origprec(i).EQ.'1') THEN 
        WRITE(s_vec_tavg_k(i),'(f10.1)') f_vec_tavg_k(i)
        GOTO 30
       ENDIF
       IF (s_vec_tavg_origprec(i).EQ.'2') THEN 
        WRITE(s_vec_tavg_k(i),'(f10.2)') f_vec_tavg_k(i)
        GOTO 30
       ENDIF
       IF (s_vec_tavg_origprec(i).EQ.'3') THEN 
        WRITE(s_vec_tavg_k(i),'(f10.3)') f_vec_tavg_k(i)
        GOTO 30
       ENDIF

       print*,'TAVG series'
       print*,'i...',i,f_vec_tavg_c(i),f_vec_tavg_k(i)
       print*,'s_vec_tavg_origprec=',TRIM(s_vec_tavg_origprec(i))

       STOP 'convert_variables2; origprec not found'
30     CONTINUE

       ENDIF
      ENDDO

 50   CONTINUE

c      print*,'f_vec_tmax_c=',(f_vec_tmax_c(i),i=1,l_lines)
c      print*,'f_vec_tmin_c=',(f_vec_tmin_c(i),i=1,l_lines)
c      print*,'f_vec_tavg_c=',(f_vec_tavg_c(i),i=1,l_lines)

c      print*,'f_vec_tmax_k=',(f_vec_tmax_k(i),i=1,l_lines)
c      print*,'f_vec_tmin_k=',(f_vec_tmin_k(i),i=1,l_lines)
c      print*,'f_vec_tavg_k=',(f_vec_tavg_k(i),i=1,l_lines)

c      print*,'s_vec_tmax_k=',(TRIM(s_vec_tmax_k(i)),i=1,l_lines)
c      print*,'s_vec_tmin_k=',(TRIM(s_vec_tmin_k(i)),i=1,l_lines)
c      print*,'s_vec_tavg_k=',(TRIM(s_vec_tavg_k(i)),i=1,l_lines)

c      print*,'s_vec_tmax_origprec',
c     +   (TRIM(s_vec_tmax_origprec(i)),i=1,l_lines) 
c      print*,'s_vec_tmin_origprec',
c     +   (TRIM(s_vec_tmin_origprec(i)),i=1,l_lines)
c      print*,'s_vec_tavg_origprec',
c     +   (TRIM(s_vec_tavg_origprec(i)),i=1,l_lines)

c      print*,'just leaving convert_variables'
c      STOP 'convert_variables2'

      RETURN
      END
