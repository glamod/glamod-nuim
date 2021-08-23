c     Subroutine to read in FIPS-3letter conversion
c     AJ_Kettle, Oct16/2018
c     23Aug2019: applied to iff/mff conversion routine
c     21Mar2020: used for USAF update

      SUBROUTINE readin_fips_3lett_conversion2(l_rgh_fips,
     +  s_directory_countrycode,s_fipscode_file,
     +  l_fips,s_convertfips_2lett,s_convertfips_3lett)

      IMPLICIT NONE
c************************************************************************
c     Variables from outside

      INTEGER             :: l_rgh_fips
      INTEGER             :: l_fips
      CHARACTER(LEN=2)    :: s_convertfips_2lett(l_rgh_fips)
      CHARACTER(LEN=3)    :: s_convertfips_3lett(l_rgh_fips)

      CHARACTER(LEN=300)  :: s_directory_countrycode
      CHARACTER(LEN=300)  :: s_fipscode_file
c*****
c     Variables used in program

      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: io
      CHARACTER(LEN=300)  :: s_pathandname

      CHARACTER(LEN=200)  :: s_linget
      CHARACTER(LEN=200)  :: s_linheader
      CHARACTER(LEN=200)  :: s_linsto(l_rgh_fips)
      CHARACTER(LEN=200)  :: s_lindata(l_rgh_fips)

      CHARACTER(LEN=1)    :: s_test

      INTEGER             :: i_len(l_rgh_fips)
      INTEGER             :: i_commacnt(l_rgh_fips)
      INTEGER             :: i_commapos(l_rgh_fips,10)
      INTEGER             :: i_commacnt_max
      INTEGER             :: i_lenmax

      CHARACTER(LEN=2)    :: s_get2
      CHARACTER(LEN=3)    :: s_get3

      CHARACTER(LEN=3)    :: s_3lett_orig(9)
      CHARACTER(LEN=3)    :: s_3lett_repl(9)

c************************************************************************
c      print*,'just entered readin_fips_3lett_conversion'

      s_pathandname=
     +  TRIM(s_directory_countrycode)//TRIM(s_fipscode_file)

c     Read in lines
      ii=0

      OPEN(UNIT=1,FILE=TRIM(s_pathandname),FORM='formatted',
     +  STATUS='OLD',ACTION='READ')      

c     Read header line
      READ(1,1002,IOSTAT=io) s_linheader

c     Initialize maximum counter
      i_commacnt_max=0   
      i_lenmax      =0

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
        s_linsto(ii)=s_linget

        i_len(ii)=LEN_TRIM(s_linget)
        i_lenmax=MAX(i_lenmax,i_len(ii))

c       Get commas & positions
        jj=0
        i_commacnt(ii)=0
        DO j=1,i_len(ii)
         s_test=s_linget(j:j)
         IF (s_test.EQ.',') THEN
          i_commacnt(ii)=i_commacnt(ii)+1
          i_commapos(ii,i_commacnt(ii))=j
         ENDIF 
        ENDDO

        i_commacnt_max=MAX(i_commacnt_max,i_commacnt(ii)) 

c        print*,'s_linget=',TRIM(s_linget)
c        print*,'i_commacnt=',i_commacnt(ii)
c        print*,'i_commapos1,2,3=',i_commapos(ii,1),
c     +    i_commapos(ii,2),i_commapos(ii,3)

        s_get2=s_linget(i_commapos(ii,1)+1:i_commapos(ii,2)-1)
        s_get3=s_linget(i_commapos(ii,2)+1:i_commapos(ii,3)-1)

c        print*,'s_get2='//s_get2//'='//s_get3//'=',ii

c        s_get2=s_linget(i_commapos(ii,1)+1:i_commapos(ii,1)+2)
c        s_get3=s_linget(i_commapos(ii,2)+1:i_commapos(ii,2)+3)

        s_convertfips_2lett(ii)=s_get2
        s_convertfips_3lett(ii)=s_get3

cc       Get countryname & countrycode2 with last comma position
c        i_st1=1
c        i_en1=i_commapos(ii,i_commacnt(ii))-1
c        i_st2=i_commapos(ii,i_commacnt(ii))+1
c        i_en2=i_commapos(ii,i_commacnt(ii))+2

c        s_fips_countryname(ii) =s_linget(i_st1:i_en1)
c        s_fips_countrycode2(ii)=s_linget(i_st2:i_en2)

c        CALL SLEEP(1)

       ENDIF
      ENDDO                !end of line-counting loop

100   CONTINUE

      CLOSE(UNIT=1)

      l_fips=ii

c     Output 2 & 3 letter codes
c      DO i=1,l_fips 
c       print*,'i...',i,'x'//s_convertfips_2lett(i)//'x'//
c     +    s_convertfips_3lett(i)
c      ENDDO

c      print*,'l_fips=',l_fips
c      print*,'i_commacnt_max=',i_commacnt_max
c      print*,'i_commacnt=',(i_commacnt(i),i=1,10)
c      print*,'i_lenmax=',i_lenmax
c************************************************************************
c     Hard wire corrections to 3-letter codes

      s_3lett_orig(1)='ROM'
      s_3lett_orig(2)='UKA'
      s_3lett_orig(3)='UZB'
      s_3lett_orig(4)='ZAR'
      s_3lett_orig(5)='ZWB'
      s_3lett_orig(6)='ANT'
      s_3lett_orig(7)='CXR'
      s_3lett_orig(8)='TMP'
      s_3lett_orig(9)='WLF'

      s_3lett_repl(1)='ROU'
      s_3lett_repl(2)='UKR'
      s_3lett_repl(3)='USB'
      s_3lett_repl(4)='COD'
      s_3lett_repl(5)='ZMB'
      s_3lett_repl(6)='ATF'
      s_3lett_repl(7)='CXV'
      s_3lett_repl(8)='TLS'
      s_3lett_repl(9)='WSM'

      DO i=1,l_fips
       DO j=1,9
        IF (TRIM(s_convertfips_3lett(i)).EQ.s_3lett_orig(j)) THEN
         s_convertfips_3lett(i)=s_3lett_repl(j)
        ENDIF
       ENDDO
      ENDDO 

c************************************************************************
c      print*,'just leaving readin_fips_3lett_conversion'

      RETURN 
      END
