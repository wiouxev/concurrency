#iOS Company restrictions - claims (test)

#groups to pull device list from

#IL Appr Unit 3
#fac80900-bcd6-4f7d-8ea7-6558281de36e

#WRO Appr Unit 1
#28791d18-28aa-4af7-aa5e-fdac2c26bb8c

#CI10010
#3af12d54-2da8-4255-8003-4d3f8505c5d2

#SRO Appr Unit 1
#c9722e65-f07e-4efb-aade-934f8377cbb0

#Claims Training
#186b3867-3b8e-4e45-9030-04b48fa24399

#IL Appr Unit 1
#ed64b07b-3531-408e-9e10-8056488f917f

#Desk Appraiser Unit
#375f07dd-379c-42ee-bd2a-523bad4af6ec

#IL Appr Unit 2
#b9d94d49-d7c0-4af5-b01d-650afd0d5be7

#WRO Appr Unit 2
#b3a7d1be-5241-4333-b674-82a82de9726e

#Field Claims - Property
#5084b982-85fe-40e2-b279-d2780a640935



#groups to move to

#IL Appr Unit 3 - Devices 
#1d88ca46-c41b-44c0-805a-799d83034120

#WRO Appr Unit 1 - Devices 
#2839598c-4cb0-49b4-91dd-8441d5b0ab85

#CI10010 - Devices
#34e8f849-1cf0-4367-97ff-f960c92eb0ac

#SRO Appr Unit 1 - Devices
#3788f2b5-f0fa-4127-9fab-a21f1b69371b

#Claims Training - Devices
#4c79b6e0-9c27-464d-94e3-48756f83a54e	

#IL Appr Unit 1 - Devices
#5d5f7957-ffb7-4240-8969-fa794bdff454

#Desk Appraiser Unit - Devices
#5f1d8573-52e5-4d6f-a9dd-30d0876c315a

#IL Appr Unit 2 - Devices
#6c79a5d4-fa67-432b-bca4-dfedb49c0d48

#WRO Appr Unit 2 - Devices
#befcd226-c4fe-4212-8ba8-d54137e64672

#Field Claims - Property - Devices
#f978f759-d27a-4c03-b752-63eda3ed23f0


# User groups -> Devices 
# modules needed for script: AzureAD, IntuneBackupAndRestore, MSGraphFunctions

# Getting all personal owned devices
# OLD
# $PersonalDevices = Get-ManagedDevices | Where-Object {$_.OwnerType -eq "personal"} | Select-Object id,devicename,ownertype
# If any personal devices found
# if ($PersonalDevices -ne $null) {
# 
#    # Personal devices found - looping through each
#    ForEach ($PersonalDevice in $PersonalDevices) {
#        
#        # Setting ownertype on devices
#        Set-ManagedDevice -id $PersonalDevice.id -ownertype Company
# 
#    }
# 
# }
# 
# No devices found - write to host
# else {
#    Write-Host -ForegroundColor Yellow "No personal devices found"
# }


# connect to Azure AD
write-host -foregroundcolor Red "Connecting to Azure..."
Connect-AzureAD




#######################################IL Appr Unit 3
#fac80900-bcd6-4f7d-8ea7-6558281de36e - user
#1d88ca46-c41b-44c0-805a-799d83034120

#IL Appr Unit 3
# Pulls AD devices owned by users within user provided group ObjectID, and displays to host
get-azureADgroupmember -objectID "fac80900-bcd6-4f7d-8ea7-6558281de36e" | get-AzureADUserOwnedDevice
$DevicesByUserGroup1 = Get-azureADgroupmember -objectID “fac80900-bcd6-4f7d-8ea7-6558281de36e” | get-AzureADUserOwnedDevice | Select-Object objectID #,DeviceID
write-host -ForegroundColor Yellow "Retrieved all devices owned by users in Group fac80900-bcd6-4f7d-8ea7-6558281de36e - IL Appr Unit 3"
# $DevicesByUserGroup variable successfully grabs all devices via ObjectID and lists them out when variable is called



foreach ($objID in $DevicesByUserGroup1.objectID) 
 {
  Add-AzureADGroupMember -ObjectId "1d88ca46-c41b-44c0-805a-799d83034120" -RefObjectId "$objID"

  write-host -ForegroundColor Yellow "Successfully added owned devices within user group fac80900-bcd6-4f7d-8ea7-6558281de36e - IL Appr Unit 3 to group 1d88ca46-c41b-44c0-805a-799d83034120 - IL Appr Unit 3 - Devices."
 }
# writes to host the resulting device member list of group that script added devices to
write-host -ForegroundColor Yellow "New group member list for group 1d88ca46-c41b-44c0-805a-799d83034120 - IL Appr Unit 3 - Devices"
get-azureADgroupmember -objectID "1d88ca46-c41b-44c0-805a-799d83034120"

##################################################WRO Appr Unit 1
#28791d18-28aa-4af7-aa5e-fdac2c26bb8c - user
#2839598c-4cb0-49b4-91dd-8441d5b0ab85 - devices

#WRO Appr Unit 1
# Pulls AD devices owned by users within user provided group ObjectID, and displays to host
get-azureADgroupmember -objectID "28791d18-28aa-4af7-aa5e-fdac2c26bb8c" | get-AzureADUserOwnedDevice
$DevicesByUserGroup2 = Get-azureADgroupmember -objectID “28791d18-28aa-4af7-aa5e-fdac2c26bb8c” | get-AzureADUserOwnedDevice | Select-Object objectID #,DeviceID
write-host -ForegroundColor Yellow "Retrieved all devices owned by users in Group WRO Appr Unit 1"
# $DevicesByUserGroup variable successfully grabs all devices via ObjectID and lists them out when variable is called


# adds devices from previous group to this group 
write-host -ForegroundColor Yellow "Script is adding devices to group WRO Appr Unit 1"

foreach ($objID in $DevicesByUserGroup2.objectID) 
 {
  Add-AzureADGroupMember -ObjectId "2839598c-4cb0-49b4-91dd-8441d5b0ab85" -RefObjectId "$objID"

  write-host -ForegroundColor Yellow "Successfully added owned devices within user group WRO Appr Unit 1 to group WRO Appr Unit 1 - Devices."
 }
# writes to host the resulting device member list of group that script added devices to
write-host -ForegroundColor Yellow "New group member list for group WRO Appr Unit 1 - Devices"
get-azureADgroupmember -objectID "2839598c-4cb0-49b4-91dd-8441d5b0ab85"


##################################################CI10010
#3af12d54-2da8-4255-8003-4d3f8505c5d2 - user
#34e8f849-1cf0-4367-97ff-f960c92eb0ac - devices

#CI10010
# Pulls AD devices owned by users within user provided group ObjectID, and displays to host
get-azureADgroupmember -objectID "3af12d54-2da8-4255-8003-4d3f8505c5d2" | get-AzureADUserOwnedDevice
$DevicesByUserGroup3 = Get-azureADgroupmember -objectID “3af12d54-2da8-4255-8003-4d3f8505c5d2” | get-AzureADUserOwnedDevice | Select-Object objectID #,DeviceID
write-host -ForegroundColor Yellow "Retrieved all devices owned by users in Group CI10010"
# $DevicesByUserGroup variable successfully grabs all devices via ObjectID and lists them out when variable is called


# adds devices from previous group to this group 
write-host -ForegroundColor Yellow "Script is adding devices to group CI10010"

foreach ($objID in $DevicesByUserGroup3.objectID) 
 {
  Add-AzureADGroupMember -ObjectId "34e8f849-1cf0-4367-97ff-f960c92eb0ac" -RefObjectId "$objID"

  write-host -ForegroundColor Yellow "Successfully added owned devices within user group CI10010 to group CI10010 - Devices."
 }
# writes to host the resulting device member list of group that script added devices to
write-host -ForegroundColor Yellow "New group member list for group CI10010 - Devices"
get-azureADgroupmember -objectID "34e8f849-1cf0-4367-97ff-f960c92eb0ac"



##################################################SRO Appr Unit 1
#c9722e65-f07e-4efb-aade-934f8377cbb0 - user
#3788f2b5-f0fa-4127-9fab-a21f1b69371b - devices

#SRO Appr Unit 1
# Pulls AD devices owned by users within user provided group ObjectID, and displays to host
get-azureADgroupmember -objectID "c9722e65-f07e-4efb-aade-934f8377cbb0" | get-AzureADUserOwnedDevice
$DevicesByUserGroup4 = Get-azureADgroupmember -objectID “c9722e65-f07e-4efb-aade-934f8377cbb0” | get-AzureADUserOwnedDevice | Select-Object objectID #,DeviceID
write-host -ForegroundColor Yellow "Retrieved all devices owned by users in Group SRO Appr Unit 1"
# $DevicesByUserGroup variable successfully grabs all devices via ObjectID and lists them out when variable is called


# adds devices from previous group to this group 
write-host -ForegroundColor Yellow "Script is adding devices to group CI10010"

foreach ($objID in $DevicesByUserGroup4.objectID) 
 {
  Add-AzureADGroupMember -ObjectId "3788f2b5-f0fa-4127-9fab-a21f1b69371b" -RefObjectId "$objID"

  write-host -ForegroundColor Yellow "Successfully added owned devices within user group SRO Appr Unit 1 to group SRO Appr Unit 1 - Devices."
 }
# writes to host the resulting device member list of group that script added devices to
write-host -ForegroundColor Yellow "New group member list for group SRO Appr Unit 1 - Devices"
get-azureADgroupmember -objectID "3788f2b5-f0fa-4127-9fab-a21f1b69371b"



##################################################Claims Training
#186b3867-3b8e-4e45-9030-04b48fa24399 - user
#4c79b6e0-9c27-464d-94e3-48756f83a54e - devices

#Claims Training
# Pulls AD devices owned by users within user provided group ObjectID, and displays to host
get-azureADgroupmember -objectID "186b3867-3b8e-4e45-9030-04b48fa24399" | get-AzureADUserOwnedDevice
$DevicesByUserGroup5 = Get-azureADgroupmember -objectID “186b3867-3b8e-4e45-9030-04b48fa24399” | get-AzureADUserOwnedDevice | Select-Object objectID #,DeviceID
write-host -ForegroundColor Yellow "Retrieved all devices owned by users in Group Claims Training"
# $DevicesByUserGroup variable successfully grabs all devices via ObjectID and lists them out when variable is called


# adds devices from previous group to this group 
write-host -ForegroundColor Yellow "Script is adding devices to group Claims Training"

foreach ($objID in $DevicesByUserGroup5.objectID) 
 {
  Add-AzureADGroupMember -ObjectId "4c79b6e0-9c27-464d-94e3-48756f83a54e" -RefObjectId "$objID"

  write-host -ForegroundColor Yellow "Successfully added owned devices within user group Claims Training to group Claims Training - Devices."
 }
# writes to host the resulting device member list of group that script added devices to
write-host -ForegroundColor Yellow "New group member list for group Claims Training - Devices"
get-azureADgroupmember -objectID "4c79b6e0-9c27-464d-94e3-48756f83a54e"




##################################################IL Appr Unit 1
#ed64b07b-3531-408e-9e10-8056488f917f - user
#5d5f7957-ffb7-4240-8969-fa794bdff454 - devices

#IL Appr Unit 1
# Pulls AD devices owned by users within user provided group ObjectID, and displays to host
get-azureADgroupmember -objectID "ed64b07b-3531-408e-9e10-8056488f917f" | get-AzureADUserOwnedDevice
$DevicesByUserGroup6 = Get-azureADgroupmember -objectID “ed64b07b-3531-408e-9e10-8056488f917f” | get-AzureADUserOwnedDevice | Select-Object objectID #,DeviceID
write-host -ForegroundColor Yellow "Retrieved all devices owned by users in group IL Appr Unit 1"
# $DevicesByUserGroup variable successfully grabs all devices via ObjectID and lists them out when variable is called


# adds devices from previous group to this group 
write-host -ForegroundColor Yellow "Script is adding devices to group IL Appr Unit 1"

foreach ($objID in $DevicesByUserGroup6.objectID) 
 {
  Add-AzureADGroupMember -ObjectId "5d5f7957-ffb7-4240-8969-fa794bdff454" -RefObjectId "$objID"

  write-host -ForegroundColor Yellow "Successfully added owned devices within user group IL Appr Unit 1 to group IL Appr Unit 1 - Devices."
 }
# writes to host the resulting device member list of group that script added devices to
write-host -ForegroundColor Yellow "New group member list for group IL Appr Unit 1 - Devices"
get-azureADgroupmember -objectID "5d5f7957-ffb7-4240-8969-fa794bdff454"



##################################################Desk Appraiser Unit
#375f07dd-379c-42ee-bd2a-523bad4af6ec - user
#5f1d8573-52e5-4d6f-a9dd-30d0876c315a - devices

#Desk Appraiser Unit
# Pulls AD devices owned by users within user provided group ObjectID, and displays to host
get-azureADgroupmember -objectID "375f07dd-379c-42ee-bd2a-523bad4af6ec" | get-AzureADUserOwnedDevice
$DevicesByUserGroup7 = Get-azureADgroupmember -objectID “375f07dd-379c-42ee-bd2a-523bad4af6ec” | get-AzureADUserOwnedDevice | Select-Object objectID #,DeviceID
write-host -ForegroundColor Yellow "Retrieved all devices owned by users in group Desk Appraiser Unit"
# $DevicesByUserGroup variable successfully grabs all devices via ObjectID and lists them out when variable is called


# adds devices from previous group to this group 
write-host -ForegroundColor Yellow "Script is adding devices to group Desk Appraiser Unit"

foreach ($objID in $DevicesByUserGroup7.objectID) 
 {
  Add-AzureADGroupMember -ObjectId "5f1d8573-52e5-4d6f-a9dd-30d0876c315a" -RefObjectId "$objID"

  write-host -ForegroundColor Yellow "Successfully added owned devices within user group Desk Appraiser Unit to group Desk Appraiser Unit - Devices."
 }
# writes to host the resulting device member list of group that script added devices to
write-host -ForegroundColor Yellow "New group member list for group Desk Appraiser Unit - Devices"
get-azureADgroupmember -objectID "5f1d8573-52e5-4d6f-a9dd-30d0876c315a"




##################################################IL Appr Unit 2
#b9d94d49-d7c0-4af5-b01d-650afd0d5be7 - user
#6c79a5d4-fa67-432b-bca4-dfedb49c0d48 - devices

#IL Appr Unit 2
# Pulls AD devices owned by users within user provided group ObjectID, and displays to host
get-azureADgroupmember -objectID "b9d94d49-d7c0-4af5-b01d-650afd0d5be7" | get-AzureADUserOwnedDevice
$DevicesByUserGroup8 = Get-azureADgroupmember -objectID “b9d94d49-d7c0-4af5-b01d-650afd0d5be7” | get-AzureADUserOwnedDevice | Select-Object objectID #,DeviceID
write-host -ForegroundColor Yellow "Retrieved all devices owned by users in group IL Appr Unit 2"
# $DevicesByUserGroup variable successfully grabs all devices via ObjectID and lists them out when variable is called


# adds devices from previous group to this group 
write-host -ForegroundColor Yellow "Script is adding devices to group IL Appr Unit 2"

foreach ($objID in $DevicesByUserGroup8.objectID) 
 {
  Add-AzureADGroupMember -ObjectId "6c79a5d4-fa67-432b-bca4-dfedb49c0d48" -RefObjectId "$objID"

  write-host -ForegroundColor Yellow "Successfully added owned devices within user group IL Appr Unit 2 to group IL Appr Unit 2 - Devices."
 }
# writes to host the resulting device member list of group that script added devices to
write-host -ForegroundColor Yellow "New group member list for group IL Appr Unit 2 - Devices"
get-azureADgroupmember -objectID "6c79a5d4-fa67-432b-bca4-dfedb49c0d48"



#################################################WRO Appr Unit 2
#b3a7d1be-5241-4333-b674-82a82de9726e - user
#befcd226-c4fe-4212-8ba8-d54137e64672 - devices

#WRO Appr Unit 2
# Pulls AD devices owned by users within user provided group ObjectID, and displays to host
get-azureADgroupmember -objectID "b3a7d1be-5241-4333-b674-82a82de9726e" | get-AzureADUserOwnedDevice
$DevicesByUserGroup9 = Get-azureADgroupmember -objectID “b3a7d1be-5241-4333-b674-82a82de9726e” | get-AzureADUserOwnedDevice | Select-Object objectID #,DeviceID
write-host -ForegroundColor Yellow "Retrieved all devices owned by users in group WRO Appr Unit 2"
# $DevicesByUserGroup variable successfully grabs all devices via ObjectID and lists them out when variable is called


# adds devices from previous group to this group 
write-host -ForegroundColor Yellow "Script is adding devices to group WRO Appr Unit 2"

foreach ($objID in $DevicesByUserGroup9.objectID) 
 {
  Add-AzureADGroupMember -ObjectId "befcd226-c4fe-4212-8ba8-d54137e64672" -RefObjectId "$objID"

  write-host -ForegroundColor Yellow "Successfully added owned devices within user group IL Appr Unit 2 to group IL Appr Unit 2 - Devices."
 }
# writes to host the resulting device member list of group that script added devices to
write-host -ForegroundColor Yellow "New group member list for group IL Appr Unit 2 - Devices"
get-azureADgroupmember -objectID "befcd226-c4fe-4212-8ba8-d54137e64672"



#################################################Field Claims - Property
#5084b982-85fe-40e2-b279-d2780a640935 - user
#f978f759-d27a-4c03-b752-63eda3ed23f0 - devices

#Field Claims Property
# Pulls AD devices owned by users within user provided group ObjectID, and displays to host
get-azureADgroupmember -objectID "5084b982-85fe-40e2-b279-d2780a640935" | get-AzureADUserOwnedDevice
$DevicesByUserGroup10 = Get-azureADgroupmember -objectID “5084b982-85fe-40e2-b279-d2780a640935” | get-AzureADUserOwnedDevice | Select-Object objectID #,DeviceID
write-host -ForegroundColor Yellow "Retrieved all devices owned by users in group Field Claims - Property"
# $DevicesByUserGroup variable successfully grabs all devices via ObjectID and lists them out when variable is called


# adds devices from previous group to this group 
write-host -ForegroundColor Yellow "Script is adding devices to group Field Claims - Property"

foreach ($objID in $DevicesByUserGroup10.objectID) 
 {
  Add-AzureADGroupMember -ObjectId "f978f759-d27a-4c03-b752-63eda3ed23f0" -RefObjectId "$objID"

  write-host -ForegroundColor Yellow "Successfully added owned devices within user group Field Claims - Property to group Field Claims - Property - Devices."
 }
# writes to host the resulting device member list of group that script added devices to
write-host -ForegroundColor Yellow "New group member list for group Field Claims - Property - Devices"
get-azureADgroupmember -objectID "f978f759-d27a-4c03-b752-63eda3ed23f0"






# end script
write-host -ForegroundColor Yellow "Complete!"


# baby's first powershell script 
# improvement ideas
# create if/then section for creating a group within the script
# add code to translate objectIDs to simple group displaynames
# make secondary static script that keeps claims device group up to date?
# add .count to device groups before and after each task, then list how many total new added
#29