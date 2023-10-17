# Define the registry path
$registryPath = "HKLM:\SOFTWARE\Palo Alto Networks\GlobalProtect\PanSetup"

# Check if the registry path exists, and if not, create it
if (!(Test-Path -Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
}

# Set the registry keys
Set-ItemProperty -Path $registryPath -Name "prelogon" -Value "1"
Set-ItemProperty -Path $registryPath -Name "portal" -Value "vpn.infores.com"

