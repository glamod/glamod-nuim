c     Subroutine to find sequence of location changes
c     AJ_Kettle, Sept.19/2018
c     28Jun2019: modified for P20190207_endtoend
c     16Mar2020: adapted for USAF update
c     17Mar2020: pulled string latlon through program

      SUBROUTINE find_distinct_triplet_latlonhgt2(f_ndflag,
     +  l_rgh_numlines,i_ndatalines,
     +  f_vec_latitude,f_vec_longitude,f_vec_platformheight,
     +  s_vec_latitude,s_vec_longitude,s_vec_platformheight,

     +  i_triplediff_cnt,i_triplediff_numobs,
     +  f_triplediff_lat,f_triplediff_lon,f_triplediff_plathght,
     +  s_triplediff_lat,s_triplediff_lon,s_triplediff_plathght,
     +  i_triplediff_nswitch,
     +  i_vec_triplet_index)

      IMPLICIT NONE
c************************************************************************
      INTEGER             :: i,j,k,ii,jj,kk
      REAL                :: f_ndflag

      INTEGER             :: l_rgh_numlines,i_ndatalines

      REAL                :: f_vec_latitude(l_rgh_numlines)
      REAL                :: f_vec_longitude(l_rgh_numlines)
      REAL                :: f_vec_platformheight(l_rgh_numlines)

      CHARACTER(LEN=*)    :: s_vec_latitude(l_rgh_numlines)
      CHARACTER(LEN=*)    :: s_vec_longitude(l_rgh_numlines)
      CHARACTER(LEN=*)    :: s_vec_platformheight(l_rgh_numlines)

      INTEGER             :: i_triplediff_cnt
      INTEGER             :: i_triplediff_numobs(l_rgh_numlines)
      REAL                :: f_triplediff_lat(l_rgh_numlines)
      REAL                :: f_triplediff_lon(l_rgh_numlines)
      REAL                :: f_triplediff_plathght(l_rgh_numlines)

      CHARACTER(LEN=*)    :: s_triplediff_lat(l_rgh_numlines)
      CHARACTER(LEN=*)    :: s_triplediff_lon(l_rgh_numlines)
      CHARACTER(LEN=*)    :: s_triplediff_plathght(l_rgh_numlines)

      INTEGER             :: i_triplediff_nswitch

      INTEGER             :: i_vec_triplet_index(l_rgh_numlines)
c************************************************************************
c      print*,'just inside find_distinct_triplet_latlonhgt'

c     Assign first value of analysis
      i_triplediff_nswitch=0

      DO i=1,i_ndatalines-1
c      Condition for change in any lat-lon-hght
       IF (f_vec_latitude(i).NE.f_vec_latitude(i+1).OR.
     +     f_vec_longitude(i).NE.f_vec_longitude(i+1).OR.
     +     f_vec_platformheight(i).NE.f_vec_platformheight(i+1)) THEN 

        i_triplediff_nswitch=i_triplediff_nswitch+1

c       Stop program if array exceeded
c        IF (i_locchange_cnt.GT.10000) THEN 
c         print*,'i,i_locchange_cnt',i,i_locchange_cnt
c         STOP 'end find_loc_change_time overlength array'
c        ENDIF

       ENDIF
      ENDDO
c*****
c     Find distinct lat-lon-hgt combinations
      i_triplediff_cnt=0
c     Initialization
      DO i=1,l_rgh_numlines
       i_triplediff_numobs(i)   =0
       f_triplediff_lat(i)      =f_ndflag
       f_triplediff_lon(i)      =f_ndflag
       f_triplediff_plathght(i) =f_ndflag

       s_triplediff_lat(i)      =''
       s_triplediff_lon(i)      =''
       s_triplediff_plathght(i) =''
      ENDDO

c     Assign first element change
      i_triplediff_cnt=1
      i_triplediff_numobs(1)  =i_triplediff_numobs(1)+1
      f_triplediff_lat(1)     =f_vec_latitude(1)
      f_triplediff_lon(1)     =f_vec_longitude(1)
      f_triplediff_plathght(1)=f_vec_platformheight(1)

      s_triplediff_lat(1)     =s_vec_latitude(1)
      s_triplediff_lon(1)     =s_vec_longitude(1)
      s_triplediff_plathght(1)=s_vec_platformheight(1)

      DO i=2,i_ndatalines

       DO j=1,i_triplediff_cnt
c       Condition for match with existing record
        IF (f_vec_latitude(i).EQ.f_triplediff_lat(j).AND.
     +      f_vec_longitude(i).EQ.f_triplediff_lon(j).AND.
     +      f_vec_platformheight(i).EQ.f_triplediff_plathght(j)) THEN
          i_triplediff_numobs(j)=i_triplediff_numobs(j)+1
         GOTO 52
        ENDIF
       ENDDO

c      If here then distinct list must be updated
       i_triplediff_cnt=i_triplediff_cnt+1
       i_triplediff_numobs(i_triplediff_cnt)  =
     +    i_triplediff_numobs(i_triplediff_cnt)+1 

       f_triplediff_lat(i_triplediff_cnt)     =f_vec_latitude(i)
       f_triplediff_lon(i_triplediff_cnt)     =f_vec_longitude(i)
       f_triplediff_plathght(i_triplediff_cnt)=f_vec_platformheight(i)

       s_triplediff_lat(i_triplediff_cnt)     =s_vec_latitude(i)
       s_triplediff_lon(i_triplediff_cnt)     =s_vec_longitude(i)
       s_triplediff_plathght(i_triplediff_cnt)=s_vec_platformheight(i)

 52    CONTINUE
      ENDDO

c      print*,'i_triplediff_cnt=',i_triplediff_cnt
c      print*,'i_triplediff_nswitch=',i_triplediff_nswitch
c************************************************************************
c     Assign triplet index to each line

      DO i=1,i_ndatalines   !cycle through all lines of station
       DO j=1,i_triplediff_cnt
        IF (f_vec_latitude(i)  .EQ.f_triplediff_lat(j).AND. 
     +      f_vec_longitude(i) .EQ.f_triplediff_lon(j).AND.
     +      f_vec_platformheight(i).EQ.f_triplediff_plathght(j)) THEN 
         i_vec_triplet_index(i)=j
         GOTO 10
        ENDIF
       ENDDO

       print*,'triplet match not found'
       STOP 'find_distinct_triplet_latlonhgt'

 10    CONTINUE
      ENDDO
c************************************************************************
c      print*,'just find_distinct_triplet_latlonhgt'

c      STOP 'end find_distinct_triplet_latlonhgt'

      RETURN
      END
