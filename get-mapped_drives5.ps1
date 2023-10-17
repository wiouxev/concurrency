$batchContent = @'
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

'@

##set default behavior for .ps1 files
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.ps1\UserChoice" -Name "ProgId" -Value "Microsoft.PowerShellScript.1"

$batchFilePath = "C:\temp\get-mapped-drives.ps1"
$batchContent | Out-File -FilePath $batchFilePath -Encoding ASCII
$shortcutPath = [System.IO.Path]::Combine("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\get-mapped-drives.lnk")
$shell = New-Object -ComObject WScript.Shell
$shortcut = $shell.CreateShortcut($shortcutPath)
$shortcut.TargetPath = $batchFilePath
$shortcut.WindowStyle = 7  # Minimized window
$shortcut.Save()



