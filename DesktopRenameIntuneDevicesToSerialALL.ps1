Connect-MSGraph
$AlliOSDevices = Get-IntuneManagedDevice -Filter "(contains(operatingsystem, 'iOS')%20and%20isSupervised eq true)"
Foreach ($AlliOS in $AlliOSDevices)
{
$DeviceID = $Device.id
$Resource = "deviceManagement/managedDevices('$DeviceID')/setDeviceName"
$graphApiVersion = "Beta"
$uri = "https://graph.microsoft.com/$graphApiVersion/$($resource)"
$JSONName = @"
{
deviceName:"$($Device.serialNumber)"
}
"@
if ($AlliOS.deviceName -ne $AlliOS.serialNumber)
{
Invoke-MSGraphRequest -HttpMethod POST -Url $uri -Content $JSONName
}
}

#source https://timmyit.com/2019/05/21/intune-rename-ios-devices-with-intune-powershell-sdk/