#plugin serial number for script or change to user input
Connect-MSGraph

$SN = Read-Host -Prompt 'Serial #:'
$Device = Get-IntuneManagedDevice -Filter "contains(serialNumber,'$SN')"
 
$DeviceID = $Device.id
$Resource = "deviceManagement/managedDevices('$DeviceID')/setDeviceName"
$graphApiVersion = "Beta"
$uri = &amp;amp;amp;"https://graph.microsoft.com/$graphApiVersion/$($resource)"
 
$JSONName = @"
{
deviceName:"$($Device.serialNumber)"
}
"@
 
Invoke-MSGraphRequest -HttpMethod POST -Url $uri -Content $JSONName