c     Subroutine to erase files from output directories if i_start=1
c     AJ_Kettle, 26Mar2019
c     10Jun2019: modified to erase file from header2 & observation2 directories
c     29Oct2019: modified for use with GHCND Nov 2019 release
c     11apr2020: used for 01May2020 release

      SUBROUTINE erase_files_seq20201210(i_start,
     +  s_directory_output_header,s_directory_output_observation,
     +  s_directory_output_lite,
     +  s_directory_output_lastfile,s_directory_output_receipt,
     +  s_directory_output_errorfile,
     +  s_directory_output_qc,s_directory_output_receipt_linecount)

      IMPLICIT NONE
c************************************************************************
c     Variables passed into program

      INTEGER             :: i_start

      CHARACTER(LEN=300)  :: s_directory_output_header
      CHARACTER(LEN=300)  :: s_directory_output_observation
      CHARACTER(LEN=300)  :: s_directory_output_lite

      CHARACTER(LEN=300)  :: s_directory_output_lastfile
      CHARACTER(LEN=300)  :: s_directory_output_receipt
      CHARACTER(LEN=300)  :: s_directory_output_errorfile

      CHARACTER(LEN=300)  :: s_directory_output_qc
      CHARACTER(LEN=300)  :: s_directory_output_receipt_linecount
c*****
c     Variables used within program

      INTEGER             :: io
      CHARACTER(LEN=300)  :: s_command
c************************************************************************
c      print*,'just entered erase_files_seq'
c      print*,'i_start=',i_start

c     Remove files from output directories

c      IF (i_start.EQ.1) THEN

c     REMOVE header files
      s_command='for f in '//
     +   TRIM(s_directory_output_header)//'*.*; do rm "$f"; done'
      print*,'s_command=',TRIM(s_command)
      CALL SYSTEM(s_command,io)

c     REMOVE observation files
      s_command='for f in '//
     +   TRIM(s_directory_output_observation)//'*.*; do rm "$f"; done'
      print*,'s_command=',TRIM(s_command)
      CALL SYSTEM(s_command,io)

c     REMOVE lite files
      s_command='for f in '//
     +   TRIM(s_directory_output_lite)//'*.*; do rm "$f"; done'
      print*,'s_command=',TRIM(s_command)
      CALL SYSTEM(s_command,io)

c     REMOVE receipt files
      s_command='for f in '//
     +   TRIM(s_directory_output_receipt)//'*.*; do rm "$f"; done'
      print*,'s_command=',TRIM(s_command)
      CALL SYSTEM(s_command,io)

c     REMOVE errorfile files
      s_command='for f in '//
     +   TRIM(s_directory_output_errorfile)//'*.*; do rm "$f"; done'
      print*,'s_command=',TRIM(s_command)
      CALL SYSTEM(s_command,io)

c     REMOVE qc files
      s_command='for f in '//
     +   TRIM(s_directory_output_qc)//'*.*; do rm "$f"; done'
      print*,'s_command=',TRIM(s_command)
      CALL SYSTEM(s_command,io)

c     REMOVE receipt_linecount files
      s_command='for f in '//
     +   TRIM(s_directory_output_receipt_linecount)//
     +   '*; do rm "$f"; done'
      print*,'s_command=',TRIM(s_command)
      CALL SYSTEM(s_command,io)
c*****
c     this is manual process
c     REMOVE lastfile files
      s_command='for f in '//
     +   TRIM(s_directory_output_lastfile)//'*.*; do rm "$f"; done'
      print*,'s_command=',TRIM(s_command)
      CALL SYSTEM(s_command,io)

c     REMOVE runtime files
c      s_command='for f in '//
c     +   TRIM(s_directory_output_runtime)//'*.*; do rm "$f"; done'
c      print*,'s_command=',TRIM(s_command)
c      CALL SYSTEM(s_command,io)

c*****
c************************************************************************
c      ENDIF

c      STOP 'erase_files_condition'

      RETURN
      END
