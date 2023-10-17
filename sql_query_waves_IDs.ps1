﻿$SQLServer = "VWENTAPP540102P"
$db = "DirSyncPro"
$devicetable = "BT_Device"
#$sqlusername = "MigratorProADM"
#$sqluserpw = Read-Host -AsSecureString -Prompt "Enter Password for MigratorProAdm"
$sqlcred = get-credential
$devicesquery = "select commonname, description, AgentLastContactTimestamp, DiscoveryStatus, CredentialCacheStatus, reaclstatus, offlinedomainjoinstatus, Cutoverstatus from $devicetable where batchid = $devicewave"
$batchquery = "SELECT BatchId, Batchname FROM [DirSyncPro].[dbo].[ADM_Batch]"


##instal module if needed
if(-not (get-module sqlserver -listavailable)){
install-module -name sqlserver -scope currentuser -force -confirm:$false
}

##Display Wave IDs
write-host "Available Batch IDs"
#$availbatchids = Invoke-Sqlcmd -ServerInstance $SQLServer -username $sqlusername -password $sqluserpw -Database $db -Query $batchquery
$availbatchids = Invoke-Sqlcmd -ServerInstance $SQLServer -Credential $sqlcred -Database $db -Query $batchquery

$availbatchids


