c     Subroutine to get triplet summary data from single file
c     AJ_Kettle, 11Jul2019
c     15Sep2019: modified from get_triplet_data_single_file2; 2 more meta lines
c     27Mar2020: used for USAF update

      SUBROUTINE get_triplet_data_single_file4(
     +   s_dir_outfile_iff_netplatdistinct,s_file_single,
     +   l_cnt_rgh,l_cnt_triplet,
     +   s_networktype_single,s_platformid_single,
     +   s_vec_index,
     +   s_vec_latitude,s_vec_longitude,s_vec_height,
     +   s_vec_wdir_cnt,s_vec_wspd_cnt,
     +   s_vec_airt_cnt,s_vec_dewp_cnt,
     +   s_vec_slp_cnt,s_vec_stnp_cnt,
     +   s_metasingle_name,s_metasingle_cdmlandcode,
     +   s_vec_year_st,s_vec_year_en,s_vec_assemble_varcode)

      IMPLICIT NONE
c************************************************************************
c     Declare variables 

      CHARACTER(LEN=*)    :: s_dir_outfile_iff_netplatdistinct
      CHARACTER(LEN=*)    :: s_file_single

      INTEGER             :: l_cnt_rgh
      INTEGER             :: l_cnt_triplet

      CHARACTER(LEN=*)    :: s_networktype_single
      CHARACTER(LEN=*)    :: s_platformid_single
      CHARACTER(LEN=*)    :: s_vec_index(l_cnt_rgh)
      CHARACTER(LEN=*)    :: s_vec_latitude(l_cnt_rgh)
      CHARACTER(LEN=*)    :: s_vec_longitude(l_cnt_rgh)
      CHARACTER(LEN=*)    :: s_vec_height(l_cnt_rgh)
      CHARACTER(LEN=*)    :: s_vec_wdir_cnt(l_cnt_rgh)
      CHARACTER(LEN=*)    :: s_vec_wspd_cnt(l_cnt_rgh)
      CHARACTER(LEN=*)    :: s_vec_airt_cnt(l_cnt_rgh)
      CHARACTER(LEN=*)    :: s_vec_dewp_cnt(l_cnt_rgh)
      CHARACTER(LEN=*)    :: s_vec_slp_cnt(l_cnt_rgh)
      CHARACTER(LEN=*)    :: s_vec_stnp_cnt(l_cnt_rgh)

      CHARACTER(LEN=*)    :: s_metasingle_name
      CHARACTER(LEN=*)    :: s_metasingle_cdmlandcode
c      CHARACTER(LEN=*)    :: s_metasingle_lat
c      CHARACTER(LEN=*)    :: s_metasingle_lon
c      CHARACTER(LEN=*)    :: s_metasingle_elev

      CHARACTER(LEN=*)    :: s_vec_year_st(l_cnt_rgh)
      CHARACTER(LEN=*)    :: s_vec_year_en(l_cnt_rgh)
      CHARACTER(LEN=*)    :: s_vec_assemble_varcode(l_cnt_rgh)
c*****
c     Variables used in subroutine

      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: io

      CHARACTER(LEN=300)  :: s_linget
      CHARACTER(LEN=300)  :: s_pathandname
c************************************************************************
c      print*,'just inside get_triplet_data_single_file3'

      ii=0
      jj=0

      s_pathandname=
     +  TRIM(s_dir_outfile_iff_netplatdistinct)//TRIM(s_file_single)

      OPEN(UNIT=2,FILE=TRIM(s_pathandname),
     +  FORM='formatted',STATUS='OLD',ACTION='READ')     

      DO 

c      Read data line
       READ(2,1002,IOSTAT=io) s_linget
1002   FORMAT(a300)
       IF (io .GT. 0) THEN
        WRITE(*,*) 'Check input. Something went wrong'
        GOTO 100
       ELSE IF (io .LT. 0) THEN 
c        WRITE(*,*) 'end of file reached'
        GOTO 100
       ELSE

        ii=ii+1

c        print*,'s_linget=',TRIM(s_linget)

c       line 1: title
c       line 2: blank
c       line 3: name & date
c       line 4: blank
 
c       line 5: networktype
        IF (ii.EQ.5) THEN
         s_networktype_single=ADJUSTL(s_linget(17:26))
        ENDIF
c       line 6: Platform_id
        IF (ii.EQ.6) THEN
         s_platformid_single =ADJUSTL(s_linget(17:26))
        ENDIF

c       line 7: blank
c       line 8: Metadata identifiers
c       line 9: Metadata Networktype
c       line 10:Metadata Platform id
c       line 11:Country code
        IF (ii.EQ.11) THEN
         s_metasingle_cdmlandcode=ADJUSTL(s_linget(17:26))
        ENDIF
c       line 12:cdmlandcode
        IF (ii.EQ.12) THEN
         s_metasingle_name=ADJUSTL(s_linget(17:66))
        ENDIF
c       line 13: s_metasingle_lat
c       line 14: s_metasingle_lon
c       line 15: s_metasingle_elev

c       line 16: blank
c       line 17: Number of lines
c       line 18: Number of triplets
c       line 19: blank
c       line 20: table header 1
c       line 21: table header 2

        IF (ii.GE.22) THEN
         jj=jj+1

         IF (jj.GT.l_cnt_rgh) THEN
          print*,'emergency stop too many triplets'
          STOP 'get_triplet_update_single_file'          
         ENDIF

         s_vec_index(jj)    =ADJUSTL((s_linget(1:2)))
         s_vec_latitude(jj) =ADJUSTL((s_linget(4:12)))
         s_vec_longitude(jj)=ADJUSTL((s_linget(14:22)))
         s_vec_height(jj)   =ADJUSTL((s_linget(24:32)))
         s_vec_wdir_cnt(jj) =ADJUSTL(s_linget(34:40))
         s_vec_wspd_cnt(jj) =ADJUSTL(s_linget(42:48))
         s_vec_airt_cnt(jj) =ADJUSTL(s_linget(50:56))
         s_vec_dewp_cnt(jj) =ADJUSTL(s_linget(58:64))
         s_vec_slp_cnt(jj)  =ADJUSTL(s_linget(66:72))
         s_vec_stnp_cnt(jj) =ADJUSTL(s_linget(74:80))

         s_vec_year_st(jj)  =ADJUSTL(s_linget(82:85))
         s_vec_year_en(jj)  =ADJUSTL(s_linget(87:90))
         s_vec_assemble_varcode(jj)=ADJUSTL(s_linget(92:116))

c         print*,'jj=',jj
c         print*,'lat='//s_vec_latitude(jj)//'='
c         print*,'lon=',s_vec_longitude(jj)//'='
c         print*,'height=',s_vec_height(jj)//'='
c         print*,'wdir=',s_vec_wdir_cnt(jj)//'='
c         print*,'wspd=',s_vec_wspd_cnt(jj)//'='
c         print*,'airt=',s_vec_airt_cnt(jj)//'='
c         print*,'dewp=',s_vec_dewp_cnt(jj)//'='
c         print*,'slp=',s_vec_slp_cnt(jj)//'='
c         print*,'stnp=',s_vec_stnp_cnt(jj)//'='

c         print*,'s_vec_year_st='//TRIM(s_vec_year_st(jj))//'='
c         print*,'s_vec_year_en='//TRIM(s_vec_year_en(jj))//'='
c         print*,'s_vec_assemble_varcode='//
c     +     TRIM(s_vec_assemble_varcode(jj))//'='

        ENDIF

c        print*,'s_linget',ii,TRIM(s_linget)

       ENDIF
      ENDDO                !end of line-counter

100   CONTINUE

      CLOSE(UNIT=2)

      l_cnt_triplet=jj

c      print*,'l_cnt_triplet',l_cnt_triplet

c      print*,'just leaving get_triplet_data_single_file3'
c      STOP

      RETURN
      END
