# Set the new tenant ID
    #Circana/IRI = 4372820-4447-4b27-ac2e-4bdabb3c0121
    #NPD = X
$NewTenantID = "4372820-4447-4b27-ac2e-4bdabb3c0121"

# Define the registry key paths for the tenant ID switch and for SyncAdminReports to delete
$OneDriveRegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\OneDrive"
$SyncAdminReportsKeyPath = "$OneDriveRegistryPath\SyncAdminReports"

# Set the new tenant ID in the KFMSilentOptIn registry value
Set-ItemProperty -Path $OneDriveRegistryPath -Name "KFMSilentOptIn" -Value $NewTenantID

 
# Check if the SyncAdminReports key exists & delete
if (Test-Path -Path $SyncAdminReportsKeyPath) {
    # Delete the SyncAdminReports key if it exists
    Remove-Item -Path $SyncAdminReportsKeyPath -Force
    Write-Host "SyncAdminReports key deleted."
} else {
    Write-Host "SyncAdminReports key does not exist."
}


# Define the remaining registry key paths 
$OneDriveRegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\OneDrive"
$RegistryKeys = @{
    "KFMSilentOptInDesktop" = "$OneDriveRegistryPath\KFMSilentOptInDesktop"
    "KFMSilentOptInDocuments" = "$OneDriveRegistryPath\KFMSilentOptInDocuments"
    "KFMSilentOptInPictures" = "$OneDriveRegistryPath\KFMSilentOptInPictures"
    "KFMSilentOptInWithNotification" = "$OneDriveRegistryPath\KFMSilentOptInWithNotification"
    "SilentAccountConfig" = "$OneDriveRegistryPath\SilentAccountConfig"
}


# Check and set values for the 5 other registry keys
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
