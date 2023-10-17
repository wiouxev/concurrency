## Start of "get devices from Azuure AD" 
## source: https://smsagent.blog/2018/10/22/querying-for-devices-in-azure-ad-and-intune-with-powershell-and-microsoft-graph/

Function Get-AzureADDevices(){

[cmdletbinding()]

$graphAPIversion = "v1.0"
$resource = "devices"
$queryParams = ""

    try {

        $uri = "https://graph.microsoft.com/$graphAPIversion/$($resource)$queryparams"
        Invoke-RestMethod -Uri $uri -Headers $authToken -Method Get
    }

    catch {

    $ex = $_.Exception
    $errorResponse =$ex.Response.GetResponseStream()
    $reader = New-Object System.IO.StreamReader ($errorResponse)
    $reader.BaseStream.Position = 0
    $reader.DiscardBufferedData()
    $responseBody = $reader.ReadToEnd();
    Write-Host "Response content:`n$responseBody" -f Red
    Write-Error "Request to $Uri failed with HTTP Status $($ex.Response.StatusCode) $($ex.Response.StatusDescription)"
    write-host
    break
 
    }

}



# Return AzureAD device data from get-azureaddevices.ps1
# source: https://smsagent.blog/2018/10/22/querying-for-devices-in-azure-ad-and-intune-with-powershell-and-microsoft-graph/
# Connect-AzureAD

$ADDeviceResponse = Get-AzureADDevices
$ADDevices = $ADDeviceResponse.Value
$NextLink = $ADDeviceResponse.'@odata.nextLink'
# Need to loop the requests because only 100 results are returned each time
While ($NextLink -ne $null)
{
    $ADDeviceResponse = Invoke-RestMethod -Uri $NextLink -Headers $authToken -Method Get
    $NextLink = $ADDeviceResponse.'@odata.nextLink'
    $ADDevices += $ADDeviceResponse.Value
}
 
Write-Host "Found $($ADDevices.Count) devices in Azure AD" -ForegroundColor Yellow
$ADDevices.operatingSystem | group -NoElement
 
$DeviceTypes = $ADDevices.operatingSystem | group -NoElement | Select -ExpandProperty Name
$AzureADDevices = @{}
Foreach ($DeviceType in $DeviceTypes)
{
    $AzureADDevices.$DeviceType = $ADDevices | where {$_.operatingSystem -eq "$DeviceType"} | Sort displayName
}
 
Write-host "Devices have been saved to a variable. Enter '`$AzureADDevices' to view."