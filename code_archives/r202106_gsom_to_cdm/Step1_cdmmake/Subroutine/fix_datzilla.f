c     Subroutine to fix Datzilla problem
c     AJ_Kettle, 02Dec2019

      SUBROUTINE fix_datzilla(l_rgh_lines,l_lines, 
     +  s_vec_snow_sourcenum,s_vec_snow_recordnum,
     +  i_vec_snow_qcmod_flag,
     +  i_cnt_recordnum,s_mat_sourcenum,s_mat_recordnum,
     +  i_flag_cat4,i_cnt_cat4_allcase)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into subroutine

      INTEGER             :: l_rgh_lines
      INTEGER             :: l_lines
 
      CHARACTER(*)        :: s_vec_snow_sourcenum(l_rgh_lines)
      CHARACTER(*)        :: s_vec_snow_recordnum(l_rgh_lines)

      INTEGER             :: i_vec_snow_qcmod_flag(l_rgh_lines)
      INTEGER             :: i_cnt_recordnum(l_rgh_lines)
      CHARACTER(*)        :: s_mat_sourcenum(l_rgh_lines,6)      !len=3
      CHARACTER(*)        :: s_mat_recordnum(l_rgh_lines,6)      !len=2

      INTEGER             :: i_flag_cat4
      INTEGER             :: i_cnt_cat4_allcase
c*****
c     Variables used in subroutine

      INTEGER             :: i,j,k,ii,jj,kk  

      INTEGER             :: i_qcmod_new
      CHARACTER(LEN=2)    :: s_recordnum_new
c************************************************************************
c      print*,'just entered fix_datzilla'

c      GOTO 10

      DO i=1,l_lines

c      Act if qcmod_flag activated
       IF (i_vec_snow_qcmod_flag(i).GT.0) THEN !should be 1 at this point

c        print*,'i_vec_snow_qcmod_flag=',i,i_vec_snow_qcmod_flag(i)
c        print*,'s_vec_snow_sourcenum=',
c     +    i,'|'//s_vec_snow_sourcenum(i)//'|'
c        print*,'i_cnt_recordnum=',i,i_cnt_recordnum(i)

c       If no Datzilla ticket, then no way to fix
        IF (TRIM(s_vec_snow_sourcenum(i)).NE.'165') THEN 
c        Initialize the cat4 flag to bad
         i_flag_cat4=1
         i_cnt_cat4_allcase=i_cnt_cat4_allcase+1
         i_vec_snow_qcmod_flag(i)=2  !set QC output flag to no solution
        ENDIF

c       Act if Datzilla ticket
        IF (TRIM(s_vec_snow_sourcenum(i)).EQ.'165') THEN 

c         print*,'Condition 2 met'
c         print*,'s_vec_snow_sourcenum=',i,s_vec_snow_sourcenum(i)

c        Horizontal test: act if alternatives
         IF (i_cnt_recordnum(i).GT.0) THEN

c          print*,'Condition 3 met'
c          print*,'i_cnt_recordnum=',i,i_cnt_recordnum(i)
 
          s_vec_snow_sourcenum(i)=s_mat_sourcenum(i,1)
          s_vec_snow_recordnum(i)=s_mat_recordnum(i,1)
c          i_vec_snow_qcmod_flag(i)=1  !set QC output flag

c          print*,'s_vec_snow_sourcenum(i)=',
c     +      i,'|'//s_vec_snow_sourcenum(i)//'|'
c          print*,'s_vec_snow_recordnum(i)=',
c     +      i,'|'//s_vec_snow_recordnum(i)//'|'

          GOTO 20
         ENDIF

c        Vertical test
         IF (i_cnt_recordnum(i).EQ.0) THEN

c          print*,'first vertical test'
c          print*,'s_vec_snow_sourcenum=',TRIM(s_vec_snow_sourcenum(i-1))
c          print*,'s_vec_snow_recordnum=',TRIM(s_vec_snow_recordnum(i-1))

c         Vertical search for number before
          IF (i.GT.1) THEN 
           IF (LEN_TRIM(s_vec_snow_sourcenum(i-1)).GT.0.AND.
     +         LEN_TRIM(s_vec_snow_recordnum(i-1)).GT.0) THEN 

c            print*,'Condition 4a met'

            s_vec_snow_sourcenum(i)=s_vec_snow_sourcenum(i-1)
            s_vec_snow_recordnum(i)=s_vec_snow_recordnum(i-1)
c            i_vec_snow_qcmod_flag(i)=1  !set QC output flag

c            print*,'s_vec_snow_sourcenum(i)=',
c     +        i,'|'//s_vec_snow_sourcenum(i)//'|'
c            print*,'s_vec_snow_recordnum(i)=',
c     +        i,'|'//s_vec_snow_recordnum(i)//'|'

            GOTO 20

           ENDIF
          ENDIF
c         Vertical search for number after
          IF (i.LT.l_lines) THEN 
           IF (LEN_TRIM(s_vec_snow_sourcenum(i+1)).GT.0.AND.
     +         LEN_TRIM(s_vec_snow_recordnum(i+1)).GT.0) THEN 

c            print*,'Condition 4b met'

            s_vec_snow_sourcenum(i)=s_vec_snow_sourcenum(i+1)
            s_vec_snow_recordnum(i)=s_vec_snow_recordnum(i+1)
c            i_vec_snow_qcmod_flag(i)=1  !set QC output flag
c            i_flag_cat4=0

c            print*,'s_vec_snow_sourcenum(i)=',
c     +        i,'|'//s_vec_snow_sourcenum(i)//'|'
c            print*,'s_vec_snow_recordnum(i)=',
c     +        i,'|'//s_vec_snow_recordnum(i)//'|'

            GOTO 20

           ENDIF
          ENDIF

c         If here then solution not possible for Datzilla ticket
          i_flag_cat4=1
          i_cnt_cat4_allcase=i_cnt_cat4_allcase+1
          i_vec_snow_qcmod_flag(i)=2  !set QC output flag to no solution
         ENDIF

        ENDIF
       ENDIF

cc        No solution possible
c         IF (i_cnt_recordnum(i).EQ.0) THEN
c          i_qcmod_new=2       !assign flag for no solution
c          s_recordnum_new=''  !no record number possible
c         ENDIF

cc        Workaround solution
c         IF (i_cnt_recordnum(i).GT.0) THEN
c          i_qcmod_new=1       !assign flag for workaround solution
c          s_recordnum_new=s_mat_recordnum(i,1)  !first record number
c         ENDIF

c         i_vec_snow_qcmod_flag(i)=i_qcmod_new
c         s_vec_snow_recordnum(i) =s_recordnum_new

c         print*,'s_vec_snow_sourcenum=',i,TRIM(s_vec_snow_sourcenum(i))

c         print*,'i_cnt_recordnum=',i_cnt_recordnum(i)
c         IF (i_cnt_recordnum(i).GT.0) THEN
c          print*,'s_mat_sourcenum=',
c      +      (s_mat_sourcenum(i,ii),ii=1,i_cnt_recordnum(i))
c          print*,'s_mat_recordnum=',
c      +      (s_mat_recordnum(i,ii),ii=1,i_cnt_recordnum(i))
c         ENDIF

c         print*,'i_qcmod_new=',i_qcmod_new
c         print*,'s_recordnum_new=',s_recordnum_new

 20    CONTINUE

      ENDDO

 10    CONTINUE

c      print*,'just leaving fix_datzilla'

      RETURN
      END
