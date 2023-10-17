#Disable Crash Control
Set-itemproperty -path "HKLM:\SYSTEM\CurrentControlSet\Control\CrashControl" -name EnableLogFile -Value 0 -Type DWORD

 #Disable TCPIP Devolution
Set-itemproperty -path "HKLM:\SYSTEM\CurrentControlSet\Services\TCPIP\Parameters" -name "UseDomainNameDevolution" -Value 0 -Type DWORD

#Disable Workplace JOIN
# Set variables to indicate value and key to set
$RegistryPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WorkplaceJoin'
$Name = 'BlockAADWorkplaceJoin'
$Value = '1'
# Create the key if it does not exist
If (-NOT (Test-Path $RegistryPath)) {New-Item -Path $RegistryPath -Force | Out-Null}  
# Now set the value
New-ItemProperty -Path $RegistryPath -Name $Name -Value $Value -PropertyType DWORD -Force

#Disable First Run for IE
# Set variables to indicate value and key to set
$RegistryPath = 'HKLM:\Software\Policies\Microsoft\Internet Explorer\Main'
$Name = 'DisableFirstRunCustomize'
$Value = '1'
# Create the key if it does not exist
If (-NOT (Test-Path $RegistryPath)) {New-Item -Path $RegistryPath -Force | Out-Null}  
# Now set the value
New-ItemProperty -Path $RegistryPath -Name $Name -Value $Value -PropertyType DWORD -Force

# Disable First Run for Edge
# Set variables to indicate value and key to set
$RegistryPath = 'HKLM:\Software\Policies\Microsoft\Edge'
$Name = 'FirstRunExperience'
$Value = '1'
# Create the key if it does not exist
If (-NOT (Test-Path $RegistryPath)) {New-Item -Path $RegistryPath -Force | Out-Null}  
# Now set the value
New-ItemProperty -Path $RegistryPath -Name $Name -Value $Value -PropertyType DWORD -Force

#Change Power Profile 
powercfg.exe -SETACTIVE 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 
#Specifically set active power profile settings to never for plugged in and 5min for battery
powercfg /change monitor-timeout-ac 0
powercfg /change monitor-timeout-dc 5
powercfg /change disk-timeout-ac 0
powercfg /change disk-timeout-dc 5
powercfg /change standby-timeout-ac 0
powercfg /change standby-timeout-dc 5
powercfg /change hibernate-timeout-ac 0
powercfg /change hibernate-timeout-dc 5
#Set power profile settings to a default value after migration
##powercfg /change monitor-timeout-ac 15
##powercfg /change monitor-timeout-dc 15
##powercfg /change disk-timeout-ac 15
##powercfg /change disk-timeout-dc 15
##powercfg /change standby-timeout-ac 15
##powercfg /change standby-timeout-dc 15
##powercfg /change hibernate-timeout-ac 15
##powercfg /change hibernate-timeout-dc 15
###CHANGE TO ONLY PLUGGED IN###