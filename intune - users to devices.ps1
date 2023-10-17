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



# NEW 

# explain script function
write-host -ForegroundColor Yellow "This Script retrieves and adds all Azure AD owned devices from all users from a provided user-based group to a different provided group (device-based) by using ObjectID's."

# explain what's needed to run script
write-host -ForegroundColor Yellow "To run this script, you will need AzureAD ObjectID's for host AD group (user) and targeted AD group (new group or device group)"

# connect to Azure AD
write-host -foregroundcolor Red "Connecting to Azure..."
Connect-AzureAD

# Obtain user-based group objectID from user
# write-host -ForegroundColor Red "ObjectID of user-based group:"
$ADuserGroup = Read-Host "ObjectID of user-based group"
write-host -ForegroundColor Yellow "Script is retrieving all devices owned by users in the group $ADuserGroup."


# Pulls AD devices owned by users within user provided group ObjectID, and displays to host
get-azureADgroupmember -objectID "$ADUSerGroup" | get-AzureADUserOwnedDevice
$DevicesByUserGroup = Get-azureADgroupmember -objectID “$ADUserGroup” | get-AzureADUserOwnedDevice | Select-Object objectID #,DeviceID
write-host -ForegroundColor Yellow "Retrieved all devices owned by users in Group $ADuserGroup"
# $DevicesByUserGroup variable successfully grabs all devices via ObjectID and lists them out when variable is called


# If you want to add a group creation step/prompt...
# write-host -ForegroundColor Red "Do you need to create a new group now?"
# $answer = prompt-host
# If $answer = yes {
# write-host -ForegroundColor Yellow "FYI: Script will append ' - Devices' to provided group name"
# write-host -ForegroundColor Red "Name for new device group"
# $DeviceGroupName = prompt-host
# new-AzureADGroup -DisplayName "$DeviceGroupName - Devices" -MailEnabled $false -SecurityEnabled $true -MailNickname "NotSet"
# write-host -ForegroundColor Yellow "AD group $DeviceGroupName - Devices created"
# }
# if $answer = no ... next step in script



# prompts user for group to add devices to
$ADdeviceGroup = Read-Host "ObjectID of intended device-based Azure AD Group to add devices to"
# write-host -ForegroundColor Red "ObjectID of intended device-based Azure AD Group to add devices to:" (wrong syntax)

# adds devices from previous group to this group 
write-host -ForegroundColor Yellow "Script is adding devices to group $ADdeviceGroup"
# Get-AzureADGroup $ADDeviceGroup (not needed?)
Add-AzureADGroupMember -objectID "$ADdeviceGroup" -RefObjectID "$DevicesByUserGroup"
# ^ need to figure out how to do batch adds.. might need an if-then for each object/deviceID..
# ^ get an invalud value error: invalid value specified for object ref property 'objectid'.. doesn't like the list
# Created $test2 variable with one device objectID: Add-AzureADGroupMember -objectID "$ADdeviceGroup" -RefObjectID "$Test2"
# ^ this worked
foreach ($objID in $DevicesByUserGroup.objectID) 
 {
  Add-AzureADGroupMember -ObjectId "$ADdeviceGroup" -RefObjectId "$objID"

  write-host -ForegroundColor Yellow "Successfully added owned devices within user group $ADuserGroup to group $ADdeviceGroup."
 }
# writes to host the resulting device member list of group that script added devices to
write-host -ForegroundColor Yellow "New group member list for group $ADdeviceGroup"
get-azureADgroupmember -objectID "$ADdeviceGroup"

# end script
write-host -ForegroundColor Yellow "Complete!"


# baby's first powershell script 
# improvement ideas
# create if/then section for creating a group within the script
# add code to translate objectIDs to simple group displaynames
# make secondary static script that keeps claims device group up to date?

