## Check if C:\temp exists, create if not
$directoryPath = "C:\temp"
# Check if the directory exists
if (-not (Test-Path -Path $directoryPath -PathType Container)) {
    # Create the directory
    New-Item -ItemType Directory -Path $directoryPath | Out-Null
    Write-Host "Directory '$directoryPath' created."
}
else {
    Write-Host "Directory '$directoryPath' already exists."
}

# 
$batchContent = @'
$PC = $Env:COMPUTERNAME
$drives = Get-WmiObject Win32_MappedLogicalDisk

$driveInfo = foreach ($drive in $drives) {
    $driveLetter = $drive.DeviceID
    $driveName = $drive.ProviderName
    $driveLocation = $drive.Name

    [PSCustomObject]@{
        "Client PC" = $PC
        "Drive letter" = $driveLetter
        "Mapped drive name" = $driveName
        "Mapped drive location" = $driveLocation
    }
}

# Export drive info to CSV
$filename = "_mapped_drives"
$extension = ".csv"
$exportPath = "C:\temp\" + $PC + $filename + $extension
$exportPath2 = "C:\temp\" + $filename + $extension

$driveInfo | Export-Csv -Path $exportPath -NoTypeInformation
$driveInfo | Export-Csv -Path $exportPath2 -NoTypeInformation
'@


$batchFilePath = "C:\temp\get-mapped-drives.ps1"
$batchContent | Out-File -FilePath $batchFilePath -Encoding ASCII
$shortcutPath = [System.IO.Path]::Combine("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\get-mapped-drives.lnk")
$shell = New-Object -ComObject WScript.Shell
$shortcut = $shell.CreateShortcut($shortcutPath)
$shortcut.TargetPath = "powershell.exe"
$shortcut.Arguments = "-ExecutionPolicy Bypass -File `"$batchFilePath`""
$shortcut.WindowStyle = 7 # Minimized window
$shortcut.Save()

