 program add_hourly_stns
 use ghcnhmod
 implicit none
 
 ! Modified to work with hourly stations spring 2020
 ! Modified spring 2021 to add features
 
 integer, parameter :: iNumStnsinBlock = 10000, iUPctSame = 11
 integer, parameter :: iAIDLength=15
 real, parameter :: rTooFar = 30.0
 
 integer :: iNumAStns, iNumBStns, iAddSrcLoc, i, iNumMatches, iAStn, iNumXRefIds, iCntXed
 integer :: iBStn, iNumMingled, iNumCustomMingled, iSrc, iNumCtryCodes, iCtry
 integer :: iStn, iNumDelStns, iCStn, iNumNewCustStns, iNumNewStns, iNumNewCustSrcs, iNumNewSrcs
 integer :: iALength, iBLength, iFIPS, nFIPS, iStat, iIndex, iSrcRank
 integer, allocatable, dimension(:) :: iMatchedBStns
 integer, dimension(iMaxnStns) :: iSourceCnts, iCustomSourceCnts
 
 real, dimension(1:3,1:iMaxnStns) :: rACoords, rBCoords
 real, dimension(1:iMaxnStns) :: rDistances
 real :: rXedDistance
 
 character(len=100) :: cBaseInv, cAddInv, cMingleListIn, cXRefFile, cMingleListCustom
 character(len=03) :: cAddSrcCode
 character(len=11) :: cNewGhcnhId
 character(len=02) :: cACountryCode,cNetWorkCode
 character(len=05), dimension(1:iMaxNStns) :: cAWmoIds
 character(len=02), dimension(1:250) :: cCountryCodes
 character(Len=02), dimension(1:iMaxnStns) :: cACountryCodes, cAStates, cFipsCodes
 character(len=62), dimension(1:250) :: cCountryNames
 character(len=11), dimension(1:iMaxnStns) :: cBStnIDs
 character(len=iAIDLength), dimension(1:iMaxnStns) :: cAStnIDs
 character(len=15), dimension(1:2,1:iMaxnStns) :: cXRefIds !add stn is first; base stn
 character(len=11), dimension(1:iMaxnStns) ::  cMingledIds, cCustomMingledIds, cDelStnIds
 character(len=03), dimension(iMaxnSourceRecs,iMaxnStns) :: cSrcRecCodes, cCustomSrcRecCodes
 character(len=03), dimension(iMaxnStns) :: cFipsSrc
 character(len=15), dimension(iMaxnSourceRecs,iMaxnStns) :: cSrcRecIds, cCustomSrcRecIds
 character(len=15), dimension(1:iMaxnStns) :: cFipsSrcIds
 
 character(len=51), dimension(1:iMaxnStns) :: cAAuxFields, cBAuxFields
 character(len=85), dimension(1:iMaxnStns) :: cInvOutRecs
 character(len=11), allocatable, dimension(:) :: cXedBStnIds
 character(len=11), allocatable, dimension(:) :: cBStnIdsWithNewSrc
! character(len=30), dimension(1:iMaxnStns) :: cANames
 character(len=54), dimension(1:iMaxnStns) :: cANames
 character(len=30), dimension(1:iMaxnStns) :: cACountries
 !character(len=54), dimension(1:iMaxnStns) :: cANames
 
 logical :: lExist, lSrcinCustomMingle
 
 call getarg(1,cMingleListIn)
 call getarg(2,cBaseInv) 
 call getarg(3,cAddInv)
 call getarg(4,cAddSrcCode)
 call getarg(5,cXRefFile)
 call getarg(6,cMingleListCustom)
 
 open(iUFIPS,file='/home/mmenne/lists/sources/fips-codes.csv',status='old')
 
 iFips = 1
 do 
   read(iUFIPS,*,iostat=iStat) cFipsCodes(iFips),cFipsSrc(iFips),cFipsSrcIds(iFips) 
   if(iStat == -1) exit
!   write(*,*) cFipsCodes(iFips),cFipsSrc(iFips),cFipsSrcIds(iFips)
   iFips = iFips+1
 end do 
 nFips = iFips
 
 iIndex = iIndexinSrcHierarchy(cAddSrcCode)

 if (iIndex /= 0) then 
   cNetworkCode = cNetworkCodes(iIndex)
 else
   cNetworkCode = 'U0'
 endif
 
 iSourceCnts = 0

 if (cBaseInv=="" .or. cAddInv=="" .or. cMingleListIn=="" .or. cAddSrcCode=="" .or. cXrefFile=="" .or. cMingleListCustom=="") then
   write (*,*) "USAGE: <Current Mingle List> <Current Inventory List> <Inventory of Stations to Add> &
   & <Source Code for Stations to Add> <Cross Reference File between Add Stations and Base Stations> <Custom Mingle List>"  
   stop
 endif

 inquire(file=trim(cMingleListIn),Exist=lExist)
 if (.not. lExist) then 
   write(*,*) 'Current Mingle list '//trim(cMingleListIn)//' does not exist...stopping'
   stop
 endif

 inquire(file=trim(cBaseInv),Exist=lExist)
 if (.not. lExist) then 
   write(*,*) 'Inventory file '//trim(cBaseInv)//' does not exist...stopping'
   stop
 endif

 inquire(file=trim(cAddInv),Exist=lExist)
 if (.not. lExist) then 
   write(*,*) 'Inventory file '//trim(cAddInv)//' does not exist...stopping'
   stop
 endif

 if(count(cSourceCodes == cAddSrcCode) /= 1) then
   write(*,*) 'There is a problem with the new source code in the hierarchy:',cSourceCodes, '...stopping'
   stop
 endif
 
 inquire(file=trim(cXrefFile),Exist=lExist)
 if (.not. lExist) then 
   write(*,*) 'Cross reference file '//trim(cXrefFile)//' does not exist...stopping'
   stop
 endif
 
 inquire(file=trim(cMingleListCustom),Exist=lExist)
 if (.not. lExist) then 
   write(*,*) 'Custom Mingle List '//trim(cMingleListCustom)//' does not exist...stopping'
   stop
 endif

 do iAddSrcLoc=1,iMaxnSourcePaths  !find index of source to add within GHCN-hourly source hierarchy

   if(cSourceCodes(iAddSrcLoc) == cAddSrcCode) exit

 enddo
 
 iNumXRefIds = 0
 
 open(iUStnList,file=trim(cXRefFile),status='old')
 call readXRefFile(iNumXRefIds)
 close(iUStnList)
! do iStn=1,iNumXrefIds
!   write(*,*) cXrefIds(:,iStn)
! end do
! stop
 open(iUMsg,file='add-hourly-stns-'//cAddSrcCode//'.log',status='replace')
 
 open(iUMingleList,file=trim(cMingleListIn),status='old')
 
 call readMingleList(cMingledIds,iSourceCnts,cSrcRecCodes,cSrcRecIds,iNumMingled)
 
 close(iUMingleList)

 open(iUMingleList,file=trim(cMingleListCustom),status='old')
 
 call readMingleList(cCustomMingledIds,iCustomSourceCnts,cCustomSrcRecCodes,cCustomSrcRecIds,iNumCustomMingled)

 write(*,*) 'Read ', iNumCustomMingled, ' custom mingle records from ', trim(cMingleListCustom)
! write(*,*) iNumCustomMingled, cCustomMingledIds(1:iNumCustomMingled), cCustomSrcRecIds(:,1:iNumCustomMingled)

 close(iUMingleList)
 
 open(iUCountryCodes,file='/home/mmenne/lists/ghcnh-countries.txt',status='old')
 call readCountryCodes(cCountryCodes,cCountryNames,iNumCtryCodes)
 close(iUCountryCodes)
 
 write(*,*) iNumCtryCodes
! stop
 
 lSrcinCustomMingle = .true.
 
 if(count(cCustomSrcRecCodes == cAddSrcCode) == 0) lSrcinCustomMingle = .false.
 
 write(*,*) 'Source ', cAddSrcCode, ' has ', count(cCustomSrcRecCodes == cAddSrcCode), &
 ' custom mingle entries in ', trim(cMingleListCustom)

 open(iUStnList,file=trim(cBaseInv),status='old')
 
 call readInv(cBStnIds,rBCoords,cBAuxFields,iNumBStns)
 
 close(iUStnList)
 
 do iBStn = 1, iNumBStns
   write(cInvOutRecs(iBStn),'(a11,1x,f8.4,1x,f9.4,1x,f6.1,a48)') cBStnIds(iBStn),rBCoords(:,iBStn),cBAuxFields(iBStn)(1:48)
 end do
 
 cAStates = ' '
 cAWmoIds = ' ' 
 open(iUStnList,file=trim(cAddInv),status='old')
 
! call readCdmp(cAStnIds,rACoords,cANames,cAWmoIds,cACountryCodes,cAStates,iNumAStns)
! call read_245_Inv(cAStnIds,rACoords,cANames,iNumAStns)
! call read_td13_Inv(cAStnIds,rACoords,cANames,cACountries,cAWmoIds,iNumAStns)
 call read_csv_Inv(cAStnIds,rACoords,cANames,cACountries,cFipsCodes,cAStates,cAWmoIds,iNumAStns)
! call read_ISPD_Inv(cAStnIds,rACoords,cANames,cACountryCodes,iNumAStns)

 close(iUStnList)
 
 write(*,*) "Station counts ", iNumMingled, iNumBStns
 
 if (iNumMingled /= iNumBStns) then
   write(*,*) 'Number of stations in base mingle-list and base station list is not the same...stopping'
   stop
 endif
 
 write(*,*) 'Number of stations in base lists: ', iNumBStns
 write(*,*) 'Number of add stations not flagged by pre_screen or intrasource_dupchk: ', iNumAStns
 write(*,*) 'Number of base stations for which ',cAddSrcCode, ' is a potential additional source: ', iNumXrefIds

 iNumNewCustStns = 0
 iNumNewStns = 0 
 iNumNewCustSrcs = 0
 iNumNewSrcs = 0
 

 do iAStn = 1, iNumAStns
 
!   write(*,*) trim(cAStnIds(iAStn))
!   stop
 
   if(count(cSrcRecIds==cAStnIds(iAStn) .and. cSrcRecCodes==cAddSrcCode)>0) then
   
      write(*,*) 'Error: Add Station Id:', cAStnIds(iAStn), ' is already in mingle list...stopping'
!      stop
      cycle
   
   endif
   
!find country code if this is source 245 (set up in subroutine)
   cACountryCode = cFipsCodes(iAStn)

   if(cAddSrcCode=='245') then 
     cACountryCode = 'XX'
     call findCntryCode(cACountries(iAStn),cCountryNames,cACountryCode)     
   endif 
   if(cFipsCodes(iAStn) == 'XX') then
     call findCntryCode(cACountries(iAStn),cCountryNames,cACountryCode)
     cACountryCodes(iAStn) = cACountryCode
   endif     

   write(*,*) cAStnIds(iAStn), cACountries(iAStn), cFipsCodes(iAStn), cACountryCode


!   cACountryCode = cFipsCodes(iAStn)
   iCStn=0  !index of custom mingle id
   
   cNewGhcnhId = " "
 
   if(lSrcinCustomMingle) then
  
      call findCustomMingleIndex(iAStn,iCStn)
!       write(*,*) 'iCStn = ', iCStn
!       write(*,*) 'iNumCustomMingled = ', iNumCustomMingled
      
      !check if this add station has a custom mingle entry
     
      if(iCStn>0) then
      
!        write(*,*) cAStnIds(iAStn), cCustomMingledIds(iCStn)
      
        iCntXed = count(cMingledIds(1:iNumMingled)==cCustomMingledIds(iCStn))
	
	if(iCntXed==0) then
	
	  cNewGhcnhId = cCustomMingledIds(iCStn)
	  
	  call addNewStn(cAStnIds(iAStn),rACoords(1,iAStn),rACoords(2,iAStn),rACoords(3,iAStn),cANames(iAStn),&
	  cACountryCode,cAStates(iAStn),cAWmoIds(iAStn),cNewGhcnhId)
	  
	  iNumNewCustStns = iNumNewCustStns + 1
	  iNumNewStns = iNumNewStns + 1
	  
	elseif(iCntXed == 1) then
	
!	  do iBStn = 1,iNumBStns
	  
!	    if(cBStnIds(iBStn) == c
	
!	  rXedDistance = rDistance(rACoords(1,iAStn),rACoords(2,iAStn),rBCoords(1,iBStn),rBCoords(2,iBStn))
	  
!	  write(*,*) 'Distance between custom xrefed stations ',cAStnIds(iAStn),cBStnIds(iBStn), ' = ', rXedDistance
	
          call insertSrcRec(cAStnIds(iAStn),cCustomMingledIds(iCStn),rACoords(1,iAStn),rACoords(2,iAStn),&
	  rACoords(3,iAStn),cANames(iAStn))
	  
            iNumNewCustSrcs = iNumNewCustSrcs + 1
            iNumNewSrcs = iNumNewSrcs + 1
	    
	elseif(iCntXed > 1) then
	
	  write(*,*) 'Error: ', cCustomMingledIds(iCStn), ' appears more than once in mingle-list...stopping'
	  stop
	  
	endif
      
        cycle
      
      end if
     
   endif 
   
   iCntXed = count(cXRefIds(1,1:iNumXRefIds) == cAStnIds(iAStn))
   write(*,*) iCntXed, cAStnIds(iAStn)
   
   if(iCntXed > 1) then !do not add this new source id because it matches with multiple base station ids
     write(*,*) cAStnIds(iAStn)//' is not added because it was cross referenced with ',iCntXed,' base stations' 
     cycle  
   endif
   
   if(iCntXed == 0) then !new source is not cross referenced with any base station; create new ghcnd station
      call addNewStn(cAStnIds(iAStn),rACoords(1,iAStn),rACoords(2,iAStn),rACoords(3,iAStn),cANames(iAStn),&
      cACountryCode,cAStates(iAStn),cAWmoIds(iAStn),cNewGhcnhId)
      iNumNewStns = iNumNewStns + 1
      cycle
   endif

!if we reach this point iCntXed = 1 meaning the add station was cross referenced to one base station

   allocate(cXedBStnIds(1:iCntXed)) !create an array of base station id(s) that is (are) cross referenced with new source id 
				    !(currently only one will occur) 
   
   cXedBStnIds=pack(cXrefIds(2,1:iNumXRefIds) , (cXrefIds(1,1:iNumXRefIds)== cAStnIds(iAStn)) )  !pack base id that is cross reference to add station id
   
!   if(count(cXrefIds(2,:) == cXedBStnIds(1))>1) then 
!      write(iUMsg,*) cAStnIds(iAStn)//' is not added because the corresponding base station is cross referenced &
!      &with this and at least one other add station'  
!      deallocate(cXedBStnIds)
!      cycle !the same base station id is cross reference with multiple new source ids
!   endif
   
   do iBStn=1,iNumBStns
     if(cXedBStnIds(1) == cBStnIds(iBStn)) then 
   
       rXedDistance = rDistance(rACoords(1,iAStn),rACoords(2,iAStn),rBCoords(1,iBStn),rBCoords(2,iBStn))
       if(iSourceCnts(iBStn) < 0) then
         write(*,*) cBStnIds(iBStn)
	 stop
       endif
	  
       write(*,*) 'Distance between xrefed stations ',cXedBStnIds(1),' and ', cAStnIds(iAStn),' = ', rXedDistance
       write(*,*) rACoords(1,iAStn),rACoords(2,iAStn),rBCoords(1,iBStn),rBCoords(2,iBStn)
       exit
       
     endif
   end do
   
   if(rXedDistance > rTooFar) then
     write(*,*) cAStnIds(iAStn)//' is not added as a source to '//cXedBStnIds(1)//' because it is ',rXedDistance,&
     ' away '
!     cycle
   end if
   
   if(rXedDistance < rTooFar) then 
     call insertSrcRec(cAStnIds(iAStn),cXedBStnIds(1),rACoords(1,iAStn),rACoords(2,iAStn),rACoords(3,iAStn),cANames(iAStn))
     iNumNewSrcs = iNumNewSrcs + 1
   end if
	       
   deallocate(cXedBStnIds)
   
   call flush(iUMsg)
   
 enddo 
 
 call check4dups()
 
 
! call system("rm /data/lists/latest/ghcnh-mingle-list.txt")
! call system("rm /data/lists/latest/ghcnh-stations.txt")
 open(iUMingleList,file='/home/mmenne/lists/rel5/minglelist/ghcnh-mingle-list.txt',status='replace')
 open(iUStnList,file='/home/mmenne/lists/rel5/minglelist/ghcnh-station-list.txt',status='replace')
! open(21,file='/data/lists/latest/ghcnh-mingle-list.txt',status='new')
! open(22,file='/data/lists/latest/ghcnh-stations.txt',status='new')
 
 do iStn = 1,iNumMingled
 
   if(count(cDelStnIds(1:iNumDelStns) == cMingledIds(iStn)) == 0) then
 
      write(iUMingleList,'(a11,1x,i2,150(1x,a3,1x,a15))') cMingledIds(iStn),iSourceCnts(iStn),(cSrcRecCodes(iSrc,iStn), &
        cSrcRecIds(iSrc,iStn), iSrc=1,iSourceCnts(iStn))
      
      write(iUStnList,'(a)') cInvOutRecs(iStn)
!      write(*,'(a11,1x,i2,150(1x,a3,1x,a15))') cMingledIds(iStn),iSourceCnts(iStn),(cSrcRecCodes(iSrc,iStn), &
!        cSrcRecIds(iSrc,iStn), iSrc=1,iSourceCnts(iStn))
      
!      write(*,'(a)') cInvOutRecs(iStn)
      
   else
   
      write(iUMsg,'("DELETED ",a11,1x,i2,150(1x,a3,1x,a15))') cMingledIds(iStn),iSourceCnts(iStn),(cSrcRecCodes(iSrc,iStn), &
        cSrcRecIds(iSrc,iStn), iSrc=1,iSourceCnts(iStn))
	
   endif

 end do
 
 write(*,*) 'add_stns.exe produced mingle and station lists with ', iNumMingled, &
 ' ghcn-hourly stations consisting of ', sum(iSourceCnts), &
 ' total source station records'
 write(*,*) iNumNewStns, ' new stations were added from source ', cAddSrcCode, &
 ' including ', iNumNewCustStns, ' from ', trim(cMingleListCustom)
 write(*,*) 'Added ', cAddSrcCode, ' as a new source to ', iNumNewSrcs, ' stations including ', &
 iNumNewCustSrcs, ' from ', trim(cMingleListCustom)
 write(*,*) 'Found ',iNumDelStns, ' ghcn-hourly ids with duplicate records'
 
 close(iUMingleList)
 close(iUStnList)

 open(iUMingleList,file='/home/mmenne/lists/ghcnh-mingle-list.csv',status='replace')
 
 do iStn = 1,iNumMingled
  
    iSrcRank = 0
 
    do iSrc = iSourceCnts(iStn), 1, -1 
    
      iSrcRank = iSrcRank + 1
 
      write(iUMingleList,'(a11,",",a,",",i3,",",a)') cMingledIds(iStn),trim(cSrcRecIds(iSrc,iStn)),iSrcRank,&
      cSrcRecCodes(iSrc,iStn)
       
	
    end do
      
!      write(iUStnList,'(a)') cInvOutRecs(iStn)
	
 end do

! close(21)
! close(22)
 close(iUMsg)
 
 contains 
!-------------------------------------------------------------------------------------------------------------------------------
 subroutine readInv(cStnIds,rCoords,cAuxFields,iNumStns)
 !read a GHCND formatted station inventory
 use ghcndmod
 
 implicit none
 
 integer :: iStn, iNumStns,iStat
 
 real, dimension(1:3,1:iMaxnStns) :: rCoords
 character (len=11), dimension(1:iMaxnStns) :: cStnIDs
 character (len=51), dimension(1:iMaxnStns) :: cAuxFields
 character (len=01) :: cFlag

 iStn=1
 do
   read(iUStnList,'(a11,a1,f8.4,1x,f9.4,1x,f6.1,a51)',IOSTAT=iStat) cStnIds(iStn),cFlag, rCoords(:,iStn),cAuxFields(iStn)
   if (iStat==-1) exit
   if(cFlag /= ' ') cycle
   iStn=iStn+1
 enddo
 
 iNumStns = iStn-1
 
 end subroutine
!-------------------------------------------------------------------------------------------------------------------------------
 subroutine readCdmp(cStnIds,rCoords,cANames,cAWmoIds,cACountryCodes,cAStates,iNumStns)
 !read a GHCND formatted station inventory
 use ghcndmod
 
 implicit none
 
 integer :: iStn, iNumStns,iStat
 
 real, dimension(1:3,1:iMaxnStns) :: rCoords
 character (len=iAIDLength), dimension(1:iMaxnStns) :: cStnIDs
 character (len=30), dimension(1:iMaxnStns) :: cANames
 character (len=05), dimension(1:iMaxnStns) :: cAWmoIds
 character (len=02), dimension(1:iMaxnStns) :: cACountryCodes, cAStates
 character (len=01) :: cFlag
 character (len=92) :: cLine

 iStn=1
 do
   read(iUStnList,'(a15,a1,f8.4,1x,f9.4,1x,f6.1,1x,a2,1x,a30,9x,a5,1x,a2)',IOSTAT=iStat) cStnIds(iStn),cFlag, rCoords(:,iStn),&
   cAStates(iStn),cANames(iStn),cAWmoIds(iStn),cACountryCodes(iStn)
 ! read(iUStnList,'(a)',iostat=iStat) cLine
   if (iStat==-1) exit
   if(cFlag /= ' ') cycle
!   write(*,*) cLine
   iStn=iStn+1
 enddo
 
 iNumStns = iStn-1
 
 end subroutine
!-------------------------------------------------------------------------------------------------------------------------------
 subroutine read_td13_Inv(cStnIds,rCoords,cNames,cCountries,cAWMOIds,iNumStns)
 !read a GHCND formatted station inventory
 use ghcndmod
 
 implicit none
 
 integer :: iStn, iNumStns,iStat
 
 real, dimension(1:3) :: rCoord
 real, dimension(1:3,1:iMaxnStns) :: rCoords

 character (len=05) :: cAWmoId
 character (len=iAIDLength) :: cStnId
 character (len=54) :: cName
 character (len=30) :: cCountry
 character (len=05), dimension(1:iMaxnStns) :: cAWmoIDs
 character (len=iAIDLength), dimension(1:iMaxnStns) :: cStnIDs
 character (len=51), dimension(1:iMaxnStns) :: cAuxFields
 character (len=54), dimension(1:iMaxnStns) :: cNames
 character (len=30), dimension(1:iMaxnStns) :: cCountries
character (len=01) :: cFlag

 cStnIds = " "
 
 
 
 iStn=1
 do
!   read(iUStnList,'(a11,a1,f8.4,1x,f9.4,1x,f6.1,a51)',IOSTAT=iStat) cStnIds,cFlag, rCoords(:,iStn),cAuxFields(iStn)
   read(iUStnList,'(a15,a1,f8.4,1x,f9.4,1x,f6.1,4x,a54,a30,a11)',IOSTAT=iStat) cStnId,cFlag, rCoord(:),cName,cCountry,cAWmoId
!   write(*,'(a15,a1,f8.4,1x,f9.4,1x,f6.1,4x,a54,a30)') cStnId,cFlag, rCoord(:),cName,cCountry,cAWmoId
   if (iStat==-1) exit
   if(cFlag /= ' ') cycle
   
!   if(cStnId /= cStnIds(iStn)) iStn = iStn+1
   cStnIds(iStn) = cStnId
   rCoords(:,iStn) = rCoord
   cNames(iStn) = cName
   cCountries(iStn) = cCountry
   cAWmoIds(iStn) = cAWmoId
   iStn = iStn+1
 enddo
 
 iNumStns = iStn-1
 
 end subroutine
!-------------------------------------------------------------------------------------------------------------------------------
 subroutine read_new_Inv(cStnIds,rCoords,cNames,cCountries,cCountryCodes,iNumStns)
 !read a GHCND formatted station inventory
 use ghcndmod
 
 implicit none
 
 integer :: iStn, iNumStns,iStat
 
 real, dimension(1:3) :: rCoord
 real, dimension(1:3,1:iMaxnStns) :: rCoords

 character (len=05) :: cAWmoId
 character (len=02) :: cCountryCode
 character (len=iAIDLength) :: cStnId
 character (len=54) :: cName
 character (len=30) :: cCountry
! character (len=05), dimension(1:iMaxnStns) :: cAWmoIDs
 character (len=iAIDLength), dimension(1:iMaxnStns) :: cStnIDs
! character (len=51), dimension(1:iMaxnStns) :: cAuxFields
 character (len=54), dimension(1:iMaxnStns) :: cNames
 character (len=30), dimension(1:iMaxnStns) :: cCountries
 character (len=02), dimension(1:iMaxnStns) :: cCountryCodes
character (len=01) :: cFlag

 cStnIds = " "
 iStn=1
 do
!   read(iUStnList,'(a11,a1,f8.4,1x,f9.4,1x,f6.1,a51)',IOSTAT=iStat) cStnIds,cFlag, rCoords(:,iStn),cAuxFields(iStn)
   read(iUStnList,'(a15,a1,f8.4,1x,f9.4,1x,f6.1,1x,a2,1x,a54,a30)',IOSTAT=iStat) cStnId,cFlag, rCoord(:),cCountryCode,&
   cName,cCountry
!   write(*,'(a15,a1,f8.4,1x,f9.4,1x,f6.1,4x,a54,a30)') cStnId,cFlag, rCoord(:),cName,cCountry,cAWmoId
   if (iStat==-1) exit
   if(cFlag /= ' ') cycle
   
!   if(cStnId /= cStnIds(iStn)) iStn = iStn+1
   cStnIds(iStn) = cStnId
   rCoords(:,iStn) = rCoord
   cNames(iStn) = cName
   cCountries(iStn) = cCountry
!   cAWmoIds(iStn) = cAWmoId
   cCountryCodes(iStn) = cCountryCode
   iStn = iStn+1
 enddo
 
 iNumStns = iStn-1
 
 end subroutine
!-------------------------------------------------------------------------------------------------------------------------------
 subroutine read_csv_Inv(cStnIds,rCoords,cNames,cCountries,cFipsCodes,cStates,cAWmoIds,iNumStns)
 !read a GHCND formatted station inventory
! use ghcndmod
 
 implicit none
 
 integer :: iStn, iNumStns,iStat, iALength
 
 real, dimension(1:3) :: rCoord
 real, dimension(1:3,1:iMaxnStns) :: rCoords
 real :: rLat, rLon, rElev

 character (len=05) :: cAWmoId
 character (len=02) :: cCountryCode, cState
 character (len=03) :: cStnSrc
 character (len=iAIDLength) :: cStnId, cStnIdOld
 character (len=30) :: cName
 character (len=30) :: cCountry,cPolicy
 character (len=05), dimension(1:iMaxnStns) :: cAWmoIDs
 character (len=iAIDLength), dimension(1:iMaxnStns) :: cStnIDs
! character (len=51), dimension(1:iMaxnStns) :: cAuxFields
 character (len=54), dimension(1:iMaxnStns) :: cNames
 character (len=30), dimension(1:iMaxnStns) :: cCountries
 character (len=02), dimension(1:iMaxnStns) :: cFipsCodes, cStates
 character (len=01) :: cFlag

 cStnIds = " "
 cStnIdOld = " "
 iStn=1
 do
   read(iUStnList,*,iostat=iStat) cStnSrc,cStnId,rLat,rLon,&
   rElev,cName, cState, cCountryCode, cCountry, cPolicy, cAWMOId 
   iALength = len_trim(cStnId)
!   write(*,*) cStnSrc,cStnId,rLat,rLon,rElev,cName, cState, cCountryCode, cCountry, cPolicy, cAWMOId
   if(len_trim(cState) < 2) cState="  "
   if(len_trim(cCountry) < 1) cCountry =" "
   if(len_trim(cAWmoId)< 1) cAWmoId = "     "
   write(*,*) cStnSrc,cStnId,rLat,rLon,rElev,cName, cState, cCountryCode, cCountry, cPolicy, cAWMOId
   if (iStat==-1) exit
!   if(cStnId(iALength-4:iALength) == cStnIdOld(iALength-4:iALength)) cycle
   cStnIds(iStn) = cStnId
   rCoords(1,iStn) = rLat
   rCoords(2,iStn) = rLon
   rCoords(3,iStn) = rElev
   cNames(iStn) = cName
   cCountries(iStn) = cCountry
   cAWmoIds(iStn) = cAWmoId
   cFipsCodes(iStn) = cCountryCode
   cStates(iStn) = cState
   iStn = iStn+1
   cStnIdOld = cStnId
 enddo
 
 iNumStns = iStn-1
 
 end subroutine
!-------------------------------------------------------------------------------------------------------------------------------
 subroutine read_ISPD_Inv(cStnIds,rCoords,cNames,cCountryCodes,iNumStns)
 !read a GHCND formatted station inventory
 use ghcndmod
 
 implicit none
 
 integer :: iStn, iNumStns,iStat
 
 real, dimension(1:3) :: rCoord
 real, dimension(1:3,1:iMaxnStns) :: rCoords

 character (len=05) :: cAWmoId
 character (len=15) :: cStnId
 character (len=54) :: cName
 character (len=02) :: cCountryCode
 character (len=30), dimension(1:iMaxnStns) :: cNames
 character (len=15), dimension(1:iMaxnStns) :: cStnIDs
 character (len=02), dimension(1:iMaxnStns) :: cCountryCodes
character (len=01) :: cFlag

 cStnIds = " "
 iStn=1
 do
!   read(iUStnList,'(a11,a1,f8.4,1x,f9.4,1x,f6.1,a51)',IOSTAT=iStat) cStnIds,cFlag, rCoords(:,iStn),cAuxFields(iStn)
   read(iUStnList,'(a15,a1,f8.4,1x,f9.4,1x,f6.1,1x,a2,1x,a30)',IOSTAT=iStat) cStnId,cFlag, rCoord(:),cCountryCode,cName
!   write(*,'(a11,a1,f8.4,1x,f9.4,1x,f6.1,4x,a54,a30)') cStnId,cFlag, rCoord(:),cName,cCountry
   if (iStat==-1) exit
   if(cFlag /= ' ') cycle
   
!   if(cStnId /= cStnIds(iStn)) iStn = iStn+1
   cStnIds(iStn) = cStnId
   rCoords(:,iStn) = rCoord
   cCountryCodes(iStn) = cCountryCode
   cNames(iStn) = cName
   iStn = iStn+1
 enddo
 
 iNumStns = iStn-1
 
 end subroutine
!-------------------------------------------------------------------------------------------------------------------------------
 subroutine read_245_Inv(cStnIds,rCoords,cNames,iNumStns)
 !read a GHCND formatted station inventory
 use ghcndmod
 
 implicit none
 
 integer :: iStn, iNumStns,iStat
 
 real, dimension(1:3) :: rCoord
 real, dimension(1:3,1:iMaxnStns) :: rCoords

 character (len=11) :: cStnId
 character (len=56) :: cName
! character (len=30) :: cCountry
 character (len=11), dimension(1:iMaxnStns) :: cStnIDs
 character (len=51), dimension(1:iMaxnStns) :: cAuxFields
 character (len=54), dimension(1:iMaxnStns) :: cNames
 character (len=30), dimension(1:iMaxnStns) :: cCountries
character (len=01) :: cFlag

 cStnIds = " "
 iStn=1
 do
!   read(iUStnList,'(a11,a1,f8.4,1x,f9.4,1x,f6.1,a51)',IOSTAT=iStat) cStnIds,cFlag, rCoords(:,iStn),cAuxFields(iStn)
   read(iUStnList,'(a11,a1,f8.4,1x,f9.4,1x,f6.1,4x,a55)',IOSTAT=iStat) cStnId,cFlag, rCoord(:),cName
   if (iStat==-1) exit
   if(cFlag /= ' ') cycle
   
   if(cStnId /= cStnIds(iStn)) iStn = iStn+1
   cStnIds(iStn) = cStnId
   rCoords(:,iStn) = rCoord
   cNames(iStn) = cName
!   cCountries(iStn) = cCountry
 enddo
 
 iNumStns = iStn+1
 
 end subroutine

!-------------------------------------------------------------------------------------------------------------------------------
 subroutine genDistances(rALatLon,rBLatLons,iNumBStns,rDistances)
 
 implicit none
 
 integer :: iBStn, iNumBStns
 
 real, dimension(1:iMaxnStns) :: rDistances
 real, dimension(1:2) :: rALatLon
 real, dimension(1:2,1:iMaxnStns) :: rBLatLons
 
 do iBStn = 1, iNumBStns
 
   rDistances(iBStn) = distance(rALatLon(1), rALatLon(2), rBLatLons(1,iBStn), rBLatLons(2,iBStn))*(2*3.14159*6.38*10.0**3.0)/360.0
   
 enddo
 
 return
 
 end subroutine genDistances
!-------------------------------------------------------------------------------------------------------------------------------
 real function rDistance(rALat, rALon,rBLat, rBLon)
 
 implicit none
 
! integer :: iBStn, iNumBStns
 
 real :: rALat, rALon, rBLat, rBLon
 
 rDistance = distance(rALat, rALon, rBLat, rBLon)*(2*3.14159*6.38*10.0**3.0)/360.0
 
 return
 
 end function rDistance

!------------------------------------------------------------------------------------------------------------------------------------
 subroutine readXRefFile(iNumXRefIds)
 
 implicit none
 
 integer :: iNumXRefIds, iStat
 !character (len=iAIDLength), dimension(1:2,iMaxnStns) :: cXRefIds !add stn is first then base stn
 character (len=27) :: cString
 
 iNumXRefIds = 1
 
 do 
!   read(iUStnList,'(a15,1x,a11)',IOSTAT=iStat) cXRefIds(1,iNumXRefIds),cXRefIds(2,iNumXRefIds)
   read(iUStnList,'(a)',IOSTAT=iStat) cString
   if(iStat == -1) exit
   cXRefIds(1,iNumXRefIds) = cString(1:15)
   cXRefIds(2,iNumXRefIds) = cString(17:27)
   iNumXRefIds = iNumXRefIds + 1
!   write(*,*) cXRefIds(1:2,iNumXRefIds), iNumXRefIds
 end do
! stop

 iNumXRefIds = iNumXRefIds - 1
 
 return
 
 end subroutine
!------------------------------------------------------------------------------------------------------------------------------------
 subroutine readMingleList(cMingledIds,iSourceCnts,cSrcRecCodes,cSrcRecIds,iNumMingled)
 
 implicit none
 
 character(len=11), dimension(1:iMaxnStns) ::  cMingledIds
 character(len=03), dimension(iMaxnSourceRecs,iMaxnStns) :: cSrcRecCodes
 character(len=15), dimension(iMaxnSourceRecs,iMaxnStns) :: cSrcRecIds
 
 integer :: iNumMingled, iStat
 integer, dimension(iMaxnStns) :: iSourceCnts
 
 cMingledIds = " "
 cSrcRecCodes = " "
 cSrcRecIds = " "
 iSourceCnts = 0
 
 iNumMingled=1
 
 do 
!   read(iUMingleList,'(a11,1x,i2,50(1x,a1,1x,a11))',IOSTAT=iStat) cMingledIds(iNumMingled),&
   read(iUMingleList,'(a11,1x,i2,150(1x,a3,1x,a15))',IOSTAT=iStat) cMingledIds(iNumMingled),&
   iSourceCnts(iNumMingled),(cSrcRecCodes(i,iNumMingled),&
      cSrcRecIds(i,iNumMingled),i=1,iSourceCnts(iNumMingled))
   if(iStat==-1) exit
!   write(*,*) cMingledIds(iNumMingled),&
!   iSourceCnts(iNumMingled),(cSrcRecCodes(i,iNumMingled),&
!      cSrcRecIds(i,iNumMingled),i=1,iSourceCnts(iNumMingled))
   iNumMingled = iNumMingled + 1
 end do
 
 iNumMingled = iNumMingled - 1
 
 end subroutine
!------------------------------------------------------------------------------------------------------------------------------------
 subroutine insertSrcRec(cAStnId,cBStnId,rALat,rALon,rAElev,cAName)
 
 implicit none
 
 character(len=05) :: cAWMO
 character(len=11) :: cBStnId
 character(len=iAIDLength) :: cAStnId
 character(len=51) :: cAAux
 character(len=30) :: cAName
 character(len=59) :: cALocName
 
 integer :: iInsertLoc, iStnWithNewSrc
 
 real :: rALat,rALon,rAElev
 
 do iStn = 1, iNumMingled
 
   if(cMingledIds(iStn)==cBStnId) then 
      iStnWithNewSrc = iStn
      exit
   endif
 
 end do
 
 if(iStnWithNewSrc > iNumMingled) then
   write(*,*) 'Did not find station with new source ... cannot add rec to ', cBStnId
   return
 endif
 
 write(*,*) "Insert source for : ", cAStnId,cBStnId
 write(*,*) cMingledIds(iStnWithNewSrc) 
   
 iInsertLoc = iSourceCnts(iStnWithNewSrc) + 1
   
 do iSrc = 1, iSourceCnts(iStnWithNewSrc)
   
   if(iIndexinSrcHierarchy(cSrcRecCodes(iSrc,iStnWithNewSrc)) > iAddSrcLoc) then
      iInsertLoc = iSrc
      cSrcRecCodes(iInsertLoc+1:iSourceCnts(iStnWithNewSrc)+1,iStnWithNewSrc) = &
         cSrcRecCodes(iInsertLoc:iSourceCnts(iStnWithNewSrc),iStnWithNewSrc)
      cSrcRecIds(iInsertLoc+1:iSourceCnts(iStnWithNewSrc)+1,iStnWithNewSrc) = & 
         cSrcRecIds(iInsertLoc:iSourceCnts(iStnWithNewSrc),iStnWithNewSrc)
      exit
   endif
   
 enddo
   
 cSrcRecCodes(iInsertLoc,iStnWithNewSrc) = cSourceCodes(iAddSrcLoc)
 cSrcRecIds(iInsertLoc,iStnWithNewSrc) = cAStnId
 iSourceCnts(iStnWithNewSrc) = iSourceCnts(iStnWithNewSrc) + 1
 
 write(cALocName,'(f8.4,1x,f9.4,1x,f6.1,4x,a)') rALat,rALon,rAElev,cAName(1:30)
 cAWMO = cAAux(44:48)
 
 if(count(cAddSrcCode == (/'245','248','313','314','315'/)) > 0) return  !do not update cInvOutRecs for td13 or cdmp
 
 return
 
 if(cALocName /= cInvOutRecs(iStnWithNewSrc)(13:71) .and. cAddSrcCode /= 'S') then  !Update Coordinates, State Code and Name if not from GSOD
   write(iUMsg,'(a)') cInvOutRecs(iStnWithNewSrc)(1:11)//': Updating Coordinates and/or name '&
   //cInvOutRecs(iStnWithNewSrc)(13:71)//' with '//cALocName
   cInvOutRecs(iStnWithNewSrc)(13:71) = cALocName
 endif
 
 if(cAddSrcCode /='E' .and. cAWMO /= cInvOutRecs(iStnWithNewSrc)(81:85)) then  !ECA station info does not include WMO Ids, so update only if not ECA 
   write(iUMsg,'(a)') cInvOutRecs(iStnWithNewSrc)(1:11)//': Updating WMO ID '//cInvOutRecs(iStnWithNewSrc)(81:85)//' with '//cAWMO
   cInvOutRecs(iStnWithNewSrc)(81:85) = cAWMO
 endif  
 end subroutine insertSrcRec
!------------------------------------------------------------------------------------------------------------------------------------
 subroutine addNewStn(cAStnId,rALat,rALon,rAElev,cAName,cCountryCode,cAState,cAWmoId,cNewGhcnhId)
 
 implicit none
 
 character(len=03) :: cZeros = '000'
 character(len=11) :: cNewGhcnhId
 character(len=iAIDLength) :: cAStnId
 character(len=02) :: cCountryCode, cAState
 character(len=30) :: cAName
 character(len=30) :: cUName
 character(len=05) :: cAWmoId
 
 integer :: iInsertLoc, idash1, idash2, iStart, iUnderScore, iNumZeros2Add, iALength
 
 real :: rALat,rALon,rAElev
 
 iInsertLoc = iNumMingled + 1
 iALength = len_trim(cAStnId)
!      cCountryCode='XX'
!      do iFips=1,nFips
!        if(cFipsCodes(iFips) == "XX" .or. cFipsCodes(iFips) == "??" .or. cFipsCodes(iFips) ==' ') cycle
!        if(trim(cFipsSrcIds(iFips)) == trim(cAStnId) .and. &
!	  trim(cFipsSrc(iFips)) == cAddSrcCode) then
!	  cCountryCode = cFipsCodes(iFips)
!	  write(*,*) 'Found FIPS'
!	  exit
!        end if
!     end do
 if (cAddSrcCode == "319") cCountryCode = 'AS'
! if (cAddSrcCode == "341") cCountryCode = 'CA'
  
 write(*,*) cNetworkCode, iALength, cAStnId, cAddSrcCode
 
 if(cNewGhcnhId == " ") then
 
 cNewGhcnhId(3:11) = '00000000'
 
 if(cAddSrcCode == '245') then
 
    iALength = len_trim(cAStnId)
    
    if(iALength == 9) then
    
      cNewGhcnhId = cCountryCode//'MU00'//cAStnId(5:9)
      
    elseif(iALength < 9) then
      
      cNewGhcnhId = cCountryCode//'MU00'//cAStnId(iALength-4:iALength)
      
    endif

 elseif(cAddSrcCode == '313' .or. cAddSrcCode == '314' .or. cAddSrcCode == '315') then
  
  cNewGhcnhId = cCountryCode//"W000"//cAStnId(iALength-4:iALength)

 elseif(cAddSrcCode == '343' .or. cAddSrcCode == '344' .or. cAddSrcCode == '345' .or. cAddSrcCode == '346') then
  
  cNewGhcnhId = cCountryCode//"W000"//cAStnId(iALength-4:iALength)
  
 elseif(cAddSrcCode == '335') then
 
!  cCountryCode = 'US' 
  cNewGhcnhId = cCountryCode//"W000"//cAStnId(8:12)
    
 elseif(cAddSrcCode == '248') then      
    
   cNewGhcnhId = cCountryCode//'M000'//trim(cAStnId(7:11))

 elseif(cAddSrcCode == '318') then
 
   cNewGhcnhId = cCountryCode//'M000'//trim(cAStnId(4:8)) 
   
 elseif(cAddSrcCode == '262') then      
    
   cNewGhcnhId = cCountryCode//'N0'//trim(cAStnId(1:7))

 elseif(cAddSrcCode == '264') then

   cNewGhcnhId = cCountryCode//'N0'//trim(cAStnId(1:5))
 
 elseif(cAddSrcCode == '249') then      
    
   cNewGhcnhId = cCountryCode//'U000'//trim(cAStnId(1:5))
   
 elseif(cNetworkCode(1:1) == 'M') then
        cNewGhcnhId(1:2) = cCountryCode
	cNewGhcnhId(3:3) = "M"
	cNewGhcnhId(7:11) = cAStnId(iALength-4:iALength)
      elseif(cNetworkCode(1:1) == 'I') then
        cNewGhcnhId(1:2) = cCountryCode
	cNewGhcnhId(3:3) = "I"
	cNewGhcnhId(8:11) = cAStnId(iALength-3:iALength)
      elseif(cNetworkCode(1:1) == 'A') then
        cNewGhcnhId(1:2) = cCountryCode
	cNewGhcnhId(3:3) = "A"
	cNewGhcnhId(6:11) = cAStnId(iALength-5:iALength)
      elseif(cNetworkCode(1:1) == 'W') then
        if(cCountryCode == "XX") cCountryCode="US"
        cNewGhcnhId(1:2) = cCountryCode
	cNewGhcnhId(3:3) = "W"
	cNewGhcnhId(7:11) = cAStnId(iALength-4:iALength)
      elseif(cNetworkCode(1:2) == 'CM') then
        cNewGhcnhId(1:2) = cCountryCode
	cNewGhcnhId(3:4) = "CM"
	cNewGhcnhId(7:11) = cAStnId(iALength-4:iALength)
      elseif(cNetworkCode(1:1) == 'N') then
        cNewGhcnhId(1:2) = cCountryCode
	cNewGhcnhId(3:3) = "N"
	if(iALength >= 8) then
	  cNewGhcnhId(4:11) = cAStnId(iALength-7:iALength)
	elseif(iALength==7) then 
	  cNewGhcnhId(5:11) = cAStnId(1:7)
	elseif(iALength==6) then 
	  cNewGhcnhId(6:11) = cAStnId(1:6)
	elseif(iALength==5) then 
	  cNewGhcnhId(7:11) = cAStnId(1:5)
	elseif(iALength==4) then 
	  cNewGhcnhId(7:11) = cAStnId(1:4)
	endif	
      elseif(cNetworkCode(1:1) == 'U'.or. cNetworkCode(1:1)=='P') then
        cNewGhcnhId(1:2) = cCountryCode
	cNewGhcnhId(3:3) = cNetworkCode(1:1)
	if(iALength >= 8) then
	  cNewGhcnhId(4:11) = cAStnId(iALength-7:iALength)
	elseif(iALength==7) then 
	  cNewGhcnhId(5:11) = cAStnId(1:7)
	elseif(iALength==6) then 
	  cNewGhcnhId(6:11) = cAStnId(1:6)
	elseif(iALength==5) then 
	  cNewGhcnhId(7:11) = cAStnId(1:5)
	elseif(iALength==4) then 
	  cNewGhcnhId(8:11) = cAStnId(1:4)
        elseif(iALength==3) then
          cNewGhcnhId(9:11) = cAStnId(1:3)
	endif
      
!      endif
   
!   iALength = len_trim(cAStnId)
!   cNewGhcnhId(4:11) = '00000000'
!   cNewGhcnhId(1:3) = cCountryCode//'U'
!   if(iALength > 8) iALength = 8 
!   cNewGhcnhId(4:4+iALength-1) = cAStnId(1:iALength)
       
 endif !finished checking source code that determines new ghcnd id format
 
 write(*,*) 'New GHCNh station created ',cNewGhcnhId
 
 if(cNewGhcnhId == ' ') then
   write(*,*) 'Ghcnd id could not be created...stopping'
   stop
 endif  !finished checking if new ghcnd id is blank, i.e., could not be created
 
 endif !finished checking if supplied new ghcnd id was blank
 
 if(cNewGhcnhId == ' ') then
   write(*,*) 'Ghcnd id could not be created...stopping'
   stop
 endif
 
 do iStn = 1,iNumMingled
 
    if(cNewGhcnhId < cMingledIds(iStn)) then
   
        iInsertLoc = iStn
      
        cMingledIds(iInsertLoc+1:iNumMingled+1) = cMingledIds(iInsertLoc:iNumMingled)
	iSourceCnts(iInsertLoc+1:iNumMingled+1) = iSourceCnts(iInsertLoc:iNumMingled)
	cSrcRecCodes(:,iInsertLoc+1:iNumMingled+1) = cSrcRecCodes(:,iInsertLoc:iNumMingled)
	cSrcRecIds(:,iInsertLoc+1:iNumMingled+1) = cSrcRecIds(:,iInsertLoc:iNumMingled)
	cInvOutRecs(iInsertLoc+1:iNumMingled+1) = cInvOutRecs(iInsertLoc:iNumMingled)
   
        exit
   
    endif
 
 enddo
   
 cMingledIds(iInsertLoc) = cNewGhcnhId
 iSourceCnts(iInsertLoc) = 1
 cSrcRecCodes(1,iInsertLoc) = cAddSrcCode
 cSrcRecIds(1,iInsertLoc) = cAStnId
 cUname = uppercase(cAName(1:30))
 write(cInvOutRecs(iInsertLoc),'(a11,1x,f8.4,1x,f9.4,1x,f6.1,1x,a2,1x,a30,9x,a5)') cNewGhcnhId,rALat,rALon,rAElev,cAState,&
 cUName,cAWmoId
 iNumMingled = iNumMingled + 1
 
!use existing cAStnId for this primary sources (only search in this case)
 
! else need to add as a consecutive count with country 999 (edit cAInvRecs)
!copy cAInvRecs line to cInvOutRecs--adjust mingle stuff
 
 end subroutine addNewStn
!------------------------------------------------------------------------------------------------------------------------
 subroutine combineStns(cNewStnId,rNewLat,rNewLon,rNewElev,cNewAux,cOldStnIds,iNumOldStns,cMingledIds,&
                 iNumMingled,iSourceCnts,cSrcRecCodes,cSrcRecIds,cInvOutRecs)


 character(len=11) :: cNewStnId
 character(len=51) :: cNewAux

 character(len=11), dimension(1:iNumOldStns) :: cOldStnIds
 character(len=11), dimension(1:iMaxnStns) ::  cMingledIds
 character(len=01), dimension(iMaxnSourceRecs,iMaxnStns) :: cSrcRecCodes
 character(len=01), dimension(iMaxnSourceRecs) :: cNewSrcCodes
 character(len=11), dimension(iMaxnSourceRecs) :: cNewSrcIds
 character(len=11), dimension(iMaxnSourceRecs,iMaxnStns) :: cSrcRecIds
 character(len=85), dimension(iMaxnStns) :: cInvOutRecs

 integer, dimension(iMaxnStns) :: iSourceCnts
 
 integer :: iNewSrcCnt, iNumMingled, iNumOldStns,iOldStn,iInsertLoc
 
 real :: rNewLat,rNewLon, rNewElev

 iNewSrcCnt = 0

 do iOldStn = 1,iNumOldStns
 
   do iStn = 1, iNumMingled
   
      if(cMingledIds(iStn) == cOldStnIds(iOldStn)) exit
   
   enddo 
   
   do iSrc = 1,iSourceCnts(iStn)
   
      call addASource(cSrcRecCodes(iSrc,iStn),cSrcRecIds(iSrc,iStn),iNewSrcCnt,cNewSrcCodes,cNewSrcIds)
      
   end do
   
   !now delete iOldStn record from Mingle List arrays and cInvOutRecs
   
   cMingledIds(iStn:iNumMingled-1) = cMingledIds(iStn+1:iNumMingled)
   cMingledIds(iNumMingled) = " "
   iSourceCnts(iStn:iNumMingled-1) = iSourceCnts(iStn+1:iNumMingled)
   iSourceCnts(iNumMingled) = 0
   cSrcRecCodes(:,iStn:iNumMingled-1) = cSrcRecCodes(:,iStn+1:iNumMingled)
   cSrcRecCodes(:,iNumMingled) = " "
   cSrcRecIds(:,iStn:iNumMingled-1) = cSrcRecIds(:,iStn+1:iNumMingled)
   cSrcRecIds(:,iNumMingled) = " "
   cInvOutRecs(iStn:iNumMingled-1) = cInvOutRecs(iStn+1:iNumMingled)
   cInvOutRecs(iNumMingled) = " "

   iNumMingled = iNumMingled - 1
   
 end do !iOldStn do
   
 !now insert the combined record
   
 iInsertLoc = iNumMingled + 1
 
 do iStn = 1,iNumMingled
 
    if(cNewStnId < cMingledIds(iStn)) then
   
      iInsertLoc = iStn
      
      cMingledIds(iInsertLoc+1:iNumMingled+1) = cMingledIds(iInsertLoc:iNumMingled)
      iSourceCnts(iInsertLoc+1:iNumMingled+1) = iSourceCnts(iInsertLoc:iNumMingled)
      cSrcRecCodes(:,iInsertLoc+1:iNumMingled+1) = cSrcRecCodes(:,iInsertLoc:iNumMingled)
      cSrcRecIds(:,iInsertLoc+1:iNumMingled+1) = cSrcRecIds(:,iInsertLoc:iNumMingled)
      cInvOutRecs(iInsertLoc+1:iNumMingled+1) = cInvOutRecs(iInsertLoc:iNumMingled)
   
      exit
   
    endif
 
 enddo
   
 cMingledIds(iInsertLoc) = cNewStnId
 iSourceCnts(iInsertLoc) = iNewSrcCnt
 cSrcRecCodes(:,iInsertLoc) = cNewSrcCodes
 cSrcRecIds(:,iInsertLoc) = cNewSrcIds
 write(cInvOutRecs(iInsertLoc),'(a11,1x,f8.4,1x,f9.4,1x,f6.1,a48)') cNewStnId,rNewLat,rNewLon,rNewElev,cNewAux(1:48)
 iNumMingled = iNumMingled + 1
 
 end subroutine combineStns
 !---------------------------------------------------------------------------
 subroutine addASource(cSrc2Add,cId2Add,iNumSources,cSrcCodes,cSrcIds)
 
 character(len=01), dimension(iMaxnSourceRecs) :: cSrcCodes
 character(len=11), dimension(iMaxnSourceRecs) :: cSrcIds
 
 character(len=03) :: cSrc2Add
 character(len=11) :: cId2Add

 integer :: iSrc2AddHrchyLoc, iNumSources, iInsertLoc

 if(count(cSrcCodes == cSrc2Add .and. cSrcIds == cId2Add) > 0) return 

 iSrc2AddHrchyLoc = iIndexinSrcHierarchy(cSrc2Add)
 
 iInsertLoc = iNumSources + 1
   
 do iSrc = 1, iNumSources
   
   if(iIndexinSrcHierarchy(cSrcCodes(iSrc)) > iSrc2AddHrchyLoc) then
      iInsertLoc = iSrc
      cSrcCodes(iInsertLoc+1:iNumSources+1) = cSrcCodes(iInsertLoc:iNumSources)
      cSrcIds(iInsertLoc+1:iNumSources+1) = cSrcIds(iInsertLoc:iNumSources)
      exit
   endif
   
 enddo
   
 cSrcCodes(iInsertLoc) = cSrc2Add
 cSrcIds(iInsertLoc) = cId2Add
 iNumSources = iNumSources + 1

 end subroutine
!-----------------------------------------------------------------------------------------   
 subroutine check4Dups()
 
 integer :: iCnt
 
 cDelStnIds = ' '
 
 iNumDelStns = 0
 
 do iStn = 1, iNumMingled
 
   if(count(cDelStnIds == cMingledIds(iStn)) > 0) cycle
   
   iCnt = count(cMingledIds(1:iNumMingled) == cMingledIds(iStn))
   
   if(iCnt == 1) cycle
   
   iNumDelStns = iNumDelStns + 1
   
   cDelStnIds(iNumDelStns) = cMingledIds(iStn)
 
 end do
 
 end subroutine check4Dups
!-----------------------------------------------------------------------------------------
 subroutine findCustomMingleIndex(iAIndex,iCIndex)
 
 integer:: iAIndex, iCIndex, i
 
 iCIndex=0
 
 do i=1,iNumCustomMingled
 
   if(count(cCustomSrcRecCodes(1:iCustomSourceCnts(i),i)==cAddSrcCode .and. &
   cCustomSrcRecIds(1:iCustomSourceCnts(i),i)==cAStnIds(iAIndex))>0) then 
     iCIndex=i
     exit
   endif
 
 end do
 return
 
 end subroutine findCustomMingleIndex
!-----------------------------------------------------------------------------------------
 subroutine readCountryCodes(cCountryCodes,cCountryNames,iNumCtryCodes)
 
 integer :: iNumCtryCodes, iStat
 
 character(len=02), dimension(1:250) :: cCountryCodes
 character(len=62), dimension(1:250) :: cCountryNames
 
 iNumCtryCodes = 1
 
 do 
   read(iUCountryCodes,'(a2,1x,a60)',iostat=iStat) cCountryCodes(iNumCtryCodes), cCountryNames(iNumCtryCodes)
   if(iStat == -1) exit
!   write(*,*) cCountryCodes(iNumCtryCodes), " ",cCountryNames(iNumCtryCodes)
   iNumCtryCodes = iNumCtryCodes + 1
 end do
 
 iNumCtryCodes = iNumCtryCodes -1
 
 end subroutine readCountryCodes
!------------------------------------------------------------------------------------------
!**********************************************************************

function uppercase(str) result(ucstr)

! convert string to upper case

integer :: i, ilen,iquote, iachar, iav, ioffset, iqc

character (len=*):: str
character (len=len_trim(str)):: ucstr

ilen=len_trim(str)
ioffset=iachar('A')-iachar('a')     
iquote=0
ucstr=str
do i=1,ilen
  iav=iachar(str(i:i))
  if(iquote==0 .and. (iav==34 .or.iav==39)) then
    iquote=1
    iqc=iav
    cycle
  end if
  if(iquote==1 .and. iav==iqc) then
    iquote=0
    cycle
  end if
  if (iquote==1) cycle
  if(iav >= iachar('a') .and. iav <= iachar('z')) then
    ucstr(i:i)=achar(iav+ioffset)
  else
    ucstr(i:i)=str(i:i)
  end if
end do
return

end function uppercase
!**********************************************************************

subroutine removesp(str)

! Removes spaces, tabs, and control characters in string str

character(len=*):: str
character(len=1):: ch
character(len=len_trim(str))::outstr

integer :: ich, k, lenstr

str=adjustl(str)
lenstr=len_trim(str)
outstr=' '
k=0

do i=1,lenstr
  ch=str(i:i)
  ich=iachar(ch)
  select case(ich)    
    case(0:32)  ! space, tab, or control character
         cycle       
    case(33:)  
      k=k+1
      outstr(k:k)=ch
  end select
end do

str=adjustl(outstr)

end subroutine removesp

subroutine findCntryCode(cACountry,cCountryNames,cACountryCode)
 character(len=62), dimension(1:250) :: cCountryNames
 character(len=30) :: cACountry
 character(len=02) :: cACountryCode
 integer :: iALength, iBLength, iCtry
 
   cACountryCode = 'XX'

   iALength = len_trim(adjustl(cACountry))

   do iCtry = 1,iNumCtryCodes
   
     call removesp(cACountry)
     call removesp(cCountryNames(iCtry))
   
     iBLength = len_trim(adjustl(cCountryNames(iCtry)))
!     write(*,*) cAStnIds(iAStn),iBLength,adjustl(cCountryNames(iCtry)(1:iBLength)), " ",iALength,&
!     adjustl(cACountries(iAStn)(1:iALength))
  
!     if(adjustl(cCountryNames(iCtry)(1:iBLength)) == adjustl(cACountries(iAStn)(1:iALength))) then
!      write(*,*) cAStnIds(iAStn),cACountries(iAStn),cCountryNames(iCtry)
!     stop
     if(cACountry == cCountryNames(iCtry)) then
!       write(*,*) 'Country found'
!       stop
       
       cACountryCode = cCountryCodes(iCtry)
       exit
     endif
   
   end do   
   return
end subroutine findCntryCode

!**********************************************************************


 end program add_hourly_stns
