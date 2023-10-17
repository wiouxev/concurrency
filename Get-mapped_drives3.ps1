$PC = hostname
$drives = Get-WmiObject Win32_MappedLogicalDisk

$driveInfo = foreach ($drive in $drives) {
    $driveLetter = $drive.DeviceID
    $driveName = $drive.ProviderName
    $driveLocation = $drive.Name
    #$drivePath = $drive.__PATH
    #$driveFileSystem = $drive.FileSystem
    #$driveVolume = $drive.VolumeName
    #$driveSystem = $drive.SystemName

    [PSCustomObject]@{
        "Client PC" = $PC
        "Drive letter" = $driveLetter
        "Mapped drive name" = $driveName
        "Mapped drive location" = $driveLocation
        #"Path" = $drive__PATH
        #"File System" = $driveFileSystem
        #"Drive Volume" = $driveVolume  
        #"Drive System" = $driveSystem      
    }
}

#update output path
#$driveInfo | Export-Csv -Path "C:\Program Files (x86)\Binary Tree\ADPro Agent\Files\" + $PC + "_mapped_drives.csv" -NoTypeInformation
$driveInfo | Export-Csv -Path "C:\Program Files (x86)\Binary Tree\ADPro Agent\Files\" + $PC + "_mapped_drives.csv" -NoTypeInformation
#$PCOutput = "\\win0879.infores.com\MIG$\" + $PCvar + ".txt"

#mapped drives for test PCs
##\\npd.com\corpdata
##\\wcirfs01\companydata\public
