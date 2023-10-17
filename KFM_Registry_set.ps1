# Set the new tenant ID
    #Circana/IRI = 4372820-4447-4b27-ac2e-4bdabb3c0121
    #NPD = X
$NewTenantID = "4372820-4447-4b27-ac2e-4bdabb3c0121"

# Define the registry key paths
$OneDriveRegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\OneDrive"
$RegistryKeys = @{
    "KFMSilentOptInDesktop" = "$OneDriveRegistryPath\KFMSilentOptInDesktop"
    "KFMSilentOptInDocuments" = "$OneDriveRegistryPath\KFMSilentOptInDocuments"
    "KFMSilentOptInPictures" = "$OneDriveRegistryPath\KFMSilentOptInPictures"
    "KFMSilentOptInWithNotification" = "$OneDriveRegistryPath\KFMSilentOptInWithNotification"
    "SilentAccountConfig" = "$OneDriveRegistryPath\SilentAccountConfig"
}

# Set the new tenant ID in the KFMSilentOptIn registry value if not already set
if ((Get-ItemProperty -Path $RegistryKeys["KFMSilentOptIn"]).KFMSilentOptIn -ne $NewTenantID) {
    Set-ItemProperty -Path $RegistryKeys["KFMSilentOptIn"] -Name "KFMSilentOptIn" -Value $NewTenantID
    Write-Host "KFMSilentOptIn value updated."
}

# Check and set values for the other registry keys
foreach ($key in $RegistryKeys.Keys) {
    if (Test-Path -Path $RegistryKeys[$key]) {
        $value = (Get-ItemProperty -Path $RegistryKeys[$key] -Name $key -ErrorAction SilentlyContinue).$key
        if ($value -ne "1") {
            Set-ItemProperty -Path $RegistryKeys[$key] -Name $key -Value "1"
            Write-Host "$key value updated."
        } else {
            Write-Host "$key value is already set to 1."
        }
    } else {
        Write-Host "$key does not exist."
    }
}
