#gets a list of mapped drives on local machine
$drives = Get-WmiObject Win32_MappedLogicalDisk

#stores relevant info for each drive found
foreach ($drive in $drives) {
    $driveLetter = $drive.DeviceID
    $driveName = $drive.ProviderName
    $driveLocation = $drive.Name

    Write-Output "Drive letter: $driveLetter"
    Write-Output "Mapped drive name: $driveName"
    Write-Output "Mapped drive location: $driveLocation"
}

#organize data for CSV output
$driveInfo = foreach ($drive in $drives) {
    $driveLetter = $drive.DeviceID
    $driveName = $drive.ProviderName
    $driveLocation = $drive.Name

    [PSCustomObject]@{
        "Drive letter" = $driveLetter
        "Mapped drive name" = $driveName
        "Mapped drive location" = $driveLocation
    }
}

#export CSV
$driveInfo | Export-Csv -Path "C:\mapped_drives.csv" -NoTypeInformation
