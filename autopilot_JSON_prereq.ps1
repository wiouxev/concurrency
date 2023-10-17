#install all prereq modules
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Install-Module WindowsAutopilotIntune -MinimumVersion 5.4.0 -Force
Install-Module Microsoft.Graph.Groups -Force
Install-Module Microsoft.Graph.Authentication -Force
Install-Module Microsoft.Graph.Identity.DirectoryManagement -Force

Import-Module WindowsAutopilotIntune -MinimumVersion 5.4
Import-Module Microsoft.Graph.Groups
Import-Module Microsoft.Graph.Authentication
Import-Module Microsoft.Graph.Identity.DirectoryManagement

#connect to Graph
#$tenantID = "0cf1000a-f2b2-4206-b5de-109ea0169973" - Chris' dev tenant, use concurrency acct
#$tenantID = "96f95b62-7765-4d7c-81d0-e3ce54b82887" - my dev tenant, use MOD admin
#$credentialU = "admin@M365x45194823.onmicrosoft.com"
#$credentialP = "VpbV2y2X6O"

#Connect-MgGraph -tenantID $tenantID -Scopes "Device.ReadWrite.All", "DeviceManagementManagedDevices.ReadWrite.All", "DeviceManagementServiceConfig.ReadWrite.All", "Domain.ReadWrite.All", "Group.ReadWrite.All", "GroupMember.ReadWrite.All", "User.Read"


#create JSON(s)
Connect-MgGraph -Scopes "Device.ReadWrite.All", "DeviceManagementManagedDevices.ReadWrite.All", "DeviceManagementServiceConfig.ReadWrite.All", "Domain.ReadWrite.All", "Group.ReadWrite.All", "GroupMember.ReadWrite.All", "User.Read"
$AutopilotProfile = Get-AutopilotProfile
$targetDirectory = "C:\users\estueve\downloads\migration"
$AutopilotProfile | ForEach-Object {
    New-Item -ItemType Directory -Path "$targetDirectory\$($_.displayName)"
    $_ | ConvertTo-AutopilotConfigurationJSON | Set-Content -Encoding Ascii "$targetDirectory\$($_.displayName)\AutopilotConfigurationFile.json"
}