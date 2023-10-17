#plugin serial number for script or change to user input
#my work iphone serial: F4GZC8WSN72J
Connect-MSGraph

$SN = Read-Host -Prompt 'Serial #'
$Device = Get-IntuneManagedDevice -Filter "contains(serialNumber,'F4GZC8WSN72J')"
 
$DeviceID = $Device.id
$Resource = "deviceManagement/managedDevices('$DeviceID')/setDeviceName"
$graphApiVersion = "Beta"
$uri = "https://graph.microsoft.com/$graphApiVersion/$($resource)"
 
$JSONName = @"
{
deviceName:"$($Device.serialNumber)"
}
"@
 
Invoke-MSGraphRequest -HttpMethod POST -Url $uri -Content $JSONName


#source
# https://timmyit.com/2019/05/21/intune-rename-ios-devices-with-intune-powershell-sdk/
#verified working