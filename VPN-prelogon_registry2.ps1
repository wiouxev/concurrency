# Define the registry path
$registryPath = "HKLM:\SOFTWARE\Palo Alto Networks\GlobalProtect\PanSetup"
$registryPath2 = "HKLM:\SOFTWARE\Palo Alto Networks\GlobalProtect\Settings"

# Check if the registry path exists, and if not, create it
if (!(Test-Path -Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
}
if (!(Test-Path -Path $registryPath2)) {
    New-Item -Path $registryPath2 -Force | Out-Null
}

# Set the registry keys
Set-ItemProperty -Path $registryPath -Name "prelogon" -Value "1"
Set-ItemProperty -Path $registryPath -Name "portal" -Value "vpn.infores.com"
#
Set-ItemProperty -Path $registryPath2 -Name "certificate-store-lookup" -Value "machine"
##