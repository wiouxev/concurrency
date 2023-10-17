Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force

#Get PC Info

$PCvar = $Env:COMPUTERNAME

#Define path for report

##live paths
$PCOutput = "\\VWENTAPP540101P.brunswick.com\MIG$\" + $PCvar + ".txt"
$PCCSVOUT = "\\VWENTAPP540101P.brunswick.com\MIG$\" + $PCvar + ".csv"

##testing paths
#$PCOutput = "C:\temp\brntesting\" + $PCvar + ".txt"
#$PCCSVOUT = "C:\temp\brntesting\" + $PCvar + ".csv"


$divider = "-----------------------------------"

#Get runtime info

$timestampout = get-date

$timestampout | Out-file $PCOutput -append

$divider | Out-file $PCOutput -append

#SCCM Status

$sccmstat = test-path "C:\Windows\CCM\SCClient.exe"

$SCCMSTATout =  “SCCM Install status is: $sccmstat”

$SCCMSTATout | Out-file $PCOutput -append

$SCCMkey = (get-itemproperty -path HKLM:\SOFTWARE\Microsoft\SMS\DP -name "SiteCode").Sitecode

$SCCMMP = (get-itemproperty -path HKLM:\SOFTWARE\Microsoft\SMS\DP -name "ManagementPoints").ManagementPoints

$SCCMkeyout =  “SCCM site code: $SCCMkey”

$SCCMMPout =  “SCCM management point: $SCCMMP”

$SCCMkeyout | Out-file $PCOutput -append

$SCCMMPout | Out-file $PCOutput -append

$divider | Out-file $PCOutput -append

#Encryption Status

$encobj = (manage-bde -status -computername localhost C: | where {$_ -match 'Protection Status'})

$encData = $encobj.split(':')

$encData1 = $encData[1]

$encout = "Protection status:$encdata1"

$encout | Out-file $PCOutput -append

$divider | Out-file $PCOutput -append

#PC Boot Info
$localstat = Get-CimInstance -ClassName win32_operatingsystem| select csname, lastbootuptime

$localstatcsname = $localstat.csname

$localstatboot = $localstat.lastbootuptime

$localstat2 = Get-CimInstance -ClassName win32_computersystem | select domain

$localstat2net = Get-CimInstance -ClassName win32_networkadapterconfiguration | select IPAddress

$localstat2ip = $localstat2net.ipaddress

$localstat2dom = $localstat2.domain

$localstatmsg1 = "Computer name: $localstatcsname"

$localstatmsg3 = "IP address: $localstat2ip"

$localstatmsg2 = "Last boot time: $localstatboot"

$localstat2msg1 = "Computer domain: $localstat2dom"

$localstatmsg1 | Out-file $PCOutput -append

$localstatmsg3 | Out-file $PCOutput -append

$localstat2msg1 | Out-file $PCOutput -append

$localstatmsg2 | Out-file $PCOutput -append

$publicip = Invoke-RestMethod -Uri ('http://ipinfo.io/'+(Invoke-WebRequest -uri "http://ifconfig.me/ip").Content)
$publicip = $publicIP.IP

$publicipmsg = "Public IP address: $publicip"

$publicipmsg | Out-file $PCOutput -append

$netconn = Get-NetConnectionProfile

$netconnname = $netconn.name

$netconninterface = $netconn.interfacealias

$netconncat = $netconn.networkcategory

$netconnmsg = "Connected to $netconnname using $netconninterface as $netconncat"

$netconnmsg | Out-file $PCOutput -append


$wifi = netsh wlan show profiles name="BRN-Enterprise"
if ($wifi -match 'Profile "BRN-Enterprise" is not found on the system'){
    $wifistatus = "not found"
    #Write-host $wifi
    }
    elseif ($wifi -like "*Profile BRN-Enterprise on interface*") {
    $wifistatus = "found"
    #write-host "Profile BRN-Enterprise was found"
    }
    else {
    #write-host "wifi error"
    $wifistatus="error"
    }

$wifistatustext = "BRN Enterprise wifi profile is $wifistatus"
$wifistatustext | Out-file $PCOutput -append

$divider | Out-file $PCOutput -append


#Logged on User info
$UserLoginValue = (Get-ItemProperty -path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI" -name "LastLoggedOnUser").LastLoggedOnUser

$UserLoginOut = "Current Logged in User: $UserLoginValue"

$UserLoginOut | Out-file $PCOutput -append

$divider | Out-file $PCOutput -append

#Security Tools Status
$CSSensorinstalled = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where { $_.DisplayName -eq "Crowdstrike Sensor Platform" }) -ne $null
$CSSensorStatus = "Crowdstrike Sensor Platform installation is $CSSensorinstalled"
$CSSensorStatus | Out-file $PCOutput -append
##needs csv export added

$CSFirmwareinstalled = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where { $_.DisplayName -eq "Crowdstrike Firmware Analysis" }) -ne $null
$CSFirmwareStatus = "Crowdstrike Firmware Analysis installation is $CSFirmwareinstalled"
$CSFirmwareStatus | Out-file $PCOutput -append
##needs csv export added

$CSDCinstalled = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where { $_.DisplayName -eq "Crowdstrike Device Control" }) -ne $null
$CSDCStatus = "Crowdstrike Device Control installation is $CSDCinstalled"
$CSDCStatus | Out-file $PCOutput -append
##needs csv export added

$rapid7installed = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where { $_.DisplayName -eq "Rapid7 insight Agent" }) -ne $null
$Rapid7Status = "Rapid7 Insight Agent installation is $Rapid7installed"
$Rapid7Status | Out-file $PCOutput -append
##needs csv export added

$LAPSinstalled = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where { $_.DisplayName -eq "Local Administrator Password Solution" }) -ne $null
$LAPSStatus = "Local Administrator Password Solution installation is $LAPSinstalled"
$LAPSStatus | Out-file $PCOutput -append
##needs csv export added

$divider | Out-file $PCOutput -append

#Windows Domain Firewall Check
#needs csv export added
$domainfirewallcheck = Get-NetFirewallProfile -name domain | select Enabled
$domainfirewallstatusenabled = $domainfirewallcheck.enabled
$domainfirewallstatus = "Domain Firewall enabled is $domainfirewallstatusenabled"
$domainfirewallstatus | Out-file $PCOutput -append

#Windows Private Firewall Check
#needs csv export added
$privatefirewallcheck = Get-NetFirewallProfile -name private | select Enabled
$privatefirewallstatusenabled = $privatefirewallcheck.enabled
$privatefirewallstatus = "Private Firewall enabled is $privatefirewallstatusenabled"
$privatefirewallstatus | Out-file $PCOutput -append

#Windows Public Firewall Check
#needs csv export added
$publicfirewallcheck = Get-NetFirewallProfile -name public | select Enabled
$Publicfirewallstatusenabled = $Publicfirewallcheck.enabled
$publicfirewallstatus = "Public Firewall enabled is $publicfirewallstatusenabled"
$publicfirewallstatus | Out-file $PCOutput -append


#Final Output for CSV

$csvarr = "$PCvar,$timestampout,$SCCMSTAT,$SCCMkey,$SCCMMP,$encdata1,$localstatcsname,$localstat2ip,$localstatboot,$localstat2dom,$publicip,$netconnname,$netconninterface,$netconncat,$wifistatustext,$UserLoginValue"

$csvarr | Out-file $PCCSVOUT

##ALL BELOW HERE WORK IN PROGRESS FOR POWERAPPS

#convert objects to strings for import
$localstat2ipstring = out-string -inputobject $localstat2ip
$netconncatstring = out-string -inputobject $netconncat
$sccmstatstring = out-string -inputobject $sccmstat
$sccmpstring = out-string -inputobject $sccmp
$sccmkeystring = out-string -inputobject $sccmkey
$cssensorinstalledstring = out-string -inputobject $cssensorinstalled
$csfirmwareinstalledstring = out-string -InputObject $CSFirmwareinstalled
$csdcinstalledstring = Out-String -InputObject $csdcinstalled
$rapid7installedstring = Out-String -InputObject $rapid7installed
$lapsinstalledstring = Out-String -InputObject $lapsinstalled
$domainfirewallstatusenabledstring = Out-String -InputObject $domainfirewallstatusenabled
$privatefirewallstatusenabledstring = Out-String -InputObject $privatefirewallstatusenabled
$publicfirewallstatusenabledstring = Out-String -InputObject $publicfirewallstatusenabled

##Check if module is imported and installed, if not install and import as necessary

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
            Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
            if (Find-Module -Name $m | Where-Object {$_.Name -eq $m}) {
                Install-Module -Name $m -Force -Verbose -Scope CurrentUser
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
Load-Module "Az.Automation" 
Load-Module "Microsoft.Xrm.Data.PowerShell"


##use clientID to auth if using this comment out the user connection
$oAuthClientId = "3e5a5e57-782a-4f61-9f1f-3aa40d5b2fe0"
$connectionString="AuthType=ClientSecret;url=https://orgd14353c5.crm.dynamics.com;ClientId=$oAuthClientId; ClientSecret=0ZN8Q~gBoLDRwZiyrgWwJtxlS~hstUWDoEaoTbDW"
$conn = Get-CrmConnection -ConnectionString $connectionString

## TESTING USE ONLY Online - use oAuth and XrmTooling Ui by providing your UPN and the enviroment url
#$conn = connect-crmonline -Username kbose@concurrency.com -ServerUrl orgd14353c5.crm.dynamics.com


# Create an device and store record Guid to a variable 
$deviceId = New-CrmRecord -conn $conn -EntityLogicalName cr28a_device -Fields @{
    "cr28a_name"=$localstatcsname; 
    "cr28a_devicename"=$localstatcsname
    "cr28a_bitlocker"=$encdata1
    "cr28a_boottime"=$localstatboot
    "cr28a_domain"=$localstat2dom
    "cr28a_lastuserloggedin"=$userloginvalue
    "cr204_localips"=$localstat2ipstring
    "cr28a_netcategory"=$netconncatstring
    "cr204_netconnected"=$netconnname
    "cr28a_pcname"=$pcvar
    "cr28a_publicip"=$publicip
    "cr204_sccminstalledstring"=$sccmstatstring
    "cr28a_sccmmp"=$sccmpstring
    "cr28a_sccmsite"=$sccmkeystring
    "cr204_getinfolastrun"=$timestampout
    "cr28a_netinterface"=$netconninterface
    "cr204_brnwifiprofile"=$wifistatus
    "cr204_cssensorinstalled"=$cssensorinstalledstring
    "cr204_csfirmwareinstalled"=$csfirmwareinstalledstring
    "cr204_csdevicecontrolinstalled"=$csdcinstalledstring
    "cr204_rapid7installed"=$rapid7installedstring
    "cr204_lapsinstalled"=$lapsinstalledstring
    "cr204_domainfirewallenabled"=$domainfirewallstatusenabledstring
    "cr204_privatefirewallenabled"=$privatefirewallstatusenabledstring
    "cr204_publicfirewallenabledstring"=$publicfirewallstatusenabledstring
    }  
 
# Display the Guid 
$deviceId 
 
# Retrieve a record and store record to a variable 
#$device = Get-CrmRecord -conn $conn -EntityLogicalName cr28a_device -Id $deviceId -Fields cr28a_name,cr28a_pcname 
#testing
#$device = Get-CrmRecord -conn $conn -EntityLogicalName cr28a_device -Id 0bd9a5fa-4029-ed11-9db1-000d3a3abc4f -Fields cr28a_name,cr28a_pcname 
 
# Display the record 
#$device 
 
# Set new name value for the record 
#$device.cr28a_name = "Sample Account Updated automation" 
 
### Update the record 
#Set-CrmRecord -conn $conn -CrmRecord $device 
 
# Retrieve the record again and display the result 
#Get-CrmRecord -conn $conn -EntityLogicalName cr28a_device -Id $deviceId -Fields cr28a_name 
 
# Delete the record 
#Remove-CrmRecord -conn $conn -CrmRecord $account 


#Remove-CrmRecord -conn $conn -CrmRecord $account 

