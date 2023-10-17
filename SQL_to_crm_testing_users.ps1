$SQLServer = "VWENTAPP540102P"
$db = "DirSyncPro"
$devicetable = "BT_Device"
#$sqlusername = "MigratorProADM"
#$sqluserpw = Read-Host -Prompt "Enter Password for MigratorProAdm" -assecurestring
$sqlcred = get-credential


##instal module if needed
if(-not (get-module sqlserver -listavailable)){
install-module -name sqlserver -scope currentuser -force -confirm:$false
}

##Display Wave IDs
#write-host "Available Batch IDs"
#$availbatchids = Invoke-Sqlcmd -ServerInstance $SQLServer -username $sqlusername -password $sqluserpw -Database $db -Query $batchquery
#$availbatchids
#write-host $availbatchids
#$devicewave = Read-Host -Prompt "Enter Wave IDs separated by commas"

##connect to devices db and export information to csv by wave
#$devicesquery = "select batchid, commonname, description, AgentLastContactTimestamp, DiscoveryStatus, CredentialCacheStatus, reaclstatus, offlinedomainjoinstatus, Cutoverstatus from $devicetable where batchid in ($devicewave)"
#$deviceinfoquery = "select top 25 BatchID, CommonName, AgentLastContactTimestamp, CredentialCacheStatus, OfflineDomainJoinStatus, CutoverStatus, description, DN, targetDN, lastusn from [DirSyncPro].[dbo].[BT_Device]"
##limisted query for ttesting
#$userinfoquery = "select top 30 lastusn, displayname, SourceSAMAccountName, TargetSAMAccountName, MatchValue1, UserPrincipalName,TargetUserPrincipalName from BT_Person" 

##full query for production
$userinfoquery = "select lastusn, displayname, SourceSAMAccountName, TargetSAMAccountName, MatchValue1, UserPrincipalName,TargetUserPrincipalName from BT_Person" 
#Invoke-Sqlcmd -ServerInstance $SQLServer -username "MigratorProAdm" -password $sqluserpw -Database $db -Query $devicesquery | Export-Csv $outputfilename -Delimiter "," -NoTypeInformation
$SQLResults = Invoke-Sqlcmd -ServerInstance $SQLServer -Credential $sqlcred -Database $db -Query $userinfoquery

##install and load modules to upload to crm
function Load-Module ($m) {

    # If module is imported say that and do nothing
    if (Get-Module | Where-Object {$_.Name -eq $m}) {
        write-host "Module $m is already imported."
    }
    else {

        # If module is not imported, but available on disk then import
        if (Get-Module -ListAvailable | Where-Object {$_.Name -eq $m}) {
            Import-Module $m -Verbose
        }
        else {
            
            # If module is not imported, not available on disk, but is in online gallery then install and import
            Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -scope currentuser
            start-sleep 90
            if (Find-Module -Name $m | Where-Object {$_.Name -eq $m}) {
                Install-Module -Name $m -Force -Verbose -Scope CurrentUser
                start-sleep 90
                Import-Module $m -Verbose
            }
            else {

                # If the module is not imported, not available and not in the online gallery then abort
                write-host "Module $m not imported, not available and not in an online gallery, exiting."
                EXIT 1
            }
        }
    }
}


##import modules
#Load-Module "Az.Automation" 
#Load-Module "Microsoft.Xrm.Data.PowerShell"

##use clientID to auth if using this comment out the user connection
$oAuthClientId = "3e5a5e57-782a-4f61-9f1f-3aa40d5b2fe0"
$connectionString="AuthType=ClientSecret;url=https://orgd14353c5.crm.dynamics.com;ClientId=$oAuthClientId; ClientSecret=0ZN8Q~gBoLDRwZiyrgWwJtxlS~hstUWDoEaoTbDW"
$conn = Get-CrmConnection -ConnectionString $connectionString

##go through each sql record, and upload to crm

ForEach ($user in $sqlresults) {

$sqluserlastusn = Out-String -InputObject $user.lastusn
#$sqldevicecommonnamestring = Out-String -InputObject $device.CommonName
#if (!$device.AgentLastContactTimestamp) {$sqldeviceALT = "Never Contacted"}
#else {$sqldeviceALT = [datetime]$device.agentlastcontacttimestamp}
#if ($device.AgentLastContactTimestamp -isnot [dbnull]) {
#    $sqldeviceALT = [datetime]$device.agentlastcontacttimestamp} 
#    else {
#    $sqldeviceALT = ""}
$sqluserdisplayname = Out-String -InputObject $user.displayname
$sqlusersourceSAM = Out-String -InputObject $user.sourcesamaccountname
$sqlusertargetSAM = Out-String -InputObject $user.targetsamaccountname
$sqlusermatch = Out-String -InputObject $user.matchvalue1
$sqlusersourceUPN = Out-String -InputObject $user.userprincipalname
$sqlusertargetUPN = Out-String -InputObject $user.targetuserprincipalname



## Create an device and store record Guid to a variable 
##!!!!CREATE TABLE AND UPDATE THE BELOW
$userBTRecord = New-CrmRecord -conn $conn -EntityLogicalName cr204_bt_users -Fields @{
    "cr204_lastusn"=$sqluserlastusn
    "cr204_userdisplayname"=$sqluserdisplayname
    "cr204_sourcesamaccountname"=$sqlusersourceSAM
    "cr204_targetsamaccountname"=$sqlusertargetSAM
    "cr204_employeeid"=$sqlusermatch
    "cr204_sourceupn"=$sqlusersourceUPN
    "cr204_targetupn"=$sqlusertargetUPN
 }
#Display the Guid 
$UserBTRecord
}


##sample select and return to file
#Invoke-Sqlcmd -ServerInstance $SQLServer -Database $db3 -Query $selectdata | Export-Csv "C:\files\reports\run.csv" -Delimiter "," -NoTypeInformation