$SQLServer = "VWENTAPP540102P"
$db = "DirSyncPro"
$devicetable = "BT_Device"
#$sqlusername = "MigratorProADM"
#$sqluserpw = Read-Host -AsSecureString -Prompt "Enter Password for MigratorProAdm"
$sqlcred = get-credential
$devicesquery = "select commonname, description, AgentLastContactTimestamp, DiscoveryStatus, CredentialCacheStatus, reaclstatus, offlinedomainjoinstatus, Cutoverstatus from $devicetable where batchid = $devicewave"
$batchquery = "SELECT BatchId, Batchname FROM [DirSyncPro].[dbo].[ADM_Batch]"
$groupfix = "update BT_Groups set TargetNetBIOSName = 'BRN' where type = 'group'"
$groupquery = "select NetBIOSName, SourceSAMAccountName, TargetNetBIOSName, TargetSAMAccountName, ObjectSID, TargetObjectSID, TargetDirectoryID, UserPrincipalName, readytosync, needsattention, type from [DirSyncPro].[dbo].[BT_Groups] where type = 'group' order by SourceSAMAccountName DESC"


##instal module if needed
if(-not (get-module sqlserver -listavailable)){
install-module -name sqlserver -scope currentuser -force -confirm:$false

}

##manual input csv path and name
$outputfilename = Read-Host -Prompt "Enter path and name of file to be output"

##Display Wave IDs
write-host "Updating Groups TargetNetBIOSName"
#$availbatchids = Invoke-Sqlcmd -ServerInstance $SQLServer -username $sqlusername -password $sqluserpw -Database $db -Query $batchquery
$groupquerycmd = Invoke-Sqlcmd -ServerInstance $SQLServer -Credential $sqlcred -Database $db -Query $groupquery

$groupquerycmd | Export-Csv $outputfilename -Delimiter "," -NoTypeInformation


