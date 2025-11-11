c     Subroutine to get start & end year from 6 variables
c     AJ_Kettle, 29Aug2019
c     17Mar2020: used for USAF update

      SUBROUTINE get_startend_from_6var3(
     +  l_rgh_datalines,i_triplediff_cnt,
     +  i_triplet_datacnt_good_wdir,i_triplet_datacnt_good_wspd,
     +  i_triplet_datacnt_good_airt,i_triplet_datacnt_good_dewp,
     +  i_triplet_datacnt_good_slp,i_triplet_datacnt_good_stnp,
     +  s_triplet_st_year_wdir,s_triplet_en_year_wdir, 
     +  s_triplet_st_year_wspd,s_triplet_en_year_wspd, 
     +  s_triplet_st_year_airt,s_triplet_en_year_airt, 
     +  s_triplet_st_year_dewp,s_triplet_en_year_dewp, 
     +  s_triplet_st_year_slp,s_triplet_en_year_slp, 
     +  s_triplet_st_year_stnp,s_triplet_en_year_stnp,
     +  s_year_st_g6,s_year_en_g6,
     +  s_assemble_varcode)

      IMPLICIT NONE
c************************************************************************
c     Declare variables 

      INTEGER            :: l_rgh_datalines
      INTEGER            :: i_triplediff_cnt

      INTEGER            :: i_triplet_datacnt_good_wdir(l_rgh_datalines)
      INTEGER            :: i_triplet_datacnt_good_wspd(l_rgh_datalines)
      INTEGER            :: i_triplet_datacnt_good_airt(l_rgh_datalines)
      INTEGER            :: i_triplet_datacnt_good_dewp(l_rgh_datalines)
      INTEGER            :: i_triplet_datacnt_good_slp(l_rgh_datalines)
      INTEGER            :: i_triplet_datacnt_good_stnp(l_rgh_datalines)

      CHARACTER(LEN=4)    :: s_triplet_st_year_wdir(l_rgh_datalines)
      CHARACTER(LEN=4)    :: s_triplet_en_year_wdir(l_rgh_datalines)
      CHARACTER(LEN=4)    :: s_triplet_st_year_wspd(l_rgh_datalines)
      CHARACTER(LEN=4)    :: s_triplet_en_year_wspd(l_rgh_datalines)
      CHARACTER(LEN=4)    :: s_triplet_st_year_airt(l_rgh_datalines)
      CHARACTER(LEN=4)    :: s_triplet_en_year_airt(l_rgh_datalines)
      CHARACTER(LEN=4)    :: s_triplet_st_year_dewp(l_rgh_datalines)
      CHARACTER(LEN=4)    :: s_triplet_en_year_dewp(l_rgh_datalines)
      CHARACTER(LEN=4)    :: s_triplet_st_year_slp(l_rgh_datalines)
      CHARACTER(LEN=4)    :: s_triplet_en_year_slp(l_rgh_datalines)
      CHARACTER(LEN=4)    :: s_triplet_st_year_stnp(l_rgh_datalines)
      CHARACTER(LEN=4)    :: s_triplet_en_year_stnp(l_rgh_datalines)

      CHARACTER(LEN=4)    :: s_year_st_g6(l_rgh_datalines)
      CHARACTER(LEN=4)    :: s_year_en_g6(l_rgh_datalines)   

      CHARACTER(LEN=30)   :: s_assemble_varcode(l_rgh_datalines)
c*****
c     Variables used within subroutine

      INTEGER             :: i,j,k,ii,jj,kk

      CHARACTER(LEN=10)   :: s_date_single_st
      CHARACTER(LEN=10)   :: s_date_single_en

      CHARACTER(LEN=4)    :: s_year_single_st
      CHARACTER(LEN=4)    :: s_year_single_en
      INTEGER             :: i_year_single_st
      INTEGER             :: i_year_single_en

      CHARACTER(LEN=4)    :: s_vec_year_st(6)
      CHARACTER(LEN=4)    :: s_vec_year_en(6)
      INTEGER             :: i_vec_year_st(6)
      INTEGER             :: i_vec_year_en(6)

      INTEGER             :: i_min_year_st
      INTEGER             :: i_max_year_en
      CHARACTER(LEN=4)    :: s_min_year_st
      CHARACTER(LEN=4)    :: s_max_year_en

      CHARACTER(LEN=3)    :: s_vec_varcode(6) 

      CHARACTER(LEN=30)   :: s_build_list
      CHARACTER(LEN=30)   :: s_build_list2

      INTEGER             :: l_element
      INTEGER             :: i_len
c************************************************************************
c      print*,'just entered get_startend_from_6var3'

c*****
c     Assign variable codes (from Github tables)
      s_vec_varcode(1)='106'   
      s_vec_varcode(2)='107'
      s_vec_varcode(3)='85'
      s_vec_varcode(4)='36'
      s_vec_varcode(5)='58'
      s_vec_varcode(6)='57'   
c*****
c     Initialize variables to be passed out
      DO i=1,i_triplediff_cnt
       s_year_st_g6(i)      =''
       s_year_en_g6(i)      =''
       s_assemble_varcode(i)=''
      ENDDO
c*****
c     Cycle through all triplets

      DO i=1,i_triplediff_cnt

       ii=0                        !counter for 6 element vector
       s_build_list='{'            !initialize varcode list

c      1.WDIR
       IF (i_triplet_datacnt_good_wdir(i).GT.0) THEN 
        s_build_list=TRIM(s_build_list)//TRIM(s_vec_varcode(1))//','

c        print*,'wdir year',
c     +    s_triplet_st_year_wdir(i),s_triplet_en_year_wdir(i)

        s_year_single_st=s_triplet_st_year_wdir(i)
        s_year_single_en=s_triplet_en_year_wdir(i)

c        s_date_single_st=s_triplet_st_date_dd_mm_yyyy_wdir(i)
c        s_date_single_en=s_triplet_en_date_dd_mm_yyyy_wdir(i)

c        s_year_single_st=s_date_single_st(7:10)
c        s_year_single_en=s_date_single_en(7:10)

        READ(s_year_single_st,'(i4)') i_year_single_st
        READ(s_year_single_en,'(i4)') i_year_single_en

        ii=ii+1
        i_vec_year_st(ii)=i_year_single_st
        i_vec_year_en(ii)=i_year_single_en
       ENDIF

c      2.WSPD
       IF (i_triplet_datacnt_good_wspd(i).GT.0) THEN 
        s_build_list=TRIM(s_build_list)//TRIM(s_vec_varcode(2))//','

        s_year_single_st=s_triplet_st_year_wspd(i)
        s_year_single_en=s_triplet_en_year_wspd(i)

c        s_date_single_st=s_triplet_st_date_dd_mm_yyyy_wspd(i)
c        s_date_single_en=s_triplet_en_date_dd_mm_yyyy_wspd(i)

c        s_year_single_st=s_date_single_st(7:10)
c        s_year_single_en=s_date_single_en(7:10)

        READ(s_year_single_st,'(i4)') i_year_single_st
        READ(s_year_single_en,'(i4)') i_year_single_en

        ii=ii+1
        i_vec_year_st(ii)=i_year_single_st
        i_vec_year_en(ii)=i_year_single_en
       ENDIF

c      3.AIRT
       IF (i_triplet_datacnt_good_airt(i).GT.0) THEN 
        s_build_list=TRIM(s_build_list)//TRIM(s_vec_varcode(3))//','

        s_year_single_st=s_triplet_st_year_airt(i)
        s_year_single_en=s_triplet_en_year_airt(i)

c        s_date_single_st=s_triplet_st_date_dd_mm_yyyy_airt(i)
c        s_date_single_en=s_triplet_en_date_dd_mm_yyyy_airt(i)

c        s_year_single_st=s_date_single_st(7:10)
c        s_year_single_en=s_date_single_en(7:10)

        READ(s_year_single_st,'(i4)') i_year_single_st
        READ(s_year_single_en,'(i4)') i_year_single_en

        ii=ii+1
        i_vec_year_st(ii)=i_year_single_st
        i_vec_year_en(ii)=i_year_single_en
       ENDIF

c      4.DEWP
       IF (i_triplet_datacnt_good_dewp(i).GT.0) THEN 
        s_build_list=TRIM(s_build_list)//TRIM(s_vec_varcode(4))//','

        s_year_single_st=s_triplet_st_year_dewp(i)
        s_year_single_en=s_triplet_en_year_dewp(i)

c        s_date_single_st=s_triplet_st_date_dd_mm_yyyy_dewp(i)
c        s_date_single_en=s_triplet_en_date_dd_mm_yyyy_dewp(i)

c        s_year_single_st=s_date_single_st(7:10)
c        s_year_single_en=s_date_single_en(7:10)

        READ(s_year_single_st,'(i4)') i_year_single_st
        READ(s_year_single_en,'(i4)') i_year_single_en

        ii=ii+1
        i_vec_year_st(ii)=i_year_single_st
        i_vec_year_en(ii)=i_year_single_en
       ENDIF

c      5.SLP
       IF (i_triplet_datacnt_good_slp(i).GT.0) THEN 
        s_build_list=TRIM(s_build_list)//TRIM(s_vec_varcode(5))//','

        s_year_single_st=s_triplet_st_year_slp(i)
        s_year_single_en=s_triplet_en_year_slp(i)

c        s_date_single_st=s_triplet_st_date_dd_mm_yyyy_slp(i)
c        s_date_single_en=s_triplet_en_date_dd_mm_yyyy_slp(i)

c        s_year_single_st=s_date_single_st(7:10)
c        s_year_single_en=s_date_single_en(7:10)

        READ(s_year_single_st,'(i4)') i_year_single_st
        READ(s_year_single_en,'(i4)') i_year_single_en

        ii=ii+1
        i_vec_year_st(ii)=i_year_single_st
        i_vec_year_en(ii)=i_year_single_en
       ENDIF

c      6.STNP
       IF (i_triplet_datacnt_good_stnp(i).GT.0) THEN
        s_build_list=TRIM(s_build_list)//TRIM(s_vec_varcode(6))//','
 
        s_year_single_st=s_triplet_st_year_stnp(i)
        s_year_single_en=s_triplet_en_year_stnp(i)

c        s_date_single_st=s_triplet_st_date_dd_mm_yyyy_stnp(i)
c        s_date_single_en=s_triplet_en_date_dd_mm_yyyy_stnp(i)

c        s_year_single_st=s_date_single_st(7:10)
c        s_year_single_en=s_date_single_en(7:10)

        READ(s_year_single_st,'(i4)') i_year_single_st
        READ(s_year_single_en,'(i4)') i_year_single_en

        ii=ii+1
        i_vec_year_st(ii)=i_year_single_st
        i_vec_year_en(ii)=i_year_single_en
       ENDIF

c      terminate varcode list
       i_len=LEN_TRIM(s_build_list)
       s_build_list2=s_build_list(1:i_len-1)
       s_build_list2=TRIM(s_build_list2)//'}'
       s_assemble_varcode(i)=s_build_list2

       l_element=ii

c      Set var code list to blank if no values present
       IF (l_element.EQ.0) THEN
        s_assemble_varcode(i)='{}'
       ENDIF

c      Find min/max vector
       s_min_year_st=''           !initialize variables
       s_max_year_en=''
       IF (l_element.GT.0) THEN   !change start/end year if any var present 

        i_min_year_st=+10000
        i_max_year_en=-10000

        DO ii=1,l_element
         i_min_year_st=MIN(i_min_year_st,i_vec_year_st(ii))
         i_max_year_en=MAX(i_max_year_en,i_vec_year_en(ii))
        ENDDO

c       Convert integer to string
        WRITE(s_min_year_st,'(i4)') i_min_year_st
        WRITE(s_max_year_en,'(i4)') i_max_year_en
       ENDIF

c      Archive results
       s_year_st_g6(i)=s_min_year_st
       s_year_en_g6(i)=s_max_year_en

c       print*,'i,l_element=',i,l_element
c       print*,'i_vec_year_st=',(i_vec_year_st(ii),ii=1,l_element)
c       print*,'i_vec_year_en=',(i_vec_year_en(ii),ii=1,l_element)
c       print*,'good=',
c     +  i_triplet_datacnt_good_wdir(i),i_triplet_datacnt_good_wspd(i),
c     +  i_triplet_datacnt_good_airt(i),i_triplet_datacnt_good_dewp(i),
c     +  i_triplet_datacnt_good_slp(i),i_triplet_datacnt_good_stnp(i)
c       print*,'i_min_year_st...',i_min_year_st,i_max_year_en
c       print*,'s_min_year_st...',s_min_year_st,s_max_year_en
c       print*,'s_assemble_varcode...',s_assemble_varcode(i)

      ENDDO    !Close i-index
c*****
c*****
c      print*,'just leaving get_startend_from_6var3'

      RETURN
      END
