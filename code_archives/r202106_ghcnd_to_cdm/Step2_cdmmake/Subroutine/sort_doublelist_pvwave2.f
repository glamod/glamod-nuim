c     Sorting subroutine
c     Feb12/2018: arr must be DOUBLE PRECISION 
c     23Feb2020: taken for usaf update files

      SUBROUTINE sort_doublelist_pvwave2(n,arr,brr)

      IMPLICIT NONE
c****
      INTEGER          n
      DOUBLE PRECISION arr(n)
      DOUBLE PRECISION crr(n)
      INTEGER          brr(n)
      INTEGER          i,j
      DOUBLE PRECISION a
      INTEGER          b
c****
c     Copy original array
      DO i=1,n
       brr(i)=i         !simple ascending index
       crr(i)=arr(i)
      ENDDO 
c****
      DO j=2,n
       a=crr(j)
       b=brr(j)
       DO i=j-1,1,-1
        IF (crr(i).LE.a) GOTO 10
        crr(i+1)=crr(i)
        brr(i+1)=brr(i)
       ENDDO
       i=0
10     crr(i+1)=a
       brr(i+1)=b
      ENDDO
     
      RETURN
      END
