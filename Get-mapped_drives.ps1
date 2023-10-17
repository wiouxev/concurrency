$drives = Get-WmiObject Win32_MappedLogicalDisk

foreach ($drive in $drives) {
    $driveLetter = $drive.DeviceID
    $driveName = $drive.ProviderName
    $driveLocation = $drive.Name

    Write-Output "Drive letter: $driveLetter"
    Write-Output "Mapped drive name: $driveName"
    Write-Output "Mapped drive location: $driveLocation"
}