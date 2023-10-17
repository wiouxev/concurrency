# Content of get-mapped-drives.ps1
$content = @'
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

#export
$filename = "_mapped_drives"
$extension = ".csv"
$exportPath = "C:\temp\" + $PC + $filename + $extension

$driveInfo | Export-Csv -Path $exportPath -NoTypeInformation
'@

# Create or overwrite the get-mapped-drives.ps1 file in C:\temp with the above content
Set-Content -Path 'C:\temp\get-mapped-drives.ps1' -Value $content


Start-sleep -seconds 5

$batchFilePath = "C:\temp\get-mapped-drives.ps1"
$shortcutPath = [System.IO.Path]::Combine("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\get-mapped-drives.lnk")
$shell = New-Object -ComObject WScript.Shell
$shortcut = $shell.CreateShortcut($shortcutPath)
$shortcut.TargetPath = "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
#$shortcut.TargetPath = $batchFilePath
$shortcut.Arguments = "-ExecutionPolicy Bypass -File `"$batchFilePath`""
$shortcut.WindowStyle = 7  # Minimized window
$shortcut.Save()