c     Subroutine to read in data file
c     AJ_Kettle, Sep28/2017

      SUBROUTINE get_day_data_historical1(s_pathandname,f_ndflag,
     +   l_prod,l_prod_fulluse,
     +   s_day_date,s_daytot_pptflg,
     +   f_dayavg_airt_c,f_dayavg_vapprs_mb,f_dayavg_ccov_okta,
     +   f_dayavg_pres_mb,f_dayavg_relh_pc,f_dayavg_wspd_ms,
     +   f_daymax_airt_c,f_daymin_airt_c,f_daymin_minbod_c,
     +   f_daymax_gust_ms,f_daytot_ppt_mm,f_daytot_sundur_h,
     +   f_daytot_snoacc_cm)

c      dayavg_airt_c
c      dayavg_vapprs_mb
c      dayavg_ccov_okta
c      dayavg_pres_mb
c      dayavg_relh_pc
c      dayavg_wspd_ms
c      daymax_airt_c
c      daymin_airt_c
c      daymin_minbod_c
c      daymax_gust_ms
c      daytot_ppt_mm
c      daytot_sundur_h
c      daytot_snoacc_cm

      IMPLICIT NONE
c************************************************************************
      CHARACTER(LEN=200)  :: s_pathandname

      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: io

      REAL                :: f_ndflag
      CHARACTER(LEN=400)  :: s_linget
      CHARACTER(LEN=400)  :: s_lindat(100000)

      INTEGER             :: i_cnt,i_pos(20),i_pos_st(20),i_pos_en(20)
      INTEGER             :: l_commacnt
c      INTEGER             :: i_pos_loc(20)
      INTEGER             :: l_header,l_header_m1
      CHARACTER(LEN=30)   :: s_vec_headername(20)

      INTEGER             :: l_linelimit
      INTEGER             :: l_prod_full
      INTEGER             :: l_prod_fulluse
      INTEGER             :: l_prod
      INTEGER             :: i_error
      CHARACTER(LEN=8)    :: s_matrix_field(100000,20)

      INTEGER             :: i_rec_commacnt(100000)
      INTEGER             :: i_rec_errorcnt(100000)
      INTEGER             :: i_max_errorcnt

      INTEGER             :: i_fieldwidth(20)

      CHARACTER(LEN=8)    :: s_day_date(100000)
      CHARACTER(LEN=10)   :: s_dayavg_airt_c(100000)
      CHARACTER(LEN=10)   :: s_dayavg_vapprs_mb(100000)
      CHARACTER(LEN=10)   :: s_dayavg_ccov_okta(100000)
      CHARACTER(LEN=10)   :: s_dayavg_pres_mb(100000)
      CHARACTER(LEN=10)   :: s_dayavg_relh_pc(100000)
      CHARACTER(LEN=10)   :: s_dayavg_wspd_ms(100000)
      CHARACTER(LEN=10)   :: s_daymax_airt_c(100000)
      CHARACTER(LEN=10)   :: s_daymin_airt_c(100000)
      CHARACTER(LEN=10)   :: s_daymin_minbod_c(100000)
      CHARACTER(LEN=10)   :: s_daymax_gust_ms(100000)
      CHARACTER(LEN=10)   :: s_daytot_ppt_mm(100000)
      CHARACTER(LEN=10)   :: s_daytot_pptflg(100000)
      CHARACTER(LEN=10)   :: s_daytot_sundur_h(100000)
      CHARACTER(LEN=10)   :: s_daytot_snoacc_cm(100000)  

      CHARACTER(LEN=10)   :: s_test
      CHARACTER(LEN=8)    :: s_test8
      REAL                :: f_test
      INTEGER             :: i_test

      REAL                :: f_dayavg_airt_c(100000)
      REAL                :: f_dayavg_vapprs_mb(100000)
      REAL                :: f_dayavg_ccov_okta(100000)
      REAL                :: f_dayavg_pres_mb(100000)
      REAL                :: f_dayavg_relh_pc(100000)
      REAL                :: f_dayavg_wspd_ms(100000)
      REAL                :: f_daymax_airt_c(100000)
      REAL                :: f_daymin_airt_c(100000)
      REAL                :: f_daymin_minbod_c(100000)
      REAL                :: f_daymax_gust_ms(100000)
      REAL                :: f_daytot_ppt_mm(100000)
      REAL                :: f_daytot_sundur_h(100000)
      REAL                :: f_daytot_snoacc_cm(100000)  

      CHARACTER(LEN=4)    :: s_year
c      CHARACTER(LEN=2)    :: s_month
c      CHARACTER(LEN=2)    :: s_day
      INTEGER             :: i_year
c      INTEGER             :: i_month
c      INTEGER             :: i_day
      INTEGER              :: i_day_year(100000)

c************************************************************************
c      print*,'just inside get_day_data_historical1'

      OPEN(UNIT=1,FILE=s_pathandname,FORM='formatted',
     +  STATUS='OLD',ACTION='READ') 

c     Read in header
      READ(1,1000,IOSTAT=io) s_linget
1000  FORMAT(a400)

c     Find location of semicolons
      i_cnt=1
      DO j=1,400
       IF (s_linget(j:j).EQ.';') THEN
        i_pos(i_cnt)=j
        i_cnt=i_cnt+1
       ENDIF
c      On header line eor always at end
       IF (s_linget(j:j+2).EQ.'eor') THEN
        GOTO 101
       ENDIF
      ENDDO
101   CONTINUE

      l_header   =i_cnt
      l_header_m1=l_header-1

c      print*,'l_header=',l_header,l_header_m1
c      print*,'i_pos=',(i_pos(j),j=1,l_header)
c*************************************************************************
c     Get all header names
      s_vec_headername(1)=s_linget(1:i_pos(1)-1)  
      DO j=2,l_header_m1
       s_vec_headername(j)=
     +  TRIM(ADJUSTL(s_linget(i_pos(j-1)+1:i_pos(j)-1)))  
      ENDDO
      s_vec_headername(l_header_m1+1)=
     +   s_linget(i_pos(l_header_m1)+1:i_pos(l_header_m1)+10)

c      print*,'i_pos(l_header)=',i_pos(l_header),i_pos(l_header+1)

c      print*,'s_vec_headername=',
c     +   ( TRIM(ADJUSTL(s_vec_headername(j))),j=1,l_header )
c************************************************************************
c     Read lines of data
      ii=1

      l_linelimit=100000

      DO 
       READ(1,1000,IOSTAT=io) s_linget
   
       IF (io .GT. 0) THEN
        WRITE(*,*) 'Check input. Something went wrong'
        GOTO 100
       ELSE IF (io .LT. 0) THEN 
c        WRITE(*,*) 'end of file reached'
        GOTO 100
       ELSE

c       Archive original line
c        s_lindat(ii)='x'//TRIM(ADJUSTL(s_linget))//'x'
        s_lindat(ii)=s_linget
        ii=ii+1

        IF (ii.EQ.l_linelimit) THEN
         print*,'Emergency stop, line limit exceeded,ii',ii
         CALL SLEEP(5)
        ENDIF

       ENDIF

      ENDDO
100   CONTINUE

      CLOSE(UNIT=1)

      l_prod_full=ii-1
      l_prod_fulluse=l_prod_full-1

c      print*,'l_prod=',l_prod
c************************************************************************
c     Extract full matrix of info
     
      DO j=1,l_prod_fulluse
       s_linget=s_lindat(j)

c      Initializations
       i_cnt=1
       i_error=0
       DO k=1,20 
        i_pos_en(i_cnt) =k
        i_pos_st(i_cnt) =k
c        i_pos_loc(i_cnt)=k
       ENDDO

       DO k=1,398

c       Normal case semi-colon
        IF (s_linget(k:k).EQ.';') THEN
         i_pos(i_cnt)=k
         i_pos_en(i_cnt) =k
         i_pos_st(i_cnt) =k
c         i_pos_loc(i_cnt)=k

         i_cnt=i_cnt+1
        ENDIF
cc       Error case 'eor'
c        IF (s_linget(k:k+2).EQ.'eor') THEN
c         i_pos(i_cnt)=k+2
c         i_pos_en(i_cnt)=k
c         i_pos_st(i_cnt)=k+2
c         i_cnt=i_cnt+1
c         i_error=i_error+1
c        ENDIF

       ENDDO                 !close k-index

       l_commacnt=i_cnt-1

       i_rec_commacnt(j)  =l_commacnt
       i_rec_errorcnt(j)  =i_error

c       print*,'l_commacnt=',l_commacnt   !should be 17
c       print*,'i_pos_st=',(i_pos_st(k),k=1,l_commacnt)
c       print*,'i_pos_en=',(i_pos_en(k),k=1,l_commacnt)
c       print*,'i_pos_loc=',(i_pos_loc(k),k=1,l_commacnt)

c      Extract values for all fields
       s_matrix_field(j,1) =TRIM(ADJUSTL( s_linget(1:i_pos_en(1)-1) ))
       DO k=1,l_commacnt-1
        s_matrix_field(j,k+1)=
     +    TRIM(ADJUSTL( s_linget(i_pos_st(k)+1:i_pos_en(k+1)-1) ))
       ENDDO 
       k=l_commacnt
       s_matrix_field(j,k+1)=
     +    TRIM(ADJUSTL( s_linget(i_pos_st(k)+1:i_pos_st(k)+8) ))

c       print*,'l_commacnt=',l_commacnt
c       print*,'s_matrix_field',(s_matrix_field(j,k),k=1,l_commacnt+1)
c       CALL SLEEP(1)

      ENDDO                  !close j-index

c      print*,'i_rec_errorcnt=',(i_rec_errorcnt(j),j=1,10)
c************************************************************************
c     Width of field

      DO j=1,l_commacnt-1
       i_fieldwidth(j)=i_pos_en(j+1)-i_pos_st(j)
      ENDDO
c      print*,'i_fieldwidth=',(i_fieldwidth(j),j=1,l_commacnt-1)
c************************************************************************
c     Find maximum error count for all lines in record
      i_max_errorcnt=i_rec_errorcnt(1)
      DO j=1,l_prod_fulluse
       i_max_errorcnt=MAX(i_max_errorcnt,i_rec_errorcnt(j))
      ENDDO

c      print*,'i_max_errorcnt=',i_max_errorcnt 
c************************************************************************
c     Extract key parameters

      DO i=1,l_prod_fulluse
       s_day_date(i)        =s_matrix_field(i,2)
       s_dayavg_airt_c(i)   =s_matrix_field(i,4)
       s_dayavg_vapprs_mb(i)=s_matrix_field(i,5)
       s_dayavg_ccov_okta(i)=s_matrix_field(i,6)
       s_dayavg_pres_mb(i)  =s_matrix_field(i,7)
       s_dayavg_relh_pc(i)  =s_matrix_field(i,8)
       s_dayavg_wspd_ms(i)  =s_matrix_field(i,9)
       s_daymax_airt_c(i)   =s_matrix_field(i,10)
       s_daymin_airt_c(i)   =s_matrix_field(i,11)
       s_daymin_minbod_c(i) =s_matrix_field(i,12)
       s_daymax_gust_ms(i)  =s_matrix_field(i,13)
       s_daytot_ppt_mm(i)   =s_matrix_field(i,14)
       s_daytot_pptflg(i)   =s_matrix_field(i,15)
       s_daytot_sundur_h(i) =s_matrix_field(i,16)
       s_daytot_snoacc_cm(i)=s_matrix_field(i,17)
      ENDDO     

c      print*,'s_airt_c=',   (s_dayavg_airt_c(i),i=1,5) 
c      print*,'s_vapprs_mb=',(s_dayavg_vapprs_mb(i),i=1,5) 
c      print*,'s_ccov_okta=',(s_dayavg_ccov_okta(i),i=1,5) 
c      print*,'s_pres_mb=',  (s_dayavg_pres_mb(i),i=1,5) 
c      print*,'s_relh_pc=',  (s_dayavg_relh_pc(i),i=1,5) 
c      print*,'s_wspd_ms=',  (s_dayavg_wspd_ms(i),i=1,5) 
c      print*,'s_airtmx_c=', (s_daymax_airt_c(i),i=1,5) 
c      print*,'s_airtmn_c=', (s_daymin_airt_c(i),i=1,5) 
c      print*,'s_minbod_c=', (s_daymin_minbod_c(i),i=1,5) 
c      print*,'s_gustmx_ms=',(s_daymax_gust_ms(i),i=1,5) 
c      print*,'s_ppt_mm=',   (s_daytot_ppt_mm(i),i=1,5)
c      print*,'s_pptflg=',   (s_daytot_pptflg(i),i=1,5)
c      print*,'s_sundur_h=', (s_daytot_sundur_h(i),i=1,5) 
c      print*,'s_snoacc_cm=',(s_daytot_snoacc_cm(i),i=1,5) 
c************************************************************************
c     Convert parameter to float
      DO i=1,l_prod_fulluse
c      dayavg_airt_c
       s_test=s_dayavg_airt_c(i)
       READ(s_test,*) f_test
       f_dayavg_airt_c(i)=f_test

c      dayavg_vapprs_mb
       s_test=s_dayavg_vapprs_mb(i)
       READ(s_test,*) f_test
       f_dayavg_vapprs_mb(i)=f_test

c      dayavg_ccov_okta
       s_test=s_dayavg_ccov_okta(i)
       READ(s_test,*) f_test
       f_dayavg_ccov_okta(i)=f_test

c      dayavg_pres_mb
       s_test=s_dayavg_pres_mb(i)
       READ(s_test,*) f_test
       f_dayavg_pres_mb(i)=f_test

c      dayavg_relh_pc
       s_test=s_dayavg_relh_pc(i)
       READ(s_test,*) f_test
       f_dayavg_relh_pc(i)=f_test

c      dayavg_wspd_ms
       s_test=s_dayavg_wspd_ms(i)
       READ(s_test,*) f_test
       f_dayavg_wspd_ms(i)=f_test

c      daymax_airt_c
       s_test=s_daymax_airt_c(i)
       READ(s_test,*) f_test
       f_daymax_airt_c(i)=f_test

c      daymin_airt_c
       s_test=s_daymin_airt_c(i)
       READ(s_test,*) f_test
       f_daymin_airt_c(i)=f_test

c      daymin_minbod_c
       s_test=s_daymin_minbod_c(i)
       READ(s_test,*) f_test
       f_daymin_minbod_c(i)=f_test

c      daymax_gust_ms
       s_test=s_daymax_gust_ms(i)
       READ(s_test,*) f_test
       f_daymax_gust_ms(i)=f_test

c      daytot_ppt_mm
       s_test=s_daytot_ppt_mm(i)
       READ(s_test,*) f_test
       f_daytot_ppt_mm(i)=f_test

c      daytot_sundur_h
       s_test=s_daytot_sundur_h(i)
       READ(s_test,*) f_test
       f_daytot_sundur_h(i)=f_test

c      daytot_snoacc_cm
       s_test=s_daytot_snoacc_cm(i)
       READ(s_test,*) f_test
       f_daytot_snoacc_cm(i)=f_test

      ENDDO
c************************************************************************
c     Sequence to identify date stamp reversals

      DO i=1,l_prod_fulluse  
       s_test8=s_day_date(i)
       s_year=s_test8(1:4)
       READ(s_year,*) i_test
       i_year=i_test

       i_day_year(i)=i_year
      ENDDO

c     Check for year reversals
      l_prod=l_prod_fulluse
      DO i=1,l_prod_fulluse-1
       IF (i_day_year(i+1).LT.i_day_year(i)) THEN
        l_prod=i                   !use sequence up to first reversal only
        GOTO 16
       ENDIF 
      ENDDO
16    CONTINUE
c************************************************************************
      RETURN
      END
