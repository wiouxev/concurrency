
##############################################################################################

# Check if there are pending Windows updates to be applied on the next reboot
$pendingUpdates = (Get-CimInstance -ClassName Win32_OperatingSystem).RebootPending
if ($pendingUpdates) {
    Write-Host "There are pending Windows updates to be applied on the next reboot."
} else {
    Write-Host "No pending Windows updates to be applied on the next reboot."
}
