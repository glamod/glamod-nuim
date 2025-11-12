c     Subroutine to readin countrycode conversion information
c     23Aug2019: modified for IFF/MFF conversion program
c     21Mar2020: used for USAF update

      SUBROUTINE readin_countrycode2(l_rgh_subregion,
     +  s_directory_countrycode,s_countrycode_file,
     +  l_subregion,s_subregion_indexnumber,
     +  s_subregion_countrycode2,s_subregion_countrycode3,
     +  s_subregion_countryname)

      IMPLICIT NONE
c************************************************************************
c     Outside variables
      CHARACTER(LEN=300)  :: s_directory_countrycode
      CHARACTER(LEN=300)  :: s_countrycode_file
      INTEGER             :: l_rgh_subregion
      INTEGER             :: l_subregion
    
      CHARACTER(LEN=3)    :: s_subregion_indexnumber(300)  
      CHARACTER(LEN=2)    :: s_subregion_countrycode2(300)
      CHARACTER(LEN=3)    :: s_subregion_countrycode3(300)
      CHARACTER(LEN=80)   :: s_subregion_countryname(300)
c*****
c     Variables used within program
      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: io
      CHARACTER(LEN=300)  :: s_pathandname

      CHARACTER(LEN=100)  :: s_linget
      CHARACTER(LEN=100)  :: s_linsto(500)
      CHARACTER(LEN=100)  :: s_lindata(300)

      INTEGER             :: i_st
      INTEGER             :: i_en
c************************************************************************
c      print*,'just entered readin_countrycode'

      s_pathandname=
     +  TRIM(s_directory_countrycode)//TRIM(s_countrycode_file)

c     Read in lines
      ii=0

      OPEN(UNIT=1,FILE=TRIM(s_pathandname),FORM='formatted',
     +  STATUS='OLD',ACTION='READ')      

      DO 

c      Read data line
       READ(1,1002,IOSTAT=io) s_linget
1002   FORMAT(a100)
       IF (io .GT. 0) THEN
        WRITE(*,*) 'Check input. Something went wrong'
        GOTO 100
       ELSE IF (io .LT. 0) THEN 
c        WRITE(*,*) 'end of file reached'
        GOTO 100
       ELSE

        ii=ii+1
        s_linsto(ii)=s_linget

        IF (s_linget(1:2).EQ.'s-') THEN 
         i_st=ii+1
        ENDIF
        IF (s_linget(1:2).EQ.'e-') THEN 
         i_en=ii-1
        ENDIF

       ENDIF
      ENDDO                !end of line-counting loop

100   CONTINUE

      CLOSE(UNIT=1)

c      print*,'i_st,i_en=',i_st,i_en
c************************************************************************
c     Extract data from file

      ii=0
      DO i=i_st,i_en
       ii=ii+1
       s_lindata(ii)=s_linsto(i)
      ENDDO
      l_subregion=ii

      DO i=1,l_subregion
       s_linget=s_lindata(i)

       s_subregion_indexnumber(i) =s_linget(1:3)  
       s_subregion_countrycode2(i)=s_linget(13:14)
       s_subregion_countrycode3(i)=s_linget(16:18)
       s_subregion_countryname(i) =s_linget(20:100)

c       print*,'i=',i,s_subregion_indexnumber(i)//'x'//
c     +  s_subregion_countrycode2(i)//'x'//s_subregion_countrycode3(i)//
c     +  'x'//TRIM(s_subregion_countryname(i))
      ENDDO
c************************************************************************
c      print*,'just leaving readin_countrycode'

      RETURN
      END
