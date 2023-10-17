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

$devicewave = Read-Host -Prompt "Enter Wave IDs separated by commas"

##manual input csv path and name
$outputfilename = Read-Host -Prompt "Enter path and name of file to be output"

##connect to devices db and export information to csv by wave
$devicesquery = "select d.batchid, b.batchname, commonname, description, AgentLastContactTimestamp, DiscoveryStatus, CredentialCacheStatus, reaclstatus, offlinedomainjoinstatus, Cutoverstatus, lastjobmessage from $devicetable D left join ADM_Batch B on D.BatchID=B.BatchID where d.batchid in ($devicewave)"
#Invoke-Sqlcmd -ServerInstance $SQLServer -username "MigratorProAdm" -password $sqluserpw -Database $db -Query $devicesquery | Export-Csv $outputfilename -Delimiter "," -NoTypeInformation
Invoke-Sqlcmd -ServerInstance $SQLServer -Credential $sqlcred -Database $db -Query $devicesquery | Export-Csv $outputfilename -Delimiter "," -NoTypeInformation


##sample select and return to file
#Invoke-Sqlcmd -ServerInstance $SQLServer -Database $db3 -Query $selectdata | Export-Csv "C:\files\reports\run.csv" -Delimiter "," -NoTypeInformation