c     Subroutine to remove duplicate data from claremorris(auto)
c     AJ_Kettle, Dec18/2017

      SUBROUTINE clean_daydata(l_mlent,s_filename,s_filename_test,
     +   l_datalines_pre,s_vec_stnnum_pre,
     +   s_vec_date_pre,s_vec_time_pre,
     +   f_vec_rain_mm_pre,f_vec_maxdy_c_pre,f_vec_mindy_c_pre,
     +   f_vec_airt_k_pre,

     +   l_datalines,s_vec_stnnum,
     +   s_vec_date,s_vec_time,
     +   f_vec_rain_mm,f_vec_maxdy_c,f_vec_mindy_c,
     +   f_vec_airt_k)

      IMPLICIT NONE
c************************************************************************
c     Declare variables

      INTEGER             :: l_mlent
      INTEGER             :: i,j,k,ii,jj,kk

      CHARACTER(LEN=300)  :: s_filename
      CHARACTER(LEN=300)  :: s_filename_test

c     preliminary data
      INTEGER             :: l_datalines_pre
      CHARACTER(LEN=8)    :: s_vec_stnnum_pre(l_mlent)    
      CHARACTER(LEN=10)   :: s_vec_date_pre(l_mlent)
      CHARACTER(LEN=8)    :: s_vec_time_pre(l_mlent)
      REAL                :: f_vec_rain_mm_pre(l_mlent)        
      REAL                :: f_vec_maxdy_c_pre(l_mlent)         
      REAL                :: f_vec_mindy_c_pre(l_mlent)         

c     data after correction for duplicates
      INTEGER             :: l_datalines
      CHARACTER(LEN=8)    :: s_vec_stnnum(l_mlent)    
      CHARACTER(LEN=10)   :: s_vec_date(l_mlent)
      CHARACTER(LEN=8)    :: s_vec_time(l_mlent)
      REAL                :: f_vec_rain_mm(l_mlent)        
      REAL                :: f_vec_maxdy_c(l_mlent)         
      REAL                :: f_vec_mindy_c(l_mlent)         

      REAL                :: f_vec_airt_k_pre(l_mlent) 
      REAL                :: f_vec_airt_k(l_mlent) 

      CHARACTER(LEN=10)   :: s_date_single 
      CHARACTER(LEN=4)    :: s_year
      CHARACTER(LEN=2)    :: s_month
      CHARACTER(LEN=2)    :: s_day

      INTEGER             :: i_vec_flag(l_mlent)
      INTEGER             :: i_accum
c************************************************************************
      print*,'just entered clean_daydata'
c      print*,'s_filename',TRIM(s_filename)
c      print*,'s_filename_test',TRIM(s_filename_test)
c      CALL SLEEP(1)

      IF (TRIM(s_filename).EQ.TRIM(s_filename_test)) THEN 
c       print*,'match found'
c       CALL SLEEP(5)

       i_accum=0
       DO i=1,l_datalines_pre
        i_vec_flag(i)=0         

        s_date_single=s_vec_date_pre(i)
        s_year =s_date_single(1:4)
        s_month=s_date_single(6:7)
        s_day  =s_date_single(9:10)

        IF (s_date_single.EQ.'2011/08/30') THEN
         i_accum=i_accum+1
         i_vec_flag(i)=i_accum

c         print*,'match x found' 
        ENDIF
       ENDDO

       ii=1
       DO i=1,l_datalines_pre 
c       Criterion to remove 2nd case of aug30 2011
c        IF (LEN_TRIM(s_vec_time_pre(i)).NE.0) THEN  
        IF (i_vec_flag(i).LT.1) THEN 
         s_vec_stnnum(ii) =s_vec_stnnum_pre(i)  
         s_vec_date(ii)   =s_vec_date_pre(i)
         s_vec_time(ii)   =s_vec_time_pre(i)
         f_vec_rain_mm(ii)=f_vec_rain_mm_pre(i)      
         f_vec_maxdy_c(ii)=f_vec_maxdy_c_pre(i)         
         f_vec_mindy_c(ii)=f_vec_mindy_c_pre(i)         

         f_vec_airt_k(ii) =f_vec_airt_k_pre(i)
         ii=ii+1
        ENDIF
        IF (i_vec_flag(i).EQ.2) THEN  
         print*,'duplicate found'
        ENDIF
       ENDDO

       l_datalines=l_datalines_pre-1
c       print*,'l_datalines...',l_datalines,l_datalines_pre

      ENDIF

      IF (.NOT.(TRIM(s_filename).EQ.TRIM(s_filename_test))) THEN 
       l_datalines=l_datalines_pre

       DO i=1,l_datalines 
        s_vec_stnnum(i) =s_vec_stnnum_pre(i)  
        s_vec_date(i)   =s_vec_date_pre(i)
        s_vec_time(i)   =s_vec_time_pre(i)
        f_vec_rain_mm(i)=f_vec_rain_mm_pre(i)      
        f_vec_maxdy_c(i)=f_vec_maxdy_c_pre(i)         
        f_vec_mindy_c(i)=f_vec_mindy_c_pre(i)         

        f_vec_airt_k(i) =f_vec_airt_k_pre(i) 
       ENDDO
      ENDIF

c************************************************************************
c      print*,'just leaving clean_daydata'

      RETURN
      END