$SQLServer = "VWENTAPP540102P"
$db = "DirSyncPro"
$devicetable = "BT_Device"
#$sqlusername = "MigratorProADM"
#$sqluserpw = Read-Host -Prompt "Enter Password for MigratorProAdm" -assecurestring
$sqlcred = get-credential
$batchquery = "SELECT BatchId, Batchname FROM [DirSyncPro].[dbo].[ADM_Batch]"


##instal module if needed
if(-not (get-module sqlserver -listavailable)){
install-module -name sqlserver -scope currentuser -force -confirm:$false
}

##Display Wave IDs
#write-host "Available Batch IDs"
#$availbatchids = Invoke-Sqlcmd -ServerInstance $SQLServer -username $sqlusername -password $sqluserpw -Database $db -Query $batchquery
#$availbatchids
#write-host $availbatchids

$devicewave = Read-Host -Prompt "Enter Wave ID"

##manual input csv path and name
$outputfilename = Read-Host -Prompt "Enter path and name of file to be output"

##connect to devices db and export information to csv by wave
$w10query = "Select bt_device.deviceid, commonname, actionname, status, message from BT_Device 
LEFT JOIN ADM_DeviceJob ON bt_Device.deviceid = ADM_DeviceJob.deviceid 
where batchid = $devicewave AND actionname = 'win10-tasks'"
#$devicesquery = "select batchid, commonname, description, AgentLastContactTimestamp, DiscoveryStatus, CredentialCacheStatus, 
#reaclstatus, offlinedomainjoinstatus, Cutoverstatus from $devicetable where batchid in ($devicewave)"
#Invoke-Sqlcmd -ServerInstance $SQLServer -username "MigratorProAdm" -password $sqluserpw -Database $db -Query $devicesquery | Export-Csv $outputfilename -Delimiter "," -NoTypeInformation
Invoke-Sqlcmd -ServerInstance $SQLServer -Credential $sqlcred -Database $db -Query $w10query | Export-Csv $outputfilename -Delimiter "," -NoTypeInformation
