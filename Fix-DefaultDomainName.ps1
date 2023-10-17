## This will adjust the registry values to ensure that 'infores.com' is not the default domain name upon login screen for a migrated computer
## additionally this should mitigate issues when trying to login via username/UPN only 

# Specify the domain you want to set as default
$domainName = "Circana.com"

# Specify the registry path
$registryPath1 = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
$registryPath2 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"


# Check if the registry path exists, and if not, create it
if (!(Test-Path -Path $registryPath1)) {
    New-Item -Path $registryPath1 -Force | Out-Null
}
if (!(Test-Path -Path $registryPath2)) {
    New-Item -Path $registryPath2 -Force | Out-Null
}

# Set the DefaultDomainName to the desired domain
Set-ItemProperty -Path $registryPath1 -Name "DefaultDomainName" -Value $domainName -Force
Set-ItemProperty -Path $registryPath1 -Name "AltDefaultDomainName" -Value $domainName -Force
Set-ItemProperty -Path $registryPath1 -Name "CachePrimaryDomain" -Value $domainName -Force
Set-ItemProperty -Path $registryPath2 -Name "DefaultLogonDomain" -Value $domainName -Force


#####Optionally, create a registry script that can be used with Group Policy to enforce this setting
####$regFileContent = @"
####Windows Registry Editor Version 5.00
####[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon]
####"DefaultDomainName"="$domainName"
####"@
# Specify the output path for the .reg file
#$outputPath = "C:\temp\SetDefaultDomain.reg"
# Output the contents to a .reg file
#$regFileContent | Out-File -FilePath $outputPath -Encoding ASCII

# Display a message indicating that the script has finished executing
#Write-Host "Default domain has been set. You can use the created .reg file with Group Policy to enforce this setting."


## BT ODJ relevant settings
#
#			{
#				$winLogonDomain = $CutoverCredentials_TargetDomainName
#
#				if ($PSDebugEnabled -eq $true) { DebugLog "Clearing cached logon values" }	
#
#				Remove-RegistryValue -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI" -Name "LastLoggedOnSAMUser"
#				Remove-RegistryValue -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI" -Name "LastLoggedOnUser"
#				Remove-RegistryValue -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI" -Name "LastLoggedOnUserSID"
#				Remove-RegistryValue -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\SessionData\1" -Name "LastLoggedOnSAMUser"
#				Remove-RegistryValue -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\SessionData\1" -Name "LoggedOnSAMUser"
#				Remove-RegistryValue -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\SessionData\1" -Name "LastLoggedOnSAMUsername"
#				Remove-RegistryValue -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "DcacheUpdate"
#				Remove-RegistryValue -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "DefaultUserName"
#
#				if ($PSDebugEnabled -eq $true) { DebugLog "Setting new values for $winLogonDomain" }	
#						
#				Set-RegistryValue -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "DefaultLogonDomain" -Value $winLogonDomain
#				Set-RegistryValue -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "HideFastUserSwitching" -Value 1 -Type DWord
#				Set-RegistryValue -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "DefaultDomainName" -Value $winLogonDomain
#				Set-RegistryValue -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "AltDefaultDomainName" -Value $winLogonDomain
#				Set-RegistryValue -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "CachePrimaryDomain" -Value $winLogonDomain
#	}