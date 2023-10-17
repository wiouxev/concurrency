$batchContent = @'
:loop
#time is miliseconds (1000 = 1 second)
ping odmduaproduspublicapi.azurewebsites.net -n 1 -w 30000
if errorlevel 1 goto loop

# Wait for an additional 1 minute (60 seconds)
timeout /t 180 /nobreak

START "" "C:\Program Files (x86)\Quest\On Demand Migration Desktop Update Agent\DesktopUpdateAgent.exe"
exit
'@

$batchFilePath = "C:\temp\automate-odm.bat"
$batchContent | Out-File -FilePath $batchFilePath -Encoding ASCII
$shortcutPath = [System.IO.Path]::Combine("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\automate-odm-shortcut.lnk")
$shell = New-Object -ComObject WScript.Shell
$shortcut = $shell.CreateShortcut($shortcutPath)
$shortcut.TargetPath = $batchFilePath
$shortcut.WindowStyle = 7  # Minimized window
$shortcut.Save()

