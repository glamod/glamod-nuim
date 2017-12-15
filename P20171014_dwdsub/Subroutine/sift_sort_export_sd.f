      SUBROUTINE sift_sort_export_sd(s_directory_output,s_filename1,
     +  s_date,
     +  l_mstn,l_file_use,
     +  f_arch_dayavg_airt_ngood,f_arch_dayavg_airt_nbad,
     +  f_arch_dayavg_airt_avg_c,
     +  f_arch_dayavg_airt_min_c,f_arch_dayavg_airt_max_c)


      IMPLICIT NONE
c************************************************************************
      CHARACTER(LEN=300)  :: s_directory_output
      CHARACTER(LEN=300)  :: s_filename1
      CHARACTER(LEN=300)  :: s_pathandname1
      CHARACTER(LEN=8)    :: s_date

      INTEGER             :: l_mstn
      INTEGER             :: l_file_use
      REAL                :: f_arch_dayavg_airt_ngood(l_mstn)
      REAL                :: f_arch_dayavg_airt_nbad(l_mstn)
      REAL                :: f_arch_dayavg_airt_avg_c(l_mstn)
      REAL                :: f_arch_dayavg_airt_min_c(l_mstn)
      REAL                :: f_arch_dayavg_airt_max_c(l_mstn)

      REAL                :: f_vec_avg(l_mstn)
      REAL                :: f_vec_min(l_mstn)
      REAL                :: f_vec_max(l_mstn)
      REAL                :: f_vec_ngood(l_mstn)
      REAL                :: f_vec_nbad(l_mstn)

      REAL                :: f_sortvec_avg(l_mstn)
      REAL                :: f_sortvec_min(l_mstn)
      REAL                :: f_sortvec_max(l_mstn)
      REAL                :: f_sortvec_ngood(l_mstn)
      REAL                :: f_sortvec_nbad(l_mstn)

      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: l_vec
      INTEGER             :: i_vec_sortorder(l_mstn)
      REAL                :: f_vec_sortavg(l_mstn)
c************************************************************************
c     Sift data find non-zero entries

c     Initialize variable
      ii=1

      DO i=1,l_file_use
       IF (f_arch_dayavg_airt_ngood(i).GT.0.0) THEN 
        f_vec_avg(ii)  =f_arch_dayavg_airt_avg_c(i)
        f_vec_min(ii)  =f_arch_dayavg_airt_min_c(i)
        f_vec_max(ii)  =f_arch_dayavg_airt_max_c(i)
        f_vec_ngood(ii)=f_arch_dayavg_airt_ngood(i)
        f_vec_nbad(ii) =f_arch_dayavg_airt_nbad(i)

        ii=ii+1
       ENDIF
      ENDDO

      l_vec=ii-1
      print*,'l_vec=',l_vec
c************************************************************************
c     Sort extracted vectors
      CALL sort_like_pwave(l_vec,f_vec_avg,i_vec_sortorder)

      DO i=1,l_vec
       f_sortvec_avg(i)  =f_vec_avg(i_vec_sortorder(i))
       f_sortvec_min(i)  =f_vec_min(i_vec_sortorder(i))
       f_sortvec_max(i)  =f_vec_max(i_vec_sortorder(i))
       f_sortvec_ngood(i)=f_vec_ngood(i_vec_sortorder(i))
       f_sortvec_nbad(i) =f_vec_nbad(i_vec_sortorder(i))
      ENDDO

c      print*,'f_vec_avg=',(f_vec_avg(i),i=1,10)
c      print*,'i_vec_sortorder=',(i_vec_sortorder(i),i=1,10)
c      print*,'f_vec_avg=',(f_vec_avg(i_vec_sortorder(i)),i=1,10)
c      print*,'f_vec_min=',(f_vec_min(i_vec_sortorder(i)),i=1,10)
c      print*,'f_vec_max=',(f_vec_max(i_vec_sortorder(i)),i=1,10)
c      print*,'ngood_sorted',(i_vec_ngood(i_vec_sortorder(i)),i=1,10)
c************************************************************************
      s_pathandname1=TRIM(s_directory_output)//TRIM(s_filename1)

c      print*,'s_pathandname1=',s_pathandname1

      OPEN(UNIT=1,
     +  FILE=s_pathandname1,
     +  FORM='formatted',
     +  STATUS='NEW',ACTION='WRITE')

      WRITE(UNIT=1,FMT=3009) 'DWD - sifted/sorted data '
      WRITE(UNIT=1,FMT=3009) '                         '
3009  FORMAT(a25) 

      WRITE(unit=1,FMT=3029) 'AJ_Kettle ',s_date                          
3029  FORMAT(t1,a10,t12,a8) 
      WRITE(unit=1,FMT=3023) '                                        '
3023  FORMAT(t1,a40) 
      WRITE(unit=1,FMT=3031) 'N_days    ',l_vec                          
3031  FORMAT(t1,a10,t12,i4) 
      WRITE(unit=1,FMT=3023) '                                        '

      WRITE(unit=1,FMT=3025) 'Average ','Minimum ','Maximum ',
     +  'N_good  ','N_bad   '
      WRITE(unit=1,FMT=3025) '+------+','+------+','+------+',
     +  '+------+','+------+'
3025  FORMAT(t1,a8,t9,a8,t17,a8,t25,a8,t33,a8)

      DO i=1,l_vec
       WRITE(unit=1,FMT=3027) 
     +  f_sortvec_avg(i),f_sortvec_min(i),f_sortvec_max(i),
     +  f_sortvec_ngood(i),f_sortvec_nbad(i)
3027   FORMAT(t1,f8.2,t9,f8.2,t17,f8.2,t25,f8.0,t33,f8.0)
      ENDDO

      CLOSE(UNIT=1)
c************************************************************************
      RETURN
      END
