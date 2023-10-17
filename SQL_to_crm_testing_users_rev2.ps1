$SQLServer = "VWENTAPP540102P"
$db = "DirSyncPro"
$devicetable = "BT_Device"
$sqlcred = get-credential


##instal module if needed
if(-not (get-module sqlserver -listavailable)){
install-module -name sqlserver -scope currentuser -force -confirm:$false
}

##full query for production
#$userinfoquery = "select lastusn, displayname, SourceSAMAccountName, TargetSAMAccountName, MatchValue1, UserPrincipalName,TargetUserPrincipalName from BT_Person" 
$newuserinfoquery = "select lastusn, displayname, SourceSAMAccountName, TargetSAMAccountName, MatchValue1, UserPrincipalName,TargetUserPrincipalName, CountryName, Company, Department, EmployeeType, JobTitle, Location, msexchassistantname from BT_Person"
#Invoke-Sqlcmd -ServerInstance $SQLServer -username "MigratorProAdm" -password $sqluserpw -Database $db -Query $devicesquery | Export-Csv $outputfilename -Delimiter "," -NoTypeInformation
$SQLResults = Invoke-Sqlcmd -ServerInstance $SQLServer -Credential $sqlcred -Database $db -Query $newuserinfoquery

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


##20221108 - testing getting records and deleting
##pulls all records into an array
#$existingcrmrecords = get-crmrecords -EntityLogicalName cr204_bt_users -fields cr204_userdisplayname, cr204_employeeid
##displays record at array position 0
#$existingcrmrecords.crmrecord[0]



##TEST SINGLE
#get-CrmRecords -conn $conn -EntityLogicalName cr204_bt_users -filterattribute "cr204_userdisplayname" -filteroperator "like" -filtervalue "test"

##this works!!
#get-CrmRecords -conn $conn -EntityLogicalName cr204_bt_users -filterattribute "cr204_userdisplayname" -filteroperator like -filtervalue "%test%"

##this worked better!!
#$testID = 244657
#get-CrmRecords -conn $conn -EntityLogicalName cr204_bt_users -filterattribute "cr204_employeeid" -filteroperator like -filtervalue "%$testID%"

#-Fields @{
#    "cr204_test"="something else"}



##go through each sql record, and upload to crm

ForEach ($user in $sqlresults) {

$sqluserlastusn = Out-String -InputObject $user.lastusn
$sqluserdisplayname = Out-String -InputObject $user.displayname
$sqlusersourceSAM = Out-String -InputObject $user.sourcesamaccountname
$sqlusertargetSAM = Out-String -InputObject $user.targetsamaccountname
$sqlusermatch = Out-String -InputObject $user.matchvalue1
$sqlusermatchnumber = $user.matchvalue1
$sqlusersourceUPN = Out-String -InputObject $user.userprincipalname
$sqlusertargetUPN = Out-String -InputObject $user.targetuserprincipalname
$sqlusercountryname = Out-String -InputObject $user.countryname
$sqlusercompany = Out-String -InputObject $user.company
$sqluserdepartment = Out-String -InputObject $user.department
$sqluseremployeetype = Out-String -InputObject $user.employeetype
$sqluserjobtitle = Out-String -InputObject $user.jobtitle
$sqluserlocation = Out-String -InputObject $user.location
$sqluserassistantname = Out-String -InputObject $user.mxexchassistantname

##logic to be added: check for $sqlusermatchnumber = dbnull


##if $sqlusermatchnumbe not null: $usercrmrecord with filtervalue based on usermatchnumber
##if $sqlusermatchnumbenull: check for $usersourceupn = null
##     ##if $usersourceupn not null: $usercrmrecord with filtervalue based on $usersourceupn
##     ##if $usersourceupn null: check for $targetuupn =null
##          ##if $targetupn not null: $usercrmrecord with filtervalue based on $usertargetupn
##          ##if $targetupn null: error
##new logic
##check $usercrmrecord = null
##if $usercrmrecord null: new-crmrecord
##if $usercrmrecord notnull: set-crmrecord





##THIS SECTION WORKS TO SEARCH FOR RECORD BY EMPLOYEEID AND UPDATE
##Locate record by employeeid/matchnumber
$usercrmrecord = get-CrmRecords -conn $conn -EntityLogicalName cr204_bt_users -filterattribute "cr204_employeeid" -filteroperator like -filtervalue "%$sqlusermatchnumber%"
##get GUID from record
$crmguid = $usercrmrecord.CrmRecords[0].cr204_bt_usersid.guid
##update record using GUID gathered by matched employeeid

$updateuserCRMRecord = set-CrmRecord -conn $conn -EntityLogicalName cr204_bt_users -id $crmguid -Fields @{
    "cr204_lastusn"=$sqluserlastusn
    "cr204_userdisplayname"=$sqluserdisplayname
    "cr204_sourcesamaccountname"=$sqlusersourceSAM
    "cr204_targetsamaccountname"=$sqlusertargetSAM
    "cr204_employeeid"=$sqlusermatch
    "cr204_sourceupn"=$sqlusersourceUPN
    "cr204_targetupn"=$sqlusertargetUPN
    "cr204_countryname"=$sqlusercountryname
    "cr204_company"=$sqlusercompany
    "cr204_department"=$sqluserdepartment
    "cr204_employeetype"=$sqluseremployeetype
    "cr204_jobtitle"=$sqluserjobtitle
    "cr204_location"=$sqluserlocation
    "cr204_assistantname"=$sqluserassistantname
     }
#display guid
#$crmguid
#$updateuserCRMRecord
}





## Create an device and store record Guid to a variable 
##!!!!CREATE TABLE AND UPDATE THE BELOW
###commented all for testing update
#$userBTRecord = New-CrmRecord -conn $conn -EntityLogicalName cr204_bt_users -Fields @{
#    "cr204_lastusn"=$sqluserlastusn
#    "cr204_userdisplayname"=$sqluserdisplayname
#    "cr204_sourcesamaccountname"=$sqlusersourceSAM
#    "cr204_targetsamaccountname"=$sqlusertargetSAM
#    "cr204_employeeid"=$sqlusermatch
#    "cr204_sourceupn"=$sqlusersourceUPN
#    "cr204_countryname"=$sqlusercountryname
#    "cr204_company"=$sqlusercompany
#    "cr204_department"=$sqluserdepartment
#    "cr204_employeetype"=$sqluseremployeetype
#    "cr204_jobtitle"=$sqluserjobtitle
#    "cr204_location"=$sqluserlocation
#    "cr204_assistantname"=$sqluserassistantname
#     }
#Display the Guid 
#$UserBTRecord
#}


##sample select and return to file
#Invoke-Sqlcmd -ServerInstance $SQLServer -Database $db3 -Query $selectdata | Export-Csv "C:\files\reports\run.csv" -Delimiter "," -NoTypeInformation