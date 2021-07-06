c     Extract vectors from daily lines
c     AJ_Kettle, 03Dec2018

      SUBROUTINE get_fields_from_ghcnd_line2(s_linget,
     +  s_sing_id,s_sing_date_yyyymmdd,s_sing_element,s_sing_datavalue,
     +  s_sing_mflag,s_sing_qflag,s_sing_sflag,s_sing_obstime)

      IMPLICIT NONE
c************************************************************************
c     Declare variables passed into program

      CHARACTER(LEN=50)   :: s_linget
c*****
c     Other variables used in program

      INTEGER             :: i,j,k,ii,jj,kk
      INTEGER             :: i_len

      INTEGER             :: i_commacnt
      INTEGER             :: i_commapos(7)

      CHARACTER(LEN=12)   :: s_sing_id
      CHARACTER(LEN=8)    :: s_sing_date_yyyymmdd
      CHARACTER(LEN=4)    :: s_sing_element
      CHARACTER(LEN=5)    :: s_sing_datavalue
      CHARACTER(LEN=1)    :: s_sing_mflag 
      CHARACTER(LEN=1)    :: s_sing_qflag
      CHARACTER(LEN=1)    :: s_sing_sflag
      CHARACTER(LEN=4)    :: s_sing_obstime

      INTEGER             :: i_len_id
      INTEGER             :: i_len_date_yyyymmdd
      INTEGER             :: i_len_element
      INTEGER             :: i_len_datavalue
      INTEGER             :: i_len_mflag 
      INTEGER             :: i_len_qflag
      INTEGER             :: i_len_sflag
      INTEGER             :: i_len_obstime

c************************************************************************
c      print*,'just inside get_fields_from_ghcnd_line'

      i_len=LEN_TRIM(s_linget)

      i_commacnt=0

      DO i=1,i_len
       IF (s_linget(i:i).EQ.',') THEN 
        i_commacnt=i_commacnt+1
        i_commapos(i_commacnt)=i
       ENDIF
      ENDDO

      IF (i_commacnt.NE.7) THEN 
       STOP 'get_fields_from_ghcnd_line; i_commacnt not 7'
      ENDIF

      i_len_id            =i_commapos(1)-1
      i_len_date_yyyymmdd =i_commapos(2)-i_commapos(1)-1
      i_len_element       =i_commapos(3)-i_commapos(2)-1
      i_len_datavalue     =i_commapos(4)-i_commapos(3)-1
      i_len_mflag         =i_commapos(5)-i_commapos(4)-1
      i_len_qflag         =i_commapos(6)-i_commapos(5)-1
      i_len_sflag         =i_commapos(7)-i_commapos(6)-1
      i_len_obstime       =i_len-(i_commapos(7)+1)

c     Check if fields correct
      IF (i_len_id.GT.12) THEN 
       print*,'s_linget=',TRIM(s_linget)
       print*,'i_len_id=',i_len_id
       STOP 'get_fields_from_ghcnd_line; emergency stop'
      ENDIF
      IF (i_len_date_yyyymmdd.GT.8) THEN 
       print*,'s_linget=',TRIM(s_linget)
       print*,'i_len_date_yyyymmdd=',i_len_date_yyyymmdd
       STOP 'get_fields_from_ghcnd_line; emergency stop'
      ENDIF
      IF (i_len_element.GT.4) THEN 
       print*,'s_linget=',TRIM(s_linget)
       print*,'i_len_element=',i_len_element
       STOP 'get_fields_from_ghcnd_line; emergency stop'
      ENDIF
      IF (i_len_datavalue.GT.5) THEN 
       print*,'s_linget=',TRIM(s_linget)
       print*,'i_len_datavalue=',i_len_datavalue
       STOP 'get_fields_from_ghcnd_line; emergency stop'
      ENDIF
      IF (i_len_mflag.GT.1) THEN 
       print*,'s_linget=',TRIM(s_linget)
       print*,'i_len_mflag=',i_len_mflag
       STOP 'get_fields_from_ghcnd_line; emergency stop'
      ENDIF
      IF (i_len_qflag.GT.1) THEN 
       print*,'s_linget=',TRIM(s_linget)
       print*,'i_len_qflag=',i_len_qflag
       STOP 'get_fields_from_ghcnd_line; emergency stop'
      ENDIF
      IF (i_len_sflag.GT.1) THEN 
       print*,'s_linget=',TRIM(s_linget)
       print*,'i_len_sflag=',i_len_sflag
       STOP 'get_fields_from_ghcnd_line; emergency stop'
      ENDIF
      IF (i_len_obstime.GT.4) THEN 
       print*,'s_linget=',TRIM(s_linget)
       print*,'i_len_obstime=',i_len_obstime
       STOP 'get_fields_from_ghcnd_line; emergency stop'
      ENDIF

      s_sing_id           =s_linget(1:i_commapos(1)-1)
      s_sing_date_yyyymmdd=s_linget(i_commapos(1)+1:i_commapos(2)-1)
      s_sing_element      =s_linget(i_commapos(2)+1:i_commapos(3)-1)
      s_sing_datavalue    =s_linget(i_commapos(3)+1:i_commapos(4)-1)
      s_sing_mflag        =s_linget(i_commapos(4)+1:i_commapos(5)-1)
      s_sing_qflag        =s_linget(i_commapos(5)+1:i_commapos(6)-1)
      s_sing_sflag        =s_linget(i_commapos(6)+1:i_commapos(7)-1)
      s_sing_obstime      =s_linget(i_commapos(7)+1:i_len)

c      print*,'i_commacnt=',i_commacnt

c      print*,'just leaving get_fields_from_ghcnd_line'

      RETURN
      END
