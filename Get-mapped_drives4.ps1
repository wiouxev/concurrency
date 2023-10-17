$PC = $Env:COMPUTERNAME
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


#export
$filename = "_mapped_drives"
$extension = ".csv"
$exportPath = "C:\temp\" + $PC + $filename + $extension
$exportPath2 = "C:\temp\" + $filename + $extension

$driveInfo | Export-Csv -Path $exportPath -NoTypeInformation
$driveInfo | Export-Csv -Path $exportPath2 -NoTypeInformation

#$driveInfo | Export-Csv -Path "C:\Users\npd concurrency03\desktop\" + $PC + "_mapped_drives.csv" -NoTypeInformation
#$driveInfo | Export-Csv -Path "C:\Program Files (x86)\Binary Tree\ADPro Agent\Files\mapped_drives.csv" -NoTypeInformation
#$driveInfo | Export-Csv -Path "C:\Program Files (x86)\Binary Tree\ADPro Agent\Files" -NoTypeInformation
#$driveInfo | Export-Csv -Path "C:\concurrency\exports\mapped drives\mapped_drives.csv" -NoTypeInformation
#$driveInfo | Export-Csv -Path "C:\temp\$PC_mapped_drives.csv" -NoTypeInformation










