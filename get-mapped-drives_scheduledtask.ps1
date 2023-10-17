$batchFilePath = "C:\temp\get-mapped-drives.ps1"
$shortcutPath = [System.IO.Path]::Combine("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\get-mapped-drives.lnk")
$shell = New-Object -ComObject WScript.Shell
$shortcut = $shell.CreateShortcut($shortcutPath)
$shortcut.TargetPath = "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
#$shortcut.TargetPath = $batchFilePath
$shortcut.Arguments = "-ExecutionPolicy Bypass -File `"$batchFilePath`""
$shortcut.WindowStyle = 7  # Minimized window
$shortcut.Save()