program mingle_subdaily_data

use strings
implicit none
character(len=1), parameter :: delimiter = "|"

integer, parameter :: iNElem = 6 
integer, parameter :: iUStationList = 21, iUDataFile = 22, iUMingleList = 26,iUInv = 27, iULog=28
integer, parameter :: iMaxNStns = 25000
integer, parameter :: iMaxNSrcs = 100
integer, parameter :: iUStationListOut = 23, iUFileList = 24, iUMFFOutFile = 25
integer, parameter :: iMaxN_IFF_Fields = 25
integer, parameter :: iMinYr = 1750, iMaxYr = 2021
integer, parameter :: iTemp = 1, iDewP = 2, iStnP = 3, iSeaP = 4, iWDir = 5, iWSpd = 6
integer :: iStat, iDataFile, iStn, iElem, iField, iSrc, iStringLength, iNumSrcs
integer :: iYear, iMonth, iDay, iHour, iMin, iYr, iMo, iDy, iHr, iMi, iNFields, m, idx, i
integer :: iMinYear, iMaxYear

logical :: lExist, lWrite

character(len=22), dimension(iNElem) :: cElemsLong=(/'temperature           ',&
'dew_point_temperature ','station_level_pressure','sea_level_pressure    ',&
'wind_direction        ','wind_speed            '/)

character(len=03) :: cSrcId
character(len=30) :: cName
character(len=08) :: cLat
character(len=09) :: cLon
character(len=06) :: cElev
character(len=96),dimension(iMaxNStns) :: cStations
character(len=11),dimension(iMaxNStns) :: cStnIds,cMinStnIds
character(len=30),dimension(iMaxNSrcs) :: cSrcIds
character(len=03),dimension(iMaxNSrcs) :: cSrcCodes
character(len=12),allocatable,dimension(:,:,:,:,:,:) :: cDataVals
character(len=03),allocatable,dimension(:,:,:,:,:,:) :: cDataSrcCodes
character(len=16),allocatable,dimension(:,:,:,:,:,:) :: cDataSrcIds
character(len=03) :: cSrcCode
character(len=15) :: cList
character(len=200) :: cDataString,cString
character(len=20) :: cDataSrcId
character(len=300) :: cHeader
character(len=300) :: cFileName
character(len=30) :: cFileNameBase
character(len=200), dimension(1:iMaxN_IFF_Fields) :: cFields
!character(len=30), dimension(:), allocatable :: cFields
character(len=600) :: cMFFHeader = 'Station_ID|Station_name|Year|Month|Day|Hour|Minute|Latitude|Longitude|'&
//'Elevation|temperature|temperature_Source_Code|temperature_Source_Station_ID|dew_point_temperature|'&
//'dew_point_temperature_Source_Code|dew_point_temperature_Source_Station_ID|'&
//'station_level_pressure|station_level_pressure_Source_Code|station_level_pressure_Source_Station_ID|'&
//'sea_level_pressure|sea_level_pressure_Source_Code|sea_level_pressure_Source_Station_ID|'&
//'wind_direction|wind_direction_Source_Code|wind_direction_Source_Station_ID|'&
//'wind_speed|wind_speed_Source_Code|wind_speed_Source_Station_ID'

call getarg(1,cList)

allocate(cDataVals(iMinYr:iMaxYr,1:12,1:31,0:24,0:59,1:6))
allocate(cDataSrcIds(iMinYr:iMaxYr,1:12,1:31,0:24,0:59,1:6))
allocate(cDataSrcCodes(iMinYr:iMaxYr,1:12,1:31,0:24,0:59,1:6))

open(iUMingleList,file='ghcnh-mingle-list-'//trim(cList)//'.txt', status='old')
open(iUStationList,file='ghcnh-station-list-'//trim(cList)//'.txt', status='old')
open(iULog,file='mingle-subdaily-data-'//trim(cList)//'.log',status='replace')

iStn = 1

do
  read(iUMingleList, *, iostat=iStat) cMinStnIds(iStn),iNumSrcs,(cSrcCodes(iSrc),&
  cSrcIds(iSrc),iSrc=1,iNumSrcs)
  if(iStat == -1) exit
  read(iUStationList, '(a11,1x,a8,1x,a9,1x,a6,4x,a30)', iostat=iStat) cStnIds(iStn),cLat,cLon,cElev,cName
  if(iStat == -1) exit

  if(cMinStnIds(iStn) /= cStnIds(iStn)) then
   write(iULog,'(a)') 'Mingle and Station List IDs do not match', cMinStnIds(iStn), cStnIds(iStn)
   cycle
  end if 

  inquire(file='/gws/nopw/j04/c3s311a_lot2/data/level1/land/level1b_sub_daily_data/mff_test/'//trim(cStnIds(iStn))//'.mff',EXIST=lExist)

  if(lExist) cycle

  iMaxYear = -9999
  iMinYear = 9999 
  write(*,*) cStnIds(iStn)

  cDataVals = ''
  cDataSrcCodes = ''
  cDataSrcIDs = ''

  do iSrc=1,iNumSrcs
  
    cSrcCode=cSrcCodes(iSrc)
    cSrcId=cSrcIds(iSrc)
    
    do iElem = 1, iNElem

   
!    write(*,*) trim(cElemsLong(iElem))
    !check if that element/source file is available 

    cFileName='/gws/nopw/j04/c3s311a_lot2/data/level1/land/level1a_sub_daily_data/'//trim(cElemsLong(iElem))//&
   '/'//cSrcCodes(iSrc)//'/'//trim(cSrcIds(iSrc))//'_'//trim(cElemsLong(iElem))//&
   '_'//cSrcCodes(iSrc)//'.psv'

   if(cSrcCodes(iSrc)=='223' .or. cSrcCodes(iSrc)=='222' .or. cSrcCodes(iStn)=='221' .or. cSrcCodes(iStn)=='220'  & 
     .or. cSrcCodes(iSrc)=='335' .or. cSrcCodes(iSrc)=='343' .or. cSrcCodes(iSrc)=='314' .or. cSrcCodes(iSrc)=='313' &
     .or. cSrcCodes(iSrc)=='315'&
     .or. cSrcCodes(iSrc)=='316' .or. cSrcCodes(iStn)=='344' .or.cSrcCodes(iStn)=='345' .or. cSrcCodes(iStn)=='346') then
  

    cFileName='/gws/nopw/j04/c3s311a_lot2/data/level1/land/level1a_sub_daily_data/'//trim(cElemsLong(iElem))//&
   '/'//cSrcCodes(iSrc)//'/'//trim(cSrcIds(iSrc))//'-'//trim(cElemsLong(iElem))//&
   '-'//cSrcCodes(iSrc)//'.psv'

   endif
    inquire(file=trim(cFileName),Exist=lExist)
!    write(*,*) trim(cFileName)
    if(.not. lExist) cycle
    write(*,*) trim(cFileName)

     !convert to csv
    
!     call system("tr '\r' '"//'"\r'//"' < "//trim(cFileName)//&
!      " | sed 's/^/"//'"'//"/g' | sed 's/|/"//'","'//"/g'| sed 's/$/"//'"'//"/g' > "//&
!      "datafile.csv")

      !open and read csv file
!      open(iUDataFile, file='datafile.csv',status='old')
      open(iUDataFile, file=trim(cFileName),status='old')
    
      read(iUDataFile,'(a)', iostat=iStat) cHeader

      do
      
        read(iUDataFile,'(a)',iostat=iStat) cDataString
        if(iStat == -1) exit

       iNFields = count(transfer(cDataString, 'a', len(cDataString)) == delimiter) + 1
!       write(*,*) 'iNFields = ', iNFields

!       allocate(cFields(1:19))
       
       call parse(cDataString, delimiter,cFields,iNFields)
       if(iNFields > 19) then
         write(iUlog,*) trim(cFileName)//' has more than 19 fields'
       endif
!       read(cDataString,*, IOSTAT=iStat) (cFields(iField), &
!        iField=1, iMaxN_IFF_Fields)
!       read(cDataString,*, IOSTAT=iStat) cFields(1:iNFields+1)
!       write(*,*) 'iNFields = ', iNFields
!       write(*,*) cFields(1:iNFields)
       read(cFields(5),'(i4)',iostat=iStat) iYear
       if(iStat /= 0) cycle
       read(cFields(6),'(i2)',iostat=iStat) iMonth
       if(iStat /= 0) cycle
       read(cFields(7),'(i2)',iostat=iStat) iDay
       if(iStat /= 0) cycle
       read(cFields(8),'(i2)',iostat=iStat) iHour
       if(iStat /= 0) cycle
       read(cFields(9),'(i2)',iostat=iStat) iMin
       if(iStat /= 0) cycle
      
       if(iYear > iMaxYear) iMaxYear = iYear
       if(iYear < iMinYear) iMinYear = iYear

!       write(*,*) cFields(2)
       if(iYear < iMinYr .or. iYear > iMaxYr) then
         write(iULog,*) 'Year=',iYear,'out of bounds): ', cFields(5), ' for ',cStnIds(iStn),' ',trim(cFileName) 
         cycle
       endif
       if(iHour < 0 .or. iHr > 24) then
         write(iULog,*) 'Hour out of bounds for',cStnIds(iStn),cElemsLong(iElem),iYear,iMonth,iDay
         cycle
       endif
       if(iMin == 99) iMin = 0
       if(iMin < 0 .or. iMin > 59) then
         write(iULog,*) 'Minute out of bounds): ', cFields(9), ' for ',cStnIds(iStn),' ',trim(cFileName)  
         cycle
       endif
       if(trim(cFields(13)) /= "Null" .and. cFields(13) /= '') then
         cDataVals(iYear,iMonth,iDay,iHour,iMin,iElem) = cFields(13)
         cDataSrcCodes(iYear,iMonth,iDay,iHour,iMin,iElem) = cFields(1)
         cDataSrcIds(iYear,iMonth,iDay,iHour,iMin,iElem) = cFields(2)
       endif
!        write(*,*) trim(cFields(13))
      
      end do 
      close(iUDataFile)
   
    end do !end element loop
  end do !end source loop
  
  if(iMinYear < iMinYr .or. iMaxYear > iMaxYr) then
    write(*,*) 'Year bounds issue 9s f0r station ', cStnIds(iStn), iMinYear,iMaxYr
    cycle
  endif

!   open(iUMFFOutFile,file='/data2/level1b/level1b_sub_daily_data/'//cStnIds(iStn)//'.mff',status='replace')
  open(iUMFFOutFile,file='/gws/nopw/j04/c3s311a_lot2/data/level1/land/'//&
    'level1b_sub_daily_data/mff_test/'//cStnIds(iStn)//'.mff',status='replace')
  open(iUInv,file='/gws/nopw/j04/c3s311a_lot2/data/level1/land/level1b_sub_daily_data/inv_test/'//cStnIds(iStn)//&
  '.inv',status='replace') 
   write(iUMFFOutFile,'(a)') trim(cMFFHeader)
   write(iUInv,'(a11,1x,i4,1x,i4)') cStnIds(iStn),iMinYear,iMaxYear
   write(*,*) cStnIds(iStn),iMinYear,iMaxYear  
   do iYr=iMinYear,iMaxYear
   flush(iUMFFOutFile)
     do iMo=1,12
        do iDy = 1,31
          do iHr = 0,23
!            lWrite = .false.
            do iMi = 0,59

             if(count(cDataVals(iYr,iMo,iDy,iHr,iMi,1:iNElem) /= '') > 0) then
               cString=''
               do iElem=1,iNElem
                 if(cDataVals(iYr,iMo,iDy,iHr,iMi,iElem) /='') then 
                   cString=trim(cString)//"|"//trim(cDataVals(iYr,iMo,iDy,iHr,iMi,iElem))//'|'//&
                   trim(cDataSrcCodes(iYr,iMo,iDy,iHr,iMi,iElem))//'|'//trim(cDataSrcIds(iYr,iMo,iDy,iHr,iMi,iElem))
                 else
                   cString=trim(cString)//"|||"//"   "
                 endif
!                 if(cDataSrcIds(iMo,iDy,iHr,iMi,iElem) /=' ') cDataSrcId=cDataSrcIds(iMo,iDy,iHr,iMi,iElem)
               end do 
               write(iUMFFOutFile,'(a,"|",a,"|",i4,"|",4(i2.2,"|"),2(a,"|"),a,a)') trim(cStnIds(iStn)),&
               trim(cName),iYr,iMo,iDy,iHr,iMi,trim(adjustl(cLat)),trim(adjustl(cLon)),trim(adjustl(cElev)),&
	       trim(adjustl(cString))
 
             endif
            end do 
          end do
        end do
     end do
   end do

  close(iUInv) 
  close(iUMFFOutFile)  
  iStn = iStn + 1
 
end do !end do iStn loop

end program mingle_subdaily_data
