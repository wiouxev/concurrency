Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force

#Get PC Info

$PCvar = $Env:COMPUTERNAME

#Define path for report

$PCOutput = "\\win0879.infores.com\MIG$\" + $PCvar + ".txt"

$PCCSVOUT = "\\win0879.infores.com \MIG$\" + $PCvar + ".csv"

$divider = "-----------------------------------"

#Get runtime info

$timestampout = get-date

$timestampout | Out-file $PCOutput -append

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


$wifi = netsh wlan show profiles name="IRI-Enterprise"
if ($wifi -match 'Profile "IRI-Enterprise" is not found on the system'){
    $wifistatus = "not found"
    #Write-host $wifi
    }
    elseif ($wifi -like "*Profile IRI-Enterprise on interface*") {
    $wifistatus = "found"
    #write-host "Profile IRI-Enterprise was found"
    }
    else {
    #write-host "wifi error"
    $wifistatus="error"
    }

$wifistatustext = "IRI Enterprise wifi profile is $wifistatus"
$wifistatustext | Out-file $PCOutput -append


$getpowercfg = powercfg.exe /getactivescheme
$powercfgarray = $getpowercfg.split(" ")
$activepowercfgGUID = $powercfgarray[3]

if ($activepowercfgGUID -match '381b4222-f694-41f0-9685-ff5bb260df2e'){
    $activepowercfg = "powersaver"
    #Write-host $activepowercfg
    }
    elseif ($activepowercfgGUID -match '8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c'){
    $activepowercfg = "High Performance"
    #write-host $activepowercfg
    }
    else {
    $activepowercfg = "non-standard"
    #write-host $activepowercfg
    }

$powerstatustext = "Active Power Profile is $activepowercfg"
$powerstatustext | Out-File $PCOutput -append

$divider | Out-file $PCOutput -append


#Logged on User info
$UserLoginValue = (Get-ItemProperty -path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI" -name "LastLoggedOnUser").LastLoggedOnUser

$UserLoginOut = "Current Logged in User: $UserLoginValue"

$UserLoginOut | Out-file $PCOutput -append

$logonserver = (get-wmiobject -clas win32_ntdomain -filter "DomainName ='BRN'").domaincontrollername

$logonserverout = "Logon Server Used: $logonserver"

$logonserverout | out-file $PCOutput -append

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

$csvarr = "$PCvar,$timestampout,$encdata1,$localstatcsname,$localstat2ip,$localstatboot,$localstat2dom,$publicip,$netconnname,$netconninterface,$netconncat,$wifistatustext,$UserLoginValue"

$csvarr | Out-file $PCCSVOUT
